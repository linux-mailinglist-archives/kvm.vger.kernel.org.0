Return-Path: <kvm+bounces-45372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFAF8AA8AD2
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BB29168180
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05951DED52;
	Mon,  5 May 2025 01:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KUe8ApN1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860191D90AD
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409973; cv=none; b=QqDoDp1omv43nCq5JgJDkEXdQ3C+ofFRPes1ogmZtFL/QcIsMK+oQ2DqfsJY2v5ov0infLWQ5C4efevVNu59q/eqaJmBCMYwttIYsn7zJ00Y2MOm3IRxCd+yEKd2aFkV8fkKUKsDP1CCdEXfPu7iMr9707eWgaJ03xVHeG64f68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409973; c=relaxed/simple;
	bh=0ND4mB9JS7urQpEVchws9S6EzmrvFhsdvB7VUnUD0HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmv7sg3rO+OHMs+/gqiLby+1pQPxhlyLXFOcF+Gm2UKzjVIPwXbPgrqqH469q2YTC0iPEkzqUIoMvhjcCdkgXKwlNVldrNSGbvOGVJ10vrERAjV1v/EV6926PrbfX3tRyzNVpmjsQrVR0vmWriBCPLP84gImu81VQzumG6C8XZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KUe8ApN1; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-736aa9d0f2aso5194774b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409971; x=1747014771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DYtSZEbP1atLGb677pRK4UuiMz1CYlbqC5aWBJkLTc=;
        b=KUe8ApN1OOsTMJpNBB6qWlUvUutGw4ho3li6t/3JtxVTeMlKdRq6YXt5WGn/KEunC1
         DRtLZZlpAr+ZldImdOL3dz0nLxwcnK9Dc1l0laRlpoGBCmNjP8gv3CUVGHbDJC175OK4
         TZNn9W1uBN7GDcs3OY561xzama0yHmq3rAVxJKOnrkkQlqcwq9ekwXeTdszo5PSOjD4a
         0e2ZTJgvNGBO1tEPCv9vXa4jcukhKn9kyuhMgEA+hUiLdulTLcLuMnkZr/dbbiNjncvQ
         fPRv9laOV87RtBeqs1u9lfHKccTUOTVxSnJYdc66er1E4aqgZfZMmjic3t/fmzhmfBrD
         sy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409971; x=1747014771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DYtSZEbP1atLGb677pRK4UuiMz1CYlbqC5aWBJkLTc=;
        b=SE5Fetm94ttkP04MZ3y3Uod2LbeBtxbKy3ume7bN/hO0ypAkE6nA+5OHEGjUfumxC0
         vcdH2m5HBA7RxWq8Ka/WCQf1Z8AORcPEksAIFcY5U2KCehkyuPGkx5LaO1jtEFDhbE/y
         zq9wyyYNmJkCAu7dqom7Fjt2STdUlURl53YNyQjBKHBlNeLzySMQiXM8HOEFgu2fMiux
         Y5atMAXiYQSvF10EpZoaMq3QcrGl0qwm342XNzox9yOhxAie1M4gjcLDA8jdubyRdS2F
         NXn4i70oowN60qLyFbDhtOzE+oKuAQjLuxjw3bNzFQFW1UctawExnC9nVuU2zPkcXDdg
         CFhw==
X-Forwarded-Encrypted: i=1; AJvYcCWMVly0frDLGdJK/sn+dzS0lTJxcm8tHbjjKjkt2JJ4tmqNPSrUJ50vZsC6fQS2+Jcogzw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWZ1JerddCkM2l46wB5N5VCoVzj2u17VoyDA5WPF/K4SRkG1tL
	ltvWFP6G3j3SvqTeEpxAdc6j81anufwyLvkPq+1mUlUI1WgR28wCBZdV19gDR9Q=
X-Gm-Gg: ASbGncu35u2LvlB01N+wFCd8Rg2AWyzY0+MJIzzJNIdRCK/HiRIaI/ZLUn7sp7Xtk2e
	g6cN11QzfVS6GF/fmCWehPDdNkKhTZvpCoUKid4eyYRqIB3oKm1qrexulmX/ZjPd6pyPDWokCyQ
	los4d/cjql5s/RFWhhegYeDnFnQD058mdj27wrWInaOFkc8jxCDj6QxzcNhZtfvW7akD6pJVzON
	hzS7PUETEHHovVCBaoJT2NrqAViG2dim8yOUlgFgBlS46x99jU4A2ARbfgBi+VBvVXfU/g/62D5
	/NRDtcGcVOAoADGUC/h9c339Mg8APXCRjEm3EIJb
X-Google-Smtp-Source: AGHT+IGVarzG9+Ft7iZTh+BmJpw4oNqMHWcxpYoJIe/50d6p1PE5Wrx6QUAXleCla+pHMM66eQdcWg==
X-Received: by 2002:a05:6a20:87aa:b0:20f:953c:fb57 with SMTP id adf61e73a8af0-20f953cfbf2mr2868991637.42.1746409971130;
        Sun, 04 May 2025 18:52:51 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:50 -0700 (PDT)
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
Subject: [PATCH v5 25/48] target/arm/helper: compile file twice (user, system)
Date: Sun,  4 May 2025 18:52:00 -0700
Message-ID: <20250505015223.3895275-26-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 48a6bf59353..c8c80c3f969 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -2,7 +2,6 @@ arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
   'gdbstub.c',
-  'helper.c',
   'vfp_fpscr.c',
 ))
 arm_ss.add(zlib)
@@ -32,6 +31,7 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
 ))
 arm_user_ss.add(files(
   'debug_helper.c',
+  'helper.c',
 ))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
@@ -39,6 +39,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
   'debug_helper.c',
+  'helper.c',
 ))
 
 subdir('hvf')
-- 
2.47.2


