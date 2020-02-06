Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62918154926
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgBFQ2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:28:19 -0500
Received: from mga04.intel.com ([192.55.52.120]:30727 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbgBFQ2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 11:28:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 08:28:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="344968003"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Feb 2020 08:28:18 -0800
Date:   Thu, 6 Feb 2020 08:28:18 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 12/19] KVM: Move memslot deletion to helper function
Message-ID: <20200206162818.GD13067@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-13-sean.j.christopherson@intel.com>
 <20200206161415.GA695333@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206161415.GA695333@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 11:14:15AM -0500, Peter Xu wrote:
> On Tue, Jan 21, 2020 at 02:31:50PM -0800, Sean Christopherson wrote:
> > Move memslot deletion into its own routine so that the success path for
> > other memslot updates does not need to use kvm_free_memslot(), i.e. can
> > explicitly destroy the dirty bitmap when necessary.  This paves the way
> > for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
> > NULL for @dont.
> > 
> > Add a comment above the code to make a copy of the existing memslot
> > prior to deletion, it is not at all obvious that the pointer will become
> > stale during sorting and/or installation of new memslots.
> 
> Could you help explain a bit on this explicit comment?  I can follow
> up with the patch itself which looks all correct to me, but I failed
> to catch what this extra comment wants to emphasize...

It's tempting to write the code like this (I know, because I did it):

	if (!mem->memory_size)
		return kvm_delete_memslot(kvm, mem, slot, as_id);

	new = *slot;

Where @slot is a pointer to the memslot to be deleted.  At first, second,
and third glances, this seems perfectly sane.

The issue is that slot was pulled from struct kvm_memslots.memslots, e.g.

	slot = &slots->memslots[index];

Note that slots->memslots holds actual "struct kvm_memory_slot" objects,
not pointers to slots.  When update_memslots() sorts the slots, it swaps
the actual slot objects, not pointers.  I.e. after update_memslots(), even
though @slot points at the same address, it's could be pointing at a
different slot.  As a result kvm_free_memslot() in kvm_delete_memslot()
will free the dirty page info and arch-specific points for some random
slot, not the intended slot, and will set npages=0 for that random slot.
