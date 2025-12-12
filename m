Return-Path: <kvm+bounces-65831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE848CB90B5
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B28030B6E99
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529773126D8;
	Fri, 12 Dec 2025 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QeNLDxnb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5YTwb03"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38A1311C10
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551894; cv=none; b=g8G1xCa0hsDVb7YbBhPFk2k7FYdmyiMTzLkNjHPtelPqw/5cQoISoYNq5I2oW1zIDJcDGQtd7GjhemqR941FUJAIoi0/4Xmi8tZt8/P/F8wQa3arWFQSgu7Vyypaw23X/H5dZ3XrgKHPjwGJy9Z932iyaZSyqIc2SmebEdxKfiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551894; c=relaxed/simple;
	bh=Avd0Iucs4chfxam4cs+se2OZalp664SYUu3l4dCBEAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Te2ukd2K17o158q1vQYt7/q0nlQMy1enT7SG5PdIVKfqTmWEz3XV9Z8+P1TIT8ngFJavP0t3gd/tJ6+gUWJ4AAoDeivoUbQmLTJeCn5YXX3uRedzDX3RU303ZNRNrgqToNpw2oB20zehdDbbdJVNfFtVOsXiAf6k1LM6Xlzvj5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QeNLDxnb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5YTwb03; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tEQtRpZIU+af5B0NJVC06k5FBVfVHxHqEV2FPCkoDHk=;
	b=QeNLDxnbkPVn6jBBqUSH01YZMudEZ2CcxpXE1pXoXEuNxkc3q1NDg2Ig0p2q1n3Hm9EdXu
	AIH8rXGlTOVsB+lHXdhRXnTwehGQxvQqJkzC3x5NysbEVqgP1HbO+YVg069/sp/3IgbqW2
	kCiSfBI7XVtZka8PjiNUpBeVG/Zp2rc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-FIihecA9N66MOGvweXaWIg-1; Fri, 12 Dec 2025 10:04:50 -0500
X-MC-Unique: FIihecA9N66MOGvweXaWIg-1
X-Mimecast-MFC-AGG-ID: FIihecA9N66MOGvweXaWIg_1765551889
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-29f25e494c2so7654525ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551889; x=1766156689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tEQtRpZIU+af5B0NJVC06k5FBVfVHxHqEV2FPCkoDHk=;
        b=M5YTwb03B1Cp8TU8t516vkt+rYVtqpFuab/gC1DKU9jLAfoZTEF/fnriqk+Voi6wwj
         L/xGBQpt3Q/QVsWO2I2ao5sjKdugrt8RDd2bg1IzwMSIb+5xyBHlZbcxJf+3rbaY2lxs
         3qHlauKMLf8QaDwoQX4JUfhnXbnQygCfzdy35Bu3S7zOtamAWFP5gDp5ETA8e66aUP0/
         JeXqkEncadJjs68b5VenLNfBIJMMycTZkKjQ0qB8OGJKRQ/JnPC950VUJZnBK7sIxI/H
         ESHSOUKYeiwl7qPkYAkPaK1ACZ4b17QsaefOXjzwDrQbQkVgqX1lPJKMzAGUtWoo7JUC
         E5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551889; x=1766156689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tEQtRpZIU+af5B0NJVC06k5FBVfVHxHqEV2FPCkoDHk=;
        b=GvT22PMEU3d/F+INCqEdjbXL28z8EibNpsiW9f0In4XUksls1+NEr42p8BYTJWayiX
         c4HAl599ByneKkyY/ywIsdfACljGHpvrNKNRwqZODgxESTvRE6rtHr5R67ehXGnYhqm6
         yMCK92SXrqbnXPY34vviCNShICOI+aMTAhW1AQ++xy33FkQ7rHKoCPIz5lrCzBsrZ/5J
         8SJBIvGmRUOkK7wb8HQ7byWCo8DrLmSz1sAro8IgqIg0vfu+LVfQcRiGG4GqC5xbbI+2
         qh8VnWPhAyBdBd1+FCtFaPLIr6fCEu5qcFtF2pNDkx65ShJvKOom0W0Euxjn4y54qcdb
         +D8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUcgAAeIO24eiE01TJdu0xm6mlAEn8oc7Mc6LMd6slxwpQAqNZTQGuhKLlze2b1QtKzvHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrYY1Z8wj6hLdTSKBQ2ty7pgmUSWfASLPghBpo+AXrYJnBWDYD
	s+V2XCd7Ro/FMfUy5jTskDJLN9h18wuwYcvLi2DqIs4/JEKRhnzu1CEwEHDmq3SvM4EBfogeH1q
	keIgNvGB59IJVI3QaoJWboQY3PCv3wwnY1q7xP37MiLbA92xc0WfeWw==
