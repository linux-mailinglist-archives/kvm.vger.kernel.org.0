Return-Path: <kvm+bounces-45366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A58AA8AC9
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF3B616ACD3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 589DD19D09C;
	Mon,  5 May 2025 01:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RtWpMYEP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD181C5D5A
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409968; cv=none; b=AKBun3Uyq56uqKTokMO0l9sn9uDnRI6RSGa4gQsM50wjinSJBqbT6LHZEXEHx1BxL08LHkeezOkqoIGdCEyUnooR+C2xAQmE6JlR1IznSyqpsDqRpIfVnoz6hxh97mBG3Mf0DjPqTZXVNrDRPQ4Ke5Z1DRSt/i2NAgU8jlJQ2YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409968; c=relaxed/simple;
	bh=nW7ac0NUfdnDJCcYnr3MXIbzudND0FOdxl26cRuKPK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QY3JHNcaEvfgSR8V8pVOHobyVAAW4g9TIuXjY46LjOk7rIPkY6E2XKFZpGNMVEfngNLW4PyN/DyLcVL0xAuXE9h7VsZ7xd+VS8AaLccVvyS1TkKF8eubWHNDR4oYY8Du46yQfqQIW9D6h0mEfZxbveYEyNPIbWPINf7PsA0eOp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RtWpMYEP; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-73bf5aa95e7so3472424b3a.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409966; x=1747014766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/RowU+G9lDkd5OLEKmfnzuDeOXrVzkwWk098+SYGJQ=;
        b=RtWpMYEPWaj2w30m4d3UBjy+YjuPwljzi9rb/V6kJ/cpJZtIZPv/bbGNjdx6kw1OrD
         NSAQhF+XNZo8rLSBzjwXOj3qF1MyZGLELqsmRkDqnnrC9ZoSGD3w2M2zFD05RxijBrPl
         uw8mj7SWe/W+ReoUprkMlOthgclNDZfsM6mR5to6hT0YkYN/cBhUQo4c37GnBi+usMKI
         OvdsXxtCciUA//kh9jJFaAgp6vua6IXDnXFoMrh5FETzPstGRbwmYzAXS9PYE5/d0grN
         R7S1Bzelu/B+GREKFOoeeWl/0S89eZ15gQ3GNx3Vb0jbG6zzIWoHmfyXZ+MqQBxFFKEL
         rnlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409966; x=1747014766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u/RowU+G9lDkd5OLEKmfnzuDeOXrVzkwWk098+SYGJQ=;
        b=r5kOgoK5Pp3ZXQcWz26encao9BzWAnrNlIPQmtctRRXWTuUinZ9TsfxKLhR0nkZTBu
         52kC8/08V9Uni9rhjVX7smAJ4RcU5HSMKvVZW6VfwRfWLzHwmCvmuaaf21ViKmRlu6qs
         yG8/PnvvTK2kjfTAR1FDEJbKbeIpP6s5bp0tOVrS4qaEn9GqiUSZog54HUeQOM26dJX5
         aeNtmZ+I7h3jBJM4tuqycfDfkF49HvCgG0H1UcHp/dixOscJ6Hic623qnRJphi1ggRP7
         joLZyQcK6ALNd7rtof99EHthFTkJ4XTbjC2Roc57btTYH5f9QcCczdLZuhRhvs/78ZpA
         uR0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVC76UyfPGNUY+LVsVjJBOqbsalF7LQ99s17zF9bVFMlzdXs7kl/Tb2KyKQuFneYZvZoQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkqtrT8nSSnLOdahE4/d4SEr2LIV0F91mTWO85XUoZpxVFo43+
	W+Pnl/Qx/p/KbGbJh2rzUMLin5zFd0jlWmLjbLacHzrYzpEeMUdPT/8/z0DMfyk=
X-Gm-Gg: ASbGncv7qfBLIhRkU1BYljZJc7e7bmnrAxPGY78I6/UvLxogDuG0uI3EnjrR+zG/rOP
	Y8ZwKz3KgaLV0C8YeI3+it2YAm1/huTpcI1drk6LbxYDjwRdHmHgvd3SNEd86lHWHsyY6jsb0dn
	WMisCYNXcfVPHoSmQLZ9HwJU2hIWxgC41GN/kLrzbP3FjyCruQ+PkLRErMLZ+B/WcE0ToKdqWH4
	4KVQyY9jIHFGgNzixcRLcxEWrXQD7aw28nkmEuetLsvt3Z6i27emZlr89++Q4A6mSIzguLhElO+
	BooSHjQj0mBPgxm+WJ9MBd9v4qfpxTcmkSDZuvXUPKkh1ujYW7Y=
X-Google-Smtp-Source: AGHT+IHvKSJobjP6MasjBNHYZkgZFCidjZ93WTofXhQPX9cCEfH7oVgrZaz5xL9shO2OYO2rSBmRrg==
X-Received: by 2002:a05:6a20:c890:b0:1fe:5921:44f2 with SMTP id adf61e73a8af0-20e969e9676mr7298784637.20.1746409966282;
        Sun, 04 May 2025 18:52:46 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:45 -0700 (PDT)
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
Subject: [PATCH v5 20/48] target/arm/debug_helper: compile file twice (user, system)
Date: Sun,  4 May 2025 18:51:55 -0700
Message-ID: <20250505015223.3895275-21-pierrick.bouvier@linaro.org>
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


