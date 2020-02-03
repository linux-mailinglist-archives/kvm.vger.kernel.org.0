Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC7141506F3
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgBCNUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728407AbgBCNUp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:45 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DIB0O080681
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:44 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxm9cr293-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:38 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DIGt6082424
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:34 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxm9cr22a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:32 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DKGgX018832;
        Mon, 3 Feb 2020 13:20:23 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 2xw0y690sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:23 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DKLQ934013474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:21 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86EB728067;
        Mon,  3 Feb 2020 13:20:21 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82FB72805C;
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
Subject: [RFCv2 37/37] KVM: s390: protvirt: Add UV cpu reset calls
Date:   Mon,  3 Feb 2020 08:19:57 -0500
Message-Id: <20200203131957.383915-38-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

For protected VMs, the VCPU resets are done by the Ultravisor, as KVM
has no access to the VCPU registers.

As the Ultravisor will only accept a call for the reset that is
needed, we need to fence the UV calls when chaining resets.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3e4716b3fc02..f7a3f84be064 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4699,6 +4699,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int idx;
 	long r;
+	u32 ret;
 
 	vcpu_load(vcpu);
 
@@ -4720,14 +4721,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_S390_CLEAR_RESET:
 		r = 0;
 		kvm_arch_vcpu_ioctl_clear_reset(vcpu);
+		if (kvm_s390_pv_handle_cpu(vcpu)) {
+			r = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
+					  UVC_CMD_CPU_RESET_CLEAR, &ret);
+			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET CLEAR VCPU: cpu %d rc %x rrc %x",
+				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+		}
 		break;
 	case KVM_S390_INITIAL_RESET:
 		r = 0;
 		kvm_arch_vcpu_ioctl_initial_reset(vcpu);
+		if (kvm_s390_pv_handle_cpu(vcpu)) {
+			r = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
+					  UVC_CMD_CPU_RESET_INITIAL,
+					  &ret);
+			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET INITIAL VCPU: cpu %d rc %x rrc %x",
+				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+		}
 		break;
 	case KVM_S390_NORMAL_RESET:
 		r = 0;
 		kvm_arch_vcpu_ioctl_normal_reset(vcpu);
+		if (kvm_s390_pv_handle_cpu(vcpu)) {
+			r = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
+					  UVC_CMD_CPU_RESET, &ret);
+			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET NORMAL VCPU: cpu %d rc %x rrc %x",
+				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+		}
 		break;
 	case KVM_SET_ONE_REG:
 	case KVM_GET_ONE_REG: {
-- 
2.24.0

