Return-Path: <kvm+bounces-54545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F832B23770
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 21:12:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 022E86E7A02
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A24622882CE;
	Tue, 12 Aug 2025 19:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="15/UvXHy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AA21A3029;
	Tue, 12 Aug 2025 19:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025877; cv=fail; b=bXeYopJszVhQtG2AZy+TydIJipBT5nwO4FpmzB0F1PEsd/c8ZsP2e1x5Ni12zQ9n/l35YacEFU9PW5JKzcNLI7vuanfZpzLbY/v81aCSOMFFk3ilUKb6HpKzmfLt+4zhp9MQ2X6bV+1pzleAJs+qJKZg4RwRu4eqaF0VNHLBj/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025877; c=relaxed/simple;
	bh=8iXdeAkGnsUtzz2pQ4MpFPeGBwrFOd3/VI9klWAGpq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UlldIP/k7O9/gDURTRX1YIsgVKrsVO8OqjsRqT/wueYRoCTBvSVQjkqXVkqvVgqfUBnJV/q2HsS+919nby54ngWyGNaAh1hyj7ZXORCLyu+0byKBpJpPuxhmuUcTXrIJMDbs8zOCVmoqGQdaSeg7WTcM2NWMocwb0JRSna//CZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=15/UvXHy; arc=fail smtp.client-ip=40.107.236.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BW7Zhteh+A2/b4ztbK0Op8yNRhYhGu6rMT/7YrsYmE/Mxxhn4GJUoq5SlbsWJ22fcKRKTCdXHm83LMfZCC3MWUBYnPk4jYPw7/eQyi+x5BLHaef7IN8ZXanO+ehlz6cntSNupspAEPeeHXVVKgbZHWVcyhA7Hn7FM6noQviIcybt6K/yp7Wui+LcWR0NXx/YIs9GNXoHgJqfy2uGzwlyzyOFB5/sYnkJst0U/N06iXCdRFYvSzZbZ6FnkAhI582wfIMsSzAh2WSpBdarVX6EaHFjKAM9c+/OXZ6rBJYoezoTOxi2CzhE5WgLQUZfaZc+wNQy9gRq/njYJMcd+hqBpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGZOeSPoW1Pov5wO3f+hMPfD6ITI3APpxwzHxHilsKs=;
 b=PotE/wWGgKTYQwCkKXAo5OxmhMMjGuM7yajEZCBWTjd3xuI8MxUqW84ZJnG6IvXEZLliqkdqkyYTEdSE0f0ZqcPXBo4anDFlF6vjXels0XFCGbgDFbqC2yYC5qbNGkWTOe+fTumcvEAYK/MmirM7tg9hqgPgrSrWFRmmkb+kILLRQI3ftYsK8OC3/Ejp1pd4WWCfbI0r1L86qyL/gIRHUVJjejPzFWT7/wIFEjXogRy9PfFJQ7gvYGohCnxwDdO9jPFDFMaHWqFF/MZOvvaSLJcDo1xtpCN5LHfxomEN3D1XByUeGAXVrq8YXw85A099D014ocdF+y8hMMz62nj0+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGZOeSPoW1Pov5wO3f+hMPfD6ITI3APpxwzHxHilsKs=;
 b=15/UvXHyOFeN3MwspkQQmJp81PZiXhc9mbH2jOjMVQNzSaMSxxbfqs2rNRncnCs7Z+dFVYi33HSm3rLHO+0Lc6DqYJr2UnKr2zp7ddpBnr0n9h0OxEK3MvG63gqWBuXsz5PH9T1heRH38nnP31zPz3lSNS+5VczyN25Hh9tRX7I=
