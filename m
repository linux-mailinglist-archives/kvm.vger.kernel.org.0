Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A354D44B5
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 11:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbiCJKdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 05:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241327AbiCJKdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 05:33:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2155E13EF82;
        Thu, 10 Mar 2022 02:32:06 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22AAFo48027764;
        Thu, 10 Mar 2022 10:32:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ndP7BE+G5S6W7gq+skUJFLobUXMuZSupQc2bmfKz+9o=;
 b=INwp4PaGI4xEsuVCP0MnjWAZuAC11xfEyxrRjwBfqCSOiloWbenKj9ep9kQ4qv+3E8tA
 GY9loo//y69QAIfXmadiiCWbtFI+681vTdkgqcliz2qkb04Z9h7dNB34EMsHWUJ8ogHc
 73QxVyonMx/4KNeZMT+hqt7nYPV+xy95xgPieEA+hz2EdQmG2l5a2lE/HogfXZTo60VJ
 nIkKGmsWIsog9s96HghfhyNZhfg3/2ytCh3pgcQWGa7k5kSL0rPUu8xovjFejbGmfchs
 TT/z3JygVxoKM6oidCPSkN3fG14BK4r2ll4AcQdOV/k6ksOjsB+uM6vtbAwtc6tbNaW8 rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3epwy3mm0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:32:05 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22AAD7Dt009992;
        Thu, 10 Mar 2022 10:32:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3epwy3mkvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:32:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22AAJQZW021592;
        Thu, 10 Mar 2022 10:31:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3eky4j4edv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:31:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22AAVklm39977242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 10:31:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 424D75204F;
        Thu, 10 Mar 2022 10:31:46 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A60A95204E;
        Thu, 10 Mar 2022 10:31:45 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH v2 3/9] KVM: s390: pv: Add query interface
Date:   Thu, 10 Mar 2022 10:31:06 +0000
Message-Id: <20220310103112.2156-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220310103112.2156-1-frankja@linux.ibm.com>
References: <20220310103112.2156-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gAxIAhfjPPJyueZ1M2hjm5eCBBukE4zc
X-Proofpoint-ORIG-GUID: PJFyVDL_E-_au-W9MhJbSD_u0oSdkADR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
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

Some of the query information is already available via sysfs but
having a IOCTL makes the information easier to retrieve.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 76 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h | 25 +++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 020356653d1a..67e1e445681f 100644
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
+	ssize_t len;
+
+	switch (info->header.id) {
+	case KVM_PV_INFO_VM: {
+		len =  sizeof(info->header) + sizeof(info->vm);
+
+		if (info->header.len_max < len)
+			return -EINVAL;
+
+		memcpy(info->vm.inst_calls_list,
+		       uv_info.inst_calls_list,
+		       sizeof(uv_info.inst_calls_list));
+
+		/* It's max cpuidm not max cpus so it's off by one */
+		info->vm.max_cpus = uv_info.max_guest_cpu_id + 1;
+		info->vm.max_guests = uv_info.max_num_sec_conf;
+		info->vm.max_guest_addr = uv_info.max_sec_stor_addr;
+		info->vm.feature_indication = uv_info.uv_feature_indications;
+
+		return len;
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
index a02bbf8fd0f6..21f19863c417 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1643,6 +1643,30 @@ struct kvm_s390_pv_unp {
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
@@ -1651,6 +1675,7 @@ enum pv_cmd_id {
 	KVM_PV_VERIFY,
 	KVM_PV_PREP_RESET,
 	KVM_PV_UNSHARE_ALL,
+	KVM_PV_INFO,
 };
 
 struct kvm_pv_cmd {
-- 
2.32.0

