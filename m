Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172016F44DA
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 15:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbjEBNO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 09:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbjEBNO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 09:14:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0CBE4D;
        Tue,  2 May 2023 06:14:55 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342D8WLf011697;
        Tue, 2 May 2023 13:14:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YRyBzNqnnynE+z107Ep0FeJ+iML5TzKShPDIZWT8ouI=;
 b=JUNFadRJQjo7Sd91cxGEkaKOnChcOt32j91XihFdD5etl79OkdCTaPcMbx1UP2WwZvTe
 5yvzpoO7QfgEzcY4CAkq5FpCZCs+aeImMJxZdIJ5NAJSlcoGHO5REAy3IRcOpiIvAKgX
 H00ScV6fPXgARiQpB64DqttTyc1m/kST6JEzg6IZTG+3WCx2iyOfWsq0+UdyZI8ELw9E
 9jyxCSNCsBWBZWn5WzS4/W3anjh+yRnNayFvlDtaxJLWQ3CaOpsq2QcJ4K+bK1VuMs1U
 1lsPqnQwwE09X0PO0lJGf0dC3/fkUhHRBgnvOJRFj1ihtnHIvKSf08ZaMulub3liaYR5 UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2s394nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:14:54 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342D8d7P011990;
        Tue, 2 May 2023 13:14:32 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2s394gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:14:32 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3427Ybht001893;
        Tue, 2 May 2023 13:09:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6har6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342D9KOL34341296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:09:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48E2D20040;
        Tue,  2 May 2023 13:09:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F8D520049;
        Tue,  2 May 2023 13:09:19 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:09:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/9] s390x: uv-host: Check for sufficient amount of memory
Date:   Tue,  2 May 2023 13:07:25 +0000
Message-Id: <20230502130732.147210-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502130732.147210-1-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Vl1fyEUE3i1a7yLLW3A0w6U92Dyo26GZ
X-Proofpoint-GUID: s-MoTJPofgXyjwoQsjDj2UtjYtvVZ8oi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2305020111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The UV init storage needs to be above 2G so we need a little over 2G
of memory when running the test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 9dfaebd7..34ca7148 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -15,6 +15,7 @@
 #include <sclp.h>
 #include <smp.h>
 #include <uv.h>
+#include <snippet.h>
 #include <mmu.h>
 #include <asm/page.h>
 #include <asm/sigp.h>
@@ -720,6 +721,13 @@ int main(void)
 	test_invalid();
 	test_uv_uninitialized();
 	test_query();
+
+	if (get_ram_size() < SNIPPET_PV_MIN_MEM_SIZE) {
+		report_skip("Not enough memory. This test needs about %ld MB of memory",
+			    SNIPPET_PV_MIN_MEM_SIZE / 1024 / 1024);
+		goto done;
+	}
+
 	test_init();
 
 	setup_vmem();
-- 
2.34.1

