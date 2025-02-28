Return-Path: <kvm+bounces-39677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F891A49488
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:15:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E2AB170BC5
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4AD02566E2;
	Fri, 28 Feb 2025 09:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OehtII8z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918F6253B57;
	Fri, 28 Feb 2025 09:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740734102; cv=fail; b=ravnccpAQVkbjlt13FJyYSpzHwsSlWuAwG/mjWbiIeBMOaShWhKJ4+h6njvM3gL5c0sSuIm7Dr56/v1RY8u3jk3++yHxv2v3MIWye5w9PRg3wvrZ8Uz0/Dausu5CD94nPYytpfuYvJRu+rwaxXb4qFWxPyf/syEBNYkRlbx22T8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740734102; c=relaxed/simple;
	bh=3REV2kayRnUaGmkwulLIAV9kE4axXxV1VL0SIrFMV5M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uBh1ukuVaCi1+Cg4q5paoL62QiIFE7bhl09KLNh7g5H9UfpeYEVt0TQSRWgORj6YL5+22XFhhXDKbsPNgqPW1kYh+CKEkYqurlDJSn4OzPdlUV7oxW0jO6iFO6HnGJfKCUpjcqOBZJtWOEQvU/OI4Tt35ZvRnp3cENX/YeZ1lgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OehtII8z; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QsnVOdmV3nqOg2ZgWgY4Ytdq/D/0Mvy/mGgAPlD3TNByJiPp1xrpvgZkifDwvUGlpjAJq1Wo2h7S2asji5U/SobBauNKqXgGPznCq6weVEDLG9FFP50q79FNzjp0LKmmKl6J1iBRn3xR0aNilCrRyqjArdw4TfDs+ENHHuM97412c9L3o/fDaFi6Ykj1c4usY+OFRGCu6Kzz58PKcUXI1qqD1p0PvZtnUKA6xAOBXpZpaNBc9rOwlddEQ7UsrQn0h3+Ee9E6NYERGNlDe5Vzu5BLGICRksdhuBcVRqQhsWo9KN1mY/100pu9Y6XjW45hTJbXiiY2WwtOSiN8z44/Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyBNbG2XSWw6wm5YloiqxAMiurt4t4P/KO7IIvhebds=;
 b=PQKt8tRyAhFfgWSBK/v4PRbC5ma8n1XTOll3wvA+25WpnhcKSqMCFvJcu/pP/ABRJHfP+jUotV1z7B46u3A/mm1EV+mOo1gVKWFMuv7mtRSnv8Eotp/w1XznNR2RhWf2T54gMhVdcYhDOAmGKv681cAjPie5WeFnRPvgxpm96SQZ4ZMOpedyvQEN8HsJVFUoJLqihG/AShQ9sYljZpk7rJJJf9D+mMKxkqfWXZ2v1Fl8Rnet7Iojc85oF94DCJiBQyCbbYYUV/qQnjeGgNCJ7lifD1nUQaOkz3+JTYM8GrHuwsOikQ1wyAMVGh3cJXEjfOuQyv1bCQiCQt2owsu7oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyBNbG2XSWw6wm5YloiqxAMiurt4t4P/KO7IIvhebds=;
 b=OehtII8zKYdb3bXpTuPa1Z2GroBCb6gETfQVyVviCjJ8PhAtpQpr7veqIXZmgDHTx50OysA8F3/GpdKUCNexigVzLBF3ODd9zJ5S8B2IZZjQqasqDR4SQjbgZW403BZLZppXGUByNEUl9x5+EMtoYFIPoST/2Gc+q3ojeXi/vbM=
Received: from BN8PR16CA0006.namprd16.prod.outlook.com (2603:10b6:408:4c::19)
 by MN0PR12MB6270.namprd12.prod.outlook.com (2603:10b6:208:3c2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.24; Fri, 28 Feb
 2025 09:14:57 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:4c:cafe::e) by BN8PR16CA0006.outlook.office365.com
 (2603:10b6:408:4c::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.21 via Frontend Transport; Fri,
 28 Feb 2025 09:14:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:14:57 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:13:14 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 12/19] KVM: SVM/SEV: Secure AVIC: Set VGIF in VMSA area
