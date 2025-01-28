Return-Path: <kvm+bounces-36775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9718BA20BEE
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:22:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAF05163211
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:22:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9581A841E;
	Tue, 28 Jan 2025 14:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aw79zbov"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F5FBE40
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074139; cv=none; b=TbMlo3DqzXmpo8VfihloLrY+zBm6xTO9X47HVTSJW4867MXHibW838XkreqlHS+D1Fknw/d2mNx/pH5SkYDjWvfvkbh4rnL5uCXGQUmMuCIVETcC91xjfHjwrIAoTgA/tp+fk7qLnMt6UwYTTP5bdbClo6U69qGsSJXofba5f3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074139; c=relaxed/simple;
	bh=d3QR2WmkDFD+oMZDqW8H7idPmKwNuab/wFXOjmWXtsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N9nfGcyFP31tDeasgcD/qHFlnSQ8rUNiJK5/TOJkrMLOvodIjSYZAbv3EUHvS5eItEH9si8tJTrKPjCthL3mZGT6RfC8Mic5Jf4wriv+eE5SVv/mOw2gS0Ohk21M4+bg/MfEianc3qQ4gLEy69UG//8pm+QBwa5BErJ5pI+Qlwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aw79zbov; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4363ae65100so63376585e9.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738074135; x=1738678935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+boILYhYAtgeHGjq7jZm3ySgVoHBXMK8/hh/+aqTVRc=;
        b=aw79zbovrNCRGOBa6QNfVDqLQQQKOcx04we5VVXT5fvCHuGd+nWPUs3Zj+B9AgFxGE
         HR4FzVRK28LPchbP0OVivgK049aN/OUtJdhWVoNgqMwX+APxOKbB9AYjTKHCxc40kgGd
         w+YBxVegCGWRvSdlJCfSklcvLAvEAIC7De0FToarezZm/nLHa62sAiiKLb6CiBZnPOD4
         19rJ7DampXPfj+x3RvuMPYYCenzzCIvpqpIitr0WGUhomGdB1qgOqcnVNuE1o9ckLbeZ
         DgEGgwwxQIRVozjF6/b0+jvSAI9VomG9gr7OZtFyPRWgeKQVN7jqBYTCSK6dRJzrIhN4
         bq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738074135; x=1738678935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+boILYhYAtgeHGjq7jZm3ySgVoHBXMK8/hh/+aqTVRc=;
        b=NMnfOqLwXvZc6BV/F7ln5Qsxh7PtLCzeSUDeVENnxMtJV7iACcFzeMuZXrYcRT+HZP
         mFHYy0xUE/n8ypJGb3AQwg450vYXx26SpC5IPZB6czzfO8+Nmj1V70Oxwkh3r1xCC2XB
         82ojkkmT0M4SyNo2iSnvhX+ebhKodx5N+Oy80Hwn9hl1MoKDlvYgrQx5NOeP97oYfTgx
         F0cSCRWO4QWFDJ15QMEx/Crh2DXIqI/yAOe4EwEOLVDmXGb48fMlDV6+XiLKHDk3mk/5
         YA9jTY1nTfjW5OucY1qbpPyNK5idE96rxoC8vqF/aND6Tl6G+58nj6DysaxbEyuAlQ6r
         jQRg==
X-Forwarded-Encrypted: i=1; AJvYcCWfN85mDxuvFxxOmlZyeW9SGbokLzcasRsr+CYOmR+mH2YK9+MdMhtITeP/kfaUMyg7HYI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvWOoMuge3H+VOxrAk4CmtlGd87bIZSAXDGos17nVmGdKLvHVN
	rE+V6r1FL7cG6CFtMLMjiTjbPczowK2Are3VqZ7g5PB8SJ6zL/UC/g5xOd3Lfl8Gy/JbT/thILz
	uuDM=
