Return-Path: <kvm+bounces-60301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DACECBE86AC
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:39:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99DBE42421C
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E26C332EDA;
	Fri, 17 Oct 2025 11:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iNbKAAvi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74480332ECA
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 11:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760700841; cv=none; b=lPMYClEmzKGHrOri21HkR6BsI52/oiriFpK+opcAXPOMtZLN7dhMabS2459nE6YjsK2wZ28ouiNx+AsINHJgv/O+pAsuTzOceI+ncRa0YKtn34lAJizXfEPCB1MYhBTY663llhfo8uuG3IrS7deSfDYDkWFdVr3sG9qRThTnD+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760700841; c=relaxed/simple;
	bh=bxdHKZc9pbxBqChYt8+Yh2D0W1yYdSw1LpL8rApqlNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5elHWJiPLpKEN2X/QPUZvEsVTfgBUi88McxN05k+WqQp0Rvt+3JANgEWsXgd9biB3Mc8LsBHwHIvjFXrEEWylABPh+ipDSmNED2wZLIW+p35BUWjT15feSad8QSD2eahmF8O1k5OQgWgPkHrLEOVeFzcvMwXmpKgck47U/tmas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iNbKAAvi; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-471193a9d9eso8510355e9.2
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 04:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760700838; x=1761305638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFuBYoXthwAAHQXYSal9xNPgZEHCC/OlTSTKqa/XfA4=;
        b=iNbKAAvi1HcVq2Fp/kmn7klr1Px2FwHRSjW7qG9OjgpcyOFzdewfHo8xJy3bz4dk7X
         Ff/PlXzWO2p0w1y+otISK5956obsqY5jZMAkoNpTuMfXM8bf71l10Sutdt/s6cvcSV0n
         win1rNr2J6mfxCIbjyxNqSVxsgvrvIeZuqLK635SHmVg6jMWkY8IegcS2hOcLEHeEWxa
         rRim9ycIjBTDML+WDY+gKBPSjTkBmp+0ame1ZGEYrthM0t+kA3ycDs1YQYYal7k5vbZy
         A+b3ix4UMMmuismKbgQQSaMP8ZcAJr570XMSiJE7NKLHqNZtnhQSe8rC1UXcO40bcjjZ
         1uFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760700838; x=1761305638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CFuBYoXthwAAHQXYSal9xNPgZEHCC/OlTSTKqa/XfA4=;
        b=iXKiAm/xSJ58VGH0c5pb5uyIb+UMY/GAnsOsD6lBXW8lFvSVIqR5ZZXXGWKwUqHY/8
         dsrkp7gr1l+Jvg8d1/5aDa3/VPb+2rloS939RVkyeZNyTmNYNHEfQZCeAXXGRlg2gy9a
         UT8lo3pmwHA0wHAwDnDeeeHFCgwgSZG+EVcFic04QPgm2BS0lG1s7VbyUUz5qar6UP++
         pnK/3gK75gBwIqnhRySqLDLtAaLotQWyHkA1/CRzltxnkKFIathy8v2LZzIawDgfoUX5
         TGjJaMgdYe/e8JmI6H2MvIBXQH0pLmAVQsNunwAa+UXlnilZPkuHLqvW0md2CZyE6msC
         wGSg==
X-Forwarded-Encrypted: i=1; AJvYcCUd/B02+ufbBSNCvS8ldPeLZqCbNojwvO9JDJaIEG6gZgSPLpfSY8Bkt1t9HxOtjUMCw/s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYxCNQgq+Q750c1i673IPxiW03oaBB6VpkFbHSjCW5EPtuMTCf
	d0yejozgvYmx6GEMCZGcQwL2IOcHIx9Eu1qcba8x6oQV2r4m9L2wqWey
