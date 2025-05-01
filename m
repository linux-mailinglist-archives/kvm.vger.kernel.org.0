Return-Path: <kvm+bounces-45048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C906AA5ADC
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13DAA9A3B9A
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6476527C164;
	Thu,  1 May 2025 06:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z38ExGk3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1273927BF84
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080651; cv=none; b=ZsAFY3bWnjkiVjzqRiETLsNPkmDgUL98/v/1qVFDkET0t8uxh95eOgwXP7OMFhaypQ80NTuFM1wy3IRjeKtLVeuoZawtIXgc5bGoReOUCIGm8ZsbRk3fWoZDIgg0PLFedv5aMNcvLB9Kaf+dnhnQeFI/jPtQMkcpqcA8UT4KNow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080651; c=relaxed/simple;
	bh=agxSHqt216q97tHE5kaHJIXtaVkgzls/uZw3EXJnmZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOSH8xqwk9CNHQ+WdptYA0sXmMPr8/Fxk3vMg8FaJKI2KKRyEOAVjlVPUmyFtdGGhx62ocy+Cfj1W9LsTvbpjG7UNNjZ4BYSiPROR6F3WZAgTw1Ldlnk+T1P2JD01II7ppRNk5Nve2HovZ+XFPMDU+adS/IwJ9/IShWB1yx9GSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z38ExGk3; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7399838db7fso756373b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080649; x=1746685449; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BaxN1Wnwe73nlXtsILpKd8Zw9LObEA+fWJ9HYaRv6lM=;
        b=Z38ExGk375MJCVO7uZIUzlLNqlCsGGu9j3ArTj5k8N6jnYeiXtYnHPyGzyDNV5g3ie
         wUECSxo7llr+y/V269KvLKHN6FWmbqjGfyD1S4awJCGzhEVKCXj+0R/6icwe7eJ2gl1e
         phu9C26WPbBZkLTkwh+5J7t4my9iet6wsLo7y5/fb9P0bmNtnr99PoSIAaQa8/rwIeI8
         gNzidCJshAy8UTakRcxk+7GAlPvK0jxC9pjYrE3uMQLCtvlC4aJG89GUAenf3NmmV96r
         VHppFpkBhxbgmoIRa0mL/EkdeEI8kJcuYoxTprMtZK8CWjQFX7yIEAbWVlOIf8CZ8SEQ
         cVMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080649; x=1746685449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BaxN1Wnwe73nlXtsILpKd8Zw9LObEA+fWJ9HYaRv6lM=;
        b=DtbzpEYBTbtBBhoSd5oZpT3uqDT5BlAwdW/wowX/Yz3XN1tI8xijgjJPIc1kIXNOAI
         dtSg/rHdm24VtTgrDq5XaJHh4IUotWWKLd58iRy6FJGFyyib61MsItQR2vmS9IQLBYUe
         sdgqBHHDox6Tz9OhmHllKzReVeyvTBSjDUdNNodpNYpSsHi3TjvAO9/1gimCgJxXBPo8
         xsVENrsEcunQv/bX854Oq0KIzk3sjKsKC1gULV65AaekdbzbuBnCMoaZyLUHpqAqP81p
         mNEp8FgNMWYCn2aRltGuaEnENoTF1MG/GHsmXs7Cpckr4Q2wdV41MGfZpqo7TTOW4YWW
         g6MQ==
X-Forwarded-Encrypted: i=1; AJvYcCXU4gHkR9ZP6cxn+FzZXGJ7sJnIgJGT3rSfgrtSl3f6D5ShuW8rc2x0IosmOxMhOqph5A4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yza0jxGZ2LKLf5aw17p0r5pj1FHlkAGwSl1lZtJzE+3VWxpPvse
	v6E4GCJc5GKmnp0gg89Z6fjKdVmmWzYe09c11fdkACFIyfwzV16icg8vciS871E=
X-Gm-Gg: ASbGnctr8In+7r3eGGQJsj2v9Mj3MFpqpv2QJankDF7L7kQbVqcWxjJzMUj+5LkgZDI
	QISeTJw3Up0+7mAHVSUhdoBoXjR7OZWtlzmX3ZYcLavGbeqmSd8sxuycjcWzn7JZUgEjHbV+3ry
	QQdTXnCeCp+NCtdVocbM9ECQdg/8sldk4nQ3w0MbHwb6qhKFdoNmXIzjysX4lLDg1I9UZm4jP4Q
	ZbuJNqITsenzvE5CgFdoskYzWVfsfLpRIh5Hvn7cRK2gzlpV/HNCB8pCPKDbPWGGGQthj3rBU5J
	q/f5mpWiQJ+AS/Ve7Qrn2v4ol7gt1c4HeSk9sLXN
X-Google-Smtp-Source: AGHT+IE4Xqp2t/vPNxcm9GHqM8zO2cSqpXtBFOyo1i51a7Px1LaEZe+L/FgMGOOkmgJ2scnA9wDOsQ==
X-Received: by 2002:a05:6a00:e8f:b0:740:6f6:7338 with SMTP id d2e1a72fcca58-7404917149cmr2440508b3a.3.1746080649301;
        Wed, 30 Apr 2025 23:24:09 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:08 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 20/33] target/arm/helper: replace target_ulong by vaddr
Date: Wed, 30 Apr 2025 23:23:31 -0700
Message-ID: <20250501062344.2526061-21-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 085c1656027..595d9334977 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -10641,7 +10641,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
     unsigned int new_el = env->exception.target_el;
-    target_ulong addr = env->cp15.vbar_el[new_el];
+    vaddr addr = env->cp15.vbar_el[new_el];
     unsigned int new_mode = aarch64_pstate_mode(new_el, true);
     unsigned int old_mode;
     unsigned int cur_el = arm_current_el(env);
-- 
2.47.2


