Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7794319B61
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 09:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhBLIk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 03:40:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61158 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230209AbhBLIk1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 03:40:27 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11C8Xxie145185;
        Fri, 12 Feb 2021 03:39:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=eEyyw/JG8dndF7Hy8KSpk/rjQK2Wmj2BTdpkw6D7exM=;
 b=iD2kheKr9WbZKRVRfCEj5xziF+HDckvk8nD+A8jkblKMPMxjzawMEPMxFkOiBCHzMrCJ
 g2TKeeX6RS/ULz1KdOH9n5MnmfrpM8fUZII/MeFMXE0aGQVUfu5Gy8SYX6oJsclHEYyD
 NI0NdVFb6l7P1jNbDcBY8EcNkXJQIItkzX4ChO+iDg1wSGhPHV2O6JXv1OdCZZWQAVzc
 lcqcgB/xbGHMK1750tLk/uzqgNMgI1oW2Z3DOepdTeFSgoWYTlxe4mZ5x2izUoO1e8sK
 DdNCPCBgcQkpSCRU3nbbmTc7Xu2rUAGnn3qpc8sB7to6a9EvGbaW/GDZ9+NwYUJH+DhU bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nnyfgk6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 03:39:44 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11C8YJ65147319;
        Fri, 12 Feb 2021 03:39:44 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nnyfgk5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 03:39:44 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11C8bDsS018646;
        Fri, 12 Feb 2021 08:39:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 36hjch3cp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 08:39:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11C8dSEu32964874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 08:39:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C62CA42041;
        Fri, 12 Feb 2021 08:39:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57B6842042;
        Fri, 12 Feb 2021 08:39:38 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.28.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Feb 2021 08:39:38 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, pmorel@linux.ibm.com
Subject: [PATCH v2 1/1] s390:kvm: diag9c forwarding
Date:   Fri, 12 Feb 2021 09:39:36 +0100
Message-Id: <1613119176-20864-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613119176-20864-1-git-send-email-pmorel@linux.ibm.com>
References: <1613119176-20864-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_02:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102120060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we receive intercept a DIAG_9C from the guest we verify
that the target real CPU associated with the virtual CPU
designated by the guest is running and if not we forward the
DIAG_9C to the target real CPU.

To avoid a diag9c storm we allow a maximal rate of diag9c forwarding.

The rate is calculated as a count per second defined as a
new parameter of the s390 kvm module: diag9c_forwarding_hz .

The default value is to not forward diag9c.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 Documentation/virt/kvm/s390-diag.rst | 33 ++++++++++++++++++++++++++++
 arch/s390/include/asm/kvm_host.h     |  1 +
 arch/s390/include/asm/smp.h          |  1 +
 arch/s390/kernel/smp.c               |  1 +
 arch/s390/kvm/diag.c                 | 31 +++++++++++++++++++++++---
 arch/s390/kvm/kvm-s390.c             |  6 +++++
 arch/s390/kvm/kvm-s390.h             |  8 +++++++
 7 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/s390-diag.rst b/Documentation/virt/kvm/s390-diag.rst
index eaac4864d3d6..a6371bc4ea90 100644
--- a/Documentation/virt/kvm/s390-diag.rst
+++ b/Documentation/virt/kvm/s390-diag.rst
@@ -84,3 +84,36 @@ If the function code specifies 0x501, breakpoint functions may be performed.
 This function code is handled by userspace.
 
 This diagnose function code has no subfunctions and uses no parameters.
