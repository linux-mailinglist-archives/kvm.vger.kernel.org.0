Return-Path: <kvm+bounces-44678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75F08AA018B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D5CC481638
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C618B274FD1;
	Tue, 29 Apr 2025 05:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vKehPiF0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C939274FDD
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902830; cv=none; b=ArtjylmnaaEsHppmBzMis6X1QdDqUEXlzm1q8jwz1S1qnUhPop6ky8w9dhB/OxW5gH51WRh3qpfPV943dljahdqActKMIviT+E7aPdEreMaeKspxXsm9OlslLYi6DIiuCcSf9NJRXsntCCi5v+NBRT3xgnMYqDsiOIJFv7wmcmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902830; c=relaxed/simple;
	bh=TCEawUFMpZai3gFdT9yaGvolwoPVss9ZaYCTI+QByqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zed6tmSzuA3p45Zdz5eLR1OyD+7z62y6L/gID+7EbRg96iBzwqoJHVAEm91+HH7CyQPGjNb8NOkWvFQDy6LOhoDSyFUGwAt6ESdS9K2niiWbK9jnuRP+gv+1sIQcp25INcYWy0U0S8sleHXkAC+RhMlM38RUMDKnCvH93wpG+2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vKehPiF0; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-224341bbc1dso59548925ad.3
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902828; x=1746507628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihSbjG4MVG/rPWJxnirZVcYWQR5uI9SkbcEMwpHCSZo=;
        b=vKehPiF07wM4ZeXhn3heuwSbobGQmJyfoUVY9BKIcLgXqhKO1ClmZifXuOcSla3rHZ
         SXKqRRFPdXE5CBZH/BApHYnvEtOzPYdfWnHch5WEoutp52ZOPVB/e0/mVmjtpLeLmJKr
         wTzfH6YoAZVMp2uu5RLaxL/T1A6LqtQdvzpsMRAXbo2Focf3F2TeBa/r88jLj5gGI39B
         m8nYQJq0/TtsRjeet3Sp1W1+bKju3I9EjazJDUz8Lq8gjr/CzzqAssdtIbvhhWL789Ae
         5iOCU9RjqB7AouNDM2FpYvvsA9rVPMzYzSPh2I1o5AE3/hcrabPicXkifboCNvqhEB6E
         Welw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902828; x=1746507628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ihSbjG4MVG/rPWJxnirZVcYWQR5uI9SkbcEMwpHCSZo=;
        b=F2cJQUBaF3pQEdwMRwETxpxDMl2oQUejhHkIHFBqa+yTR3c5W61cK5zJFTKgBRdW4/
         QRwK4qeTkoIGRMPk8euHj+9fbElnGQ7+/0LejA5eig/SyLG/xup/LIMX52tCu6MGOgKm
         JRm/YUOo44cQuDWj6HO1cGvwUkssEj0vOXQ7HmgrZ8z3JL/9SybbRgS+Loa69eHF8X7z
         2HCplW7pJU8k9us8kirY6XhdGj5mrdf9SiwxmZtFn0FFZZ1/Zrszcq0QQavwBq4awtEm
         OST/LhOBnio1v4388HYi8d2bDSi7NvZcxvzg2KPDdIEeGcPsCiZmSK7oVl6+gvj/A5+x
         /0og==
X-Forwarded-Encrypted: i=1; AJvYcCUaXwXEZT1DkzX7Zf2Xbh+90cL7Mr2CsRk4pyTYW/eXfcQq5SCAZQhQn5FmzypQBdh7iLI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3DcN6y+ezTLrJMwuW+vy0QTM3NT2k4GoiAFZ3VwzMSbVyGN0F
	pk8ojgLXhVjN4CuiCjGN82Vmcj7cosE4eZ77YLpll9amIDcxWiw0SqhZ2zM8b3A=
X-Gm-Gg: ASbGncvt7iSQK42tU/dzF3qPymrpJRM6DSSX2ZNbzlrraj3H6ein7EAGYk2cLIvvPH/
	Y3tEyqE4b9mo8ktC+AIBCTNUL6Q4J7hA+OwFv1bGDSsHbR2aY/tOzoarhcCDJ9kdou0+BBndfPW
	0Oyzpf1JevryeartqvePGXmjyHVXgblfUBBxrjE8AeSd1944FxYuXshVh+aATk9lj+sQkZhzK1z
	QeaNrkKBAE+nV4VILXf3Xo/c+lXdC45hA0TQgeyEU1h4VQpdDIdl6JU1WQfLSKHpkdEykena63a
	MpVXuuZsxkmo7Zbw73s/KrlMCrcWe+zOBbopk9D6
X-Google-Smtp-Source: AGHT+IEKl36/YxFSXyEEI7I6vw/C5AE7dte38/aDWx18O4SHf3AWwMBIzGuoDNMnlOWkHNEFDjArGA==
X-Received: by 2002:a17:902:cec7:b0:210:fce4:11ec with SMTP id d9443c01a7336-22de700725emr25054985ad.1.1745902827904;
        Mon, 28 Apr 2025 22:00:27 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:27 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 13/13] target/arm/cpu32-stubs.c: compile file twice (user, system)
Date: Mon, 28 Apr 2025 22:00:10 -0700
Message-ID: <20250429050010.971128-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It could be squashed with commit introducing it, but I would prefer to
introduce target/arm/cpu.c first.

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


