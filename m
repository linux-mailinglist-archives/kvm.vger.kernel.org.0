Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C76049FCFC
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 16:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245094AbiA1Plo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 10:41:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19758 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbiA1Pln (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 10:41:43 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20SFDsTH003114;
        Fri, 28 Jan 2022 15:41:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mIVC4tQn5urWzaW41VWBK+MJStHSJn6U89EnXjbE3rE=;
 b=RJ8KPUwxbfNfcjGo1b5rmJ4kcDaJhu1+/G1QyRROuY4A2xVZxpmenPKrIImx3AqFjHrR
 eLid26hs1C6S5baPAMRh7WH3vBEyEyc5uF1ovb0WRFTOmOrFKNNQCrCqKyZq3GkoTlbL
 oXcLU+nuq/waYXfsqF1pp3RJfI7vZ7qTymQieOYt3YbTrNwhFr2iTmIJqCJYnNWRafLE
 lUAWJbcVBGVDOsIz3TKxeCKX/tEefbQv1xX4wUU4xCC3naACrVzBBYCz5EbnydYgebfS
 kIl0HeyEfUDOQj/Wtd8ZjJzqIZEiTiqQ++Hgz3suOHdbPRnueYbZWvbrAfZuj0xKhgb+ 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvfvb4ubx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 15:41:31 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20SFE1ji003675;
        Fri, 28 Jan 2022 15:41:30 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvfvb4ub5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 15:41:30 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20SFWtDS023981;
        Fri, 28 Jan 2022 15:41:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3dr9ja8d0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 15:41:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20SFfPu824183278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 15:41:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2343D11C050;
        Fri, 28 Jan 2022 15:41:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8405311C066;
        Fri, 28 Jan 2022 15:41:23 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jan 2022 15:41:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, guang.zeng@intel.com,
        jing2.liu@intel.com, kevin.tian@intel.com, seanjc@google.com,
        tglx@linutronix.de, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH] kvm: Move KVM_GET_XSAVE2 IOCTL definition at the end of kvm.h
Date:   Fri, 28 Jan 2022 15:40:25 +0000
Message-Id: <20220128154025.102666-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -uiKA0YRqUO9Fvd8H9dVOt-g1rUD7k-I
X-Proofpoint-ORIG-GUID: BXvA1Awgy1RUwIGL4zNAYE-i2P-NrMDv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-28_04,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201280097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This way we can more easily find the next free IOCTL number when
adding new IOCTLs.

Fixes: be50b2065dfa ("kvm: x86: Add support for getting/setting expanded xstate buffer")
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 include/uapi/linux/kvm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9563d294f181..efe81fef25eb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1623,9 +1623,6 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
-/* Available with KVM_CAP_XSAVE2 */
-#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
-
 struct kvm_s390_pv_sec_parm {
 	__u64 origin;
 	__u64 length;
@@ -2047,4 +2044,7 @@ struct kvm_stats_desc {
 
 #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
 
+/* Available with KVM_CAP_XSAVE2 */
+#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
+
 #endif /* __LINUX_KVM_H */
-- 
2.32.0

