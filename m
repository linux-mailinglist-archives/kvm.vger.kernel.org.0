Return-Path: <kvm+bounces-14853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23C2C8A7408
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 431F61C2136D
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2267B13777F;
	Tue, 16 Apr 2024 19:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oVJVHN5y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E54D13777B
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294013; cv=none; b=KPfIJ/CsYwNOBL0qiKHFpFZLw4uhPiOnNejssfFCs83mzN34ZPhDWAWnN5ugRnYNQlLU0lfIwa83CqX1H0jgpWWaj/aHyqipI/XKke7+wctGg7WDsgQg8oKvD2BNxuKMvI/3mxuDPKJe+v4UHlVRafFiKzWlddmmECEIDUhzvBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294013; c=relaxed/simple;
	bh=K1mwwMOSS47AzlkrVHBlQ+ijKS7GPj2yY2IErCkgglI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CNnVi46RaR4owk7PxuOFCXaTlZGJywmAmunv34uCpoQnjin3qpmu67qiNVZW0ynqVFVTysgIhyERNvTma+/Q6DkREx18KiqJWdS8Xbv8za+rpPr0NJHtxkFMZLROyHNwHn5LJMyex/g3ZpwTfyWHUfBQRhObkc7DNAd/JHcDX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oVJVHN5y; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-516ef30b16eso5678139e87.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713294010; x=1713898810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r03IbH4Q5jukHMDYRNDrIPnxYvDkdnR4utG+Rvdo7L0=;
        b=oVJVHN5yOv6jjMh+WN5wF7csswhK1CzMbPFp8TLaAiHfH6WB+JGsCVhwzwkYetgrPI
         n29yLxeMFiXNhMqBCQlXg6l+uUusdZaTozfets05l4WSWr9LTg5JiI7ZNJrRJGAZ6Kut
         t4KDThz5MiZ/y2axl+9SZdyF5nau1IkeK4R/8RhplZEUCYNSou0M8hY95qqdKc03Brq9
         tuo0bXTutAp1msi2PADX58A6bwlg90vPfGcNlYbkf5yjhcBAaNnrw0EDI8MzLuyIUWuc
         s1PEFg4bHR1jSdMv8UxzPe4UJSDztzN0kX6SHTmvbxj11kzwSdSJuzXfq2dCpVsHwrMY
         6V8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713294010; x=1713898810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r03IbH4Q5jukHMDYRNDrIPnxYvDkdnR4utG+Rvdo7L0=;
        b=G4DzEZwyL7rJsipbGzzTrVpNxALDp+eEsBIi6E49mWLnVnLqP126+x2VBfqB6g4yxR
         ybHdeIrq7T60ZPaQM7dQuYVppfW2OpgMVxZDvIOMc/pYWVzTS3aXuUVoZ22uIMGegSGP
         lBwz3MxNRMvH8hGyhRrMLHB4h40cLR/BkJNKJzAN7bSPQq5K6o30XwZaWr3CS+thBLz+
         h+q25d0imVSp1mHITaDTXJdThlUx+r6J66c8gCShqWaLT7wSg1DaX2xklsZ+5tFY+t9W
         6CAbhQ+/+0ebxboXmCaVO3G74L8t2DUUI21koOujckGLH/WkOlx3yV0TRMQixJCSUUpu
         ci9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVmXFL30X+Z7QTKSfF9f7pP8NAqq6dTLZNplo5rfJEnAlhWiOCHVWKSejtyS/cU76MnpErHcT3SbVOxgFU6W9XG+kJN
X-Gm-Message-State: AOJu0YwBY9O7FcNVEyzmMFfI5pE9Lj2T/ksrp0eGYoEgQAdSWVAAKJYc
	P9LLCZRcH+5NWavSkjxfzNZCzCOUNssSW0o4gf4rwUkDVAkMNopG6jF8xuXwUBg=
