Return-Path: <kvm+bounces-69190-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AC2aLnJKeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69190-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:17:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 282529000C
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:17:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1719D3028009
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD57F329387;
	Tue, 27 Jan 2026 05:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HjhHMyZg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FtHTiYAu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA6515B971
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491019; cv=none; b=vC1RA/DgGfkxecsK83gbeuIPbaz8V/BIyNO564iNJZrMomwCls135g2OHuCHFKhWdReBFz9NdPbw1ro7RNuEYtTiKxyHjTRGL8P1jJg62TfsTnwv3ydSItpruV8kn+Klhsgz6IA+ucgXYWDRScLjIhPn8k3TtgvDkRbgCNdBn8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491019; c=relaxed/simple;
	bh=BeHlhn10CLAQntcZTBSYs63o2j+Pe0x/TffL1x8Q/dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twc9AfJskgDzT9ZtLTJbyOGaRVyyeZDtJhhdMi77wg7gvvzJMJD5yXY3td8ODjBra7zK5aKQaOKh+FiQujGsll1thziQwyUxpLhnQeSiXzJ6a3LJaCxqsAxt1cYueHPxm8t+STPDRymdNyp9YuLsTNeST3+yTiRIyT7F6qqOuh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HjhHMyZg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FtHTiYAu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CdaABaxt514z7cKlS+uuQzBXtNPXSHeITNnbmc7YpWg=;
	b=HjhHMyZgxelxntsyZGbtrseIYDtlO3cUwfJO3mGjc5eKdcaStONruubUYas+3TE0wxXmCZ
	tx399jlLPLX4AXQ0nP3qt6OgtTTCbZyxaadqZTKkBvg9oaumS43iMezfsgUGIPrPd57PDx
	MjpIQ8usvrdzQaXyGRDC6PYGS/mmOF4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-6RhmbHOwPAaUDwqvnESkiw-1; Tue, 27 Jan 2026 00:16:54 -0500
X-MC-Unique: 6RhmbHOwPAaUDwqvnESkiw-1
X-Mimecast-MFC-AGG-ID: 6RhmbHOwPAaUDwqvnESkiw_1769491014
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34c64cd48a8so5491489a91.0
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491014; x=1770095814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdaABaxt514z7cKlS+uuQzBXtNPXSHeITNnbmc7YpWg=;
        b=FtHTiYAu9kcpFn51nKEiDFmLxbeJzNXCasCVTxbgYyPPGlSeEImNGEvM6rPJ6LUFgK
         FLdYmYmuc6JRM5L1Yl6RMo9hU/kXPDqQjQPoWw9tCUD9hnbNIdyKUB7jgBLuRF7ZjwTS
         nbKWlLN+u7PIdRaqqL6C2HnJQlIWR6bXCXIrPxrucWt/LI9KfpktcVNK5whhMvIk3qX5
         sarDzZLn7QTYkFMFizgBa4OFAa4EFU6RIpEAcECaL7KF9cNtt2jKItIL9feVD6bYcguN
         T0p1Y2ob7FK5ZLAS0Q0+XIa0bN4YMvBA34Dqggbq0XuEE3dGqp5gbOzaj4diDardcJoL
         zubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491014; x=1770095814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CdaABaxt514z7cKlS+uuQzBXtNPXSHeITNnbmc7YpWg=;
        b=O/NUccjxrGw/HUfhFIW0c1iMDEgvzRNVYPoE5iH1ivZLvN/MEQyiwWuXUs3tDyyLEo
         28E99cyx4YLQ2HLYya4IIB1OF6u3PQXDQWoGkhEOyN96CyL+UKiZwDpy4ks3MdOkbKMZ
         0Bl7C/qt1vu98j+flM63lzBUxdkFX0X4NrTiLB6q3sFP5dAvgfMHuPbVc838HWJl/uez
         t7Mw2jaoag3vpIw9g6CThCu3TS29Sgb75tJezvd1e82VxfdHQnjBIDoV6LsCOLeEZc6Y
         h+g61sTajVaKCppWJKKfRyBAYmFbAxDoifzV1kiyruo7AlJSNTd0WUyYb7i8k27/B3fB
         jjRg==
X-Forwarded-Encrypted: i=1; AJvYcCUKiB/CG9RYD0FHlQLUnrA7sIZcTfPfJls30d6zjVfGuGVocZNxqdySseg+JWvzUn3MG2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWDcNGzmcrhWjazOjbOCNSKAvibSpVSk+8lzwMHrceLywc+Ld5
	nvHO/MMKwKxQBATNmmVSh8PNvEm9vE15eNyzEmP6LwrhI+Bg1YneGosqATIJ3UC+NbU0j6gCLET
	Zes1nm20p2sTTNBZZaXJ+zSRfOf+OHwljesI3J/UR1k3GdzxN/PCEwg==
