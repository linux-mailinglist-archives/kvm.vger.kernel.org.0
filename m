Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37880509CAB
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 11:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387892AbiDUJsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 05:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387881AbiDUJsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 05:48:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CFA27145;
        Thu, 21 Apr 2022 02:45:38 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L6hCfe025278;
        Thu, 21 Apr 2022 09:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=btGRwvF7AFlYnTVHmc0uCAheHymyGzGwFIweOZtQICQ=;
 b=ec5ZoObLLPIIhgLtz4yz4bEdX9EP5V7HOyBuW5JopEY3zaHgE8JzPKQeBLGMiO9So65s
 mEM1bFWBdqgCCRcsGM3OAKvAAIjA0rr9JTiLaVDyv4u0dxCersU6jXHxZ8zYX1DlvVpx
 q9ZnJYDFXBewYfH9ko4lj9x/B//mQltN3uN795rB/IBd3RtZu71fqd1WdDS4WdIdn8IF
 VQiUFatt/BGiFkSGIv11Gr+LTziKQhX7QCRkJ1kANv6JE0XHRPMb9kKRLjfmc+CAvuuf
 0c8UOp/upt/1fIjprpG9lW0prq6D5guoE6HqOtOFGp3rx3xQ9+K53LFCafjyqRrZVXMn wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjf52jspx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:37 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L9c37H009841;
        Thu, 21 Apr 2022 09:45:37 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjf52jsph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L9cYlq000623;
        Thu, 21 Apr 2022 09:45:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ffn2hyn29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L9Wgmd14745992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 09:32:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 724C411C050;
        Thu, 21 Apr 2022 09:45:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7B6911C04A;
        Thu, 21 Apr 2022 09:45:31 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 09:45:31 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 4/5] s390x: uv-guest: add share bit test
Date:   Thu, 21 Apr 2022 09:45:26 +0000
Message-Id: <20220421094527.32261-5-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421094527.32261-1-seiden@linux.ibm.com>
References: <20220421094527.32261-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pmohFkCkvBV1qNxOFUYIUHXOppppXpkx
X-Proofpoint-ORIG-GUID: YyMq1S2IrsUfH5qhlJIahx0l3IenLQM0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The UV facility bits shared/unshared must both be set or none.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/uv-guest.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 728c60aa..77057bd2 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -159,6 +159,14 @@ static void test_invalid(void)
 	report_prefix_pop();
 }
 
+static void test_share_bits(void)
+{
+	bool unshare = uv_query_test_call(BIT_UVC_CMD_REMOVE_SHARED_ACCESS);
+	bool share = uv_query_test_call(BIT_UVC_CMD_SET_SHARED_ACCESS);
+
+	report(!(share ^ unshare), "share bits");
+}
+
 int main(void)
 {
 	bool has_uvc = test_facility(158);
@@ -169,6 +177,12 @@ int main(void)
 		goto done;
 	}
 
+	/*
+	 * Needs to be done before the guest-fence,
+	 * as the fence tests if both shared bits are present
+	 */
+	test_share_bits();
+
 	if (!uv_os_is_guest()) {
 		report_skip("Not a protected guest");
 		goto done;
-- 
2.30.2

