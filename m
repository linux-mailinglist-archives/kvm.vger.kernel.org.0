Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CD335CAC4
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 18:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243251AbhDLQGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 12:06:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51870 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241288AbhDLQGM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 12:06:12 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CG5OGM194513;
        Mon, 12 Apr 2021 12:05:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=ZuKDLumTyKHfZJyiqUZafWtRtnulfOPR4HOhFYIEpVw=;
 b=FnANR6G+CskeqsgxKVXTB/+RyAx0LXWtM4Uzhbszjw0J/bo7hsJmSueRGy9XQ+YQXdpv
 dKfgFtJ4W8wCreDCGAKPg9zKIy1b2wATEz4NdhaSaQn37AzK9kH4YWJAN6U7qaxrBx3C
 xs32hCBqe1bejeWUSfTHIDJQx5ILS8FaqxOqgxibPGAHCtCoSBRVFxKDEht14RYLz2cW
 EHnenviJyoO/nhMkJ5gMNtUOmWIxZpE+lR5tvrHq4WESkj9ovbrCodQ9iQRbvlrxahrB
 qToGxBdzOM2aRnHGddKZflpr2EdjPEC0+8vSZjiZkCl9vQTXNU9vSHrTUIAZ7nmv3QTA uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37usjb9nha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:52 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CG5i6b196091;
        Mon, 12 Apr 2021 12:05:52 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37usjb9ngj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:52 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CFrQ6k019419;
        Mon, 12 Apr 2021 16:05:50 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 37u3n891ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 16:05:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CG5P5j35914172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:05:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C61F42041;
        Mon, 12 Apr 2021 16:05:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4A2B42045;
        Mon, 12 Apr 2021 16:05:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 12 Apr 2021 16:05:46 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 9972EE0393; Mon, 12 Apr 2021 18:05:46 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 2/7] KVM: s390: diag9c (directed yield) forwarding
Date:   Mon, 12 Apr 2021 18:05:40 +0200
Message-Id: <20210412160545.231194-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412160545.231194-1-borntraeger@de.ibm.com>
References: <20210412160545.231194-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6dRVtax5tlcW6K4nBohhAlfEvGE1Z9Mv
X-Proofpoint-GUID: TvzTwAzpLnU6SU5VHTlhAT2yEIo71un3
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

When we intercept a DIAG_9C from the guest we verify that the
target real CPU associated with the virtual CPU designated by
the guest is running and if not we forward the DIAG_9C to the
target real CPU.

To avoid a diag9c storm we allow a maximal rate of diag9c forwarding.

The rate is calculated as a count per second defined as a new
parameter of the s390 kvm module: diag9c_forwarding_hz .

The default value of 0 is to not forward diag9c.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Link: https://lore.kernel.org/r/1613997661-22525-2-git-send-email-pmorel@linux.ibm.com
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
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
index 6bcfc5614bbc..0af3e032a49d 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -454,6 +454,7 @@ struct kvm_vcpu_stat {
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
index 58c8afa3da65..2fec2b80d35d 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -429,6 +429,7 @@ void notrace smp_yield_cpu(int cpu)
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
index 333193982e51..cfe720d16a6a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -158,6 +158,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("instruction_diag_44", diagnose_44),
 	VCPU_STAT("instruction_diag_9c", diagnose_9c),
 	VCPU_STAT("diag_9c_ignored", diagnose_9c_ignored),
+	VCPU_STAT("diag_9c_forward", diagnose_9c_forward),
 	VCPU_STAT("instruction_diag_258", diagnose_258),
 	VCPU_STAT("instruction_diag_308", diagnose_308),
 	VCPU_STAT("instruction_diag_500", diagnose_500),
@@ -185,6 +186,11 @@ static bool use_gisa  = true;
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
2.30.2

