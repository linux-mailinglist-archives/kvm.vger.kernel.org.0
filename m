Return-Path: <kvm+bounces-21670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B045931DFB
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 02:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 780C51F22250
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 00:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF2717C2;
	Tue, 16 Jul 2024 00:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qhp1IjFK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC2C322B;
	Tue, 16 Jul 2024 00:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721088814; cv=fail; b=YpQChqEF5vscgVc1eDm2awrmObWfvvn6cqyBrt5RzcEXwv1631XagzWhITRfdy1qFmh94lolpZ4ZBVwgX4lut7qgImz1/EKZpoYr8WaG4noB7iMcwrRmIOJ/zpKuiqu2kocTbifX0TkjsKoC9UhMpdNpqF4R8Q1AgLHvkoUzfoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721088814; c=relaxed/simple;
	bh=sbQKI6YD2wWvMZbTv70AUyXzqK6I70eL5lrhN3ZBvDI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DKDJKu+TamT8+/LEUmuI2YpzZNee3uLn4AAV+3yvd5oCBeXc6tq/C+8HhJxQk7s6d54gvDiv246JPzM0+c1ixaf5hlFUkyCbP/h/7u7K1Gj8G1ySFmJ6D+F/yFZn5mrpxyMUUQKfofGoY+A+0mm5eRXC3XxHUj65KJMnsyqBrso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qhp1IjFK; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pf4QZkXoM3BGJALoq+CBK9hRZPWRQnNfvB+Z8drJHe2HX9ZLZnLZUdJQ4jVdhBYoyoLn6yBmnHV2yc/gl+KzWcTuLFfCo92tLwiZ3Php+ldIf/+wpoVllmzQshtHEi4yst+y9Q+H2BTDivmmk41aDfqNP4tquknjtcODIg+y2EioVuZmE0C0FSQiVsnU2yAwWeCbatfXZCGzhR1+yp+bOP4FZiIHDC8arjpyTnU2WjedSqbPz3SxQWiGVpZFHhT2+TID7loTU/ikNGVdp5C77wwnc53Zk2qsbwDKP5X7tMsBC2kR6/aFRyZj8jgWJW1gCPTfDd3GD0oRElghZwDxpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RK5g6dkiPmeQWqloFtJt+J7yiV3QF+cYZgW+8+Rmj1A=;
 b=X3ajSc3PkckHyAOxZVWwcMpAKj/o2pqLH6JlwUlpmpkj/ByI1Z/WMY0E67QRBF6PTgzwaktKCMZ2KF6SlUWGxwF2Gkc/KJz4SvM3f56jLz/MkXqiH9/JfU0G08eInuY3H+3HFMDeQPIDbtO1r/yrY4gFvoR/KTca26U7OiKwp3IS7W5vkwNL5GxHRg+Ozo0jGAUe391gQivz4I5YtfJUc2jm16bOpO91oyLy+BP3wkWZLMNlG+G9o7++CW1dRoJyxpIllXNvSPpq4F7tP1ZtoPeZHE1OBxvHkyNBDZ4IIttWdP2RKl8Ju1rnCwjzaV/BBW9gYoaQi/GNsX963b9XZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RK5g6dkiPmeQWqloFtJt+J7yiV3QF+cYZgW+8+Rmj1A=;
 b=qhp1IjFKz7Z6JIFUlUz22/tkCbZfTKVGAZgvowWp0O5Y64PxNVCfYmBciabc3atnfJwhIG3LBw52lsgObEm9QomOF3Vrrhr3vBIcslBxja0EmbxQ4bXJi10Rlw8qFL4zza08xI3QPNtMxBQPWAIAkOuqMhKHUAiCcBMPJhdlSqA=
Received: from BL1PR13CA0372.namprd13.prod.outlook.com (2603:10b6:208:2c0::17)
 by IA1PR12MB8358.namprd12.prod.outlook.com (2603:10b6:208:3fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.27; Tue, 16 Jul
 2024 00:13:30 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:208:2c0:cafe::d4) by BL1PR13CA0372.outlook.office365.com
 (2603:10b6:208:2c0::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14 via Frontend
 Transport; Tue, 16 Jul 2024 00:13:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Tue, 16 Jul 2024 00:13:30 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 15 Jul
 2024 19:13:29 -0500
Date: Mon, 15 Jul 2024 17:26:28 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 01/12] KVM: guest_memfd: return folio from
 __kvm_gmem_get_pfn()
