Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739D0347E0F
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236548AbhCXQpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:45:11 -0400
Received: from mail-dm6nam12on2040.outbound.protection.outlook.com ([40.107.243.40]:48321
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236294AbhCXQou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXArRgn1pdUVW0sRPWoBo6PrSmtuP+EfPUOU86ZuagOSwLD99sYE1BkzOhL1OaKQodJZ6sbh6s5b3x5ch0vF3be1xV/qTMR7lFgqQGi138LkAZ5L4J2n1gTyC+ZrAxD0V6BEP4FdXmqyAXgl+/4yOhgWEk6qKihyy8ZXMhiqhHKVSKDr6gn4UStks7f1z3z8MnZu4B7Mtn66s9DdKf9cJ8pMHD0ck4ncQHHndRj4tHuzG2YQzHawyJ4X5zPn8GOiqXNj/6ai9lyNAuMjJC/wDkR+e8pLjAB6N5yECV/Np65luYcsMpnIIMiZWraHiLf6FyuY1lBROiD68R3qDmXUxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sfy/Z3yb2E4+ZL1lv2LxIA2msu72HSeqEratNEjoluc=;
 b=Djn0uiwmdYBMcRQf1XnM7Rd0dr8uAINCqn1YvifRS4MJb8+QJHtXjevocH/F0hwKFOtkJZRsPd6iA3lfYnN5B5ItkQrOCTcmbKODCaZ2usPX3DBlZym+lBG3w0SghpSgQqp0mWz4tgWxuqmnoUh4AGhkf20XXaz31Jr2xK/rV8wOZd5nKqF33zIBePUsAgWaI0jorAhZ6ixXDe74h3qInECEF0fKVDiEn//jkavZNSr/KN/I+IBA8Fx86ShUj/vlUIOwxKAIy9+fTvzQlDgkqmOaKiXtZChkfuq/+dVu82GIFXLKiv5qoDTRuwSg2SS84wrR1LZSchONSeO+fZqEtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sfy/Z3yb2E4+ZL1lv2LxIA2msu72HSeqEratNEjoluc=;
 b=HA0KPRkY9ATnD8/cyJkZpjU9nHyOCPTB5BbMq6N11DvsyadCdQzsSpbOXAYVRpEbZhxXyfsQpGR9dj7k5YHBS/QKEYVskWXkIC+IqPj4dz1Rq/uJDM4rUb9w3QNCtWP+EQfSqzCLyCE5BtFkFeM6pT7Dyyusp5P6+nXuFo/SdFk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 16:44:48 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:48 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     ak@linux.intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part1 PATCH 13/13] x86/kernel: add support to validate memory when changing C-bit
