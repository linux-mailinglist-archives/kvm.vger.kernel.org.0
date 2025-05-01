Return-Path: <kvm+bounces-45052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A812DAA5AE2
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 691949A387E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7BF21A0731;
	Thu,  1 May 2025 06:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vi7vNCEI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A131427C175
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080654; cv=none; b=MZYryylHmSB5UkbN7h1Ma4UvKNjk8eVJ+tZrITNLrA4ayUjHbeSYEf91lWw16omk//k4IV2XXPXgtOlZx6RVhVwEZDBTT1E2cSin5UE5OUe0mzLrS8TLzmm/DLt7etpWLw/XVvDeem0Akdtmj+pCoPN5lnU/bD+JcaGiXxpq+bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080654; c=relaxed/simple;
	bh=TkDmyBk1ur76s8ROUUdgZOD9exnir7BYC0WO2ZNYbPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuiomqMboVYzQM2PUfUWNiyovBsQr6kLPS/siAScXgh42D8xoCBypsSDFbKthfKJvDEHNM0+hGR9w2o/ZLInGW9bxh9DdFNxoH/xKKklF531gdJuJ4PcsLHb0UXUyOJTcI2Xv9A7Lo75xoGyoCSfFWBoOSs7J80CdnkajYrIyI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vi7vNCEI; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-736b0c68092so650089b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080652; x=1746685452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=miCfOFxcLwOy1CTNdjQhs14VDpxTa+yf7od3eWjLkPI=;
        b=vi7vNCEIfqqDpLdy4HPglds5PKw4wsFV/8usvlrJ+PiwjzJogCmJO8mkaS/DMSTwO5
         73MPW5VzwLbld1T4wgFMvlT2udbICQWFSShL+7JSeeuYci28UCUPuMuRWtYyn2lEFBNA
         upJ2QpAN+m2RmZsS2cyHADdDOK3aHoV+DFTpYJuM9ZZ2qNmzlK5vwg28iFSA2kdUVa1c
         22rZtW6OrCeAG1wEb7DBc9TeSwD10cnrFXSI3HCS1Wow0VK3y9nb+rzV05CMEAcYIBxM
         wOCTNehJhXTvWnHoXCjRepW1QLUhA1MEitWGjqYo524Pp4jqdVr2D8Jrjv/iS94L/94a
         buZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080652; x=1746685452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=miCfOFxcLwOy1CTNdjQhs14VDpxTa+yf7od3eWjLkPI=;
        b=O4ZDn/fnD8S+1LgcBetWnP4o+GZwlqWiFB4R2QoG0mzVBYgD1aAmDAP0S3yAwid7Gh
         T2+Eb24D6QLVaG4y+sxk7pkq5Y5NSJFDYTb1hbJQR0hZi8X4rh9LFwwDatDbQrpq5Ucx
         rFixR8Mf9PHfvsEahfF1aT+LUmQn6XOTOj4W/2k2VnspJbmfZJynmlpSWaCnBYdlt7AK
         xNUBtJM4iXMhPZJmxY9rZjb8No1JI0KJ75gotJBZApsFvg8MNo2h0PRUEloseXfqjnvR
         soAjL/N8c3epMXqFTDoyvdgpdte9u/o4A9ywSzzZKqT/pPeaHHwGJgbyloV0vXfbmCDd
         +nNw==
X-Forwarded-Encrypted: i=1; AJvYcCVdtj3Upmzqod9P+rKWW++/fl7w3YZ2DQNbEewtQqV4NqaIG78i+vCohnybJsDL+MhJM1k=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd8CNrE0CHM1AxNKmLEav5Vaaee01swVB4ueAbb2vJGZ70B+T3
	ICGO6J5onvPdfWNCmHsMBDuIsLSuGQ6sFEb9xbpZZh1EiY7gy/SchR+7t5Hp40k=
X-Gm-Gg: ASbGnctdzd4iTaOyzRMu2sGLEvBgh82T4DWLmHuJM/62f6d/XXkLGyc4KkRDqqCezVU
	exB4oVKTpLO7SllpM0PrjDB8hamNOVYv5HAH/RFvHYCAhOg1CZGCbnRhVSo2t6EWwHWHAlu/vl6
	BOI6M7OJMIbyliABDBwcsNeIkHXtYl9agdx1ueA6mIi8OoM8047CC3gDtq1fzNJpix4IrLN/qP7
	btfGtn8d5WZpkhMCIfdHOOBypgMMXQzPXbWDB7CwzLxy1+V4rzJyuUBq97xy7X2uSKJBsfOvN7e
	2OvQd9QiIW+sS/hv54McPmu8oER4L8VFjs4S+fQ2
X-Google-Smtp-Source: AGHT+IE4iNMjCRGNXv/fseoNykwPT2G0LRq1qk1LIkgMA+iLCoJoZ7bKEIOylarNXH7Ek9PQxpdm2g==
X-Received: by 2002:a05:6a00:188b:b0:730:927c:d451 with SMTP id d2e1a72fcca58-740492600d1mr1992567b3a.20.1746080652023;
        Wed, 30 Apr 2025 23:24:12 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:11 -0700 (PDT)
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
Subject: [PATCH v3 23/33] target/arm/helper: compile file twice (user, system)
Date: Wed, 30 Apr 2025 23:23:34 -0700
Message-ID: <20250501062344.2526061-24-pierrick.bouvier@linaro.org>
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


