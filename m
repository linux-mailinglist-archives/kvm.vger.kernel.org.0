Return-Path: <kvm+bounces-55589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB456B334E4
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 06:06:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63C9C480606
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 04:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCF5242D66;
	Mon, 25 Aug 2025 04:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JWWDyZYT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066FB2BAF9;
	Mon, 25 Aug 2025 04:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756094758; cv=fail; b=HND3qPXeGWmDHpsA/RzBlGBFut38u06rnazIxAOgbhjBdaLJTEcx2TofSZUnLjQiwG6lk5yRArUHc6XH9oGMf/8b1s2vWUGPvhx7ULwgQ/Y8P3qvMKSsFlvwcJ7n5duHJTyEVqPbyUukXK0hhyP85h/iTv8lp7SbXq78l1tdCXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756094758; c=relaxed/simple;
	bh=gzi5rWP/oWu5r1O+qWyVJmZwLo2kxV2Fc7bAoKRn9qM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=oGTll1GLmGOtscjj6rLAlYb2vtviwHj6NkzVryeb+e/8Y20iMnE9MHLmT8hrPraFp7h7QpTt2VSmz5KUrpIm4UtvXRhP0pXjL4QzdWzhMBcApNdkm0lYAm7olNZ2qd6WggdZwtJ5SZzxN3aILFh4wJB+/PtZduQvJds1HSZtvSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JWWDyZYT; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eHec4I9x841rNNAlbRfQ70DlIQxeHV7hD67e9ADY3v2H1AaZpemJ9y+5tV7DN3BqQAzTgBzpsLOg6u6I1tXhwCm38QdHBxHjbaOWhvLpMYC1YlJwlfqQVoarvx83I8X2ek70W7waRRabpP0eEn2RMPeGZSpiiKZBAxc9H2pMmdF9JHxA7ReRXxnwOEpLryaYSYMhuTDLNVP4lvcXJmMx6j5fKFX7+cjKRWJHvRa+Ynlx1XifQDvMU2f/RHPFTWt0KrtWN1th6QgG4/4sv9LDWltU9x5tp5XNN/6NuiWdJQsVY0Zq2L25WhqbqpQ/Yuss4QrcS1HwhSa7QFG9HqmChw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iE8xXl+kiNqUBHcX4zRcgpnBxWdF7gs6r9Ch2Sq+NhI=;
 b=r2KdKD7HbCjxCwaq5SnHhoELfHApUmvwBPL4FXEJxxcVT9OCP8pmBThVh/iwvQ9rc8wPfenpQ3Og8Ol7SfQFAlmFxkKwNwjURodc7EGR9JbTwHctK4fGmbNnPzVvqNf9XP4F8cv6pdOEfCAW7vfI+hwvEOmOk9BYFuvioOSnMRBMMe5slItV7JlUolW1GPNLTJNO1Z/o3rKhQ9T/xsAAbJw1YZ5W8MxTiDEr9YT9BGe8kscJfuh2FsSjm4xPxkeKtWgpvt39166AIDdNBbHaEJBc7k8SRWb6c3OJA20XCuK5WoU5svLrVaME0B4ymRroL7ybxCp9x9J2YMYZs6+0aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iE8xXl+kiNqUBHcX4zRcgpnBxWdF7gs6r9Ch2Sq+NhI=;
 b=JWWDyZYThImtAB7fNL87DmbFURBUoaz7tJnQMRuyVcjCv6bewTWFQ4P6X2z+4WT+K4Vqdbc47v9f7oN0gGfYDsStx/4vMgaak6CgKjU8ZZXGPcyTm7SuAdItMbFjwFurdHpTQKFJQE7XtSJeGY/ycHiY6les7zJ7jLNLB1ZI++U=
