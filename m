Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B063A326606
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 18:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhBZRDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 12:03:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229598AbhBZRDw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 12:03:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614358945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=g3BvVTqRZcHNF2bumxV68Pob+1+419O+zr+luXDJ/Hw=;
        b=Lti730L46J4eckU8bFO0nzJD0/hJ+tR9WKPp2KOCKmiSYuadjGKP6ksA+0qL/9mDgSmwjj
        ofINtrMNhCdH53CYoHA/RyRyYTQJ2zCMXfimeDijk+dLJcoN/a+gdqXVsJsVEa8NzoTJmz
        EM9wFuOSngSF5rQsa8a5VYZS/Ab1xNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-3BbK47cxMPiVi7l1ogcxdQ-1; Fri, 26 Feb 2021 12:02:23 -0500
X-MC-Unique: 3BbK47cxMPiVi7l1ogcxdQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDC081005501
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 17:02:22 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99E0560875
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 17:02:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] KVM: svm: add a test to observe the gain from clean bits
Date:   Fri, 26 Feb 2021 12:02:22 -0500
Message-Id: <20210226170222.227577-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm.h       | 24 +++++++++++++++++++++---
 x86/svm_tests.c |  9 +++++++++
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index a0863b8..593e3b0 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -51,6 +51,22 @@ enum {
 	INTERCEPT_MWAIT_COND,
 };
 
+enum {
+        VMCB_CLEAN_INTERCEPTS = 1, /* Intercept vectors, TSC offset, pause filter count */
+        VMCB_CLEAN_PERM_MAP = 2,   /* IOPM Base and MSRPM Base */
+        VMCB_CLEAN_ASID = 4,       /* ASID */
+        VMCB_CLEAN_INTR = 8,       /* int_ctl, int_vector */
+        VMCB_CLEAN_NPT = 16,       /* npt_en, nCR3, gPAT */
+        VMCB_CLEAN_CR = 32,        /* CR0, CR3, CR4, EFER */
+        VMCB_CLEAN_DR = 64,        /* DR6, DR7 */
+        VMCB_CLEAN_DT = 128,       /* GDT, IDT */
+        VMCB_CLEAN_SEG = 256,      /* CS, DS, SS, ES, CPL */
+        VMCB_CLEAN_CR2 = 512,      /* CR2 only */
+        VMCB_CLEAN_LBR = 1024,     /* DBGCTL, BR_FROM, BR_TO, LAST_EX_FROM, LAST_EX_TO */
+        VMCB_CLEAN_AVIC = 2048,    /* APIC_BAR, APIC_BACKING_PAGE,
+				      PHYSICAL_TABLE pointer, LOGICAL_TABLE pointer */
+        VMCB_CLEAN_ALL = 4095,
+};
 
 struct __attribute__ ((__packed__)) vmcb_control_area {
 	u16 intercept_cr_read;
@@ -83,12 +99,14 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 event_inj_err;
 	u64 nested_cr3;
 	u64 lbr_ctl;
-	u64 reserved_5;
+	u32 clean;
+	u32 reserved_5;
 	u64 next_rip;
-	u8 reserved_6[816];
+	u8 insn_len;
+	u8 insn_bytes[15];
+	u8 reserved_6[800];
 };
 
-
 #define TLB_CONTROL_DO_NOTHING 0
 #define TLB_CONTROL_FLUSH_ALL_ASID 1
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..8b6fbd5 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1020,6 +1020,12 @@ static bool latency_finished(struct svm_test *test)
     return runs == 0;
 }
 
+static bool latency_finished_clean(struct svm_test *test)
+{
+    vmcb->control.clean = VMCB_CLEAN_ALL;
+    return latency_finished(test);
+}
+
 static bool latency_check(struct svm_test *test)
 {
     printf("    Latency VMRUN : max: %ld min: %ld avg: %ld\n", latvmrun_max,
@@ -2458,6 +2464,9 @@ struct svm_test svm_tests[] = {
     { "latency_run_exit", default_supported, latency_prepare,
       default_prepare_gif_clear, latency_test,
       latency_finished, latency_check },
+    { "latency_run_exit_clean", default_supported, latency_prepare,
+      default_prepare_gif_clear, latency_test,
+      latency_finished_clean, latency_check },
     { "latency_svm_insn", default_supported, lat_svm_insn_prepare,
       default_prepare_gif_clear, null_test,
       lat_svm_insn_finished, lat_svm_insn_check },
-- 
2.26.2

