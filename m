Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A446DAA7F
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 10:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbjDGI5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 04:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbjDGI5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 04:57:09 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE1EA5CB;
        Fri,  7 Apr 2023 01:57:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o11so39565357ple.1;
        Fri, 07 Apr 2023 01:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680857827; x=1683449827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gpAcJUBZnPRe6gVW7efqQAtGabyC/Y11dXostFs84j4=;
        b=gLnkbJy6vCxNcSx0/K8fZShwl5sL9ieZFfkqJrE4xPkeFw6MA+zxEbkEkVlfJtmIOk
         IofcB+gFPxc4fBacN8KQrLDCxWqA8uhUduggQ07Ar+zvnTKSxM2/b7l1ddEvM5Ldl4BH
         k8j49KONMc/sxCPWAPGP2za0R4HV4yaIO+/ELgCChCYBT4lgV9WBJok9wrHWt1oQCzGd
         cK/Z+zLE5Br4hsKGnz+Bh7Dc833/1llMX/wTBDka562sWC7TGB2hRMliI4Axx5TL+WZ6
         mbAg099iNBg2Sa5aq0oln9h540Y+jzT1GnH24ivEJaMOMv6GZnhcj6tM+eQwVp1A9N8X
         +SBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680857827; x=1683449827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gpAcJUBZnPRe6gVW7efqQAtGabyC/Y11dXostFs84j4=;
        b=0LlFJv0+4g0KIfHCHc9fVGuyzP+UBvcILcFeDClEOCfO2h83nKmFlpxXf4x1qTM5IA
         Cnz6eFpntr1NW+qWzYFv9AaA9s/c/8wBKTuAE9TZyCpiA7Lvgn4ydfIM42QcSsF81s9l
         6OpEKHpubKz0UyyQup5XKhEZriuE0oDdFDssu76GZvg8YRzEzlkE4xKbF1KyRO11G0Hi
         u/UXC9/Lt/DuN90GrdLK9Rc3LUemjGg/6sh1q4YpYqLCO5FnxLmZ8/Y3b8QRe9tbVQ+/
         wH5yHiMbcUYVIMVMEGNLBWrw99WDAEvLLOIiCH+KQBvhSDBWDoiJh1PHulv5CHKuQk3m
         +XLA==
X-Gm-Message-State: AAQBX9eAWlnyzilBebUB3VNl1kkMnEUO6/5seQdHy6PwPcNB6CDZc6bq
        jj8RF0toAxam2K2ETdrGKn0=
X-Google-Smtp-Source: AKy350be/ScJbmO+Mg+B6KUTaSAdUbcioZ7BsNYOR88ApxU9erwMf6iOUpf+/7vkW7V9nlQFUkvSzQ==
X-Received: by 2002:a05:6a20:4c9a:b0:cb:7958:7071 with SMTP id fq26-20020a056a204c9a00b000cb79587071mr2128294pzb.19.1680857826847;
        Fri, 07 Apr 2023 01:57:06 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u12-20020a62ed0c000000b0062e23e81b24sm2568860pfh.114.2023.04.07.01.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 01:57:05 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH V2] KVM: x86/pmu: Disable vPMU if EVENTSEL_GUESTONLY bit doesn't exist
Date:   Fri,  7 Apr 2023 16:56:46 +0800
Message-Id: <20230407085646.24809-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Unlike Intel's MSR atomic_switch mechanism, AMD supports guest pmu
basic counter feature by setting the GUESTONLY bit on the host, so the
presence or absence of this bit determines whether vPMU is emulatable
(e.g. in nested virtualization). Since on AMD, writing reserved bits of
EVENTSEL register does not bring #GP, KVM needs to update the global
enable_pmu value by checking the persistence of this GUESTONLY bit.

Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
V1:
https://lore.kernel.org/kvm/20230307113819.34089-1-likexu@tencent.com
V1 -> V2 Changelog:
- Preemption needs to be disabled to ensure a stable CPU; (Sean)
- KVM should be restoring the original value too; (Sean)
- Disable vPMU once guest_only mode is not supported; (Sean)
- Appreciate any better way to probe for GUESTONLY support;

 arch/x86/kvm/svm/svm.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7584eb85410b..1ab885596510 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4884,6 +4884,20 @@ static __init void svm_adjust_mmio_mask(void)
 	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
 }
 
+static __init bool pmu_has_guestonly_mode(void)
+{
+	u64 original, value;
+
+	preempt_disable();
+	rdmsrl(MSR_F15H_PERF_CTL0, original);
+	wrmsrl(MSR_F15H_PERF_CTL0, AMD64_EVENTSEL_GUESTONLY);
+	rdmsrl(MSR_F15H_PERF_CTL0, value);
+	wrmsrl(MSR_F15H_PERF_CTL0, original);
+	preempt_enable();
+
+	return value == AMD64_EVENTSEL_GUESTONLY;
+}
+
 static __init void svm_set_cpu_caps(void)
 {
 	kvm_set_cpu_caps();
@@ -4928,6 +4942,9 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
+	/* Probe for AMD64_EVENTSEL_GUESTONLY support */
+	enable_pmu &= pmu_has_guestonly_mode();
+
 	/* AMD PMU PERFCTR_CORE CPUID */
 	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
 		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);

base-commit: 649bccd7fac98225525c79cf4b1cecc4bafdfc54
-- 
2.40.0

