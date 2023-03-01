Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA486A675F
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 06:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjCAFeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 00:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjCAFeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 00:34:44 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CE418169
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:43 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536e8d6d9ceso260781647b3.12
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677648883;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cm42io0xC+Ut0GU3E5WLWJMzeEm/fUz5RzaC8FAGr+s=;
        b=BDIcDGL0w/tILTFhzbpRcsq+EcguU0SculKGfTPdUSUMOJ9fwhLerg9GazlWH35VYH
         k18amV/15o5QJuWDI9rcmRIKxiJ0/gNl9Q/+EtgQmtp+YzA4L2ETHcz2NQbvMqcSsVx9
         VFGtvWxyb8w2GHnFk06lZjwUxsn0MOzTFuRk34+ivJeWfTeRcUzwhdbCsDACI9cqznOJ
         HaYXDkCTJQW0qurVP7JgxugLe/eJ20dqB1VSluVIWDVrLUfLsGJNI5vDcxiz1mW+3gTs
         VYXZPDw+FsX/T/GJMybyONfSCozVSF+Sa6wkIV6OKN2Z/5ktJzvvwtWaaU7xONYOEF0W
         xWjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677648883;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cm42io0xC+Ut0GU3E5WLWJMzeEm/fUz5RzaC8FAGr+s=;
        b=XBTOkG1lSpqqciBvbIaY0tAUuZNaSsrnSoarvCmQHRSuw+u0QL4UK8cHZ3hHnxxAdP
         PRFw6L810mhr11I/XYtHbtm4xuqHVqWV7wGjXby6mSlMZDR2kvus7NSQjPAHNvnENK2n
         8I/5xIjr3VSHD19NQyHIxYdnRN+udLC1x42FbvKBX329rVlVbzuqCUDucIJa5x9a2Zlz
         9QiTozQY34XBwZFDYCwkp4jwTHicWxYZL6ZGq+ShbvpqqYj6D7yhcnEBbJhS3vX6u8jh
         SQKxGSN2/kmO2MobhfuixHE2Z3wQXsLPfiU5vKJAHJmHbKi5EjaCdEbcHhFNcSMJrsPw
         Gbgg==
X-Gm-Message-State: AO0yUKWR0DRtVI8ABEo1Z2t0JTs5VHVNxUCSiAV8fpf1/vAWKoSS6SoS
        Wl8K+/jqOEUsvPmaLs4LcEMzh65R2mEZK6mAXUgZ/ZsANsTZ5wHj+kxpJShvtumD9B8h4Vxeyh3
        bcp6E+X94avnT2NdV5P5EnDX0dVgRbCGjj/8mjiUrwp3TCDihEMFl4WoNfr1LPvlA064O
X-Google-Smtp-Source: AK7set9tsImpPjvy05AEY+GiJz7S120Mj8lWkyCUl+BsGHzMK3snRDEeUblYmA6nhroXrPFrGeB9DrGL5Dr8R03q
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a81:af08:0:b0:536:5557:33a8 with SMTP
 id n8-20020a81af08000000b00536555733a8mr3220700ywh.9.1677648882819; Tue, 28
 Feb 2023 21:34:42 -0800 (PST)
Date:   Wed,  1 Mar 2023 05:34:19 +0000
In-Reply-To: <20230301053425.3880773-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230301053425.3880773-3-aaronlewis@google.com>
Subject: [PATCH 2/8] KVM: selftests: Add XFEATURE masks to common code
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Add XFEATURE masks to processor.h to make them more broadly available
in KVM selftests.

They were taken from fpu/types.h, which included a difference in
spacing between the ones in amx_test from XTILECFG and XTILEDATA, to
XTILE_CFG and XTILE_DATA.  This has been reflected in amx_test.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 17 ++++++++++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 22 +++++++------------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 62a5c3953deb..8e201575ef73 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -48,6 +48,23 @@ extern bool host_cpu_is_amd;
 #define X86_CR4_SMAP		(1ul << 21)
 #define X86_CR4_PKE		(1ul << 22)
 
+#define XFEATURE_MASK_FP		BIT_ULL(0)
+#define XFEATURE_MASK_SSE		BIT_ULL(1)
+#define XFEATURE_MASK_YMM		BIT_ULL(2)
+#define XFEATURE_MASK_BNDREGS		BIT_ULL(3)
+#define XFEATURE_MASK_BNDCSR		BIT_ULL(4)
+#define XFEATURE_MASK_OPMASK		BIT_ULL(5)
+#define XFEATURE_MASK_ZMM_Hi256		BIT_ULL(6)
+#define XFEATURE_MASK_Hi16_ZMM		BIT_ULL(7)
+#define XFEATURE_MASK_XTILE_CFG		BIT_ULL(17)
+#define XFEATURE_MASK_XTILE_DATA	BIT_ULL(18)
+
+#define XFEATURE_MASK_AVX512		(XFEATURE_MASK_OPMASK \
+					 | XFEATURE_MASK_ZMM_Hi256 \
+					 | XFEATURE_MASK_Hi16_ZMM)
+#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILE_DATA \
+					 | XFEATURE_MASK_XTILE_CFG)
+
 /* Note, these are ordered alphabetically to match kvm_cpuid_entry2.  Eww. */
 enum cpuid_output_regs {
 	KVM_CPUID_EAX,
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 4b733ad21831..14a7656620d5 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -33,12 +33,6 @@
 #define MAX_TILES			16
 #define RESERVED_BYTES			14
 
-#define XFEATURE_XTILECFG		17
-#define XFEATURE_XTILEDATA		18
-#define XFEATURE_MASK_XTILECFG		(1 << XFEATURE_XTILECFG)
-#define XFEATURE_MASK_XTILEDATA		(1 << XFEATURE_XTILEDATA)
-#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILECFG | XFEATURE_MASK_XTILEDATA)
-
 #define XSAVE_HDR_OFFSET		512
 
 struct xsave_data {
@@ -187,14 +181,14 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	__tilerelease();
 	GUEST_SYNC(5);
 	/* bit 18 not in the XCOMP_BV after xsavec() */
-	set_xstatebv(xsave_data, XFEATURE_MASK_XTILEDATA);
-	__xsavec(xsave_data, XFEATURE_MASK_XTILEDATA);
-	GUEST_ASSERT((get_xstatebv(xsave_data) & XFEATURE_MASK_XTILEDATA) == 0);
+	set_xstatebv(xsave_data, XFEATURE_MASK_XTILE_DATA);
+	__xsavec(xsave_data, XFEATURE_MASK_XTILE_DATA);
+	GUEST_ASSERT((get_xstatebv(xsave_data) & XFEATURE_MASK_XTILE_DATA) == 0);
 
 	/* xfd=0x40000, disable amx tiledata */
-	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILEDATA);
+	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
 	GUEST_SYNC(6);
-	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILEDATA);
+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
 	/* Trigger #NM exception */
@@ -206,11 +200,11 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 
 void guest_nm_handler(struct ex_regs *regs)
 {
-	/* Check if #NM is triggered by XFEATURE_MASK_XTILEDATA */
+	/* Check if #NM is triggered by XFEATURE_MASK_XTILE_DATA */
 	GUEST_SYNC(7);
-	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_SYNC(8);
-	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	/* Clear xfd_err */
 	wrmsr(MSR_IA32_XFD_ERR, 0);
 	/* xfd=0, enable amx */
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

