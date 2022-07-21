Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6415B57D120
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbiGUQO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbiGUQOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:14:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F98887F62;
        Thu, 21 Jul 2022 09:13:56 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFFRlR020377;
        Thu, 21 Jul 2022 16:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=pxZnktUo93ICyM0i3XmQXaEdKmO/c5s4a3zy3Da/D/I=;
 b=rS7I7XEPppmpQlQnd3SJDrkDTo3hm2ZzsFZ5qAHKfSzniS6JncdfhhsU3eHDoINcbh2V
 k+YRAKtZUIS+OGWeMEmvYjuaRSh42MmzRz8EY0khuKVPgN7HB2hTpGVWpTvzTW0pKmVF
 kL1R2PG9VfbXqdrkaak7h98Cjmjsm7ZYlYJGXNl+K9PlwWosN78KSU8SpwsxxBLofleI
 Hyj+DboRh8PUZzRLnu27e9E9KCKNRsCwLMtAGiXbZy8TQREu8gWBRtUeBgSzauPR9ouF
 F//hjpPMvCg20ii94w3qIkz0r5shXfP14o5SX9WvpeladeqwYbsNq6+CwqYIZXY8OCH3 UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8f2m3mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:30 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFFesV022550;
        Thu, 21 Jul 2022 16:13:30 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8f2m3jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:30 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG8NPw019513;
        Thu, 21 Jul 2022 16:13:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8nexy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDbaT18874650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C485A405B;
        Thu, 21 Jul 2022 16:13:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24A24A4054;
        Thu, 21 Jul 2022 16:13:24 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:24 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
Subject: [GIT PULL 33/42] KVM: s390: pv: clear the state without memset
Date:   Thu, 21 Jul 2022 18:12:53 +0200
Message-Id: <20220721161302.156182-34-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NQ59bxBKD-af6sYV70YDAZF2Tli6cukJ
X-Proofpoint-GUID: iuw7ymIOf9leZhajHJTuzr0uvnNRT3pE
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=856 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not use memset to clean the whole struct kvm_s390_pv; instead,
explicitly clear the fields that need to be cleared.

Upcoming patches will introduce new fields in the struct kvm_s390_pv
that will not need to be cleared.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220628135619.32410-8-imbrenda@linux.ibm.com
Message-Id: <20220628135619.32410-8-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 59e0d5399113..d18c5ccfa5dc 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -17,6 +17,14 @@
 #include <linux/sched/mm.h>
 #include "kvm-s390.h"
 
+static void kvm_s390_clear_pv_state(struct kvm *kvm)
+{
+	kvm->arch.pv.handle = 0;
+	kvm->arch.pv.guest_len = 0;
+	kvm->arch.pv.stor_base = 0;
+	kvm->arch.pv.stor_var = NULL;
+}
+
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 {
 	int cc;
@@ -111,7 +119,7 @@ static void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
 	vfree(kvm->arch.pv.stor_var);
 	free_pages(kvm->arch.pv.stor_base,
 		   get_order(uv_info.guest_base_stor_len));
-	memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
+	kvm_s390_clear_pv_state(kvm);
 }
 
 static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
-- 
2.36.1

