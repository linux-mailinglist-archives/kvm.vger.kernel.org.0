Return-Path: <kvm+bounces-10030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F08AA868AE0
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:40:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5F8D282E47
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 08:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2AA912FF69;
	Tue, 27 Feb 2024 08:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pvCTDH9p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE747B3D3
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 08:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709023224; cv=none; b=t/CXTAeV11tJkvglaGY01qk6kUPIt7gy3ie7JP8JMtI3GBoZHMhiq3qY5NQxEiaikit6ZCGWaGH0P/W7gK7VV0kh0hpp9ujxnudu0wBYIs4zyhgzUWMFk4+sgCxoLqDkfknGgYbabYcHyiAWo9Oq8bxBmHk88FUR9cbyBDN05WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709023224; c=relaxed/simple;
	bh=CBqzF2WbF6mxXofugfGCh9KbQbez8nFtvoRqbo22BTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RV27kfq/RRzIO+WmAebx7ghwtk9eDOWldIZpzFPz8E9uUhM+VwT4ihRNqt/jJFwrjjaWxvXFq7bwiOEVnUzcCVewI411BZkg4ayXgcqBsCr3aq17EZoHMDENFkIVaewXCjhfVOf3ZpNQe0clwqcAY1YpezRZFWup10IpVpw9ZMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pvCTDH9p; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-33dc3fe739aso1447885f8f.0
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 00:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709023221; x=1709628021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWmgk+68LApkOPWy7YUYgSrrjaqZXObndrHRfRf+NyU=;
        b=pvCTDH9pNW4ohwYFtYGHsqQY2Ui9ma4XlBooSx0v4VN5d4rt2CYyxq1BVZ4u8LdAcG
         bW/QNGYAiRMYPuBuk12azze+Seq4EewMFDB70hUcI6gSBV6NA+KPEjJWXxV+tkS4TyfU
         hQcegeX2DijqGgHGrp/hq1u+9Achl7gHMw4YEE+YocOBQ3ovXgq7DVlIh27436NAG5nH
         v1G5XpmwZfPHIdZSgnp2u//+Fx3Gm8PyFeNUdc3D22Pzg3qGZ0upwIaq1qlV4rqgGVvb
         gULYD3iEm7L28NG4JTKMicXiUDi965mSpE3WuQ3czp2TcqIzOFyEpm4Hl+CleYqF5D5S
         Nm/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709023221; x=1709628021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWmgk+68LApkOPWy7YUYgSrrjaqZXObndrHRfRf+NyU=;
        b=JtTkUHRy0Nr6vcOOewzmb9eECpODh4tThl5M9nKT5LBZZxOWitTfxhnt/i2TkOkZQU
         9GuYBJ24llAUCO6f0yteCkrbt0Ns1gNYZfVJ6HFe1cnKyeogUszCx0Smd4U29Fgki/io
         0SM3wviw30nNdBHk8EapU6Gx32Ybscxe4V7ku6ptJ0xQ2/9DWdBVx97ewld4RXqmgAH+
         0D/vMyCKoHDwd13Pf+n5mlBru3DbLJLrkmrscoQheqY99zmxaZsbnjCM7jKLYkjsGLaw
         3WM6vEI8FIbs0OziXZGr/qczOBYCvU2kJwGesFnPVzh7PHMilR7Xn1kcWL516keRfq+l
         3aVg==
X-Forwarded-Encrypted: i=1; AJvYcCWYOplgxlBSCQ63f41T5TtAtoK2auOnv9uFTNCtdWP7BzxwXK8kQW8dYD0iUHUypCzgto552ctsRnargwGsrx56P4hg
X-Gm-Message-State: AOJu0YyNOmM260g01zGOMv4JNpTgcTrnHyLlaN+20c4mpR9Bl19C4PIl
	Dmi58+VfvgYggBZ8czOb/zjbOZP5acky8YQ19/QCo3GkPyrTbLLVahltX9GGm3s=
X-Google-Smtp-Source: AGHT+IHlowSWUgonUicezcAUv37tfeY2t4fNQ8ilz1Ff3gwsIZgFc3bnnF3Er3iJzfWjvl1FPo7WKg==
X-Received: by 2002:a5d:4106:0:b0:33d:90c2:c7f4 with SMTP id l6-20020a5d4106000000b0033d90c2c7f4mr8225142wrp.14.1709023220812;
        Tue, 27 Feb 2024 00:40:20 -0800 (PST)
Received: from m1x-phil.lan (mic92-h03-176-184-33-214.dsl.sta.abo.bbox.fr. [176.184.33.214])
        by smtp.gmail.com with ESMTPSA id bj29-20020a0560001e1d00b0033d81d9c44esm10779692wrb.70.2024.02.27.00.40.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Feb 2024 00:40:20 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	kvm@vger.kernel.org
Subject: [PULL 05/30] hw/i386/kvmvapic: Inline sysbus_address_space()
Date: Tue, 27 Feb 2024 09:39:21 +0100
Message-ID: <20240227083948.5427-6-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240227083948.5427-1-philmd@linaro.org>
References: <20240227083948.5427-1-philmd@linaro.org>
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
Message-Id: <20240216153517.49422-6-philmd@linaro.org>
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


