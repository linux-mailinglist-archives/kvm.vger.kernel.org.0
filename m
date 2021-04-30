Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B36B36FA84
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhD3MkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:40:11 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:33505
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232501AbhD3Mj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:39:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5WeossFBSp1CjS35+X9qltGDGTw7T2yZS+yFmuQU39eMItwalUHOvtGaUzKQLt+kBmbxFYwlQzhHT8c0xkTgiSJqM9rVmmoeSYFMNlMazTOpzyBu1nV7pc92pNqHkW9K8IN9sH2SvNCFwtOklB/+1apLiNYNs6+1RY0BtdBNrdtwAWQJ3knUcs4XUNpiuG2pDSGopcYb/3peGQYl+luBkerWYMhvHpRGtw0BFM6xmdj3dKvDwQROt1LpAxUSfZGE1nivBEWZYUYoxlgeQOf0buzmEYIG54pctQyyzvcnucqQRgcZIqFFb44Uamj2kBRBaxGh/Pfwi8bwGNTNlexyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCyQrABOK79UUGNlr+sQq2uK45PIMflOhTcnCmYUUZM=;
 b=kp8KQkZfKDI5DuUAlZ216v8iwFD+iwL/QdBbAuL3WB3BfZiCyjsx/AWwZ1RNYQJs7T5tHUvoetYZxo+uN4mlm/t+aeXkQlI00wafn5vEM3m64XPYur/VGZkiQ9zOhOnwMiuUAIYYwj6T97lCbXx2nOjdgw+04dBiOVuiBJHDgsANycC4tehb9+HztPzZYKwMm4jrXbCjY6XdPawmWcy5vjo0AwXZX7zAAsGkMm9LM9I6n08yV5fz2xzOiiXyRQ0UQqom8p2MEvSH1G6IVVcfSD41X+yDyy96qmRTPaqdvli5IoMyjq8BI0mv+3H61IjtwosuiXwC76g8eTcVpSy9UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCyQrABOK79UUGNlr+sQq2uK45PIMflOhTcnCmYUUZM=;
 b=Kg84P2cgFXTHTQIkjpdD0xY9GAhtyUhorj8CdQGfJ5s36YgtB/cYTc4cihUv1RKQjSa9ryCYc7NCBbcKmKpJL2RJtSdp8DEELCYQ/1T12dix64yR/wznjPAISSs8eso2T/sKWmTDNYYx2F89RS86KEn3QwncRVR9xWmO1OEmyKk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:01 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:01 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 10/37] x86/fault: Add support to handle the RMP fault for kernel address
