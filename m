Return-Path: <kvm+bounces-69195-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uNjfJbNKeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69195-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:18:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 388AB90082
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 92E653051D3C
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FDDD283FEA;
	Tue, 27 Jan 2026 05:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hFZDeLmw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ljlq9gAL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F9915B971
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491032; cv=none; b=i27OFzrhTo1UHQnVAhhSNnDtMvKJM6bIOE+P3PkQb1I2LryAJGfCToRE7SZN/F0wNC0eNPYwugI6StWZda+p5DHZq6R98Nv+g8kDeg+bwPREvZmeWtJuA585Kn6rMmze7ilvmcUXfaerm3K5aT7kNN4hyneKCi/EO9HDP+w4C3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491032; c=relaxed/simple;
	bh=Z9plG+Z+ycB2JWb4VU0c994A3uUi+PnSPDWjsVqdrEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpAl2GF69nMHk90iN5TKjv8dRzOgP2CyHKPBCXk05unPqvHpirmBiDkbhrMTvemCM0Wq8yeQ2lSJnpK0SomQEZFqZm0jviO8tq4MSqLq5TR4ROkmO45C1r/ulV2t7wdYqDR1UARjjMUr1grZnVuzMe9hb9/0u8d0heQT3nlDxts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hFZDeLmw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ljlq9gAL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YuzXnGtIe5+ocaB4DlBWBC8HhEPJq9yVKADc+BsREeM=;
	b=hFZDeLmwC8nSebLqxclQdbV3JUYwAPvQBuDCUJIA9AgmlBAzGP8/xj3DxTKPwOjxqczOkR
	jJmC65PqNACH9qFSozuGTRMTXoq3IVzwdU3d8kmZkEd+BJo/jIewqlweG2+5NdZ0ojgFCd
	FbAvbz96Sxv3GV4vKFKUG35W0y9fBMQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-YP2EU1UjNsi1XogajMGGJA-1; Tue, 27 Jan 2026 00:17:07 -0500
X-MC-Unique: YP2EU1UjNsi1XogajMGGJA-1
X-Mimecast-MFC-AGG-ID: YP2EU1UjNsi1XogajMGGJA_1769491027
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34ac814f308so571560a91.3
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491026; x=1770095826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YuzXnGtIe5+ocaB4DlBWBC8HhEPJq9yVKADc+BsREeM=;
        b=ljlq9gAL8He5uvizPva5GvEJpE5nOD1vP6ebckCbQBxPPF7vUTiLlJKhJzXF/o0hYj
         VRbrNLRCnKOKqai2xL7YzeMBWqxZ6tf4L0NweC5nlwXL53CpPqRg8HkXf3PxTwNQDHpe
         i1WyhzxGb8888xQrcZhs4k09GMgPQzCZT0z8jF/FYuiZ3ga2a+eARYqKM8+WJCl5t7Ml
         YACk6unqum0ySw5p5+izlWilbjH2vKfdLvryRaXbr6ylX0XfrE9XqvjzRYuuUcB/Su3l
         a379t7V+/2YUOes7VlGWwSCnSsEQeDnkLacFKp6d4YBXaxQAS6lP+8Antl+piIdmOrZ1
         U7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491026; x=1770095826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YuzXnGtIe5+ocaB4DlBWBC8HhEPJq9yVKADc+BsREeM=;
        b=p1rz3Ds23XDkHgz+AkfmSB7JzR5nwn4IeH6ZmvFa0YLGByObxSwczjwBkVteO7TOO8
         FM7bnHyWScr9pRysvqTkBLgH2U+c0vZLTLnU20duxiz1kDzOgWs1AyvSVidrCQWWwlEC
         4IB9O9jICaw0z1br3WszeWN1V/MyFratJ4d5EuVNx5cnEW2NpehVFed3SXu76VUYi5b0
         FI6XEJ7Izzv4i7gsAHMslHJ8uoJe4u38W5R4K4sDvkAnfGk57C+kzVY5gH4RDZorFHFl
         AFByMVdRlZz77JMRVw1Zdo9MfrPSgqT+X12sHVA8aT1iBVPD5XSyX7m4Cz2ZMCxQe2is
         Zu2w==
X-Forwarded-Encrypted: i=1; AJvYcCVSl3NvBndgC48z/73BbtyBtThMP0Jpij3ymp/+d8xn4pGFcqEpTz0Zjt4TI2kyMJU5y+g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxof7nPBWvr5f5lE3950UqyaD3/HQ/kfgdWaan3oZuUOcpQG7Uc
	LLsqzWyp/09B62U5YrJaEMt9U67znt3yiFHsyuUIlVKU0gOxVcBY2BL0kWpCRf/ZmdYsCjXKyyq
	NTqIBrqIgRiaJoakmGKde8kPhpBSgcET6vV0rkZMTK/Uf2jiLV9cn0tzBIonLTw==
X-Gm-Gg: AZuq6aLE1n3884ahP/FLlXLnnBTBakmSYcxyBKuMMF6dVb2GO6pQSY+MZKhgojwN78G
	Uy1Pzymb8BFzRJn+tZdk0pvcvPXP7rI3+mBcVF+oXRlpZ8BG35vGMnYw96n2amrR/5+PR847Et3
	4kU3YvQfmcIwK9tNFv+fU4ls/tmMCa2IwFjI82WiqjJZCOcDrh8qZFW/4MI3VdOwvuCKML5xE/p
	oAZbMzBRImm09SaXyVsRnnliSf+ysKHju6v96gbBgsYeba8opuJ0lxgCsF0Gi8EVQp0ALVAXveD
	8bd9pqKUojRUFHgy0qWGbzp9U6V/pIwXXQQMJfFloCoZgSgMJu06nus8D0wbGUKwaaITI/4fsdb
	5rZDwDWcicOU/5a93ei6TWsbOaXtKUJJekygIcM73kg==
X-Received: by 2002:a17:90a:d603:b0:34a:b4a2:f0c8 with SMTP id 98e67ed59e1d1-353feda7c73mr651586a91.30.1769491026563;
        Mon, 26 Jan 2026 21:17:06 -0800 (PST)
X-Received: by 2002:a17:90a:d603:b0:34a:b4a2:f0c8 with SMTP id 98e67ed59e1d1-353feda7c73mr651570a91.30.1769491026174;
        Mon, 26 Jan 2026 21:17:06 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:05 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 10/33] kvm/i386: implement architecture support for kvm file descriptor change
Date: Tue, 27 Jan 2026 10:45:38 +0530
Message-ID: <20260127051612.219475-11-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-69195-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 388AB90082
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
index e28ab18a14..e27ccff7a6 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3269,14 +3269,52 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
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
@@ -3284,6 +3322,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     int ret;
     struct utsname utsname;
     Error *local_err = NULL;
+    static bool first = true;
 
     /*
      * Initialize confidential guest (SEV/TDX) context, if required
@@ -3312,21 +3351,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
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
@@ -3353,16 +3381,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
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
@@ -3409,15 +3438,22 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
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


