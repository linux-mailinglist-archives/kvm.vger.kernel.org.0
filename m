Return-Path: <kvm+bounces-38790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9300CA3E5D1
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 21:25:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C4F270176D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E1A264611;
	Thu, 20 Feb 2025 20:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PGiEtmcw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04812135BB;
	Thu, 20 Feb 2025 20:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740083039; cv=fail; b=srqh8I5ZcFa0LQaom3BRXNo7wfe/2EnxCwGxi8oXOjQEUmgMqz/ORmkJAvXdjilkR9CM1h2BzAWp7pRHaYTEedWh3a7y7RBaEabMCCv/n27Ono+8F+RfGtKLq14hBYQvyeqTuMIg4Q3PVNwSJI+z+4R6a6faArYdLxF0dCW0NyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740083039; c=relaxed/simple;
	bh=GKRCrXtlrBWRmk2P/7O5c+LwSj9dOiHr4q6fSsDMU5Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VZCpP1aRuz/vDbTObJYqOsbpFxpO7rqgmcY9oHowSPJNlr3rfJPoEsnTkckDLYsJawj2eT5I+F5Yt5WQF7rFtW6uWnjeYSCfeFNHERbg5Yty/q6dDMCgNiOLLnpHG7s6H4ttvBmxMQH9w5jUCDH4oC47nKeHGmL80H8057QZK2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PGiEtmcw; arc=fail smtp.client-ip=40.107.92.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r8irvRURVyrr2JQbw574mxVrQZp11KautokLIR69c8U+YWTTUiCODArWJpauWsuVZtcH5DY1HJUpYfNnvJBbldfL/rzL0zWpuNrAMB3Llxkz8ZhHsF4Hblc8ns9Xuv+MKhECkfAM92jipfPrVSSqYYxlKrh8wj7ClDmgEK0hN3wC6CJr1Ec2lzPQs9PMxPkc/Kbm/IldwTsXhRTqn63Z+ZpQ5H+RvUFA95D0W85ZZeLzSaC+gMD+/ZPBSpZsQ2CwNN6/vfKadwAWh8I5zSUItpQzvmjC65qyqQJ7Jf2cgd+qfbxUJA3eHgau6QCOoGdD5rvmFZwvmF8U6URv5fr9zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZNeapccyKSEizmx30Q+9G2eomMPkaOTzP1cKqaFyfc=;
 b=hEHFGLVU6vcUH1jWCxvEKnSiL+W9EJTARA5ntZT0dsh9UdQj0rP2rm8BGFj72/XRekTirV9j9hEq8NnuCajHVsDwcKpv8n17ijLGxH1hZrwWNF7RiHRawtURr3dAANRc8AOISFLJt/HfetyWYBfeieZ4xSngYl2e6rPIkRZxysrNBBSPKKyR+ns41n7l1WHsaBpK3L9mllFB6BSP4/h/9sJg6ixwWmqwZp3RXPAJIOelqjLJiifr0eCQujNUWgDe+hZuIAQU5TzNBoALTec50uy/cM94Y7LYhJNyihi2zbfMETvIxW3xxfCBV6Ohhhg+3nAv+84B2Sb4GmKOiZ4qKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZNeapccyKSEizmx30Q+9G2eomMPkaOTzP1cKqaFyfc=;
 b=PGiEtmcwXBhXw3fK1O4SUYLdnTYtSFTFwS9DNPWKU1gvFmoULT6GFXxlQNUyO8vdnxNOYf70c0AA0n8HbRhqQ6ilyIvEqjM+eaaWScZej7pXiEAnbR/kU+8fS01ldsoqQY0syEpVDAFghHbQcV974hVsx4MBQvXC/R3pDbH60bU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BY5PR12MB4324.namprd12.prod.outlook.com (2603:10b6:a03:209::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Thu, 20 Feb
 2025 20:23:54 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8445.020; Thu, 20 Feb 2025
 20:23:54 +0000
Message-ID: <cc89eda4-d1f8-48e1-9bfd-d550846e2d84@amd.com>
Date: Thu, 20 Feb 2025 14:23:52 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] crypto: ccp: Move SEV/SNP Platform initialization
 to KVM
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1739997129.git.ashish.kalra@amd.com>
 <8ddb15b23f5c7c9a250109a402b6541e5bc72d0f.1739997129.git.ashish.kalra@amd.com>
 <68daec1d-63b3-ecc5-f8c3-9df8a905ec88@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <68daec1d-63b3-ecc5-f8c3-9df8a905ec88@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0385.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::30) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BY5PR12MB4324:EE_
