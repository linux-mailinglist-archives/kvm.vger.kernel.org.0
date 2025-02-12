Return-Path: <kvm+bounces-37948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A827A31D7B
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 05:27:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F106C3A7207
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 04:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FAE31E5707;
	Wed, 12 Feb 2025 04:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M5APhr1J"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD08027182D
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 04:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739334446; cv=fail; b=n73g/XGPpIoPYJ5671EessFXlIvM2acK5tOlVr43Cga9+Jml7qD5yrf/EpEE7C+g7IcpdbRq5uKj/1rgkGkPguQIWfaauegv+LGuwbsFPKxS5ZK87qAEHov1K7CaO5tEoNzKoxHUrviywODeNQOIJQbI3iXwYJV9+A42gWN19hQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739334446; c=relaxed/simple;
	bh=+H1WDr9XJIJ2Nzju4KdfMTThUaqbDjeNt1BmOeWbHPI=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oidPHOA1uzMB2xhekuOqMuO+ntfRW04ftwt+yaSPA97uFDNkqKAO5gnZOYBm9OxiYQODTuj3fL9ntx5BMSTqSa8Q0qHXKcobaI4R2iIhj7y4wbewSSvyPPeYQOCmHdHzsHWTb8U72Z0vX+wsqncJo63u4q1C60izEf+ihCetJis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M5APhr1J; arc=fail smtp.client-ip=40.107.92.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYBW9I5EOnTK1nhc7USLUhVbr9qv3/QYtMybAct4VLwZfu8RcySW46w6dQF/eTyUwTVCP7lBM5Msc1ocH8tiDBE/84lriNNBZ2euMi2VlqZDYqllFD4s+8L2I76j3Pm6sRJIDTMW9SQpvYQPr80xYv7wnywyZKD8OO6SI4xCTkVhvAtFPGE3rUtqBv8IkXvFAXPzhCPb4oux+af5aOdwOddPHvdKSeWc/3eqZQO/JpgsxqMArdbcfNewX3/cGgmJjV3IIeUq8LmmVPO6fzNyd0EfwnF/Xjo1CaC+M2/BqDONngALbGaX5bQ6J/CCJ5FPds1Ssi6Lw1kEEXJw4SHdkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+H1WDr9XJIJ2Nzju4KdfMTThUaqbDjeNt1BmOeWbHPI=;
 b=SJ4zMIN3+KwfM7leaSLjeakGR0XC9HEJ7MruYHg5GwZU7Md7vQXlGzQ+QpmRdYPQthVHG+3xm2DVNjkd5+tg0SJHKcMW+/T9ImXVoSAojB9ZaaiJNmu6EgcCh6ubppclzaqGi1UaB3D1BYOngx6esAxLC3G3oFmO3DyzH3MHQiz0ZXr6g0G7wDo5TPEtjIAVXmWclGED4px6lx9FfgMjCNDnxrUDRqPxoxHHsqk/r7jXlyTpRTlFs02Ai/pbbJCnM6WIScbDkz3n6ub5u/Snc+b3O8zMzte3JBI0cb9iQzMKvmkCqR0ROTpZgengt/6B9A28HGxuP2btB5s25yIMDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+H1WDr9XJIJ2Nzju4KdfMTThUaqbDjeNt1BmOeWbHPI=;
 b=M5APhr1JS8LA+jdYaCnLbCdTgAzjEkO0kWhwUdIVs4/M+gxoob710QgmFnsA/vCe2k58FlegTto62UvzjLILLhYvpQZyAcYwpKrBnVCZmS2Cgb4inztAB5+UgmHuA7oBembvNp+7a37IOXTifly56lDNPTc7Cyri0jHnsyE2Rt4=
Received: from CYXPR03CA0064.namprd03.prod.outlook.com (2603:10b6:930:d1::19)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Wed, 12 Feb
 2025 04:27:21 +0000
