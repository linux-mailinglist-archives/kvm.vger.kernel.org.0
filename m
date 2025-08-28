Return-Path: <kvm+bounces-56081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E91B39A8D
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 12:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D59981883A2F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 10:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C3CD30DEB1;
	Thu, 28 Aug 2025 10:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kGsCyYsW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71AF30DD14
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 10:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756377829; cv=fail; b=UzsirvlxhalF+nWmNWxeG/XNHQcAy/qGwG0AGBsEO7Y+Pjlb+B9fnLuloBtJMyMVJclwmAwfzrJsrKRzUjHA23nBaGMPg0EigbjfDkZjTpp2M/fTAQTIa8C4VUAQuuAy0GeGYwkj+exqrNDMpWa4/RMnSItVAycmNEy8pFBjo7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756377829; c=relaxed/simple;
	bh=v5j7I6q+wyFZoIpChlmyEw/tSnmIW+/yz5fNb4iuGdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eWIguI8aOsAD0BZhvObM/saf3OEFSLKw8z5vSgU7TRasJ0L+4yRH9l0FSbRSf0PDoN6nrXVSMDbXeknLea/RGpEPh36+xZ2gZdKOsKkMRgyQ0PpBusWuoVeUdOlbjfqHw/6fcSWk4eHaseAOK2tVqVAtRtO1ZSlnloWeGqr8+b4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kGsCyYsW; arc=fail smtp.client-ip=40.107.236.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fZKoUYw9N6IGtLGnBgWkIvjf7wP/gQx73cbBhHZr7FteIAFBvGH4vMKVaROPShuqE6+wq3AIHp1eL3GZg7Fi/uCneN4LIAT4LIvPy9icrC7YJCgF0pSDmo6A/u1GP2S0EqLhDhtMJJkfQuVXHvl7wdXSg8NvUowZ5v2gGf8kLD7Ap8xH08+W0sYmpj1QyPpF4Nxl4/4JFAKS61t2mq08yEfNCrbv1FtEI5bHNTJlihuTsqf+13NkmwM4YUer9BacuGMEJSqP4lZr872oj0tZ+7RVfpDq7aOZ3oCo4epotfK8umeyTjYAB8x1MZWIXvdlYhWW743qVqpL6FKCdufZNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7hyTj7Y0DWW/Se9QEONraBANi0J3xJ8eI9LOJy9xGk=;
 b=VaX4jeSs478RHeWcqhp7xOPHEaWNTX3kT8u3HCaXGuY2g5Bigg4x315EHhSrwGvt0/VHVx+c3nJ2FVLOyP3VEmxw5ph4lLSgRM+T+qSIC9Dd9sjRCU1vE/2JHbGIFyiThoYH5MFiuZR2Q5dMdBvoIgVHNTrSF3/D0H4HeIVh86VGghNhqqBkEpNh/RX6laOBNsKpckawFT+NS1H5SIXkQHXXxxjX9x1aBdtRq/CgZAr3KjmY6mzf/yvSI3EAfde4UnShI7cDKB+RPSnE/DdIZu5n+9AbLfJ7PGfxfN27jmUl7xptjs+cUukhYqY4dMxaMtiuiS2FB7HqRd88EF6FMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7hyTj7Y0DWW/Se9QEONraBANi0J3xJ8eI9LOJy9xGk=;
 b=kGsCyYsWwfkq77SfvgxNyzUPgDKSwEUk1yWVXQ2yKuexO5qJOSG/TaQCndz5zdmyeFNy3Gs/DDJl4tiJg5JA++/4xLhjM4McQw5utHUBBoK5oN0qUtNGGtynDZsgIqx5bYpxgtJQT0kWImJ1QC138r/FzYhFdSG2Kn8YQT1LjcE=
