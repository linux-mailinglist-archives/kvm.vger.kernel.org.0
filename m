Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04261506E7
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgBCNU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24630 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728351AbgBCNUZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:25 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DFDhV064122
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:24 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxjde4jan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:24 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DFLoB064873
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:24 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxjde4j9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:24 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DKG3L010429;
        Mon, 3 Feb 2020 13:20:22 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02wdc.us.ibm.com with ESMTP id 2xw0y610bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:22 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DKLJ537028306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:21 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E2C02806F;
        Mon,  3 Feb 2020 13:20:21 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39D5B2806A;
        Mon,  3 Feb 2020 13:20:21 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:20:21 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 33/37] KVM: s390: protvirt: Support cmd 5 operation state
Date:   Mon,  3 Feb 2020 08:19:53 -0500
Message-Id: <20200203131957.383915-34-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Code 5 for the set cpu state UV call tells the UV to load a PSW from
the SE header (first IPL) or from guest location 0x0 (diag 308 subcode
0/1). Also it sets the cpu into operating state afterwards, so we can
start it.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 1 +
 arch/s390/kvm/kvm-s390.c   | 7 +++++++
 include/uapi/linux/kvm.h   | 1 +
 3 files changed, 9 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 584ad82740b6..7f5606f39d36 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -168,6 +168,7 @@ struct uv_cb_unp {
 #define PV_CPU_STATE_OPR	1
 #define PV_CPU_STATE_STP	2
 #define PV_CPU_STATE_CHKSTP	3
+#define PV_CPU_STATE_OPR_LOAD	5
 
 struct uv_cb_cpu_set_state {
 	struct uv_cb_header header;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index da8aeb24362a..2beb93f0572f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4658,6 +4658,13 @@ static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
 		r = kvm_s390_pv_destroy_cpu(vcpu);
 		break;
 	}
+	case KVM_PV_VCPU_SET_IPL_PSW: {
+		if (!kvm_s390_pv_handle_cpu(vcpu))
+			return -EINVAL;
+
+		r = kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR_LOAD);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8b77e92a6422..69831f40519a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1506,6 +1506,7 @@ enum pv_cmd_id {
 	KVM_PV_VM_UNSHARE,
 	KVM_PV_VCPU_CREATE,
 	KVM_PV_VCPU_DESTROY,
+	KVM_PV_VCPU_SET_IPL_PSW,
 };
 
 struct kvm_pv_cmd {
-- 
2.24.0

