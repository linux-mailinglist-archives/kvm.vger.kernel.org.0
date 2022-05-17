Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E47652A832
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351030AbiEQQhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351003AbiEQQg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:36:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5585D2FFF6;
        Tue, 17 May 2022 09:36:57 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HGIdvY023420;
        Tue, 17 May 2022 16:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jl5a6BcXbaYurZM1/SE0yEIwIEbMJN6JbSIj/Vd5v1Q=;
 b=HeP1P2hLK9emPZsUtbZZk08eGbCH1x6znhOnA9PL9hQjqo+IfBfePZYnW3HrJ5vJ5Zy5
 KUsnj8dL+/9Q3Rew4yCN2C68eXjwTEjsHHuyfVLIwJIMUEwRoLRJ7cXqVQomktxTP5rP
 +T2okz6CzjZcqcm0rcXPjb58uAMj0/qn8IhPz/MRs/5V4STz9wT62dyIMVfdqA40cPqi
 mA20vABclgMkFXp62F3oeNev41JVUOvXHdeNvxvQu5c2kT7lrXIIfX3nvPRX/CJdUzn8
 xWcSpg+nmX5ygGMnkF3rfrU9JHn3oouhnNm3jLinS53dBeHcEOKQE3CFsOdLOXfF4R61 +w== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4f46ggcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:56 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HGY5sg001279;
        Tue, 17 May 2022 16:36:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428umdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HGaIUw32768488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 16:36:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58E2711C054;
        Tue, 17 May 2022 16:36:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D11A511C04C;
        Tue, 17 May 2022 16:36:50 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 16:36:50 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v6 07/11] kvm: s390: Add CPU dump functionality
Date:   Tue, 17 May 2022 16:36:25 +0000
Message-Id: <20220517163629.3443-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517163629.3443-1-frankja@linux.ibm.com>
References: <20220517163629.3443-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TwH_RFMeEG2E0vHzTa3-PQ0Vj8ZgcsWz
X-Proofpoint-ORIG-GUID: TwH_RFMeEG2E0vHzTa3-PQ0Vj8ZgcsWz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=922
 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170101
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
 arch/s390/kvm/kvm-s390.c | 69 ++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h |  1 +
 arch/s390/kvm/pv.c       | 16 ++++++++++
 include/uapi/linux/kvm.h |  4 +++
 4 files changed, 90 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 24b8ac61efff..1938756d4a32 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5087,6 +5087,48 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
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
+	data = kvzalloc(uv_info.guest_cpu_stor_len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = kvm_s390_pv_dump_cpu(vcpu, data, &cmd->rc, &cmd->rrc);
+
+	VCPU_EVENT(vcpu, 3, "PROTVIRT DUMP CPU %d rc %x rrc %x",
+		   vcpu->vcpu_id, cmd->rc, cmd->rrc);
+
+	if (ret)
+		ret = -EINVAL;
+
+	/* On success copy over the dump data */
+	if (!ret && copy_to_user((__u8 __user *)dmp.buff_addr, data, uv_info.guest_cpu_stor_len))
+		ret = -EFAULT;
+
+	kvfree(data);
+	return ret;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -5251,6 +5293,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
index 2c11eb5ba3ef..dd01d989816f 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -250,6 +250,7 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 		       unsigned long tweak, u16 *rc, u16 *rrc);
 int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state);
+int kvm_s390_pv_dump_cpu(struct kvm_vcpu *vcpu, void *buff, u16 *rc, u16 *rrc);
 int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
 				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc);
 int kvm_s390_pv_dump_complete(struct kvm *kvm, void __user *buff_user,
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 52a67e2aaadd..a200543cf6a1 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -305,6 +305,22 @@ int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state)
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
index b34850907291..204b06e3a50b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1649,6 +1649,7 @@ enum pv_cmd_dmp_id {
 	KVM_PV_DUMP_INIT,
 	KVM_PV_DUMP_CONFIG_STOR_STATE,
 	KVM_PV_DUMP_COMPLETE,
+	KVM_PV_DUMP_CPU,
 };
 
 struct kvm_s390_pv_dmp {
@@ -2110,4 +2111,7 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+/* Available with KVM_CAP_S390_PROTECTED_DUMP */
+#define KVM_S390_PV_CPU_COMMAND	_IOWR(KVMIO, 0xd0, struct kvm_pv_cmd)
+
 #endif /* __LINUX_KVM_H */
-- 
2.34.1

