Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6107AC074
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjIWK1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjIWK1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:27:12 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15A0CC2
        for <kvm@vger.kernel.org>; Sat, 23 Sep 2023 03:20:38 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-502e7d66c1eso5583114e87.1
        for <kvm@vger.kernel.org>; Sat, 23 Sep 2023 03:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philjordan-eu.20230601.gappssmtp.com; s=20230601; t=1695464437; x=1696069237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=beqPlsrep7tGPBGi9Y6AF8G8DeZpnuf0Z6TGNso5/5E=;
        b=yHKmSziefvYU9p+Q9lT0VfE8LBLKCo69WsReKD0MCteT3qHZOiqicDHprvYik+72aA
         cgR9cB6bOrAUMmcKVCRjPR9sKGQttcnWPZmbxQs0iR5kIcmXULg6bLcxxLrvzkQQ7n8s
         iMLoDTEKVGS43ujXKo7AcxxM1cTuwmVsdG6/CLNYQ0XySFcQP9QkjicoLvLJcpaWxzcz
         VPaQP+43G8/YMk+fCCszK/PHqcFC9tmpiAarR7qLnOvVuOqrs1M/mMpiWRGh92G46YRn
         KHkLRNdfKHmUS1yxvSsFka0bVu1CMuE8UXVVLsP+kt85awWaT/DOg4esTRJnE+Iv2wA9
         aVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695464437; x=1696069237;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=beqPlsrep7tGPBGi9Y6AF8G8DeZpnuf0Z6TGNso5/5E=;
        b=ltDgOsqN1CSoi+26fT6hhQ2ATB6H/evYLchToC3LF2kvGATwhGeVAu2dmLOxxmwCtS
         Om4l06+0d1Xp1UVr8USds2GAWy0Q6Q2/H4OQ7jETw9H1zJyrcNxY+LUjtNdK0d/aEBkK
         oHtP2JJfomZy3Da+LtYjckbqLDBxGGW950HcgFZT6s96Z8OnTBq8mTM1hM+QWdT3fbAG
         mQVjIjb3TsWz4Ao3DvbDVdmGHtXA6i4hQWDAtByvxWfD8zPiZ4CGJv6Z0mMAf4Zlrdai
         Gk8BC3vUv+TLoms+VCHKbkwdGjebKpC0irAaluX5MCfiJ0MX5a3OYDVR8+53QOHPTA74
         u23w==
X-Gm-Message-State: AOJu0YzXxnBpgX+VH7RsR7gf9oA4jkuh+AuRHLAFbqgDb6NUdihXrRCs
        OKJNVy2HYKA4jJUUIytNGAKZmBKNZJ75pjR1qvc=
X-Google-Smtp-Source: AGHT+IEY5eQrLes5cwu48PovxAT7BJkS+xd3OcfLrqC1y6EBaKadlTUSDy6OZjEIgdSgCiZ8xwNBEw==
X-Received: by 2002:a05:6512:3454:b0:4fe:711:2931 with SMTP id j20-20020a056512345400b004fe07112931mr1374392lfr.22.1695464436597;
        Sat, 23 Sep 2023 03:20:36 -0700 (PDT)
Received: from localhost.localdomain (89-104-8-249.customer.bnet.at. [89.104.8.249])
        by smtp.gmail.com with ESMTPSA id v22-20020a056402185600b0052a3aa50d72sm3223833edy.40.2023.09.23.03.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Sep 2023 03:20:35 -0700 (PDT)
From:   Phil Dennis-Jordan <phil@philjordan.eu>
To:     kvm@vger.kernel.org
Cc:     lists@philjordan.eu, Phil Dennis-Jordan <phil@philjordan.eu>
Subject: [kvm-unit-tests PATCH] x86/apic: Gates test_pv_ipi on KVM cpuid, not test device
Date:   Sat, 23 Sep 2023 12:20:19 +0200
Message-Id: <20230923102019.29444-1-phil@philjordan.eu>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SPF_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This changes the test for the KVM IPI hypercall API to be skipped if the
relevant cpuid feature bit is not set or if the KVM cpuid leaf is
missing, rather than the presence of the test device. The latter is an
unreliable inference on non-KVM platforms.

It also adds a skip report when these tests are skipped.

Signed-off-by: Phil Dennis-Jordan <phil@philjordan.eu>
---
 lib/x86/processor.h | 19 +++++++++++++++++++
 x86/apic.c          |  9 ++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 44f4fd1e..9a4c0d26 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -284,6 +284,13 @@ static inline bool is_intel(void)
 #define X86_FEATURE_VNMI		(CPUID(0x8000000A, 0, EDX, 25))
 #define	X86_FEATURE_AMD_PMU_V2		(CPUID(0x80000022, 0, EAX, 0))
 
+/*
+ * Hypervisor specific leaves (KVM, ...)
+ * See:
+ * https://kernel.org/doc/html/latest/virt/kvm/x86/cpuid.html
+ */
+#define	X86_KVM_FEATURE_PV_SEND_IPI  (CPUID(0x40000001, 0, EAX, 11))
+
 static inline bool this_cpu_has(u64 feature)
 {
 	u32 input_eax = feature >> 32;
@@ -299,6 +306,18 @@ static inline bool this_cpu_has(u64 feature)
 	return ((*(tmp + (output_reg % 32))) & (1 << bit));
 }
 
+static inline bool kvm_feature_flags_supported(void)
+{
+	struct cpuid c;
+
+	c = cpuid_indexed(0x40000000, 0);
+	return
+		c.b == 0x4b4d564b
+		&& c.c == 0x564b4d56
+		&& c.d == 0x4d
+		&& (c.a >= 0x40000001 || c.a == 0);
+}
+
 struct far_pointer32 {
 	u32 offset;
 	u16 selector;
diff --git a/x86/apic.c b/x86/apic.c
index dd7e7834..525e08fd 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -30,6 +30,11 @@ static bool is_xapic_enabled(void)
 	return (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN;
 }
 
+static bool is_kvm_ipi_hypercall_supported(void)
+{
+	return kvm_feature_flags_supported() && this_cpu_has(X86_KVM_FEATURE_PV_SEND_IPI);
+}
+
 static void test_lapic_existence(void)
 {
 	u8 version;
@@ -658,8 +663,10 @@ static void test_pv_ipi(void)
 	int ret;
 	unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 = 0x0;
 
-	if (!test_device_enabled())
+	if (!is_kvm_ipi_hypercall_supported()) {
+		report_skip("PV IPIs testing (No KVM IPI hypercall flag in cpuid)");
 		return;
+	}
 
 	asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 	report(!ret, "PV IPIs testing");
-- 
2.36.1

