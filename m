Return-Path: <kvm+bounces-45332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 12760AA841B
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F0DA7AC436
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110871CAA7D;
	Sun,  4 May 2025 05:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UWFHJOK7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C162B1D5CDE
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336596; cv=none; b=MazzBzqHw6aHSsFzmPOu5bS0KiIXIVgKUHndQ9HSYjUvJ61uSz/Cuz/rujYC+fW95FusipJdIbN79+0WazlEMFAer/ehJYLDon9Ds+mlMs43MepRULfprdIwgGkWtv1LYSrBMcHF0iL89bcV30NzfRSByUFL2Edt83fQhVVOf1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336596; c=relaxed/simple;
	bh=Kjqzo2SrMiuHnTPgEQWry4cti2B6mx/aYScQLCzNOKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gP4exksi5dmtqsePRzrA5cFEBrQaa6WVpdhqlY7SHO/uxqN7MQWBJ+/j9QiCEyomILxhuQ4fn4deh+oiLLU0P30EeIFXA8F33bOALq4Pk5OI+flTxWF5OMBR77TC9yRBkSiDrPvAqFsvSXkHkOFF4FxHY1UFHGvwMTuXqK9mVrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UWFHJOK7; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-739525d4e12so3346375b3a.3
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336594; x=1746941394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L0iUuajRF9Ju9HAVblTOBk8R4VBHR5p055b5FK0U9oc=;
        b=UWFHJOK71oNL/0RquWNTVRYB1V5syUn4KtI5YQBKvWmdecMhQyIgFOPAvduxVY0oDn
         kCe8Rf0Rf8/UsoEzPx9TeWzS1XiOlLFVofA64+Eg/y9z5DwCNurKr5YUq9O1hWjbxaLB
         Z+5uoSyC1fBbzY9+jKX/GzHt3rgt5dBBmRFg/iL5PDlhePPvCYxn+GnzAO4HIduF/gya
         On0Ta6C8+fok3dx68Iy6CS0SB9nWwiL8cIlxz/sf2CBCTPKC24dMx8KAEmVB9hOKg/Pg
         1zHWd6ir/5/XTvp+jf0+4NZZczk7on81dN2Iv/gPZ+E2xid1BrgxZdVvbzVViznCn18z
         G0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336594; x=1746941394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L0iUuajRF9Ju9HAVblTOBk8R4VBHR5p055b5FK0U9oc=;
        b=vOoB9/KcHWxMQ+a/OgB/kS5PopZzeMU+M335clYEsYLsQRg+dhHmVjdcx6EzIAQ2wp
         cTHobJYAUui6YYn8qoP5BoJYqyVRPYTCSb0ZfyUCR2xaoAt344fzORUdhcm7/v0FUFPr
         YIVYCQSRd3Y70lCZGwxj4ftxbfuJVm+qJmcI+udTMxOIGd5k28DaWBaLb4liy/gg0xFD
         Iuefq1eWZNPIY5jQp7r/BL7WNzs0vOeSd+9jAaQQUgWabQSAht1TI7ishY2awjJhbVTR
         pGTAj7O3SQInCFCKrVfQfBr6Xs1UdBbXsX8grHuWZpFk/TOT+un0pfD5ts5Z1LhpE9VJ
         PeBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVudJuN8AdHNf5QvzZrv8m8Q76q67V1tmqC+03dH0DFX509hfZa8ydxWqWj82fsTe9SE/4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz92jDBohWW0pvQ1AvJLlLKCVOGYqqspWMDvh9J7IWYcMOkzJQ4
	A56yORJHmG0WDKzFwx4/aMomEQBRexH6m37i0G4QmpOA17UGUTfgZ3h5LyazSpI=
X-Gm-Gg: ASbGncss/YKKIiJuLoGKKgGzKdk334t/gkj8km0xGW8li7ALvSH5ThrKXVMgU+dirbI
	OC4WYnebywObx+th8s/2QgbB5kXWurlSrC36Pm0CcYxO6YCq6/ichTCix+3ZoED5alJZieUFefF
	8/p8jJZSWSFZ0pHSQ7BxJsRn27/FJIRr6HmXJaMWCDA6ag8iDF9UzKZWL5CbqsftR9f5ZYcATGV
	2PTejwA8AXKxWR23+eg+qUfD85hjg2c9oDS8NWQCUueGAB6dcGLMD/fKXB6FQ3P11QVS2L8Vklb
	20lyPZkCWE4V3drDQbgjhtkN2n3NnelsZ4Xp3+dFA5219frjY8s=
X-Google-Smtp-Source: AGHT+IF+EPugBKZQllOB6ZlaN9XF/AgCeG8gT7XrYMYc5dzrkZ7ZMMR4F0EEYWmv2FreUz8tb1cCXA==
X-Received: by 2002:a05:6a00:410e:b0:736:7270:4d18 with SMTP id d2e1a72fcca58-74058a568d4mr11150341b3a.14.1746336594179;
        Sat, 03 May 2025 22:29:54 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:53 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 39/40] target/arm/kvm-stub: add missing stubs
Date: Sat,  3 May 2025 22:29:13 -0700
Message-ID: <20250504052914.3525365-40-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Those become needed once kvm_enabled can't be known at compile time.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-stub.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 4806365cdc5..34e57fab011 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -109,3 +109,13 @@ void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_cpu_pre_save(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
+
+bool kvm_arm_cpu_post_load(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


