Return-Path: <kvm+bounces-45322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D498AA8411
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6F341892B93
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0F01B3929;
	Sun,  4 May 2025 05:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SVUAHl7K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EA517A31F
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336588; cv=none; b=r0hM730pXriuwTEFiCqkPTLO0wNGoAjKTnzuNLrhYEVXxZon9SB48Gtus8UpcJttrqSz1PmOaTmiSpE3mBKiLWkzhzsCmkMta0b5dnhXVR3hGH1LAsfUTjasSKd0nwIYeQqkUwMeWAuqxXDR747Dhwexj/AsTajZi5c3FrZSWNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336588; c=relaxed/simple;
	bh=jBQ48UUiTmKfd2YtIeycQ+HfzJJ8p0Zs5JvaTTN+QW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFrtfSQLTIolZ4hJcCCJkVOU8NRFZNBuw3lFIiWTnbvlT6LOp6wmfmA1SEeyodI88gLSSmLbe4AndwpJyilLyes2WaVJOemjXUIueXFSQGF9WD9imwWlL92fb4OnyHZDJKSoNy4g7HnQLrZq4LaFZJ2JsTr3vh0ywCQJOGds9Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SVUAHl7K; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2264aefc45dso53637565ad.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336586; x=1746941386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SeLT1f95/cGbe62bYfKMrzmzjdSaQ72IuCLuyv7ztwQ=;
        b=SVUAHl7KEHAOCNRbQ1PlMdlCfeJx99LOylo8TcN1MA6e3iPbBYo4R8sojrnPSpZh6C
         ayoAQ1RQQV71d56Mksp7HvCqiSglw4zG/abL8GFje9rif8ngaUDVRKPyCsBovoo/zt0e
         2yrcbQV4ToFh8PvateQhKN81eNSK36FgfIAAI78FExC97HowQubvKbdw2NQ+DdM3IJzE
         Cy+Np+/qfedV39hc4AkAk/xq5oMY3erGMZ9JLyTSG8lOn0AsQKDzv7U6HwTilPfDK9hp
         pfwuygVaD8p68mpG+aYAeiU00SB+aYTL377jXfRXH0p5J+9xh/PhwYXqdoUaq5L1rddo
         MxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336586; x=1746941386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SeLT1f95/cGbe62bYfKMrzmzjdSaQ72IuCLuyv7ztwQ=;
        b=v6TSilpU4Do1T01TqlhVsA1R8vGedmolERSywlfZjqLh1X9JKiv2Ss7G4flGpdihNR
         MilYxZ7mXyNF0bACujXfWSJLSiHgsP/Xek9oZkQN4c9Pt10ef8j5f2iJiRQanm66NvNF
         KLX4WW6cytIFaW2K6wwHUv5CRd5zjISW8M2zga2JMkeFQTgIpsZuF9k9qMr0epHyWcjl
         OIrmXTI5WoJIGFeo1SwK4DAJL4jv6a+N5JdBrNhV07Nh5dGBddbcGmUroXs/H3k4SJva
         Wx/45ywDaiiRj/wPmHQ6kNPQlu+4jUSZc0E7k/36MEUDSCRdFLqcpM9X98umDurHhbWq
         /2Ag==
X-Forwarded-Encrypted: i=1; AJvYcCVjV12V3Fki9XykVODGcqlQw8R45cvN0IxzDsqRKpGAkLQOI1BQFE4T/3XNpZ2qffScnRQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy32Zx+9VkQLVcwur0MyQlbb3GQCNnsyvYgYNGhj7LfIzIzwSIf
	K2+mAXAqA2iEUCKApclaTtbmeY2fS3YE7xcQJoAjG1MmRMPXi7+uvc0P56vAn/cMrbHydTCs4UK
	AKAw=
X-Gm-Gg: ASbGncsHdWDKf1at65Od9YQFPVBq2vibMuGmL8A/DOVV7+S9GpOLFdPNlF2rqj4EQYo
	H/bEw/fX+XqVamVG4EhmUoxQKKbtektH+KTlkDt8a/33xywnWVXrSjW/f2JsxteQD4kXvEZ0m4w
	zrem+ajNaFpiLyv2My2e1AmdG64F3enplKR5eE8SgWEk92tzhbxJMSmcv30mIAcs75Ux8aLuIWE
	PpGj4KP4JPOrKFobfXvvQ2ahblIKeJHe0Jtr+3LTUxKgIKgWj1S57XV61ZERnb2gF63xXOJxy7t
	4hf9loJ4d8fBufP8LxLepkofFGCF0ZY5dybF3t0y
X-Google-Smtp-Source: AGHT+IG3YwhSYkIrQWb9joOE66utyaPWKSvpqKpUrI0Qe6pFy1DfaUaoK33eaJpaAdCqsfCzd4IiYQ==
X-Received: by 2002:a17:902:c947:b0:225:ac99:ae0f with SMTP id d9443c01a7336-22e1e8ebb30mr45072365ad.1.1746336585772;
        Sat, 03 May 2025 22:29:45 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:45 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 29/40] target/arm/arm-powerctl: compile file once (system)
Date: Sat,  3 May 2025 22:29:03 -0700
Message-ID: <20250504052914.3525365-30-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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
index 95a2b077dd6..7db573f4a97 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,6 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
-  'arm-powerctl.c',
   'arm-qmp-cmds.c',
   'cortex-regs.c',
   'machine.c',
@@ -38,6 +37,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
   'arch_dump.c',
+  'arm-powerctl.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


