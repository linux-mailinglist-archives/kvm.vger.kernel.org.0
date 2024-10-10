Return-Path: <kvm+bounces-28563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2979B999161
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FE691F25729
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA5791EBFE8;
	Thu, 10 Oct 2024 18:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EuZXlSMa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BB21CFEA7;
	Thu, 10 Oct 2024 18:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728585180; cv=fail; b=f3B3RYWhmeVI4v/vCBjhXpAOW+2dG451WwpfZsD8iSaW85EngFFXLGSNPqe3Y0P+GxT6SmD3GoXanV5D4HyvZ+mxvACru1cPqNkPSOi021bGo3xm3Kiqv+AsE73EvgkObULS0pxAZIFn13KAjRVl6exo7sN0LSwdN0nU1IL63l0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728585180; c=relaxed/simple;
	bh=eAoFVIe4QcFGmUCTuR7ptoaOpyrQi/OvIRR3QFF71oc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pfUTlEvJCRS72cemIim+BqHscYTS4LoCjsnLtcfjYCGjaFN4pBM9+qbDdqKHKpiZ7MPtr6mEJJG9DFI94tSAZLbLR/Yfqw+QODc4VTQ+g1zKcHlm7yHTR10FahlW7rrrbTkCH8NAdOVXpIKyyJYdj6P0GKPnSSCPOgB4OiMr6tM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EuZXlSMa; arc=fail smtp.client-ip=40.107.93.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3GF/zH5rzXctoDnJKSyEYJ03KaJd3vAQacGjoy4c9l/xqCb5yiKdDI9x0jaH6ULA66Y24b/1Bz5AZz7D3Xb6qgTs3wx52b0VC4IOWEG/pi2j50yLCIXYF7NnIV+K+6I8eNroJ8dgt6XIaQgy/v31O9xTuo8XF1Q+scApoX5g2ZKuBtiQJtepFONhdmgZyL+7la58kwH1Euw/Dpvi7sXkKSvWOhDYxbL2TJddUzvrVLDtqumi8lAyi7bizcDGrGogIUu4/jbNpRHFAI1dphrBQpMfc8zh24uGhNpCSTo5xk7js2P3qs7Y9+mXnJqLvdA/yK7NAXdPEfdLcJ6sA1qBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYNfQBGrhKX+ya2bZOmfWBiF8/23uoDACYucRFUgnIk=;
 b=hbPlbTKxeEOIXV4rXD2g3ZtzIZAMajCXx++UVPi28HhHV+Z3pQaTV8qYXCHEw41e857JPNZQjckE8RhhnJcJByAgBbnhZvCtkx7/9xuMenoucAH8/44dPpAEBhOortqJmYcGuwiacq2uxZSEankYNqCSwhWmkUi5c6diIU4tfOnGC7NNS6cEJa9/sS4K7pTT6+ePjmseOc0IMHDZ6DI/E4CKf61jy8OWbVHC1W9r83ttm6OjX7zsq91+NMl3tRwRdy+11Ol7z+CIcvhrce7X0O/rxJ52JPuMzqLkRqfWYNEheJQUcaufhcpwc/Vxvx6leP3JtvRsti1a2CGMF9/C8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYNfQBGrhKX+ya2bZOmfWBiF8/23uoDACYucRFUgnIk=;
 b=EuZXlSMa0eYqDNWIR/wCeGLwvFuRNa/QxvjbHZdGYpjgCugyH5fqR6irtglRnYwwlLhp4ksY503as4k/VxxFA/Dh9GS3EdeB/pQoYNCO1RBGOZikUXkJiRkLLmiw2z2NM9D/PRtxc7Iytx5UlyL67Z33ski5gvXNyBtK6/ZCnzs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH0PR12MB7905.namprd12.prod.outlook.com (2603:10b6:510:28b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Thu, 10 Oct
 2024 18:32:53 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8048.017; Thu, 10 Oct 2024
 18:32:53 +0000
Message-ID: <379ccd07-533d-8cbc-2d25-b5b5f4849abe@amd.com>
Date: Thu, 10 Oct 2024 13:32:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v12 05/19] virt: sev-guest: Reduce the scope of SNP
 command mutex
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241009092850.197575-1-nikunj@amd.com>
 <20241009092850.197575-6-nikunj@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241009092850.197575-6-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH0PR12MB7905:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ea0fb70-abd6-4d18-dbdd-08dce959f394
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TWxxdXpZRk0xTU9BQ1htbnhqeklGUXYvaXV2L0VtaDlpN2R3NGFSMUVHMDVT?=
 =?utf-8?B?Ny9QTlcxbFFsekdNOElJQ3hHeXgyWHhHLzBjNG1HVUJ2TUFIdXFablh6Qllz?=
 =?utf-8?B?c2E1R3RvaG1raWFFeFNjZVRQYjV6eGhmUW9pVmhYM2c0RUxXSld2N1B5blpa?=
 =?utf-8?B?aFRBVjhKRHNJU0RXWHcxY3hpdVB0S0FSczhEMWFXNFZKV1lTa1VkQ2I2Yy9V?=
 =?utf-8?B?RW96YzBVKzV1S3ZueHVNM0ltTXBsdHMxWkJseEttd2RZUFlNWDZoblBTOGk4?=
 =?utf-8?B?bEZhQnhQY3F6T2JKTXByNmtrQmthMDVyMnBoMnpKd0l0di9tTlJQZzBHdVAy?=
 =?utf-8?B?ZzY3RGU1Zm1qUk5KOFVKcmc4OHVGRjFHV3IrZW04bWIvaDRlT3NXYVdZSFJr?=
 =?utf-8?B?dFd2enhsWkVuOGRNS09sdlZZckpJOENNcVNzVjVkNG9Nc3ZoVE44V015K0dI?=
 =?utf-8?B?N3ZYSGlwemRJd0NXUTVReURpeDBlYWQvL3kxOTRtb0xIWnl3ejg2Z3JpZlVJ?=
 =?utf-8?B?VzVZL1BTaHVVL0x0UkFScE0zYXV5M21ETU1saG45V0xGc3VtdldhNXkva21j?=
 =?utf-8?B?QTJXR1dhYWRINWZQSjRHandUOHN3ZUMva09abXUyaGlwT2ZaWW1pZ0NHNDhw?=
 =?utf-8?B?WFFad0owVUNpbzJXM3RWV0xYNWJITW1aQ1lBYXVxUk43TWlJV2gvQno1K3hX?=
 =?utf-8?B?MWVod3dmc1Q0Y080TGFxb3lyZ1I2aEd5T0xBT3MveHNOd1ViY0JneU5EQTJj?=
 =?utf-8?B?aEcvUVlEcnJ2dFVHVlB4RmVqcDJXcktKdWhsVEN0bVkrbkI1NjNlc0p3SVVt?=
 =?utf-8?B?Q0hBV2FHUDV2Q05pQzQ3WVBWMEV3WElDLzRWWXFoNTgrK1hWNnl3dlB0SGNL?=
 =?utf-8?B?M3dDbWxRUS96QTZ4N0FRMjJ1dm10aDdEQklWRDJSaTBiUXVUdWEvK3RvY3Na?=
 =?utf-8?B?V2RUdkdWeEwzaU1lMDlYeXZ6a3RWQk10VzljQlBUaW95SlF1Y0RCV3BwbENT?=
 =?utf-8?B?SXZ1TUFjbDRaQS9Sd3pTUkJoZjBCYmxZVFBXZXpWTldpV2NBdXUrYjRGWUFH?=
 =?utf-8?B?QjcyTVd6enl2ZDdweFBDbGwwbWtKaUtTQWtwODlFSHZrTGxqTVR0aFZ1TDF0?=
 =?utf-8?B?RmlwR0EvQ0dtY2o5NURyKzBDMWpWVE41UTJocUZqWitlMXhyanRvTVJKRFl0?=
 =?utf-8?B?MDV1a2c5Y1F1bW4vL1M2Ym12Zld4d05udll3azBOdlFIV2wzZkdNZ2tpWlJ6?=
 =?utf-8?B?SlFJQmJMVExPYVZLTzhCSU5tMHZTQnY0ei8vSUN1c2ZQUHNWZS9NcjJDaXpE?=
 =?utf-8?B?VHgrME9OZElIZWJaOXhJUjE5SVhPNEJ6YkVnN2Y0S0hyOVd6MDlDakMyMmhE?=
 =?utf-8?B?WCs1dUZrblQxeXltS3dDT09MRDU0cGdLVFdZR0VWdG5oVzgvRytSbmxtUngz?=
 =?utf-8?B?dFZuQVozTXhJVjhtQ3UxR0h6VWxDTzlFYXNPTzhpaWUvZC9XNmxTQ3A1dUZJ?=
 =?utf-8?B?cVdBZU05eGw2QUxBdThDcm1Lcm90U3lYdFl1aFFFYWkya0NPVkxYbU5XdGtC?=
 =?utf-8?B?S1JNNGRoUFlXbUhFUDdHNklKSWJ2aU9yZmZMcDJ0ZndITlV6K3BDSXhSTUlV?=
 =?utf-8?B?NFIxZEJBdmdDZEMxVy9xdFZBa2cvLzJUNEhNbWZyb01JSnNKNXU1Sk1GL0hh?=
 =?utf-8?B?alhYRnkvSndhbGdzZkR1UFpIWkZZOVRWaGQ5cndXK2hGYUxmVCtHdmx3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3E4YUVXN1M4eEJzcGJ0Z21XdXZLTTNCMnNJOEIvRCt0QXY3UVpqODlRaXll?=
 =?utf-8?B?MUEzWXVkVElsTTcrY1lDWjVMRTB4LzZsMWRzZENrb0c1eVJxVWJsSVRFSE5z?=
 =?utf-8?B?TEszMkJCYTREelBXSVVBbHdFMTdkUkdCQkk1L2tBRCtnRENPdkJtYWxGbDJG?=
 =?utf-8?B?MXFveDliUGtpd3ZqNHcrM2pYYlNLaW9OYUNSeGQwT3Z4ZjhBbXdxRy9Ub2xI?=
 =?utf-8?B?a2hpVitHUnNoVE1DNVNxZFgzRi9rOFlhQjMvbzVmby8xaDZ3MU9LMzZOU2hk?=
 =?utf-8?B?bEl3aFNsK00xR1ZSbHJmZjd2U1VqNWlERTZXQWxRbFhlWjZBcEMrejg3S0Mv?=
 =?utf-8?B?Yk16bUtmMkZIVllCbEtyczNVSFB5QWZiZUFQWDBObnJ6L3RKTnVNQjV3QUlu?=
 =?utf-8?B?Nnhud1BLcm1maDRhODBQV1Q5K0svUTJjZW93L2FuQlVJclI3bFdDTXM1Rm1C?=
 =?utf-8?B?c3lBeFBvOXJZSFBOTm4zUlpiTmVIMzdIYWZRQmdQTmpJamJ3VE5NUWhxQSs4?=
 =?utf-8?B?YXA2K3Qxcmg4QndENUU5S0llcTN2YnA3UUs1MWhVQXYvTW5oTXRHdkdWQmdE?=
 =?utf-8?B?YlF1UTB5ZmRkZGNQUi9kcFFZL0lBTzJHdFlQd3RZRUxDNXZrOE90Rk1Gak1B?=
 =?utf-8?B?UDRYQk1UV1BkcDJrV3UvQnIyRnBOekNZTzJRNGJuMjVId1RYRmlESlA1MTZI?=
 =?utf-8?B?aTRUeEFMUi9pdzg2MUxGditjM0M5aGdHRk5BRDV0N25XcnRZMGpzWjBXakJL?=
 =?utf-8?B?T0NXSHhsV2l0UUVhTjc2aVI5UzBYeDZSczJvdjZMUmxXZjFEYnV4QTF0cjVN?=
 =?utf-8?B?M0lqNnhhTk4yUWhtM292eGpsK0ZhcGI1YjVKeUcxYkQzdXFaSUtjZjdIVGZV?=
 =?utf-8?B?N1ZZRWpRRWs0YjlkamczNzAwbTh5aUVYNzRmaXRGV1gzS1ZhV1E5bFg5VzZo?=
 =?utf-8?B?blRndVhWRitua29COTRBMnYxWEcvdVVTQUM3UzZHQ3JIQ0EySVQyYTdaeTJa?=
 =?utf-8?B?UFJmREdiWHl4Vmd0blkyR0xIdHdnNmNLR1NPMFpkdzUwaHlrTFZ1WnB3N2I2?=
 =?utf-8?B?ZklVUjZsSmpLcWZwejdQckdHR00rcFdyYmNpZHlpMnUrcmpyVk1BaGI1MCt3?=
 =?utf-8?B?dUpQUUhXSStFU0tQUTgrOUpGYVdJblJMb0RuajA0encwWXNpV3RMb1kxMjd3?=
 =?utf-8?B?bzJVZ2FIN2ZEZTlHL3lSZ252dFpkRERSZ3ZZSUhNOFNXd1pXYkJlemFudHcr?=
 =?utf-8?B?cHowZ1hLSGJTcHlZbHJyRS9ySkNCSFlGZVYyeDc1eWpYTk1CREs0cTl4Z2tP?=
 =?utf-8?B?OWlOR3F6R1JkVmVZSVA5djA5Q1UzMENJZFNraTc0ZzdRNFgyVlBod0pxUzJM?=
 =?utf-8?B?enBkOFo1V3BFejVKYXl5RC9UOURoM2hZdWtSTkFxTUR4c1dxcjA4MnExOVp1?=
 =?utf-8?B?dFpma2loWmxJY3AvVTNHTVJnYWU1ekNrcGw0cHk5b2R6MDdRT203aUt3bXBI?=
 =?utf-8?B?dlh3TDA4VkJQMmtRSnFoZHVPcU9EY2VzSDQ4UmJMNWp4bE1INHlJeUlXR0Y3?=
 =?utf-8?B?c1BLRDBPZGJCUFNFMWNxaFhjM0kzRmtlNzlWZGYzbnVHUmdCTGdTandZNTNM?=
 =?utf-8?B?N05oNEthWkZYb0tmekFZT0c2M1l6WUs3cVZxQzNtTzBFZVdmT1pWaHY1RVlO?=
 =?utf-8?B?N25ZbWZXMXlvS2JyRUhGdUlSQ3c1SFFCMG5EM2NLNGtHb2pPclBDajMwR25q?=
 =?utf-8?B?aXFweWJDMVVlTUxIdzBrY3VUcCtYYWErakY1RnBNR0FZa3ZTT2V3WnBpV2No?=
 =?utf-8?B?ZytYcnI5OWxZamVLTCsrbU5NK0J0OTBQVUZWeCtVb245bXlmK3FrV21Qbmtn?=
 =?utf-8?B?YUpreDIySHBCYS9nVmZIcXcrSUQxYzJuOGRsVzBtcFM2azBCcFl6Tm1ZTkhn?=
 =?utf-8?B?VEVpdWFrRTl3RTRUWnVyUzFUam1rK01KVzJnUTBUd25TalBPQWEvQmhEZFd5?=
 =?utf-8?B?V2djRkV3cXFXbWFDZTErSWtRVWJDUFE2TFVOeSt2STN1LzJudkpYbnN6TFlu?=
 =?utf-8?B?a3FTR2JZK3BUenhWOU1reE5hb21rLzdaSWFGZk5USWE3aElzcFUxZi9IWmw3?=
 =?utf-8?Q?PrDGZ1PNiHcp4VAoUkjNSNyNJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea0fb70-abd6-4d18-dbdd-08dce959f394
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 18:32:52.9105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wrvC+/woMFzUteXAGINRAvWMgl5KnDM3pDJxbxQsHn5qOr4jG1EoANSKomsge5bsHbhSXKYQQNBtUaEQWGIMgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7905

