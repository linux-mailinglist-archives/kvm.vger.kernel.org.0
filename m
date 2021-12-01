Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9891465767
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 21:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbhLAUxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 15:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243183AbhLAUwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 15:52:30 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484BAC061574;
        Wed,  1 Dec 2021 12:49:05 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r25so41166290edq.7;
        Wed, 01 Dec 2021 12:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2rhfSmgvTWjQm/+3pDwlyvKqwDfq0EmWIwk1gwkVrZ4=;
        b=UWXckEF4EqvPbvZDH1HXpzvu2JF3JEz5GkM1j4kJ83J5ptuIYPS9zwolWzlJ+lnIdL
         1/5+Ha/0WyEW3aQY1nBSp7oqNxkLs0aSBRfJtDU/eOvL/6tYLl/xyzPjG9D+qJ+Q0RfY
         1FJHhT+WztabFtGA+xm84TWYxtgDtVXxpq/CRDz2Nl42XBQZgrm0zkTPtC9v5qxCJOAb
         iLKhUvfh2+nqSZZRRhy2ygkY88qbg07BuIz/Tf5sfM0TKg5Z8Z4ldMS574XycIPUj6t1
         Y8nau6rCNRFfAABjIKfpzM5Ag3MljorkUHiP6aTg03VrPcywT7hfELm9QnoGLTaJIWnh
         p3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2rhfSmgvTWjQm/+3pDwlyvKqwDfq0EmWIwk1gwkVrZ4=;
        b=flv4aRlGoJiCw0FJz/8SubDbfJ1Or38mu48MUhFeAY7JIA7ya4NuKSBg355ggrWDEk
         POH91Ge7SL4nBuFcZ2sFNkYGX5sugnDT91GSw7Q0T1s8dKtNCkbE3UVKa1ZiAOjWXcVM
         +Z6+rRLulncWT9camrM6QTNIs5Pvk548/gMiXru8H7ieuwwZC60eszsZPFWNnkaywv/2
         kA7JCHjAOiBMPHHfbRoY9bi63cES8tBPOm2qREt6tj+Gbf4pQDRf90+X99N036tiEcB9
         +v2nMYqvSS4u7wWKY4N2jBfv+mj59Jmk3K4i4TXIY2OfeAwRzpAbu5jq7ZpLYLOPMdKG
         rlXA==
X-Gm-Message-State: AOAM530wkUAjvVeKd6CUMPeeeyiwVemQ0HNevsS2JYR03FiMsXs0iZZP
        yLU2uOdNVAXYinBZ0vzx+Mk=
X-Google-Smtp-Source: ABdhPJxGHHQsNKS3CQqsDvOudwE4O4+jFbswerXfXdeTBx/rC+AIfe1RlXLpVppFRQ/o/m+2vVqGtg==
X-Received: by 2002:a17:907:9487:: with SMTP id dm7mr10008243ejc.2.1638391743807;
        Wed, 01 Dec 2021 12:49:03 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id b11sm560309ede.62.2021.12.01.12.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 12:49:03 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bf99bb5c-f3e1-670d-cdd4-261215160524@redhat.com>
Date:   Wed, 1 Dec 2021 21:49:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 04/28] KVM: x86/mmu: Retry page fault if root is
 invalidated by memslot update
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-5-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211120045046.3940942-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/21 05:50, Sean Christopherson wrote:
> Bail from the page fault handler if the root shadow page was obsoleted by
> a memslot update.  Do the check _after_ acuiring mmu_lock, as the TDP MMU
> doesn't rely on the memslot/MMU generation, and instead relies on the
> root being explicit marked invalid by kvm_mmu_zap_all_fast(), which takes
> mmu_lock for write.
> 
> For the TDP MMU, inserting a SPTE into an obsolete root can leak a SP if
> kvm_tdp_mmu_zap_invalidated_roots() has already zapped the SP, i.e. has
> moved past the gfn associated with the SP.
> 
> For other MMUs, the resulting behavior is far more convoluted, though
> unlikely to be truly problematic.  Installing SPs/SPTEs into the obsolete
> root isn't directly problematic, as the obsolete root will be unloaded
> and dropped before the vCPU re-enters the guest.  But because the legacy
> MMU tracks shadow pages by their role, any SP created by the fault can
> can be reused in the new post-reload root.  Again, that _shouldn't_ be
> problematic as any leaf child SPTEs will be created for the current/valid
> memslot generation, and kvm_mmu_get_page() will not reuse child SPs from
> the old generation as they will be flagged as obsolete.  But, given that
> continuing with the fault is pointess (the root will be unloaded), apply
> the check to all MMUs.
> 
> Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
> Cc: stable@vger.kernel.org
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c         | 23 +++++++++++++++++++++--
>   arch/x86/kvm/mmu/paging_tmpl.h |  3 ++-
>   2 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d2ad12a4d66e..31ce913efe37 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1936,7 +1936,11 @@ static void mmu_audit_disable(void) { }
>   
>   static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   {
> -	return sp->role.invalid ||
> +	if (sp->role.invalid)
> +		return true;
> +
> +	/* TDP MMU pages due not use the MMU generation. */
> +	return !sp->tdp_mmu_page &&
>   	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
>   }
>   
> @@ -3976,6 +3980,20 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   	return true;
>   }
>   
> +/*
> + * Returns true if the page fault is stale and needs to be retried, i.e. if the
> + * root was invalidated by a memslot update or a relevant mmu_notifier fired.
> + */
> +static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
> +				struct kvm_page_fault *fault, int mmu_seq)
> +{
> +	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root_hpa)))
> +		return true;
> +
> +	return fault->slot &&
> +	       mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
> +}
> +
>   static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   {
>   	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
> @@ -4013,8 +4031,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>   	else
>   		write_lock(&vcpu->kvm->mmu_lock);
>   
> -	if (fault->slot && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
> +	if (is_page_fault_stale(vcpu, fault, mmu_seq))
>   		goto out_unlock;
> +
>   	r = make_mmu_pages_available(vcpu);
>   	if (r)
>   		goto out_unlock;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index f87d36898c44..708a5d297fe1 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -911,7 +911,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>   
>   	r = RET_PF_RETRY;
>   	write_lock(&vcpu->kvm->mmu_lock);
> -	if (fault->slot && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
> +
> +	if (is_page_fault_stale(vcpu, fault, mmu_seq))
>   		goto out_unlock;
>   
>   	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
> 

Queued, thanks.

Paolo
