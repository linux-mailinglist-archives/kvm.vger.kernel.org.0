Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BBB3A3243
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 19:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhFJRjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 13:39:22 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:47746 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhFJRjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 13:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623346645; x=1654882645;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=bUcsS2klQa9+ToA72tCeg7KuKqu3JXMHtZvcZJcVyLc=;
  b=aMBA8Qdbgxk9rx5UW7apzOyb0JZgAgUoVuWWxOwvZzxLYpE0gD+WD7NF
   ie1EZdAXbiEh9IdvW8sxJyfQzsBcy+dnqqdeJpc7c66gMUr2312HGN2+C
   UwPyZH+RgwB0CFMfK3E3/WO2VjN0PR/q87y1SI6eoK8kdddxDyGDkmuce
   g=;
X-IronPort-AV: E=Sophos;i="5.83,264,1616457600"; 
   d="scan'208";a="139518281"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 10 Jun 2021 17:37:18 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id B2A8FA1C5B;
        Thu, 10 Jun 2021 17:37:16 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.55) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 17:37:12 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 2/3] x86: Move hyper-v hypercall related methods to lib/x86/
Date:   Thu, 10 Jun 2021 19:36:49 +0200
Message-ID: <61703b2ec0d9ded05d63dd6564460c81ce76fe11.1623346319.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1623346319.git.sidcha@amazon.de>
References: <cover.1623346319.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D36UWA001.ant.amazon.com (10.43.160.71) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some future tests that we are about to write need to perform hypercalls;
move do_hypercall() and hypercall page setup methods to a more
accessible location: libs/x86/hyperv.c.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 lib/x86/hyperv.h         |  4 +++
 lib/x86/hyperv.c         | 51 ++++++++++++++++++++++++++++++++++
 x86/hyperv_connections.c | 60 ++++------------------------------------
 3 files changed, 60 insertions(+), 55 deletions(-)

diff --git a/lib/x86/hyperv.h b/lib/x86/hyperv.h
index 38de0d2..889f5a6 100644
--- a/lib/x86/hyperv.h
+++ b/lib/x86/hyperv.h
@@ -213,4 +213,8 @@ struct hv_reference_tsc_page {
         int64_t tsc_offset;
 };
 
+void hv_setup_hypercall(void);
+void hv_teardown_hypercall(void);
+u64 hv_hypercall(u16 code, u64 arg, bool fast);
+
 #endif
diff --git a/lib/x86/hyperv.c b/lib/x86/hyperv.c
index 60f7645..e7c3351 100644
--- a/lib/x86/hyperv.c
+++ b/lib/x86/hyperv.c
@@ -1,6 +1,7 @@
 #include "hyperv.h"
 #include "asm/io.h"
 #include "smp.h"
+#include "alloc_page.h"
 
 enum {
     HV_TEST_DEV_SINT_ROUTE_CREATE = 1,
@@ -68,3 +69,53 @@ void evt_conn_destroy(u8 sint, u8 conn_id)
     sint_disable(sint);
     synic_ctl(HV_TEST_DEV_EVT_CONN_DESTROY, 0, 0, conn_id);
 }
+
+static void *hypercall_page;
+
+void hv_setup_hypercall(void)
+{
+	u64 guestid = (0x8f00ull << 48);
+
+	hypercall_page = alloc_page();
+	if (!hypercall_page)
+		report_abort("failed to allocate hypercall page");
+
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, guestid);
+
+	wrmsr(HV_X64_MSR_HYPERCALL,
+	      (u64)virt_to_phys(hypercall_page) | HV_X64_MSR_HYPERCALL_ENABLE);
+}
+
+void hv_teardown_hypercall(void)
+{
+	wrmsr(HV_X64_MSR_HYPERCALL, 0);
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, 0);
+	free_page(hypercall_page);
+}
+
+u64 hv_hypercall(u16 code, u64 arg, bool fast)
+{
+	u64 ret;
+	u64 ctl = code;
+	if (fast)
+		ctl |= HV_HYPERCALL_FAST;
+
+	asm volatile ("call *%[hcall_page]"
+#ifdef __x86_64__
+		      "\n mov $0,%%r8"
+		      : "=a"(ret)
+		      : "c"(ctl), "d"(arg),
+#else
+		      : "=A"(ret)
+		      : "A"(ctl),
+			"b" ((u32)(arg >> 32)), "c" ((u32)arg),
+			"D"(0), "S"(0),
+#endif
+		      [hcall_page] "m" (hypercall_page)
+#ifdef __x86_64__
+		      : "r8"
+#endif
+		     );
+
+	return ret;
+}
diff --git a/x86/hyperv_connections.c b/x86/hyperv_connections.c
index 6e8ac32..1650f01 100644
--- a/x86/hyperv_connections.c
+++ b/x86/hyperv_connections.c
@@ -38,56 +38,6 @@ static void sint_isr(isr_regs_t *regs)
 	atomic_inc(&hv_vcpus[smp_id()].sint_received);
 }
 
