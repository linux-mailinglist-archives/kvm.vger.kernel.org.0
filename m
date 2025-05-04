Return-Path: <kvm+bounces-45321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 930FBAA840E
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AD87188476F
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B17271B041A;
	Sun,  4 May 2025 05:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oIXtnS80"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5682E1AA1FE
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336586; cv=none; b=PXoSEtqnMqLhk8CgHlxl2QqTsAkTKxMY0oImO87ZiH1szkXihYMFWzHiQiIFrMhXaMbMI3m5xKdIpGStkMRSJqgTf+r/La4qP02ulEMpHMFCX3nC97sDHXiyLb9e9/AETYeMt+sQvyCE6ojMHkcQ34iN8FDF75oCfoV0xExTMWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336586; c=relaxed/simple;
	bh=4VSma7tBGQnF8/QKFfrPJksO4he5ezXQE7tRteaFFz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsYFJIF3P2nDf64zB6/kqaaXW2j0GQmjjW0k7VaNCTcXiTUQ0A8jsJYTsz04/yvjVPzSI/5s/EEL9IyF7Wv1t9rZRQ3gzwTheSHdVhbgrZbcs5aBeJmbaVFgsdbXhtsarBAPxV2yK/5FppfingGlMQ1vaiiDtfiCinD9GVARcmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oIXtnS80; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-739525d4e12so3346354b3a.3
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336585; x=1746941385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3Dpv/gYklKxQ6NcaNjklM8os0pkN4N34WBJsdRDY08=;
        b=oIXtnS80u195/2/JB4z2si/RO96ySokirw1tEG3SESVhNFImzh0rq8DMoKDC4fL0qG
         eo/KjKAt2hf5sLO2/mRkvKTiSqHt+mTFjTYrxFhcY7P7yK2LT6rO63Jx7lSlHPwgtucx
         Inn12xk5rsO0Wr2fmKdWRLNNNTwaurmbYwT7VTqpdHb+2MVW6ZhpgKlF7GZSM7L+1PfG
         dkBhA8xhvyj5NVpV1EKV29NCVU7EdDm/ws//JmkdRVPguJz/nMvoRUXdxtaKRsth6EbN
         9pT6jhHFGrDOfk7OJW7W8rfBv8EzxgQz7z0pYWFiVzDlncMdzMz1bnK1If3hnJS2R8Nb
         nepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336585; x=1746941385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j3Dpv/gYklKxQ6NcaNjklM8os0pkN4N34WBJsdRDY08=;
        b=pwtaRvhD/3cSHJyHwYhRzBNdweSW7wM00I58/YxwBH0wQPV+EUgRGUehtKAlD1ad9+
         lUQuLTvAsgjjOCUoPE6mMCza8dzl+12oYlz0crNdnMDzTPqIlktqwa5bDhOLzOs/vrZa
         QPdBlN6OjWGtp1h1+2sxxYqwEn9GM6el2qvJeFSf/evFLEzRQCGHEom0lX/HjnE4BiyM
         WYvv7dTsQtfLtzgZiQ6yrQz485/F2187LxJ/wJJKL75p1OQaxIgHCcZIYqcYkeK8E1r3
         OvABaagosiK8+AAUYIuXBjRhSHLNVum1cpiArEYY4HXSOTv+tn19lu/snqP0afdEo8WZ
         JCeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXR3lTRoapeDTaDLSxLFDkS509Q07xDFLApJzl09Jm+VNlrKsD+w8nMbFrWTDHzDrTRyFM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl5UaUmMLm715hzFoiyfoh4lX7upq7asIOVExNtEoh4vXkA3fA
	Qnj4kwEV3MQM4w6cpdh601tQctXqiC/trysZuCl1fUn6K7OCM0zty2aTFBIpQPs=
X-Gm-Gg: ASbGncsDWHBs+Wi82j3jLDa50Vhhbe/gEGs6rdAAAWKuGRutT9D0E7ARMpp2LEko2od
	H6vHTlPuR8D2WGZN47q11LlCGoN3kVlAthA/Vm1OwIeM+IXNhJPNAR/EccQ/6t1LpUbxGa38J/i
	ymkqDAF0b2VgPGcXc0bb33sArft3SROk+bWXM7xBVD7xm0pSpYyLSBQ7C1z6BBqCTjleGpF6S9d
	8Ph+evgk1G1a1F91GrtD4x5mh/PzCXmFu/kFqHrsWSgoGU8noKfAisblT3hU9wFyliV+ui2fh8V
	/N4DTuritrirX+5AkBsFwl5DqzwJSznMpN+NLAl9
X-Google-Smtp-Source: AGHT+IF9bJqlPmghjDpbd8Zl1EC77NJasNz3fJ6npNVxR0Z+1P+76zRrAVulXFYymz8tcW1RA4zs4g==
X-Received: by 2002:a05:6a20:3d85:b0:1f5:77bd:ecbc with SMTP id adf61e73a8af0-20cde951f95mr12471654637.16.1746336584651;
        Sat, 03 May 2025 22:29:44 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:44 -0700 (PDT)
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
Subject: [PATCH v4 28/40] target/arm/arch_dump: compile file once (system)
Date: Sat,  3 May 2025 22:29:02 -0700
Message-ID: <20250504052914.3525365-29-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 06d479570e2..95a2b077dd6 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,6 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
-  'arch_dump.c',
   'arm-powerctl.c',
   'arm-qmp-cmds.c',
   'cortex-regs.c',
@@ -38,6 +37,7 @@ arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
+  'arch_dump.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


