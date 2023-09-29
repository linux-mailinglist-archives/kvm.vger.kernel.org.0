Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8AB7B3761
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 17:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbjI2P5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 11:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbjI2P5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 11:57:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C401B1;
        Fri, 29 Sep 2023 08:57:28 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38TFqlFD005235;
        Fri, 29 Sep 2023 15:57:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=oFacZOwOoY+LYBCFwIGVQ2DczoB89O2NEgGXDXHXHEw=;
 b=jaLf//oVIUj3oJJQtjCctc2T1FG/KCU0qQRy5Lj7uBK+Hul1yWeZ9ZWot5MNyitkdUVw
 f9aycGyqx1HJlT5vea7KAcZaY7bo7YhXfYzA3UnW2dD3uPZ6/6Zwop88LlRnlubteun7
 FyWrITIlSNE4Coat5j6da5NTbiISu/dP5NxZug2wE7e/oGeRrhFvGGaFzhefvYTn7lQT
 Gt9TK3g5bkaGnnUvaHzrbD/uuH6XodB4/QJa344yqRznfJbsYihxh+bMM4FOqjbfLhqa
 kLJxjzFlTryLJta25b7dquNIdaeReMhWMz6IvXrbfrf12RU+Mgw64Jsky/6ACCZ0QHJs 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3te1kxr2q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Sep 2023 15:57:27 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38TFuB3w023474;
        Fri, 29 Sep 2023 15:57:27 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3te1kxr2fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Sep 2023 15:57:27 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38TFBfdw008130;
        Fri, 29 Sep 2023 15:57:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3taar05ym9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Sep 2023 15:57:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38TFv6D964356812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 15:57:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B231420049;
        Fri, 29 Sep 2023 15:57:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96F7A2004D;
        Fri, 29 Sep 2023 15:57:06 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 29 Sep 2023 15:57:06 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [GIT PULL 1/1] KVM: s390: fix gisa destroy operation might lead to cpu stalls
Date:   Fri, 29 Sep 2023 17:57:06 +0200
Message-ID: <20230929155706.81033-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230929155706.81033-1-imbrenda@linux.ibm.com>
References: <20230929155706.81033-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: T8PMJ5F0jrCAxncZ31aW-v4a84Lml5Qd
X-Proofpoint-GUID: nQNi4ttSNWP0rHR5eytZT8SvYKP21Owa
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_13,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=990 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309290134
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Mueller <mimu@linux.ibm.com>

A GISA cannot be destroyed as long it is linked in the GIB alert list
as this would break the alert list. Just waiting for its removal from
the list triggered by another vm is not sufficient as it might be the
only vm. The below shown cpu stall situation might occur when GIB alerts
are delayed and is fixed by calling process_gib_alert_list() instead of
waiting.

At this time the vcpus of the vm are already destroyed and thus
no vcpu can be kicked to enter the SIE again if for some reason an
interrupt is pending for that vm.

Additionally the IAM restore value is set to 0x00. That would be a bug
introduced by incomplete device de-registration, i.e. missing
kvm_s390_gisc_unregister() call.

Setting this value and the IAM in the GISA to 0x00 guarantees that late
interrupts don't bring the GISA back into the alert list.

