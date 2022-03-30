Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85B74EC4B0
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345424AbiC3MoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345451AbiC3Mnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:43:51 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7245BBD8BB;
        Wed, 30 Mar 2022 05:37:13 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UBeWbu012250;
        Wed, 30 Mar 2022 12:20:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bBagpf3UOA+PpSCNVLyi1ETS/jEwThVvwlcvBRnnx50=;
 b=Wqjo5LmzlXpUlYkSdWc6dpHrq/jZFN3ceJ4en5TZu2hPh/ntHvkR5UbgsXJ2qnVEd/zl
 ApdEn9qCQKdHV2zhax8uHvRLpWbROmO5V669+18gfbAhj3BLEmFC7GnI1w/Icgq/b1Dl
 DWA3RkB5TPBRnvOpowuLvJjQfW5LM9eWNQH+ZXusRKShPC/k/5htiIvcyl9bRbVmS6SD
 2AAvfmrEA8OwSwb/jQutjVQnIB8qZ5G1Fr+xgHsQKi5+DyidyYFkV1O529CE7DfnjZ4n
 srpeRaKj3xFc+SJJ1ZkmOLxDT5pkSHz7pQHPE+r7T1pVsYDgfu+HTq48qzK3VMnXJABl Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40c957y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:41 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UBhSxx019594;
        Wed, 30 Mar 2022 12:20:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40c957x5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UBvTLH023981;
        Wed, 30 Mar 2022 12:20:38 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf9ghqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UCKZQM48824626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:20:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BE8242042;
        Wed, 30 Mar 2022 12:20:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B03804204B;
        Wed, 30 Mar 2022 12:20:34 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 12:20:34 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH v3 6/9] kvm: s390: Add configuration dump functionality
Date:   Wed, 30 Mar 2022 12:19:49 +0000
Message-Id: <20220330121952.105725-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330121952.105725-1-frankja@linux.ibm.com>
References: <20220330121952.105725-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s8ItzxgF68-u49Peopi9VC0HbPJ-4vyt
X-Proofpoint-GUID: QiR_OILEvAnH0U4veiQ8tJQurcYX0rqM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes dumping inside of a VM fails, is unavailable or doesn't
yield the required data. For these occasions we dump the VM from the
outside, writing memory and cpu data to a file.

Up to now PV guests only supported dumping from the inside of the
guest through dumpers like KDUMP. A PV guest can be dumped from the
hypervisor but the data will be stale and / or encrypted.

To get the actual state of the PV VM we need the help of the
Ultravisor who safeguards the VM state. New UV calls have been added
to initialize the dump, dump storage state data, dump cpu data and
complete the dump process. We expose these calls in this patch via a
new UV ioctl command.

The sensitive parts of the dump data are encrypted, the dump key is
derived from the Customer Communication Key (CCK). This ensures that
only the owner of the VM who has the CCK can decrypt the dump data.

The memory is dumped / read via a normal export call and a re-import
after the dump initialization is not needed (no re-encryption with a
dump key).

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |   1 +
 arch/s390/kvm/kvm-s390.c         | 146 +++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h         |   2 +
 arch/s390/kvm/pv.c               | 115 ++++++++++++++++++++++++
 include/uapi/linux/kvm.h         |  15 ++++
 5 files changed, 279 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a22c9266ea05..659bf4be6f04 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -921,6 +921,7 @@ struct kvm_s390_pv {
 	u64 guest_len;
 	unsigned long stor_base;
 	void *stor_var;
+	bool dumping;
 };
 
 struct kvm_arch{
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c6ad3b2e32f9..42afa5ea690c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -606,6 +606,26 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_PROTECTED:
 		r = is_prot_virt_host();
 		break;
+	case KVM_CAP_S390_PROTECTED_DUMP: {
+		u64 pv_cmds_dump[] = {
+			BIT_UVC_CMD_DUMP_INIT,
+			BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE,
+			BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE,
+			BIT_UVC_CMD_DUMP_CPU,
+		};
+		int i;
+
+		if (!is_prot_virt_host())
+			return 0;
+
+		r = 1;
+		for (i = 0; i < ARRAY_SIZE(pv_cmds_dump); i++) {
+			if (!test_bit_inv(pv_cmds_dump[i],
+					  (unsigned long *)&uv_info.inst_calls_list))
+				return 0;
+		}
+		break;
+	}
 	default:
 		r = 0;
 	}
@@ -2273,6 +2293,101 @@ static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
 	}
 }
 
