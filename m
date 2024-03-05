Return-Path: <kvm+bounces-10988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF15987208E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:43:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84D922883EE
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC788626A;
	Tue,  5 Mar 2024 13:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xyos9Q0E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B412B5915D
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646175; cv=none; b=BRtV7Blx8/nBE6qbdWAAWsXNWF5dFdrUPAYgvJX3jG5+CIKQXek9xsQlXj3iXXsrKWuq7wpcd3AFeQNB6d+4JOqgL9s25ZLfsd8gKgtLenR1804IRwDeUj9nPcATH+tDnp5jzhPNTEQ3nkG2h5OQaPTiOZ0o2Z9NVCjUzEOfxsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646175; c=relaxed/simple;
	bh=2+aQnHax8qcm6hglygfT9XHRHSnzR1kia8emApeNfO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0U9xam1/dpnKZmQtRfM6lC74bLOogxwJSRru3oP70Dk0IiP+muvZVir9LffeAK56HIKkFh2ey43G+tfkfK+h/xpqq/bfK/lNJPjqTde+t6NV10vQWzhiwgNq+fWf0rVPeUlOVfDhQztRD6/aTsbNkf6KfilhbfyixrLch22D0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xyos9Q0E; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a44f2d894b7so376268166b.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646172; x=1710250972; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfW77RB2c7k3ZDXHGh05HNMU3UcmTeaypC3Kdgt/4jc=;
        b=Xyos9Q0EnTYiahB/SlOA+ZUukEbERsHVaH5pJyfgpPoiSZW9eKUYvORCU5auJ74Fxn
         Vz3BHMKqcXCSscGof43g6DNYz/786+fDwdnLJdGkzjWLWHmf8PEvHc6QXAKD6cUovlYx
         7pjdSjW1Lg7UAdIQSvO+/WE6wh0no0F1BqG7xFWwKXtzcZwlGHWCJ4IcCcyR+VuDtgMl
         6xnW/7SJrpmaTyLN+p6WDvG0j3oy5nfFEKIPeCrlxDoHktCwt0jp6tvRwRHgJN2wjeUr
         Qu5sHO8QSuTZo5hF9x5l9foAs7qSJZ2ZRSU6l6Kk+MpAg1eizSpas/oFJjcGuYSq/R8r
         YnfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646172; x=1710250972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dfW77RB2c7k3ZDXHGh05HNMU3UcmTeaypC3Kdgt/4jc=;
        b=JIxqYWxITlxY7CEB4LloANphVEarHSDwukhEXdVS6UDTHeSu+f0oIqWrihVIvK3Pqp
         CKyFoEdAaIjbMDoNILyOIvlio7fyErbffGytnSKFXhswIWF6Hs2gDHt6JJPay1co2agQ
         PhE/e6JDWKtfDVjmJxttCyMmDLED57rHNjF5G8I4OiL9Vz/WwF246Z15j9RGohongShH
         orpo4r2S8yRyqtK7yc89vUasj/RgMVxK4KDlnCob/d0VWhjq5vReSKQ51BoRXp/Bbbfc
         Cdu9UGoScvIqsHCVC8akx8QgCibQmOPks7vdSEueKSXlouwPtcYNj0P1TJXv52rxJmLV
         LVJw==
X-Forwarded-Encrypted: i=1; AJvYcCVeqXjwWwbIAq9atKDDnZCnXhbkdMZSKSgY5pW8pNvgm9ZFFAA2bHiz3h3wEc/61lLEVxX3R8+Qimnv2P5IE6iN1vnu
X-Gm-Message-State: AOJu0Yy0bHin4YBhwkyD6bPxJJIsLkPttfPCsVJPACgWMW+NwSvhzmnM
	nlxaoTDIEDx5KoptyfwZIHHQWZxMR+UsYM+g1dy6/8hXFAsi3SQfnoncibSKYPs=
X-Google-Smtp-Source: AGHT+IFHUEUkZWZFlVXOVF2NKxZ+5If4reUQf8Sy4TYxGOUAHFlet0qWjxsTML0lIIl8M8UOzNFzsA==
X-Received: by 2002:a17:906:378b:b0:a44:90b3:aa3b with SMTP id n11-20020a170906378b00b00a4490b3aa3bmr8825793ejc.11.1709646172215;
        Tue, 05 Mar 2024 05:42:52 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id tj10-20020a170907c24a00b00a4452ed413asm5859830ejc.16.2024.03.05.05.42.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:42:51 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	devel@lists.libvirt.org,
	David Hildenbrand <david@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.1 04/18] hw/usb/hcd-xhci: Remove XHCI_FLAG_SS_FIRST flag
Date: Tue,  5 Mar 2024 14:42:06 +0100
Message-ID: <20240305134221.30924-5-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240305134221.30924-1-philmd@linaro.org>
References: <20240305134221.30924-1-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/usb/hcd-xhci.h     |  1 -
 hw/usb/hcd-xhci-nec.c |  2 --
 hw/usb/hcd-xhci-pci.c |  1 -
 hw/usb/hcd-xhci.c     | 42 ++++++++----------------------------------
 4 files changed, 8 insertions(+), 38 deletions(-)

diff --git a/hw/usb/hcd-xhci.h b/hw/usb/hcd-xhci.h
index 7dcab8b8db..051ea43261 100644
--- a/hw/usb/hcd-xhci.h
+++ b/hw/usb/hcd-xhci.h
@@ -36,7 +36,6 @@ typedef struct XHCIStreamContext XHCIStreamContext;
 typedef struct XHCIEPContext XHCIEPContext;
 
 enum xhci_flags {
-    XHCI_FLAG_SS_FIRST = 1,
     XHCI_FLAG_ENABLE_STREAMS = 3,
 };
 
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


