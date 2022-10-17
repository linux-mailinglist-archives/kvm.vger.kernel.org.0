Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC00D600B14
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 11:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiJQJkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 05:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiJQJkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 05:40:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28ED2612F
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 02:40:03 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29H9Sikd036486
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WNn40PAhbPsmQBWNZBVICZokJRHvZeoAljktxOW7PMw=;
 b=LIbJmY8Tf4z9kjYzzLMJNF3Faoozgued9kNfdGCBk0uOSY0D7m6pSoW018ZPOE/qH/gp
 WRTBrb8VYTOg3iLJBTOMbgw/2FI1uzSHFy0MnKVrYrHzbEmaZEhTXLk/Vm+rB2X0wy7e
 6Chlal1enIpFYszCx+CabhyNiYa3Gp57+wjBYslZUSgGNmrkcxE9XvI1YcG2ZsDRnYDp
 SOm4K4+mkBT2QsjTwjQvfQI/lC64MGuxpxfEg2d26YXjwQ3JE+aJMSwBzHGNRBlnXbVh
 a1xLTxv/LQC5qrx+iVKu0YoVuViCDOdiUbOo77bG5p/2YA/CiQ0BxhGhWtVD3ekgVCXg rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86ugben4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:03 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29H9LN9H018885
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86ugbekp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:40:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29H9Z51M009839;
        Mon, 17 Oct 2022 09:40:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg92qmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:40:00 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29H9eUl352953398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 09:40:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83DDCA405B;
        Mon, 17 Oct 2022 09:39:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBBD3A4054;
        Mon, 17 Oct 2022 09:39:56 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Oct 2022 09:39:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 6/8] s390x: uv-host: Remove duplicated +
Date:   Mon, 17 Oct 2022 09:39:23 +0000
Message-Id: <20221017093925.2038-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221017093925.2038-1-frankja@linux.ibm.com>
References: <20221017093925.2038-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3-CbA8icW13Q7PWT1__LBC5LLzy3AIcW
X-Proofpoint-ORIG-GUID: mbALF1iH5YhCEJjS01S6zIXTO2AtJ8qt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_07,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210170055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

One + is definitely enough here.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/uv-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 05502d9a..76d3e373 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -451,7 +451,7 @@ static void test_config_create(void)
 	uvcb_cgc.guest_sca = tmp;
 
 	tmp = uvcb_cgc.guest_sca;
-	uvcb_cgc.guest_sca = get_max_ram_size() + + PAGE_SIZE * 4;
+	uvcb_cgc.guest_sca = get_max_ram_size() + PAGE_SIZE * 4;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
 	report(uvcb_cgc.header.rc == 0x10d && rc == 1,
 	       "sca inaccessible");
-- 
2.34.1

