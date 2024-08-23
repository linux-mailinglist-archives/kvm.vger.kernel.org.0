Return-Path: <kvm+bounces-24911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9C6095CDEB
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AA621C20986
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FD318859C;
	Fri, 23 Aug 2024 13:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="B03MGVNP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B7A18661A;
	Fri, 23 Aug 2024 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419876; cv=fail; b=MQWTYFyITDV6Q7vrAy4qYNt4VaaaPnR7+0ZQVVXiu/TLVyu9t81QDceKjrVuaxar0MHGDHYBzIhVOL1+koPNnFCc5oTZcestqmA+MrSijkV+w+jjmIqd3SdtUKtBdITfasFdj7zpQuBUyXkd6KgMOgrwEwpCaI/XdyFP/D7R+K8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419876; c=relaxed/simple;
	bh=L6pd26/9c5ODDOY9aJZ0s+HK9y1ZBYz6bPFlCbUXDT4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IquR4hR0bC92AwloICRGjYiN0mSIpxkGLRlJmbGBaBmtrt1UiUXvykW4QDZ2CiRRgCxrxfWDmxWKA5t6SeGbfXGEedDbxpYmaQwH5lwwLAketvNGnWlAuYo5LilDqWk3wd8EI568oA/kX1XBGoF7k3TacSxrcSC2cR9W40yVops=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=B03MGVNP; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QfH+xHr/Mcgi6Ehrl0ciuwiMjIDhqFRNHcyRZynawZV88+FY64jLTGC92lPB9ZWcFXb2/3Iy4NuTu7GYZ4PDODp4PX6kupZTWVIfQbnPvQyROKffZGF0P1prnLU0ByKka+pY6c9GjUVo1hAINNl07afVTaJiETQJL/vi55TeAsvg2v1QP4o8vUkJOsuvq3WVn8xfFwY0OKaq+Jpbt5lHUzhFT45ozywRur196D/VtahVzxe7sxmdUY/hqWAn7LnF1c3/ZXqALHCEaEkxPI67O6al9qne4tjp4OzLZJy9h5DLJgpIL47CTuRcJU9kVq/Oqjd1yGGXRPH/3xHuy5tyAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHDV/OEuyy1j1v1UJzuiCPuYoYMTBdR78IoDRdsVYTo=;
 b=PMp5pBPvsEGjnle3Jv74NKVvlwWXxcpZuhqMnksdrkx7rx/y9MFWL+8lnixCdY4Iopn2LymXvsn/EbLnEX+WvZURazsJUtEEPFn9ySHcdPGwFDxCn3JFicCP57lOl0USFvoEk6qSox3JQjhOqe9/dwcUXAlxpG2kv6XgvNYUC9mBdfs1SWDyG4X34DpvEIyjuS2D0dWBzV8OIOPlrOK3oTbo+hBk3IpqTI9vC62k2SzzgP+oqxLwRdH+dqan+HZfimm3OjFQ2qZDTHhTwpLLm7g1k86M2S57iWu+kRnbXPlhltoXhz1uraR73SjOAwft8uo81HqP0GlPSF2xqWuKXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHDV/OEuyy1j1v1UJzuiCPuYoYMTBdR78IoDRdsVYTo=;
 b=B03MGVNPVx7hwqGPW5fLfus81ClX6E3ar4whOwlTa67u7MVkFnPtmOi+wXvkxUKUo1h3pxLrnZzWJp7OhYqP9K24JUxToPw3Q0v02scdP7JF3PXUoy57+gNOgZdu387yayexIGzXrFLa4yYTipg0fmoUi/zYut1Fixd9wsoickw=
Received: from PH7PR02CA0027.namprd02.prod.outlook.com (2603:10b6:510:33d::16)
 by DS0PR12MB7534.namprd12.prod.outlook.com (2603:10b6:8:139::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Fri, 23 Aug
 2024 13:31:11 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:510:33d:cafe::e7) by PH7PR02CA0027.outlook.office365.com
 (2603:10b6:510:33d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:31:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:31:10 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:31:04 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 13/21] KVM: X86: Handle private MMIO as shared
