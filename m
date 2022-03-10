Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0684D44BB
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 11:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbiCJKdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 05:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241362AbiCJKdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 05:33:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DDE13DE3C;
        Thu, 10 Mar 2022 02:32:13 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22A7xNBh004459;
        Thu, 10 Mar 2022 10:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BWMOMQ6UVagtVwKIz3qIlRqzYQbjfDm2UVJ9IBRjWp4=;
 b=fzUiHkJe5I5tsbg6RMWo1yZYU3zWYC0uULPah+oJdh1jS8Q2jl7ffVvPD9FEAXaXP2JD
 NzpHTVlcky1MNCvxEwONRmxrSzefIadAOjBDyxVHD3b5V9E4A8OrpRfJdSSe7gqnxzNb
 lw4DtDoU8fVHCH6xWJvfxrGebHqJ60eq5H7ZcSQQBFhs7TnqP6Bad6FQN4KrnF7xAHyV
 g8uT9xhzhk3Rog2JbecooMPt5bMXFn/zJj60cIPeZPTeb8jDl9YBzivT7C0uzSdDn/AU
 fcNeXAISdpWk8z/LgBYBhNvktkxxogmZI8N7joVVg8jRL582n8U5eh8L7zF9ZNhtNb2G WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3entt9qhmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:32:12 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22A9hfbe017249;
        Thu, 10 Mar 2022 10:32:12 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3entt9qheg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:32:12 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22AAJRwO021608;
        Thu, 10 Mar 2022 10:31:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3eky4j4ee0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:31:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22AAVnOp52625864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 10:31:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 166495204E;
        Thu, 10 Mar 2022 10:31:49 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7B23F52050;
        Thu, 10 Mar 2022 10:31:48 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH v2 7/9] kvm: s390: Add CPU dump functionality
Date:   Thu, 10 Mar 2022 10:31:10 +0000
Message-Id: <20220310103112.2156-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220310103112.2156-1-frankja@linux.ibm.com>
References: <20220310103112.2156-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sArUe6yzocdIJPtX5uP3dAA8dgiSGwuT
X-Proofpoint-ORIG-GUID: CDY_eyYlMzUFVmQgvhsDPb5nEvQ4P-h3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=898 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203100056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The previous patch introduced the per-VM dump functions now let's
focus on dumping the VCPU state via the newly introduced
KVM_S390_PV_CPU_COMMAND ioctl which mirrors the VM UV ioctl and can be
extended with new commands later.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 73 ++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h |  1 +
 arch/s390/kvm/pv.c       | 16 +++++++++
 include/uapi/linux/kvm.h |  5 +++
 4 files changed, 95 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 817e18c4244d..287d4dfffd66 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5118,6 +5118,52 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 	return -ENOIOCTLCMD;
 }
 
+static int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu,
+					struct kvm_pv_cmd *cmd)
+{
+	struct kvm_s390_pv_dmp dmp;
+	void *data;
+	int ret;
+
+	/* Dump initialization is a prerequisite */
+	if (!vcpu->kvm->arch.pv.dumping)
+		return -EINVAL;
+
+	if (copy_from_user(&dmp, (__u8 __user *)cmd->data, sizeof(dmp)))
+		return -EFAULT;
+
+	/* We only handle this subcmd right now */
+	if (dmp.subcmd != KVM_PV_DUMP_CPU)
+		return -EINVAL;
+
+	/* CPU dump length is the same as create cpu storage donation. */
+	if (dmp.buff_len != uv_info.guest_cpu_stor_len)
+		return -EINVAL;
+
+	data = vzalloc(uv_info.guest_cpu_stor_len);
+	if (!data)
+		return -ENOMEM;
+
+	ret = kvm_s390_pv_dump_cpu(vcpu, data, &cmd->rc, &cmd->rrc);
+
+	VCPU_EVENT(vcpu, 3, "PROTVIRT DUMP CPU %d rc %x rrc %x",
+		   vcpu->vcpu_id, cmd->rc, cmd->rrc);
+
+	if (ret) {
+		vfree(data);
+		return -EINVAL;
+	}
+
+	/* On success copy over the dump data */
+	if (copy_to_user((__u8 __user *)dmp.buff_addr, data, uv_info.guest_cpu_stor_len)) {
+		vfree(data);
+		return -EFAULT;
+	}
+
+	vfree(data);
+	return 0;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -5282,6 +5328,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 					   irq_state.len);
 		break;
 	}
+	case KVM_S390_PV_CPU_COMMAND: {
+		struct kvm_pv_cmd cmd;
+
+		r = -EINVAL;
+		if (!is_prot_virt_host())
+			break;
+
+		r = -EFAULT;
+		if (copy_from_user(&cmd, argp, sizeof(cmd)))
+			break;
+
+		r = -EINVAL;
+		if (cmd.flags)
+			break;
+
+		/* We only handle this cmd right now */
+		if (cmd.cmd != KVM_PV_DUMP)
+			break;
+
+		r = kvm_s390_handle_pv_vcpu_dump(vcpu, &cmd);
+
+		/* Always copy over UV rc / rrc data */
+		if (copy_to_user((__u8 __user *)argp, &cmd.rc,
+				 sizeof(cmd.rc) + sizeof(cmd.rrc)))
+			r = -EFAULT;
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 324a23bf0678..681a427808d7 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -250,6 +250,7 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 		       unsigned long tweak, u16 *rc, u16 *rrc);
 int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state);
+int kvm_s390_pv_dump_cpu(struct kvm_vcpu *vcpu, void *buff, u16 *rc, u16 *rrc);
 int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
 				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc);
 
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 2d42ec53a52e..63ffcce64056 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -304,6 +304,22 @@ int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state)
 	return 0;
 }
 
+int kvm_s390_pv_dump_cpu(struct kvm_vcpu *vcpu, void *buff, u16 *rc, u16 *rrc)
+{
+	struct uv_cb_dump_cpu uvcb = {
+		.header.cmd = UVC_CMD_DUMP_CPU,
+		.header.len = sizeof(uvcb),
+		.cpu_handle = vcpu->arch.pv.handle,
+		.dump_area_origin = (u64)buff,
+	};
+	int cc;
+
+	cc = uv_call_sched(0, (u64)&uvcb);
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+	return cc;
+}
+
 /* Size of the cache for the storage state dump data. 1MB for now */
 #define DUMP_BUFF_LEN HPAGE_SIZE
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6808ea0be648..673cfdccadbf 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1142,6 +1142,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SYS_ATTRIBUTES 209
 #define KVM_CAP_PPC_AIL_MODE_3 210
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
+#define KVM_CAP_S390_PROTECTED_DUMP 212
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1647,6 +1648,7 @@ enum pv_cmd_dmp_id {
 	KVM_PV_DUMP_INIT,
 	KVM_PV_DUMP_CONFIG_STOR_STATE,
 	KVM_PV_DUMP_COMPLETE,
+	KVM_PV_DUMP_CPU,
 };
 
 struct kvm_s390_pv_dmp {
@@ -2106,4 +2108,7 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+/* Available with KVM_CAP_S390_PROTECTED_DUMP */
+#define KVM_S390_PV_CPU_COMMAND	_IOWR(KVMIO, 0xd0, struct kvm_pv_cmd)
+
 #endif /* __LINUX_KVM_H */
-- 
2.32.0

