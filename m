Return-Path: <kvm+bounces-50321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB36AAE3FF0
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 346A5189A8FC
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD6D247281;
	Mon, 23 Jun 2025 12:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FHWuPJ4S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D45A242D99
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681182; cv=none; b=D+41Mte8SJDSpXBaFyFLyPYkJ/jc7+MX2MHzcmMZGefV1Hz6LxSrYti7FcrZDFGf49BOdMgElz1l0lIQrUd0qTrl7PcTl6Qcd4qCBXhKtJ/Hw4Mx5IPC/N//B0SfUsZ4R2jFDmNVVv5NoSGDkqVCsKYdTdoWzNUiMHbN8PXQob4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681182; c=relaxed/simple;
	bh=ElSpehtVPafWOQWpZZmVuFns6hA4/nw7v13MHWHSRoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cHXDWES+SnOsAN95rUA9jWyawHaHwekN3b5CKaiZB6vP9ocIXbbwKP+tySGrewmIrztTz0iv+905SbQOKyj5aU9qDMsPBOXLQ3CfkRaxhRwNPlNroxFvecadRHjtR7QmS7ZsQN3WeE+GE9wLFNJFj+K+Ga5fs7ZkSf7qOWLBEIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FHWuPJ4S; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a507e88b0aso3477535f8f.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681179; x=1751285979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48R2YiPamWEGXpLD/SMOVBFSdD9dMYPDAhGM9B3qv/Y=;
        b=FHWuPJ4SyiKOQyeRRYRsakMONnZZ2P+z7AVNj1Zt3d99iJZUNzkSLZguKLSJDOjsib
         Uh2c+TKFIerNfMdKlV7ZTJAkTWTl8Q0nlQPKPnO4eJ4ltA8/d4fEClNa+Jlu52Oq8i4H
         NjFdE/v7mDtg1r/y9j7rsY4ymHX1fMMlCVaKI6yZFWS8pSNYZyayBs+3gi4ww5nmZSid
         fPiFIDFnyl8KBBnCM7KJxobXrMI8E32QpmYlWEMrXe3DinjQk2hSBAQOU1tWfIsb4kjC
         GWLAEf+GLYpm8DPVfeMwdKL8j5yqaTJNNE+SzrOgepqlbtQWbHzTSd60YgsU86YX+LIx
         /reQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681179; x=1751285979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=48R2YiPamWEGXpLD/SMOVBFSdD9dMYPDAhGM9B3qv/Y=;
        b=o/MhIV8EXyTLWyHmXxiA2b4Z3LkZ10ex3eUfdyvyO03qxmI+28x8mTTKnvdObBDbsx
         W/BVFfMONPKaYdjgxXNe0CTucoEQNk6GTIp3TnvK6DFyOk73Ciw+eg2LXqADp3bvEzPm
         MA8m1qhaMlh34KsUBPKWP2w19qqIRxE5a8VovkMBQxXE+EyGtRCsL5nt7WsVGjmcjuC2
         lDMq5+cOLJZCYalC8u2PKGN5jyU1Xptg7V/j+XqoqP6x9WKNjNOaL5sMbJG4mlvS0YXV
         QaZZeMbGRE5Rl7FRZ4jtP7rmza6DaG8orXPn5u9rBwfGreFMZYOV6d1MwLpatKTIU1xx
         29Hg==
X-Forwarded-Encrypted: i=1; AJvYcCWLmrRGkQM1/lRzHSCdOMxAIgfU5KpXjLSUeu9Kd0Fj4csSmNkkwxsZjjesv64X2v1o0qY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7FILz8KOR3Z0hWrcuOi/Onu4W8njRy41LWHjiGJhDyM2++aHT
	45w0tYf2mRzQoJl1K3Irn0eii8WOxy/gmwMjc+4hx9FwgiVqpHGYk35bCHW+Snaeh6E=
X-Gm-Gg: ASbGncuzeuaT6RikG6b4qlHmkInck5ATySgS41OAVkolewzG8L+eEsjboK1CtOUoZw8
	ni8zFR01cYTbImzVZdbvKzGLYGFppZ6kKfsAcO1JXcEqW4P7sZ7g8pnJ39GuUme/vhHDIfIgi6y
	IdAKvW41PdYlwZ7oh5+4TWXbzxlxIJb8LCCtuoaj54VFdt9JurQaRmfcbMIfwkC9xSS4LIhjYZR
	DQiXMxCYxaLJMrT2/TmmnigoEW9LNepH4vVw5m8Tq5ksy/qwt9lZJZVp6wZm28FUuLqcF6lfMsd
	VnqOwzfoMRUzZNHq/PKOuPHFB1WVYp6pk+u+1Jh9AIX8kVwNDwvM3jC8bV6KQjtqOzZfmyu0ilW
	jVrB1zDVbmaw++daIpMSABEKLqVRoGuvDl33dsAyzJu1Ffyw=