Date:   Fri, 30 Apr 2021 07:37:55 -0500
Message-Id: <20210430123822.13825-11-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bf20d5d-6549-4eb7-7fe1-08d90bd4ee3a
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB28324ED858E6540E6CA14C04E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cIceHTwfnDB6LBrE/jg7iFWuyflVC+R8O87T5a0FJxxOWPCXh1zoUEABppF5b+dWdrfcEYVXzoa8rO+jHJmIiE9jXf9RfnYNC/1WEpdNBUEa7MimXzlEbYMlflqIiW+egj7777hFr0MVpEuPWonGNwCIRva/aQJMoAMeVDA+5C5XZ5TFQh6JMCNfUIQ0Qg83qF4TWSfC4eYSoTqeXs9osxvpnxwPZlTx0lz0l2L0CCfEBRK92LK1Pr41o+BCx7kIPT68kdWLkEuprf/5X6DDn0Jaiz1b7/Dodttpmh1UyCt6ZydJaG2Trbl+clWnoDjmLnd0BlWWhvU0T59jMtdSiq3t/wr20PwjrjkXppt0hPBFRJ8V1RHgMDl+qicTjwVkXPCW7fZfQPvu6XeXfepNKDaaaujdFOK0PrKZrky9vn1p6L4F9ssHbJejlfgnii76Lza96oC8Ly3wFRW+aQ/NH3TEdirHOWf3KZWCKBL4gVCwcaIYqZ0cEQoqlU4m8cSj/no56jWYXr4yebutw1UgREDW8RO25CFP3lfDAGQf6gyaFdlMdlrMUoKKSn2S9C+WBKdgIF0Mg1Vzdl59HawSOHgZ5X0CtsIYN4Cc6BTE6csqDRsNlx7IH8H8Wy2XZFfbC2Wn9mg99zt4DoEaYVgdsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Rn/hOGE5zgOc19JGwTzr9KmvYXVOZGr9D0B2OZ0pwjP8JDXIlWcapmAbW8J4?=
 =?us-ascii?Q?HxQ5hPxTjQqbEWes4tNXlfyQFomNxow1NvSSQC2L4wd9GfrtxJ5VlvRteJmg?=
 =?us-ascii?Q?9rvGJtB0FdKqaG31x8MKbeYZGYkUCPiyoaYZtvrcMzvCi9CYjRioCqqtl9wK?=
 =?us-ascii?Q?uTHK2uM42c8iOr6WKfGAiHpfMugyY7QXvjFHYTAnk0FFRIunlh0Nx0XWIcBE?=
 =?us-ascii?Q?XOR9y2A3OvP2KpZTOaT0TJXPvmEoIQOZElmKHfjtX1bglequ6s56hH0+IukB?=
 =?us-ascii?Q?z/BgZg6jib6Lq7sJyQwrmvi1r0/kRcQZsTleD1i3v/MfwzYZrpHMDCLnBy2q?=
 =?us-ascii?Q?5uGIOeTlz/gzGawZO1tIVnqkSUfJzA6V1QuEYSIRP0V50ln5XUZloAg/n+i2?=
 =?us-ascii?Q?uDqFPHDGsxwBI+q405wROfxVkNxX+HcXFZZVrgaUABPHB+qdh/NvQcCFUN+u?=
 =?us-ascii?Q?gNpdOHBcqGBeXPdlNZFxs8f+GZJcL9YlVsGiP5GYTShPuvrUnsMizqgAEmne?=
 =?us-ascii?Q?T/pW9RpwgO74SUobgrpsk9deY5d7tLveC/1CrbKtFI7DEwcSb74FvbzwzJ7B?=
 =?us-ascii?Q?6uPJM8iXtYeMJHuYYBiZ0oRPv4u4eSEhOqTLqpvHMUKPwhfm/Z3Gni/ZlzY5?=
 =?us-ascii?Q?Eiz6GKqdpCDZK7pnV5aYRq1jle9ksT/c2XmSz5cVr0NMz7gG0klpt0rJSTxy?=
 =?us-ascii?Q?+ck1NINE/X5aiQX531FFpnFqGdPu+PJgeolT/NULm4WDWYsb0w3mAB9qvu2T?=
 =?us-ascii?Q?1uJTLqRuOpB97zxjHn7ICD4BSBytSsP6Hk53wJfgKfZftD01372p6GOdrtIK?=
 =?us-ascii?Q?q8CODwFgvcYdVP1NQAwXOXzwQq6QUbValfoOgdHhwDkT+XOh6VWkXi08WzpT?=
 =?us-ascii?Q?3OT/1evbI3dk0hInvN/QJ3iE6Iu4d8gE5UnrCKhKXjMaf2Y3XXL9M2HB/SED?=
 =?us-ascii?Q?YHdZFLAi2C5ui5tRLbVbrVBPW9ngEHEgq5kzauoCXJcRPXzZ1y/5gT23uxNq?=
 =?us-ascii?Q?Yye8eIovo4ACP6tZiW3RTLPK6R+JxC3J/EAJnGuitSZY9jYxTjQPlDftCQrv?=
 =?us-ascii?Q?orHdOLMYVWLZCvgMTOBF0Wk1TrkvBNlIAkyr4E1yOp2ilvPkVY6O56Gak9Yx?=
 =?us-ascii?Q?yHmj144tbU/tS+J2uf1PI9QNV5wURZdCKHCGagw4R8BlYRSOLWn8o4DSQsdz?=
 =?us-ascii?Q?MtcSfTAdcaIJ12sgVnzCBjJCdZIk7fpQd9tqZdgalGryE9i1Pz3qZVd8lmLH?=
 =?us-ascii?Q?e+SypU5UVVqUinoxVi4LapE9kTU0JvIEiOwdVBJxvKOrvWq8LwaAzFvnPoHg?=
 =?us-ascii?Q?hv82888QiEfJb+iWMQgByPcR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf20d5d-6549-4eb7-7fe1-08d90bd4ee3a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:00.9198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nRmtZyNfrbhpnPFFmRFEmJxYXpLgvKHCLludYJUfRY+KLsL8bj2QBtBCOppziaz/WbjKI0DxMIHu0fzhYeqs3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is enabled globally, a write from the host goes through the
