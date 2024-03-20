Return-Path: <kvm+bounces-12238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11267880DB1
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 632D3B23650
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B262482C4;
	Wed, 20 Mar 2024 08:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Q0krMyYp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED4A481A7
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924471; cv=fail; b=PRDswKC1vqFZjJyetw8+3mI9G/eFiEBCMg0oTbQI7+duIPuIFhETTmhXmOF8nh05XodpOkIJFv/rldJ+9/k9Wj8aVq9B2zwJYmy6TSzPQJB3w1CRe0YDBTTZiNHzM4B0EcjjxFlOVCI4S450hFwmf7w+MwTW+ZjpySLAOGuAaYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924471; c=relaxed/simple;
	bh=ZHcBR89nSQ85C72giZ/VAYp4pgQX4qjUe/ptPw1Tzo0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TkYHKvkfFMTIssIm+xugxFcEM21Vv3s7kvaBw2R3NU3nay79wcWHvrjoJxRueX3xnA4T3rZjMzYqVNwRMXOJe0OzdtXFT8Z5TjOkBtc8QevcvjR6Si0MunH5VvsnNzRzCIOSO8SACHb+GiMZIusEPfLdsGsKYtliiNnnS50C7/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Q0krMyYp; arc=fail smtp.client-ip=40.107.93.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsHyjXN6/Lo33kpj3Zp6kzdUjzsWhMNAiw/+ArgY0fzxkBwKLfPj7rSZJvzHau3+LSg9Dc+t3ST92pL4X/36Eam8HptTqG9ZVBb5s/UycbHGhKJC/k23cDM4ePMkx8FeDhBJGR4eHNAYDa7rRdEuV9TPNN3C9VBnDfHeHyKpMRVCMCRabXYkv1oOiW65QHhE2bnQXXSNmAvVrPSbJ+yYFLdMV+TbPZtjlANSu5OevMvjarvO2WuTswfR9DkOcBh8lla+sw7I1/wZOdAU43n+d4XX2CC0ft3PXa2F4T52OCabKm7iiknCWrX+9dnuv48xb0qt3sHe7ZYcScdQD8nvfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/yKiAMs6y17O5kmKwFQUlz87KwThdrdL0Q1XulVXP24=;
 b=AyqdIrANNpG/aILRp1mTtQNadlJOAiakZmRnfosuoHCx8PvyML9twPLuEJKtm9cxSi1fSy9LIL7oV6aiwVXlEjBLtuYkTZ3Ojm0YBUToBZwaShr1Agao8H+65aYajWrBDlHKz/q2EWKK0yIR8USvleT7nBBNljQY1EKDRDkH/uwmCdDatW8ii9Sxe5j6ve+/QCUiUwzvD1OdBYub9QBSAadL83itx55XBvk3G6XxBxWIcwwxuWc265aKaMo5zrrV4UKFbCHbpJ+DyLYNT9pQrNoUnoa4DaZPyeANG7r2oGC/B+zR8Vfim4hz5MlaCDl5q4J4YyyX3/zr67SnmfNFTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yKiAMs6y17O5kmKwFQUlz87KwThdrdL0Q1XulVXP24=;
 b=Q0krMyYpqhmFR6L8iYUVMgCxYRsHPv1UWYdwXexHJ8GaL45D63Tn4l3rIct86BOPO0vH2MagmDsOqCzezcU0vYR+nPBUzAc1HnEsgiditz0yU4dgQb4gbxWxdTmbA6PauTXX1TTiZJa52SkDScEYnGsWsuS7ZkyVCtNJnRhS2Ks=
Received: from BYAPR08CA0045.namprd08.prod.outlook.com (2603:10b6:a03:117::22)
 by PH7PR12MB6539.namprd12.prod.outlook.com (2603:10b6:510:1f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.22; Wed, 20 Mar
 2024 08:47:47 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:a03:117:cafe::9c) by BYAPR08CA0045.outlook.office365.com
 (2603:10b6:a03:117::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26 via Frontend
 Transport; Wed, 20 Mar 2024 08:47:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:47:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:47:46 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 26/49] i386/sev: Skip machine-init-done notifiers for SNP
Date: Wed, 20 Mar 2024 03:39:22 -0500
Message-ID: <20240320083945.991426-27-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|PH7PR12MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b603f5-16fd-43eb-dc3c-08dc48ba6ab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	b6wCCzyxr8hwsDnAjV1Y5N71P3UWNnP+cnOyTLiJk6S9H4VV5sefrxhTtC2IJ1dv8BFTuKuoc6DqNrYtt1Moz9thSzsZpL/5d55qjMpjkxmJQQyth79nisDZsf5ecIHwcdcHZl5whGV3adhewmEZsd+ifHBGSCfUM2f0Y/L7GQx8pW2sa4F6W9WAMuLi6P7bfjrfC4uWBX/5LidE5hS87egB5l9XrQKWJpKiUd+U0+u4LCsqiQHN89aBZOgH5XslT1hFffE28Yc7eVCuFUzj7fbGieyz3I/7J+ekP6BlNtI6FVqW4Snz/l4x6ceN+nOVzGK5fp/JkEUTlmqsPVHF2ERApIBgrr4uiaSSucgVl4LsOkAfzutYnX0CCAdihwlbfH1eU/8MjfqD8Gb46H53oo5MJ9vhDRkqGB++c4X2ME5DlvjwEWZYGREQ5TJo7SW2CEp954srlHF26FIAARjSu7R5L7XSALIzZ3kBWdrGKzKLSjBcqLY0ewm/HBirfrqwrDucGT4tQpUlVU7w9QnR1zvEanJSyFDe4Ocb4YH+UYQBxQInSrkAycsYj0QdU+HYnxGzw9fJ/LgHf1bKK4PpDfgn4/YNUecf9eh1qOfu/cRYdki6BkKZ4xcUB5zJHKyRk7fySbbkacn2vUx3kcSD/ux/ei3dOuzTxgTgrzb/GWRCy9fExVdfJdismwkRE7wvgpwUYtUsZxRLCtEXVEpGkWCfVOxKLQj9h7R5aWPGLyHziaeKtWe6IpgUYgMcPFv/
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:47:46.9403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b603f5-16fd-43eb-dc3c-08dc48ba6ab4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6539

The machine done notify event is used for SEV guests to get the
measurement of the encrypted images. When SEV-SNP is enabled, the
measurement is part of the guest attestation process where it can be
collected without any reliance on the VMM. So skip registering the
notifier for SNP in favor of using guest attestation instead.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 774262d834..e4deb7b41e 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -989,9 +989,17 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
          * own internal mechanisms for registering/pinning private memory.
          */
         ram_block_notifier_add(&sev_ram_notifier);
+
+        /*
+         * The machine done notify event is used for SEV guests to get the
+         * measurement of the encrypted images. When SEV-SNP is enabled, the
+         * measurement is part of the guest attestation process where it can
+         * be collected without any reliance on the VMM. So skip registering
+         * the notifier for SNP in favor of using guest attestation instead.
+         */
+        qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     }
 
-    qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
 
     cgs->ready = true;
-- 
2.25.1


