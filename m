Return-Path: <kvm+bounces-71760-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGEnKsJxnml0VQQAu9opvQ
	(envelope-from <kvm+bounces-71760-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D71B519151F
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 61347304F7F2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4287921420B;
	Wed, 25 Feb 2026 03:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TPX+2qm2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MY0MKWyl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325732641FC
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991470; cv=none; b=ERmc4Q5EbwsIJ9Sp7ctc5nHt9vtvy0MAz3sQt0Ae+/Ku0jhGsBrtahNO6I8zf7HXIA+xOp8xn0HLVqHsyafGz+fLonc0kaclLBzKK//ByelrQS49OF6ZhqanTQyMbYQPR6IEI6GJshKrn1qmD+a7i2U9rTLPHuPqYPYX5d32+5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991470; c=relaxed/simple;
	bh=3+uK9ZPZzKOQAyf5S/Pg0yKpMtKvNLG092RQpE3Uljw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TH7oLzXZ7oQKiG7vc0Zh4uIKFuXsRiD6Puhzf67VeSlRPBXLS3oLIArq5km6dIgKN5H807kv7beRkYemppCBEHYugM/7oUr5xzCYhXoG4/9eH9gv65bn/sr1IISBC1Cp2eV3eC8z3oR5oMgqxyJTcWrp9SAMq84uiE/qRAYIrSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TPX+2qm2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MY0MKWyl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kdx//uhe0dGZAW7ELRMRtjQOSKo80AjzaA5Q7pgL+h8=;
	b=TPX+2qm2O89sX3Z7gGiAhyrtflCFMIbpYLJF8/ogoi7V9nbHU3pQUlfbz5WftK5QrO1caD
	CBMes1M+/zWfks9jtdFFr8ujitDD/OuHiAfnir4AVNScdAIkRvI8jCdfGIX+BUMNRnKS69
	E1NCcKe5bbStqbXdnXJ5chaGS+Pa9jM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-agyiFo1QPZCjsU4y9Xg-Yw-1; Tue, 24 Feb 2026 22:51:06 -0500
X-MC-Unique: agyiFo1QPZCjsU4y9Xg-Yw-1
X-Mimecast-MFC-AGG-ID: agyiFo1QPZCjsU4y9Xg-Yw_1771991465
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-354c0eb08ceso39231398a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991465; x=1772596265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdx//uhe0dGZAW7ELRMRtjQOSKo80AjzaA5Q7pgL+h8=;
        b=MY0MKWylu/TNWk+8hUs9c6Y9DA+3o2mxUGOh8ADhMbK186VlskZcFFqFN3YJwQQ5KZ
         0OHHbOTukp1x2xy1A/N3zPIflkgPu/8na0gwVuhrC3boU0BXUsDZTmUPxQ8kbD1TuI2r
         cShw9Zz3tymq2n9GQ5cAmpNnSZmu6P42ncTclUj+lS3nQPIh4ftnTR1xffcW6jIySn/X
         OdFYZweFeRfL04EJfH9L5xxEJpFVPB/0C1E5WEDJmtfkv4sh1KIketkpoTX2EET/3kLQ
         c/EWdj3Vb/wJKlCgPqjvBpy6LnylxTx0zFLWnHExiYE6hkwTKqAudvnVKZhL+1z3DAqy
         ZMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991465; x=1772596265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kdx//uhe0dGZAW7ELRMRtjQOSKo80AjzaA5Q7pgL+h8=;
        b=a9TlAAco/W7WH5Kwjkkv5zifR4UeXDU19hGA1w6cBZxCMqR9CPzMprVg9fG7+hyKNV
         s1JoQqiZXMWm25y9krJ8L1vv/bwWT0RpllRXM3GUSSLkltS+JL2aO4javCDFCZaSm8P+
         PoKGwA57WZhnqUcBicWwuKNk+uU+eJ2Lzk0uvIgSsBnMnSP42RDlRnTyvIVVyDLMeLPS
         fNzoz5+brEqAvXye4CWSJd51cnj/EIAtB9nJEO1XwProFZTeKuvO+5r9ALHRbT5lo1Nz
         gi+4AatcAxIZZDPljpqZM3UXS1NQQj6oSwnFDevJEEWBXx0ry93cHQNpSjviGl3KxynL
         walQ==
X-Forwarded-Encrypted: i=1; AJvYcCXF+1BghdPgRwMAOmy2uoeg1CQISLE4d0YOZsmmIlfKK5NFX17rYlS2AQdG6ofDeCsg/24=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQr0sWRjXo/ChnpfsbaQuB45tFwnVG0MbhlWQZoUUj3PvBQLpj
	qvl+qo5uiEgh3NmVHAhvmLQ4apGcw3IjYfJDwbRI2RcFoLv3g8O0TW0jmpWEecdkgC1VRIFXBwJ
	bI1c/nWErEjRqLIMn0E9s1NNSR72mqLt3o+QK7crx9bUO25SlXVQYvg==
X-Gm-Gg: ATEYQzwULsNPyU8PkVlZLmmg67HrVjlG52FsPRTGW465mI0bihGIiAXUQVoZbG0raCu
	q8gpJOyvGjA9MmbtsjMvUDPEYPT9zjEF5Kntgbw08aVgkBO57/L5sZgdaXVekZXj2TGUpAZGoiD
	GSYMxtIJLE6DZYtpBJ5krparDUGEph+T5kZ1w5AgfKwvIM+km5M/ILLHRHhQl3hun02QsEp+c3f
	iwHIY1d/6ezncCsvSbbmgo1mNZxkKYbidVEBbJzvOXjlk6OFZXlGfmoavX4Z3ykB/DtpuknJ1Yd
	trNh5+wIrAAYN4ql4r748ypzLGbU6rv3GWm5LSqsWflr1Jqyr/95TjXdq/LZIirtRw1vLGMhPQr
	0SOaRNW+sXR53YDlH8tPulw1p68bg2uClfFBr+9pg6g0olXKfSWmieDM=
X-Received: by 2002:a17:90b:1b05:b0:34c:2db6:57d5 with SMTP id 98e67ed59e1d1-358ae6be0e4mr10612278a91.0.1771991465461;
        Tue, 24 Feb 2026 19:51:05 -0800 (PST)
X-Received: by 2002:a17:90b:1b05:b0:34c:2db6:57d5 with SMTP id 98e67ed59e1d1-358ae6be0e4mr10612249a91.0.1771991465011;
        Tue, 24 Feb 2026 19:51:05 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:51:04 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 17/35] i386/tdx: finalize TDX guest state upon reset
Date: Wed, 25 Feb 2026 09:19:22 +0530
Message-ID: <20260225035000.385950-18-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260225035000.385950-1-anisinha@redhat.com>
References: <20260225035000.385950-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71760-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D71B519151F
X-Rspamd-Action: no action

When the confidential virtual machine KVM file descriptor changes due to the
guest reset, some TDX specific setup steps needs to be done again. This
includes finalizing the initial guest launch state again. This change
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


