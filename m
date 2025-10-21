Return-Path: <kvm+bounces-60643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D740EBF552C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 450203505FA
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F0331DDB7;
	Tue, 21 Oct 2025 08:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="my1WhYgU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C363054CE
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036256; cv=none; b=n6KUg6Lf+pF0nfDPqzlNrOFDwsCC9D2gu6hyeCO2sGHzYZE22RlLAG2tktokQswRfwfJkzNlvFIsBH6xYakGlIgZqCXU3VMed1uq5yU6bHiOkm5hbdxa5bqmFSb/j8v4tuqolMY4T4d+Kmsieho+hhqBOoMTv/uODDhGwC8Kr1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036256; c=relaxed/simple;
	bh=wc2UGh/IdTnQe/qvhf9L5tXhyb851AF6ymOCka7tjJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jpu4frpuAzCpTbHsszy712CZWvmqSARBHzHqFyk6X5UIW4vb2sc5VIYtKGNezgr/WcxzfnrMPGSCOPE9ZU/yWNZE7zBORXqg/enTstzBsWjwk9qmXeyrw3T4q8+dKs8NQMI9dEQ2zcrcfbE64ktaOZXNJuLhSIG0hkwDdmFvz30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=my1WhYgU; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-426ed6f4db5so3312210f8f.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036252; x=1761641052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fggegq+zKz5OUQPZsxqCN6WOO/FKu9sNtbgG7iUQYj8=;
        b=my1WhYgUj1cGmRjuBlMoT3Z44T5uUoXWlCIpPm5gOWgeet+BHCg0B+HV1SCd/u31Lq
         OmFPUean+7evg8hgLrlt4JAjiNW9L4SNv71Q0KolmCwWc7xXjZ1zbPJeQ8hTe51Jk+0F
         +OozdJZNP6VvvyWCunuHa8v9xSX+SevIGBy9qEiT5AHCEQ3SQLursylVI5uQRV2nVQ1S
         SbJuioHXDrL3jFojTnXiWIwYYVPqze3SkGoYHZRk6aeX0SnXgLLuQmsEJuI00dm/SMXl
         1kWsrrpujW81e8djoXjmFBGEHCkIKzFg41gZ91gWPh1LelduRqb7JYosUeqqbokCZpRj
         9aPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036252; x=1761641052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fggegq+zKz5OUQPZsxqCN6WOO/FKu9sNtbgG7iUQYj8=;
        b=nzNk1KfatpUPvWWCAE3aZ9w++bQ3jgqFO0kOff6+xhJoQiJzJ5OZdgTPiY/ZV5bk04
         kMOcdBEGNkRe4eKmGXVoDKkVJwwB6I7oKbAkXLyguCGSqyMbkTTqvkgF4OxKTVdlTBp5
         zy2gMVOw7TI+OZAmbdhTiVlfz6qwDPRRDtKUEFv6rYi9bNb/v9zSa+moJN28XomzKnTz
         eGsVX56wfDKDozNZdfNQB93PE0hEjpu2rVCpalXD0nHTBGzAm79xaAAfNz8mNeIBRkfR
         UZOsBTA2etB0OImFvdy9gVKWPx32VHv+H64SvcsHCcgUcBrsJePY6X9LCYBGXrK+MKsd
         9lGA==
X-Forwarded-Encrypted: i=1; AJvYcCVYb6r1fMVoP9cn78StNsNQnvt48B6x840VjW9bccQ1Te3PPs8iESfqQFNKiepeS1RupVs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqNyFVmRhVxxUzlTa2CdxQS4MOsKUmlyRbO3PiJNFqgtTe4EXA
	CEfgOL3vbLPCHkNBN2Gt/GPKvbJUPKulcCFYdoT06EGLFc/3IhizzTQj4SmfON1EIpA=
