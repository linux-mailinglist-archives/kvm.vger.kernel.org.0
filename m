Return-Path: <kvm+bounces-40511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A842A57FB2
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 163AD3AB914
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A32A520D50D;
	Sat,  8 Mar 2025 23:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l4WB1w6R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6BE1B425C
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475428; cv=none; b=nh0pt6qpZ7bCSPg0fAabk1Oww4lIge+2etXCrswj1hotkDOQyV0s0VwadYdKjSoZciczrSMpP+pcxkrAh2U0be00dLs0pYwsu25twjIaftAhOIKdYHUExDS9F7NJZlfBB9dInIdYyyWiZwB68nK3Ce+62DMWGIqF8/Y18vTpxSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475428; c=relaxed/simple;
	bh=elWpsIOnV0p3LFy4LnL/vFxjO0MGaJh5o5Tte1c4oC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VGu75z8lXAp1+gh3/YB361kMINuIrJViOuTCSghMiykasVNMgeD+NU7XeYTTqRIAKo3imjt2Rv1ys2a9dl35Gw7dwnzZu/YMMjCwFqYR4weJ5xmiYgfpH+73L4sZ3zhvRAtaXIzs77Yfd+4liI7wQLNBRTJ8gG7ARkiVA1ou4ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l4WB1w6R; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43bcc04d4fcso17916375e9.2
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475425; x=1742080225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAApOfCWWikXdcBm+45ltUmeOBmLQGFruMZPHaiGOZ8=;
        b=l4WB1w6RxIj1XfV8FitOLA8BtSlVL3OR4eW43OBstDDECzWe2v7fmrNghHANYpB4l/
         Nj+kZltdalxMwhKu8yk2tN8xy67Iv0Z+ABO3CZffJ2xjZkSVdll0nYllmYd1ts6bVTu7
         gdV9pZBXVh51kvDVMkzAcUrZ+Q2d2+huDC3tbIw1Bv9ldF+BMeydFFCDLzWYvxu/Z1iH
         4aDIv90zAXeqAqMF1X6ChgRikKZi+xIsSbKmSjlraPDl0MyzYRjhj/dq5teDe5uLhOl9
         BGf9yx4tfPsXkKMw+0FuiFsM1TRJ6hqtKbF0it7T4IFmc3ttgk44QgblqViCiADlq0D6
         s4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475425; x=1742080225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OAApOfCWWikXdcBm+45ltUmeOBmLQGFruMZPHaiGOZ8=;
        b=mI1ONnVxU19OLbgPxB2S7Uxwv8JM0YLepG3731LVinVfVdr6xWpEB8GHgHngzspLvI
         aGWJze0qrSWd+6BHp6r0xaZJuSpqEZnL/WhS/zsVOxpfmtHKR5z5E3HePc637rK89Uat
         YZDu1EmdW9OXw0aBmJQuOBTSjDVZeTdyBdzXL7jmgsAwrFU+6q6o5ohfRj2raaCTz4Cp
         aV8wznq8rpdbfVTsn4I5bgUxSihIRnvFLJmUYT0MqnCRVovEWyppYPi8FIENhZlqa5tZ
         l1GM8/4fHU6HO/AnNJfx1fZwCFIdZGgV3gztv9PsGZ2qGTBqDkreoKRqo2BGz4CZVRfj
         Mkyw==
X-Forwarded-Encrypted: i=1; AJvYcCX6nmDNmsg3BDeD09eQavqTLCjvbl1R15mXdf5pG9OL2DjtT0u66ijwDKdCAeq49kp1OOA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2SEzop4WJwkYs5Eno/732ht6qQSDAn87tceEShZOp4R5TXSlU
	aCvmJo586mY/j+GzfpDhmU3C8OMECGaOwtQvm4c7J2YCEjGjvbQ7AnNzhl6PJp0=
