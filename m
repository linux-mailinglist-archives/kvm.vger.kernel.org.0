Return-Path: <kvm+bounces-41349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61C21A668A6
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B0EE3A910B
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C2A1C5D44;
	Tue, 18 Mar 2025 04:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZsApJ2CX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C611A8409
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273497; cv=none; b=taEa5L/bbvJ661n9emXZlsvq/ncHYhDWeYnplxrBKKD8CpA1WIF3DaKaQarEzglvEh18lTr3SiW53oxcHUN646HSGiVfAKwOJFMWxk5n+BrPpzrMoox6ChJZPC/26kdtq9uSfJXG7Jx6H8hwbCLb0STkbS5tv+br/jHIu8PDA0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273497; c=relaxed/simple;
	bh=0XNoLi343cKSJUwwhWz+jDoQYtdPX1ZsKxln9viXDb8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nuQB7v8ZDjJbcgfWQNdl9wq4mUwNpaobMN1tITcuRfZbnWbMSkaulSor0JYAW2Baaq1HgrkMJmpJeSixqpCivoSOp5ACsGK6Lz3f7DjATnJXFHYm7qwuzi0I5WOwLRjkweTn6EC2v2vZpzyXjREJx9byz5cXm9OBk5XKibDkkEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZsApJ2CX; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22438c356c8so89591635ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273495; x=1742878295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAWROUlIn7auIWdaE5em6TVb2NvztQjiLgpJIDrbZCE=;
        b=ZsApJ2CXib/tZOc0pn/ZlRCvy4LxHLpK7SkT+zcvHosdSZiu0jAOL9RpN+6zqHyd0G
         IhUhE6nAbpYxAY6hzEbu95LwJSH3EwAHYQIbS8wKRfgkU8Vzw2bBHvpto4dAqybUpg7X
         qRCBXvlt2L+C70yvDvygKr0KuIpw4CfVN6pUHMDO4mykUNRDQFMhUEaOhAGBFnjoc8k1
         DVH55aHlci14/PUcrjmVX6PmDDUFddY4Kmv7x9lRa61LD18neENc8o5zPJ+0OaZO1HrQ
         rkZ0eEFn2fP2oaSS8vF53QNyDoZfvQB6u15scgiPWR1DmNg91iBYVVdBxXsYX8BhSpvC
         lafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273495; x=1742878295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OAWROUlIn7auIWdaE5em6TVb2NvztQjiLgpJIDrbZCE=;
        b=dpLLiotGc+5+sbSiC3GFCda1nmuBC/SmpZhXh/wK8OfIbYCTWJ8Do6tiaf20guYQs4
         xCZvXBlkxEsO93ny98gafolouUqzXCB4kvcuBB6Rt1u53vYg7QFzKLA2D0AusdkTU7jZ
         LhFqu1i0jW8PdcCYIBS5DG61SqeUzSI4qM6XyIirfIxp1iUdtSuq7jUTgGgvqmlFSeCU
         JQpu/uZpWkbx74W8J8Qs/PFG+rvR86OekRRg4Up2bCxrFZQhOYQYtZYQOdlH/BwJLUQm
         Z1wH2byU3hG69iWOhazDBSZPyeONR7u1oLvL6ON23gl17HzNxYzzDfcxZkAvUFzqIOMV
         FY0A==
X-Forwarded-Encrypted: i=1; AJvYcCW5UsXvLftvNGyc4DPDxvXr0OSMdJu6JsQo2SDT6ze/7WzM//1gFxXrIROX5cGP+xcg+CY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1YiRIEDRpZEEJtIX9C9xNiPMc6kBuQUY/RHgTentHHOKH4azO
	gaZPxHz8xSoUGUSrCvx0mHfRipDhe6+Y68H+ZzF7yUFobus4n7TS3I2/Xetmsl4=
X-Gm-Gg: ASbGncuUE6E3mJBxYwJX5R5UYceSUcPPtuQs4Wj8077QsxilynvayOCJvRLss8xxqbu
	8e4q71IBOmsfYFfV0/gp75O2xXJaYINjkdLiBzHO2NzCFV2ALE+kI0mnncXc9etKDzLO7TMgaL0
	uWIGO+F/AQSUOEVEBM8hLO9E3pt1ah25F0wLbr30CTi7rFuAdMJtjXmXmBg5sW+kH9yhvcczoHF
	6aupQeSxLMt1UfuwYcCq+97Dr31deKtCVuK5JBgGkDKTQCUiMNNWVw3G5Nhtw5xoKLCehFcxd8G
	Hjq0uIvvq0LBApksMWcQtyBSwrFC/0tfexN0jj8Za3eB
X-Google-Smtp-Source: AGHT+IEt46y/1QHMt9sgoOzblTQOO/Vh992GC9mrguK0N9zijMCVTkkxREI+0zrgLP1cwHkaSo90Bw==
X-Received: by 2002:a05:6a00:b95:b0:736:3d7c:2368 with SMTP id d2e1a72fcca58-73722353269mr17764448b3a.7.1742273495053;
        Mon, 17 Mar 2025 21:51:35 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:34 -0700 (PDT)
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
Subject: [PATCH 02/13] exec/cpu-all: restrict compile time assert to target specific code
Date: Mon, 17 Mar 2025 21:51:14 -0700
Message-Id: <20250318045125.759259-3-pierrick.bouvier@linaro.org>
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

TLB_FLAGS defines are based on TARGET_PAGE_BITS_MIN, which is defined
for every target.

In the next commit, we'll introduce a non-static define for
TARGET_PAGE_BITS_MIN in common code, thus, we can't check this at
compile time, except in target specific code.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 6dd71eb0de9..7c6c47c43ed 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -112,8 +112,10 @@ static inline int cpu_mmu_index(CPUState *cs, bool ifetch)
 
 #define TLB_SLOW_FLAGS_MASK  (TLB_BSWAP | TLB_WATCHPOINT | TLB_CHECK_ALIGNED)
 
+#ifdef COMPILING_PER_TARGET
 /* The two sets of flags must not overlap. */
 QEMU_BUILD_BUG_ON(TLB_FLAGS_MASK & TLB_SLOW_FLAGS_MASK);
+#endif
 
 #endif /* !CONFIG_USER_ONLY */
 
-- 
2.39.5


