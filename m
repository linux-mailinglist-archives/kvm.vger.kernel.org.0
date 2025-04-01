Return-Path: <kvm+bounces-42383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 739C1A7811F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:09:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A072188F4D3
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79565212FA7;
	Tue,  1 Apr 2025 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S6xiP5HE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A98720DD63
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527175; cv=none; b=OTEBrlkmWFaFRa79qLUnyLW54D2i+qfxytoebhio4Bi7GOoHp8DafGlcabTLU0NDe+hDD1O1V0jaX4+xwQoY8FjVNrGxH4/Mev/QN11GEBDXNBVx8446zPCmkfJc/T8YVb1ZqIB1bWiOFYEVvwiyS+DjchMENeiB54//F5Kjc1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527175; c=relaxed/simple;
	bh=/ojOGjSENscu9Pb3+EYr5PYhSwGXxXZJjaejcHeP+sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9PjM+lNQRv+XlXO0HJbYVR2SMlhySl51AI25wGYytHnhzdUVNhi2j3T1ir/ubQfVeEM0W8Tvt/hiWYj+OV9cY5MIw0108LRHSKIZzETmq1IzSMIPwU/KkYtMRsYOdAXBnh6PbsynoxKyy+/eZOVzBljB5ATxiLDsUvAVsI4zIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S6xiP5HE; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-227aaa82fafso113042265ad.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 10:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527173; x=1744131973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDtkvMqdi74R/fuGRWaxI6Vx86s77IjYzoT0QepjNQ0=;
        b=S6xiP5HEq8apTva9FNYjO9i7twUf7S/Kvzpc0PE2T+IvpJPtj/7cTUBMoh53vimGfR
         kQWPId2cBItBLrtXblAUkA6odn+QkexcgRWdMWIarS1HpX/118mq4A+H3lPPaDZU2xVM
         L9jXbkscZLo4OJzq+FOFO1hp+G3B1lWzndyznvgl7VW8hHaM44X7CAs7x00nEAuGE9D7
         A1PzxbQ4Qdd5kQq843ryfsBLnn5ErEeyWmjTIBKILPnpT7CUFecr1zUIOXwNVBUWp4Xh
         4UOhInsGeqD+9Qz2pLXv1iCT/I1as6pAdYbHbvbYwMvD8A70RlBmmgC+jQodpKP21KxH
         oCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527173; x=1744131973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KDtkvMqdi74R/fuGRWaxI6Vx86s77IjYzoT0QepjNQ0=;
        b=IHKfC4p/tzcY+TUP2iY+PPyKq2cf9ZHY9ywzLbDL+5bEHl25YsA0mUuJKAWeJdymTn
         C/S5xl3KrXmnXy1qCQQx5r0rE/9Buvm1toQMRJSyIOFpNsffPZ1c8HhTjGV7aU2B5YiM
         4ZMs3pB7oYqShRMntMZz1Shqa4nn3s6LG1hadOqA7ZaZvT+j47sAVDgxFjhPZCPx2X9A
         XqfCf/KbtYdfd9cBCHE5Zu3iJslLY6KYoSLGH7zInh41WKU0qv5uzXG3uCUvKUF8fpHO
         OPyvx9XfzEjP/1rBjZfpwq3FifoJLwgcaEGSt7N5xUPpe6zuMnOdvG9D15eVqf7a7NBo
         xsUg==
X-Forwarded-Encrypted: i=1; AJvYcCUrDpDLIuYJxKHSU2XVnY3OndUmzOxCI6bTYvbi1IQwBq9zN4J159MfV6him68PkiLCXJI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKq7kZYlwjblCxp2/240pnCKttGoGIml2EE6WHtSuLpPGvI8qa
	F85HCATMCUaJ0aSXZ57SIrNsM+mR6+QDA52krKdkUxQtSe931PMm
X-Gm-Gg: ASbGncspSxjd2EL5+B76XddGJu+jSjhXESTi3N8A13ZHepA8YDGJQO3Pxna0NZWCBH9
	3zNOzuEwkdZYNvHmm9vLRNvnmQ+3OWLAARzCCVWball+OYDDAItsiAUEz0xb6PXF9mBw+GD760G
	LWCiHodUiXn5VO0Ft3hGy26MU2mXRQxzkD+BJVVxK44UTenPlS35jKer+Cp/68RxHNJ/4DjVQgl
	OB0vtFeMnGGq9XnPZ/4M5mpt/e5XqWCSOD4kLScuPVa6GmvOgLpfG2jYi8OJzv2KJipsCQ2Hz90
	xjXIIpiqqUR35SCKL2V1Z9val0SncuJopzgzGY+r
X-Google-Smtp-Source: AGHT+IGVQaPozKtnYFtEaxGdcDkcmfSHjENYsZlMxOjS55uxLWGM2YiQ/vVbzslmIBGst/k5j79maA==
X-Received: by 2002:a05:6a00:3a13:b0:736:491b:536d with SMTP id d2e1a72fcca58-7398046fe65mr22142417b3a.20.1743527173462;
        Tue, 01 Apr 2025 10:06:13 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:06:13 -0700 (PDT)
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	jens.wiklander@linaro.org,
	sumit.garg@kernel.org,
	mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	pbonzini@redhat.com,
	praan@google.com,
	Yuvraj Sakshith <yuvraj.kernel@gmail.com>
Subject: [RFC PATCH 4/7] KVM: arm64: Forward guest CPU state to TEE mediator on SMC trap
Date: Tue,  1 Apr 2025 22:35:24 +0530
Message-ID: <20250401170527.344092-5-yuvraj.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When guest makes an SMC, the call is denied by the hypervisor
and not handled (ignored). In the presence of the TEE Mediator
module, the SMC from guest is forwarded with it's vCPU register
state through tee_mediator_forward_request().

Signed-off-by: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
---
 arch/arm64/kvm/hypercalls.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 569941eeb3fe..cb34bb87188c 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -3,6 +3,7 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
+#include <linux/tee_mediator.h>
 
 #include <asm/kvm_emulate.h>
 
@@ -90,7 +91,10 @@ static bool kvm_smccc_default_allowed(u32 func_id)
 		 */
 		if (func_id >= KVM_PSCI_FN(0) && func_id <= KVM_PSCI_FN(3))
 			return true;
-
+#ifdef CONFIG_TEE_MEDIATOR
+		if (ARM_SMCCC_IS_OWNER_TRUSTED_APP(func_id) || ARM_SMCCC_IS_OWNER_TRUSTED_OS(func_id))
+			return true;
+#endif
 		return false;
 	}
 }
@@ -284,7 +288,14 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 		WARN_RATELIMIT(1, "Unhandled SMCCC filter action: %d\n", action);
 		goto out;
 	}
-
+#ifdef CONFIG_TEE_MEDIATOR
+	if (ARM_SMCCC_IS_OWNER_TRUSTED_APP(func_id) || ARM_SMCCC_IS_OWNER_TRUSTED_OS(func_id)) {
+		if (tee_mediator_is_active()) {
+			tee_mediator_forward_request(vcpu);
+			return 1;
+		}
+	}
+#endif
 	switch (func_id) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		val[0] = ARM_SMCCC_VERSION_1_1;
-- 
2.43.0


