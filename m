Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914D87857F6
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 14:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbjHWMmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 08:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbjHWMmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 08:42:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFAFE45;
        Wed, 23 Aug 2023 05:42:06 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37NCTqCX032517;
        Wed, 23 Aug 2023 12:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=HgdAm3/Pz8P6vhOfEhfyu6nnLd0x1EVq+srZg4Khlu4=;
 b=H6fHKSgB5wqnzJVn4vcOPwkRMW13PbBzchERDCXRasXJtxGhGv4/3VXA6bfmQiC2D1Qe
 6zVsGCS0f3QIWTNy7tMkJvlUU5ZdxMgr4Doa/gDFkVHfmTPJxONR2gNyS0T1ipdngJ9P
 VM2DzHVIiEzToK+xDN1EwCjwfArlXWDGFIRfdPdC2+aw2MC/fgkl/j6iXhxHCD/RuzNI
 Os/NyAtP+Xu4DAhZGzNm/mgoT/AsV2orKuxO03In+Imgj2L61clCbzNagG/qjSG2UDMv
 nuwh3q5SQ+jgwHENeOiIcmHnwJK0oTvbKaJvlXjXv4+buaO8Pbqh7JaLO25wQZV+KrA0 CQ== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3snj040g32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 12:42:06 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37NC97rE027333;
        Wed, 23 Aug 2023 12:42:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn20sebk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 12:42:04 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37NCg1es18678294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Aug 2023 12:42:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F9E32004E;
        Wed, 23 Aug 2023 12:42:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E8EE20040;
        Wed, 23 Aug 2023 12:42:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 23 Aug 2023 12:42:00 +0000 (GMT)
From:   Michael Mueller <mimu@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [PATCH] KVM: s390: fix gisa destroy operation might lead to cpu stalls
Date:   Wed, 23 Aug 2023 14:41:40 +0200
Message-Id: <20230823124140.3839373-1-mimu@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0RXvBsQz4WzYMNQF0hThdGPBngPknwbv
X-Proofpoint-ORIG-GUID: 0RXvBsQz4WzYMNQF0hThdGPBngPknwbv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-23_06,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 clxscore=1015 bulkscore=0 adultscore=0 malwarescore=0
 mlxlogscore=669 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308230115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A GISA cannot be destroyed as long it is linked in the GIB alert list
as this would breake the alert list. Just waiting for its removal from
the list triggered by another vm is not sufficient as it might be the
only vm. The below shown cpu stall situation might occur when GIB alerts
are delayed and is fixed by calling process_gib_alert_list() instead of
waiting. At this time the vcpus of the vm are already destroyed and thus
no vcpu can be kicked to enter the SIE again if for some reason an
interrupt is pending for that vm.

The situation can now be observed in the kvm-trace:

 00 01692784587:752383 3 - 0014 000003ff80165b58  vm 0x000000008a880000 created by pid 1462
 00 01692784634:287555 3 - 0007 000003ff80172c14  vm 0x000000008a880000 gisa in alert list during destroy
 00 01692784634:322955 3 - 0002 000003ff8016219a  vm 0x000000008a880000 destroyed

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
 arch/s390/kvm/interrupt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 9bd0a873f3b1..73153bea6c24 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3205,8 +3205,10 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
 	if (gi->alert.mask)
 		KVM_EVENT(3, "vm 0x%pK has unexpected iam 0x%02x",
 			  kvm, gi->alert.mask);
-	while (gisa_in_alert_list(gi->origin))
-		cpu_relax();
+	while (gisa_in_alert_list(gi->origin)) {
+		KVM_EVENT(3, "vm 0x%pK gisa in alert list during destroy", kvm);
+		process_gib_alert_list();
+	}
 	hrtimer_cancel(&gi->timer);
 	gi->origin = NULL;
 	VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
-- 
2.39.2

