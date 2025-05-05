Return-Path: <kvm+bounces-45373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34827AA8AD3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:54:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3835F1893CA2
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19FF1A01B9;
	Mon,  5 May 2025 01:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UZUxJfzv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABDD1DE2BF
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409974; cv=none; b=qS0clZwaHHNtwQKty3+y+1OkzrtviTa1yzSdig+zJDQWyGixIUB3ZBkJOsxzNFeYZfH0bF3nmX6gNZ7ewT0ZFlF4Zy0Nbt0dqw/fWnL91bu+UPmnn9Nu6/CG4+JbX4WnpMPXh47SmBkkpMdHz/FKbJdpsRQs8sqejmrImoXj2Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409974; c=relaxed/simple;
	bh=rVRDTbWWEqwgabZa5zWcVeyAjZSJEYR9LpoFB4OvRA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiC2HvFuWYzKNJdHcu/2rozG9OZAaBIPMrPKu+/SQlZyo6bq6KDfA/KxxM73owuIs1NytD+1zuVJqV8AeUPJbx8WLtqhZzs2IckK/kb4OUu2v+UCgrHc04PgLv8+IA6D5DQ6Tusi9PmaAvogS+AVjgCpAGG/6orsC/n2NCnnL6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UZUxJfzv; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-736e52948ebso5050363b3a.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409972; x=1747014772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d146Pj4KjTAmT+769pG7plO/J3O67dCMeGHKPEFKjBI=;
        b=UZUxJfzvSAcr9+52kiQ/9wRhIXj39OKTn1FqbaRlLt8Z19AflaWk2N+rjipBxBUqwn
         P6YavkbgpIlFch8Y4JQJRLv0PHu4+nPzua0UCNnI9WOBKeHPZKYdO/MBvmrtsW4PunBL
         TRC43WqVLLPDiQywfOFbFtagDGYxVmieA/2vRLQk8/lgprHEgQrX/P5u/407SrJhk8M7
         1Mx38Qq7ulBOGDrzcjO2jiFPoan3Q5VEFPVds3XtdsPfbxmx4cpLgX2e5zZ5h06TdelT
         ySxgKP4dQHCSthw0a+ULBi98oB+o4BD2QcKTv68WaDAow28NgbtQkiibx06M0xH4BDU8
         e/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409972; x=1747014772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d146Pj4KjTAmT+769pG7plO/J3O67dCMeGHKPEFKjBI=;
        b=ZzyvJJ0Ss7knL2yRvwOaK0H4gyITSnKyxPG0T4eX2ewrurg5alxtdwo9Dv63ky1q8L
         bcrpFy8qqq0GcRb8reszT61L045fTOTBigOg4ye8RtzbwPjGwPZl+QmLIMawMa3/z0vc
         SRLaFpm0WE4PMcXEBJuAUXJzW/THkGg75OtTNa7Dj4t60JDjCViZd1Pn+eD1c5q1b2I6
         ajxVpsRvsUpHJRKr2WemE3KeeODWNSCCs0S3x2dERdPK9hUJIbW2tYicTsKnY9JbCmO5
         MyQwQ/SxfOzBiYBiA3BUhbodBaImb53arFlS6toMCV2cCaX+lWDuIGOW7EYH1Cyn0tIM
         Wxvg==
X-Forwarded-Encrypted: i=1; AJvYcCW/yMS1Eb7W7vty+SufzfMbXXG2cayRVnRjIaJ0f9TT430fxp/QOVSCuKjap//fbqUq+oA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfCFMHhhSS45td0Luvm4ufId4+5VOeSLxbaWDX0TR1pMGy2EZa
	U+ex4q/Gz7D7mNwyOzRJIJbmUojsYshqgvcfI8d1dh6G3G7ez8IsU7fkpTkiS9I=
X-Gm-Gg: ASbGncst9mSTDIDctA2aP1Ei1rC5RCEmAm/bNMf7mCNxBZzUWsBBTVg18pVr4KEorJH
	0tsHsIxnEhcrxhp8pzTCt2mK27wsSrMMFiUN2zZ2etM4XBUhqWm7HIVYEMmnmB6pC187EO0nrsc
	GgAaltKqkzoZQxIgCAlRNpu5RfyCnnlgMoecuXzpnFz+NVQVoYbxa/wZ71xd/TeEBxu69OLef8v
	PlHXmhAdxDPXbXsIFQUm4qM+ZlwCelWpYBz45AsJJ3li1UiGhcstAkTCY9K6pyivgK+x2z/UGkR
	XAAgCyABjDgAa8+SZnXma20SACEW8GIiLOxgYL6i
X-Google-Smtp-Source: AGHT+IGZ69sv3kczzHn3t5JXlx8OboELStxZ9BcN0YDHiBVacizLgdUVZrm/NwDxt4C9RQMegT+mlw==
X-Received: by 2002:a05:6a21:998e:b0:1f5:9431:46e7 with SMTP id adf61e73a8af0-20e97dae814mr7597572637.42.1746409972003;
        Sun, 04 May 2025 18:52:52 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:51 -0700 (PDT)
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
Subject: [PATCH v5 26/48] target/arm/vfp_fpscr: compile file twice (user, system)
Date: Sun,  4 May 2025 18:52:01 -0700
Message-ID: <20250505015223.3895275-27-pierrick.bouvier@linaro.org>
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
index c8c80c3f969..06d479570e2 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -2,7 +2,6 @@ arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
   'gdbstub.c',
-  'vfp_fpscr.c',
 ))
 arm_ss.add(zlib)
 
@@ -32,6 +31,7 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_user_ss.add(files(
   'debug_helper.c',
   'helper.c',
+  'vfp_fpscr.c',
 ))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
@@ -40,6 +40,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_common_system_ss.add(files(
   'debug_helper.c',
   'helper.c',
+  'vfp_fpscr.c',
 ))
 
 subdir('hvf')
-- 
2.47.2