X-Gm-Gg: ASbGncuk6qvWKpyF/CoknIiRpLpfOOPXFK4MhuOLlHNAGQpy/90OxjUTW+LKPwmZqNS
	0fLpiSsEX7lYzZphyY+uWBmGE10MQhYwc7J8mZPHlmaggUzk6ab05YQhA49fSRVNKKeExJxCwUg
	plACNLqTAl5aCW1sx6+KrIzQHhxPSakiz6XQ3JNGdIL35uNFiUzhqdMkeDc9QrGoi77lU5jFwth
	wlNZKkPTfCBKaXIgYtwmYkn+FfpTjkQ2PQD1ZXbm3HKWwhtQFZseCfKOMeThpuwGa98czGoHT4q
	q9SYWJx4ZMp4gBOY3LEMsxZttGD4LRHsG1VdyAZPnd8xf7CWSDgUkjayLvXfY4c3nNz3EaOYVbF
	DUhVY46jxlDYk+SZ76zc=
X-Google-Smtp-Source: AGHT+IEsdUpzC3vvzIbC6qsVM93qE5A0/3sv2x9KGYFFRAItc0/EzKZy6rlmtqCICch1ekTW0tHDTg==
X-Received: by 2002:a05:600c:3b1a:b0:43b:c541:51d3 with SMTP id 5b1f17b1804b1-43c601cfe2cmr50795605e9.6.1741475425507;
        Sat, 08 Mar 2025 15:10:25 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ceaac390bsm30320235e9.35.2025.03.08.15.10.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:10:25 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	qemu-s390x@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 11/21] hw/vfio/igd: Define TYPE_VFIO_PCI_IGD_LPC_BRIDGE
Date: Sun,  9 Mar 2025 00:09:07 +0100
Message-ID: <20250308230917.18907-12-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250308230917.18907-1-philmd@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Define TYPE_VFIO_PCI_IGD_LPC_BRIDGE once to help
following where the QOM type is used in the code.
We'll use it once more in the next commit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/pci-quirks.h | 2 ++
 hw/vfio/igd.c        | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/hw/vfio/pci-quirks.h b/hw/vfio/pci-quirks.h
index d1532e379b1..fdaa81f00aa 100644
--- a/hw/vfio/pci-quirks.h
+++ b/hw/vfio/pci-quirks.h
@@ -69,4 +69,6 @@ typedef struct VFIOConfigMirrorQuirk {
 
 extern const MemoryRegionOps vfio_generic_mirror_quirk;
 
+#define TYPE_VFIO_PCI_IGD_LPC_BRIDGE "vfio-pci-igd-lpc-bridge"
+
 #endif /* HW_VFIO_VFIO_PCI_QUIRKS_H */
diff --git a/hw/vfio/igd.c b/hw/vfio/igd.c
index b1a237edd66..1fd3c4ef1d0 100644
--- a/hw/vfio/igd.c
+++ b/hw/vfio/igd.c
@@ -262,7 +262,7 @@ static void vfio_pci_igd_lpc_bridge_class_init(ObjectClass *klass, void *data)
 }
 
 static const TypeInfo vfio_pci_igd_lpc_bridge_info = {
-    .name = "vfio-pci-igd-lpc-bridge",
+    .name = TYPE_VFIO_PCI_IGD_LPC_BRIDGE,
     .parent = TYPE_PCI_DEVICE,
     .class_init = vfio_pci_igd_lpc_bridge_class_init,
     .interfaces = (InterfaceInfo[]) {
@@ -524,7 +524,7 @@ void vfio_probe_igd_bar4_quirk(VFIOPCIDevice *vdev, int nr)
     lpc_bridge = pci_find_device(pci_device_root_bus(&vdev->pdev),
                                  0, PCI_DEVFN(0x1f, 0));
     if (lpc_bridge && !object_dynamic_cast(OBJECT(lpc_bridge),
-                                           "vfio-pci-igd-lpc-bridge")) {
+                                           TYPE_VFIO_PCI_IGD_LPC_BRIDGE)) {
         error_report("IGD device %s cannot support legacy mode due to existing "
                      "devices at address 1f.0", vdev->vbasedev.name);
         return;
-- 
2.47.1