X-Gm-Gg: ASbGncu2cdJswj/7x7t8mf0HLlbdV1glV286qFLJXQLha3JA7Sy9buj5B79JjVGn6md
	Df8AJ/FQcmGceJRnZnwxbZVsAg1GqcaBpZSjfAFaF+ITSFbupCOEVWkT6vzXi2+L9GC+dxmNK19
	fZeb4wa8NHX4+Rgjo59sDpqSt+h7/v4AOrXvVU/CNGEjTHtB93rAzas8YPfBu3CvaodLLgSKjF4
	49pvs7lWjm1DJzobqVQwNgMuaZZgMuXNh0r9veOsfwudFCiT1f3NQ0YVP5zSxwoFCAsaC7hsKqN
	JRebmz4q0YX0DVRansWy+u3C4zUDg/8eQACS7fjbR/kmnl1GO1B3HUpmxkj9Or3D9A==
X-Google-Smtp-Source: AGHT+IGiyDf3PkdYsZe6jk+4/3mMAG2JXndCBMlzg8yxTvd0a+VKOSqbgVH5XTu3dPPXX+j4kBOFOQ==
X-Received: by 2002:a05:600c:1386:b0:434:f739:7cd9 with SMTP id 5b1f17b1804b1-438913cf349mr381680345e9.9.1738074135029;
        Tue, 28 Jan 2025 06:22:15 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd4857b8sm168810805e9.15.2025.01.28.06.22.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jan 2025 06:22:14 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [RFC PATCH 4/9] hw/qdev: Introduce DeviceClass::[un]wire() handlers
Date: Tue, 28 Jan 2025 15:21:47 +0100
Message-ID: <20250128142152.9889-5-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250128142152.9889-1-philmd@linaro.org>
References: <20250128142152.9889-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We are trying to understand what means "a qdev is realized".
One explanation was "the device is guest visible"; however
many devices are realized before being mapped, thus are not
"guest visible". Some devices map / wire their IRQs before
being realized (such ISA devices). There is a need for devices
to be "automatically" mapped/wired (see [2]) such CLI-created
devices, but this apply generically to dynamic machines.

Currently the device creation steps are expected to roughly be:

  (external use)                (QDev core)                   (Device Impl)
   ~~~~~~~~~~~~                  ~~~~~~~~~                     ~~~~~~~~~~~

                               INIT enter
                   ----->
                         +----------------------+
                         |    Allocate state    |
                         +----------------------+
                                                 ----->
                                                        +---------------------+
                                                        | INIT children       |
                                                        |                     |
                                                        | Alias children properties
                                                        |                     |
                                                        | Expose properties   |
                                INIT exit               +---------------------+
                   <-----------------------------------
 +----------------+
 | set properties |
 |                |
 | set ClkIn      |
 +----------------+          REALIZE enter
                   ---------------------------------->
                                                       +----------------------+
                                                       | Use config properties|
                                                       |                      |
                                                       | Realize children     |
                                                       |                      |
                                                       | Init GPIOs/IRQs      |
                                                       |                      |
                                                       | Init MemoryRegions   |
                                                       +----------------------+
                               REALIZE exit
                   <-----------------------------------                        ----  "realized" / "guest visible"
+-----------------+
| Explicit wiring:|
|   IRQs          |
|   I/O / Mem     |
|   ClkOut        |
+-----------------+             RESET enter
                    --------------------------------->
                                                       +----------------------+
                                                       | Reset default values |
                                                       +----------------------+

But as mentioned, various devices "wire" parts before they exit
the "realize" step.
In order to clarify, I'm trying to enforce what can be done
*before* and *after* realization.

*after* a device is expected to be stable (no more configurable)
and fully usable.

