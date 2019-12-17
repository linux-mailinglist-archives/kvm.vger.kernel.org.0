Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9861239D2
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 23:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfLQWVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 17:21:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:26022 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbfLQWVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 17:21:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 14:20:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; 
   d="scan'208";a="209859511"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2019 14:20:58 -0800
Date:   Tue, 17 Dec 2019 14:20:59 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v4 01/19] KVM: x86: Allocate new rmap and large page
 tracking when moving memslot
Message-ID: <20191217222058.GD11771@linux.intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-2-sean.j.christopherson@intel.com>
 <20191217215640.GI7258@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217215640.GI7258@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 04:56:40PM -0500, Peter Xu wrote:
> On Tue, Dec 17, 2019 at 12:40:23PM -0800, Sean Christopherson wrote:
> > Reallocate a rmap array and recalcuate large page compatibility when
> > moving an existing memslot to correctly handle the alignment properties
> > of the new memslot.  The number of rmap entries required at each level
> > is dependent on the alignment of the memslot's base gfn with respect to
> > that level, e.g. moving a large-page aligned memslot so that it becomes
> > unaligned will increase the number of rmap entries needed at the now
> > unaligned level.

...

> I think the error-prone part is:
> 
> 	new = old = *slot;

Lol, IMO the error-prone part is the entire memslot mess :-)

> Where IMHO it would be better if we only copy pointers explicitly when
> under control, rather than blindly copying all the pointers in the
> structure which even contains sub-structures.

Long term, yes, that would be ideal.  For the immediate bug fix, reworking
common KVM and other arch code would be unnecessarily dangerous and would
make it more difficult to backport the fix to stable branches.

I actually briefly considered moving the slot->arch handling into arch
code as part of the bug fix, but the memslot code has many subtle
dependencies, e.g. PPC and x86 rely on common KVM code to copy slot->arch
when flags are being changed.

I'll happily clean up the slot->arch code once this series is merged.
There is refactoring in this series that will make it a lot easier to do
additional clean up.

> For example, I see PPC has this:
> 
> struct kvm_arch_memory_slot {
> #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> 	unsigned long *rmap;
> #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
> };
> 
> I started to look into HV code of it a bit, then I see...
> 
>  - kvm_arch_create_memslot(kvmppc_core_create_memslot_hv) init slot->arch.rmap,
>  - kvm_arch_flush_shadow_memslot(kvmppc_core_flush_memslot_hv) didn't free it,
>  - kvm_arch_prepare_memory_region(kvmppc_core_prepare_memory_region_hv) is nop.
> 
> So Does it have similar issue?

No, KVM doesn't allow a memslot's size to be changed, and PPC's rmap
allocation is directly tied to the size of the memslot.  The x86 bug exists
because the size of its metadata arrays varies based on the alignment of
the base gfn.
