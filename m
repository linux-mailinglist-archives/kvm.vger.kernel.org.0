Return-Path: <kvm+bounces-69178-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MBejH+btd2kVmgEAu9opvQ
	(envelope-from <kvm+bounces-69178-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 23:42:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5FDE8E000
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 23:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 474A33006027
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 22:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1367330ACE6;
	Mon, 26 Jan 2026 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hxJPgGTu"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012011.outbound.protection.outlook.com [40.93.195.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67F1301001;
	Mon, 26 Jan 2026 22:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769467361; cv=fail; b=SJMdmNReIoFWG6HPsq/ujt7DFOCOq4UgJz8UqjCF71RugbIfQJOPkbj3N+KzP/KeEWto9mIXWLPGXscFI7JE620+z6L1t1OzIxASXIRC+m71iNp2SALpIt5JAM2lb2DJaU8KBi18WodAtkvVE4OEf12lSDeTaojPJZbL6IhZSy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769467361; c=relaxed/simple;
	bh=WOUtYpmcR1v8dBOQlICRp4zmJR9/6jkcK10PoLhkYv4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BJUn5e8IgJ1LblGiHQy7GHv/ZXoLFrfuLYFO9su+JC7wGzDh5pgmyiGksx8aptTL4AQlPuRqsdKuEl4JTIHJ6mjeWexvlIda0cRXXFOF+LoIDrqPfYq+BL55rthoKWkVMxSzRX2XGTnJ17BKwm3rXobLk25ZVDApSPAYCI+3dLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hxJPgGTu; arc=fail smtp.client-ip=40.93.195.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RW8bQDPmkutLPbHZ1efscD6GKciHnglB2lh0nnqVYc9/4gf1oMDC37XjMFcMg4uPFYq1TBLt/6PRY3IBKoJOAJlF2kOPQqC8u8auRiJ0B/L/d6ZhYdc840zAPSrlPrnzlYss1H/IVWp2ExMe3BV06KxlZNFQ7pyqiM3bajU1X8FSi9ic1iNDDw2uQHKS1vWmawhmhb7FhNM8zc9nKWL8qh+VvCBZBXXrHiPmUJkC54VjWx6jC+u8nJNLeUWLi11vdbFRIpNL+k/wS0JD0qAKRd3Jo0IL6yI2TZPnVYqElITUphiyxfuhIhhCvhyel3gyji5yD0AiD0+UFVaI2+yDSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iu0tAILsn5vJYW6s03PcaWE+4uwPEY5T2Ys2p2hJpsI=;
 b=Nfaxcf7fCX8r5zRJCPsYYogK0cesk68JitD5H70wXXfdrieVotYTDtndYoReuuGqKFYQ3YJnROn6rsnzbPVHIIE/KsQMB0HRqeF36sg+pDOxSreNEaRpbc1vse3JCVacuzklqkhkC5Yay6aznOOb1jjsUVLqAzhwS+Nznr8FfVSzU2NXLkj/bMKCnqTeStioAVT464iS6QW7aKcpKfMRW111V4qA9rYv/bW4mGWIYZ4HG4Nz5p3h2BnzQmDXtnSyMCsd52dG/DNBwK1tBEO2kiYunf4Hx1Wat1I8h3y8cMeu583Unk8khhKmO8LNWZShWteWH6xnHJjDbgT7VYinMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iu0tAILsn5vJYW6s03PcaWE+4uwPEY5T2Ys2p2hJpsI=;
 b=hxJPgGTuemyLQqwwDsMfFTlyeOijEfIG/a9/v+a2flDwmfhjOv0uUqbblcL9JtfBotdbiJLa8yKu+CrXLHKB79qs2CRBkdpv9Yw0O5aTCJ8nhMh8KkQu6Sqa0GVIPYqXPu8+WefoKvUgAN8XpxzV0q9xANiGVOLiLiN6mRmK9dQ=
Received: from BN0PR10CA0009.namprd10.prod.outlook.com (2603:10b6:408:143::6)
 by PH7PR12MB8016.namprd12.prod.outlook.com (2603:10b6:510:26b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Mon, 26 Jan
 2026 22:42:34 +0000
Received: from BN2PEPF00004FC1.namprd04.prod.outlook.com
 (2603:10b6:408:143:cafe::4b) by BN0PR10CA0009.outlook.office365.com
 (2603:10b6:408:143::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Mon,
 26 Jan 2026 22:42:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FC1.mail.protection.outlook.com (10.167.243.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Mon, 26 Jan 2026 22:42:34 +0000
Received: from gaul.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 26 Jan
 2026 16:42:31 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Borislav Petkov <borislav.petkov@amd.com>,
	Borislav Petkov <bp@alien8.de>, Naveen Rao <naveen.rao@amd.com>, David Kaplan
	<david.kaplan@amd.com>, Kim Phillips <kim.phillips@amd.com>,
	<stable@kernel.org>
Subject: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
Date: Mon, 26 Jan 2026 16:42:04 -0600
Message-ID: <20260126224205.1442196-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260126224205.1442196-1-kim.phillips@amd.com>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC1:EE_|PH7PR12MB8016:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f16bdb5-6ecb-4ce5-0fb4-08de5d2c32bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S3wFWKvZXs8NgpmjlQOzorF7/CHfghb7K30ntd6pepqL4jw/4uZ2dwOgyNjS?=
 =?us-ascii?Q?nrSaGkY5b33BuCoieYfHpPcbQONTWzJH7acokcN8QrMmJWF2S7kYaPliWKg1?=
 =?us-ascii?Q?4qbHzAvWk9dCvBuEsdp1x5QwSq7kROBQ6H3PXE7F3QgZ1BvHUK3HDuPKWNA9?=
 =?us-ascii?Q?8S1zC6ZdkLT1zFI+qQGYWLjrqROsXAPW+D581n5BcHsIQ8MjJHSLY1G/mY2P?=
 =?us-ascii?Q?1V31ACfTz5A31XKw0hh7Sov6dMOepTHMHQuoZ9T/cw/YDsPYxL0iGSjO2nqF?=
 =?us-ascii?Q?ceyLiGi8HlVTf7wDbAZThj2/Tu21hi6XXLkqfd+VHnC1IqcdPc0vtHN9nN0e?=
 =?us-ascii?Q?xmd+NcYiGPuTPw9EgoszAg5+sEuxktrx+uXr9lgTiZDsv+K2NgC2m1JH0rLy?=
 =?us-ascii?Q?g8jKaglauIIGOrYcAufF4Q9K0W6vOl4JE+FXgBXkatcL9kzT8GVFwWs4Fxtm?=
 =?us-ascii?Q?QVt8/SYRfrTO2cySbuZCqtWVI/EdSZHCIBnTE4Ay8bBYcmdqi/Q449ZrFJhY?=
 =?us-ascii?Q?m9KmpenCW6ndZ8yMtfxSwsV4SmF93KitD1kZXJQFmWBO8UqfJMFn5CsgQoIN?=
 =?us-ascii?Q?fq8WkbLHSB+gLK/ctXaTVFTOZJS9IWiQ6mHNXoVJgsOHM/GchRZzq7Rtjz+6?=
 =?us-ascii?Q?desJOh7wEON/SnSNd2IVR2vzcaZZ5xgaGYULpV/20wt2cVFPkG17oXCEJH/j?=
 =?us-ascii?Q?U7dmJM4sYoxbrn3C/cvNeWV6M7qSc5JaYxQo3XyeEMDAq6b6CdqOQ+anVreQ?=
 =?us-ascii?Q?pxuTpJeL8f2wFW5bWZhfqutbNXVc58q5aFMnXUvMNdAMy+dGr5gm/CqtmOTV?=
 =?us-ascii?Q?J/L1lXfFMqfRtazeg3nsREneIhIiS6NxRYXIdrCGGyTCV84EyrfUY/CSDGe9?=
 =?us-ascii?Q?9IIFlBP/ub1O5fPlDxcdEg2Gq6rpCIydBThGzBWFeFfbf7IQCX0HNtHiqMXS?=
 =?us-ascii?Q?/Or7Cnpvx+NjyA+5boxOIPWr3zvkSall1Z1LnNyVrBV3FAyckKtEKMkiKVkV?=
 =?us-ascii?Q?tf4DfxIcp20zengShxls44KOhf0jft/ZzlmNb2UoRsafSW22C9kvnAB04VKU?=
 =?us-ascii?Q?cSigu7/DdY4IjiU8bZL1NMRy1DW9QZv+U+SW6SlLxDgiZVllbOeVg5Ei1J2o?=
 =?us-ascii?Q?lgZJF0YpCU4WhkRr54Mcfvk2vhs5hDpQxCrr1YjvSIDtNknJEip1XkCt6kyk?=
 =?us-ascii?Q?co/JMb8oFqVepLjkUHylLGD8NGLFtPvKGYtb2Ey627n1AGLekH4CLTE0o9jq?=
 =?us-ascii?Q?2+qT20x2TwMlwhnHy7rOZcswhvrlZEIm2Gjb2d7o4s3JFhqIpWk+pMAptWOL?=
 =?us-ascii?Q?ddwWevAKwFe5ccPkrYbKjNhj6k+6uElcgBfN7yCcuc71m5kGomxRnbo/3Vge?=
 =?us-ascii?Q?kKZ+bpSlvfOBTSZpnBftIT+k6hckgJI+r6PjNdCx9Y48+EeKuhHzKgvj5h90?=
 =?us-ascii?Q?UYD3GP8MCdzSOG5BLd3jQ+c4AmYEXK8ij5IQmOw87AF3bkLTfifaEg/jaAJ6?=
 =?us-ascii?Q?syN1wdMuYB0AYHKMuJqwQ4aNnzy2sAqARLKL6HbJvLZl1mcIze9D0lSIfihO?=
 =?us-ascii?Q?Jza3wGiSE/avm90NiSy3l+ixpTaZDn6NaRWNH+At2t3B0m6Pp3jPb64YHYM0?=
 =?us-ascii?Q?/hZhxMe1Maxcreprrf0dRi4/UHH366duqrgxWl3IDPEoQB8Avys0MKc3Oxck?=
 =?us-ascii?Q?ukQJzg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 22:42:34.3956
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f16bdb5-6ecb-4ce5-0fb4-08de5d2c32bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8016
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69178-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: A5FDE8E000
X-Rspamd-Action: no action

The SEV-SNP IBPB-on-Entry feature does not require a guest-side
implementation. The feature was added in Zen5 h/w, after the first
SNP Zen implementation, and thus was not accounted for when the
initial set of SNP features were added to the kernel.

In its abundant precaution, commit 8c29f0165405 ("x86/sev: Add SEV-SNP
guest feature negotiation support") included SEV_STATUS' IBPB-on-Entry
bit as a reserved bit, thereby masking guests from using the feature.

Unmask the bit, to allow guests to take advantage of the feature on
hypervisor kernel versions that support it: Amend the SEV_STATUS MSR
SNP_RESERVED_MASK to exclude bit 23 (IbpbOnEntry).

Fixes: 8c29f0165405 ("x86/sev: Add SEV-SNP guest feature negotiation support")
Cc: Nikunj A Dadhania <nikunj@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
CC: Borislav Petkov (AMD) <bp@alien8.de>
CC: Michael Roth <michael.roth@amd.com>
Cc: stable@kernel.org
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/boot/compressed/sev.c   | 1 +
 arch/x86/coco/sev/core.c         | 1 +
 arch/x86/include/asm/msr-index.h | 5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index c8c1464b3a56..2b639703b8dd 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -188,6 +188,7 @@ bool sev_es_check_ghcb_fault(unsigned long address)
 				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
 				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
 				 MSR_AMD64_SNP_SECURE_AVIC |		\
+				 MSR_AMD64_SNP_RESERVED_BITS19_22 |	\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
 #ifdef CONFIG_AMD_SECURE_AVIC
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 9ae3b11754e6..13f608117411 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -122,6 +122,7 @@ static const char * const sev_status_feat_names[] = {
 	[MSR_AMD64_SNP_VMSA_REG_PROT_BIT]	= "VMSARegProt",
 	[MSR_AMD64_SNP_SMT_PROT_BIT]		= "SMTProt",
 	[MSR_AMD64_SNP_SECURE_AVIC_BIT]		= "SecureAVIC",
+	[MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT]	= "IBPBOnEntry",
 };
 
 /*
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4d3566bb1a93..9016a6b00bc7 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -735,7 +735,10 @@
 #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
 #define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
 #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
-#define MSR_AMD64_SNP_RESV_BIT		19
+#define MSR_AMD64_SNP_RESERVED_BITS19_22 GENMASK_ULL(22, 19)
+#define MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT	23
+#define MSR_AMD64_SNP_IBPB_ON_ENTRY	BIT_ULL(MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT)
+#define MSR_AMD64_SNP_RESV_BIT		24
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 #define MSR_AMD64_SAVIC_CONTROL		0xc0010138
 #define MSR_AMD64_SAVIC_EN_BIT		0
-- 
2.43.0


