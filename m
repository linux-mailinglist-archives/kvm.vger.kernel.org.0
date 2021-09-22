Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87934414276
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhIVHUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:20:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233228AbhIVHUf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 03:20:35 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M6CvK5018881;
        Wed, 22 Sep 2021 03:19:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ih18O89CAt9Jc6itVCK/6O7R2Ea4Fi8D95DsC3HHXzg=;
 b=rn4jQIWhYUt6sf9FVOKgkWf2aHvow/MpDy2UGGNv18Inn/JTFxAvkvkunIGNATMTb1r7
 GThEgBYkjYJIjXCAk4djCgFrtAj8GptfOuHcsVeXkt9ieSk4xkLvPVajLQDHOXl6zOAa
 jG4N08wso8wIADeGIbzzQpX92VhRZRkEgk9MNPC1e3xtIEnfcbPcNXrFnx/+Hwe4E9h7
 fcAwqr7NcwVurYx0Lyjsczd2gciuNPEg7JjR4x+IQUu5tDoWky2e5+jK5zAToaRzplOI
 tXbj1/ygZ3UJDboGiWN5/BpxIdmAfm9J4RSwVAVXgU6QsvY9gmcSr57F935QF2Fwhsmo tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7t09er16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:05 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M6jZpx025518;
        Wed, 22 Sep 2021 03:19:04 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7t09er0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:04 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M78EEj013387;
        Wed, 22 Sep 2021 07:19:02 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3b7q6pkgru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:19:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M7ECoq61604304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 07:14:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE054A405F;
        Wed, 22 Sep 2021 07:18:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22E70A4055;
        Wed, 22 Sep 2021 07:18:58 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 07:18:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 6/9] lib: s390x: Print PGM code as hex
Date:   Wed, 22 Sep 2021 07:18:08 +0000
Message-Id: <20210922071811.1913-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210922071811.1913-1-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D9Qtpszowo1kJOATJincpMf_eqGolsTW
X-Proofpoint-ORIG-GUID: hosBIHoWeZrNvMUCvwC9vryFuU8vUet1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_02,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=932 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have them defined as hex constants in lib/s390x/asm/arch_def.h so
why not print them as hex values?

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 126d4c0a..27d3b767 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -169,7 +169,7 @@ static void print_pgm_info(struct stack_frame_int *stack)
 		  lc->pgm_old_psw.addr <= (uintptr_t)sie_exit);
 
 	printf("\n");
-	printf("Unexpected program interrupt %s: %d on cpu %d at %#lx, ilen %d\n",
+	printf("Unexpected program interrupt %s: %#x on cpu %d at %#lx, ilen %d\n",
 	       in_sie ? "in SIE" : "",
 	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr, lc->pgm_int_id);
 	print_int_regs(stack);
-- 
2.30.2

