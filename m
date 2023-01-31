Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B626827C2
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 09:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjAaI4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 03:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjAaIzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 03:55:48 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453A84B4B8;
        Tue, 31 Jan 2023 00:50:57 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b5so7126520plz.5;
        Tue, 31 Jan 2023 00:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HlkVox6I5FUnYmeSbSAQbPKPPzCS1DM4/BxJexDwink=;
        b=Oq1dXhl4AUSq8SXfZljEFxeZ8ojBbgd4u0vv7mGVOxjeDwJMKIrj20TgTJo8kv+Z4f
         iNsJ6hwcsEM5hhzKAiB6obCDQQJzp809Ew9v1jFPi3PJ4mLttadxPE74sdCNpIwzTIGx
         uhY+wdQbildYvj0qD76Vn9EY6yoV5nj9VOK65PSADlwZ80ouO3XR31NhNLwp0wcA+kI0
         13McnwS/DW09DS3eegJBnZFack5BkaBktzWt4MuMLU5Z/IjCY/74vMghBEAVSqmvbk3q
         XXHasbBZveqS8jyzGusZFmiEBFqAEfqlzNRrgzQc4I4RVqAdftplt1UWPXl9lwSJ2Mvz
         GgHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HlkVox6I5FUnYmeSbSAQbPKPPzCS1DM4/BxJexDwink=;
        b=xes/bvxmPhx3hflGLVheYZx47L4PtuXEwB2Nx3kDhtx9Cy5ugPvSwGxneJJ2c7ch9E
         XdU9pMRiqj/OLrEUcVphDe3eoidqXqpjMqKUa51VMI+5yhwIaXn+Rg3V5fd4W8k7IquU
         nSG+eiU3Tu5tUi2SNvgRFFwlRB5TpYZ0//WdAQ7ZxmJt39BLKHZ1zQ1Wygz6xIgloY0r
         YBA5zwHn8ZV1MievaLWUbOOr0BhhbPLetQaUjWS1Zn46HLGEcMLRf3sGhM7X9IkyO3MM
         2+sblETDra+ZYckeo2qxGd8+Cg+H+ZeQESPXEOweTSu6KUjUExyshX6htCsqtqc3RQPD
         J4Fg==
X-Gm-Message-State: AO0yUKU2remG1hfMlOh27TxpdEFeMT1uq5wQ+TlWlZbkIu1AVubBUp25
        42KqKViMSLXGSumZRqhDFWU=
X-Google-Smtp-Source: AK7set/qRO5xcYdV+5kV7GzLg/C0kCaV8drqDWjezWS5nG0YJiIatE2AszyuXEyg+3sevQWJupMa+Q==
X-Received: by 2002:a17:902:c70a:b0:196:3056:38f4 with SMTP id p10-20020a170902c70a00b00196305638f4mr17717245plp.50.1675155050883;
        Tue, 31 Jan 2023 00:50:50 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id o17-20020a170902d4d100b00196077ba463sm9196140plg.123.2023.01.31.00.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 00:50:50 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianfeng Gao <jianfeng.gao@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v2] KVM: x86/pmu: Disable all vPMU features support on Intel hybrid CPUs
Date:   Tue, 31 Jan 2023 16:50:31 +0800
Message-Id: <20230131085031.88939-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
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

Disable KVM support for virtualizing PMUs on hosts with hybrid PMUs until
KVM gains a sane way to enumeration the hybrid vPMU to userspace and/or
gains a mechanism to let userspace opt-in to the dangers of exposing a
hybrid vPMU to KVM guests.

Virtualizing a hybrid PMU, or at least part of a hybrid PMU, is possible,
but it requires userspace to pin vCPUs to pCPUs to prevent migrating a
vCPU between a big core and a little core, requires the VMM to accurately
enumerate the topology to the guest (if exposing a hybrid CPU to the
guest), and also requires the VMM to accurately enumerate the vPMU
capabilities to the guest.

The last point is especially problematic, as KVM doesn't control which
pCPU it runs on when enumerating KVM's vPMU capabilities to userspace.
For now, simply disable vPMU support on hybrid CPUs to avoid inducing
seemingly random #GPs in guests.

Reported-by: Jianfeng Gao <jianfeng.gao@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
v1: https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com/
 arch/x86/kvm/pmu.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 79988dafb15b..6a3995657e1e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -166,9 +166,11 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 
 	 /*
 	  * For Intel, only support guest architectural pmu
-	  * on a host with architectural pmu.
+	  * on a non-hybrid host with architectural pmu.
 	  */
-	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
+	if (!kvm_pmu_cap.num_counters_gp ||
+	    (is_intel && (!kvm_pmu_cap.version ||
+			  boot_cpu_has(X86_FEATURE_HYBRID_CPU))))
 		enable_pmu = false;
 
 	if (!enable_pmu) {
-- 
2.39.1

