Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C73F6E5110
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 21:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjDQThG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 15:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDQThE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 15:37:04 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A46EC;
        Mon, 17 Apr 2023 12:37:02 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4edc51644b6so95351e87.1;
        Mon, 17 Apr 2023 12:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681760220; x=1684352220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kcEqkWwDnSb2Vr/kKTigbKdiQ7bKuudzY2P/pZrExU=;
        b=pawD2mkoR+7QoMOQwCB1AYWgSd7dZsJs1NVJiLuM60kxBLCpkr2u4c0nF5ciUFoNg0
         k64wLTCq9lKp1A9g4gM11Gz1bvdH/RnqRnvRg2cb5tTkWeDqcLa3mmal1kkmOdkllnJ4
         t5dQTf0HLMzlrlpir1+cDDWeTS7lzjzS3t1QAMYtgjAGJ1Vgc8IhthnKhcZkfaHeWPFm
         ZOxNaEFpS3uEQYOsMx3NAxkcXE8XAT30AuY/dh5LOnWz/vjz//Ob2Wcv1xrNyZ32VlrF
         jNrfMS+JpHkjIf7/sWpdFWV/8UllRnGfSqjgeCPr2nw6CYEAnP/gBVVhhDX4+CoUU5XF
         QOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681760220; x=1684352220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7kcEqkWwDnSb2Vr/kKTigbKdiQ7bKuudzY2P/pZrExU=;
        b=CT4FdIUtQbVZFdnsgAuZ0Cy838fcg9u0JEr0ZxuZ7puxLvKj2Wo1GAfC7Exo1aFr8H
         c6s9zdHhtTKWrqpMmZ/FRazPsnKmq4cxpqWtVyS1vNysiwyDu6G/CPk4YYprd5v0NQuy
         pt0XeHIJzmIkNVERPDl+xr4T5LMC8SpiEs+4xEmNRsK+qD/LV0yB+782ZFyt/SDrGkwW
         KlY3eG+KzLUl3XJFBNV8Mu6LfEERD/Zmla4O10TtCDJ8YBL+EUyAwVX/qiMELHy46JsW
         M9lRgCxh7iiEv2vQTH/PN18gaAsJNy4YA4oCZW1S74giV7/Z7TW8qHwi719QaaSbLzcS
         rGAQ==
X-Gm-Message-State: AAQBX9c9yzuMbJBSaKvSXmBGN2jgoDkVF7mK85Jl2lVb1ytJn42ozOoy
        LGU9ZrEmC7kqYJfmgGukgxM=
X-Google-Smtp-Source: AKy350bwPR/Fg5EyUJdxVaBkSyRMFm3rP1YuBXk/6dNmo5EhpB5GHRJudKaNFxzjf189UrXL2rbMsg==
X-Received: by 2002:a05:651c:88a:b0:2a8:c954:e9e0 with SMTP id d10-20020a05651c088a00b002a8c954e9e0mr991502ljq.3.1681760220186;
        Mon, 17 Apr 2023 12:37:00 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id p24-20020a2ea418000000b002a7a5201bfdsm2328460ljn.80.2023.04.17.12.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 12:37:00 -0700 (PDT)
Date:   Mon, 17 Apr 2023 22:36:11 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH 1/5] KVM: Split tdp_mmu_pages to private and shared
 lists
Message-ID: <20230417223611.00004aee.zhi.wang.linux@gmail.com>
In-Reply-To: <20230407201921.2703758-2-sagis@google.com>
References: <20230407201921.2703758-1-sagis@google.com>
        <20230407201921.2703758-2-sagis@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Apr 2023 20:19:17 +0000
Sagi Shahar <sagis@google.com> wrote:

This patch is actually adding a separate counter for accounting private
tdp mmu page not really introducing a new tdp_mmu_pages list for private
pages. I guess better refine the tittle to reflect what this patch
is doing.

> tdp_mmu_pages holds all the active pages used by the mmu. When we
> transfer the state during intra-host migration we need to transfer the
> private pages but not the shared ones.
> 
Maybe explain a little bit about how the shared one is processed. Guess
one sentence is enough.
> Keeping them in separate counters makes this transfer more efficient.
> 
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  5 ++++-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 11 +++++++++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ae377eec81987..5ed70cd9d74bf 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1426,9 +1426,12 @@ struct kvm_arch {
>  	struct task_struct *nx_huge_page_recovery_thread;
>  
>  #ifdef CONFIG_X86_64
> -	/* The number of TDP MMU pages across all roots. */
> +	/* The number of non-private TDP MMU pages across all roots. */
>  	atomic64_t tdp_mmu_pages;
>  
> +	/* Same as tdp_mmu_pages but only for private pages. */
> +	atomic64_t tdp_private_mmu_pages;
> +
>  	/*
>  	 * List of struct kvm_mmu_pages being used as roots.
>  	 * All struct kvm_mmu_pages in the list should have
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 58a236a69ec72..327dee4f6170e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -44,6 +44,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
>  
>  	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
> +	WARN_ON(atomic64_read(&kvm->arch.tdp_private_mmu_pages));
>  	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
>  
>  	/*
> @@ -373,13 +374,19 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>  static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	kvm_account_pgtable_pages((void *)sp->spt, +1);
> -	atomic64_inc(&kvm->arch.tdp_mmu_pages);
> +	if (is_private_sp(sp))
> +		atomic64_inc(&kvm->arch.tdp_private_mmu_pages);
> +	else
> +		atomic64_inc(&kvm->arch.tdp_mmu_pages);
>  }
>  
>  static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	kvm_account_pgtable_pages((void *)sp->spt, -1);
> -	atomic64_dec(&kvm->arch.tdp_mmu_pages);
> +	if (is_private_sp(sp))
> +		atomic64_dec(&kvm->arch.tdp_private_mmu_pages);
> +	else
> +		atomic64_dec(&kvm->arch.tdp_mmu_pages);
>  }
>  
>  /**

