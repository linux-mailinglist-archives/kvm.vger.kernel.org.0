Return-Path: <kvm+bounces-45883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB76AAFBDD
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C929C500E5F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFFD22D9E3;
	Thu,  8 May 2025 13:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CxwUVTOC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953E322A807
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711879; cv=none; b=pnzWQbFndGOaJ27AiAOj9EEiqzlbO8w29TAEDiGYthqKMkUNXMlDsFWQ3195yuyrc6HhLRCNgJk16obqQfu4sSQJMGby6on+aYWpc72Cb5S5Zfz7PJMjp5O3FdlXNrqVw4GpYehF5e6OxolmqECDOnFcyjgalpbjsVzEyByoMlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711879; c=relaxed/simple;
	bh=BBW3uB+3VA8sxUHTu0VzCPzaT8pWcPQJXL/Tqx/HXmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AAzgLxrYh4uuSH5i/EmGisP7vyOusTyO6HGXucGbYqxAfV1bEea3N0U9agp7mM/0qFp3ej63t7UNB26aPZwPwd2ndqGXzCROnRyx3U8x1tFg9BYepAY1mKJ4q6gqlRByqwv4t5ricuo9IHK7+aqmvydmfQKzWoWY3YEr+RRoG6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CxwUVTOC; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-30820167b47so901085a91.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711877; x=1747316677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ABC8+QfGyso1WyDvOcXI+0OZWgW+TnNwcrP3jxKT+bs=;
        b=CxwUVTOCSUFUyRk8nXH87jIXy2pBLhylmwWie9PmrDys2P6Sriqs7aUjff01+DOrWs
         DT63g1NAgg3PCEDJIYhnhJZ1pziIdxToZLOqusqps+3QmS+BHez2MBh74hDsFu9t9r1f
         xE6y4wMFqCfdIxUBnGKMVr0U0vg+xetozmnnLX4xkTtRaMIZ4vlZq69mgOhCbuoTjqP7
         t9HRaKh2DVwcG2KLPrVZEzAPaIXDCoXPsH3ZeMbvsJsiYlp/vh/qLPLr7wWi2oepoWtM
         k4ah3T9mh/CHY+Ww4y0wQTHGtf7ES4svDn9LSLoZJw+xLQfgJB2L3SHjtEiQWpOLhkQf
         +ptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711877; x=1747316677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ABC8+QfGyso1WyDvOcXI+0OZWgW+TnNwcrP3jxKT+bs=;
        b=WE5/1NqzmtNxCoCHRquvp3xjxCra3x3coEDSQc2TOpu4htWChaNcnjn+WHObZb0Qz2
         UhrAsR18mNLcjwDo++iykZqEIqHJgGfm+axPJRUNZfWS60BBQJkhb+gThmEu2MCHZMNP
         d3orprwfaNhOLdAZi1pqh0UOHYGSX6fceI46o9SOWVpRtS9/61K5wntnYHYeRIpqQo5W
         R+OZid1Qm3SCiR/TlTz7OEn4KHyKD19JA99bMH33QFPra78Kl9liawCBYLs/HhFTYbDh
         SEXUvXiftWWb0D+4IjByNa0llZI3esK1LabBGiQcX0GFHcpo8tCPr78BTlewl/QG/+oC
         wfIg==
X-Forwarded-Encrypted: i=1; AJvYcCXid4rmbNtvoMcGr8SazbxW+oB1SMSqVUosOTfAghY1r6YRJ0g2QjRt5O1Nz7Oqu5sP3qE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ9kmvB86RQU+cKF0IK6RoEJtRhcNip0soES5QDPGlghrzTDq0
	VMoikqZXdHSPVU/+U3klH4qRDLzSACc1jXFdJl31hge6Nh2WkqfGpkVI0AcwPNc=
