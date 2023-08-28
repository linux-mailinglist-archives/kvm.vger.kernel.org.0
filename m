Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11B778B433
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 17:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjH1PQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 11:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbjH1PPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 11:15:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE4E1B1;
        Mon, 28 Aug 2023 08:15:33 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37SFCElP032262;
        Mon, 28 Aug 2023 15:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=a9zW4y6wX+Vjd4cyRYYup7zG8XHC/V5PSyLZbrCMtp4=;
 b=Xp5YyjDHLeiM6N+cmcS5cdpEE4fCu4hXk9mueZxxhZhTYZ76fMZhEEt4GPXcrG5sHXe5
 Vd0Nz35K0qyOB/wf4OHOpTqCrkr0i1JiOj/dX6QUKPeI5J62DeoQWygQ20wjTmoBHAey
 9saGgCh7MyZhGLF3J5C5qTxO7J308NG7806DwMcUikucfmwNRgd5PVM4Xbk3xG3QQtfV
 VjwpN4WXPwEK2BU0D1/Ar7PjlTog+RQiSbhqdRhvi0rDdyecHTiqzuxiBH1TF1Roa8xP
 ZdGqEkpHrs3d0d48bHEKZPW7b/ZOtmScTYmWeofi86h3h26zdKY4Z3GVdfVMTjdVonco WA== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sr8q797vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Aug 2023 15:15:31 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37SEpmME004888;
        Mon, 28 Aug 2023 15:15:31 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3squqscfh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Aug 2023 15:15:31 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37SFFSJo58327298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Aug 2023 15:15:28 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F23F22004B;
        Mon, 28 Aug 2023 15:15:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A5D820040;
        Mon, 28 Aug 2023 15:15:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 28 Aug 2023 15:15:27 +0000 (GMT)
From:   Michael Mueller <mimu@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [PATCH v3] KVM: s390: fix gisa destroy operation might lead to cpu stalls
Date:   Mon, 28 Aug 2023 17:15:19 +0200
Message-Id: <20230828151519.2187418-1-mimu@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zUj5h_lKi6ydOdfuzzWmMUct5Xfc099e
X-Proofpoint-ORIG-GUID: zUj5h_lKi6ydOdfuzzWmMUct5Xfc099e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-28_12,2023-08-28_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=816 suspectscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308280132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 arch/s390/kvm/interrupt.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 85e39f472bb4..75e200bd1030 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3216,11 +3216,12 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
 
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
2.39.2

