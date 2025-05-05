Return-Path: <kvm+bounces-45387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0AA9AA8AE9
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45B87168918
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB881991DD;
	Mon,  5 May 2025 01:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X9Lzjqqw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531FEA957
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746410186; cv=none; b=FKTwWBcWoDr5rq7Ob8TF29EGaF17mZ3PwwD3BAigXrUudtzsFijkcK97lifOOWUIeF6Xl7pSUJqpfTFBHXppRCo4JRDGvmdRkcfY3VbvyyKPGhgbeWe9hEXjbZC4iVgTUXXeunLXQM3bOIN4JweatX7epJrbopcQh8Ql6BqKq0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746410186; c=relaxed/simple;
	bh=/zYUGtiopuAnKe6Qv0yETkvli2mk8237qAU3JIOPtdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqnOtcq+A7k6dsudCVI3er0ZW30EHBa07tPnDjSX7tn0KXwx95csXbOf23VgfIIjkrlzenz91rLTwJ9D9q/4IEBdnXIi7s/3GPlERB8iQkBk5WV0F0hsA5W8HALtiVpHbICV+I3LCIwAw1jbTdsCWpOhJLltDSjOJlQzVADIrbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X9Lzjqqw; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-30549dacd53so3293092a91.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746410184; x=1747014984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6rvyCptpZZum3a3XLfgy4KbKHlT47oeB0wfjegrLwc=;
        b=X9Lzjqqwo3bL/XAmGZukFiHPDMxIm0SLXDqjTmKaUrjZvDDZNOdsaf8111aXYO4SDk
         pEoiC4LcgjghbpzCQSpPy+Kk67p+cKWPIXvDzfLYYzz3/r8QBU90+yW/t236Gh6hkoc+
         +BANSQAsjuDjqbFqfaS3Eh4Y+6LpVTAea6Gpu0fh8cgjI2eKg55MUBAxMoC2LcBXTcUE
         t+kYRJIEuWZhLkHtMq7UHQGJb30DMA+SpKMoQiWRc+4nEbk+wq03L8lvxZ9xeZcoyh3B
         sFbNVIYnMaz2GxBGIBkpSwuAORmzg9FVbcQvCZfwHc2/gH5LwUOy8eAVXJQBliDWtW8j
         hiUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746410184; x=1747014984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6rvyCptpZZum3a3XLfgy4KbKHlT47oeB0wfjegrLwc=;
        b=TygyZzuNNX+JBk2bEKFGWluStGH4q8o+ZZIVh/+Bw7b8YArzgsm63yH2elxrOJ5kp/
         cYaA4nWk6SGTZAGKQj4luSG+WF02DXnZYPb9+0Iw7aQuRq9JB+B+CDZmzHsLcsl3iTVu
         Ah23uMtAy2hs/frd5qIOmj0gsEoeZHk+CL9lyyap6FCavPHZ6h0SI97sGnVdYNyJgfga
         mADEojiWS85MuEpAgE+AT3EhASzbMenxrDr3Pza7V0xVpj1yRz1rapJPMQ82Ijs3/ubK
         gMQOhXMVU8fp98MXOPAPELBOVyaRXrEIHcBQgrOo5PsDG4RoIb4mH6XSxd0jsBqsk0/E
         +znw==
X-Forwarded-Encrypted: i=1; AJvYcCUeTzboAjAgdrBLqwW7cig7BDj9MZY9s+FYybALg/2ezyFxkGVNHhn+Gi5J5D+bkhAqLuM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+6elIHzshooJNgYLyIiBL1PNY1zE2iBiKX3Wwp3+v4U+Ehixn
	7tsiCyqohUztUuJ/PilQn4YuMQiM0h9KoG9hVQYj9Oh/aftoaQMiJo3Uv60Wmio=
X-Gm-Gg: ASbGncsD6LHA8F0dSwiI+zhusvJrUIkbtWPty5CP2nPzo3v2FHUxTOI5EhfQK7eavGY
	rNN+LTlILQyPINc8xKrGgBMeEw6BmYdstDuQGBxq0/khKjXmPPdbAie0nhwe0BhPR5PaRz7rJrB
	IUC6s/S3nbEquRuJE01WNIzyK3MR/9gGQN42mkxuFqtfohziZOeKxp4S+EJyW4IaA93C7BHyaNt
	WUSR+K6TJkX+C21M40C8TMfY/1C5jrAf+h2PZWtBkERH00gm9GFEZiccG0Lt2KZ8u2an3A9gN0t
	gNTMDiGSHZTLpl0IdF2yuAsaZpOcq/mzmUX90jzm
X-Google-Smtp-Source: AGHT+IGit+JLh7j94oEa65elMcYUy5zCoUjV9A6bao3GjfXJLsS5Z1ncHzwZWCairFLXqpsh9XIIvA==
X-Received: by 2002:a17:90b:548c:b0:2ee:c30f:33c9 with SMTP id 98e67ed59e1d1-30a4e228570mr16054269a91.14.1746410184424;
        Sun, 04 May 2025 18:56:24 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a47640279sm7516495a91.44.2025.05.04.18.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:56:24 -0700 (PDT)
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
Subject: [PATCH v5 40/48] target/arm/machine: compile file once (system)
Date: Sun,  4 May 2025 18:52:15 -0700
Message-ID: <20250505015223.3895275-41-pierrick.bouvier@linaro.org>
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
index bb1c09676d5..b404fa54863 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -13,7 +13,6 @@ arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
-  'machine.c',
 ))
 arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
@@ -39,6 +38,7 @@ arm_common_system_ss.add(files(
   'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
+  'machine.c',
   'ptw.c',
   'vfp_fpscr.c',
 ))
-- 
2.47.2


