Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6F0E075A
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 17:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731801AbfJVP22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 11:28:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:32269 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729666AbfJVP22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 11:28:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 08:28:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,216,1569308400"; 
   d="scan'208";a="191500433"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 22 Oct 2019 08:28:27 -0700
Date:   Tue, 22 Oct 2019 08:28:27 -0700
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
Message-ID: <20191022152827.GC2343@linux.intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-15-sean.j.christopherson@intel.com>
 <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 22, 2019 at 04:04:18PM +0200, Paolo Bonzini wrote:
> On 22/10/19 02:35, Sean Christopherson wrote:
> > +static inline int kvm_shift_memslots_forward(struct kvm_memslots *slots,
> > +					     struct kvm_memory_slot *new)
> > +{
> > +	struct kvm_memory_slot *mslots = slots->memslots;
> > +	int i;
> > +
> > +	if (WARN_ON_ONCE(slots->id_to_index[new->id] == -1) ||
> > +	    WARN_ON_ONCE(!slots->used_slots))
> > +		return -1;
> > +
> > +	for (i = slots->id_to_index[new->id]; i < slots->used_slots - 1; i++) {
> > +		if (new->base_gfn > mslots[i + 1].base_gfn)
> > +			break;
> > +
> > +		WARN_ON_ONCE(new->base_gfn == mslots[i + 1].base_gfn);
> > +
> > +		/* Shift the next memslot forward one and update its index. */
> > +		mslots[i] = mslots[i + 1];
> > +		slots->id_to_index[mslots[i].id] = i;
> > +	}
> > +	return i;
> > +}
> > +
> > +static inline int kvm_shift_memslots_back(struct kvm_memslots *slots,
> > +					  struct kvm_memory_slot *new,
> > +					  int start)
> 
> This new implementation of the insertion sort loses the comments that
> were there in the old one.  Please keep them as function comments.

I assume you're talking about this blurb in particular?

	 * The ">=" is needed when creating a slot with base_gfn == 0,
	 * so that it moves before all those with base_gfn == npages == 0.