Date: Fri, 23 Aug 2024 23:21:27 +1000
Message-ID: <20240823132137.336874-14-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|DS0PR12MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: 819b8ffa-7789-4a69-6c58-08dcc377d9bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qPVdSoQlMba8XHmoAHr43s7qV+qM6CshJwGDkfUmVEOmXkFXcU+AvcRV2qzI?=
 =?us-ascii?Q?BWwNiJM2C8udTywwy3+W9uB4A/HuRZ4D/sJxWiGNC/gtl1GewqkuF256NFmd?=
 =?us-ascii?Q?dnzO7j9uSuasWxQ/lO/kKUSAfaJAdT7wjSNhH3/rp+pfRwym5GoEEr8vbMWG?=
 =?us-ascii?Q?4Wg7hOauka5AXcGqH9U2OeRzt7t4G+Vrmba1A5UpsnW1NduyYbmOzHomKNHG?=
 =?us-ascii?Q?d+yGSkz+lIKhnI9k2axyMIn54c/yqQ1H9zJ1pCPzPZndIg0WTb8n1MVlF+zX?=
 =?us-ascii?Q?dsT73rx16fUxlkai9VAGCVXIJjXzctZIefSUpG4WHVgAy0AIUWAW+PPATYqB?=
 =?us-ascii?Q?Ii3SGK7+0Pdh2pVEwP+oyCYnmYAJQwe6Ap0FOR2LChp8qMFJ0fBLIa8UCAJY?=
 =?us-ascii?Q?K7A7irOyUegFgm4igoWfmyUIugKbwLgVkfD4P83gQs8ybGZp60Vddzyow0Mq?=
 =?us-ascii?Q?z+Xfe188wJJfkZmiM0jNzUeM/REDmx9rXX88nMm3O0KHvF65hydVk+gie4Fw?=
 =?us-ascii?Q?8tHdabYsXxXW+tiWZMbJMipmqofasCcfj5dRINVN4AHivTqQKE0DA70m2zF4?=
 =?us-ascii?Q?xMEePXCn04VBDlfCNFaZQIYpOCK+P2FSZxpRgsMGyE5///EGHDjcmp9TXKxl?=
 =?us-ascii?Q?IxvJppANwHoPNFPOL7SsN7Gr767jJLbhj4QNjrnA2eZkbosB3zrXuil577pf?=
 =?us-ascii?Q?UF2ZPbZezWHjrKS/7GdkeYUTW+yVvrr0LQ3/JT9Ryd8npnUbrxth6DyXMCD0?=
 =?us-ascii?Q?35+B7S8aT16QaI7t4Jz4ytSQ1DZnSmMkhcwAIiHDyNCkDW6foAlOOB07NqBc?=
 =?us-ascii?Q?2/eBK9++UaRWfEuCG4iL+gmT0CxpfFn+vVtPYfHKFo+FwY9sZ1J8E4bBwIvs?=
 =?us-ascii?Q?Bw2qvvMKolZMD2YHaFX+6+K1J6HZZkX5sa5zlQL0EsrNKm0sD6AcwRdVoGxr?=
 =?us-ascii?Q?6j7ykE0M1kjH4S1wTznGREJxvTzQVbBzMUYOU2kJiNfU9uCTlTjIiwZ7W3J6?=
 =?us-ascii?Q?sqh8wTr09zpyj9iz5yrmENxgkileYFxfgnS+I2voNxIIv2zSVstpZvjvgGXM?=
 =?us-ascii?Q?T7x885BS5DkFLb49+teF/kfl5Gh+gcqoq9UpkwRpEmzdyfsX7BF7gCk1CD6Z?=
 =?us-ascii?Q?A8v4L/lGGLa8AkSsF/cgJm8CrNfoCts5MMJneGdrIIUqvcr2TKNZVSGBncr1?=
 =?us-ascii?Q?ulpvwWmu1Ot6oBssVz9H8f1IH2QY7EektiPDzNmthOvwsKxl0+yshrQnn4Al?=
 =?us-ascii?Q?dsf8I9ycQz83V9ZKnLv5lVgl3+irgQp0nWisinZ9++DJRn8rown2k9/Jb0SG?=
 =?us-ascii?Q?aNl+3gQzxj2NPCtOC3aGVmmWPdiFj4ndgnHe33FqA21BXrBHyY+L3TmlTz5m?=
 =?us-ascii?Q?mFU36Zl37Hj640kMCza1q930v09eZMFkrnKFi7GdfwqOrdx5ojpP5yJJ6FWy?=
 =?us-ascii?Q?oZ98dkN/pLOSeusHVjxOw9z5IYfanrFa?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:31:10.0243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 819b8ffa-7789-4a69-6c58-08dcc377d9bf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7534

Currently private MMIO nested page faults are not expected so when such
fault occurs, KVM tries moving the faulted page from private to shared
which is not going to work as private MMIO is not backed by memfd.

Handle private MMIO as shared: skip page state change and memfd
page state tracking.

The MMIO KVM memory slot is still marked as shared as the guest can
access it as private or shared so marking the MMIO slot as private
is not going to help.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 928cf84778b0..e74f5c3d0821 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4366,7 +4366,11 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 {
 	bool async;
 
-	if (fault->is_private)
+	if (fault->slot && fault->is_private && !kvm_slot_can_be_private(fault->slot) &&
+	    (vcpu->kvm->arch.vm_type == KVM_X86_SNP_VM))
+		pr_warn("%s: private SEV TIO MMIO fault for fault->gfn=%llx\n",
+			__func__, fault->gfn);
+	else if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
 	async = false;
-- 
2.45.2