X-Google-Smtp-Source: AGHT+IEXe4I5B9Ke/lPmm6yKL911KIFc6TFDbUCkl0BXXwXmGDLjh6AfC57olDM6XbzOca+1lNc8Xg==
X-Received: by 2002:a05:6000:41c5:b0:3a0:a0d1:1131 with SMTP id ffacd0b85a97d-3a6d12c4483mr9863735f8f.7.1750681178908;
        Mon, 23 Jun 2025 05:19:38 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e2036094sm2260909f8f.99.2025.06.23.05.19.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:38 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 10/26] accel/hvf: Model PhysTimer register
Date: Mon, 23 Jun 2025 14:18:29 +0200
Message-ID: <20250623121845.7214-11-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Emulate PhysTimer dispatching to TCG, like we do with GIC registers.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/hvf/hvf.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index bf59b17dcb9..5169bf6e23c 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -187,6 +187,7 @@ void hvf_arm_init_debug(void)
 #define SYSREG_OSDLR_EL1      SYSREG(2, 0, 1, 3, 4)
 #define SYSREG_CNTPCT_EL0     SYSREG(3, 3, 14, 0, 1)
 #define SYSREG_CNTP_CTL_EL0   SYSREG(3, 3, 14, 2, 1)
+#define SYSREG_CNTP_CVAL_EL0  SYSREG(3, 3, 14, 2, 2)
 #define SYSREG_PMCR_EL0       SYSREG(3, 3, 9, 12, 0)
 #define SYSREG_PMUSERENR_EL0  SYSREG(3, 3, 9, 14, 0)
 #define SYSREG_PMCNTENSET_EL0 SYSREG(3, 3, 9, 12, 1)
@@ -198,6 +199,7 @@ void hvf_arm_init_debug(void)
 #define SYSREG_PMCEID0_EL0    SYSREG(3, 3, 9, 12, 6)
 #define SYSREG_PMCEID1_EL0    SYSREG(3, 3, 9, 12, 7)
 #define SYSREG_PMCCNTR_EL0    SYSREG(3, 3, 9, 13, 0)
+#define SYSREG_CNTP_TVAL_EL0  SYSREG(3, 3, 14, 2, 0)
 #define SYSREG_PMCCFILTR_EL0  SYSREG(3, 3, 14, 15, 7)
 
 #define SYSREG_ICC_AP0R0_EL1     SYSREG(3, 0, 12, 8, 4)
@@ -1326,16 +1328,15 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint64_t *val)
     }
 
     switch (reg) {
-    case SYSREG_CNTPCT_EL0:
-        *val = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) /
-              gt_cntfrq_period_ns(arm_cpu);
-        return 0;
     case SYSREG_OSLSR_EL1:
         *val = env->cp15.oslsr_el1;
         return 0;
     case SYSREG_OSDLR_EL1:
         /* Dummy register */
         return 0;
+    case SYSREG_CNTP_CTL_EL0:
+    case SYSREG_CNTP_TVAL_EL0:
+    case SYSREG_CNTPCT_EL0:
     case SYSREG_ICC_AP0R0_EL1:
     case SYSREG_ICC_AP0R1_EL1:
     case SYSREG_ICC_AP0R2_EL1:
@@ -1639,16 +1640,12 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
     case SYSREG_OSLAR_EL1:
         env->cp15.oslsr_el1 = val & 1;
         return 0;
-    case SYSREG_CNTP_CTL_EL0:
-        /*
-         * Guests should not rely on the physical counter, but macOS emits
-         * disable writes to it. Let it do so, but ignore the requests.
-         */
-        qemu_log_mask(LOG_UNIMP, "Unsupported write to CNTP_CTL_EL0\n");
-        return 0;
     case SYSREG_OSDLR_EL1:
         /* Dummy register */
         return 0;
+    case SYSREG_CNTP_CTL_EL0:
+    case SYSREG_CNTP_CVAL_EL0:
+    case SYSREG_CNTP_TVAL_EL0:
     case SYSREG_ICC_AP0R0_EL1:
     case SYSREG_ICC_AP0R1_EL1:
     case SYSREG_ICC_AP0R2_EL1:
-- 
2.49.0


