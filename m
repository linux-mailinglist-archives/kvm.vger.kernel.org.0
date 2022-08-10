Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2815D58EC86
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbiHJM6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiHJM6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:58:04 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E596069D;
        Wed, 10 Aug 2022 05:57:50 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ACpEYF004082;
        Wed, 10 Aug 2022 12:57:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aHPFCuMfOvKa7ujqveKRD4hNSt25Mom63wEEA/CUQ4g=;
 b=aVtFPzSUvURdYQE3qwVRwY+IbopJ47k6VLaK5xigswDbjGEuLg5NXKoVw2xe/jxy9a0p
 W4sy9KJO2x9F2Rm3lg/egVY0UVY+EDXbZqzHH4nT7H3Gh8S5DM6xbG//9ntnl1LAXRiX
 VK/GxEPxBfeH+b5HiQmaDMe6YdxMvkNd9aarDdh3U+KF0p7hhkPsos37f3BDpyu8RT+3
 V2dU9MCPEUTIHR5YGDeyrej/w+eYriKbH4CW21qfhU3lA0GeUQ3E9sTlPl6mwxgmCKB3
 jcwUMnPHn6DwEHGzh3YA8BG0CQ0d4CCSd52+F7Q6lRytfZjKhWLw8h5bxDWWt/YRzkVL jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv3fg1wys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:57:49 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27ACpuwY006109;
        Wed, 10 Aug 2022 12:57:48 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv3fg1wxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:57:48 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27ACqWR1026056;
        Wed, 10 Aug 2022 12:57:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3huww0rup5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:57:46 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27ACrwUB32375256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 12:53:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEE284C044;
        Wed, 10 Aug 2022 12:56:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A03D4C040;
        Wed, 10 Aug 2022 12:56:28 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.0.105])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 12:56:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v13 3/6] KVM: s390: pv: add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
Date:   Wed, 10 Aug 2022 14:56:22 +0200
Message-Id: <20220810125625.45295-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810125625.45295-1-imbrenda@linux.ibm.com>
References: <20220810125625.45295-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jtB85gxWRuBdPzEV7PjJfYPVbCrb6qc2
X-Proofpoint-GUID: pDOYcNVWbsdfQBBjth4wXnSjCJg-mXCJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_07,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 impostorscore=0 phishscore=0 mlxlogscore=705 bulkscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100038
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
index 96ec6ecb6b74..4a20a6be6601 100644
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
2.37.1