X-Gm-Gg: ASbGncvoNQCuhFBalNkLxf4dMZ3ApeZIYIVuYegLfuzubnxYOh9YMbJ0c7G6l2g+uiN
	1ekIsk1sQaifLfy2wKP9523iNqQGDYEL1+98m2YsjFfgNSMsiV+0liUthFgu2zcpNLb4vvu+2NH
	CaLd/Mf8WAbmtiu1gg2n+Oh3IwPs/SBxVIMWy0kC5urJDK5VaB7u/3jzppwNpBMbzBp0Iwmud3b
	AlfvnxEc927uHSHfTp0we1R6Ljt6hOczM9KoFR7zPmwfUfxSUab6Mx/dvdUuLfeQC/F+XiJfldP
	+SHlFyrGwz7BZkO0jBExVkOaeXDkVLfFxGFko86D/rj9y+XFKJCxpzcWu6HvslQNUwUVQeyMZwb
	rtRzhdnwp0iScA5JoTx86M/K4sVOt7zjTXjmm4+QC8csvoRc8zq3TPWNFzlOo2wVY3jOWlkgSmu
	U5JyMylFrpdhajr0xcSyRMMsR70eYr0dMYBhj8u4bzckI=
X-Google-Smtp-Source: AGHT+IE4/5NSxn/nzjrRaz/2tSIvi+OUwAPSKioBRiI/FigXa2wroS6pbibBYzUChp/qeNC2MX0YBA==
X-Received: by 2002:a05:600c:8b2f:b0:471:56:6f79 with SMTP id 5b1f17b1804b1-4711793149emr23237705e9.41.1760700837650;
        Fri, 17 Oct 2025 04:33:57 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711444c8adsm80395435e9.13.2025.10.17.04.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 04:33:57 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Laurent Vivier <lvivier@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <laurent@vivier.eu>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-trivial@nongnu.org,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH 1/8] hw/timer/i8254: Add I/O trace events
Date: Fri, 17 Oct 2025 13:33:31 +0200
Message-ID: <20251017113338.7953-2-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017113338.7953-1-shentey@gmail.com>
References: <20251017113338.7953-1-shentey@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allows to see how the guest interacts with the device.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/timer/i8254.c      | 6 ++++++
 hw/timer/trace-events | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/hw/timer/i8254.c b/hw/timer/i8254.c
index 4b25c487f7..7033ebf50d 100644
--- a/hw/timer/i8254.c
+++ b/hw/timer/i8254.c
@@ -29,6 +29,7 @@
 #include "hw/timer/i8254.h"
 #include "hw/timer/i8254_internal.h"
 #include "qom/object.h"
+#include "trace.h"
 
 //#define DEBUG_PIT
 
@@ -130,6 +131,8 @@ static void pit_ioport_write(void *opaque, hwaddr addr,
     int channel, access;
     PITChannelState *s;
 
+    trace_pit_ioport_write(addr, val);
+
     addr &= 3;
     if (addr == 3) {
         channel = val >> 6;
@@ -248,6 +251,9 @@ static uint64_t pit_ioport_read(void *opaque, hwaddr addr,
             break;
         }
     }
+
+    trace_pit_ioport_read(addr, ret);
+
     return ret;
 }
 
diff --git a/hw/timer/trace-events b/hw/timer/trace-events
index c5b6db49f5..2bb51f95ea 100644
--- a/hw/timer/trace-events
+++ b/hw/timer/trace-events
@@ -49,6 +49,10 @@ cmsdk_apb_dualtimer_read(uint64_t offset, uint64_t data, unsigned size) "CMSDK A
 cmsdk_apb_dualtimer_write(uint64_t offset, uint64_t data, unsigned size) "CMSDK APB dualtimer write: offset 0x%" PRIx64 " data 0x%" PRIx64 " size %u"
 cmsdk_apb_dualtimer_reset(void) "CMSDK APB dualtimer: reset"
 
+# i8254.c
+pit_ioport_read(uint8_t addr, uint32_t value) "[0x%" PRIx8 "] -> 0x%" PRIx32
+pit_ioport_write(uint8_t addr, uint32_t value) "[0x%" PRIx8 "] <- 0x%" PRIx32
+
 # imx_gpt.c
 imx_gpt_set_freq(uint32_t clksrc, uint32_t freq) "Setting clksrc %u to %u Hz"
 imx_gpt_read(const char *name, uint64_t value) "%s -> 0x%08" PRIx64
-- 
2.51.1.dirty


