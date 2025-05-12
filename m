Return-Path: <kvm+bounces-46212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 300CDAB4232
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86F9E3B2B11
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0E92BE0E6;
	Mon, 12 May 2025 18:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y/wBwEoA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4282BDC12
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073124; cv=none; b=DqcyN1w/bKIcNZGxyFQxWzgKkdgRfK6CsodNBbluSJB6jx4dRIZXFFJ+eL6JwUJ/hgWS2MslnYa4FVUBLdIgxd5C3m0EJi3Qge5LvAWz3Nk/Aq32JhhNfxlGho8YfjCB/L5UXhuXWKC7caav2dlJlXCrdCljaNGp0oC/638mbIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073124; c=relaxed/simple;
	bh=AEdec6YxwqEM2SMva6W9gXoK89VbojQSf/TWlriKM5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV6oNxNm/H7Whj9J7nrLP91OYEgsJft9CGLkkyzMY826FFLuQNNed6y2mbE1SmFEpwXo+2SJfE2cUyVvO3sbhqXJCAkeZ1Z+G06zNbazy/PzUvaGHu05EgzJLqhMF7EhyayYuk8KLii8OCNGHA45Wjklz5vYWdVWN1oNtDjCdHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=y/wBwEoA; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22e8461d872so45540355ad.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073122; x=1747677922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=y/wBwEoAZecqrIr1Oodetc2Kj4Qolv61YQtWk6iEZFA7WS7ZoaVJO5vpGqL2WLl6xP
         RVFI67SQyOkesV7ctjkBpem9+BcUgsWHrDccCuuOZr721BwnVdFuc5am5xchSCF/beFs
         oA2umgfb1YLsQM+RynKmfLrrScqhNtc3mCwlWWQLyFK6UkJOJtLcFUX6FQQhhYU0P63R
         A97wNxFY+1UReEFdbVNT6w1yqQCanOs33TYe3ZyxTUp8wwToxlDjWnhaAzleu/+DVqGv
         KMHUDKOvSGxTQLbYPXLoRahRxCCSbJpheibtAI4SFwQGwHM+1oANnkWxkSyIWHMK9Jv6
         J0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073122; x=1747677922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=tjXqp60y9WmLidzE/nDtqKHisAEhtqUSWdh9OopcA7jnRLoYkFHA07/Dp6OOE8dHUy
         icLUdz5ECREwTqIVhPJXbR0L73mKEEfCwi3uvY7tcSsWwYnbSZUSI4+eo1GpweK8KI4y
         682oM4SgygGdFw2FGIMV5qD3pL357QnRi7jPeGQb7taadE6oItHcPT6ZocBxyJsNgBcf
         cihn0/qxyz4ZGtcygDZyqI8PZTWKPznFewWmrFOa7mhntPocW4bhAUv709BGhrHfPVF3
         tErs8NgTFZ6OrVfWz4m/GOhzjkTuiM2X+R1VC+/U85q0PcAZ1nqygylGOr0mXrES5u4z
         3tKA==
X-Forwarded-Encrypted: i=1; AJvYcCUqEO9WYkH0r1ORLtQmlOBuVnwlFH1v/XEAB+yX2xrMz7Ag/jCMXiY7ArNxZpysAK0Ds7I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1XstaJ49NpUUk+KjSS/tkjiASeevGq18ON0vaBYQm/8fTVQ64
	eqkYgi0PaSehsMoQFiTvdCGHgOkyQk+AWg21Q5D1RXGxX7Fd5UV1E4UBraS+eQQ=
X-Gm-Gg: ASbGncsG9Za2WhgJZV4IvkmH1mq8uZ2JBxon/aqt9Yd5VO34YMTGTnNZRhtoaYk8i4n
	JhB0pAwUR6EWf7wc6d2n2pmpgnGEW4t6MlsvFdB/xpRsPnNS+TU+D3kRtq1K5r+9bfOOaXxqiIl
	hxqDiuOlwVhlK2F4Wjlex09OWvpqjv0EYTuPDVB3Ht4m7p58sL5nx1nWelahAdDxZ+OZnGc3UDO
	a/epw3sJJm/baRrMCfqQQ1meFS3WqAQbF/6RHT//Z4J8UI49HVezi3mc0b5XU2E8deOQ1OSC6py
	zvlwZJ8pcbGcpwE8Klgp8GH+T8mwRlGfktF6XX+OUqAlMjUw1tY=
X-Google-Smtp-Source: AGHT+IHpKFuSCTSiVQdUzZhZS6mF5YhbOhklGnyzh6uu2TTMvgGfDj0vX8tWLok7xquOCnqAQWr5kw==
X-Received: by 2002:a17:903:186:b0:224:c46:d162 with SMTP id d9443c01a7336-22fc8b3d8b2mr169123125ad.20.1747073121680;
        Mon, 12 May 2025 11:05:21 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:21 -0700 (PDT)
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
Subject: [PATCH v8 11/48] target/arm/cpu32-stubs.c: compile file twice (user, system)
Date: Mon, 12 May 2025 11:04:25 -0700
Message-ID: <20250512180502.2395029-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It could be squashed with commit introducing it, but I would prefer to
introduce target/arm/cpu.c first.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 89e305eb56a..de214fe5d56 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -11,13 +11,9 @@ arm_ss.add(zlib)
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
 arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
-arm_ss.add(when: 'TARGET_AARCH64',
-  if_true: files(
-    'cpu64.c',
-    'gdbstub64.c'),
-  if_false: files(
-    'cpu32-stubs.c'),
-)
+arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
+  'cpu64.c',
+  'gdbstub64.c'))
 
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
@@ -32,8 +28,12 @@ arm_system_ss.add(files(
 
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
+arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
+arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 subdir('hvf')
 
-- 
2.47.2


