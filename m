Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDD551347D
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 15:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346820AbiD1NJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 09:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346766AbiD1NIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 09:08:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AE388784;
        Thu, 28 Apr 2022 06:05:38 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SCiA0E003781;
        Thu, 28 Apr 2022 13:05:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0Hx74XoQ7Y3TvHWZKYT82INL9CNHdDKjYrcP3huPXp0=;
 b=tR2QkN3/uJMl45TlEXind+28qRpLHvENnnEgyZ42eJWOHfL6l/WocvVaOn3BsWTCj0pw
 3x0Zv8d5/lDrSFvx9FuibFIIdUINTsAJA9X7zn1OuKR2usFEQKRy3AuEKlgRbWvHwxPI
 ptNljiQNeu6V4R8ZnIAh6g9zYGy1uM0RmK/j6MWwnAvIvGbBSHiFDia3BKMdYrZo6NSA
 qFtW+p3ufAc+TnA81fMOdLH/1mpO1k983Ro1MGJXcSxuope6TiqbFDTfZVmgXygypItg
 HCBq4ypsKWUxA8anciqbq7of2szaWW4xsg12p+eNIK6BmvgSLItUDUygfCtEYWdOqUoa ug== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqu6n8fw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:05:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23SCwfvG024882;
        Thu, 28 Apr 2022 13:05:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3fm8qj7jay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:05:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23SD5VhP30605664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 13:05:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D151342041;
        Thu, 28 Apr 2022 13:05:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54BAC42042;
        Thu, 28 Apr 2022 13:05:31 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Apr 2022 13:05:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH 5/9] KVM: s390: pv: Add query dump information
Date:   Thu, 28 Apr 2022 13:00:58 +0000
Message-Id: <20220428130102.230790-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220428130102.230790-1-frankja@linux.ibm.com>
References: <20220428130102.230790-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LGZgDdBqFkRF8tOAUXDHuZ-cbM0nBlDv
X-Proofpoint-ORIG-GUID: LGZgDdBqFkRF8tOAUXDHuZ-cbM0nBlDv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=801 priorityscore=1501
 suspectscore=0 phishscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
index 23352d45a386..e327a5b8ef78 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2255,6 +2255,17 @@ static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
 
 		return len_min;
 	}
+	case KVM_PV_INFO_DUMP: {
+		len_min =  sizeof(info->header) + sizeof(info->dump);
+
+		if (info->header.len_max < len_min)
+			return -EINVAL;
+
+		info->dump.dump_cpu_buffer_len = uv_info.guest_cpu_stor_len;
+		info->dump.dump_config_mem_buffer_per_1m = uv_info.conf_dump_storage_state_len;
+		info->dump.dump_config_finalize_len = uv_info.conf_dump_finalize_len;
+		return len_min;
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 59e4fb6c7a34..2eba89d7ec29 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1647,6 +1647,13 @@ struct kvm_s390_pv_unp {
 
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
@@ -1666,7 +1673,10 @@ struct kvm_s390_pv_info_header {
 
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

