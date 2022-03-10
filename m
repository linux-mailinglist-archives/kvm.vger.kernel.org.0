Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8044D44BE
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 11:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241309AbiCJKdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 05:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241348AbiCJKdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 05:33:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD8713EF82;
        Thu, 10 Mar 2022 02:32:08 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22AAOi9E032405;
        Thu, 10 Mar 2022 10:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FAYRoEzwWiozsAPOG0uC86TDbcaHeVQJTA5KQQK+CEA=;
 b=MonGVCdMlRzTsilqGIxflqhHJgPeVU2bMXyhduxajdEvvfSoh0Qjv7am+DYDP37YVFVT
 mrA03pWD5UdIkJWy4Z98t5v45Od88iRi0zDDXr1tutytjTqvYPwBpGAZ6jT3JmV69L2T
 /GEJFJv1E6j6eQcN0pKsyzOn9DyoQ7uF+ElhAiLPXBH/HVvGBHFtrBO2JLjhOHOl3aNN
 kkEAQ+BpBraiNz034myzWcjCkqp7nyhD+NoyQeKh0W1AHbb6UowgmQgz5lvG07OpjSnF
 YSWhsN6bGJOVStRauFGMDfudE/N1KQyo76oYJ1GTibTpckcR4/jTR43k92M+UIqzY3mq ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ep0sdqd1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:32:07 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22AAU8UR016042;
        Thu, 10 Mar 2022 10:32:07 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ep0sdqcvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:32:07 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22AAL6dq027832;
        Thu, 10 Mar 2022 10:31:50 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3ekyg8jj0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 10:31:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22AAKXeL52101514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 10:20:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEE3C5204F;
        Thu, 10 Mar 2022 10:31:46 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5EC9C5204E;
        Thu, 10 Mar 2022 10:31:46 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH v2 4/9] KVM: s390: pv: Add dump support definitions
Date:   Thu, 10 Mar 2022 10:31:07 +0000
Message-Id: <20220310103112.2156-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220310103112.2156-1-frankja@linux.ibm.com>
References: <20220310103112.2156-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: a8OIW72zP-IRwknh61vE1LSq4OayudON
X-Proofpoint-GUID: GQMNCH0DKRljd6Ev1S2HyMe3Dv8-C5JT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=932 classifier=spam adjust=0 reason=mlx scancount=1
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

Lets add the constants and structure definitions needed for the dump
support.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index a774267e9a12..a69f672daa1f 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -50,6 +50,10 @@
 #define UVC_CMD_SET_UNSHARE_ALL		0x0340
 #define UVC_CMD_PIN_PAGE_SHARED		0x0341
 #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
+#define UVC_CMD_DUMP_INIT		0x0400
+#define UVC_CMD_DUMP_CONF_STOR_STATE	0x0401
+#define UVC_CMD_DUMP_CPU		0x0402
+#define UVC_CMD_DUMP_COMPLETE		0x0403
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
 
@@ -76,6 +80,10 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_UNSHARE_ALL = 20,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
+	BIT_UVC_CMD_DUMP_INIT = 24,
+	BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE = 25,
+	BIT_UVC_CMD_DUMP_CPU = 26,
+	BIT_UVC_CMD_DUMP_COMPLETE = 27,
 };
 
 enum uv_feat_ind {
@@ -225,6 +233,31 @@ struct uv_cb_share {
 	u64 reserved28;
 } __packed __aligned(8);
 
+struct uv_cb_dump_cpu {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 cpu_handle;
+	u64 dump_area_origin;
+	u64 reserved28[5];
+} __packed __aligned(8);
+
+struct uv_cb_dump_stor_state {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 config_handle;
+	u64 dump_area_origin;
+	u64 gaddr;
+	u64 reserved28[4];
+} __packed __aligned(8);
+
+struct uv_cb_dump_complete {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 config_handle;
+	u64 dump_area_origin;
+	u64 reserved30[5];
+} __packed __aligned(8);
+
 static inline int __uv_call(unsigned long r1, unsigned long r2)
 {
 	int cc;
-- 
2.32.0

