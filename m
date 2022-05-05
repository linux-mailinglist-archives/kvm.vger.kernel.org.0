Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5F051CCE7
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 01:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386888AbiEEXuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 19:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386893AbiEEXuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 19:50:37 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637CC606FE
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 16:46:56 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k14so4828883pga.0
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 16:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UXlxQWVPF63McNIcQ+A040lcStWvWFpvQxHMkE9R0XY=;
        b=At67K2Y4KGg6aRuQ7SBWpf7VNQtpqf3Y1lbdewqOCGIOp9dBYcGBoaWLhYEoSIqxQP
         Zv8nH9HNjn04xhBHJnvRuaqDorPQBLGEleKUtbDW9+CVyCrzSCnQUe906MMzyfvI5cOp
         cphDe1trwuzxUWWfrEjR8RLktm6BDp7pMrINwNHC2Lj6C6poV2839PsPY7xjZoNuG/Xo
         RlEuXTtiokG2+cELXEYgNDgGHfnw+t1XqQH+Kdhv2oEegEx3lEbHa5XnPuPB4TtJuR43
         /0OP26/oUVQBq/o9zTyABDxGo+Zk5+FzKWWuXZM90ikc+sDNWr4R7RlS/ZzuShzLvU/m
         BtzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UXlxQWVPF63McNIcQ+A040lcStWvWFpvQxHMkE9R0XY=;
        b=k4AqeLH3W1xuORKPQT18c0wP7Wme2xBD0deQCY7ICb+E3mKq+lF6FEOyTO/vkX8h45
         QIEjUZDHayMvm3ob4fTO8V8PRhuNHxDorp/SDF1k4fGsvb37WBOAYe9x8sAjbUNld4DP
         2FRMx5Qx3A0Gx562//i/teVbENGlGdw/eHH2zeH5jKebBlMotYhds633NRKEQ4sffyHj
         TuqTIGv08oL16iHAGlrYkGVgMrhy1mWJJI4ekbZxb0vJYToROgcBJDPcTTCmdirwxSGp
         ur4uqa2REFpXyp1TSMGmR8KADP10jlx3chRXwDQg+XM2iLPL0wg890XFhi7fbF7luU4i
         FKIQ==
X-Gm-Message-State: AOAM533E4IPzQpWUqppcHRXQVsyeZPZb8FJ1iZFTOWLBj8wPYB2BclKb
        UWcNCTmGHdoshS1sopTRcNMMkQ==
X-Google-Smtp-Source: ABdhPJz58A4E/Uzn7xxWw89AW8b22CVIBbrmFsaLiw+m0NqSKF1b6yIOoFI8sXFMfGQhIvtZl+2WbA==
X-Received: by 2002:a63:88c3:0:b0:3ab:2edc:b95b with SMTP id l186-20020a6388c3000000b003ab2edcb95bmr473166pgd.233.1651794415699;
        Thu, 05 May 2022 16:46:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b10-20020a17090a550a00b001d954837197sm5814952pji.22.2022.05.05.16.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 16:46:55 -0700 (PDT)
Date:   Thu, 5 May 2022 23:46:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v4 13/20] KVM: x86/mmu: Decouple rmap_add() and
 link_shadow_page() from kvm_vcpu
Message-ID: <YnRh6yyGQZ+U31U1@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-14-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-14-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 22, 2022, David Matlack wrote:
> -static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
> -			     struct kvm_mmu_page *sp)
> +static void __link_shadow_page(struct kvm_mmu_memory_cache *cache, u64 *sptep,
> +			       struct kvm_mmu_page *sp)
>  {
>  	u64 spte;
>  
> @@ -2297,12 +2300,17 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
>  
>  	mmu_spte_set(sptep, spte);
>  
> -	mmu_page_add_parent_pte(vcpu, sp, sptep);
> +	mmu_page_add_parent_pte(cache, sp, sptep);
>  
>  	if (sp->unsync_children || sp->unsync)
>  		mark_unsync(sptep);
>  }
>  
> +static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep, struct kvm_mmu_page *sp)

Nit, would prefer to wrap here, especially since __link_shadow_page() wraps.

> +{
> +	__link_shadow_page(&vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
> +}
> +
>  static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  				   unsigned direct_access)
>  {
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
