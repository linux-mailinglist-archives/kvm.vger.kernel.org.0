Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE64E3D85
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 22:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbfJXUs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 16:48:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:31973 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbfJXUs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 16:48:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 13:48:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; 
   d="scan'208";a="201596808"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 24 Oct 2019 13:48:26 -0700
Date:   Thu, 24 Oct 2019 13:48:26 -0700
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
Message-ID: <20191024204826.GE28043@linux.intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-15-sean.j.christopherson@intel.com>
 <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
 <20191022152827.GC2343@linux.intel.com>
 <625e511f-bd35-3b92-0c6d-550c10fc5827@redhat.com>
 <20191022155220.GD2343@linux.intel.com>
 <5c61c094-ee32-4dcf-b3ae-092eba0159c5@redhat.com>
 <20191024193856.GA28043@linux.intel.com>
 <5320341c-1abb-610b-8f5e-090a6726a9b1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5320341c-1abb-610b-8f5e-090a6726a9b1@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 10:24:09PM +0200, Paolo Bonzini wrote:
> On 24/10/19 21:38, Sean Christopherson wrote:
> > only
> >  * its new index into the array is update.
> 
> s/update/tracked/?

Ya, tracked is better.  Waffled between updated and tracked, chose poorly :-)

>   Returns the changed memslot's
> >  * current index into the memslots array.
> >  */
> > static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
> > 					    struct kvm_memory_slot *memslot)
> > {
> > 	struct kvm_memory_slot *mslots = slots->memslots;
> > 	int i;
> > 
> > 	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
> > 	    WARN_ON_ONCE(!slots->used_slots))
> > 		return -1;
> > 
> > 	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
> > 		if (memslot->base_gfn > mslots[i + 1].base_gfn)
> > 			break;
> > 
> > 		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
> > 
> > 		/* Shift the next memslot forward one and update its index. */
> > 		mslots[i] = mslots[i + 1];
> > 		slots->id_to_index[mslots[i].id] = i;
> > 	}
> > 	return i;
> > }
> > 
> > /*
> >  * Move a changed memslot forwards in the array by shifting existing slots with
> >  * a lower GFN toward the back of the array.  Note, the changed memslot itself
> >  * is not preserved in the array, i.e. not swapped at this time, only its new
> >  * index into the array is updated
> 
> Same here?
> 
> >  * Note, slots are sorted from highest->lowest instead of lowest->highest for
> >  * historical reasons.
> 
> Not just that, the largest slot (with all RAM above 4GB) is also often
> at the highest address at least on x86.

Ah, increasing the odds of a quick hit on lookup...but only when using a
linear search.  The binary search starts in the middle, so that
optimization is also historical :-)

> But we could sort them by size now, so I agree to call these historical
> reasons.

That wouldn't work with the binary search though.

> The code itself is fine, thanks for the work on documenting it.
> 
> Paolo
> 
