Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AA07D1D46
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 15:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjJUNkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Oct 2023 09:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjJUNkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Oct 2023 09:40:32 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D43E7
        for <kvm@vger.kernel.org>; Sat, 21 Oct 2023 06:40:29 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-40859c46447so2869505e9.1
        for <kvm@vger.kernel.org>; Sat, 21 Oct 2023 06:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697895628; x=1698500428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=At1jsVLlupIiRvoiq5by/aHnfQWBZjYV5W5vgE3NJa4=;
        b=HZcUSNORVdothOXHfmQ0Wy9zEUWu8ULYajyrlD8QSihElUSVoXamsyp6DKfuQvij10
         MNo9CfJDZNycgIPOEinLI0HDHpxg0cWifRcRNRKFnKwg1QUSpkLVVb56fIG9qmUJTgXU
         7MXewzJYEOYF1/RuAtzOaBqzksVpi5vKvU6KtZxJbY9qgyQUeQFeukYLt7WSi+bAQHTA
         w0rYGMfTDE/YxF9actqc1jg/Ndi78txGpwF3zsv60urTCVyqyRd/KCs4Bvo4KWCUhiY6
         looQb9B0JYxretZyKyJLSX1UrDxfxHx83LJzRFtxqBJJmZrYhK/3Pof+V+OySf1JeOGh
         3osA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697895628; x=1698500428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=At1jsVLlupIiRvoiq5by/aHnfQWBZjYV5W5vgE3NJa4=;
        b=cmUg1n8P3EG10sUeb2wf2JsUac3xwozXyF1ORjXVtZOLRPu/1Y4B2thzzRr7cXM/Iv
         BAhOmQj3LrxM8mSXJdUJI1ipBYN+sLBOmLMrJRiB8Gwj5UfEdxdky5PlGsCNc5Ttfsbx
         NjmmdpfW9s71TLAXIt3LU8yXO/rRLgnofJhJPWu6zyywK+X8BNw1Ap+eh8QajADY8Muz
         afmkYBayI2DO7SKQj5i64DOEV3aWukFd09nAtr7dhUPZ1ooddyHSPoyYBgjiPPJIx516
         Y7NT7h7CtgbsQazs4sNg4nM0JBcn31OLAkp5TqaZ+dhrZHnCoysqQ9fYpwmnesc83hAZ
         UNzQ==
X-Gm-Message-State: AOJu0YySMO7/KKWR2GMpEZSsbpi5LOzn7OoJdbibLsxNiAEgkAyCV5bm
        5/M94QJm8qsj00HylGy/Km8=
X-Google-Smtp-Source: AGHT+IEnZ/0NJLa2Gx/dyL23Jh+pUGPX2QqVxWhvvc8m5QJWNV2Sl/aI/LuNDM2hajRdioanaI2evA==
X-Received: by 2002:a05:600c:4f45:b0:407:7e7a:6017 with SMTP id m5-20020a05600c4f4500b004077e7a6017mr3625970wmq.11.1697895627615;
        Sat, 21 Oct 2023 06:40:27 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:864b:8201:e534:34f4:1c34:8de7])
        by smtp.googlemail.com with ESMTPSA id e7-20020a05600c218700b00407efbc4361sm9302948wme.9.2023.10.21.06.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Oct 2023 06:40:26 -0700 (PDT)
From:   Daan De Meyer <daan.j.demeyer@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: [PATCH] Add class property to configure KVM device node to use
Date:   Sat, 21 Oct 2023 15:40:15 +0200
Message-ID: <20231021134015.1119597-1-daan.j.demeyer@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows passing the KVM device node to use as a file
descriptor via /dev/fdset/XX. Passing the device node to
use as a file descriptor allows running qemu unprivileged
even when the user running qemu is not in the kvm group
on distributions where access to /dev/kvm is gated behind
membership of the kvm group (as long as the process invoking
qemu is able to open /dev/kvm and passes the file descriptor
to qemu).

Signed-off-by: Daan De Meyer <daan.j.demeyer@gmail.com>
---
 accel/kvm/kvm-all.c      | 25 ++++++++++++++++++++++++-
 include/sysemu/kvm_int.h |  1 +
 qemu-options.hx          |  8 +++++++-
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 72e1d1141c..3e0b2d00e9 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2478,7 +2478,7 @@ static int kvm_init(MachineState *ms)
     QTAILQ_INIT(&s->kvm_sw_breakpoints);
 #endif
     QLIST_INIT(&s->kvm_parked_vcpus);
-    s->fd = qemu_open_old("/dev/kvm", O_RDWR);
+    s->fd = qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
     if (s->fd == -1) {
         fprintf(stderr, "Could not access KVM kernel module: %m\n");
         ret = -errno;
@@ -3775,6 +3775,24 @@ static void kvm_set_dirty_ring_size(Object *obj, Visitor *v,
     s->kvm_dirty_ring_size = value;
 }
 
+static char *kvm_get_device(Object *obj,
+                            Error **errp G_GNUC_UNUSED)
+{
+    KVMState *s = KVM_STATE(obj);
+
+    return g_strdup(s->device);
+}
+
+static void kvm_set_device(Object *obj,
+                           const char *value,
+                           Error **errp G_GNUC_UNUSED)
+{
+    KVMState *s = KVM_STATE(obj);
+
+    g_free(s->device);
+    s->device = g_strdup(value);
+}
+
 static void kvm_accel_instance_init(Object *obj)
 {
     KVMState *s = KVM_STATE(obj);
@@ -3793,6 +3811,7 @@ static void kvm_accel_instance_init(Object *obj)
     s->xen_version = 0;
     s->xen_gnttab_max_frames = 64;
     s->xen_evtchn_max_pirq = 256;
+    s->device = NULL;
 }
 
 /**
@@ -3833,6 +3852,10 @@ static void kvm_accel_class_init(ObjectClass *oc, void *data)
     object_class_property_set_description(oc, "dirty-ring-size",
         "Size of KVM dirty page ring buffer (default: 0, i.e. use bitmap)");
 
+    object_class_property_add_str(oc, "device", kvm_get_device, kvm_set_device);
+    object_class_property_set_description(oc, "device",
+        "Path to the device node to use (default: /dev/kvm)");
+
     kvm_arch_accel_class_init(oc);
 }
 
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index a5b9122cb8..19a5364a4b 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -124,6 +124,7 @@ struct KVMState
     uint32_t xen_caps;
     uint16_t xen_gnttab_max_frames;
     uint16_t xen_evtchn_max_pirq;
+    char *device;
 };
 
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
diff --git a/qemu-options.hx b/qemu-options.hx
index 54a7e94970..40ad15a9da 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -188,7 +188,8 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
     "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
-    "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
+    "                thread=single|multi (enable multi-threaded TCG)\n"
+    "                device=path (KVM device path, default /dev/kvm)\n", QEMU_ARCH_ALL)
 SRST
 ``-accel name[,prop=value[,...]]``
     This is used to enable an accelerator. Depending on the target
@@ -269,6 +270,11 @@ SRST
         open up for a specified of time (i.e. notify-window).
         Default: notify-vmexit=run,notify-window=0.
 
+    ``device=path``
+        Sets the path to the KVM device node. Defaults to ``/dev/kvm``. This
+        option can be used to pass the KVM device to use via a file descriptor
+        by setting the value to ``/dev/fdset/NN``.
+
 ERST
 
 DEF("smp", HAS_ARG, QEMU_OPTION_smp,
-- 
2.41.0

