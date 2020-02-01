Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4B914F874
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 16:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgBAP3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 10:29:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43872 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726825AbgBAP3G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 1 Feb 2020 10:29:06 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 011FHYZR136800
        for <kvm@vger.kernel.org>; Sat, 1 Feb 2020 10:29:05 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xw7quxckn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2020 10:29:04 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Sat, 1 Feb 2020 15:29:03 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 1 Feb 2020 15:29:00 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 011FS79350856290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 1 Feb 2020 15:28:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F8E85204F;
        Sat,  1 Feb 2020 15:28:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.30.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DC1455204E;
        Sat,  1 Feb 2020 15:28:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 3/7] s390x: Stop the cpu that is executing exit()
Date:   Sat,  1 Feb 2020 10:28:47 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200201152851.82867-1-frankja@linux.ibm.com>
References: <20200201152851.82867-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020115-0012-0000-0000-00000382CBAA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020115-0013-0000-0000-000021BF2BB6
Message-Id: <20200201152851.82867-4-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-01_03:2020-01-31,2020-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=714 mlxscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002010113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPU 0 is not necessarily the CPU which does the exit if we ran into a
test abort situation. So, let's ask stap() which cpu does the exit and
stop it on exit.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index 32f09b5..e091c37 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -46,6 +46,6 @@ void exit(int code)
 	smp_teardown();
 	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
 	while (1) {
-		sigp(0, SIGP_STOP, 0, NULL);
+		sigp(stap(), SIGP_STOP, 0, NULL);
 	}
 }
-- 
2.20.1

