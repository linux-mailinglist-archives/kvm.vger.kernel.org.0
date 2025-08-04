Return-Path: <kvm+bounces-53886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62961B19E85
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 11:10:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58A721890EE1
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 09:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 039B824635E;
	Mon,  4 Aug 2025 09:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uKaKVyKq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2079.outbound.protection.outlook.com [40.107.102.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C652459DC
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 09:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754298619; cv=fail; b=VP3fTe+tEjd6XvfSMAWP6074ZsFC1lfZlyAiKNuGq3DVY7/eItFyE1fICReeMtoRC0R9mvFYqv985A3imyZ0/DodNes2lCTTKDPcDk6S/zgKAtmyrSGJ8oll8DlK3H1z0QQyj/mhgCDXM0BfwF6Cp2s0W4pJpPEaMO4dnfJYTTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754298619; c=relaxed/simple;
	bh=HzQ1nE7zkPirQVQa6oV9wMXWPTlKUcs2g/Ot/Iq6WR8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DbMEscPbU9SkAw35G5pcK2UITYwaX9vbRKDyj/zjBwaAJzwUPkuSXwkHNpUAK9t5WA+m5KHqXEsjmYArC59xv1Pn1A3yuJsmXPs+lF1tz5OriXge5DZ771t2iKXZ9Hh5PMZZiyu/Yoe48ah0SofR9tA0CxNlAe2nIulnsxwtMzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uKaKVyKq; arc=fail smtp.client-ip=40.107.102.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qLwqsf7X7SAAyRaHrJd31wNJ+8Hju36H2sMo3wmenlwmvq9mFy2QYIK8maxGy3HUxK4ziTHm8oAZGmNRB9VBP4m4I5XtBroypckg/AGItc1ewEKx0l+iBrITOrKd5XPYdnb8OxFSgePp6oggmwGjVUoS0mZJHdiRhjBcff0kR3PC/wmtoLbfsQRNLq4ddI7UreebsbRF9SjGe1uqW5FfABZCdrd1Sr+4FJ/P4P4CGVaL2Rqz3PFdj+0xMl1TETljCgTc1JiW8er3wTo4aa9V3+whlnt0S+3iXOSA7gIFgY4VNiDmzwrDELswNoAGsQxrFwS+v8Ud7pBzhC4uZshjtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImscV+O7xRyf9FViPa3M4usgSLuOEjHrCi6UY2i0IuI=;
 b=EysN2zMGRd0EWsEbYPEt4H1VbbDxY0BxaBEfKZhk5SPcfdCtJUXnGfRji5vuWh9aHGE+4JF7KRMLj2QeMKR5tRJujGr9fFUTp92TIrJAtsC1Z+K9Z73/419TZyTd5+KR4f6cHv+/McbTc0PztV1MtQb9w10g2vi+hgOKEfTY6XRY2n1OEG/7fLzBqJG8+bouWIqUHILTkp+YxU6OROewcF1JVqACvG7MMULnvt/QS4dKEZUZq0YGI7mfi3aPWeW+9CiOiXWBs7bL3kRtT7wqax6+ir9Xze4ujIYKxkbTdHhz0+e+h4B32iwthsS8g1nYegjnH0u1mYRNZ46ARjzgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImscV+O7xRyf9FViPa3M4usgSLuOEjHrCi6UY2i0IuI=;
 b=uKaKVyKq5Mx6qpeX21vab+TzRtsaNEQdbGc42h4MUsIDqmLGl05PUDU1uODsq2uFBLGP0pdGw5pIZ9qywW8/bBM5eWmXdt06Qj45tLX6ZEz4j8ozOlm6h9/t30ENyeEc7qm7cfQ8oO19huYutTmF0tXGfkCujGrEYVGMlQVsZjc=
Received: from DM6PR17CA0004.namprd17.prod.outlook.com (2603:10b6:5:1b3::17)
 by LV8PR12MB9450.namprd12.prod.outlook.com (2603:10b6:408:202::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.17; Mon, 4 Aug
 2025 09:10:13 +0000
Received: from CY4PEPF0000EE35.namprd05.prod.outlook.com
 (2603:10b6:5:1b3:cafe::e9) by DM6PR17CA0004.outlook.office365.com
 (2603:10b6:5:1b3::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.20 via Frontend Transport; Mon,
 4 Aug 2025 09:10:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE35.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Mon, 4 Aug 2025 09:10:13 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 4 Aug
 2025 04:10:05 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <nikunj@amd.com>
Subject: [PATCH v3 0/2] KVM: SEV: Improve GHCB Version Handling for SEV-ES/SEV-SNP
Date: Mon, 4 Aug 2025 14:39:43 +0530
Message-ID: <20250804090945.267199-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE35:EE_|LV8PR12MB9450:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aa66806-1cd7-40db-438a-08ddd336b879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YV6KPzsEfhwvd5Dwtxg2Zh7LTlyQFSF0AHF2h7n69NA6PqZMdc1aHRKorN6+?=
 =?us-ascii?Q?Y0WCoszOMzI1MTrQ2Seuc45hgLRFoCbJBmgIVKsNPn9I8aiH8pcjwrvuLvgj?=
 =?us-ascii?Q?GCT7hws6O7om6f5YRewMNIVRWAw1hMS//kuIhDSQduMCqgclZDhbRR27XQMO?=
 =?us-ascii?Q?g2l6Bdi7ynsrRo4phCRRGfwPpYehuuT6FjGNL0jH4c1qRuc9XLHBB/wkEZ8y?=
 =?us-ascii?Q?Xdk/+WPaoTYxcAtWCgvaEjWe68kxrbgL1+lCts2s4cToMMEg+vPoOyZCkIUd?=
 =?us-ascii?Q?9pYMF6yP7ZXsEwvUl5SlWEHSqUftl5KeoiNmBTkrPBaSZUlFQcC0838xaagX?=
 =?us-ascii?Q?yR5Mage75dUjHSdsA46aW26dNM7CTjTWEMKXS0MBeBgbHx3Hx8QtoIzAZhHM?=
 =?us-ascii?Q?kHQdTzbUkCUP3F1DizbWF9zckRtYOimw+hon+KO6jM/JhKaIWmKetwMeGd/E?=
 =?us-ascii?Q?eKn8EQyrAL/aq+67q8ktEwKFiF6ok9KaWWmN043xpX9Njdte+3NkPwMVUV0M?=
 =?us-ascii?Q?OnnhOkoDfEGJJlgXk/j3z0ct6UKPhJgYfOJkxvAYDfejeR7g/7U8uTLrqvxj?=
 =?us-ascii?Q?DdcnXWb/34SRnezr5l2zcIax1LIZqY2ZHX6TOA24DUj2N24Uw8eI6jqDa2Ri?=
 =?us-ascii?Q?byoEmCk1RceQcDEbnV1V3ocEYKhv3sXnkhRcFPzUbNMh+DGZXEUO7uMzspEx?=
 =?us-ascii?Q?hWA27TkpUeS1/jdxiccs4uDSUkhPntggGBxRFlIVGfEkWWHg21Kwlcz/AVg+?=
 =?us-ascii?Q?RPkRhsLkN9sJsSxuo52/58AJPG9SEPMZFN3MQE+p1mr8PD8hRZrbKDXIZRG6?=
 =?us-ascii?Q?50rpIRdCIN80uAiYOYerhAfq7rDIb9y9WCjLvV1EYFAAHT1D7JyC+4YIDqrQ?=
 =?us-ascii?Q?OUG7TD7sxs7PZtTts/o/tzU0RcUqcyXkdKjvd6xW2fmlTVWZfAr2N7XW0MPS?=
 =?us-ascii?Q?4aIC16VC1pTy9+2k/9x4eY2IzXKxkVNDZXBgWoC+7hoE3caX3RBYMbPOVADZ?=
 =?us-ascii?Q?alpFjLkKiAGeJfBqMtRJVnYgzB+aS+lkRbRoCOl8Y/OA50Js1YXgl6te/mJW?=
 =?us-ascii?Q?HqFfeOcWPgZgKABkGv5eLhiCArK/ZEALNZ5TOJx5ykOHMSkAdbSjnuYLIeNQ?=
 =?us-ascii?Q?YHKaH4c//FnafwPcR6zyqjK1kg2onTSeTVFZymVTMXbCt7PMO2bt3XgEBrhx?=
 =?us-ascii?Q?SZZQaI/LHly5w01g7o4jReBZLfBQDSWY+PUgSfMFAYeWd41Qhhr80ObzA8Qq?=
 =?us-ascii?Q?Sd56J+noLsMt/y35lX9DSxiWSmgm3jUD+CmqiphO6sYKVUoTFLcYkv7x9lJe?=
 =?us-ascii?Q?EKUELyNC/fKI00tf6NKStdWB00XgviCapPxWhZIlEnlwBt7ZxjKP81ZSOcev?=
 =?us-ascii?Q?LaE7iDUrHdMqYmmAb981muPrAsZ6Vh0NNNy9PK2HeLZ9Oh9452xlOhC/U98F?=
 =?us-ascii?Q?cRoOZrJ155KfK5uvJQblLhPI0hGTA8M4ctEz4Zzem1k66xtzD0frJG63syHO?=
 =?us-ascii?Q?52dC85qI4AWHrqqIWZxTHApmcLXcGV/LYWnn6WvG96DEEK/aYC4WDlnuJQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 09:10:13.2188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa66806-1cd7-40db-438a-08ddd336b879
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE35.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9450

As discussed here[1]:

Refactor SEV's GHCB version handling to improve clarity and ABI stability.
* Set the default GHCB version (2) for SEV-ES guests earlier in the flow
* Remove the GHCB_VERSION_DEFAULT macro in favor of hardcoded values to
  prevent potential ABI issues
* Improve comments to better explain version requirements.
* Enforce minimum GHCB version for SEV-SNP guests.

Patches are based on kvm/next

1. https://lore.kernel.org/kvm/aHp9EGExmlq9Kx9T@google.com/

Nikunj A Dadhania (2):
  KVM: SEV: Drop GHCB_VERSION_DEFAULT and open code it
  KVM: SEV: Enforce minimum GHCB version requirement for SEV-SNP guests

 arch/x86/kvm/svm/sev.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)


base-commit: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030
-- 
2.43.0


