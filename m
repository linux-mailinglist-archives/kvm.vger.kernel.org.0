Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2424354FB30
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 18:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383423AbiFQQj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 12:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382975AbiFQQjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 12:39:21 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEE3427C0
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 09:39:20 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y6so4351245plg.0
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 09:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wrdO5P+XurdaeOgOSQ+5kEyKwT7FiNPp233iypu4ges=;
        b=GLI0UsmAM2SwCj2zsTHa0oDcnMYgcUb1C8zvkJSBU2UTOlY+q5LsCvt8d+o0gH9deL
         EJxKuYIJsSURtNXkFUX2typL9jcEhnHUIRDb2fSyphm9SbBxXCf/MxljTwYKChU0WzD6
         /u1khMJU8yxHRUkSSrcsf2gPV+QsawCwxs6Z7CB1hM4QlTf2EFT/vN36oa28X48YXT+G
         dUjTHEpcxFF355xRlPkgRYJHYusbuSXE6SVvev0aFEMSpuRmMiYWYOgP6gRhRDvuQUkw
         f0gwMORKivzLEb67Z570CcSn5DcFYQGhm25keeGm2aqAsRUjtljk6RQGoKz0WIt/+DNi
         FCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wrdO5P+XurdaeOgOSQ+5kEyKwT7FiNPp233iypu4ges=;
        b=jvXKEWn/KuOb75ogtJ4/6i3ntMWHmMoUEe7dPTOUd8/VlmXcHJrm9CSRfF75+I8PZg
         +SEmf/ZFYMbalIG3JR0Z6bg2cmvao7HPK+UbEDOQoTewQ54V6UG6iSgjj52wDGXdPGVt
         ctxB8WBq7aaLJAkKeWL/syPshe7StkXTjbUSxcxhqk/L9pDVl2JY1zX4WoGwIQj4HG0u
         xfu+wdSdzhM8CnEEBZdkVkzsCAvlIfDiT4SG+EEwWd0xvvDctzAJCMm6k9awGsQJF/Uj
         ZKDX5ZBQ0EWqKwgnpqgEu8eNM7v3U1H1zKhB3UKsjRB4Zbt3fpoe0lgmANn7dglBEehs
         RWSw==
X-Gm-Message-State: AJIora8zL77hG3Tjgr59Ne/7k5ukh/yy2q8Gpy2dAasw+TlCf7LP7dKS
        GSNpCnVUDnqaMPj4Kh6Je7ywZA==
X-Google-Smtp-Source: AGRyM1vVWqfyGPjBRUy89tBJu9kICwdn0HHYHxZToGtJz6hzC1Mdg/1dOrUNNuf4HFLCQTuqX0StEg==
X-Received: by 2002:a17:902:c407:b0:163:df01:bbbc with SMTP id k7-20020a170902c40700b00163df01bbbcmr10210387plk.4.1655483959855;
        Fri, 17 Jun 2022 09:39:19 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id s10-20020a63af4a000000b003db7de758besm4134739pgo.5.2022.06.17.09.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 09:39:19 -0700 (PDT)
Date:   Fri, 17 Jun 2022 16:39:15 +0000
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
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v6 15/22] KVM: x86/mmu: Decouple rmap_add() and
 link_shadow_page() from kvm_vcpu
Message-ID: <YqyuM3v0SNPyrOmP@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-16-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-16-dmatlack@google.com>
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

On Mon, May 16, 2022, David Matlack wrote:
> @@ -1592,15 +1589,21 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
>  	sp = sptep_to_sp(spte);
>  	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
>  	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
> -	rmap_count = pte_list_add(vcpu, spte, rmap_head);
> +	rmap_count = pte_list_add(cache, spte, rmap_head);
>  
>  	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
> -		kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
> +		kvm_unmap_rmapp(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));

Ewww, the existing code is awful.  This call passes NULL for @slot, but it already
has a slot!  This could simply be

		pte_list_destroy(vcpu->kvm, rmap_head);

but that's undesirable with the current name as it's not remotely obvious that
pte_list_destroy() actually zaps rmaps.

I'll send a separate series to clean this up, e.g. rename pte_list_destroy() to
make it clear that it zaps SPTEs.  That'll also give me a good excuse to kill the
"p is for pointer" rmapp() naming scheme.  The only conflict with your series is
this one vcpu->kvm => kvm change, which is easy to note and resolve.

>  		kvm_flush_remote_tlbs_with_address(
> -				vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
> +				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
>  	}
>  }
>  
> +static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
> +		     u64 *spte, gfn_t gfn)
> +{
> +	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn);

I prefer to grab "cache" locally,

	struct kvm_mmu_memory_cache *cache = &vcpu->arch.mmu_pte_list_desc_cache;

	__rmap_add(vcpu->kvm, cache, slot, spte, gfn);

both to keep the lines shorter in the final form (adding "access" runs yours out
to 93 chars), and because I find it easier to see read the call without a gigantic
parameter in the midde.
