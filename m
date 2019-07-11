Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C705E658D7
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfGKO2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38288 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729074AbfGKO2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOKHZ001595;
        Thu, 11 Jul 2019 14:26:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=gDByh8p+inBGj8eNOkt+0s0ErRCor6nCeXzUp1uJmZ0=;
 b=uIvYew5i+/N3gKnyr4ociYqq+qt56BKvpfHx2yG6ELbiXTDFF1FnRFdNiTxKLqzKpugT
 7rZFZ27tp3XeOzJIDBEQWKZlGMdD04zWtCMR9kz9rtKT/I1eEKjmUoR0EfXOS4LZP41X
 SaOmMD0h5rmiZKjuWODlCFnTwFv/w3OU84qMp7I8vBQjvkB4kLSw+vU/HUfR9FiS4qmM
 dt9lswqhmPEYZvrjigJDb4qNQfKlbGFfmUQluSi/uyNCjdt/jH+m3QqAeoRgbBE5SECi
 sbhB6HhXJDdRZ5C1Vh+uI9HzCIOa4DMf+C+kQvxHt3TG4Fqj9spPHDE/SpvfNokpoD2Z Tw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0dyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:25 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcu5021444;
        Thu, 11 Jul 2019 14:26:21 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 12/26] mm/asi: Function to copy page-table entries for percpu buffer
Date:   Thu, 11 Jul 2019 16:25:24 +0200
Message-Id: <1562855138-19507-13-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=895 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide functions to copy page-table entries from the kernel page-table
to an ASI page-table for a percpu buffer. A percpu buffer have a different
VA range for each cpu and all them have to be copied.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h  |    6 ++++++
 arch/x86/mm/asi_pagetable.c |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 919129f..912b6a7 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -105,6 +105,12 @@ static inline int asi_map_module(struct asi *asi, char *module_name)
 	return asi_map(asi, module->core_layout.base, module->core_layout.size);
 }
 
+#define	ASI_MAP_CPUVAR(asi, cpuvar)	\
+	asi_map_percpu(asi, &cpuvar, sizeof(cpuvar))
+
+extern int asi_map_percpu(struct asi *asi, void *percpu_ptr, size_t size);
+extern void asi_unmap_percpu(struct asi *asi, void *percpu_ptr);
+
 /*
  * Function to exit the current isolation. This is used to abort isolation
  * when a task using isolation is scheduled out.
diff --git a/arch/x86/mm/asi_pagetable.c b/arch/x86/mm/asi_pagetable.c
index 7aee236..a4fe867 100644
--- a/arch/x86/mm/asi_pagetable.c
+++ b/arch/x86/mm/asi_pagetable.c
@@ -804,3 +804,41 @@ void asi_unmap(struct asi *asi, void *ptr)
 	spin_unlock_irqrestore(&asi->lock, flags);
 }
 EXPORT_SYMBOL(asi_unmap);
+
+void asi_unmap_percpu(struct asi *asi, void *percpu_ptr)
+{
+	void *ptr;
+	int cpu;
+
+	pr_debug("ASI %p: UNMAP PERCPU %px\n", asi, percpu_ptr);
+	for_each_possible_cpu(cpu) {
+		ptr = per_cpu_ptr(percpu_ptr, cpu);
+		pr_debug("ASI %p: UNMAP PERCPU%d %px\n", asi, cpu, ptr);
+		asi_unmap(asi, ptr);
+	}
+}
+EXPORT_SYMBOL(asi_unmap_percpu);
+
+int asi_map_percpu(struct asi *asi, void *percpu_ptr, size_t size)
+{
+	int cpu, err;
+	void *ptr;
+
+	pr_debug("ASI %p: MAP PERCPU %px\n", asi, percpu_ptr);
+	for_each_possible_cpu(cpu) {
+		ptr = per_cpu_ptr(percpu_ptr, cpu);
+		pr_debug("ASI %p: MAP PERCPU%d %px\n", asi, cpu, ptr);
+		err = asi_map(asi, ptr, size);
+		if (err) {
+			/*
+			 * Need to unmap any percpu mapping which has
+			 * succeeded before the failure.
+			 */
+			asi_unmap_percpu(asi, percpu_ptr);
+			return err;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(asi_map_percpu);
-- 
1.7.1

