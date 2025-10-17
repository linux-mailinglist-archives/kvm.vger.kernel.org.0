Return-Path: <kvm+bounces-60325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69590BE91DB
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F9EC1AA1F68
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B224B36CDF9;
	Fri, 17 Oct 2025 14:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f/EHlisX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C3936999B
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710378; cv=none; b=bXSsc8xXSgCRCvpSLJ3kB0zk7fhZODy/WFSrrxNTlomuPln362V0nUvVfj4wOHCQL9wRIEcPjcDEXbN7yiUVSxAasMP61w94iT0AkBcPrdsEB8xcGXN/CZWZxy29Uws5o8R9IbE2mXBd1DfcGlBpCN5cIw2MiYnv7We/0sEnoTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710378; c=relaxed/simple;
	bh=xwV1Hr9G9Q2Jcbvyd00RPZYhlNpKeqkS0MOkZbeh8aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzXuWCY8evcx4adn/I3hO/6Sxtqg5eSuN+r1eHjkA9gvNArgHuonCzFP10UrOjmajwaeUgENX+yw3xhDK434xtSBMm6ugC53eqAOtJlEa0+HxEcvLQ8TgNrjpK0JRXKpyWuxtoAdfHr9LLANUYPYc5mI4Rke4JkY1QRhua1aWjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f/EHlisX; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-471193a9d9eso10650875e9.2
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710375; x=1761315175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uoQ6SLuQ7FwjPP9PEz/jS+6Ivn8fi/SY5nUjIteDwfY=;
        b=f/EHlisXRw9BDUCFq8VIv8ipQFZwwzt8w5G7Cl+rvH6TtK4uc2xJS4pCIQoQhO6qPr
         eklDLwBYugzh3gFHkVsoZo9qW/Snb78Xx+qPOyg7z1zITjv2JoT+kBHpX0O6YlXYIgIf
         +nJq9X5pyg94faajx6NmQSdDFOnB0M0w5341u7CYN41gbHtPWB/CyFh2bP8Czxf+fM9r
         SUmlCbTVf07wH3AZmcCeJ8goYFa6ECX3BUfQdKMg1pLVmIlBSaSPWVPiaReUX1HLVxOg
         hv3IC4OsM8X99LT8eF7M0Vb2bV410+Pkl/6GqvsztR3Hq1/x/Fw681fN7x0Wae1kfR2R
         IwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710375; x=1761315175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uoQ6SLuQ7FwjPP9PEz/jS+6Ivn8fi/SY5nUjIteDwfY=;
        b=G40BPo1SKzuULbElEvF5LqGSUjK6vtt8JJloLMnzc2blZRPU9oAqJgB1lgsRv6ZfW4
         pXP56957DIBDAoxaR+yvARsm6SvQBG6qreBB6cSIXsFZFzPhsH0TGDPm1C93MWHxAZR+
         wpfUZ3iiHsPdGukPjRN1NcG1JF/uC2EkeHo2E3PlZxN84JZvTpLztKGvrVC4EYnkkPzj
         A9lUzJyUCAyyccge2LkBJ9Wp3Cu2l0vIPYCyC6pcC1uSWC/EP8+GdBsKiGRc+qOmlIlY
         SZvV90AzDeinNpCJlAhNr1f11DwriFzZS5qKFBSk665MX7GnqwfMs1bTaJqWSTp83CAc
         y/MQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkUVkcvBYNY3FlghagdQnvtSJHhqMHf62uIZtRlc+Ln1Yb+amYNrGPQ6070P5Yv97yCr4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJD8bEOxo2r+Dj4CuFdKIpxT1jt+KCeaTmyKeBVlbWmEwrvVHv
	nKdiZKKfJEWZwMpFooAfGGQo9l7voIEthhXxhAQHrUELBJwGYNlbmdwu
