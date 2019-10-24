Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDEBE30E7
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfJXLmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48344 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439143AbfJXLmp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:45 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBb7Ob007240
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:45 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vuags23f8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:44 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:43 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:41 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBgdRD15532066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:42:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB9AE5204F;
        Thu, 24 Oct 2019 11:42:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1F5525204E;
        Thu, 24 Oct 2019 11:42:38 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 32/37] KVM: s390: protvirt: UV calls diag308 0, 1
Date:   Thu, 24 Oct 2019 07:40:54 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0020-0000-0000-0000037DCE97
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0021-0000-0000-000021D41500
Message-Id: <20191024114059.102802-33-frankja@linux.ibm.com>
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

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 25 +++++++++++++++++++++++++
 arch/s390/kvm/diag.c       |  1 +
 arch/s390/kvm/kvm-s390.c   | 20 ++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h   |  2 ++
 arch/s390/kvm/pv.c         | 19 +++++++++++++++++++
 include/uapi/linux/kvm.h   |  2 ++
 6 files changed, 69 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 9ce9363aee1c..33b52ba306af 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -35,6 +35,12 @@
 #define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
 #define UVC_CMD_UNPACK_IMG		0x0301
 #define UVC_CMD_VERIFY_IMG		0x0302
+#define UVC_CMD_CPU_RESET		0x0310
+#define UVC_CMD_CPU_RESET_INITIAL	0x0311
+#define UVC_CMD_PERF_CONF_CLEAR_RESET	0x0320
+#define UVC_CMD_CPU_RESET_CLEAR		0x0321
+#define UVC_CMD_CPU_SET_STATE		0x0330
+#define UVC_CMD_SET_UNSHARED_ALL	0x0340
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
 
@@ -53,6 +59,12 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_SET_SEC_PARMS = 11,
 	BIT_UVC_CMD_UNPACK_IMG = 13,
 	BIT_UVC_CMD_VERIFY_IMG = 14,
+	BIT_UVC_CMD_CPU_RESET = 15,
+	BIT_UVC_CMD_CPU_RESET_INITIAL = 16,
+	BIT_UVC_CMD_CPU_SET_STATE = 17,
+	BIT_UVC_CMD_PREPARE_CLEAR_RESET = 18,
+	BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET = 19,
+	BIT_UVC_CMD_REMOVE_SHARED_ACCES = 20,
 };
 
 struct uv_cb_header {
@@ -148,6 +160,19 @@ struct uv_cb_unp {
 	u64 reserved28[3];
 } __packed __aligned(8);
 
+#define PV_CPU_STATE_OPR	1
+#define PV_CPU_STATE_STP	2
+#define PV_CPU_STATE_CHKSTP	3
+
+struct uv_cb_cpu_set_state {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 cpu_handle;
+	u8  reserved20[7];
+	u8  state;
+	u64 reserved28[5];
+};
+
 /*
  * A common UV call struct for the following calls:
  * Destroy cpu/config
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index b951dbdcb6a0..1c53eb7ba152 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -13,6 +13,7 @@
 #include <asm/pgalloc.h>
 #include <asm/gmap.h>
 #include <asm/virtio-ccw.h>
+#include <asm/uv.h>
 #include "kvm-s390.h"
 #include "trace.h"
 #include "trace-s390.h"
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8947f1812b12..d3fd3ad1d09b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2256,6 +2256,26 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 			 ret >> 16, ret & 0x0000ffff);
 		break;
 	}
+	case KVM_PV_VM_PERF_CLEAR_RESET: {
+		u32 ret;
+
+		r = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
+				  UVC_CMD_PERF_CONF_CLEAR_RESET,
+				  &ret);
+		VM_EVENT(kvm, 3, "PROTVIRT PERF CLEAR: rc %x rrc %x",
+			 ret >> 16, ret & 0x0000ffff);
+		break;
+	}
+	case KVM_PV_VM_UNSHARE: {
+		u32 ret;
+
+		r = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
+				  UVC_CMD_SET_UNSHARED_ALL,
+				  &ret);
+		VM_EVENT(kvm, 3, "PROTVIRT UNSHARE: %d rc %x rrc %x",
+			 r, ret >> 16, ret & 0x0000ffff);
+		break;
+	}
 	default:
 		return -ENOTTY;
 	}
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 0d61dcc51f0e..8cd2e978363d 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -209,6 +209,7 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length);
 int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 		       unsigned long tweak);
 int kvm_s390_pv_verify(struct kvm *kvm);
+int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state);
 
 static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
 {
@@ -238,6 +239,7 @@ static inline int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr,
 				     unsigned long size,  unsigned long tweak)
 { return 0; }
 static inline int kvm_s390_pv_verify(struct kvm *kvm) { return 0; }
+static inline int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state) { return 0; }
 static inline bool kvm_s390_pv_is_protected(struct kvm *kvm) { return 0; }
 static inline u64 kvm_s390_pv_handle(struct kvm *kvm) { return 0; }
 static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu) { return 0; }
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index be7d558ab897..cf79a6503e1c 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -280,3 +280,22 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 		 uvcb.header.rc, uvcb.header.rrc);
 	return rc;
 }
+
+int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state)
+{
+	int rc;
+	struct uv_cb_cpu_set_state uvcb = {
+		.header.cmd	= UVC_CMD_CPU_SET_STATE,
+		.header.len	= sizeof(uvcb),
+		.cpu_handle	= kvm_s390_pv_handle_cpu(vcpu),
+		.state		= state,
+	};
+
+	if (!kvm_s390_pv_handle_cpu(vcpu))
+		return -EINVAL;
+
+	rc = uv_call(0, (u64)&uvcb);
+	if (rc)
+		return -EINVAL;
+	return 0;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index bb37d5710c89..f75a051a7705 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1479,6 +1479,8 @@ enum pv_cmd_id {
 	KVM_PV_VM_SET_SEC_PARMS,
 	KVM_PV_VM_UNPACK,
 	KVM_PV_VM_VERIFY,
+	KVM_PV_VM_PERF_CLEAR_RESET,
+	KVM_PV_VM_UNSHARE,
 	KVM_PV_VCPU_CREATE,
 	KVM_PV_VCPU_DESTROY,
 };
-- 
2.20.1

