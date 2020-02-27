Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699601713C7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 10:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgB0JKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 04:10:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22082 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728624AbgB0JKn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Feb 2020 04:10:43 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01R9597I084018
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 04:10:42 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydxenx2gc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 04:10:41 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Thu, 27 Feb 2020 09:10:39 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 09:10:37 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01R99dVM50921732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 09:09:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E813A4040;
        Thu, 27 Feb 2020 09:10:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BB1CA4051;
        Thu, 27 Feb 2020 09:10:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 09:10:36 +0000 (GMT)
From:   Michael Mueller <mimu@linux.ibm.com>
To:     borntraeger@de.ibm.com, frankja@linux.vnet.ibm.com,
        mimu@linux.ibm.com
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, linux-s390@vger.kernel.org
Subject: [PATCH] KVM: s390: introduce module parameter kvm.use_gisa
Date:   Thu, 27 Feb 2020 10:10:31 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20022709-0028-0000-0000-000003DE6E4F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022709-0029-0000-0000-000024A38CE3
Message-Id: <20200227091031.102993-1-mimu@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_02:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The boolean module parameter "kvm.use_gisa" controls if newly
created guests will use the GISA facility if provided by the
host system. The default is yes.

  # cat /sys/module/kvm/parameters/use_gisa
  Y

The parameter can be changed on the fly.

  # echo N > /sys/module/kvm/parameters/use_gisa

Already running guests are not affected by this change.

The kvm s390 debug feature shows if a guest is running with GISA.

  # grep gisa /sys/kernel/debug/s390dbf/kvm-$pid/sprintf
  00 01582725059:843303 3 - 08 00000000e119bc01  gisa 0x00000000c9ac2642 initialized
  00 01582725059:903840 3 - 11 000000004391ee22  00[0000000000000000-0000000000000000]: AIV gisa format-1 enabled for cpu 000
  ...
  00 01582725059:916847 3 - 08 0000000094fff572  gisa 0x00000000c9ac2642 cleared

In general, that value should not be changed as the GISA facility
enhances interruption delivery performance.

A reason to switch the GISA facility off might be a performance
comparison run or debugging.

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d7ff30e45589..5c2081488024 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -184,6 +184,11 @@ static u8 halt_poll_max_steal = 10;
 module_param(halt_poll_max_steal, byte, 0644);
 MODULE_PARM_DESC(halt_poll_max_steal, "Maximum percentage of steal time to allow polling");
 
+/* if set to true, the GISA will be initialized and used if available */
+static bool use_gisa  = true;
+module_param(use_gisa, bool, 0644);
+MODULE_PARM_DESC(use_gisa, "Use the GISA if the host supports it.");
+
 /*
  * For now we handle at most 16 double words as this is what the s390 base
  * kernel handles and stores in the prefix page. If we ever need to go beyond
@@ -2504,7 +2509,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.use_skf = sclp.has_skey;
 	spin_lock_init(&kvm->arch.start_stop_lock);
 	kvm_s390_vsie_init(kvm);
-	kvm_s390_gisa_init(kvm);
+	if (use_gisa)
+		kvm_s390_gisa_init(kvm);
 	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
 
 	return 0;
-- 
2.17.1

