Return-Path: <kvm+bounces-41918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51BA0A6E91B
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB5D57A3A9D
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BEE1B87E1;
	Tue, 25 Mar 2025 04:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hy8bZONI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014B61F3D52
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878790; cv=none; b=mVHUAhSK7esleAzJ4xbKpAdb8YHRpTFvZu+HsgqRYmidf8sICFXTkO+4bP528BGLdLswnLdZyIpbwYrRXhnJgp9LxbwtPG6j7kpf9FdPJ0ZzRAEZFvL5mQYtUvYurMzbJ3my3PyYo09QPPKY8Eg6XJZn9zDbEkAxbQhiTeXKHYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878790; c=relaxed/simple;
	bh=MVSGXLFvx/sQVHFNxyxpLkKNWvRwdkqd/YtDlQ3Tuwo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y9XEmT7LsvfmBSdy5MPW61fP1QUMePdkVQEnpAnvmr+d6Oc9QhssvYTcDhEdq9OEA1IQ66TRlcGzs5FU53xMvRpvpMzVWArTKRiRVRsrag4FfHTzf+nVaYenNQE9pNFwLLLKtPJmMoRc6QB+USApHyz8xkkjpW2Cx1HkXHEE7k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Hy8bZONI; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-301a4d5156aso8931831a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878788; x=1743483588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7C1awJz84K192Xls/S9mWSPpF8Y3H6ZCzb0fk03waGc=;
        b=Hy8bZONIIoTPsdDmDGXCa0B2cyC/Ed83/8BC3kSeJc2zTz1NVeDuIANe1ZM31hZPnD
         Uh/6PQuhOBZ5aAzGn3K3+5dSZ0MwGwV0rrL8fK5ShRjURv8Mo00QNE28K0Hki0nLdP7n
         4HlQWEUcT9hBo7qWArYJG739SDDKCODXMQENtd7hm5x6GcJGpZjI57mkDc/StaHUAXhj
         T+hwcb4nprYzzG3wJvWoolwHh+gGy6SKZfVBEA9Z3O5KRTFPmi40u2GC6L0awzaECEkl
         ztk3ehfDcxcYQIKzG7E8UAD8Xwx2wOA1r/EBr1RrN3rKA+OcPxqH9TvvDVMz5RTuNIJt
         x3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878788; x=1743483588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7C1awJz84K192Xls/S9mWSPpF8Y3H6ZCzb0fk03waGc=;
        b=no+myDIWHHYjH7QHM4fZMBufZCc4bGvAB8pUuOFO+4nyhRSQ6exi0+C/Dahy4e1RBi
         Towc5fh1K4Ixqo9IAPDFpcVxh7cDycEy1fuN+hghxLXMAZCrNSadL4n1nHDpxn0FLsAk
         tPGgf1lRwOzarcJst3MiiuN6WZpDMuRdwZrK4UgiPlTA9k3xA8x0ZWyLX4Vu66tR/BPr
         PZW5krfr7EahNU+bSR6dhxX3IVfj95R6c/OPh9EYD3L/weW/cLk9QVGA2pchCT9bsTst
         tmyTTrMFAyBsnoooJ5uUZJzcmuyQyJhmhtwsYjLHdqQJDewyzHPgezOX23Ems4LOhj+N
         Em7w==
X-Forwarded-Encrypted: i=1; AJvYcCUKc7F6tx12P6fxT8TwT6xBMygE88QBmTUtL6Lakw8Wq3wW23hhLj3mdWvrc+OKTJ80Ojo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Iok/CIHh+lGY6m2frzmwNqomVO361J+8tC18+pbBJ2bApfqf
	pZ/OiukgqYP7D+/kH00X/gi9XmiXUcXLhcreBtZHmczJDZu/JU3tutdAfeTlW2Y=
X-Gm-Gg: ASbGncvMMPiEBq6IN+TkdOSRU39sVSjVy3TV6vr3cFmHX0T13PTcYL8Nl7Z+x9Z3h0m
	y3giDeE+Mg7on2BEHLgoTICOyS2OdGGsSvrElEuRuPlt/Ssp2LMYQcqYoRQSK3G+E3fIfIMG+lN
	pSm+pP6rng1bAxs4zoaOfFDZ/2UTLXfJM8ClPlrIjCdo1VOiJZ4FI6y4sSU86TRGHRGl1EUOuwR
	a87JCM1AqNOsB0l15noP7MI5yHnMXE2s+cgSXlFGcqsjhef3PSEw5M58Bo4kktAXmOvKc13WSqq
	V/PCRnX0A4aJMWj8+ryIZWdK/T0YATJG3Ace07a+THGS
X-Google-Smtp-Source: AGHT+IHSXNPp3Q2e8oDSf/SNPDReLESf+MJRHhmLcAh+DyIr5z05CoANzbsKkecUcyVNZ39qvJN20w==
X-Received: by 2002:a17:90b:2cc6:b0:2fe:a79e:f56f with SMTP id 98e67ed59e1d1-3030fe9e9c3mr24748768a91.13.1742878788216;
        Mon, 24 Mar 2025 21:59:48 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:47 -0700 (PDT)
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
Subject: [PATCH v3 28/29] hw/arm/xlnx-versal: prepare compilation unit to be common
Date: Mon, 24 Mar 2025 21:59:13 -0700
Message-Id: <20250325045915.994760-29-pierrick.bouvier@linaro.org>
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
 hw/arm/xlnx-versal.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/hw/arm/xlnx-versal.c b/hw/arm/xlnx-versal.c
index 278545a3f7b..f0b383b29ee 100644
--- a/hw/arm/xlnx-versal.c
+++ b/hw/arm/xlnx-versal.c
@@ -17,9 +17,7 @@
 #include "hw/sysbus.h"
 #include "net/net.h"
 #include "system/system.h"
-#include "system/kvm.h"
 #include "hw/arm/boot.h"
-#include "kvm_arm.h"
 #include "hw/misc/unimp.h"
 #include "hw/arm/xlnx-versal.h"
 #include "qemu/log.h"
-- 
2.39.5


