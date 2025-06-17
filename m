Return-Path: <kvm+bounces-49738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34AC4ADD8EC
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 19:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B74E0189C70F
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B1A2F9489;
	Tue, 17 Jun 2025 16:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bu1q4WWc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9982EA734
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178041; cv=none; b=osuLhVKtlUPbIxcfQCbRDtUBUVug2HZe6lFJ11rf/J54/KjQ0m90z8+2Qd0svtVrNIGw6vgTfv4U06wt0smXWuRQXTsFxmGLsspGAh4eiBHv/pIu2be9+3FzMY6PJiLeSbEnrvSp03h2QaT7SpmTHvjILG8I0EuBrLa9hPqP6pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178041; c=relaxed/simple;
	bh=/zuZXQd3G8HB9wVqfw33gcSFYkprHwQa0L64x+MK56w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FGf70NOC+4Ii5KmgUHeFRjiGXCuln2U/rRYBORiJxzFo/+PfW5JTmowjlqPs9S5pUsCh9dSyOyDiSf365KceXiGpbg+kIrLjt+En1NX/7rGBBQ7gOUC8ZP4FUwhfqISoTFOKJ8CEZUFjTeSUp9C6C6tsmeWRzVYZr5mDJSEwzBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Bu1q4WWc; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-450dd065828so48835865e9.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178038; x=1750782838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aoMza4IYUrQ4pKhizFEWSlqdn80g7ODuwHDUZB6a5Mc=;
        b=Bu1q4WWcFBzvAG1nTvHcTWPfBl0tZOJY0vLxKJoqJKeXaJ9DVt0cn9mGIx/QndsrAU
         Gs6B2iqUou36/effarnxPrYgAFp5t/fT5Gg0zZex3TBKWorwTQ6beafEU9gekYQB7tIG
         CIM2jqxwav3wZnOOH2osIj9PIwYMzx9NXe9k18o7uA8iFfdttbPsB+5/PrcQOcwvCPgf
         ucNoYa2zflrbYvPfP08oBmQqGEGe/pU0cgm7JF+40VNcHodgVwdih+YrvFgDJJpI81CK
         viuvVaz93Z8CN7gB9loo44lqtWanSjKHrOOQ+tJT4uKWzWN6HALzkb9+1yBXBWJ9/fqx
         kWGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178038; x=1750782838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aoMza4IYUrQ4pKhizFEWSlqdn80g7ODuwHDUZB6a5Mc=;
        b=doZJP+mzLIT7GzRVCzcbY+k/I2Zrv5gXjEf1fkD5924mvK1qChT/jHuQLn40adV/ip
         Ey3LBJqkH5H74xJKwXy23dzyDW0ZpQg7TNyuhDt3FY5R61U3BKtXXdtvbj8c9y0e7mfb
         mrzML07aRzcAXR1aQS36O6aNkIr3n5+HfbecrEy0aIrRUrs2EIUBYQbEWzMOxTGQZwn+
         1k7rMW46hXE4aMbeG8INuIIzpKrmWBQ7fMdfsBh4vH2BIxKsTF3nfIezmDcigwME9OXk
         eGlSmCUtmX58plAV8Ne8JNrEj8FzsYGZVryqpS40rLL4FtzuLCAmVrizyz0zAaRONNDc
         yVPw==
X-Forwarded-Encrypted: i=1; AJvYcCWrh6QmIPeLey+u109Vg/I8d+sdQOzTEWShnrmWW1DetPCz0xsyQYziCnluQtzijP02crM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJqLn04Wln/fKdnlwuS7j6eDxuo+NOBoJUJ5J/P4DXNEVkXl4j
	eRMVyhJGI0L6pVsDFevMVRTqnszOiF4hv6n019qSUR3KxUe2oAiZorNwev3MxYnnN9M=
X-Gm-Gg: ASbGncvcVk7mxWn6bvKACw8lDyHBtGYP/4RVY0SgUdmW9nMaUU6JfmLgd/vvGifkPBk
	331WJpK+jXrr1X6ahHKs8bnZqGZ6QWn1cQ/2dn9gkYe/JokUbenvtbRiDifr0g6M2NzVvTp3eTo
	2v9Hnf71kuu97AZlsBzruutodBA+/fD8ULfePo5mFY32o5OspT7xNf/OdvOR5hj7R3BVF5qfqY5
	CmeHQNl5aL8EZR1RZpIRLz0ukGQI/xcXZlI6RxFccfQkBg97/Jr8OaGVVfoD/SCDXzt6gW/ayLA
	VP94H/Uqkwk4TD0QxJbbah7qu0yThLb6+7d+caxOISMQBmjyXzRdJUgrpUS7ox0=
