Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281284ACBDA
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 23:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243675AbiBGWKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 17:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiBGWKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 17:10:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E116C061355
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 14:10:44 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id om7so1122675pjb.5
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 14:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G6eyJKmfFUAf01J78dlSIW81WrqdXWXhBcO7ghlDcmA=;
        b=sKkGLjPzG0ZdullIrSblfCWKuBIrej5PizLx1i2qsH980wbmqxt87m/yEzS8GwLs1r
         GpBtXo/uBEMAQWFyNhPUTJHGjK1BXW6BhmIpgOlyY7lg0VqBmCNP+FmDvYSobG6QKC7h
         EyAbVBAfrarGbvoAxWACbeFf2ire1Wjo+L4d9dHlNFdRBDF9ymnK473SClAzMFMMYSaK
         RaOSlWQZoQBVw6y2uZcLQsrAHEtfoj1BJr+/fn7H4gmWBGST+mtyzPX10xJexfKJ70/8
         lsJNUUxI3VCqNoqmFvtAt6VCmXD70qbFQTRDmPly42D/kpiC+nLBc+WzwW1ss4RbgCTa
         iIWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G6eyJKmfFUAf01J78dlSIW81WrqdXWXhBcO7ghlDcmA=;
        b=hnpTeFXLIKAPM2p/+byTxO2Xm+ZrDttk3H6G7eoKcOMLbWxFHwgLBsU5lELIOjEBS1
         bIX5UBnQfAEOmoVCZyNOQUrmlFEanv/Kl/bDaFpdHeJPBsusWoQltLv57XenTj2EkEOE
         4/PlJ+jG3mAOr9ZTQ7nl3at7p4rCN+Sir0dGh5Wo9YNvJBdybUwUCzFbeIcBVUKVNzM+
         3MAo3T3v5AZZ904EJ12xmNV6vlKfJ5db1lh+ignxD7JipXhYfJ76gBLMH6UMaOK2cnhf
         GIAqLUtD3Twv3HxQmpwVOLLBbWIC9xP8PwOqgFR5zusEiIsnwBkCHBgreHOAJYyCbMKI
         xsMg==
X-Gm-Message-State: AOAM533qeSfr5fY+yL5+vqPuI1tTJR4hEWBL0TFStwEiBxlwbQ+bJ5BT
        pTdRPx2nOSnSPQS9ZEvK0OwmBg==
X-Google-Smtp-Source: ABdhPJxB51iuOhrkdmc8x9jKC4OFpA+BCdGplAtgiK5P5F4x8sDSnX4s5Ux5HHNw1ECYAALxgHakVw==
X-Received: by 2002:a17:90b:2251:: with SMTP id hk17mr1096502pjb.210.1644271843558;
        Mon, 07 Feb 2022 14:10:43 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id p21sm207825pfo.97.2022.02.07.14.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:10:42 -0800 (PST)
Date:   Mon, 7 Feb 2022 22:10:39 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 11/23] KVM: MMU: do not recompute root level from
 kvm_mmu_role_regs
Message-ID: <YgGY31hso29mbQ2E@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-12-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-12-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:57:06AM -0500, Paolo Bonzini wrote:
> The root_level can be found in the cpu_role (in fact the field
> is superfluous and could be removed, but one thing at a time).
> Since there is only one usage left of role_regs_to_root_level,
> inline it into kvm_calc_cpu_role.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f98444e1d834..74789295f922 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -253,19 +253,6 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
>  	return regs;
>  }
>  
> -static int role_regs_to_root_level(const struct kvm_mmu_role_regs *regs)
> -{
> -	if (!____is_cr0_pg(regs))
> -		return 0;
> -	else if (____is_efer_lma(regs))
> -		return ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL :
> -					       PT64_ROOT_4LEVEL;
> -	else if (____is_cr4_pae(regs))
> -		return PT32E_ROOT_LEVEL;
> -	else
> -		return PT32_ROOT_LEVEL;
> -}
> -
>  static inline bool kvm_available_flush_tlb_with_range(void)
>  {
>  	return kvm_x86_ops.tlb_remote_flush_with_range;
> @@ -4673,7 +4660,13 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
>  		role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);
>  		role.base.smap_andnot_wp = ____is_cr4_smap(regs) && !____is_cr0_wp(regs);
>  		role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
> -		role.base.level = role_regs_to_root_level(regs);
> +
> +		if (____is_efer_lma(regs))
> +			role.base.level = ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
> +		else if (____is_cr4_pae(regs))
> +			role.base.level = PT32E_ROOT_LEVEL;
> +		else
> +			role.base.level = PT32_ROOT_LEVEL;

Did you mean to drop the !CR0.PG case?

>  
>  		role.ext.cr0_pg = 1;
>  		role.ext.cr4_pae = ____is_cr4_pae(regs);
> @@ -4766,7 +4759,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
>  	context->get_guest_pgd = get_cr3;
>  	context->get_pdptr = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
> -	context->root_level = role_regs_to_root_level(regs);
> +	context->root_level = cpu_role.base.level;
>  
>  	if (!is_cr0_pg(context))
>  		context->gva_to_gpa = nonpaging_gva_to_gpa;
> -- 
> 2.31.1
> 
> 
