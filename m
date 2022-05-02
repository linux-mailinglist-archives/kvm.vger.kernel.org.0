Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C360516D91
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 11:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384326AbiEBJnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 05:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384319AbiEBJnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 05:43:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0070E1F635;
        Mon,  2 May 2022 02:39:36 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2429AW1Y023526;
        Mon, 2 May 2022 09:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YeEcwzoQU2gf96jlbH7OCr7mO808nxIs0WgsMo5NncI=;
 b=niqZvD7QjHRULzDsd+isELsRUHHNplGy/4SAwDQ99nBsacYg5ZDKVkn3yShXeZ8unfGt
 acAzFHmq77TVr1qiAUzco6q9/tYjB5jruNtlk/FUO23ZjFR0WWtUHt7XWF7T6g6kIXWQ
 rIM1WpRf2Ukhc+P6liX5xE1POiGG6b6IoS04yp4+5VQ++wfmCsQYRDS3ShD93wEU4cdZ
 ZF/yy+HCG28XqWADVo56mrX9jX9dLr/92r69lKu/V3Yd16NamB10CUuRT5uUu7uJgGjO
 bOHuRMMPFAzDdfWQ5gDmhICCZdEQvLjtTiJ/dLw6uSS+dfwXTaFRjxTm/x/i/9q1xppV Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftc988j16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:36 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2429WMLH000917;
        Mon, 2 May 2022 09:39:35 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftc988j0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:35 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2429dEs5003965;
        Mon, 2 May 2022 09:39:33 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3frvr8tfam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2429dUkc46268906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 09:39:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97662AE053;
        Mon,  2 May 2022 09:39:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC68FAE045;
        Mon,  2 May 2022 09:39:29 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 09:39:29 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 4/6] s390x: uv-guest: Remove double report_prefix_pop
Date:   Mon,  2 May 2022 09:39:23 +0000
Message-Id: <20220502093925.4118-5-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220502093925.4118-1-seiden@linux.ibm.com>
References: <20220502093925.4118-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1mCJ5ZMZDmlM2dCGnujXmulCd2r9FFps
X-Proofpoint-ORIG-GUID: 1rUNl2ahIkicXEf2jgVrBbYbbB50vWds
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_03,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
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
2.30.2

