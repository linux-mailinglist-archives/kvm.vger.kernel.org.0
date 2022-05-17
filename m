Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF6F52A829
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350998AbiEQQhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350989AbiEQQg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:36:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9272A2FE44;
        Tue, 17 May 2022 09:36:55 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HGPQS1031312;
        Tue, 17 May 2022 16:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=stJituto7JtOqAI5Bvh2wGYjCx85KJGkaw5RkPOwRsc=;
 b=U3X3xDG+qLxsYVTJykdxwfE8eXaSSnzXg1FaXNmhpI/E7O8kjakPu1KdFwFn2gXTKT7e
 pO+BQ3Ym8QmJg7iDmZHp9f7fTxmRAd0e9ivoZOEkQFu5vLk1xNzw5lzFZg2sh5rIeGft
 DoDHpautluP5Fqd9On2Ct+uv/SjZAOZgKyz1G2Wgv87RsLAyZkvlVhYYKv1v3GADhDOk
 LYnxw/jsbo2NrnM/x3eTIvK0IyZdVldH3gAzJqTsy2l5XGzSgsC+RgBMGJad5y5deLIc
 cwh4JtMkdzPBrKhvPXwJJotqAy6H4kQ2DvhiNYRgrH37FvgnZZRpWOgAbfLSxjVlKU21 9g== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4f7d0ad4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:53 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HGWmOS011858;
        Tue, 17 May 2022 16:36:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3g2428umwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HGamrK32506170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 16:36:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA17E11C05B;
        Tue, 17 May 2022 16:36:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DBB011C054;
        Tue, 17 May 2022 16:36:48 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 16:36:48 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v6 03/11] KVM: s390: pv: Add query interface
Date:   Tue, 17 May 2022 16:36:21 +0000
Message-Id: <20220517163629.3443-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517163629.3443-1-frankja@linux.ibm.com>
References: <20220517163629.3443-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f4T17sc86FMI3zqMGwE4AEDWeM28ZQJK
X-Proofpoint-ORIG-GUID: f4T17sc86FMI3zqMGwE4AEDWeM28ZQJK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some of the query information is already available via sysfs but
having a IOCTL makes the information easier to retrieve.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 76 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h | 25 +++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 156d1c25a3c1..4c2d87d66e60 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2224,6 +2224,42 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 	return r;
 }
 
+/*
+ * Here we provide user space with a direct interface to query UV
+ * related data like UV maxima and available features as well as
+ * feature specific data.
+ *
+ * To facilitate future extension of the data structures we'll try to
+ * write data up to the maximum requested length.
+ */
+static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
+{
+	ssize_t len_min;
+
+	switch (info->header.id) {
+	case KVM_PV_INFO_VM: {
+		len_min =  sizeof(info->header) + sizeof(info->vm);
+
+		if (info->header.len_max < len_min)
+			return -EINVAL;
+
+		memcpy(info->vm.inst_calls_list,
+		       uv_info.inst_calls_list,
+		       sizeof(uv_info.inst_calls_list));
+
+		/* It's max cpuid not max cpus, so it's off by one */
+		info->vm.max_cpus = uv_info.max_guest_cpu_id + 1;
+		info->vm.max_guests = uv_info.max_num_sec_conf;
+		info->vm.max_guest_addr = uv_info.max_sec_stor_addr;
+		info->vm.feature_indication = uv_info.uv_feature_indications;
+
+		return len_min;
+	}
+	default:
+		return -EINVAL;
+	}
+}
+
 static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 {
 	int r = 0;
@@ -2360,6 +2396,46 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 			     cmd->rc, cmd->rrc);
 		break;
 	}
+	case KVM_PV_INFO: {
+		struct kvm_s390_pv_info info = {};
+		ssize_t data_len;
+
+		/*
+		 * No need to check the VM protection here.
+		 *
+		 * Maybe user space wants to query some of the data
+		 * when the VM is still unprotected. If we see the
+		 * need to fence a new data command we can still
+		 * return an error in the info handler.
+		 */
+
+		r = -EFAULT;
+		if (copy_from_user(&info, argp, sizeof(info.header)))
+			break;
+
+		r = -EINVAL;
+		if (info.header.len_max < sizeof(info.header))
+			break;
+
+		data_len = kvm_s390_handle_pv_info(&info);
+		if (data_len < 0) {
+			r = data_len;
+			break;
+		}
+		/*
+		 * If a data command struct is extended (multiple
+		 * times) this can be used to determine how much of it
+		 * is valid.
+		 */
+		info.header.len_written = data_len;
+
+		r = -EFAULT;
+		if (copy_to_user(argp, &info, data_len))
+			break;
+
+		r = 0;
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 91a6fe4e02c0..59e4fb6c7a34 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1645,6 +1645,30 @@ struct kvm_s390_pv_unp {
 	__u64 tweak;
 };
 
+enum pv_cmd_info_id {
+	KVM_PV_INFO_VM,
+};
+
+struct kvm_s390_pv_info_vm {
+	__u64 inst_calls_list[4];
+	__u64 max_cpus;
+	__u64 max_guests;
+	__u64 max_guest_addr;
+	__u64 feature_indication;
+};
+
+struct kvm_s390_pv_info_header {
+	__u32 id;
+	__u32 len_max;
+	__u32 len_written;
+	__u32 reserved;
+};
+
+struct kvm_s390_pv_info {
+	struct kvm_s390_pv_info_header header;
+	struct kvm_s390_pv_info_vm vm;
+};
+
 enum pv_cmd_id {
 	KVM_PV_ENABLE,
 	KVM_PV_DISABLE,
@@ -1653,6 +1677,7 @@ enum pv_cmd_id {
 	KVM_PV_VERIFY,
 	KVM_PV_PREP_RESET,
 	KVM_PV_UNSHARE_ALL,
+	KVM_PV_INFO,
 };
 
 struct kvm_pv_cmd {
-- 
2.34.1