+static int kvm_s390_pv_dmp(struct kvm *kvm, struct kvm_pv_cmd *cmd,
+			   struct kvm_s390_pv_dmp dmp)
+{
+	int r = -EINVAL;
+	void __user *result_buff = (void __user *)dmp.buff_addr;
+
+	switch (dmp.subcmd) {
+	case KVM_PV_DUMP_INIT: {
+		if (kvm->arch.pv.dumping)
+			break;
+
+		/*
+		 * Block SIE entry as concurrent dump UVCs could lead
+		 * to validities.
+		 */
+		kvm_s390_vcpu_block_all(kvm);
+
+		r = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
+				  UVC_CMD_DUMP_INIT, &cmd->rc, &cmd->rrc);
+		KVM_UV_EVENT(kvm, 3, "PROTVIRT DUMP INIT: rc %x rrc %x",
+			     cmd->rc, cmd->rrc);
+		if (!r)
+			kvm->arch.pv.dumping = true;
+		else {
+			kvm_s390_vcpu_unblock_all(kvm);
+			r = -EINVAL;
+		}
+		break;
+	}
+	case KVM_PV_DUMP_CONFIG_STOR_STATE: {
+		if (!kvm->arch.pv.dumping)
+			break;
+
+		/*
+		 * GADDR is an output parameter since we might stop
+		 * early. As dmp will be copied back in our caller, we
+		 * don't need to do it ourselves.
+		 */
+		r = kvm_s390_pv_dump_stor_state(kvm, result_buff, &dmp.gaddr, dmp.buff_len,
+						&cmd->rc, &cmd->rrc);
+		break;
+	}
+	case KVM_PV_DUMP_COMPLETE: {
+		struct uv_cb_dump_complete complete = {
+			.header.len = sizeof(complete),
+			.header.cmd = UVC_CMD_DUMP_COMPLETE,
+			.config_handle = kvm_s390_pv_get_handle(kvm),
+		};
+		u64 *compl_data;
+
+		r = -EINVAL;
+		if (!kvm->arch.pv.dumping)
+			break;
+
+		if (dmp.buff_len < uv_info.conf_dump_finalize_len)
+			break;
+
+		/* Allocate dump area */
+		r = -ENOMEM;
+		compl_data = vzalloc(uv_info.conf_dump_finalize_len);
+		if (!compl_data)
+			break;
+		complete.dump_area_origin = (u64)compl_data;
+
+		r = uv_call(0, (u64)&complete);
+		cmd->rc = complete.header.rc;
+		cmd->rrc = complete.header.rrc;
+		KVM_UV_EVENT(kvm, 3, "PROTVIRT DUMP COMPLETE: rc %x rrc %x",
+			     complete.header.rc, complete.header.rrc);
+
+		if (!r) {
+			/*
+			 * kvm_s390_pv_dealloc_vm() will also (mem)set
+			 * this to false on a reboot or other destroy
+			 * operation for this vm.
+			 */
+			kvm->arch.pv.dumping = false;
+			kvm_s390_vcpu_unblock_all(kvm);
+			r = copy_to_user(result_buff, compl_data, uv_info.conf_dump_finalize_len);
+			if (r)
+				r = -EFAULT;
+		}
+		vfree(compl_data);
+		if (r > 0)
+			r = -EINVAL;
+		break;
+	}
+	default:
+		r = -ENOTTY;
+		break;
+	}
+
+	return r;
+}
+
 static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 {
 	int r = 0;
@@ -2449,6 +2564,28 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		r = 0;
 		break;
 	}
+	case KVM_PV_DUMP: {
+		struct kvm_s390_pv_dmp dmp;
+
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm))
+			break;
+
+		r = -EFAULT;
+		if (copy_from_user(&dmp, argp, sizeof(dmp)))
+			break;
+
+		r = kvm_s390_pv_dmp(kvm, cmd, dmp);
+		if (r)
+			break;
+
+		if (copy_to_user(argp, &dmp, sizeof(dmp))) {
+			r = -EFAULT;
+			break;
+		}
+
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
@@ -4566,6 +4703,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_run *kvm_run = vcpu->run;
 	int rc;
 
+	/*
+	 * Running a VM while dumping always has the potential to
+	 * produce inconsistent dump data. But for PV vcpus a SIE
+	 * entry while dumping could also lead to a validity which we
+	 * absolutely want to avoid.
+	 */
+	if (vcpu->kvm->arch.pv.dumping)
+		return -EINVAL;
+
 	if (kvm_run->immediate_exit)
 		return -EINTR;
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 798955b62fa3..c7f0ec709186 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -250,6 +250,8 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 		       unsigned long tweak, u16 *rc, u16 *rrc);
 int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state);
+int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
+				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc);
 
 static inline u64 kvm_s390_pv_get_handle(struct kvm *kvm)
 {
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 7f7c0d6af2ce..2d42ec53a52e 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -303,3 +303,118 @@ int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state)
 		return -EINVAL;
 	return 0;
 }
