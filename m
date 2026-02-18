Return-Path: <kvm+bounces-71233-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAhAGiKmlWkxTAIAu9opvQ
	(envelope-from <kvm+bounces-71233-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BE54E155FF8
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C04D33036EF5
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2480B30DEB8;
	Wed, 18 Feb 2026 11:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fq/GYgor";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bdxlP8XM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E3830DEBA
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415020; cv=none; b=m6xUUia6qjdBpK9YL7eAedBjVYYeBFgRodRagVgDDTzSiSM/tfykxb4EA2DLZL4+k7TySnYYDW7iP8KHnDaDQUoqIvGmfU4lzw9fhjVttEoTpF7thvW7NWaSE5ed1Os3ZYpe67KsGNwlHRw2XiJbTgG+yEtypF1/p7G8DafbAJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415020; c=relaxed/simple;
	bh=3+uK9ZPZzKOQAyf5S/Pg0yKpMtKvNLG092RQpE3Uljw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0SDbjHu0ZekTXJCFGKkUIrdY5hVFeV1SOYDSOVm7UFe9qX8SeGJFTcbOc2PqeXhIwHKtlnFF1ke+yz6Jy5MX6Lv3SEO/CD7NGaiLhOzUtkCmH03+u8td57nnpS5p99TpBJJFyV7bp2KT6qSgRXiIFql5zMiwsKpoecuntMzad0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fq/GYgor; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdxlP8XM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771415017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kdx//uhe0dGZAW7ELRMRtjQOSKo80AjzaA5Q7pgL+h8=;
	b=fq/GYgortbxGSeyquXaV7/wQ+81UXESRs+J2LhCcTjMy7xNMEQWcT7u9x2iyAm/hHg2+0e
	Gl3UHo+ydRDWteeZxXCChMKA2Syr2fbUwCe1WAEpp5ouOe8nSaCq9z15tKGZNMUmhzirJa
	n9ROktK4wVCsWwZLlpH5o6TX+CLhjOs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-SsbohT8wNOug_5slpn00aA-1; Wed, 18 Feb 2026 06:43:36 -0500
X-MC-Unique: SsbohT8wNOug_5slpn00aA-1
X-Mimecast-MFC-AGG-ID: SsbohT8wNOug_5slpn00aA_1771415016
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aaf2ce5d81so62267765ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771415015; x=1772019815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdx//uhe0dGZAW7ELRMRtjQOSKo80AjzaA5Q7pgL+h8=;
        b=bdxlP8XMRfOlTzKowkzKIId1DnM06wvoB0fRhxiSa49p5w4TV6JMB3unS55ZIpY/OB
         0ajb0uY65HF4zV9+sPzgUmJwoZOvcNMODZCxFhREtwj2gMkphNO1FGwcxEvoCAUUkOYq
         McZ6YCRtNvfYAFwTHjpK562FTOFxU0GhrXQ6HRhhHt/JZ/hiqHBrTnW7uMf+8cY+8Rwy
         VpaFaN57u3TGI+xk/QsXbMnerD4RGUU3u1L7ljFYy+1O2bbKHZhEaTexvj0ux6AzCQYQ
         cGXGOOAQ11Dyo2Oq63Fo6tbHdb01lY3SiPnaGdta9toSKA5mlrm0u501V5qoPT7aXNAT
         oBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415015; x=1772019815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kdx//uhe0dGZAW7ELRMRtjQOSKo80AjzaA5Q7pgL+h8=;
        b=apSkiylgyP+N2orbeyVsdNAz/e+Qpc8RtOoKygVoMLK88AzVIuUZxYCgXAxuh1B4J+
         O5kpRK30PXzMdOCZOVGujvqeXcOqgGoMpqVVewGPP2kDaf+y6x1i9pxHtVX+TRFVzYM7
         QW5W7fRtashqL6BoVL3JzOCkxlr0VjZRYvekX42EC+NjCpUepkIEfs1Gzzg9ZPb5ak18
         4hmg6abLptVX7qgc+TaP3DsyhuXVR0H6kRApqyxoGIdwROn5bFuH6GJJR6hx0RwSuRHF
         X6QuoFPA1A9RbtahUgneL5GKI/vOMiAa75230tyMUJ79mnYVN4+rtrvtij1zqv81ImKY
         a6Tw==
X-Forwarded-Encrypted: i=1; AJvYcCV741FEPE21PYvLqqnO583bRiyAxpz8fHeiOatYed3EAX2f6CNjthpkI/2kY/57eo+pTo4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFfZZcxhHuBT2+kOisBehYAw1UQM4E1cS67NytyWwVZ7zssFXC
	uftAhz6dcq4B9x42L3CaY/rMtK6tbEorAuzTMCgMiI39yjxDUmjUmgRyU/rU8+h2H9nhurArSYP
	3LT1wRTXLD+bnkfPeCfX3CTJTRmt9uuz/9eBElFMwziaLlbrfan9GPh70NHDYog==
X-Gm-Gg: AZuq6aIUSP3AgVh4khcFiP/xCcFj+xDB+40reNIxX0aCQZNEVYlQLxG71iuwabs2wMN
	K+hSJGnZGjx0Y8u7LhiLzi3M5j80+NQ/Thcefglzotq7VxvxN/Q8zGv6nAknqEScc1cgT753z/d
	U/3xYRtrYnnke77xtawKzeDVWVax7p29naQwON2qSzNvpj2U4+MD05VqIAOt+iyWs0ovLD6sd+q
	IOn6TIIM5bsG2LojAAnGHrhEp2zsMwXFwJO0PCAvkqhyx0TW6qqwE7M3Y9g8RaP1yTvbMK3A0xc
	MhCUPcp1JxhvtqaEvz+BJYaPJMs946Wj2DTIIQfscdMPgd70WJyLgZfoncYrAsNrZoLgRpEgDG/
	QZzk7YYA80dWtpybrK9lU5J6TTLMR8W6ZlZm6/hvjx0u1xUPRcEWg
X-Received: by 2002:a17:902:e5c8:b0:2aa:d647:c312 with SMTP id d9443c01a7336-2ad175c5952mr155523715ad.61.1771415015237;
        Wed, 18 Feb 2026 03:43:35 -0800 (PST)
X-Received: by 2002:a17:902:e5c8:b0:2aa:d647:c312 with SMTP id d9443c01a7336-2ad175c5952mr155523515ad.61.1771415014774;
        Wed, 18 Feb 2026 03:43:34 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:34 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 16/34] i386/tdx: finalize TDX guest state upon reset
Date: Wed, 18 Feb 2026 17:12:09 +0530
Message-ID: <20260218114233.266178-17-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260218114233.266178-1-anisinha@redhat.com>
References: <20260218114233.266178-1-anisinha@redhat.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71233-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BE54E155FF8
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


