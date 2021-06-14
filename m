Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45853A67C0
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbhFNN02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:26:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42092 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233102AbhFNN0Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 09:26:25 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15ED36ew184486;
        Mon, 14 Jun 2021 09:24:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=d/Q9jExTfUvPXsbrrC88KaKDmr7W4nQUtCJ1+fK2xYk=;
 b=IDyCN/67ntdjqLJURNCiY52GmlXPgqsNl1YKMNGmTzjpy06742d/OZrC4zfiE7eFFeut
 nBpN0LNkPLQ9jrZEGW7+cD/XmClKCbbOP2Xylq4D+DdCJNj0cedkwW8q2QuLfogT0eWu
 nG/EVzZeiy4a54FexpoOoHKX4U1TdJWWXPqRGM0HS4NY5VByqA8jHLFQ9jasr3vIqVkv
 gYPW5ZzyjHz3UvQa14JINpbJbqjYJbSCke0BGNthkVRhm7okmDajUaMNlWvkzH0OVRtI
 Y2SWKcScToEo+QV9AEvwDp1U7GH8IxZucodigRw33sDQSh//AWM2ofOs3Y/HRj2DbJzB Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39673fsu24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 09:24:05 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15ED3TCg188795;
        Mon, 14 Jun 2021 09:24:04 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39673fsu0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 09:24:04 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15EDMi08000469;
        Mon, 14 Jun 2021 13:24:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 394mj8rycj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 13:24:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15EDNxjS29098296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 13:23:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B69E5204E;
        Mon, 14 Jun 2021 13:23:59 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.73])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B60BA5204F;
        Mon, 14 Jun 2021 13:23:58 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        david@redhat.com, linux-mm@kvack.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 1/2] mm/vmalloc: add vmalloc_no_huge
Date:   Mon, 14 Jun 2021 15:23:56 +0200
Message-Id: <20210614132357.10202-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614132357.10202-1-imbrenda@linux.ibm.com>
References: <20210614132357.10202-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tQW2hgtwcMNCajTGyriuWlOD1nFkV2Dq
X-Proofpoint-GUID: 5efeXzVoX7H1Z8cEpOjQkmBgkzmVQ4wA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_07:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106140089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 121e6f3258fe3 ("mm/vmalloc: hugepage vmalloc mappings") added
support for hugepage vmalloc mappings, it also added the flag
VM_NO_HUGE_VMAP for __vmalloc_node_range to request the allocation to
be performed with 0-order non-huge pages.  This flag is not accessible
when calling vmalloc, the only option is to call directly
__vmalloc_node_range, which is not exported.

This means that a module can't vmalloc memory with small pages.

Case in point: KVM on s390x needs to vmalloc a large area, and it needs
to be mapped with non-huge pages, because of a hardware limitation.

This patch adds the function vmalloc_no_huge, which works like vmalloc,
but it is guaranteed to always back the mapping using small pages. This
new function is exported, therefore it is usable by modules.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 include/linux/vmalloc.h |  1 +
 mm/vmalloc.c            | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 4d668abb6391..bfaaf0b6fa76 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -135,6 +135,7 @@ extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			const void *caller);
 void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller);
+void *vmalloc_no_huge(unsigned long size);
 
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a13ac524f6ff..296a2fcc3fbe 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2998,6 +2998,22 @@ void *vmalloc(unsigned long size)
 }
 EXPORT_SYMBOL(vmalloc);
 
+/**
+ * vmalloc_no_huge - allocate virtually contiguous memory using small pages
+ * @size:    allocation size
+ *
+ * Allocate enough non-huge pages to cover @size from the page level
+ * allocator and map them into contiguous kernel virtual space.
+ *
+ * Return: pointer to the allocated memory or %NULL on error
+ */
+void *vmalloc_no_huge(unsigned long size)
+{
+	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END, GFP_KERNEL, PAGE_KERNEL,
+				    VM_NO_HUGE_VMAP, NUMA_NO_NODE, __builtin_return_address(0));
+}
+EXPORT_SYMBOL(vmalloc_no_huge);
+
 /**
  * vzalloc - allocate virtually contiguous memory with zero fill
  * @size:    allocation size
-- 
2.31.1

