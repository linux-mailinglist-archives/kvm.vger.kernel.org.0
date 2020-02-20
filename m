Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D651165BE7
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 11:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgBTKlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 05:41:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727930AbgBTKkb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 05:40:31 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KAYPk5010345;
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y8xdpne07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01KAZ2Au011876;
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y8xdpndyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01KAGQmt022801;
        Thu, 20 Feb 2020 10:40:28 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 2y68976x1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 10:40:28 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KAePN832506194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 10:40:25 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72808112074;
        Thu, 20 Feb 2020 10:40:25 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EC3F11206D;
        Thu, 20 Feb 2020 10:40:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 10:40:25 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH v3 33/37] KVM: s390: protvirt: Add UV cpu reset calls
Date:   Thu, 20 Feb 2020 05:40:16 -0500
Message-Id: <20200220104020.5343-34-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220104020.5343-1-borntraeger@de.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_02:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

For protected VMs, the VCPU resets are done by the Ultravisor, as KVM
has no access to the VCPU registers.

Note that the ultravisor will only accept a call for the exact reset
that has been requested.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/uv.h |  6 ++++++
 arch/s390/kvm/kvm-s390.c   | 20 ++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 4945e44e1528..cb95763ffb30 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -36,7 +36,10 @@
 #define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
 #define UVC_CMD_UNPACK_IMG		0x0301
 #define UVC_CMD_VERIFY_IMG		0x0302
+#define UVC_CMD_CPU_RESET		0x0310
+#define UVC_CMD_CPU_RESET_INITIAL	0x0311
 #define UVC_CMD_PREPARE_RESET		0x0320
+#define UVC_CMD_CPU_RESET_CLEAR		0x0321
 #define UVC_CMD_CPU_SET_STATE		0x0330
 #define UVC_CMD_SET_UNSHARE_ALL		0x0340
 #define UVC_CMD_PIN_PAGE_SHARED		0x0341
@@ -59,8 +62,11 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_SET_SEC_PARMS = 11,
 	BIT_UVC_CMD_UNPACK_IMG = 13,
 	BIT_UVC_CMD_VERIFY_IMG = 14,
+	BIT_UVC_CMD_CPU_RESET = 15,
+	BIT_UVC_CMD_CPU_RESET_INITIAL = 16,
 	BIT_UVC_CMD_CPU_SET_STATE = 17,
 	BIT_UVC_CMD_PREPARE_RESET = 18,
+	BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET = 19,
 	BIT_UVC_CMD_UNSHARE_ALL = 20,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 76ab9e4c8f55..d79ccd34b5cb 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4705,6 +4705,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int idx;
 	long r;
+	u16 rc, rrc;
 
 	vcpu_load(vcpu);
 
@@ -4726,14 +4727,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_S390_CLEAR_RESET:
 		r = 0;
 		kvm_arch_vcpu_ioctl_clear_reset(vcpu);
+		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+			r = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
+					  UVC_CMD_CPU_RESET_CLEAR, &rc, &rrc);
+			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET CLEAR VCPU: rc %x rrc %x",
+				   rc, rrc);
+		}
 		break;
 	case KVM_S390_INITIAL_RESET:
 		r = 0;
 		kvm_arch_vcpu_ioctl_initial_reset(vcpu);
+		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+			r = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
+					  UVC_CMD_CPU_RESET_INITIAL,
+					  &rc, &rrc);
+			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET INITIAL VCPU: rc %x rrc %x",
+				   rc, rrc);
+		}
 		break;
 	case KVM_S390_NORMAL_RESET:
 		r = 0;
 		kvm_arch_vcpu_ioctl_normal_reset(vcpu);
+		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+			r = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
+					  UVC_CMD_CPU_RESET, &rc, &rrc);
+			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET NORMAL VCPU: rc %x rrc %x",
+				   rc, rrc);
+		}
 		break;
 	case KVM_SET_ONE_REG:
 	case KVM_GET_ONE_REG: {
-- 
2.25.0