X-Google-Smtp-Source: AGHT+IE6pt33ke9xpxkXCz0wErJ6OWj9AV5oeVpKv/9/pglk58bJEG+5/55asfXJBldZuJtVgP7Iyw==
X-Received: by 2002:a05:600c:6095:b0:43c:fffc:7886 with SMTP id 5b1f17b1804b1-4535627dbe5mr19855865e9.8.1750178038202;
        Tue, 17 Jun 2025 09:33:58 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e232e4asm178682015e9.11.2025.06.17.09.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:55 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id DC5DE5F924;
	Tue, 17 Jun 2025 17:33:52 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Cornelia Huck <cohuck@redhat.com>,
	qemu-arm@nongnu.org,
	Mark Burton <mburton@qti.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH 10/11] kvm/arm: implement a basic hypercall handler
Date: Tue, 17 Jun 2025 17:33:50 +0100
Message-ID: <20250617163351.2640572-11-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617163351.2640572-1-alex.bennee@linaro.org>
References: <20250617163351.2640572-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For now just deal with the basic version probe we see during startup.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 target/arm/kvm.c        | 44 +++++++++++++++++++++++++++++++++++++++++
 target/arm/trace-events |  1 +
 2 files changed, 45 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 0a852af126..1280e2c1e8 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1507,6 +1507,43 @@ static int kvm_arm_handle_sysreg_trap(ARMCPU *cpu,
     return -1;
 }
 
+/*
+ * The guest is making a hypercall or firmware call. We can handle a
+ * limited number of them (e.g. PSCI) but we can't emulate a true
+ * firmware. This is an abbreviated version of
+ * kvm_smccc_call_handler() in the kernel and the TCG only arm_handle_psci_call().
+ *
+ * In the SplitAccel case we would be transitioning to execute EL2+
+ * under TCG.
+ */
+static int kvm_arm_handle_hypercall(ARMCPU *cpu,
+                                    int esr_ec)
+{
+    CPUARMState *env = &cpu->env;
+    int32_t ret = 0;
+
+    trace_kvm_hypercall(esr_ec, env->xregs[0]);
+
+    switch (env->xregs[0]) {
+    case QEMU_PSCI_0_2_FN_PSCI_VERSION:
+        ret = QEMU_PSCI_VERSION_1_1;
+        break;
+    case QEMU_PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+        ret = QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED; /* No trusted OS */
+        break;
+    case QEMU_PSCI_1_0_FN_PSCI_FEATURES:
+        ret = QEMU_PSCI_RET_NOT_SUPPORTED;
+        break;
+    default:
+        qemu_log_mask(LOG_UNIMP, "%s: unhandled hypercall %"PRIx64"\n",
+                      __func__, env->xregs[0]);
+        return -1;
+    }
+
+    env->xregs[0] = ret;
+    return 0;
+}
+
 /**
  * kvm_arm_handle_hard_trap:
  * @cpu: ARMCPU
@@ -1538,6 +1575,13 @@ static int kvm_arm_handle_hard_trap(ARMCPU *cpu,
     switch (esr_ec) {
     case EC_SYSTEMREGISTERTRAP:
         return kvm_arm_handle_sysreg_trap(cpu, esr_iss, elr);
+    case EC_AA32_SVC:
+    case EC_AA32_HVC:
+    case EC_AA32_SMC:
+    case EC_AA64_SVC:
+    case EC_AA64_HVC:
+    case EC_AA64_SMC:
+        return kvm_arm_handle_hypercall(cpu, esr_ec);
     default:
         qemu_log_mask(LOG_UNIMP, "%s: unhandled EC: %x/%x/%x/%d\n",
                 __func__, esr_ec, esr_iss, esr_iss2, esr_il);
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 69bb4d370d..10cdba92a3 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -15,3 +15,4 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 kvm_sysreg_read(const char *name, uint64_t val) "%s => 0x%" PRIx64
 kvm_sysreg_write(const char *name, uint64_t val) "%s <=  0x%" PRIx64
+kvm_hypercall(int ec, uint64_t arg0) "%d: %"PRIx64
-- 
2.47.2


