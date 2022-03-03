Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FDE4CC78E
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbiCCVFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbiCCVFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:05:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F71986D7;
        Thu,  3 Mar 2022 13:04:33 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KZU8t020313;
        Thu, 3 Mar 2022 21:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3ZH8MdghW/0bZQm9UWePe5VZGRdVrWK2R6PL6sAdecU=;
 b=sZpVKdlrbn11lDqG6xUG1Ac7jYqnBj+QuwrFAifrEsM4ExZ234LJ1XBtZwEDVi64bCNC
 valo4i7D9JyEHywoq4TPObw0lntq5lW/zfhA3AaStLkL//7k6Auy304tA8lKsvtvep8w
 kWOrmzx1UbnqwXQDrfSv1xyrIaVj8OX5dwfgn/NPbR74Jb64Fxy9ha4Jl8yP5PXX2xXz
 OzTzIq1v5PFvD4NVHb/6y6ayb4tXX3GTu/4iySCCrdDb0h1x4Aoz/Oob8S7DY7UeGyAP
 XELjLvy7Armhs4xTnkulv6f/UdkCqN+psmQk/tVq2mzsBjiqZKYv228MPUorxkU+JIcg cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ek4uk8fm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:32 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223KgPrK020374;
        Thu, 3 Mar 2022 21:04:32 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ek4uk8fkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:32 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223L2wVR007966;
        Thu, 3 Mar 2022 21:04:30 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ek4k40231-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:30 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223KrSgf50266610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 20:53:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B20542049;
        Thu,  3 Mar 2022 21:04:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1763142041;
        Thu,  3 Mar 2022 21:04:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  3 Mar 2022 21:04:27 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 89BE4E048E; Thu,  3 Mar 2022 22:04:26 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v1 6/6] lib: s390x: smp: Convert remaining smp_sigp to _retry
Date:   Thu,  3 Mar 2022 22:04:25 +0100
Message-Id: <20220303210425.1693486-7-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220303210425.1693486-1-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BoWTKvWYIczb_Vagb8cEPQc_c4Biz-oL
X-Proofpoint-ORIG-GUID: fr8QLmWkab7E53jue4vTnF47G35AfNXH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 clxscore=1011 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203030095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A SIGP SENSE is used to determine if a CPU is stopped or operating,
and thus has a vested interest in ensuring it received a CC0 or CC1,
instead of a CC2 (BUSY). But, any order could receive a CC2 response,
and is probably ill-equipped to respond to it.

In practice, the order is likely to only encounter this when racing
with a SIGP STOP (AND STORE STATUS) or SIGP RESTART order, which are
unlikely. But, since it's not impossible, let's convert the library
calls that issue a SIGP to loop on CC2 so the callers do not need
to react to that possible outcome.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 lib/s390x/smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 85b046a5..2e476264 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -85,7 +85,7 @@ bool smp_cpu_stopped(uint16_t idx)
 
 bool smp_sense_running_status(uint16_t idx)
 {
-	if (smp_sigp(idx, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
+	if (smp_sigp_retry(idx, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
 		return true;
 	/* Status stored condition code is equivalent to cpu not running. */
 	return false;
@@ -169,7 +169,7 @@ static int smp_cpu_restart_nolock(uint16_t idx, struct psw *psw)
 	 * running after the restart.
 	 */
 	smp_cpu_stop_nolock(idx, false);
-	rc = smp_sigp(idx, SIGP_RESTART, 0, NULL);
+	rc = smp_sigp_retry(idx, SIGP_RESTART, 0, NULL);
 	if (rc)
 		return rc;
 	/*
-- 
2.32.0

