Return-Path: <kvm+bounces-70908-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CA7aI7NyjWk+2wAAu9opvQ
	(envelope-from <kvm+bounces-70908-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 143BF12A9C4
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4F6CB30C2F70
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6118B2749E6;
	Thu, 12 Feb 2026 06:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ObSIu7yj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="G+AvRsr4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF2A1F5834
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877568; cv=none; b=cOsF0wNa/eqSH6UTtr95IDyzHjLsVOJA9u1l2NpCm9fOPbi6FRag3RyONGMJam+r4cF21fn5ydpRHCDU3JUBs9cPKNs7gZIlFEZhDKcEC8v9yftJxvYygUqziKyfdgIJJSJuzIItTld401Blb0VsOl4yUd4Nw12HLv5Ue95Ct4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877568; c=relaxed/simple;
	bh=TlEpYm1ft0ctydFJ0D3yb9e7P+XgOJXqeIfBKYhWGec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqTOk6N2QwZn7gOdAGFhRiBTK/61/Nhe+tCr3UFIeIQiHrFrf9RGCbK3bQkgb01tRyxJIN9DOOlJYOCWhC8VrC4abXAoTk+5hsMRCEuRAYpFyO3pFQvGMv/Gt9XUj4lmH0FI8DxW3ZNUOsypn/+RfxhYZDoaSFOWTGk0Tc2W8zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ObSIu7yj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=G+AvRsr4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=22GpwhOlGGm3YDWl4oHQuQsIgR+l63T6jAvu0DmCDfs=;
	b=ObSIu7yjUx/8JCQPKCZZHwJLv2P+iCCksa/EJtsC6Q1V65MWavoniiMdJs/WjAmSNaZFTR
	7n4r4bmqnjW+zhWSSyYfcV++6iCw4AZGXII/fEiKQGNPtzdQagO3zcZgO6yZh0WwSA7m4w
	Ie3tty4cAUnkAOok7COLUUHPt2N2LiY=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-n60koorAObWWJEKnML-E7A-1; Thu, 12 Feb 2026 01:26:04 -0500
X-MC-Unique: n60koorAObWWJEKnML-E7A-1
X-Mimecast-MFC-AGG-ID: n60koorAObWWJEKnML-E7A_1770877563
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b62da7602a0so4356150a12.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877563; x=1771482363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=22GpwhOlGGm3YDWl4oHQuQsIgR+l63T6jAvu0DmCDfs=;
        b=G+AvRsr4kAgqoJS4esWkgRv4IhzmmBVBO+VbCXA9LNlq6W6xH4/eH2PdltIw6IMS2X
         U2LMTey+f6E4dHpHRBbdMyo4+Sr1MqOn7w3bV1Q+wUXJEXWK2spnO/7tskroWvSmmWJX
         O6s0e12JyDS7BkZfgvaYx/N8HIK7KMfgD8ipd7/M3SHJr+8oONUMe8w3Y2LcG1exQpdK
         2toQ/DCwWXB5FgHRc9fzp4i46E+CilFPhlPALiVi5KTWETM7y97H4NK1qVgbdeictWEa
         aGWwrbN3lJNuSjvJt1O0jM5ik21I2CqYwDkE7bbPm3lAcXVYSwB21JznsSS9WpfNTrF1
         UMqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877563; x=1771482363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=22GpwhOlGGm3YDWl4oHQuQsIgR+l63T6jAvu0DmCDfs=;
        b=OXYSu0k66T5xHbrzINlYDxnodE3QT4mZxrQ0pOfUbGrXNRaHYRN4Ki+mxcG2KOE88j
         3so7+m7WELsPx7GdVnBOhzo1SVp1Vc6xYEPBhDzM/tH9Zz7xAAzF+zReLAz+aKVOEO5I
         VT0OPnb8TQ72c0bi0AIpxTc/VOZhbiq9eGuJa40fRsQoE7G5UHm9rLP2XnIOxx5UsHZp
         2r4ao7Nev2ipbil1nZxazpxB2uskaQmKBKWjZVExEDrop6MEg7oc0bQNHAO1dXki+sEQ
         gmORomMPhkTnyKGpKbccG0cUGe9nIMP3tX0TxDloFQDlQCGNMmqgN2zGMjyH2rxQKBIs
         0XnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSrZ78Twm/8j/mZ2LR1RthXLvvSfW+z7m28Eh9zP/z7CWoYIZanhJVX3HCJ7M9o5G2OvI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwncwnUh1IM5DSQ2fp9tk9StZIXp86KQTva66GSKEUYLEgTsRhv
	5+3FGZ0FG6wljo8cQe/DCkG1EHtSWEn+5/SRwnU/zKSy+NwNmubUN3bEfHcvFMM0rfGzgm2dvLh
	Dpj66j+39Pi/LLhHtWxw8JR2hstUOOWxupCqwxjpI79M1GkczAliNTA==
X-Gm-Gg: AZuq6aINCsNPdGJ83Mlar3wu+C0m+E1vn6J1x7TxxiLxES7fZndkdySQWPVc85NxNZT
	96OFV5PhdEqJBNcjI3McNk3xB5il6ZME/FhPx+X5QArdoBr9eqJPsUFDLycuTLPjzvcvoWKfSnX
	cR/L89Lbt2e4lLCeavHodhF8w8UbQe+goA3PgVTYdmXON0+8VXIKjfmVBQLhHZZjOG9uEVMWEks
	qjRO/V7T21ma88V7wV2jCUtN2KUjtPjArcpJ6XubO0JPTdnpTP3NttmRXpugA7v1Y7IsAWC4Ns3
	+kOJcV1LvxEIad77lAdw0dqNiwKMtDyuz+YU121O54zYHW0T1immeaF4nyWpvFW46BoZBJ5WpwW
	R6AVBmoOsRGu5vbaywnrKCnAfx6NyZcbl/See3tX5w19PgcgL8W6ji0Y=
X-Received: by 2002:a05:6a20:9f05:b0:33b:5a3f:3cbe with SMTP id adf61e73a8af0-394488554a9mr1595688637.54.1770877563434;
        Wed, 11 Feb 2026 22:26:03 -0800 (PST)
X-Received: by 2002:a05:6a20:9f05:b0:33b:5a3f:3cbe with SMTP id adf61e73a8af0-394488554a9mr1595668637.54.1770877563001;
        Wed, 11 Feb 2026 22:26:03 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:26:02 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 09/31] kvm/i386: implement architecture support for kvm file descriptor change
