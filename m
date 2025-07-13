Return-Path: <kvm+bounces-52244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D89FB0317E
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 16:32:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37094189894B
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 14:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B1FE2777E8;
	Sun, 13 Jul 2025 14:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kOFOtmzK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8777B367;
	Sun, 13 Jul 2025 14:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752417144; cv=fail; b=MFuWPoGOPcOB42mFC5EkMR5evpDUin9b18yo8R7IQAfQgHwqmSFdzU/wLoEyUOk4KSu0Ni5njsWVgrrm2eMlhWapvOmyCfgC01rnAovXaPBovCLDR0lbGgJeRJE4Wg2rI5NKo/+YJemOVf5DKh9jf6ZPvrgjyv4cTJcNV6nLEKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752417144; c=relaxed/simple;
	bh=aUVBW0DzFjqQuxDSZnxh4p07lcz5tc/x7hs+1M1cRa0=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bJEUhsPsjUqdSAgbiyhj1Ztvk1c132zM2ZfGn/86U6QtVlikyqe3+YZwe79EyhDJ5nb+ODIGpC26fhtjLeIsKKdy1BgqzvpaICg00UVoQUTUPmhl8ZZqjBk2o2+IWJTq8WEco1jOZ7OJcarZH3g+HSSvuVJauPVushCUgaX8ySw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kOFOtmzK; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=njHn0R2DASIAuRuSUki/gxylUhybRZPUElYCXg6rOwd/fXMgkF/PIbaSQtwW8iE6OFzDwRLBKlDJieYuQKAPVPTydag8XxTBwsnQQCRTQ5/FnpgcNPEFXj7ih/QvVWBonMbkge5RIl0PJhQGzDJbdVTihb70Bq+DKTB/vrp1EnXb1D9I7Q+G2n31Ff/CMKnN/KvF+1D79Suw6NUEc4VIo+lio9GTI/UjzLAYbeDNct/d7zLAViaYMSE8Ni/6PNydUaBD3xtC5dzeyw8EaMpVZO7p/LYEb0bUZseShL/AwekaEvMhrxIiqtCsEad9I5joTF9B5A866lfgsrDrKbhTCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ud6m6QmDZpQlfB55tYbFFjR1KXOHcPWAHarClJLmlsU=;
 b=BxnIXA5F+RCLYf3cDmQWOoEP6zj0Fjp0j7vlWprqZolZRIPNvb0etDntDiQQvvQbdM7t7KzMsH0UywSb5Uj5lNZrIIF/Qol2CMAr3Kp/PYiG+pJ1G6XYua5HQpOrM2NwMsgjoQabQ9wQmieXkxaDV8uS51WU/5t+CGvEF7bHo0F40G5SALlBH5mOSoTbiAPtWZUsQKEhAtTvISq8xoy/ebGWEDEIxAax/doKY6BVhhv+HlfsMl8jGpTZzurWtDzJwJsAq2V1xcN+ppywB/3LNaeMoFDuGsVLKdVzsLXyOfUs6ErjUxRmQdnvZoZREcKnQ3d7+98EXBpE6YQJ27MCsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ud6m6QmDZpQlfB55tYbFFjR1KXOHcPWAHarClJLmlsU=;
 b=kOFOtmzKsFhMGrfywV6Xls4GY2CwMQEPsyryvStzuuTbcE9Vk+5KAMuWQ6Qa7DQkfnbNdyWMKocEtelehYe93X2Q5zr2FtrM3Q8bmHFIpaZKtWmU/DnLmUi4rTO0/yOabFXc5MrMYkEFcdVryCv6cx1vLKKjM55lELVTz4fVxjc=
