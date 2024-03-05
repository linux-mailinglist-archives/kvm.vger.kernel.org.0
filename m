Return-Path: <kvm+bounces-10986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF64187208A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A77728632E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC50F85C7A;
	Tue,  5 Mar 2024 13:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N/j2q7kK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D84B5915D
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646169; cv=none; b=GySMwiZZioIA+5Ga8Ah5Qtf2liRQ3Ntq70ylm2X9uBqYYyIHmEm6Lqua19Donnk9HCO8kKL4gOglU+17RnanDY0/yDtMnsuEX/P+JSFBaGfSUwjcNYjSxf9M4FMezAs+6zGKWgedqeHug4s7Gw350bTeGMlYiT+KU5qL7F/rwPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646169; c=relaxed/simple;
	bh=N991mKd0AFXRIfv94zfpnQ52F8jfBOvaDyhRcABY4Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SKJglQ3txzQZshEPYNQveAMuxG3CwrdYUGIvF1QcZmrhdJhbj0OC1YsQAvFexhfU1dYecYoz2rnNfrvY3pZvpoSC+CGvl53Fw7aUNPNezAc118ShSXBdg4dRKqHuG0NysJeTQoBWp/Beooav3dI7KifxT0LQS5kYV3lsfNu9mmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N/j2q7kK; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5672afabb86so2435126a12.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646165; x=1710250965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=puZvfwYJmiovgLIksxQYRb4sHK5AG83t9xnfOfq3iqY=;
        b=N/j2q7kKXs50wAHkTYVrY2Ago+a6IZzZwMcfQDJGec8QWy/Z+FVmxMLXVXWP6tlUEj
         Ew/bUUd4VV7fJTRrQU9zDA9hzSg8Lc4i+WEI0TLFYf0znRJJVd+VcqmAmSlEwMi2EG21
         KF0Mv3Av50oXqVW9jzpN6ov4Cf1CoTyLJbRHezm0GiBj1qQuI6qYM12LCBBw6etjp7h9
         fYR8ygNHKblYdE9WzfFFSQVVN8Dfs8chaEW56dIyV/2Ln8SNvKR9mu0xaCKDu27PBov0
         odhHoEbH+A2+SaIeRrTT+++MN8Yd3nPCMGaFyejJvQKJiBpm3SX6W0W9DBA3qXY/jWTa
         FK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646165; x=1710250965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=puZvfwYJmiovgLIksxQYRb4sHK5AG83t9xnfOfq3iqY=;
        b=w4MEkxxy925j4QXtMRNUOuubCRFZVFPB1hPKWjj6wZdXqyR+/5Mc2aW9Gc1cN1gjmt
         nOQ7VlLSiPeG5Hekz7EXtmKrFzpqcTZ1xcyPsaf1M0bu2rBxLEBjK+pcK7tmRScxq8Nf
         QCqIngYt9Shd7pXPx82+tGTkAX8wtnFyj27MIGYZLSnMPBuiKujh+jcsqMvdgER7GAyZ
         cpUmN17xuHyqvRKNwSN8ClQ4cI138c+J+VFB1NxiYuEPP+ddCIdliGragkdN2P+n6z/U
         T3m1D4dP6MkbZIupT7CNaFmOrk4ERYS0pLEwpFzfwK0W9+GmuguTkXXjx9PSDxkIhDaT
         m9sw==
X-Forwarded-Encrypted: i=1; AJvYcCXTtEv/7kjSYK7n/8FZiPMx/hoeJMrsoErVtxKIcPrCB7HrDkq+d5bzx+TfJh2LI6oL4g3v0mFeZFKAk5ST5uLpODBW
X-Gm-Message-State: AOJu0Yxov5+R2ENv0raLbOSUKieec6cA8XIlIPridvS9r44uPPzuA+Ky
	6fw3LYEoh/EhySGXyUvibQlt3dtsIsWJYAN9rDDfVndew7ivc2Dl2wxYmlut5LU=
