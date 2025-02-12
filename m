Return-Path: <kvm+bounces-37956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FE55A32152
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 09:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78F8E1885CA7
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 08:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315AD20551F;
	Wed, 12 Feb 2025 08:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JcUDEjSL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9CC204C00
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 08:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739349485; cv=fail; b=WaGGvyWJYzMLOG7W55HZYJpBpixdlNm/QygEKgRauDniMNlQCdq80PJ9SQe35UJ2FeHDteimDcqjvjO+SK3LaRR6RjBH6Bf1FZWVtSV/7IlOwafqsR49qTx1IxfEM7igVF7LLnnsov9ui1ndyQPzLcINKrPSM5dGR0OOxM/ZNVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739349485; c=relaxed/simple;
	bh=JvPyiUe0v+7Cv4/1AnJzWFtcptj5oJwW9beBeIj2D+Q=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QcyQ+2WETBKuM/8Ygu/+UKsqUTyArBCXo3bEgnOK7H9bkmrNacfhwBfrAK6iuN9Neaw6BqtF1anq0VrCzw5+cc6pnvM/oAVBCgEor7D863a42xU+02+URqsYnDLDzuu94RnXrzJc2SE0Rs1NOVTzf20qiU6UxVlxUpIRqZSQwE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JcUDEjSL; arc=fail smtp.client-ip=40.107.243.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dUQm2NnBqk58lVHTKNlr0U0gzA0V1bSz3BX5U/SJulECDqpKyyjU9KmVn+2xoeVAHntANL62eAJR6Un1M4WLTNtvjIF1NYE3rHb3jkZe+nX9YW1UKOFAnp8YbEb9TfwYXA3xq5JvaMvFaiz1wmj2ebdZq0Mpa5YiD3sjqsTakKtbFwCPgDcwvQ1IsL9Is0zYEHsH2tMJDpAwak15iiEPL8CH/lhHFV1djg1pTtOKmmyf7x87YlEQp6i/yAlKadAnDLGKmrtvBaryvveNHsvfAmuQ053rwlLEOFrjoiLRpD2YvDupIYBNyPDGA2IVcgoH0zupO8QbxCLYKLSbnL6msA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzrR41bt0e+CpYVLFB+wg8RGgmVND7M1BZFNmo8cKts=;
 b=NkGMYtrAKx5X5d6seacc0W2nOYhpHQRF/iBS81wy1ICL6PdiStxbaZlaxYKiDCJ70FuVQ9KUM7Md7vIn4Cxd/iQVcv7QDhL3waQEdpCTQKjAUuvX+A7+kJeQYDsctlqFGWpqkp6BOgt7EFn77fsW2hglB6GG8zrzAPoEZewENIv4hhSq5rvI5GVdlNpmlmi+t31xd9+o3PZq00N8om+wwL7TL0lQhbZL+jGHrcpABI4qZDLpZGRiULkH+nhTrL6le4uJYFRGa1jRVHtHoVHI4l4+0O+fl4q5uPCwjfKlT2uJ66FBL9WwiBhTRJEWTDiP1bR76rVf6H1Iqevbvb/uaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzrR41bt0e+CpYVLFB+wg8RGgmVND7M1BZFNmo8cKts=;
 b=JcUDEjSLmzwho2r+gPS7bs+Tk71jX8SR0Xotvvvl+AGNdV6BpwQiLPINbiRBgGdInGMiN5kw1OAsiSjpvnXTxaPrV0SLMAwVKUAk46FSjzgqjW361KY2F2bosJ4l7Aw3D8nHMAJbeViJre/qrWHIroEjVw+67xktlWVs8HIRuBI=
