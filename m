Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8842D528087
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 11:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242266AbiEPJKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 05:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242075AbiEPJJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 05:09:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C9F22B30;
        Mon, 16 May 2022 02:09:35 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G7UWiF003777;
        Mon, 16 May 2022 09:09:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=L233qFz/CEOcFmm8h7PktO+jVN2xHLRjx5gX34vyaKo=;
 b=CVF6wY4GgwZQF3+Cclx0HaJPRwojakqbtYlRZk5DH22qUzyJNO2isFle3oepSBMXXJra
 4a8DF2cm3T9mAIedOXnsUTDEzfv95BDS/Kma0zPrGTfrqVPB4OI0k/n/DlmoYw9Z02e0
 M8pqeob9iUbzXw7iZw8wvow+B+iUpFO2jlzV8i9Dz9T+wpa4eHXWXeK0a+Pk1wyXfYlQ
 QMV9ZyIadBOrLqCGUVI0CxxRat2+sy0CUZ19dVrorSOHpJe6m5fYowb4JKimonkbzB53
 V2SAkVnKptGnmyktGAMT00TcMcYfPjdmff/VTa/Ij/TsbRAGr6Mc+p6pF7C93nWTDFWx tg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3j9k1tt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:34 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G99Wt5017871;
        Mon, 16 May 2022 09:09:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3g2428suac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:32 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G99TpK44040686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 09:09:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1022942045;
        Mon, 16 May 2022 09:09:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87D1D42041;
        Mon, 16 May 2022 09:09:28 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 09:09:28 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v5 07/10] kvm: s390: Add CPU dump functionality
Date:   Mon, 16 May 2022 09:08:14 +0000
Message-Id: <20220516090817.1110090-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220516090817.1110090-1-frankja@linux.ibm.com>
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2maSh-4DOJLhjsruwl06-ZEuHvuXGNla
X-Proofpoint-GUID: 2maSh-4DOJLhjsruwl06-ZEuHvuXGNla
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_05,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=923 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 include/uapi/linux/kvm.h |  4 +++
 4 files changed, 94 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6bf9dd85d50f..c0c848c84552 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5129,6 +5129,52 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
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
@@ -5293,6 +5339,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
index 2868dd0bba25..a39815184350 100644
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
index fd261667d2c2..8c72330efc0e 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -300,6 +300,22 @@ int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state)
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
index 1c60c2d314ba..0a8b57654ea7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1657,6 +1657,7 @@ enum pv_cmd_dmp_id {
 	KVM_PV_DUMP_INIT,
 	KVM_PV_DUMP_CONFIG_STOR_STATE,
 	KVM_PV_DUMP_COMPLETE,
+	KVM_PV_DUMP_CPU,
 };
 
 struct kvm_s390_pv_dmp {
@@ -2118,4 +2119,7 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+/* Available with KVM_CAP_S390_PROTECTED_DUMP */
+#define KVM_S390_PV_CPU_COMMAND	_IOWR(KVMIO, 0xd0, struct kvm_pv_cmd)
+
 #endif /* __LINUX_KVM_H */
-- 
2.34.1

