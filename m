Return-Path: <kvm+bounces-59405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21157BB3554
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB03A561C60
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 779C1301031;
	Thu,  2 Oct 2025 08:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V1hlqQx/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD424301027
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394543; cv=none; b=NjDkKgdHnghFfu66/6fL4cSTOxnqwZTRNR983ZNn/WO2aHmEBDDVdNgfoChSymThDxk77uSoXya9KUtN1cMw3ODH7gSMKTHoMh8HuDTAwEenphkLHehw1ut7q+iVda9x5L/snz8TPiZfDj2NOukdBCIkFFdae6IT/gneyAYIscM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394543; c=relaxed/simple;
	bh=WylwQiHpnSrpdGGeWblMPZJSVrOX6r9al4llOU0YKUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LRHWQ9ZQkBcOkoNdnqWJDaW2ccqJQwuFbtGfp3y+4+/g4qhRjaf5MxpbJmzDyd3NdvOGtXtXXegKpCUm4ldykAW1rtjP7elGv3MB9Z7pV/4JNiSi/kEN8tBYUpq1By+fZuX45XechRhjC7L7K1LHee9u6eYjU8lPMEREUxx94nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V1hlqQx/; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e37d6c21eso4990745e9.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394539; x=1759999339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rvvp0krdvj9KI0seW+qea5ZtA/ftLNrinoYyViTKgNM=;
        b=V1hlqQx/6OB/lJPUWFAxwhJUoGjwPPvpwVBeXaUT9lq+v0QY6a/Am3GQupijJZZ/vB
         8+fkL3o317PeUmT64AJHVU8KLy1uxZBUUIim9SHUXrPQxEmpNayuS6eKSu0korRZcU+1
         3mQ2OY2BJWw9GpYp2MbYDUc8dlyQWYJdrerLJoSo/yoXDyt2hBttMGhaYgS6aWUfIztO
         sHPyP3nhnAmmrr7SToHnYGO9ojCkfRSTE/TDxZmy5VAQv/s+N1uo1O8sMkQ0JmQ2F6v7
         XkzlHPVuxOPtf8DB9Ul0G39P7tN51dcsiibcaUwWw3V9++T2hcWpgy7y6TdgX38kysuk
         fS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394539; x=1759999339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rvvp0krdvj9KI0seW+qea5ZtA/ftLNrinoYyViTKgNM=;
        b=S0bvutSXmfOHo4Z/52v0XXvoEbKEE1BQ+wvThciz6R7b/KC7M5zYRtf/reaBfTuG7J
         Z6eJCtbylQrgTPvY8SdkTwz7Yht9A+arcJiQALMxzsDCMPuwouBa2XQf+Lg9SaE0YUml
         9bqUKU2wt49g6mjvOWDIq7nwuaQ5m2xr8kzHlQ33vmUFZUGo3rHKMtR6Z+hvMXies+bO
         8PztGd/EFCg8aX8pd5TDk6A3mbPviriiZw1pCMLAx/N9p5wQRagwVBWtgKqAkqA+4Woj
         3+0R3Y98t8hAOwcTYVd95OA9GbNxhF/32f3N5x5WeXAwZWM51ldaw+KUE2D/2x26l/S5
         AjXg==
X-Forwarded-Encrypted: i=1; AJvYcCWR/uKGEVHO8j3UrlkGug5gIWEbluk9EnODLC4OE76o51i5AcDGgPA5Pt59XH6axLYqVQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHMsbZ13aF6LkRgpvfPlMZ/4EYpIFHBpF2/SUD2Ng2AN4GDWhP
	l5z2k3wFHacu4fDHXf+pfjdM6D4GrJOL1SncMD0SiHHCmZgUpuX1sW4yFRuOj9oAY84=
