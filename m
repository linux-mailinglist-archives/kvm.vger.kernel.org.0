Return-Path: <kvm+bounces-37538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07DE5A2B4BE
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 23:05:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D07E3A7B61
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 22:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED69422FF3A;
	Thu,  6 Feb 2025 22:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Aj+aNfIt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9650D22330D;
	Thu,  6 Feb 2025 22:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738879489; cv=fail; b=YVqgubBppYoT5DDAI8tN/Kb+FN5QKr++TAvHQH9OynQNe//r7O/18G8blWn2ZgPfnKZYWpcjo3kw7RS9Ee7E/t8h+hv4jHewqip/u1SMLyvySNL7Nk5j3i3KY4T3DGxoTNYVZ+uhJSkFZk8vkMMtnh9wQ5bdTyKch89u2+bWj+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738879489; c=relaxed/simple;
	bh=kbs/RIWM2KtNS1vchD/DE7EKQy/uqaykjrOB19XD2MA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GLFQL33Q3TI02L+Uuk586SIiw/Jjap1KpDaVZw/MVbUIYnrEAlLKrL2C8JvrJDOVTtQIOMe15UC0gj6KemKqnFt5Oxa1/TB0F+wlnTVlqVn8M7zsKiNYh0fH2gvVFH18IPeJgayquu1OV8Ij6G5f2t60Y+nPUmfx5+5GnP8fvPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Aj+aNfIt; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ov30MeFB0e9GjisSjjSRaolUWSI58fzClRlaMPseHmuDsgZ+poN1xyxFY07rBMlPgOz+/ktmM9ou4uwyQ4CjeYDpo1yVz8G14qw1kbTbrLB7ooeiQsPgs691nsQCpgxQa4NT+f/dSIxjVWrBT7D93WHcFwTuHy/Ua5tDE8o68/hhQxIW3Ezz5kdmPgOCwAyi3np1oaktjCAq+BJ7h4PXXanSAotxZZ5/UWqw208c8YFUjnPM5kLQuPQ6bmKQAdZaAe/V7NvixekY59lCz1Dp/9v6xnciL7t68fJ8wHSQgPn51DbMU3+nrI7lVkRU+7P0lSCYdBcf3p4qdTSGDV+kzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dCBWQtp0kzt+6NiNVrlga5COWub+EtXa064p4cjeFtM=;
 b=p7CnhqIIPVNL7I2IQStqaJGXuzalnIT5+NLhEnrpwdN5bDGrdcjAvGr5f00rM4+A4kECShRyE3TeMAm7xvMG8gTNdIgI+eK8tXyNevk40CnhFzymFUU7VYhTEQZ745zsXcIeu28o+C788+rVCKjV5K5AIiuz+zaa4/gpaAKM1ARfJ9LJr280k3L7yo1DobGRQ8QWLJ7sFUsQ9tPPORNNLgRjYzZiQIK1gzDNlr6QE6uSH/cC5ZARDhRiK03WN1L+AP2d5g5EfCpkwYxEy539Q4DI8DAhXT5MnJSWi3aMW8sNm5WT71C4/tTgunTH5+ssYVuxE0WFIbgi8gzfdQVYaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dCBWQtp0kzt+6NiNVrlga5COWub+EtXa064p4cjeFtM=;
 b=Aj+aNfItdszycwr6nocv7ow/FWfwbrWEJ3QrCoJC3Q2yXQK1VOzV5BZd6kuSnn7NTByAk+VZU1KSLBeCpniRjxQ8S7RPIDWq/7I8s1FVyWYDvDrO5zc7MMCjCBRP4dMOVY4Auyqsx1ZO2gwlTu6idS7GEF8uEmj7spTKvR4Y88s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ0PR12MB7006.namprd12.prod.outlook.com (2603:10b6:a03:486::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Thu, 6 Feb
 2025 22:04:45 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8422.012; Thu, 6 Feb 2025
 22:04:44 +0000
Message-ID: <1640f2af-8c1f-2a9f-9bd0-9a581576f329@amd.com>
Date: Thu, 6 Feb 2025 16:04:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v7 2/3] KVM: SVM: Remove wbinvd in sev_vm_destroy()
Content-Language: en-US
To: Zheyun Shen <szy0127@sjtu.edu.cn>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, kevinloughlin@google.com,
 mingo@redhat.com, bp@alien8.de
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128015345.7929-1-szy0127@sjtu.edu.cn>
 <20250128015345.7929-3-szy0127@sjtu.edu.cn>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250128015345.7929-3-szy0127@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0051.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ0PR12MB7006:EE_
