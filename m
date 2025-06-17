Return-Path: <kvm+bounces-49730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41EB8ADD8E7
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 19:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E4704A1B4B
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DFA52F949D;
	Tue, 17 Jun 2025 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zqn3qYIB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5728B2F4314
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178037; cv=none; b=P1A+U05ChOQ9vvhSxQtqOkleUqzIvQq1MBDZbQDslYOZtLbul02l4KmbuCHVfk9StBxPeN0MNL5MYEE4ZXaibSBEfEe2kiio9VKrCZmmSFiRuHctz1amPG9oUzpnWrGN4px2tMQvl4A4UbpmIRxC05FEOKDvTgYvjs5z/JQxk4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178037; c=relaxed/simple;
	bh=L4myMu/cWT9qX6vmTnTIkHeIJaC5LU9AHzzs8qFm7Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lf+W62mN7iE61PC9lE9bEmPWO8alNaIUpZ25eXqXOM3GcV6GqYmnZX9nCNIEqQKv4Fgp3b3+ZRGQcAErpVeBINiT7SQA9Omn5xvgmn0zI4l6MHtkQBuONIns5Eoh6IqACrbVJWhr1qXMGS2Qwn22dd09CHqfkSC7MVbvpRHsVrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zqn3qYIB; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45305c280a3so25100105e9.3
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178034; x=1750782834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/pVLW980tQUeFMbPOSrmbCV35FWVqLGwZwmiSRkT/nc=;
        b=zqn3qYIB2/KjIYX1Hrr1lxnjjVIv83ybuBZPpPapn2CPeLiV7Jq8TjEdqYVzgSVmVV
         K2DI1xQ40odSwe0W7DOMusYIi9QpnulaMb3XednueQ1jbqr+fNL0zLZVFRXzhQ0D8Zf2
         uZg+wAS4+1UpZsss58XeH3S2ybf9wKXq/x9G8uiK1saS4oIjevMKE7rKhY0m+oV/q9z7
         wM8Sj3eNul8MVzNKZSbsFy4Q06Z1ko8hdw6MUoIucxgLwxG1uVDgo3BaWKYiBxGJRmfT
         xhu1saNZ7ZdrUM+B6uP2wE0IIcp7VoT4ELohYHM9S4YG0s1ldrIpVCoFmRqsYVaEM/W6
         v9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178034; x=1750782834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/pVLW980tQUeFMbPOSrmbCV35FWVqLGwZwmiSRkT/nc=;
        b=M7i/CyQYWU7uiz74BqPK6tmafdCTc7Nz0B7ra6wY4fKLJARQj4rlyUwVLVjz2Oo8G0
         Bgyb+9d7g7rKliWmnMumcylanWfkjpbGjaSzg9gUwe/sea+mSIv6sIAe8mHJ5cfoE2hs
         LAZSCNj6WLPkUKwSli6mMeRnc0pjzmopSWR+1E3Hw3Uk+2DTBX02s7ls4ylKcR5+0sBU
         VZbd9TWoZrVUXFGZOV/sv5DTKLJlvcTubRaM2VW61lUxkkuB1U50u+PO4kuw60pnWnRb
         voDXySFAyTTgl9iWK2bX8LBJoSRWOHv7PmpDRMtBI5m4OYPDcBc0Y2fEzqluX0q+WT1r
         txHg==
X-Forwarded-Encrypted: i=1; AJvYcCWJuGUoTaDvtHOecbjcYJBLqbMS7dVk3utT/YdiMUhKehQ1CX3ajlwZf46P5Y1HRmU/Pls=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7rB9We/KuJevEBys0jUQaq0kRqn5i2/FGz6dEy7m+qr0jcEYA
	8GRdU3OTGrE1BN8rcH09Bz3Ckpo/r9UKRm5MdjVh00MFjIr10e3sVpuePqk6fjBSZpY=