X-MS-Office365-Filtering-Correlation-Id: 886b247a-909e-4748-1aea-08dd51ec7f40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VlBxTGVDRDVFMjBJM3lNSmZPSGt0VFc3akNWM0lWUmdMbHBhWENnSWxsY1d3?=
 =?utf-8?B?cHUzSzZsWHdXQXVXRE83aHpodzRaYmF6NTVsQ1FxczZnd1FOTklwMDRKbkJn?=
 =?utf-8?B?a2lXZVBzMTlDUXlVZjU4N0p0VytQdDBlUUpQR2ZiTkRPbFBXWk9VTzR3OUpk?=
 =?utf-8?B?Y3QrdWFiK3ZlRGIxQ3QxYWJjVnA4UEQzSURwdlNQbmZOZTZFSnJiUzJXMVhy?=
 =?utf-8?B?dE93T1ppTGFEendnclNwYTYzMzQ3QzJNYmZGMjRwVGFmdS9oOGlvN2w3MlJC?=
 =?utf-8?B?bzRxcXUyZVBHYmpzSGYwZnA3S0cveDJDeVlvbzd6NW4zeFdpNjZPRjNJNnF3?=
 =?utf-8?B?NUJvNVV1MmhMQ1NMMm00aytEVmptV0ExclNoeUxNaHgrYmo2RG1BenA4UDRw?=
 =?utf-8?B?WDZmVkdvZFN5b2RBVWJQRlBzc0c5QlVodC93SVZaQnNscStHZHJkalpRYk5n?=
 =?utf-8?B?VmhTQm5hUUQ1WjluMVIrRzAvZnlPZVlCbnR3ZytUWTdseGxNVFVzdFZjc0xT?=
 =?utf-8?B?RjZWcFk1RllXeml0T0JUZTZIUFNiSHNVSFBSUmJVZDNrSGhiSnA5MkdjV0E5?=
 =?utf-8?B?OUpMcUdYS3VZazR3Q0cwL0I5bVVIMFBWVHJ4SUN6L0lhMFJsc3F5U1IrVm1B?=
 =?utf-8?B?T0Ntb0dRaDdCVUZWbis1WGQ1Ulg1NXQ0WE5velBBZ01ycWlkYjVVdkpXMFdU?=
 =?utf-8?B?YzlRUDBrajErOFduNEZtT1VzT1NLckQvQkVyMWUwRnYxWWJmYTNSZW5XN3Ja?=
 =?utf-8?B?dTM4VHI1dExEbWZTVEFmRW9DSWk4WlVYdkk3dHlUblVKRkg1RFZqcWdYd2ts?=
 =?utf-8?B?QXAraC94RmlNWGp1ekhlUW1rcFVQRnBBSzZkcDh2TkxYQWZ0eWFBYmRiQ1pM?=
 =?utf-8?B?QTJ5MGtyWkh6YnpPOVNMZlJ3cVhXajlRVnNsNlpBemVSM3h1UVNTeEtrNHU0?=
 =?utf-8?B?YmFDZnNMZFJEenhxVno4YWdQQ0ZpTWluVFNxTUx1UjFmU0JLU2Q1eDk1WkZn?=
 =?utf-8?B?a1MyZTZWWU5OUHNOODNMcytWYVU3M0U1UW14T1JzcGpTQzZ1UDVYSGJ1ejVz?=
 =?utf-8?B?WWE1bVZEREdRZ0MrODVreHNaM3Boam5RRWZwSStCekhuZyszOUhJUmtyeTZ0?=
 =?utf-8?B?aFB0dVI0V0NIUS9RU0JYdWVuRW5CcXI0bWdld2VTbUZodHBSZkNPTzFnWElZ?=
 =?utf-8?B?MzhXQkdTYnRiV0NLdlZuQTh0SEtFNlpGTHc1SnFRTzRVMWFMSERmYVhtV2FV?=
 =?utf-8?B?ejl6aUlzZ2JiOG5SVmhvVDRocFdpNGhadSt5RWE5aU04eTBoZHp2aVhLWFQ4?=
 =?utf-8?B?OEU5YWl2a0FVeEZENEx2RzliaDRFK2VTTDNzWGRRcitWZmx6TnVNdmQzaDV4?=
 =?utf-8?B?bFc2bjBJWXdESHhSRTBOc1hqd2VvRVZaTy91TUl0dXVFcGF5YVB4K0tjS25p?=
 =?utf-8?B?Q2ZJWWpFSmF3dlcvS0FBRVEwWGdOUlA1THByc1dYVjkzNFBLUVNKMUcyRmcx?=
 =?utf-8?B?VnhlaWhvU3lsWHR0YWNjVkZ1ZU43cTdobkQ0M0szMXFCQ2xLckZLQkg2TUYr?=
 =?utf-8?B?WVhPOXAzUkpZU2pibTlySkRta01RcjB2bkFqUVp6SHM1cEdQTWc3Q3IwS0Nz?=
 =?utf-8?B?ak1heDhpdHNJbGd5bVdVQlBLVnZVV3JsSG51azRhcHEvZklNZlV5QTZVWDM5?=
 =?utf-8?B?OUp3dkhMRkVNczlsczZrSUVQeFI0aFVQa2tWd3JMZkpqWEpldWY5SU9pdTVY?=
 =?utf-8?B?ejFReGhZd2tDR3c2TXdkcWVyZVljTUpQaEx2dThEMEJmbFJrSFhjRHVVRW14?=
 =?utf-8?B?VmJNTEFyRSsvMUlNa2VJMVJFdkl6Q3M4emRhVG5jMmYwdWZ3ZVZJVGE2TEVt?=
 =?utf-8?B?VUVSVExDZFAvNE5rZ1FRRXR2cllSSnVxdlVxWDkxTHNuZFJmNzd3TjNZYUJx?=
 =?utf-8?Q?yOibWEtmgLM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1FiTFhkZUphUjNxd3R5M0ZiaDNZSFlRM1VKTkFGY3R3T0U1R09IZGlpSkdR?=
 =?utf-8?B?cWVIcjVZdk9FSVpZNFRvSkdXeklpNjhYUlduakN3dUUzWUx4L0gycDR0NlJx?=
 =?utf-8?B?RXpsOUhRbWlSQVZsL0M3amxxS3dWT3FCTUg2ZStBWU1SQ1FVa1I5M1BydEpk?=
 =?utf-8?B?bkFHMU9PLytJa05LZXlaQXN2WGc5MERVeGxYQXVPdHV5ZWpzWSt5ODZiL3lV?=
 =?utf-8?B?UzVia2c3eEVtVGVMa0krQUJtYjhRTkpDNTg4UEpLcmM0RC80aWxHeEw3dWxD?=
 =?utf-8?B?VGVNNjE3YkRKSFZIeFZhTHZsUS9SSk9rWmVMTnlMSEs4NmkwOStBSlBFWFJX?=
 =?utf-8?B?MmJNdUZONkg3MThCd1p2Vng2MThkZmtlbVdIMjQ2ZEZleW94eGc5cVBnd0NZ?=
 =?utf-8?B?NWlUNzNFSFhLVWlrRUVGc211b3JFN0I3SlVTcGtuN2xaMjk5WkdsWXdqZWpv?=
 =?utf-8?B?L0FVQmdxTG9lT0NQY3RwN3ZnVy93U1U2d3RISFFaSy9sMHJsTlhDKzM3MmFD?=
 =?utf-8?B?c3J4b1BuanB3YVdubXlQQ2xGa2JVcDdVbWNMeVg3R0V3NmZNeE1aUFlxcXdK?=
 =?utf-8?B?WHpOWjRFYVdiQU1RMjlLYzAwZmNlb25PblkzbVA5VHNZY3JRMEtXQ1NvMFFy?=
 =?utf-8?B?dHZHeGM4L05vMGVQaWdDdFhnL3lTMk5QVzg5bnBwQU5GZjBLM2xPbE4vcURV?=
 =?utf-8?B?ajB0cEpsWk9QZ3RlWFEvU3ZUWnlkNTNGVFQwMzBzUE90V282UnErcWxNUUxM?=
 =?utf-8?B?SElHczZCVnl3UjN6TlYxZlJsYnR5OGVXemQzbm1FK3RMUHVFQXVkKzZwSm5o?=
 =?utf-8?B?WDV5Y3FHd3R5VldUSTN5T3lJYUFJdlBZRjRHY0VVSmJ5RTFUWHFjNHlIR0Rh?=
 =?utf-8?B?U21LSHZBSlRTb054aXlBUko2UVd5OEQzeFI0RHRMd0RZKzhoQnl4MzgxYmdj?=
 =?utf-8?B?eDV3YU03REd4blBsY1E4UTEvM0E5Rlg2TndDT1c2aHNTR2NLZVJ3WEo0WXEr?=
 =?utf-8?B?Q0FjSndOMUdST0sxME9SRVJTT0ZRU2JyTFdsUm4xT01vMmlQVTNERkJCaU9m?=
 =?utf-8?B?dlFIeU9zSnlDZ0pIaGJmUmZpazgxZnQvVUhJblFocTA0aEN2bjlPNXp6QlNW?=
 =?utf-8?B?MEVMTk9XRVdTMmJZdFJNczkxeUF1UnlKNERwRlNpcmRqanRWaHJka0oreVZy?=
 =?utf-8?B?bHVJUEc2NkpoYUxEeTMyaEtCM1Jka1B1SXg0TmZGcldoVllWb2dnbmJzMEw3?=
 =?utf-8?B?UW1mY3hPcnJrQWQ4SmVpRkNDMHhJc2w4UUJuUkszMWlRbVBOQnlJUFBZVDNl?=
 =?utf-8?B?bVJCN3ZvK21LSnc2cW9rdHlzUWNRU2R4UjM0cVM0Q0NMZExhbHE4blNxOHl2?=
 =?utf-8?B?RFlBMXBJNmpiNjhoc0RwOVhDZXJTQVlCMS91aUs4ZlM3THg0aHBncE5Dc21Q?=
 =?utf-8?B?UmpYeDJhVWIyQkVQODB5K2c1ZzFvN0MrRytRekc1enVWMVZVTHZ1REg1WFVG?=
 =?utf-8?B?V0s0ajZCYVVPbmY3cTRwQTJTWDlCa3ZnaC9DbVdPLzZoNWFoa3JyQndBSEo3?=
 =?utf-8?B?WEVZYVZLT1ZYajFrNzNFYVRzd2tMYlRGZ0UzZHh2dzR2OUJoNmYvNDNnMEtu?=
 =?utf-8?B?RzY4Z2tTRk1rcTFZc2tBVmZnTzgranZUSm5iUmd2SWE3OUl6enQ4M1NPeE9u?=
 =?utf-8?B?L014LzVaWUVSNlJWWDk2cHZWWHZ5YTcwNlVXUlk1UkgyRndDWkxneU1ub2p5?=
 =?utf-8?B?eW9sR3YzSDUxdWdscEFVU3BrUWpvM3E3ekF0YXF2SXdId3RtRStmNlVuZnlZ?=
 =?utf-8?B?OU15NGR1RjJ5OUFWdTF6RjVpOXNCWmsvcUVTdE1wTkRlWnhUeUQyZnl5Y3pk?=
 =?utf-8?B?ZFpwakVIQVpGUnlLd0xtdWNSK1FoM2RqK05Rb0ZQMGpQOUFaL2dlU2N6Z0h0?=
 =?utf-8?B?eXNiUDdWRlhGU0lVTG01dWVMOVlHNThWMjJ6UUw4dEFMbVVwOFUrR0kwY3F6?=
 =?utf-8?B?VkhQaDJNemQyQmJzL1hoUjNSMHhjNVBreUozU2JMc3FzcXV0T3dlK0JiejM0?=
 =?utf-8?B?UDZ6bEpSRUZ6MGozNEFXVmp2TVVlbEJIL0t0NlVQV04zSkNWbzFlT0tzZFBI?=
 =?utf-8?Q?0s8Lxo3P/U+2MaTOlzXiBGGDB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886b247a-909e-4748-1aea-08dd51ec7f40
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 20:23:54.6587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZyV2iJ7es6UsUDySa2DSG5Cs8tofljsXvXjS4YCcE3MKFFMYoBvLVS/9V2m7dQSYhEwcZmK+E5h1B0DCyw7Vgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4324

