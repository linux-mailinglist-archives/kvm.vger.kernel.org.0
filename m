Return-Path: <kvm+bounces-42077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A331A723D7
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 23:21:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADC4E17816F
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 22:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C08C262801;
	Wed, 26 Mar 2025 22:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZWxYfPA4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43E45028C
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 22:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743027676; cv=fail; b=Vmtwm4HLKZZ/fVU852KYlNu8bT1+2gc7V2W3gvDA7jsL4XPRUoSyhuoEkQenSNt+oMlr9DRPIMd5muCEr+vq06JQ7t+dCfnW9jM8hlFWbK+i3+qF1IV9YR8wHqLmgC8KGOnIGIQbh+qv7lTxrwtNVRxlvNh/C5rtdcG68itJBCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743027676; c=relaxed/simple;
	bh=3xYj4tZhyaeyY45qPLql1O9QHQsKdXW2WpwYeNsR3AY=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=RQ2sCoBCgem3ynogx+r43qewxy2/QegLk+jyPws4yb9UOpV38B40RsAFozWvXK8EpwlwUvGq5RXOTqfwZrK22ZIfpSVdMGktQzWELyHcrKyreGTfbhGgF3gkATHrNCTdTneCRZyKIcN2mxfvph9WloStznUaKkVTEW0Dfxb2QsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZWxYfPA4; arc=fail smtp.client-ip=40.107.236.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I7ookL40UyWENheEc6Stu19R2ZZGzr7Xkouny5kzJpGCPPHHD+K+wzAiXPjzxhVAKmGhTfIdTykBvQeCCZgs8Qm4cHxfZ04dSQ2b41h2jqtdDc3wpmwTzUuR2LHdZRxVixuyFX7YVdUIFB3HUqvVE/Nwy8DD6xVTRIPmPrJiOj5aOwO2ZwC3DIMGgbuBmf04EfXpIzntetxOhxh+oACCY9wzjnFdgRbug4/IMjNff9EqV34S07SxCvbBRWCcjzb13WRr2t5D5If/EvG/H+CBJcvBdJjFWoVVMjVnNUOc83cKBlmQauBuG47ClVpc3S3R1Zy54P3iaN8lEYMEZoTHCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xYj4tZhyaeyY45qPLql1O9QHQsKdXW2WpwYeNsR3AY=;
 b=GlFImBRD469bZJGHQZ1bYDlq9oQnE+iWQFY/TpVONTHkGCbtP4ipSorBuAnUxtUy6XVAUyGeFMBUxe8IIz7LAzYoFs+AhDQx+2gwvHVyImvOuZtjj+k62d/cDFc0yrYV59/nFjYn1bAJnIwaQYGerogVYaTbMz7VAmJgxN8Po8tdh97epsU3GFXjA43RIg1Xtufadj1uOrGARMDsUZY1tE9XMJyjIoXN7/kXcuJY/Nrigu0RuumFKrnZo9D2B0RaO/v2NBwNAE+2WAaRFXHgCpKhsURbtKBV5srVzSMW7lXzlQkjeG/MsmsoY6sVFd7FwwNjsLufmU8pqxV5a3g05g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xYj4tZhyaeyY45qPLql1O9QHQsKdXW2WpwYeNsR3AY=;
 b=ZWxYfPA4MMAU8bhjwcIA+VTProkPNclzPM2W+KrGbOyIBrasxTF0WaoIlGr+Xu5zS4HYXCuJyDx1zRBoxOqVKF17tw+BivXYZrLvF2S/McpTr5M/P2osp3qXrdXjubmNxI6TlFWaUZflRQnk0Eo4K5rw2NEeB8y96qXDDrHZShc=
