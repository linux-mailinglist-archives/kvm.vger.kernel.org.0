Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B023354E0E
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbhDFHlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236586AbhDFHlL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:11 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367YA6t028832
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=EfL/kDE6fuF7vdMI66aibmN5UZf0hrOEvp3yuYUkV7M=;
 b=ra1MyQeN9QUhd8ZghAFaCqvzUAGGetXZokZiHSDTbGPPD9BJ38AzNeDSEreTPUuaCl3b
 3lluat2gFirvum3+XAw1cJQ6NGy96qiwpUPLvRP0Uf33r/pBShBHdjr9symeX/yA6V0+
 +gzGRxijuFCQkZjlhM+VrpxmKPVdiW2SVcHIwIoC992ouyVGhlk62LslqZTdBtXxdyO6
 Br8lZdJ6TcxFagbaYSbzHOluIeaQvffwydPEUqxkwopJ97gmxBzIuplr3xahGYCARgbE
 yWUrmrZb1vb46GC3Z/aAXzaamtr0gme0UpUbmYmmTvcn43Rk+ciZ9PJj13wIqV32CJIv Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5tyk6kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:03 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367YPIj029500
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:03 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5tyk6js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:03 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367WscD026282;
        Tue, 6 Apr 2021 07:41:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 37q2y9hwtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:41:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367ewqE52429228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 283374C04E;
        Tue,  6 Apr 2021 07:40:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAE7F4C059;
        Tue,  6 Apr 2021 07:40:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 09/16] s390x: css: ssch with mis aligned ORB
Date:   Tue,  6 Apr 2021 09:40:46 +0200
Message-Id: <1617694853-6881-10-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _CYlXvYCxJr2sUQv7wn9BVl3rrdIlMFC
X-Proofpoint-GUID: hJQ18OhwKh167TZUQPkxGmQjz_DPBlim
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxscore=0 mlxlogscore=850 priorityscore=1501 adultscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We expect a specification exception for a misaligned ORB.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index d248cac..47452ba 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -103,9 +103,30 @@ static void ssch_orb_cpa_zero(void)
 	orb->cpa = cpa;
 }
 
+static void ssch_orb_alignment(void)
+{
+	void *p;
+
+	/* Prepare a Valid orb on a misaligned address*/
+	p = alloc_pages_flags(0, AREA_DMA31);
+	assert(p);
+	p += 2;
+
+	((struct orb *)p)->intparm = test_device_sid;
+	((struct orb *)p)->ctrl = ORB_CTRL_ISIC | ORB_CTRL_FMT | ORB_LPM_DFLT;
+	((struct orb *)p)->cpa = (long)ccw;
+
+	expect_pgm_int();
+	ssch(test_device_sid, p);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+	free_pages(p - 2);
+}
+
 static struct tests ssh_tests[] = {
 	{ "privilege", ssch_privilege },
 	{ "orb cpa zero", ssch_orb_cpa_zero },
+	{ "orb alignment", ssch_orb_alignment },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

