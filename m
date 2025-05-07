Return-Path: <kvm+bounces-45785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B74AAEF6D
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 861A54616A1
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C611291175;
	Wed,  7 May 2025 23:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e9gQQz6p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744EB2920BE
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661383; cv=none; b=KZw71CJA8DC6rG1dKiNmKX+Un8kKEJhfVQqhNUYplNQT87iR6qruJqsb4OPQ9jgAyhP3KPjLbPZUvConZBQsNoF+dlnAneQfmu9GYpDBk+HJ3RIHuxJMM1Yv4T6DyVgimhdc5R6zDh/5YunL44mYTel7N49kkAoS9BKe6RY2PtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661383; c=relaxed/simple;
	bh=8vg2IZHqw2STpGB6ZVzzw4KpItNlLQpKc2XKGr2GKPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXtHawl+8zuXOYLIjsGUEUhBiFTl+ZHlUpF255xzIcQtQmXqLDpyOoL35nMZHi21SscD6DmFmkAO+vlfQJYeuqadTAbIqbWUM1PjirM9sdIVRbi9xPJPsff79gmaH/cTRAJgYHXAcXdCEZyn717CKuhrrB7TOQBxwNnzrPscPF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e9gQQz6p; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22e5df32197so5421365ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661381; x=1747266181; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qKk8/QkUIjT9lIUpEMWVh2Ot+bgJ9+GR50UCxP/rL4M=;
        b=e9gQQz6pPejVxI+ZP42ejsGqemR8hxCEHlUl//Rsp/4a2esDVHsLoTXEonbdbTpTH2
         bkDf3i091ptEKB8ZLu27tTn0WaQLmV4Zv5AwARQLDHUC0TLpOu5WTfFSLKgdOE+ievFu
         xM5i00ElbDwsSlOHSBMtyVpeEE9c0N7BrkZg+kTUS0600sofQewy2eoPt40jB71x8lLE
         kwyCKualH33UhX81NvvYrpwu1K0wDdSMoWRGlwLNpczr5d4G0wi3EHMO1RRo+NCuSRjF
         ZHm6DBNaRn8Ik/hrwkLE6WVBjcH8WHnx/mLdgnde9KkdhhVvFLxqLexgtcTKLwTZulZp
         QPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661381; x=1747266181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKk8/QkUIjT9lIUpEMWVh2Ot+bgJ9+GR50UCxP/rL4M=;
        b=rCojjz8Y97lFCrpuUzp17hohQwB1A+vxlNMxkP1nOoVzzSA6Ekq7NDIQadEKqJhIoZ
         km4fcMtQt2ZCI95kt37Vg5cN5RfSwow64ROH7lSyWQP5uCzDH7RvfVSTd92jkceUmKW4
         ArHa6M7EMJTHmVipDnES5uGg6U/KWzDAeOSe/Vt5pqYZp6AVmbkrqNL5deoJoFUZhwqH
         1NWlxKXSZCk+ftflXs8rMRSuM6quGfCf/YJUWeZC+oMOtDyDTf9pbpmmVT65a9PzKf+I
         7EaAeK8i5ePk5IRRM/tWxafcKL8J97W3OL+nTbxD3y4sw72z5qfs6tTVn86rH0MVepW4
         HmLg==
X-Forwarded-Encrypted: i=1; AJvYcCWy866peObVFnKKlvqZIwCWfW0aitF5Ewh0BcS/72mQV6LaJ93g5cwBId4VFmO2e6uCvJY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg8BYSik09Horzl2e4O8Q4sH3653BScA20Dqfm98BVR89hG+0n
	maY8FvrlIRrVLnRAbLYMjq7ZwxGUDyAEinkFIrdBJc3zzFPcaDPBjlfbhEldn80=
X-Gm-Gg: ASbGncv9lb1C+sUL3E5oO/4ufq+ANRa+KNPOmR/qY11RxCuUyOYKMIPWO0VOguFyNc8
	+HbeIUf+qY0Gi2mu9QBTAbpRvlSUAxqEkXiivRjdurETElq59keG9A3DpHzhLTAB/3IcEqFsBKi
	XaIcEMWxvbcWyDPav93vaae3ZH6zw6lkTEbfyjPj+vl6OD2VN2gy+w6ZuqZwr0PHVEaom7lGQZn
	u9/xc/7T/kAsTQx58gfD+zTu8lO6z5SD3Bfey3UIbxYnXmu3kEw2512Mfg5JzAyx3PNAwUudbiD
	Igx9m7uvgK/SditbqNLjagQCvHNxsdHUpX+6ftU22o/zhht3UCI=
X-Google-Smtp-Source: AGHT+IEtrmABkvFcC0wwODWJ4uGeFDWgLJSjaesR2JBWITN0CKAaHlEB2/gwVjupmJwkGzAEZulBew==
X-Received: by 2002:a17:903:2352:b0:224:93e:b5d7 with SMTP id d9443c01a7336-22e5eded337mr89643515ad.34.1746661380896;
        Wed, 07 May 2025 16:43:00 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:00 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 20/49] target/arm/helper: restrict include to common helpers
Date: Wed,  7 May 2025 16:42:11 -0700
Message-ID: <20250507234241.957746-21-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 360e6ac0f59..941fc35d24d 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -12,7 +12,6 @@
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "exec/helper-proto.h"
 #include "exec/page-protection.h"
 #include "exec/mmap-lock.h"
 #include "qemu/main-loop.h"
@@ -35,6 +34,9 @@
 #include "cpregs.h"
 #include "target/arm/gtimer.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #define ARM_CPU_FREQ 1000000000 /* FIXME: 1 GHz, should be configurable */
 
 static void switch_mode(CPUARMState *env, int mode);
-- 
2.47.2


