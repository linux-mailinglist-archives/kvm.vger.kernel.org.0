Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677CA2816FA
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388082AbgJBPof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:44:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388042AbgJBPo2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 11:44:28 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092FgwPJ170905
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WZCOOR6Tso02f7vzcm7TNgr9Sxlc2Kv8yjQ1TOfgxzk=;
 b=iPAuiy0NWB3yq//sdPSVnvGBUYRVwt4CO4UqZ0PlJ6RTsd1dlrQ0DClmxFQ4nCuqk7fN
 3lgpvzuhyi4+OU+3z/FwolXeDid8bd0qC448yMyWCd9SOrHwu5lWENYAOmoc1/tAqebO
 FEEYpUfWsuRZdMq8IWrvVaUdvq7MOk2e1iowYIs3GGuNcJHANGz1Xb+wdLSftPak5soa
 SVZ4/98OEEPtgFux+fQG9QlYseLP77TQxA/c+lG5x7H/VLbhmV14yZ9BeOWiHjOySJHl
 gXMfh01RLBPmdXLHDF8eSQwR42fWrb5ABKq34IRkT/gMQkYE6ArCx8vQmLzYiNAYIFJY qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x73900ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 11:44:27 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092FiM3n174298
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:27 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x73900x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 11:44:27 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092FiOwr003243;
        Fri, 2 Oct 2020 15:44:24 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 33sw98bgyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 15:44:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092FiLS432244042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 15:44:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC1AD42047;
        Fri,  2 Oct 2020 15:44:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BF2942041;
        Fri,  2 Oct 2020 15:44:21 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.90])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 15:44:21 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/7] lib/list: Add double linked list management functions
Date:   Fri,  2 Oct 2020 17:44:14 +0200
Message-Id: <20201002154420.292134-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002154420.292134-1-imbrenda@linux.ibm.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 clxscore=1015 adultscore=0 mlxlogscore=944 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add simple double linked lists.

Apart from the struct itself, there are functions to add and remove
items, and check for emptyness.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/list.h | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 lib/list.h

diff --git a/lib/list.h b/lib/list.h
new file mode 100644
index 0000000..702a78c
--- /dev/null
+++ b/lib/list.h
@@ -0,0 +1,53 @@
+#ifndef LIST_H
+#define LIST_H
+
+#include <stdbool.h>
+
+/*
+ * Simple double linked list. The pointer to the list is a list item itself,
+ * like in the kernel implementation.
+ */
+struct linked_list {
+	struct linked_list *prev;
+	struct linked_list *next;
+};
+
+/*
+ * An empty list is a list item whose prev and next both point to itself.
+ * Returns true if the list is empty.
+ */
+static inline bool is_list_empty(struct linked_list *p)
+{
+	return !p->next || !p->prev || p == p->next || p == p->prev;
+}
+
+/*
+ * Remove the given element from the list, if the list is not already empty.
+ * The removed element is returned.
+ */
+static inline struct linked_list *list_remove(struct linked_list *l)
+{
+	if (is_list_empty(l))
+		return NULL;
+
+	l->prev->next = l->next;
+	l->next->prev = l->prev;
+	l->prev = l->next = NULL;
+
+	return l;
+}
+
+/*
+ * Add the given element after the given list head.
+ */
+static inline void list_add(struct linked_list *head, struct linked_list *li)
+{
+	assert(li);
+	assert(head);
+	li->prev = head;
+	li->next = head->next;
+	head->next->prev = li;
+	head->next = li;
+}
+
+#endif
-- 
2.26.2

