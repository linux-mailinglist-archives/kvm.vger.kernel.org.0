Return-Path: <kvm+bounces-46218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81ADCAB433D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:32:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5676D7B1291
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E032BEC43;
	Mon, 12 May 2025 18:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bpUXo1QQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90D12BE7CA
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073130; cv=none; b=Yr3pLmDU7GeE3uNhndZj0MUaP1Pg2RQsaUjShXZ9bng2Kozgsj866hWZy5iPVQiDk4e9T7IEobti0AOLGV4hkHqLpWBkDeJFkA7ZrGSenhzzese+9hzQLoXxGd8trav+4t8qerrw0UullbSvvX6FRMRr2poO9B+fkrZihMaPZk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073130; c=relaxed/simple;
	bh=nW7ac0NUfdnDJCcYnr3MXIbzudND0FOdxl26cRuKPK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSCGAust6NAuVfPB9jOpthfFqYybdrSij2223HKRLLME29Ro9YJNY7Ac4u7id8QmL+8GSO3nUN8t+MF6F9ibQNpdfEtW3vRnKpMaDUvu+ZtHGPjZa0PnLhxjjXl/X5A0EEsrJtAZc8pXGChBdhkE5EUBcHeS6oI9zyOlBEO+Rlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bpUXo1QQ; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-af6a315b491so4169368a12.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073128; x=1747677928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/RowU+G9lDkd5OLEKmfnzuDeOXrVzkwWk098+SYGJQ=;
        b=bpUXo1QQRJD7qMXbPoAlg6do4TcY1mK+EtC/LLljxBcXC/YGfjkVWQ2eui0+TyeJIa
         x2a4AmCLw4RRhwKalj3XmaUMW2GPFF4NWR4hcVM9ANjzS8W5xC+5d+/rlGtd3qdJI1xG
         Whj/fWc8CU3h9TRgY3SkaTOFExBXfaaFwS/2/7rB1+q7Kz3rvYMtdLRq3c5LUnvLHKh5
         YFmNT6sdvJdfTC7EMPByunz9SW08CLwjYc+QpBAEvKfyT9k/X5T1KXw96PTLHGn1pSlb
         DrLh0Fud+DwA3J0Iq5cE0hf/9ADaUT49zAB/kZmoYdhdy5t6pKMM7sE8BDFXkManJ1oE
         h1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073128; x=1747677928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u/RowU+G9lDkd5OLEKmfnzuDeOXrVzkwWk098+SYGJQ=;
        b=a/fv4kK8nb6pW2unw2AEYb4JHr9JYyIQp8Cm8e1snq7joQKFnhl/tcAT+7cEWL3CQm
         dH+hbiKgSoNdFXDV6qqSlRfMDv90R8PN6+Vn4b64CQTriYUoohnyiuuA0TMKhFB/oKJr
         ivN0A2JsaG4/E82zEwcEnoVBVdwCyPAGtyDVKFa0St+rw1XOoBjaezdco3qZ5u/mRIVh
         LOSBmH2soP4bvH+nA0PpY0665gJx7wFmS50bU3wZabxLFT2G5ZEXv+moeuERm9yPCcP4
         EvgDj3cBjKM2VRoL9UL+xGksMZTTIHuXTdyaVwzcJ9tlrzVRiHR8WX7PvFo0Geo2Dxej
         usww==
X-Forwarded-Encrypted: i=1; AJvYcCVQq33nWdgi7IpM89tA/MEYexbAvi73kfOUvVSuWpdsLc1RR0gCYe04cM7eg2eashr2niA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5+kFm9hBYX6eF/OPYsnvceVVSnP0SCyV2pB3OyUfHqsLqGk36
	njEhKlt11O6CIn8SEpZfA4oWtVv25OiW9EV1DP2umdHiAG3U5QLNICbnj5L/5I4=
X-Gm-Gg: ASbGncstvO6IZV4UtFX9qkioRh2ljqnJz8YkNf6LjSIQfYL+jJmtMFfSPJauA4rYs2H
	GGsSw2tnfDDF5zhq8bZSqsobNxOCVyc4dC3+BNzlDJa3uzU5Kra1r4cd42ta/2BVoce+ze6Iy/s
	+TBUVUmW2wo0Jo8f4NiOxvERJ59aij4/63uk1nY9bnlGwiZrNLGTB0F07I/W+1pobtghwAs0T6Q
	BR2vXz74S8h3UA3xBQmISLR3RYjjcfmhdXIspWRkAt7WHUFR6R+Zjm+akBsq4vFdzXfNdsvk7A1
	fk6nCfqV/qBs3sToD9EbG7rOXMdMW9Y2j+OFBj6i63PQqJUZpOI=
X-Google-Smtp-Source: AGHT+IGBFLyUXnJODxwQklVoTmHypYD49+fnU1Q9uQoOxl8BDjJ///fY5fDQpGikfqEEvaljvptQSg==
X-Received: by 2002:a17:903:2381:b0:224:1609:a74a with SMTP id d9443c01a7336-22fc9185e2dmr242500925ad.34.1747073128103;
        Mon, 12 May 2025 11:05:28 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:27 -0700 (PDT)
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
Subject: [PATCH v8 18/48] target/arm/debug_helper: compile file twice (user, system)
Date: Mon, 12 May 2025 11:04:32 -0700
Message-ID: <20250512180502.2395029-19-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


