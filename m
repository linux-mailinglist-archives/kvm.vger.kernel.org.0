Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605277C8465
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 13:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjJMLac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 07:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjJMLab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 07:30:31 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B2591
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 04:30:29 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-692d2e8c003so2400524b3a.1
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 04:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697196629; x=1697801429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2kEj9owmff5WdmJZ3/IwZ7dXS/lR7029hPJPtdIdgVE=;
        b=FEF5MdtM1l4bEHkrxxosGgxovxjsj6AW6hVIwRENST7Aod9FflGDjdZWFxqMwPfCPd
         oC7vQyv4gQ4Lxh8dUnsW8gTPyUOradj58P7DOrfPUiTGGMwMhz29By+WeVhLol433MhY
         TAzh9X1iB8o6P5VnB7hwm8/kNt1TOB6YLX82pGCU+cU/0RYvR6tf3Dm++YRIOGmX+v75
         zzlTNeWYSJbcBGmMK8GDJ8oWax90PDpj/ffmo+v2Qx4NxXUtdGxMIEImra4XhqM3od2z
         qmsSZrvNFdtwOn2jj5aO6uZHIylnn6NgQQp/J+phXO/Cs2ANwx9LsTOcTKLvf+Wu2P3H
         t5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697196629; x=1697801429;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2kEj9owmff5WdmJZ3/IwZ7dXS/lR7029hPJPtdIdgVE=;
        b=A42gvMCmDzpzQGGayGoqxi41P129OmMrlGs0zk1/pgzC8lUvIAg9uMQMiQ1mJCFcRD
         cvH0dLAtQhFZ9xm8xeAqvz1KASXRrogwkVPfz0NeAGiOKuIiTR86PgJ5m/7h+1LRuiZ9
         tlMcXbOoRWXEc4kMHypCIttOFSZJzKF1z8C4Tdf3CPNKNByZ6RbMpR80vRENAID+nBmY
         T/HVpbrF3i+HvkTB8OCSJU8DsiFgvu8/BH4UxGAnmkTU2MQQnTNB/du4xpxSdNUcMJrh
         aH1ecdnu6ei31v77WVRcnvuyUEiGebdl2iV7pGvG8vKqlLTfLR1BzN9nWzdk22Ia3jU8
         lVmg==
X-Gm-Message-State: AOJu0YyMP6vIGtV+yTxRZ76Nw/d2vrLrWVa+ejgQ7R+INtnXPy7x4q90
        7gUVLi5E/U294b2G1iHJPS/1twHTsAY+Fw==
X-Google-Smtp-Source: AGHT+IEUNm3VBO+F/sZguB22eWdPqoWFJpCpGtVbajH9vyW7BJCVCxeLbI1nHGzpEX8DXbHPNQvQIQ==
X-Received: by 2002:a05:6a21:a599:b0:153:39d9:56f8 with SMTP id gd25-20020a056a21a59900b0015339d956f8mr35635415pzc.15.1697196628844;
        Fri, 13 Oct 2023 04:30:28 -0700 (PDT)
Received: from FLYINGPENG-MB0.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id h7-20020a63b007000000b0057412d84d25sm3222863pgf.4.2023.10.13.04.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Oct 2023 04:30:28 -0700 (PDT)
From:   flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH v3] KVM: x86: Use octal for file permission
Date:   Fri, 13 Oct 2023 19:30:20 +0800
Message-Id: <20231013113020.77523-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
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

From: Peng Hao <flyingpeng@tencent.com>

Improve code readability and checkpatch warnings:
  WARNING: Symbolic permissions 'S_IRUGO' are not preferred. Consider using octal permissions '0444'.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++----------
 arch/x86/kvm/x86.c     | 18 +++++++++---------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f283eb47f6ac..ee6542e8837a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -199,7 +199,7 @@ module_param_named(npt, npt_enabled, bool, 0444);
 
 /* allow nested virtualization in KVM/SVM */
 static int nested = true;
-module_param(nested, int, S_IRUGO);
+module_param(nested, int, 0444);
 
 /* enable/disable Next RIP Save */
 int nrips = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index af73d5d54ec8..c1e2d80377e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -82,28 +82,28 @@ bool __read_mostly enable_vpid = 1;
 module_param_named(vpid, enable_vpid, bool, 0444);
 
 static bool __read_mostly enable_vnmi = 1;
