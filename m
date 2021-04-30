Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2A636F9FA
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhD3MSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:18:51 -0400
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:15328
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232225AbhD3MST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:18:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ket99h8yEtf5u76S9ojD4DW6ileFQ4iuEMIZRyT13WK4w2sSaAD4QeGEGUYUtrBYwJsasUQd+5Mmb6NRfCp9RC9PXIQZvXjhbfnrqnOUYVWSB1J9MDjHO+bNAbZm6WDJOmj1rc78FScFsgzkM3DiJky7u/pTLdOGYQG1jzpR5z7dKoPH1opoo/J24qJf8AWmp+F8Jii+jKPcifoeWejMeD/kiPTY1Q/q8eQuGSbx4ssY2sudYpxmGpRAaR4NjjTpl/SKNsLXpjtNipGFIsof15sPi7Qo5KFj1A3zqweVccNfcgkPr9p4zz68vcYHYY7ubEs1NRRzvpSr01ZsXPxbRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMaIGL0wm0r4MXad+d2+QJohR14hhojorUTmCVuCysE=;
 b=I6gjFL/olljDjx4rKG9XoQNN7KZgyOK43q9Axcef8cQkvbVuXPcIeiSLaW+NcIkTZMnfqETeVm2s8DmqNyyZGuKZW9c8KimzDyl2N+Cd6Uy0xO1uO7igNnTWS3UtgBZVOUoQdGmb7uA8nXLxLtQ1XJ5CXrYHdAH5ydgmlJTo0c1BR7EZ0Bx/RNh7/EeN8jEkfKffnIWuLFgCZs3iZFyY8C3eg1/dSXtfhhUNqLoMoQC8ygcaVfu+otQHsH5qdm41W2tkWaCH/+OtEXWL8A4B0ZyAahJLbgT2J1jjJJPx3tjv7ZLhvf9YyCdQlnnW8E8VUFg/1+Hx+hi+7dCP58L8mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMaIGL0wm0r4MXad+d2+QJohR14hhojorUTmCVuCysE=;
 b=NDnMXJiWjjRQkeOH0iZ+ISTTYCBCiertR7pEKMt5TK+lZsCwxsiWvIZplLv3vePbbYbSfKK0Th0vFR0uGkezfCqciR0O8V6HQ1iPU6mZLxI0uvV4KzS2SN4BhPN1EI11hd31op2/9tRXD6WKDTXXdHshhHsEiKxJqeYJe2SlSIs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 12:17:03 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:17:03 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 17/20] x86/mm: Add support to validate memory when changing C-bit
