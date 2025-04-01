Return-Path: <kvm+bounces-42380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBDCBA7811E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:08:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 537323AF05F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8752E20FAB2;
	Tue,  1 Apr 2025 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nWR6X5ge"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDAF21C193
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527159; cv=none; b=U26qYyM/IvoJ2qoN+NzjdZkNAEdG6dnOeOk8ieg/MCcY6Uyf2CxFpibovvSU6akBCTfaPmTzgTlAWST0OcTEyOXdiwSXfuXHAmJmJv4i4kEvhx0mWw/JUaqlutbGTM6Asmfhn9n5jccEMt7z3mWgSMur6H5mCFUG7u02c2IgNAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527159; c=relaxed/simple;
	bh=KXerYYejaebsX7jbyb1Lb5RpqboiWkfKzCdImI0qQB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h61Ll5K0C0ya85LQskPBEnvrsRBybXcEnHd217vgWjoi7ggx/zv1M1N2eYnnO9/snvh5/HXgd1slPMPbfupbpyZU2LURlh+d0Vog8rEXh2QSfbv5qVrxqI2ddg9FQgRLZuk7de8UfYhdN2IgibzEHMdUhjNGHQ0zdSFY2PwrxW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nWR6X5ge; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22438c356c8so113828305ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 10:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527156; x=1744131956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5jy8qC0h8+P67i9ZAO/Zho3A5/9ZziVLel9NfnuQo2c=;
        b=nWR6X5gemlBHD4/CJYXdeGqVRbVt5+jRbtFRAvxesHE/AABhHKIyAkEeJ+BvInn/mR
         4DJKS6xQOvKCU9+7ok1FOhha/0VWmB2vaVVasfBK3mao7F03jCq8gFCExOCLwgNySUMw
         B7fpOTY1DevO+QKwB9jmpV7cF4j5Uzq6yqafp6TWYMBWnEihyEPcuO7V8GwVRStRhR6M
         87oHQ9+aYNtkrAG0ZfUnMuZmYsXw/FzHhmEMSsQ3gAmD685E6thDHhhm6OaTiP4T9oBY
         Gm1REtcdTrUkoBgHCv6N4001+YMl4pFx0Qoirn84UU1q5ywkqDo9+iAlWaj8sY7rfliC
         tFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527156; x=1744131956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5jy8qC0h8+P67i9ZAO/Zho3A5/9ZziVLel9NfnuQo2c=;
        b=f5QODAo4ij27db5b3o4ZJX+RWNljLYhW1JzvxuB4OG6jc7LZwVRXrCEouaY10wK4Ba
         wVjX/YFj2pttzl1NglybY111CIGTbjXUNjvhtvGlyWwv2I1UjomfQQMmNtKXdgSsi+Im
         d6afFx7vW5OsMx7pHw1eFqF9PMzVz2Kwx31JsmHejMEvKnp7LhMeGv5lIi4HPQAkdxA+
         +L1rq/JSTHDFFZ19f6yXBQdD2+h98s2EOJlOg8qSqZCXquMcZ8YxK//7+eqmJMlKoYHB
         RfGSHzy4UO/Tw9Z9/swA1BrryoC1H5PNPicIsFS8Gvr8VzW4+Hz1lFBNmIZ/Am9d+keB
         TLkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlSCITT3Wn4qgkQ6W/o1J8FPFQ9kiCfsQjQnNvBve0h4W1Q5R+2nE/CyFfBU5dq3qBO1M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx81rRXIaTtczdpJzSYFxhcJhFsTUc/6JKUbEPHrDnrqcAn6XSH
	s8o+jRvbP1M9H2xXZSNl0OJwFowzSuinOH5SvT9NsPML1SHr3TDf
X-Gm-Gg: ASbGncuDO8sIRl5SReWUcGfIk6boIXq+pY6xqGKmG1e+gz0Zako5zJh4ATJ6k9CR8l8
	uXEDc2b6bi5fgxobjT13Z1r4fmRBqdqHhaFQMybpiqvtAhpYQ4MonOgk/DyE5+TGFWnq2wiKFqs
	B18PIZ5TOyzkmZzZ2/MBVw8mKle8WraiJ1XROyeisyoPKOPq6GHYY42JsZ6THd+Zvsr5RXOWsqU
	l8isxgf3lWTrdxvw6HFpgmGDvkXqVhHD/MZdShagARgQAj4injzOqJgcyWf8pKGwjYMHYklmiv+
	zg/o25ibLFsJdqaKKZMaUR30Y4tH+H0N7Xu5gKFZ
X-Google-Smtp-Source: AGHT+IGYkL73/rVCuY5eIXCc8VPG7MsAP5ixlU5mMgBMLHSz5fauZRADZEMVVYLaM4aLq44Kjk0EYQ==
X-Received: by 2002:a17:902:ef09:b0:224:11fc:40c0 with SMTP id d9443c01a7336-2292f944013mr234995215ad.11.1743527156410;
        Tue, 01 Apr 2025 10:05:56 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:05:56 -0700 (PDT)
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
Subject: [RFC PATCH 1/7] firmware: smccc: Add macros for Trusted OS/App owner check on SMC value
Date: Tue,  1 Apr 2025 22:35:21 +0530
Message-ID: <20250401170527.344092-2-yuvraj.kernel@gmail.com>
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

This patch adds ARM_SMCCC_IS_OWNER_TRUSTED_APP() and ARM_SMCCC_IS_OWNER_TRUSTED_OS()
macros. These can be used to identify if the SMC is targetted at a Trusted OS/App in
the secure world.

Signed-off-by: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
---
 include/linux/arm-smccc.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index f19be5754090..da2b4565d5b3 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -56,6 +56,14 @@
 #define ARM_SMCCC_OWNER_TRUSTED_OS	50
 #define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
 
+#define ARM_SMCCC_IS_OWNER_TRUSTED_APP(smc_val) \
+		((ARM_SMCCC_OWNER_NUM(smc_val) >= ARM_SMCCC_OWNER_TRUSTED_APP) && \
+			(ARM_SMCCC_OWNER_NUM(smc_val) <= ARM_SMCCC_OWNER_TRUSTED_APP_END))
+
+#define ARM_SMCCC_IS_OWNER_TRUSTED_OS(smc_val)  \
+		((ARM_SMCCC_OWNER_NUM(smc_val) >= ARM_SMCCC_OWNER_TRUSTED_OS) && \
+			(ARM_SMCCC_OWNER_NUM(smc_val) <= ARM_SMCCC_OWNER_TRUSTED_OS_END))
+
 #define ARM_SMCCC_FUNC_QUERY_CALL_UID  0xff01
 
 #define ARM_SMCCC_QUIRK_NONE		0
-- 
2.43.0


