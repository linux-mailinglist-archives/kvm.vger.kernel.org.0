Return-Path: <kvm+bounces-41356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E34C9A668AD
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A7991763BB
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95BBA1CEAD3;
	Tue, 18 Mar 2025 04:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wRmQegX6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611FB1AC892
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273503; cv=none; b=uVEIHFIDh0x7OdQN0yTK6gkPYfZpV1kOeQ7df0ZxouGQmmJ2dZBk3S951+ooIFRBYVJTxWoh2tZg/em/qrdD4qIwvjTDlLUbv7jm0BY9bIhSpNCPd1ZbN/ceTUabzuxzPSdKFF/8u1UZaTBR1KcWozTbEacWBTZ/GWXgdRLef/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273503; c=relaxed/simple;
	bh=36KPe9XcKxa98v8J5OP3bBIOfAN5JP+TUtCz+O1CQ6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ox56nVhf6+0O7nz9GrirsgjrDdtTxt9ZxlFtYepcjCJ0PYLduaJIXRbKF6aRuQvKB37T3OWsKx3qk2v8PIqicStN6+OonzvHY8ZyxT1lONBKh7OsnlR+ZcxdTBa7V2iiW9OrC5NI7WcPgO3jEeCs2KAIk9Gw4CWwv5txhBfiQQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wRmQegX6; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-224341bbc1dso95649525ad.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273501; x=1742878301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zREl7MPAGqYRU9KvXrtENxfPFFrO3Nb7yWvR8XbX8nk=;
        b=wRmQegX6Y5ATqvTc7LxeBmcYcTCR+js7nRPZIPcHgZwe0OL2jW3RcJ6BW4ygWDT03G
         jpzTZMt1ZaBHGw0MYvKhMlpg02VhXoBQG2tNE0IsMIlg8FPBCFEo30VPBIW4hubJcckA
         V2Fs1M2Fxv9nZsWoEMpaIP+HoJLPPO10PxdxjhNN/GSWO4vaUCCJRujC4lC6NIE/qO0E
         fNCR1p17Wj1erR0KyUVrNuCqiYFFGbBBYQdg1k/K0NSTVJKjDgIfIFqwoDRhStlJSEFp
         +Rsd/OxjwW2W8E+v/f9041MSKmEbAlGN36NqqlQrcJljUwHTLg2+LVrrIoJi3PU0McND
         kF8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273501; x=1742878301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zREl7MPAGqYRU9KvXrtENxfPFFrO3Nb7yWvR8XbX8nk=;
        b=BhvKWAOfZZEgtdvkhNqsCKx2ENfTUfpxT5zynJ2o6/i/urtdBrCUmDlo/mTtvO7g3n
         iS0euUk67zuAnj1UIGXdnAPi7sc8wQGOj37ByhH3gtV8D+S+cHyk8Jtet9gcSICoIj0L
         WQwH48GtG2Qnwnpa5PCuTgUVhQgzgWwge+4ECweG6HnWaoD2uT+gR/4FbQoS8PZg3sXE
         b0tOGw+VKOjtQQNP5oyzRM9/PcH3DWqrh/SXgxJsDlTQd5tD+7jYAgOamz1vnBOSlHVw
         FzNFPQi5jAmOfHJKctkSjBuAlmVPOy57wuNXNMOnfpvtvCwd57lHiNZbXsdahNXFKtFp
         5Rkg==
X-Forwarded-Encrypted: i=1; AJvYcCX5x3KXUFjWyhdKlimeqS5UqiXLarm1Ns4t3OgSjgYq/Lo1EwBppy+ZZKFo1O0Z71bWaUU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhWj9liVFjsARNifDylxsaq8IJDAuF8IqrdnFgzm9bJpx6GkPu
	BE63ws8gFCASy58usKw2C78jtMB3dYoaoTNGRgP6ZkHlFuR7vY8earENhx47U08=
X-Gm-Gg: ASbGncuQCak5kKCkFeRCVw+rBJoDkw0bpf+7MaZlebZm4TRB1KCTynrR186m8Q7WdfA
	nP6luTdf1lKlbyzTZYgkhjxFZOjZSA87TPSuNobZJxXaoPHRMDRskZywcnQb1HuIYxNsivB800e
	DZTofh9v0pu3une4qJtTNvtVdorekLIc5w4pEwfnal24jP4u0yL3lWrHdJKE+flFfsoj0n5Ig2l
	A8B1fDeeIuppCHg2Qs3zJe5uPLzvjEC8lc3VxfrK11rufsvMJZW5l7iL6CRcuv8jjz/7A6F3Alh
	EtHNVTd9gRS6Ifgtu5tY1t9zUyT275Qv0j36AM4glVNNfuEhB2diu5g=
X-Google-Smtp-Source: AGHT+IFqAyZQRbRYtYEmeMsrs7MIVpz3F5a0071joCl+4E1pyIG8nDoF4tustrp2jVDZXF29mgQhWA==
X-Received: by 2002:a05:6a00:1829:b0:736:a540:c9ad with SMTP id d2e1a72fcca58-737572d542bmr3107911b3a.20.1742273500665;
        Mon, 17 Mar 2025 21:51:40 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:40 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 08/13] target/arm/cpu: flags2 is always uint64_t
Date: Mon, 17 Mar 2025 21:51:20 -0700
Message-Id: <20250318045125.759259-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not rely on target dependent type, but use a fixed type instead.
Since the original type is unsigned, it should be safe to extend its
size without any side effect.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.h        | 2 +-
 target/arm/tcg/hflags.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 96f7801a239..27a0d4550f2 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -194,7 +194,7 @@ typedef struct ARMPACKey {
 /* See the commentary above the TBFLAG field definitions.  */
 typedef struct CPUARMTBFlags {
     uint32_t flags;
-    target_ulong flags2;
+    uint64_t flags2;
 } CPUARMTBFlags;
 
 typedef struct ARMMMUFaultInfo ARMMMUFaultInfo;
diff --git a/target/arm/tcg/hflags.c b/target/arm/tcg/hflags.c
index 8d79b8b7ae1..e51d9f7b159 100644
--- a/target/arm/tcg/hflags.c
+++ b/target/arm/tcg/hflags.c
@@ -506,8 +506,8 @@ void assert_hflags_rebuild_correctly(CPUARMState *env)
 
     if (unlikely(c.flags != r.flags || c.flags2 != r.flags2)) {
         fprintf(stderr, "TCG hflags mismatch "
-                        "(current:(0x%08x,0x" TARGET_FMT_lx ")"
-                        " rebuilt:(0x%08x,0x" TARGET_FMT_lx ")\n",
+                        "(current:(0x%08x,0x%016" PRIx64 ")"
+                        " rebuilt:(0x%08x,0x%016" PRIx64 ")\n",
                 c.flags, c.flags2, r.flags, r.flags2);
         abort();
     }
-- 
2.39.5


