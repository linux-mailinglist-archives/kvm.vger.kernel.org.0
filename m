Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5BD5FA098
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 16:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJJOzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 10:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJJOyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 10:54:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4D315A2B;
        Mon, 10 Oct 2022 07:54:50 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29AEb4p6020862;
        Mon, 10 Oct 2022 14:54:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Fw1EeZZCG3hmuEnYz7y/mq2bjIcoWc77Hzpd462bULQ=;
 b=EPmJRZhnLe/dmZaQ47NRquFvqgR9UzGK26MGyeulTaduKzUAF6j0Tk3aTAG8f/RJkzq3
 6VGq1sjrgSytHnMeB/zBGCUgrJ/jIXui7NUln2VOpRyk7MQQ08kI7U3Vt+6syGPGsZli
 YQ09gypnrwXS6Th0FBZ3o2MQwqjsxS4d4OglQaAxYdZEcTkxF/MP5mxdFggIQdYc6h6c
 H0M7J90JMGhY1tC8nlM1J65xIqEeK7LAXdRcLTgtOPrXGWk/y/FzOIdieeQNeoiMBe/P
 qL/43higb2dA45oqczodOwO9uoFlFwp+Tc2mRoAUi9Ut6hRKdJfzKikl2Ha1YZ9rqeBA XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3jhbfatf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 14:54:50 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29AEeIfE031739;
        Mon, 10 Oct 2022 14:54:49 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3jhbfasf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 14:54:49 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29AEolBm013831;
        Mon, 10 Oct 2022 14:54:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3k30u92xsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 14:54:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29AEsid847972640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 14:54:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2744D5204F;
        Mon, 10 Oct 2022 14:54:44 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.242])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CF98752051;
        Mon, 10 Oct 2022 14:54:43 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v15 3/6] KVM: s390: pv: add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
Date:   Mon, 10 Oct 2022 16:54:39 +0200
Message-Id: <20221010145442.85867-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221010145442.85867-1-imbrenda@linux.ibm.com>
References: <20221010145442.85867-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UzsRAJ8KbDu2Ajt-0KVIrYOjxCgYHUCR
X-Proofpoint-ORIG-GUID: t02m07GG-0ph7NCEiFS7vU8-m9PA1xdg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-10_08,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=714
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE to signal that the
KVM_PV_ASYNC_DISABLE and KVM_PV_ASYNC_DISABLE_PREPARE commands for the
KVM_S390_PV_COMMAND ioctl are available.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 3 +++
 include/uapi/linux/kvm.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1affbf0782bb..372230b92448 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -618,6 +618,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_BPB:
 		r = test_facility(82);
 		break;
+	case KVM_CAP_S390_PROTECTED_ASYNC_DISABLE:
+		r = async_destroy && is_prot_virt_host();
+		break;
 	case KVM_CAP_S390_PROTECTED:
 		r = is_prot_virt_host();
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 02602c5c1975..9afe0084b2c5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
+#define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 225
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.37.3