X-Gm-Gg: AY/fxX615Y7iHTx5qAzR/O5Sfjzd510QsB1yif8psxg0pTNKFgWhywfBIBqSQqVISbF
	vyeDGB71dV1pQbDMTBd7yksufdc14OSZDVafyhoWItNPP99GQdGkeVdgPXMlttBgGN4nJwLjJbJ
	5F5rPNLIzvtz3cEkFdEAupj5m6Hx8J8mnU7WcbKq5NLVbjKK/D03/a3PfOwc4zZGuNVTv+3yqXS
	OLC/SYPkdzgiA46P2BN0fEl4sosgdO6iPIfhq0WbiKY10R8nueOtTkeGgwes44gngS4FKjFor6/
	uwAjghtFA9nwIEXNAOQ9C33VyJPI1jFk9rJbcq5H5nQTeZqpobY1e+o6YsGpG+0R0Vn4dLiQs/e
	JE/uDZtUb8JJqhrvu1btV+qOmdgpflaF6aw/fDJjZRxw=
X-Received: by 2002:a17:903:8cd:b0:29a:4a5:d688 with SMTP id d9443c01a7336-29eeebcedb9mr67342355ad.15.1765551889042;
        Fri, 12 Dec 2025 07:04:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZBw3cmTdXgss3nJnSVhW4vDvRaSjlwKI3kdKjvhl/302qsw+kjO/S5XkgEuKUu8iYibkyig==
X-Received: by 2002:a17:903:8cd:b0:29a:4a5:d688 with SMTP id d9443c01a7336-29eeebcedb9mr67341775ad.15.1765551888392;
        Fri, 12 Dec 2025 07:04:48 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:04:48 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 07/28] kvm/i386: implement architecture support for kvm file descriptor change
Date: Fri, 12 Dec 2025 20:33:35 +0530
Message-ID: <20251212150359.548787-8-anisinha@redhat.com>
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

When the kvm file descriptor changes as a part of confidential guest reset,
some architecture specific setups including SEV/SEV-SNP/TDX specific setups
needs to be redone. These changes are implemented as a part of the
kvm_arch_vmfd_change_ops() call which was introduced previously.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 132 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 119 insertions(+), 13 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index cdfcb70f40..e971f5f8c4 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3252,9 +3252,126 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
     return 0;
 }
 
+static int xen_init_wrapper(MachineState *ms, KVMState *s);
+
 int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
 {
-    abort();
+    Error *local_err = NULL;
+    int ret;
+
+    /*
+     * Initialize confidential context, if required
+     *
+     * If no memory encryption is requested (ms->cgs == NULL) this is
+     * a no-op.
+     *
+     */
+    if (ms->cgs) {
+        ret = confidential_guest_kvm_init(ms->cgs, &local_err);
+        if (ret < 0) {
+            error_report_err(local_err);
+            return ret;
+        }
+    }
+
+    ret = kvm_vm_enable_exception_payload(s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    ret = kvm_vm_enable_triple_fault_event(s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (s->xen_version) {
+        ret = xen_init_wrapper(ms, s);
+        if (ret < 0) {
+            return ret;
+        }
+    }
+
+    ret = kvm_vm_set_identity_map_addr(s, KVM_IDENTITY_BASE);
+    if (ret < 0) {
+        return ret;
+    }
+
+    ret = kvm_vm_set_tss_addr(s, KVM_IDENTITY_BASE + 0x1000);
+    if (ret < 0) {
+        return ret;
+    }
+    ret = kvm_vm_set_nr_mmu_pages(s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE) &&
+        x86_machine_is_smm_enabled(X86_MACHINE(ms))) {
+        memory_listener_register(&smram_listener.listener,
+                                 &smram_address_space);
+    }
+
+    if (enable_cpu_pm) {
+        ret = kvm_vm_enable_disable_exits(s);
+        if (ret < 0) {
+            error_report("kvm: guest stopping CPU not supported: %s",
+                         strerror(-ret));
+            return ret;
+        }
+    }
+
+    if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
+        X86MachineState *x86ms = X86_MACHINE(ms);
+
+        if (x86ms->bus_lock_ratelimit > 0) {
+            ret = kvm_vm_enable_bus_lock_exit(s);
+            if (ret < 0) {
+                return ret;
+            }
+        }
+        kvm_set_max_apic_id(x86ms->apic_id_limit);
+    }
+
+    if (kvm_check_extension(s, KVM_CAP_X86_NOTIFY_VMEXIT)) {
+        ret = kvm_vm_enable_notify_vmexit(s);
+        if (ret < 0) {
+            return ret;
+        }
+    }
+
+    if (kvm_vm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR)) {
+        ret = kvm_vm_enable_userspace_msr(s);
+        if (ret < 0) {
+            return ret;
+        }
+
+        if (s->msr_energy.enable == true) {
+            ret = kvm_vm_enable_energy_msrs(s);
+            if (ret < 0) {
+                return ret;
+            }
+        }
+    }
+
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
 
 int kvm_arch_init(MachineState *ms, KVMState *s)
@@ -3290,21 +3407,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
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
-- 
2.42.0