X-Gm-Gg: AZuq6aIbDvm2TuEHdk5NXyIH63TPekqLBb9valeyqLfiBS3ZYzwzjEZthU6y3OpmxBz
	vzddwKQINXHkb67yFH8CXfiOBYgCDYnin0zxeClBG8jMP72a/+fr4Y//+1Subs7Joz/wE2NtVwI
	+ypa2t5PU/S/rIg1iNoWSSasEG9JHTsvo2IMqF3hU40QkRiCfMq5wtamGijccgjfb78HYWDrAfU
	uYcj/0eQNWQLW0Tm92xsIGDDOx4ZdAQLpnsGiGXsn2AbZ02owKDeHF2Cc6S/AA/VWLjxdwgcxsn
	rX5FwIM10u41j+9OhFCNc3mKRO/pjOtfzh3oIpNo6j5COfEkBDdtf8u0bP+IdL9ic1l+4G61ETL
	5IKAggd02RAldE0xh8Crsm3KeyAfz0Y6YRFsIjl2y3g==
X-Received: by 2002:a17:90b:562c:b0:353:100:2f20 with SMTP id 98e67ed59e1d1-353fece4c43mr607600a91.10.1769491013456;
        Mon, 26 Jan 2026 21:16:53 -0800 (PST)
X-Received: by 2002:a17:90b:562c:b0:353:100:2f20 with SMTP id 98e67ed59e1d1-353fece4c43mr607573a91.10.1769491013023;
        Mon, 26 Jan 2026 21:16:53 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:16:52 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Thomas Huth <thuth@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org
Subject: [PATCH v3 05/33] accel/kvm: add changes required to support KVM VM file descriptor change
Date: Tue, 27 Jan 2026 10:45:33 +0530
Message-ID: <20260127051612.219475-6-anisinha@redhat.com>
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
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_TO(0.00)[redhat.com,linaro.org,loongson.cn,kernel.org,aurel32.net,flygoat.com,gmail.com,linux.ibm.com,dabbelt.com,wdc.com,ventanamicro.com,linux.alibaba.com];
	RCPT_COUNT_TWELVE(0.00)[33];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69190-lists,kvm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 282529000C
X-Rspamd-Action: no action

This change adds common kvm specific support to handle KVM VM file descriptor
change. KVM VM file descriptor can change as a part of confidential guest reset
mechanism. A new function api kvm_arch_on_vmfd_change() per
architecture platform is added in order to implement architecture specific
changes required to support it. A subsequent patch will add x86 specific
implementation for kvm_arch_on_vmfd_change() as currently only x86 supports
confidential guest reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c        | 80 ++++++++++++++++++++++++++++++++++++--
 accel/kvm/trace-events     |  1 +
 include/system/kvm.h       |  2 +
 target/arm/kvm.c           | 10 +++++
 target/i386/kvm/kvm.c      | 10 +++++
 target/loongarch/kvm/kvm.c | 10 +++++
 target/mips/kvm.c          | 10 +++++
 target/ppc/kvm.c           | 10 +++++
 target/riscv/kvm/kvm-cpu.c | 10 +++++
 target/s390x/kvm/kvm.c     | 10 +++++
 10 files changed, 150 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 8301a512e7..46243cfcf2 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2415,11 +2415,9 @@ void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi)
     g_hash_table_insert(s->gsimap, irq, GINT_TO_POINTER(gsi));
 }
 
-static void kvm_irqchip_create(KVMState *s)
+static void do_kvm_irqchip_create(KVMState *s)
 {
     int ret;
-
-    assert(s->kernel_irqchip_split != ON_OFF_AUTO_AUTO);
     if (kvm_check_extension(s, KVM_CAP_IRQCHIP)) {
         ;
     } else if (kvm_check_extension(s, KVM_CAP_S390_IRQCHIP)) {
@@ -2452,7 +2450,13 @@ static void kvm_irqchip_create(KVMState *s)
         fprintf(stderr, "Create kernel irqchip failed: %s\n", strerror(-ret));
         exit(1);
     }
+}
 
