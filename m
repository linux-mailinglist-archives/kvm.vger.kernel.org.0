Return-Path: <kvm+bounces-52427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E48FCB05183
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0CCC1AA71B3
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 06:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFFF2D3752;
	Tue, 15 Jul 2025 06:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tbT2T8R8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AD52D375A;
	Tue, 15 Jul 2025 06:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752559693; cv=fail; b=RX2Yg2RTrvz/6MJxEkIiGfDv/FlrziTxeOiZjpBogGcXKm3mCgHOX+Xkr2gjrzwk2ajAuo7WfRfTT6gkMqR+Xnpt0K+8VMNEguFBxTFp2A/UkK5AE+snLkfiJYAo0b7CrfhyuHdhn2RWhLJqSosU6KDxOcgiH1jK3hf+kE8gXqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752559693; c=relaxed/simple;
	bh=lRPxVGiCeOjP6Ie9ESDENII3PQCPG3+IbEArJx3ZGAc=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gfZXgP0pAEAdbI8QfVCFSzLErSyI4XNC6QXqF09gaXhhg+PkEOXcGsXiAS7jGF05pbuYhBYvl/KPGz60sHT99vcy0t8W92Z+5Wc3Ps7Kbsq1rzKr8nHPPRG/B0YWLn63CDlkCRqzAs9T2I3R8cFidfhtOjpgAZ4Y119u6w4mUJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tbT2T8R8; arc=fail smtp.client-ip=40.107.93.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Km3tm9qEOu+j79WdRryU7wpA+z2yeGZQNwk+DapFtu6BMGl19ag/VFPtRVDtxsxhut5iBHsq2ETriny9odCAkAILaTyTYj8XPfAy3bzj7WYqj2/k2dEnQnIeKIiE2dLu01Z8aPs4gz51nbK4rxyt9WghTLPj1J9AYrDX3Hp5jVplkbRkjvUSyR/Hd9A5KWci19cz6+B/j9q2d1Kh1VyccxdC1gPJo2yKy5USCkvCQbqgWtyqz6wSW4K2r6qLQ/4T5xwGu2p38LAIvJCbwxAmWnU8aG8++FqyXdqTEbgl4exSpX+1RAoKzISV6yRj/tnGd8ttkYcdZ33HixE+nBRjVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2hXFdyIm5hnmcc06spiyzyeeICoicMxGglZE9cgINQ=;
 b=Mocu3G5aF/h6uf3RzP7HNcgzi0AdOe5yLH809MQBJXKlsUYwzOQ0gx5f2/HWmq+wW7cQylcbYt4dR2Pw2uXI8/LTf8JPnZ1YpYh1VR6JId8ylheVCWbpphg52sVTZmfAA8DnOJUqPlrwvNdq1b7IPDTuNctWpiuLAll23wDYjHyAgWryMIXKnleSq1n6aThlR8gZhViuhY8gt3YIHf5d5Y4yC17qxdkIQ/PjP5VGkyg+iRRi8070mQuAS83osmXy0VwRPyLke0YVAoeaOcjlCMD11SIsPzaT+dvapzI082mhM3gCPJwZn2aUc4d5zDlB7tnwD7SUjE2PfeWz7vO23Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2hXFdyIm5hnmcc06spiyzyeeICoicMxGglZE9cgINQ=;
 b=tbT2T8R8c9IVlYXnJ4Zou8RTw/Z/E7BMlbOvP6y/VFMrfzpWsWqQ9y+6SgJGSVVkNSQuy+ZvQKzheOoW44m/kgIKwP7ti56UoBvJ1WSY5qytUAugZBzPaodS4M1UCwqSZRghWD+5XdTwv2S++ibZCf/5+W9g6T5vWYzCUn1V33I=