Date: Thu, 12 Feb 2026 11:54:53 +0530
Message-ID: <20260212062522.99565-10-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70908-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 143BF12A9C4
X-Rspamd-Action: no action

When the kvm file descriptor changes as a part of confidential guest reset,
some architecture specific setups including SEV/SEV-SNP/TDX specific setups
needs to be redone. These changes are implemented as a part of the
kvm_arch_on_vmfd_change() callback which was introduced previously.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c        | 82 ++++++++++++++++++++++++++----------
 target/i386/kvm/trace-events |  1 +
 2 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 5d9b79529f..e82a6e9eda 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3268,14 +3268,52 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
     return 0;
 }
 
+static int xen_init_wrapper(MachineState *ms, KVMState *s);
+
 int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
 {
-    abort();
+    int ret;
+
+    ret = kvm_arch_init(ms, s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
+        X86MachineState *x86ms = X86_MACHINE(ms);
+
+        if (x86_machine_is_smm_enabled(x86ms)) {
+            memory_listener_register(&smram_listener.listener,
+                                     &smram_address_space);
+        }
+        kvm_set_max_apic_id(x86ms->apic_id_limit);
+    }
+
+    trace_kvm_arch_on_vmfd_change();
+    return 0;
+}
+
+static int xen_init_wrapper(MachineState *ms, KVMState *s)
+{
+    int ret = 0;
+#ifdef CONFIG_XEN_EMU
+    if (!object_dynamic_cast(OBJECT(ms), TYPE_PC_MACHINE)) {
+        error_report("kvm: Xen support only available in PC machine");
+        return -ENOTSUP;
+    }
+    /* hyperv_enabled() doesn't work yet. */
+    uint32_t msr = XEN_HYPERCALL_MSR;
+    ret = kvm_xen_init(s, msr);
+#else
+    error_report("kvm: Xen support not enabled in qemu");
+    return -ENOTSUP;
+#endif
+    return ret;
 }
 
 bool kvm_arch_supports_vmfd_change(void)
 {
-    return false;
+    return true;
 }
 
 int kvm_arch_init(MachineState *ms, KVMState *s)
