Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC984436A8
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 20:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhKBTtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 15:49:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229813AbhKBTtk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 15:49:40 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2GtVwn006524;
        Tue, 2 Nov 2021 19:47:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Z+hJG9bgDzC6JdvMTcc/Vex+3+06nRWBHDdvdAH/dug=;
 b=QeeV5l/+y5Im0AldP+G6T6wesIsQTiERd5gNhwsATajZNb8qrxP7497MdCg2YPqWODUj
 TtCl7OlGVTjm5abkvjkAl0ldwFTRpz8NNRrD4F81KoN/k+l9+BS/7q822eGxEl31I+fR
 lwPpgGxcS4851BfoLSEG/ASYIsA3SBoLduBMID1fn73nvZzfVHoRGVgWSBIJ6YaykFSk
 j+k7XnxdsoakEEEQSowXJt/ZSRZmEJVdcIBhZxA1VT7tzWDUPCIboU5jbUxU5iq59zIx
 qHK6GljkUAUBRBJBLTOtM/S1JqJW4pf6x1PxDuFnjX80iwvpayMkSLjiodNV/t3UyVq4 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c399ekewk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:47:03 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A2JelB8004446;
        Tue, 2 Nov 2021 19:47:02 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c399ekew2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:47:02 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A2JRUxZ004654;
        Tue, 2 Nov 2021 19:47:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3c0wp9q237-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:47:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A2JkvnO67043818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Nov 2021 19:46:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FB3852057;
        Tue,  2 Nov 2021 19:46:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 1D3BE52051;
        Tue,  2 Nov 2021 19:46:57 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id CA33AE2136; Tue,  2 Nov 2021 20:46:56 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v2 1/2] Capability/IOCTL/Documentation
Date:   Tue,  2 Nov 2021 20:46:51 +0100
Message-Id: <20211102194652.2685098-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211102194652.2685098-1-farman@linux.ibm.com>
References: <20211102194652.2685098-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HmSxy9R_GvPQZpEwY527C6nEbpk3vYIE
X-Proofpoint-ORIG-GUID: 5afXWrrJARhzSEPTuxqxNGyvhB22qba9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_08,2021-11-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111020104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(This should be squashed with the next patch; it's just broken
out for ease-of-future rebase.)

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 27 +++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  4 ++++
 2 files changed, 31 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a6729c8cf063..00fdc86545e5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5317,6 +5317,18 @@ the trailing ``'\0'``, is indicated by ``name_size`` in the header.
 The Stats Data block contains an array of 64-bit values in the same order
 as the descriptors in Descriptors block.
 
+4.134 KVM_S390_VCPU_RESET_SIGP_BUSY
+-----------------------------------
+
+:Capability: KVM_CAP_S390_USER_SIGP_BUSY
+:Architectures: s390
+:Type: vcpu ioctl
+:Parameters: none
+:Returns: 0
+
+This ioctl resets the VCPU's indicator that it is busy processing a SIGP
+order, and is thus available for additional SIGP orders.
+
 5. The kvm_run structure
 ========================
 
@@ -6706,6 +6718,21 @@ MAP_SHARED mmap will result in an -EINVAL return.
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
 
+7.29 KVM_CAP_S390_USER_SIGP_BUSY
+--------------------------------
+
+:Architectures: s390
+:Parameters: none
+
+This capability indicates that KVM should indicate when a SIGP order has been
+sent to userspace for a particular vcpu, and return CC2 (BUSY) to any further
+SIGP order directed at the same vcpu even for those orders that are handled
+within the kernel.
+
+This capability is dependent on KVM_CAP_S390_USER_SIGP. If this capability
+is not enabled, SIGP orders handled by the kernel may not indicate whether a
+vcpu is currently processing another SIGP order.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..7e7727b4ef59 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_S390_USER_SIGP_BUSY 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2007,4 +2008,7 @@ struct kvm_stats_desc {
 
 #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
 
+/* Available with KVM_CAP_S390_USER_SIGP_BUSY */
+#define KVM_S390_VCPU_RESET_SIGP_BUSY	_IO(KVMIO, 0xcf)
+
 #endif /* __LINUX_KVM_H */
-- 
2.25.1