Received: from DS7PR05CA0067.namprd05.prod.outlook.com (2603:10b6:8:57::12) by
 CYXPR12MB9388.namprd12.prod.outlook.com (2603:10b6:930:e8::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.28; Sun, 13 Jul 2025 14:32:16 +0000
Received: from DS2PEPF00003442.namprd04.prod.outlook.com
 (2603:10b6:8:57:cafe::33) by DS7PR05CA0067.outlook.office365.com
 (2603:10b6:8:57::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.14 via Frontend Transport; Sun,
 13 Jul 2025 14:32:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003442.mail.protection.outlook.com (10.167.17.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Sun, 13 Jul 2025 14:32:16 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 13 Jul
 2025 09:32:13 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, Michael Roth
	<michael.roth@amd.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] KVM: SEV: Enforce minimum GHCB version requirement for
 SEV-SNP guests
In-Reply-To: <aHEMmmBWzW_FpX7e@google.com>
References: <20250711045408.95129-1-nikunj@amd.com>
 <aHEMmmBWzW_FpX7e@google.com>
Date: Sun, 13 Jul 2025 14:32:11 +0000
Message-ID: <85ple4go0k.fsf@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003442:EE_|CYXPR12MB9388:EE_
X-MS-Office365-Filtering-Correlation-Id: b5f193c9-1eaa-41a7-69bb-08ddc21a10cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/8YJuhUqPSLdYFigmSAn+c75t+8xuAnhuyY/vNLBDwNQ3NL0VfTBcixHfD3W?=
 =?us-ascii?Q?r10KknVgD4jpyO/B4z7dj+NuWwQKYlION05FVO1X4V5m9JwGf0f+gLnmrVfZ?=
 =?us-ascii?Q?sXUYo/JrLsbcBhZT9GnkET2tgnDio4Mq+Z6cASrxU2h7C3Jd+rvy87+y9pI3?=
 =?us-ascii?Q?/dGIcAgeVkM/RDVfhD7Lvu11lycUypRXvrzTI8U5jRJraGNqF00uM8oNRWnu?=
 =?us-ascii?Q?t5OSlZ3v8b/Eix3khXJnbdcWAhqPyL69yY/MXnMpVeyYltunVg9BexxayAI4?=
 =?us-ascii?Q?KuTYpgJftxu8T6FqWqe55l3HO++0VfDtBAUvJdpop1m0kjY0YPBxyQYpOeAy?=
 =?us-ascii?Q?D6J+cWpUlD40Q729I57cSgBI/UpyLbH8rBrWrWYNkdh0siVDU5OluOtxVn/L?=
 =?us-ascii?Q?1C3YsDTGDnwz13COm3xID/WN+JNEtGpjZB2uGyR1cFbGIDThsZJ89Vy00QM9?=
 =?us-ascii?Q?LZHNypBrqV1GAc+y4cSsqxRTcHr6zwAoC9Abj/MLEaa69jecP0TXHSTxW+r0?=
 =?us-ascii?Q?SB7F8am+eTgoOPksdETNl/Z5zFu/WUgs5Pd7So5s/l44UaizhvAyyUi1AYJv?=
 =?us-ascii?Q?e2YJw8slWaMEWb+2Tm1pBg7pxpk08R3Dlx5w5+Rd0EGiRIoDbSgbR77eM8Pk?=
 =?us-ascii?Q?XzbKHPxI+QTa0dtMDEMmAISBrkLkpBE20wXiPVXeETjuwr08dLAYkjIBKPXq?=
 =?us-ascii?Q?1vjiAFxjTQdMLNOs9h0rIIOR7sKAdknbi/padvrCfcWGrqezYHJcDk6QLz2s?=
 =?us-ascii?Q?VoUMFVi2KzsiJwRH9aRaDKZBxq0W2d0ich0oNp71RcEaFJKCluH4WzFy5gbJ?=
 =?us-ascii?Q?ogWKqQ441qF92PQvxcb70/Hwc8KYzRprZCO04vqLMpTkM0TwuMR7y5ijM2n5?=
 =?us-ascii?Q?sE9uRHhT68PE/oje+ySu6VaZzVIMlRAZJVim8iB12uwvHYnsajlYe9GuU1OA?=
 =?us-ascii?Q?m8OLWqwza7kbLjEM1hooi+z2NOaUWtIevD6OLOLN2NHuE5lwVuoH+BO/W/dG?=
 =?us-ascii?Q?qWaHwmsBY+Pf6lVGN9JNReQ4qf61cScR1fAxq1KmpPGHAFil+wyLEFjneOmc?=
 =?us-ascii?Q?GCl5mt6Z4ycFXeTlzalZN5w83fA2u3sSS8XxCrZeEPeMl5htfZBS1i53mIJn?=
 =?us-ascii?Q?ATy5Dc6r5AgNGa/zUg6s8YVr0oDS63tX5x5lE4oyBEflhfxPQTnGws4zRSsD?=
 =?us-ascii?Q?AERLSbUFYPPcRqfIc9VNJztT2TpMocoggWcCRjQsM1Z154o+CvHuhaYk19+q?=
 =?us-ascii?Q?GK0EIusaYnO2jtlDebo5yzAc5S+TG/npbqrQspounKDbFrrPGFPYoLbVawoI?=
 =?us-ascii?Q?VuW86/Onny+diyuReQUws0UiBiAto9K1GwU2m2WdDUTPUIAnr4W5B7kPYrAw?=
 =?us-ascii?Q?ZiF9NrtlTXqUmCGWvW5ZAae6eLKaCsoIq5YAK6ZMX5LexKUIrhQNNRV0QRb2?=
 =?us-ascii?Q?knDFoWS1Xka+ZrxMWPmcksKVevEmFiTYCg5JSoppMY5I14ZLkuBySGg62X/X?=
 =?us-ascii?Q?X5be0TzEhXGYq0auJAbAsTLqQLFxTXywHcQh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2025 14:32:16.2362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f193c9-1eaa-41a7-69bb-08ddc21a10cb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003442.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9388

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jul 11, 2025, Nikunj A Dadhania wrote:
>> Require a minimum GHCB version of 2 when starting SEV-SNP guests through
>> KVM_SEV_INIT2. When a VMM attempts to start an SEV-SNP guest with an
>> incompatible GHCB version (less than 2), reject the request early rather
>> than allowing the guest to start with an incorrect protocol version and
>> fail later.
>
> What happens with ghcb_version==1?   I.e. what failure occurs, and
> when?

SNP guest terminates with following error:

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
Code=c5 5a 08 2d 00 00 00 00 00 00 00 00 00 00 00 00 56 54 46 00 <0f> 20
c0 a8 01 74 05 e9 2c ff ff ff e9 11 ff 90 00 00 00 00 00 00 00 00 00 00
00 00 00 00

Hypervisor logs the guest termination with GHCB_SNP_UNSUPPORTED error code:

kvm_amd: SEV-ES guest requested termination: 0x0:0x2

Regards
Nikunj


