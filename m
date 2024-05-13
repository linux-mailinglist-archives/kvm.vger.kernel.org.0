Return-Path: <kvm+bounces-17343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A017E8C45FD
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 19:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0BC0BB23382
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 17:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FA3522339;
	Mon, 13 May 2024 17:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RktCxG5I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F322B37147;
	Mon, 13 May 2024 17:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715621295; cv=fail; b=mYDjwY0fMsNrc44PSh1Flcc7+UlZ13q7OPGVV5nlWedmSr5+VnncXlUAFuBH2hf8ALFuWjUgoT8hdLc5db8uB7FFmquOataEXGbQsj8lhwmp2BTCj+/tq/wTlfHqk2gvBb8d2uxYZYMf15N6GJ2ZUOn5iNsFVJzJOvHwnN1NxNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715621295; c=relaxed/simple;
	bh=X2TyUZBpKE4CdsOK9sDAFR+FzRu+NGB2oRo1B2XkNA8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Mtiw9dsqbKNBTWjQgEmh7laZRbqhdZKk8FQWvlfdtC9icB1ZyroLL3oJnC2i9RNFhBo16UeiL4UoHa+TImbRTctT05tqvRRrDaCQXltXQ4y7bH0aYTJ+g49dZbpm91b7JNldXAkoni2xopPvW/prBKywOM6dvzdHTMlg2IFXRXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RktCxG5I; arc=fail smtp.client-ip=40.107.244.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bP5v+9+F4H92hHZUBO+ExCoDNgR5PokGZ8WhMD0GAFSU7+M0fAxpo9XiXn32x7x3mtT++8wq5YiAnjHV744n9Iv1+qCpNpTuM7sd/c23ei+fFOOLsS6qcYiIEKv4UP9o6EJV7CnWPS+rT0WUzZ1h7gwtgwFY7feD1FbeItxIPTq9WLmrOdRoLGjynglbapLXsGrkz1Yd3Nk10kG5wahSrUxu4SxyokDkCsEqITlVmJFBM70KFt7fstlU9rH4kjOQXUgiBHulW6cj7fnu4sTqW45IR/dhsq52jeHv/8OnNXPSFbQZL9L0ylwiQCRgMcmo+JSEEYjx4qWI5ZivJvrK5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lKwFwiQMV+7KnOetMR3uIee8u0G7vmNTmBgib6N/LQ=;
 b=iUgLyO5OqIC7UbHdEdVWi45G+fIEIMXIdDfUC3GDK/8fQQ9TagSdV/rOxzP5pXaM8OIzbGzlZgnAhZeVUpWt5FOTAH/G9mxhYB+TrL0Y4s6UkkrD3F3uOz49Hei2Zewcuh5ZZUal5HBfJeiMu8jvLH2gdgfBb0lqQVqalDhpKvO5KN6+90Xc1jFnnpgcr+dukelIj5vVLWV67df+UhPWQfmfGO0o238URZZWCGGt5qSP8g6psIlj2jvKYcwTrbNd5iku2H62FL9ktXsgi4OyULWfVMuvJf4E5tGXKF1wTDHj/dO0bO9uFrdD2JdOoi7L2KZ6PyzPZDew3X1iBJcchQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lKwFwiQMV+7KnOetMR3uIee8u0G7vmNTmBgib6N/LQ=;
 b=RktCxG5IbU22lg64dijKjgm9U+jbBotYx9cijI2exUvCvD0Wf0PsoPqs+0V0JPC0Yboq2jQMg3q5avKx7UsLrfMzVAlW3JtWQuEbLpxcTtUksxc6xpff/0RQovptjYgAb4r3k6vwJEyRl/lHf7znU7b2pgIt8IhONLQufOWMESA=