Hello Tom,

On 2/20/2025 2:03 PM, Tom Lendacky wrote:
> On 2/19/25 14:55, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> SNP initialization is forced during PSP driver probe purely because SNP
>> can't be initialized if VMs are running.  But the only in-tree user of
>> SEV/SNP functionality is KVM, and KVM depends on PSP driver for the same.
>> Forcing SEV/SNP initialization because a hypervisor could be running
>> legacy non-confidential VMs make no sense.
>>
>> This patch removes SEV/SNP initialization from the PSP driver probe
>> time and moves the requirement to initialize SEV/SNP functionality
>> to KVM if it wants to use SEV/SNP.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 25 +------------------------
>>  1 file changed, 1 insertion(+), 24 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index f0f3e6d29200..99a663dbc2b6 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1346,18 +1346,13 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>  	if (sev->state == SEV_STATE_INIT)
>>  		return 0;
>>  
>> -	/*
>> -	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
>> -	 * so perform SEV-SNP initialization at probe time.
>> -	 */
>>  	rc = __sev_snp_init_locked(&args->error);
>>  	if (rc && rc != -ENODEV) {
>>  		/*
>>  		 * Don't abort the probe if SNP INIT failed,
>>  		 * continue to initialize the legacy SEV firmware.
>>  		 */
>> -		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
>> -			rc, args->error);
>> +		dev_err(sev->dev, "SEV-SNP: failed to INIT, continue SEV INIT\n");
> 
> Please don't remove the error information.
> 

