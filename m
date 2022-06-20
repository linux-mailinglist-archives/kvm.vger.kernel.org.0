Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD25552780
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345347AbiFTXEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346437AbiFTXDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:03:13 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0A326A;
        Mon, 20 Jun 2022 16:03:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UF/O2LdY1y0sM+lmNG1u8bI1Jz3TFtgdpd9IEc4qbUsFsBt6/K8GwoUc1/BDByJ6J89RyPW7FGg8Yd9iJfVKLpVWmqy3BdNjpj1KZciabadyCIjpdLxf71OPh4Rd+2opOxKfyKZhGI7OcCYFtet5KoS/WbM4dASGWJ5Ffbp2LaGlJb4tjTgpCtZSLkj3dUXC2dQKRUKsS4sRG39zMAU58Jh3ua1SXqS9JopOq+f1cokMy/sgeE5NmWuGXiq9AGd6sY60Nk/YteZU2hSzMasU1ZwwgndYDwxWFqlY+grjFfzLbFKk2KPrldELHmYN2RjQKkv4l4uDDreltPXHtpaZNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYv/Dd9ylbR7sB6pYeGtnenzQgpHeT/327OIouQsHEY=;
 b=FNhwY9vblG4ZjGi6U4zRRFURBaMmfJqxjR5/R4DQWgq9RAzw2Z5AB0U7z5x/h+5M+jrzatqq0qzdbZAAXJvCNv3aoxS6Vh+zC5QPz/nRvpFgMq1Rh1u9Ua8PaCqi6I8pA3kgFbC2VP4P9nYwUqwW15P/eaOuv6kGPeVsSwU9jFYdQq7LRm1T9FitVD4OwEH1tCbmE6062lalcL6Izm4mflwqELoTChWmLMT5B5mnAI+tVE/h0Q6hjAObHkBp3g/6PvEMqeSTLKE31vv6GGSUzOUOU75vuHzPiZ4vyD8Kfb49hQmglEw8oqV3iJ7VenjOXygfiJEQxLQgrYEwrqTPwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYv/Dd9ylbR7sB6pYeGtnenzQgpHeT/327OIouQsHEY=;
 b=NA1VwggxMpWnh2pLMXXDHS6gdJUIyih6q44Nt9E5kLKMUPsXtVj219SslAmFN/73Euc85r54F7Zpv0yDO5ciC6bVJYczUFLg5eLMZ8V1Amx7cbrsPdm+8m5T0dxXrplzjeCWP0pjQtIES7JSupjoYUULin+YcMgqbNevb8QuWNk=
