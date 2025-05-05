Return-Path: <kvm+bounces-45537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69576AAB805
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D2181C25375
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A93C4B13FD;
	Tue,  6 May 2025 00:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yjoLi6nj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C337C2F1529
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487451; cv=none; b=OUgShtjBlOlm0KrjCfWBwoPRbbFKQ0UxPfYvWAMUbbBGTIk9TDSqO37/V7pTjnWFxcvbC0GZa59xMZssge0cj46cU7UNkPeATcOprNM90otI/n5iocZCReg+GR8i595pfy9RyX6tIToLKRG7fMRzmY26vssM5TNzxfwkqxrmH+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487451; c=relaxed/simple;
	bh=AN4RRiWvpdSDf4xDQ7kJYYeLe2vuCOxKtfxRBNV5WsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnlGKmxIx/Ib+0/HTigOMT/duXI8n7y3K4zpgTaiQ0Axb4l7ri56mxbn4/Z7k7+1P/+X8r+7uhjGek7oSASlDydZKTembxcL7b99QfXym2IGamC+zuv5Ze/bc7oa7DjtkSMa42VMxaylBUGOH2RJZ29eAnfZiQxbq4BPhb34A7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yjoLi6nj; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2243803b776so1514055ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487449; x=1747092249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FePGOnuFMFKSpyGOLnQnHaWTz9W0KMamhZVlYN31tfM=;
        b=yjoLi6njW7IVQsdUH/+NN5E3rYi32DFZvDn/+HhJ7qN6vwyVmKAUiemBg/o9PBdLX8
         2k+sRWFMWJ24u3q77YgEFlRAyVlRYZQukOG3SKocSEa6NlcPvldSZKJ7pxANtNNH1RKh
         nGZh/YxgBlYSyxpocLIOLzT7zuv2e5esuof7yzsCytViTUMmL4LoLDX4i8Qj9YhwTpaT
         0vcaeYHEDJwJSxFer8dI/276txHW0kk9dc9SlEF5nm6n+rE0PldyR6CYRuRQjvcdVdEn
         okUxIE9SZ3Tl73cykKmGpLvlyuEnli6kpB+vgD8Ik/W9y8LnS2vshNfkVW24eSR0CcLt
         Wc7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487449; x=1747092249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FePGOnuFMFKSpyGOLnQnHaWTz9W0KMamhZVlYN31tfM=;
        b=NDfr3gKtJjW9yLWtOLqDwTHz65RRH9bJYeCmBQzkzIBZUjAwXtW4Bi8SwEujl7HdVH
         VXyfBsjEQ9znE1/CEROqm19VNsDIZ0xSHQT5FmhqfN2INFTnqE5Jyoe7vW19XrHwqxzY
         eQur0gKDtJmC/Tll0yAzzVfom9aToYpZSyJIPOxbfNsAoyfnGG3cGDXi4HaVeKRvbJ+Q
         ytQpoxSuU71NFSzP27AnRR1FPRsGq6wmUid++0ca1knXr5Lwr0KmxVt6fxC3nJ60CM7g
         2Rep45A4tnxblxBTwgeKLjcDwD/+dm8RJ6xX0XbUGmcv0Bjp4rwgUgEExcj/dUKXh6qu
         +1tw==
X-Forwarded-Encrypted: i=1; AJvYcCXzyXcempnV9LdKmTSXyZ5zU2J3BAWwmTJkoWEfuf+PLEfVT0RxDyDFRwgtuOLSQqj9LXI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8rndHzYNp0Tlouah6QqmryWPGHBHHJ4KPsECLwTh0a19yONjo
	vX892+ZEbQXrPp5d0gp1mC7faPxRG8UkflaxiWZLgNPicPNXUAaQtfHgIzhFkCg=
X-Gm-Gg: ASbGncsKPJq7CxcPLTwCUNC2B5RyDI2uQUwsuVLuNEfXM0+PT4TgPAjkGkdqOcHSqfs
	Ltqx8iet4iS/6RKWQVbWdoQ+r7HpDb6vS3ZFPVt+Aj0X7/JjkB2DpzL75VBiXNgtYdlsnXXmSJV
	v5iRoa6JAieBwlNoHbSSHjxsmha8SWGUekIeGthIm1FsjflgWkTyWHA3Xax4DJQhWOjx+Dm8H5c
	FVU7FXgiwf99BN5FG7/BYNvV4BVOIDf8N3rxJlDpMgoO6W8PyXgtB73LsMVMgxE7JTw1YNKicLn
	DNQtO6nzCv02y1I4+/dCmc7tHw+PlCyIrNHK4cR8UQYmkqYiJc0=
X-Google-Smtp-Source: AGHT+IG4fx0CvaAjKNBoHndxnHIoiD3HJu4nruhwtm92fod++gF3qwZx+wAOg50uRK5w+IBGupV2nA==
X-Received: by 2002:a17:902:d4c2:b0:22e:2cf7:c677 with SMTP id d9443c01a7336-22e364b6de0mr10842955ad.47.1746487449067;
        Mon, 05 May 2025 16:24:09 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e16348edasm58705265ad.28.2025.05.05.16.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:24:08 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 41/50] target/arm/tcg/vec_internal: use forward declaration for CPUARMState
Date: Mon,  5 May 2025 16:20:06 -0700
Message-ID: <20250505232015.130990-42-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed so this header can be included without requiring cpu.h.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/vec_internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/tcg/vec_internal.h b/target/arm/tcg/vec_internal.h
index 6b93b5aeb94..c02f9c37f83 100644
--- a/target/arm/tcg/vec_internal.h
+++ b/target/arm/tcg/vec_internal.h
@@ -22,6 +22,8 @@
 
 #include "fpu/softfloat.h"
 
+typedef struct CPUArchState CPUARMState;
+
 /*
  * Note that vector data is stored in host-endian 64-bit chunks,
  * so addressing units smaller than that needs a host-endian fixup.
-- 
2.47.2


