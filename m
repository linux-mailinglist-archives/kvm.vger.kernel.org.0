Return-Path: <kvm+bounces-45382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D5CD6AA8ADE
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:55:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D98141893DA1
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A2A1F3B96;
	Mon,  5 May 2025 01:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hTyPRiyQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98891EE7DD
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409983; cv=none; b=eSX64sGN1Azn04wsIPy+7eTDJPIBTQFpJpX/16hLH1GK6UGZQ3fZz9KSUMiu/JbVLa9sJHXARmVdEW3f/fFpW3bUCKZBVztfCM9ljT0lzQ5mmO6DDcz1v9sxlSVM9n7K0XY6ZxYdOgob3xpJFArxBZWUMZiGHGd85jI+mQ6CvOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409983; c=relaxed/simple;
	bh=JFv4YlTrDm1SIM/o00YgUrqEFpXOxh+2IWOwbnFpb2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jp/Jx6yghzImL6LF0JPKIKUr2+QlK8eL3v+FDt4nWj99lrHiUIVZRQ5dZOkhUaw/GmnayVz74tF6MSeWZ6FtCGHQ7R6PIoWd8rf4BlIFxhs38ARjrcUSBF0b5mVxWH1W8qj9mOQuZPXRyvecHhd3TBJ7roa3zwfM2EFnro7ExaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hTyPRiyQ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-73972a54919so3590927b3a.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409981; x=1747014781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rXLXuVNGEyfjK9Yd01QUJZvt/uyYRhxbr8cOAxNhYLE=;
        b=hTyPRiyQiccUqfREbLMcaSgBhlH3h+UvmIHgUaBSZcyxsfP2vaLQKQx1O0WibY+rgm
         9wgUCfY0Y3CZ/RSOwT7mY6HZw3LCKzJ0i2GA8o/kpXBk17qdCdjDWTUSOgllXvoXJOE3
         qVXjb9URbHwZj/BL9nJ9EfNS3uCFVFwHjtuSknjw0WUGAv/BGtkv38XLL0hRaFIt9Yb+
         W/2dsT0tQU1FKBvocpCHSz0C95B/6U3pBzKc5iTZ9g0BB7V4SeEQk8pfvIuK7ex7MvzN
         P6xpyq/g+eCaZgDkLa/bnCHUdNiOoYCFwTVbVIRgSOBJXMO+gqE/VRWbvsGsxLOtybIf
         UXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409981; x=1747014781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rXLXuVNGEyfjK9Yd01QUJZvt/uyYRhxbr8cOAxNhYLE=;
        b=e7R64ZzXm1PsAH0VroqkMC/Jm0R4d59T3HuqIYfcLBlfEXPLHeMReXyIQJCz84pGh2
         ym2F342t9kRuEv0IstjmgtQYHYljlpYeuAwFHRbr8U4J9Ob8SeDjqiTXTz+OI48rm8GB
         IMVyKOzAisrEmCCEnRsYkX5fO8kZMyu4q/3VWV9ts+PwL/aIqhKiTmxtptDheNdFLMgH
         VpVyfLrETS8+yaXY97zZst2tvdNBsNbt7MjIekTA4TVa1nXOrvbhmYuzkex/bDwssrEP
         nx/niDD9NoKMPZk5HXmRXf+SDq/7lyhOLn2ipsXvqNx4I7S8d8oHFv3OOmYNlpvy8uzY
         0fVA==
X-Forwarded-Encrypted: i=1; AJvYcCW+GxLW0afshZpx8BiDHOAXJHOiajW4WjQWIvqcFK0FCjdQK5Ufq9Gz/H5IoYkJZzjV7zc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxheXGP8Q3NLPEsmXwHNN0E6YB6JVdG/feA3xdbIaJuU5Xx7I9F
	6Sa7+wxeWwPWWwyDcA2I58eyoOHVyJJHCIe7FOhllOsC+241L7BK1HI2S+NGc5U=
X-Gm-Gg: ASbGnctKsYuctUz8ftKRXv50GrAjLBx25zLunhru5cNG68tUL5SkHusrIBiqqOjCrlN
	tmxkMG/pusVHFj6cZlFcVB+HpsP8KGKhXU6dAQDHSvWhVgt/YQ8pfgelzyz6DziHrutMBf/XWbU
	nKlE7ZAlPL/MkRj93+HQsp/aj7yl+Koq1iPvsfHJKkXvemPz6N25DrgB2hsBGBKVmTNeOZRFiYS
	EMcrs9QTAWitdTwwOCYE0kEuR2bQE8xfvQkSFpqQefrss5aNqXYW0nWaDLQ9ndekqakln9Ae4N0
	lVDju+CmFbLMD66XQAqc+tg4grShc4PQpHm/9QHl
X-Google-Smtp-Source: AGHT+IHfI0k8vkxFfPNj2aCSH0PSyH++uXGXhOEGH/b7PGVfp4DeG6fFush3rZ7gI58mdIV36AorCw==
X-Received: by 2002:a05:6a00:4c0e:b0:739:50c0:b3fe with SMTP id d2e1a72fcca58-7406f0b0434mr9256730b3a.8.1746409980959;
        Sun, 04 May 2025 18:53:00 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:53:00 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 35/48] target/arm/kvm-stub: compile file once (system)
Date: Sun,  4 May 2025 18:52:10 -0700
Message-ID: <20250505015223.3895275-36-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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


