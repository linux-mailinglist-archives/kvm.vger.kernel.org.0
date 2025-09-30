Return-Path: <kvm+bounces-59083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F1ABAB82E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 615551C565C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 05:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CABEE276056;
	Tue, 30 Sep 2025 05:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cwOvLGo7"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012046.outbound.protection.outlook.com [52.101.48.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE1819DF4F
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 05:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759211210; cv=fail; b=tQC4O5qTuRynqg5VyFgNs6MTJEkRJBGibwptiDEJ5V8ibT3aPyinKI7gR3cOPy7zIkjEiyYdRcPzbjlrkXFNs1ASqfSm7glNbjm36OV8RgSaEcUrnaujfrE25gx/gZT2AUb2HfKNiYxuSJs0mvzRwqjtigWya+6Pt5b4YM9wibA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759211210; c=relaxed/simple;
	bh=T+opD8YNor7FkY58iIokiifZgtjJ1BIF1WehFUkwby8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mjwOIcmf4lWwJwjCgDHqqrue9f2fBt07F5Q9LOUak/ctGNqKb+evg/QAXXf9DChXA15JpJW43LF7/AsZAN/HWzUkIFRrZLnl3AujvM77LOyUDJMUnzklawjfEF2MuhZJ3J8yA3NTPGzf0x5CUqnDoMqWNw23hXZUf6cO3qAIPI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cwOvLGo7; arc=fail smtp.client-ip=52.101.48.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vGLG9LRCTXlJxNLCXr0X0JpS/iaN2aGYkfDI4vARB2IGmXfz57g6C0CWOfRagtx9FfEqn/RV6vct6RuLMVxmvuaivgxHdHewmw+fY9oIaeLqMfhigYFVbQEMHY6Nj3UTG6jI3dJelcktpfMWYobnUitbLqNQfxqQPOCxZjmNIKvfqabTm89c6oLH+unWGTkzKI1Fa4XGjrmvJo6Qaa26JVouvdGwXzJubF82sOggO0/RkawW9T/lQbHHNLaVxfdr0ZhT36TmIurFDsMLVjeTu56zuRDVJW4vAEAByAA96ZId/0I9gyMWJyuse3D/57xg2rBWPyILc0TEzOR1X+/Vvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgghoBSb8bmdkRAFFv0MVewQts4WH9t1dFK3W3U1bQ8=;
 b=hFuUphzkxR73psrvrGzdOYzT7zydbWg8kXdmqyF7eiMe34+WlzauwunX3g5NgVN7zh9vQPU6ZBfbXuLqprtuEGyoju6taX2XPZgymuAogGATqCx6RVNYa38aT/NgM1KlRJcCXCowMQC/vASxC3h4NoA4nRRDEMzVWJXuBUdYAsF0W5EC1niRJrPeCnDYc7c8oLCTbhpaUdJPA2wglhMUZ53gWXy208ZZH0vkeVEYpqfCLp0WnDcdpP+Lx8LpbYKSQKXQqMo7YgG+jq2S93PYlAc2tmU/G2eKOsgbJM3QHg3d8Cwbh08gYWwvurGCQDGX6g9lD6K4RjeUtGU8d2Pe8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgghoBSb8bmdkRAFFv0MVewQts4WH9t1dFK3W3U1bQ8=;
 b=cwOvLGo7fa6NZD2s+CLKycaj0xcaYrWfTp3bcZX2/2MvUuY8IMazriXGlth7PIw7LThsaA9E0r6N/Oqmd4xbm4fvk34/uUIv54d72vCxqYiXGjM7HZCjCTsr8nzW8eARlRvMICQQLCIXSknhL44zebq3RWbFE9SE9gyU0uyNbtc=
