Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3650F1506F1
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgBCNUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728300AbgBCNUJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:09 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DFVkD059500
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:08 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxbx5ykf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:08 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DFi97060310
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:07 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxbx5ykea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:07 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DIqgx024201;
        Mon, 3 Feb 2020 13:20:06 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma05wdc.us.ibm.com with ESMTP id 2xw0y6h25m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DK5uB34996726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:05 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DE5628067;
        Mon,  3 Feb 2020 13:20:05 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A1912805A;
        Mon,  3 Feb 2020 13:20:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:20:05 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 22/37] KVM: s390: protvirt: handle secure guest prefix pages
Date:   Mon,  3 Feb 2020 08:19:42 -0500
Message-Id: <20200203131957.383915-23-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 adultscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The SPX instruction is handled by the ulravisor. We do get a
notification intercept, though. Let us update our internal view.

In addition to that, when the guest prefix page is not secure, an
intercept 112 (0x70) is indicated.  To avoid this for the most common
cases, we can make the guest prefix page protected whenever we pin it.
We have to deal with 112 nevertheless, e.g. when some host code triggers
an export (e.g. qemu dump guest memory). We can simply re-run the
pinning logic by doing a no-op prefix change.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/intercept.c        | 15 +++++++++++++++
 arch/s390/kvm/kvm-s390.c         | 14 ++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 48f382680755..686b00ced55b 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -225,6 +225,7 @@ struct kvm_s390_sie_block {
 #define ICPT_PV_INT_EN	0x64
 #define ICPT_PV_INSTR	0x68
 #define ICPT_PV_NOTIF	0x6c
+#define ICPT_PV_PREF	0x70
 	__u8	icptcode;		/* 0x0050 */
 	__u8	icptstatus;		/* 0x0051 */
 	__u16	ihcpu;			/* 0x0052 */
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index d63f9cf10360..ceba0abb1900 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -451,6 +451,15 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
 	return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
 }
 
+static int handle_pv_spx(struct kvm_vcpu *vcpu)
+{
+	u32 pref = *(u32 *)vcpu->arch.sie_block->sidad;
+
+	kvm_s390_set_prefix(vcpu, pref);
+	trace_kvm_s390_handle_prefix(vcpu, 1, pref);
+	return 0;
+}
+
 static int handle_pv_sclp(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
@@ -475,6 +484,8 @@ static int handle_pv_sclp(struct kvm_vcpu *vcpu)
 
 static int handle_pv_not(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.sie_block->ipa == 0xb210)
+		return handle_pv_spx(vcpu);
 	if (vcpu->arch.sie_block->ipa == 0xb220)
 		return handle_pv_sclp(vcpu);
 
@@ -533,6 +544,10 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 	case ICPT_PV_NOTIF:
 		rc = handle_pv_not(vcpu);
 		break;
+	case ICPT_PV_PREF:
+		rc = 0;
+		kvm_s390_set_prefix(vcpu, kvm_s390_get_prefix(vcpu));
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 76303b0f1226..6e74c7afae3a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3675,6 +3675,20 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 		rc = gmap_mprotect_notify(vcpu->arch.gmap,
 					  kvm_s390_get_prefix(vcpu),
 					  PAGE_SIZE * 2, PROT_WRITE);
+		if (!rc && kvm_s390_pv_is_protected(vcpu->kvm)) {
+			do {
+				rc = uv_convert_to_secure(
+						vcpu->arch.gmap,
+						kvm_s390_get_prefix(vcpu));
+			} while (rc == -EAGAIN);
+			WARN_ONCE(rc, "Error while importing first prefix page. rc %d", rc);
+			do {
+				rc = uv_convert_to_secure(
+						vcpu->arch.gmap,
+						kvm_s390_get_prefix(vcpu) + PAGE_SIZE);
+			} while (rc == -EAGAIN);
+			WARN_ONCE(rc, "Error while importing second prefix page. rc %d", rc);
+		}
 		if (rc) {
 			kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 			return rc;
-- 
2.24.0

