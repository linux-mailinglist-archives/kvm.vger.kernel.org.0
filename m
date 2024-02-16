Return-Path: <kvm+bounces-8877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B54F858173
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 16:40:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D25D21F216A3
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C26C130E5C;
	Fri, 16 Feb 2024 15:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NK8VBBZl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99456130E46
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 15:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097754; cv=none; b=VDsmRDF2qfscCWnTM/hbFzwps+Kur2aZA0Zh/Aa3Zyx0D+UR6deF2bI4DRr/cC0li2eSdhkUrVPhpKuQrtvm9ksUUY8DZIliJMe7IydqSu5yn43bpyDMwOqYnxN8Sm+Z7AoOa8UiXE6SzV0kWgda7mrFbLxF3AQwMyQUPGZ1f88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097754; c=relaxed/simple;
	bh=la7Vl36AyEucchH/aNjEnDvhPD2hQcAjD88lexFDLqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjx6Uj6fWwgdJ1Ix71VETz3n/qxY3ec4PSAoOQKvinCG+pE/uIhRr/rVsNdNGGWdletet9WJPaQeW+sdMrdUho8nUU6IZcg283WF6oh/xaIz4k8ZxS3U1/tJLhCzaOdiSVDGAPnhLjEur1o6ReDXAj25v30gukmZ/ox1HJkw7ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NK8VBBZl; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2d220e39907so2721751fa.1
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 07:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708097750; x=1708702550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fLBBhh1GSx7gD4Lvttkm3NNOOv+Jojp8q0UUHVCrGQ=;
        b=NK8VBBZlfrd+3bhli2kbjw6XotEOT7edk0OngsKdaiR9AGpxXhcCqmrcgyNV9IJdxe
         9FyrhHjTVgb61qqwQlm13QkQMwy7K/iY/6nNsni1HT8tOeMfXF0nuJW0+JHp1etUl7S+
         2Ok/t97IXQv5rsvcOXrJBLSDCM2pje4i54hAIZuzhUqjHHDCNFdOXaFOXEu1VCP5E1R4
         J+1V1kSIxz62Dxze0HAa5mpbQ60P3Ci/xslTeGWP/5SPzW+z4Jvdw59LZc08IOfCd+8K
         PDRgK5dyvbdNSja/I3Zs9e+saBVb0eGbUN3AiFB2fUotz3eCYbLanCMuVmAQPmEJmCHX
         J9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708097750; x=1708702550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fLBBhh1GSx7gD4Lvttkm3NNOOv+Jojp8q0UUHVCrGQ=;
        b=kZoyYAuQrWOZYilB3UiG3Lr0EW2OM0rWkrhzQuty12JulLrcC6Tasi2eUSrj5CeQUC
         tLR35Lm506S8mvHwwjqAEc16U07bq7Xh1pb4u3AfY1z2fQthFugkGZ7vK9+KYTblyH/p
         S3GGcvOK6pJ6srf09JsW6/bdLLM20/uEwfHxzPtRi5RUGj5DoT3uaLAuyViLl8n0CdEE
         /akth33SfFwDvrWl/D5siGt5TFmxUuPBGeyHRC2Qah5J2xQA/4T0lp4uDghIEqIxA6MF
         9S57JinTPkRYFtUM2KLbKViQvQOGK4YYW9/S3Y8RQsXHzQ5me2WKrtayaXjmA4Is4+bj
         Jx/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU9gPCnkmyG/sKxcYF0JVszDWHiP3DwOODlTrfEIo20uLx7FVPGG1/MZJVbVj4Vh1H0SclejQ9RqiYEgcHmR/55jhrn
X-Gm-Message-State: AOJu0YzcLzZXTuSGQvB5x9RcJ50V9PiA0aT/9+PoEgjlOXSyVPHMA9YD
	AnbXJmBR6vMJdmWWr+NY+RJhVK6uhZzuoCKNoQqlm1BtxAeGyNg/HwmSIw/sIZjcKiPSEL/tbnV
	A
X-Google-Smtp-Source: AGHT+IGNHeZhgcGo12jNmOStEDC3hBsbxmtv6u/9HX9Me13ycUZT94SzgrmFQ42EJFSWhVNwe4Qrpw==
X-Received: by 2002:a05:6512:224d:b0:512:99ad:d465 with SMTP id i13-20020a056512224d00b0051299add465mr995055lfu.16.1708097750674;
        Fri, 16 Feb 2024 07:35:50 -0800 (PST)
Received: from m1x-phil.lan ([176.187.210.246])
        by smtp.gmail.com with ESMTPSA id e1-20020aa7d7c1000000b005621b45daffsm85225eds.28.2024.02.16.07.35.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Feb 2024 07:35:50 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mitsyanko <i.mitsyanko@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 5/6] hw/i386/kvmvapic: Inline sysbus_address_space()
Date: Fri, 16 Feb 2024 16:35:16 +0100
Message-ID: <20240216153517.49422-6-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240216153517.49422-1-philmd@linaro.org>
References: <20240216153517.49422-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

sysbus_address_space(...) is a simple wrapper to
get_system_memory(). Use it in place, since KVM
VAPIC doesn't distinct address spaces.

Rename the 'as' variable as 'mr' since it is a
MemoryRegion type, not an AddressSpace one.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/kvmvapic.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/hw/i386/kvmvapic.c b/hw/i386/kvmvapic.c
index f2b0aff479..25321d4f66 100644
--- a/hw/i386/kvmvapic.c
+++ b/hw/i386/kvmvapic.c
@@ -16,6 +16,7 @@
 #include "sysemu/hw_accel.h"
 #include "sysemu/kvm.h"
 #include "sysemu/runstate.h"
+#include "exec/address-spaces.h"
 #include "hw/i386/apic_internal.h"
 #include "hw/sysbus.h"
 #include "hw/boards.h"
@@ -57,6 +58,7 @@ typedef struct GuestROMState {
 
 struct VAPICROMState {
     SysBusDevice busdev;
+
     MemoryRegion io;
     MemoryRegion rom;
     uint32_t state;
@@ -580,19 +582,17 @@ static int vapic_map_rom_writable(VAPICROMState *s)
 {
     hwaddr rom_paddr = s->rom_state_paddr & ROM_BLOCK_MASK;
     MemoryRegionSection section;
-    MemoryRegion *as;
+    MemoryRegion *mr = get_system_memory();
     size_t rom_size;
     uint8_t *ram;
 
-    as = sysbus_address_space(&s->busdev);
-
     if (s->rom_mapped_writable) {
-        memory_region_del_subregion(as, &s->rom);
+        memory_region_del_subregion(mr, &s->rom);
         object_unparent(OBJECT(&s->rom));
     }
 
     /* grab RAM memory region (region @rom_paddr may still be pc.rom) */
-    section = memory_region_find(as, 0, 1);
+    section = memory_region_find(mr, 0, 1);
 
     /* read ROM size from RAM region */
     if (rom_paddr + 2 >= memory_region_size(section.mr)) {
@@ -613,7 +613,7 @@ static int vapic_map_rom_writable(VAPICROMState *s)
 
     memory_region_init_alias(&s->rom, OBJECT(s), "kvmvapic-rom", section.mr,
                              rom_paddr, rom_size);
-    memory_region_add_subregion_overlap(as, rom_paddr, &s->rom, 1000);
+    memory_region_add_subregion_overlap(mr, rom_paddr, &s->rom, 1000);
     s->rom_mapped_writable = true;
     memory_region_unref(section.mr);
 
-- 
2.41.0


