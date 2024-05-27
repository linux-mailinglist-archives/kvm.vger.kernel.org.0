Return-Path: <kvm+bounces-18158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 886E38CF90E
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 08:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA60C1C20B3E
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 06:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC86B17BA7;
	Mon, 27 May 2024 06:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b="G56r8TuQ"
X-Original-To: kvm@vger.kernel.org
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B2517BBF
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 06:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716791288; cv=none; b=lDkZXR5+sSwvKqbCL7d0812Bk9tXLu7U/GcuDPaypVOQX9g0ZGbY9uHDtO03fLgsCRVJImjWQHx5rnYyI8iG0gWQH7ETYUE5qV3d5H3ot/zOtuTJgstNPbVj74cE9zg7gMze9L7+mNg3+TijjgMiMM6ALYwvF8L4VnGWfDXiXNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716791288; c=relaxed/simple;
	bh=BefW+i79hFiQr0TmF/pX07bNCPSAXcucnPXkLavgfJU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V6NAk0W4Xd4crKwD5fPPt3RJlrDnIurGWzeUuLXbGWABXOEiyw1ma4qmOfNHR62vUyW+vEpfQszUSRHPeHdIN0eu8x0yVfQoOvIvzHXJ1axusEuEkwDnRPI2OZIHWG5xNVQ08Rq51HERlnqyE656Kg8RokwEAhz4Vdh71zvle2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de; spf=pass smtp.mailfrom=t-8ch.de; dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b=G56r8TuQ; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=t-8ch.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
	t=1716791283; bh=BefW+i79hFiQr0TmF/pX07bNCPSAXcucnPXkLavgfJU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=G56r8TuQBApCHkNC6OPEPjtDkgfnoCZOPb1WiIl9EO9BPU5XAwIXmcnIfpYM8qeWs
	 EmFwm6Be5pnz43cQO66z93Qw4sQUH6D42ULexGl5zhOaS998DfpMrWlAVXDQQ3wLiK
	 LhedfWQrbwOdDoklI5EvdHS4VdmAOveCBh0ol/cc=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>
Date: Mon, 27 May 2024 08:27:49 +0200
Subject: [PATCH v8 3/8] hw/misc/pvpanic: centralize definition of supported
 events
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20240527-pvpanic-shutdown-v8-3-5a28ec02558b@t-8ch.de>
References: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
In-Reply-To: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
To: "Michael S. Tsirkin" <mst@redhat.com>, 
 Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, 
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1716791282; l=3183;
 i=thomas@t-8ch.de; s=20221212; h=from:subject:message-id;
 bh=BefW+i79hFiQr0TmF/pX07bNCPSAXcucnPXkLavgfJU=;
 b=ez/WyG2JARJRjbwcJM5FgC6KkyvkMjGZpSqoX8QKrUhIvrC83TzwoCDiHEQAMTmXxSx/3mrd4
 Lt7gqxJe9vFBjlAMcMMHOTQPr88IjorhJaMKnlgGU+PUr7c+SCZaCwq
X-Developer-Key: i=thomas@t-8ch.de; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The different components of pvpanic duplicate the list of supported
events. Move it to the shared header file to minimize changes when new
events are added.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Thomas Weißschuh <thomas@t-8ch.de>
---
 hw/misc/pvpanic-isa.c     | 3 +--
 hw/misc/pvpanic-pci.c     | 3 +--
 hw/misc/pvpanic.c         | 3 +--
 include/hw/misc/pvpanic.h | 4 ++++
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/hw/misc/pvpanic-isa.c b/hw/misc/pvpanic-isa.c
index ccec50f61bbd..9a923b786907 100644
--- a/hw/misc/pvpanic-isa.c
+++ b/hw/misc/pvpanic-isa.c
@@ -21,7 +21,6 @@
 #include "hw/misc/pvpanic.h"
 #include "qom/object.h"
 #include "hw/isa/isa.h"
-#include "standard-headers/linux/pvpanic.h"
 #include "hw/acpi/acpi_aml_interface.h"
 
 OBJECT_DECLARE_SIMPLE_TYPE(PVPanicISAState, PVPANIC_ISA_DEVICE)
@@ -102,7 +101,7 @@ static void build_pvpanic_isa_aml(AcpiDevAmlIf *adev, Aml *scope)
 static Property pvpanic_isa_properties[] = {
     DEFINE_PROP_UINT16(PVPANIC_IOPORT_PROP, PVPanicISAState, ioport, 0x505),
     DEFINE_PROP_UINT8("events", PVPanicISAState, pvpanic.events,
-                      PVPANIC_PANICKED | PVPANIC_CRASH_LOADED),
+                      PVPANIC_EVENTS),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/misc/pvpanic-pci.c b/hw/misc/pvpanic-pci.c
index 83be95d0d249..603c5c7600da 100644
--- a/hw/misc/pvpanic-pci.c
+++ b/hw/misc/pvpanic-pci.c
@@ -21,7 +21,6 @@
 #include "hw/misc/pvpanic.h"
 #include "qom/object.h"
 #include "hw/pci/pci_device.h"
-#include "standard-headers/linux/pvpanic.h"
 
 OBJECT_DECLARE_SIMPLE_TYPE(PVPanicPCIState, PVPANIC_PCI_DEVICE)
 
@@ -55,7 +54,7 @@ static void pvpanic_pci_realizefn(PCIDevice *dev, Error **errp)
 
 static Property pvpanic_pci_properties[] = {
     DEFINE_PROP_UINT8("events", PVPanicPCIState, pvpanic.events,
-                      PVPANIC_PANICKED | PVPANIC_CRASH_LOADED),
+                      PVPANIC_EVENTS),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/misc/pvpanic.c b/hw/misc/pvpanic.c
index 1540e9091a45..a4982cc5928e 100644
--- a/hw/misc/pvpanic.c
+++ b/hw/misc/pvpanic.c
@@ -21,13 +21,12 @@
 #include "hw/qdev-properties.h"
 #include "hw/misc/pvpanic.h"
 #include "qom/object.h"
-#include "standard-headers/linux/pvpanic.h"
 
 static void handle_event(int event)
 {
     static bool logged;
 
-    if (event & ~(PVPANIC_PANICKED | PVPANIC_CRASH_LOADED) && !logged) {
+    if (event & ~PVPANIC_EVENTS && !logged) {
         qemu_log_mask(LOG_GUEST_ERROR, "pvpanic: unknown event %#x.\n", event);
         logged = true;
     }
diff --git a/include/hw/misc/pvpanic.h b/include/hw/misc/pvpanic.h
index fab94165d03d..947468b81b1a 100644
--- a/include/hw/misc/pvpanic.h
+++ b/include/hw/misc/pvpanic.h
@@ -18,6 +18,10 @@
 #include "exec/memory.h"
 #include "qom/object.h"
 
+#include "standard-headers/linux/pvpanic.h"
+
+#define PVPANIC_EVENTS (PVPANIC_PANICKED | PVPANIC_CRASH_LOADED)
+
 #define TYPE_PVPANIC_ISA_DEVICE "pvpanic"
 #define TYPE_PVPANIC_PCI_DEVICE "pvpanic-pci"
 

-- 
2.45.1


