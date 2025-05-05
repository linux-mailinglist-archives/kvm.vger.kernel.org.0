Return-Path: <kvm+bounces-45375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73745AA8AD6
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:54:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC460165C82
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEAF41E1A3D;
	Mon,  5 May 2025 01:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V9IcQoSM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43AC1DDA32
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409976; cv=none; b=L0VqvTzahStgSVA9UhJHEYogPCsbjVYf3WuLcIjbmXXxYTrMAZBjGWm/j0WvOk7IvHp0DV51qmANaeqSgTPnFpJf1FYWjEHp4YWcQhZEnC2D245mbka3IgTWyc5mtBeom0ZljvY2kE44OKSLreSBHu2irijos4DFSkN44SiYo8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409976; c=relaxed/simple;
	bh=4VSma7tBGQnF8/QKFfrPJksO4he5ezXQE7tRteaFFz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FU/EqqdGIlt3z/LYKK/COHgzIcH2J97FZvd03iFF3Qj0a4RD/SdyeDofdP9vi5iC07TtvPlmrCuIe+1Rje25hlScooMA/AJDNOetwKZ1T8PIqETjjocHZI5runJ/pT9A1aGpk4O38+01z6ppe1WjsqNN5C5fTjuVi5wKHm6dptw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V9IcQoSM; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-739b3fe7ce8so3407103b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409974; x=1747014774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3Dpv/gYklKxQ6NcaNjklM8os0pkN4N34WBJsdRDY08=;
        b=V9IcQoSMGcfU47g+uI/LtpSkTIdzBjiTVGcVNMvlijEpn5aOaksLYZdrp2EEKQN/Jl
         z0fEwiP4pH1HSNADIKBvsujkvyftsOPfY6zGKfs44P4P7nv1UrnJJyQndEAULKJL/YBf
         aRZ1Hi3S58DywTsW7ayeKl1XclvD9k6+OozBeaof4tO84380IPi4EQsbMmKeHv3WKlx3
         YbR616JV6/c6GEKAibj5viYAsvw0k4rApbczvuHrremvTBy6NWgX5yyxv1LKqKX3TPYW
         uBs3jR2+yObXs6s5o2U2aTzYwLUmISRk29mnHoQQiM1GnhR5jys+VbG/Xz1F9QzMt4GU
         dmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409974; x=1747014774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j3Dpv/gYklKxQ6NcaNjklM8os0pkN4N34WBJsdRDY08=;
        b=ppqCrzC0JPV8TO7U2+U/NQC4nqbau0r3zMi0AXo2GEqJ/fUpL/pgm58//2EIxo2qwq
         JS8BkcJN2qMwxgXvv5/zFewNCkOQZZyfQW/ErN6iv8zGwcRHCw5M9KkKXTYtH0k9pE7+
         6h/2vs9ZeEUYOAUWNwxHslmQXNwQRvhyhILnTslpEXU4FKwUuXQRvXw/IWonnl7Na/pi
         xkwJIqNgIIddLp5iByvCzzCJPeG1g/ZdtkxG+szPAvwqFvqJvYwBNsVj7XSKspcgumls
         lpFCae0RJsD2IhBjjRTXq+6IRNxfbmMvP4yQmZcCV8V13C3XWzal0P5CyfUAFs9v3GI9
         WSZg==
X-Forwarded-Encrypted: i=1; AJvYcCX36y53mK5LwKeKkRI0IS4vuxHuQiMAqt0Tc7+MkVm57jtIO35EccrmFmOlW+p7M1cTxzM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3KxhDtr2R0nnT+i+29uW85xcv1B3NteDR2IMp8zKrVuXXTDFp
	dsjPv0KPhFqnGFi99HqLNqpxl99T/4a2MbqeaXUC1KiffSAu1HSGyjC3671Do+E=
X-Gm-Gg: ASbGncv0SaTq6fJ00IRPTweS2DfievQWS3qUhc+pp4yhWzhlzROTsZhp5LVyIVxp+6O
	LU27liMm9pf2V/zJcZ5wKGVq1zQUixuzwrLSu9EIVqCGm4AWZVBgD/hX5dCfFUi2p8xnuYqnMoM
	0VuoXWjznv/omhEWJ1od7wKvnsy5i6ZRJg6u765KSEw749l9LtvfnKGlDJtWynwHKrq63o5a7Ii
	etG9/oTAEj5d/JXg8gT2wP/x1dCJGuY1I1xiki49x71nXRVuVQxhqDxUO/gVlyI3U72uFTdrQkd
	JH+aUGRVWK7YRLXOmQf+YEcLwbuKVYYAtxpZJSUE
X-Google-Smtp-Source: AGHT+IHdlJKhlcZ2kt3ODw4v558rSVu1ViDFZ39o1QmfrNdqy3wKd5aYQgrOUrBoY8TpFSoZhih5EA==
X-Received: by 2002:a05:6a20:72a2:b0:1ee:e655:97ea with SMTP id adf61e73a8af0-20e07c0bfdfmr12520841637.41.1746409974048;
        Sun, 04 May 2025 18:52:54 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:53 -0700 (PDT)
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
Subject: [PATCH v5 28/48] target/arm/arch_dump: compile file once (system)
Date: Sun,  4 May 2025 18:52:03 -0700
Message-ID: <20250505015223.3895275-29-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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