X-Gm-Gg: ASbGncsDcIujJ37OBITpXPgVKcKNB3Jg8TXouwDFpxBvDg8OVGSwNR/CZTAI1c0W1lL
	UQgbeCVTnuszC+NxvjTzRxm4K+1e+/Sux6JoeBEpgJR8Brsuql6E/XcjtqA4zFL/LLhOs/wvED+
	kFHQ88Xlm0663xvk1mcfEuYnjiXO7hv0tUnezEatGaw1Sgq9EkHwmH6GuMTisUsG+gm6CrtYfs5
	Lz3P3kxJpjxaPOmtkbLhW2mfXl7Jg/P3LGfui9gJERkSHNqPxfHqCZ+GUqBiWCWXZUMo9m9b/lv
	XXNmhTQ1ghNIyvDFHjdiwWCGjKCjy0ReYa18kdax5FlYorhyI3Q+/oz+A/IiA33etsM790lHE2u
	XAkLxG43+NkvrwlUAjayLQH2lp6AIbMTIuFtd3QSjJFisGIS+ZwoVRdGfyTn05FN8xnpo7EiWFH
	xgaT1dXDbh8HFuwSz0A7Seq/c4dm3BOzCuegp3qam85kk=
X-Google-Smtp-Source: AGHT+IGDUpHFktS1phJv11AWEB4wPTsgryq8zLqwvPwmU/+IRwKwm/FCG4X5/AX6gCWAr8CSOUFAfQ==
X-Received: by 2002:a05:600c:548d:b0:45f:27fb:8016 with SMTP id 5b1f17b1804b1-471178726a9mr27315245e9.1.1760710375304;
        Fri, 17 Oct 2025 07:12:55 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cb36e7csm51359675e9.2.2025.10.17.07.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:12:54 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Roman Bolshakov <rbolshakov@ddn.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Eduardo Habkost <eduardo@habkost.net>,
	Cameron Esfahani <dirty@apple.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-trivial@nongnu.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	qemu-block@nongnu.org,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Michael Tokarev <mjt@tls.msk.ru>,
	John Snow <jsnow@redhat.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v2 09/11] hw/intc/apic: Ensure own APIC use in apic_register_{read,write}
Date: Fri, 17 Oct 2025 16:11:15 +0200
Message-ID: <20251017141117.105944-10-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017141117.105944-1-shentey@gmail.com>
References: <20251017141117.105944-1-shentey@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As per the previous patch, the own APIC instance is already available in
apic_msr_{read,write}, and can be passed along. In apic_mem_{read,write}, the
own APIC instance is available as the opaque parameter, since it gets registered
when initializing the io_memory attribute. As a result, no
cpu_get_current_apic() is involved any longer.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/intc/apic.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/hw/intc/apic.c b/hw/intc/apic.c
index ba0eda3921..fee5201372 100644
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
@@ -876,7 +870,7 @@ static uint64_t apic_mem_read(void *opaque, hwaddr addr, unsigned size)
     }
 
     index = (addr >> 4) & 0xff;
-    apic_register_read(index, &val);
+    apic_register_read(opaque, index, &val);
 
     return val;
 }
@@ -891,7 +885,7 @@ int apic_msr_read(APICCommonState *s, int index, uint64_t *val)
         return -1;
     }
 
-    return apic_register_read(index, val);
+    return apic_register_read(s, index, val);
 }
 
 static void apic_send_msi(MSIMessage *msi)
@@ -919,15 +913,8 @@ static void apic_send_msi(MSIMessage *msi)
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
@@ -1073,7 +1060,7 @@ static void apic_mem_write(void *opaque, hwaddr addr, uint64_t val,
         return;
     }
 
-    apic_register_write(index, val);
+    apic_register_write(opaque, index, val);
 }
 
 int apic_msr_write(APICCommonState *s, int index, uint64_t val)
@@ -1086,7 +1073,7 @@ int apic_msr_write(APICCommonState *s, int index, uint64_t val)
         return -1;
     }
 
-    return apic_register_write(index, val);
+    return apic_register_write(s, index, val);
 }
 
 static void apic_pre_save(APICCommonState *s)
-- 
2.51.1.dirty


