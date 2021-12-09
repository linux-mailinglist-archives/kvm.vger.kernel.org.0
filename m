Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AB746E779
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbhLILXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhLILXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 06:23:35 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1682C061746;
        Thu,  9 Dec 2021 03:20:01 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id g14so18062148edb.8;
        Thu, 09 Dec 2021 03:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8cka27pUXNfxsr0im9qCknRQikes3lFWNeWh7HLOFEU=;
        b=SNivddiPLosoMR/4WbBln+9BVonbZSWQ5py5nigvB8gLYTbH9YrzbeigR5wungR1JT
         EvxX/vLQ6/2yKEj5ujnD0oCSu3aFtJTTWzM/oZ/gmS4CHVpNF/YF9a7IGE26ssL56wbb
         1y50FJiXXVLK2EkMoWkEpR886jnkoygX9WTXKr9MibzbFSkm6KR3FICMOQOCnQFIn0XG
         H2ZySF2WkHnIHKIMMAVZSnpl7wGvIGqr9JWz21IjoZyktTt7zvv0sNMdVFTQcmPdIuQf
         f3UuItpyaUflXrANJUs9Kt6hT11A8zbMr84mNRtIY935KOWmohUFx7o3rqw7Kgu6Vycv
         G5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8cka27pUXNfxsr0im9qCknRQikes3lFWNeWh7HLOFEU=;
        b=n0C+nVTlIILL0JtfzwmhKOPzlS4JelaPEcuNhTxDEF3FD8LQuC9VVgro6rhl6zx07B
         eNK68IoqY+rlg/akXSVueSn9Sji/ACImb/Oo0y8ADFGeKHIWBPse463ooZsrMKBDl2ek
         NsCY05jFF08CDQuIZAB4Ba7ExCoCW5HKKIcbPNsycSxYEMQmr3SI2lU9K5miG8Jh4Ux6
         svuLwNyowaTB/Rv8FDS5P4QuuaRfAH2wCcz0pap+1VZPt3wsmlJEfm81Dymyi661kExo
         o/y1EYwOOpN2mVEYu1IoAi3/0qGPzdR0xDKWSVNKDPF7S7B457L+ZhO9NuzDbM3mf/R2
         y08w==
X-Gm-Message-State: AOAM5332TGIwq/Pfdo/Ze9bxuJZBCfcyUeFtE+xB1kgbjxL3UFQonpuT
        YtxsVha4QhIxOtZBRtGgew0=
X-Google-Smtp-Source: ABdhPJwHTZdJOkqYC59hGiS90JISP4mI+idYQEkqe284TzAt4eBU8cE1pAiAPkqLIkcrU83c5zt7lg==
X-Received: by 2002:a50:8dcb:: with SMTP id s11mr26970403edh.125.1639048793186;
        Thu, 09 Dec 2021 03:19:53 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id s16sm3372802edt.30.2021.12.09.03.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 03:19:52 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3c6262a1-84ad-d048-2654-a5d2f0816e57@redhat.com>
Date:   Thu, 9 Dec 2021 12:19:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/7] KVM: x86: Retry page fault if MMU reload is pending
 and root has no sp
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <20211209060552.2956723-1-seanjc@google.com>
 <20211209060552.2956723-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211209060552.2956723-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 07:05, Sean Christopherson wrote:
> Play nice with a NULL shadow page when checking for an obsolete root in
> the page fault handler by flagging the page fault as stale if there's no
> shadow page associated with the root and KVM_REQ_MMU_RELOAD is pending.
> Invalidating memslots, which is the only case where _all_ roots need to
> be reloaded, requests all vCPUs to reload their MMUs while holding
> mmu_lock for lock.
> 
> The "special" roots, e.g. pae_root when KVM uses PAE paging, are not
> backed by a shadow page.  Running with TDP disabled or with nested NPT
> explodes spectaculary due to dereferencing a NULL shadow page pointer.
> 
> Skip the KVM_REQ_MMU_RELOAD check if there is a valid shadow page for the
> root.  Zapping shadow pages in response to guest activity, e.g. when the
> guest frees a PGD, can trigger KVM_REQ_MMU_RELOAD even if the current
> vCPU isn't using the affected root.  I.e. KVM_REQ_MMU_RELOAD can be seen
> with a completely valid root shadow page.  This is a bit of a moot point
> as KVM currently unloads all roots on KVM_REQ_MMU_RELOAD, but that will
> be cleaned up in the future.
> 
> Fixes: a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalidated by memslot update")
> Cc: stable@vger.kernel.org
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1ccee4d17481..1d275e9d76b5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3971,7 +3971,21 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
>   				struct kvm_page_fault *fault, int mmu_seq)
>   {
> -	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root_hpa)))
> +	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root_hpa);
> +
> +	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
> +	if (sp && is_obsolete_sp(vcpu->kvm, sp))
> +		return true;
> +
> +	/*
> +	 * Roots without an associated shadow page are considered invalid if
> +	 * there is a pending request to free obsolete roots.  The request is
> +	 * only a hint that the current root _may_ be obsolete and needs to be
> +	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
> +	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
> +	 * to reload even if no vCPU is actively using the root.
> +	 */
> +	if (!sp && kvm_test_request(KVM_REQ_MMU_RELOAD, vcpu))
>   		return true;
>   
>   	return fault->slot &&
> 

Queued this one for 5.16, thanks.

Paolo
