Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F44295B4F
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 11:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2510010AbgJVJDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 05:03:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2510002AbgJVJDt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 05:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603357427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Je2jFvCO27StOIkKgrouHunvyqoP9JExaghhikO6Vs=;
        b=XaN2Q36UBWAWSz1JBzX1qe/Kil0FXQ/tEKPuUghytRE4h1xphe0OoA+MUUt6INTCSVMDQD
        QN4T46p4Lkdmv6REnSI7NFX4zB7F3cmtf64DgCvijDCo7ZSNoGojefqVEy4FhqfPl0sNxc
        7xOeMD/8Cx33tjR9jjhhWrRZppER19o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-19_y7knjPIyBjhE3xdMMqQ-1; Thu, 22 Oct 2020 05:03:45 -0400
X-MC-Unique: 19_y7knjPIyBjhE3xdMMqQ-1
Received: by mail-wm1-f72.google.com with SMTP id r7so206076wmr.5
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 02:03:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9Je2jFvCO27StOIkKgrouHunvyqoP9JExaghhikO6Vs=;
        b=XOmcSC7F2cykebLJaDvSz7X0dXz6vM3RKR8CVNFtLR56fg2qMMX5qqagU1jKfi2Hx8
         ej+4HajcE4CqdWF2y91/rd1yeyOa+Mdbi08ecVTbjYYG0SjF+URlIQncaaP/mC4y9psF
         5GocAshl9WNFCSYR5IV0RTtYor3rPXG7XjHsKeAzIr6qTodW2LPirI6+qj4uGqcn7Ozs
         pLql+Xxd8qsOkAadQSgRXTec+0u0ihH+vB2/TuhoW8JMNsawEQhlz9WspAn53/QeSrvF
         Xl0HKcIIahEVt32WcgVGZ76u+23e9nIq69FHiRwHf4l8dtxcJ+5AUqAN9hVSColq9UKj
         oxuw==
X-Gm-Message-State: AOAM533Z3ZiWAccFV1gkzbbWHVjjoq57J69v4b0E3KZkggDFzHylcoVg
        9XahQtaVwKBJ9NK9rQYoRA8Bm/PZ+n34DS86bu10S+8Cg9yK6Kkp2Li2XRqP9gL2oRoXdHDrFr1
        InSXqQ87Mu261
X-Received: by 2002:adf:e849:: with SMTP id d9mr1708248wrn.25.1603357423642;
        Thu, 22 Oct 2020 02:03:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfTBvYaNzDpR+zNozNdjDxRpP8OAwt9zC14YB2BK6Fa6ztImIPcgYnO+EeQNitUmcXduYE5w==
X-Received: by 2002:adf:e849:: with SMTP id d9mr1708216wrn.25.1603357423370;
        Thu, 22 Oct 2020 02:03:43 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 130sm2484578wmd.18.2020.10.22.02.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 02:03:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/10] KVM: VMX: Invalidate hv_tlb_eptp to denote an EPTP mismatch
