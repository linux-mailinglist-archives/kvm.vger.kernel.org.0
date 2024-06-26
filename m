Return-Path: <kvm+bounces-20557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA47918395
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 16:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B43F1C21DFF
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 14:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6839818411F;
	Wed, 26 Jun 2024 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mOSe6kCA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B9217D37E
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719410595; cv=none; b=BHWvIr4mg/hWk8vtGq7ELAuAEf6YNDwVdqE8OvcSHGzl8Iinky5YrNfwjo0uSmE/bugq1Uej7bANrRExH2QVek3znzBaIy7jlZ8bZ55LLMgLjyZhis/Ii5aUjbVpImvId9DR/fqiJf1tc2wIzNAhdDm+29CQMlt3tV6eKzbvAIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719410595; c=relaxed/simple;
	bh=+e5VwsIR2jSAc56b6mLSS6DwYDmFt946XA2CwvSJ/QA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=H73xz8Fxj2uDHO6lrsyknV/llaW815XbYV7AlNKsuEgHxQPbDRB6B1SmUCLVFMkfXWZIdHk471oGVq3DvKZkLh7pQQfuceq0wlvp8/pRaYYHtKOpHKYzPrX8jerRB2z2Ib/3VcoMGtg/8ASSPD6/Fvmvmwng5rzqC0Y7dKcXhvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mOSe6kCA; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a6f8ebbd268so112683966b.0
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 07:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719410592; x=1720015392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hb6LcajEHMuf71XU0VM8Xn9J7SZV1K25f5gPBrNRxwY=;
        b=mOSe6kCAvTOD9rB2I8EmO9wY0ztiLBHZhT41mMGBhwm+pMIOTiGbq/kGWwah1SnUQW
         dmBpoCLLBSJSWPOkV8M6aShqV4qtmNV0sWXR30ViKcVzhFuTO1tjZ2oyDhHmV1wdSMdy
         fFF0eXRnODnq59M7pBcFNZTlUBYgsh6f6BMuJ36n/fc0ipcE8WSgeee3TrfI2leS4ims
         5c6ETHDHMR/0owLJPCA2IavmmB9v9fkEWmBtj8cE0p6/Hd9bGt8Znt3wphFC7A2NrPPS
         Nstk3LmlLBOFbeyvh14Pv5oGVcK9JxXK/4FYgL+028Avp4LJffywXUZhKA6nlst5HkME
         LEEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719410592; x=1720015392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hb6LcajEHMuf71XU0VM8Xn9J7SZV1K25f5gPBrNRxwY=;
        b=hd0TbaKL01+DkSI3exFHJFCLWt4YdxOZHLBBYC09iTCdI5/RuGlyWM4741vkk3s6e+
         E7moweoVWim4LwQbBn3f3KpMPoduKmF7LEwzphSuWyNIU2i+FlZR/LkvHkDPve4l0NVG
         jCDPMd9nPWiA2Pn9LSU8NQ9zNz2dNUssC/0E/fuBMF0bb3Hje+6PpfPXAn5bF2eye84E
         g+hJ8l8lh+dHN3pM7IhvcHmoUKSdSoN3CfNM8Okxt4/CBrRNfx2GqjbO2/4lfZPwVJew
         CDJYpNB4vkR25JjirUbfU1MEX0ROfB0QbQ4fs2Z/3li9/XKrj/3lsxFPIyKTiQ5uCqB6
         YxPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhmiNEzn8AumaBRjQvocmz1Dg+YsZBIQ7VUCpnuT+QX5af2+izmkiXJmU6DAX/NxXw1GnvEbLYjfOcRdKBq2no3fFD
X-Gm-Message-State: AOJu0YyhKZ6b7/4O6hijCpHjzbE8rmfV3Vj/CjhDPJRz+ewtXNFlUkC5
	IFfPX/SXoODQKfumyP0sz/i+ZkUZDUzRFsRtwCvjTtD9Xwdr13XjxE8LIYWpxc/w6oRZOc5jPRW
	y
X-Google-Smtp-Source: AGHT+IGlV17/zBQgow1726AbkNZwtdZH1JCC1vuie9PnfspBFdgxeCw+GkOY6yUXX55JTu2Y5kiFYg==
X-Received: by 2002:a17:906:abd2:b0:a6f:e2f1:537b with SMTP id a640c23a62f3a-a700e706f07mr954361266b.28.1719410591717;
        Wed, 26 Jun 2024 07:03:11 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6fcf54923fsm617544466b.104.2024.06.26.07.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 07:03:11 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 5A06A5F8AA;
	Wed, 26 Jun 2024 15:03:10 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org (open list:X86 KVM CPUs)
Subject: [RFC PATCH] target/i386: restrict SEV to 64 bit host builds
Date: Wed, 26 Jun 2024 15:03:07 +0100
Message-Id: <20240626140307.1026816-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Re-enabling the 32 bit host build on i686 showed the recently merged
SEV code doesn't take enough care over its types. While the format
strings could use more portable types there isn't much we can do about
casting uint64_t into a pointer. The easiest solution seems to be just
to disable SEV for a 32 bit build. It's highly unlikely anyone would
want this functionality anyway.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 target/i386/sev.h       | 2 +-
 target/i386/meson.build | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index 858005a119..b0cb9dd7ed 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -45,7 +45,7 @@ typedef struct SevKernelLoaderContext {
     size_t cmdline_size;
 } SevKernelLoaderContext;
 
-#ifdef CONFIG_SEV
+#if defined(CONFIG_SEV) && defined(HOST_X86_64)
 bool sev_enabled(void);
 bool sev_es_enabled(void);
 bool sev_snp_enabled(void);
diff --git a/target/i386/meson.build b/target/i386/meson.build
index 075117989b..d2a008926c 100644
--- a/target/i386/meson.build
+++ b/target/i386/meson.build
@@ -6,7 +6,7 @@ i386_ss.add(files(
   'xsave_helper.c',
   'cpu-dump.c',
 ))
-i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c', 'confidential-guest.c'))
+i386_ss.add(when: ['CONFIG_SEV', 'HOST_X86_64'], if_true: files('host-cpu.c', 'confidential-guest.c'))
 
 # x86 cpu type
 i386_ss.add(when: 'CONFIG_KVM', if_true: files('host-cpu.c'))
@@ -21,7 +21,7 @@ i386_system_ss.add(files(
   'cpu-apic.c',
   'cpu-sysemu.c',
 ))
-i386_system_ss.add(when: 'CONFIG_SEV', if_true: files('sev.c'), if_false: files('sev-sysemu-stub.c'))
+i386_system_ss.add(when: ['CONFIG_SEV', 'HOST_X86_64'], if_true: files('sev.c'), if_false: files('sev-sysemu-stub.c'))
 
 i386_user_ss = ss.source_set()
 
-- 
2.39.2


