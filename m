Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3625B0BBE
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 19:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiIGRpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 13:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiIGRpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 13:45:43 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CF39BB78
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 10:45:40 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id v128so1046460ioe.12
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 10:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=S/oonIaSgU5+P+xzaVg+rVuKI8oFDrUKwNm4xv6c2Yw=;
        b=jTRq4KN+MFLm8CxxBQM492Nbg+eiBsIkRudHUkBxz64Hp3RNe28+MUJYyF8LTDk+4q
         7k8MA7jbsmfrmus7ejcfugn6Be8my2hjvTMScdCFh7JG45Ttul5ZH6Ez5A5xZzgjsYfe
         tHBvhe4bHR16VgXBomHHGEx/0b5G0H8Uhktbde6vK4Q+5yq7916uNMoiE2mNXscadES/
         GtYFpc9IZDlJGozKkFfe6axLKweAM41WjDa0srIjc0c1lzNMeRD8CmegySAxKXm5KN0w
         SyNr23Zv/pUEdGG2EF11c+pRATnJx7OB7VcfwYOTezE9VI3/LEPVMFaxInFWkvkABxAO
         CeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=S/oonIaSgU5+P+xzaVg+rVuKI8oFDrUKwNm4xv6c2Yw=;
        b=XcV9ajO/E5IV0/l3qGS3r/R8KWNQudv0gQBCxhXFSv0ZwKSXw4HP3NRebYwx5BMxfG
         R2geu1j+Z33uFLFvhQmSgsz8rjc1NIFXxl5SaPcMaPA3YLLCpOKfjMlw8woYdklmMsQ1
         hSWtdMANQ9VGfp+4zWDJ5hxf0YwOZ4/GGi0G3Jv8UMkaOt3qvW9MnGymI4BTNRyRlHIn
         FyIkl6Nm9MveyhJaQH35F8+cqqhSBP+H+lpPxYnz85H8pDDai5EJwmZTaCORS3COX2Z3
         f3yrsd4BKgiKEeb1U46RrI9UGjF5p971M+tN5CImjlmU+GCXwUkae5LPjT73iu3tkqRM
         BC0A==
X-Gm-Message-State: ACgBeo3m/1yTPMtaZc0N5gcfwFMDKxjiS76ccYzhjut5OyZxz5oBPRSD
        IMZE4RsoWmqQdUt7tyLZooxCaIk94VV3MKvAtDtWuw==
X-Google-Smtp-Source: AA6agR7OhLGMem1qhjuMVUdxb6YLpofj4pnp6ALJAfN+/AJK9FZfXj9IAHFzMkxEStSbHnAdeJ+Y3a++RqzhD6XSTyc=
X-Received: by 2002:a02:cbb4:0:b0:34c:d42:ac34 with SMTP id
 v20-20020a02cbb4000000b0034c0d42ac34mr2694474jap.249.1662572739595; Wed, 07
 Sep 2022 10:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <9151e79d4f5af888242b9589c0a106a49a97837c.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <9151e79d4f5af888242b9589c0a106a49a97837c.1655761627.git.ashish.kalra@amd.com>
From:   Alper Gun <alpergun@google.com>
Date:   Wed, 7 Sep 2022 10:45:28 -0700
Message-ID: <CABpDEunmzbzm-Hwi9iwWmCokfMde9yEZ+aSCrF7LPjqMvMvNeg@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 31/49] KVM: x86: Introduce kvm_mmu_get_tdp_walk()
 for SEV-SNP use
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        dgilbert@redhat.com, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Jun 20, 2022 at 4:09 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The SEV-SNP VMs may call the page state change VMGEXIT to add the GPA
> as private or shared in the RMP table. The page state change VMGEXIT
> will contain the RMP page level to be used in the RMP entry. If the
> page level between the TDP and RMP does not match then, it will result
> in nested-page-fault (RMP violation).
>
> The SEV-SNP VMGEXIT handler will use the kvm_mmu_get_tdp_walk() to get
> the current page-level in the TDP for the given GPA and calculate a
> workable page level. If a GPA is mapped as a 4K-page in the TDP, but
> the guest requested to add the GPA as a 2M in the RMP entry then the
> 2M request will be broken into 4K-pages to keep the RMP and TDP
> page-levels in sync.
>
> TDP SPTEs are RCU protected so need to put kvm_mmu_get_tdp_walk() in RCU
> read-side critical section by using walk_shadow_page_lockless_begin() and
> walk_lockless_shadow_page_lockless_end(). This fixes the
> "suspicious RCU usage" message seen with lockdep kernel build.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/mmu.h     |  2 ++
>  arch/x86/kvm/mmu/mmu.c | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index c99b15e97a0a..d55b5166389a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -178,6 +178,8 @@ static inline bool is_nx_huge_page_enabled(void)
>         return READ_ONCE(nx_huge_pages);
>  }
>
> +bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level);
> +
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>                                         u32 err, bool prefetch)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 569021af349a..c1ac486e096e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4151,6 +4151,39 @@ kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
>
> +bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level)
> +{
> +       u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
> +       int leaf, root;
> +
> +       walk_shadow_page_lockless_begin(vcpu);
> +
> +       if (is_tdp_mmu(vcpu->arch.mmu))
> +               leaf = kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, &root);
> +       else
> +               leaf = get_walk(vcpu, gpa, sptes, &root);
> +
> +       walk_shadow_page_lockless_end(vcpu);
> +
> +       if (unlikely(leaf < 0))
> +               return false;
> +
> +       /* Check if the leaf SPTE is present */
> +       if (!is_shadow_present_pte(sptes[leaf]))
> +               return false;
> +
> +       *pfn = spte_to_pfn(sptes[leaf]);
> +       if (leaf > PG_LEVEL_4K) {
> +               u64 page_mask = KVM_PAGES_PER_HPAGE(leaf) - KVM_PAGES_PER_HPAGE(leaf - 1);
> +               *pfn |= (gpa_to_gfn(gpa) & page_mask);

Similar to the discussion in the other patch, I believe you should
apply the same fix here as well.
It should be
u64 page_mask = KVM_PAGES_PER_HPAGE(leaf) - 1;

> +       }
> +
> +       *level = leaf;
> +
> +       return true;
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_get_tdp_walk);
> +
>  static void nonpaging_init_context(struct kvm_mmu *context)
>  {
>         context->page_fault = nonpaging_page_fault;
> --
> 2.25.1
>
