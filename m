Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B783A2F8F
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 17:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhFJPog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 11:44:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46002 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231356AbhFJPof (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 11:44:35 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AFXORA094017;
        Thu, 10 Jun 2021 11:42:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RDlGeGGZR9MUk+iXXW+r4erk5KUvKKu/IS5n4qA0x7o=;
 b=I30T5W3t5Ys0ELnJ0LdN5T6utF9urUitRsPAFOIY7z1kq9wtQBvaWJtBUQ5mE3zFMG3W
 xa52XWxAsrzfqlwfQ0Yq1U32AE37M9Pyj2i6W4VHATescZKQxXHyuwNY+dNwvD206ZDL
 hpecNgzF2EHu+j5IoiJ69Axe1HQ6q09Y1XKPGauR8rV/xsQBRwRQjVNToPGGdY2gBNnc
 ObF5cetwqzvw5owMWc53CjNPUXLF3wnZR695LDx8+L9R8yZ4c+xuJjLecjESp370PqRC
 v935GpAhK0rjkpQUDlg5YTnNI0C5UVf7MB8YQ+8Dq9/OOaQiZusVWUaPTtCXPiRSOTHF XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393mu91v16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 11:42:27 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15AFXrJ6096289;
        Thu, 10 Jun 2021 11:42:27 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393mu91v0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 11:42:27 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15AFX3r0031382;
        Thu, 10 Jun 2021 15:42:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3936ns08m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 15:42:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15AFgMEm34668926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 15:42:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E9B942047;
        Thu, 10 Jun 2021 15:42:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B495C42045;
        Thu, 10 Jun 2021 15:42:21 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.240])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Jun 2021 15:42:21 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        david@redhat.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 1/2] mm/vmalloc: add vmalloc_no_huge
Date:   Thu, 10 Jun 2021 17:42:19 +0200
Message-Id: <20210610154220.529122-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610154220.529122-1-imbrenda@linux.ibm.com>
References: <20210610154220.529122-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zyArlWDvrVWhy5c4PKKsxS6DEZSDGhAV
X-Proofpoint-ORIG-GUID: yYfALIzOA1g5D1szFX7LNQTRxnyVsT7D
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_10:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The recent patches to add support for hugepage vmalloc mappings added a
flag for __vmalloc_node_range to allow to request small pages.
This flag is not accessible when calling vmalloc, the only option is to
call directly __vmalloc_node_range, which is not exported.

This means that a module can't vmalloc memory with small pages.

Case in point: KVM on s390x needs to vmalloc a large area, and it needs
to be mapped with small pages, because of a hardware limitation.

This patch adds the function vmalloc_no_huge, which works like vmalloc,
but it is guaranteed to always back the mapping using small pages. This
function is exported, therefore it is usable by modules.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

