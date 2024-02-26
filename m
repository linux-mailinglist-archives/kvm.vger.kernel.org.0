Return-Path: <kvm+bounces-9951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA69867F0E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5556C29A661
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 17:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9154812F5BD;
	Mon, 26 Feb 2024 17:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lrx0Z07N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1086412F5B7
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969118; cv=none; b=N0Jk68EpFm9cClLgeN/nutBdiXsvuSosaI8KFVe4aBJDmr+hAlcXP5uJKnfYp1VRce/WSAG1ameyfK1oHlL0kcZaXDCyiMZoAMuSYk8X3k0Jwd0SbK1LCHmDHVM4ezJIxJaZIuFHQm4uiskJcc1KxaSdklsd25cTAmgo4L76BlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969118; c=relaxed/simple;
	bh=aaWED2VM8wwd/UWFdenyVQlHhf2WoZ3lYD4llSdWljI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FvT9d8DS8NyAo11B7cGkFVmBMhfXuh2j17n2WrafQlWQfqG0c9mFatI0X59BSKDOYp5i0ZhD5nZ7bOBbjkSXuLm43G2KjaXlbKo7J97td3qpqzw0Ws1a41NYDS6K1Zm1mtjomiPKuuUDhknYs0Ee129CzLZ35BDZMtOzYM896Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lrx0Z07N; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-412a45f4766so9395065e9.3
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 09:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708969115; x=1709573915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibVcW3lwaKG1GGTyMtc1ku+JoJ+rReT+MXHBNQRHkgA=;
        b=lrx0Z07Nb100FpPiIx3TMqpDb5fFGTbp8f4wIM8OS25VD49/B+VCuCVUsJh1CucNCl
         jlBYkdphJjn3z4BAFX6cahHu8Jv8ETZpnhHgJy0hk6evPqgX53gwdjm+Oa7IP5CmIKkF
         WQa5RtctGfTR0aDPXRq7IAT14IcqMesfCeuitI+z5UIfAEecGwbNlga3hiFuse02DFNA
         BnmytuRLtRgkSJeBFMP+5RaXiMQ8tgUnctnTUP6PeizzGYGHrUj4xKPBH8jFySjhDy/x
         QS9ffNrF6td9QuaJSsksVj1YHmn2z9hGwR7niLy2sTa2RAixW85NhiLXpJkXB5fiVk0g
         CWAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708969115; x=1709573915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ibVcW3lwaKG1GGTyMtc1ku+JoJ+rReT+MXHBNQRHkgA=;
        b=IJFzXufSKCcyBGH368cXAAKvi252r7PbKwuX08TnuqDfWnoDEGUzZkKy1syrVZG/dv
         boSpT47TxDr0HpBPnfJ894Ogj8C7J/rMjYkLNidmbxWAfEqgvY6m0umc3xKYiSJLXN2S
         lBEqwMRvH8wp4cBiIHTrd5QTFrWiFNxTZ/4Md8nSei/Fd9knqFG+AJira/HzSGmyygYk
         Yu635GYAnt+v52rh+lqx7M8ZyMJQRPCdj4hOeJ0S5YVgz2QaUmzWBsq5bQNeqziWslIG
         Cldgh5QkK8Mgw0NYOJlxQYv+Zr91QxokKIwPppkwoDe9H1mdobrQFbx87i4Vk+/AX4nW
         l/RA==
X-Forwarded-Encrypted: i=1; AJvYcCXuLe33JbL+aSsVE8EE11N0t3u82oOMWKvi9UnWLDjxzdGi7R70loEJKLv5HEYR+AkOJg/hZ0eOLpetyCJhQWYkrVy2
X-Gm-Message-State: AOJu0Yx6qmt/mgVX1TVO5y7aNb/QzWwgtziMETF5aidVXyxwx9h/i/0m
	OF5G8JBMBW/GZwTID8OxaIN/pM7brPRUcVh26P8Lzs3poKSp+lYNB7Ai5L74YgU=
X-Google-Smtp-Source: AGHT+IED3271S3qIMUH2+9yk3xe32TnYj/AZbnHNirU/8Xb2RKs9teRqHrsj7TTO7uYVBlnphX9cyw==
X-Received: by 2002:a05:600c:5246:b0:412:8d98:78a with SMTP id fc6-20020a05600c524600b004128d98078amr7017617wmb.13.1708969115328;
        Mon, 26 Feb 2024 09:38:35 -0800 (PST)
Received: from m1x-phil.lan ([176.187.223.153])
        by smtp.gmail.com with ESMTPSA id v6-20020a05600c470600b00412a2919d98sm5708711wmo.10.2024.02.26.09.38.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 26 Feb 2024 09:38:34 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	kvm@vger.kernel.org
Subject: [PATCH v2 5/6] hw/i386/kvmvapic: Inline sysbus_address_space()
Date: Mon, 26 Feb 2024 18:38:03 +0100
Message-ID: <20240226173805.289-6-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240226173805.289-1-philmd@linaro.org>
References: <20240226173805.289-1-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 hw/i386/kvmvapic.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/hw/i386/kvmvapic.c b/hw/i386/kvmvapic.c
index 20b0300357..61a65ef2ab 100644
--- a/hw/i386/kvmvapic.c
+++ b/hw/i386/kvmvapic.c
@@ -58,6 +58,7 @@ typedef struct GuestROMState {
 
 struct VAPICROMState {
     SysBusDevice busdev;
+
     MemoryRegion io;
     MemoryRegion rom;
     uint32_t state;
@@ -581,19 +582,17 @@ static int vapic_map_rom_writable(VAPICROMState *s)
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
@@ -614,7 +613,7 @@ static int vapic_map_rom_writable(VAPICROMState *s)
 
     memory_region_init_alias(&s->rom, OBJECT(s), "kvmvapic-rom", section.mr,
                              rom_paddr, rom_size);
-    memory_region_add_subregion_overlap(as, rom_paddr, &s->rom, 1000);
+    memory_region_add_subregion_overlap(mr, rom_paddr, &s->rom, 1000);
     s->rom_mapped_writable = true;
     memory_region_unref(section.mr);
 
-- 
2.41.0