X-Gm-Gg: ASbGncuCQLqfqGRi+M8KtroN3Lat1k395aDUTzmSrsMUDMSw4ixNS9532D3YOfwbUaT
	heJYsPvM6lYLAI1GFeCLaFT4qGZScqe9+9UJz0n7VJp0jbWlA0Xy+Ijl+fS0znacFeN7B0JNUYI
	evLyvaaHLgYlCGxER8McLOcv+JRxmpgSpWhXv3pfgPBK0/IUufXX96SYHnz+j0/g98GGbZVegs7
	DGLR9QhLNJkYysprdMAvDnpoIsSv+5vyQchxMB724cHpS3g/gBT3WM3FmsDO5YCBzPWEa/UPO9l
	3XsJIiVYQHo6+Wm1n1O2+bnf1PG4h/KVy75yIYaVo6vuIZh169/iWxqFeovqtNQ=
X-Google-Smtp-Source: AGHT+IE8v8HeR2piaWlFX6bbvfHCxqXZXhONIJkvHNHlEOHHSq+0M0P/3+bbuJRt/SWwiA7WH7QLGg==
X-Received: by 2002:a05:600c:8286:b0:450:cfe1:a827 with SMTP id 5b1f17b1804b1-4533cb1a7c4mr155107765e9.31.1750178033665;
        Tue, 17 Jun 2025 09:33:53 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e268de2sm181468295e9.40.2025.06.17.09.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:52 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 15EEF5F873;
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
Subject: [RFC PATCH 02/11] target/arm: re-arrange debug_cp_reginfo
Date: Tue, 17 Jun 2025 17:33:42 +0100
Message-ID: <20250617163351.2640572-3-alex.bennee@linaro.org>
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

Although we are using structure initialisation the order of the
op[012]/cr[nm] fields don't match the rest of the code base.
Re-organise to be consistent and help the poor engineer who is
grepping for system registers.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 target/arm/debug_helper.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index 69fb1d0d9f..8130ff78de 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -948,19 +948,21 @@ static const ARMCPRegInfo debug_cp_reginfo[] = {
      * DBGDSAR is deprecated and must RAZ from v8 anyway, so it has no AArch64
      * accessor.
      */
-    { .name = "DBGDRAR", .cp = 14, .crn = 1, .crm = 0, .opc1 = 0, .opc2 = 0,
+    { .name = "DBGDRAR", .cp = 14,
+      .opc0 = 0, .crn = 1, .crm = 0, .opc1 = 0, .opc2 = 0,
       .access = PL0_R, .accessfn = access_tdra,
       .type = ARM_CP_CONST | ARM_CP_NO_GDB, .resetvalue = 0 },
     { .name = "MDRAR_EL1", .state = ARM_CP_STATE_AA64,
-      .opc0 = 2, .opc1 = 0, .crn = 1, .crm = 0, .opc2 = 0,
+      .opc0 = 2, .crn = 1, .crm = 0, .opc1 = 0, .opc2 = 0,
       .access = PL1_R, .accessfn = access_tdra,
       .type = ARM_CP_CONST, .resetvalue = 0 },
-    { .name = "DBGDSAR", .cp = 14, .crn = 2, .crm = 0, .opc1 = 0, .opc2 = 0,
+    { .name = "DBGDSAR", .cp = 14,
+      .opc0 = 0, .opc1 = 0, .crn = 2, .crm = 0,.opc2 = 0,
       .access = PL0_R, .accessfn = access_tdra,
       .type = ARM_CP_CONST | ARM_CP_NO_GDB, .resetvalue = 0 },
     /* Monitor debug system control register; the 32-bit alias is DBGDSCRext. */
-    { .name = "MDSCR_EL1", .state = ARM_CP_STATE_BOTH,
-      .cp = 14, .opc0 = 2, .opc1 = 0, .crn = 0, .crm = 2, .opc2 = 2,
+    { .name = "MDSCR_EL1", .state = ARM_CP_STATE_BOTH, .cp = 14,
+      .opc0 = 2, .opc1 = 0, .crn = 0, .crm = 2, .opc2 = 2,
       .access = PL1_RW, .accessfn = access_tda,
       .fgt = FGT_MDSCR_EL1,
       .nv2_redirect_offset = 0x158,
-- 
2.47.2


