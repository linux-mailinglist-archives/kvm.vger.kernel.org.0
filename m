Return-Path: <kvm+bounces-54427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B94CB212D4
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34D4F1907F7E
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4422D47FD;
	Mon, 11 Aug 2025 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DtY8mlvL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A8C2C21F8
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754932026; cv=none; b=niLAeNCMppa7zTvN17EdD4Cqx/U9VKJdUb1Itj6a9hZld6DaBEp/bfvwacBEw+aWkpS8wyEGwILOq1BAUidyIh+zfdiUTacPxT20LU0iVj/WSljb04yGOV9UH6HM11DPAQXWr4UClvRIdGWAQxCsuTlsCMBBIKcWcBAeV9p8MGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754932026; c=relaxed/simple;
	bh=y3mvboDGdc9a5jc5SWh598zdp75yn7mHDfSaQeNsPlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PktM6ISv5GOYgVUEcJjZNC2QZjAE3+WvQVuyake+HgExhmR8ePor5jVDhiqPieyRLRANjrs71vprX+noLHSrDiTwGTShY2+E4DvJlEg6EyN23YI0EhSeKHmMZKw7xXjc+OKTWA572kkO3QCTMvhdOtMNDcZq9B3dnPf8mly5gjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DtY8mlvL; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-459e39ee7ccso45606075e9.2
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754932023; x=1755536823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wXHYeE/dbTRdflhUmCNmx7Q9a47atxr+CRA/ufWMQVM=;
        b=DtY8mlvLcp0ZLIgnz7tjXaqCFYgm0pTijVr+haC9Wzugx7vZ0zjW4OsnGS+ouLFwuh
         kqCxm1sAoSOGIER2glVnYhzNbZazE8qKztlKds0mqeXWrEcf9C+3BJtDlVOMye/Yb4aG
         ur8jpryGzAsHUFOYk+vCfXaTHK/AH/lSniVXJNYzQO/9jyOYXLoMFLuoJ28Y9ryKEO4p
         GgOR7zRFLln+zYACvnnoPKYN4QW63SSlLUOVNSsBQmojpmD1jp7tOO3QUdrfZKU57Caw
         7NnDsNsDcxKnyK41gqfFari+R4SKV/0+p4UssefXq15K2N3OEe9MhCg9RF1UwRNp1jA5
         EThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754932023; x=1755536823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wXHYeE/dbTRdflhUmCNmx7Q9a47atxr+CRA/ufWMQVM=;
        b=M4rzC65oOncTKdJ6Fn5RH3hdfBVWzPoGu7nviKowRDO52btWQjQwKMxZ+j2ptLBSGD
         1PdLHSnPXAtR7SIiG7uaPFyfjQiB9q7EQtX+XlHdSZX62574/oTXN9Y7MAd8nLgpMMxR
         9f69Jh12+vvj6W2j7Po+iitH1Bo8Zi2R23/zmvQWbVBPWoRDuS3Nk6OgLqOCRO0GBuFI
         r3XuDAG+IYUjvlNKIUNs9EJYMkgC506uZ0zIlVUlznd6B0gzalk7k5XwzJm6TrzM//t9
         7IJcRRyHmN2w6Ctk7FQBHfIxTTVBa4LE5rKojmDDyC5mYq4zURmXwwR82bRWRbE2GIHt
         2hnA==
X-Forwarded-Encrypted: i=1; AJvYcCUgm5CAf2BbK5uz5OCAaRCKDvStNilJ3qzYVZXUWdMo1lDN8wPZnJ13DveaQVfxoJmi2xA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxutzvz0Fx5usTaE89wZYaHGqgEiHYtoWH4jqkNJgipeJISUEqg
	jL+WUQqRI682vxWy46JnxhEfuA0CxCO3qKnhWalkOSHXwk4yi1AVl3dkvx8fs3FkwdDMBjbxXD2
	psoYi
X-Gm-Gg: ASbGncvBS4V3jb08Lk6fiyjtBd/Ajd3eAYIgC2CDQjkMMLMfNMTWubnQBxdextmGlEr
	67ufdI1YJq2WOiT9bmNuhhfzGk6UtUSOEi3/OEI0QGlxeOp5nVUZ2jSYwseCUP4/MdmsFkVK2oU
	JD5pTpeBA3e/dJbrezoNY5A/wmPmTGsbhcZCsGz+Sa7YSFdi14i0i3DDc9vFNeGs7/ZCtEuSty3
	btgcDsVfm3vMuc+0eSQgjjyAFV6kfJYfIfm3s+dsaIxAw79SqlbRW2XYLmaWUAZ91M/UNbuDLup
	vuu7E3cWcMOvj02HQ0XouGKwhkLa/DQCZQtPfm+RWPwjr2I7rmvASxFw4NvXdB4rtQn6WloXKwd
	Bbj+dXGOpCgXsR9uQUn6/mbvpv3ZAGwHBm/mqLj5/Noi9dD0MY2gR53a6h/pC/fiSlOogQPun