On 10/9/24 04:28, Nikunj A Dadhania wrote:
> The SNP command mutex is used to serialize access to the shared buffer,
> command handling, and message sequence number.
> 
> All shared buffer, command handling, and message sequence updates are done
> within snp_send_guest_request(), so moving the mutex to this function is
> appropriate and maintains the critical section.
> 
> Since the mutex is now taken at a later point in time, remove the lockdep
> checks that occur before taking the mutex.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/virt/coco/sev-guest/sev-guest.c | 35 ++++++-------------------
>  1 file changed, 8 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 2a1b542168b1..1bddef822446 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -345,6 +345,14 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
>  	u64 seqno;
>  	int rc;
>  
> +	guard(mutex)(&snp_cmd_mutex);
> +
> +	/* Check if the VMPCK is not empty */
> +	if (is_vmpck_empty(snp_dev)) {
> +		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
> +		return -ENOTTY;
> +	}
> +
>  	/* Get message sequence and verify that its a non-zero */
>  	seqno = snp_get_msg_seqno(snp_dev);
>  	if (!seqno)
> @@ -401,8 +409,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
>  	struct snp_guest_req req = {};
>  	int rc, resp_len;
>  
> -	lockdep_assert_held(&snp_cmd_mutex);
> -
>  	if (!arg->req_data || !arg->resp_data)
>  		return -EINVAL;
>  
> @@ -449,8 +455,6 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>  	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
>  	u8 buf[64 + 16];
>  
> -	lockdep_assert_held(&snp_cmd_mutex);
> -
>  	if (!arg->req_data || !arg->resp_data)
>  		return -EINVAL;
>  
> @@ -501,8 +505,6 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>  	int ret, npages = 0, resp_len;
>  	sockptr_t certs_address;
>  
> -	lockdep_assert_held(&snp_cmd_mutex);
> -
>  	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
>  		return -EINVAL;
>  
> @@ -598,15 +600,6 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>  	if (!input.msg_version)
>  		return -EINVAL;
>  
> -	mutex_lock(&snp_cmd_mutex);
> -
> -	/* Check if the VMPCK is not empty */
> -	if (is_vmpck_empty(snp_dev)) {
> -		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
> -		mutex_unlock(&snp_cmd_mutex);
> -		return -ENOTTY;
> -	}
> -
>  	switch (ioctl) {
>  	case SNP_GET_REPORT:
>  		ret = get_report(snp_dev, &input);
> @@ -628,8 +621,6 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>  		break;
>  	}
>  
> -	mutex_unlock(&snp_cmd_mutex);
> -
>  	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
>  		return -EFAULT;
>  
> @@ -744,8 +735,6 @@ static int sev_svsm_report_new(struct tsm_report *report, void *data)
>  	man_len = SZ_4K;
>  	certs_len = SEV_FW_BLOB_MAX_SIZE;
>  
> -	guard(mutex)(&snp_cmd_mutex);
> -
>  	if (guid_is_null(&desc->service_guid)) {
>  		call_id = SVSM_ATTEST_CALL(SVSM_ATTEST_SERVICES);
>  	} else {
> @@ -880,14 +869,6 @@ static int sev_report_new(struct tsm_report *report, void *data)
>  	if (!buf)
>  		return -ENOMEM;
>  
> -	guard(mutex)(&snp_cmd_mutex);
> -
> -	/* Check if the VMPCK is not empty */
> -	if (is_vmpck_empty(snp_dev)) {
> -		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
> -		return -ENOTTY;
> -	}
> -
>  	cert_table = buf + report_size;
>  	struct snp_ext_report_req ext_req = {
>  		.data = { .vmpl = desc->privlevel },

