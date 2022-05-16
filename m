Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3824152807B
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 11:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242164AbiEPJJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 05:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241985AbiEPJJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 05:09:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6551A80F;
        Mon, 16 May 2022 02:09:32 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G7jMTW018972;
        Mon, 16 May 2022 09:09:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OqNmAsGSrOorKHPTWmIM0IJ/JRs0rqZ2zx6nI8uTMe0=;
 b=psK+pVYhQm/fsWTbbRcFIvJjHzIjWD6i4mp+oz8L0TumiIWH4E7DvUVCdu3P61jOoNiS
 Re58yoUBqa6G+RXotSQ7qf+93kScBKR7dYbzaYraWtAlHAqe61gughINrdv3PGUE2PiR
 WMDzMxCLdOzYNJTefOas/7pch8Qe67OoXTyhFNy2On4pYYeJus0lwzztTqRczbsTMTHZ
 XpEpBItXNFAcVERpS26tDGgt+qzuVlJMDMJ9L3JJ/2ie7h3cPNZcdhSVcH2UDTwA/Cf6
 qT9sQzydeAH5f5Jvu5GoD3sI/z2REB9xvDXjQahS35yOCq00KNDwlYt/cVjbl934AQjG wg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3jgm1jgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:31 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G95Zm6013034;
        Mon, 16 May 2022 09:09:29 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3g23pj1ttx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G99QLh47644930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 09:09:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6131742045;
        Mon, 16 May 2022 09:09:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8C2A4203F;
        Mon, 16 May 2022 09:09:25 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 09:09:25 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v5 03/10] KVM: s390: pv: Add query interface
Date:   Mon, 16 May 2022 09:08:10 +0000
Message-Id: <20220516090817.1110090-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220516090817.1110090-1-frankja@linux.ibm.com>
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nR0yLNEX5jnhuDUXWVkQ6Ha-fdl5mdRk
X-Proofpoint-ORIG-GUID: nR0yLNEX5jnhuDUXWVkQ6Ha-fdl5mdRk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_05,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxscore=0 spamscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=978 lowpriorityscore=0 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160049
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
---
 arch/s390/kvm/kvm-s390.c | 76 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h | 25 +++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 76ad6408cb2c..5859f243d287 100644
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
index 6a184d260c7f..8ac9de7d1386 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1653,6 +1653,30 @@ struct kvm_s390_pv_unp {
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
@@ -1661,6 +1685,7 @@ enum pv_cmd_id {
 	KVM_PV_VERIFY,
 	KVM_PV_PREP_RESET,
 	KVM_PV_UNSHARE_ALL,
+	KVM_PV_INFO,
 };
 
 struct kvm_pv_cmd {
-- 
2.34.1

