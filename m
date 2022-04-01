Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A8A4EEC31
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345385AbiDALSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345491AbiDALSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B241183833
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:32 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2319nshx006693
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wzL5xJwNsFDnfnxbmIxwSXPBJVGThk0vkNbAHvvPNjQ=;
 b=otxd2NKadKkC+VSYok9EnaHIVActrhqdkxhHF3m4c5KZ96IGA9cz8K5wKe8y8ofFGw8K
 uMpVOCm7xsyyzQighPFtXqh18C/NVpWP9yc2zJrqA0h/iq2WNKd5afofTqh8d4zcbd7U
 gp+TEFQOZgIIJ5rypLrf+bAlWhuPm27skqDAwkPjHVotYyeGAJiFFvRLbUq24aceU2Sy
 Mb2fiv0Qfbwu3bgmYrUvydFgNWb3zVD+8zldw+4mb8HZTzny2tlAYsSLrvDP8C7cmXQQ
 +pbK2LG6RckOqSg3AhY/IzuPtZjkEphifiOZB4GVnqlRiZObU1RpNJ2ih+TOaUxbWGzq kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y3y1rmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:32 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231BGHv3021523
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:31 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y3y1rkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:31 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B87Cd013029;
        Fri, 1 Apr 2022 11:16:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf9mv09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231B4MXT23265708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:04:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC2054C06D;
        Fri,  1 Apr 2022 11:16:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C7A74C06F;
        Fri,  1 Apr 2022 11:16:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:25 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Eric Farman <farman@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 01/27] lib: s390x: smp: Retry SIGP SENSE on CC2
Date:   Fri,  1 Apr 2022 13:15:54 +0200
Message-Id: <20220401111620.366435-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D51sKuzq_mNXjARm6fiyf9OQn2qCXf-E
X-Proofpoint-ORIG-GUID: 3Tlu9RaiOHo9zExxGXLVGMkbItRwC7Rw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

The routine smp_cpu_stopped() issues a SIGP SENSE, and returns true
if it received a CC1 (STATUS STORED) with the STOPPED or CHECK STOP
bits enabled. Otherwise, it returns false.

This is misleading, because a CC2 (BUSY) merely indicates that the
order code could not be processed, not that the CPU is operating.
It could be operating but in the process of being stopped.

Convert the invocation of the SIGP SENSE to retry when a CC2 is
received, so we get a more definitive answer.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 46e1b022..368d6add 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -78,7 +78,7 @@ bool smp_cpu_stopped(uint16_t idx)
 {
 	uint32_t status;
 
-	if (smp_sigp(idx, SIGP_SENSE, 0, &status) != SIGP_CC_STATUS_STORED)
+	if (smp_sigp_retry(idx, SIGP_SENSE, 0, &status) != SIGP_CC_STATUS_STORED)
 		return false;
 	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
 }
-- 
2.34.1

