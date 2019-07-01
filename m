Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E9F4BD67
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 18:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfFSQBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 12:01:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725899AbfFSQBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jun 2019 12:01:42 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5JFrlpe081443
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 12:01:41 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t7qt11hwr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 12:01:40 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farosas@linux.ibm.com>;
        Wed, 19 Jun 2019 17:01:40 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 19 Jun 2019 17:01:37 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5JG1asX8192548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 16:01:36 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1136BAC05B;
        Wed, 19 Jun 2019 16:01:36 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 677BFAC05F;
        Wed, 19 Jun 2019 16:01:33 +0000 (GMT)
Received: from farosas.linux.ibm.com.ibmuc.com (unknown [9.80.201.249])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jun 2019 16:01:33 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        david@gibson.dropbear.id.au, aik@ozlabs.ru
Subject: [PATCH v3] KVM: PPC: Report single stepping capability
Date:   Wed, 19 Jun 2019 13:01:27 -0300
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061916-0052-0000-0000-000003D2D390
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011291; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01220284; UDB=6.00641924; IPR=6.01001425;
 MB=3.00027379; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-19 16:01:39
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061916-0053-0000-0000-00006161BA1B
Message-Id: <20190619160127.24561-1-farosas@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When calling the KVM_SET_GUEST_DEBUG ioctl, userspace might request
the next instruction to be single stepped via the
KVM_GUESTDBG_SINGLESTEP control bit of the kvm_guest_debug structure.

This patch adds the KVM_CAP_PPC_GUEST_DEBUG_SSTEP capability in order
to inform userspace about the state of single stepping support.

We currently don't have support for guest single stepping implemented
in Book3S HV so the capability is only present for Book3S PR and
BookE.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---

v1 -> v2:
 - add capability description to Documentation/virtual/kvm/api.txt

v2 -> v3:
 - be explicit in the commit message about when the capability is
   present
 - remove unnecessary check for CONFIG_BOOKE

 Documentation/virtual/kvm/api.txt | 3 +++
 arch/powerpc/kvm/powerpc.c        | 2 ++
 include/uapi/linux/kvm.h          | 1 +
 3 files changed, 6 insertions(+)

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
index 6d704ad2472b..bd0a73eaf7ba 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -527,6 +527,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IMMEDIATE_EXIT:
 		r = 1;
 		break;
+	case KVM_CAP_PPC_GUEST_DEBUG_SSTEP:
+		/* fall through */
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