Received: from CH0PR03CA0102.namprd03.prod.outlook.com (2603:10b6:610:cd::17)
 by DS0PR12MB7701.namprd12.prod.outlook.com (2603:10b6:8:133::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Tue, 30 Sep
 2025 05:46:43 +0000
Received: from CH1PEPF0000A345.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::a1) by CH0PR03CA0102.outlook.office365.com
 (2603:10b6:610:cd::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.17 via Frontend Transport; Tue,
 30 Sep 2025 05:46:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH1PEPF0000A345.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Tue, 30 Sep 2025 05:46:43 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Mon, 29 Sep
 2025 22:46:43 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 30 Sep
 2025 00:46:43 -0500
Received: from [10.136.40.228] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 29 Sep 2025 22:46:40 -0700
Message-ID: <09412800-6643-4ed4-b7d6-3f767fcc2407@amd.com>
Date: Tue, 30 Sep 2025 11:16:39 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] KVM: SVM: Add Page modification logging support
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20250925101052.1868431-1-nikunj@amd.com>
 <20250925101052.1868431-6-nikunj@amd.com>
 <4321f668a69d02e93ad40db9304ef24b66a0f19d.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <4321f668a69d02e93ad40db9304ef24b66a0f19d.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB05.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A345:EE_|DS0PR12MB7701:EE_
