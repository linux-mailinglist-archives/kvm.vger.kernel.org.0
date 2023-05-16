Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4C5704EAB
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 15:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbjEPNFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 09:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbjEPNF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 09:05:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EC37EDC;
        Tue, 16 May 2023 06:05:13 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GD4XIC021706;
        Tue, 16 May 2023 13:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1IczDNc8tH0/j9KgWi5OwHxjchX8LQZKK8D9BTZ+So0=;
 b=nH78+UBTH5wwXNiYKpJLNUiTdXsoTHotOcCr3+sFQBSi5Aur7TwZBJtcIBw3MXbP7HO5
 nCGAE8z/RVhC35lzbUrknYqKWPQa/0R2jLd+8nLD3bDob2ME9c7D3SmLbz82qVxHyHBj
 QHmnFD5JPJVcwSROvH0bqJSlHBBTeGIeIiKdrq1FM3Pdg8zNI8juYayIJ4NIwP+iRJR2
 BRBx7Y0LNkU+mlZ8jEvgVtbzL6w/oh6eov38vuhormeT58adIt6iF3Fx8aeiffl8HrV0
 nHNmjjkqqQLb/XmKZxhcGq9MpOvFnarLB/3gL1RLnb/b7j0A7yoyMVorSue8NPxXDChv 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm8h63wgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:05:10 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GD4kno022784;
        Tue, 16 May 2023 13:05:06 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm8h63w7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:05:06 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34G9cQbu029898;
        Tue, 16 May 2023 13:05:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3qj1tdscet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:05:00 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GD4v0g21627584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 May 2023 13:04:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2167F20040;
        Tue, 16 May 2023 13:04:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E58052004D;
        Tue, 16 May 2023 13:04:56 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 16 May 2023 13:04:56 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 3/6] s390x: lib: don't forward PSW when handling exception in SIE
Date:   Tue, 16 May 2023 15:04:53 +0200
Message-Id: <20230516130456.256205-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230516130456.256205-1-nrb@linux.ibm.com>
References: <20230516130456.256205-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d_pITMD3Lkh-P34nQAYjU1UXvOnZnOtE
X-Proofpoint-ORIG-GUID: dpSueACaiKWC-PWuJI0Ffwbb9rH1vhxa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_06,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 mlxscore=0 clxscore=1015 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 1180ec44d72f..2e5309cee40f 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -148,6 +148,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 	if (lowcore.pgm_old_psw.addr >= (uint64_t)&sie_entry &&
 	    lowcore.pgm_old_psw.addr <= (uint64_t)&sie_exit) {
 		lowcore.pgm_old_psw.addr = (uint64_t)&sie_exit;
+		return;
 	}
 
 	switch (lowcore.pgm_int_code) {
-- 
2.39.1

