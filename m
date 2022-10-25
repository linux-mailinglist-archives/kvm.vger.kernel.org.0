Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5783B60CB27
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJYLoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbiJYLn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6041F17579E
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:56 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB891H028179
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YKdBzTKjyGoc08uZsMMYw6HkTyEebJff88vpFXTYmBM=;
 b=OCymQbhEJU3VnE9twdP49Y2zeHFd68JrIvOSiTzl9ed/V8QCcm0DXs3QanEOmKrJMX1x
 YkhnyJqe6XjT4PYjiJLGWdQ7Nt62G0AHe6r3QCC4tO67Uqc8p/coC+mmxdKoW7QDo+FZ
 A6WaqGt5kSJxs/O2Uj3sSZfoKU7qJmgZudlqgN9AWWpJY2kviiupZgd/126qeMqc5yG+
 1qN0IJNtc4bXthC7a7kGGHTNeDgyJIF2/g60GFLGbTwBklv8aaTJmBm+ghuA5jhqcWO4
 YPylSV+QNukCpJZNZE3eOSseSlfXfMhVHPG5ZcheQafwvh6g7aER7oNgfzBBBzgL0p2e fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee35t8f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:55 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PB8AZB028265
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:55 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee35t8e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBd8YP024257;
        Tue, 25 Oct 2022 11:43:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3kdugat57c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBhoQ14981394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:43:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC63FAE04D;
        Tue, 25 Oct 2022 11:43:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFB2CAE053;
        Tue, 25 Oct 2022 11:43:49 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:49 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 16/22] s390x: uv-host: fix allocation of UV memory
Date:   Tue, 25 Oct 2022 13:43:39 +0200
Message-Id: <20221025114345.28003-17-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _lxJ20aQGQkpPjQQjmmKv1I4ocQr4NBY
X-Proofpoint-GUID: xw8rduj7b6rx9gLRd4_KK_cdHqb6aZqD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=985
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allocate the donated storage with 1M alignment from the normal pool, to
force it to be above 2G without wasting a whole 2G block of memory.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20221020123143.213778-3-imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/uv-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 191e8b3f..9f09f80e 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -504,7 +504,7 @@ static void test_init(void)
 	struct psw psw;
 
 	/* Donated storage needs to be over 2GB */
-	mem = (uint64_t)memalign(1UL << 31, uvcb_qui.uv_base_stor_len);
+	mem = (uint64_t)memalign_pages_flags(SZ_1M, uvcb_qui.uv_base_stor_len, AREA_NORMAL);
 
 	uvcb_init.header.len = sizeof(uvcb_init);
 	uvcb_init.header.cmd = UVC_CMD_INIT_UV;
-- 
2.37.3

