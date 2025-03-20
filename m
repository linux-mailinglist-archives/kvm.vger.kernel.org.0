Return-Path: <kvm+bounces-41629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 033E2A6B0E5
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98F6A4876CE
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24ECE22E3E3;
	Thu, 20 Mar 2025 22:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pCM23pP2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D777D22DFA1
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509839; cv=none; b=D59AJBJMzmK+Bw2UQgGZwgLws4LsQ9UpF3/Tlx4apnAhq6FfbJ1PY8dOIiID6mPES5LoIX9rnzQ3sgiaRYyHCwrB2YFnNllYGr5OUcak7YiLbbNLnuLFrTItqYNV8P36vG5WQHjq1ZZ3IKvJ6jnxdbTs6AP+lKxBl5wa3zu8c04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509839; c=relaxed/simple;
	bh=xT68E+rzjyVKcjJPEQ8eBJRSJMsa3UtyRtrf3d4T2ig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ULsyG4zRKnXZTTQFwROkSeugvTSPzVqbWoBXZuolk3ZqdlTmEQmHBXkPT0hJLF5fVKUQ8emH7P9+E5GD17l3JrnQo0XhA+TfR27SyHzZEKCyR50S/GLQzMMXAcKDSpG4CgN4fMnQsk8rydGsTtxfh+Fj/Sud5TUNBNa4X9KIMuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pCM23pP2; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2235189adaeso25865275ad.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509837; x=1743114637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+1+7CiGx+iAiQeBUt37G0/UwWZT/ijcOCdLS2QJIME=;
        b=pCM23pP2gQj12Zy/dyWbGUMnpRgjfdtMq2qI3a3rzaRcdQSVU0FGsMjxszm+uMmAXt
         H1UXDtI45yCDMtk21p6FePmseR+LApuDumHtDLCnNMMq+2+nGeRAoxTeMSWGcO4+cxQG
         ZVnHBovt1KNBjomNTS2/9vQoUwyyiGWb4kx4oajdvDzSb7UeawwTc1kwtlrGFUANiI5f
         E5jW2AqmmdJmebEYcVSnpNBnE1P2ujZqreeBqrHAY7KqXTltJHVmixpoV/9EcmbsuhPL
         fEdVQVN+C5jhMLp31xWd/u5pM4zVd259WTFC/4zMv6cKbqaQoj7Fkg9OljTOvoNvj0WL
         jEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509837; x=1743114637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A+1+7CiGx+iAiQeBUt37G0/UwWZT/ijcOCdLS2QJIME=;
        b=dK60NXD6lDAQqxdv8MkEUfKkL3BSop6H8N7A9mit0BNfIV5EUzOVoC/z54+IUbZ7+Q
         9MAuaVcgsSyKlqMz3OdgznkhbZwhPGAufQUs6TCrk5RprqFc1hyF7ADEVFOLJjW2ZCpq
         7KzZD5FTmE0Zexe+53u4MqDn4Uz/uxsAEety8y31dG4p4YQOMpjetTNmoa/TtYBOfHFP
         u0ijiG8nqCEJ2PMhFRMxRM756sjxD4tcboBQlfoNolVfIbz2VtZFsLHlfylYh+kj0/yA
         YqHykDFoRi+puKYu8cSEy1tK5+9KZrvJJ9hbA+p5XBvfRZhlwi9EoMwxlzhNhlOSX2WC
         h82A==
X-Gm-Message-State: AOJu0YzIlzX9pKXdWQziSFlx3iIvHoMuQvlPfcaPpRBOXte4YriLU8PB
	UMjQF7rrYiTE1p1L2ArljaXcr10RajSr+4wOObWhPYue4e4oJxBACDNZRPEciaQ=
