Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659614D44BF
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 11:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241321AbiCJKdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 05:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241372AbiCJKdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 05:33:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C5C13EF93;
        Thu, 10 Mar 2022 02:32:14 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22A7ZBPY004312;
        Thu, 10 Mar 2022 10:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Oh/nhXpbM3k9coX9oLkixJfslZy5nDeeK/JhNeLwLBU=;
 b=ezXgSJBGlayHyytvd5GIrP7i8LHwFj10HGhdDhKqTwX93ESrjREd2fSJstdFuboIqOwn
 JS9E7GgHzIune5LGs2Cho/iu/NwfHV2zet3lFpOgT+PRNaXvSNf0/LWLFxoiSZ7w6xJJ
 dWq9Ew6oK0zeAsPooku0LVMnjk3hYZi/K0ZNy3oeN3+1w0VSRp+qu+fSRFrWoquT8V78
 M66sJ5AOovlqQM8klD+M/YmIe8mTa70EK5tS02XTIaWcnQouvHhxfjCAjMkK8PenmAya
 naTqTV5laGgdX8AjfXQ/ZUcRYyqUb2BFkQSfb0ywtKydgF457Ro5DwJuvXZruDLzD13S qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3entt9qhna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:32:14 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22A9v1Pg005203;
        Thu, 10 Mar 2022 10:32:14 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3entt9qhe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:32:14 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22AAJoLo024167;
        Thu, 10 Mar 2022 10:31:50 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3epysw9f5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:31:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22AAKYXh52232542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 10:20:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6AC552050;
        Thu, 10 Mar 2022 10:31:47 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1753E5204E;
        Thu, 10 Mar 2022 10:31:47 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH v2 5/9] KVM: s390: pv: Add query dump information
Date:   Thu, 10 Mar 2022 10:31:08 +0000
Message-Id: <20220310103112.2156-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220310103112.2156-1-frankja@linux.ibm.com>
References: <20220310103112.2156-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JjYZrq2uiojA--w3frFYUZm0-qt_wM4w
X-Proofpoint-ORIG-GUID: U-m4K6JBTI9eoW7RSkqaDKMccUE7jynd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=882 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
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

The dump API requires userspace to provide buffers into which we will
store data. The dump information added in this patch tells userspace
how big those buffers need to be.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 11 +++++++++++
 include/uapi/linux/kvm.h | 12 +++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 67e1e445681f..c388d08b9626 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2255,6 +2255,17 @@ static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
 
 		return len;
 	}
+	case KVM_PV_INFO_DUMP: {
+		len =  sizeof(info->header) + sizeof(info->dump);
+
+		if (info->header.len_max < len)
+			return -EINVAL;
+
+		info->dump.dump_cpu_buffer_len = uv_info.guest_cpu_stor_len;
+		info->dump.dump_config_mem_buffer_per_1m = uv_info.conf_dump_storage_state_len;
+		info->dump.dump_config_finalize_len = uv_info.conf_dump_finalize_len;
+		return len;
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 21f19863c417..eed2ae8397ae 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1645,6 +1645,13 @@ struct kvm_s390_pv_unp {
 
 enum pv_cmd_info_id {
 	KVM_PV_INFO_VM,
+	KVM_PV_INFO_DUMP,
+};
+
+struct kvm_s390_pv_info_dump {
+	__u64 dump_cpu_buffer_len;
+	__u64 dump_config_mem_buffer_per_1m;
+	__u64 dump_config_finalize_len;
 };
 
 struct kvm_s390_pv_info_vm {
@@ -1664,7 +1671,10 @@ struct kvm_s390_pv_info_header {
 
 struct kvm_s390_pv_info {
 	struct kvm_s390_pv_info_header header;
-	struct kvm_s390_pv_info_vm vm;
+	union {
+		struct kvm_s390_pv_info_dump dump;
+		struct kvm_s390_pv_info_vm vm;
+	};
 };
 
 enum pv_cmd_id {
-- 
2.32.0

