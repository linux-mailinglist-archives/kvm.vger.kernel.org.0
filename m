Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B735FE07ED
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 17:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388292AbfJVPwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 11:52:23 -0400
Received: from mga03.intel.com ([134.134.136.65]:53569 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387675AbfJVPwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 11:52:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 08:52:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,216,1569308400"; 
   d="scan'208";a="196476114"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 22 Oct 2019 08:52:20 -0700
Date:   Tue, 22 Oct 2019 08:52:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/15] KVM: Terminate memslot walks via used_slots
Message-ID: <20191022155220.GD2343@linux.intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-15-sean.j.christopherson@intel.com>
 <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
 <20191022152827.GC2343@linux.intel.com>
 <625e511f-bd35-3b92-0c6d-550c10fc5827@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <625e511f-bd35-3b92-0c6d-550c10fc5827@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 22, 2019 at 05:30:58PM +0200, Paolo Bonzini wrote:
> On 22/10/19 17:28, Sean Christopherson wrote:
> > On Tue, Oct 22, 2019 at 04:04:18PM +0200, Paolo Bonzini wrote:
> >> On 22/10/19 02:35, Sean Christopherson wrote:
> >>> +static inline int kvm_shift_memslots_forward(struct kvm_memslots *slots,
> >>> +					     struct kvm_memory_slot *new)
> >>> +{
> >>> +	struct kvm_memory_slot *mslots = slots->memslots;
> >>> +	int i;
> >>> +
> >>> +	if (WARN_ON_ONCE(slots->id_to_index[new->id] == -1) ||
> >>> +	    WARN_ON_ONCE(!slots->used_slots))
> >>> +		return -1;
> >>> +
> >>> +	for (i = slots->id_to_index[new->id]; i < slots->used_slots - 1; i++) {
> >>> +		if (new->base_gfn > mslots[i + 1].base_gfn)
> >>> +			break;
> >>> +
> >>> +		WARN_ON_ONCE(new->base_gfn == mslots[i + 1].base_gfn);
> >>> +
> >>> +		/* Shift the next memslot forward one and update its index. */
> >>> +		mslots[i] = mslots[i + 1];
> >>> +		slots->id_to_index[mslots[i].id] = i;
> >>> +	}
> >>> +	return i;
> >>> +}
> >>> +
> >>> +static inline int kvm_shift_memslots_back(struct kvm_memslots *slots,
> >>> +					  struct kvm_memory_slot *new,
> >>> +					  int start)
> >>
> >> This new implementation of the insertion sort loses the comments that
> >> were there in the old one.  Please keep them as function comments.
> > 
> > I assume you're talking about this blurb in particular?
> > 
> > 	 * The ">=" is needed when creating a slot with base_gfn == 0,
> > 	 * so that it moves before all those with base_gfn == npages == 0.
> 
> Yes, well all of the comments.  You can also keep them in the caller, as
> you prefer.

The primary function comment is still there, the only other comment that I
dropped was the second half of the above comment:

	 *
	 * On the other hand, if new->npages is zero, the above loop has
	 * already left i pointing to the beginning of the empty part of
	 * mslots, and the ">=" would move the hole backwards in this
	 * case---which is wrong.  So skip the loop when deleting a slot.
	 */

Which doesn't carry forward very well.  Is there another comment I'm
overlooking?

Anyways, I'm not at all opposed to adding comments, just want to make sure
I'm not forgetting something.  If it's ok with you, I'll comment the code
and/or functions and reply here to refine them without having to respin
the whole series.
