Return-Path: <kvm+bounces-60462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F6A7BEECA3
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 23:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ED97C4E711C
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 21:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41604239E79;
	Sun, 19 Oct 2025 21:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NhM3vytf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAD423B61A
	for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760907827; cv=none; b=eaRZWJHeHja9j5jolZAc8jc684KYr/pJZ5m1bHaJkh8BfVBeKk6RWZxfwXF0oQfEohz/gDbtuzf2hYUj7INYQir1486/4u4KYX0jSAs78bI27itfqi4N4m5BHz3Lq09qPbxlAMYpi0dpuZQhdgDuUdB6kOa05bKLI+oVtS9p9+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760907827; c=relaxed/simple;
	bh=S9JSVfuvtDV+aqqeUvYHZdMtVIQKstW9G81yP+8zmXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqJLM2D6R+BTtqmrgYeK4w84FLkbr0aRiV0zNrPeTdfgLXDDv+yO4LOYbQiuSKBZYReLCbtkbSyT4YlljDeCT+9ilaZqO5DnuXfdJ00HdV+2KHcpCebcReFcnI2mS1G+mYehb7LHFwDtZ/XUDjf48nHU7qcpYXitNmd3tGo5Zfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NhM3vytf; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-63c1006fdcfso6986923a12.2
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 14:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760907824; x=1761512624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ROqS5b9mjR1Hcdo/MNxQW9zo/TvwGOsH5rFLzCQXjhw=;
        b=NhM3vytfTPF2v0qm6+gdobNT5ajq3+BJo75z86gAC92HeUgDz19mA1saWrrubma9Ii
         NzLO59W46lhcr0zEV3O4mmUrApDEv73nFDB+U4P0eJSM+BlmtMVeaSfIxxVR5KW2sU+y
         U3HptRqZlnl5M+/mFqjvTGYqitWolMbDKoVDekxxJ62274LI2PxAcS0sEubt/psoO+G1
         9bB6gnTAdJn3s43tY7JxNyHkPjqBbXuTUCa5HGJUslSWMubeqqUc1fi6ZjZXFwZr9PQf
         wEwzZj1t8XKG8YWvdDpKQC0RjNhUYgIG9mPe5xVflxPEponR7nSAq9s36ZA/VByiV2SA
         dw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760907824; x=1761512624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ROqS5b9mjR1Hcdo/MNxQW9zo/TvwGOsH5rFLzCQXjhw=;
        b=DF9zx358cqBkKRdR4dLGD+FkngMp4TaxpywpUfM4dF+lNfK8gWFn/P5beKqFaXV8/t
         q8WNd6Pe/usZptpPwUZ9JfKiZnNa0227ItZRJfuz1eWIJy6gUP9cNPKlT1TnLQzX3tk3
         QSBLKPm9uR+sCMc20vXJxUJyh3m3B6Cuze2ilZygOGIdlNsuMyTujClMyn3K7Lv9iKwr
         mkGtntnRgaFeFJxNeA50D/aZ9wjXUMRA7Se6jRCBQ/UUoP77J1Q7ZlxvBqJGHAzSlJ1D
         WslPStfQTkrJPKv8RW5EdQgx5xOSOd8gu2zHYkN/LgnStHZtRQXPVseqA85/4e2iQnma
         9AnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVL5PYXJ6qwnUMSV+fbUXrXMcoLa3apoiRBiixFBXBcqXcq9zxuO0RnYCD15H3xA8F1DOg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBC3Pp6DPyGQ34AKen//JSmFGJfXnWdJdRXCyeQsrzpHGfJGQc
	y1mfBcRDao/1ioDCglzkoB4iJxlvjGFn3Nk6YkgcI0BUCTeeWo5X40BT
X-Gm-Gg: ASbGncvIMVr4l2TxinFhrR3ebt20jtZ9cpdYelZeW8MJXJqrZiZWAQTFsnzIsFzVyti
	v7P9gHK8+5sgqc7OdMMOx9u7RVMr2i1atemM7sNFeIEq3eveRO1wm0T6Mkkt8nS0zNl808I+4Sy
	NRUMNGSZqaQhyyTCqnqoqo1alJ8M3F+/irg1omBJGehaN36R76vqN81shlsybg6/qbH5PsXGBBi
	QKCNr3NjlVpIC6zAB1/jYg6jFBGzbF7eR3jblui77gIgL9gi244ObpUz3SiGxkDKpRCuKD6i+6x
	tj05PCpIKdY/3W5SRCfidtA47NTwglceOJIAxEyA7tmGVzg826JoIA0DLjFE+2GVbcgWeEwOGxb
	mqO5GhOnxfwtfjfccNafHZPNpKjVHM81Og6LlOa9+AJ2e0RjQdM5nBLF8U1OxvIKM09gKsjVEsK
	CYU6+ObOCj72Y5TEuikXwo5yMtyea3SwxMAwy+jsNWExwm57A/hwB0eutZzzJ9n/UQ9EDn