Date:   Fri, 30 Apr 2021 07:16:13 -0500
Message-Id: <20210430121616.2295-18-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 464f59d2-b716-46b5-2f1b-08d90bd1dadf
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2640A23D3C2FBA1090BCAFECE55E9@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hRniK0fgBvVTPqtnTYx6Py5hZ+9GZ92MtBuQI/VUo8OoDU0v0hIWokfCj09tjmdxpClSCF0OKqBd7SEpOUkUtzGUUwerWCPtkd+PtPI90ezX0uKIc7I3iAWQNJzMnU7eQLkDxITD77id7QTvSatnIhY4mBeZYvpS5dj55fkKTaVqjoGKTuq2Du57Zy8ombhzERacvaUDTWgS29e+SJUzhMbfKHJj/wGotCu/vUy4Nuv/00Xtd+Xk9g0MGdtUyww4z3xc00rn9ZY994+gxUWaN9pTfyM1XAF+iyEvwZuieyo6H2+bTzd/iQIjorUccd1QM4IBi8cpqHRycJnBZN0yBMvcxOpdUEyvskLbnUi6Gte13lbq8owLV/osvDjJkKUdETjPOypu4kxR0PBGtSXeOqLN+Lx8+Yrr8YsQGS0opviO7hqLQmC1sSKDN2UmHMfDQQPF7VxQbk4NdwyVZYbvuxrHop4fpiWMLmCSmOlx5MCSwrtrTfzsCTSJUOhxW1p+hCfp0iZwlw6zYO/FSUe0ACh7F+rKhBWDkjebA0JGX7L9khE9sWon/uZtI6K4cXLmbRUAQbgMZxkl9DEjCewxDA2rm4J7WpRhoiIS4oDY8cW3/O8RqzhFDSeU/5yQ+ufBomRh7xTwNtPCZaabw4PjNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(6666004)(52116002)(7416002)(316002)(16526019)(2906002)(36756003)(186003)(26005)(38100700002)(38350700002)(66556008)(66946007)(5660300002)(1076003)(66476007)(4326008)(83380400001)(6486002)(86362001)(8936002)(956004)(44832011)(2616005)(15650500001)(8676002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VpkEfemvrnKSrDEdv8u9hf0Hi1e8ZhIeeFBNBntojIyaMn6ynXNPONTCOzhJ?=
 =?us-ascii?Q?rZ55aA//bRJUNm4PK+9Hfd9+e2hHXelMZTirdJx2Wo5lkcAQWYM3NXQDnb7G?=
 =?us-ascii?Q?yYCZFJhopbZW931kNsiYlHVnQypAHc+e5506jDn5q0hzmvTMaN+1ukYFWHJd?=
 =?us-ascii?Q?EI24HrEcd9cgpfLImYhcyMiYpbIYATid5k+b52dyu+wNFs4wkAKVmDyJCkly?=
 =?us-ascii?Q?aAE4ikG2kj7aJ0+xXxWDPw3sXxvM8UNVX7XQRp/jA4spKykeRFQfY0/qSGzc?=
 =?us-ascii?Q?HJSR5xzjlGY2pe6IogYdjdZxKYFSAedXE0t0n6koBlMKy/rchCWkG+Wj+pyw?=
 =?us-ascii?Q?9A+A60QPeuYneckyeXFRhXAci+RFiyAJP/fD3VEWwHH8PzL+F2XTG9aXOxDI?=
 =?us-ascii?Q?QCBd8u6dc8Obns0dj5kDIFWG4PehvvrhIyKyfWsLT0jDXrxVTi1G5/Js2FTi?=
 =?us-ascii?Q?jpGEnlVbRbivPR0TeuxQidtncDxVQkdGM9z27nTHtu+8kXAccURmoTMdVOP7?=
 =?us-ascii?Q?WEIj05Zj/LITE8xSFLASL3VKH117qsHaUuOMvKQKZ+YBUlZEpEF0fl0aWSsS?=
 =?us-ascii?Q?v/69H6POSzFNm0QZMkrKLABnvUjIlMnboxmo3Ec4Dv1TajDOfi7vf++HBA03?=
 =?us-ascii?Q?JFM71VUp2b0lZFVNlcf156iVCgIi9OjjDW82lXqyDOHtqVeld6RaewvykdKh?=
 =?us-ascii?Q?ps2YDZoIyxBxu8GD2B66nR6Tu4FQsZ/l7aRJOcdFX1oneEKJfKrjX3olYT0f?=
 =?us-ascii?Q?k3jVz1Xdsu4X/9gdv0sCdLVsm/QaLV43npCw+cqoMfPQ8RA3FO6UfFi2fOIz?=
 =?us-ascii?Q?Qske1Z/f/xF9OzkcryGBUSC+F+DtKap+Sbel7I8YjhrPQiqgUp4q6LsWHVMc?=
 =?us-ascii?Q?JjXbV4zoAZAknnapSWwl292vimCrZGD1fS5c+R71iz65ROnDeMOo6c/JHtU7?=
 =?us-ascii?Q?FllFU/NQHzGpo/NOIJAG0I/7fnYZF61bhpWMtQvnQVOka/5i6A8w0jK3CWp7?=
 =?us-ascii?Q?l3Fe80Xa3yE/Xj1ZgjBxCfpfCVtF1VDzugvcCjV0kDMweaulf8P0WH7RiTfA?=
 =?us-ascii?Q?mCLLkWJ1yVwdngT6XkRVJU+ChDQaM+5drd5/CMD+XXlcLajFagbrD91lFC8K?=
 =?us-ascii?Q?r+jSoAg/jCcWuHdGX72ap2gKvgut6iWHFSHnoD56kmcCqvEPo6wbzNHYUSO3?=
 =?us-ascii?Q?t6w+5Bbi4fcrw7E62tXVZWQwfPzshsEHkrQ3nkYAmqCbI8YXZ8r+OJp7y/I6?=
 =?us-ascii?Q?UdRolqBfReF7TkKDHngoFzOPDu9hSVkRG5YaSLkKKRIhXmVt8wPngomWE45l?=
 =?us-ascii?Q?iTpPFzLyWhiEt9fuJ8ajWtiK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 464f59d2-b716-46b5-2f1b-08d90bd1dadf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:59.8955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xZ6s0O41UxxOfXsy5tjYqdbJUPluzIaPLdMXL1+PHoq4/WgrQjrr4AcsUsGYnpBb1RMRVtuhEHa3x5fd7FTFxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The set_memory_{encrypt,decrypt}() are used for changing the pages
from decrypted (shared) to encrypted (private) and vice versa.
When SEV-SNP is active, the page state transition needs to go through
additional steps.

If the page is transitioned from shared to private, then perform the
following after the encryption attribute is set in the page table:

1. Issue the page state change VMGEXIT to add the memory region in
   the RMP table.
2. Validate the memory region after the RMP entry is added.

To maintain the security guarantees, if the page is transitioned from
private to shared, then perform the following before encryption attribute
is removed from the page table:

1. Invalidate the page.
2. Issue the page state change VMGEXIT to remove the page from RMP table.

To change the page state in the RMP table, use the Page State Change
VMGEXIT defined in the GHCB specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev.h   |   4 ++
 arch/x86/kernel/sev.c        | 114 +++++++++++++++++++++++++++++++++++
 arch/x86/mm/pat/set_memory.c |  15 +++++
 3 files changed, 133 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 62aba82acfb8..1b505061d9f7 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -111,6 +111,8 @@ void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long padd
 		unsigned int npages);
 void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
 		unsigned int npages);
