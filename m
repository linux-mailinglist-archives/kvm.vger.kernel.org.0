Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A18736F9EF
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhD3MSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:18:13 -0400
Received: from mail-dm6nam10on2056.outbound.protection.outlook.com ([40.107.93.56]:37728
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232313AbhD3MR7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uy+1/iq2zQ6ZU7N/XZDyaNTBYUwzmDcxYgOr5dPofQayFTyO843LPabK7AjJJuUnKOExeq5rssQeIxJXbGlckPCzt8db1IPvBmmNK/LphxhrV7eB5uLLJu03QLVJPOgq/em+GFXorAoy1nY/Wy0zMY+bvXg0rn77Ndf2jIl2+Zn7ayvXhNwfKTTZ9x19EzMVyr9udKmzchyM1u106uLX8qCJOyaGdKUETP+hgvfxBGeIav7by6RfCi+MCvGEnFGflDv21SOuj05h+r+Ymj4AmNSvHcg+hF6ysJGGJ6GiS6tA3LzqDTICMHDt7TeCaQhCq0nGouAIgTOBD1ZnbEkJzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2IYYbkzCemoJSX5JRfh+d6XPS1LjlSdPCKjkUCy/6rk=;
 b=D09IqOkhfJagdOMnpHCFxVBHWYdnP9wkp+22G8D/uHSRasO/ZF4FyhOepsnsQjB9O6wcFwL/KoLtZ+yxw3H8UQb2/pkZT/0aSauKq1N5DCv/KpiZmGf16pxkUbfj3ENRv4hz+076ij+eRHn33f0PUvttZqATigGDrOswtIP60zt0JZw2dyuyNPKRzH9GOqeF9y7tUyYtLuCrS708yjmk4S3/VUWUyFmNi7X+LaxSuz/M3BYZdxGcWGwOxRWg+DVAOgTm/Gt6y3Vj0G0LTsRnjvhGUksjBbFTvlmdCRjjUtuLPp3eMWZ36YEkBiPMnEoEqjsMUXePmSGl57wmzrlZVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2IYYbkzCemoJSX5JRfh+d6XPS1LjlSdPCKjkUCy/6rk=;
 b=YBt9qyB5Ico/vVG8CtZqUHx3ntU1bDcfkoKf2iBQ6gMhbEdZSKqjqBOjdCEu9BhmICZiWqlkoT/4jiiKgwqn9OK5vnsQS++DjjtyGWw0PUGo/AolIizWOs/ZJOg0f5P0/s/nTOHmFllsEdQ0lnm91wsHLtKo/ho5X3qiTB8xzWI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 12:17:02 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:17:02 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 14/20] x86/sev: Add helper for validating pages in early enc attribute changes
