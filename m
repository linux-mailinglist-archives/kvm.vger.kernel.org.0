Return-Path: <kvm+bounces-67170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E16A6CFA9E0
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 20:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 22946329F22C
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 18:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E504D34D92E;
	Tue,  6 Jan 2026 18:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RFaq8HgR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410E034D4C8
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 18:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767724593; cv=none; b=l7PCYjugY1o0AfJ8Fn+GZ6c1A18GCGmcX3HDb4zANlvulXwjIIUqhU4tlcj5qjdE0vxI9NhPTSshEP2kIFRefO0/sU+5dibBEQxf1ED0Cl4q4C8MdTcyayJbIumRL6lHFjSdYQ9lNnC6pwoJcGlnwmAQv072zncgCopy47Uo+T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767724593; c=relaxed/simple;
	bh=iaNvxP9YjN/F6/rPSs9s2EjK3Mstpq44G5RBSPZMziU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r/0oc/i/2QMZVCq/H30mOkU7byC/lS4XA83qvW+MyRPxQih4O673nMR2QZSVSlePdTJxYCM6Sw2otjgl+vgjg4MgGK/g5xfYOdSSl6ZIcP8n6ggATHdb+Arl7WVKKHcIdWC7owv47f8/iKcDFxX3/sakt5qfDCCpvDAXtMQKV7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RFaq8HgR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767724590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cs0d/Whb67p4rhqOVd8pNKSJF4qon8ztCFF10BlCZRI=;
	b=RFaq8HgRXRMOVydv38S2il1N5iagkwZkqviTCvoHgbTbgh4TDn33gYLiOJpKaHkPCXmRDv
	T+BPRmhZzYSYgl/YnpNgLYYMkZQPCKIiVJqEAoEmijICL9b9/K7bVP9cdlXocoMGBqqQy/
	UV9zpRguMmoT1G151MU1HXd00suJSY4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-5nMqeKUNO7yu3Gh36mD6JQ-1; Tue,
 06 Jan 2026 13:36:27 -0500
X-MC-Unique: 5nMqeKUNO7yu3Gh36mD6JQ-1
X-Mimecast-MFC-AGG-ID: 5nMqeKUNO7yu3Gh36mD6JQ_1767724586
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20A24195609D;
	Tue,  6 Jan 2026 18:36:26 +0000 (UTC)
Received: from localhost (unknown [10.45.242.7])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CCEAA30001B9;
	Tue,  6 Jan 2026 18:36:24 +0000 (UTC)
From: marcandre.lureau@redhat.com
To: qemu-devel@nongnu.org
Cc: berrange@redhat.com,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org (open list:X86 KVM CPUs)
Subject: [PATCH] Add query-tdx-capabilities
Date: Tue,  6 Jan 2026 22:36:20 +0400
Message-ID: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Return an empty TdxCapability struct, for extensibility and matching
query-sev-capabilities return type.

Fixes: https://issues.redhat.com/browse/RHEL-129674
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 qapi/misc-i386.json        | 30 ++++++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h |  1 +
 target/i386/kvm/kvm.c      |  5 +++++
 target/i386/kvm/tdx-stub.c |  8 ++++++++
 target/i386/kvm/tdx.c      | 21 +++++++++++++++++++++
 5 files changed, 65 insertions(+)

diff --git a/qapi/misc-i386.json b/qapi/misc-i386.json
index 05a94d6c416..f10e4338b48 100644
--- a/qapi/misc-i386.json
+++ b/qapi/misc-i386.json
@@ -225,6 +225,36 @@
 ##
 { 'command': 'query-sev-capabilities', 'returns': 'SevCapability' }
 
+##
+# @TdxCapability:
+#
+# The struct describes capability for Intel Trust Domain Extensions
+# (TDX) feature.
+#
+# Since: 11.0
+##
+{ 'struct': 'TdxCapability',
+  'data': { } }
+
+##
+# @query-tdx-capabilities:
+#
+# Get TDX capabilities.
+#
+# This is only supported on Intel X86 platforms with KVM enabled.
+#
+# Errors:
+#     - If TDX is not available on the platform, GenericError
+#
+# Since: 11.0
+#
+# .. qmp-example::
+#
+#     -> { "execute": "query-tdx-capabilities" }
+#     <- { "return": {} }
+##
+{ 'command': 'query-tdx-capabilities', 'returns': 'TdxCapability' }
+
 ##
 # @sev-inject-launch-secret:
 #
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 2b653442f4d..71dd45be47a 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -61,6 +61,7 @@ void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
 
 bool kvm_has_x2apic_api(void);
 bool kvm_has_waitpkg(void);
+bool kvm_has_tdx(void);
 
 uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
 void kvm_update_msi_routes_all(void *private, bool global,
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7b9b740a8e5..8ce25d7e785 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6582,6 +6582,11 @@ bool kvm_has_waitpkg(void)
     return has_msr_umwait;
 }
 
+bool kvm_has_tdx(void)
+{
+    return kvm_is_vm_type_supported(KVM_X86_TDX_VM);
+}
+
 #define ARCH_REQ_XCOMP_GUEST_PERM       0x1025
 
 void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index 1f0e108a69e..c4e7f2c58c8 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -1,6 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 
 #include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qapi/qapi-commands-misc-i386.h"
 
 #include "tdx.h"
 
@@ -30,3 +32,9 @@ void tdx_handle_get_tdvmcall_info(X86CPU *cpu, struct kvm_run *run)
 void tdx_handle_setup_event_notify_interrupt(X86CPU *cpu, struct kvm_run *run)
 {
 }
+
+TdxCapability *qmp_query_tdx_capabilities(Error **errp)
+{
+    error_setg(errp, "TDX is not available in this QEMU");
+    return NULL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 01619857685..b5ee3b1ab92 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -14,6 +14,7 @@
 #include "qemu/base64.h"
 #include "qemu/mmap-alloc.h"
 #include "qapi/error.h"
+#include "qapi/qapi-commands-misc-i386.h"
 #include "qapi/qapi-visit-sockets.h"
 #include "qom/object_interfaces.h"
 #include "crypto/hash.h"
@@ -1537,6 +1538,26 @@ static void tdx_guest_finalize(Object *obj)
 {
 }
 
+static TdxCapability *tdx_get_capabilities(Error **errp)
+{
+    if (!kvm_enabled()) {
+        error_setg(errp, "TDX is not available without KVM");
+        return NULL;
+    }
+
+    if (!kvm_has_tdx()) {
+        error_setg(errp, "TDX is not supported by this host");
+        return NULL;
+    }
+
+    return g_new0(TdxCapability, 1);
+}
+
+TdxCapability *qmp_query_tdx_capabilities(Error **errp)
+{
+    return tdx_get_capabilities(errp);
+}
+
 static void tdx_guest_class_init(ObjectClass *oc, const void *data)
 {
     ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
-- 
2.52.0


