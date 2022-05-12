Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D9352492A
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352177AbiELJhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352104AbiELJfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA04625B
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:45 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9FMTv021308
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kWXBR0czXeMGNOjQwe7x7dejSgIQuD3w4ONNM/DqNVk=;
 b=N3O0v1NQo+YdxEyLxBTbhEYxk8GFLNe/U93Bp5nj1UcCRBCnXchm3C7daYTU48RKqXnz
 iXuJt4dzQXz99RSGTLeZvXLDxmprhffPHUQlLhWp+iBVw5J7Q7/zAzIldoQ1S7RIXnUZ
 FZ+4zkaRdDenvXoyReNiV14PUkVhjvByHGFM7ATMIBSNj9WO+6b5lRY5zIWt+mOa2gqW
 T9I1/zD7UIRjGYpmLcNOeUyHLRpNFENnm88cfjjuqgNMf0uzLs6F9QNt6ykrMwThqXpa
 rt8zkXRjZH5G9j8lORSCD1AI2qjS3auqevXODnLw2FAppU/flsZeL5bLfQ2yjq3XY5Tb GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yefrbfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:44 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9H6nU001916
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yefrbed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XTQC023792;
        Thu, 12 May 2022 09:35:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd8xrya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZcRf57409966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBCAA11C052;
        Thu, 12 May 2022 09:35:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AFE611C04C;
        Thu, 12 May 2022 09:35:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:38 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 26/28] s390x: uv-guest: Remove double report_prefix_pop
Date:   Thu, 12 May 2022 11:35:21 +0200
Message-Id: <20220512093523.36132-27-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uliENXFaHWhQGaVKb5jCFT1fbRUfkzrc
X-Proofpoint-GUID: 35OYH5gVKcZQghKjvUWdYn8M_cTCZ2WZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/uv-guest.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 728c60aa..fd2cfef1 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -111,8 +111,6 @@ static void test_sharing(void)
 	cc = uv_call(0, (u64)&uvcb);
 	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "unshare");
 	report_prefix_pop();
-
-	report_prefix_pop();
 }
 
 static struct {
-- 
2.36.1

