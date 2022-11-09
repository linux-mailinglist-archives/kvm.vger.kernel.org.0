Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D200B622571
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 09:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiKII3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 03:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiKII2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 03:28:40 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007802673;
        Wed,  9 Nov 2022 00:28:24 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 6so7475274pgm.6;
        Wed, 09 Nov 2022 00:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gfUfiLMSDty5pKmQVoXHf+IXuNDCfniw4Yx5uF+cedc=;
        b=PnI7rvNSYoxT0RIx9PjwUuB4E8+I6ctdIzfJW5WPVkYFdo6fNDbFR5+nkOhGiD7tBC
         paRtJh+4d2zHmWDnSy4Y/XW2fcRvniC+O8yMkHgBHztLiIMpK5I73nBppDoy6LhhEfJd
         eMJBqwFEmV7OnrE5H9OFycKhGWh7qmVjtnJuA7uAfS+gQTLSjaeRkkq3RCmR2w6ovpWa
         M4MmVKtUuyl9Tubbd82EaYTkkxk1Fa2dJ1FHt2W3QQA7PNjHIcHBTf0mFOOCO3Duga2x
         EDGn6XabJSKE00eTmRCBNurRUy8frYI26f1/9ANQjFvp7ffzsenCgI5MysYXZ3hqSvGs
         7Lbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gfUfiLMSDty5pKmQVoXHf+IXuNDCfniw4Yx5uF+cedc=;
        b=yvZ6iAsymmEYPcrzvxdF1rfflRqDDkMdP+KxUq5VN8D7LkjU/l9ei8fTm579ATxeDN
         Lg80+eys4gfEq3Z7s58BmGEXhumPmNS8h8ONY83NBuuiP7rgFSOtN1KnNtTQMIQdZk6B
         fpMs3IkTmLQbvZJXchThnKv+kVX8JOQWtQsrYgAn5RSq1niNUXBREETu2HBXaLytiUS+
         EvAA9faQFm11uGthDXIx1KlMuAgEKQjBXy3fqQMsMn1W0D9B5NTC3ivffemYjVBWw6lf
         Uiqh//c2pwQipaj71MqirqJB9ODVTYXnXcjD4cttKsomfa6K4RmveVQPLEFrHKY3rSUH
         55BQ==
X-Gm-Message-State: ACrzQf26yvuIgazzz/URlnSv9kJo8zZhAYQnaVrLicIsx3hKp7tiUF9k
        DnmkmXKcMaA52gZrRnLU2cQ=
X-Google-Smtp-Source: AMsMyM7nhrQmBZGVpIWYdjyBZ00IVGqrFU186h5QWpWJo3k8nZxDn0GdZCogTXkBwAGEX8l5ienUdw==
X-Received: by 2002:a63:1145:0:b0:46a:e00c:579c with SMTP id 5-20020a631145000000b0046ae00c579cmr52119177pgr.279.1667982504412;
        Wed, 09 Nov 2022 00:28:24 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b14-20020a63d30e000000b00470537b9b0asm6587700pgg.51.2022.11.09.00.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 00:28:24 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v3 2/3] KVM: x86/pmu: Add PRIR++ and PDist support for SPR and later models
Date:   Wed,  9 Nov 2022 16:28:01 +0800
Message-Id: <20221109082802.27543-3-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109082802.27543-1-likexu@tencent.com>
References: <20221109082802.27543-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The pebs capability on the SPR is basically the same as Ice Lake Server
with the exception of two special facilities that have been enhanced and
require special handling.

Upon triggering a PEBS assist, there will be a finite delay between the
time the counter overflows and when the microcode starts to carry out
its data collection obligations. Even if the delay is constant in core
clock space, it invariably manifest as variable "skids" in instruction
address space.

On the Ice Lake Server, the Precise Distribution of Instructions Retire
(PDIR) facility mitigates the "skid" problem by providing an early
indication of when the counter is about to overflow. On SPR, the PDIR
counter available (Fixed 0) is unchanged, but the capability is enhanced
to Instruction-Accurate PDIR (PDIR++), where PEBS is taken on the
next instruction after the one that caused the overflow.

SPR also introduces a new Precise Distribution (PDist) facility only on
general programmable counter 0. Per Intel SDM, PDist eliminates any
skid or shadowing effects from PEBS. With PDist, the PEBS record will
be generated precisely upon completion of the instruction or operation
that causes the counter to overflow (there is no "wait for next occurrence"
by default).

In terms of KVM handling, when guest accesses those special counters,
the KVM needs to request the same index counters via the perf_event
kernel subsystem to ensure that the guest uses the correct pebs hardware
counter (PRIR++ or PDist). This is mainly achieved by adjusting the
event precise level to the maximum, where the semantics of this magic
number is mainly defined by the internal software context of perf_event
and it's also backwards compatible as part of the user space interface.

Opportunistically, refine confusing comments on TNT+, as the only
ones that currently support pebs_ept are Ice Lake server and SPR (GLC+).

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 935c9d80ab50..3df48fc34e97 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -28,9 +28,18 @@
 struct x86_pmu_capability __read_mostly kvm_pmu_cap;
 EXPORT_SYMBOL_GPL(kvm_pmu_cap);
 
-static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
+/* Precise Distribution of Instructions Retired (PDIR) */
+static const struct x86_cpu_id vmx_pebs_pdir_cpu[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	/* Instruction-Accurate PDIR (PDIR++) */
+	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	{}
+};
+
+/* Precise Distribution (PDist) */
+static const struct x86_cpu_id vmx_pebs_pdist_cpu[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
 	{}
 };
 
@@ -155,6 +164,28 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
 
+static u64 pmc_get_pebs_precise_level(struct kvm_pmc *pmc)
+{
+	/*
+	 * For some model specific pebs counters with special capabilities
+	 * (PDIR, PDIR++, PDIST), KVM needs to raise the event precise
+	 * level to the maximum value (currently 3, backwards compatible)
+	 * so that the perf subsystem would assign specific hardware counter
+	 * with that capability for vPMC.
+	 */
+	if ((pmc->idx == 0 && x86_match_cpu(vmx_pebs_pdist_cpu)) ||
+	    (pmc->idx == 32 && x86_match_cpu(vmx_pebs_pdir_cpu)))
+		return 3;
+
+	/*
+	 * The non-zero precision level of guest event makes the ordinary
+	 * guest event becomes a guest PEBS event and triggers the host
+	 * PEBS PMI handler to determine whether the PEBS overflow PMI
+	 * comes from the host counters or the guest.
+	 */
+	return 1;
+}
+
 static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 				 bool exclude_user, bool exclude_kernel,
 				 bool intr)
@@ -186,22 +217,12 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 	}
 	if (pebs) {
 		/*
-		 * The non-zero precision level of guest event makes the ordinary
-		 * guest event becomes a guest PEBS event and triggers the host
-		 * PEBS PMI handler to determine whether the PEBS overflow PMI
-		 * comes from the host counters or the guest.
-		 *
 		 * For most PEBS hardware events, the difference in the software
 		 * precision levels of guest and host PEBS events will not affect
 		 * the accuracy of the PEBS profiling result, because the "event IP"
 		 * in the PEBS record is calibrated on the guest side.
-		 *
-		 * On Icelake everything is fine. Other hardware (GLC+, TNT+) that
-		 * could possibly care here is unsupported and needs changes.
 		 */
-		attr.precise_ip = 1;
-		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
-			attr.precise_ip = 3;
+		attr.precise_ip = pmc_get_pebs_precise_level(pmc);
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
-- 
2.38.1

