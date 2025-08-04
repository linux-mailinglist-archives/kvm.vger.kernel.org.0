Return-Path: <kvm+bounces-53887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F22BB19E86
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 11:10:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E4FA18868BA
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 09:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1F5245038;
	Mon,  4 Aug 2025 09:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZgkCDn7V"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2040.outbound.protection.outlook.com [40.107.96.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF912244668
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 09:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754298625; cv=fail; b=m9x/IJITK9kfYUOyulUEYNH1QJXyjc2kLmndqQEELD5mYdnBue4TJ89hkpLYnTAHQfOshVwTfD/dqlcgTbghJfxEmsqzXLeOyJW1crJc4NIx0Mf75OHcb9i5I6iSFyWMYK1Bvl4+1U8qBK2TEZfzGFK5eFoDXyuEX7ggupfYiMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754298625; c=relaxed/simple;
	bh=XDs6iENd+PGjq8sE4ItHvlLaCoefQg0FUDTARZ/TGzY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m4PL844t2oRDfxoSZAtu/I38a1nYs0Zb9nsUDbuexNLX5vDb5wJfNKYYdOra0raVFj5RI9DmF6n4yyrzf816aIr693kI2U0eAuArblre3j1Tp+THRwJnmCuYWC1fitWd8VCMHtFO0WERipvOf/o81mFTPeeh1jK1pDdduhYb5Qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZgkCDn7V; arc=fail smtp.client-ip=40.107.96.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ozoDFXfN4wv4JgDMbNveO/JxqMzTuqIXoN0dJ0C1+ODJuUn5YTYNBu4Fuo4W5pVTtnDxhcalXx6kNBmTFeRSD72jwUU4tgfW89QmopdceAtb6IqcfV+ZcfKh1kQaOR69/LM4RwXpOkAsT5EBakOiTg90fJ+/KQTWE5SM6nPei5HyCJQHo5Xbh3SQA123Qz5D7ADuKiPXtl6TMSv5+2XIM0Il1EL3msNnpeynulZZpAINBIAJy/6kLzCfhxnMog7zQJ9iDbTY2+CSUnttYUB7T6KqOShPAphcF2h/IPnuFevVqP7O2giJdYWKlzFv0DgLAuYY3pL6u7yS9wDZqV9sbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9Jlpa0DvRFRyIv+Ypsq72jx5WKR+BWg+xKo7fg4be4=;
 b=tG5IvjGWc8tdXiZKSKENPs/FwXYhTTMnTPXaEd+S7/aF29TySkq/ZHnML5iUYyRKiPZjXIgzyi5VbSq3ldW3EJDHFKTkSJkDq88RXgKH4TrNbz4arT5cZCk0qEYdT1Qlmq4ou+DtwFaIxLh8eK8UDeYcmteehpW4cDRr5QPzTlly8SqYnKgkzadjKs/h96Wl+dcn8NQ3o7Bk61UvCK54HDMf0cq+/Qzl4hIaVwqN4nQWEOWPzEt8QpaEFsGSVi0ZcU8SCERLYr5rUtzI+BheAomAGZNg+ZTxFU2zTII2OzH+yW7SdDeF+cV2eZwEr803aLw3I1wR/4lM07IVEw3Waw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9Jlpa0DvRFRyIv+Ypsq72jx5WKR+BWg+xKo7fg4be4=;
 b=ZgkCDn7Vcr1ThbqeanlDCBvHAXlt3/fBO9Z3NoDJI2+TN+sYbVymKhBhGCMqumackrNUNIIuhVJQliZuXzJcnuXOY0UhS3sTqpJa0Qv86INnvmJFYA3fIcFwAB1cEKxs/SJwoDrYhbCd/EsDbGNAQarlxxGzRU1EqPuWtVA2WIg=
