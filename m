Return-Path: <kvm+bounces-21765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8447933628
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 07:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E63928351A
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 174CDBA45;
	Wed, 17 Jul 2024 05:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LI0wWaE2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CE81173F
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 05:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721192622; cv=none; b=PLazmMtFdWCSwxH9+xMpHDZ2TYfxWN7BHZp95YdQBY51gyR0yI3UwCnpOzFjWRvmFpscAuPNMe1Gej8rFHVMsA/v/k/IexegSpFViDxHqdfb5DUUFq0iGSy4eMmZSa93UIni0/ZzP4G8YCMuem9w419mjZ2YpJDWBssVaAEcBB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721192622; c=relaxed/simple;
	bh=NHsbG+3i1ilrBkLPo8A4bK9Cr7DuiY2Nq135xD3maok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Type; b=h1W+pGV7YySmR+adQlEfCvI9IqUefMsT0ebLRpQWQNIxIDUabON37Bu5e5NWppxHDAVcibIwrbocg73iLXptWqTgtbFSYfWLlqZESe4wxtryHbXpP2f+qKh3Rh0SmRvZDHps973hYLU+DBD9/pPQIUvUSf+qHh9JILNyFv7PYkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LI0wWaE2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721192619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xvBboM0gBLgPXgc0OfI2YETwpo6vg79+rDTOsfSo04k=;
	b=LI0wWaE2fopgIG7sZGLoBmSBIXjmfpLMT0oYcSIfbFyWTlTL/LSOXPgqBEj4b6H9Vz2gh+
	JnwKYhS8kTUC+eP+46fAdFPkIgxmJGPrjLrqtoIbPQ3h+8IBpnQkvQHpJDckGEyvZ5kVZl
	Lpdh9TcbM9ArbqLP95v3HTyFyEeCeRc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-mDKldqnmMo6ACtDoetQU_A-1; Wed, 17 Jul 2024 01:03:37 -0400
X-MC-Unique: mDKldqnmMo6ACtDoetQU_A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42794cb8251so41224445e9.2
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 22:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721192616; x=1721797416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvBboM0gBLgPXgc0OfI2YETwpo6vg79+rDTOsfSo04k=;
        b=R/1AaFMCs/HiU7g56+nhO0rXezQlXfSEW7wb4zZ77ctpVSNisVK16rD9dG30vYxGTt
         NhvqmtPT/sBEuHNDfXKGCp2/azLH3EVSSah6pZKkRVT//58TSe9dRAThcE0pTD/fa5LE
         sOfZf54aT+rc0KQyN+/uMJcKtB8+vFJ5z9qFdzbLwt3xc5/1jbDC1Gw0qXLHIHmMio7p
         IiddSnnKWf3EgTm5VPJGomlArpQDmJe2amh2owAHiinYt2CU8dW7rBtJgEvcRSX9wTwu
         I3c5rHT4iRt+1jc1FHaeNPHehGMEsX4PaJOsPC4RJCwne83D7C2m/cF9d3520wulRs1L
         nQ5A==
X-Forwarded-Encrypted: i=1; AJvYcCUcvN2+V7j20Q83edTfClZxOxirE6L3QdJx5KEZPcahsJ/sWYHqxFyQOMzIKEJhl+3LDZwGTtqCNY0r8XASk6wVJOd3
X-Gm-Message-State: AOJu0YzxeeepWT7BvKIzbpCcXXvGEa/c/F914EP69+eVnGi05pHopEQ7
	KwuCUmdYolZmKJhgyXe2LvCp92UH0UidTmNW9XGhvAN/Zkq/LTx6pCqi7u1oXn5nNbaFa2ZQwa8
	KA11XX0Pmr9cG2u2sBMl/CtUw9Bur+Cd5faCPC8B9kmY7mW94ig==
X-Received: by 2002:a05:600c:4690:b0:426:6696:9e50 with SMTP id 5b1f17b1804b1-427c2cb0869mr2671665e9.14.1721192615791;
        Tue, 16 Jul 2024 22:03:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0dJd1zzIHD6YIbXa+f5V3qfglRo8jsbLkdiBokdBFJ2faTewrH4mT6rdxGu48prFtIHsKVw==
X-Received: by 2002:a05:600c:4690:b0:426:6696:9e50 with SMTP id 5b1f17b1804b1-427c2cb0869mr2671585e9.14.1721192615513;
        Tue, 16 Jul 2024 22:03:35 -0700 (PDT)
Received: from avogadro.local ([151.95.101.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427a5e77488sm158244645e9.9.2024.07.16.22.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 22:03:34 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: qemu-devel@nongnu.org
Cc: Michael Roth <michael.roth@amd.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	kvm@vger.kernel.org
Subject: [PULL 01/20] i386/sev: Don't allow automatic fallback to legacy KVM_SEV*_INIT
Date: Wed, 17 Jul 2024 07:03:11 +0200
Message-ID: <20240717050331.295371-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240717050331.295371-1-pbonzini@redhat.com>
References: <20240717050331.295371-1-pbonzini@redhat.com>
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