X-Gm-Gg: ASbGnctz1SyfzLZ6E7zCf/2Ns0BhVZ+dToD6IDdfOJv1SmghC8Rr++sbzooc717F5m9
	ckBQZm0pI8PSYmHptDc9rzWrbGp4iT7/Raf6tlXIM7vilQk65SjRTA/Eb0zphxHlFga+1Gik4eC
	gdoP1mZ/2Y+YWsEIR6GNnpvgU5QHslx7CJ2aOM5A8+jiatZ1TSW6NuP2XdfauDF+aMEo0RlAY40
	OelIu+7AejMA1HhloiOakjur64/xURbseY3y8n0VdeOtAAr4OjOYrE4n7kT43/eOtedsGV4Wbrx
	5FDbwX/Wgh/lJUpFXEPKD0hckHHUAtdUWKxWWb0w1up3Qj7rSuRZeQ49kHjzBzzlUqU5+64/3p0
	XZrYgYkG/EzxFoXWCUZ9p8tKxELnKtrUF7uArrq1pBlfDJsNI4Hdt1YmpQEMDDMwrHAxIelXxwz
	y8v9D6NqKQgGYn+CasWeaqHajFPwsf2g==
X-Google-Smtp-Source: AGHT+IG82FlfkoxisOQbRYrohdopoSBAhOILCB0HaVdDr5q4Gy9SbJH0YmtL/0EDlkKLEQXXp8/WZQ==
X-Received: by 2002:a05:600c:4ec6:b0:46c:e3df:529e with SMTP id 5b1f17b1804b1-46e612ba9ecmr42260135e9.19.1759394539032;
        Thu, 02 Oct 2025 01:42:19 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8abf0bsm2636723f8f.17.2025.10.02.01.42.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:18 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 03/17] target/i386/arch_memory_mapping: Use address_space_memory_is_io()
Date: Thu,  2 Oct 2025 10:41:48 +0200
Message-ID: <20251002084203.63899-4-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since all functions have an address space argument, it is
trivial to replace cpu_physical_memory_is_io() by
address_space_memory_is_io().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/i386/arch_memory_mapping.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/target/i386/arch_memory_mapping.c b/target/i386/arch_memory_mapping.c
index a2398c21732..560f4689abc 100644
--- a/target/i386/arch_memory_mapping.c
+++ b/target/i386/arch_memory_mapping.c
@@ -35,7 +35,7 @@ static void walk_pte(MemoryMappingList *list, AddressSpace *as,
         }
 
         start_paddr = (pte & ~0xfff) & ~(0x1ULL << 63);
-        if (cpu_physical_memory_is_io(start_paddr)) {
+        if (address_space_is_io(as, start_paddr)) {
             /* I/O region */
             continue;
         }
@@ -65,7 +65,7 @@ static void walk_pte2(MemoryMappingList *list, AddressSpace *as,
         }
 
         start_paddr = pte & ~0xfff;
-        if (cpu_physical_memory_is_io(start_paddr)) {
+        if (address_space_is_io(as, start_paddr)) {
             /* I/O region */
             continue;
         }
@@ -100,7 +100,7 @@ static void walk_pde(MemoryMappingList *list, AddressSpace *as,
         if (pde & PG_PSE_MASK) {
             /* 2 MB page */
             start_paddr = (pde & ~0x1fffff) & ~(0x1ULL << 63);
-            if (cpu_physical_memory_is_io(start_paddr)) {
+            if (address_space_is_io(as, start_paddr)) {
                 /* I/O region */
                 continue;
             }
@@ -142,7 +142,7 @@ static void walk_pde2(MemoryMappingList *list, AddressSpace *as,
              */
             high_paddr = ((hwaddr)(pde & 0x1fe000) << 19);
             start_paddr = (pde & ~0x3fffff) | high_paddr;
-            if (cpu_physical_memory_is_io(start_paddr)) {
+            if (address_space_is_io(as, start_paddr)) {
                 /* I/O region */
                 continue;
             }
@@ -203,7 +203,7 @@ static void walk_pdpe(MemoryMappingList *list, AddressSpace *as,
         if (pdpe & PG_PSE_MASK) {
             /* 1 GB page */
             start_paddr = (pdpe & ~0x3fffffff) & ~(0x1ULL << 63);
-            if (cpu_physical_memory_is_io(start_paddr)) {
+            if (address_space_is_io(as, start_paddr)) {
                 /* I/O region */
                 continue;
             }
-- 
2.51.0


