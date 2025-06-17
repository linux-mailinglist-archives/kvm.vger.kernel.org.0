Return-Path: <kvm+bounces-49741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5982ADD873
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73B5F1945C1C
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F892FA63C;
	Tue, 17 Jun 2025 16:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RZ0i31DD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EBA2EA751
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178042; cv=none; b=QJBQnbXXHH2ZS3ezDTzmTpzcB2AuB2ublinGMEak1td/1LgjljX6YL+nxg5RRbG/BlBmWbcgNcTwfofbjtL6AI7RQ6VhoiyLAEhflCPid2OuG7SlAfTTMaAQ1qK1rjq9q6nEON+N2/mJQbPw5jOXMccNUWwdPt/Dlj6cW/HlieU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178042; c=relaxed/simple;
	bh=KDxsVP69tGp7xtGYwPP0tQZjd1rakZ12nrPME0E9lgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=boFiLasHNx1QxFrt8gYH0QfYUOOLkZ2JYYaXY7ivvUqaN33MnswYqbkMldz7iMKmRlEwgvemtJU/QtjGzx5m/bqsscsXDET/eTC94MD5+YtfBYEz4F8gxOvyfvhOFQBGhr80vdoevfoItIjgLE5MXlIUZ2KbqVgg38j6TOLZEKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RZ0i31DD; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a4ef2c2ef3so4913275f8f.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178039; x=1750782839; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GncEdQO/d7gOZ9LM+QxKenzRx6813cX2TxyJIAl7x3Y=;
        b=RZ0i31DDUNIv7/Rden3K7UUpskY3LIWNuOtNxl610XMIhsfoEZfL/jUqxSxQOIwJ4R
         Gor0o6jNs/dIKIB1VHTUpVSUUBF/UvxRq2o7J8x0osdytGC5UGrUdtUnEe8p30eDSvIl
         9UbpccyLar7BXH4xTimetj5VnKmCE5fUWvr+mx+eD4TfN6McE4rMzmpVQ0Csq1xSBoDX
         pmEcxHzO3cKIjBPQ2U82/2jEUfwAd6lfoS0/4QWusFx7hbQ6QUkjxkPVP4pgRD50bGTc
         9iOiDoNum/09kAD7+2dXRhr+rrLUmXqYJNbL7Dih8+XWYD4kbjg5jY+gKOlsbg0fxpFD
         0wDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178039; x=1750782839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GncEdQO/d7gOZ9LM+QxKenzRx6813cX2TxyJIAl7x3Y=;
        b=XBI5sROYbh/F8GQGRTUh0cCgJB3Q9zfotCUFd/x2eSymuzmK493HL0CMSnP32tx0ZC
         MsOPVIkzYxEs4oN/y2ddelAEA1bC3VqyO+O9wUVYMmusxvWN8R5LjvrekwdncDWcW0lX
         95biYFl57/+aja9SeQ2QGKxNjDrt3twBQ0754M2aKBSVnk+Dx0vAxfneZb+uryAT5u8/
         A9vYdsRv3s4cFmgK9QhysmvOAEtDf0marU/nLNxJb000m5d7INtUoTyRPRNli75M2ESx
         g3/mgYz3+u6F6gKd19zj2sv5GdF7KPONLGWgbe4vuIr2ClPCsUF5wTnbEYh5xCTJEap6
         xmrA==
X-Forwarded-Encrypted: i=1; AJvYcCVT6tsVn9BYImDqcfy9jwjhZucta32MZjk98phSL09cABj9xe/TUybkT3dk/FGH4UnyieQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3+NgmDvA0QcASYzdiiIBZRMOW4PecorW+9rPmlUUX1RDb2frX
	Z17G07/oM8cRA7O78tF3A6IOPjSN2YrdMxsY/eHX044ChnDWyRW8SZmNcZn98bKLvCw=
