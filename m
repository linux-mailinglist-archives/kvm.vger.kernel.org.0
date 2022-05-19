Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E2B52D4B8
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237683AbiESNq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239057AbiESNpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265E75AECE
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:44:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6E74617A3
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB594C34100;
        Thu, 19 May 2022 13:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967880;
        bh=sMh0UCgIWjXVfrdGOf6s/H5Omqvu6QIYMqHdrALaiFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fChHAdSeRCu5nnQLCIerdlLwME4HuSOoTq765F+p2PmiqZDNBy1OVBaPUy1Z+HP/5
         Qr1oV8QjMOdjFyK0QNZ5b+s6lQhG92ykY+hY/pqHuopk2MFzqF41khrHQy/p/Ge8cz
         vJ1Cpm4Ro9E4tqvDsz+QEcI6ejpFG36wYD/mc1nx7d1v4zxcLiTyKdWgjXgcoDMs4x
         i+EkttApQGaALL7WwshRplmOs/bHG0ui/pZLNqG0PpfG0DKO1Q3fpSdp00+mzz0JO1
         TByAThQbuHkNkXxIXi4JwfqrSNOhO7eTBWHimmB6/ZmlyAKq6zxN2SzCqDS94EJyKf
         Pu3EqqpciPeHQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 34/89] KVM: arm64: Don't access kvm_arm_hyp_percpu_base at EL1
Date:   Thu, 19 May 2022 14:41:09 +0100
Message-Id: <20220519134204.5379-35-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

The host KVM PMU code can currently index kvm_arm_hyp_percpu_base[]
through this_cpu_ptr_hyp_sym(), but will not actually dereference that
pointer when protected KVM is enabled. In preparation for making
kvm_arm_hyp_percpu_base[] unaccessible to the host, let's make sure the
indexing in hyp per-cpu pages is also done after the static key check to
avoid spurious accesses to EL2-private data from EL1.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/pmu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 03a6c1f4a09a..a8878fd8b696 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -31,9 +31,13 @@ static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
  */
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 {
-	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
+	struct kvm_host_data *ctx;
 
-	if (!kvm_arm_support_pmu_v3() || !ctx || !kvm_pmu_switch_needed(attr))
+	if (!kvm_arm_support_pmu_v3())
+		return;
+
+	ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
+	if (!ctx || !kvm_pmu_switch_needed(attr))
 		return;
 
 	if (!attr->exclude_host)
@@ -47,9 +51,13 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
  */
 void kvm_clr_pmu_events(u32 clr)
 {
-	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
+	struct kvm_host_data *ctx;
+
+	if (!kvm_arm_support_pmu_v3())
+		return;
 
-	if (!kvm_arm_support_pmu_v3() || !ctx)
+	ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
+	if (!ctx)
 		return;
 
 	ctx->pmu_events.events_host &= ~clr;
-- 
2.36.1.124.g0e6072fb45-goog

