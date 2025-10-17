Return-Path: <kvm+bounces-60317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50998BE91C6
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9756E1AA2004
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1476536CDF8;
	Fri, 17 Oct 2025 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U8uI/M4K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8559A332EDB
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710369; cv=none; b=YiRInHw4pU0FTcFHKzGodbhyYqFHBdaTqpftfn8w+GPcO97h71iqNsS6gjtNPBePoPCQDpLQGXiZKERP5FMk89bu1tp3bn1JZuGquAH98bmIULWlKAlwc/V9MRAlycFHxVBDU8yv7vFJPiGwnoyp7qBYu9ylb2z6+NAED07mQEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710369; c=relaxed/simple;
	bh=bxdHKZc9pbxBqChYt8+Yh2D0W1yYdSw1LpL8rApqlNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKTza6ZEo0XO+04HfDLbV7e/vxH4M/DA25Hl4z0gKJV9eXdde1jdReu/mm5L7rOSngCZu3taMFa3nQon2bwGHcIs38diEklNl/TxotIFtv5rTuCdJZpTaYTl9Bd5PipaTZI5373lpf04ewUEYmJtMegeBBOIG0HTYw9E10MdCGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U8uI/M4K; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-426fd62bfeaso873676f8f.2
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710366; x=1761315166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFuBYoXthwAAHQXYSal9xNPgZEHCC/OlTSTKqa/XfA4=;
        b=U8uI/M4KFizDYc+3zWWtrt2DFOFz+u0PimhSYw2t3doY/AduhVIU1krt3vXHJ3DLTd
         SGSgj9jBFBQCbvXkxK8VT5ULaEyLfR/Yzof2Kt8mFeRadq4+qKCD1PO1xt3mypMlBRC7
         LU1nFTT1l9xYKP89tqtOHqhfF+iJJEdq9iVAQA+wKpNIySEh3856XE9tlao4Lt0xY1p5
         R4Haa28w5QyAvZ24jm6OrRsNIUMsM52eJH/jF0u4mcynBXUX1Pzp4Y5b1h8L7tdAClx4
         NzLXfHwmkqkQG8U5DYWVLDvmk/vRtXS5+x+cvRxPDiKvNaMj9Xw7xT8zRHsqM2PXQhB/
         r20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710366; x=1761315166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CFuBYoXthwAAHQXYSal9xNPgZEHCC/OlTSTKqa/XfA4=;
        b=eHYyBshrsqsNJlZM/CzEkwbYLJCERdbl8+n1o2Z9eo7OLO3sC6+vb1ybw9DJ0ZzGPv
         NZGm+wfBz/3pmU5gImhC8XCBR6In07lnfcyFbNfl540cojSLsV/v00vq/PSjtW/YRHsB
         dm1oHZhEnyBEyN30swohcxwNxuUcM2QIqP9/KF06d3WQrQiS3mCaMYoqFVT12MQyy8+U
         hexaot7U2VKaDmKRJl/rRF/IPM/EMQ0u1RHBB/HVurecT/8nZ5yTyM+uYZb1HH1cFiU/
         q+2J4vPWy2FxnmJIXaySGd/GgVBQ2oswV8Q2HgBD5no78KRCNtUOHS71VSzNuHVtRu+b
         1bAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJaNd4zg2Obr/osJuwEypk1BAP1vsxT9OxFs76wkOJE78j2C5ZKU/w0kmR/NvNGzAyyyQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkA+Al06uwVHkZJQ/BW0U+G+as96l/+qLEXktVCGr05ZnY7H8M
	3gpV6fU9JxZgvrJXcm1PHsli8XJaxtmZ1/5EHrX14+hdP8ckdOmJPNgi
X-Gm-Gg: ASbGncsBm0jRgUceZ1YOhc++SMc3J/vEKd43zQm1Qq0HVMvbtMEJ7G3nnE/DAy2HpZT
	fY1u3CjGV/N9zDbFgGlDgqkT9SfVIexrVerJ30QmthWEx9+zPUZr9QKT1Z+RFNMP/fAvaoBhuJA
	r4+KchNGBm2QRumQ4eHdr0P1QvAc94b+P7Nz6hFRGlqMsSa+l1vanMMPC0v7n9r5gYm2cliYNVv
	qPRep6HeX0DSUvNKs27l+4i93+sglDCONaYl40sp/bvIM52EHP3el7cVSn6OHyNl/Drv4aWHp1y
	AHpl7H0TOZbkFsIowGor0sWFDmk7XcvqoIpoySVYlJuoLSz7wFa+K5R2+7VK5wlYC5ePUPDW0n0
	kQTaHcSFx7WF9PGrKHCD8Pzb5JqheAu0W19Cn6xSunJrwAo19WSMV6Q+ZLp2cMDI+nvXhVTF/fU
	E2q8S8qVvwyt2xUo9h8by/wjTbvi7x3+3X
X-Google-Smtp-Source: AGHT+IGHj5C2eusACsFwArx+C7dtue7Nn7sN6TxgdAb/eWFrYxY0hNIfyjFi65Oo95iq3W/yO2xXEg==
X-Received: by 2002:a05:6000:1865:b0:425:8bd2:24de with SMTP id ffacd0b85a97d-42704d145c9mr2514261f8f.9.1760710365572;
        Fri, 17 Oct 2025 07:12:45 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cb36e7csm51359675e9.2.2025.10.17.07.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:12:45 -0700 (PDT)
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
Subject: [PATCH v2 01/11] hw/timer/i8254: Add I/O trace events
Date: Fri, 17 Oct 2025 16:11:07 +0200
Message-ID: <20251017141117.105944-2-shentey@gmail.com>
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