Date:   Fri, 30 Apr 2021 07:16:10 -0500
Message-Id: <20210430121616.2295-15-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f474b941-8b9d-45ff-befd-08d90bd1d9a2
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26408FF1B1FEBD05C17C8E39E55E9@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ceuaSeusMnVPb54CGk2NgtQwRTeOKCNeA4MU9YFy6ofIwwjEl3GwGJx7PpYmwZoR/38ewufPr0sd5WeEvyvxJ5Va4PofZWQH89HFGuCpMXUNdt3705Mr5ZHH7A43mIUqK8IFXn97PtqLyBJBk0jU9hm1WXoTC/VPTHtA97pveiX4y+jwiZmq28k/6cnPsedfda7qidQ3Z/Bh/Nu6QF3n69h4c1PdFL3tNqSh7V3fDmuZ0zLDypE6hkvl7svAW4gUbV32iDoIx/WsWC9TL3eDdt5GrKCwePRMNQoJ56yqC6cyAr46mmt982eW1baqNO8a2zynxHd/tsIx75Zzh5uGbOjLvNxGlWV+GDnluPfr0lLmucAWncS1cZJts3i88x0YKsGE0EA7kRVsOjXC3f1lOzI30LtodnjU9rPrT2VYyb8al09J+rS4WpZDyVvE7SJ17TD64TSpx112PfgpMcrydHxHl2vULEDQOrv8zPaN6q4bhRYUJxm1nr6RxfBgTGuBFlGxZ+AfY9FLCT0cX3v29pj4+4i2J3osM8J0kV2s6YWtlDnee5fFV0DRpmexwXgqDyOPxmbg8R+gfgwAXVCR1xHvRc4atgWqM0SKN2q9juqTcaFjbQvpEZdT6e1DoCBwTmnYPMXWXBetXN1Wzhlefw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(6666004)(52116002)(7416002)(316002)(16526019)(2906002)(36756003)(186003)(26005)(38100700002)(38350700002)(66556008)(66946007)(5660300002)(1076003)(66476007)(4326008)(83380400001)(6486002)(86362001)(8936002)(956004)(44832011)(2616005)(8676002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xyeZ6nRIUuGwc15mUIALOq5VhEM7XH8o34eVedg58Qij5kcw8tAwDq/iFV4a?=
 =?us-ascii?Q?KddMTSYf4HtJRnh0zQyMTUAMZD8fXOgeTBfBCWA1Cz10nxwID0QMJaHcEkyo?=
 =?us-ascii?Q?oklFY8a9ZFcAaWcJQfYXuJUeVODfRJLXdEXpkLhfFZCOsoPLVPbAoaB8YYHI?=
 =?us-ascii?Q?aU5FAIO5sxCfuYpoTiTIeDlQLxrGvBRRn7WxYYOJXqOiZb2Rr77yvhKW4FhH?=
 =?us-ascii?Q?9uh+c/MVDZVsx7IH7MdVwWztM7gv479eLoZ5wYbCRM7ey5Ex/dvLZ7WKz3OA?=
 =?us-ascii?Q?CKJ0yxkRBGLggTEIdhZRpQE0rjfUfIKdMRlbj7rdOpULKuGHN04ooe5zAHfH?=
 =?us-ascii?Q?1xwuECBjzL08DILYBU2233awHxWq87jwqDsrP4AW28rKeeQV+AqkRDhUUmFU?=
 =?us-ascii?Q?08fB+nbqWaZIyPjB2bypKtwM6ijRd5NCapTGHVSLYanAjo99RCz0mofF0b68?=
 =?us-ascii?Q?YkfAFmGCJqRJ8fMAe97ZDrr31VkrMaL3alfi7g7Hp2i7f1uc7k/3I/XIZh2M?=
 =?us-ascii?Q?QD9ALtQNJHdP5jWI9MdPISjm7mgE4cqsDkhJIwvh9fYL2PnmIk6rVdkfFXzE?=
 =?us-ascii?Q?XSnOZoNdRKTMmVqNpaumwnqGVAZRNrb5W4RAlE5mJH0T5KNuFc4w1vI4fByY?=
 =?us-ascii?Q?EMP8gg12A1+1swZFwKstye44+3Gv6Lz0c2/WnulftXDpNroF2KOLrZeW+0an?=
 =?us-ascii?Q?8NSxJnMs46Zd6sLEfa/wvyaPOe4z/ukR+oLIgCaCvVJsb4jdBJKWA1BGa0wz?=
 =?us-ascii?Q?hIAf217mj1oohs0ZIgocnUEiYSpkvQ4xtC40NMNCvZmMyZNOREmO4fTcvARQ?=
 =?us-ascii?Q?EtbIKnrRfJxd2KnQfegvPRO2DUHKw/PZnbU9kLS/EC8pn7x02Qgx7t5LijPp?=
 =?us-ascii?Q?dkcNQ3qLMv36JoeXi1R+GT80yl+3jf0CMuYoTR7vUu9zILkLpCFLO9QJNlLE?=
 =?us-ascii?Q?4/mn/WNX1o7MlOBj1Af0NPQGfKKN4Fatz0WyXfdxZiNYzuW/R7kX2TTikJ+a?=
 =?us-ascii?Q?ImDvqcuZ/K9V3JUUWZRku48jR7wjCPfvoUNtRvSIEpkttq3naU8qC1iffFQN?=
 =?us-ascii?Q?FvDTV8aMehIoMCm2u+pGGL32GkDwdp1yPbN8XhzwEJfAjbtX46LuWYDd8qst?=
 =?us-ascii?Q?GdQ1j7pz2gX66livFVGtDh54ICs/Y+aYCK/0I8nMj2LSOqvrD4BuDmI40enB?=
 =?us-ascii?Q?OIK5eXsgSAuJlBuOFWm9aaYHZeWKV+XtPGTr+LmJ9AfQpHrgR6UXhK/Y5/3Q?=
 =?us-ascii?Q?B1SbNijPznNDJfWleDKErhB4Y+KB2SXhrduP4+9CoG6GovbgJ36nx8ihA3xS?=
 =?us-ascii?Q?0uaAfAuda4U5vBpi06QQH+Ll?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f474b941-8b9d-45ff-befd-08d90bd1d9a2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:57.8367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUQ7PHX2TsZc3Vdliy0SDzVQOh+iRXJOF33gGp3lwwd3Aq/KFu10nX0lPmB9Ex5A10rIEfWHJmMMmYKNHlVL0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The early_set_memory_{encrypt,decrypt}() are used for changing the
page from decrypted (shared) to encrypted (private) and vice versa.
When SEV-SNP is active, the page state transition needs to go through
additional steps.

If the page is transitioned from shared to private, then perform the
following after the encryption attribute is set in the page table:

1. Issue the page state change VMGEXIT to add the page as a private
   in the RMP table.
2. Validate the page after its successfully added in the RMP table.

To maintain the security guarantees, if the page is transitioned from
private to shared, then perform the following before clearing the
encryption attribute from the page table.

1. Invalidate the page.
2. Issue the page state change VMGEXIT to make the page shared in the
   RMP table.

The early_set_memory_{encrypt,decrypt} can be called before the GHCB
is setup, use the SNP page state MSR protocol VMGEXIT defined in the GHCB
specification to request the page state change in the RMP table.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev.h | 12 ++++++
 arch/x86/kernel/sev.c      | 87 ++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c  | 43 ++++++++++++++++++-
 3 files changed, 140 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 48f911a229ba..62aba82acfb8 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -107,6 +107,10 @@ static inline int pvalidate(unsigned long vaddr, bool rmp_psize, bool validate)
 
 	return rc;
 }