X-Gm-Gg: ASbGncsUwo7K8iUIIyo/XATN9FSlRoHsesnvO66InmRZOY6k4Fp5+AkPL9QVCDNuI5z
	dSnTkZTYhu3A+NtqArU+w+fAMeF2ps5ZpkrVfw6LkQlhaWShbJ6DXnuIyvlxq+T/PqmoSLau7US
	7xjAKtodwullD7KP3pW7qBcC/3Z7eDF3+lpnj+JRDB9603bVKO3l4O5CCiwEiEscHdLOyLrpe2H
	IHOy0vo84RYlvEtT7rzBP1tRV4S/LlNL7pf5Oqsx5b9Q5vKQk2d+pzmyDvjfv7xtGHsT7auOWq+
	PwGkbiaA7F+J2WgdoS9Bu8rJIwFomcGgtRkZHr8FocWqySIZmNqGVZfh+Y3dWIKeq8PU7MLRQ65
	AOudTEsGr1KSO1AneH9qNal0DXZMDGbZ/egTUnGTkXRd1fZdwSfX4uG8aNcN8b/cWoSEXI9zcu6
	L7u+6yXnTerdkdFoXNVK7zLPLUGf8/lNo4rWxysrxDprIzSRKMJ+574S3Z/Jei
X-Google-Smtp-Source: AGHT+IEoYici4uejy48h7rF7LlsVTKlA5+khtpcojAL22mlKWdDcTixLD0jI1vVMR+Nu/9WOupMBrA==
X-Received: by 2002:a05:6000:4205:b0:3ec:db87:ff53 with SMTP id ffacd0b85a97d-42704b5a931mr12540847f8f.12.1761036252539;
        Tue, 21 Oct 2025 01:44:12 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce3e2sm19285508f8f.47.2025.10.21.01.44.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 01:44:11 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 05/11] hw/ppc/spapr: Inline few SPAPR_IRQ_* uses
Date: Tue, 21 Oct 2025 10:43:39 +0200
Message-ID: <20251021084346.73671-6-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021084346.73671-1-philmd@linaro.org>
References: <20251021084346.73671-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ppc/spapr_events.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
index 548a190ce89..892ddc7f8f7 100644
--- a/hw/ppc/spapr_events.c
+++ b/hw/ppc/spapr_events.c
@@ -1041,16 +1041,14 @@ void spapr_clear_pending_hotplug_events(SpaprMachineState *spapr)
 
 void spapr_events_init(SpaprMachineState *spapr)
 {
-    int epow_irq = SPAPR_IRQ_EPOW;
-
-    spapr_irq_claim(spapr, epow_irq, false, &error_fatal);
+    spapr_irq_claim(spapr, SPAPR_IRQ_EPOW, false, &error_fatal);
 
     QTAILQ_INIT(&spapr->pending_events);
 
     spapr->event_sources = spapr_event_sources_new();
 
     spapr_event_sources_register(spapr->event_sources, EVENT_CLASS_EPOW,
-                                 epow_irq);
+                                 SPAPR_IRQ_EPOW);
 
     /* NOTE: if machine supports modern/dedicated hotplug event source,
      * we add it to the device-tree unconditionally. This means we may
@@ -1061,12 +1059,10 @@ void spapr_events_init(SpaprMachineState *spapr)
      * checking that it's enabled.
      */
     if (spapr->use_hotplug_event_source) {
-        int hp_irq = SPAPR_IRQ_HOTPLUG;
-
-        spapr_irq_claim(spapr, hp_irq, false, &error_fatal);
+        spapr_irq_claim(spapr, SPAPR_IRQ_HOTPLUG, false, &error_fatal);
 
         spapr_event_sources_register(spapr->event_sources, EVENT_CLASS_HOT_PLUG,
-                                     hp_irq);
+                                     SPAPR_IRQ_HOTPLUG);
     }
 
     spapr->epow_notifier.notify = spapr_powerdown_req;
-- 
2.51.0