+
+/* Size of the cache for the storage state dump data. 1MB for now */
+#define DUMP_BUFF_LEN HPAGE_SIZE
+
+/*
+ * kvm_s390_pv_dump_stor_state
+ *
+ * @kvm: pointer to the guest's KVM struct
+ * @buff_user: Userspace pointer where we will write the results to
+ * @gaddr: Starting absolute guest address for which the storage state
+ *         is requested. This value will be updated with the last
+ *         address for which data was written when returning to
+ *         userspace.
+ * @buff_user_len: Length of the buff_user buffer
+ * @rc: Pointer to where the uvcb return code is stored
+ * @rrc: Pointer to where the uvcb return reason code is stored
+ *
+ * Return:
+ *  0 on success
+ *  -ENOMEM if allocating the cache fails
+ *  -EINVAL if gaddr is not aligned to 1MB
+ *  -EINVAL if buff_user_len is not aligned to uv_info.conf_dump_storage_state_len
+ *  -EINVAL if the UV call fails, rc and rrc will be set in this case
+ *  -EFAULT if copying the result to buff_user failed
+ */
+int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
+				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc)
+{
+	struct uv_cb_dump_stor_state uvcb = {
+		.header.cmd = UVC_CMD_DUMP_CONF_STOR_STATE,
+		.header.len = sizeof(uvcb),
+		.config_handle = kvm->arch.pv.handle,
+		.gaddr = *gaddr,
+		.dump_area_origin = 0,
+	};
+	size_t buff_kvm_size;
+	size_t size_done = 0;
+	u8 *buff_kvm = NULL;
+	int cc, ret;
+
+	ret = -EINVAL;
+	/* UV call processes 1MB guest storage chunks at a time */
+	if (*gaddr & ~HPAGE_MASK)
+		goto out;
+
+	/*
+	 * We provide the storage state for 1MB chunks of guest
+	 * storage. The buffer will need to be aligned to
+	 * conf_dump_storage_state_len so we don't end on a partial
+	 * chunk.
+	 */
+	if (!buff_user_len ||
+	    buff_user_len & (uv_info.conf_dump_storage_state_len - 1))
+		goto out;
+
+	/*
+	 * Allocate a buffer from which we will later copy to the user process.
+	 *
+	 * We don't want userspace to dictate our buffer size so we limit it to DUMP_BUFF_LEN.
+	 */
+	ret = -ENOMEM;
+	buff_kvm_size = buff_user_len <= DUMP_BUFF_LEN ? buff_user_len : DUMP_BUFF_LEN;
+	buff_kvm = vzalloc(buff_kvm_size);
+	if (!buff_kvm)
+		goto out;
+
+	ret = 0;
+	uvcb.dump_area_origin = (u64)buff_kvm;
+	/* We will loop until the user buffer is filled or an error occurs */
+	do {
+		/* Get a page of data */
+		cc = uv_call_sched(0, (u64)&uvcb);
+
+		/* All or nothing */
+		if (cc) {
+			ret = -EINVAL;
+			break;
+		}
+
+		size_done += uv_info.conf_dump_storage_state_len;
+		uvcb.dump_area_origin += uv_info.conf_dump_storage_state_len;
+		uvcb.gaddr += HPAGE_SIZE;
+		buff_user_len -= PAGE_SIZE;
+
+		/* KVM Buffer full, time to copy to the process */
+		if (!buff_user_len ||
+		    uvcb.dump_area_origin == (uintptr_t)buff_kvm + buff_kvm_size) {
+
+			if (copy_to_user(buff_user, buff_kvm,
+					 uvcb.dump_area_origin - (uintptr_t)buff_kvm)) {
+				ret = -EFAULT;
+				break;
+			}
+
+			buff_user += size_done;
+			size_done = 0;
+			uvcb.dump_area_origin = (u64)buff_kvm;
+		}
+	} while (buff_user_len);
+
+	/* Report back where we ended dumping */
+	*gaddr = uvcb.gaddr;
+
+	/* Lets only log errors, we don't want to spam */
+out:
+	if (ret)
+		KVM_UV_EVENT(kvm, 3,
+			     "PROTVIRT DUMP STORAGE STATE: addr %llx ret %d, uvcb rc %x rrc %x",
+			     uvcb.gaddr, ret, uvcb.header.rc, uvcb.header.rrc);
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+	vfree(buff_kvm);
+
+	return ret;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eed2ae8397ae..6808ea0be648 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1643,6 +1643,20 @@ struct kvm_s390_pv_unp {
 	__u64 tweak;
 };
 
+enum pv_cmd_dmp_id {
+	KVM_PV_DUMP_INIT,
+	KVM_PV_DUMP_CONFIG_STOR_STATE,
+	KVM_PV_DUMP_COMPLETE,
+};
+
+struct kvm_s390_pv_dmp {
+	__u64 subcmd;
+	__u64 buff_addr;
+	__u64 buff_len;
+	__u64 gaddr;		/* For dump storage state */
+	__u64 reserved[4];
+};
+
 enum pv_cmd_info_id {
 	KVM_PV_INFO_VM,
 	KVM_PV_INFO_DUMP,
@@ -1686,6 +1700,7 @@ enum pv_cmd_id {
 	KVM_PV_PREP_RESET,
 	KVM_PV_UNSHARE_ALL,
 	KVM_PV_INFO,
+	KVM_PV_DUMP,
 };
 
 struct kvm_pv_cmd {
-- 
2.32.0