CPU stall caused by kvm_s390_gisa_destroy():

 [ 4915.311372] rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: { 14-.... } 24533 jiffies s: 5269 root: 0x1/.
 [ 4915.311390] rcu: blocking rcu_node structures (internal RCU debug): l=1:0-15:0x4000/.
 [ 4915.311394] Task dump for CPU 14:
 [ 4915.311395] task:qemu-system-s39 state:R  running task     stack:0     pid:217198 ppid:1      flags:0x00000045
 [ 4915.311399] Call Trace:
 [ 4915.311401]  [<0000038003a33a10>] 0x38003a33a10
 [ 4933.861321] rcu: INFO: rcu_sched self-detected stall on CPU
 [ 4933.861332] rcu: 	14-....: (42008 ticks this GP) idle=53f4/1/0x4000000000000000 softirq=61530/61530 fqs=14031
 [ 4933.861353] rcu: 	(t=42008 jiffies g=238109 q=100360 ncpus=18)
 [ 4933.861357] CPU: 14 PID: 217198 Comm: qemu-system-s39 Not tainted 6.5.0-20230816.rc6.git26.a9d17c5d8813.300.fc38.s390x #1
 [ 4933.861360] Hardware name: IBM 8561 T01 703 (LPAR)
 [ 4933.861361] Krnl PSW : 0704e00180000000 000003ff804bfc66 (kvm_s390_gisa_destroy+0x3e/0xe0 [kvm])
 [ 4933.861414]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
 [ 4933.861416] Krnl GPRS: 0000000000000000 00000372000000fc 00000002134f8000 000000000d5f5900
 [ 4933.861419]            00000002f5ea1d18 00000002f5ea1d18 0000000000000000 0000000000000000
 [ 4933.861420]            00000002134fa890 00000002134f8958 000000000d5f5900 00000002134f8000
 [ 4933.861422]            000003ffa06acf98 000003ffa06858b0 0000038003a33c20 0000038003a33bc8
 [ 4933.861430] Krnl Code: 000003ff804bfc58: ec66002b007e	cij	%r6,0,6,000003ff804bfcae
                           000003ff804bfc5e: b904003a		lgr	%r3,%r10
                          #000003ff804bfc62: a7f40005		brc	15,000003ff804bfc6c
                          >000003ff804bfc66: e330b7300204	lg	%r3,10032(%r11)
                           000003ff804bfc6c: 58003000		l	%r0,0(%r3)
                           000003ff804bfc70: ec03fffb6076	crj	%r0,%r3,6,000003ff804bfc66
                           000003ff804bfc76: e320b7600271	lay	%r2,10080(%r11)
                           000003ff804bfc7c: c0e5fffea339	brasl	%r14,000003ff804942ee
 [ 4933.861444] Call Trace:
 [ 4933.861445]  [<000003ff804bfc66>] kvm_s390_gisa_destroy+0x3e/0xe0 [kvm]
 [ 4933.861460] ([<00000002623523de>] free_unref_page+0xee/0x148)
 [ 4933.861507]  [<000003ff804aea98>] kvm_arch_destroy_vm+0x50/0x120 [kvm]
 [ 4933.861521]  [<000003ff8049d374>] kvm_destroy_vm+0x174/0x288 [kvm]
 [ 4933.861532]  [<000003ff8049d4fe>] kvm_vm_release+0x36/0x48 [kvm]
 [ 4933.861542]  [<00000002623cd04a>] __fput+0xea/0x2a8
 [ 4933.861547]  [<00000002620d5bf8>] task_work_run+0x88/0xf0
 [ 4933.861551]  [<00000002620b0aa6>] do_exit+0x2c6/0x528
 [ 4933.861556]  [<00000002620b0f00>] do_group_exit+0x40/0xb8
 [ 4933.861557]  [<00000002620b0fa6>] __s390x_sys_exit_group+0x2e/0x30
 [ 4933.861559]  [<0000000262d481f4>] __do_syscall+0x1d4/0x200
 [ 4933.861563]  [<0000000262d59028>] system_call+0x70/0x98
 [ 4933.861565] Last Breaking-Event-Address:
 [ 4933.861566]  [<0000038003a33b60>] 0x38003a33b60

Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230901105823.3973928-1-mimu@linux.ibm.com
Message-ID: <20230901105823.3973928-1-mimu@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index c1b47d608a2b..efaebba5ee19 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -303,11 +303,6 @@ static inline u8 gisa_get_ipm_or_restore_iam(struct kvm_s390_gisa_interrupt *gi)
 	return 0;
 }
 
-static inline int gisa_in_alert_list(struct kvm_s390_gisa *gisa)
-{
-	return READ_ONCE(gisa->next_alert) != (u32)virt_to_phys(gisa);
-}
-
 static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
 {
 	set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
@@ -3216,11 +3211,12 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
 
 	if (!gi->origin)
 		return;
-	if (gi->alert.mask)
-		KVM_EVENT(3, "vm 0x%pK has unexpected iam 0x%02x",
-			  kvm, gi->alert.mask);
-	while (gisa_in_alert_list(gi->origin))
-		cpu_relax();
+	WARN(gi->alert.mask != 0x00,
+	     "unexpected non zero alert.mask 0x%02x",
+	     gi->alert.mask);
+	gi->alert.mask = 0x00;
+	if (gisa_set_iam(gi->origin, gi->alert.mask))
+		process_gib_alert_list();
 	hrtimer_cancel(&gi->timer);
 	gi->origin = NULL;
 	VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
-- 
2.41.0

