Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D955552A835
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351044AbiEQQhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350997AbiEQQg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:36:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C222FE5F;
        Tue, 17 May 2022 09:36:55 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HG3GmM017946;
        Tue, 17 May 2022 16:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xzcR/3hXBcEfDnzayo7H043mqKd8iSSuHA+zZ8X6XfE=;
 b=GhGbk/OLA8ZUJqqNFQ161nhmbEymzOccznSBkF67a4UgW0pXxGLGQS65YRHPLI2oXX2b
 BxEQgWtU288zRedcqSLwI55RpMKu++AMAeTjU0PxDKmQ48N9pR+Fg8C/007Z1tLEB80x
 P0Ouk+r8VurmRABGN4tjGSrbGBzUej26GB4pM0H+uYunJGPEWkgKwkQEUBwh0Eswc4Yh
 EQjfQNcUabPKWg9YGPwSPKstQGuMyikJ5pz2xiPk7FK7s+xUhsgqcKPyLUVTXAAUG23M
 EoorQMnok2Sq1KpQprfvn05wdQRYqNxfGw25L6XprGAOv5n4QmwbAtH81Vm6qqzOT1Gu nw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4ew0gxfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HGYCxx030335;
        Tue, 17 May 2022 16:36:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjchg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HGaoqP44761590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 16:36:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08D1811C04C;
        Tue, 17 May 2022 16:36:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8022211C04A;
        Tue, 17 May 2022 16:36:49 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 16:36:49 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v6 05/11] KVM: s390: pv: Add query dump information
Date:   Tue, 17 May 2022 16:36:23 +0000
Message-Id: <20220517163629.3443-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517163629.3443-1-frankja@linux.ibm.com>
References: <20220517163629.3443-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tjRPNY0YKfOhX04XTONdfUKTXe3zL4D3
X-Proofpoint-GUID: tjRPNY0YKfOhX04XTONdfUKTXe3zL4D3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 mlxscore=0 impostorscore=0 adultscore=0
 suspectscore=0 mlxlogscore=934 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205170101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The dump API requires userspace to provide buffers into which we will
store data. The dump information added in this patch tells userspace
how big those buffers need to be.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 11 +++++++++++
 include/uapi/linux/kvm.h | 12 +++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4c2d87d66e60..3cfaaa5994e1 100644
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
2.34.1