Received: from MW4PR04CA0098.namprd04.prod.outlook.com (2603:10b6:303:83::13)
 by DS7PR12MB5741.namprd12.prod.outlook.com (2603:10b6:8:70::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.18; Wed, 12 Feb 2025 08:37:59 +0000
Received: from CO1PEPF000075EF.namprd03.prod.outlook.com
 (2603:10b6:303:83:cafe::f) by MW4PR04CA0098.outlook.office365.com
 (2603:10b6:303:83::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.12 via Frontend Transport; Wed,
 12 Feb 2025 08:37:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000075EF.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Wed, 12 Feb 2025 08:37:59 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 12 Feb
 2025 02:37:55 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Sean Christopherson <seanjc@google.com>, Tom Lendacky
	<thomas.lendacky@amd.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <santosh.shukla@amd.com>,
	<bp@alien8.de>, <ketanch@iitk.ac.in>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
In-Reply-To: <Z6vRHK72H66v7TRq@google.com>
References: <20250210092230.151034-1-nikunj@amd.com>
 <20250210092230.151034-4-nikunj@amd.com>
 <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com>
 <Z6vRHK72H66v7TRq@google.com>
Date: Wed, 12 Feb 2025 08:37:53 +0000
Message-ID: <858qqbtv6m.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075EF:EE_|DS7PR12MB5741:EE_
X-MS-Office365-Filtering-Correlation-Id: d91d3206-2dd3-4358-6159-08dd4b408e53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8vh1i1AiEqBE/B5d761z0UG+4gQQlDKa2NKjU0bWWFKXiHqcEaybxKYyE7d6?=
 =?us-ascii?Q?MaRfqxN+9aUx8CrbsMSPQODxQqQxyC55dEAdCW7yVfPgLS5MaRiHoxQFAcGQ?=
 =?us-ascii?Q?WkphNGIFxxx9ggaLNTpENbk0LhLCuuAecUOmNbgYdNu4f3zuRjM1TSmUPTR5?=
 =?us-ascii?Q?6cvw/+LKb7iUKxykbwymGpt6Kr4Kxr5C9HpKxb5GCac8RjLhBdaByfeYADeH?=
 =?us-ascii?Q?PczaHWG+MdcQJ3TsdO6RW8k+amrrkmC01Lzc93MdGDDn3SKfDXDSjnzwoKCQ?=
 =?us-ascii?Q?fgVPTMgV6vUvg47zuG77W7ems+GUrFaAWDu6g1NOo4Mt/MCtUsPgUzChFVqs?=
 =?us-ascii?Q?0pZEh6RbDTJ5gZn7ijhxKJ7e+z9yKkviPikpNu4vRClOoxX+HfN6pMamZqAi?=
 =?us-ascii?Q?Xr2OYbBxmQj+ZzT+8cI3rNtvOajpn7W+JCEMVs03roWR10WSkE3ftjyq8t/h?=
 =?us-ascii?Q?wQmz2vuyDc7Vmzf67p5k13mp1HmQraiGH3AsIEhTDZHs6QJSpcdo6HfrSvx7?=
 =?us-ascii?Q?/okhJoqhzn4EtvhWQuOZZ+N568zv1Ca3UMDe8q0Pur8LNPAialx5PfUJL7w1?=
 =?us-ascii?Q?Dz+PVQwRxXTNrzunbZKkxGR52CyW70uIIImJUM1ln/EBNk85yryupkhutnwF?=
 =?us-ascii?Q?RCR8ZZ9oaenefubzJObnrS0fxtvvTeANAuoaP5swqxc3XogTXIgiaSaDIkb4?=
 =?us-ascii?Q?7GNqKarak+tKmgTCa0aknb5IM6lPVDXvMkHR+FwC3V1HgaQwq+O9Yhdc84Bt?=
 =?us-ascii?Q?sK8VhlmLM7WELm8mggDN3LZja6MMqsdW8cVpsYioE08B1Kz/RONLh4uKHPxe?=
 =?us-ascii?Q?tFlMkj9qpmln5B/rL/DvO/5qeP+P82IyN7RJbMqpWB29TQkiHjAIw6ygZm0n?=
 =?us-ascii?Q?YJiHA8G1lGjBsg+1H+7a+ah5zzK7hl9vkbS4puKhV5DWl8YK1tP0m6wEIfr/?=
 =?us-ascii?Q?ggy+/TtOAqGvHxuQJyiOgqnhc+ZxhbhOrNPCDML2WGKOu8iSMbgXyIreoPNt?=
 =?us-ascii?Q?QhntQ6fU0Q7N3p6+XyJGtdp/ZiknVk2jwCcKgpPeZIy/xWwkrhyvAEtK4WiY?=
 =?us-ascii?Q?2ecR+H20fT+ht20HBmEte5a3B8FtcrBvX3/FGBngHLPK3gPkmqMfCtN1gSCn?=
 =?us-ascii?Q?iN8O/JDpGkcbMFudfmmZX4FVIpfAYBeasyD24DNpTrtdjZopTqlAMWZZCY5F?=
 =?us-ascii?Q?dDo8wSxi15+BQrl8PO/y7YfM+bI14aaD9k8qeATrg6sXsMFx5MLuSh8YvANl?=
 =?us-ascii?Q?1F2830+Cb7ihno0PkQHmdzVwV3bNh3lEsqLO36lsQeEMzeJHo4GV2u48em8T?=
 =?us-ascii?Q?X8stuIuPUUhklk14oHLsQv1rCugLELCApp3M96r7yztT+cyR5EwXa7p3HT0S?=
 =?us-ascii?Q?IWJWvigMa4CggfYGIl3KVrqDiTIzzRO8jYxZUlJ8LbZZQpmoZxMHeAsSMDkG?=
 =?us-ascii?Q?s56Q0xyNQz8nUyheOnaYxPTd1D6IrN1Pd77h8rQMDfdxTucMQqiS3JT83cVA?=
 =?us-ascii?Q?oC0rx4fL9fMYOiI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 08:37:59.2266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d91d3206-2dd3-4358-6159-08dd4b408e53
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075EF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5741

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Feb 10, 2025, Tom Lendacky wrote:
>> On 2/10/25 03:22, Nikunj A Dadhania wrote:
>> > Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests, as such
>> > writes are not expected. Log the error and return #GP to the guest.
>> 
>> Re-word this to make it a bit clearer about why this is needed. It is
>> expected that the guest won't write to MSR_IA32_TSC or, if it does, it
>> will ignore any writes to it and not exit to the HV. So this is catching
>> the case where that behavior is not occurring.
>
> Unless it's architectural impossible for KVM to modify MSR_IA32_TSC, I don't see
> any reason for KVM to care.  If the guest wants to modify TSC, that's the guest's
> prerogative.
>
> If KVM _can't_ honor the write, then that's something else entirely, and the
> changelog should pretty much write itself.

How about the below changelog:

    KVM: SVM: Prevent writes to TSC MSR when Secure TSC is enabled

    Secure TSC enabled SNP guests should not write to the TSC MSR. Any such
    writes should be identified and ignored by the guest kernel in the #VC
    handler. As a safety measure, detect and disallow writes to MSR_IA32_TSC by
    Secure TSC enabled guests, as these writes are not expected to reach the
    hypervisor. Log the error and return #GP to the guest.

    Additionally, incorporate a check for protected guest state to allow the
    VMM to initialize the TSC MSR.

Regards,
Nikunj

