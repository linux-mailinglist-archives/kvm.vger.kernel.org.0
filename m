Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1326E72A94D
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 08:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjFJGQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jun 2023 02:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjFJGQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jun 2023 02:16:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261B93AB1
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 23:16:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bc5e2021f00so24328276.3
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 23:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686377783; x=1688969783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yRFpiF9EW1xpDdddok4DKuKkCXcjFgH6nNPKa16z1Tg=;
        b=v85qEb5h7erEV0vhQyB+Gi9zMu8mK1PwATuaa4UYvMQlHpiTl5aYYGPTGKVLzxNyJ1
         s0aXRiu7I6K8vz9Vcw2KIiG+VcvSfR3imgnH8gfmeqbt8d9Ubg9ut0tgfN4dct+DafI4
         FzY6T7hYX0d1i0q7DDMWnJsnTy9731J3qEexOmihzJVCvHq36GuKp8r8ai15VkdJRq1t
         VS0DwYsrPqtOqTaSAqdz1sl0fdHzpzFEEdMoy8sIXgcGeqim8rf5WEC5aMWTAepcp8dn
         wZQeFF4CG0zk7363WR2hAEhSrpXL8o0j5xLhPfmBsygnY0C9VjVNFpmS7djf9kuJVvBS
         +GAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686377783; x=1688969783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yRFpiF9EW1xpDdddok4DKuKkCXcjFgH6nNPKa16z1Tg=;
        b=E8QzyyiIQwa9dCp12ZVGuxBUdPw47e1XTJ9Kr6/9Lr4M9AUmRDRDhJ6uoYfOtPpSg3
         /K1Yx1ui4vCT3dJuMVRDAUbDVDtIVIMiSyH094O3lBBQPDVjrA2npndb68JQyk5sItMg
         8xZIMdSxhB8c4TGRNJVf+h7lF7WchuZhmZHiT0z+zbSM1Z/92w7fagk9LJNVXUB6xhJ7
         fB7wdBacTx7xCEWTGHy1GonAqq2/cejjPEXjMJ3l0tsRWj2sBP3ZLm7syjluEt+LIRlz
         OqipAgCQsHp/+t2cVVX32fSUDX+E/5GAc59B4Vd+lMZTjCyi9IoZtbBoyZPNueUD2DfU
         JvyA==
X-Gm-Message-State: AC+VfDxO5wi5bP+2FbzrJOT7i8PCS0jHtjPpigwINPIfWxE+OD96X9Gi
        WfEdxGon4SadznSrC6/KbOL34MUcdt0=
X-Google-Smtp-Source: ACHHUZ5PHGV4oelgCpab9bxHiQhiMBK4E/MkgJr0Ll1vuL3QAsfBaqeaprxSa0xFu5L+88zqObG0H4XDUv4=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:1085:b0:bac:f582:ef18 with SMTP id
 v5-20020a056902108500b00bacf582ef18mr1834265ybu.5.1686377783371; Fri, 09 Jun
 2023 23:16:23 -0700 (PDT)
Date:   Fri,  9 Jun 2023 23:15:20 -0700
In-Reply-To: <20230610061520.3026530-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230610061520.3026530-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230610061520.3026530-3-reijiw@google.com>
Subject: [PATCH 2/2] KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer systems
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

Disallow userspace from configuring vPMU for guests on systems
where the PMUVer is not uniform across all PEs.
KVM has not been advertising PMUv3 to the guests with vPMU on
such systems anyway, and such systems would be extremely
uncommon and unlikely to even use KVM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/arm.c      |  1 +
 arch/arm64/kvm/pmu-emul.c |  3 ---
 include/kvm/arm_pmu.h     | 10 ++++++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c..21901fbd6e4d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1960,6 +1960,7 @@ static int __init init_subsystems(void)
 		goto out;
 
 	kvm_register_perf_callbacks(NULL);
+	kvm_arm_set_support_pmu_v3();
 
 out:
 	if (err)
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 5d2903f52a5f..45b84cf22026 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -684,9 +684,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	entry->arm_pmu = pmu;
 	list_add_tail(&entry->entry, &arm_pmus);
 
-	if (list_is_singular(&arm_pmus))
-		static_branch_enable(&kvm_arm_pmu_available);
-
 out_unlock:
 	mutex_unlock(&arm_pmus_lock);
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index eef17de966da..af1fe2b53fbb 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -105,6 +105,14 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
+static inline void kvm_arm_set_support_pmu_v3(void)
+{
+	u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
+
+	if (pmu_v3_is_supported(pmuver))
+		static_branch_enable(&kvm_arm_pmu_available);
+}
+
 #else
 struct kvm_pmu {
 };
@@ -114,6 +122,8 @@ static inline bool kvm_arm_support_pmu_v3(void)
 	return false;
 }
 
+static inline void kvm_arm_set_support_pmu_v3(void) {};
+
 #define kvm_arm_pmu_irq_initialized(v)	(false)
 static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 					    u64 select_idx)
-- 
2.41.0.162.gfafddb0af9-goog

