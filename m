Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952D56779C7
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 12:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjAWLDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 06:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjAWLDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 06:03:41 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573ED18169
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 03:03:40 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ss4so29338946ejb.11
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 03:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8nHM8yyaEmBjEgyXWgFGonFD03pg+zSiWIDjK0eEjVE=;
        b=nX2aRVwWQF/kuuaDEfzKMZcjnFkarUOQ4gPJgSlQf4L3jbvoqNlv86tpWgJFzhmZoR
         Zcdy0xMr2C9LqaAwYUwGLx61pC6INiLCNZ4wqblpdym+vJD73m2aeanKyMaHD9mJtfgA
         3kCZKCUH087vDrCt3LtRbxJ60JwVPzs3I7Sc0N9WyEiEzO+HSPPS5AlcCTVMRMbsE6XN
         L5HS5m/W/nHzNbfuhYAfAKzxoQqqJpAKNa9sGw9N0HhqdWI9GYzBWqOBqvLZoWgzOQDp
         OlTrJJ8xodzsDiZNTzLAst61echxAb58Jw+d1nQZA+ZJwyKyFr+lIHEoUxkRjcPdk16Q
         SPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nHM8yyaEmBjEgyXWgFGonFD03pg+zSiWIDjK0eEjVE=;
        b=sqDb8xZ3nge4qY7ULCxPfSLUhuvLJZ6FyWmSNWXzbBTRv2X0hRxN5tD3iSHO+nRcxK
         adbcqnAYNkxCXkIkjQhTZKPEOzw6lg9/TVF3Xvlb7HIgKfOTm50VP5L+ISoY8YJoTGtW
         g3Th+Lg0tqIiTtUMeZRa1yL7yRZVSMvksX1tRFEWW2XiBDVrHpbvEUvVFD/L04Px6K31
         8Sfbkn3neqoZQDc0feXSpW6RS61tdCl7kQjOGqwx1wUPcZXYs6aX9quxfCFFJKvRhvGi
         SKcPl3fakxeXZmMXPWTDtLXwQcQ5y6FTqP9mPPeGp7clAQ86gnNkPfMvkLUQy7kpfoA4
         auqg==
X-Gm-Message-State: AFqh2kqHWpB1+sd+Tl6qipDtn9zld2vtpB+S3Rs3dMf/Dz11godALUub
        KwwsmFcIQSwYfVnaGrpzcnrBSg==
X-Google-Smtp-Source: AMrXdXu3hOZNQbMBpbg9WG/nQ6yc7jkGkZRbARoAECj3fYCt8bkyPvibGlnW08h2f5aXenyZ3S9Ciw==
X-Received: by 2002:a17:907:b9da:b0:872:21b2:9a1f with SMTP id xa26-20020a170907b9da00b0087221b29a1fmr25436642ejc.58.1674471818955;
        Mon, 23 Jan 2023 03:03:38 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id w26-20020a1709060a1a00b0087768737091sm7252459ejf.207.2023.01.23.03.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:03:38 -0800 (PST)
Date:   Mon, 23 Jan 2023 12:03:37 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Alexandre Ghiti <alexghiti@rivosinc.com>
Cc:     Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: RISC-V: Fix wrong usage of PGDIR_SIZE to check page
 sizes
Message-ID: <20230123110337.3pmsk7nvip3sxlc4@orel>
References: <20230123092928.808014-1-alexghiti@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123092928.808014-1-alexghiti@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023 at 10:29:28AM +0100, Alexandre Ghiti wrote:
> At the moment, riscv only supports PMD and PUD hugepages. For sv39,
> PGDIR_SIZE == PUD_SIZE but not for sv48 and sv57. So fix this by changing
> PGDIR_SIZE into PUD_SIZE.

Can you please add a sentence as to how you found this? Some test case
or just by analysis?

Anyway,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

> 
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>  arch/riscv/kvm/mmu.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 34b57e0be2ef..dbc4ca060174 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -585,7 +585,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	if (!kvm->arch.pgd)
>  		return false;
>  
> -	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
> +	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
>  
>  	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
>  				   &ptep, &ptep_level))
> @@ -603,7 +603,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	if (!kvm->arch.pgd)
>  		return false;
>  
> -	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
> +	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
>  
>  	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
>  				   &ptep, &ptep_level))
> @@ -645,12 +645,12 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>  	if (logging || (vma->vm_flags & VM_PFNMAP))
>  		vma_pagesize = PAGE_SIZE;
>  
> -	if (vma_pagesize == PMD_SIZE || vma_pagesize == PGDIR_SIZE)
> +	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>  		gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
>  
>  	mmap_read_unlock(current->mm);
>  
> -	if (vma_pagesize != PGDIR_SIZE &&
> +	if (vma_pagesize != PUD_SIZE &&
>  	    vma_pagesize != PMD_SIZE &&
>  	    vma_pagesize != PAGE_SIZE) {
>  		kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
> -- 
> 2.37.2
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
