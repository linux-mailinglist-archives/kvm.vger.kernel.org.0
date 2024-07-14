Return-Path: <kvm+bounces-21609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F2593099E
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2024 13:11:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E005281934
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2024 11:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E6DE53389;
	Sun, 14 Jul 2024 11:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VkM4r8lS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709612B9AA
	for <kvm@vger.kernel.org>; Sun, 14 Jul 2024 11:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720955487; cv=none; b=ENrj9AiqvOzMXk2mskxPVGaYPVrJ7tRTsj9qhMX4dlC4FBarAqWk+YiFCADMrqyMvpkps23HBfYZ5e0lQxUg8E5sUppP2rEcMl8YJYfqHtxq/FC7a8DuCN5FC9UVvy94GQPfbx8P+B07r72Sfsag6+3sddv50co4CveQJ0mfKJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720955487; c=relaxed/simple;
	bh=NHsbG+3i1ilrBkLPo8A4bK9Cr7DuiY2Nq135xD3maok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Type; b=eJ+Ut4rmscANTuuuTf+EGf4uMFapymTSmyL3PqGGAZ1/fry77vwYGv80TcXUEn66362B+8Vv8HxYq63MHkJTxSZHdTXaQw4yAeZRTVQOOONcgsPezeCbIkthCWx6t3+qlvSpTjI/dmL1Y192MeSqh3ASh17uTx/hdbjwb/dyi28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VkM4r8lS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720955483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xvBboM0gBLgPXgc0OfI2YETwpo6vg79+rDTOsfSo04k=;
	b=VkM4r8lS5q/jYAcg1HrBjrpHaKrwyj3lXLTTiPPgkBUs8MEsWFKo/IUep1emO9UMGfiJrA
	4H+vIY2Ii1OvBcr2578Wlu7ar6XflmKc4JSRhezfJ1LQMST8B95njvihMdrIKSDTLwpCqq
	jfGmrZB/PSiF/IDRgGyc28w9DpFxjLc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-9GCe7zvjMaOW9k4ubaTMeg-1; Sun, 14 Jul 2024 07:11:21 -0400
X-MC-Unique: 9GCe7zvjMaOW9k4ubaTMeg-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-52ea965188eso4726154e87.1
        for <kvm@vger.kernel.org>; Sun, 14 Jul 2024 04:11:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720955479; x=1721560279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvBboM0gBLgPXgc0OfI2YETwpo6vg79+rDTOsfSo04k=;
        b=E1pxhNvaa4nINLCXAxYzGk2lrImQw1MRbFAlfb6frtyNYaxm/zV9HyaofxynAB3xwz
         YPzlNahV+D+Pi1HD30q9ok6hA7R+pv8A6swPqZ5vkWuQj6mxv/R4yEOvyKO/DHJFLkhC
         Ol2sFaxlZpnabJ94Rv9UkTNpsOgS9QEkV2ybWW0WXr61L3jflY3rJ5uVwrnAK+O6wN42
         MghxXnuLt4mwVhlxXktpKCS24r3fPhwK3unTEMmN04nuwoHvLjrhB2gs6q9yN7Z2kjLi
         re/yiVLZO6goSTzC2cmqrXEXIajZxTCk5w20IHeCoIVr7eFQgMv7rUMArtMYmLAHqq0c
         49lw==
X-Forwarded-Encrypted: i=1; AJvYcCW6QXIxLrVQEftpWyZESoBM9IB3oRmgKBjxSVrZUwOdavirmd8Nisj8agkKFTgqxylFtt3YkfbOQG54YmQ1FfQ4L++5
X-Gm-Message-State: AOJu0YxbztHnjmC4FSOyfm50XTAyshunJ1Q0fEw6lMxh0fuvHVXXU6aK
	d8/9JT6CTdeGvEP1Jgi1h7uSavaZDmZ4xh1dtnLdcrYE7D6Ez7PgycYABuW+4Fq4kbncxbb7QzJ
	CSDdbJ8SsMUqG2lfeLJbAKnKLZUzuOgo2IhSsaBBEVZ+THJae8w==