+void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
+		unsigned int npages);
+void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
+		unsigned int npages);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -114,6 +118,14 @@ static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { ret
 static inline void sev_es_nmi_complete(void) { }
 static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
 static inline int pvalidate(unsigned long vaddr, bool rmp_psize, bool validate) { return 0; }
+static inline void __init
+early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr, unsigned int npages)
+{
+}
+static inline void __init
+early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr, unsigned int npages)
+{
+}
 #endif
 
 #endif
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index e6819f170ec4..33420f6da030 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -525,6 +525,93 @@ static u64 get_jump_table_addr(void)
 	return ret;
 }
 
+static void pvalidate_pages(unsigned long vaddr, unsigned int npages, bool validate)
+{
+	unsigned long vaddr_end;
+	int rc;
+
+	vaddr = vaddr & PAGE_MASK;
+	vaddr_end = vaddr + (npages << PAGE_SHIFT);
+
+	while (vaddr < vaddr_end) {
+		rc = pvalidate(vaddr, RMP_PG_SIZE_4K, validate);
+		if (rc) {
+			WARN(rc, "Failed to validate address 0x%lx ret %d", vaddr, rc);
+			goto e_fail;
+		}
+
+		vaddr = vaddr + PAGE_SIZE;
+	}
+
+	return;
+
+e_fail:
+	sev_es_terminate(1, GHCB_TERM_PVALIDATE);
+}
+
+static void __init early_snp_set_page_state(unsigned long paddr, unsigned int npages, int op)
+{
+	unsigned long paddr_end;
+	u64 val;
+
+	paddr = paddr & PAGE_MASK;
+	paddr_end = paddr + (npages << PAGE_SHIFT);
+
+	while (paddr < paddr_end) {
+		/*
+		 * Use the MSR protcol because this function can be called before the GHCB
+		 * is established.
+		 */
+		sev_es_wr_ghcb_msr(GHCB_MSR_PSC_REQ_GFN(paddr >> PAGE_SHIFT, op));
+		VMGEXIT();
+
+		val = sev_es_rd_ghcb_msr();
+
+		if (GHCB_RESP_CODE(val) != GHCB_MSR_PSC_RESP)
+			goto e_term;
+
+		if (GHCB_MSR_PSC_RESP_VAL(val)) {
+			WARN(1, "Failed to change page state to '%s' paddr 0x%lx error 0x%llx\n",
+				op == SNP_PAGE_STATE_PRIVATE ? "private" : "shared", paddr,
+				GHCB_MSR_PSC_RESP_VAL(val));
+			goto e_term;
+		}
+
+		paddr = paddr + PAGE_SIZE;
+	}
+
+	return;
+
+e_term:
+	sev_es_terminate(1, GHCB_TERM_PSC);
+}
+
+void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
+					 unsigned int npages)
+{
+	if (!sev_snp_active())
+		return;
+
+	 /* Ask hypervisor to add the memory pages in RMP table as a 'private'. */
+	early_snp_set_page_state(paddr, npages, SNP_PAGE_STATE_PRIVATE);
+
+	/* Validate the memory pages after its added in the RMP table. */
+	pvalidate_pages(vaddr, npages, 1);
+}
+
+void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
+					unsigned int npages)
+{
+	if (!sev_snp_active())
+		return;
+
+	/* Invalidate memory pages before making it shared in the RMP table. */
+	pvalidate_pages(vaddr, npages, 0);
+
+	 /* Ask hypervisor to make the memory pages shared in the RMP table. */
+	early_snp_set_page_state(paddr, npages, SNP_PAGE_STATE_SHARED);
+}
+
 int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
 {
 	u16 startup_cs, startup_ip;
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 076d993acba3..f722518b244f 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -30,6 +30,7 @@
 #include <asm/processor-flags.h>
 #include <asm/msr.h>
 #include <asm/cmdline.h>
+#include <asm/sev.h>
 
 #include "mm_internal.h"
 
@@ -50,6 +51,30 @@ bool sev_enabled __section(".data");
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
 
+/*
+ * When SNP is active, this routine changes the page state from private to
+ * shared before copying the data from the source to destination and restore
+ * after the copy. This is required because the source address is mapped as
+ * decrypted by the caller of the routine.
+ */
+static inline void __init snp_memcpy(void *dst, void *src, size_t sz, unsigned long paddr,
+				     bool dec)
+{
+	unsigned long npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
+
+	if (dec) {
+		/* If the paddr needs to be accessed decrypted, make the page shared before memcpy. */
+		early_snp_set_memory_shared((unsigned long)__va(paddr), paddr, npages);
+
+		memcpy(dst, src, sz);
+
+		/* Restore the page state after the memcpy. */
+		early_snp_set_memory_private((unsigned long)__va(paddr), paddr, npages);
+	} else {
+		memcpy(dst, src, sz);
+	}
+}
+
 /*
  * This routine does not change the underlying encryption setting of the
  * page(s) that map this memory. It assumes that eventually the memory is
@@ -98,8 +123,8 @@ static void __init __sme_early_enc_dec(resource_size_t paddr,
 		 * Use a temporary buffer, of cache-line multiple size, to
 		 * avoid data corruption as documented in the APM.
 		 */
-		memcpy(sme_early_buffer, src, len);
-		memcpy(dst, sme_early_buffer, len);
+		snp_memcpy(sme_early_buffer, src, len, paddr, enc);
+		snp_memcpy(dst, sme_early_buffer, len, paddr, !enc);
 
 		early_memunmap(dst, len);
 		early_memunmap(src, len);
@@ -279,9 +304,23 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 	else
 		sme_early_decrypt(pa, size);
 
+	/*
+	 * If page is getting mapped decrypted in the page table, then the page state
+	 * change in the RMP table must happen before the page table updates.
+	 */
+	if (!enc)
+		early_snp_set_memory_shared((unsigned long)__va(pa), pa, 1);
+
 	/* Change the page encryption mask. */
 	new_pte = pfn_pte(pfn, new_prot);
 	set_pte_atomic(kpte, new_pte);
+
+	/*
+	 * If page is set encrypted in the page table, then update the RMP table to
+	 * add this page as private.
+	 */
+	if (enc)
+		early_snp_set_memory_private((unsigned long)__va(pa), pa, 1);
 }
 
 static int __init early_set_memory_enc_dec(unsigned long vaddr,
-- 
2.17.1

