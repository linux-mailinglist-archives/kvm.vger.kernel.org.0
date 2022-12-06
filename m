Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47ED3643EA2
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiLFIa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbiLFIaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:30:15 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DF91A83C;
        Tue,  6 Dec 2022 00:30:10 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso17389135pjt.0;
        Tue, 06 Dec 2022 00:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VUAXslo7pyeEryWuDg5bgr4Jvxx+orS9YH75NmcZQEs=;
        b=d9gty1PChBUuJEj+eBI3FfgvQkY/AEPxGhAqOzRelh9DWWpeiNyKOQoyMrjNTQbENg
         D7IIni1tBrVAlJv8gav6jEZYSV40Rfz23lPb2elRxh9LY9TyCBzrWyTJDUNJRNA6HFy+
         4+dGwgLZkqQAtDoiWXHo5axbfcfgSmhyDR6/8gDYR40D+PAZ3R3YnFES5YKuPtKmdfY9
         bxPW3RRSKsP1DffOEf318vatdHO//qk+38qyn1XdhmeO9cYdZtBSxkFdXIPt3SlPQg8k
         zGnovL94zB15A4Ic+iNIKp7YhewgE3MG6TJFFW9/7tbrts3J59jVr0QSsnWwVXg1pf0p
         n58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VUAXslo7pyeEryWuDg5bgr4Jvxx+orS9YH75NmcZQEs=;
        b=s4eFB4lgAcVU1oZY47vWQCIMLxsGNWm45WzzwxD1EKXgKorQLnK1ss1Wdn2NkDlrsG
         ZwtgxfUnolz9O3zYyILDIYm2XGMBbO0rdgVFQEfZm7WfNKpQk3dSSxGzpvZQzdGWxqOL
         0lSjxjo37TJp36duyEXc6dm4hIWfnMKyMdiTfcPuYdzhsCPqUCn2KLpSdwXoFVhe3OMy
         yWYfio4xvuMcYjXHPDFZG9cjKuwrPtFOfyy9pJWM2Q1uSZzvYkXVeiiE4nCCtuatvcIn
         rklzTj0yNUkAY2vUpVXH05k4HKC5JCFUlEJbmSP/kEieIpG9ES3OZY9K4vETfJkp/c5b
         TdPQ==
X-Gm-Message-State: ANoB5pnGWz65pOy1YCRQ8YLLSeY9BqrvUWrAA7kHN8ZErMBSsIBZS2yV
        q2Lm+E0SANe+/y4ujWxT4oE=
X-Google-Smtp-Source: AA0mqf4pU1vWZ4AaaCtpGWH7abBR/qX0KLP2JMdjCYlqSZcD1kjAJNQ0KjjJsjihSPENwTlQRUqmBg==
X-Received: by 2002:a17:90a:6bc7:b0:219:ed2d:5595 with SMTP id w65-20020a17090a6bc700b00219ed2d5595mr5055021pjj.238.1670315410287;
        Tue, 06 Dec 2022 00:30:10 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h15-20020a056a00000f00b00574d38f4d37sm11203330pfk.45.2022.12.06.00.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 00:30:10 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH RESEND v3 2/3] KVM: x86/pmu: Add PRIR++ and PDist support for SPR and later models
Date:   Tue,  6 Dec 2022 16:29:43 +0800
Message-Id: <20221206082944.59837-3-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206082944.59837-1-likexu@tencent.com>
References: <20221206082944.59837-1-likexu@tencent.com>
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
index 684393c22105..8c8bfd078a3f 100644
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