X-Received: by 2002:a05:6512:ad2:b0:52e:bdfc:1d05 with SMTP id 2adb3069b0e04-52ebdfc1ffcmr10321434e87.44.1720955479643;
        Sun, 14 Jul 2024 04:11:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/0YOQVR0yqj4226D+TkFKAQsMIz1Xsv7xLq/slMcsDTBh/wvGCUrcxMJjoWM5RzGPbNJLsQ==
X-Received: by 2002:a05:6512:ad2:b0:52e:bdfc:1d05 with SMTP id 2adb3069b0e04-52ebdfc1ffcmr10321421e87.44.1720955479295;
        Sun, 14 Jul 2024 04:11:19 -0700 (PDT)
Received: from avogadro.local ([151.95.101.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427a5edb41asm47985225e9.36.2024.07.14.04.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 04:11:18 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: qemu-devel@nongnu.org
Cc: Michael Roth <michael.roth@amd.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	kvm@vger.kernel.org
Subject: [PULL 12/13] i386/sev: Don't allow automatic fallback to legacy KVM_SEV*_INIT
Date: Sun, 14 Jul 2024 13:10:42 +0200
Message-ID: <20240714111043.14132-13-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240714111043.14132-1-pbonzini@redhat.com>
References: <20240714111043.14132-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Roth <michael.roth@amd.com>

Currently if the 'legacy-vm-type' property of the sev-guest object is
'on', QEMU will attempt to use the newer KVM_SEV_INIT2 kernel
interface in conjunction with the newer KVM_X86_SEV_VM and
KVM_X86_SEV_ES_VM KVM VM types.

This can lead to measurement changes if, for instance, an SEV guest was
created on a host that originally had an older kernel that didn't
support KVM_SEV_INIT2, but is booted on the same host later on after the
host kernel was upgraded.

Instead, if legacy-vm-type is 'off', QEMU should fail if the
KVM_SEV_INIT2 interface is not provided by the current host kernel.
Modify the fallback handling accordingly.

In the future, VMSA features and other flags might be added to QEMU
which will require legacy-vm-type to be 'off' because they will rely
on the newer KVM_SEV_INIT2 interface. It may be difficult to convey to
users what values of legacy-vm-type are compatible with which
features/options, so as part of this rework, switch legacy-vm-type to a
tri-state OnOffAuto option. 'auto' in this case will automatically
switch to using the newer KVM_SEV_INIT2, but only if it is required to
make use of new VMSA features or other options only available via
KVM_SEV_INIT2.

Defining 'auto' in this way would avoid inadvertantly breaking
compatibility with older kernels since it would only be used in cases
where users opt into newer features that are only available via
KVM_SEV_INIT2 and newer kernels, and provide better default behavior
than the legacy-vm-type=off behavior that was previously in place, so
make it the default for 9.1+ machine types.

Cc: Daniel P. Berrangé <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
cc: kvm@vger.kernel.org
Signed-off-by: Michael Roth <michael.roth@amd.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Link: https://lore.kernel.org/r/20240710041005.83720-1-michael.roth@amd.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 qapi/qom.json     | 18 ++++++----
 hw/i386/pc.c      |  2 +-
 target/i386/sev.c | 87 +++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 84 insertions(+), 23 deletions(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index 8e75a419c30..7eccd2e14e2 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -924,12 +924,16 @@
 # @handle: SEV firmware handle (default: 0)
 #
 # @legacy-vm-type: Use legacy KVM_SEV_INIT KVM interface for creating the VM.
-#                  The newer KVM_SEV_INIT2 interface syncs additional vCPU
-#                  state when initializing the VMSA structures, which will
-#                  result in a different guest measurement. Set this to
-#                  maintain compatibility with older QEMU or kernel versions
-#                  that rely on legacy KVM_SEV_INIT behavior.
-#                  (default: false) (since 9.1)
+#                  The newer KVM_SEV_INIT2 interface, from Linux >= 6.10, syncs
+#                  additional vCPU state when initializing the VMSA structures,
+#                  which will result in a different guest measurement. Set
+#                  this to 'on' to force compatibility with older QEMU or kernel
+#                  versions that rely on legacy KVM_SEV_INIT behavior. 'auto'
+#                  will behave identically to 'on', but will automatically
+#                  switch to using KVM_SEV_INIT2 if the user specifies any
+#                  additional options that require it. If set to 'off', QEMU
+#                  will require KVM_SEV_INIT2 unconditionally.
+#                  (default: off) (since 9.1)
 #
 # Since: 2.12
 ##
@@ -939,7 +943,7 @@
             '*session-file': 'str',
             '*policy': 'uint32',
             '*handle': 'uint32',
-            '*legacy-vm-type': 'bool' } }
+            '*legacy-vm-type': 'OnOffAuto' } }
 
 ##
 # @SevSnpGuestProperties:
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 4fbc5774708..c74931d577a 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -83,7 +83,7 @@ GlobalProperty pc_compat_9_0[] = {
     { TYPE_X86_CPU, "x-amd-topoext-features-only", "false" },
     { TYPE_X86_CPU, "x-l1-cache-per-thread", "false" },
     { TYPE_X86_CPU, "guest-phys-bits", "0" },
-    { "sev-guest", "legacy-vm-type", "true" },
+    { "sev-guest", "legacy-vm-type", "on" },
     { TYPE_X86_CPU, "legacy-multi-node", "on" },
 };
 const size_t pc_compat_9_0_len = G_N_ELEMENTS(pc_compat_9_0);
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 2ba5f517228..a1157c0ede6 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -144,7 +144,7 @@ struct SevGuestState {
     uint32_t policy;
     char *dh_cert_file;
     char *session_file;
-    bool legacy_vm_type;
+    OnOffAuto legacy_vm_type;
 };
 
 struct SevSnpGuestState {
@@ -1369,6 +1369,17 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
     }
 }
 