Date: Fri, 28 Feb 2025 14:21:08 +0530
Message-ID: <20250228085115.105648-13-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|MN0PR12MB6270:EE_
X-MS-Office365-Filtering-Correlation-Id: ea734084-93a8-4e32-c425-08dd57d85f0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5sED9Xx+FQfcll7bKSOhVECSvMi2s2XzFvAyB95Rt15iZmpJg/sL8bCAk6/Z?=
 =?us-ascii?Q?O+EgJeU9UaSD9/pPg1CbAx53JgkMmiIkxGQkef+wmZSv1s71C5Gvoe5Nz83C?=
 =?us-ascii?Q?e6iSumzhvwt9udiTqR7H5AfLavBtZnqS64ZiFIdvmFDdxudQGqOdXwIi9Q0x?=
 =?us-ascii?Q?NHr2KjT9daZ9BNEInDW4n6mKzuPhpHjl4PARg5SLvkAB5MMeWQnn/jTFC5G0?=
 =?us-ascii?Q?fauAeU7oGvYLQp7Ig+fD7lANDuhEE3OFkgWEC7mXJG8mlKklaMlCf58yFppm?=
 =?us-ascii?Q?ABt4GHiKIeaiyam5iUM1uNBS/q3+KzDxUFjC318SYatYtLPlXXKJEO8+nLGV?=
 =?us-ascii?Q?WgD7mveXDMA1n7GURm1sT9edMTY0hfo/eex6hbwMGrALypGswpJCTCTrME6e?=
 =?us-ascii?Q?HxMsCU/t6oiz6TuVTPp3u6dZBR/4Tc2wYV2a+u0H/P/BfuTEMoRHmE3tb0TM?=
 =?us-ascii?Q?BiboPXV/3fZuiY8uXfjHvNaMcmOzgfpWdBPzyvXNBAXf6ToT9MUU8f+0LHvG?=
 =?us-ascii?Q?MhceFXhJwAqgN29Tk2fgEehlPwFD5whM9Zl1SczXnF/UzSGP6xZuJuRr2wRC?=
 =?us-ascii?Q?nKFGvkl94PcR8332+jDIsu8xT/iVkEJpFufG0Q9a1EWLbXv/UpEFE5KQWKhv?=
 =?us-ascii?Q?MdrHv0q8JC/x92bw8tYFI3zqHBvo4brDICetMT9A+Qv7U1fqxtxcLfgbJKuq?=
 =?us-ascii?Q?zarM5G3/saiwJIinI+QAF6pqwl2+NXLOYgtf6nk+kBx3tnPg031qPW3K2CZp?=
 =?us-ascii?Q?OPEEW3xfNuS/xBgEZo4Wb6kaSBgjyvr8bFZlY0fe7qWFHS+GFXQFf54Ff4w1?=
 =?us-ascii?Q?z0RO8HsH4HG+BL9m+68oRF5ljDB8QB1mwPKzL/nYlKbcNFvdiJoyWrOptaXG?=
 =?us-ascii?Q?131Z5fYomygV1ppoSldryNj3/K6MLsi75zKxhVXf3D0R4BKuTmbVcC+q9bra?=
 =?us-ascii?Q?A45PnuVzYSpolkopycs/Ms7QBBkzq/tJf93g40rokBrxd6SBegjZmgpEzQn1?=
 =?us-ascii?Q?MqJLaeXH5ZVBuGwlxSA/5SrcTddAS2lX4Rg1T5GgmhO3Bof0FFkLAitOgMyA?=
 =?us-ascii?Q?u1nQhpkjPEvcMiYlgesGEj7DWhadbSWzulXjCIZiBpCXKTInZw+23a95PAPx?=
 =?us-ascii?Q?R5D9PvozNCvGtolbcCAYW7A43GMp1JyP1NiwG05nhfuNDMuVrerA99I+JFw4?=
 =?us-ascii?Q?sH3PoQBAgSCQRgBBp6Hty+H//z3zHaEo3rzZOOez5OUA9qIWSLChvKgzK+5s?=
 =?us-ascii?Q?8DRTloBcTDpoavMhaFf5+svIxPCkjU529wgCxwbmUakTOKwrIYfPzUfSfHlP?=
 =?us-ascii?Q?+/MRehfyJKt4rLjDkjL3MKOdCdRyxJdCeek6jEoavLAEh81feTIuArUslqgx?=
 =?us-ascii?Q?2GqPIM+GgCEewf7EQkLFG56bz6/G3EVlyX4eJH0dVG16LF1EQVxLotl4dgZ2?=
 =?us-ascii?Q?szs6K+GtCFPqOFPfgJ9dltQ73MqHzaZcwAvZPNYm29HmjCrdaEjMDV3tKXIH?=
 =?us-ascii?Q?iERWUT9cVimiXYw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:14:57.5209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea734084-93a8-4e32-c425-08dd57d85f0e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6270

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires VGIF in VMSA to be set in order for interrupts to
be delivered to the guest. Usually for enabling GIF, VGIF field (bit 9
of VINTR_CTRL in VMCB) is set. However Secure AVIC ignores the VGIF
field in VMCB and requires VGIF field in VINTR_CTRL of VMSA to be set.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5106afc40cc8..07a8a0c09382 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -854,6 +854,8 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->dr6  = svm->vcpu.arch.dr6;
 
 	save->sev_features = sev->vmsa_features;
+	if (sev_savic_active(vcpu->kvm))
+		save->vintr_ctrl |= V_GIF_MASK;
 
 	/*
 	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
-- 
2.34.1


