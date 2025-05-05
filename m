Return-Path: <kvm+bounces-45395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6D2AA8AF3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22A6416489C
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6EFF1991D2;
	Mon,  5 May 2025 01:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vozwerAA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9945B1A316D
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746410193; cv=none; b=qiA02GGkW7ubaP0/Ka5xVujrjhS9ji//i50HtkO7qsXRdCcfLCrm9cFrE7AsqyOnIu3enB1i08MKLNhnZ9TSdnEvcViWpuNgXAQ1xuCefzySYnyKpUeEuh5JBajc0ZO5X+JRldMcLit32VeofPzgqU6lo8ys/v8mY5+4bAiQbuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746410193; c=relaxed/simple;
	bh=ahrZ5k+Ow3aa+pRIYB15I5rEpCLVaNzIbnnR6Mx+SHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CP81wJbieIqdxo+8VWyBpiJBElyiNYC1SHGjXMrndBUhwCjhdP0xt9sGORqU8kXD5rz4Eakmk4qFiYEDLNLro8TNkmOO/0yB9R2gjb+1axvB616eHNLZQJ1SoMrnWsXh8XX6G0hVwYcTawablXnU28/jdJwbhS1WeAim+R1MPmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vozwerAA; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3014678689aso2981349a91.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746410191; x=1747014991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UaIKPxnuDIO9RtYHmPPx5mO5g3g9VX4P8Ofr9oTYv0I=;
        b=vozwerAAqdxPG8tf8Wnltfh+/kT3OQTxx62kjvfu8sA1vjxngbWUKZDTCL1SfTcAC6
         QaTVfhkijhQfkTvH1o8WuUYRn+U8rvJfRo/Z1smAhUe+ZGa3ZGruoUEqbaS7ZeAsmztB
         aUznXrmmsRyNYVJrDX72AX4rPMP2WcZquNwvW21bV7FAcHBE/3XMBsaAiR3M9Q6384N3
         pDKYMPitX4Jrv5Wo4Ql9odXNzWpxRs9ayqt6H/RADTBXViKk3FSGr73HXOXlpyqyySYd
         0OaZyvSl3ux0mCrtaSILcSGmoSHpPNBtsdPOxnOEibdNOrLUouYVhdHL+zMdS7r1UTX8
         sYJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746410191; x=1747014991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UaIKPxnuDIO9RtYHmPPx5mO5g3g9VX4P8Ofr9oTYv0I=;
        b=OUePEYUcHkxhpUWCR87XMumLYubnso3Hk0Mvvnx0pNfKtRKKTQSTlLoekXu/H3wFY9
         leFMsZiMxMJXs27XJFDQ5xJIaXKRjU7eL95LwW+cVdlruVZPSCU58cbL3AXXJpv1CXNS
         D/DphDFLMwmfrKHA44GB+/QP6o8Czzp9yda+uQK9o2OEog56fTVW5ZmuDd5vl7eYSIou
         x6ynXu3J086ojwuZQfnCX42kVLJ1pchH5e6o5S9p8JD+Vxr0ML61n9jn8rz6P2Cn9jbp
         8FtyvpZ73n3PHbwv/NVKHxGsAa58wmHgH58DABAgFHDphADecg3XYFWELeWeXvmTAziY
         cFZg==
X-Forwarded-Encrypted: i=1; AJvYcCU6NJOwuwyO5z52oyiJF2U3NiG1/OyzhBCEfc1m7/d9uTfZlGLtd85mrZccYBTwlqi+ztw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYexZAKQ5yLHoour5RccFgyh3mfgizNsU90iZEx00xacC1zhbD
	wpTavcFZjGhRR8nnknN54FEXrfcldtbeUiwGJ5C4nw5k+QhnFqY/pSfdr3YrRiM=
X-Gm-Gg: ASbGncthhVQmRYZYxC2ZP6WynsBAqeJOcMNcndLx/JRN87EGxYIrrgcgejh1bh35P8/
	bxbEh3rvpR1gpVPbtAKnBOGJrq1CJGmb5w6OvsFEH7IkTdE/3GB7YpeTtFk5Req5JpuhZw+nIhc
	v+e5dPLSlZ2vG808sSzMWXhbgyPj5mxa1MrR80DPz5Xx1sq5LPWqf/2pSh99/Obf5Y20PIcs62a
	PwyOTgJ0sn/IS+IjJZ7boZPvDOwEqcqWfG/AxxCiz/9mo+8UHCQRyIszu7QljEJFb5Pyylx1Xd/
	MO4Bw7aoLle6WUy+qUGy1G7uR5v629JiAMVGLOEQ
X-Google-Smtp-Source: AGHT+IGasy7FjzgJ95jnC6u+9mr0bhUE6vKNVWFzb5iSdvQTVXKhLaRg66T02sUairn8/pITB2lG9g==
X-Received: by 2002:a17:90b:5868:b0:2ff:7b28:a51a with SMTP id 98e67ed59e1d1-30a619a53e6mr9850659a91.17.1746410190956;
        Sun, 04 May 2025 18:56:30 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a47640279sm7516495a91.44.2025.05.04.18.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:56:30 -0700 (PDT)
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
Subject: [PATCH v5 48/48] target/arm/tcg/vfp_helper: compile file twice (system, user)
Date: Sun,  4 May 2025 18:52:23 -0700
Message-ID: <20250505015223.3895275-49-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/vfp_helper.c | 4 +++-
 target/arm/tcg/meson.build  | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/vfp_helper.c b/target/arm/tcg/vfp_helper.c
index b32e2f4e27c..b1324c5c0a6 100644
--- a/target/arm/tcg/vfp_helper.c
+++ b/target/arm/tcg/vfp_helper.c
@@ -19,12 +19,14 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/helper-proto.h"
 #include "internals.h"
 #include "cpu-features.h"
 #include "fpu/softfloat.h"
 #include "qemu/log.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 /*
  * Set the float_status behaviour to match the Arm defaults:
  *  * tininess-before-rounding
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index ad306f73eff..2245bafbe15 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -34,7 +34,6 @@ arm_ss.add(files(
   'mve_helper.c',
   'op_helper.c',
   'vec_helper.c',
-  'vfp_helper.c',
 ))
 
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
@@ -65,6 +64,7 @@ arm_common_system_ss.add(files(
   'neon_helper.c',
   'tlb_helper.c',
   'tlb-insns.c',
+  'vfp_helper.c',
 ))
 arm_user_ss.add(files(
   'arith_helper.c',
@@ -74,4 +74,5 @@ arm_user_ss.add(files(
   'neon_helper.c',
   'tlb_helper.c',
   'tlb-insns.c',
+  'vfp_helper.c',
 ))
-- 
2.47.2