Date:   Wed, 24 Mar 2021 11:44:24 -0500
Message-Id: <20210324164424.28124-14-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324164424.28124-1-brijesh.singh@amd.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1cf0731e-bf6b-436f-3de1-08d8eee42316
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4446307D5D5342A136AB2E1FE5639@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kiAaIFzvjdfeW1YIs37SVKNa8db5eTk44LAq2hLOgWzHdyYX76FD5G86+VxTrqhiyu/rbnscMrbCcqk/aOZ8DCN6ewSNzgcz2539ljxeksiTXUowyXNydFNscrw/JFhxcX8AkpLo6uc3jcSksR/sHoDGi7e8nGJetYw2vphJbL5ULiJR2RGFci+c2sPHfPS8ROGd/zICaDTm0VBAH2gzh1ahBrpXFoD6PPXdCXVlhKpoR7XCJWxhsnbqqC4zEOrFzYG6Kss6CIF0IfXNCWzaD5ssEHEBPNJ5HUwtPpCQpp023EnDeLXOHT4zyGnphmbjpHpOmsY8nBootds0Y+k+sRz+fOYTQfu639FT4HxvbPuSkQ2Wn7zzx0/ohqTPjvb1jVvfycG0S2zX1GmzwP+X/dyV1+e9QyC4egltiBwfa3SBpbq40a9zg4GjDbUNqsYV6S6B9rFvEB57Jy6q5SsP6T5Hy8UGVnSdXJ0DEr0PCe/xEaGEsGDHG+/5RX6ZKbTBRPAgpLPEgNNCqVNN+UFw/1FI3bXbvBXTtgjRyjRIXY2kay/S2RZoUjRVpClpZIst/gqMff9q3xd6UczuWkpID2KOWTP1drTeUVAvMMuIoAl+KZDmh4+RCdsfmu2SGTqS/6WEAgaqHd9le8ac7tELE3kwgUo+7fZoXQOHA15kr9A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(8676002)(1076003)(4326008)(6666004)(38100700001)(8936002)(956004)(2616005)(5660300002)(186003)(66946007)(86362001)(44832011)(36756003)(15650500001)(7696005)(6486002)(7416002)(478600001)(66476007)(66556008)(52116002)(316002)(83380400001)(16526019)(2906002)(26005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ziEuDUKI5g6YVEAkPk06lcan7+sorLkofFxFxqJ9Mmizp3M1LaRF1+rAGeDM?=
 =?us-ascii?Q?/kbg5BA2KPkwKPjdJ/rjns4tSWKtkdY5dLFRd/A54Vz0qtRsQywxW4r9PFlp?=
 =?us-ascii?Q?eoG1PfQ7ZDPk5VNngZc4O4gKghjwJehxwAmp8zTmt2IfXpMyulQgfBFhi0zI?=
 =?us-ascii?Q?P5Po6C2MGPi0eziqA9+t3HlcFoirNZoGLgpK67n46Ul4Qfe8XFDk3pMRYkDD?=
 =?us-ascii?Q?6TwujSHtjMFwGukFkpVMjznFnau+vGF3EoUVRRHgcSU2gEUuzN21uM2V7Tgp?=
 =?us-ascii?Q?EWfk8Iw9v10SDWW23YCa81FGYClzigXsazlqv+8Fl2BBw2sDzXa7nO72eGf4?=
 =?us-ascii?Q?MD5qYKdbF00lxaBE+0QvTOI6CN1ccevPXYQb5o3/r5wNCus22oBiUMataeWK?=
 =?us-ascii?Q?+yTLcfXIj8ANfzN5DjRyRsnfoFqQ6wp9vVovb9jtePXs1Y+hKyZAosOEtNTH?=
 =?us-ascii?Q?4C4PLLEcO5C9JXzJWVqDtJk6eGMDB9uXNqFvLV3kcEw3KS4L6eAMmkdv8orn?=
 =?us-ascii?Q?lA0Fdfotwphc10XJzRdXntqh3cMg5WVgdUWUcRPPkJF17VwYT+okm1Q1SLfL?=
 =?us-ascii?Q?JV31P+KRToCIJJqDZm396Vchkk/0imHQGgh7KjG+006xCc4EcyCI9fy/GANi?=
 =?us-ascii?Q?QAewjzJ7fQ/zWsKQToFpmBK7o/wdjl+0qHS6npHwNzic+A/sNhAc5i6BfVCo?=
 =?us-ascii?Q?WfcKQHOEPF/Q2/Rxd0z8hvevXeux/221BNRSW3lEQj7TW1JY+sU1qBMWsgvw?=
 =?us-ascii?Q?T7fPjjXZNEhTIGrmLzFJ2ukRBxf4W8vBJ33ilmn2nv34rCBhJuqXdwZ+ionJ?=
 =?us-ascii?Q?tCf6pfz51HBInqVgD2VCWnnOGmbzxX+uDJlKGAYdSZzIC6s4WfdC+mMJZPci?=
 =?us-ascii?Q?4SlN1gTp+XVxjKomc9+Efg4pPVxZVcT7mmLJra6qpjVgwkQ4hOnq0mCd8kFp?=
 =?us-ascii?Q?X4ydktYVNAQnN6x0Cj49dtSek/UJWwtLqfVRNjWzVHwzGXi4y0jgMpnL70wI?=
 =?us-ascii?Q?uITD3vPw07O+GPUYP0o7z8NBCf25NoeWV30EaC+Yz2DkC1dqXLG2d1lzvMc4?=
 =?us-ascii?Q?kOOkRvQLx4dnXosfuXdnY/zwE9ZtpnCKgahOL5BC7btTNfuFZ6J4QR97E2vV?=
 =?us-ascii?Q?21QrN+9Q+Tpa/EYPrrfOhIHfaacC4fMXm1hH1bKdilLs49bPvJVse8MXYfQB?=
 =?us-ascii?Q?bVPwrZu/jf7Wj0QWsSDwGt6pex7m0V1BP/Nd6nfYUe7qid69w56dx4VvJddP?=
 =?us-ascii?Q?FN9EXsPXVofFgQVysHcdP2GC9p/UGkSW0GsPDJ/CaLhveDGApunapErFxknf?=
 =?us-ascii?Q?Q3HiPJ/do5YL6SoJkWBrujTa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf0731e-bf6b-436f-3de1-08d8eee42316
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:48.3038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvWdixe2H+07vIKUIYTAnuX/W+AUpsJ+D6z8ZrWwsyXGqkU0XfbUxmzkkuH7Sa9UPbjGaDFr8ZpUOjSulJKU5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
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
VMGEXIT defined in the GHCB spec section 4.1.6.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-es.h  |   2 +
 arch/x86/include/asm/sev-snp.h |   4 ++
 arch/x86/kernel/sev-es.c       |   7 +++
 arch/x86/kernel/sev-snp.c      | 106 +++++++++++++++++++++++++++++++++
 arch/x86/mm/pat/set_memory.c   |  19 ++++++
 5 files changed, 138 insertions(+)

diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index 33838a8f8495..8715e41e2c8f 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -109,6 +109,7 @@ static __always_inline void sev_es_nmi_complete(void)
 extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
 extern struct ghcb *sev_es_get_ghcb(struct ghcb_state *state);
 extern void sev_es_put_ghcb(struct ghcb_state *state);
+extern int vmgexit_page_state_change(struct ghcb *ghcb, void *data);
 
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
@@ -118,6 +119,7 @@ static inline void sev_es_nmi_complete(void) { }
 static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
 static inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state) { return NULL; }
 static inline void sev_es_put_ghcb(struct ghcb_state *state) { }
