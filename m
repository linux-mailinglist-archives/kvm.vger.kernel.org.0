Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1931A223A95
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 13:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgGQLeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 07:34:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23002 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgGQLe3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jul 2020 07:34:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594985667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=drwIDnPePb0U+gsjdqJ9mNmNmtntq76LKVrvvY6ldbE=;
        b=aN/AQOOmkuyp1TR1OrnFvB9Dj1G2hds4HL9DdCWERnNPcQQv+HuzuTIRDnTV1Qi/gvkMs1
        8qlfACOazHuCthuEyvXkz8ahP3Hz1XiPQqDS7JzIQV9h91Hy/xIg1lCtzOHx5A7CS4hU9G
        EBN4E/Vya3aOF3AvS5SUujl8/eolsmQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-8cB0XYUwPpeEFvsp2Tf_1g-1; Fri, 17 Jul 2020 07:34:26 -0400
X-MC-Unique: 8cB0XYUwPpeEFvsp2Tf_1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 410741085;
        Fri, 17 Jul 2020 11:34:24 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C11B319C58;
        Fri, 17 Jul 2020 11:34:23 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests v2 2/3] svm: INIT and STARTUP ipi test
Date:   Fri, 17 Jul 2020 07:34:21 -0400
Message-Id: <20200717113422.19575-3-cavery@redhat.com>
In-Reply-To: <20200717113422.19575-1-cavery@redhat.com>
References: <20200717113422.19575-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Init the vcpu and issue the STARTUP ipi to indicate the vcpu
should execute its startup routine.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 x86/cstart64.S  |  1 +
 x86/svm_tests.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index 3ae98d3..dfd7320 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -7,6 +7,7 @@
 .globl tss_descr
 .globl gdt64_desc
 .globl online_cpus
+.globl cpu_online_count
 
 ipi_vector = 0x20
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 3b0d019..698eb20 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -17,6 +17,8 @@ static void *scratch_page;
 
 #define LATENCY_RUNS 1000000
 
+extern u16 cpu_online_count;
+
 u64 tsc_start;
 u64 tsc_end;
 
@@ -1885,6 +1887,58 @@ static bool reg_corruption_check(struct svm_test *test)
     return get_test_stage(test) == 1;
 }
 
+static void get_tss_entry(void *data)
+{
+    struct descriptor_table_ptr gdt;
+    struct segment_desc64 *gdt_table;
+    struct segment_desc64 *tss_entry;
+    u16 tr = 0;
+
+    sgdt(&gdt);
+    tr = str();
+    gdt_table = (struct segment_desc64 *) gdt.base;
+    tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
+    *((struct segment_desc64 **)data) = tss_entry;
+}
+
+static int orig_cpu_count;
+
+static void init_startup_prepare(struct svm_test *test)
+{
+    struct segment_desc64 *tss_entry;
+    int i;
+
+    vmcb_ident(vmcb);
+
+    on_cpu(1, get_tss_entry, &tss_entry);
+
+    orig_cpu_count = cpu_online_count;
+
+    apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT,
+                   id_map[1]);
+
+    delay(100000000ULL);
+
+    --cpu_online_count;
+
+    *(uint64_t *)tss_entry &= ~DESC_BUSY;
+
+    apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP, id_map[1]);
+
+    for (i = 0; i < 5 && cpu_online_count < orig_cpu_count; i++)
+       delay(100000000ULL);
+}
+
+static bool init_startup_finished(struct svm_test *test)
+{
+    return true;
+}
+
+static bool init_startup_check(struct svm_test *test)
+{
+    return cpu_online_count == orig_cpu_count;
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /*
@@ -2198,6 +2252,9 @@ struct svm_test svm_tests[] = {
     { "reg_corruption", default_supported, reg_corruption_prepare,
       default_prepare_gif_clear, reg_corruption_test,
       reg_corruption_finished, reg_corruption_check },
+    { "svm_init_startup_test", smp_supported, init_startup_prepare,
+      default_prepare_gif_clear, null_test,
+      init_startup_finished, init_startup_check },
     TEST(svm_guest_state_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.20.1

