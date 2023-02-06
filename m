Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E20E68C491
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 18:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjBFRYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 12:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjBFRYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 12:24:04 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED202B617
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 09:23:50 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id n18-20020a056e02101200b0030f2b79c2ffso8514299ilj.20
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 09:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HShlHRYMfKfRQSfEY5d9PUEY0vusoRIVcg8R7I5JtSo=;
        b=KFxpvgYxyiHxlMf2kQXY8O7Vohrk2xKMdNeZHDLHgtSxKzi5XFednKMFazo7zN0g78
         pHamNJHi0NB0xPRWtg7XSuph++snmq8X/mXf+v8P19DeJTrxJx7n1xOAUc8/lDYK0QLo
         xiqV/MtYIXgl+7OFWheeL9dxdw54qLmGzVDOWAtMt0M/Ne8BolgoCEvOynt1cVUyK9RY
         OtkeMk/n1bmTUHXHtRKHl05QdrYycuHcPG1X149XVXiiThRv86Ac3hE0O1CXCoXo8i7Z
         qK6M4Da9UnpHsAK2d4hSQ1Wo5O6cqG/hV8I8eA2nNI0pZag0tnKnjald5fDghJch3EC9
         IQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HShlHRYMfKfRQSfEY5d9PUEY0vusoRIVcg8R7I5JtSo=;
        b=j/VnLBvvlSyO4vTsmStVoRjPk0t+kf7ZRMf+99Wy5LH749SGy/Jjwg1s+t4Kv7vr3c
         CT+Ov+eKCfkmCjEEdBgoH5Zn/91EF1FVUf2PbUN/QPrtAPxFc/zHqOl/Z/88AZznLKkf
         1muZ0EhOf5fa82Z2q2SK/N184B70hW/Qf7HbOKho/wyC5V0dVO5AVYop1jJCNGEYGYIo
         D22+iQxlWwqsp2DqMsmGzAhPFlwjRSDDxZnJ3DMDhO02rN6/auXPgUKUJbF7UaXi/T4U
         SttT7XgWwYgOAMw1UY10mE29K9FsNpdeFtuV504vfGh5l1E6MvK1m43Wi1QM0duB283w
         TqwQ==
X-Gm-Message-State: AO0yUKW15A8TXsjsCAx+N5t6vRfkIZZ5LVsQPcmPLEcWttx92aVp1Urk
        5lwIal9b0+vQOk+9ROKX+bZsCb36ksOi
X-Google-Smtp-Source: AK7set/9GAC28caZmQydbqalQDK26Zt8xTg53hi5Ypa/Bv48w9Y1qLEuLIHz5iY/6yq1c0y2Fxyz72FHxLL2
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6602:714:b0:72c:d79b:bd3d with SMTP id
 f20-20020a056602071400b0072cd79bbd3dmr1888748iox.49.1675704230413; Mon, 06
 Feb 2023 09:23:50 -0800 (PST)
Date:   Mon,  6 Feb 2023 17:23:36 +0000
In-Reply-To: <20230206172340.2639971-1-rananta@google.com>
Mime-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206172340.2639971-4-rananta@google.com>
Subject: [PATCH v2 3/7] KVM: arm64: Implement  __kvm_tlb_flush_range_vmid_ipa()
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define  __kvm_tlb_flush_range_vmid_ipa() (for VHE and nVHE)
to flush a range of stage-2 page-tables using IPA in one go.
If the system supports FEAT_TLBIRANGE, the following patches
would conviniently replace global TLBI such as vmalls12e1is
in the map, unmap, and dirty-logging paths with ripas2e1is
instead.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  3 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 12 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c      | 28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/tlb.c       | 24 ++++++++++++++++++++++++
 4 files changed, 67 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 995ff048e8851..80a8ea85e84f8 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_range_vmid_ipa,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
@@ -243,6 +244,8 @@ extern void __kvm_flush_vm_context(void);
 extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
+extern void __kvm_tlb_flush_range_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t start,
+						phys_addr_t end, int level, int tlb_level);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 728e01d4536b0..5787eee4c9fe4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -125,6 +125,17 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
 	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 }
 
+static void handle___kvm_tlb_flush_range_vmid_ipa(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
+	DECLARE_REG(phys_addr_t, end, host_ctxt, 3);
+	DECLARE_REG(int, level, host_ctxt, 4);
+	DECLARE_REG(int, tlb_level, host_ctxt, 5);
+
+	__kvm_tlb_flush_range_vmid_ipa(kern_hyp_va(mmu), start, end, level, tlb_level);
+}
+
 static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
@@ -315,6 +326,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
+	HANDLE_FUNC(__kvm_tlb_flush_range_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d296d617f5896..7398dd00445e7 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -109,6 +109,34 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_range_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t start,
+					phys_addr_t end, int level, int tlb_level)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	__kvm_tlb_flush_range(ipas2e1is, mmu, start, end, level, tlb_level);
+
+	/*
+	 * Range-based ipas2e1is flushes only Stage-2 entries, and since the
+	 * VA isn't available for Stage-1 entries, flush the entire stage-1.
+	 */
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
index 24cef9b87f9e9..e9c1d69f7ddf7 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -111,6 +111,30 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_range_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t start,
+					phys_addr_t end, int level, int tlb_level)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	__kvm_tlb_flush_range(ipas2e1is, mmu, start, end, level, tlb_level);
+
+	/*
+	 * Range-based ipas2e1is flushes only Stage-2 entries, and since the
+	 * VA isn't available for Stage-1 entries, flush the entire stage-1.
+	 */
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
2.39.1.519.gcb327c4b5f-goog

