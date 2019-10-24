Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D96E30EB
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439184AbfJXLmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439144AbfJXLms (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:48 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBbAI3088904
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:47 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vuapnhg39-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:47 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:45 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:43 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBgfAt42598424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:42:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C43752057;
        Thu, 24 Oct 2019 11:42:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DC80B52050;
        Thu, 24 Oct 2019 11:42:39 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 33/37] KVM: s390: Introduce VCPU reset IOCTL
Date:   Thu, 24 Oct 2019 07:40:55 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0008-0000-0000-00000326C82E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0009-0000-0000-00004A45FB38
Message-Id: <20191024114059.102802-34-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With PV we need to do things for all reset types, not only initial...

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 53 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h |  6 +++++
 2 files changed, 59 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d3fd3ad1d09b..d8ee3a98e961 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3472,6 +3472,53 @@ static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int kvm_arch_vcpu_ioctl_reset(struct kvm_vcpu *vcpu,
+				     unsigned long type)
+{
+	int rc;
+	u32 ret;
+
+	switch (type) {
+	case KVM_S390_VCPU_RESET_NORMAL:
+		/*
+		 * Only very little is reset, userspace handles the
+		 * non-protected case.
+		 */
+		rc = 0;
+		if (kvm_s390_pv_handle_cpu(vcpu)) {
+			rc = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
+					   UVC_CMD_CPU_RESET, &ret);
+			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET NORMAL VCPU: cpu %d rc %x rrc %x",
+				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+		}
+		break;
+	case KVM_S390_VCPU_RESET_INITIAL:
+		rc = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
+		if (kvm_s390_pv_handle_cpu(vcpu)) {
+			uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
+				      UVC_CMD_CPU_RESET_INITIAL,
+				      &ret);
+			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET INITIAL VCPU: cpu %d rc %x rrc %x",
+				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+		}
+		break;
+	case KVM_S390_VCPU_RESET_CLEAR:
+		rc = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
+		if (kvm_s390_pv_handle_cpu(vcpu)) {
+			rc = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
+					   UVC_CMD_CPU_RESET_CLEAR, &ret);
+			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET CLEAR VCPU: cpu %d rc %x rrc %x",
+				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+		}
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+	return rc;
+}
+
+
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	vcpu_load(vcpu);
@@ -4633,8 +4680,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_S390_INITIAL_RESET:
+		r = -EINVAL;
+		if (kvm_s390_pv_is_protected(vcpu->kvm))
+			break;
 		r = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
 		break;
+	case KVM_S390_VCPU_RESET:
+		r = kvm_arch_vcpu_ioctl_reset(vcpu, arg);
+		break;
 	case KVM_SET_ONE_REG:
 	case KVM_GET_ONE_REG: {
 		struct kvm_one_reg reg;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f75a051a7705..2846ed5e5dd9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1496,6 +1496,12 @@ struct kvm_pv_cmd {
 #define KVM_S390_PV_COMMAND		_IOW(KVMIO, 0xc3, struct kvm_pv_cmd)
 #define KVM_S390_PV_COMMAND_VCPU	_IOW(KVMIO, 0xc4, struct kvm_pv_cmd)
 
+#define KVM_S390_VCPU_RESET_NORMAL	0
+#define KVM_S390_VCPU_RESET_INITIAL	1
+#define KVM_S390_VCPU_RESET_CLEAR	2
+
+#define KVM_S390_VCPU_RESET    _IO(KVMIO,   0xd0)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.20.1

