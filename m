Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07804C0F14
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 10:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbiBWJVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 04:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239259AbiBWJU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 04:20:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864198564F;
        Wed, 23 Feb 2022 01:20:30 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N920pY013877;
        Wed, 23 Feb 2022 09:20:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+th4ZJsXzZd4mykGJhSfEe+4Oz7F/vem+IJtXPz645U=;
 b=rXSQ4uyUE6INF6MQ5cuZFfW25/13zpfGG36eCB91cb2cgZDU1NA0MEs9XSOMbKGELlru
 iX/96CEVarp+1cFZrvJWcJyVFGwwUOuvCfuvX39yR1MaCbbNnSKT9FP0rRGCcHvDesYM
 nmxNIxlEEKgje0GK3MbL5+tVa4HWGEooZestmKOA/CmBM6GWbBIS2kiFLYfl/SkXdwHY
 O2s3ngnx356/lFxGJmvwU+gHFBUAhGDTTC3Wisw3evbRzNElPxyCtsTY5k60LP6q/GNN
 EyY5Rp6zyHHWUdB5birGBDHFJprliUh/idIf+QDIt2rXNmWHub3hmBJV7TZlu552vah1 vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed8gfhx3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:30 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21N8ZDDG025506;
        Wed, 23 Feb 2022 09:20:29 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed8gfhx29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:29 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21N9D19m030195;
        Wed, 23 Feb 2022 09:20:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3ear6973tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21N99iBw47317454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 09:09:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1483611C050;
        Wed, 23 Feb 2022 09:20:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77C1711C04A;
        Wed, 23 Feb 2022 09:20:22 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 09:20:22 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH 7/9] kvm: s390: Add CPU dump functionality
Date:   Wed, 23 Feb 2022 09:20:05 +0000
Message-Id: <20220223092007.3163-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220223092007.3163-1-frankja@linux.ibm.com>
References: <20220223092007.3163-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 51o2acrLNQMVQS8rDPORzDgLT4QrZO1u
X-Proofpoint-GUID: Z5jDXfAq98SlR3WxgNiOuS_pUuJEnhi6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 spamscore=0 mlxlogscore=925
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230049
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
 arch/s390/kvm/kvm-s390.c | 72 ++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h |  1 +
 arch/s390/kvm/pv.c       | 16 +++++++++
 include/uapi/linux/kvm.h |  4 +++
 4 files changed, 93 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 074d50d58430..d73cbd910a79 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5084,6 +5084,51 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 	return -ENOIOCTLCMD;
 }
 
+int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd)
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
@@ -5248,6 +5293,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
index dbae30aa338c..5746a7679f21 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -241,6 +241,7 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 		       unsigned long tweak, u16 *rc, u16 *rrc);
 int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state);
+int kvm_s390_pv_dump_cpu(struct kvm_vcpu *vcpu, void *buff, u16 *rc, u16 *rrc);
 int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
 				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc);
 
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 3c1c257ed38e..f5a9ff0164b2 100644
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
index 913c5907b9f1..129d21f403c3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1647,6 +1647,7 @@ enum pv_cmd_dmp_id {
 	KVM_PV_DUMP_INIT,
 	KVM_PV_DUMP_CONFIG_STOR_STATE,
 	KVM_PV_DUMP_COMPLETE,
+	KVM_PV_DUMP_CPU,
 };
 
 struct kvm_s390_pv_dmp {
@@ -2104,4 +2105,7 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+/* Available with KVM_CAP_S390_PROTECTED_DUMP */
+#define KVM_S390_PV_CPU_COMMAND	_IOWR(KVMIO, 0xd0, struct kvm_pv_cmd)
+
 #endif /* __LINUX_KVM_H */
-- 
2.32.0

