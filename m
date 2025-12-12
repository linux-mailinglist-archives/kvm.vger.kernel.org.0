Return-Path: <kvm+bounces-65836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9790CCB90E2
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:08:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31CD030C3C80
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E8E631AF25;
	Fri, 12 Dec 2025 15:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gXddt8ZL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a7mlVHrp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875B4313285
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551913; cv=none; b=I/1JZKtNsWlRZsWNdl70BPj12DZj6NILa3Anxl1V7hedB7gLvEOLvxNEsCeqFcrm16ab/SzXq2N8NfDFvq5NW4w4A8u5HTrP+a+FDh1/efpRitMvS7gS+rsHBac396JLZcpyr1o4O2qgtPFNBsANupISp22+anyTDjnUOQmCXHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551913; c=relaxed/simple;
	bh=z4WYJc3d1Rnc8z/Wg9FYEiY8BSOeXWhgWmdymTHCij4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doYEFTtHxWNvCXW75G+vZnqyUV8g1NHXIHDFS/2kC7dT7j6swbK3iYhnSVk+7yme4VNsH2vS9JtVPNmdfEn5xFNvWwbFXMmJ82DUy9aFiB/FlzZprYoFIvolrC19eiyyXKWeEChva6T7cTzw/3touD1R4TUK4occy8tngbbktII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gXddt8ZL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a7mlVHrp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oEIEJzPUM8lszorjY76ZFvjs6ACj0dKr14L1nFW+0jg=;
	b=gXddt8ZL1hbZNMjL9JMtKHPbHlnTSZRQzk8yhpT2y5BLZANKp/c0E3NaV4z17Or/pSkPp+
	2QW1/8UztXNf8i+Kh7PrwhbXB2P878WTvioj0N3vCPfJGLFct+X7AJtWmTSp477rT6LhMO
	1ZtmH7tc5nu6DrNZ+IYPruwPpiBXtIo=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-OfUtEbpkNnOuFiPrCCbi4g-1; Fri, 12 Dec 2025 10:05:07 -0500
X-MC-Unique: OfUtEbpkNnOuFiPrCCbi4g-1
X-Mimecast-MFC-AGG-ID: OfUtEbpkNnOuFiPrCCbi4g_1765551907
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a07fa318fdso3763345ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551906; x=1766156706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEIEJzPUM8lszorjY76ZFvjs6ACj0dKr14L1nFW+0jg=;
        b=a7mlVHrpG66rU+yFBYzFPFC0YvofolPK5kG87znEK0EkQAXZ2J3PzpIq4tMTHKV8Nk
         elyMFEBN7WQEUkv7GF4mzVwuT0lHaQKaQIykvPJlgwxbTDjq8DgTqDnH8kLEAJnSnNKN
         UkzubiT60x90oCWiqCzcM+xXKjoG4+4cHbwpC23aUYYH5XaMcCRmnBKERb9RcGKsE0mp
         uqfgWB1MdNjc7HSZciiJQ2nKbIvnZr8AvU0o4ICikjAhYa0DDfNKqvepSskWaFMDHHhn
         GpJdp/bILZTXFt68lxEKWHOURYtjlbjWRMLy5IsDqCR2mV7FRNeDK8lq3iz7jHqG6cMD
         ppxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551906; x=1766156706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oEIEJzPUM8lszorjY76ZFvjs6ACj0dKr14L1nFW+0jg=;
        b=dDZTn5WDkHyagI6LKhXpcybFfziBM9Xc91r9ltcAZdUCZS1NF1pLxiiqU3OOClR/pB
         r65tHC3ejGznYAmcxOff8g9esxcXHc1xw0iakgceGnvvsAD9m106aqFXj4OKPELWogRv
         JxNpGqvMwnMASRn2QRuNIZyFjUuo2uaFEgBNoxES+7Nz3SurHT95f4xf5s7ebVI5C4AU
         xiZoUFcHRpKnZYvfW5hYuxQDW2eUBRjL0DUfEHL/bJiWuyB+hiNH17fivX1ssOth6x5n
         UG3K3HMBnmEMxxL5BlYW3o36vaQ7WPcxvdqdjfbcv1qbCe1EHRbCcljo9/WaHXcvZcyC
         DWWg==
