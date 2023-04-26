Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FB26EF946
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 19:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbjDZRYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 13:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbjDZRX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 13:23:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EA96E90
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b9a2abd8f7bso2379160276.2
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529828; x=1685121828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pAiG4M4zdB3ZPS4C+GQYfSIhvMBL1SgC8o3oTmyskQQ=;
        b=CxpcHMMhr7Fgwt8dYCe2BOA8DJw7t6x9BkvXVWXeb0YcCgwBkQtF8DnD/Ths5GSkI+
         v1t6R1QGyERjMK+D5NseLjfRctZKQ27CUmT2R2sxrBuZgxaYCjhf1Q3jh6mCN9m3BV0m
         8xrYcP0CJHnbSlXzofhde25irTEsX55L2leF3+KTYcPagKp5YJm0DsWFUp1E9iIs/Qfg
         dLolmFoUiq2Ag2B9x/JQmfADG5PWsZMerC2tpy/RA6s3lFNGK6dq/L+QRCKTXXOYAasa
         hh9gRXO3KGJ3MEqKZgFnLLicv3QlxI1RiT1WpnZdOn88tlx03NNf4+OnFQfWhAudgup1
         9Uiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529828; x=1685121828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pAiG4M4zdB3ZPS4C+GQYfSIhvMBL1SgC8o3oTmyskQQ=;
        b=hxFa8QpS451c75N0uP3Nkcdz/eW+vam/iQLkXxas1jR/vFa6nFICqWbZvWK3iRpiEj
         /TqE7kNeNPnYsfYbHcTBKPJrSy7DUhE29zDFW2Vdem2hpfkkYZvYxQ7/VM1gauHR+4z8
         u/FPqDMXEO9H35erE8HoQ5lMOqocgXprOOqBUJveOJJCfRBYCVAND656kFitFBRIXwWX
         qwytptxFZnvvuAVgMTVsNVaClLCJ6Yp0503oyr6N8WFo3rFynuxk6/dbYWZ19N2DscCe
         fmUxGbzPifi1UneuSVkEXoU1UaGBHVEdaexRX0CpmZvj+NM2QEJ5MPS3V+A1PWC7jchA
         5Agg==
X-Gm-Message-State: AAQBX9fx/m1MPLMcKI+SQ6jic4phX5eh0SL2z+UsKxM+FlukeLGUzUlh
        GI1fynGHbixfHvPk4sKfH3SrrgvkQX/iog==
X-Google-Smtp-Source: AKy350ZC4mXk7wOxH8b9fUBEzfpbdi/sM13by1NauZUSpknjsByveFQnwFClX/PKT22DO0G93jmh0idMzU6hCQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:d6ca:0:b0:b95:ecc5:5796 with SMTP id
 n193-20020a25d6ca000000b00b95ecc55796mr8271060ybg.12.1682529828133; Wed, 26
 Apr 2023 10:23:48 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:23:26 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-9-ricarkol@google.com>
Subject: [PATCH v8 08/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd() into it. A
future commit will add some more things to do inside of
kvm_uninit_stage2_mmu().

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 1 +
 arch/arm64/kvm/mmu.c             | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 27e63c111f78a..20c50e00496d8 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -172,6 +172,7 @@ void __init free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
+void kvm_uninit_stage2_mmu(struct kvm *kvm);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 92f8872550f26..46f005a894e57 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -771,6 +771,11 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return err;
 }
 
+void kvm_uninit_stage2_mmu(struct kvm *kvm)
+{
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
+}
+
 static void stage2_unmap_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
@@ -1864,7 +1869,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_uninit_stage2_mmu(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.40.1.495.gc816e09b53d-goog

