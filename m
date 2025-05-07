Return-Path: <kvm+bounces-45795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 821F7AAEF89
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:46:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6155B7BFD3A
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E35E293472;
	Wed,  7 May 2025 23:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GtuuAm5h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08155293729
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661390; cv=none; b=uCBlflesT45LpzN9mh4fUYROMDa5CSOZCpCxfyGxvfGUQkXFoHV+CPvIkqCjSyylpUo8DKuRuSVVEEEKS8a7SAR5E6M6czvXDd/xm6VnbiFCRcc7aD1ae822PubDpgKlI4seEc30Abz8crvRJDV33CVrRdyhGqDh3XK2J0xHBxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661390; c=relaxed/simple;
	bh=nio9YJkiK2g8f7JN+bhkPA8UAPODA+S829FcakWQE/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCumv2pmOhHXvwA0IjaISK2HgucuTNHvmCQ0cxmaQYV3x1GjgMEeMZESEw6ltMI08iu9+J2Wbsg4z5xttFRVoqEaUQv7soxPaVsVzwyOqiuiozyhTWRsvaL099+t/AS0FFMgcWr1O53PIuKNKej2xFfFcuzdh9bQ7dPIIAW9+5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GtuuAm5h; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-30a8cbddca4so496686a91.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661388; x=1747266188; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rVtP/RnhHG9awohdmhc7BZy6oUycGDI8ImSQa94LuXo=;
        b=GtuuAm5hMxE9pGmBDbEHV8uhwX8s/Vifmyn7MrDXXetAIJ6k8siyXmVfhwWckxnh8B
         YF/QC6DT1kHoT/TWG/sqDGXSDfyYQhxDaHDGubGkoU1zgSffgWufrIA5vdSk1In+TMsg
         qhnydpera2f0kWdH/yitb0E3kFbFh3Vusmm98pT1sTHEXAU6OUPSVk3hGz6cT30U+rLM
         aN0uFUsvl16fF7Co3UfnC344SkbQOeY9b4WED7VEsKUGFJYofT+zBzWfKR+709ri84Yr
         bcUKRva6j4e1iuzy+ovZU7HBB3Zdzrj7ZgCCs0rq/sPgRd/F8FIt9vif/tuNpc8FtqJl
         t7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661388; x=1747266188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rVtP/RnhHG9awohdmhc7BZy6oUycGDI8ImSQa94LuXo=;
        b=g7Jwg5ysfH0CMEDsnPEU0B1Su7eDu1di9M85bTAQSlH6dphfkOCtJBveldYFC0/uRM
         eeiWlDJaydoK4lc3ROBa3rvPYlP9UWzIXt6MD5BVY6aG9ii6ViGcqMju0gpb0XkjtjGG
         zMNh8NYySnjW6PEtRjNni68vZZjSQiRNQBVdei9wx5PpyOOjzJu3bgl+uYsI4NJOZV1q
         flLAmah+AuBUI/06jL7UnegbAowdcVWsbTZGd4P09N6K3ysBCte5vttgEEyy9PC7b1VC
         GNqQ8qKZH/u1eor3Y+vNjnUA/6vxetK75Nms9dQMm/eJStxd2YWQZcqrfe5mcNxaD3as
         QVcA==
X-Forwarded-Encrypted: i=1; AJvYcCXTUl4AfVK4cZOyo8Q12EiHsmUfW5mQV91+HeU62fJj7O2bzfsg0w+OmEu5HmJE4Sug8BU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcKwAVRqnkpTrU0MS6ijlZcIOtN03mrV0rVxTKyFXssYSphg16
	cTL1Wo73NiSgaZwax2kzon8stMLvb4Oni6yStzt3JFMxIZHlXOcqaoVCZ8k1XXoAZdEMoPdYofW
	scQmLqA==
X-Gm-Gg: ASbGnculfZJo+1p2t+nhuSND2nD/I18/BAD/7AgwPKLj9xwMNaSr7UpdHni2gpT4Ui2
	HnDAbgXW1wEUtZTS+RE0lhcxWKqdfIj/Z3MTTF0mgKLN0I1pV4wMFfEDiSb4VqQgW8Fl8JKTumH
	7jN2vSkyHIjmJYKHCzvaJW+7mPlkfJcepExCpPWvT7ZCaiyHayaqGhddXhqWyRfTcDQzqwbpm5U
	Y2mi7OOkEWHOgV6crW1n2/D3Ni8YlWJu6NAVfUcnj4cp4ylYwCWc8RkuNqBvHbT25vxGj12651y
	B5N6vmsCjDvoEitHN8BftxzjcMcHfR5O9/Zl88+B
X-Google-Smtp-Source: AGHT+IElhneOo62MjSKskYIQy7VHQ7smeSPm1m2Q80DLuetPyAssqqhuGAhjwKmYU5VfAYntwmXZvg==
X-Received: by 2002:a17:90b:3a8f:b0:301:6343:1626 with SMTP id 98e67ed59e1d1-30b28ce15d3mr1418228a91.1.1746661388386;
        Wed, 07 May 2025 16:43:08 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:08 -0700 (PDT)
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
Subject: [PATCH v7 29/49] target/arm/cortex-regs: compile file once (system)
Date: Wed,  7 May 2025 16:42:20 -0700
Message-ID: <20250507234241.957746-30-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 7db573f4a97..6e0327b6f5b 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -16,7 +16,6 @@ arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
-  'cortex-regs.c',
   'machine.c',
   'ptw.c',
 ))
@@ -38,6 +37,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_common_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
+  'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


