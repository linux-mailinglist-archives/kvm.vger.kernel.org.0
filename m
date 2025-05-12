Return-Path: <kvm+bounces-46211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB0ECAB422F
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77CA03B1E04
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90A91EE03B;
	Mon, 12 May 2025 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ruxsA6eb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ED62BD93A
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073123; cv=none; b=tONL1Ot9NICroojt0NA8UzKE+R5xQd1w/jJ33O3bz55RMcIVExuXGrD4XGy7a1FnhU4LDoyAdEz6oYWjlZWALmcy/FgzBNgHOXt5sTz6y5ryZG66Sg+ot/7LciueUgfO3KZqdgfWEhm5CMdouOAacRU9FolxCz+GF14reNwEDzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073123; c=relaxed/simple;
	bh=30HYw1I8aFdjg6SHuQTxQCRNvR/7AoVCDPUJgGhi7zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkSKvtTsw+SM6OfgXpupGf51y97gFcAyQ93kqculiWflgBigWnN2xhs1TI3rrcMdt0kCF0oTe3cKfmaZDlB0rrYt+qHMDc22bJazN4MphXpdJIh45oIItGnoYWMlf5FHv8a9KnQSpiwELLMIG4VDr3CS9LuZK1Aoz+sbgABZm/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ruxsA6eb; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22e45088d6eso61801795ad.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073121; x=1747677921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mduWzGcqrbCCMCYuVdtTD2ZBid0+LWN3eUl0cLQ5HO8=;
        b=ruxsA6eb0qAIUvxjw9cbqxf6L6E4qTyUeGme6aWkI5dT6mGsIp82VWGE+zxoUA0lcu
         ZI3vkgnTUXGC5SQ7V8cmgubUfftorsJbAmS537Q3EAUhV+gGtRvPEtfiUJZXKzgqlvwc
         ztEOKe/16lxAsOQBS5F1DsKcz237UwR8GRXy/Dg+JlMUDA6w8aQwkCUkGHcYneQt2/6G
         HP1keipYGLWt4B7JFfjf+gk4UT7GSeejEn+HQfA9IVQ3OZ3b0aBFluVRQuElTQ0fnia8
         GBGliihIEuJzxDSC2sCEZmgYJAo/Q1wHnosdn3kOpnZ7HBgTkduhtDK7Ersp6lE7+Oc8
         AcKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073121; x=1747677921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mduWzGcqrbCCMCYuVdtTD2ZBid0+LWN3eUl0cLQ5HO8=;
        b=ihpJCEOLVMSdYq6jgP6o4NH5r7e/wEh+uH58847v6u9Dbgvc4q3XJyyeSdye+sHOzf
         8jZ30GKCOaUI75Le6HZjHrbZ7rDdIMIXDONB6AZTDj/U5g3/yAtrl0TjjBgppA9q7YZ1
         lblWChGd3btX3feWw9fWPcmBgJpMAtrPgjy7OvKNfC3l/SqzzlDS4zStnT3sUFJHyDeH
         3gtGpao8iK4ZsL0qGNBolhPi06kl+Cm2wFvtkY1PABIDXbhjI3jiNkApD3n4xUAJdwmN
         MdoCxIfh0PCe8W1Ktma2ShbkkVpg5P3IfBeRY5qUF3mfXYnh55bIKMx5bKnWnM6mQL8m
         C77Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwuV0nsZUoMbq4EOSKAvo1M7KWGycMdQ6x5l3XbMIYp1WJL4/7Hw6D8AaejLl8ezNrp9U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ1thaW2e5sm2xRE5sOPrlSPk3fx891RT9EYiwgnMJ1zYfqg9A
	ERKM20FV74fQ2YUmpRldDjhI31euXNueTQM8e7mxSoxp2XRYmDynoZAH4wf8EyI=
X-Gm-Gg: ASbGncvJugSWEZlrx1BLHwPmr5o9sHY4RZgoH9HrryN7iptwJgIKzj2QvUbEPS+UYkA
	hHd96LeSO9zvYXjKqlcOM5W8vpp23/TugrJ8KXqhjfXyhwo8SrEwVlX9EHbTd3qys3O2aH2YQO9
	MrRQ+9gDnWyVO2Uul+rLbX1wM20lN4LX5Ztcx1X5gi/wJsW4YTW5ZL3BwUo5qqBSRAeTrYLbYsc
	AUTimZ0Gz6sKGQJcRIgec5VwNDI2aKGknfB91+7t2eJQqDLywno1U7hybj0xy/J5tqCPxIIlqqg
	f2e337UL8AondbBJepMTRGUkdXZPAvsdGKdhjawe1FS08WFYvm4=
X-Google-Smtp-Source: AGHT+IGQ0jT14jyzTd9oLZJ5Ff9RHlx1LDHlzLtes2Wc+VS1ksOBLnpI4eSNg5NipXT2Z1Fqyejf/A==
X-Received: by 2002:a17:902:e810:b0:220:cd9a:a167 with SMTP id d9443c01a7336-22fc8affe60mr200210875ad.4.1747073120819;
        Mon, 12 May 2025 11:05:20 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:20 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 10/48] target/arm/cpu: compile file twice (user, system) only
Date: Mon, 12 May 2025 11:04:24 -0700
Message-ID: <20250512180502.2395029-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index c39ddc4427b..89e305eb56a 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -1,6 +1,6 @@
 arm_ss = ss.source_set()
+arm_common_ss = ss.source_set()
 arm_ss.add(files(
-  'cpu.c',
   'debug_helper.c',
   'gdbstub.c',
   'helper.c',
@@ -20,6 +20,7 @@ arm_ss.add(when: 'TARGET_AARCH64',
 )
 
 arm_system_ss = ss.source_set()
+arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
@@ -30,6 +31,9 @@ arm_system_ss.add(files(
 ))
 
 arm_user_ss = ss.source_set()
+arm_user_ss.add(files('cpu.c'))
+
+arm_common_system_ss.add(files('cpu.c'), capstone)
 
 subdir('hvf')
 
@@ -42,3 +46,5 @@ endif
 target_arch += {'arm': arm_ss}
 target_system_arch += {'arm': arm_system_ss}
 target_user_arch += {'arm': arm_user_ss}
+target_common_arch += {'arm': arm_common_ss}
+target_common_system_arch += {'arm': arm_common_system_ss}
-- 
2.47.2