Received: from SJ0PR03CA0281.namprd03.prod.outlook.com (2603:10b6:a03:39e::16)
 by CY5PR12MB6252.namprd12.prod.outlook.com (2603:10b6:930:20::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 04:05:53 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:a03:39e:cafe::e9) by SJ0PR03CA0281.outlook.office365.com
 (2603:10b6:a03:39e::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 04:05:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Mon, 25 Aug 2025 04:05:52 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 24 Aug
 2025 23:05:52 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 24 Aug
 2025 23:05:51 -0500
Received: from [172.31.184.125] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 24 Aug 2025 23:05:45 -0500
Message-ID: <ce208192-e1c0-4bcc-8c27-31b2af683872@amd.com>
Date: Mon, 25 Aug 2025 09:35:39 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] x86/cpu/topology: Check for X86_FEATURE_XTOPOLOGY
 instead of passing has_topoext
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
	<babu.moger@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
 <20250818060435.2452-5-kprateek.nayak@amd.com> <87ms7o3kn6.ffs@tglx>
 <87jz2s3h2b.ffs@tglx>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <87jz2s3h2b.ffs@tglx>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB05.amd.com: kprateek.nayak@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|CY5PR12MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: d32f4788-a45e-4b51-8611-08dde38caf2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2ZwRU1SNDFHbk8ydWpmdU5Da3NjbkFjNkVlRDF6M2RFZ0RrZkl6TkU1SzIx?=
 =?utf-8?B?M1Zyb0lhUDNiVlc2OEZlMDBUTnMzeUU5cm9LcFJJSnMvTE9DbngwK3RuVXo5?=
 =?utf-8?B?L0Q4MTRuWnRFQWZ2NXNqL1dpSFpNYWI2S2I3SmZpL0Z4M0RWaFZSOFlXVk5l?=
 =?utf-8?B?anNucENrUXJTSjJFZFBCbkpCZEp3bFBtZkFNdDliZkppTW9uL0NHeHFTTnhz?=
 =?utf-8?B?STZ3aVFsMTdyMVR2S0p6aXVlTEl0SmNUTHc5bkh1NG1maHZ0UFNETjZldDgw?=
 =?utf-8?B?TUFmYmZGMjBUdTBNdkRGVnNmMGI5UjcxSFlpYmVjZDlzZG45UFB5K1FMTWJn?=
 =?utf-8?B?SU5jM25reC83T1N6WjBPaFp5TkFYTFVXc0xjNldEZlFOR1k3MU56ekpyNEQ3?=
 =?utf-8?B?ei90cGNYTUJQRmVxMUJOWTJKa3ZxQ2RJRmVxOVNrVFBkdy9CekJjVjl4MjZI?=
 =?utf-8?B?ajVDR0ZKZEEyVXJwWW9iNHFMYnp1RHpKVk1UTXVldnFBNjdJcjQ0SmZYZzhZ?=
 =?utf-8?B?Qm5XQTgrK1J6ZjFueFNqZnNlNGRPQTJCZE55c3Z2Uk5tbG01STNKT2YvY3Zh?=
 =?utf-8?B?Vk5aTWs2dHdFT3B5TjByY1J1WEpLZXhqb0xseXZmbUJQNnlucVJoMnRPZVJW?=
 =?utf-8?B?Q3JZcHlmVG5JcEoySG9HdlpUOFVlbkFGdkhjNVlOVmkxbU9oZ1BWbXVPNVNV?=
 =?utf-8?B?KzUrMSt1eWFSK0RJdXJ6UFhlNGR3VFNRZ2c5K2NPQjYwY3N3UXdrZWJRdXgy?=
 =?utf-8?B?eW9FNHFvQS85RElJQ21oaktiN1BYZ1kzZXpyaUxnWjdhR0puaDNad0ZXak94?=
 =?utf-8?B?OXNQSGw1SXQyb25BWUdKb080c1FlSWdmQys2UFM5ZjYvdld2YUJ2WC9nSzht?=
 =?utf-8?B?QjN5UytZSlQwdjJCSFFHdmFHYUU2amFTTlRiSjRNdkdvSFVKOVBnSmhxdTJH?=
 =?utf-8?B?ZGFrRzdDU1VtdmdIUURHSDFyNkJJYlRVUGZpeHZ3amxjWjBrVWd1WGpKT0sv?=
 =?utf-8?B?alExNkJzSXVSTWw0RDNFUnh6dFEyWHRxOTh1NHR4bElINFZrdTRnNWZoSkw4?=
 =?utf-8?B?bkRjOTN2VzMzS09vYnVuL09NNG4xc2tGblloeVBjQ0IzSWhLSk0wRjRGZ0pS?=
 =?utf-8?B?U24xOWRWY2R1K2tPQW4wM2M2RmhtWUJTNlpWTjhvemVNSkJ3d295K3RqZzdk?=
 =?utf-8?B?ZWExQnBxNHJ0S0M0cHZuWGw5dDMrT1hDWG1pZDdZeWtSZm05OXQzQzVkUlFX?=
 =?utf-8?B?TWlFQXg4c0cxcFc3T0FhTktTY3RKbnhBYVR5WGxiclZnMVJpdzNQUUFGTW0x?=
 =?utf-8?B?eXV3Z29SUm5ucDI0eFZCOUg4alhFbUlia0kxNWl4RTNPMTZTZDdsRmlLQVNz?=
 =?utf-8?B?bmphRzB1dDd2ZHJJVENIM1FGM1ZXTFkwOU5LLzJPbGFvMXFHREJKbkhRYWhI?=
 =?utf-8?B?OW5XeW1EeW5DdiswUDV0WG9tdjhqY3VldG9OY0RIU04rWE5tMmloNjdYZ2JN?=
 =?utf-8?B?SnlwOXZpUUw3bVNCUHBpZm9JeE9pandML3RkSmpMMDdRRVBwKzhXdDhVRXVs?=
 =?utf-8?B?ZHlSbGFFZkx2eWRxTlBFZytvMTVvY1MySTF1eVFpeFZIZmJ0eDF3VkMxUGZz?=
 =?utf-8?B?QjV2L08zdkpWeUpKSnhCWlBiY0xMc0w5bDU5VE9yUTFvdG1tTmtiemVsNXh1?=
 =?utf-8?B?eUpsZmMzazJMQkxpSGNzSXRXUVdlRnhITzkrN1NlNEZwcW5WeTArbGVaQUdz?=
 =?utf-8?B?L3BGWEdqMmpCc0cxMEdRMkNSQTAycXVyblU5bzVLT3JmOWEzYkFWQlREQWJ0?=
 =?utf-8?B?OWNMMEFxMHNHTS9hNVhFOTE1czdsQU9PMnVHUy81ZG1oMERqVmlwUHNqUFE3?=
 =?utf-8?B?YkU4YXVOa2VlcGxZTlowTVEwNnhTdHNtUGc3MFNvWWQvUXlKd0R2a0R0ZHVL?=
 =?utf-8?B?NCt0SEExRVRlNUViVXpkajVuNWZKSXlpSEx4cE1PMmNqUFdSYS9QeTlBNVgv?=
 =?utf-8?B?VDQwNytBaGt3NktidSswdmlBeXJMWHlRbnNxb0hpSzVjNGl3TTFRYzFVZTIr?=
 =?utf-8?Q?5YK1mV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 04:05:52.8990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d32f4788-a45e-4b51-8611-08dde38caf2c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6252

Hello Thomas,

On 8/24/2025 8:25 PM, Thomas Gleixner wrote:
> On Sun, Aug 24 2025 at 15:38, Thomas Gleixner wrote:
>>> -	if (!has_topoext) {
>>> +	if (!cpu_feature_enabled(X86_FEATURE_XTOPOLOGY)) {
>>>  		/*
>>>  		 * Prefer initial_apicid parsed from XTOPOLOGY leaf
>>>  		 * 0x8000026 or 0xb if available. Otherwise prefer the
>>
>> That's patently wrong.
>>
>> The leaves might be "available", but are not guaranteed to be valid. So
>> FEATURE_XTOPOLOGY gives you the wrong answer.
>>
>> The has_topoext logic is there for a reason.
> 
> Hrm. I have to correct myself. It's set by the 0xb... parsing when that
> finds a valid leaf. My memory tricked me on that.
> 
> So yes, it can be used for that, but that's a cleanup. The simple fix
> should be applied first as that's trivial to backport.

Thank you for taking a look at the series. I'll move the fixes ahead and
refresh the current Patch 2 with your suggested diff in the next
version.

-- 
Thanks and Regards,
Prateek


