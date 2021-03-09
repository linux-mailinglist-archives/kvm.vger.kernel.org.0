Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B23D332D30
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 18:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhCIR0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 12:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhCIR0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 12:26:21 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67465C06174A
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 09:26:10 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so1045150pjb.1
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 09:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=urAaypekQgaubc5jPAbSIvvw+GQR+qdziDhnK+qSiO4=;
        b=A+MV8h7QyRMx3+QfhUVA0oaXcPDEyynfUB6PCR/zmv80WtBzxOXS/RXb36gNqwrAvf
         52Itc4np4MrLvNADeqEnKL2E4YSEpw7xoUzL+lXN3CTHxgKQkm3VWGSAokjtvJhyobEQ
         OyD/u3TPj2KQwSCcFLC5AHcSS/NxebmDoRA9xEVfyiqwA1guHnt7L7SliAb79rGEnWXk
         JOzIDj2uT86bDdNo822I0Yg5fIbSyLOPiduKcpjUo0TrAqX9QME1eb4PH8AmtCJZK0QE
         CtrPsMMhWpbCgmm71QMz88I+AUpx2MoHGhfdrffz5/8YExyZgxJhKJWPg2qxQM/zWiKt
         wFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=urAaypekQgaubc5jPAbSIvvw+GQR+qdziDhnK+qSiO4=;
        b=QMLUVIVqltbtdn5P2oXoOOM26Ifc4cneeuJLWZ7hqBYyySLvBFPQS52ZktG+rRcPyf
         FnMW1iYz0kuG+Fa0zbVOaJnzsjN5poqfK5xms/ArQVfIp+ynFbrAPK10HqiMlvXMV0tH
         OfxKIF14VHmM6VZf0cVsuzkIZFjoeisMByI9c5BVIdfepNcFd0WDelTLIG6HyLU7FXAY
         1iM0A3jsegTnAhGtV8iShsuzQhFWDLUycx1sLtIaTixqkuuXK9bRapPvvyyflfcvkUeh
         7lp0WFAi/YPE/UrRhJUf+SB3zHkzRHwoFCguNHJJk06FxTVE//yUMKvWclAo5iFX/KBP
         H1+A==
X-Gm-Message-State: AOAM531ByLmHfFaeTRiBCloBNnxeJqtUPTwu/PBqji+EZRv0tgwhoFfv
        qEgIkNW+G5+I7stAbApHNmt0Vw==
X-Google-Smtp-Source: ABdhPJzHAbAMiIKY//SaDBpEhgcYsNnsCXZWVmFwCZ8MUE+7GI5zYswzU23258mTykiDGvr7DEboyQ==
X-Received: by 2002:a17:90a:ae14:: with SMTP id t20mr5645989pjq.90.1615310769838;
        Tue, 09 Mar 2021 09:26:09 -0800 (PST)
Received: from google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
        by smtp.gmail.com with ESMTPSA id b14sm3628460pji.14.2021.03.09.09.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 09:26:09 -0800 (PST)
Date:   Tue, 9 Mar 2021 09:26:02 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 1/2] KVM: x86: Fixup "Get active PCID only when writing a
 CR3 value"
Message-ID: <YEevqq3bywrowDLC@google.com>
References: <20210309021900.1001843-1-seanjc@google.com>
 <20210309021900.1001843-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309021900.1001843-2-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021, Sean Christopherson wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Fix SME and PCID, which got horribly mangled on application.

Gah, the SME changes are supposed to be in "KVM: x86/mmu: Mark the PAE roots as
decrypted for shadow paging", which has not yet been merged.  Stuffing them
here doesn't make things work, but it does break git blame.

I'll send you a v2 with more appropriate fixup, and the PAE changes on top.

> Fixes: a16241ae56fa ("KVM: x86: Get active PCID only when writing a CR3 value")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7876ddf896b8..271196400495 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3907,15 +3907,20 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	unsigned long cr3;
>  
> -	cr3 = __sme_set(root_hpa);
>  	if (npt_enabled) {
> -		svm->vmcb->control.nested_cr3 = root_hpa;
> +		svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
>  		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
>  
>  		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
>  		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
>  			return;
>  		cr3 = vcpu->arch.cr3;
> +	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
> +		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
> +	} else {
> +		/* PCID in the guest should be impossible with a 32-bit MMU. */
> +		WARN_ON_ONCE(kvm_get_active_pcid(vcpu));
> +		cr3 = root_hpa;
>  	}
>  
>  	svm->vmcb->save.cr3 = cr3;
> -- 
> 2.30.1.766.gb4fecdf3b7-goog
> 