RMP check. When the host writes to pages, hardware checks the following
conditions at the end of page walk:

1. Assigned bit in the RMP table is zero (i.e page is shared).
2. If the page table entry that gives the sPA indicates that the target
   page size is a large page, then all RMP entries for the 4KB
   constituting pages of the target must have the assigned bit 0.
3. Immutable bit in the RMP table is not zero.

The hardware will raise page fault if one of the above conditions is not
met. A host should not encounter the RMP fault in normal execution, but
a malicious guest could trick the hypervisor into it. e.g., a guest does
not make the GHCB page shared, on #VMGEXIT, the hypervisor will attempt
to write to GHCB page.

Try resolving the fault instead of crashing the host. To resolve it,
forcefully clear the assigned bit from the RMP entry to make the page
shared so that the write succeeds.  If the fault handler cannot resolve
the RMP violation, then dump the RMP entry for debugging purposes.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/mm/fault.c | 146 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 146 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 39d22f6870e1..d833fe84010f 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -19,6 +19,7 @@
 #include <linux/uaccess.h>		/* faulthandler_disabled()	*/
 #include <linux/efi.h>			/* efi_crash_gracefully_on_page_fault()*/
 #include <linux/mm_types.h>
+#include <linux/sev.h>			/* snp_lookup_page_in_rmptable() */
 
 #include <asm/cpufeature.h>		/* boot_cpu_has, ...		*/
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
@@ -1132,6 +1133,145 @@ bool fault_in_kernel_space(unsigned long address)
 	return address >= TASK_SIZE_MAX;
 }
 
