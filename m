Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AF72E811
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 00:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfE2WWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 18:22:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47566 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbfE2WWf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 May 2019 18:22:35 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4TM2ggj019960
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 18:22:34 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ssyju765j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 18:22:34 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farosas@linux.ibm.com>;
        Wed, 29 May 2019 23:22:33 +0100
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 29 May 2019 23:22:29 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4TMMSev26411456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 22:22:28 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98613C6055;
        Wed, 29 May 2019 22:22:28 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32320C605A;
        Wed, 29 May 2019 22:22:25 +0000 (GMT)
Received: from farosas.linux.ibm.com.ibmuc.com (unknown [9.85.162.241])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 29 May 2019 22:22:24 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        david@gibson.dropbear.id.au, aik@ozlabs.ru
Subject: [PATCH v2] KVM: PPC: Report single stepping capability
Date:   Wed, 29 May 2019 19:22:19 -0300
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19052922-8235-0000-0000-00000EA056E7
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011181; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01210457; UDB=6.00635958; IPR=6.00991489;
 MB=3.00027107; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-29 22:22:31
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052922-8236-0000-0000-000045C5ED1E
Message-Id: <20190529222219.27994-1-farosas@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=990 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When calling the KVM_SET_GUEST_DEBUG ioctl, userspace might request
the next instruction to be single stepped via the
KVM_GUESTDBG_SINGLESTEP control bit of the kvm_guest_debug structure.

We currently don't have support for guest single stepping implemented
in Book3S HV.

This patch adds the KVM_CAP_PPC_GUEST_DEBUG_SSTEP capability in order
to inform userspace about the state of single stepping support.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---

v1 -> v2:
 - add capability description to Documentation/virtual/kvm/api.txt

 Documentation/virtual/kvm/api.txt | 3 +++
 arch/powerpc/kvm/powerpc.c        | 5 +++++
 include/uapi/linux/kvm.h          | 1 +
 3 files changed, 9 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index ba6c42c576dd..a77643bfa917 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2969,6 +2969,9 @@ can be determined by querying the KVM_CAP_GUEST_DEBUG_HW_BPS and
 KVM_CAP_GUEST_DEBUG_HW_WPS capabilities which return a positive number
 indicating the number of supported registers.
 
+For ppc, the KVM_CAP_PPC_GUEST_DEBUG_SSTEP capability indicates whether
+the single-step debug event (KVM_GUESTDBG_SINGLESTEP) is supported.
+
 When debug events exit the main run loop with the reason
 KVM_EXIT_DEBUG with the kvm_debug_exit_arch part of the kvm_run
 structure containing architecture specific debug information.
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 3393b166817a..fd7e7d55637e 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -538,6 +538,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IMMEDIATE_EXIT:
 		r = 1;
 		break;
+	case KVM_CAP_PPC_GUEST_DEBUG_SSTEP:
+#ifdef CONFIG_BOOKE
+		r = 1;
+		break;
+#endif
 	case KVM_CAP_PPC_PAIRED_SINGLES:
 	case KVM_CAP_PPC_OSI:
 	case KVM_CAP_PPC_GET_PVINFO:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2fe12b40d503..cad9fcd90f39 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 173
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.20.1