Received: from CY4PEPF0000E9D3.namprd03.prod.outlook.com
 (2603:10b6:930:d1:cafe::29) by CYXPR03CA0064.outlook.office365.com
 (2603:10b6:930:d1::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.12 via Frontend Transport; Wed,
 12 Feb 2025 04:27:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D3.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Wed, 12 Feb 2025 04:27:21 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 11 Feb
 2025 22:26:59 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <santosh.shukla@amd.com>, <bp@alien8.de>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
In-Reply-To: <f13c458e-d836-33bf-631e-e15e6c9f81ad@amd.com>
References: <20250210092230.151034-1-nikunj@amd.com>
 <20250210092230.151034-4-nikunj@amd.com>
 <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com> <85ed04ubwc.fsf@amd.com>
 <33fceaf0-ab35-cdcc-6e4f-16b058a96b42@amd.com>
 <f13c458e-d836-33bf-631e-e15e6c9f81ad@amd.com>
Date: Wed, 12 Feb 2025 04:26:51 +0000
Message-ID: <85bjv7u6t0.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D3:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 51a2db77-7da8-4237-1648-08dd4b1d8b14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ockLf3wU3NEcEGflCpCezm9IgbRyzYz0jwSmsTT3GY7984XYzGlvBO4XtjDm?=
 =?us-ascii?Q?uxuxPv7nktnO4guPYSST+f94dNgO1WorhWM79BRIzP6kTWzqfaHnVkG1gZzM?=
 =?us-ascii?Q?XvTNcHt4KvcMVR/OVn4eYaGL6KHqjgIwYIJ9PV56HMaMRN0+9ZFlnASdKItK?=
 =?us-ascii?Q?OhSPhJVQR1ThekhuHIFIH7poJCqEpJ71mCAF9lyVLct1o+nb8slldDghz8b+?=
 =?us-ascii?Q?NVuAOlmhQFyFXekOIL9AjVkn+lru95n20sNRhhP7YL1odwtb9rK2dypC2vAu?=
 =?us-ascii?Q?degnoxEYKZPXKXGZx8qCiK1iP2jogMqu8jF1oN+H/V4O5YNBNeNqyRiU6rLO?=
 =?us-ascii?Q?ymoqJTwhjeTJz0bMJrfiPb4KB0yxHVjbG8QU9lZ3YhWkdHUOrRVtrOcJVEuk?=
 =?us-ascii?Q?Cex1/iJygH6L+zEVDPaidU/fkmdFspnV22/Yn1Ke3F3hyHTRkNwO9+8AOM0j?=
 =?us-ascii?Q?DEoqafUA6oG19bUMgqU08kwkYkBfJTzOFcgsYrEovmRvhTiSHbqF8PWZVCh5?=
 =?us-ascii?Q?cebAjpNktC9y2XdPbk0gxVDr7/N2CCoaJVC2XiQbl7byXf/tpOKTRob6KWbG?=
 =?us-ascii?Q?VlsGojwKzanfu1VdippBA7dccSpNHO6ac6Q7PYj55hGdai+gLoIAECr9Snjb?=
 =?us-ascii?Q?povtCQIbBl52rS3efyVO/IW/NBfiOPGDC0su9mMkD+ZHA0UPrOtm9Ye3cYE9?=
 =?us-ascii?Q?qGkvRkxdZVrLbFgDSe7ZtruE3rdK0ZOoyldSWskvUErMNxHeRtYDFj1D9EKL?=
 =?us-ascii?Q?SuVGa8+BoWx6wvkn6dQir+l4i45CO45d+e7ZOvqifKZggfxHaQJr2qPJO3zK?=
 =?us-ascii?Q?lZnTzhSxHjhf1KSZZIxprT7u933iSW4H7HnWd7BT0+2oI8468AKA/1xKLCSM?=
 =?us-ascii?Q?I+MCeFNpMLi33Iutr3P2PtOJz4Acj7sHNnbNtgb+tjsE/YCeXVDfgw/9mukN?=
 =?us-ascii?Q?Z9KBji41q46xhOGfHjaANqm4pvxLOAv9CFi4oHv2qEIOpRM6+eqA2pK4jmWh?=
 =?us-ascii?Q?vvQjXlIxl79h6UgkDXHLBYilpWGr7o1kjWn0o5PYW7faMIPEaq5UdS04Bkkv?=
 =?us-ascii?Q?03LEqo+K994g95P9lYknkTVMXG+RoNQkcYD5LLhtpUxLedqvIQV+lgnDgBpd?=
 =?us-ascii?Q?3Z/BsGrH+3o0CAyW906aXmNAk+01TETycavSlE+8Gcx7THZQN4Z30Wm3p1/q?=
 =?us-ascii?Q?nsnJQ6GW/2M7Ll57PZGFWUfsbf7tGhTKBZOdmYKeEY9MIWLjtKWvhH+6WpXV?=
 =?us-ascii?Q?2BI/orPg2s7mC6yfht3Lt+Vox+T2926srryX9GjIfZJUds18712XHOOQaul5?=
 =?us-ascii?Q?PKstHqALjtqAoXbnGLaCty6X8AAbyB3SJlxdAO/EGDorAMtDik25ZwQ9oH93?=
 =?us-ascii?Q?gnwZrjcf8whj8HTxe3XxDzlza5ATPcmWC6jyxADiOSkKAqnZUfNxd+p0bAJd?=
 =?us-ascii?Q?i/j1fswzQjg36QnhLwmcxH6VryRQMq6GIn3f3kkYenkfkjsTdy4KlUkDx3u4?=
 =?us-ascii?Q?5Jg5I7Oe3Yzf6ac=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 04:27:21.4243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51a2db77-7da8-4237-1648-08dd4b1d8b14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406

Tom Lendacky <thomas.lendacky@amd.com> writes:

> On 2/11/25 08:03, Tom Lendacky wrote:
>> On 2/11/25 02:24, Nikunj A Dadhania wrote:
>>> Tom Lendacky <thomas.lendacky@amd.com> writes:
>>>
>>>> On 2/10/25 03:22, Nikunj A Dadhania wrote:
>
> Ah, strike that, the write from Qemu is just ignored in this situation.
> But doesn't that break existing support since we no longer call into
> kvm_set_msr_common() for MSR_IA32_TSC? This looks like it needs to
> invoke kvm_set_msr_common() if it isn't a Secure TSC guest.

Right, I will add that.

Regards
Nikunj

