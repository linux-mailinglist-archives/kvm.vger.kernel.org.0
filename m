Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70056457830
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 22:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbhKSVkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 16:40:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235262AbhKSVkR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 16:40:17 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJLIWHQ031622;
        Fri, 19 Nov 2021 21:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fLJN1OwTfDL7nZ8IwLAFT9pFSURzXxJhDOt/4m0V5Ho=;
 b=EcmQqUxhSlaguxVTm2x6sevoprXmbtWTfhxb8ix4NpZoXwxharxxu8w794YQKIhB9AWn
 HIU8IgQ3+14SbiPPzJy0MyfnpTKALh+U9hB41i8pQ5Ad/R06DgAQlGCyGkrfMHUe/1tk
 doM2Y7w77ICGxn3Xzmt82RPB/goNWvk7nt/UiQR7ptogRqQ5KJzcbh4OGeRGGx/q0Ok8
 HHmvER3/B29MojPsHSrzh09EnTQe5oh/z/K9Fgb0FirjhXvjwqerQkz+9vk9uYW5pp6F
 afw7V2wO2FcLg9y8Zk8nphJOx7lr8cnFikruK321SkHTzSAQjIMQtW11XW4+jSyCZ1+p bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cekqgga50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 21:37:15 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AJLPufg003257;
        Fri, 19 Nov 2021 21:37:14 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cekqgga4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 21:37:14 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AJLI6JX001639;
        Fri, 19 Nov 2021 21:37:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3ca50at2w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 21:37:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AJLU9hN48693642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 21:30:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FFB8A4053;
        Fri, 19 Nov 2021 21:37:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B91AA404D;
        Fri, 19 Nov 2021 21:37:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 19 Nov 2021 21:37:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id DECB4E128D; Fri, 19 Nov 2021 22:37:08 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v4 1/2] Capability/IOCTL/Documentation
Date:   Fri, 19 Nov 2021 22:37:06 +0100
Message-Id: <20211119213707.2363945-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119213707.2363945-1-farman@linux.ibm.com>
References: <20211119213707.2363945-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Cxrl4CzwwcPjt8ZGtKMONQYNeedZqdp3
X-Proofpoint-GUID: iTygox2nU3xwOm-S-aYCuQrWzIBZ8iBp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_15,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111190114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(This should be squashed with the next patch; it's just broken
out for ease-of-future rebase.)

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 22 ++++++++++++++++++++++
 include/uapi/linux/kvm.h       | 16 ++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a6729c8cf063..012167775419 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5317,6 +5317,18 @@ the trailing ``'\0'``, is indicated by ``name_size`` in the header.
 The Stats Data block contains an array of 64-bit values in the same order
 as the descriptors in Descriptors block.
 
+4.134 KVM_S390_USER_BUSY
+---------------------------------
+
+:Capability: KVM_CAP_S390_USER_BUSY
+:Architectures: s390
+:Type: vcpu ioctl
+:Parameters: struct kvm_s390_busy_info
+:Returns: 0, or -EBUSY if VCPU is already busy
+
+This ioctl sets the VCPU's indicator that it is busy processing an item
+of work, and is thus unavailable for additional work of that type.
+
 5. The kvm_run structure
 ========================
 
@@ -6706,6 +6718,16 @@ MAP_SHARED mmap will result in an -EINVAL return.
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
 
+7.29 KVM_CAP_S390_USER_BUSY
+--------------------------------
+
+:Architectures: s390
+:Parameters: none
+
+This capability indicates that KVM should indicate when a vcpu is busy
+performing some work, and conflicting work directed at the same vcpu should
+return CC2 (BUSY) until it has completed.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..7f16f9fb4ae8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_S390_USER_BUSY 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2007,4 +2008,19 @@ struct kvm_stats_desc {
 
 #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
 
+/* Available with KVM_CAP_S390_USER_BUSY */
+#define KVM_S390_USER_BUSY	_IOW(KVMIO, 0xcf, struct kvm_s390_user_busy_info)
+
+#define KVM_S390_USER_BUSY_REASON_SIGP		1
+
+#define KVM_S390_USER_BUSY_FUNCTION_RESET	0
+#define KVM_S390_USER_BUSY_FUNCTION_SET		1
+
+/* FIXME struct description */
+struct kvm_s390_user_busy_info {
+	__u32 reason;
+	__u32 function;
+	__u32 payload;
+};
+
 #endif /* __LINUX_KVM_H */
-- 
2.25.1

