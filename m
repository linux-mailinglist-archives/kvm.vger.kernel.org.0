Return-Path: <kvm+bounces-69199-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IA8xBPBKeGkKpQEAu9opvQ
	(envelope-from <kvm+bounces-69199-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:19:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 69079900F6
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:19:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DEE743064E9B
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B77329C5F;
	Tue, 27 Jan 2026 05:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chTyUbKB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AjeoGv7s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F87329C57
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491049; cv=none; b=TReAOTtAw7tU9uacDHSgTXAeORY5q94GDQS0j1tvVbBTR5lFa8X0DZ4RoxXKiV40J0+vSppwZeo70vMHfiMb9GCIn0Bd0eZeSzi4TmjKYVx9wKIWfmaUf3uY3Q1QkMeHDx5Ab9PucUfW/65zF2ND4XIAdMCEm5p5M/wBZCHGwh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491049; c=relaxed/simple;
	bh=1OPqNKYK0GBDdFNv0UA1AxrDPe8UTJl+SOD1wUKIsTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ohgc1+KrVNRZKpuDuc4c95UJckAXSb2ge8LMkIz8xz6jJMu8w6O5Hkwc0UxEr4VPvlH2Nv4StIyNYdeQr2uikQDGRXBh3dIB3rBU6aIBSFZX8CKhgW4CKl5Mwwm0JTc3QpBtmu39GZctH/yPbhOKDYKUjlb/HTmv2i1g5XCNzgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chTyUbKB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AjeoGv7s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnOtqZFQnQ7z67Y/wwL5FaGuBGKBCde67NUJiikFzaU=;
	b=chTyUbKBQFBYjapSH5z9KfQOu8vDe+T5y2MMUG4eLgncvYr+pU3wqSl3mHkzDNDDhDPzPj
	ggrLhHWbuVkH1KisVaroSl04zdKFqx8IJ8vqlMmt5VZOCt/ikw6P1VuhGQKPn2ilIwXry3
	MDt8sUYOnr8hfq1ow8rqvLUeT/hmyb4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-eOsshHtNNDqGgHx8xAVJ-g-1; Tue, 27 Jan 2026 00:17:24 -0500
X-MC-Unique: eOsshHtNNDqGgHx8xAVJ-g-1
X-Mimecast-MFC-AGG-ID: eOsshHtNNDqGgHx8xAVJ-g_1769491044
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34c64cd48a8so5491950a91.0
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491044; x=1770095844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OnOtqZFQnQ7z67Y/wwL5FaGuBGKBCde67NUJiikFzaU=;
        b=AjeoGv7szH5r+JY8riVVfe0sth6ZFqkDASOu9Piy6vA830Ttb0NrgleEKyCeOXL4ox
         vKyPPnXOdooov6/jeHL6ZxrPP/axN7stQeqeuy386mQqljc3iZ/zVKU4o17TZAxh1wAs
         fXSLo5TIExw9eCdcB+ope8rcSwXcz8Q81B6BE2vvEpa1FKo536XvPEeyEgl8fqOo776E
         M8mYbN6t9zKzN78Sapm2XADVtEH4qEYEGPTN3JV4IZpYcQ6jWeeAaReum0EuDjif1bVE
         GUYAQIeCW3ZH+7f7cTRyrPjPj99Hh4JlcGfYg/V7DiK6aaSlnP4Mzaj47Kh/x7mPpZzL
         LUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491044; x=1770095844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OnOtqZFQnQ7z67Y/wwL5FaGuBGKBCde67NUJiikFzaU=;
        b=LpPuPfeAGwUSSPUBfHUKR+sc3ezqQktkcYPXyip2jRkhpBHBEuP3Uc8fysUC9Ejc7c
         96kCfzIfBAUvQeYw1/ioJHxRrDv3tEs8EI7XBV3EkGpS7wGpeXbWT86034o72cyrF47o
         L+EnSKi0p8RsZ3F/SQYKTAlREB2KffBT3RzjVaIIiq0Jn2xp/s5sVAiCy1p9KnteQfrj
         Nx+fuXNJ1rKxlZZI0Pycl8yhNV4xhJrZ5IA3yNUDUI8YjtmjtWFPRKo8dgydahDkyAmc
         9tNr/Bdap1sMcYV2es/LvvOhgsYh/BMX0wXYv6k9mGxU4IALT6oKUT1k3B+7GPNdFCmC
         OrRw==
X-Forwarded-Encrypted: i=1; AJvYcCWfdslL4yU7u+oZTJLA6eU/zonnOZgos2KYMI4lORmPNlO5E45dL80Ul1ElkVYlVTVPwkI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFUiSDVQUuRvyDAtpVdEUt9CCBR2YMfgCcnNip/PqDWvnuqGB4
	RFPJffyhnk/vH7nznwfKQyT2o1jYBk0XzINWLxeL0YgAodPb4XI+GCIA0jQIXknJ62W7QHXV6kv
	DfJrdeZ1Z/BmqdOwAi8V72acL5RKpJHnlBTE5PIZM5dPrLbaFSpIkkA==
X-Gm-Gg: AZuq6aJyX6jIbP214+qXyRwwXCqS9QtgyMiCuNA8EEsk7BI2LxSTkqew6iztbO+FjFr
	sVC1hVQy/yKrfv4DSLut69kI2O1ncrya9TSpVZmW+Fl8hk5hzmeRGU1nzop9Vkb12vVyaBYInsv
	ntMEHVevwY6ItzUTrxdmwyWimYrpjm/OS1rqizUXlV3Ld2yvBqVx9ENvGWhfDOVjrlqMmzMRHEN
	CPrDHra23bBu33vhV7hEiMdvoQ563J5UaYxSrhZ0mCxqH5R3ek4vR5DriZzucz93de7IWwuR3Ug
	j5GVYeqWwBsXmr3y5hhtS6EaxfMXI8PoT0eUVi4KfDWa89692MgEYWjAe0LJ6p7XQLLwDfRlMPg
	Oh3iDtozEAFnS1nYYxt6HN8pD7l0WrCiPCzyKiprz1g==
X-Received: by 2002:a17:90a:ee88:b0:353:3f04:1b78 with SMTP id 98e67ed59e1d1-353fecd096emr470471a91.4.1769491043810;
        Mon, 26 Jan 2026 21:17:23 -0800 (PST)
X-Received: by 2002:a17:90a:ee88:b0:353:3f04:1b78 with SMTP id 98e67ed59e1d1-353fecd096emr470454a91.4.1769491043445;
        Mon, 26 Jan 2026 21:17:23 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:23 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 16/33] i386/tdx: finalize TDX guest state upon reset
