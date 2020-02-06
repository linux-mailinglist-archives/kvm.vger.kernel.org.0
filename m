Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC54154C0B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 20:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgBFTWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 14:22:32 -0500
Received: from mga12.intel.com ([192.55.52.136]:22504 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727630AbgBFTWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 14:22:32 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 11:22:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="232140746"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2020 11:22:30 -0800
Date:   Thu, 6 Feb 2020 11:22:30 -0800
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
Subject: Re: [PATCH v5 14/19] KVM: Clean up local variable usage in
 __kvm_set_memory_region()
Message-ID: <20200206192230.GE13067@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-15-sean.j.christopherson@intel.com>
 <20200206190641.GA700495@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206190641.GA700495@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 02:06:41PM -0500, Peter Xu wrote:
> On Tue, Jan 21, 2020 at 02:31:52PM -0800, Sean Christopherson wrote:
> 
> [...]
> 
> > @@ -1101,52 +1099,55 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
> >  		return -EINVAL;
> >  
> > -	slot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> > -	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
> > -	npages = mem->memory_size >> PAGE_SHIFT;
> > -
> > -	if (npages > KVM_MEM_MAX_NR_PAGES)
> > -		return -EINVAL;
> > -
> >  	/*
> >  	 * Make a full copy of the old memslot, the pointer will become stale
> >  	 * when the memslots are re-sorted by update_memslots().
> >  	 */
> > -	old = *slot;
> > +	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> > +	old = *tmp;
> > +	tmp = NULL;
> 
> Shall we keep this chunk to the patch where it will be used?  Other
> than that, it looks good to me.

I assume you're talking about doing this instead of using @tmp?

	old = *id_to_memslot(__kvm_memslots(kvm, as_id), id);

It's obviously possible, but I really like resulting diff for
__kvm_set_memory_region() in "KVM: Terminate memslot walks via used_slots"
when tmp is used.

@@ -1104,8 +1203,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
         * when the memslots are re-sorted by update_memslots().
         */
        tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
-       old = *tmp;
-       tmp = NULL;
+       if (tmp) {
+               old = *tmp;
+               tmp = NULL;
+       } else {
+               memset(&old, 0, sizeof(old));
+               old.id = id;
+       }

