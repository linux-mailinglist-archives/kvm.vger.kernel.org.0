Return-Path: <kvm+bounces-18161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D218CF912
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 08:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA6C11C20C1C
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 06:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 870E625774;
	Mon, 27 May 2024 06:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b="GG6Gk6EL"
X-Original-To: kvm@vger.kernel.org
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C841F93E
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 06:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716791291; cv=none; b=MJGwTlNL+lVLk7BtARVmqQAyR8AOk9axpNiwtIr8+f+Qc8eL4dDL0EBi6sbHNYu0bEaHzSabcSIw5i2OJiQCZPov1K/9hUkDrndVQ0TcxvVmM/0oeq4cGdnJTRgu8+DZzxGiWOj8gCQStU2PFN2FRIHVMgqYg8uTmySLLewjCUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716791291; c=relaxed/simple;
	bh=s5VaI29lwZj1ic4YhfNoQySSm+8g+nzVFlmlxZMx79I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RjR6kkytFU/8YZQi2QLE1pfJVfW4mTRL6yBtyh5KmTfKcu4DQXYZuidsl9peB7M75X7DjiidnMiaRD9OpmDjoC6lYFL9WvtAQzdau3tYkvcHvdBKiAjjugBZj4p3CiNYaElrvVtp18Q5y4aIbj4e/RZaqPUGLlxM43cC2ZSVAc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de; spf=pass smtp.mailfrom=t-8ch.de; dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b=GG6Gk6EL; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=t-8ch.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
	t=1716791283; bh=s5VaI29lwZj1ic4YhfNoQySSm+8g+nzVFlmlxZMx79I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GG6Gk6EL54vJcshYSoUXOFF/d9332hutWk2dWDyLmitmoPBEH0hybxmTzWmpz/q+T
	 2AbVTA0dUsmhPss994RjENrEGbmDBgDoO5boV4dz6rqoKCokyjdRGal+XRbNFms9Mq
	 3yIbFVZbu13hINuXL577NvQ9l2FFj+uC6u2b0TaU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>
Date: Mon, 27 May 2024 08:27:51 +0200
Subject: [PATCH v8 5/8] hw/misc/pvpanic: add support for normal shutdowns
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20240527-pvpanic-shutdown-v8-5-5a28ec02558b@t-8ch.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1716791282; l=2474;
 i=thomas@t-8ch.de; s=20221212; h=from:subject:message-id;
 bh=s5VaI29lwZj1ic4YhfNoQySSm+8g+nzVFlmlxZMx79I=;
 b=eFGqUTzQJobqUIXaRVRjnXdRt672/izm7hsoRvVKqM2uiQXXKoPkEA8RyjnGlWkZMwN6un8u+
 kNpbRtoMzmFB7kPmcu99bp2Cmr4kbzWQ4v1miX/rt4vIzv+l4snBlJk
X-Developer-Key: i=thomas@t-8ch.de; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

Shutdown requests are normally hardware dependent.
By extending pvpanic to also handle shutdown requests, guests can
submit such requests with an easily implementable and cross-platform
mechanism.

Acked-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Thomas Weißschuh <thomas@t-8ch.de>
---
 hw/misc/pvpanic.c         | 5 +++++
 include/hw/misc/pvpanic.h | 2 +-
 include/sysemu/runstate.h | 1 +
 system/runstate.c         | 5 +++++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/hw/misc/pvpanic.c b/hw/misc/pvpanic.c
index a4982cc5928e..0e9505451a7a 100644
--- a/hw/misc/pvpanic.c
+++ b/hw/misc/pvpanic.c
@@ -40,6 +40,11 @@ static void handle_event(int event)
         qemu_system_guest_crashloaded(NULL);
         return;
     }
+
+    if (event & PVPANIC_SHUTDOWN) {
+        qemu_system_guest_pvshutdown();
+        return;
+    }
 }
 
 /* return supported events on read */
diff --git a/include/hw/misc/pvpanic.h b/include/hw/misc/pvpanic.h
index 947468b81b1a..fbbf2bbf5dbb 100644
--- a/include/hw/misc/pvpanic.h
+++ b/include/hw/misc/pvpanic.h
@@ -20,7 +20,7 @@
 
 #include "standard-headers/linux/pvpanic.h"
 
-#define PVPANIC_EVENTS (PVPANIC_PANICKED | PVPANIC_CRASH_LOADED)
+#define PVPANIC_EVENTS (PVPANIC_PANICKED | PVPANIC_CRASH_LOADED | PVPANIC_SHUTDOWN)
 
 #define TYPE_PVPANIC_ISA_DEVICE "pvpanic"
 #define TYPE_PVPANIC_PCI_DEVICE "pvpanic-pci"
diff --git a/include/sysemu/runstate.h b/include/sysemu/runstate.h
index 0117d243c4ed..e210a37abf0f 100644
--- a/include/sysemu/runstate.h
+++ b/include/sysemu/runstate.h
@@ -104,6 +104,7 @@ void qemu_system_killed(int signal, pid_t pid);
 void qemu_system_reset(ShutdownCause reason);
 void qemu_system_guest_panicked(GuestPanicInformation *info);
 void qemu_system_guest_crashloaded(GuestPanicInformation *info);
+void qemu_system_guest_pvshutdown(void);
 bool qemu_system_dump_in_progress(void);
 
 #endif
diff --git a/system/runstate.c b/system/runstate.c
index cb4905a40fce..83055f327831 100644
--- a/system/runstate.c
+++ b/system/runstate.c
@@ -585,6 +585,11 @@ void qemu_system_guest_crashloaded(GuestPanicInformation *info)
     qapi_free_GuestPanicInformation(info);
 }
 
+void qemu_system_guest_pvshutdown(void)
+{
+    qemu_system_shutdown_request(SHUTDOWN_CAUSE_GUEST_SHUTDOWN);
+}
+
 void qemu_system_reset_request(ShutdownCause reason)
 {
     if (reboot_action == REBOOT_ACTION_SHUTDOWN &&

-- 
2.45.1


