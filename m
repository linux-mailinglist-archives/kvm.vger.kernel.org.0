Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4426658F7
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfGKO1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:27:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37316 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbfGKO1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:27:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOAvB001518;
        Thu, 11 Jul 2019 14:26:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=Ag0k+tMlXoCUCjgmP3NxD1Cl4FnNgcaLg1SLsqSglmA=;
 b=keVQsRLhZyNb/dFJnnzguyu+6Vl7qT1iW80eQJUi6p8HUYNezOn2M6QRB0NcNQhQI7JT
 5HACwzQ7vK/fKkmWqNIFxS0mv8uBEA1J5s9pHNXY/wHvMqw/x77ya8pCk5djXXg3w8tA
 Y+DFHNzDwpT4d81yj2dhIMIFubn8ssOAMPMn8hTz8Cg2l5maUEKHDpqBF2nYVJbVIius
 zq+q7wJ21XaxrzeREUMqbHN8popuelxmyOtwjWh5plKHWNmsE8C4KEMn9NIt7tf3KMir
 nsOpTlKGCKH8e0WHGLCVGvgf9UFWaCxJYPAxRKOlsGhf5idexkvlsNaYd43tN8SZVOoQ SA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0dyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:28 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcu6021444;
        Thu, 11 Jul 2019 14:26:25 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 13/26] mm/asi: Add asi_remap() function
Date:   Thu, 11 Jul 2019 16:25:25 +0200
Message-Id: <1562855138-19507-14-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=832 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a function to remap an already mapped buffer with a new address
in an ASI page-table: the already mapped buffer is unmapped, and a
new mapping is added for the specified new address.

This is useful to track and remap a buffer which can be freed and
then reallocated.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h  |    1 +
 arch/x86/mm/asi_pagetable.c |   25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 912b6a7..cf5d198 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -84,6 +84,7 @@ extern int asi_map_range(struct asi *asi, void *ptr, size_t size,
 			 enum page_table_level level);
 extern int asi_map(struct asi *asi, void *ptr, unsigned long size);
 extern void asi_unmap(struct asi *asi, void *ptr);
+extern int asi_remap(struct asi *asi, void **mapping, void *ptr, size_t size);
 
 /*
  * Copy the memory mapping for the current module. This is defined as a
diff --git a/arch/x86/mm/asi_pagetable.c b/arch/x86/mm/asi_pagetable.c
index a4fe867..1ff0c47 100644
--- a/arch/x86/mm/asi_pagetable.c
+++ b/arch/x86/mm/asi_pagetable.c
@@ -842,3 +842,28 @@ int asi_map_percpu(struct asi *asi, void *percpu_ptr, size_t size)
 	return 0;
 }
 EXPORT_SYMBOL(asi_map_percpu);
+
+int asi_remap(struct asi *asi, void **current_ptrp, void *new_ptr, size_t size)
+{
+	void *current_ptr = *current_ptrp;
+	int err;
+
+	if (current_ptr == new_ptr) {
+		/* no change, already mapped */
+		return 0;
+	}
+
+	if (current_ptr) {
+		asi_unmap(asi, current_ptr);
+		*current_ptrp = NULL;
+	}
+
+	err = asi_map(asi, new_ptr, size);
+	if (err)
+		return err;
+
+	*current_ptrp = new_ptr;
+
+	return 0;
+}
+EXPORT_SYMBOL(asi_remap);
-- 
1.7.1