Received: from DM6PR01CA0021.prod.exchangelabs.com (2603:10b6:5:296::26) by
 SN7PR12MB7882.namprd12.prod.outlook.com (2603:10b6:806:348::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 17:28:12 +0000
Received: from DS1PEPF00017090.namprd03.prod.outlook.com (2603:10b6:5:296::4)
 by DM6PR01CA0021.outlook.office365.com (2603:10b6:5:296::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.55 via Frontend Transport; Mon, 13 May 2024 17:28:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017090.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 17:28:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 13 May
 2024 12:28:10 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-coco@lists.linux.dev>, Sean Christopherson <seanjc@google.com>, Nathan
 Chancellor <nathan@kernel.org>
Subject: [PATCH] KVM: SEV: Fix uninitialized firmware error code
Date: Mon, 13 May 2024 12:27:04 -0500
Message-ID: <20240513172704.718533-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017090:EE_|SN7PR12MB7882:EE_
X-MS-Office365-Filtering-Correlation-Id: 575740f7-1b87-4731-3994-08dc73721023
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|82310400017|36860700004|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A1O9bZZJK6zrpG6zNOwEN244jZ6U8FmC5cQhrYGSXTZLeXqft4MgRzseZ+D9?=
 =?us-ascii?Q?zwZUhYJ4rUxB8xsnDmnGj6Qd1h+2Tw2zYzN9ICAhJCvbLgRsycwaQoQAnZpT?=
 =?us-ascii?Q?25ZlVFZ2E6AGL6Dhk7TmUZVSITAbRl1nO+RZL6Xv+6uLWlnED+oP+enK+WmD?=
 =?us-ascii?Q?Tapeg3jaMNf2s5Jpx1WSyRslMhmlmtCj32XceyHTwbXwIJiD1lzlzCuf/Zsd?=
 =?us-ascii?Q?scrZm+54k7YKXloLKJ/6DSBmTKKkdYzzg7AMbCfi+WwGWpfoWBub7voelnUv?=
 =?us-ascii?Q?TGe7NYqEn2/rBgk47oT+meUlKHrfhRb7sohxlVXlB3QU8mkUCTlwtanCbHdj?=
 =?us-ascii?Q?DcnLu+3cpShu2/zNcsNpIJTxskJV5vGcspf1EQPJsw/trixVgZx7TMd71wNl?=
 =?us-ascii?Q?TM+Qhd9rzfj8dCx1NVz85F9mmSrkzZrKqPfFTuTXtVLFiE5H6J/B72eNWq4f?=
 =?us-ascii?Q?GWgo3eRw9vtrUqGhBh01hGGRib9PHOovT/jB6NW7G57E2MSWXTGwvZfSc5iE?=
 =?us-ascii?Q?lgzSlalm+u8nv90hKKm0saEzb0ALQhQgqh/17k3fLWxsTmfD6tivGncbkdYj?=
 =?us-ascii?Q?RvM6Z5NaOfNOPI/fs/OTaUluxTz3b+9Zb/+3hsQRDR8ypZewJoEEYiLOOLjP?=
 =?us-ascii?Q?RQQIBAOS0RyyAwlp410yN7nwdX5eqbRWIiOC3MSRRXoAwCe9K2eVXKAKE2ng?=
 =?us-ascii?Q?eIeOipqQPo9k21T4oW1xjS2tgf+erYgDLTcNFGLZYnj+AnM6oAiDQUCmdFZa?=
 =?us-ascii?Q?zye3NKx75bqhXqCkR1SflzZMsy4KqXeGe9G2jeYoZ0ybjU1DWsOgCdBujumu?=
 =?us-ascii?Q?dBq/i08lKh1Yxx/29LUYl0bshCnwO0DjxFXuBZeOmN0PRuZemYFoX8RFA7/H?=
 =?us-ascii?Q?JymQll9iSy3J8grd01WysMNxXilUs+JkSoGKBTefX1rK+VtucxKTHFKbSBNX?=
 =?us-ascii?Q?qYEQJ5ckoHS9ue/3a61X31mrpYfHhJQJaLG3nTOpwNi9WdbPC9S4PKvZaHKe?=
 =?us-ascii?Q?Ccf0HJCBUgC6/4VYgsbwvm7AuuKz27zvt3dTwKmuuy/wX/+jUgX6ouANzNRc?=
 =?us-ascii?Q?Pyk/TG0IeYrcBXuTrI0sxS4+6dq3eZeS3osMdEN57GzvTtWpdxecJjJJQ2OD?=
 =?us-ascii?Q?iSVvtguYsL9rUSo+Jl5EYzSwDzYlWxqJwaqugPHFpI8Co3KdV/vnzpopbktz?=
 =?us-ascii?Q?p3A/rf48tpCoE212oovSQIeuOshgbJ2Dye4XEWEFUJLhuI0DFPiSiWT45b/5?=
 =?us-ascii?Q?Tn22UfGPHbqSytnSPsMHeyAnfFJb68mYkR+6nFAzxo043k1nFxFlecQsv23V?=
 =?us-ascii?Q?CKY0SIkAFF+hBkQR319M0tXF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400017)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 17:28:11.3040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 575740f7-1b87-4731-3994-08dc73721023
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017090.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7882

The current code triggers a clang warning due to passing back an
uninitialized firmware return code in cases where an attestation request
is aborted before getting sent to userspace. Since firmware has not been
involved at this point the appropriate value is 0.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/kvm/20240513151920.GA3061950@thelio-3990X/
Fixes: 32fde9e18b3f ("KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event")
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 57c2c8025547..59c0d89a4d52 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4048,7 +4048,6 @@ static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
 	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long data_npages;
-	sev_ret_code fw_err;
 	gpa_t data_gpa;
 
 	if (!sev_snp_guest(vcpu->kvm))
@@ -4075,7 +4074,7 @@ static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
 	return 0; /* forward request to userspace */
 
 abort_request:
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, 0));
 	return 1; /* resume guest */
 }
 
-- 
2.25.1