X-Google-Smtp-Source: AGHT+IFUuly7Dqrg66psU4QHCuRXsJhkEzRy6aRPP2+eyqivHdPhhh2IohEjZISBtH74GHrPxa9how==
X-Received: by 2002:a05:6000:2c09:b0:3b7:806e:7773 with SMTP id ffacd0b85a97d-3b910fd97fbmr541303f8f.15.1754932022551;
        Mon, 11 Aug 2025 10:07:02 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3abf33sm41526775f8f.7.2025.08.11.10.07.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:07:02 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Haibo Xu <haibo.xu@linaro.org>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Alexander Graf <agraf@csgraf.de>,
	Claudio Fontana <cfontana@suse.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Mads Ynddal <mads@ynddal.dk>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH 09/11] target/arm/hvf: Sync registers used at EL2
Date: Mon, 11 Aug 2025 19:06:09 +0200
Message-ID: <20250811170611.37482-10-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250811170611.37482-1-philmd@linaro.org>
References: <20250811170611.37482-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mohamed Mediouni <mohamed@unpredictable.fr>

When starting up the VM at EL2, more sysregs are available. Sync the state of those.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
[PMD: Adapted to host_cpu_feature_supported() API]
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/hvf/hvf.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 5174973991f..778dc3cedf7 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -400,6 +400,7 @@ static const struct hvf_reg_match hvf_fpreg_match[] = {
 struct hvf_sreg_match {
     int reg;
     uint32_t key;
+    bool el2;
     uint32_t cp_idx;
 };
 
@@ -545,6 +546,27 @@ static struct hvf_sreg_match hvf_sreg_match[] = {
     { HV_SYS_REG_CNTV_CTL_EL0, HVF_SYSREG(14, 3, 3, 3, 1) },
     { HV_SYS_REG_CNTV_CVAL_EL0, HVF_SYSREG(14, 3, 3, 3, 2) },
     { HV_SYS_REG_SP_EL1, HVF_SYSREG(4, 1, 3, 4, 0) },
+    /* EL2 */
+    { HV_SYS_REG_CPTR_EL2, HVF_SYSREG(1, 1, 3, 4, 2), .el2 = true },
+    { HV_SYS_REG_ELR_EL2, HVF_SYSREG(4, 0, 3, 4, 1), .el2 = true },
+    { HV_SYS_REG_ESR_EL2, HVF_SYSREG(5, 2, 3, 4, 0), .el2 = true },
+    { HV_SYS_REG_FAR_EL2, HVF_SYSREG(6, 0, 3, 4, 0), .el2 = true },
+    { HV_SYS_REG_HCR_EL2, HVF_SYSREG(1, 1, 3, 4, 0), .el2 = true },
+    { HV_SYS_REG_HPFAR_EL2, HVF_SYSREG(6, 0, 3, 4, 4), .el2 = true },
+    { HV_SYS_REG_MAIR_EL2, HVF_SYSREG(10, 2, 3, 4, 0), .el2 = true },
+    { HV_SYS_REG_MDCR_EL2, HVF_SYSREG(1, 1, 3, 4, 1), .el2 = true },
+    { HV_SYS_REG_SCTLR_EL2, HVF_SYSREG(1, 0, 3, 4, 0), .el2 = true },
+    { HV_SYS_REG_SPSR_EL2, HVF_SYSREG(4, 0, 3, 4, 0), .el2 = true },
+    { HV_SYS_REG_SP_EL2, HVF_SYSREG(4, 1, 3, 6, 0), .el2 = true},
+    { HV_SYS_REG_TCR_EL2, HVF_SYSREG(2, 0, 3, 4, 2), .el2 = true },
+    { HV_SYS_REG_TPIDR_EL2, HVF_SYSREG(13, 0, 3, 4, 2), .el2 = true },
+    { HV_SYS_REG_TTBR0_EL2, HVF_SYSREG(2, 0, 3, 4, 0), .el2 = true },
+    { HV_SYS_REG_TTBR1_EL2, HVF_SYSREG(2, 0, 3, 4, 1), .el2 = true },
+    { HV_SYS_REG_VBAR_EL2, HVF_SYSREG(12, 0, 3, 4, 0), .el2 = true },
+    { HV_SYS_REG_VMPIDR_EL2, HVF_SYSREG(0, 0, 3, 4, 5), .el2 = true },
+    { HV_SYS_REG_VPIDR_EL2, HVF_SYSREG(0, 0, 3, 4, 0), .el2 = true },
+    { HV_SYS_REG_VTCR_EL2, HVF_SYSREG(2, 1, 3, 4, 2), .el2 = true },
+    { HV_SYS_REG_VTTBR_EL2, HVF_SYSREG(2, 1, 3, 4, 0), .el2 = true },
 };
 
 int hvf_get_registers(CPUState *cpu)
@@ -588,6 +610,12 @@ int hvf_get_registers(CPUState *cpu)
             continue;
         }
 
+        if (hvf_sreg_match[i].el2
+            && arm_feature(env, ARM_FEATURE_EL2)
+            && !host_cpu_feature_supported(ARM_FEATURE_EL2, false)) {
+            continue;
+        }
+
         if (cpu->accel->guest_debug_enabled) {
             /* Handle debug registers */
             switch (hvf_sreg_match[i].reg) {
@@ -725,6 +753,12 @@ int hvf_put_registers(CPUState *cpu)
             continue;
         }
 
+        if (hvf_sreg_match[i].el2
+            && arm_feature(env, ARM_FEATURE_EL2)
+            && !host_cpu_feature_supported(ARM_FEATURE_EL2, false)) {
+            continue;
+        }
+
         if (cpu->accel->guest_debug_enabled) {
             /* Handle debug registers */
             switch (hvf_sreg_match[i].reg) {
-- 
2.49.0


