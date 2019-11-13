Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D03FB052
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 13:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfKMMX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 07:23:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726449AbfKMMX0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 07:23:26 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADCIEWL118425
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:23:26 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w8gg5kdj7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:23:25 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 13 Nov 2019 12:23:23 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 12:23:22 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADCNLYs50593828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 12:23:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CB624C052;
        Wed, 13 Nov 2019 12:23:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D21434C050;
        Wed, 13 Nov 2019 12:23:20 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.55])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 12:23:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [PATCH v1 3/4] s390x:irq: make IRQ handler weak
Date:   Wed, 13 Nov 2019 13:23:18 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111312-0016-0000-0000-000002C34919
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111312-0017-0000-0000-00003324E434
Message-Id: <1573647799-30584-4-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=2 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=2
 clxscore=1015 lowpriorityscore=0 mlxscore=2 impostorscore=0
 mlxlogscore=160 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having a weak function allows the tests programm to declare its own IRQ
handler.
This is helpfull when developping I/O tests.
---
 lib/s390x/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 7aecfc5..0049194 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -140,7 +140,7 @@ void handle_mcck_int(sregs_t *regs)
 		     lc->mcck_old_psw.addr);
 }
 
-void handle_io_int(sregs_t *regs)
+__attribute__((weak)) void handle_io_int(sregs_t *regs)
 {
 	report_abort("Unexpected io interrupt: at %#lx",
 		     lc->io_old_psw.addr);
-- 
2.7.4