The error(s) are already being printed in __sev_snp_init_locked() otherwise the same
error will be printed twice, hence removing it here.

>>  	}
>>  
>>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
>> @@ -2505,9 +2500,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>>  void sev_pci_init(void)
>>  {
>>  	struct sev_device *sev = psp_master->sev_data;
>> -	struct sev_platform_init_args args = {0};
>>  	u8 api_major, api_minor, build;
>> -	int rc;
>>  
>>  	if (!sev)
>>  		return;
>> @@ -2530,16 +2523,6 @@ void sev_pci_init(void)
>>  			 api_major, api_minor, build,
>>  			 sev->api_major, sev->api_minor, sev->build);
>>  
>> -	/* Initialize the platform */
>> -	args.probe = true;
>> -	rc = sev_platform_init(&args);
>> -	if (rc)
>> -		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
>> -			args.error, rc);
>> -
>> -	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
>> -		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
>> -
>>  	return;
>>  
>>  err:
>> @@ -2550,10 +2533,4 @@ void sev_pci_init(void)
>>  
>>  void sev_pci_exit(void)
>>  {
>> -	struct sev_device *sev = psp_master->sev_data;
>> -
>> -	if (!sev)
>> -		return;
>> -
>> -	sev_firmware_shutdown(sev);
> 
> Should this remain? If there's a bug in KVM that somehow skips the
> shutdown call, then SEV will remain initialized. I think the path is
> safe to call a second time.

Ok.

Thanks,
Ashish


