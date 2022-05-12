Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3520524910
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352097AbiELJfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352009AbiELJfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE4969B78
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:36 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9Ewwp019286
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WClAnKcrn3d9d4fNcMf0WsY5mZnNyZUO+NwFG1dz9Bg=;
 b=pPK0wBstY2WcpFkNtbwp4o/Ok1wYbR+W+D69B0FpdcWtFYbeC/r1xUYQfKhUpG5ti93W
 A5z8fHHQ5eGnpiG507xni56n9J+DgO5il3rpOQJ2d69dwx3mbhVzxphiyVnYF16opB4V
 heP6h3p5QdNvYB7HpHr5rAlK5/VXGRx0WI3/PCmEY9Z0VRlJkHaO+M5uZtAWfy61JNOW
 nM00RxUG61og8LxyClJxh7LPUw/jN1OTSkQeG6QE/C5LEp+r59ZbbSA4mbJyAdEUzZwe
 dgW0fH0Rgc9Lii5kR3rUPpXj8rQPomzOI4bAvvk9JwbLAh+Zt5X0xNUrfA7asSKrLqPz pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yefrbbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:36 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9K63a015248
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:35 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yefrbay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:35 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XU3i023800;
        Thu, 12 May 2022 09:35:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd8xrxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:33 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9Z9O433292778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9497711C054;
        Thu, 12 May 2022 09:35:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4405011C050;
        Thu, 12 May 2022 09:35:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:30 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 05/28] s390x: smp: make stop stopped cpu look the same as the running case
Date:   Thu, 12 May 2022 11:35:00 +0200
Message-Id: <20220512093523.36132-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vPrCsc2hJs-grc9Mw031P111bFmlN9W4
X-Proofpoint-GUID: EWbtKAArgypp1Sp1dzulSOHdyNLbXL-Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=896
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

From: Nico Boehr <nrb@linux.ibm.com>

Adjust the stop stopped CPU case such that it looks the same as the stop running
CPU case: use the nowait variant, handle the error code in the same way and make
the report messages look the same.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 5257852c..de3aba71 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -144,8 +144,9 @@ static void test_stop(void)
 	report(smp_cpu_stopped(1), "cpu stopped");
 
 	report_prefix_push("stop stopped CPU");
-	report(!smp_cpu_stop(1), "STOP succeeds");
-	report(smp_cpu_stopped(1), "CPU is stopped");
+	rc = smp_cpu_stop_nowait(1);
+	report(!rc, "return code");
+	report(smp_cpu_stopped(1), "cpu stopped");
 	report_prefix_pop();
 
 	report_prefix_pop();
-- 
2.36.1