To be able to use internal/auto wiring (such ISA devices) and
keep the current external/explicit wiring, I propose to add an
extra "internal wiring" step, happening after the REALIZE step
as:

  (external use)                (QDev core)                   (Device Impl)
   ~~~~~~~~~~~~                  ~~~~~~~~~                     ~~~~~~~~~~~

                               INIT enter
                   ----->
                         +----------------------+
                         |    Allocate state    |
                         +----------------------+
                                                 ----->
                                                        +---------------------+
                                                        | INIT children       |
                                                        |                     |
                                                        | Alias children properties
                                                        |                     |
                                                        | Expose properties   |
                                INIT exit               +---------------------+
                   <-----------------------------------
 +----------------+
 | set properties |
 |                |
 | set ClkIn      |
 +----------------+          REALIZE enter
                   ---------------------------------->
                                                       +----------------------+
                                                       | Use config properties|
                                                       |                      |
                                                       | Realize children     |
                                                       |                      |
                                                       | Init GPIOs/IRQs      |
                                                       |                      |
                                                       | Init MemoryRegions   |
                                                       +----------------------+
                               REALIZE exit       <---
                         +----------------------+
                         | Internal auto wiring |
                         |   IRQs               |  (i.e. ISA bus)
                         |   I/O / Mem          |
                         |   ClkOut             |
                         +----------------------+
                    <---                                                       ----  "realized"
+-----------------+
| External wiring:|
|   IRQs          |
|   I/O / Mem     |
|   ClkOut        |
+-----------------+             RESET enter                                    ----  "guest visible"
                    --------------------------------->
                                                       +----------------------+
                                                       | Reset default values |
                                                       +----------------------+

The "realized" point is not changed. "guest visible" concept only
occurs *after* wiring, just before the reset phase.

This change introduces the DeviceClass::wire handler within qdev
core realization code.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/qdev-core.h |  7 +++++++
 hw/core/qdev.c         | 20 +++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index 530f3da7021..021bb7afdc0 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -102,7 +102,12 @@ typedef int (*DeviceSyncConfig)(DeviceState *dev, Error **errp);
  * @props: Properties accessing state fields.
  * @realize: Callback function invoked when the #DeviceState:realized
  * property is changed to %true.
+ * @wire: Callback function called after @realize to connect IRQs,
+ * clocks and map memories. Can not fail.
+ * @unwire: Callback function to undo @wire. Called before @unrealize.
+ * Can not fail.
  * @unrealize: Callback function invoked when the #DeviceState:realized
+ * property is changed to %false. Can not fail.
  * property is changed to %false.
  * @sync_config: Callback function invoked when QMP command device-sync-config
  * is called. Should synchronize device configuration from host to guest part
@@ -171,6 +176,8 @@ struct DeviceClass {
      */
     DeviceReset legacy_reset;
     DeviceRealize realize;
+    void (*wire)(DeviceState *dev);
+    void (*unwire)(DeviceState *dev);
     DeviceUnrealize unrealize;
     DeviceSyncConfig sync_config;
 
diff --git a/hw/core/qdev.c b/hw/core/qdev.c
index 82bbdcb654e..38449255365 100644
--- a/hw/core/qdev.c
+++ b/hw/core/qdev.c
@@ -554,6 +554,15 @@ static void device_set_realized(Object *obj, bool value, Error **errp)
             }
        }
 
+        if (dc->wire) {
+            if (!dc->unwire) {
+                warn_report_once("wire() without unwire() for type '%s'",
+                                 object_get_typename(OBJECT(dev)));
+            }
+            dc->wire(dev);
+        }
+
+        /* At this point the device is "guest visible". */
        qatomic_store_release(&dev->realized, value);
 
     } else if (!value && dev->realized) {
@@ -573,6 +582,15 @@ static void device_set_realized(Object *obj, bool value, Error **errp)
          */
         smp_wmb();
 
+        if (dc->unwire) {
+            if (!dc->wire) {
+                error_report("disconnect() without connect() for type '%s'",
+                             object_get_typename(OBJECT(dev)));
+                abort();
+            }
+            dc->unwire(dev);
+        }
+
         QLIST_FOREACH(bus, &dev->child_bus, sibling) {
             qbus_unrealize(bus);
         }
@@ -585,8 +603,8 @@ static void device_set_realized(Object *obj, bool value, Error **errp)
         dev->pending_deleted_event = true;
         DEVICE_LISTENER_CALL(unrealize, Reverse, dev);
     }
-
     assert(local_err == NULL);
+
     return;
 
 child_realize_fail:
-- 
2.47.1


