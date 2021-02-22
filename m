Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE5C3217EC
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 14:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhBVNDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 08:03:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57174 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231710AbhBVNCd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 08:02:33 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11MCu72w036763;
        Mon, 22 Feb 2021 08:01:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=/dx7gXr7W6eqWre/v+YmsB4pd9UnY7Jmi/X7eOln7b8=;
 b=h55ljubKKdfYhNkt4mJwr34dLqSmkrnBJ9Dym5S509Lam0z4FCWsLm6qGt4bVJa1CmxA
 pWUQQQ7acoiNQTI2CWk8Ws2KkhfXXk/OhsK5NI0HYQ4VsVy2gKfOUEfMg6y73iOzJHer
 dd84fA4/pcnlm0uuifagNrzkGH2cY6vbRcbySFSGa8FxC3LJZKLza2OmRJ3P4jVu/c6M
 x7SSx+QfmhSL2VLhlVwC5q92E9hEQePD3vwRTBQ5F/66Dimp7sBjot5g9ey25Ws8tWIn
 yytEiJgDyhvJhaSQVwvrwUAZ9gTV8nmw3ybhifRDZ7wswTgbiUn+c4+FG+Vt30MZHv48 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vd2288wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 08:01:50 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11MCvUqD060467;
        Mon, 22 Feb 2021 08:01:39 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vd2287ps-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 08:01:39 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11MCS4Ae017061;
        Mon, 22 Feb 2021 12:41:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 36tt289mjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 12:41:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11MCep3i26607876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 12:40:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D44E4AE04D;
        Mon, 22 Feb 2021 12:41:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BC05AE045;
        Mon, 22 Feb 2021 12:41:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.71.218])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Feb 2021 12:41:03 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, pmorel@linux.ibm.com
Subject: [PATCH v4 1/1] KVM: s390: diag9c (directed yield) forwarding
Date:   Mon, 22 Feb 2021 13:41:01 +0100
Message-Id: <1613997661-22525-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613997661-22525-1-git-send-email-pmorel@linux.ibm.com>
References: <1613997661-22525-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_02:2021-02-22,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 clxscore=1015 phishscore=0
 impostorscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102220115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we intercept a DIAG_9C from the guest we verify that the
target real CPU associated with the virtual CPU designated by
the guest is running and if not we forward the DIAG_9C to the
target real CPU.

To avoid a diag9c storm we allow a maximal rate of diag9c forwarding.

The rate is calculated as a count per second defined as a new
parameter of the s390 kvm module: diag9c_forwarding_hz .

The default value of 0 is to not forward diag9c.

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
index eaac4864d3d6..ca85f030eb0b 100644
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
+DIAGNOSE with function code 0x9c may improve system performance by
+yielding the host CPU on which the guest CPU is running to be assigned
+to another guest CPU, preferably the logical CPU containing the specified
+target CPU.
+
+
+DIAG 'X'9C forwarding
++++++++++++++++++++++
+
+The guest may send a DIAGNOSE 0x9c in order to yield to a certain
+other vcpu. An example is a Linux guest that tries to yield to the vcpu
+that is currently holding a spinlock, but not running.
+
+However, on the host the real cpu backing the vcpu may itself not be
+running.
+Forwarding the DIAGNOSE 0x9c initially sent by the guest to yield to
+the backing cpu will hopefully cause that cpu, and thus subsequently
+the guest's vcpu, to be scheduled.
+
+
+diag9c_forwarding_hz
+    KVM kernel parameter allowing to specify the maximum number of DIAGNOSE
+    0x9c forwarding per second in the purpose of avoiding a DIAGNOSE 0x9c
+    forwarding storm.
+    A value of 0 turns the forwarding off.
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
index 27c763014114..cecdecd33a58 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -422,6 +422,7 @@ void notrace smp_yield_cpu(int cpu)
 	asm volatile("diag %0,0,0x9c"
 		     : : "d" (pcpu_devices[cpu].address));
 }
+EXPORT_SYMBOL_GPL(smp_yield_cpu);
 
 /*
  * Send cpus emergency shutdown signal. This gives the cpus the
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 5b8ec1c447e1..02c146f9e5cd 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -150,6 +150,19 @@ static int __diag_time_slice_end(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int forward_cnt;
+static unsigned long cur_slice;
+
+static int diag9c_forwarding_overrun(void)
+{
+	/* Reset the count on a new slice */
+	if (time_after(jiffies, cur_slice)) {
+		cur_slice = jiffies;
+		forward_cnt = diag9c_forwarding_hz / HZ;
+	}
+	return forward_cnt-- <= 0 ? 1 : 0;
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
index 053ef36784e4..7b113d14ed7c 100644
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
+MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second, 0 to turn off");
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

