Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8614B53C55C
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 08:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241814AbiFCG6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 02:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241801AbiFCG5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 02:57:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B8625E9;
        Thu,  2 Jun 2022 23:56:59 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2536DSMJ018923;
        Fri, 3 Jun 2022 06:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZM0EGnTr0HshCLiG2MtObM/Hg+qtXcKnlMVm315EyL0=;
 b=OawcnlEHNX05uSJXWJ0/0SFioLQQVqtsYbDzf3fSJLuC7Bitv4jzep+q2G2XbM5GJfAG
 BNvqeH64fUn34XwygWsb3oO1WxRKGOrkFgC5gP4xXcRjw98NsPt9EkYUIh8WqWbJYQJZ
 xhBTGX64Zyq3BAu7aL8U4xBxTKJlpLtrFn2PTdlmPwwRDMVMl/PpM53Bo9+GRvdYchqI
 t1XFk6dXYT/oCzwR5YjHKgCtoumCc2JL/VV3+hI5HJeFV8n9WsViamXIQmP3qYLeFqaZ
 69xdEi9gcmcCUZizyGEG+B4XBBXJy0gec4oKrIXxqvE1FrTgeapOOXbZjiExr8QOVeGQ Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfcu8gn6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:58 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2536FOjN023520;
        Fri, 3 Jun 2022 06:56:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfcu8gn5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2536ptAw009840;
        Fri, 3 Jun 2022 06:56:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3gbcae80v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2536urKN55640504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 06:56:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45AA842049;
        Fri,  3 Jun 2022 06:56:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E17F242042;
        Fri,  3 Jun 2022 06:56:52 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 06:56:52 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v11 17/19] KVM: s390: pv: add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
Date:   Fri,  3 Jun 2022 08:56:43 +0200
Message-Id: <20220603065645.10019-18-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603065645.10019-1-imbrenda@linux.ibm.com>
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1RSwdtLwCbeYzKBoxu6ZXkSAbKO6Ju_V
X-Proofpoint-ORIG-GUID: ZcHfb5-6zZGuWgUe7XX8_Z-AErX1lGHX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_02,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 clxscore=1015 mlxscore=0 mlxlogscore=620
 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030027
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
---
 arch/s390/kvm/kvm-s390.c | 3 +++
 include/uapi/linux/kvm.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 842419092c0c..aeb654849f2d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -609,6 +609,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
index 91b072c137bf..b22dd1221b30 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1157,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_TSC_CONTROL 214
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
 #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
+#define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 225
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.36.1