X-Gm-Gg: ASbGncsDCFKkGhJjBNU8DwGuZTB6qqbsJvBHswr5x3flG64V59WPT49h66TvWXHnw+f
	+XRXHUkReO4T2lZb1cCtnczW8LA/rTS1Tb1IJe+u6EKFXtR1kUPtbiW7Vq8chaQHAQZZol49vL3
	NkmjSJEF6aN+lKrhEu9e1qotPCNhda8Cph5AnMpO+gO/EI1RkMDPKWwPoFeiIb6qeBlaUCrLgtM
	TOBgg47FND+0gsvsK/rZ9jk+tLQohOlug/IYrdvMeyZe9BCx6FrXs2ctl2KvGCXBxvFq+k+Qt3j
	AlbRSRWMF3QcvLijrQcia6iOs15243r5cDPHPdVsEbJY
X-Google-Smtp-Source: AGHT+IG0L9vR3TvEwtKsOTQ+jVnK9o/DeH5SAcVF5sO9ApBZUM8ybqvtvKZgXXJTYhMOle1B9x9PXA==
X-Received: by 2002:a17:902:c411:b0:216:4676:dfb5 with SMTP id d9443c01a7336-22780af524fmr17603635ad.21.1742509837102;
        Thu, 20 Mar 2025 15:30:37 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:36 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 26/30] hw/arm/armv7m: prepare compilation unit to be common
Date: Thu, 20 Mar 2025 15:29:58 -0700
Message-Id: <20250320223002.2915728-27-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/armv7m.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/hw/arm/armv7m.c b/hw/arm/armv7m.c
index 98a69846119..c367c2dcb99 100644
--- a/hw/arm/armv7m.c
+++ b/hw/arm/armv7m.c
@@ -139,8 +139,9 @@ static MemTxResult v7m_sysreg_ns_write(void *opaque, hwaddr addr,
     if (attrs.secure) {
         /* S accesses to the alias act like NS accesses to the real region */
         attrs.secure = 0;
+        MemOp end = target_words_bigendian() ? MO_BE : MO_LE;
         return memory_region_dispatch_write(mr, addr, value,
-                                            size_memop(size) | MO_TE, attrs);
+                                            size_memop(size) | end, attrs);
     } else {
         /* NS attrs are RAZ/WI for privileged, and BusFault for user */
         if (attrs.user) {
@@ -159,8 +160,9 @@ static MemTxResult v7m_sysreg_ns_read(void *opaque, hwaddr addr,
     if (attrs.secure) {
         /* S accesses to the alias act like NS accesses to the real region */
         attrs.secure = 0;
+        MemOp end = target_words_bigendian() ? MO_BE : MO_LE;
         return memory_region_dispatch_read(mr, addr, data,
-                                           size_memop(size) | MO_TE, attrs);
+                                           size_memop(size) | end, attrs);
     } else {
         /* NS attrs are RAZ/WI for privileged, and BusFault for user */
         if (attrs.user) {
@@ -186,8 +188,9 @@ static MemTxResult v7m_systick_write(void *opaque, hwaddr addr,
 
     /* Direct the access to the correct systick */
     mr = sysbus_mmio_get_region(SYS_BUS_DEVICE(&s->systick[attrs.secure]), 0);
+    MemOp end = target_words_bigendian() ? MO_BE : MO_LE;
     return memory_region_dispatch_write(mr, addr, value,
-                                        size_memop(size) | MO_TE, attrs);
+                                        size_memop(size) | end, attrs);
 }
 
 static MemTxResult v7m_systick_read(void *opaque, hwaddr addr,
@@ -199,7 +202,8 @@ static MemTxResult v7m_systick_read(void *opaque, hwaddr addr,
 
     /* Direct the access to the correct systick */
     mr = sysbus_mmio_get_region(SYS_BUS_DEVICE(&s->systick[attrs.secure]), 0);
-    return memory_region_dispatch_read(mr, addr, data, size_memop(size) | MO_TE,
+    MemOp end = target_words_bigendian() ? MO_BE : MO_LE;
+    return memory_region_dispatch_read(mr, addr, data, size_memop(size) | end,
                                        attrs);
 }
 
-- 
2.39.5


