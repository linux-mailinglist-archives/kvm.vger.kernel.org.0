Return-Path: <kvm+bounces-34749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F010A054CA
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 08:47:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0B091887A62
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 07:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADD51ACEB5;
	Wed,  8 Jan 2025 07:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A10TZbtr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1781537C8;
	Wed,  8 Jan 2025 07:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736322451; cv=fail; b=bde3JxIqDKx8HyZTxm6sJKoWK0lGHLtioDFKLKBKfsu6GZayPNlaZkZlV24Lqn0BIScYlGXbcdRjcKx4Wfs3ckE11tQwMiKeu9RACDysFZUqg3EC+yC6zDV0mNJFnFsRRVxm7dlrT6F67jbEjWOya3hsebv6ytDFkwGlqRiA2fI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736322451; c=relaxed/simple;
	bh=sxDgyw2sw8SvE26vju0eDKPK8wYZjn7H5Gtn6h4/qUk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dd+euFIrh6/nbZNeFHmC+9bAbzxeV9yGco18bBwQqwTvRNHLv+nUvhvmxeSvLKcamEWoA4py44KcLQkOjtexbYcFq1pSg4pXFXCAgHgr2OFQNZnCMtKDiTNMWiHQ6/pATvznoJL3Wh9UWvwc1+2vMk4xnu3sXDkdcy3cnKTPGpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A10TZbtr; arc=fail smtp.client-ip=40.107.223.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jmO7nJt3OBeXQ3vQTbeTxDqY5OtxXFNu/eG8bWbwtafpbNRIZXeT20uMTyt8xqoZOT0B9l2PrRhwcBhS1QvW///CMRtLOhgVcs/Q/RGao+stDCcw/bEmegNOkcjrpRHGhhKUhlS7Vrz7dMV5iOzbVHihGYxt4QqGKDnW9MTE8h+IN4H7F2+48F9kac2m0N5uUywo2voxJgytYtnp7grp2cwvBlQQiPx0M5b02UpAMJpqnVpcdIibgzKufY0340ymh6eySIPf/7lHnLz8Lm4Q0qXnSfOs9VICk4/Sl/jOK9kVk6NHiRDuQkmmnV1OyiPbJgsVhV8rlTjV8zUJZR//hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ysu6EntOK+kIOn3BanzT9ZofX37KcNLyQoBx55dYPps=;
 b=O7JZ/Jy79IrA/1da2xqHo2QXf5NoAYxi9ZfJTYezwyXI0izXeTUsgEcTdt6vffVJMXaBI0ShsEny12hLfn1olebrAtx/OZxKgHy+f2T1R3cJq9B6PXgIkXn1jVOQG7acyNZdZjz4tcyeFLvqHFfa2ouAVkUNWsRxfEhvJRF/djXte4l+1OdnlskHvpcz2uoSDL6YZmts4CKQD4VN//pq4rvUAXedVyhadagHB0DOda1bfLnOpHoOTxjZzmCaoEZqfv+as4CpYku5N46mEUiPW4OKYynHDXxb8GLXjKIWUUG81Nl98uG3kBN2Aa1NayQO9Bi1r0N6PkLfqfQEIm1LMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ysu6EntOK+kIOn3BanzT9ZofX37KcNLyQoBx55dYPps=;
 b=A10TZbtrbTzH5cyjziFE7XdnMnllpYjpbVG8bA8IG0Ra/akvh59xFHU2tdhr+pSb5kqZC+GL4lXaxHBHnfRT8sdL8NHMy5ZKzjV/W8jC1ZQ/6tdJqhsK2G6kQa7M8l2GLxvvIqXCG2QGjF1eAACS9uBYKCA3JLO4xAkTlXFe/vk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MW6PR12MB8834.namprd12.prod.outlook.com (2603:10b6:303:23c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Wed, 8 Jan
 2025 07:47:23 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8335.011; Wed, 8 Jan 2025
 07:47:23 +0000
Message-ID: <c7165d80-ab7f-425b-8323-3f759e1e41a6@amd.com>
Date: Wed, 8 Jan 2025 13:17:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
To: Borislav Petkov <bp@alien8.de>, Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com,
 francescolavra.fl@gmail.com
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-6-nikunj@amd.com>
 <20250107104227.GEZ30FE1kUWP2ArRkD@fat_crate.local>
 <465c5636-d535-453b-b1ea-4610a0227715@amd.com>
 <20250107123711.GEZ30f9_OzOcJSF10o@fat_crate.local>
 <32359d64-357b-2104-59e8-4d3339a2197c@amd.com>
 <20250107191817.GFZ319-V7lsrjBU8Tj@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250107191817.GFZ319-V7lsrjBU8Tj@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0210.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MW6PR12MB8834:EE_
X-MS-Office365-Filtering-Correlation-Id: 70d7269e-51a0-4e3e-3d14-08dd2fb8b02b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TXhEUzRzWXFKZkR5VGtnT3RoWGc2TGl3anVUS2t2OVIvdFpWTlFoVEFxOEJp?=
 =?utf-8?B?VnloODNmUVBoNTNmaVdtMTZhRG9GVERtdmZQTlFpRk1Ga3h5M05SakVVTitR?=
 =?utf-8?B?dnlQTzV6Y3pyR3M1ZE44d2orSDNGL1hmYy9Uelg4OVhFVWxjN1NzS3QvK1Zo?=
 =?utf-8?B?NjJZb24xdUFBdmJPaHhMRU02aFNDc2JXUjhmaWlmbVRmU3VVNy8vTkpRaUlP?=
 =?utf-8?B?a1R4L0ZLUWhPWk41V3d1VkdpZ05vUmR0clBHM29GOVlLaUpROEI2T3Arc2Fk?=
 =?utf-8?B?YXhuLzJUSzZCZldtNGFFZlhVZ1VQallFZWNoYzQrbGtMNTBXSjBrcVl6cTJ2?=
 =?utf-8?B?VDNVenhpdi9HK1JtOXpYMDlhckNCZkNEaXYrQWduSWZXbGcydlJFMWNpRWxa?=
 =?utf-8?B?WHo3eDVjeGp4dGgrM3craVhxYURjYWJFL21EelVjNDREeWNHb0JDSzBVUnQ5?=
 =?utf-8?B?bk90Myszb0toMmtreittMm1uVkc4cm5hekRjUGx0TzAwWjhVK2hFRmpsTzNR?=
 =?utf-8?B?WWRITDZmQkF2cEtVQ0N1YjRnVC9wa05SZVA0VnZBa0hvR1FweDFBenUwTnds?=
 =?utf-8?B?cUh0Tmt2MjRmS1ovTkJTdHdqcFNuTU9aaFl0NmlzV1F4TXdmS1RmdkFjc0lz?=
 =?utf-8?B?c2pVL2NWOG9wU1pCeVI0SUREaXMvNDkwMVVtd05YMEZaM1laNTJyOTY4Q0lZ?=
 =?utf-8?B?MlBMRlhTbEJ5bk14Tk9IWXJGYmFXczJOOEtBOFN2V20zK2VJVjFPOTI5SHpK?=
 =?utf-8?B?WXJTQTUvRllZZUpqOGZPQysxMzVFT1p5R1FDaVpzS25pdUJjZENmY1JsL2NU?=
 =?utf-8?B?TnlGL2FRd2h3bzM4NzBJZnJtR0lRZGVUTzBIVnZXVzhtZXhveTh4NVhNdTZh?=
 =?utf-8?B?T2p2a3hkNkgycGI1aTc1cmZMYkpRdHQwVkVCYUNXbjlTZUhBL21wMjBHVzZ2?=
 =?utf-8?B?NGdmNE43VVV6MzliRFptQWxKR0ptUXkyWGxNRCt2RnhEZ2pwL2JwWk9zS0s4?=
 =?utf-8?B?bHlMVHRCT3NJU2s0anpPSDNwYjU0RDdGUk4wR1U1UU1MMnhIM2NKOFRFU1Va?=
 =?utf-8?B?M0JzUklldFROTzJPcnpPS0xWWFB1UVp4TXQ1dkMwMjR1LzlVb1FpM1YwS0hJ?=
 =?utf-8?B?K3Z3ZE00MytXUGRWUHlORUhjTkxIWU5TWTNnWnMxeTJOUlBFcm4wYWh0MWY1?=
 =?utf-8?B?dlNZbE5yNzNaS29NUmhWNUxEZ1dRTnVURkk5RDJxcU1HcExSQmpDMXFiZk8r?=
 =?utf-8?B?NTBpVXFOVC94bktzWUlEeDNOQnh4a3VNQlhrZjlBT0JtTzNFZlhvZFRwSk9C?=
 =?utf-8?B?TGk3Vy9KSFR5K0JiS2RBQUJ0U2phaHBmRFZsZTZIYXlzaWVHZ2U5ZkdCcDhS?=
 =?utf-8?B?T0g1Tm9aalBzUXdueDBPajYwM3ZvM3RuQnRMRVcvQS85QmVZTnVlV3FPcmcy?=
 =?utf-8?B?YnowRkFucXhtSnRpZnZ2OXExWkVSeTBCWSswZFNaNU5RcSsyU1lkYThubzNu?=
 =?utf-8?B?L0ZncGE3RjJ4eVlhOHZmVndoZVZwdnRxWEVRS2N1d1BUaXNsenpUMnBnYWgx?=
 =?utf-8?B?QU5oVHF2cm5sZFJEaGZZVHNuOUgxZDJES2VRNVgvU09sMlp1Qk1hK0U4MUFn?=
 =?utf-8?B?T01uUyt4WVl0NE92dXFVUVBYMmFvdHJ1ZnN4WUZSbzlyMlFkNnpnckhiYzE5?=
 =?utf-8?B?cEVXcVdFMmZ1NDF0b2t2elBISGFXcHBiRGtBcmNNR0FodS8xdmNEUjBWVTQr?=
 =?utf-8?B?U2dNVXBmQ0VLVUFScDNlVTdqalZUSGQ3K0NwOVBkeDlNVDRCRHBlYzBGNTlD?=
 =?utf-8?B?cXVBMUF3SWhBM1dMU2xzbHM5TCtvWFN3QnQvQm52ZHBUS0txeU5DcE9PWVc2?=
 =?utf-8?Q?QK8jfwuDA863h?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzJWVWtnYWZWbWE3Z29QclFMZzRKWGQ4ODZncmN1N2xrSTZoSXFyRXY1OUJa?=
 =?utf-8?B?R3A4eGJEa2xjUVBObDR6akxVRG54VmpBNGNYQ1VsN3U1aFJna3Z4b3BHaVZv?=
 =?utf-8?B?bFROVExqMVpWYUlnOWNSNUFlRTdlS1I2eGNmazIxbUJBaC9xZDhKV01Bd1Rx?=
 =?utf-8?B?N2hkT05SeXFPWlhlSmptVGQxSjFmcHJKZmhiVVBZTHVSSFc4V2hTTHVWYkM5?=
 =?utf-8?B?Tk01RG1iQXIyandDZlNFQnlLRXZJb1VXcmVlRUpEOGZBeWQzVUNpNHpBUy96?=
 =?utf-8?B?VFo1MzY2K0VwUEtVd09NbDVoL2RiSEtJNStSSEN0Y01XaENMcXdjY2d1YVpt?=
 =?utf-8?B?aFJPbElVMzY2Zjk3c0Zma1FnYU1lcm0xQkVPS3hOUE0waDNCTDJTV29tMnlz?=
 =?utf-8?B?b09vR3JpRlQxSGFoeUd0WWVvTDAvd0hZVnRacmNSSWNyczd1NklWSEhkRzlR?=
 =?utf-8?B?L0dmMUVDbjVaV2djcUJ4K1VaK3U5RlQ4M1JIZi8ySjM0M3dKOHFJM0lHMkFU?=
 =?utf-8?B?VHFGK1hhckdyekpaSzhHajhSNkJZaW1rS2xmSnFidnRXU3RwdDZPekpDaWhx?=
 =?utf-8?B?TUI1OUR2dWJjYlExV29WY2s2NU9xanNiVzlKL1lzRkpnSFlzN205emVvamN3?=
 =?utf-8?B?ZFIzTVJOdlpGMmpKV2R3Nk1RUjhYRWtmdUpDMDhFbEVOb29Ya1o3aGNDQ2VM?=
 =?utf-8?B?Wk9BSFRtRk43ZUdoVllWSEhtZ1NvdFNUV3dTT1ppOVZmV1J0VmFBeG1nWHlD?=
 =?utf-8?B?SHk1WkpZcEpTT3hocmplQ3BBQnNySFlpcUJySWJLOU9YMzk4MCtBT2h0T250?=
 =?utf-8?B?dlk1TUhTQXpOdzJtVmcrK0hiajl5NDMrTXdJRnNEZW0waWFDdTE0SVRUYkhr?=
 =?utf-8?B?dWFxcEdTQ3R4czlqMExmR2RUY3hoTHhXTkJGV1FMQjlRdGxwOUE1bW4vcVpE?=
 =?utf-8?B?RWUzcUlXMWFteXFNMytJaGhrQ2RrMWNVb3l1dTdkaFIwd2lQZjltak4wdVJh?=
 =?utf-8?B?RFJvK3ZpdTdzV1MvTUNYWm8rRWg4VzJpcnJTVFR0MzFPN0FIRkJ3cy93QkNQ?=
 =?utf-8?B?aU9PM2s2aDA4Z2JGVXNyaXc0WkF2SFFrNDNSUmNiUkFoSzNmVHVoUVRzR1FE?=
 =?utf-8?B?T3I4b2ZNOHJvWldHZTNtNWpYK05hN0o3cS9MWHRiZmxoUjY3Z2lFRmw5c3hi?=
 =?utf-8?B?UXEzMVhPaHdRaVVsaGVmTU5BSWQ2SHdiVzV5S05XeDVMMjJBR3YxZ1hXOUVm?=
 =?utf-8?B?Wm9jR2o4clpWWmxnUkdxL012aG92K0FuL1ZRdy9VQUJYVy9HcHBMR2Z2bGRY?=
 =?utf-8?B?elRtVlVBVlFOSmF3dzhMRGhQckQ1WFB1azA2YlVYeWVlYVN2cU81U0tpVXFM?=
 =?utf-8?B?TkdpMEN3RHJLenhjNDJmUFFoT1FFYmd1OTVQMlZweHVkMXBKcFdNQk1mVzUr?=
 =?utf-8?B?YmxiQ1VZOHB0dHJ3dlpmQkRkMGFSY0ttZ2ZIbmRVUGVkaDRaR2VvS1NldG0x?=
 =?utf-8?B?ckFTR2lDcWJibUhaM3hCM3BUOHZ0ZncvOUoyV3ZCWkxRc3dsTnVQK3JaK1FW?=
 =?utf-8?B?R2hMZElzNzVXWlhlbGdGaFBkM2lZYkZEbzFMZUJNakI5blhRaWo3am9rVVFy?=
 =?utf-8?B?b3dCMWJxMkpuZ3NxWGtXWUkrK3ExK0FTUXhsZXN4dnBoZzk1QytHUmozRyty?=
 =?utf-8?B?Yk5SLy9mMVc5aHRUSE53V0taZEI5V2g5UHFrR21OUmcxRkp6bFYzWUVRMjQz?=
 =?utf-8?B?a2IxNnY3T255bDJRU1l5d0ZpWFpkdTB3U0NZY2RkY3NDd000dGZUb29mMkls?=
 =?utf-8?B?YWZDb0NwVW1KNFhHa0xmTklaMGRYc0dkbEwxR1U5bFN2cDIySFl1QlNsT3kr?=
 =?utf-8?B?bWF0Wk1nTi9IMXR2aGdYVjNwOWthY1BTWmh3SWN3SmljVzdGa3I0am1ra1Na?=
 =?utf-8?B?azBGUjVMcitMd3ZmdXNXRWpHVDVuVkppOTBKeFJSM1Azamt2MDE4b3NRcFN1?=
 =?utf-8?B?NFVzWEQ1eUVKK2pleXo1UzVGYlJPTExxdS9QREtJUjJGTjk5b0hIREwvWmR1?=
 =?utf-8?B?MG5sQ2h3N0lJZElHOFVNSzE4NjRtZGZQUFUxNTd3cS9EMXZ3WExPQzdnbFFV?=
 =?utf-8?Q?DQW5oAUtnebR8g1r2LkHFNBcR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d7269e-51a0-4e3e-3d14-08dd2fb8b02b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 07:47:23.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQWGeIlgODU98Abyu8pSW5WuAmrGH8vhXRjv8ZtFdLhnv5S6C56E6o3d0kUmNcletuj1Eb4IX1CS+K2R0DSjtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8834



On 1/8/2025 12:48 AM, Borislav Petkov wrote:
> On Tue, Jan 07, 2025 at 12:53:26PM -0600, Tom Lendacky wrote:
>> Yes, but from a readability point of view this makes it perfectly clear
>> that Secure TSC is only for SNP guests.
> 
> That would mean that we need to check SNP with every SNP-specific feature
> which would be just silly. And all SNP feature bits have "SNP" in the same
> so...
> 

Right, here is the updated diff:

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 715c2c09582f..d6647953590b 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -98,8 +98,7 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
 		return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
 
 	case CC_ATTR_GUEST_SNP_SECURE_TSC:
-		return (sev_status & MSR_AMD64_SEV_SNP_ENABLED) &&
-			(sev_status & MSR_AMD64_SNP_SECURE_TSC);
+		return sev_status & MSR_AMD64_SNP_SECURE_TSC;
 
 	case CC_ATTR_HOST_SEV_SNP:
 		return cc_flags.host_sev_snp;
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 00a0ac3baab7..763cfeb65b2f 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -3218,7 +3218,8 @@ static int __init snp_get_tsc_info(void)
 
 void __init snp_secure_tsc_prepare(void)
 {
-	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) ||
+	    !cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
 		return;
 
 	if (snp_get_tsc_info()) {