X-Google-Smtp-Source: AGHT+IHRsiss2Z7S14JYdvY6Yt6YrgQ0OojgolVzH0Nx8AY7SPkGC1icvBRPX09j77zZ7WWRP2L3sQ==
X-Received: by 2002:ac2:5544:0:b0:515:bee6:5e8c with SMTP id l4-20020ac25544000000b00515bee65e8cmr7857295lfk.40.1713294009690;
        Tue, 16 Apr 2024 12:00:09 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id ae12-20020a17090725cc00b00a529aeb4eccsm2558072ejc.140.2024.04.16.12.00.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 12:00:09 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v4 04/22] hw/usb/hcd-xhci: Remove XHCI_FLAG_SS_FIRST flag
Date: Tue, 16 Apr 2024 20:59:20 +0200
Message-ID: <20240416185939.37984-5-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240416185939.37984-1-philmd@linaro.org>
References: <20240416185939.37984-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

XHCI_FLAG_SS_FIRST was only used by the pc-i440fx-2.0 machine,
which got removed. Remove it and simplify various functions in
hcd-xhci.c.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/usb/hcd-xhci.h     |  3 +--
 hw/usb/hcd-xhci-nec.c |  2 --
 hw/usb/hcd-xhci-pci.c |  1 -
 hw/usb/hcd-xhci.c     | 42 ++++++++----------------------------------
 4 files changed, 9 insertions(+), 39 deletions(-)

