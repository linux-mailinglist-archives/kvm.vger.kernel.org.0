Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22A25F0D0E
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 16:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiI3OHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 10:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiI3OHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 10:07:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BED147CD6;
        Fri, 30 Sep 2022 07:07:00 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28UDreFT031925;
        Fri, 30 Sep 2022 14:06:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QMyPueg21bmYcdGpFb52kbUutuQsZm9CwkwzwQqjxhI=;
 b=BETNcZPL7nm5OSCYxZBA5x9nq4UIEtmfPsRMnYfmf9Rs0nT2mCEcmP8LY06cQ63iNqRV
 VAZIfCiHsqslVLhABc9XTmhlfy2o1xiD6FK7jiM6qkirW9uxjoTmgu0zGRuNdUTteg6x
 UYJX8aIf1RMFNpeWuX7LjmATiu4RA6v1ktHQmKxqmorwZyIaThjtEKx+qmxYBDFy8HEA
 rR0H47V4LuI5OVy1B8WkGu64r682Ti8Hg3+feiuwwy6cRWAb6OgTk/Apn3zd/HPCm30u
 8AVci72n/wPiDpJo4u32r9SrEe9l7FRFyAH3ztgz5kRuRQsLTvfTSUHTLk1fL7xBAN2t aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jx1qygfy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:06:59 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28UDsVrX002260;
        Fri, 30 Sep 2022 14:06:58 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jx1qygfvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:06:58 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28UDosGP009364;
        Fri, 30 Sep 2022 14:01:56 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3jssh964cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:01:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28UE1qKs393962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 14:01:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C78D0A4053;
        Fri, 30 Sep 2022 14:01:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C4E0A404D;
        Fri, 30 Sep 2022 14:01:52 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.242])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Sep 2022 14:01:52 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v14 3/6] KVM: s390: pv: add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
Date:   Fri, 30 Sep 2022 16:01:47 +0200
Message-Id: <20220930140150.37463-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930140150.37463-1-imbrenda@linux.ibm.com>
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3rSDr4YMG927u75Gx4_OfbkrhQqb3CyI
X-Proofpoint-ORIG-GUID: bIz4Tt5fK-chINgTqGLu4CIeTJhxwIuo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-30_04,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=698 phishscore=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209300090
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
---
 arch/s390/kvm/kvm-s390.c | 3 +++
 include/uapi/linux/kvm.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d0027964a6f5..7a3bd68efd85 100644
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

