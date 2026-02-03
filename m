Return-Path: <kvm+bounces-70109-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0GZFH+V2gmm+UwMAu9opvQ
	(envelope-from <kvm+bounces-70109-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:29:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D01BFDF433
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 11C6D3087DF6
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1718936F43E;
	Tue,  3 Feb 2026 22:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pupHBZsF"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011036.outbound.protection.outlook.com [52.101.52.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DC13242D2;
	Tue,  3 Feb 2026 22:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770157475; cv=fail; b=fZ8W2kFhzXD91mN8m/YWoW0lGxB2ARp2P3ucYMADCQ+CuK8ADLfAa1L01s0lEl5wnBOyfZl86DteRNOiET7SxKd1Dtsvk++AfuUK2c3/6fRXzhp1YwYZZK6bS9nQ4iGyVVB5nC2yZZQeuMew5rSCgtxwe3zrgr1YwiZxDRazd9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770157475; c=relaxed/simple;
	bh=feYov+vi8AXecuaLRDxWejw9ZWHaEqJrwfvdlB8ddd4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vB5SvPSJBo+BUwG/M1fsoXZuxDO0jQhxB6Wr/O1KtIh2AiQ8MNPBE/WOcRcuSmmvmnflbDIype17ORHybfpauQqdU9xCmApYQq2jA5Fnpas3sUIj4t5oeCIsQO854WOR4OllyxS+mSLxzZEyY/Jr/LvSQqMUyNQrXSLno+Td1H0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pupHBZsF; arc=fail smtp.client-ip=52.101.52.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xssQnRkXGx9JdcQ24iL5/ZD0SZPY/GHSeipdX0oV+xiuqqF/sG/1GgVIG3aausvHZdOYUPWG7CiuUprB6dreVHTUMuLzDqYHf3sZTmnuiHCHIyldkzwIbCGma/PTZESG9LxAtX5tDHn2F0O0e3Hyy0e9/aGe/R7RMlFLW3TChVyWin6O3wqEqKbILEksWULmmitMY6zsU2Nh5dS/MpSD5FNtbAl8T47Jvx7SexV9mcAfItDikuxY+eYciQhUlk1IltxYZstbVFnUUsHbImNTCI1KjokKpFDMM/Jd2LAld+7FkLmWQlXHnE9r9e5Qcw4qK4kxr45U84Quu01uZNCOCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zn4iva4LGmaSfFnkFbI6mTpHhYHsLRt0KWfyads4ojo=;
 b=YWeoDi8JlfewugRMVGkVw00SQ5ZWQuaEy17+XJ3T7wHkgiomOjSWFfLIcIo7WZ6mhTtitTD7R/RryVkgtrK/0SbFn1iwUBrIiGYAVEjjh1mfz+o7R0QvnvRJxqb/8mEkUMsUjt88tPs1mqEyYa71DMZVrvtYNzqdILy1K80i20fcy6NrPqAXOsSa7A51Ttcgl9j3iDYT9TmDJ75V6w0X6WoIhMFIG27k/j5VyKUaTKLB2A7AwzugEQ3sHRWDBzZrkqRLbcYlnrKhpWFN+0XknXMLeFj3qMgof20MpyqoLqL3tHdkomLELtSU/BGdfwtrs5L9X9mg3IHFEmCOFeG+3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zn4iva4LGmaSfFnkFbI6mTpHhYHsLRt0KWfyads4ojo=;
 b=pupHBZsFwTVcE/QWJIz+VxY81B/5T9fGPMqxijWbHIa5AWkiWGIFhUgWbzv5A8/cJOAxnm+cQugaDHNp51IWRst2x1Faog1wKknOjCVO/UaFOqy+4H6gMSGJ9MuejgrXPd0JnV5ufL9gXOpPXSgs4XlV400FszEW7fTERpDGG2o=
Received: from CH2PR07CA0038.namprd07.prod.outlook.com (2603:10b6:610:5b::12)
 by BY5PR12MB4147.namprd12.prod.outlook.com (2603:10b6:a03:205::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Tue, 3 Feb
 2026 22:24:29 +0000
Received: from DS2PEPF00003447.namprd04.prod.outlook.com
 (2603:10b6:610:5b:cafe::12) by CH2PR07CA0038.outlook.office365.com
 (2603:10b6:610:5b::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.12 via Frontend Transport; Tue,
 3 Feb 2026 22:24:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00003447.mail.protection.outlook.com (10.167.17.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Tue, 3 Feb 2026 22:24:29 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Feb
 2026 16:24:28 -0600
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
Subject: [PATCH v2 1/3] x86/sev: Allow IBPB-on-Entry feature for SNP guests
Date: Tue, 3 Feb 2026 16:24:03 -0600
Message-ID: <20260203222405.4065706-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260203222405.4065706-1-kim.phillips@amd.com>
References: <20260203222405.4065706-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003447:EE_|BY5PR12MB4147:EE_
X-MS-Office365-Filtering-Correlation-Id: c06b1b53-5cd9-44f0-a21c-08de6372ff2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iswPl2NVnDvwNVROp/GFnY9yw6vZ0eCC5RdV6JfO85CuePd3jzp/HVeamgxA?=
 =?us-ascii?Q?vu9sIioB6l/DcuQVrm427/0ocGeFSeXHcDFNkff2K6tErD3KHkCiUJRuVkGH?=
 =?us-ascii?Q?mIkpuRBHJ5HdXW1r4Z2kXsdXH4TQWJu3nW6ElLZYPS5oYFpy+NVDYiFdQJk8?=
 =?us-ascii?Q?R6UG9VIs2LeAek/OLw7AO2/6GtdIIFD2/eago3T9D3h5xF6EXtjzsi/+NN0H?=
 =?us-ascii?Q?hKL+lNtNnK0YPHNXk6UqrieZsEx7MJ5MqgBjLLapjl5n9HBqK5qA88WA8KKk?=
 =?us-ascii?Q?d/QZdPVUWiIc0DPvDIt/2lq/t3N/9tTLyWg6/Tb1kmA8VNHmwqUk/X6qtVM8?=
 =?us-ascii?Q?zMFL/dD74VOhWmayPvYNrg/icGsGTsjiaOYrK08iLLDkySb95ZsQd8wxg+z4?=
 =?us-ascii?Q?n1CUsUxNhEkobwkJR7O2slDIqjE8sLUm+B13JFqBytZIsQW8XaOT3T/83YO2?=
 =?us-ascii?Q?UQPbziWDF0hcn/oTvRqFGh+VAarFDky1+nTTdRsIS+a0d7YfOgAiw0i6+hMF?=
 =?us-ascii?Q?3VinxrDYC7YeIJ/M3m0BV1xS+sRywDivKwKPKIKPAOqpWJRl6PbhNIqtXwwc?=
 =?us-ascii?Q?qptFpCzFwsmapN7IfJvo+9D/0+UaCumia/BJpPT66XNQkYovh1BvL06d2bFc?=
 =?us-ascii?Q?7GSYVShH0cpn+kg9aUvcGINm7/D3ZxPy6Z6WKkPr8PVqOojNqTa9q44vQptI?=
 =?us-ascii?Q?k+bhAcO4GHqcW6SxlZE9vrabg0p6KclsNSswjXch2h0aV162Od6ycuEPo+02?=
 =?us-ascii?Q?R/02xQ21+JKhV6THA3OUYx38lpF/Jeg7pnRiZQjluQUFp499eCidFVRJtIwU?=
 =?us-ascii?Q?NixbRsrWHR4oIj3Uz4xlucCx4FraRk+xjGBVKcUC9PG2/fsY2HBT+526TGZT?=
 =?us-ascii?Q?tJpQWznf7vw7YwCaVFNioVroj7Z4C0R1XDCP9T2tvp1t/R6JE1rjZdj/BQT2?=
 =?us-ascii?Q?ng8D1NTMLMILyPLwpDtE8ui0aNF7OYPAR7bfvztroyT5IsOHUbXln94zGpQ2?=
 =?us-ascii?Q?Q091vo+MNt4ioCUuzWjB9ZTajxYIsk3Y6HRJ78yVsVfMeWkrYi6oR8y98J8+?=
 =?us-ascii?Q?1UF8t2rbDwzpA19RFEp8ds5FwMDXyj0qWVmGkHUT4N1yNa8E/wGEWWbnGYvf?=
 =?us-ascii?Q?zfYQVHGJ2ZYoteXZv0nLbsGg+vWai/N/2EW24IyXX3cPAdnfktDQCkV9jLp4?=
 =?us-ascii?Q?9QG0D660v+xOYaedav18/sv6VB5IUIG2xcrjIp1TOKnWN5AxO2ALIDNWecPO?=
 =?us-ascii?Q?ZUT2DKji8g0qshY0htm78qQ+J08n4pXjErtlNgncuSvxtwkH6yGn+BxCQinL?=
 =?us-ascii?Q?si5aGh6+vaIGxwU3FNMNUb+c+Uvm7RxIthGcQ2LY1QHCkYEpbUWh9tWSj7Pc?=
 =?us-ascii?Q?ah42vK0oe0ywEFrZ9o577FUcEZ36TlTKodJzCvxDwjfMAUdeHOl70zkq/ord?=
 =?us-ascii?Q?eUk6tMpcT1qTCwXgZeW2SEhPrfk4HV0PwNzJZZSuO7jN6K/6SLB+JVntZ6GY?=
 =?us-ascii?Q?SuHMFmQKQi+HTSHsLnt7lKteBRQgAaaY6ub54Kg0jHB6WZQ1KoPO0eB+tgtW?=
 =?us-ascii?Q?wZ+g63kb5qNO5U7BMtiNHv5VJGJPnrvEr1togrl+bQ43l33/tMWnS0RO/mJT?=
 =?us-ascii?Q?9GY/jdZd9bCwJuoCyibBzctCFRj2Ndxthmrx8Fanm+gr1bfPwPdhDZ4dT2iQ?=
 =?us-ascii?Q?6HXtYg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ckhm2vyfg6AJ7Bw9cLjQpukl+CK3HByLbaqdm5/BM9ikfA4eUxfI3Y3ps5rJyILtYDLZapg+3KpsWd1t1Lk7ShzCo53K36c8XzNXK/3RQIk/TB1ZQbnhlUGvyvZa0+5YhgwWfax6MLTIP/fJ1znpyscNQ0OXDfkNBJGE+nE2M82cw/a6qCW/KtVXg+hjRR+mX5PkI2njqFgiicHIQdxE0/uRpY1a70fvKEqo518cj4htHtwAtsdxUl6jUt38ur083RFXrZDjwmNrnSv+QzyQ2v471MgqndLTZP0Z4xeiJai0U9pm69qgeo1Sx8ze0hKgVb57Ur9BhIr53gWBxJTWLea1VwLdEQO0hemuARK2rlLvtubiUST2hthEixXSMm8N1vSOIfLqmQaINtjngtpTGQv7o3/GAy2Z8l8N8Ev0L49BSsXNG0akPHyWqg8sxvSU
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 22:24:29.0973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c06b1b53-5cd9-44f0-a21c-08de6372ff2c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4147
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70109-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:email,amd.com:dkim,amd.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: D01BFDF433
X-Rspamd-Action: no action

The SEV-SNP IBPB-on-Entry feature does not require a guest-side
implementation. The feature was added in Zen5 h/w, after the first
SNP Zen implementation, and thus was not accounted for when the
initial set of SNP features were added to the kernel.

In its abundant precaution, commit 8c29f0165405 ("x86/sev: Add SEV-SNP
guest feature negotiation support") included SEV_STATUS' IBPB-on-Entry
bit as a reserved bit, thereby masking guests from using the feature.

Allow guests to make use of IBPB-on-Entry when supported by the
hypervisor, as the bit is now architecturally defined and safe to
expose.

Fixes: 8c29f0165405 ("x86/sev: Add SEV-SNP guest feature negotiation support")
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Michael Roth <michael.roth@amd.com>
Cc: stable@kernel.org
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
v2:
 - Change title (Nikunj)
 - Add reviews-by (Nikunj, Tom)
 - Change the description to more generally explain what the patch does (Boris)
v1: https://lore.kernel.org/kvm/20260126224205.1442196-2-kim.phillips@amd.com/

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


