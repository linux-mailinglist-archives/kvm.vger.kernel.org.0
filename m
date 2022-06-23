Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7E1558BF8
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 01:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiFWXyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 19:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiFWXyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 19:54:06 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F041860C75
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 16:54:04 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id r1so600291plo.10
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 16:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wd94p2+WqQP2Ii1WcqvC1IXTIcgtiGxYezXGFIQe4aw=;
        b=KRbCcVbxTFuDlazWUaKQUOPh9qGmRm7JwBluWdtIN5lgQADy/y7Up21hjyeZeQys9Z
         NMqMid/gRBBHHYlCK7KIkeKD3DLErorhP5V+TeYnyI1mbE93G5ic0rsWpsJWV1C+42LU
         PrYQmevMfKBsIGm95i+gNd0xYzQmBNyHGbpvH3LVLLxC5rB1V6KN19Cl9M0sp5s2w9l6
         WLbDnhaJ7u2YbmxJX0UAAtHMm5VyarVBixum6aehiJ5wufCuioLQdpujYZHlxrQGAQod
         hl/cO0Ueg3xaFoThE8ukKSg2RezOKgvSQvZsrkDGOCohZDFk9SBliO8ffRLHYo8T0d61
         lPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wd94p2+WqQP2Ii1WcqvC1IXTIcgtiGxYezXGFIQe4aw=;
        b=Cs5dH/BhEb94YPrYzbSRG/78+1XOXHjBtDdK0y5VtJkBDh+j1gmiB/5ZLyRTQ4JQkM
         R+6gF2iN1CPNcoCsHgjtVipznaDOTDL06Knu/pEV7tu+IVLGS0DYMQE/mQzc240kZAK7
         N95tnkX+5ad8N7BPA15OPUMYzUfXbusgha9HjPko6is0Fn3xhzI4Eet/RmlpcrHxNkGi
         vYScJT9WG6obG47UvCESHmOo7RjY2AzDUq5V+74wVhwM8zhG9kr7tknhpNs0gBMRyale
         0mzUSG6rOtm93owbZ5EhTOBLRWcRD6zJ7iHk+O4o8GXeyuZ9gDerkZui75UfKU1X0dSJ
         oR+A==
X-Gm-Message-State: AJIora+rdiRwMtEdHAIOO60dNYxaIqf/R5oW9m/bVpgB/F3/w7BZYWab
        ZF+ZF19kSBzyQXiylDaunXkJ+w==
X-Google-Smtp-Source: AGRyM1siQHqmIeCYJDWhvQWr1e0zNrxAB/HYSnquYY9LulXlxpDsnuWHIYP6tBFrXyXqdMpDCmOmEg==
X-Received: by 2002:a17:902:dac5:b0:164:13b2:4916 with SMTP id q5-20020a170902dac500b0016413b24916mr41737113plx.32.1656028444167;
        Thu, 23 Jun 2022 16:54:04 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id bf27-20020a056a000d9b00b0051bd9981ccbsm220385pfb.39.2022.06.23.16.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 16:54:03 -0700 (PDT)
Date:   Thu, 23 Jun 2022 23:53:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, maz@kernel.org,
        anup@brainfault.org, bgardon@google.com, peterx@redhat.com,
        maciej.szmigiero@oracle.com, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        pfeiner@google.com, jiangshanlai@gmail.com, dmatlack@google.com
Subject: Re: [PATCH v7 19/23] KVM: x86/mmu: Zap collapsible SPTEs in shadow
 MMU at all possible levels
Message-ID: <YrT9F6S/PjYVk6Hr@google.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
 <20220622192710.2547152-20-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622192710.2547152-20-pbonzini@redhat.com>
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

On Wed, Jun 22, 2022, Paolo Bonzini wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU. This
> is fine for now since KVM never creates intermediate huge pages during
> dirty logging. In other words, KVM always replaces 1GiB pages directly
> with 4KiB pages, so there is no reason to look for collapsible 2MiB
> pages.
> 
> However, this will stop being true once the shadow MMU participates in
> eager page splitting. During eager page splitting, each 1GiB is first
> split into 2MiB pages and then those are split into 4KiB pages. The
> intermediate 2MiB pages may be left behind if an error condition causes
> eager page splitting to bail early.
> 
> No functional change intended.
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> Message-Id: <20220516232138.1783324-20-dmatlack@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 13a059ad5dc7..36bc49f08d60 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6154,18 +6154,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  	return need_tlb_flush;
>  }
>  
> +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> +					   const struct kvm_memory_slot *slot)
> +{
> +	/*
> +	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
> +	 * pages that are already mapped at the maximum possible level.
> +	 */
> +	if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> +			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
> +			      true))

Can you fix this up to put "true" on the previous line?

And if you do that, maybe also tweak the comment to reference "hugepage level"
instead of "possible level"?

---
 arch/x86/kvm/mmu/mmu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8825716060e4..34b0e85b26a4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6450,12 +6450,11 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 					   const struct kvm_memory_slot *slot)
 {
 	/*
-	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
-	 * pages that are already mapped at the maximum possible level.
+	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1, there's no need to zap pages
+	 * that are already mapped at the maximum hugepage level.
 	 */
 	if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
-			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
-			      true))
+			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
 		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 }


base-commit: fd43332c2900db8ca852676f37f0ab423d0c369a
--

