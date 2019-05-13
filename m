Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA451B897
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbfEMOkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:40:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbfEMOkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:40:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd4le195008;
        Mon, 13 May 2019 14:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=k+F2ikPI91eVYLszQvHNmFnwWVR/o1Jhouj4HTjs9uc=;
 b=sPuRCB7AsbZZWT9m3DPio3N73cCl1qZSGvYcOtO5wcwsHy2zHWKroJG67uw/Upj6MB8h
 as5U+fXDw92G4CC+u+VRhy4iiGPx4okU0TKnt3mZX/RUGaqFhGWJu4ijIoE5Zs9d9SNL
 u//amNhRfak4bvPH2HOHsboCM+M+dxOBIVZGLn3TN6a2pmSvuViBD6jXP4r86MOGViz9
 jN0fBYhsPujDrb6O6Mzol1ztWZq7wn6RT/LFtqlQE5JCw2X/1/QkZ/0lzXFxFT78JDD8
 PNKqvAwiyWmQ5SmRKDUE6R4j7mSNKvwv3s4EEuyCXYkMX1kBdTCqgLL8P3W8I/5vm5L5 rw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2sdq1q7ata-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:04 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQ9022780;
        Mon, 13 May 2019 14:38:56 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 06/27] KVM: x86: Exit KVM isolation on IRQ entry
Date:   Mon, 13 May 2019 16:38:14 +0200
Message-Id: <1557758315-12667-7-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

Next commits will change most of KVM #VMExit handlers to run
in KVM isolated address space. Any interrupt handler raised
during execution in KVM address space needs to switch back
to host address space.

This patch makes sure that IRQ handlers will run in full
host address space instead of KVM isolated address space.

Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/apic.h    |    4 ++--
 arch/x86/include/asm/hardirq.h |   10 ++++++++++
 arch/x86/kernel/smp.c          |    2 +-
 arch/x86/platform/uv/tlb_uv.c  |    2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 130e81e..606da8f 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -515,7 +515,7 @@ static inline unsigned int read_apic_id(void)
 static inline void entering_irq(void)
 {
 	irq_enter();
-	kvm_set_cpu_l1tf_flush_l1d();
+	kvm_cpu_may_access_sensitive_data();
 }
 
 static inline void entering_ack_irq(void)
@@ -528,7 +528,7 @@ static inline void ipi_entering_ack_irq(void)
 {
 	irq_enter();
 	ack_APIC_irq();
-	kvm_set_cpu_l1tf_flush_l1d();
+	kvm_cpu_may_access_sensitive_data();
 }
 
 static inline void exiting_irq(void)
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index d9069bb..e082ecb 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -80,4 +80,14 @@ static inline bool kvm_get_cpu_l1tf_flush_l1d(void)
 static inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
 #endif /* IS_ENABLED(CONFIG_KVM_INTEL) */
 
+#ifdef CONFIG_HAVE_KVM
+extern void (*kvm_isolation_exit_handler)(void);
+
+static inline void kvm_cpu_may_access_sensitive_data(void)
+{
+	kvm_set_cpu_l1tf_flush_l1d();
+	kvm_isolation_exit_handler();
+}
+#endif
+
 #endif /* _ASM_X86_HARDIRQ_H */
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 04adc8d..b99fda0 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -261,7 +261,7 @@ __visible void __irq_entry smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
-	kvm_set_cpu_l1tf_flush_l1d();
+	kvm_cpu_may_access_sensitive_data();
 
 	if (trace_resched_ipi_enabled()) {
 		/*
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 1297e18..83a17ca 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1285,7 +1285,7 @@ void uv_bau_message_interrupt(struct pt_regs *regs)
 	struct msg_desc msgdesc;
 
 	ack_APIC_irq();
-	kvm_set_cpu_l1tf_flush_l1d();
+	kvm_cpu_may_access_sensitive_data();
 	time_start = get_cycles();
 
 	bcp = &per_cpu(bau_control, smp_processor_id());
-- 
1.7.1