X-Gm-Gg: ASbGncuwaGgYKNkNCRt4RJfbf1KrepHynLI7CKDsQWqkmF2qpjgb84oOhn7zDrvoi+E
	VumzGBm4WtYiLqF2E0Ai94QVBC1gmhP/VI+Bb+HyxxT26b17CWjla85sxLY4lJwFHVZDisB3RCd
	iK7B7vWvY+sJ7KN+2PRZKK/alF5Beu7EbLGQ+y26ZJfLoRW2d1QfA/9tqJFa+QIoq0giw27PanN
	kxsfgVYDRvWdQCOev6v5CgiwdDD3VOKTtdj/XDnqYtk9AznjoyzuIxXyZC7TqB/ELUOLlkRwPSu
	NgM8ghD4Ua0FcuDa+3xnu7Tk/FVsGS7JwCwdytZye6XdHWkZYtzvtSTvFDKqsv9FhNPGGT6xVfB
	MjtmN776ZFw0quGA=
X-Google-Smtp-Source: AGHT+IEUdsHAoEH5Q8KZKtz2AvzabbEqVKF3EUjTCg5XRDEcrks+oGqKHzSziA06tvgUnitC8tKtJg==
X-Received: by 2002:a17:90b:224e:b0:2ee:c30f:33c9 with SMTP id 98e67ed59e1d1-30adbf3b191mr5502686a91.14.1746711876787;
        Thu, 08 May 2025 06:44:36 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30ad474a05bsm2173239a91.2.2025.05.08.06.44.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:44:36 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: [PATCH v4 23/27] hw/i386/intel_iommu: Remove IntelIOMMUState::buggy_eim field
Date: Thu,  8 May 2025 15:35:46 +0200
Message-ID: <20250508133550.81391-24-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The IntelIOMMUState::buggy_eim boolean was only set in
the hw_compat_2_7[] array, via the 'x-buggy-eim=true'
property. We removed all machines using that array, lets
remove that property, simplifying vtd_decide_config().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
---
 include/hw/i386/intel_iommu.h | 1 -
 hw/i386/intel_iommu.c         | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index e95477e8554..29304329d05 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -303,7 +303,6 @@ struct IntelIOMMUState {
     uint32_t intr_size;             /* Number of IR table entries */
     bool intr_eime;                 /* Extended interrupt mode enabled */
     OnOffAuto intr_eim;             /* Toggle for EIM cabability */
-    bool buggy_eim;                 /* Force buggy EIM unless eim=off */
     uint8_t aw_bits;                /* Host/IOVA address width (in bits) */
     bool dma_drain;                 /* Whether DMA r/w draining enabled */
     bool dma_translation;           /* Whether DMA translation supported */
diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 5f8ed1243d1..c980cecb4ee 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3823,7 +3823,6 @@ static const Property vtd_properties[] = {
     DEFINE_PROP_UINT32("version", IntelIOMMUState, version, 0),
     DEFINE_PROP_ON_OFF_AUTO("eim", IntelIOMMUState, intr_eim,
                             ON_OFF_AUTO_AUTO),
-    DEFINE_PROP_BOOL("x-buggy-eim", IntelIOMMUState, buggy_eim, false),
     DEFINE_PROP_UINT8("aw-bits", IntelIOMMUState, aw_bits,
                       VTD_HOST_ADDRESS_WIDTH),
     DEFINE_PROP_BOOL("caching-mode", IntelIOMMUState, caching_mode, FALSE),
@@ -4731,11 +4730,11 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
     }
 
     if (s->intr_eim == ON_OFF_AUTO_AUTO) {
-        s->intr_eim = (kvm_irqchip_in_kernel() || s->buggy_eim)
+        s->intr_eim = kvm_irqchip_in_kernel()
                       && x86_iommu_ir_supported(x86_iommu) ?
                                               ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
     }
-    if (s->intr_eim == ON_OFF_AUTO_ON && !s->buggy_eim) {
+    if (s->intr_eim == ON_OFF_AUTO_ON) {
         if (kvm_irqchip_is_split() && !kvm_enable_x2apic()) {
             error_setg(errp, "eim=on requires support on the KVM side"
                              "(X2APIC_API, first shipped in v4.7)");
-- 
2.47.1


