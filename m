Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B135414284
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhIVHVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:21:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50326 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233226AbhIVHUf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 03:20:35 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M5BvGA032763;
        Wed, 22 Sep 2021 03:19:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nSH9GOiU/WIPxXLjUHWWeRe8Stoe2b9vZkVREoSEaeg=;
 b=OZM4E43ptfG8IPO/7qLfpOLvsvHJrIbcVgMZnrt2m5tyGamjQR2rA0ds/NPX1PJF1A7K
 Aw7xu+JIoAq7yqr3e04yl0EdgRWG2E0Far46Gcs/fB/4qG5EZjJltRnvk7jJBGJ4+4xz
 MWJEIRhUX46j9L7ziT+KcRMbfUj/hha3JTj468F8K5o07XFguvaqINXZS2S73VkVjIBI
 e2ZgsYEkW5oGVCYi/s0LJV8hcSMxs1vYYsqmuKY4ZXPd6qw43Mn18QBbwijYSuI7Idat
 uKt1mke/lm9Lh/5sOfJGN/ZQ07Boz1o28mC/EAEGo8bwiIFkUEv7YVeyiUBzxx+saCWo PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7x4jad6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:03 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M7Ip32024174;
        Wed, 22 Sep 2021 03:19:02 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7x4jad6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:02 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M77vh2030134;
        Wed, 22 Sep 2021 07:19:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3b7q6qugph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:19:00 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M7IvB364946500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 07:18:57 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC39CA4055;
        Wed, 22 Sep 2021 07:18:56 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2849FA4040;
        Wed, 22 Sep 2021 07:18:56 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 07:18:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 4/9] lib: s390x: uv: Fix share return value and print
Date:   Wed, 22 Sep 2021 07:18:06 +0000
Message-Id: <20210922071811.1913-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210922071811.1913-1-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1FZr4WfFYUR_dsGR5ReTXKW_YnK2kNdy
X-Proofpoint-ORIG-GUID: 1Fdj4x0Ntc0cUQBnGM6BSh-FM4-MxxnD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_02,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 phishscore=0 mlxlogscore=909 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109200000 definitions=main-2109220048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's only return 0/1 for success/failure respectively.
If needed we can later add rc/rrc pointers so we can check for the
reasons of cc==1 cases like we do in the kernel.

As share might also be used in snippets it's best not to use prints to
avoid linking problems so lets remove the report_info().

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index ec10d1c4..2f099553 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -219,15 +219,8 @@ static inline int share(unsigned long addr, u16 cmd)
 		.header.len = sizeof(uvcb),
 		.paddr = addr
 	};
-	int cc;
 
-	cc = uv_call(0, (u64)&uvcb);
-	if (!cc && uvcb.header.rc == UVC_RC_EXECUTED)
-		return 0;
-
-	report_info("uv_call: cmd %04x cc %d response code: %04x", cc, cmd,
-		    uvcb.header.rc);
-	return -1;
+	return uv_call(0, (u64)&uvcb);
 }
 
 /*
-- 
2.30.2

