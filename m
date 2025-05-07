Return-Path: <kvm+bounces-45777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6A6CAAEF62
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1C081BA7BA5
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CABEA292080;
	Wed,  7 May 2025 23:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OfOZePLN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6D72918DA
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661375; cv=none; b=n2n+UIvYz4u7+ztTLAv6sOahGboPCG+a1WSDkkTa/FlKMjgR/U63wQMEXx0v/29aamO0oR/HnNxwu8DaA29CMA929yequtJLYzzSkuFSan8x/09EiwSYJSrcrBGawV12xny7KDlmhDRQSCEwNfDy4hOTI2L+Xu54yGb3XWVwZbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661375; c=relaxed/simple;
	bh=30HYw1I8aFdjg6SHuQTxQCRNvR/7AoVCDPUJgGhi7zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnD7CPrWkwmBnI9q00yGscIjkcZq4ML0ZmeZLBcwz0chat3ilpSRcXDdmGqqKOuWTbxVeYPuMJtPAho7nsni4zaM9813hZqaAz3lgb3yrbZVo5dwNx4+4Y9y8pMWgZWC6oUKEDfZVTwX9gXbJouGUmd3JhzXFw9m17OWZz7/BN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OfOZePLN; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-309d2e8c20cso576587a91.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661373; x=1747266173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mduWzGcqrbCCMCYuVdtTD2ZBid0+LWN3eUl0cLQ5HO8=;
        b=OfOZePLNnTk+k8/8Ii1R+ixmwotqd9RBad4IDIMMD/FauHKg2H7OEsbrsE71O0/f7r
         3GV+Yg/ins55RNFibzkRarv4BuYWGSSHG4qjlmTFjFM8ZrZDJgjWgs2u2FamvA/JyZf4
         WIyPn92dkZKXbnmHJrVL912SzV0l5T9tYoGEPxE7qCNWaTFiqu1cV6320F7p9JyiNxhf
         geYVGMMhZKfs4NNEiR2y9XDXPYDnhA0qZUdXa6fmRt3/PR2OO77EvqEPT5sNqQ76cOsm
         8BACAtxFrIZzqKWJFnKWrkpbKBObzsoBplcq14Drk9mZ/leKkPUU4lFzRULFtlrWHUnC
         aQ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661373; x=1747266173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mduWzGcqrbCCMCYuVdtTD2ZBid0+LWN3eUl0cLQ5HO8=;
        b=Exe2ZTXxVRkvHobQAu4ojRulL/JIvr/ffWcAkhJE/DWUph6F0Y6gsBg0feoDTbrQK3
         weIvrsfH1KMZS/dts836yh4jtIczA81lqQonkYBaxXMPNn3rQQjGJKy68xk/L6nTADyA
         +jiMIenDgns7gFOPeh8UujBhGx9puMFR9NsqOu3pHl7tAvrLJKeeiuJgaNWAVQP1VDaB
         2wKo0rB8M3aUXrDX9Ng7UVRxERP7va2kfk6NqonXJESzbmwf8rKU/wVyMIbGBrIJa9fA
         TXYp10HfsAJd/5h99Npi9IhNubTulzRjfGIilmSI9opa4fM1pfnUjtKUE9jlY7U3X1vU
         fCIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWs//phoJEXDqZ80r50j9WsyLgZaMng+WzVukaB2MZCV5uf13NrT+XWEZ1dAAIMKEUAuvc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxeq1rEQAGQA0URSWayWIMk8+7pqHat93ZLwYRGSrSX0hSe7aBf
	xIqkl6lb53066O4EfiY1ePbDGTigO1WtRXOBCvA4+iy2Qme5DxIojmQzFj6lemE=
X-Gm-Gg: ASbGncvXpBv06VpHIN2oAMLOT16B/KiRMwwEWmR19GFYVGulGTmy7KCdw58KlIEyb5A
	rMpJZfkThrdNKwt8eWy02uHGP7Vfj9FPseQAl8M4ufcXxl+DSWIvd2xLiey7f3+y32mAMCAB5hD
	fBU4i2sfQ/itoZEGzHKnYwMaSqsyNw2T+qNlEMuGMB31zh1sJ2a76x9F/5eCynRjYd1aDOa3YUX
	tR6Ntbeo6rmr1qBWOqIVe81Kr/doXVqHqgpcf4ERaJqHIHdVBM7vKpLKNo8khgsb8U5HMJAzomt
	2kgIUvI82v4e7LcAeFLVM+ySt9sysRF/BWs283Pc
X-Google-Smtp-Source: AGHT+IGT9jj0uwCiSn5aHiR6pkWAiqIqY3mUNfD2ufhi6mS0ZBXJtvhfq5oYsu0oWVVtjh2cwW1W1A==
X-Received: by 2002:a17:90b:38c6:b0:2fe:b174:31fe with SMTP id 98e67ed59e1d1-30aac18622dmr7695290a91.2.1746661372934;
        Wed, 07 May 2025 16:42:52 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:52 -0700 (PDT)
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
Subject: [PATCH v7 11/49] target/arm/cpu: compile file twice (user, system) only
Date: Wed,  7 May 2025 16:42:02 -0700
Message-ID: <20250507234241.957746-12-pierrick.bouvier@linaro.org>
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


