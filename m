Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7534CC78A
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiCCVFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbiCCVFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:05:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F628954AB;
        Thu,  3 Mar 2022 13:04:33 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223JIrKT017700;
        Thu, 3 Mar 2022 21:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GTmNGpl7gE00KNwgGmtP2Xqpg3CFrt+iiO3gyZizRuc=;
 b=F1MtN+zE9q3h9BdUxetX0+xflTxuXeKv/wKBrx22HrpUo/mL4wD8Ae81C12WrHJmNn5k
 695G/be+ZXqgh6E62l1xY8lE16bD/zQxDUhsQ9PqahmUnA3aqAzCp+ECQSZBksxKRt6l
 YHXqFcASm2lsrdxSy8ZDJf/HXYGPRNPfxb5rr81a/rhQGGqIwim0Xe+r0TABjTQUXxvC
 0gEpkeIYhiFUXBsOiv0tploHjgfQF2JltWUMTFv1/dh38I1vJ5LwRQkOx0LcesyjoKxy
 GKcwMe7ZsVsmXW/V0Swvke33eEcMvi9/gOvByRoMDjiOPMWqggYFsiVGINJt0wjDzXTT qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek3qphtmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:33 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223Ktl5P005556;
        Thu, 3 Mar 2022 21:04:32 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek3qphtkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223L2veI021324;
        Thu, 3 Mar 2022 21:04:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ek4k402k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223L4QSe41746924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 21:04:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF8C411C04A;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDCAE11C054;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7DC17E03B1; Thu,  3 Mar 2022 22:04:26 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v1 1/6] lib: s390x: smp: Retry SIGP SENSE on CC2
Date:   Thu,  3 Mar 2022 22:04:20 +0100
Message-Id: <20220303210425.1693486-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220303210425.1693486-1-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JtdI-HSoOrUAxZBdj1ET2I7iRPs78YBJ
X-Proofpoint-ORIG-GUID: R8JHdvL1EzsgU5Hw1ylUQnvhOptaJ8Z6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
2.32.0