X-Forwarded-Encrypted: i=1; AJvYcCWMD9dPR2PqHbfE7srqw767NA/4TwZvZAuQmV6iwGTOJdSrYaB1rkvdLG4BNc0Diu7l8bo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg8Y36nyIBA/XP+Kl6iLNgQRelVL1mLrA7+OCF3u+9ClZuP8wT
	VpAlOZ/v2zG1Kjx0WK9oZGtRIwqEpfo2Eik+lupsbuveUmggEaC9eyNIGqF2uHGmYkbtoSoGXwL
	RGn6C7kbxu7bQ24njFo9rW7NXpIuRVjWt3MELXDJS1w6O0RCsYD1VvA==
X-Gm-Gg: AY/fxX4P8eE1bELbHmxQfuH00y8abKh8fBQJZ6J4YZN1cB8DzZRnzi52v0AhjRPsmcS
	K1ENUAciYyrejEFVQHNxF58mGOLT3o8CIq1iyo+Km86BskqrTsuTvByhFTgWaDErQyNp/0baw22
	A4XqJ7TmdLE7YZsNkTg5BxZmU4MkG+olimxfJUBLHJAfDiIVqJVdySOpWbpgZ9UsGu8/BtDQUC0
	Hn+VMON0QSLiaka0owm+e/P2o567Xvn2V391/Rm4HSXhHTGzsPAtFLEmJ6v1iH7G0PA5xxh7cSn
	hufeegVzayk8Vn6IDEXS4DKtX4u+/9LBg3lOnCTvXXoSnEZXM2uOJqnMLf+nHd/iSYgFFbtEGt7
	yZ8C5b0cXrZvvpNaMT0DlpdNgc/Ca/BEOVeZJ26MFLlI=
X-Received: by 2002:a17:903:244a:b0:295:fc0:5a32 with SMTP id d9443c01a7336-29f26ceb95bmr19878465ad.3.1765551906314;
        Fri, 12 Dec 2025 07:05:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IET9ImeOBpvT3cnvF8vtwzmhT6W/Ab/9Nek/sYkQoLeG9AkBTnkGRFc8OBeHTEwi3vM/PO5yg==
X-Received: by 2002:a17:903:244a:b0:295:fc0:5a32 with SMTP id d9443c01a7336-29f26ceb95bmr19877865ad.3.1765551905720;
        Fri, 12 Dec 2025 07:05:05 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:05:05 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 13/28] i386/tdx: finalize TDX guest state upon reset
Date: Fri, 12 Dec 2025 20:33:41 +0530
Message-ID: <20251212150359.548787-14-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the confidential virtual machine KVM file descriptor changes due to the
guest reset, some TDX specific setup steps needs to be done again. This
includes finalizing the inital guest launch state again. This change
re-executes some parts of the TDX setup during the device reset phaze using a
resettable interface. This finalizes the guest launch state again and locks
it in. Also care has been taken so that notifiers are installed only once.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/tdx.c | 39 +++++++++++++++++++++++++++++++++++++--
 target/i386/kvm/tdx.h |  1 +
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index bafaf62cdb..1903cc2132 100644
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
@@ -389,6 +390,19 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
     CONFIDENTIAL_GUEST_SUPPORT(tdx_guest)->ready = true;
 }
 
+static void tdx_handle_reset(Object *obj, ResetType type)
+{
+    if (!runstate_is_running()) {
+        return;
+    }
+
+    if (!kvm_enable_hypercall(BIT_ULL(KVM_HC_MAP_GPA_RANGE))) {
+        error_setg(&error_fatal, "KVM_HC_MAP_GPA_RANGE not enabled for guest");
+    }
+
+    tdx_finalize_vm(NULL, NULL);
+}
+
 static Notifier tdx_machine_done_notify = {
     .notify = tdx_finalize_vm,
 };
@@ -689,6 +703,7 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     X86MachineState *x86ms = X86_MACHINE(ms);
     TdxGuest *tdx = TDX_GUEST(cgs);
     int r = 0;
+    static bool notifier_added;
 
     kvm_mark_guest_state_protected();
 
@@ -736,8 +751,10 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
      */
     kvm_readonly_mem_allowed = false;
 
-    qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
-
+    if (!notifier_added) {
+        qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
+        notifier_added = true;
+    }
     tdx_guest = tdx;
     return 0;
 }
@@ -1503,6 +1520,7 @@ OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    TDX_GUEST,
                                    X86_CONFIDENTIAL_GUEST,
                                    { TYPE_USER_CREATABLE },
+                                   { TYPE_RESETTABLE_INTERFACE },
                                    { NULL })
 
 static void tdx_guest_init(Object *obj)
@@ -1536,20 +1554,37 @@ static void tdx_guest_init(Object *obj)
 
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
     x86_klass->kvm_type = tdx_kvm_type;
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
-- 
2.42.0


