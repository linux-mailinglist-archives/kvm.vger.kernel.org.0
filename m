Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82974606038
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 14:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiJTMcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 08:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJTMb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 08:31:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EDE42AF7
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 05:31:58 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KCS4pC021262
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:31:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vRW/cHVW306AYCHJzYRZ10i0nVe6XF1mhOx+r/fQmKs=;
 b=hG+vZEoiOlwXPo66cIwcgzSB5F17P0RgQe/nW0I5QfHDutte4f5EnUda7ul4ZhqzHQeU
 PhzUOtesjIdvsGIpAjHtvxNS4XCD6xusDLeV9zOMaErhTm1WSSmr7yW6EDvdcNtbsf5A
 DUiHs1qw76ENtgGKpfMLB37cuyegaTX1iA2s1xEeU93RDMVG1kaBPRvldNYa3SH7c26q
 xYgNLiU4w1wBF6ghUKfqys1uIK0uH4I4d0FChngyDUC1ifZBynalAut8Z8Hqs9R+UbGw
 k42qOwybdqLmq9Fyw4iMq6kW2W5DbnHIWvMCoBI8VQS8ZFDSqPplB8/slviymccyyFV3 +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb6c3g273-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:31:57 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KCU7lb028212
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:31:57 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb6c3g26n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 12:31:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KCLimL010926;
        Thu, 20 Oct 2022 12:31:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg98x35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 12:31:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KCWPDu52035858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 12:32:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31F5A42041;
        Thu, 20 Oct 2022 12:31:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD7D642045;
        Thu, 20 Oct 2022 12:31:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.8.239])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 12:31:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/2] s390x: uv-host: fix allocation of UV memory
Date:   Thu, 20 Oct 2022 14:31:43 +0200
Message-Id: <20221020123143.213778-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221020123143.213778-1-imbrenda@linux.ibm.com>
References: <20221020123143.213778-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PPmBqTHyiTLW1C9hsRsU524v_KzRfPpP
X-Proofpoint-ORIG-GUID: 947igDjtJKL8v54WGyhX3A25XnmLquMj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_03,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=1015 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200072
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
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by; Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/uv-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index a1a6d120..e1fc0213 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -329,7 +329,7 @@ static void test_init(void)
 	struct psw psw;
 
 	/* Donated storage needs to be over 2GB */
-	mem = (uint64_t)memalign(1UL << 31, uvcb_qui.uv_base_stor_len);
+	mem = (uint64_t)memalign_pages_flags(SZ_1M, uvcb_qui.uv_base_stor_len, AREA_NORMAL);
 
 	uvcb_init.header.len = sizeof(uvcb_init);
 	uvcb_init.header.cmd = UVC_CMD_INIT_UV;
-- 
2.37.3