diff --git a/hw/usb/hcd-xhci.h b/hw/usb/hcd-xhci.h
index 1efa4858fb..fe16d7ad05 100644
--- a/hw/usb/hcd-xhci.h
+++ b/hw/usb/hcd-xhci.h
@@ -36,8 +36,7 @@ typedef struct XHCIStreamContext XHCIStreamContext;
 typedef struct XHCIEPContext XHCIEPContext;
 
 enum xhci_flags {
-    XHCI_FLAG_SS_FIRST = 1,
-    XHCI_FLAG_ENABLE_STREAMS,
+    XHCI_FLAG_ENABLE_STREAMS = 1,
 };
 
 typedef enum TRBType {
diff --git a/hw/usb/hcd-xhci-nec.c b/hw/usb/hcd-xhci-nec.c
index 5d5b069cf9..0c063b3697 100644
--- a/hw/usb/hcd-xhci-nec.c
+++ b/hw/usb/hcd-xhci-nec.c
@@ -41,8 +41,6 @@ struct XHCINecState {
 static Property nec_xhci_properties[] = {
     DEFINE_PROP_ON_OFF_AUTO("msi", XHCIPciState, msi, ON_OFF_AUTO_AUTO),
     DEFINE_PROP_ON_OFF_AUTO("msix", XHCIPciState, msix, ON_OFF_AUTO_AUTO),
-    DEFINE_PROP_BIT("superspeed-ports-first", XHCINecState, flags,
-                    XHCI_FLAG_SS_FIRST, true),
     DEFINE_PROP_UINT32("intrs", XHCINecState, intrs, XHCI_MAXINTRS),
     DEFINE_PROP_UINT32("slots", XHCINecState, slots, XHCI_MAXSLOTS),
     DEFINE_PROP_END_OF_LIST(),
diff --git a/hw/usb/hcd-xhci-pci.c b/hw/usb/hcd-xhci-pci.c
index cbad96f393..264d7ebb77 100644
--- a/hw/usb/hcd-xhci-pci.c
+++ b/hw/usb/hcd-xhci-pci.c
@@ -242,7 +242,6 @@ static void qemu_xhci_instance_init(Object *obj)
     s->msix     = ON_OFF_AUTO_AUTO;
     xhci->numintrs = XHCI_MAXINTRS;
     xhci->numslots = XHCI_MAXSLOTS;
-    xhci_set_flag(xhci, XHCI_FLAG_SS_FIRST);
 }
 
 static const TypeInfo qemu_xhci_info = {
diff --git a/hw/usb/hcd-xhci.c b/hw/usb/hcd-xhci.c
index ad40232eb6..b6411f0bda 100644
--- a/hw/usb/hcd-xhci.c
+++ b/hw/usb/hcd-xhci.c
@@ -541,18 +541,10 @@ static XHCIPort *xhci_lookup_port(XHCIState *xhci, struct USBPort *uport)
     case USB_SPEED_LOW:
     case USB_SPEED_FULL:
     case USB_SPEED_HIGH:
-        if (xhci_get_flag(xhci, XHCI_FLAG_SS_FIRST)) {
-            index = uport->index + xhci->numports_3;
-        } else {
-            index = uport->index;
-        }
+        index = uport->index + xhci->numports_3;
         break;
     case USB_SPEED_SUPER:
-        if (xhci_get_flag(xhci, XHCI_FLAG_SS_FIRST)) {
-            index = uport->index;
-        } else {
-            index = uport->index + xhci->numports_2;
-        }
+        index = uport->index;
         break;
     default:
         return NULL;
@@ -2779,11 +2771,7 @@ static uint64_t xhci_cap_read(void *ptr, hwaddr reg, unsigned size)
         ret = 0x20425355; /* "USB " */
         break;
     case 0x28: /* Supported Protocol:08 */
-        if (xhci_get_flag(xhci, XHCI_FLAG_SS_FIRST)) {
-            ret = (xhci->numports_2<<8) | (xhci->numports_3+1);
-        } else {
-            ret = (xhci->numports_2<<8) | 1;
-        }
+        ret = (xhci->numports_2 << 8) | (xhci->numports_3 + 1);
         break;
     case 0x2c: /* Supported Protocol:0c */
         ret = 0x00000000; /* reserved */
@@ -2795,11 +2783,7 @@ static uint64_t xhci_cap_read(void *ptr, hwaddr reg, unsigned size)
         ret = 0x20425355; /* "USB " */
         break;
     case 0x38: /* Supported Protocol:08 */
-        if (xhci_get_flag(xhci, XHCI_FLAG_SS_FIRST)) {
-            ret = (xhci->numports_3<<8) | 1;
-        } else {
-            ret = (xhci->numports_3<<8) | (xhci->numports_2+1);
-        }
+        ret = (xhci->numports_3 << 8) | 1;
         break;
     case 0x3c: /* Supported Protocol:0c */
         ret = 0x00000000; /* reserved */
@@ -3349,13 +3333,8 @@ static void usb_xhci_init(XHCIState *xhci)
     for (i = 0; i < usbports; i++) {
         speedmask = 0;
         if (i < xhci->numports_2) {
-            if (xhci_get_flag(xhci, XHCI_FLAG_SS_FIRST)) {
-                port = &xhci->ports[i + xhci->numports_3];
-                port->portnr = i + 1 + xhci->numports_3;
-            } else {
-                port = &xhci->ports[i];
-                port->portnr = i + 1;
-            }
+            port = &xhci->ports[i + xhci->numports_3];
+            port->portnr = i + 1 + xhci->numports_3;
             port->uport = &xhci->uports[i];
             port->speedmask =
                 USB_SPEED_MASK_LOW  |
@@ -3366,13 +3345,8 @@ static void usb_xhci_init(XHCIState *xhci)
             speedmask |= port->speedmask;
         }
         if (i < xhci->numports_3) {
-            if (xhci_get_flag(xhci, XHCI_FLAG_SS_FIRST)) {
-                port = &xhci->ports[i];
-                port->portnr = i + 1;
-            } else {
-                port = &xhci->ports[i + xhci->numports_2];
-                port->portnr = i + 1 + xhci->numports_2;
-            }
+            port = &xhci->ports[i];
+            port->portnr = i + 1;
             port->uport = &xhci->uports[i];
             port->speedmask = USB_SPEED_MASK_SUPER;
             assert(i < XHCI_MAXPORTS);
-- 
2.41.0


