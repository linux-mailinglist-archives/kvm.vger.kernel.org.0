Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33993E4C63
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 20:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbhHISwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 14:52:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230175AbhHISwF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 14:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628535104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iMS8DmFOfu2rnAzje99qeWnCj6sFSKFUDctsU0VRGyM=;
        b=Ytw+4Rzt0g/cOI+3XMM/cOVUMl1baPcJXocJSGamrUuKg++OuA5Mk4JnnzvCQIrw9xH7ue
        NwFmKNxPo8kBa6S1FbF9jfzhHvZJTM3G4wTdiosXt0gUon4qDsKvjjjtthO1konjcQh8F9
        xRVcC3uxTEHGlaiXVUgsy8iwxFHJeJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-r1wtH50IP_qVo2CDsnWqkw-1; Mon, 09 Aug 2021 14:51:41 -0400
X-MC-Unique: r1wtH50IP_qVo2CDsnWqkw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBDFE100806D;
        Mon,  9 Aug 2021 18:51:39 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 378C81036D35;
        Mon,  9 Aug 2021 18:51:35 +0000 (UTC)
Message-ID: <d3e0ba8085a8b6054e757dac696823f1181a712b.camel@redhat.com>
Subject: Re: [PATCH v3 06/12] KVM: x86: don't disable APICv memslot when
 inhibited
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Mon, 09 Aug 2021 21:51:34 +0300
In-Reply-To: <f221e94c-fb64-a859-de3c-30f883eac657@redhat.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
         <20210802183329.2309921-7-mlevitsk@redhat.com>
         <f221e94c-fb64-a859-de3c-30f883eac657@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-08-03 at 10:44 +0200, Paolo Bonzini wrote:
> Reviewing this patch and the next one together.
> 
> On 02/08/21 20:33, Maxim Levitsky wrote:
> > +static int avic_alloc_access_page(struct kvm *kvm)
> >  {
> >  	void __user *ret;
> >  	int r = 0;
> >  
> >  	mutex_lock(&kvm->slots_lock);
> > +
> > +	if (kvm->arch.apic_access_memslot_enabled)
> >  		goto out;
> 
> This variable is overloaded between "is access enabled" and "is the 
> memslot allocated".  I think you should check 
> kvm->arch.apicv_inhibit_reasons instead in kvm_faultin_pfn.
> 
> 
> > +	if (!activate)
> > +		kvm_zap_gfn_range(kvm, gpa_to_gfn(APIC_DEFAULT_PHYS_BASE),
> > +				  gpa_to_gfn(APIC_DEFAULT_PHYS_BASE + PAGE_SIZE));
> > +
> 
> Off by one, the last argument of kvm_zap_gfn_range is inclusive:

Actually is it? 

There are 3 uses of this function.
Two of them (kvm_post_set_cr0 and one case in update_mtrr) use 0,~0ULL which is indeed inclusive,
but for variable mtrrs I see that in var_mtrr_range this code:

*end = (*start | ~mask) + 1;

and the *end is passed to kvm_zap_gfn_range.


Another thing I noticed that I added calls to kvm_inc_notifier_count/kvm_dec_notifier_count
in the kvm_zap_gfn_range but these do seem to have non inclusive ends, thus 
I need to fix them sadly if this is the case.
This depends on mmu_notifier_ops and it is not documented well.

However at least mmu_notifier_retry_hva, does assume a non inclusive range since it checks


hva >= kvm->mmu_notifier_range_start &&
	    hva < kvm->mmu_notifier_range_end


Also looking at the algorithm of the kvm_zap_gfn_range.
Suppose that gfn_start == gfn_end and we have a memslot with one page at gfn_start

Then:


start = max(gfn_start, memslot->base_gfn); // start = memslot->base_gfn
end = min(gfn_end, memslot->base_gfn + memslot->npages); // end = memslot->base_gfn

if (start >= end)
	continue;

In this case it seems that it will do nothing. So I suspect that kvm_zap_gfn_range
actually needs non inclusive range but due to the facts that it was used much
it didn't cause trouble.


Another thing I found in kvm_zap_gfn_range:

kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);

But kvm_flush_remote_tlbs_with_address expects (struct kvm *kvm, u64 start_gfn, u64 pages)

kvm_flush_remote_tlbs_with_address is also for some reason called twice with the same parameters.

Could you help with that? Am I missing something?

Thanks in advance,
Best regards,
	Maxim Levitsky




> Also, checking "activate" is a bit ugly when we have "new" available as 
> well.  Yes, they are the same if !!old != !!new, but we care about the 
> global state, not the single bit.
> 
> Putting everything together, this could become something like
> 
>          trace_kvm_apicv_update_request(activate, bit);
>          if (!!old != !!new) {
> 		/*
> 		 * Kick all CPUs out of guest mode.  When
> 		 * kvm_vcpu_update_apicv succeeds in taking
> 		 * apicv_update_lock, it will see the
> 		 * new apicv_inhibit_reasons that we set below.
> 		 */
> 	        kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
> 
> 	        if (new) {
> 	                unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
> 	                kvm_zap_gfn_range(kvm, gfn, gfn);
> 	        }
> 	}
>          kvm->arch.apicv_inhibit_reasons = new;
>          mutex_unlock(&kvm->arch.apicv_update_lock);
> 
> Paolo
> 


