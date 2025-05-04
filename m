Return-Path: <kvm+bounces-45306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60B01AA83FA
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 901567AC45B
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A537D1991CB;
	Sun,  4 May 2025 05:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oodwlVqr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9B91946C8
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336573; cv=none; b=sMxd32EjPfokgDWgaCJa/zFNzW2cycrtYPhf5cQHKPHFtDBqdIARWeHlboPcH5JXs9XO5yt9y6RlqHISmMcfh7O21DcZovMPe9vQI88Me7Oxh4VJHNsOs3txn36aYytvPwu/xi0LDklLfR1/M4KEmSrp8xs7qbSRKvY8sUA/BjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336573; c=relaxed/simple;
	bh=AEdec6YxwqEM2SMva6W9gXoK89VbojQSf/TWlriKM5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTttqZw9X8y99gFLS8nVTT+TZSMn8EXZq53YcRYuzClcm7Fxb/4vVtkVyRA8UEfix/g03tDHgetxPsyGUf+Uw3U1xuiSzne8W5My83sSmPyDMeeLxwxezj/ugbLjjPLzMJKWUj2e5a9NHNIIIlJJbVykt93DCPHypiCqdQ/x0ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oodwlVqr; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7399838db7fso3535929b3a.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336572; x=1746941372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=oodwlVqr8Sv+K/9Cr1CUnoQse26MTs/JUywMyLrD9QpyGqzDrcwg8juRmfnpMAwyIe
         lEfmIPrZSWiJ2Yyw8X872Odt1vrQKABDOedN/EjK1c7nTxxqrE7fPqsaJ13WM739C83+
         21+Txas9FiyDb3QUZoXlrZq+H5Wtz2+IgYXT2vLjX8rnLjhZ6rN7Ys0R1AbLPyUEmSZf
         KPdbwN5owxHoV7Z+lQpGzmU50zkiHv050eSHy9zVD8DQ4rT72kVnmp/X6Glvsz6c1GYB
         B4Aeg0LDpStn3esd3K2VGOercaemg3rPv7TJ+A++tc3v3vOjmxkVnI2+8dVyeU3DIt1I
         l3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336572; x=1746941372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=J78dVrfiOsCsIU/PavDq+hQDLZvOmetrzogRMbmrBDWpcUhXHHNSeUhXIWPtfxMIO1
         IdGlX2OGAZ5m8pSmkuaLqdIXgy2DoS8cKLwyQfuPCt4+GO48UGfhk3lkM0fT17SFWX8Q
         2ZrMZx6QEHG6N1kHMjHwSwhnIhGRdgPvkn73LDHFu/PH0VlXL57VADQSaHEStDIrqW40
         Qc9z1csQy6djszq6zS8Y2bBStrecSWn/V1Liayln7mSfaHvhyuRmpB4T1KFHN2qYhP0H
         iHSfClfBJmhfbTICOeOHj4SJC6G6Z3jUIR0HvfG2A1od3UHeSYAhS76DT6NEq+FzSSpB
         T1YA==
X-Forwarded-Encrypted: i=1; AJvYcCWqAfeKRkNtL37H/yw4e/danXR9cXY+6et7FNo8kJ8EYyexOOEvl1TCiacsghX8jxV01xw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8pNwfqPvZNFVa9Hv4J6k9bdJVhyyuUn0Y3OErfdbifN5altUR
	8w7QFGKz7oAyUor1JuG9T8BJZ1/z8ZIVuYFER4odzNBn7tovvad8++DL4I19ErI=
X-Gm-Gg: ASbGncuhbXkrYZFLT5yiQoG8p8UdH/of6wqpQghVVfEUoq1MNj+U/KEtI8TGvsBjq+G
	NUg1N3zt24/CXfr5ACR94ytyxI1j+LeUj0EPgYyZBS9ztm5ujxNsGcjfgxPTqP3y1REI3wqUzXi
	zQNrKQFdrpJRawKU56FFZFnJBKhoTVHMWaUV8hNcyzCFsRyRXUQFZ0dt7ezj88cZE5KUSNufUnV
	Ky6sCwO31v2YMwjRvD0r58i6vuuA3gNfPIrRSQ7+bj28HRhjwnu1WiMqMI54OV4QCo8YMR7QIJw
	xuGTJjqrkN1jHPo2AMlZEhl/+FFoVsgh/92rgSD5
X-Google-Smtp-Source: AGHT+IH252EWjnH5DLBOIaSkYHKk6fED8pkBcv5fssuzsDnYonZrqjLHB+BuPp4SpV0ym3S7HAaCVw==
X-Received: by 2002:aa7:9311:0:b0:736:bced:f4cf with SMTP id d2e1a72fcca58-7405798f929mr14072441b3a.0.1746336571700;
        Sat, 03 May 2025 22:29:31 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:31 -0700 (PDT)
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
Subject: [PATCH v4 13/40] target/arm/cpu32-stubs.c: compile file twice (user, system)
Date: Sat,  3 May 2025 22:28:47 -0700
Message-ID: <20250504052914.3525365-14-pierrick.bouvier@linaro.org>
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

It could be squashed with commit introducing it, but I would prefer to
introduce target/arm/cpu.c first.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 89e305eb56a..de214fe5d56 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -11,13 +11,9 @@ arm_ss.add(zlib)
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
 arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
-arm_ss.add(when: 'TARGET_AARCH64',
-  if_true: files(
-    'cpu64.c',
-    'gdbstub64.c'),
-  if_false: files(
-    'cpu32-stubs.c'),
-)
+arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
+  'cpu64.c',
+  'gdbstub64.c'))
 
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
@@ -32,8 +28,12 @@ arm_system_ss.add(files(
 
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
+arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
+arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 subdir('hvf')
 
-- 
2.47.2