+static inline int vmgexit_page_state_change(struct ghcb *ghcb, void *data) { return 0; }
 #endif
 
 #endif
diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
index c4b096206062..59b57a5f6524 100644
--- a/arch/x86/include/asm/sev-snp.h
+++ b/arch/x86/include/asm/sev-snp.h
@@ -90,6 +90,8 @@ void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long padd
 		unsigned int npages);
 void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
 		unsigned int npages);
+int snp_set_memory_shared(unsigned long vaddr, unsigned int npages);
+int snp_set_memory_private(unsigned long vaddr, unsigned int npages);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -110,6 +112,8 @@ early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr, unsigned i
 {
 	return 0;
 }
+static inline int snp_set_memory_shared(unsigned long vaddr, unsigned int npages) { return 0; }
+static inline int snp_set_memory_private(unsigned long vaddr, unsigned int npages) { return 0; }
 
 #endif /* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index d4957b3fc43f..7309be685440 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -586,6 +586,13 @@ static bool __init sev_es_setup_ghcb(void)
 	return true;
 }
 
+int vmgexit_page_state_change(struct ghcb *ghcb, void *data)
+{
+	ghcb_set_sw_scratch(ghcb, (u64)__pa(data));
+
+	return sev_es_ghcb_hv_call(ghcb, NULL, SVM_VMGEXIT_PAGE_STATE_CHANGE, 0, 0);
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 static void sev_es_ap_hlt_loop(void)
 {
diff --git a/arch/x86/kernel/sev-snp.c b/arch/x86/kernel/sev-snp.c
index ff9b35bfb05c..d236089c0739 100644
--- a/arch/x86/kernel/sev-snp.c
+++ b/arch/x86/kernel/sev-snp.c
@@ -15,6 +15,7 @@
 
 #include <asm/sev-es.h>
 #include <asm/sev-snp.h>
+#include <asm/svm.h>
 
 static inline u64 sev_es_rd_ghcb_msr(void)
 {
@@ -161,3 +162,108 @@ void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr
 	 /* Ask hypervisor to make the memory shared in the RMP table. */
 	early_snp_set_page_state(paddr, npages, SNP_PAGE_STATE_SHARED);
 }
+
+static int snp_page_state_vmgexit(struct ghcb *ghcb, struct snp_page_state_change *data)
+{
+	struct snp_page_state_header *hdr;
+	int ret = 0;
+
+	hdr = &data->header;
+
+	/*
+	 * The hypervisor can return before processing all the entries, the loop below retries
+	 * until all the entries are processed.
+	 */
+	while (hdr->cur_entry <= hdr->end_entry) {
+		ghcb_set_sw_scratch(ghcb, (u64)__pa(data));
+		ret = vmgexit_page_state_change(ghcb, data);
+		/* Page State Change VMGEXIT can pass error code through exit_info_2. */
+		if (ret || ghcb->save.sw_exit_info_2)
+			break;
+	}
+
+	return ret;
+}
+
+static void snp_set_page_state(unsigned long paddr, unsigned int npages, int op)
+{
+	unsigned long paddr_end, paddr_next;
+	struct snp_page_state_change *data;
+	struct snp_page_state_header *hdr;
+	struct snp_page_state_entry *e;
+	struct ghcb_state state;
+	struct ghcb *ghcb;
+	int ret, idx;
+
+	paddr = paddr & PAGE_MASK;
+	paddr_end = paddr + (npages << PAGE_SHIFT);
+
+	ghcb = sev_es_get_ghcb(&state);
+
+	data = (struct snp_page_state_change *)ghcb->shared_buffer;
+	hdr = &data->header;
+	e = &(data->entry[0]);
+	memset(data, 0, sizeof (*data));
+
+	for (idx = 0; paddr < paddr_end; paddr = paddr_next) {
+		int level = PG_LEVEL_4K;
+
+		/* If we cannot fit more request then issue VMGEXIT before going further.  */
+		if (hdr->end_entry == (SNP_PAGE_STATE_CHANGE_MAX_ENTRY - 1)) {
+			ret = snp_page_state_vmgexit(ghcb, data);
+			if (ret)
+				goto e_fail;
+
+			idx = 0;
+			memset(data, 0, sizeof (*data));
+			e = &(data->entry[0]);
+		}
+
+		hdr->end_entry = idx;
+		e->gfn = paddr >> PAGE_SHIFT;
+		e->operation = op;
+		e->pagesize = X86_RMP_PG_LEVEL(level);
+		e++;
+		idx++;
+		paddr_next = paddr + page_level_size(level);
+	}
+
+	/*
+	 * We can exit the above loop before issuing the VMGEXIT, if we exited before calling the
+	 * the VMGEXIT, then issue the VMGEXIT now.
+	 */
+	if (idx)
+		ret = snp_page_state_vmgexit(ghcb, data);
+
+	sev_es_put_ghcb(&state);
+	return;
+
+e_fail:
+	/* Dump stack for the debugging purpose */
+	dump_stack();
+
+	/* Ask to terminate the guest */
+	sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+}
+
+int snp_set_memory_shared(unsigned long vaddr, unsigned int npages)
+{
+	/* Invalidate the memory before changing the page state in the RMP table. */
+	sev_snp_issue_pvalidate(vaddr, npages, false);
+
+	/* Change the page state in the RMP table. */
+	snp_set_page_state(__pa(vaddr), npages, SNP_PAGE_STATE_SHARED);
+
+	return 0;
+}
+
+int snp_set_memory_private(unsigned long vaddr, unsigned int npages)
+{
+	/* Change the page state in the RMP table. */
+	snp_set_page_state(__pa(vaddr), npages, SNP_PAGE_STATE_PRIVATE);
+
+	/* Validate the memory after the memory is made private in the RMP table. */
+	sev_snp_issue_pvalidate(vaddr, npages, true);
+
+	return 0;
+}
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 16f878c26667..19ee18ddbc37 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -27,6 +27,8 @@
 #include <asm/proto.h>
 #include <asm/memtype.h>
 #include <asm/set_memory.h>
+#include <asm/mem_encrypt.h>
+#include <asm/sev-snp.h>
 
 #include "../mm_internal.h"
 
@@ -2001,8 +2003,25 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	 */
 	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_SME_COHERENT));
 
+	/*
+	 * To maintain the security gurantees of SEV-SNP guest invalidate the memory before
+	 * clearing the encryption attribute.
+	 */
+	if (sev_snp_active() && !enc) {
+		ret = snp_set_memory_shared(addr, numpages);
+		if (ret)
+			return ret;
+	}
+
 	ret = __change_page_attr_set_clr(&cpa, 1);
 
+	/*
+	 * Now that memory is mapped encrypted in the page table, validate the memory range before
+	 * we return from here.
+	 */
+	if (!ret && sev_snp_active() && enc)
+		ret = snp_set_memory_private(addr, numpages);
+
 	/*
 	 * After changing the encryption attribute, we need to flush TLBs again
 	 * in case any speculative TLB caching occurred (but no need to flush
-- 
2.17.1