+/*
+ * This helper is to examine sev-guest properties and determine if any options
+ * have been set which rely on the newer KVM_SEV_INIT2 interface and associated
+ * KVM VM types.
+ */
+static bool sev_init2_required(SevGuestState *sev_guest)
+{
+    /* Currently no KVM_SEV_INIT2-specific options are exposed via QEMU */
+    return false;
+}
+
 static int sev_kvm_type(X86ConfidentialGuest *cg)
 {
     SevCommonState *sev_common = SEV_COMMON(cg);
@@ -1379,14 +1390,39 @@ static int sev_kvm_type(X86ConfidentialGuest *cg)
         goto out;
     }
 
-    kvm_type = (sev_guest->policy & SEV_POLICY_ES) ?
-                KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM;
-    if (kvm_is_vm_type_supported(kvm_type) && !sev_guest->legacy_vm_type) {
-        sev_common->kvm_type = kvm_type;
-    } else {
+    /* These are the only cases where legacy VM types can be used. */
+    if (sev_guest->legacy_vm_type == ON_OFF_AUTO_ON ||
+        (sev_guest->legacy_vm_type == ON_OFF_AUTO_AUTO &&
+         !sev_init2_required(sev_guest))) {
         sev_common->kvm_type = KVM_X86_DEFAULT_VM;
+        goto out;
     }
 
+    /*
+     * Newer VM types are required, either explicitly via legacy-vm-type=on, or
+     * implicitly via legacy-vm-type=auto along with additional sev-guest
+     * properties that require the newer VM types.
+     */
+    kvm_type = (sev_guest->policy & SEV_POLICY_ES) ?
+                KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM;
+    if (!kvm_is_vm_type_supported(kvm_type)) {
+        if (sev_guest->legacy_vm_type == ON_OFF_AUTO_AUTO) {
+            error_report("SEV: host kernel does not support requested %s VM type, which is required "
+                         "for the set of options specified. To allow use of the legacy "
+                         "KVM_X86_DEFAULT_VM VM type, please disable any options that are not "
+                         "compatible with the legacy VM type, or upgrade your kernel.",
+                         kvm_type == KVM_X86_SEV_VM ? "KVM_X86_SEV_VM" : "KVM_X86_SEV_ES_VM");
+        } else {
+            error_report("SEV: host kernel does not support requested %s VM type. To allow use of "
+                         "the legacy KVM_X86_DEFAULT_VM VM type, the 'legacy-vm-type' argument "
+                         "must be set to 'on' or 'auto' for the sev-guest object.",
+                         kvm_type == KVM_X86_SEV_VM ? "KVM_X86_SEV_VM" : "KVM_X86_SEV_ES_VM");
+        }
+
+        return -1;
+    }
+
+    sev_common->kvm_type = kvm_type;
 out:
     return sev_common->kvm_type;
 }