@@ -3283,6 +3321,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     int ret;
     struct utsname utsname;
     Error *local_err = NULL;
+    static bool first = true;
 
     /*
      * Initialize confidential guest (SEV/TDX) context, if required
@@ -3311,21 +3350,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     if (s->xen_version) {
-#ifdef CONFIG_XEN_EMU
-        if (!object_dynamic_cast(OBJECT(ms), TYPE_PC_MACHINE)) {
-            error_report("kvm: Xen support only available in PC machine");
-            return -ENOTSUP;
-        }
-        /* hyperv_enabled() doesn't work yet. */
-        uint32_t msr = XEN_HYPERCALL_MSR;
-        ret = kvm_xen_init(s, msr);
+        ret = xen_init_wrapper(ms, s);
         if (ret < 0) {
             return ret;
         }
-#else
-        error_report("kvm: Xen support not enabled in qemu");
-        return -ENOTSUP;
-#endif
     }
 
     ret = kvm_get_supported_msrs(s);
@@ -3352,16 +3380,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         return ret;
     }
 
-    /* Tell fw_cfg to notify the BIOS to reserve the range. */
-    e820_add_entry(KVM_IDENTITY_BASE, 0x4000, E820_RESERVED);
-
+    if (first) {
+        /* Tell fw_cfg to notify the BIOS to reserve the range. */
+        e820_add_entry(KVM_IDENTITY_BASE, 0x4000, E820_RESERVED);
+    }
     ret = kvm_vm_set_nr_mmu_pages(s);
     if (ret < 0) {
         return ret;
     }
 
     if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE) &&
-        x86_machine_is_smm_enabled(X86_MACHINE(ms))) {
+        x86_machine_is_smm_enabled(X86_MACHINE(ms)) && first) {
         smram_machine_done.notify = register_smram_listener;
         qemu_add_machine_init_done_notifier(&smram_machine_done);
     }
@@ -3408,15 +3437,22 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
                 return ret;
             }
 
-            ret = kvm_msr_energy_thread_init(s, ms);
-            if (ret < 0) {
-                error_report("kvm : error RAPL feature requirement not met");
-                return ret;
+            if (first) {
+                ret = kvm_msr_energy_thread_init(s, ms);
+                if (ret < 0) {
+                    error_report("kvm : "
+                                 "error RAPL feature requirement not met");
+                    return ret;
+                }
             }
         }
     }
 
-    kvm_vmfd_add_change_notifier(&kvm_vmfd_change_notifier);
+    if (first) {
+        kvm_vmfd_add_change_notifier(&kvm_vmfd_change_notifier);
+    }
+
+    first = false;
 
     return 0;
 }
diff --git a/target/i386/kvm/trace-events b/target/i386/kvm/trace-events
index 74a6234ff7..2d213c9f9b 100644
--- a/target/i386/kvm/trace-events
+++ b/target/i386/kvm/trace-events
@@ -6,6 +6,7 @@ kvm_x86_add_msi_route(int virq) "Adding route entry for virq %d"
 kvm_x86_remove_msi_route(int virq) "Removing route entry for virq %d"
 kvm_x86_update_msi_routes(int num) "Updated %d MSI routes"
 kvm_hc_map_gpa_range(uint64_t gpa, uint64_t size, uint64_t attributes, uint64_t flags) "gpa 0x%" PRIx64 " size 0x%" PRIx64 " attributes 0x%" PRIx64 " flags 0x%" PRIx64
+kvm_arch_on_vmfd_change(void) ""
 
 # xen-emu.c
 kvm_xen_hypercall(int cpu, uint8_t cpl, uint64_t input, uint64_t a0, uint64_t a1, uint64_t a2, uint64_t ret) "xen_hypercall: cpu %d cpl %d input %" PRIu64 " a0 0x%" PRIx64 " a1 0x%" PRIx64 " a2 0x%" PRIx64" ret 0x%" PRIx64
-- 
2.42.0


