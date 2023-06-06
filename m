Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06A1724D09
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 21:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbjFFT3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 15:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbjFFT3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 15:29:06 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EED10CA
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 12:29:05 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-565d6824f2dso96373787b3.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 12:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686079744; x=1688671744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y/6r0APF1ZckoGqXlaGvs8Fu6vhIxmcIHa2PTldZqrc=;
        b=HROLBGcLzE2atijiNX1ii4qKy1NnZjDVJ2kEkcVq7akH6GXfAU/PURTOYeA1Fd3irL
         loZJcuzeMJQWiPc+eco7vhtWoXqUp+IN5FkojMhYMlCiNpiw0fngJVyEFOcVxVyWnFQh
         +gcgaUw7f215ouppXeJewToyof44pQBb6BMXlpmlQXBXulkOf14wsE2M+dzGwXRJXGDO
         tXYBE0nFA7WI3kdoYPlUzPvl3zlKkxhGXpRIxX3eMo9NQ0NTn6HpNV1hyxUFHYQvVx79
         7pEjVRLezWD4bN8CzhqGspEo7nDCUf/xgwe0hSdoiB3Hz7hn4zw5wVWFGuOYWVlr+Pd6
         MDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686079744; x=1688671744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y/6r0APF1ZckoGqXlaGvs8Fu6vhIxmcIHa2PTldZqrc=;
        b=KsEzgEkp/dMwphfwHSQF4Wj619oh1R7O3wHwL2wntIJlwirvAEs4ZhZiWKnjivryhY
         ZMGyPrGJrI0oZH+7ufXIDRtl2WCbvTT0BbauLzvywvqRiOfPORXb/Ff9O4DD5efRJbMo
         tz+mXh2pBO1l5JSm095awfVuDdhC1Mpc4EFVig1yLNNAD/zoyWEjG8nKPhLJ8uYhwYi2
         Jzii7FpWpFNPVwvD0LyGEAFTXdE9sEBrv8uVWcxKyAVbeI2d4hS3mDdw9/QJpnhSLoHX
         SuqP0W8jvLikRC6emQxtqF/2B/OHjXttq9AK141K8V3LK1yONer6+BXGugcw8G10i/ih
         3WoQ==
X-Gm-Message-State: AC+VfDwPz+jxZ5nYtT53KCnQvRIxj2nS49WjCu3WB/K/opJ1Aelzk7oT
        L9ORaHewG/LPbubTFbInfJo0gKkT8Ph4
X-Google-Smtp-Source: ACHHUZ54ovTJrXatnDidaPzJUKJNjQF3PJ8x+yDMQFY1Hlip1RgYFAk5ctLOp86VAyj2wEpJVtXaO/c4qHQg
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:690c:708:b0:568:ee6d:3364 with SMTP id
 bs8-20020a05690c070800b00568ee6d3364mr1523405ywb.4.1686079744392; Tue, 06 Jun
 2023 12:29:04 -0700 (PDT)
Date:   Tue,  6 Jun 2023 19:28:53 +0000
In-Reply-To: <20230606192858.3600174-1-rananta@google.com>
Mime-Version: 1.0
References: <20230606192858.3600174-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606192858.3600174-3-rananta@google.com>
Subject: [PATCH v5 2/7] KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

Define  __kvm_tlb_flush_vmid_range() (for VHE and nVHE)
to flush a range of stage-2 page-tables using IPA in one go.
If the system supports FEAT_TLBIRANGE, the following patches
would conviniently replace global TLBI such as vmalls12e1is
in the map, unmap, and dirty-logging paths with ripas2e1is
instead.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  3 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c      | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/tlb.c       | 28 ++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 43c3bc0f9544d..60ed0880cc9d6 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -69,6 +69,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr,
@@ -225,6 +226,8 @@ extern void __kvm_flush_vm_context(void);
 extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
+extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+					phys_addr_t start, unsigned long pages);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 728e01d4536b0..a19a9299c8362 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -125,6 +125,16 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
 	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 }
 
+static void
+handle___kvm_tlb_flush_vmid_range(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
+	DECLARE_REG(unsigned long, pages, host_ctxt, 3);
+
+	__kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, pages);
+}
+
 static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
@@ -316,6 +326,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
+	HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__vgic_v3_read_vmcr),
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 978179133f4b9..213b11952f641 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -130,6 +130,36 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t start, unsigned long pages)
+{
+	struct tlb_inv_context cxt;
+	unsigned long stride;
+
+	/*
+	 * Since the range of addresses may not be mapped at
+	 * the same level, assume the worst case as PAGE_SIZE
+	 */
+	stride = PAGE_SIZE;
+	start = round_down(start, stride);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt, false);
+
+	__flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false);
+
+	dsb(ish);
+	__tlbi(vmalle1is);
+	dsb(ish);
+	isb();
+
+	/* See the comment below in __kvm_tlb_flush_vmid_ipa() */
+	if (icache_is_vpipt())
+		icache_inval_all_pou();
+
+	__tlb_switch_to_host(&cxt);
+}
+
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 24cef9b87f9e9..3ca3d38b7eb23 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -111,6 +111,34 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t start, unsigned long pages)
+{
+	struct tlb_inv_context cxt;
+	unsigned long stride;
+
+	/*
+	 * Since the range of addresses may not be mapped at
+	 * the same level, assume the worst case as PAGE_SIZE
+	 */
+	stride = PAGE_SIZE;
+	start = round_down(start, stride);
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	__flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false);
+
+	dsb(ish);
+	__tlbi(vmalle1is);
+	dsb(ish);
+	isb();
+
+	__tlb_switch_to_host(&cxt);
+}
+
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
-- 
2.41.0.rc0.172.g3f132b7071-goog