+static void kvm_irqchip_create(KVMState *s)
+{
+    assert(s->kernel_irqchip_split != ON_OFF_AUTO_AUTO);
+
+    do_kvm_irqchip_create(s);
     kvm_kernel_irqchip = true;
     /* If we have an in-kernel IRQ chip then we must have asynchronous
      * interrupt delivery (though the reverse is not necessarily true)
@@ -2607,6 +2611,75 @@ static int kvm_setup_dirty_ring(KVMState *s)
     return 0;
 }
 
+static int kvm_reset_vmfd(MachineState *ms)
+{
+    KVMState *s;
+    KVMMemoryListener *kml;
+    int ret = 0, type;
+    Error *err = NULL;
+
+    /*
+     * bail if the current architecture does not support VM file
+     * descriptor change.
+     */
+    if (!kvm_arch_supports_vmfd_change()) {
+        error_report("This target architecture does not support KVM VM "
+                     "file descriptor change.");
+        return -EOPNOTSUPP;
+    }
+
+    s = KVM_STATE(ms->accelerator);
+    kml = &s->memory_listener;
+
+    memory_listener_unregister(&kml->listener);
+    memory_listener_unregister(&kvm_io_listener);
+
+    if (s->vmfd >= 0) {
+        close(s->vmfd);
+    }
+
+    type = find_kvm_machine_type(ms);
+    if (type < 0) {
+        return -EINVAL;
+    }
+
+    ret = do_kvm_create_vm(s, type);
+    if (ret < 0) {
+        return ret;
+    }
+
+    s->vmfd = ret;
+
+    kvm_setup_dirty_ring(s);
+
+    /* rebind memory to new vm fd */
+    ret = ram_block_rebind(&err);
+    if (ret < 0) {
+        return ret;
+    }
+    assert(!err);
+
+    ret = kvm_arch_on_vmfd_change(ms, s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (s->kernel_irqchip_allowed) {
+        do_kvm_irqchip_create(s);
+    }
+
+    /* these can be only called after ram_block_rebind() */
+    memory_listener_register(&kml->listener, &address_space_memory);
+    memory_listener_register(&kvm_io_listener, &address_space_io);
+
+    /*
+     * kvm fd has changed. Commit the irq routes to KVM once more.
+     */
+    kvm_irqchip_commit_routes(s);
+    trace_kvm_reset_vmfd();
+    return ret;
+}
+
 static int kvm_init(AccelState *as, MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
@@ -4014,6 +4087,7 @@ static void kvm_accel_class_init(ObjectClass *oc, const void *data)
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "KVM";
     ac->init_machine = kvm_init;
+    ac->reset_vmfd = kvm_reset_vmfd;
     ac->has_memory = kvm_accel_has_memory;
     ac->allowed = &kvm_allowed;
     ac->gdbstub_supported_sstep_flags = kvm_gdbstub_sstep_flags;
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index e43d18a869..e4beda0148 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -14,6 +14,7 @@ kvm_destroy_vcpu(int cpu_index, unsigned long arch_cpu_id) "index: %d id: %lu"
 kvm_park_vcpu(int cpu_index, unsigned long arch_cpu_id) "index: %d id: %lu"
 kvm_unpark_vcpu(unsigned long arch_cpu_id, const char *msg) "id: %lu %s"
 kvm_irqchip_commit_routes(void) ""
+kvm_reset_vmfd(void) ""
 kvm_irqchip_add_msi_route(char *name, int vector, int virq) "dev %s vector %d virq %d"
 kvm_irqchip_update_msi_route(int virq) "Updating MSI route virq=%d"
 kvm_irqchip_release_virq(int virq) "virq %d"
diff --git a/include/system/kvm.h b/include/system/kvm.h
index 8f9eecf044..d40cc9750c 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -358,6 +358,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s);
 int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
 int kvm_arch_init_vcpu(CPUState *cpu);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
+bool kvm_arch_supports_vmfd_change(void);
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s);
 
 #ifdef TARGET_KVM_HAVE_RESET_PARKED_VCPU
 void kvm_arch_reset_parked_vcpu(unsigned long vcpu_id, int kvm_fd);
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 48f853fff8..a707406763 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1569,6 +1569,16 @@ void kvm_arch_init_irq_routing(KVMState *s)
 {
 }
 
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 int kvm_arch_irqchip_create(KVMState *s)
 {
     if (kvm_kernel_irqchip_split()) {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 3fdb2a3f62..346e1ef6f7 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3253,6 +3253,16 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
     return 0;
 }
 
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret;
diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index 9d844c4905..1be471fd54 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -1364,6 +1364,16 @@ int kvm_arch_irqchip_create(KVMState *s)
     return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
 }
 
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
 {
 }
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index a85e162409..d12c8b8a27 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -44,6 +44,16 @@ unsigned long kvm_arch_vcpu_id(CPUState *cs)
     return cs->cpu_index;
 }
 
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     /* MIPS has 128 signals */
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 41bd03ec2a..fba2b93290 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -180,6 +180,16 @@ int kvm_arch_irqchip_create(KVMState *s)
     return 0;
 }
 
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 static int kvm_arch_sync_sregs(PowerPCCPU *cpu)
 {
     CPUPPCState *cenv = &cpu->env;
diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
index b047ffa9c0..89207dddf9 100644
--- a/target/riscv/kvm/kvm-cpu.c
+++ b/target/riscv/kvm/kvm-cpu.c
@@ -1545,6 +1545,16 @@ int kvm_arch_irqchip_create(KVMState *s)
     return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
 }
 
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 int kvm_arch_process_async_events(CPUState *cs)
 {
     return 0;
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 54d28e37d4..556c45e7fd 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -393,6 +393,16 @@ int kvm_arch_irqchip_create(KVMState *s)
     return 0;
 }
 
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 unsigned long kvm_arch_vcpu_id(CPUState *cpu)
 {
     return cpu->cpu_index;
-- 
2.42.0