In-Reply-To: <20201021163843.GC14155@linux.intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com> <20201020215613.8972-6-sean.j.christopherson@intel.com> <87wnzj4utj.fsf@vitty.brq.redhat.com> <20201021163843.GC14155@linux.intel.com>
Date:   Thu, 22 Oct 2020 11:03:40 +0200
Message-ID: <878sby4opf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Wed, Oct 21, 2020 at 02:39:20PM +0200, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>> > Drop the dedicated 'ept_pointers_match' field in favor of stuffing
>> > 'hv_tlb_eptp' with INVALID_PAGE to mark it as invalid, i.e. to denote
>> > that there is at least one EPTP mismatch.  Use a local variable to
>> > track whether or not a mismatch is detected so that hv_tlb_eptp can be
>> > used to skip redundant flushes.
>> >
>> > No functional change intended.
>> >
>> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> > ---
>> >  arch/x86/kvm/vmx/vmx.c | 16 ++++++++--------
>> >  arch/x86/kvm/vmx/vmx.h |  7 -------
>> >  2 files changed, 8 insertions(+), 15 deletions(-)
>> >
>> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> > index 52cb9eec1db3..4dfde8b64750 100644
>> > --- a/arch/x86/kvm/vmx/vmx.c
>> > +++ b/arch/x86/kvm/vmx/vmx.c
>> > @@ -498,13 +498,13 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>> >  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
>> >  	struct kvm_vcpu *vcpu;
>> >  	int ret = 0, i;
>> > +	bool mismatch;
>> >  	u64 tmp_eptp;
>> >  
>> >  	spin_lock(&kvm_vmx->ept_pointer_lock);
>> >  
>> > -	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
>> > -		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
>> > -		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
>> > +	if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
>> > +		mismatch = false;
>> >  
>> >  		kvm_for_each_vcpu(i, vcpu, kvm) {
>> >  			tmp_eptp = to_vmx(vcpu)->ept_pointer;
>> > @@ -515,12 +515,13 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>> >  			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
>> >  				kvm_vmx->hv_tlb_eptp = tmp_eptp;
>> >  			else
>> > -				kvm_vmx->ept_pointers_match
>> > -					= EPT_POINTERS_MISMATCH;
>> > +				mismatch = true;
>> >  
>> >  			ret |= hv_remote_flush_eptp(tmp_eptp, range);
>> >  		}
>> > -	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
>> > +		if (mismatch)
>> > +			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
>> > +	} else {
>> >  		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
>> >  	}
>> 
>> Personally, I find double negations like 'mismatch = false' hard to read
>> :-).
>
> Paolo also dislikes double negatives (I just wasted a minute of my life trying
> to work a double negative into that sentence).
>
>> What if we write this all like 
>> 
>> if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
>> 	kvm_vmx->hv_tlb_eptp = to_vmx(vcpu0)->ept_pointer;
>> 	kvm_for_each_vcpu() {
>> 		tmp_eptp = to_vmx(vcpu)->ept_pointer;
>> 		if (!VALID_PAGE(tmp_eptp) || tmp_eptp != kvm_vmx->hv_tlb_eptp)
>> 			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
>> 		if (VALID_PAGE(tmp_eptp))
>> 			ret |= hv_remote_flush_eptp(tmp_eptp, range);
>> 	}
>> } else {
>> 	ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
>> }
>> 
>> (not tested and I've probably missed something)
>
> It works, but doesn't optimize the case where one or more vCPUs has an invalid
> EPTP.  E.g. if vcpuN->ept_pointer is INVALID_PAGE, vcpuN+1..vcpuZ will flush,
> even if they all match.  Now, whether or not it's worth optimizing
> that case...

Yea. As KVM is already running on Hyper-V, nesting on top of it is
likely out of question so IMO it's not even worth optimizing...

>
> This is also why I named it "mismatch", i.e. it tracks whether or not there was
> a mismatch between valid EPTPs, not that all EPTPs matched.
>
> What about replacing "mismatch" with a counter that tracks the number of unique,
> valid PGDs that are encountered?
>
> 	if (!VALID_PAGE(kvm_vmx->hv_tlb_pgd)) {
> 		unique_valid_pgd_cnt = 0;
>
> 		kvm_for_each_vcpu(i, vcpu, kvm) {
> 			tmp_pgd = to_vmx(vcpu)->hv_tlb_pgd;
> 			if (!VALID_PAGE(tmp_pgd) ||
> 			    tmp_pgd == kvm_vmx->hv_tlb_pgd)
> 				continue;
>
> 			unique_valid_pgd_cnt++;
>
> 			if (!VALID_PAGE(kvm_vmx->hv_tlb_pgd))
> 				kvm_vmx->hv_tlb_pgd = tmp_pgd;
>
> 			if (!ret)
> 				ret = hv_remote_flush_pgd(tmp_pgd, range);
>
> 			if (ret && unique_valid_pgd_cnt > 1)
> 				break;
> 		}
> 		if (unique_valid_pgd_cnt > 1)
> 			kvm_vmx->hv_tlb_pgd = INVALID_PAGE;
> 	} else {
> 		ret = hv_remote_flush_pgd(kvm_vmx->hv_tlb_pgd, range);
> 	}
>
>
> Alternatively, the pgd_cnt adjustment could be used to update hv_tlb_pgd, e.g.
>
> 			if (++unique_valid_pgd_cnt == 1)
> 				kvm_vmx->hv_tlb_pgd = tmp_pgd;
>
> I think I like this last one the most.  It self-documents what we're tracking
> as well as the relationship between the number of valid PGDs and
> hv_tlb_pgd.

Both approaches look good to me, thanks!

>
> I'll also add a few comments to explain how kvm_vmx->hv_tlb_pgd is used.
>
> Thoughts?
>  
>> > @@ -3042,8 +3043,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
>> >  		if (kvm_x86_ops.tlb_remote_flush) {
>> >  			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
>> >  			to_vmx(vcpu)->ept_pointer = eptp;
>> > -			to_kvm_vmx(kvm)->ept_pointers_match
>> > -				= EPT_POINTERS_CHECK;
>> > +			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
>> >  			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
>> >  		}
>> >  
>> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> > index 3d557a065c01..e8d7d07b2020 100644
>> > --- a/arch/x86/kvm/vmx/vmx.h
>> > +++ b/arch/x86/kvm/vmx/vmx.h
>> > @@ -288,12 +288,6 @@ struct vcpu_vmx {
>> >  	} shadow_msr_intercept;
>> >  };
>> >  
>> > -enum ept_pointers_status {
>> > -	EPT_POINTERS_CHECK = 0,
>> > -	EPT_POINTERS_MATCH = 1,
>> > -	EPT_POINTERS_MISMATCH = 2
>> > -};
>> > -
>> >  struct kvm_vmx {
>> >  	struct kvm kvm;
>> >  
>> > @@ -302,7 +296,6 @@ struct kvm_vmx {
>> >  	gpa_t ept_identity_map_addr;
>> >  
>> >  	hpa_t hv_tlb_eptp;
>> > -	enum ept_pointers_status ept_pointers_match;
>> >  	spinlock_t ept_pointer_lock;
>> >  };
>> 
>> -- 
>> Vitaly
>> 
>

-- 
Vitaly

