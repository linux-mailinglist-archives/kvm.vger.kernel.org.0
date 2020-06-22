Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9D1203C6C
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgFVQVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:21:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729599AbgFVQVu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 12:21:50 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MG2wIA103390
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:50 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysv8tm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:50 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MG3I2b106254
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:49 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysv8tjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 12:21:49 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MG30Qx015929;
        Mon, 22 Jun 2020 16:21:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 31sa381ejv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 16:21:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MGLig860686702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 16:21:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98C6F52051;
        Mon, 22 Jun 2020 16:21:44 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.197])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 491CE52050;
        Mon, 22 Jun 2020 16:21:44 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 8/8] lib/vmalloc: add locking and a check for initialization
Date:   Mon, 22 Jun 2020 18:21:41 +0200
Message-Id: <20200622162141.279716-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622162141.279716-1-imbrenda@linux.ibm.com>
References: <20200622162141.279716-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_09:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2
 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 cotscore=-2147483648 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make sure init_alloc_vpage is never called when vmalloc is in use.

Get both init_alloc_vpage and setup_vm to use the lock.

For setup_vm we only check at the end because at least on some
architectures setup_mmu can call init_alloc_vpage, which would cause
a deadlock.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/vmalloc.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 83e34aa..10f15af 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -37,11 +37,6 @@ void *alloc_vpage(void)
 	return alloc_vpages(1);
 }
 
-void init_alloc_vpage(void *top)
-{
-	vfree_top = top;
-}
-
 void *vmap(phys_addr_t phys, size_t size)
 {
 	void *mem, *p;
@@ -96,6 +91,14 @@ void __attribute__((__weak__)) find_highmem(void)
 {
 }
 
+void init_alloc_vpage(void *top)
+{
+	spin_lock(&lock);
+	assert(alloc_ops != &vmalloc_ops);
+	vfree_top = top;
+	spin_unlock(&lock);
+}
+
 void setup_vm()
 {
 	phys_addr_t base, top;
@@ -124,5 +127,8 @@ void setup_vm()
 		free_pages(phys_to_virt(base), top - base);
 	}
 
+	spin_lock(&lock);
+	assert(alloc_ops != &vmalloc_ops);
 	alloc_ops = &vmalloc_ops;
+	spin_unlock(&lock);
 }
-- 
2.26.2

