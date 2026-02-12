Return-Path: <kvm+bounces-70912-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DyaBN5yjWn42gAAu9opvQ
	(envelope-from <kvm+bounces-70912-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9747912AA0E
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1815930EDEAB
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C6022749E6;
	Thu, 12 Feb 2026 06:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wy78EA60";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YSMLm/hc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7471EB9FA
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877587; cv=none; b=W6sQm8dA/S0sPMIl/i+TNXQX3a53OgsRAEjtEwBfnfiKRG/pg8KPzpVILD8k7u0Ce7Q8AqP74lES1K/h5s0cN4pEGFQd8vwe8RPJ5wvk+tGZdWOPPGgueB2odOrWYxSpOa9OXbJSxcpQUjnmvBIbOMZN9CZpuFeHFw3iOGlP1zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877587; c=relaxed/simple;
	bh=3+uK9ZPZzKOQAyf5S/Pg0yKpMtKvNLG092RQpE3Uljw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgF1qHqoz52UaTY2WLH6UMvK2pY3p8lHcqaFEIyQrs8SXZ/I8JzX8JOCC6vVp99lxeWhikICvzPgMY/XM4qCuAXwTr7nomh36GDyGB7Wy4mX63ulacoSH8k+pg2XFGQPB/dKY6GJW9DvGQslj8jrTwm/EVLxPx2QUg+KmXqnnxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wy78EA60; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YSMLm/hc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kdx//uhe0dGZAW7ELRMRtjQOSKo80AjzaA5Q7pgL+h8=;
	b=Wy78EA60hTkWSyYoslH8x+mV0+WazeYatzk6feFygGTf4RvCzB2rc22DsMeAWKakSC7swM
	bD6PJi41EVKvp0gPwxTMUidj9RkXKGs0kzW8+AK93cIUA9wjmt3L77SquH0ihCKFBL0FlY
	ARSkNEJZ9PydeW9OmgNCgM1kGnoKLFE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-XFPU2en0PpuiWf72Mtqclg-1; Thu, 12 Feb 2026 01:26:23 -0500
X-MC-Unique: XFPU2en0PpuiWf72Mtqclg-1
X-Mimecast-MFC-AGG-ID: XFPU2en0PpuiWf72Mtqclg_1770877583
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c6df833e1efso6933513a12.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877582; x=1771482382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdx//uhe0dGZAW7ELRMRtjQOSKo80AjzaA5Q7pgL+h8=;
        b=YSMLm/hc4Pr1uVzBBlStp1lON8jKE53vh5cYMHvmlNUpZ9OgK9ZRDpMpbrUuiHxrYZ
         ZRnMT0Duo0oemg73udjFMpSnW3533nT6xq4J16GXcW643lvnKAdH18C5P/uE39sSQCye
         P49KwE7Wz2E/3kACVkAoftHcdtbcVYa/f99ZkKw6FOgq03UwR5JtsHRPWYhp70crimzk
         MNasM0a/eep2CJPTDFxRfjjsrHBLs9qBB+7KsgpyiPkT9rZEnK0ps2NiyS8pAWm0KbRI
         ew5OPN/C6GM+dcVX0oh3FvdkIOj4QMMBe8wfqBC/97yrc01UBcilj/EWd9Q/vo7tcL6x
         EVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877582; x=1771482382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kdx//uhe0dGZAW7ELRMRtjQOSKo80AjzaA5Q7pgL+h8=;
        b=NYCXzIT0Qcpp0C8suct2gOq2BjSN8NsXaTftAq94Kil8qWtcnd3OXozu2N0UmVMGkD
         Y9An6fJDgM7Mv17vbCx0dl8w6u1Ib1R117UICNlGAqfK15hSRJkOff6/lUajECJ5+tnZ
         /eooBiXgUyVi+CIY3IFzARLtulaym3eefGl0WuiUTlgfjKFbA6KqX1+JgcZtGAazzTkS
         ZaYv+lZx/UUzT8zcDvqfhVdCjVP5vRpF1lpnzLe2DREKBaaflFomCZvfxRHa7DfeSxgR
         +O0nGx/FGKri5hI3Ha6+SjCCdRqdEBvkf0I6H2Etr286xZAHvT2zxCeEDg4LzU3AWhyH
         L3FA==
X-Forwarded-Encrypted: i=1; AJvYcCWufiXIXk2r32wkrFef+x88VSsayPt5wOYUv5Uo1mS+aEPcxJDh4ZC4EYfOhS2kIcta0aU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8khG6iQFydZ4EITNUOKd/5itC3R2YaUbnuOpQqmYI8l5xaU96
	0a7Ixfj5hSgRqMSI7MdUFKqh5Kvxgd9Ju1lAoSNIUcVCXGo6M1lbw9nFUoslxdmhDQuRaz+krQ+
	crAj5J5f3QmaNtaZNTY5XUS9BSSxACnFm9kSDT1sjcK3ESMC461jbm+SoAPG0oQ==
X-Gm-Gg: AZuq6aJyob+f3O/9HKzbaPUZk/J9mwGDDDLHwFNyOH/eoYx21r5IHe6k+KDHQujqDiN
	hGZ1VnODkSkToXFpbYy4qsTXEgwXswsId9FNJPWftg+rFqSXE7qFt2VtyD1XPEHC8w/PaVOu6ap
	9GIwGkCiSmbLmspqj7kaz5utkJuXL2P9q7F20pzxG9m2PseHjAHAu8by61zY0BBEtN58Ze3/R2d
	01vuUQ26WwuicgYYxsDgl/Ir0bn8swNwSg+TV0ATtZw3GB4ddoB5M1HLZCv1SClkS30+x059PeO
	/nD9TXUuPCmbJPEDAetjtOBwoj5CrazASTtGrkSDYYMyZ32kXv/QQHzs8uy+ACFW2H0F95d3aJk
	WjSMKxdil9ozzlZXaYicZerOhYDlFmOzqd0FTNpBXnZQio7lgi113D/Y=
X-Received: by 2002:a05:6a20:2454:b0:366:14ac:e1fc with SMTP id adf61e73a8af0-3944897ea14mr1768761637.78.1770877582398;
        Wed, 11 Feb 2026 22:26:22 -0800 (PST)
X-Received: by 2002:a05:6a20:2454:b0:366:14ac:e1fc with SMTP id adf61e73a8af0-3944897ea14mr1768746637.78.1770877582040;
        Wed, 11 Feb 2026 22:26:22 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:26:21 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 15/31] i386/tdx: finalize TDX guest state upon reset
Date: Thu, 12 Feb 2026 11:54:59 +0530
Message-ID: <20260212062522.99565-16-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260212062522.99565-1-anisinha@redhat.com>
References: <20260212062522.99565-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70912-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9747912AA0E
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


