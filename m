Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237A16C9D87
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 10:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbjC0IV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 04:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbjC0IV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 04:21:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0023A1BFE;
        Mon, 27 Mar 2023 01:21:25 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32R6x8PS012834;
        Mon, 27 Mar 2023 08:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WgEFqqk5JIGLh8gZ+T28ZWgNnhlS7cfZjtXdy41apYw=;
 b=izKI/N50VXuSaB7compajxxW+jm9NjdXWVPgi0xk0BC+wi3SgdeLeQHlInJhG738EopB
 jWNwYyc/64wZRUF2/iadudxdb+1FLiot1TflZbwDsyUcwwP5Pf5s4+2ntuWegXvWj7BA
 rlkV6h0PCctfzoMlNcMs+2nxCq0uyFegLmAcFuU/VOmM4leWVqJ0lAjFpZN31je2m3s5
 J03dy8+0LSG/hXK6jUWQWXY6Ds8BpGG4z58xJMfw6fAnczbdm8MTbRqbeYSAkMTEC2PQ
 pwhq7kLtb30pJSN24HTJEHZjkLdRq+/0x7Nt2uCZ0U39OMiMHqBWBKDN5njiA7HPvbvq nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pjb1a9a86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 08:21:25 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32R6gRDP018729;
        Mon, 27 Mar 2023 08:21:25 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pjb1a9a7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 08:21:25 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32R17lA2004114;
        Mon, 27 Mar 2023 08:21:22 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3phrk6a69r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 08:21:22 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32R8LJ5J46006684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 08:21:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41FBE2004B;
        Mon, 27 Mar 2023 08:21:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 189242004F;
        Mon, 27 Mar 2023 08:21:19 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 27 Mar 2023 08:21:19 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 2/4] s390x: lib: don't forward PSW when handling exception in SIE
Date:   Mon, 27 Mar 2023 10:21:16 +0200
Message-Id: <20230327082118.2177-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230327082118.2177-1-nrb@linux.ibm.com>
References: <20230327082118.2177-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PWCjIqpHXeuT-06gjEnq24gpPWpQ5Usk
X-Proofpoint-GUID: JWcc9Kw-krXNI2RUSR6U5f7VvVu1PKgU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxscore=0 adultscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270065
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we're handling a pgm int in SIE, we want to return to the SIE
cleanup after handling the exception. That's why we set pgm_old_psw to
the sie_exit label in fixup_pgm_int.

On nullifing pgm ints, fixup_pgm_int will also forward the old PSW such
that we don't cause an pgm int again.

However, when we want to return to the sie_exit label, this is not
needed (since we've manually set pgm_old_psw). Instead, forwarding the
PSW might cause us to skip an instruction or end up in the middle of an
instruction.

So, let's just skip the rest of the fixup in case we're inside SIE.

Note that we're intentionally not fixing up the PSW in the guest; that's
best left to the test at hand by registering their own psw fixup.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/interrupt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 3f993a363ae2..eb3d6a9b701d 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -110,6 +110,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 	if (lowcore.pgm_old_psw.addr >= (uint64_t)&sie_entry &&
 	    lowcore.pgm_old_psw.addr <= (uint64_t)&sie_exit) {
 		lowcore.pgm_old_psw.addr = (uint64_t)&sie_exit;
+		return;
 	}
 
 	switch (lowcore.pgm_int_code) {
-- 
2.39.1

