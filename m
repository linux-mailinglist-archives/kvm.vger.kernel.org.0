Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843C1347E95
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbhCXRFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:30 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:50401
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236997AbhCXRE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:04:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKp4dM+CLtHN4pjO2vXAjL0HzXncS8Zwn1/+F/mq/wUbsSb0Zo9zr2Gw918GsJHi/wqd53wZ3uLpxC/I2wlfgpcbB4v7Ca1/7IBZrqg/IvsIcqvN9JUWikIBxzUHf1NF9JztPpYAyZYU1sJFJXzn2kwhR6qAfQAUVxR5/t6SG8Z8Zn5BFRwCIrI0n0CqsdgIiiqu4Pv/zVicwpWB4P9N0qKciGnNKVeYZuiMUIrM0O1IUmlcXO8MUBSlYDO52SOO1s3mhkz2R5ySO9ilnK3/6NNFkFGgL6NKaD4gdu2sQ9SgpKL/XYfsyIa3a0If0o+ZqnYt0qtDzONaQIo6z/DiuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yEbF9rxAe78JeeCbPXQ+GaRfrgmMYZagtEiSfDWdsg=;
 b=N+YMhG/bJrbHZ97ZJRZun0rMrBDr9SlYRio6sXlVU+PAMkLNIqtSzkHGhcMhXhT9GSB1Bi55YXEaHdd79P/d3Gm6s6+Tidmp+WpQjUDaBihE78u/UeVMOhOWaRbw3gzyyqhcaQ+nKhN9nJestO/av90tTYU4hlY/QyEsjCTZjUfpmpVd+2tyfdfZvrgz+0TskMQGK/ZnwH19s4fpeDcIYrXbbztjtdlO/9fJ9w4Ci/25Xx8X+NAYZCOxv1XUvT2F/rRjv/2XnnUOEoIs0eXx1WnnUJp2A2mwKQO1C9b0K0Hn+KD9fjJ3YG06mNlFh2zzp516F85IkidOXuUadh9LZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yEbF9rxAe78JeeCbPXQ+GaRfrgmMYZagtEiSfDWdsg=;
 b=wy8SWfsJPGLpMgesJ+6Q0hv7v1CJJLrM0OQELLyNlLMqtToW+uawNdRDH2TKiGSmHfUzb2uKdGfTgB7p8NWd1gzYLaVDwinYSWyuqHhEKZT/VRt2fbWnmCDom+p5Xc6laQqYjc/gM0ZWcvae9Q4DKfINy6MxB/8cMMf9J50/9vU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:55 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:55 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
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
Subject: [RFC Part2 PATCH 06/30] x86/fault: dump the RMP entry on #PF
Date:   Wed, 24 Mar 2021 12:04:12 -0500
Message-Id: <20210324170436.31843-7-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f488b2fe-b9ee-4718-fecb-08d8eee6f2a8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557B89B04DE1569344E2B02E5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +5F9xfBjhoKcpKkvtcPmV5uOFCQvyaiXetd3PD9P2MusvoK25erSJW2ZEkEu3MCTGKPMgfevjSxm8Js+Cs2cpA+ZsVKxkjOdjNgg/Cjpop89Dw/XulcGnjlfWd9up2i0U0cYoTIoaXFc/MWy/z9Vsraqm+pfFhcEzTYtH0rUZJoYRJ4OmlEecmctbtfB02QG5ZyFZvZRri2T0vbFsOkhQ1+xO2a1GIxLZpbAE/Pp7bkOvtXVjXwJ92+g+kDOmbZ1UDyAF/rszVst+uSafZrJ2URMS1W7MewZg0fcoIVb47JqtqUSFIXIrWQbH9HKG2Z6iX/f8tw9PXcT/fvE7lOOa/CdlXQirKZvpO47XCVFO6sRAb6z0SFTtZE3qFZ3yYQ2ZtYqReuWHM1tj+aEjod6ujCMotNP18FmoJFbqdieEiO6SPr7P//T/wZspomI2LbHGCklDjNxcst7vJXUTfLuWvevtFd+mZRVG08uv5WBQq/IROtH19SI/hj3Txx3U2Q6HJlOB6mkO5ihsM62Eh0L4Qe46atkA2yUe+2u+ViKsjvzw2Wci8ttXim3f6aLaeKmyWkZW6NCKW5/iHPA4h27wjcaBE7dFFCrb7y5CboS9XMMLV87rT02QA+t1nAZne8qsRyGnhPwSAKZn9GV9XMlqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?slak0qRABXmMsRitjEDoJc4nVvIuF+f0WoNLSs7zyS/ewzBvRPY5/Q3H2L7O?=
 =?us-ascii?Q?LeuP3d7Ja1NnLK/Ge696J9mIr850Pbz3jBabikJk3ZUEEFliBN58qZaSLn5K?=
 =?us-ascii?Q?yhIjh/B6T+MVJMf6HoMb77lnk1UOMa+l4zKts2k/+/plyRA1Io9hzjWC+nRl?=
 =?us-ascii?Q?7gPa+MyeOPpiWZM2sPqDJ6U+UcAOJ6Io6ZD7NAr6HUpTWcy09fXM9S2tNZeK?=
 =?us-ascii?Q?5SOcST1zkJu/q2bFMX555RZmhjp+7m2rVmhjoX8L+J/kvc/0ffap5ioxhsIg?=
 =?us-ascii?Q?OvzHnoEV1n2oKnYwSLiskLQRSkl7yaD7/LLrX0s1XotYrx8u+ssfW5sJDy8C?=
 =?us-ascii?Q?g5uJwKxrFnXcwmLCPKvTpaGCHhwSmIDZpIHbRSJA7IqHQa5gs5tna/9HR0kO?=
 =?us-ascii?Q?ldA2FRWMumIm4SbV3ZVWZRWg+//OuJpaHg+uuDu/ciPEX0sio2Ezmy6wdiZ9?=
 =?us-ascii?Q?mbKUWEPvq1C/Ng3HE/Ve//GJGiyu8PqK8jDZARUllYTW/l15E4i/4HFcPBOx?=
 =?us-ascii?Q?3NjBMWajIRpw2KjpZ5dtUM0CbD9xP9tPD7J/RjUTiLbHAOJhg1FNchRSAo25?=
 =?us-ascii?Q?rvSQeAgBrbV2wvuiQaYEmyiUP2flA1b3NxylF5ZXIMqNQhxui/0m3eyMpfWG?=
 =?us-ascii?Q?pmnFmAllBE3aYbyUQDfIDDlUn3mQ9YrKjGbkfPSnzAyCQAsfxE7ZZdisp2Gq?=
 =?us-ascii?Q?gKyJkZNZmeWngk1yeZ8n42balS0z6NdAz5aKto27iHW5CC/1YeHw3t3+9bK4?=
 =?us-ascii?Q?tu7F8CP5SEmvbTTT0IVCGxVS54oMBNoIqytSaKOuwzEmtihkA97+TpCV+RoE?=
 =?us-ascii?Q?0I10lH/4jmiJM/A8AEVRemKyGqRNtXNNKQ6WC5wu0RPqskstXnhQ73CheFLz?=
 =?us-ascii?Q?tRc/w1XLAfXJEZrHmn12AYcRRb/UYzSDFX7GNuQm6Wn6RmeyRTKLVwCM26j0?=
 =?us-ascii?Q?TtOpEoRIfNYRKHKGcbG8BQnKAcAaKWkIFiqZnBpCxQXwpbedISC0xFQzLOow?=
 =?us-ascii?Q?s9o27tJEYTzRJzxLruEBSr1iQY40Lfzhz5LdDzRS/hFg84VMTx7UTDzNI7gI?=
 =?us-ascii?Q?QmvmRJhT4vkTJu3wbaKGM/qsxcKDe3CfEZIvLyTLUg57aMm9RcsRyNNjrx32?=
 =?us-ascii?Q?OQnhxwFzd23giv2eWPW4LFzMSf3dTxgDVhET1Sw2+booVD4izikWLQ0ZictB?=
 =?us-ascii?Q?wcTRHfv/pyysAzWl2s5800EE+P51bOQA53dwfkopMMPtCjuqk8uTj1HKSYBP?=
 =?us-ascii?Q?5yxStWj17MJXRRIzGGR/MoxlQWET+TQCBw4gXt3TmUlbGG0TTnTNRjzpHBcn?=
 =?us-ascii?Q?wQwhFIHETEFeRQg+qVjeTRX4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f488b2fe-b9ee-4718-fecb-08d8eee6f2a8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:55.5924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HTp773CCWwOLEJaubrYa7cRAdodqgjeq78DS3gYfEz0OMg2jo+SOy9Y0LR1JAl1SIgV5RlVP8oypsM+5wwWTYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If hardware detects an RMP violation, it will raise a page-fault exception
