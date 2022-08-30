Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF345A71F6
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbiH3XpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiH3XpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:45:18 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CA71AD9E
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:45:17 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y29so8793896pfq.0
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=RoCr4ZIyjgjdvYiT9G+K6UgGejt2/PUkQpujNgwCvro=;
        b=YPwDxFZ5eccbk8vptk+21Bc4ySg6utvIQNWsGD45OYxzlkX30oUO+Fei3BUeZmzeDd
         DE/YIppf7ln3yx2hXvECaLWwZkn7Ys6BUDkAyZ0d9gk0izU6Ey3XV43DmEZTIh1oyaxU
         gh1HBwfKe+fTU/kOxZbD6Bvq6JCIIRpb96904NBU/AhBzx9BN99zyCxPyaZYVClC2hWk
         rvvWbLlf/HiYE9jq8LPNvi56K0E5kNccnojEc3oIZC2+wg862SzKeokHsXmvlDP3bhZD
         HsLVVuxoJVkBRX/d9vKGc5bA6jNOCrEEQ5BYXLMw0AC4lX2OT4u3I6NEqeuVCcDq2QKe
         ESVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=RoCr4ZIyjgjdvYiT9G+K6UgGejt2/PUkQpujNgwCvro=;
        b=KYPuAIcviGnHFmoOkv1sQsxE6f5q7XkHqzSPmkB++OCzbVg4J6g6TMpGVyGZ3RYsu+
         E96M+VXPrl9GJrYi0b0PsTOoMTO3sWcR7/whdZDxuSWgVGpKQX90oCOh8vuhydVl6AvH
         aEacy/AhdASJoXYvL52LCn40BEYh4WPEhMp7hRvZp9C838/WE1cOl2QZDu2nUNQ25Wdk
         h1ujL84CPx6BHizMwtDXB61LTspz8ev3TRFOGDXBP+w2PbYngNW0MPaAzThbKrCjnjMh
         NevQp2PAOv6M3fNmqQpmkXzoRF/5Q6cKKLFmmZSbZpz8OpRZlPCPfAlhBHqMeaQHs5SN
         aFfQ==
X-Gm-Message-State: ACgBeo2VFFlwvxEU1UZ348Ywf8NueP/NMGGYoyGrfZQp2f+Y0jD6q6BJ
        YQPWcENQ9w8eZZb59B6NUtA=
X-Google-Smtp-Source: AA6agR7hnw9QeSnn8R6BfEvnWd2zkGfs+1Ej45j10/zbtCax1uTBp9iLm+bdd+sqmDObfDyRfKwqxw==
X-Received: by 2002:a63:8543:0:b0:430:1ecc:7b91 with SMTP id u64-20020a638543000000b004301ecc7b91mr1006484pgd.107.1661903116663;
        Tue, 30 Aug 2022 16:45:16 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id v1-20020a622f01000000b0052e57ed8cdasm9954330pfv.55.2022.08.30.16.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 16:45:16 -0700 (PDT)
Date:   Tue, 30 Aug 2022 16:45:13 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v2 04/10] KVM: x86/mmu: Handle error PFNs in
 kvm_faultin_pfn()
Message-ID: <20220830234513.GA2711697@ls.amr.corp.intel.com>
References: <20220826231227.4096391-1-dmatlack@google.com>
 <20220826231227.4096391-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220826231227.4096391-5-dmatlack@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022 at 04:12:21PM -0700,
David Matlack <dmatlack@google.com> wrote:

> Handle error PFNs in kvm_faultin_pfn() rather than relying on the caller
> to invoke handle_abnormal_pfn() after kvm_faultin_pfn().
> Opportunistically rename kvm_handle_bad_page() to kvm_handle_error_pfn()
> to make it more consistent with is_error_pfn().
> 
> This commit moves KVM closer to being able to drop
> handle_abnormal_pfn(), which will reduce the amount of duplicate code in
> the various page fault handlers.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 49dbe274c709..273e1771965c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3144,7 +3144,7 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
>  	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, PAGE_SHIFT, tsk);
>  }
>  
> -static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> +static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
>  {
>  	/*
>  	 * Do not cache the mmio info caused by writing the readonly gfn
> @@ -3165,10 +3165,6 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
>  static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  			       unsigned int access)
>  {
> -	/* The pfn is invalid, report the error! */
> -	if (unlikely(is_error_pfn(fault->pfn)))
> -		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
> -
>  	if (unlikely(!fault->slot)) {
>  		gva_t gva = fault->is_tdp ? 0 : fault->addr;
>  
> @@ -4185,15 +4181,25 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
>  					  fault->write, &fault->map_writable,
>  					  &fault->hva);
> +
>  	return RET_PF_CONTINUE;
>  }

nit: unnecessary code churn.
Otherwise, code looks good to me.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