Received: from CP3P284CA0012.BRAP284.PROD.OUTLOOK.COM (2603:10d6:103:6c::17)
 by BL1PR12MB5334.namprd12.prod.outlook.com (2603:10b6:208:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 23:03:09 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10d6:103:6c:cafe::41) by CP3P284CA0012.outlook.office365.com
 (2603:10d6:103:6c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:03:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:03:06 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:03:01 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
Date:   Mon, 20 Jun 2022 23:02:52 +0000
Message-ID: <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e8063cf-dcb5-484c-dbce-08da53110961
X-MS-TrafficTypeDiagnostic: BL1PR12MB5334:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5334EAF5672FD6E5F79668F28EB09@BL1PR12MB5334.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ALXOuh581tFfbGNuqFc0kMGymRd1AgkPdGkvaHQjXhBxZeQZnLmN8EUUVvtlYHWRDnk4IYMpXg5YKdY1QA28E/mb5oa6YqQifSkPRhjYBeS7doNIS6XSUddIwK33Ef7Agfo2QKT7YFGVPj1dIxKTNFaFReMR7H8SfmRAule8qLmFWUzf8NRDNeTrHcnJ28FX4OI9gCdifCyGsddk+i60JgdOynCdlVplRhS60jGd+evjU/M+/YIKy+yYG9vqEW0Ezqbmu4XFXoJsD8aS2Wuap0wAh7uqI8NwbTL7otmhDN9iDl0iv0qTKB4YrM0DkeBIhMtIIW+GDBKDLHbMlb+keWiA/O8+lI4rdI2vioAPpzeBKk1bXQ5FGDcvse7B7ij/AQuT0s+QR0Deq8mrmMscD2s0QojboBOeKpLMXLzEr2UXyeDk5LneLcqDGypaSu9emqyADnzTGP4JcXNY3vp4DsRc9+7NIjVCPtukeqr/oPHKKbT9Cyo8iFTJxvB2w/w2gerGsXJBoA7hT1THZzlI3GUSjFKsGqcsGY0X3/R6CJUDTARRVInRM7AZg3W+XzZSutwGpZo4pEtdNweewiXcYFrL9JGPvoV4apO9sQYodRiqLXJmcNz3MGM/ZUtdD2R5Dqxf09eU0Jc99pcc0p57bf1aiw1LPXhzaEue8YaQ0q+vnPwLXGtX9Se5hsonSVG95QlEs7ouh3UBRe5vENd9LCGPokkHRLjWfJUzmfz8Qb8tEFxuBE4xHjx8okvdGiNeDZJdVIwLLgv90rQAlOBHBQp3IZAZmeZvh5hFtSpKJcc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(39860400002)(136003)(46966006)(40470700004)(36840700001)(8936002)(70206006)(7406005)(70586007)(8676002)(5660300002)(316002)(54906003)(2906002)(478600001)(4326008)(36860700001)(110136005)(7416002)(40480700001)(82310400005)(36756003)(7696005)(6666004)(40460700003)(26005)(356005)(86362001)(336012)(81166007)(83380400001)(16526019)(47076005)(82740400003)(426003)(41300700001)(2616005)(186003)(36900700001)(2101003)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:03:06.2366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8063cf-dcb5-484c-dbce-08da53110961
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5334
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
hypervisor will use the instruction to add pages to the RMP table. See
APM3 for details on the instruction operations.

The PSMASH instruction expands a 2MB RMP entry into a corresponding set of
contiguous 4KB-Page RMP entries. The hypervisor will use this instruction
to adjust the RMP entry without invalidating the previous RMP entry.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev.h | 11 ++++++
 arch/x86/kernel/sev.c      | 72 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index cb16f0e5b585..6ab872311544 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -85,7 +85,9 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
+#define RMP_PG_SIZE_2M			1
 #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
 
 /*
  * The RMP entry format is not architectural. The format is defined in PPR
@@ -126,6 +128,15 @@ struct snp_guest_platform_data {
 	u64 secrets_gpa;
 };
 
+struct rmpupdate {
+	u64 gpa;
+	u8 assigned;
+	u8 pagesize;
+	u8 immutable;
+	u8 rsvd;
+	u32 asid;
+} __packed;
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern struct static_key_false sev_es_enable_key;
 extern void __sev_es_ist_enter(struct pt_regs *regs);
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 59e7ec6b0326..f6c64a722e94 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2429,3 +2429,75 @@ int snp_lookup_rmpentry(u64 pfn, int *level)
 	return !!rmpentry_assigned(e);
 }
 EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
+
+int psmash(u64 pfn)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	int ret;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+	/* Binutils version 2.36 supports the PSMASH mnemonic. */
+	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
+		      : "=a"(ret)
+		      : "a"(paddr)
+		      : "memory", "cc");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(psmash);
+
+static int rmpupdate(u64 pfn, struct rmpupdate *val)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	int ret;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
+	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
+		     : "=a"(ret)
+		     : "a"(paddr), "c"((unsigned long)val)
+		     : "memory", "cc");
+	return ret;
+}
+
+int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
+{
+	struct rmpupdate val;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	memset(&val, 0, sizeof(val));
+	val.assigned = 1;
+	val.asid = asid;
+	val.immutable = immutable;
+	val.gpa = gpa;
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+
+	return rmpupdate(pfn, &val);
+}
+EXPORT_SYMBOL_GPL(rmp_make_private);
+
+int rmp_make_shared(u64 pfn, enum pg_level level)
+{
+	struct rmpupdate val;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	memset(&val, 0, sizeof(val));
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+
+	return rmpupdate(pfn, &val);
+}
+EXPORT_SYMBOL_GPL(rmp_make_shared);
-- 
2.25.1

