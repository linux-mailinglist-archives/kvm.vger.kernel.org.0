Return-Path: <kvm+bounces-55602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE9FB33894
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 10:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3ACB52022F8
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 08:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E6D28C841;
	Mon, 25 Aug 2025 08:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cYG77BwA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2066.outbound.protection.outlook.com [40.107.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B643A1FB3;
	Mon, 25 Aug 2025 08:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756109895; cv=fail; b=ZJrhpOAhZyKt10yt9hXaN+TjmIHSqd8bKal26mWj7ZtpsvsDNJfr4v+VZuIqbWsK14EEGA/eJg6tUZ4amOPLYef6mbfsqly/lzdK5duTjHAXcCkSxjkHkTTaWjR4yCiq2psNeyAUDvthDYQDzw1xIN4dwoWrcder5chtIb9Fi5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756109895; c=relaxed/simple;
	bh=bAPu2S4pY8RAOww5avJOHshppSwX2HCFayBlXBBPWYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=E35MJhDG4xxJ1s59//lOJd+sjMW1C5i5vA1W6/VuxU1mGDIFNDobeJnm50e4aJnIRtEtx7fEVJkr1iioyUGRMnR2H1zv+TcRozX4Bh/a/Bz8jp2Ae9pvdtbCui0mZ34cjQb9KKP2sPQdRojkGQD5T+HlPy11LQzX41lPj3RyUZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cYG77BwA; arc=fail smtp.client-ip=40.107.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BjQrFsuwyYsAxGldVKWmrF/Wi3yYcG1sRBdG0ysy9iG/O4l6KuRvmg76crSvRgqbYiVLXVhCBX2ZufblhXthAy7b1XAWO5L5GGmTJ1te4HgN5DZRwx6lq0M17vyHfbh38orCgmPDifJURkEkigPBxaAUX48UWMIoEXCTYde3P56qs5rTJFT6+eihKGbCK6UHYtBwA2NJZNK9yTB207QyrDPzEQr93z1q3OXGymGyJseQX5EQ/y57hdlzZABUzVp6aNBNtO6FkZhCsUT6ZhSwUs6MLDfaKlO8bYy/Uye+SkFS3EqS5t+yMqEWYWiy7QnSvb8cZ1b+59PbohPkN5aEqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2KZzo9RkfSTGwydaDkYH76GneYMcYK2yUFQjOYOyeU=;
 b=DfEW3sGzNhKCuXvZ+CLrl4ccLE3Ut03OXd+YbRLu8Ff5YkQTD7rbzs9dMUEB+3Bctaq6+DOicJ2fbIWubGBB/Ff3TKJvt8IohzMY5ivfXrtwCUFj6jebvZABqtI9+SUN0J0908O2MF3ZIrKwutbK166RyHWhn889NhndY1E1UWEZhC9lUhLVu5OLrTd1gpASJe5xSp4w+Z+Bjsgjeea7bkaeBMz1k1aWai7DYzTc36Gyrewj2yhUmqLw9hHQtelKo+34hy3i+hII7J3lN7e0b+/Tz8/vA1WR7vISwNEFwVrHwJUhwGtDpc0GyUzYla/bZTU7X96Bmhzz+gWTTIJzYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2KZzo9RkfSTGwydaDkYH76GneYMcYK2yUFQjOYOyeU=;
 b=cYG77BwA85WfWZF3Ufgw80iuZQVafZLLDbq0IrVQ1kECaPtf0E6Mqi7L5iZp0+SZhaMTIPYs69nhF6tPZJZZebeis0cwtg3/4XAHlrzSCU73tdE6sz8chb1pyNOPl0psRSqVKzX6Fo4hF7tEfyPy8GTcQ9li42hADW+15QJuVLk=
Received: from BL1PR13CA0434.namprd13.prod.outlook.com (2603:10b6:208:2c3::19)
 by CH3PR12MB9729.namprd12.prod.outlook.com (2603:10b6:610:253::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 08:18:10 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:208:2c3:cafe::f6) by BL1PR13CA0434.outlook.office365.com
 (2603:10b6:208:2c3::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Mon,
 25 Aug 2025 08:18:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.0 via Frontend Transport; Mon, 25 Aug 2025 08:18:09 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 03:18:07 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Mon, 25 Aug
 2025 01:18:07 -0700
Received: from [172.31.184.125] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Mon, 25 Aug 2025 03:18:00 -0500
Message-ID: <aa5cb79b-914a-474c-9015-e36d54149cf8@amd.com>
Date: Mon, 25 Aug 2025 13:47:54 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] x86/cpu/topology: Use initial APIC ID from
 XTOPOLOGY leaf on AMD/HYGON
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Mario Limonciello
	<mario.limonciello@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Naveen N Rao <naveen@kernel.org>,
	<stable@vger.kernel.org>
References: <20250825075732.10694-1-kprateek.nayak@amd.com>
 <20250825075732.10694-2-kprateek.nayak@amd.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20250825075732.10694-2-kprateek.nayak@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|CH3PR12MB9729:EE_
X-MS-Office365-Filtering-Correlation-Id: bd534f0f-afa7-448b-f830-08dde3afed42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eUxaM3FpSnVBYXE2d1dsaEJLRThHTGdqb2VWbGduT3JHQXZlaCtrY2VvMTRX?=
 =?utf-8?B?OXBDc0pXVTQ5RU9RQTVnelh0MGR0VU4reVVESVMrbWJicU94Y2UySUpPTGIx?=
 =?utf-8?B?Z3A1Njd1SUxmSFBwcStwSFhrTFlPR3JqdWNoeWR0amVSNHkxYllRRklOS2Vy?=
 =?utf-8?B?UGRDZnVlQk5td2VOSHZLZ1FBNnlaQjQvT1JKUmFmcWxDUnk3SnRhaUxoQ2N3?=
 =?utf-8?B?a0F0N1NDdi9MSnZ1K0t5eG9kUmhtSSs1VkgwVC9EUC9Fd1Y0M1VZVVRqb0U0?=
 =?utf-8?B?RG0zUTh1Q0dpZkwwQ3Q2VDJOQXR5ZkhSenJhNUhjbWl2N05uTGZEVWJlamh5?=
 =?utf-8?B?QzIvQi9DZzhsN1JqVjMwc2o2OHhHTjFYa1gxaWZ0VnZlaWZsczFQSFpTRi9L?=
 =?utf-8?B?Rklqc2E0ZUdIZHVMZ0kxekh0bWxOcjhuaG5TbUxJbE8zQVV4WlJ5NUo1S3BI?=
 =?utf-8?B?SG53aWxPUzZBTWJyV1JodWVoUFlucENvYzlKeC93VWRlTTArcjd4NHZpRURQ?=
 =?utf-8?B?VTNFNk9IK3pvbGpxSU9jSWNLNUJCOGtvYWx2RUpVOWxkaitjeUJTcW1oaVlR?=
 =?utf-8?B?UWI4N2R2dEtmcis4U1NLL3I4K2hVMGhNaWRCVmVyeStNT2hEWXFweFNYOTl4?=
 =?utf-8?B?TnVsZzdQU1k2UlJZT1VJVk14NmxoeUZYWXFyWHJieEh1QkxGNmZDOTJaMWFF?=
 =?utf-8?B?MGkrY2xJdU4xUGNTRXVKYmZzcms5Z1gzekhNQnVscFQrZmsxZUd2UnJhOFl6?=
 =?utf-8?B?dStSRmx2Q0ZnbjZ2ODY0SFVBUWlKU3B3MHU2QyticWpkcGlvRy9iT3RzZHBZ?=
 =?utf-8?B?dklNM3FBZmhsMXNEMWtNc3hqQlBtNGF6cVBVQWVEbitRaDNEV2hTaHhVM2xi?=
 =?utf-8?B?SUV1czhYd2xqMVR0ZjREUnBJbUYrOFFrUGxOV1M4RDFmWFA1UjdiOHV5d2NW?=
 =?utf-8?B?MjUxOFJubXVscjIwbS9wcHNhQ2Z2QkFHcWQ4Q3dBTy9ad0RCQUVIT084aFZ1?=
 =?utf-8?B?S09mQ2V6VGl6clc1TmF4WDczN1hSUTZBdjJaNnB0VmNwamFNbjZSQ2ttSll1?=
 =?utf-8?B?QlRlamlBbXMrUnBhaGs1dkgxdC92WG1BcHFaUHhwYURIbE51bzlyQWRlYldj?=
 =?utf-8?B?WGxGc2JXcldkUGVNd1JXVlMvNDI5S2hXRmlTdjhyKzAxK3g5QWgwU25qcmhG?=
 =?utf-8?B?OVgra0I5VkR0Wm90aEs1ZkF6VVJzWTVyblV3bDljRk5LZU1ucnJrSStKWmlK?=
 =?utf-8?B?Qzdta3c2cnhUUlYrTHpTb21oUXU2ZXJsTU95WDVjME5xVDNuMld2TnBvejRE?=
 =?utf-8?B?QTZvSW9mNXM3c1BEdHRkUG5kL0pNRERGMEpaajVVaVRVOS96aUY1d0JmVEdR?=
 =?utf-8?B?ZGJIWmJpdWIvNFBHSmw1Q2M3TEN5TlJ6MUw3S2p0dHp4d3AybS9qbGpjQmFZ?=
 =?utf-8?B?Z0tpZStIZnAyUlc2UFVEd2xvSndoeWc1SFZTeXc1QVBzNkxyMmV4OGpubS9N?=
 =?utf-8?B?MHdoMnVDQnZkSEcxRTJPcS9LZ2dIdWV0MmpBNnlPU21SR0lrS1ZwTCtTZ0VH?=
 =?utf-8?B?L3UzNGxnVndENENzS3FmaHo1RUl4dlBmOEVqaHlPWHAxK1phYTRpbkRtWWNL?=
 =?utf-8?B?MHkzZXkzbWNSL1NMM0l5KzhvT21VMzc0bk80VVpvdXkxV0ZydlRPS3hoZFhL?=
 =?utf-8?B?RXRSRlU2UzRianYvSUU2a1gyeHAyM0pHbnFYY1FRc0l0RTFNSXJyelBIamUx?=
 =?utf-8?B?SnFvNjlEMk5IcEUyQlFBbEd2cXViak9YT1B3K05sLzVGR1AvN082UmNrVVFS?=
 =?utf-8?B?QWRBbTVXbGtoN0N3VGh1czdQSWFnTFMyNElUdHc4YjZiVFhpOUJkek5sQTdn?=
 =?utf-8?B?Q0tMVXZuQjhsbmZrNmIzT0kremtRZXZmZ0pWK1A0MkpjVHZEN0xxYkZ2emtB?=
 =?utf-8?B?dTZOSzJ1RjJLZ011UVYwRW00RENSVlg1UCtSZ3FkUXJWa09maDdDaStvNU91?=
 =?utf-8?B?emNIWk1RQkE5MXh0VW43UHV3Y2xtekcvWFd2UG85Y0J4YUo2dXpwRWU5d3BM?=
 =?utf-8?Q?XnAJRV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 08:18:09.5427
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd534f0f-afa7-448b-f830-08dde3afed42
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9729

On 8/25/2025 1:27 PM, K Prateek Nayak wrote:
> AMD64 Architecture Programmer's Manual Volume 2: System Programming Pub.
> 24593 Rev. 3.42 [2] Section 16.12 "x2APIC_ID" mentions the Extended
> Enumeration leaf 0x8000001e (which was later superseded by the extended

The above should have been CPUID leaf 0xb (Fn0000_000B_EDX[31:0]) and
not 0x8000001e. Sorry for the oversight.

> leaf 0x80000026) provides the full x2APIC ID under all circumstances
> unlike the one reported by CPUID leaf 0x8000001e EAX which depends on
> the mode in which APIC is configured.
-- 
Thanks and Regards,
Prateek