X-Google-Smtp-Source: AGHT+IHqxQHSLWGjl/1o+caM7v59/pl99Hw05CaKkU9VxpB1BkUo2CSz0N/TNd5uoNKIH8Cs1RcreQ==
X-Received: by 2002:a05:6402:461a:b0:634:ab80:d84b with SMTP id 4fb4d7f45d1cf-63c1f6c42c3mr10193464a12.32.1760907824053;
        Sun, 19 Oct 2025 14:03:44 -0700 (PDT)
Received: from archlinux (dynamic-002-245-026-170.2.245.pool.telefonica.de. [2.245.26.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4945f003sm5107655a12.27.2025.10.19.14.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 14:03:43 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	Michael Tokarev <mjt@tls.msk.ru>,
	Cameron Esfahani <dirty@apple.com>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-trivial@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v3 09/10] hw/intc/apic: Pass APICCommonState to apic_register_{read,write}
Date: Sun, 19 Oct 2025 23:03:02 +0200
Message-ID: <20251019210303.104718-10-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251019210303.104718-1-shentey@gmail.com>
References: <20251019210303.104718-1-shentey@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As per the previous patch, the APIC instance is already available in
apic_msr_{read,write}, so it can be passed along. It turns out that
the call to cpu_get_current_apic() is only required in
apic_mem_{read,write}, so it has been moved there. Longer term,
cpu_get_current_apic() could be removed entirely if
apic_mem_{read,write} is tied to a CPU's local address space.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/intc/apic.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/hw/intc/apic.c b/hw/intc/apic.c
index ba0eda3921..077ef18686 100644
--- a/hw/intc/apic.c
+++ b/hw/intc/apic.c
@@ -769,17 +769,11 @@ static void apic_timer(void *opaque)
     apic_timer_update(s, s->next_time);
 }
 
-static int apic_register_read(int index, uint64_t *value)
+static int apic_register_read(APICCommonState *s, int index, uint64_t *value)
 {
-    APICCommonState *s;
     uint32_t val;
     int ret = 0;
 
-    s = cpu_get_current_apic();
-    if (!s) {
-        return -1;
-    }
-
     switch(index) {
     case 0x02: /* id */
         if (is_x2apic_mode(s)) {
@@ -868,6 +862,7 @@ static int apic_register_read(int index, uint64_t *value)
 
 static uint64_t apic_mem_read(void *opaque, hwaddr addr, unsigned size)
 {
+    APICCommonState *s = cpu_get_current_apic();
     uint64_t val;
     int index;
 
@@ -875,8 +870,12 @@ static uint64_t apic_mem_read(void *opaque, hwaddr addr, unsigned size)
         return 0;
     }
 
+    if (!s) {
+        return -1;
+    }
+
     index = (addr >> 4) & 0xff;
-    apic_register_read(index, &val);
+    apic_register_read(s, index, &val);
 
     return val;
 }
@@ -891,7 +890,7 @@ int apic_msr_read(APICCommonState *s, int index, uint64_t *val)
         return -1;
     }
 
-    return apic_register_read(index, val);
+    return apic_register_read(s, index, val);
 }
 
 static void apic_send_msi(MSIMessage *msi)
@@ -919,15 +918,8 @@ static void apic_send_msi(MSIMessage *msi)
     apic_deliver_irq(dest, dest_mode, delivery, vector, trigger_mode);
 }
 
-static int apic_register_write(int index, uint64_t val)
+static int apic_register_write(APICCommonState *s, int index, uint64_t val)
 {
-    APICCommonState *s;
-
-    s = cpu_get_current_apic();
-    if (!s) {
-        return -1;
-    }
-
     trace_apic_register_write(index, val);
 
     switch(index) {
@@ -1054,12 +1046,17 @@ static int apic_register_write(int index, uint64_t val)
 static void apic_mem_write(void *opaque, hwaddr addr, uint64_t val,
                            unsigned size)
 {
+    APICCommonState *s = cpu_get_current_apic();
     int index = (addr >> 4) & 0xff;
 
     if (size < 4) {
         return;
     }
 
+    if (!s) {
+        return;
+    }
+
     if (addr > 0xfff || !index) {
         /*
          * MSI and MMIO APIC are at the same memory location,
@@ -1073,7 +1070,7 @@ static void apic_mem_write(void *opaque, hwaddr addr, uint64_t val,
         return;
     }
 
-    apic_register_write(index, val);
+    apic_register_write(s, index, val);
 }
 
 int apic_msr_write(APICCommonState *s, int index, uint64_t val)
@@ -1086,7 +1083,7 @@ int apic_msr_write(APICCommonState *s, int index, uint64_t val)
         return -1;
     }
 
-    return apic_register_write(index, val);
+    return apic_register_write(s, index, val);
 }
 
 static void apic_pre_save(APICCommonState *s)
-- 
2.51.1.dirty