X-MS-Office365-Filtering-Correlation-Id: 477757a7-baab-444e-1bd6-08dd46fa437f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVdsLzZjQjBPbFV4aWtOcDdJL20rOHZ6aFlCbFc3SW11cDVjS1YwcFFmRlBE?=
 =?utf-8?B?QkQ3aXQyU1gwTjU0UDFrNFRuMUF5S3pXMHNRTmVBSDhvUzRvendaazRxWEYx?=
 =?utf-8?B?UWNITmdRTm9Tc0pvWGk1eUgrTjZ3WmFibXRTUGx2Z205UUx3WUt3aGtGRUlY?=
 =?utf-8?B?Qk1haTcrMzVuSXQwUnZWdkMzZExadHFjNEZmNWdDSlMwN25mZXpnN1paVDky?=
 =?utf-8?B?QUc5b2xkWEhGMTE4WG9mNFJrVURINi94Mm5ZQWFsVnoyVWZGMmFHaWhmUTZW?=
 =?utf-8?B?R3JROGFEenlUMVUwRVhLTFp6NWFrcmNOZWVaOStBcGJaTGFLNm9tN2J2T0w3?=
 =?utf-8?B?L0VjVjVWWWRublFhNThWMzVpR3luWmE0NHlhdjBPdytwQ1pROFEya2ZDREEv?=
 =?utf-8?B?VmJRMzdvMlgzV0hkZllUZUU0YUd1T3lFLzVXVHFJWXVDeDZWa0t1S0VHdEw3?=
 =?utf-8?B?d2VwaElTWUF4TUxFNXVIamgrQzBqWFkrdFZvcStXZ1hsZFM3NUc1RVpqZHNI?=
 =?utf-8?B?TStWY04wTUtqOGF0TjdkV25MUW5GVXdXN2pjYmN2ekozR2h2aWZKNVFDVlNY?=
 =?utf-8?B?eU9Yd2pXRHdIMko1V1ZzL282Rmt0anA3RWRkTlpvWWlwbzFDL1FwNkF6TGV6?=
 =?utf-8?B?dmswSk16NVloRzZkNHdycmNmVjRpTlluRjhOTmh2a1VpZ1FkVThQMzFENUF1?=
 =?utf-8?B?UFJFdlJLYTYxL1V5NXZBNlFqWU9DVGxJZ1h5aGlsUzFIbE9PL0FYQlZmUEE2?=
 =?utf-8?B?dFpkd2dlY254UldWbHVWbFlaWWJmOTJ3dVlnL2NYeWZSV011VEUrMnJwWERG?=
 =?utf-8?B?c09MM0JGVEZWTzBzRkpBQnptZE5BM0U4Qm5pNHd3WVdqSW5wYm90eFpMUmgw?=
 =?utf-8?B?a1ZOekthUWxDQ3VZRFJmRFdJLy91NDNYZXkvK1JtSVFFMFVwUEZCTnZEbWR0?=
 =?utf-8?B?dWp5Z0lGU1RkN3p0VWdVRUVpYXpqWVczUERRY2xxalBHSzh4cENzeEZDSnNz?=
 =?utf-8?B?OGluVXZRWHFHNDFRN0hFU2F2MDNZSGlBZTJ1UCsvR0ppbkNqYjNXVGFqZk1Y?=
 =?utf-8?B?cVNudG9Dc2Jzb0RpWHlLOVZuVU00VGs4bUdBMm5UMS84ZE05SktPa1hEcysr?=
 =?utf-8?B?NW1OeEljeGcySm9Lb0pkZkdCTEhkdEJVWmN4SnRCa3R6RkVOTHpZYnppS2Vu?=
 =?utf-8?B?Rk9lbkJZMDc4Q1RaZTZIY1ZNaUJJbC94bExtOS9DcFJoenNYZGV5VndUd0RO?=
 =?utf-8?B?L09xTDkzdjRqVFhYZ3lMeGtXMVVtS0JlRGZoWUd1Z0JLdCt6c1ZiZkNpc0hR?=
 =?utf-8?B?MzRFZHJ1cE9MN3BRdTdsOUQyTEduTWdXUHNHOENjQW9CaVU1dEV5RjJOODVU?=
 =?utf-8?B?R01TcDZCYWNoMUtoaXUxMGpXRU5GUEdQVGZiT1FpRlB3Rk8xRW5wejN0QkJH?=
 =?utf-8?B?Wk5SYTdZUXFBRGJRYzJrTDEzN2JDUzRGZWE4a3FicVIya0I2YjVjZGcrNlJu?=
 =?utf-8?B?QW03dUtCd0tsUHJGVnRadUxrQjkyREo3VCtKOVl5TmlZL05WZ3lVOEhpTzBL?=
 =?utf-8?B?V1B3NFRxMUdSQ3BKalozN3NsZ3lUV0ZhR29IWi8ycTY0N0FaVlRkRi96cnEr?=
 =?utf-8?B?VEwrek03WnN2dkYveEVzWXVqRjNreVg5KzN0cDNqSnBQRldZWllmL3p6WnJa?=
 =?utf-8?B?NzU2YlV4bVlFbS9XU1cvcmp4OUZpUFdKOTEveEZFYks2c1VkSmJURmIvY0hK?=
 =?utf-8?B?VStScDNLQW9UZW1VMXBtQUo4VVlMRm80MVVMZVcvM1FLdzczRVFWSDJENWlJ?=
 =?utf-8?B?bThEVHlEVVpCdUxDdG1PdEhZVFlhOCtPNGNNNWhkWFBYdW9XUENvS0g0MmxP?=
 =?utf-8?Q?4m5YkdImlfSPb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFF6eFBMclZYYTNLSWpuQ2FXNmlqMms2ekU2a3ZoREZ4RGhTalVrNmYyb0hV?=
 =?utf-8?B?TitJMSt1NkF2YmZHNnhwbHRRY25HVkZkVElKTjBYNHVJUjNVR1N2MVk1c1lJ?=
 =?utf-8?B?d0Y2cHEzdXNiU1FQaVFFRm42eHpWL0hhUUo2RHFWMGQ0YW0yMlFVcG1XSklO?=
 =?utf-8?B?STNxUnJyenJOQWZ4a0dZbHQxbnU3UzFRY09QTVNkclRIVFR6TzNvVzZJMW5B?=
 =?utf-8?B?VVVaSGhWNENzTTgzTEpSV1UwRkhSK2RQcnJLbGlQRmprYW9GRmRGN0FCRi9T?=
 =?utf-8?B?cmNzdkxqdHZuTGE2NElseHQvcjkwM055OWtuVnk4TUtDV1lLNUpUSzc3Q0ZJ?=
 =?utf-8?B?dDMxT0pjZUNEMGhJWkdlSVhUaHcrMEI5VENJbjFhSFIwdW05bWtTNDN6M25s?=
 =?utf-8?B?WTZLQ0tUaFlENjB0QlVsaE9TSzJ2OTJxZWhtSnBaeUZ3VlYrNW9vSUNGQW5S?=
 =?utf-8?B?YjM1YWpDZkZEOFpzWncvSzlucE83VmgrL2pka1NoUDJuc3doMXNnOVFidGJ5?=
 =?utf-8?B?RkxqTFN3YnhVYStYYjQvT2IvUG9QVzdYUWVQZGhiSWFMMUtuTTlKLzUxUThY?=
 =?utf-8?B?YXBqVm0wemFLZGpMTjlrQ2xQaGNGY2NSdHlEbElzY0h4Slg2VWovSHlMYjdE?=
 =?utf-8?B?QWt6aG9iL3lPT2NWVk9jTEJtM09lMGkxQytKT0R5SUZFQi9JZEpUaVNWWmo5?=
 =?utf-8?B?Nm5yb2dhb3V6MDMySW1RaFBuMktmYnhBYXVIeUpjV2RaejgrT01IZnpnSFVW?=
 =?utf-8?B?dG1PRDJtLzhNR2d3YVJyVUFDaTJNSTljYmNzZ2k3OEM1SUFPZzB1eHZXaU1V?=
 =?utf-8?B?bnhGRFIxSWV6QnI2ZDZ1d3Y2YmJsdGZXQ2U0MWsyWVRodjVyOXZLTzVwSGxP?=
 =?utf-8?B?NU1HN3NaZ2U4SmdVelJEVEI3WlFrc1BVTmsvdTExTnpEVXVCQ01KSEp4VERL?=
 =?utf-8?B?MGRsWEtDeXZXeDFlSXk2dTZGU2U4ais3Yzd2cEdDOHJhUFpyQ1htb0o0V0Ra?=
 =?utf-8?B?Y1J5MzgrTlRmVkFjcXd4bVVmc2NSU3BHQmI5QzRiT2xtVUJ0VC9NZ0VNOVZ0?=
 =?utf-8?B?blpxdDRpbDArU1FTenNRMFh5TzRQVVFSc002cUFyT2hBanZBeGMzM1UyRFdX?=
 =?utf-8?B?dTlDclhMRVFaUEMyZDhJdTBPdkVmNjNabHV2Z0hRSHkzVEZ3U1B2YWQrS0hQ?=
 =?utf-8?B?anFYNmkvell0V2YzTWVvbGRBRDBpSkN5TzVCNmRNUytWcGVXOFhhQnNtNnY4?=
 =?utf-8?B?MWRibDNBdjdmaytmQjVMZW1WQ0NqTFh1VWFxYUhoR2NpZkZ5dG9DdEsyVTln?=
 =?utf-8?B?QUEyTitaNFN6RzJCOXZJM3dzLytPVkk4eGVUMTk2bHFtUkYvRERKKyt1ZzhJ?=
 =?utf-8?B?Sm1BbjREYXJwZmJjazJ5WWliVWFQcHd3RFdCRWgvaEQvZW1sa2czT0VxODNY?=
 =?utf-8?B?WDhTUmc5R0x0KzNMeEJpWFpqU1MxZlF4TUtldUVYREpGRFQ5eGhQYmZRVlNI?=
 =?utf-8?B?SWUxMmhhZEg4SXVCVHNGcmt5ckptUzNYbW13MFo5U1NTVkVhVXNObmRkTk1i?=
 =?utf-8?B?ZEhaTGZtc3hrM1A3bUJmRUZ4S3ZLcCtsRjdBZGI1ampRa2JoRmVLYUg0dVo0?=
 =?utf-8?B?SXNBUXpFOHpsWlZ0ZW5pbVhlWlh0amxuSi93aytmTENmVzN5TEQveUJFMk5h?=
 =?utf-8?B?d1B0OTgyb1Q4aGJoQmZpbnZOY2pYbXMwRXNDaGV0TjJnM2R2M0dDZHFETG96?=
 =?utf-8?B?bHFpZGs0TGdHU3hxQ0t1RU41Qk9NMkh5YytsNFh4VTVNNDdpN0xnOEdaWHIz?=
 =?utf-8?B?aEdJd0psZVp1b3pyc0JrbVZzbXFMUzl1M1BNYmJqQjdSUzZ4NmdoUjRmUnJ6?=
 =?utf-8?B?eThxcjVGV0Fpa080cDlyUXFtRFVlMlRTNFBWeWZ6M2Q2aG1jZld5bjdPWGMr?=
 =?utf-8?B?UWVVTXRnR1RteW5KZENZUXBhOFlkdEdUSVZ1a09UdXdleHpVcGxQb3c1RERP?=
 =?utf-8?B?WXBQK0JFUWh1M3VERTRwc0VuL1ZpbTk1WHdGcjZmZnRqVUs3V1lPRm15MjA0?=
 =?utf-8?B?TnNXeVliS0gwRWxrSk5Db2pWYm81T2VzYWNMSHkrb0F4UHJORllWRnhFWXhF?=
 =?utf-8?Q?nUTIp6tuVlwdNUpsZfxpct5pS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 477757a7-baab-444e-1bd6-08dd46fa437f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 22:04:44.6187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BBMQQiYJKvu+cGKS6xC146T7AQE6AqCFqu/dS2tC9CHpOZmqwVmqUeSvN2EJ4hi0I5b2h7snJZK1dFC7wOZQUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7006

On 1/27/25 19:53, Zheyun Shen wrote:
> Before sev_vm_destroy() is called, kvm_arch_guest_memory_reclaimed()
> has been called for SEV and SEV-ES and kvm_arch_gmem_invalidate()
> has been called for SEV-SNP. These functions have already handled
> flushing the memory. Therefore, this wbinvd_on_all_cpus() can
> simply be dropped.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 943bd074a..1ce67de9d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2899,12 +2899,6 @@ void sev_vm_destroy(struct kvm *kvm)
>  		return;
>  	}
>  
> -	/*
> -	 * Ensure that all guest tagged cache entries are flushed before
> -	 * releasing the pages back to the system for use. CLFLUSH will
> -	 * not do this, so issue a WBINVD.
> -	 */
> -	wbinvd_on_all_cpus();
>  
>  	/*
>  	 * if userspace was terminated before unregistering the memory regions