+
+
+DIAGNOSE function code 'X'9C - Voluntary Time Slice Yield
+---------------------------------------------------------
+
+General register 1 contains the target CPU address.
+
+In a guest of a hypervisor like LPAR, KVM or z/VM using shared host CPUs,
+DIAGNOSE with function code 'X'9C may improve system performance by
+yielding the host CPU on which the guest CPU is running to be assigned
+to another guest CPU, preferably the logical CPU containing the specified
+target CPU.
+
+
+DIAG 'X'9C forwarding
++++++++++++++++++++++
+
+Under KVM, the guest operating system may send a DIAGNOSE code 'X'9C to
+the host when it fails to acquire a spinlock for a virtual CPU
+and detects that the host CPU on which the virtual guest CPU owner is
+assigned to is not running to try to get this host CPU running and
+consequently the guest virtual CPU running and freeing the lock.
+
+However, on the logical partition the real CPU on which the previously
+targeted host CPU is assign may itself not be running.
+By forwarding the DIAGNOSE code 'X'9C, initially sent by the guest,
+from the host to LPAR hypervisor, this one will hopefully schedule
+the host CPU which will let KVM run the target guest CPU.
+
+diag9c_forwarding_hz
+    KVM kernel parameter allowing to specify the maximum number of DIAGNOSE
+    'X'9C forwarding per second in the purpose of avoiding a DIAGNOSE 'X'9C
+    forwarding storm.
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 527776a1f076..cb19508c22fb 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -456,6 +456,7 @@ struct kvm_vcpu_stat {
 	u64 diagnose_44;
 	u64 diagnose_9c;
 	u64 diagnose_9c_ignored;
+	u64 diagnose_9c_forward;
 	u64 diagnose_258;
 	u64 diagnose_308;
 	u64 diagnose_500;
diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
index 01e360004481..e317fd4866c1 100644
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -63,5 +63,6 @@ extern void __noreturn cpu_die(void);
 extern void __cpu_die(unsigned int cpu);
 extern int __cpu_disable(void);
 extern void schedule_mcck_handler(void);
+void notrace smp_yield_cpu(int cpu);
 
 #endif /* __ASM_SMP_H */
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 27c763014114..15e207a671fd 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -422,6 +422,7 @@ void notrace smp_yield_cpu(int cpu)
 	asm volatile("diag %0,0,0x9c"
 		     : : "d" (pcpu_devices[cpu].address));
 }
+EXPORT_SYMBOL(smp_yield_cpu);
 
 /*
  * Send cpus emergency shutdown signal. This gives the cpus the
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 5b8ec1c447e1..34cf41fa6fa2 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -150,6 +150,19 @@ static int __diag_time_slice_end(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static unsigned int forward_cnt;
+static unsigned long cur_slice;
+
+static int diag9c_forwarding_overrun(void)
+{
+	/* Reset the count on a new slice */
+	if (time_after(jiffies, cur_slice)) {
+		cur_slice = jiffies;
+		forward_cnt = diag9c_forwarding_hz / HZ;
+	}
+	return forward_cnt-- ? 1 : 0;
+}
+
 static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu *tcpu;
@@ -167,9 +180,21 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 	if (!tcpu)
 		goto no_yield;
 
-	/* target already running */
-	if (READ_ONCE(tcpu->cpu) >= 0)
-		goto no_yield;
+	/* target guest VCPU already running */
+	if (READ_ONCE(tcpu->cpu) >= 0) {
+		if (!diag9c_forwarding_hz || diag9c_forwarding_overrun())
+			goto no_yield;
+
+		/* target host CPU already running */
+		if (!vcpu_is_preempted(tcpu->cpu))
+			goto no_yield;
+		smp_yield_cpu(tcpu->cpu);
+		VCPU_EVENT(vcpu, 5,
+			   "diag time slice end directed to %d: yield forwarded",
+			   tid);
+		vcpu->stat.diagnose_9c_forward++;
+		return 0;
+	}
 
 	if (kvm_vcpu_yield_to(tcpu) <= 0)
 		goto no_yield;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 053ef36784e4..c23e22610a89 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -157,6 +157,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("instruction_diag_44", diagnose_44),
 	VCPU_STAT("instruction_diag_9c", diagnose_9c),
 	VCPU_STAT("diag_9c_ignored", diagnose_9c_ignored),
+	VCPU_STAT("diag_9c_forward", diagnose_9c_forward),
 	VCPU_STAT("instruction_diag_258", diagnose_258),
 	VCPU_STAT("instruction_diag_308", diagnose_308),
 	VCPU_STAT("instruction_diag_500", diagnose_500),
@@ -190,6 +191,11 @@ static bool use_gisa  = true;
 module_param(use_gisa, bool, 0644);
 MODULE_PARM_DESC(use_gisa, "Use the GISA if the host supports it.");
 
+/* maximum diag9c forwarding per second */
+unsigned int diag9c_forwarding_hz;
+module_param(diag9c_forwarding_hz, uint, 0644);
+MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second");
+
 /*
  * For now we handle at most 16 double words as this is what the s390 base
  * kernel handles and stores in the prefix page. If we ever need to go beyond
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 79dcd647b378..9fad25109b0d 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -471,4 +471,12 @@ void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
  * @kvm: the KVM guest
  */
 void kvm_s390_vcpu_crypto_reset_all(struct kvm *kvm);
+
+/**
+ * diag9c_forwarding_hz
+ *
+ * Set the maximum number of diag9c forwarding per second
+ */
+extern unsigned int diag9c_forwarding_hz;
+
 #endif
-- 
2.17.1