+#define RMP_FAULT_RETRY		0
+#define RMP_FAULT_KILL		1
+#define RMP_FAULT_PAGE_SPLIT	2
+
+static inline size_t pages_per_hpage(int level)
+{
+	return page_level_size(level) / PAGE_SIZE;
+}
+
+static void dump_rmpentry(unsigned long pfn)
+{
+	struct rmpentry *e;
+	int level;
+
+	e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &level);
+
+	/*
+	 * If the RMP entry at the faulting address was not assigned, then dump may not
+	 * provide any useful debug information. Iterate through the entire 2MB region,
+	 * and dump the RMP entries if one of the bit in the RMP entry is set.
+	 */
+	if (rmpentry_assigned(e)) {
+		pr_alert("RMPEntry paddr 0x%lx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx"
+			" asid=%d vmsa=%d validated=%d]\n", pfn << PAGE_SHIFT,
+			rmpentry_assigned(e), rmpentry_immutable(e), rmpentry_pagesize(e),
+			rmpentry_gpa(e), rmpentry_asid(e), rmpentry_vmsa(e),
+			rmpentry_validated(e));
+
+		pr_alert("RMPEntry paddr 0x%lx %016llx %016llx\n", pfn << PAGE_SHIFT,
+			e->high, e->low);
+	} else {
+		unsigned long pfn_end;
+
+		pfn = pfn & ~0x1ff;
+		pfn_end = pfn + PTRS_PER_PMD;
+
+		while (pfn < pfn_end) {
+			e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &level);
+
+			if (unlikely(!e))
+				return;
+
+			if (e->low || e->high)
+				pr_alert("RMPEntry paddr 0x%lx: %016llx %016llx\n",
+					pfn << PAGE_SHIFT, e->high, e->low);
+			pfn++;
+		}
+	}
+}
+
+/*
+ * Called for all faults where 'address' is part of the kernel address space.
+ * The function returns RMP_FAULT_RETRY when its able to resolve the fault and
+ * its safe to retry.
+ */
+static int handle_kern_rmp_fault(unsigned long hw_error_code, unsigned long address)
+{
+	int ret, level, rmp_level, mask;
+	struct rmpupdate val = {};
+	struct rmpentry *e;
+	unsigned long pfn;
+	pgd_t *pgd;
+	pte_t *pte;
+
+	if (unlikely(!cpu_feature_enabled(X86_FEATURE_SEV_SNP)))
+		return RMP_FAULT_KILL;
+
+	pgd = __va(read_cr3_pa());
+	pgd += pgd_index(address);
+
+	pte = lookup_address_in_pgd(pgd, address, &level);
+
+	if (unlikely(!pte))
+		return RMP_FAULT_KILL;
+
+	switch(level) {
+	case PG_LEVEL_4K: pfn = pte_pfn(*pte); break;
+	case PG_LEVEL_2M: pfn = pmd_pfn(*(pmd_t *)pte); break;
+	case PG_LEVEL_1G: pfn = pud_pfn(*(pud_t *)pte); break;
+	case PG_LEVEL_512G: pfn = p4d_pfn(*(p4d_t *)pte); break;
+	default: return RMP_FAULT_KILL;
+	}
+
+	/* Calculate the PFN within large page. */
+	if (level > PG_LEVEL_4K) {
+		mask = pages_per_hpage(level) - pages_per_hpage(level - 1);
+		pfn |= (address >> PAGE_SHIFT) & mask;
+	}
+
+	e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
+	if (unlikely(!e))
+		return RMP_FAULT_KILL;
+
+	/*
+	 * If the immutable bit is set, we cannot convert the page to shared
+	 * to resolve the fault.
+	 */
+	if (rmpentry_immutable(e))
+		goto e_dump_rmpentry;
+
+	/*
+	 * If the host page level is greather than RMP page level then only way to
+	 * resolve the fault is to split the address. We don't support splitting
+	 * kernel address in the fault path yet.
+	 */
+	if (level > rmp_level)
+		goto e_dump_rmpentry;
+
+	/*
+	 * If the RMP page level is higher than host page level then use the PSMASH
+	 * to split the RMP large entry into 512 4K entries.
+	 */
+	if (rmp_level > level) {
+		ret = psmash(pfn_to_page(pfn & ~0x1FF));
+		if (ret) {
+			pr_alert("Failed to psmash pfn 0x%lx (rc %d)\n", pfn, ret);
+			goto e_dump_rmpentry;
+		}
+	}
+
+	/* Log that the RMP fault handler is clearing the assigned bit. */
+	if (rmpentry_assigned(e))
+		pr_alert("Force address %lx from assigned -> unassigned in RMP table\n", address);
+
+	/* Clear the assigned bit from the RMP table. */
+	ret = rmpupdate(pfn_to_page(pfn), &val);
+	if (ret) {
+		pr_alert("Failed to unassign address 0x%lx in RMP table\n", address);
+		goto e_dump_rmpentry;
+	}
+
+	return RMP_FAULT_RETRY;
+
+e_dump_rmpentry:
+
+	dump_rmpentry(pfn);
+	return RMP_FAULT_KILL;
+}
+
 /*
  * Called for all faults where 'address' is part of the kernel address
  * space.  Might get called for faults that originate from *code* that
@@ -1179,6 +1319,12 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 	}
 #endif
 
+	/* Try resolving the RMP fault. */
+	if (hw_error_code & X86_PF_RMP) {
+		if (handle_kern_rmp_fault(hw_error_code, address) == RMP_FAULT_RETRY)
+			return;
+	}
+
 	if (is_f00f_bug(regs, hw_error_code, address))
 		return;
 
-- 
2.17.1