X-MS-Office365-Filtering-Correlation-Id: 5acb22f2-dec1-4566-1d02-08ddffe4bc86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0VlVkczeGVxM1ZDUkdaUUNIV3pSQ2JRSzZmblpicDFUS3RsTmhVTEs3akpw?=
 =?utf-8?B?SldqMXZodGpCNlY4K21yYllWYy9YNXhPb2lNc1labkJwUzFSV252N2NNQkM3?=
 =?utf-8?B?UGJpa2Fndmo2SysrUFloWUREa0pCejBZK3FydzJiZ3owL2JCOHlWbFdTckJm?=
 =?utf-8?B?Q0gyd215TFM4MnlzempZYjRTN3F5VGdWbEpUNjQ4R0laVnJQVGZKdFBHYjdY?=
 =?utf-8?B?OVQzQjJMVjgxYUlqQ2RLdndwa2ZlbFdHbWRFZXBiSVhEYTJEUlkvaHNVWisz?=
 =?utf-8?B?dzRmTFd6VHJLTHZQcklydm84Umo5aXRaSnh2aFF2cDlkcE1mbEdqZG14WlRy?=
 =?utf-8?B?UXpGczRTOWJRbTJiekNaSDFSc0ZvZENETnlHNTkrMDYwYlcveVIzaUNNL2xV?=
 =?utf-8?B?UmF3U3o2dzB6SWlpRHBUc2IvTk5hMkR0MGNsZ3JkWVNDWjcxSmg2SnNqS3ZM?=
 =?utf-8?B?eENXU3BFMEkvQnpHU2F0UXltdWtmS0gzazJabmhiUUVCRTZqb3JkSWZKcTdR?=
 =?utf-8?B?blVyUXRJSjFNNFBQN0J5UzJaeGlycUE2T0poYldIMGxtOXdTNTJJMVBLa0Nt?=
 =?utf-8?B?TE1RSDl2dDNZbmVzTEhZbWhmUGxidGFDNWd1cG55SmNkWFl0N1dWc2FOZnpz?=
 =?utf-8?B?bWF6NlRWOHVMRlV2N1NsLzhWbjBLT21WU2dFbDQ4cWlDeHhrT3N3S3IzOWFp?=
 =?utf-8?B?c2Y0dDNzWGtNU0VaaXRBVU1IKzdhWmZKY2dwU2lQWmVJRGhHYTUzSkhhRzBy?=
 =?utf-8?B?UFkxN3NTQlJ6VkFwNHpoOW5lR1YrbVhFeS9oRWlTa0tuSHowZnViajJaWE1h?=
 =?utf-8?B?cjFITFhMT3JoZjRFQThyYW9sUGtYQnNhR2FUWDhnZ2pQL2hTcHNjelFFTTVk?=
 =?utf-8?B?TVJ4end1MU9NSGpIOHVkSnRMaUhqbEMwdEJVQllncm9DajdidUU3Y2JrU28w?=
 =?utf-8?B?ZGRlMTFXOUM4STBLSXBkSVV1ZWZiR3pHWEpEQUsxT2lMRXU0dmQzNEFjdDVJ?=
 =?utf-8?B?S0pVc3p1NG92WUJMS1M4Wm1UZ1R1UWE3YkgwRjFNT3FrVnFCNHFDdWdGMEVI?=
 =?utf-8?B?ZTltYlc2SnlEUXZUR3B1SG1UVVFxRHYrTnR5NGNVSkNnZllnbjBDUVgwVWUv?=
 =?utf-8?B?dTBxRG12MVZ0Umd4N0pHWWhtN3hnWEdhTVRNSUNZMHdnV1N2UW42TTN1anVp?=
 =?utf-8?B?QjR1WVRFd3NNOVFmK01GMmo3b0JPRWNEd2NZcjVLL0Rrd1BLcGNOd2s5OXNo?=
 =?utf-8?B?RzB1QTAwSjFyZWJ2K0p2cy9BMWFOTGZyR2tMcWFYbVJIS0xoZEgyWFNQelNo?=
 =?utf-8?B?aHRjZnpYWG94a2VSSTVSbEhobXNBK3FNM004bmJHaEU4c1ZKcGdlRHZBVXlF?=
 =?utf-8?B?Q0xYSEdiWWxLUzU2M09FdXVnZVV5TzF1SG9xRXQ2NUhaQURIOHNOcjdwd3o3?=
 =?utf-8?B?TDRpeFY1dm9CMXNqcWN4ejRESCsrNklhNkRQSS9PMjFEeVlMMm1MOWhWZnRJ?=
 =?utf-8?B?dlowWU55QXNYRGM4V2oxcWQ1R3FTYkZyMnlPdVNJN1BpamIyUjRXdG5uY1Nu?=
 =?utf-8?B?MzNxTmQ0TTRDcDZxSHZCc1VnWHhSMHplZTdkZ1AvRWt1cTJtc3YxcjdzN0dx?=
 =?utf-8?B?NmZTcWo4OU9VN3lEdU41U1BpQmFvVWFCenZ6UWRQU0ZUb0pHYVpyTGd0S0Vu?=
 =?utf-8?B?L1VIVGY3NUNZTXBUVElja0tHZ21sZXRBREE4cTdCTTdvNk9vT284WXk1MWxy?=
 =?utf-8?B?ZE9YWWoxOUQyZEtlOHphdGFqYnVzaVZKTFI5enBUbkh5RnorbWxhTWNZYjFQ?=
 =?utf-8?B?SWhNTDRsN0NRZHZrc2FHVENqSmZxbXVpcXByZHhNS0RuVVVyWlU0amR2WVdR?=
 =?utf-8?B?Rk9BOG43bWlYYVFFZEN2cVU3K3JtTVB5Q0tLR2FGTXRId2h3QTdIWXBvUmM1?=
 =?utf-8?B?YitIQnVUclFCU2VhdFZ2QTI3SCtEaStZbkJOYUxIdEF4Z2E2aTB5TG1TY296?=
 =?utf-8?B?VWgvSWRyZEVJNjNkOFNIRE9BMTF0ZEsxeStZeCs1UWZvS09kOHo5Nk5pUmla?=
 =?utf-8?B?NllFSzJ1TndHTStpWlhGTXJDS1QzN0ovZ2lUeEtUMWp6c2ZZRm5QQlJIMHFZ?=
 =?utf-8?Q?9TNc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 05:46:43.6483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5acb22f2-dec1-4566-1d02-08ddffe4bc86
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A345.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7701



On 9/29/2025 7:11 AM, Huang, Kai wrote:
> 
> There are duplicated code between SVM and VMX for the above chunks.  The
> logic of marking 'update_cpu_dirty_logging' as pending when vCPU is in L2
> mode and then actually updating the CPU dirty logging when existing from
> L2 to L1 can be made common, as both SVM and VMX share the same logic.
> 
> How about below diff [*]? It could be split into multiple patches (e.g.,
> one to move the code around 'update_cpu_dirty_logging_pending' from VMX to
> x86 common, and the other one to apply SVM changes on top of that).
> 
> Build test only .. I plan to have a test as well (needing to setup testing
> environment) but it would be great to see whether it works at SVM side.
> 
> [*] The diff (also attached):
> 
Hi Kai,

Thank you for the patch to move the nested CPU dirty logging logic to common code. I have a couple of questions:

1) Should I include this patch as part of my PML series and post it with v4, or would you prefer to submit it separately?

2) Since you authored this patch, may I add your From/Signed-off-by line when including it in the series?

Please let me know your preference. I'm happy to integrate it into the series or wait for you to submit it independently.

Regards,
Nikunj


