Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F2C5E5A98
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 07:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiIVFT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 01:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiIVFTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 01:19:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396B74E619;
        Wed, 21 Sep 2022 22:19:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t3so7756449ply.2;
        Wed, 21 Sep 2022 22:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=lwvggzHyTS5axyKbN+bmLBr4VnTTCkXswCqpGXL48kI=;
        b=ZlAM/FZymHarMeFJIxTjntGYBGmKN0Bgk4vK+P1f68ClXWIA7k2xtGgYUeXdNi36zi
         jxYhGLgODBpa2a15lNOFR72oJfddF7Jb6vGgVas3CnDNH2KrFiUTkH33hrmFkinvmPmc
         a0uVteJVwSqrsRCPzDnwHliPo6+GhhfiAbSUI3RIWOkct7F48g2U1jS961+QHhYpnkwD
         bJ3yin5tf5NWauBqgDHVdfAEuVxe5p6+jpOTa+HBoVVAfNkgYtM/vcTlxgPEeRkeXkyN
         7HA3RIudY6VUU2VusvVZlJBbLXrKjab1OdByV7OUMGCWKBK1dErEyVTK7zNRhXcRInas
         O5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=lwvggzHyTS5axyKbN+bmLBr4VnTTCkXswCqpGXL48kI=;
        b=oTxDftTVWjzAl+Ejv0elQA48AITpOyMC2Su5z6l/c57nL0kNhDJkDRcSSO+TNfECiv
         Vvh5mt/e4Gthl9RxrLWxpEk9kRZlaHp0HF7OyDegNVO5kq/HxvFTH7liB8VDVC36YjEY
         OXUl1a/Z1z3I7OCfYtNugYWBQqqx9+8bZNr3t+O5FrI5bqn0cWjFVdYfsllwY5pNV9l3
         2uBY6pKFAA8FgGgLFoNXbnoUfdpFhXQGPEQ0wMGI/KQHyuZourmM+lgKbIV2QCw2zkR5
         AAVHkOMZcstf6ievQyRy2F24f1oxvPtsoHq1Ui4i8jK30dftDAow1UCvq8uy5rUTp0Kl
         YYTw==
X-Gm-Message-State: ACrzQf1SJJn+NlOkW+85coOlP1fwfAC3x0eEsjjdotx0VaYUkdfSdzSS
        bIQE9SJ3vVdyh50IOGt8PNU=
X-Google-Smtp-Source: AMsMyM6g+5gE+c+OCuSiTwzzgHJXkzOC6n3qVCt9cbcT8NRvSXZ4LRKfSbyWxRktoZxvAcC0NSvzHg==
X-Received: by 2002:a17:902:a416:b0:178:a030:5f94 with SMTP id p22-20020a170902a41600b00178a0305f94mr1585722plq.162.1663823992741;
        Wed, 21 Sep 2022 22:19:52 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b7-20020a170903228700b001780a528540sm3045067plh.93.2022.09.21.22.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 22:19:52 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: x86/pmu: Add PEBS support for SPR and future non-hybird models
Date:   Thu, 22 Sep 2022 13:19:29 +0800
Message-Id: <20220922051929.89484-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220922051929.89484-1-likexu@tencent.com>
References: <20220922051929.89484-1-likexu@tencent.com>
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

Virtualization support for SPR PEBS has officially available in the
Intel SDM (June 2022) and has been validated on late stepping machines:

Compared to Ice Lake Server, the PDIR counter available (Fixed 0) on SPR
is unchanged, but the capability is enhanced to Instruction-Accurate PDIR
(PDIR++), where PEBS is taken on the next instruction after the one that
caused the overflow. Also, it introduces a new Precise Distribution (PDist)
facility that eliminates the skid when a precise event is programmed
on general programmable counter 0.

For guest usage, KVM will require the max precise level in both cases
mentioned above (other conditions may apply later), requesting the
correct hardware counter (PRIR++ or PDist) from host perf as usual.

Signed-off-by: Like Xu <likexu@tencent.com>
---
Previous:
https://lore.kernel.org/kvm/20220921064827.936-1-likexu@tencent.com/

V1 -> V2 Changelog:
- move the check into a function; (Kan)

 arch/x86/kvm/pmu.c              | 25 ++++++++++++++++++++++---
 arch/x86/kvm/vmx/capabilities.h |  4 +++-
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 02f9e4f245bd..5e9b0b3ea42d 100644
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
 
@@ -140,6 +149,16 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 	__kvm_perf_overflow(pmc, true);
 }
 
+static bool need_max_precise(struct kvm_pmc *pmc)
+{
+	if (pmc->idx == 0 && x86_match_cpu(vmx_pebs_pdist_cpu))
+		return true;
+	if (pmc->idx == 32 && x86_match_cpu(vmx_pebs_pdir_cpu))
+		return true;
+
+	return false;
+}
+
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  u64 config, bool exclude_user,
 				  bool exclude_kernel, bool intr)
@@ -181,11 +200,11 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		 * the accuracy of the PEBS profiling result, because the "event IP"
 		 * in the PEBS record is calibrated on the guest side.
 		 *
-		 * On Icelake everything is fine. Other hardware (GLC+, TNT+) that
+		 * On Icelake everything is fine. Other hardware (TNT+) that
 		 * could possibly care here is unsupported and needs changes.
 		 */
 		attr.precise_ip = 1;
-		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
+		if (need_max_precise(pmc))
 			attr.precise_ip = 3;
 	}
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c5e5dfef69c7..4dc4bbe18821 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -398,7 +398,9 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 
 static inline bool vmx_pebs_supported(void)
 {
-	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
+	return boot_cpu_has(X86_FEATURE_PEBS) &&
+		!boot_cpu_has(X86_FEATURE_HYBRID_CPU) &&
+		kvm_pmu_cap.pebs_ept;
 }
 
 static inline u64 vmx_get_perf_capabilities(void)
-- 
2.37.3