Received: from BN6PR17CA0030.namprd17.prod.outlook.com (2603:10b6:405:75::19)
 by SA1PR12MB8117.namprd12.prod.outlook.com (2603:10b6:806:334::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Tue, 15 Jul
 2025 06:08:08 +0000
Received: from BN3PEPF0000B06C.namprd21.prod.outlook.com
 (2603:10b6:405:75:cafe::5) by BN6PR17CA0030.outlook.office365.com
 (2603:10b6:405:75::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.32 via Frontend Transport; Tue,
 15 Jul 2025 06:08:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06C.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.1 via Frontend Transport; Tue, 15 Jul 2025 06:08:07 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 15 Jul
 2025 01:08:04 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, Michael Roth
	<michael.roth@amd.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] KVM: SEV: Enforce minimum GHCB version requirement for
 SEV-SNP guests
In-Reply-To: <aHUUWMnTBfcRO7Uj@google.com>
References: <20250711045408.95129-1-nikunj@amd.com>
 <aHEMmmBWzW_FpX7e@google.com> <85ple4go0k.fsf@amd.com>
 <aHUUWMnTBfcRO7Uj@google.com>
Date: Tue, 15 Jul 2025 06:08:01 +0000
Message-ID: <85ms96vvem.fsf@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06C:EE_|SA1PR12MB8117:EE_
X-MS-Office365-Filtering-Correlation-Id: 7751aafb-3d90-4941-518a-08ddc365f816
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JziILZPzmf8HBNXTPo+E84eTkEDaWM01Y2ocYIEhvWsgSqJDbw2/tPnrXTfQ?=
 =?us-ascii?Q?ojz+S/t4PRZP3wqP7XabW6LCsBoEEDMd+ENQ5rgoWRln4UlOuTj3+Izxl8mH?=
 =?us-ascii?Q?asUxZSh5NcOFCNFHPKCABLYF0TNpTbRwBNMjvYaIrJfJRPc+KsYO9rwGO64K?=
 =?us-ascii?Q?14jhrzUguCh7BbFUN3EC/KreEZhdwAzgjrOLFfTFXGrWtUruqYiAPkcXE1t4?=
 =?us-ascii?Q?owL9K7USmlSWv4YrKDus7Nu5qalLwCu7p1RJggOZea0okrh7V5NcXl50ZczK?=
 =?us-ascii?Q?Du/Bqor3mw2kt036if3shiEsEGnIWjyXkVEm2BD1xG7P/HAdUia3IVM9ejiX?=
 =?us-ascii?Q?nlsjp+dElEeRwWjvQ71GNIpOe3GVcHZmGYeLYz7WbdZLpONpk5K7L3QRmF/+?=
 =?us-ascii?Q?jAWVhmaxl+0oTqNwf8BeGBESSPb6KxmgBJeETcs+WfhHEiNiWpLaiy5++WQA?=
 =?us-ascii?Q?0rYe2JrEkSRt2C9V0W+KfWNvBnRwNX8CYGnkr3TiVAIU7mVHtFomvOlbXCJi?=
 =?us-ascii?Q?QFVRvCZYPx8uA6lXJKULCc47EklXs7aLXy6104nplCmXKVUQ51vfu2PtJsnK?=
 =?us-ascii?Q?qU5ZQwrEtRZf53d4qunWUpnRgPMnBSPpXuiQCcofzBEJtkFVzTuapNTb0QHN?=
 =?us-ascii?Q?WG+1TrMDI5x/Khwi/k9ynvdwZmovNP/a88TGjO3NfuC/dCSSB3uiWZi1RB9V?=
 =?us-ascii?Q?T607U6rSUzXWLykKcEQhAz3y7TduUV4xv8pIdNzIyH0/OjOHAuOK9KnxasCL?=
 =?us-ascii?Q?TYdoCqXZq3dF2O0Ivejs7rRuvS2tLyNs2ViQYmWTayhh/mfQNMVmFQqi/biV?=
 =?us-ascii?Q?g7/z6IissyiLsXks1XbF43j26qQqFSAFBJrSmg28UyS8Ax2fwS7f1KP3m3oC?=
 =?us-ascii?Q?tZkKLsWUBYfcIEhVFgDwD0XrKI/BbQySK5Gw2KLX1GMeGROeQxOb68KPy93j?=
 =?us-ascii?Q?IDYT4gxgQsNXHsD6AaMlH9VclA1M/OLFd7dDcvp5m6WzIxaJQDX0b9yTZpxx?=
 =?us-ascii?Q?owpAGR6ruquLOjS25N5CMRaUMrH2S/KNoreqPJLK7Aovo/GZdm+kYsRTDn53?=
 =?us-ascii?Q?6wyJzdJiT4konOSvvsmcnSRmyEFmSd0kvWhiFa269bEXQbas5C2zSgGlYbVp?=
 =?us-ascii?Q?GDILWznVv7E0SaP2CmJyyKWtgm3beFoKSpjgrG1pRBLHJjj+u/8H8hlmLsgY?=
 =?us-ascii?Q?FNJExcXTGk/KD1rEghuUorsadkIgX4O2KDODYMNP7NcRQAJxU3i5rxgkfxjy?=
 =?us-ascii?Q?e5YYe2Z0DCExLn2M+/F0NqSYaSgGO92uxYVzd36imPoNdPVIrDakP2GJ31Wn?=
 =?us-ascii?Q?mPNg3TLtoDNBrzkqNOrfcrX118ilGE8G89XaNBZaa14l8pW6daJKhZK267sG?=
 =?us-ascii?Q?h2q6MxxLp5CTu/LGgKS282tlVIPgtyGrl1EXKMlg1Sw3Hp2MnFVbboyY+USp?=
 =?us-ascii?Q?T2oj9aJHzju3B4cvc9e1TsdHA4nY1VB6cdMrc0CAN1RiSn+vE6l6z3LXsYpg?=
 =?us-ascii?Q?uQVPufamCGTLN4RN5WmgpOaqE4n/DGRh/G4A?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 06:08:07.7382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7751aafb-3d90-4941-518a-08ddc365f816
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8117

Sean Christopherson <seanjc@google.com> writes:

> On Sun, Jul 13, 2025, Nikunj A Dadhania wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Fri, Jul 11, 2025, Nikunj A Dadhania wrote:
>> >> Require a minimum GHCB version of 2 when starting SEV-SNP guests through
>> >> KVM_SEV_INIT2. When a VMM attempts to start an SEV-SNP guest with an
>> >> incompatible GHCB version (less than 2), reject the request early rather
>> >> than allowing the guest to start with an incorrect protocol version and
>> >> fail later.
>> >
>> > What happens with ghcb_version==1?   I.e. what failure occurs, and
>> > when?
>> 
>> SNP guest terminates with following error:
>
> So this probably isn't stable@ worth then?  Because I don't see any risk to the
> kernel, this is ultimately only a problem if the VMM is broken, and the "fix"
> doesn't provide any meaningful change in functionality (the VM is dead no matter
> what).

Agree, VM start will fail no matter what, just that it will be early.
I will send a v2 with updated change log and dropping the stable@ tag.

Regards,
Nikunj


