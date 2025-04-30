Return-Path: <kvm+bounces-44932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7160EAA4F55
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 17:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BCDB9C569A
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F8A261593;
	Wed, 30 Apr 2025 14:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HNtx5R+p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CC42609F6
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025142; cv=none; b=JifZ+dTFMBu87/Jsrex0m4nRGmUpQkoQLUstnz40BvN0mANQPbTJqUl2o2iIxFDZWkTW83jM2HkB/z2CoQtsKihCmhtBDHNHf0uy/jblxMK6yqxihMl+qP+wcIwOgPc10NN+hgtz3U+fHtpMfrAbCpGWr90Y3gpvBUtIA+CUZt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025142; c=relaxed/simple;
	bh=L3RK6cazlD+4isklQrUjoRwmR2X9C06dPPYneBTr45Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbqLJ4R1jqimNf0jmM1AGRnKHK7+m0H/8CZs2kuXr5Zr5ZcHKhDRNIhRHTpaS3808qi5OH/lpKF/FajUPRWPlVVlRfvqsjv7pO8V9EeuY6SJfZ8HWeU1Yy4G8ZPuyf5ID0p6mmxAs+81EzLYmUr9tkalMgGsEGsj7Iqi19at/Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HNtx5R+p; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-af523f4511fso7214401a12.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025140; x=1746629940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k54PyA3qe+UbX4AzHMockqDzIGWdHV1GUXIbKPo2M9I=;
        b=HNtx5R+p3m0dw/pL28fD0Y44wnhjT7lWxyNS7MSmT1Rdg9Wa6pofECNG6NAKeG62Nj
         RsmD34vH8P5B+8EsknfyxWewwJMnGDZBHWDSY7xBIOZ7O+DSi03wHbd/kZhxYsIJ2nwi
         a0PKl8768DR5GRaKGzYfJ8tpThaTuHcUj0G2T1f/HPFjid7ASpgkR9DIvGXPyMdQiwbD
         ujypDwy2wZcEfCD5qtmYOEmwkTqO2bQPiNdc5P2R6QaQAaMsX6WRMv/H7n6kQa1iGxy5
         Ld/oOfOEJF50GYCnad1Kcyw1McdPUlec8H3xDaBVAJEIxNZ2ehs130MaiHWdPfoupuLt
         IDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025140; x=1746629940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k54PyA3qe+UbX4AzHMockqDzIGWdHV1GUXIbKPo2M9I=;
        b=X8x82y/W+lS3UJ+0W/iHvE4u/5lwafhgdNU5Nx44JLkZAI3OC00A/3F1govPG2I7vj
         gAUS/bJw0yNYy+smf7Oof/3rcaZtosOsRjyRIbtMxhXdwF0cW1q0TWwL+R8g0HCCahBi
         KiGGbhre3OrgEHGowGbZLefRKaPXubYnNpkrZ7xvAghBAr/LF/j8JHj2a9vrLqeZWPS9
         P7yndyW8O8wtYu8/MlG1HAsgEgIBgz1QvpORaEwwVAP7hMsfkvuiWRV5nZ9WOV51HOw3
         VA72vcCxTTA+LxRz0SkUyh7Ypa6Jupy+YY68LgbXkZ0nSEPsGjKMrAH4OSEotDN4lZKf
         o4OA==
X-Forwarded-Encrypted: i=1; AJvYcCWdJWSK9XhpMOIp91t7IS/SEGlRrHhVRhIzChqVvvo2XbJOya0lFpoUVwFYFX+g6N/MD48=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKMiRNc3iltlsfXYamdF4/g8+mQZCTupz4QEnp4g3YwTjqF/Wl
	thW5/W1g+mxUUNkks7JgporsAenrnYpmsDCP4ixKG9ycRgE4q4abbSpHj/EXJ+Q=
X-Gm-Gg: ASbGncsnq4J1nkPvAefJLIExUNANvF8fTCYb9cBNqIeyGTbRaXNWgNeW+9z7hd7EaTL
	QMfZvY7x797+a7/y07ZyDYojsrkXTxjnsqbouo2ZdooNVK67WOndzECHpeQ71VbYCWCoruEAu6I
	Ct3aPya8OSSXs88dWGCa5VOQ7XWUNfMjlSEa9tmBMLY1vV0GbwNqEeuc81W5ozynkVcMGaTaRuU
	RTnZIctLr8+XA1snovzqpQn52HUPorVxORqDR3n566XOS9/tOY/7q5llsTQTJuj7l90Vjdadz0D
	EoCpaKbybApJH4q7cMcJjLbrHAFCk8ZkvZNN/RxI
X-Google-Smtp-Source: AGHT+IGmjmmRsSFucpW6qri+F9auxx0+hHGSx2UjPDyii+qX2/kTJTo22ZL7wgay9LB50sdG7A4YsA==
X-Received: by 2002:a17:90b:2644:b0:2ff:52b8:2767 with SMTP id 98e67ed59e1d1-30a33300e3bmr4611242a91.19.1746025140211;
        Wed, 30 Apr 2025 07:59:00 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:59 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	richard.henderson@linaro.org,
	anjo@rev.ng,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 11/12] target/arm/cpu: compile file twice (user, system) only
Date: Wed, 30 Apr 2025 07:58:36 -0700
Message-ID: <20250430145838.1790471-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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


