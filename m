Return-Path: <kvm+bounces-41350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E884A668A7
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:51:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A78EB19A2544
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062821C5F30;
	Tue, 18 Mar 2025 04:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="btfCs6Dk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36141B87D7
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273498; cv=none; b=Fwittn7Wm806YMM5TK84lMOHJr6hIo2G8saSPKh3CtYKazxh8Y/uboJEtp9BrjxL2S3aBN5ifHwOpLQUac1B3l1/MrTy9gyn3PpHSb9IMG4OIRGbtoVt6WN3jb0NSxpMajQZw0KkC6iXH9fIPMT8EhQaVAwEUqsr5wUIxbmhMVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273498; c=relaxed/simple;
	bh=koOePhk4+szypPcCLvagB8jF+4HgkO7+nLo/kOSwecE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IyyPFtmAwpvm4TkCrV0ciC8ptK782Pzo+qjdkuebVkN5lhP4PYX+gBDy4FE4tJzehJH+uCvuq6nha3XBoQyD3Zu9Vx9pTnPdMcF26rnwODRpTUhMVnBXY+2dhCq+7TgZzIUBawGCU0LGSESxZ1H76yHoCSpcuNRBv9BY2IrH1nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=btfCs6Dk; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-225d66a4839so63037935ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273496; x=1742878296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7b7Pa/XivG7M4hjK9jqso2S4d+dz1DGry6GtvIR3C8c=;
        b=btfCs6DkaGIKiqz2EOzWoaLlL0ByZyCXQxbs8wzMl3ZN4CJqoMxuap9xpuQwHIKKz8
         BBSn8ptYMPufFARUjq2ij4pD8p0WlOfSEjvXPl0DuoUvBCuMaC82ZAuJS0+PZEmXZW0/
         86hnRqQM3RAPg2ES+xUKECnWeSmWoLtF4sIx83oPXwWOTwEEL5NybL5e1P0J/AD9BhhI
         BLqtjdxm+UF5Z38RvUwW97AihK0WfwvQ0JwxuioyYCJv9bLLdod3vnewyQC/oFp4eWAT
         EXcZ3d0nnr04F/6N9Ha3gJj1J+KCpk1mYVO9Hzrs0N5C3GmsGfXdgb2BLZuT7Q2Qb2/8
         uALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273496; x=1742878296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7b7Pa/XivG7M4hjK9jqso2S4d+dz1DGry6GtvIR3C8c=;
        b=Iay2MM8Mw1K3ODMbK9l0Q1hhnuEPO4x5ltkJ9DxYxFujm2i5kmDlAQC5YDWc9hBgd7
         8eYrgyAKMXfSJ+9hS7ZU44Qk6WhFOxlQ2cJ3HIYlTcOHrsCOKw6ZKKb9VDg1FfDulsFt
         81OlWYUa9nSijUNQbnD4z74LhtE6TVLkpU05jcjgdndyMr9xz+9aKeMxX4pZJlaUv4mK
         lOwMa3YJwILCyZZZ1UC2hWlpPK9nU30KClFwDGQVMGBnIGxx8kVV8bk6gJhdCSMGTsEL
         6M62UEXc6BJVRbXArkLZ6IRkYcgkbttqKrxg6wYVT1cOGw6sXwMJeZMljGTTgw6CjOBe
         i/Rw==
X-Forwarded-Encrypted: i=1; AJvYcCUE1scIc2mSmps/5N6qIICl80z6EZ0URlFRYhjMG9g5xraaOVkNotQZtvYqC51GB4h8rwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvskJBGnuCP2B1msChHUX9Z19a/FuJzOYaNiMnEdgZspMgnOZS
	nGZYxuDWNS2Y+bsq5rE2PdAfpicLEa9k/r7oUPSQHQLPOAo9UeRtPVZW4JcexIw=
X-Gm-Gg: ASbGncuGzTIYSof1lmnjyiM/A1omJupFmauj3t0cGdkvRNFtHsr/bOrCLSj3qrHLtQW
	fof1LdTSlp+cIPJSgbziW2ri0lgAb63l2wUmYTpXlqwFmvlHkb00JzAiw5NrvMVLD+meNqmhr40
	kPpS0PXu+PEKtj8WKDi+ipGbkWzkZ4Rul9jajtFO6FzNDR5hjlcs2FetufuvpIbAf3nLIrPNz9q
	4jfhsNsye3kPSDvfyxaYO+UzEqFeIlICfU2sXQlPfWNtHGhNfl0SOkZlMiXIYXiB7xia1K3HB3T
	MO2hB86YJxcDcvK9xHRRP3zk6N8idPDJYMn40wZQxV/g
X-Google-Smtp-Source: AGHT+IGfy+Qdd4zIdkaKpSIgsiwDKH+mdyBXjzWe2NY8Kt3gZWsIWhQbMwLpqie8RWdAjPyywqbjZw==
X-Received: by 2002:a05:6a21:1f8d:b0:1ee:b5f4:b1d7 with SMTP id adf61e73a8af0-1fa4f9540cbmr3123721637.7.1742273495989;
        Mon, 17 Mar 2025 21:51:35 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:35 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 03/13] exec/target_page: runtime defintion for TARGET_PAGE_BITS_MIN
Date: Mon, 17 Mar 2025 21:51:15 -0700
Message-Id: <20250318045125.759259-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We introduce later a mechanism to skip cpu definitions inclusion, so we
can detect it here, and call the correct runtime function instead.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/target_page.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/exec/target_page.h b/include/exec/target_page.h
index 8e89e5cbe6f..aeddb25c743 100644
--- a/include/exec/target_page.h
+++ b/include/exec/target_page.h
@@ -40,6 +40,9 @@ extern const TargetPageBits target_page;
 #  define TARGET_PAGE_MASK   ((TARGET_PAGE_TYPE)target_page.mask)
 # endif
 # define TARGET_PAGE_SIZE    (-(int)TARGET_PAGE_MASK)
+# ifndef TARGET_PAGE_BITS_MIN
+#  define TARGET_PAGE_BITS_MIN qemu_target_page_bits_min()
+# endif
 #else
 # define TARGET_PAGE_BITS_MIN TARGET_PAGE_BITS
 # define TARGET_PAGE_SIZE    (1 << TARGET_PAGE_BITS)
-- 
2.39.5