Received: from PH8PR07CA0046.namprd07.prod.outlook.com (2603:10b6:510:2cf::24)
 by MN2PR12MB4240.namprd12.prod.outlook.com (2603:10b6:208:1d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 26 Mar
 2025 22:21:10 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:510:2cf:cafe::e0) by PH8PR07CA0046.outlook.office365.com
 (2603:10b6:510:2cf::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Wed,
 26 Mar 2025 22:21:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Wed, 26 Mar 2025 22:21:09 +0000
Received: from [10.217.0.47] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Mar
 2025 17:21:07 -0500
Message-ID: <4732241e-b706-481b-a73a-01ef77622d8a@amd.com>
Date: Wed, 26 Mar 2025 15:21:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "svsm-devel@coconut-svsm.dev" <svsm-devel@coconut-svsm.dev>, Jon Lange
	<jlange@microsoft.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"Kaplan, David" <David.Kaplan@amd.com>, Joerg Roedel <jroedel@suse.de>
From: "Melody (Huibo) Wang" <huibo.wang@amd.com>
Subject: RESEND: SEV-SNP Alternate Injection
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|MN2PR12MB4240:EE_
X-MS-Office365-Filtering-Correlation-Id: a4375e95-2278-41c6-edb9-08dd6cb4828b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K1l4SXFnSkszSlJnTXozVU1ucjdUL3p0eUJVNXhOTEJsK3ZrcUNyUHF5eVE5?=
 =?utf-8?B?TlRWKzF3UHlPSEpWWXJEMzBLbWt2SzRKUU5vUWNsdUlOT0tZcHBNMUJESVFJ?=
 =?utf-8?B?TU1td0NFSjBib3VNRW9YM0luVjNHM29VSndhdkdwTXVZNmRxNnhQSXljb1Yz?=
 =?utf-8?B?SE1GeHpZaFgrWUpCYVZsa3haMzB1eUNhcE1BMHJpSjVlNEhaSW5YN1FsTHdn?=
 =?utf-8?B?YldBVDZVUjUzQld6blUwVkgwRkNMaWRiTGhwOVFGcGZyM3Y3Tk9naGFBc2pC?=
 =?utf-8?B?WEhESWRFcktDRzZvTEs0TUpsUWd0REZnR2lpRXVQQlFSa0d0TDdiZUQ4VFBk?=
 =?utf-8?B?NEVvd1UxR1F1cWRiVTltOEx2UXRuREpqV2FWTVN4SkdZNnUzNU1Ja1cvd0kw?=
 =?utf-8?B?MGg3L0lVSzdPYmNVaEg5dHdjOGljZ1dkMzMweTBmQjFUakJBZVY0bHFraTVx?=
 =?utf-8?B?TjBUWTUwYXpKUDJYZi9sa1F0cjNwSk1qcVNPc2EzVi9BUHFlNDlHOGRJUmNI?=
 =?utf-8?B?dXFYSWdNWk5KcXFrSU94cGVHV1ZMaVo1SmFPNjh6UWlEcHhRMWVQVmJzdEpw?=
 =?utf-8?B?YzlpdExSWUF1WGZVSFRHYjAzbWREOG1ROTl2SDExdUR2MURraDBTVVJpRkdR?=
 =?utf-8?B?RlJ2M3ZkN1JNSmxyb2laMmFMaW8rc0pFQWpRd0JTUXlDYkdLZ3NscVR2N1hn?=
 =?utf-8?B?YlZVVmM4RFZqWGlqVzdwZnlDQW8rTnlxN1JadWZReXpoN1J5UWgyNWJ1a2to?=
 =?utf-8?B?OFJvQjJyWmkvOXpKaW5HZnVDZkR3NWoyQ1kyaUZqMmRPTzdZQkhXNTc2RmNL?=
 =?utf-8?B?VnllMW9jeDZBOEZwZGU0eGFMdzRtZTlpUk5qbDRwRTUxRUw1aXdTbm9VTEVk?=
 =?utf-8?B?NURlMk9FVnNlcjNSSWFFMHpVN3BsT3dRWms0YW1oMmpuWmhpWEJuSGczWU5y?=
 =?utf-8?B?UjZiMnNPV3dVdmZUTzc3RmxSdkJvYWR3bzd0SUNyT1ZSbWoydUJDSUo1VWlJ?=
 =?utf-8?B?QkRNV05UN0I5NHdGeWVwcUxKVGpMNGhKTjhtRWlBbCsxKzJLTE5BMFpYQ2Qr?=
 =?utf-8?B?WUdrNTdaWkdDV05MYmlYRjNxcnBEQlZidUlKSXNJMWppbisyS3I2VGR5SDFM?=
 =?utf-8?B?TXlyU2xYaHhOaWdoSEEvMnAzN2RpMlljRGMwekI1V3gzTEFqeXJ1enZaeFR4?=
 =?utf-8?B?QzBsbzdkaDBkQmRHbU55Q29WNG9zcFVTVHZQWDJsS3B1N0RGcTdrZ1p4c0ty?=
 =?utf-8?B?dTQ5MWJoY0JwajNqMkhUUGFVdXBTWGNjbWw4U2xUalp2UWhIVlVaN3J0eG9J?=
 =?utf-8?B?N0VNc0poZTlFVEN4MDNhQURRTkwxcFlTTHFIMngzUU4vWDgrZlA1eWZEbENm?=
 =?utf-8?B?bTBUZXFHdi96ajJ3RXlWQVR2NFRiNUxOUUthL1FJYjVpdnlaY0VTTUhSN1Yx?=
 =?utf-8?B?K3VJVDRWeFp5MzY3TXk4Nzc4TTIxUGpUaUVaU0U0M2IzNk9jWXArTnZBelVH?=
 =?utf-8?B?V3g2NVFwNDd3bTNIWEJXSVdMRzMzcmR3QlFxRll3MkZ4Q2ROY2o0M1k5eDdM?=
 =?utf-8?B?ZXZTUmdGQWVZQWtiTFBlQ3I1dzNadExCNk9EVUV6YmdKa1R1cVhXTUVaZzNp?=
 =?utf-8?B?dXpYSG4vdWdzeDZiL0NvSDZaTmtwYjF0R2xTNmZUbkR4TzR1VGdRS0NSa29L?=
 =?utf-8?B?c1dURnpkRVVUdWgxN3hIL25sdG9DbU0vUUF2RHQ2c1MrSHNkRGR2SFZpOGRP?=
 =?utf-8?B?TDFzSytsMGlRdUVEcnJ0RG1oVGRGblB6dndPM2s4aTZnc0hBQTlZcTFyRVJx?=
 =?utf-8?B?SklaY1pWR0piWWdWNG4wN3dlK081N3NLZm5Hb1FsZWtuRUwwUjRUWHQvak5K?=
 =?utf-8?B?M0piL1dHVytIZ2w5Nmh5ZGNFb1FMbkZqZ2o2ZUZZbFNIWVlSL2lWRTlna1Uw?=
 =?utf-8?B?dXVMdmRHc24yMlUzUGVnaFpJUSthRHpsVEZKU0g1a3k1NWVvbEVtWXY2NkJ5?=
 =?utf-8?Q?aTzIoIAPxipDLx6s7niA1D1Ts+4Qbs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 22:21:09.5037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4375e95-2278-41c6-edb9-08dd6cb4828b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4240

Hi,

I am currently enabling Alternate Injection for SEV-SNP guests and have encountered a design issue.

The Alternate Injection specification which is a preliminary spec supports only the SVSM APIC protocol through a subset of X2APIC MSRs, Timer support is configurable, If timer functionality is not supported, the guest must rely on the hypervisor to emulate timer support through use of the #HV Timer GHCB protocol.

When the OVMF firmware starts, it is in XAPIC mode by default and then, later during the init phase it switches the guest to X2APIC. However, with Alternate Injection enabled, the OVMF in its very first phase - SEC - does XAPIC accesses. The SVSM uses a so-called SVSM APIC protocol which uses a subset of the X2APIC MSRs.

The OVMF, however, thinks it starts off in XAPIC memory-mapped mode. There's a protocol mismatch of sorts. With Alternate Injection enabled in the SEC phase, it requires X2APIC. The registers (timer registers) - not handled by SVSM will get routed to KVM, which at that point is operating the guest in XAPIC mode until the PEI phase switches to X2APIC.

One potential solution is to have KVM enable X2APIC as soon as Alternate Injection is activated. While we could start X2APIC during the creation of the vCPU, APM Volume 2, Figure 16-32 states that we must transition from XAPIC mode to X2APIC mode first.

More specifically:

“If the feature is present, the local APIC is placed into x2APIC mode by setting bit 10 in the Local APIC Base register (MSR 01Bh). Before entering x2APIC mode, the local APIC must first be enabled (AE=1, EXTD=0).”

Therefore, I am uncertain if enabling X2APIC directly during vCPU creation is permissible.

Do you have any suggestions for a better solution?

Please feel free to ask questions if some concepts are unclear and I'll gladly expand on them.

Thanks,
Melody

