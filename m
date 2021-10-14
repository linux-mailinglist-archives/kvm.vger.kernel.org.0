Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A93342D985
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 14:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhJNMxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 08:53:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhJNMxa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 08:53:30 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ECBepq030136;
        Thu, 14 Oct 2021 08:51:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qN8jVP25qo94y4WRSZRg4aVu9f8dGFEDccERx/vBXBg=;
 b=YNwdzdAgDC1/Tfgg5ZNceY2tXOR4/ysN0yka46QM/fTctNOr1nLIRSt/swic6LdizckF
 qJHCzC3BkO0XWbyXNhq/91k1tcMKwAfobocjbH0twYM65TsztX5i7/8l0+Kjx7HlgZid
 b8qcY+w0kYpDOYlVJpcjtj8ikG4ytjfpRZo6sSaFi9eVfXucKs9UpM0FLHRuPYHyuGaQ
 ackno3jUfa42J3baDlRpLmjdZrYq4nd4PR01RnMbrsOB6QTUJD5Cw7j2vnXz+NI2cQLX
 zHj44ZHjqPcs8KSnSqe9Nc45NWSlB5sduhsgUfduhmY7xu6EjQuq+wJ6d3vHHxHXBDZA Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bpfr2qkcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 08:51:24 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ECpO4N008432;
        Thu, 14 Oct 2021 08:51:24 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bpfr2qkbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 08:51:24 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19EClWEU009083;
        Thu, 14 Oct 2021 12:51:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2qa598g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 12:51:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ECpIvt49283406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 12:51:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A52FA405D;
        Thu, 14 Oct 2021 12:51:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E52DFA405E;
        Thu, 14 Oct 2021 12:51:16 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 12:51:16 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/3] lib: s390x: Fix PSW constant
Date:   Thu, 14 Oct 2021 12:51:05 +0000
Message-Id: <20211014125107.2877-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211014125107.2877-1-frankja@linux.ibm.com>
References: <20211014125107.2877-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2-mlzsdccXUYOYY726ywn7Nj18iBjfDf
X-Proofpoint-ORIG-GUID: PtgeZDeJALNvxO3A-z9nUkj9K50OL1IX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_07,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 clxscore=1015 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=813 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Somehow the ";" got into that patch and now complicates compilation.
Let's remove it and put the constant in braces.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index b34aa792..40626d72 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -53,7 +53,7 @@ struct psw {
 #define PSW_MASK_PSTATE			0x0001000000000000UL
 #define PSW_MASK_EA			0x0000000100000000UL
 #define PSW_MASK_BA			0x0000000080000000UL
-#define PSW_MASK_64			PSW_MASK_BA | PSW_MASK_EA;
+#define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
 
 #define CTL0_LOW_ADDR_PROT		(63 - 35)
 #define CTL0_EDAT			(63 - 40)
-- 
2.30.2

