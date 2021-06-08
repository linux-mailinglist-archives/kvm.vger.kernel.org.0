Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931FB39FEA1
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 20:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbhFHSIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 14:08:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234223AbhFHSI0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 14:08:26 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158I5Yql044206;
        Tue, 8 Jun 2021 14:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8RsXQ9H/K9MlCyeojVADZLvufelTsBi/s7Q6u7tlqcY=;
 b=NRnFYRZFMcGaqACNtCjID+X0j9UYLm2ZM+38i4GU+qXNDMr511776J70zi5ylYK72zcw
 rIZbVOenFBxUlhohTSrPFxCrxULJqHP4beRF5mmFbuFNBN8jq0cnGuLRb8yYVaUzlnid
 uczCtkk0uQViDsVHLbKFYbaZghfxzkCgcC6WsYW9YFGyj4rfDerqwh/85Lppx3iUWAP8
 LiGCND9Ul825UVzz+u9GC9rRWC56zucYOMwDn40YkQo1Hhi9TUun9LAc5bSLGeYbibwi
 17vgqjdkIY1QjBwSyh/RgdRa0kz+ecVyEg5omry5LbTsGksQYub66PoezPAdMiCAmZgb og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 392cb0a5w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 14:06:26 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158I63b9046086;
        Tue, 8 Jun 2021 14:06:25 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 392cb0a5uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 14:06:25 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 158I0EXD014057;
        Tue, 8 Jun 2021 18:06:23 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3900w88xc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 18:06:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 158I6KDM35127734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 18:06:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C69552051;
        Tue,  8 Jun 2021 18:06:20 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.240])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7CFF552052;
        Tue,  8 Jun 2021 18:06:19 +0000 (GMT)
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
        David Rientjes <rientjes@google.com>
Subject: [PATCH v2 1/2] mm/vmalloc: export __vmalloc_node_range
Date:   Tue,  8 Jun 2021 20:06:17 +0200
Message-Id: <20210608180618.477766-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608180618.477766-1-imbrenda@linux.ibm.com>
References: <20210608180618.477766-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WDSPyv0peIRwnGTaSk-3ce0QniYmeRs8
X-Proofpoint-ORIG-GUID: UKfaBVGjtDsDhXCk_TIg3uPZ7zv0BEhg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_14:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080117
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

This patch exports __vmalloc_node_range so it can be used in modules
too.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Rientjes <rientjes@google.com>
---
 mm/vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a13ac524f6ff..bd6fa160b31b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2937,6 +2937,7 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(__vmalloc_node_range);
 
 /**
  * __vmalloc_node - allocate virtually contiguous memory
-- 
2.31.1