Message-ID: <l5ppmzfzdxa2iyuhx7xwkhw4ztes3lucfsflrjkzjniiozatmm@dld6drmhfbt7>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-2-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|IA1PR12MB8358:EE_
X-MS-Office365-Filtering-Correlation-Id: 1af37cfd-d97d-4fb6-0a15-08dca52c1f5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pTUh0l9ZRm/YI5OQBzYD1DF+yhGnv2OU2QQIAMmf1bpGicvB3CfEJh5YxEaU?=
 =?us-ascii?Q?LOfBEukhQQT6K1jyqc1qGPbelwoIAFnd+kmk0T1lR574J9IHISQjMPULeUTH?=
 =?us-ascii?Q?/EjvpLN8OZqiknBP4aJgH5vlpocLTSNuGU6vdYjpgl73i6XpWoi59Csn2Mlz?=
 =?us-ascii?Q?6l7UPhpry+qpTWkFbfab3x8Irnxo/mJ9fXGmXl6xl2ZOiqL2eqemzqN16PZO?=
 =?us-ascii?Q?mJ1FR2MCU0xIfXt/ezFBP1HttRzTPWwAO3700ykqaqNbEfhYcY1zl0+OFoNp?=
 =?us-ascii?Q?weRPpVDreGAgnHAtP5ZkbRCgkXILvwvA1/E0G6VAsIIezoXwNfN8EDBKL6/s?=
 =?us-ascii?Q?MqBYJ0f0VHgXJptuhd+XDP7cO38+8O8WatRrdFs6ugTCeww28PtRygaMzGdK?=
 =?us-ascii?Q?yLg21mrRbpbDtXsRPtubSEIWkOyzxu3ctPvq0sWvmw/YjJx+WSNtUTIjtx96?=
 =?us-ascii?Q?TWtSK0yEEF3x3P9UlIgo8cMEkECKdjPFe4yzB+XnBc7tYrE0RjR8KfTOg5VZ?=
 =?us-ascii?Q?XsG/MHAZO9v6qeDLrE60Em6Eiro6iNmVPqK6yUNJzydtUT3ktDwp64pE/mzP?=
 =?us-ascii?Q?RDWQD+6x/z61Ljul95JSE0FsRoAeHWVhilqLNDVNZw76+bCAIXoc9NX9dXpp?=
 =?us-ascii?Q?xV8wiFXJuvqYZN1X/Alg3+FT8yYAF/BkOyfLk/IduI09ObxsgVGSAVUXq1g1?=
 =?us-ascii?Q?f33jRWkobEa8YN22pa5Rl39lv41W/12LsRNb8TzWmV+p7pplkhSnc/yAtdnN?=
 =?us-ascii?Q?gBXYo8VheMTxliIlIBz6qghR7CzUsXLPI58VA8eFSy4Krrt+zH5RxWs/8MkO?=
 =?us-ascii?Q?HSdgYBiuE8ffNBmrlA/DMjzYhgLUZlM4XKVWIBRzzLSeSaRimsEGO34xDZaE?=
 =?us-ascii?Q?MCwUsDZADUZgVGdt+lb8DC5sN5SJcP0QQQt7SwjngBOzf70mbFuXwWlT+xyp?=
 =?us-ascii?Q?smK34T/kRVHgJX+GVLyHdetp94BVY37kCoG8yPrt9AYbjPEeKkWk0tTuoLJl?=
 =?us-ascii?Q?VbDebgRIfo5Q3qq+alRuqMwgnwegWZ02joIR4S2pm6Mt6crTFXZTAdR44PFD?=
 =?us-ascii?Q?YlVpS+ZuolthDDqrTfzgsywkRw94MPhDQFhhbE3DEfoirpX/Co1HWCMxQUT1?=
 =?us-ascii?Q?PuldxWdtjqWI/9uJIwdozVqOmdyFle+pOVl0QaD3LTCnDw/yHe888sbzTJVs?=
 =?us-ascii?Q?MBDwzmQpRz6SP4t8YbFc5hriNNxfRWQuwPrQR1gn5VJQnFa1iOayivwyF+VJ?=
 =?us-ascii?Q?iRSUpFC07We4wxPfzlHuR0j0lfwEDSMo4hjxOs+lYfzgMzq0pjmlxwTo58X5?=
 =?us-ascii?Q?aaL181R4E1MBOy2ncfW8Z2fTukJLMok1irPbBRFWPp6hT32jrcVY7ZE6R9C9?=
 =?us-ascii?Q?bwH2kGpBM4FY9NSD4mlF+qsKQTB7zhD/bJ+2EIbe3Wxfed/BxirB5/o937IN?=
 =?us-ascii?Q?qwqOQEGo42HV696SVlfjrtK13lhD4A+P?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 00:13:30.2281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af37cfd-d97d-4fb6-0a15-08dca52c1f5a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8358

On Thu, Jul 11, 2024 at 06:27:44PM -0400, Paolo Bonzini wrote:
> Right now this is simply more consistent and avoids use of pfn_to_page()
> and put_page().  It will be put to more use in upcoming patches, to
> ensure that the up-to-date flag is set at the very end of both the
> kvm_gmem_get_pfn() and kvm_gmem_populate() flows.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

