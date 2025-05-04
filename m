Return-Path: <kvm+bounces-45318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 450ABAA8407
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACF7617A0A5
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AAEA1AA1D8;
	Sun,  4 May 2025 05:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cECiFzeX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04581A2C04
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336584; cv=none; b=UY2mv8E3/uLHcKjzrY5QkFxtiIZwENxcIzFH/gUv3eSNGRwCGs709yFe/F/NvmRoeuKUs3LtOLfxzz7R9yZH9fH/PKzEDPxgKTsIVm6DfSFNvVk4gAHFU6K3o/O0o7G0EL6GKZgzYB8QeO2OKPa+ROuD3fwyrOuqGDFK6Z7XR1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336584; c=relaxed/simple;
	bh=0ND4mB9JS7urQpEVchws9S6EzmrvFhsdvB7VUnUD0HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/HlVLTYxLE2gDfHLtZZGD9Zw/ZMTQXjcd0SCtPMdbO1un/DCO7GKY/K//1WlS7aUk3e/f7ECSeql3TKtI5n5OGwyLSL3i+6BKNTkeCrMsKsEdyg0QffU9wQdHQIm32ls2fFAnv5Z5Ch+XQODnOAzgsqf4y/ACRKCAabhyc9VyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cECiFzeX; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-736aaeed234so3024275b3a.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336582; x=1746941382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DYtSZEbP1atLGb677pRK4UuiMz1CYlbqC5aWBJkLTc=;
        b=cECiFzeXDUGTNOVo7nusi6OZ9Fy8wMsQJ7nfew75KoNkYMOKA/Ye53kV2YMrlX+g8C
         jNKt4jR/immv/JOPYEMBRtODKHa/tDHcYIX1IALmCLHs0Tc2VKCXtpdRo2ZE0mTUhU4S
         4BCXZfffJBKhqetWfYSipjxuWRki2zltrUyuY0aTWZLLi6TNlaNn78raizKsTVsDGHuF
         e5J78dE9TKAiuujmuWIcNpePd+WNHfuVUUh5SNCBFvNMa/bLh78AqnCbOl05DDWSknb8
         izWOWH5ObiIkezbm3sGGs/CKF6HEvg21OmV1nSIgILySCudKkWrZtH6tOhpbxWfTlH+F
         n9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336582; x=1746941382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DYtSZEbP1atLGb677pRK4UuiMz1CYlbqC5aWBJkLTc=;
        b=m5pTEDA9Euj6ffrWb1yc6TJ6nRg1qKNHpY7cHra2jDq9LM6Ct+8ntx6r8PhHHCWIra
         5TsEvZ/rziJu9LP6xHIus9SZ3o4ofqAXTzZB9ymO2jiZm227MLkXpUotvdxHgHXpB488
         u4f2x33wt+A5ndwodvFiHbc6OJmCxgLuIrzphKgTNTCd/YpbrkBLcyjdwO63/BmE5r7h
         DMBd1iIxVztTRujIE5CKeURD5Ry3bM/0yC/P+dWQUO3zT0u685+i8y4rJfUIQqwfnoP/
         zuNMAjSphaakCcYUOu6YB2b9rhDYS/Hqi4JAVlY9JKaQxtMFw0q96EWgpdS4SS9BUv6d
         ur8g==
X-Forwarded-Encrypted: i=1; AJvYcCXXrDK0aTsORHQHJ8lW0xtKDvCUAnon+fo44AJXVt3Gs5A6tAGwOP20h0znHo5tvPpkUPk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywje2crfj6sJEx/HH4+4jstJC/CYv1ivbORIxHXRvT6CXdPppuY
	Ar/h69A0TkzwU7vLMx+Lsg34foD+UjY1W8QC942vo8+DQFmw+8QdKU+gqKI3+YQ=
X-Gm-Gg: ASbGncsUKtBDBMNLEluCJJdGfUOSOpD7K8v2ToKFC5UrWM9lLH9NQJUwdpFgwJ4ejG9
	utn9147qhzgDDOySwtkApeTV7gjebzvq1tgb7JfFQGlf4XSACmx5yFOWvoKvnbWO0u+baRKVlbR
	R0NTjH+a7+MieeQyiBCGLSPpe6BrjWPD8oLGzIyPJGdCLtzR0OFMYFxzGERzjiNrq4Vv90jdOt4
	ldSb7eSWd9VKC0ZOGPctu8t9s+kTQSI98P6ma3GjP91Z+oNNvxRD17pHgnvp46F4O48UFqCDP1r
	MQMvouyRcPX7ZYZ7kIIikMVagNrzHmFSnsOCdMTY
X-Google-Smtp-Source: AGHT+IF0vgFiMAHdZTdTEbIL7XDeL5ZCJrzUL1LmXrsR2TgO/FrRqNsHWu2PRmIMZQhJT89uq6uwwA==
X-Received: by 2002:aa7:9316:0:b0:736:339b:8296 with SMTP id d2e1a72fcca58-7406f17a52cmr4455342b3a.18.1746336582061;
        Sat, 03 May 2025 22:29:42 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:41 -0700 (PDT)
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
Subject: [PATCH v4 25/40] target/arm/helper: compile file twice (user, system)
Date: Sat,  3 May 2025 22:28:59 -0700
Message-ID: <20250504052914.3525365-26-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 48a6bf59353..c8c80c3f969 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -2,7 +2,6 @@ arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
   'gdbstub.c',
-  'helper.c',
   'vfp_fpscr.c',
 ))
 arm_ss.add(zlib)
@@ -32,6 +31,7 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
 ))
 arm_user_ss.add(files(
   'debug_helper.c',
+  'helper.c',
 ))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
@@ -39,6 +39,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
   'debug_helper.c',
+  'helper.c',
 ))
 
 subdir('hvf')
-- 
2.47.2