Date: Tue, 27 Jan 2026 10:45:44 +0530
Message-ID: <20260127051612.219475-17-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260127051612.219475-1-anisinha@redhat.com>
References: <20260127051612.219475-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69199-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 69079900F6
X-Rspamd-Action: no action

When the confidential virtual machine KVM file descriptor changes due to the
guest reset, some TDX specific setup steps needs to be done again. This
includes finalizing the inital guest launch state again. This change
re-executes some parts of the TDX setup during the device reset phaze using a
resettable interface. This finalizes the guest launch state again and locks
it in. Machine done notifier which was previously used is no longer needed as
the same code is now executed as a part of VM reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/tdx.c        | 38 +++++++++++++++++++++++++++++++-----
 target/i386/kvm/tdx.h        |  1 +
 target/i386/kvm/trace-events |  3 +++
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index fd8e3de969..37e91d95e1 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,7 @@
 #include "crypto/hash.h"
 #include "system/kvm_int.h"
 #include "system/runstate.h"
+#include "system/reset.h"
 #include "system/system.h"
 #include "system/ramblock.h"
 #include "system/address-spaces.h"
@@ -38,6 +39,7 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 #include "tdx-quote-generator.h"
+#include "trace.h"
 
 #include "standard-headers/asm-x86/kvm_para.h"
 
@@ -389,9 +391,19 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
     CONFIDENTIAL_GUEST_SUPPORT(tdx_guest)->ready = true;
 }
 
-static Notifier tdx_machine_done_notify = {
-    .notify = tdx_finalize_vm,
-};
+static void tdx_handle_reset(Object *obj, ResetType type)
+{
+    if (!runstate_is_running() && !phase_check(PHASE_MACHINE_READY)) {
+        return;
+    }
+
+    if (!kvm_enable_hypercall(BIT_ULL(KVM_HC_MAP_GPA_RANGE))) {
+        error_setg(&error_fatal, "KVM_HC_MAP_GPA_RANGE not enabled for guest");
+    }
+
+    tdx_finalize_vm(NULL, NULL);
+    trace_tdx_handle_reset();
+}
 
 /*
  * Some CPUID bits change from fixed1 to configurable bits when TDX module
@@ -738,8 +750,6 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
      */
     kvm_readonly_mem_allowed = false;
 
-    qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
-
     tdx_guest = tdx;
     return 0;
 }
@@ -1505,6 +1515,7 @@ OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    TDX_GUEST,
                                    X86_CONFIDENTIAL_GUEST,
                                    { TYPE_USER_CREATABLE },
+                                   { TYPE_RESETTABLE_INTERFACE },
                                    { NULL })
 
 static void tdx_guest_init(Object *obj)
@@ -1538,16 +1549,24 @@ static void tdx_guest_init(Object *obj)
 
     tdx->event_notify_vector = -1;
     tdx->event_notify_apicid = -1;
+    qemu_register_resettable(obj);
 }
 
 static void tdx_guest_finalize(Object *obj)
 {
 }
 
+static ResettableState *tdx_reset_state(Object *obj)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+    return &tdx->reset_state;
+}
+
 static void tdx_guest_class_init(ObjectClass *oc, const void *data)
 {
     ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
     X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
+    ResettableClass *rc = RESETTABLE_CLASS(oc);
 
     klass->kvm_init = tdx_kvm_init;
     klass->can_rebuild_guest_state = true;
@@ -1555,4 +1574,13 @@ static void tdx_guest_class_init(ObjectClass *oc, const void *data)
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
     x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
     x86_klass->check_features = tdx_check_features;
+
+    /*
+     * the exit phase makes sure sev handles reset after all legacy resets
+     * have taken place (in the hold phase) and IGVM has also properly
+     * set up the boot state.
+     */
+    rc->phases.exit = tdx_handle_reset;
+    rc->get_state = tdx_reset_state;
+
 }
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 1c38faf983..264fbe530c 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -70,6 +70,7 @@ typedef struct TdxGuest {
 
     uint32_t event_notify_vector;
     uint32_t event_notify_apicid;
+    ResettableState reset_state;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
diff --git a/target/i386/kvm/trace-events b/target/i386/kvm/trace-events
index 2d213c9f9b..a386234571 100644
--- a/target/i386/kvm/trace-events
+++ b/target/i386/kvm/trace-events
@@ -14,3 +14,6 @@ kvm_xen_soft_reset(void) ""
 kvm_xen_set_shared_info(uint64_t gfn) "shared info at gfn 0x%" PRIx64
 kvm_xen_set_vcpu_attr(int cpu, int type, uint64_t gpa) "vcpu attr cpu %d type %d gpa 0x%" PRIx64
 kvm_xen_set_vcpu_callback(int cpu, int vector) "callback vcpu %d vector %d"
+
+# tdx.c
+tdx_handle_reset(void) ""
-- 
2.42.0