with the RMP bit set. To help the debug, dump the RMP entry of the faulting
address.

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
 arch/x86/mm/fault.c | 75 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f39b551f89a6..7605e06a6dd9 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -31,6 +31,7 @@
 #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
+#include <asm/sev-snp.h>		/* lookup_rmpentry ...		*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -147,6 +148,76 @@ is_prefetch(struct pt_regs *regs, unsigned long error_code, unsigned long addr)
 DEFINE_SPINLOCK(pgd_lock);
 LIST_HEAD(pgd_list);
 
+static void dump_rmpentry(struct page *page, rmpentry_t *e)
+{
+	unsigned long paddr = page_to_pfn(page) << PAGE_SHIFT;
+
+	pr_alert("RMPEntry paddr 0x%lx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx asid=%d "
+		"vmsa=%d validated=%d]\n", paddr, rmpentry_assigned(e), rmpentry_immutable(e),
+		rmpentry_pagesize(e), rmpentry_gpa(e), rmpentry_asid(e), rmpentry_vmsa(e),
+		rmpentry_validated(e));
+	pr_alert("RMPEntry paddr 0x%lx %016llx %016llx\n", paddr, e->high, e->low);
+}
+
+static void show_rmpentry(unsigned long address)
+{
+	struct page *page = virt_to_page(address);
+	rmpentry_t *entry, *large_entry;
+	int level, rmp_level;
+	pgd_t *pgd;
+	pte_t *pte;
+
+	/* Get the RMP entry for the fault address */
+	entry = lookup_page_in_rmptable(page, &rmp_level);
+	if (!entry) {
+		pr_alert("SEV-SNP: failed to read RMP entry for address 0x%lx\n", address);
+		return;
+	}
+
+	dump_rmpentry(page, entry);
+
+	/*
+	 * If fault occurred during the large page walk, dump the RMP entry at base of 2MB page.
+	 */
+	pgd = __va(read_cr3_pa());
+	pgd += pgd_index(address);
+	pte = lookup_address_in_pgd(pgd, address, &level);
+	if ((level > PG_LEVEL_4K) && (!IS_ALIGNED(address, PMD_SIZE))) {
+		address = address & PMD_MASK;
+		large_entry = lookup_page_in_rmptable(virt_to_page(address), &rmp_level);
+		if (!large_entry) {
+			pr_alert("SEV-SNP: failed to read large RMP entry 0x%lx\n",
+				address & PMD_MASK);
+			return;
+		}
+
+		dump_rmpentry(virt_to_page(address), large_entry);
+	}
+
+	/*
+	 * If the RMP entry at the faulting address was not assigned, then dump may not provide
+	 * any useful debug information. Iterate through the entire 2MB region, and dump the RMP
+	 * entries if one of the bit in the RMP entry is set.
+	 */
+	if (!rmpentry_assigned(entry)) {
+		unsigned long start, end;
+
+		start = address & PMD_MASK;
+		end = start + PMD_SIZE;
+
+		for (; start < end; start += PAGE_SIZE) {
+			entry = lookup_page_in_rmptable(virt_to_page(start), &rmp_level);
+			if (!entry)
+				return;
+
+			/* If any of the bits in RMP entry is set then dump it */
+			if (entry->high || entry->low)
+				pr_alert("RMPEntry paddr %lx: %016llx %016llx\n",
+					page_to_pfn(page) << PAGE_SHIFT, entry->high, entry->low);
+		}
+	}
+}
+
 #ifdef CONFIG_X86_32
 static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 {
@@ -580,6 +651,10 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 	}
 
 	dump_pagetable(address);
+
+	if (error_code & X86_PF_RMP)
+		show_rmpentry(address);
+
 }
 
 static noinline void
-- 
2.17.1