Received: from PH7P220CA0075.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32c::11)
 by SA3PR12MB9227.namprd12.prod.outlook.com (2603:10b6:806:398::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 19:11:11 +0000
Received: from BY1PEPF0001AE1C.namprd04.prod.outlook.com
 (2603:10b6:510:32c:cafe::1b) by PH7P220CA0075.outlook.office365.com
 (2603:10b6:510:32c::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.14 via Frontend Transport; Tue,
 12 Aug 2025 19:11:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BY1PEPF0001AE1C.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Tue, 12 Aug 2025 19:11:10 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 12 Aug
 2025 14:11:08 -0500
Message-ID: <506de534-d4dd-4dda-b537-77964aea01b9@amd.com>
Date: Tue, 12 Aug 2025 14:11:08 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, <corbet@lwn.net>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <john.allen@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <akpm@linux-foundation.org>, <rostedt@goodmis.org>,
	<paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
 <9132edc0-1bc2-440a-ac90-64ed13d3c30c@amd.com>
 <03068367-fb6e-4f97-9910-4cf7271eae15@amd.com>
 <b063801d-af60-461d-8112-2614ebb3ac26@amd.com>
 <29bff13f-5926-49bb-af54-d4966ff3be96@amd.com>
 <5a207fe7-9553-4458-b702-ab34b21861da@amd.com>
 <a6864a2c-b88f-4639-bf66-0b0cfbc5b20c@amd.com>
 <9b0f1a56-7b8f-45ce-9219-3489faedb06c@amd.com>
 <96022875-5a6f-4192-b1eb-40f389b4859f@amd.com>
 <5eed047b-c0c1-4e89-87e9-5105cfbb578e@amd.com>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <5eed047b-c0c1-4e89-87e9-5105cfbb578e@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE1C:EE_|SA3PR12MB9227:EE_
X-MS-Office365-Filtering-Correlation-Id: f7ef0d15-dd61-4b07-7f9e-08ddd9d3ffdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|36860700013|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGhOZmlWQ0VXVjlCWW5BSWpIUHN2MFdZbXl2NUo1Rnltd3M0L0lsUkdFSHlU?=
 =?utf-8?B?L25JN1VBbEJaVGdFNHR4eXNsTzJpWS9jT1Y2MGRqRWFEVUV0NHVsMC9IZlFo?=
 =?utf-8?B?aVc0elhITXE5RVVCZWdEd3RRYUN0Z2lHaVA4M2pkdmt1V0pNMWZCVStnL0JU?=
 =?utf-8?B?Nk5CK2hWUVptd2J0Z25NSVpnQkI5d2NrRyt5QWRCajF2ZW5VZzBNdndpUFcv?=
 =?utf-8?B?Mm5kVHBOMkk4cWRvdW4zb3cyZmhyaFVZQUpBQWRMbnI2TWxoRmxWQkpiY1lX?=
 =?utf-8?B?bzNyejBNYytXaVFLeWI4ZTdnay9lcmtWR2dKTVA1Q003ZmNCUW9zbUU4QzZh?=
 =?utf-8?B?OHhUQ0FacFRXOFZqbVJnRjJIQVVUYzl6ODhKcFFEOXFCRFdJSTN0MEcvMTVt?=
 =?utf-8?B?OXdBY2FQTzJXUlpCeWxwS0Zhd2ZvQXlYRmRRWW9nbkg0amtaSGI1NWlPWTNq?=
 =?utf-8?B?dG9uZ0x2ZkdjVHJXY0hBSGt0N0kwdzFyQTJiWlRkbHBzeWd3U0VnNW5iS3B6?=
 =?utf-8?B?dlp0OUE2dWlEbnhTMW1abHZhdFAwZis4Tmx2Mmw4ZngwTkx5S011L0NsS2tU?=
 =?utf-8?B?RE4zMXNMVURFTHQ5WFhFVFVuaHM1eE5JaVlicTRoM09OV2F2QWorRU80NVNp?=
 =?utf-8?B?M3VIY3JoV3VDNnZNVU12WGs1SHlVc254d2tJcjlPZDdZaVM5WDE0N3VrNnp0?=
 =?utf-8?B?cDh2QTQycnRFMGZXUWs1RlI5VVVCQk1LSDNrQVQzcEdxbFV0QklXSlhRSEdr?=
 =?utf-8?B?OEV3ZUlzVGN5d0VGL1F3bVRXRDMwakh2Q2hEVzNYdHlndmlyc24waXdWZHlj?=
 =?utf-8?B?UGZ2UGlkMjRKQWVDL0tyY0dzSjlucnFwNHh3QW01U3FZd0JvcHBQOWdSY2tD?=
 =?utf-8?B?NXBXbjF4dXpnU091c3hoZE41RFhSaU5BRDZsRmhYc1BtSkRmbUZDaFpXZXVZ?=
 =?utf-8?B?eHREZmM4dGpBbG0zaWU4S3ZNREhDYW9WWG5DWHIyRmd6VXF2MStLR0JOMnBJ?=
 =?utf-8?B?WlFsQ0U4d2tjNzVNSVVDRHlHcWU5UmRtM2t5M0xlWmNWZllEZGY2b0NiYzdi?=
 =?utf-8?B?R2NpR1d4WUc5elNEZ2V2WUlsT3RlT1kzc2VaVjVtdWw3UDByOGI3MDFMV3gw?=
 =?utf-8?B?aS81bXdIdUJqSFpPT0VQZ0RFMzkzdklYZUw4QUlRc2NuSjRYUGpOT3diVDJ1?=
 =?utf-8?B?Sk84eldmeUIrOTU4RmNFVlg4b1NweWU1SHFHanJGREloSGdlMU1DVHdIMDNY?=
 =?utf-8?B?eUV1WmtIL0F0OVpyUVEvdU1TbHcrajk5cEFMbW42TlZncTl4Z2NGbzJlTEZM?=
 =?utf-8?B?bjc2SXUzWm9VdXZHTkoxL3ZPU1h6REovL3NEcUhCY3NnWXJuNTloSVpsbHh4?=
 =?utf-8?B?VWpNdUtvSEo4TGJaY2I3TjVxUStGNlZGM1ZzWEU3UjFQZjFHc0RTMDdycEp0?=
 =?utf-8?B?SjM5bnNrbzVSbFF6ZTROVlBsbG10UWlCRWc3cGZSZUpUaXNaVHl1M05yUFI0?=
 =?utf-8?B?STJKRldxcnBGdnM3V0I1a0Z1M2ZsdFBFZEEzNnJqMEs1bHRueVg2NlJ2aEF3?=
 =?utf-8?B?U2Z2Ry8vd1haSHBwYnhES1hmdHVQOGxKU0F4cDZhTmpVRFBtK2RieHFyYWl1?=
 =?utf-8?B?bDYraUM4U1pjdzZzeFBqaDdDTEtPV0xWT1BzMlFwam41aVU0bmt6ODBYTCtJ?=
 =?utf-8?B?aVFLWGlTMlVTektZYjk3Mm1NYm1uNElzNHhVTS9qS2N4M0VaWERpRGlHSmQ3?=
 =?utf-8?B?YmNwS1JyOGxmV2htakg0TXZkYU9xZkpzWHc5Z2hnZUlYR0xEQ2VWRUs4dUox?=
 =?utf-8?B?L012M2dZZTloNzZTTWVhQUZwd1VBclBYd0hBNE5oZ0VXTURRaHdvZ2V4V2Fl?=
 =?utf-8?B?R29JdVF3azQxbDVMcGt5Vm5kTDlPZHQwMEdlV0xrNW5ONjI1M0Zwcjhab0ZE?=
 =?utf-8?B?OFd6WjNtNXRVTmF0VWxGeklQSFBtUVQrQVM0TVY2TGd2Y0RLK3E2cDlLM2Q0?=
 =?utf-8?B?RU12eGNSRm9wQmdTYmNQQ1NlMVZhYkNOLzRlY0tBUlE0VEc2ZmswKzVMTXUw?=
 =?utf-8?B?SHpHdDg4OXpUY2xiSzVyM1ErZkdOelRKWEJtZz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(36860700013)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 19:11:10.9096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ef0d15-dd61-4b07-7f9e-08ddd9d3ffdc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE1C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9227



On 8/12/25 1:52 PM, Kalra, Ashish wrote:
>
> On 8/12/2025 1:40 PM, Kim Phillips wrote:
>
>>>> It's not as immediately obvious that it needs to (0 < x < minimum SEV ASID 100).
>>>> OTOH, if the user inputs "ciphertext_hiding_asids=0x1", they now see:
>>>>
>>>>        kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 99 < minimum SEV ASID 100)
>>>>
>>>> which - unlike the original v7 code - shows the user that the '0x1' was not interpreted as a number at all: thus the 99 in the latter condition.
>>> This is incorrect, as 0 < 99 < minimum SEV ASID 100 is a valid condition!
>> Precisely, meaning it's the '0x' in '0x1' that's the "invalid" part.
>>
>>> And how can user input of 0x1, result in max_snp_asid == 99 ?
>> It doesn't, again, the 0x is the invalid part.
>>
>>> This is the issue with combining the checks and emitting a combined error message:
>>>
>>> Here, kstroint(0x1) fails with -EINVAL and so, max_snp_asid remains set to 99 and then the combined error conveys a wrong information :
>>> !(0 < 99 < minimum SEV ASID 100)
>> It's not, it says it's *OR* that condition.
> To me this is wrong as
> !(0 < 99 < minimum SEV ASID 100) is simply not a correct statement!

The diff I provided emits exactly this:

kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 99 < minimum SEV ASID 100)


which means *EITHER*:

invalid ciphertext_hiding_asids "0x1"

*OR*

!(0 < 99 < minimum SEV ASID 100)

but since the latter is 'true', the user is pointed to the former
"0x1" as being the interpretation problem.

Would adding the word "Either" help?:

kvm_amd: Either invalid ciphertext_hiding_asids "0x1", or !(0 < 99 < minimum SEV ASID 100)

?

If not, feel free to separate them: the code is still much cleaner.

Thanks,

Kim