+void snp_set_memory_shared(unsigned long vaddr, unsigned int npages);
+void snp_set_memory_private(unsigned long vaddr, unsigned int npages);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -126,6 +128,8 @@ static inline void __init
 early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr, unsigned int npages)
 {
 }
+static inline void snp_set_memory_shared(unsigned long vaddr, unsigned int npages) { }
+static inline void snp_set_memory_private(unsigned long vaddr, unsigned int npages) { }
 #endif
 
 #endif
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 33420f6da030..f28fd8605e63 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -612,6 +612,120 @@ void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr
 	early_snp_set_page_state(paddr, npages, SNP_PAGE_STATE_SHARED);
 }
 
+static int snp_page_state_vmgexit(struct ghcb *ghcb, struct snp_page_state_change *data)
+{
+	struct snp_page_state_header *hdr;
+	int ret = 0;
+
+	hdr = &data->header;
+
+	/*
+	 * As per the GHCB specification, the hypervisor can resume the guest before
+	 * processing all the entries. The loop checks whether all the entries are
+	 * processed. If not, then keep retrying.
+	 */
+	while (hdr->cur_entry <= hdr->end_entry) {
+
+		ghcb_set_sw_scratch(ghcb, (u64)__pa(data));
+
+		ret = sev_es_ghcb_hv_call(ghcb, NULL, SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE, 0, 0);
+
+		/* Page State Change VMGEXIT can pass error code through exit_info_2. */
+		if (ret || ghcb->save.sw_exit_info_2) {
+			WARN(1, "SEV-SNP: page state change failed ret=%d exit_info_2=%llx\n",
+				ret, ghcb->save.sw_exit_info_2);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * The function uses the NAE event to batch the page state change request.
+ */
+static void snp_set_page_state(unsigned long vaddr, unsigned int npages, int op)
+{
+	struct snp_page_state_change *data;
+	struct snp_page_state_header *hdr;
+	struct snp_page_state_entry *e;
+	unsigned long vaddr_end;
+	struct ghcb_state state;
+	struct ghcb *ghcb;
+	int idx;
+
+	vaddr = vaddr & PAGE_MASK;
+	vaddr_end = vaddr + (npages << PAGE_SHIFT);
+
+	ghcb = sev_es_get_ghcb(&state);
+	if (unlikely(!ghcb))
+		panic("SEV-SNP: Failed to get GHCB\n");
+
+	data = (struct snp_page_state_change *)ghcb->shared_buffer;
+	hdr = &data->header;
+
+	while (vaddr < vaddr_end) {
+		e = data->entry;
+		memset(data, 0, sizeof (*data));
+
+		for (idx = 0; idx < VMGEXIT_PSC_MAX_ENTRY; idx++, e++) {
+			unsigned long pfn;
+
+			if (is_vmalloc_addr((void *)vaddr))
+				pfn = vmalloc_to_pfn((void *)vaddr);
+			else
+				pfn = __pa(vaddr) >> PAGE_SHIFT;
+
+			e->gfn = pfn;
+			e->operation = op;
+			hdr->end_entry = idx;
+
+			/*
+			 * The GHCB specification provides the flexibility to use
+			 * either 4K or 2MB page size in the RMP table. The curent
+			 * SNP support does not keep track of the page size used
+			 * in the RMP table. To avoid the overlap request, use the
+			 * 4K page size in the RMP table.
+			 */
+			e->pagesize = RMP_PG_SIZE_4K;
+			vaddr = vaddr + PAGE_SIZE;
+
+			if (vaddr >= vaddr_end)
+				break;
+		}
+
+		/* Terminate the guest on page state change failure. */
+		if (snp_page_state_vmgexit(ghcb, data))
+			sev_es_terminate(1, GHCB_TERM_PSC);
+	}
+
+	sev_es_put_ghcb(&state);
+}
+
+void snp_set_memory_shared(unsigned long vaddr, unsigned int npages)
+{
+	if (!sev_snp_active())
+		return;
+
+	/* Invalidate the memory before changing the page state in the RMP table. */
+	pvalidate_pages(vaddr, npages, 0);
+
+	/* Change the page state in the RMP table. */
+	snp_set_page_state(vaddr, npages, SNP_PAGE_STATE_SHARED);
+}
+
+void snp_set_memory_private(unsigned long vaddr, unsigned int npages)
+{
+	if (!sev_snp_active())
+		return;
+
+	/* Change the page state in the RMP table. */
+	snp_set_page_state(vaddr, npages, SNP_PAGE_STATE_PRIVATE);
+
+	/* Validate the memory after the memory is made private in the RMP table. */
+	pvalidate_pages(vaddr, npages, 1);
+}
+
 int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
 {
 	u16 startup_cs, startup_ip;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 427980617557..34cd13671d5c 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -27,6 +27,7 @@
 #include <asm/proto.h>
 #include <asm/memtype.h>
 #include <asm/set_memory.h>
+#include <asm/sev.h>
 
 #include "../mm_internal.h"
 
@@ -2001,8 +2002,22 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	 */
 	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_SME_COHERENT));
 
+	/*
+	 * To maintain the security gurantees of SEV-SNP guest invalidate the memory
+	 * before clearing the encryption attribute.
+	 */
+	if (!enc)
+		snp_set_memory_shared(addr, numpages);
+
 	ret = __change_page_attr_set_clr(&cpa, 1);
 
+	/*
+	 * Now that memory is mapped encrypted in the page table, validate the memory
+	 * range before the return.
+	 */
+	if (!ret && enc)
+		snp_set_memory_private(addr, numpages);
+
 	/*
 	 * After changing the encryption attribute, we need to flush TLBs again
 	 * in case any speculative TLB caching occurred (but no need to flush
-- 
2.17.1

