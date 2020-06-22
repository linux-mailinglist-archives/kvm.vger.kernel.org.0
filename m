Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6DA203C6F
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgFVQV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:21:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49046 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729718AbgFVQVz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 12:21:55 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MGCcXL030873
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:54 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31spnv7txs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:53 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MGLge3050896
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:50 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31spnv7twp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 12:21:50 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MFxxxS025826;
        Mon, 22 Jun 2020 16:21:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 31sa381j27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 16:21:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MGLhfK46989564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 16:21:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD30B52050;
        Mon, 22 Jun 2020 16:21:43 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.197])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8AAFA5204E;
        Mon, 22 Jun 2020 16:21:43 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 6/8] lib/vmalloc: fix potential race and non-standard pointer arithmetic
Date:   Mon, 22 Jun 2020 18:21:39 +0200
Message-Id: <20200622162141.279716-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622162141.279716-1-imbrenda@linux.ibm.com>
References: <20200622162141.279716-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_09:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0
 cotscore=-2147483648 impostorscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pointer vfree_top should only be accessed with the lock held, so
make sure we return a local copy of the pointer taken safely inside the
lock.

Also avoid doing pointer arithmetic on void pointers. Gcc allows it but
it is an ugly hack. Use uintptr_t for doing maths on the pointer.

This will also come useful in upcoming patches.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/vmalloc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 74b785c..83e34aa 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -20,10 +20,16 @@ static void *page_root;
 
 void *alloc_vpages(ulong nr)
 {
+	uintptr_t ptr;
+
 	spin_lock(&lock);
-	vfree_top -= PAGE_SIZE * nr;
+	ptr = (uintptr_t)vfree_top;
+	ptr -= PAGE_SIZE * nr;
+	vfree_top = (void *)ptr;
 	spin_unlock(&lock);
-	return vfree_top;
+
+	/* Cannot return vfree_top here, we are outside the lock! */
+	return (void *)ptr;
 }
 
 void *alloc_vpage(void)
-- 
2.26.2