@@ -1477,14 +1513,24 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     }
 
     trace_kvm_sev_init();
-    if (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) == KVM_X86_DEFAULT_VM) {
+    switch (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common))) {
+    case KVM_X86_DEFAULT_VM:
         cmd = sev_es_enabled() ? KVM_SEV_ES_INIT : KVM_SEV_INIT;
 
         ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
-    } else {
+        break;
+    case KVM_X86_SEV_VM:
+    case KVM_X86_SEV_ES_VM:
+    case KVM_X86_SNP_VM: {
         struct kvm_sev_init args = { 0 };
 
         ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
+        break;
+    }
+    default:
+        error_setg(errp, "%s: host kernel does not support the requested SEV configuration.",
+                   __func__);
+        return -1;
     }
 
     if (ret) {
@@ -2074,14 +2120,23 @@ sev_guest_set_session_file(Object *obj, const char *value, Error **errp)
     SEV_GUEST(obj)->session_file = g_strdup(value);
 }
 
-static bool sev_guest_get_legacy_vm_type(Object *obj, Error **errp)
+static void sev_guest_get_legacy_vm_type(Object *obj, Visitor *v,
+                                         const char *name, void *opaque,
+                                         Error **errp)
 {
-    return SEV_GUEST(obj)->legacy_vm_type;
+    SevGuestState *sev_guest = SEV_GUEST(obj);
+    OnOffAuto legacy_vm_type = sev_guest->legacy_vm_type;
+
+    visit_type_OnOffAuto(v, name, &legacy_vm_type, errp);
 }
 
-static void sev_guest_set_legacy_vm_type(Object *obj, bool value, Error **errp)
+static void sev_guest_set_legacy_vm_type(Object *obj, Visitor *v,
+                                         const char *name, void *opaque,
+                                         Error **errp)
 {
-    SEV_GUEST(obj)->legacy_vm_type = value;
+    SevGuestState *sev_guest = SEV_GUEST(obj);
+
+    visit_type_OnOffAuto(v, name, &sev_guest->legacy_vm_type, errp);
 }
 
 static void
@@ -2107,9 +2162,9 @@ sev_guest_class_init(ObjectClass *oc, void *data)
                                   sev_guest_set_session_file);
     object_class_property_set_description(oc, "session-file",
             "guest owners session parameters (encoded with base64)");
-    object_class_property_add_bool(oc, "legacy-vm-type",
-                                   sev_guest_get_legacy_vm_type,
-                                   sev_guest_set_legacy_vm_type);
+    object_class_property_add(oc, "legacy-vm-type", "OnOffAuto",
+                              sev_guest_get_legacy_vm_type,
+                              sev_guest_set_legacy_vm_type, NULL, NULL);
     object_class_property_set_description(oc, "legacy-vm-type",
             "use legacy VM type to maintain measurement compatibility with older QEMU or kernel versions.");
 }
@@ -2125,6 +2180,8 @@ sev_guest_instance_init(Object *obj)
     object_property_add_uint32_ptr(obj, "policy", &sev_guest->policy,
                                    OBJ_PROP_FLAG_READWRITE);
     object_apply_compat_props(obj);
+
+    sev_guest->legacy_vm_type = ON_OFF_AUTO_AUTO;
 }
 
 /* guest info specific sev/sev-es */
-- 
2.45.2


