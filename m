Return-Path: <kvm+bounces-41917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9FE0A6E917
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:02:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8026516917F
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C271F3FD1;
	Tue, 25 Mar 2025 04:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E+/8bbcS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E131F3BB4
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878789; cv=none; b=nhtrQ8eJX158bGgENYKXd3IH7XoQiPc4f2V38GUWBhgYRClr5h7H31xfdkPitlLhDbNohhGoUC5JSdxTHO2z0CIPKeyYw1SlKeFWt6jHxopLxaMksnbrEWMPcHcFjAfkhdlJTEu1+nYBg0hmY3hspyTlBLn2hRdjIn1HYGk7WZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878789; c=relaxed/simple;
	bh=nBO4EV0/Xwx5GfLXso0SJkETPTUhP5OWgRw8r83QcK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NpWldbdkietsvkeCzE1YjHNBb96K1B6sJhAFNuepLr2GdhTGzHUZgsdxXtSVPwc6ET/SiNKkMwiGtlrJfHM7gf4Pkb5Xb3E40FpEWAFdJmLKcbZRpM6hleZ/5UnG01uDWgU58lYVq7qMNndV9ejB5axAu7eQ0HN3L9KFI2D1dLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=E+/8bbcS; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-224100e9a5cso99106905ad.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878787; x=1743483587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CSiomrkJehve/L+8sWorbqlbLNaYCEo3w/Nkej8WFsU=;
        b=E+/8bbcSNo+L/1ck7qDqletLMLh3HYQnhCHwE2aOm5QeLrRt6Dh09LRGajaqOxmTmA
         mnrS4If9sXiP781nh/vZFTrMhpY9PDJ2Pi07JVE3GIodM6o1yuKRSAheBVLL1rw/kCFf
         iRTHCcPlid8SLmexOlfUgkwkmdJS0bz5xC1xrQiXvEhF79XC0Dc40cyfrsH5SQVqEsNv
         D3YxPmgg2sD9jmyKaILYVUlAcKCAVLPH78dFKRhhsWkVNNZtU62gNd/+WNzGPdn/6NSP
         ZHhobjltkMI7ylttmeyzL8zsDTmT5wHH2XreLb/kDDHb9gzVJQ4rClx25hyKO5cuNfcN
         hMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878787; x=1743483587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CSiomrkJehve/L+8sWorbqlbLNaYCEo3w/Nkej8WFsU=;
        b=w5ukMKGKyyGzHiCpT3cRZFUncAFQG0ey57L+LiLFhvAwA8reKCZEDPiX6fzg7c5tdA
         MeuCe/sHaRUGAEA1LINncNWqHi4PC8PHJRnJL2YpYuTnf+i6bAJGnoHR6wAeMIToYBbq
         FV3WiMQlu5yaVHx3mAqDW3ss4JuUR8/ikREXyB9lcIFuls8dkWuiNQMP7+nyWgRH0pZF
         dq1EBwiRahsRNA75oW7+xyzLWf9EEWI2K+WuZsqri13IaIekfDJRGPqgfhixVuIGFShd
         IFOeQ9UhqzmRQPNKKvak4FH/qsj4zg7W4NhXzNURBMPXOj1bOKFa1QTuN5WTrnmkdx75
         UDow==
X-Forwarded-Encrypted: i=1; AJvYcCWRzPTZ0JcBWNXKq1uniYe9Kgcd1LSrqd2ao8l+aQDPX5CKN5H9hq83zt3DqOuo5s44pPo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLL68lO0oJ6I2NFjXZZBHGL/XfI6a6dlpp4XjQcAFw7Declujv
	FO8XG8Bj30o+vISworggCdgFiE6uY3OP22Zzc2UbAE0Sgsfpj1drLNAY0z7LOWs=
X-Gm-Gg: ASbGncsIzBg+C/Nn5ypt6FS7Y5FYGGbwIWFUytc177W7cjsGiK0nLskET6Ks+S6S8g7
	v7T0sCF8UeYcAyeisa1e5Y2D2VF5PBJgoCN0ZpQNLAKriUAv3za/zfFHaOL6gdexkp48sW66Ftn
	xiQRKTy6/ZkSvygAOvD1GUefkxqQ8yk9hL7Kq/todJeWvXCKi/zoLY3c9JzMPqHTuKqJFx7T0D+
	wpa/r2bNgm2m8GmRoFIwFxGVZ2nYthhsfXTMMjcdLu37ypFpT+x70NuaSNn2AO6QIWS0Aow9Q2O
	fnye/0cELPynHS8xPmZpAhPPuTF4KI6hyKHDR9Wi9Zif
X-Google-Smtp-Source: AGHT+IE+CatLymkvFC6uB6GAY5APi0WQOW6EQGEeUyVT2LFSOsFWDTpOfPwIrlpBqEe5gBdtrM10Ow==
X-Received: by 2002:a17:902:e846:b0:223:5c33:56a2 with SMTP id d9443c01a7336-22780da6237mr279448325ad.28.1742878787203;
        Mon, 24 Mar 2025 21:59:47 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:46 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 27/29] hw/arm/xlnx-zynqmp: prepare compilation unit to be common
Date: Mon, 24 Mar 2025 21:59:12 -0700
Message-Id: <20250325045915.994760-28-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove kvm unused headers.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/xlnx-zynqmp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/hw/arm/xlnx-zynqmp.c b/hw/arm/xlnx-zynqmp.c
index d6022ff2d3d..ec2b3a41eda 100644
--- a/hw/arm/xlnx-zynqmp.c
+++ b/hw/arm/xlnx-zynqmp.c
@@ -22,9 +22,7 @@
 #include "hw/intc/arm_gic_common.h"
 #include "hw/misc/unimp.h"
 #include "hw/boards.h"
-#include "system/kvm.h"
 #include "system/system.h"
-#include "kvm_arm.h"
 #include "target/arm/cpu-qom.h"
 #include "target/arm/gtimer.h"
 
-- 
2.39.5