Received: from SJ0PR13CA0115.namprd13.prod.outlook.com (2603:10b6:a03:2c5::30)
 by SN7PR12MB6816.namprd12.prod.outlook.com (2603:10b6:806:264::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 10:43:40 +0000
Received: from SJ5PEPF000001EA.namprd05.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::3b) by SJ0PR13CA0115.outlook.office365.com
 (2603:10b6:a03:2c5::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Thu,
 28 Aug 2025 10:43:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001EA.mail.protection.outlook.com (10.167.242.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Thu, 28 Aug 2025 10:43:39 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 05:43:38 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Thu, 28 Aug 2025 05:43:36 -0500
Message-ID: <fd1b557e-8b19-4e71-8e60-3b35864d63cb@amd.com>
Date: Thu, 28 Aug 2025 16:13:35 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/4] KVM: SVM: Add Page modification logging support
To: "Huang, Kai" <kai.huang@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20250825152009.3512-1-nikunj@amd.com>
 <20250825152009.3512-5-nikunj@amd.com>
 <fb9f2dcb176b9a930557cabc24186b70522d945d.camel@intel.com>
 <86c883c4-c9a6-4ec8-b5f3-eb90b0b7918d@amd.com>
 <9e214c34f68ac985530020cef61f480f2c5922c9.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <9e214c34f68ac985530020cef61f480f2c5922c9.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EA:EE_|SN7PR12MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: 949b5d55-4ea5-40c7-e482-08dde61fc022
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXAxZXFXQ1pnQ255R2o5RWQxSmJoL05nSGp1QzBuaEFkTFhwcGNIS3Z5aXhB?=
 =?utf-8?B?dEZZWHVicUhicEJ4T29qaXJmcUE1aWZiaE5vQkkvbDJNSTRCbkdLMk8vbWVJ?=
 =?utf-8?B?cVVvU2Fjc0NnWFJDa2RIQjMyUHpBUjd4bmNJdiswS0RubTNXc3ZGNXdaekky?=
 =?utf-8?B?ekJKc1l0czJLNGR1RnVpNy9kRmhxVzNLVm5WODcrVFptTTVvNWhzQk1jWExa?=
 =?utf-8?B?YkRxcTlibk5XaE5OUU54R2xOVTJXeDNoZFcxVXNqU3QwNVJxT2tST2RCK3VR?=
 =?utf-8?B?OGl4bXpjYkxjWTMySHlRV0hzZll2di9ldjdhcTJuTmFvYzRIUmVXMXphYnhy?=
 =?utf-8?B?dDkybVJKUWVRZ0loZlN6OFdiandoaXFYeEtDV1VCRXpaUGx6aWRGQUFlSFBM?=
 =?utf-8?B?ZGVZNG9QeGFKQzhPeGtlWmlTYmN5MXc2RzJieHB3Y0xGUE1YSTBHVUsvT2VL?=
 =?utf-8?B?TWtwOHNkRVBheEZOcEJOY1RWU3NWVVFud3F5V2FhdTc3OVBpRktCZ1JETXps?=
 =?utf-8?B?b1FNbnN4dkFlTXZtdGRuRFVBM2RRZ2pnSDhvTmVZY3lHTWk0RWpINmhDZ21v?=
 =?utf-8?B?bWdneS9RbVkzMk4yUGRUSVkxSFM2emVXSlN6NTNTTTMwQXQzQlZhbURlSUtE?=
 =?utf-8?B?V0ttWERuc3Rad1lPeEc0a3l3OHIzbHpGTDA3VmlRUUh1eEZ6cGJaUS81QmJh?=
 =?utf-8?B?MFJFSnlYVVVNcDI4WDFYTmE2bXRIUGVsN2ZVZWJqZDdmSVpWMTh4OWZvSUpn?=
 =?utf-8?B?OUN6QkVJWkJCVjFXaGRoSWE4eXVta3NIcG1TVlZNQUFkeFZmV3h0ekdJSEQz?=
 =?utf-8?B?RDcyVVlhR2MwMnZIVU5zWlppM0FVV0hVUnZEQVZPTmU3Rzh4bTJPQkZXbUgr?=
 =?utf-8?B?aGlaVHFOb0tsbDVpa3NsWXM5cVBpajlCWGUrNW5iT2R4dE9lVFMzMXI3QnY0?=
 =?utf-8?B?VTBZUmUyY1VWT1h0bGpDbklzbHRCeVQrYm4zTU1xOXpQWXRrMVJYSFZnSVRv?=
 =?utf-8?B?Uk16MjlUclBjMkxyVDdKZ3JkOWtmZWFOT2VJVVd1QXVXRXB4N3UzOGZiZi9B?=
 =?utf-8?B?UU80NjZhc3V0b2xWbkg3dzdKazNwTWZSWHVoL3FCeDA3ZGs1SGlRSkVpa2R1?=
 =?utf-8?B?WURvZlVISWpZQmd3YitYMnhHKzBpQ0ZZTk05bTJmWEZxcEtVL2JmUkFJMlRL?=
 =?utf-8?B?NXBqb1FQcXhMSmRScWg2RnV1bytib1NqTVAyMmlrdjJRcnZWTmlzbS9GMVFl?=
 =?utf-8?B?QlE5MXpTUXFGamR2dUM1bnBRK1BjeDd3VnVLLzBPdlRiNjNBa2xBcHpQbTlv?=
 =?utf-8?B?UWRQeDB3c2hMVzJDUmJvN0FHWFlycUIyNU5ILzNaSVhFQnM5YmRTNzhVMjVP?=
 =?utf-8?B?d1U3aTdHSXgzQU1vT3FyMDJwQ2lENnNSTHF1YThNNmdBMGtnWUNWL1ZRaVcw?=
 =?utf-8?B?WHdLbit6Q00zTVRQakZtNzdYTThqVHo2K1lldXRQL1ZNTjhPRG1PWk5PNllh?=
 =?utf-8?B?RlltM094MG4rOWVoM2E5RlpBeTd4UTRjbm1qYzh2YXRHekVtSVdsYm5zT3BF?=
 =?utf-8?B?QlJLdG9lU1BtVHZHdk1Ob2RtQVp3djBMMDZONmdlU3dCRFFseGpXeHEyd1lM?=
 =?utf-8?B?SmlVL2JBTWdFMXV6a0RkZnlMeGlOMVVhWWJyMTR3S2xhKzhaNUtDN05BdGZW?=
 =?utf-8?B?Y1ptMEpkR2pzWDhUbjdYeS9KOGszd1EyaThvRGR0eHpLdkJKd2ZCQW1SZE9s?=
 =?utf-8?B?eVZuQ2s2emxmdVM2aE5GSkZvU2FHVkJTeHFjY0YveWlSd3RJS2ZmYTdDRnNC?=
 =?utf-8?B?KzdUNHZ1NkFuTTNBNC82eUhVa1JiSGs0YkR0NENRaDJIYVprREJqNithbW8x?=
 =?utf-8?B?L1hkemlMQXJhVU81NGtLMWpOM2FaTnBrYk1JTWtoZERpWlFnR2FWYkRqUzhK?=
 =?utf-8?B?K0x0eUM5MWYyajlueWx3Z09nMFhFNldCRXRNaWczMFhBSlRXMm9TbUtjd2Zq?=
 =?utf-8?B?S0FXcEJOYk1UOXRxTEU0RkFXOWlhOGZVcWVwRjFIMmtEZ3BBbGNqNVBGd2hn?=
 =?utf-8?Q?0MJEAN?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 10:43:39.7036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 949b5d55-4ea5-40c7-e482-08dde61fc022
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6816



On 8/28/2025 4:03 PM, Huang, Kai wrote:
> On Thu, 2025-08-28 at 12:07 +0530, Nikunj A. Dadhania wrote:
>>
>> On 8/28/2025 5:14 AM, Huang, Kai wrote:
>>> On Mon, 2025-08-25 at 15:20 +0000, Nikunj A Dadhania wrote:
>>>> +	if (pml) {
>>>> +		svm->pml_page = snp_safe_alloc_page();
>>>> +		if (!svm->pml_page)
>>>> +			goto error_free_vmsa_page;
>>>> +	}
>>>
>>> I didn't see this yesterday.  Is it mandatory for AMD PML to use
>>> snp_safe_alloc_page() to allocate the PML buffer, or we can also use
>>> normal page allocation API?
>>
>> As it is dependent on HvInUseWrAllowed, I need to use snp_safe_alloc_page().
> 
> So the patch 2 is actually a dependent for PML?

Not really, if the patch 2 is not there, the 2MB alignment workaround will be
applied to PML page allocation.

> 
>>
>> Tom?
>>
>>> VMX PML just uses alloc_pages().  I was thinking the page allocation/free
>>> code could be moved to x86 common as shared code too.
>> Got that, because of the above requirement, I was going to share the variable
>> (pml_page) but do the allocation in the vmx/svm code.
>>
> 
> If AMD and VMX PML cannot share PML buffer allocation/free code, my desire
> to share 'pml_pg' is becoming less, but I guess I kinda still think it's
> better to share the buffer pointer. :-)
Sure, will add in my next revision.

Regards
Nikunj