X-Gm-Gg: ASbGncvgmpPASTY65fPLNKaqrqF1dRLA7mjG7lMbeMrZv2bR7pTQ0NqjtgqMq9Ha23l
	GCrBccLMstnUaPm8+fo4ox4ZgfwAysFkoxipSPq+MnGwbi7xrzABlW191WdH0WJNU8HN+5NygX0
	2GxUTaglVPK3jySeGPD987O670K/d+SQT6PUPCJAGevGLmpZTPY4gRL6vMQw6O73heneiQ6cMp4
	XnygMRwPlUWpdkBAF46WZAytLMfF/Q748j8Tm2JftNYDAmVfOld2ika+CjYzIfv+/Zp+bI5y6OH
	0Yl6EhFCo8fQsvZ4vU/2J8DWSWWcXC0+Wo7wyWwzRlaHM1B+WNfGNJhSVLDl9MY=
X-Google-Smtp-Source: AGHT+IEzrNJfJxccfvZ1/Dv81sv9ibMeIsZbIicjBJbFPPlnMb0UfYqycjSiQbPuRMjeJfXuxbG2YQ==
X-Received: by 2002:a05:6000:400b:b0:3a4:f2ed:217e with SMTP id ffacd0b85a97d-3a5723af786mr11907985f8f.42.1750178039291;
        Tue, 17 Jun 2025 09:33:59 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b090b0sm14359958f8f.46.2025.06.17.09.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:58 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 01A2B5F929;
	Tue, 17 Jun 2025 17:33:53 +0100 (BST)
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
Subject: [RFC PATCH 11/11] kvm/arm: implement WFx traps for KVM
Date: Tue, 17 Jun 2025 17:33:51 +0100
Message-ID: <20250617163351.2640572-12-alex.bennee@linaro.org>
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

This allows the vCPU guest core to go to sleep on a WFx instruction.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 target/arm/kvm.c        | 28 ++++++++++++++++++++++++++++
 target/arm/trace-events |  1 +
 2 files changed, 29 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 1280e2c1e8..63ba8573a2 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1544,6 +1544,32 @@ static int kvm_arm_handle_hypercall(ARMCPU *cpu,
     return 0;
 }
 
+/*
+ * It would be perfectly fine to immediately return from any WFE/WFI
+ * trap however that would mean we spend a lot of time bouncing
+ * between the hypervisor and QEMU when things are idle.
+ */
+
+static const char * wfx_insn[] = {
+    "WFI",
+    "WFE",
+    "WFIT",
+    "WFET"
+};
+
+static int kvm_arm_handle_wfx(CPUState *cs, int esr_iss)
+{
+    int ti = extract32(esr_iss, 0, 2);
+    ARMCPU *cpu = ARM_CPU(cs);
+    CPUARMState *env = &cpu->env;
+
+    trace_kvm_wfx_trap(cs->cpu_index, wfx_insn[ti], env->pc);
+
+    /* stop the CPU, return to the top of the loop */
+    cs->stop = true;
+    return EXCP_YIELD;
+}
+
 /**
  * kvm_arm_handle_hard_trap:
  * @cpu: ARMCPU
@@ -1582,6 +1608,8 @@ static int kvm_arm_handle_hard_trap(ARMCPU *cpu,
     case EC_AA64_HVC:
     case EC_AA64_SMC:
         return kvm_arm_handle_hypercall(cpu, esr_ec);
+    case EC_WFX_TRAP:
+        return kvm_arm_handle_wfx(cs, esr_iss);
     default:
         qemu_log_mask(LOG_UNIMP, "%s: unhandled EC: %x/%x/%x/%d\n",
                 __func__, esr_ec, esr_iss, esr_iss2, esr_il);
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 10cdba92a3..bb02da12ab 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -16,3 +16,4 @@ kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is
 kvm_sysreg_read(const char *name, uint64_t val) "%s => 0x%" PRIx64
 kvm_sysreg_write(const char *name, uint64_t val) "%s <=  0x%" PRIx64
 kvm_hypercall(int ec, uint64_t arg0) "%d: %"PRIx64
+kvm_wfx_trap(int vcpu, const char *insn, uint64_t vaddr) "%d: %s @ 0x%" PRIx64
-- 
2.47.2