-module_param_named(vnmi, enable_vnmi, bool, S_IRUGO);
+module_param_named(vnmi, enable_vnmi, bool, 0444);
 
 bool __read_mostly flexpriority_enabled = 1;
-module_param_named(flexpriority, flexpriority_enabled, bool, S_IRUGO);
+module_param_named(flexpriority, flexpriority_enabled, bool, 0444);
 
 bool __read_mostly enable_ept = 1;
-module_param_named(ept, enable_ept, bool, S_IRUGO);
+module_param_named(ept, enable_ept, bool, 0444);
 
 bool __read_mostly enable_unrestricted_guest = 1;
 module_param_named(unrestricted_guest,
-			enable_unrestricted_guest, bool, S_IRUGO);
+			enable_unrestricted_guest, bool, 0444);
 
 bool __read_mostly enable_ept_ad_bits = 1;
-module_param_named(eptad, enable_ept_ad_bits, bool, S_IRUGO);
+module_param_named(eptad, enable_ept_ad_bits, bool, 0444);
 
 static bool __read_mostly emulate_invalid_guest_state = true;
-module_param(emulate_invalid_guest_state, bool, S_IRUGO);
+module_param(emulate_invalid_guest_state, bool, 0444);
 
 static bool __read_mostly fasteoi = 1;
-module_param(fasteoi, bool, S_IRUGO);
+module_param(fasteoi, bool, 0444);
 
-module_param(enable_apicv, bool, S_IRUGO);
+module_param(enable_apicv, bool, 0444);
 
 bool __read_mostly enable_ipiv = true;
 module_param(enable_ipiv, bool, 0444);
@@ -114,10 +114,10 @@ module_param(enable_ipiv, bool, 0444);
  * use VMX instructions.
  */
 static bool __read_mostly nested = 1;
-module_param(nested, bool, S_IRUGO);
+module_param(nested, bool, 0444);
 
 bool __read_mostly enable_pml = 1;
-module_param_named(pml, enable_pml, bool, S_IRUGO);
+module_param_named(pml, enable_pml, bool, 0444);
 
 static bool __read_mostly error_on_inconsistent_vmcs_config = true;
 module_param(error_on_inconsistent_vmcs_config, bool, 0444);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3412091505d..8c1190a5d09b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -145,21 +145,21 @@ EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
 
 static bool __read_mostly ignore_msrs = 0;
-module_param(ignore_msrs, bool, S_IRUGO | S_IWUSR);
+module_param(ignore_msrs, bool, 0644);
 
 bool __read_mostly report_ignored_msrs = true;
-module_param(report_ignored_msrs, bool, S_IRUGO | S_IWUSR);
+module_param(report_ignored_msrs, bool, 0644);
 EXPORT_SYMBOL_GPL(report_ignored_msrs);
 
 unsigned int min_timer_period_us = 200;
-module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
+module_param(min_timer_period_us, uint, 0644);
 
 static bool __read_mostly kvmclock_periodic_sync = true;
-module_param(kvmclock_periodic_sync, bool, S_IRUGO);
+module_param(kvmclock_periodic_sync, bool, 0444);
 
 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
 static u32 __read_mostly tsc_tolerance_ppm = 250;
-module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
+module_param(tsc_tolerance_ppm, uint, 0644);
 
 /*
  * lapic timer advance (tscdeadline mode only) in nanoseconds.  '-1' enables
@@ -168,13 +168,13 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
  * tuning, i.e. allows privileged userspace to set an exact advancement time.
  */
 static int __read_mostly lapic_timer_advance_ns = -1;
-module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
+module_param(lapic_timer_advance_ns, int, 0644);
 
 static bool __read_mostly vector_hashing = true;
-module_param(vector_hashing, bool, S_IRUGO);
+module_param(vector_hashing, bool, 0444);
 
 bool __read_mostly enable_vmware_backdoor = false;
-module_param(enable_vmware_backdoor, bool, S_IRUGO);
+module_param(enable_vmware_backdoor, bool, 0444);
 EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 
 /*
@@ -186,7 +186,7 @@ static int __read_mostly force_emulation_prefix;
 module_param(force_emulation_prefix, int, 0644);
 
 int __read_mostly pi_inject_timer = -1;
-module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
+module_param(pi_inject_timer, bint, 0644);
 
 /* Enable/disable PMU virtualization */
 bool __read_mostly enable_pmu = true;
-- 
2.31.1