Received: from MW4PR04CA0328.namprd04.prod.outlook.com (2603:10b6:303:82::33)
 by CH3PR12MB9731.namprd12.prod.outlook.com (2603:10b6:610:253::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 09:10:19 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:303:82:cafe::18) by MW4PR04CA0328.outlook.office365.com
 (2603:10b6:303:82::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.20 via Frontend Transport; Mon,
 4 Aug 2025 09:10:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Mon, 4 Aug 2025 09:10:19 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 4 Aug
 2025 04:10:14 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [PATCH v3 2/2] KVM: SEV: Enforce minimum GHCB version requirement for SEV-SNP guests
Date: Mon, 4 Aug 2025 14:39:45 +0530
Message-ID: <20250804090945.267199-3-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250804090945.267199-1-nikunj@amd.com>
References: <20250804090945.267199-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|CH3PR12MB9731:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5d97fa-e85b-4308-f120-08ddd336bc09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yhg39dHmRBaWu3rE+hgbT5xtcNWf4gco2X8wDK3TZNL4SbNpxREgVaJqEAF9?=
 =?us-ascii?Q?y/RFUkR0+0x+qj1Dkm3YkRpK0KkhCnZDPoZkmQeb83VYtpPjOBY1lRzc9LXj?=
 =?us-ascii?Q?4WK3XD4gN5E1SF2almWOP5zq6yJJM2wfb5oRQNGSwYfaf2ZtL8wlrZjECWni?=
 =?us-ascii?Q?ufMlirorjZUVGBlFlAURmLhkZq6wzzXS2ulXisu962bmbti7jGCVe8d5utN2?=
 =?us-ascii?Q?9NiNrLaX0sXxBLX1eJpVW4vJDQfglwW6cy49MA0xpbXrpj6jbZyO6on/jXmO?=
 =?us-ascii?Q?6hLKKo/glVRQXpXvu7DI+Srp4SDW8M2q5bBbQdHUJGzgIeIgXvs2n10g6L0V?=
 =?us-ascii?Q?rH+RrCa+ZwmgmaqBsMzUKnJJIknA7FiBHTgYARCe0RnDCz0VSOZhbE2W6k63?=
 =?us-ascii?Q?lSjOAmUJsblzAgh1ppsilSGc61ucOq6bt4UewT62H7J609d34UC0xmEFJB4u?=
 =?us-ascii?Q?rQuLyx+Z5zd6EY+7ns2Jjr1zix9rQOQebaOyeUyA4IJQzEOQv9Yvk1ShwMxr?=
 =?us-ascii?Q?Sri1+qa2jEUqixx+DTF5KwE55lxv5u7NuddoSiOPXL8au7OFTiK+q2rqNFbx?=
 =?us-ascii?Q?2OdTZOnbd335LxOJtwDm0unIxDDfLySqy3Oy/ZizpOoZiseFqe4Uw2GDfGr9?=
 =?us-ascii?Q?10DqYnIPU1QnOj31DYrw/3Ayh4qwgIX7Zn+72y9EhXV4TIPlQpzt/TFAQz3y?=
 =?us-ascii?Q?cBTp2zaPahxX9QiGiyPoZS5O/Dbtbw372vkIiR41uQhDIWRt8eN/Dg0boYy3?=
 =?us-ascii?Q?OB7r8Dn381/XUIvORSOgM3kGm21HQzdCI7cAaeeWc4Uagec/E7ocFVPMphdd?=
 =?us-ascii?Q?f9aFs+5u52cUO2E0PJLmmHSuw9XheW+IViaRKivixJiD7N1jkbLiTjKtjofC?=
 =?us-ascii?Q?nVzslrdbY4ei2k12SG2zgD/W7h2x20PRKvVftEv4QbmcfI/lOnSs0o3qYxtK?=
 =?us-ascii?Q?VsfrzxEEqdWrN7cqAuk0HRkqZboNxLEvbfeP31L/k/2XVA7BnPRZqFIsYiVc?=
 =?us-ascii?Q?qVOMLOUvkvnk+GXeH77JjL7CEfvkugfXVLyBJBJ6VsRpFWgcy3R92/M8YBPH?=
 =?us-ascii?Q?nuQF5SIQ41HEKImDHlvNSg9q9UOONuq8bCiJzpUzWb+xMoUqlD00KRH9x0gE?=
 =?us-ascii?Q?/61EUFLnbsoNFAqoh/PKgrb37yV9PwMUs4Z8WaR7XDrtqKt36Andp5oSY5sa?=
 =?us-ascii?Q?RlpFteNlEfDhQaEwHW5F1HGSvCRlefnltCJG+B3BkXSM0Pibs0swqrdMZYD8?=
 =?us-ascii?Q?XBTNchMdSToImKI5ZJkDbOMwIau1o93kycdOcNQWNKrvg/zk3EGRh77I0o85?=
 =?us-ascii?Q?ZyXIjnYTR9yftwp36KBEin7sJJ7F/bnDkT/DuGU+uf8gLzs0f39dPbvRw6Xq?=
 =?us-ascii?Q?X3oiUAis7DYPFebQ0/aL34v/z4LYUbXvvaMoMVE24Xs4q97ygKOD8hlq8+xu?=
 =?us-ascii?Q?fbNGLC9zPbej1Cub5tID71b1SmiMkNZJQAkH7HDW+EG5VhimaxSDinDkYzUW?=
 =?us-ascii?Q?xzK0UsC+VCXyBZ8kxJtk6QnwkMAxJLqB7HV3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 09:10:19.2059
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5d97fa-e85b-4308-f120-08ddd336bc09
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9731

Require a minimum GHCB version of 2 when starting SEV-SNP guests through
KVM_SEV_INIT2. When a VMM attempts to start an SEV-SNP guest with an
incompatible GHCB version (less than 2), reject the request early rather
than allowing the guest kernel to start with an incorrect protocol version
and fail later with GHCB_SNP_UNSUPPORTED guest termination.

Hypervisor logs the guest termination with GHCB_SNP_UNSUPPORTED error code:

kvm_amd: SEV-ES guest requested termination: 0x0:0x2

SNP guest fails with the below error message:

KVM: unknown exit reason 24
EAX=00000000 EBX=00000000 ECX=00000000 EDX=00a00f11
ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 00000000 0000ffff 00009300
CS =f000 ffff0000 0000ffff 00009b00
SS =0000 00000000 0000ffff 00009300
DS =0000 00000000 0000ffff 00009300
FS =0000 00000000 0000ffff 00009300
GS =0000 00000000 0000ffff 00009300
LDT=0000 00000000 0000ffff 00008200
TR =0000 00000000 0000ffff 00008b00
GDT=     00000000 0000ffff
IDT=     00000000 0000ffff
CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000000

Fixes: 4af663c2f64a ("KVM: SEV: Allow per-guest configuration of GHCB protocol version")
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

---

Changes since
v2:
* Add new patch for removing GHCB_VERSION_DEFAULT

v1:
* Add failure logs in the commit and drop @stable tag (Sean)
---
 arch/x86/kvm/svm/sev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 212f790eedd4..e88dce598785 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -405,6 +405,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_platform_init_args init_args = {0};
 	bool es_active = vm_type != KVM_X86_SEV_VM;
+	bool snp_active = vm_type == KVM_X86_SNP_VM;
 	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
 	int ret;
 
@@ -428,6 +429,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (es_active && !data->ghcb_version)
 		data->ghcb_version = 2;
 
+	if (snp_active && data->ghcb_version < 2)
+		return -EINVAL;
+
 	if (unlikely(sev->active))
 		return -EINVAL;
 
@@ -436,7 +440,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	sev->vmsa_features = data->vmsa_features;
 	sev->ghcb_version = data->ghcb_version;
 
-	if (vm_type == KVM_X86_SNP_VM)
+	if (snp_active)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
 	ret = sev_asid_new(sev);
@@ -454,7 +458,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	}
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
-	if (vm_type == KVM_X86_SNP_VM) {
+	if (snp_active) {
 		ret = snp_guest_req_init(kvm);
 		if (ret)
 			goto e_free;
-- 
2.43.0


