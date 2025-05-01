Return-Path: <kvm+bounces-45046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A85AA5ADA
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33F239A3C17
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C1A527A457;
	Thu,  1 May 2025 06:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZbpqV9C1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313F626B2B3
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080649; cv=none; b=nQzjaZhGOtaoorWWRH0yC/vpeuiSFh9+yF56Ytlv8VZc7zwMJkYrsyDhZQbShXtEqhigjAge8yHhQDUnSEmHScdm6ksg7pyLor2t8P/XxqH/HnOz+YYoyynloVTKTD8/Gq5+LWL7pMcMXVG/BuqnqHeGHLPUA7viQftktyWM7RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080649; c=relaxed/simple;
	bh=X29XPnjO/+sTwdF4ZO0Y7aIafhDUBXf/QA93ekzOlGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6eAzsZ3/cePLmRPkkMKPBXuG1RbINDOOwV1SCgN/NgGGwyfkUwk+TzIOb2AapNzzvU1En2dTpPIBbbYEK3+5XyI0Bx7ahK62BPC4nW1hUlmaHmCw1umEX3yq8K/+gzm+T2EfsbzEn3cuNHNbElSb6Itdkn6uJ2gHMnJ/sVz99w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZbpqV9C1; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7398d65476eso542065b3a.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080647; x=1746685447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qzuf536sTBCPBJh4XYxjRVhgJRgFP2T69wvlX9E/0Ys=;
        b=ZbpqV9C1MVPjBD4nRL6nYP375gIcpa0NIFn/QznHeCVz7I3cCDhftxw5TdVk6HqZC4
         SxWDKx4h878z7HaJhMg53v/ReaizD0VNjgYZIattiKI8mnQf8U3OLfm7N8rkPe88KEee
         FpGzCWJ3y5d9HAflN1hvwuj1p/1wqc4FVqhc/HI1bGHRtwoEbIbpgFheD7SQzm36nTyQ
         nSdmnDTVwLXALRWf5will3VfkrLvGNaaOWCePiE1UhB/sIFidl2X2rzaM2FxqVAjRhm+
         BLMpp4LkrxjkTo2eVrYDOYnk1wZwnimBS3AUZ073OrnR153ZJToxtGxR1xi8hDtFQbS0
         6FmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080647; x=1746685447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qzuf536sTBCPBJh4XYxjRVhgJRgFP2T69wvlX9E/0Ys=;
        b=qScstrnkXf22P631mi9n/89sLoeFdiOMmCCxHKZRPAhhoaEHzH/piCiOLmgSXaNMet
         I+vQU/YHRiKi0sn1DFNlgqmqXUqHWQZut3XxhvwRBCwsfK8VOiUizPK5gE0nhHI/neDt
         vLELL8Xpc2be7jK398qQdofZWy5CegibErSRnC4HM8fpGYa0/T+vPOjXAOa7B2goLaez
         WZJ1oHzPTSYa/lUzMewpnmk5ldqs8yMFlpTapp0w74bQPuLyOrm9e8S/BRDuHe21ZnTU
         tSCXZZIjTy/EtRMUuroie85TOyC82oMYOc69IOGWlHCSzjp5lRuuv1UCeCOHPDg1f1U3
         qlNA==
X-Forwarded-Encrypted: i=1; AJvYcCWXYp8br7JijknQmE+m29jqUwq0FAt32LbUjwgIa3uriPaHWWajz3vd0In0YaPx2tEjdEw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKocR4VTfN7i6KJ16WAkkXrgo8eo7qOTmoUi9Y6BBImKjjvJRE
	BqkH+2DoOYzSvsr1848Nk0W4lO0fQH7qf7blBBy6LEyOhlhme6dV/1Ou9nFufKE=
X-Gm-Gg: ASbGnctmfpZRQjRF6Xj3kARZnluorbt2tiOpdoF21bd4ue0LOLW3dr9YO4HS16A7v8k
	33gG3Z1HXw0FQkpngGlUZI3EkehlS2m5C4/7zfKc2ESTnRhWGIEucceDm6wldDAnJ4rYRBg6Usp
	ZDVf8yDdQszQwPvbPBvh68FDskMcANzr9ID5b5NUs7b7ps8ztf8GreUvFm0s2QSu46mxKtTSm/B
	kxMmgq3Pkv6r3psIdK6T5fXizPd78UscRGpdZp78G6KaCzdp14RRUeGMfOPhPYX1GIltiBYve6S
	uKtOKhisTupbE9i4QzFbsVzC1ePT938Tg6XfNCqb
X-Google-Smtp-Source: AGHT+IH60rvhXzsLotyuJD4D+gAsur7uGwYqaWIbCE5FyrkEs2z+VtwB0w2/b05zf6FPVjJahWsiMA==
X-Received: by 2002:a05:6a00:38c9:b0:73e:356:98b0 with SMTP id d2e1a72fcca58-7404923d1d4mr1814773b3a.8.1746080647585;
        Wed, 30 Apr 2025 23:24:07 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:07 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 18/33] target/arm/debug_helper: compile file twice (user, system)
Date: Wed, 30 Apr 2025 23:23:29 -0700
Message-ID: <20250501062344.2526061-19-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index de214fe5d56..48a6bf59353 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -1,7 +1,6 @@
 arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
-  'debug_helper.c',
   'gdbstub.c',
   'helper.c',
   'vfp_fpscr.c',
@@ -29,11 +28,18 @@ arm_system_ss.add(files(
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
-  'cpu32-stubs.c'))
+  'cpu32-stubs.c',
+))
+arm_user_ss.add(files(
+  'debug_helper.c',
+))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
+arm_common_system_ss.add(files(
+  'debug_helper.c',
+))
 
 subdir('hvf')
 
-- 
2.47.2