-static void *hypercall_page;
-
-static void setup_hypercall(void)
-{
-	u64 guestid = (0x8f00ull << 48);
-
-	hypercall_page = alloc_page();
-	if (!hypercall_page)
-		report_abort("failed to allocate hypercall page");
-
-	wrmsr(HV_X64_MSR_GUEST_OS_ID, guestid);
-
-	wrmsr(HV_X64_MSR_HYPERCALL,
-	      (u64)virt_to_phys(hypercall_page) | HV_X64_MSR_HYPERCALL_ENABLE);
-}
-
-static void teardown_hypercall(void)
-{
-	wrmsr(HV_X64_MSR_HYPERCALL, 0);
-	wrmsr(HV_X64_MSR_GUEST_OS_ID, 0);
-	free_page(hypercall_page);
-}
-
-static u64 do_hypercall(u16 code, u64 arg, bool fast)
-{
-	u64 ret;
-	u64 ctl = code;
-	if (fast)
-		ctl |= HV_HYPERCALL_FAST;
-
-	asm volatile ("call *%[hcall_page]"
-#ifdef __x86_64__
-		      "\n mov $0,%%r8"
-		      : "=a"(ret)
-		      : "c"(ctl), "d"(arg),
-#else
-		      : "=A"(ret)
-		      : "A"(ctl),
-			"b" ((u32)(arg >> 32)), "c" ((u32)arg),
-			"D"(0), "S"(0),
-#endif
-		      [hcall_page] "m" (hypercall_page)
-#ifdef __x86_64__
-		      : "r8"
-#endif
-		     );
-
-	return ret;
-}
-
 static void setup_cpu(void *ctx)
 {
 	int vcpu;
@@ -147,7 +97,7 @@ static void do_msg(void *ctx)
 
 	msg->payload[0]++;
 	atomic_set(&hv->sint_received, 0);
-	hv->hvcall_status = do_hypercall(HVCALL_POST_MESSAGE,
+	hv->hvcall_status = hv_hypercall(HVCALL_POST_MESSAGE,
 					 virt_to_phys(msg), 0);
 	atomic_inc(&ncpus_done);
 }
@@ -200,7 +150,7 @@ static void do_evt(void *ctx)
 	struct hv_vcpu *hv = &hv_vcpus[vcpu];
 
 	atomic_set(&hv->sint_received, 0);
-	hv->hvcall_status = do_hypercall(HVCALL_SIGNAL_EVENT,
+	hv->hvcall_status = hv_hypercall(HVCALL_SIGNAL_EVENT,
 					 hv->evt_conn, 1);
 	atomic_inc(&ncpus_done);
 }
@@ -279,9 +229,9 @@ int main(int ac, char **av)
 	handle_irq(MSG_VEC, sint_isr);
 	handle_irq(EVT_VEC, sint_isr);
 
-	setup_hypercall();
+	hv_setup_hypercall();
 
-	if (do_hypercall(HVCALL_SIGNAL_EVENT, 0x1234, 1) ==
+	if (hv_hypercall(HVCALL_SIGNAL_EVENT, 0x1234, 1) ==
 	    HV_STATUS_INVALID_HYPERCALL_CODE) {
 		report_skip("Hyper-V SynIC connections are not supported");
 		goto summary;
@@ -325,7 +275,7 @@ int main(int ac, char **av)
 	for (i = 0; i < ncpus; i++)
 		on_cpu(i, teardown_cpu, NULL);
 
-	teardown_hypercall();
+	hv_teardown_hypercall();
 
 summary:
 	return report_summary();
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