X-Google-Smtp-Source: AGHT+IGoQLz3vb/hw5i2C2mEhP7oyJ2WOykEYWfKelOzXGkQ9Oyr76XV3KVkqIMUEC1WspvOGAtlkw==
X-Received: by 2002:aa7:cb0b:0:b0:564:dd13:56e9 with SMTP id s11-20020aa7cb0b000000b00564dd1356e9mr8683560edt.29.1709646165626;
        Tue, 05 Mar 2024 05:42:45 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id z42-20020a509e2d000000b005669d904871sm6107335ede.49.2024.03.05.05.42.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:42:45 -0800 (PST)
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
Subject: [PATCH-for-9.1 03/18] hw/usb/hcd-xhci: Remove XHCI_FLAG_FORCE_PCIE_ENDCAP flag
Date: Tue,  5 Mar 2024 14:42:05 +0100
Message-ID: <20240305134221.30924-4-philmd@linaro.org>
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

XHCI_FLAG_FORCE_PCIE_ENDCAP was only used by the
pc-i440fx-2.0 machine, which got removed. Remove it
and simplify usb_xhci_pci_realize().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/usb/hcd-xhci.h     | 1 -
 hw/usb/hcd-xhci-nec.c | 2 --
 hw/usb/hcd-xhci-pci.c | 3 +--
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/hw/usb/hcd-xhci.h b/hw/usb/hcd-xhci.h
index 37f0d2e43b..7dcab8b8db 100644
--- a/hw/usb/hcd-xhci.h
+++ b/hw/usb/hcd-xhci.h
@@ -37,7 +37,6 @@ typedef struct XHCIEPContext XHCIEPContext;
 
 enum xhci_flags {
     XHCI_FLAG_SS_FIRST = 1,
-    XHCI_FLAG_FORCE_PCIE_ENDCAP = 2,
     XHCI_FLAG_ENABLE_STREAMS = 3,
 };
 
diff --git a/hw/usb/hcd-xhci-nec.c b/hw/usb/hcd-xhci-nec.c
index 328e5bfe7c..5d5b069cf9 100644
--- a/hw/usb/hcd-xhci-nec.c
+++ b/hw/usb/hcd-xhci-nec.c
@@ -43,8 +43,6 @@ static Property nec_xhci_properties[] = {
     DEFINE_PROP_ON_OFF_AUTO("msix", XHCIPciState, msix, ON_OFF_AUTO_AUTO),
     DEFINE_PROP_BIT("superspeed-ports-first", XHCINecState, flags,
                     XHCI_FLAG_SS_FIRST, true),
-    DEFINE_PROP_BIT("force-pcie-endcap", XHCINecState, flags,
-                    XHCI_FLAG_FORCE_PCIE_ENDCAP, false),
     DEFINE_PROP_UINT32("intrs", XHCINecState, intrs, XHCI_MAXINTRS),
     DEFINE_PROP_UINT32("slots", XHCINecState, slots, XHCI_MAXSLOTS),
     DEFINE_PROP_END_OF_LIST(),
diff --git a/hw/usb/hcd-xhci-pci.c b/hw/usb/hcd-xhci-pci.c
index 4423983308..cbad96f393 100644
--- a/hw/usb/hcd-xhci-pci.c
+++ b/hw/usb/hcd-xhci-pci.c
@@ -148,8 +148,7 @@ static void usb_xhci_pci_realize(struct PCIDevice *dev, Error **errp)
                      PCI_BASE_ADDRESS_MEM_TYPE_64,
                      &s->xhci.mem);
 
-    if (pci_bus_is_express(pci_get_bus(dev)) ||
-        xhci_get_flag(&s->xhci, XHCI_FLAG_FORCE_PCIE_ENDCAP)) {
+    if (pci_bus_is_express(pci_get_bus(dev))) {
         ret = pcie_endpoint_cap_init(dev, 0xa0);
         assert(ret > 0);
     }
-- 
2.41.0


