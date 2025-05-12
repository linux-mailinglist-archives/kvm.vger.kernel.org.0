Return-Path: <kvm+bounces-46233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B14DAB424E
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:21:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E084173BCF
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D8AA2C0879;
	Mon, 12 May 2025 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qq6cyC0n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4EF2C0842
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073143; cv=none; b=QPHSJ1sW80z+gxf2TnBaL/6CHL/dw7JyH+oObHGinsCRJcWG51Cu5SkFjR6K+0WE6hCCZQGdYQPHxHa7OhHZD/FBPUn16dxrDyvcHyebEKrzwYCOSilWApT4UCfRZTo9YSgf7EBNRvow9BpJLcdgJs+08DWv5C48hP6XI3m9V/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073143; c=relaxed/simple;
	bh=JFv4YlTrDm1SIM/o00YgUrqEFpXOxh+2IWOwbnFpb2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=leP/UpL1Lyt2vtxlQhJpmuYQpeorUv9717USJskj22IzhAn9DNOsGFazj++JT/fNw5w2CnK5IFkQsPdVrd0DRJagnSQy/iCm5TFMBL4pRe1f0WJNhI1S402nRnzlslIoKm1NRqx4D0esWQ0B6h/jN6SfEhHt3rGHUCaP4U/eSxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Qq6cyC0n; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b170c99aa49so3218691a12.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073141; x=1747677941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rXLXuVNGEyfjK9Yd01QUJZvt/uyYRhxbr8cOAxNhYLE=;
        b=Qq6cyC0nzYAz5EK6SR4DXP52TWVmw/9O6ZLny5H3kyNVeZ/FLjiVEbdo2ICuX71Uik
         RsJAFB77ys53nBYi28Q6cjzkhruuyM8QcQv9G/kDd5zKWPSTRyfDe0Ep3rVYTdUL2e4F
         3F+hL0FFMhFVgaHcIpZuBcG2n6JIDbZOcvf07ACB12xLl2fyIE+1b26uBZHwGyL5Skk+
         yteGFIbfPz6N3yaCYxl/TGNb10WrfuGnBgToefLLm5JMVJ7gfz/jT4M04kqvTdxe82Bu
         XBjP0gXj7RClBTNJd5kCUxl6sLHF9nrOsDGgxO/1nJv6HCe07cmtVgwep7gJZMvCHx3W
         iL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073141; x=1747677941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rXLXuVNGEyfjK9Yd01QUJZvt/uyYRhxbr8cOAxNhYLE=;
        b=ae/H9dVppE+gtYw0D98sp2mhnBaPPnmeesOXXIFsdlZ9zztq6DOP3SZYel0LpJR1dq
         c0hRX0kITm0tQvoxYpAbXFt1J9QCWCcRnjtFXlExFMsbT/P7etBkqqCHoiaQb4rPG8hn
         rZokrdYCIYfk+MKMQ5OhppinarAY08MdHAISu6kPMxU7Cd8oDBD5flJsBoOwrJWHF/Fd
         dcT4KrHzG18a1Heaj3PC3oxijHgoHLrruVgKpmuf4y7x15JqSn1NM6CIB0t903L0uOm1
         b6Fkp9T6Tf+YjaP093U8AZ1oRGuKh0B41GJwSIs931mHxNB/m9KKlm8hHqs0sq/IV6cs
         3OQA==
X-Forwarded-Encrypted: i=1; AJvYcCUUSYLs3VDMdZvKevBP5E1mgiMy93E/LgNzg2dy/fVRAX1/tmzVLirCJFYuQJjQLe2tmAk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpqKJIIfAZ4r1ayVx1LOrPN7E6T9fjx3ls1ee9OA5D53OKh18w
	dp9AZEJ5/cMsPr9taP+x2xecqF2xU2gJOKHEOgwny8WYUoByOejezv5uu/qJaXA=
X-Gm-Gg: ASbGncsTSD6ibhSyALKM4/m5Hbam6L9ziwoiY/ZVT6BCKrOtuK0c9gOOcYvoSwP9Ova
	c90NAyvE5H1l1jRB3FzAeiOZ1nd0V7z8LBckvu58AuMGDuLNWgaPJ7mHUEQ4CkPmOs4iqSwGxwH
	PAxQJUVUZCVTHyVr3boqUUmxU9QYt5Kt50rfZ1hDvnR7oMx+CRF+uOTKuilF/Tcpu3NoVMvCAAK
	xumd09lqVL2gbQ/tEB44mGSrEp2F2YVg73Dj4h8k5dxVgXgBDxGB79aFH41jbd6tRPf58n4Gn5O
	sfZ1fz/FogNFqJuqBl9RytYkXeUNMqKdjDhvKt/2AIlBjHth9XQ=
X-Google-Smtp-Source: AGHT+IEB4HGFgjrJqND6GkVuqk5sFWv3djL5NlKtJ/9FxV4Ne5ZgKlSvrPTD4P6BXHrMQGl/vG9WjA==
X-Received: by 2002:a17:902:dacd:b0:22e:566f:bca7 with SMTP id d9443c01a7336-22fc8b5192fmr194608985ad.17.1747073141166;
        Mon, 12 May 2025 11:05:41 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:40 -0700 (PDT)
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
Subject: [PATCH v8 33/48] target/arm/kvm-stub: compile file once (system)
Date: Mon, 12 May 2025 11:04:47 -0700
Message-ID: <20250512180502.2395029-34-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 29a36fb3c5e..bb1c09676d5 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,7 @@ arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
 ))
-arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
+arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss = ss.source_set()
@@ -32,6 +32,7 @@ arm_user_ss.add(files(
 arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
+arm_common_system_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
 arm_common_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
-- 
2.47.2


