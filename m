Return-Path: <kvm+bounces-45791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1348AAAEF77
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C02C1BC4404
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C555129346F;
	Wed,  7 May 2025 23:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EIy2gcSZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94293293444
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661387; cv=none; b=h1xyOqM8xtT8zJsycc4ltDGm51mpsZGQ3sVxn+nscvn4FTfNPFV7lwlod3I2JPH2Zf47d+WALjy14NTHVDuFg4ql5kHggG6GbyWwpqdh6vHqV+cdVq5ot4Z+NPdl0AxWsd4Jc1+xissEOrU6ahUsdMGfcVK3sIaPQkjZJ+BHpGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661387; c=relaxed/simple;
	bh=rVRDTbWWEqwgabZa5zWcVeyAjZSJEYR9LpoFB4OvRA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbC2Sua2P1RSFjSuTtKhDgv1Brm9qjYFyY/IWEaXgGz9SGQpVTLrh7ORb/BgRimOwYwECoaGkUhydHXWdN7ryeG+M9ysmPqI5fZ4Z+eJKVtzIMRhgEKvmnrTItso4YBE8gHXeMrhIjPCf4easUHcnNmHytPjXjO00d2xh3tgabU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EIy2gcSZ; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22fa28c761dso727465ad.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661385; x=1747266185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d146Pj4KjTAmT+769pG7plO/J3O67dCMeGHKPEFKjBI=;
        b=EIy2gcSZDOFd2yxH0D8g1sdnGfyTAnW1Bknxyw2pdWkntF8FhKjrnE6241D3WKVoZQ
         nf/qd7oP4YF7qrkc5S8L6T3mrOSis2LiKnnf7JBf1KwLvuC9x3T29kXKy/b1ML/1yfIb
         FVABLxXK4yjepKiI+OlVsVu03oV7sXX/NvZevtpDzUneLT71W2D+q41WNO3FkZrU2cgu
         R7lea/8cQHA6Ilw6kndPONxjJinMHus8qBG31NwwGBZhxPjnK1ly+qVgrO7rYp1t6Vfk
         9QPp07DE02/C+Jo8yqo1FkIfhcFhbj5AMso6MIVm7RiszQhl8mH15J9hjvHNyEPzwj0B
         vFCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661385; x=1747266185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d146Pj4KjTAmT+769pG7plO/J3O67dCMeGHKPEFKjBI=;
        b=NmRVZCYBIV5MXydReq9qwNdp3qYDudRdB7MCVOhy38OZe6MIhY1xVI7Y54lVxcNM1Q
         d4DF5JMUNKr1kq3GU6flU3NVEO+aRHDCnfIgMZBBAYYKUAsBjnnVhwN3f4OS+bOWSW2V
         w6mGvQh3PlDIULGD1CYeJMvQER1MclSOFauSuwVB5n67pOlPNRPf4QGPXJqAX7nkAZi/
         KGVONeQVh5LnpXB6n/l2WeChKmMIxQXAKhNW/XZ3scvuYzrqSV9J+X5kG8ydNAtB1zDf
         hjpiQR+pIl+jfZNtyz64VZpHXoUhnYENfMuAH4V7+/DHqYKtqS4P4/8sddWgbWdyZsbJ
         eEYw==
X-Forwarded-Encrypted: i=1; AJvYcCXNuhYRg1fHxTMfuZvmmHV6HsBuMzZOyiv5xWqs5BH/CMgMU0tygLip6a5fDcUVu36JpqU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDNhDjfcXS1roAKcS7NDol9+FJ5SvGJeS2aI9WHTniXj+IZ1SX
	mPzOra60JFnkUg+LZIQec7NpzIAdRwjbgcqixNWIMaGi6qea7d4nRYg2EcUQZFo=
X-Gm-Gg: ASbGncuOxfpbxFsWeR0cHR3uRgOlCRzpS92yivA8R6ZZGRPYd2Z7YXhM49LIqEKVo1t
	fgCTyVWvxI/QRDIZJdx9MbCHAOgEMgC3TlMIHnu/pgkoXsBS4Qt7NGdElfLyZWPxv1z0asSo799
	gs6d4EWO3HsgSgDYdEcjSpXBue3UAplZM6M1J7GtnJZHUgwJ6wu4bpbFFOg1abZu05flifELa2q
	hfZdwWemxhn1Bn+HpULUo4q7mihye4CGwJJDgyYJfItZbbsgs66/NPq6e/5eNXL6Y+WjcDhc/92
	mt57rmQiK6yA8cGJPNNxpgRuxRNyVjixBuA7NgNm
X-Google-Smtp-Source: AGHT+IFVqPCNhJ/SeZ4WWES//nY2YQYeFl/MFJZQYr21OLGxZWrJfOfR+lX0wne2fBbdqAzOq0UHOw==
X-Received: by 2002:a17:902:ccc9:b0:223:5e56:a1ce with SMTP id d9443c01a7336-22e5ea9dcf7mr74347735ad.32.1746661385074;
        Wed, 07 May 2025 16:43:05 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:04 -0700 (PDT)
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
Subject: [PATCH v7 25/49] target/arm/vfp_fpscr: compile file twice (user, system)
Date: Wed,  7 May 2025 16:42:16 -0700
Message-ID: <20250507234241.957746-26-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index c8c80c3f969..06d479570e2 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -2,7 +2,6 @@ arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
   'gdbstub.c',
-  'vfp_fpscr.c',
 ))
 arm_ss.add(zlib)
 
@@ -32,6 +31,7 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_user_ss.add(files(
   'debug_helper.c',
   'helper.c',
+  'vfp_fpscr.c',
 ))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
@@ -40,6 +40,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_common_system_ss.add(files(
   'debug_helper.c',
   'helper.c',
+  'vfp_fpscr.c',
 ))
 
 subdir('hvf')
-- 
2.47.2


