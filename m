Return-Path: <kvm+bounces-40862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A75A5E7F5
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 00:03:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FD6316ABB2
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 23:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99ABA1F130A;
	Wed, 12 Mar 2025 23:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VZ+7EIcK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0567217E00E;
	Wed, 12 Mar 2025 23:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741820588; cv=fail; b=ki5OFfhnG6MEXb+9J4qAbltjdDL+cnfr2XtrdwQzfigGdfAMUjDxioEC77oo3kTXrto96SCTRY7Nvxrjm9HiuBS42y3w2qP8giji41thJgMJuRwJ44bVLQLxeV7ZBDnggptUsNsHaczeZIESUxXB4E46DmX8y5glKdeW07Dthos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741820588; c=relaxed/simple;
	bh=iLrxdnfNLpaxcCRlRJpZvOTKptzfh/TCOyKAgRTPilo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KVpGGtXIG5nGfrp4dAJV/r9u+XiYqQnQ4WnfoSjE+iqAv5CnyHlHcJt8Ay95QHoj4HwI/c5dpL8S6HEUaHjTirE4fL2SgclrIu7Voh/cboaBQUFULhWaorcK00V/u0b5vC6lM+oAcIDR5HdHUwLz7ScF2cwqXkeKb1EI3nk8sg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VZ+7EIcK; arc=fail smtp.client-ip=40.107.93.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l/CHbvs7DqWA9AjLALtsOcY7TxWlPNUpYCOt8Q5Lm7tllWnuzgGN4O3GwZrX6CocF+dk+RBkWhymZv6tCFPS7YWJnLhzo9SVisrtuAV/4EUyFpnXs2UY7wX8SpQM/WIcha+f85P6q23hraPaKbvDYi9oRnXoL/qvIzWgDgcjBdMzAcW5eBci76CHy1Bs0xMJFaS9k2QI9L3fdwdlz4wTrKvBZE3Vhr1wcsvU2UKiWg1ackME+oBxoRA5tuErqGad5alehDOtkoO1zp6q05kR9/4I1gLnxF19ebR5F13K1bdyR0ac5tiN/Au/D/P7rziIMXIxyTovTryjWF6ZxfMwEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2kM4wgxcMOCHpVYs+qN2b0ZZ3BeVznZC5tx+kkVlNO8=;
 b=KPdNda0CU8fno4e3krOWWl4F/79+yntcahwHUhBDUc+XE+vS9OUSffC7eUikyOMLCa4LtxZfgkm2RrG1+vn/gw/dO+jKs6iWsIlN17/7VS3PoArT9bndt6WB3yotn2fX6/GEBNJ9eymo4hIX/aryX8Y6jlY1mTtHDNtzQZBdBgwsOC4qoODKcEB7aXa3vRXng4KHKaqIQ+0xIr8SOgwHmW3ld+HxVnfWicLHvdwqEgoshjqefFk5RiaClsLEj3wjFsUVjPwOTE5aF6b1l/quCXDSroo8MPr3B0uE6HRIqp82tYKytDOyRYmzsQWeOf1BUZaHFkts/4qJry0an5M+wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kM4wgxcMOCHpVYs+qN2b0ZZ3BeVznZC5tx+kkVlNO8=;
 b=VZ+7EIcKrF3z6OC4dpLsepnL/eZQqH9cfNDKUgrEE/9ui62nRcQ49LU/Cp0mAyPY3o4QAp9MoeguS4W/qFrF5EXsn9e76aEAdRqQXKji2eu4UBKH+7SYC8Fp1sbPl1MHgY6sZPVo47XxtQBvAngOXW7KYlWKR8nwnaEjxsSbGkk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by CH3PR12MB8754.namprd12.prod.outlook.com (2603:10b6:610:170::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.28; Wed, 12 Mar
 2025 23:03:04 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%2]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 23:03:04 +0000
Message-ID: <75d1f607-411c-47da-a5b9-1d434bedbff4@amd.com>
Date: Wed, 12 Mar 2025 18:02:59 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1740512583.git.ashish.kalra@amd.com>
 <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
 <Z8IBHuSc3apsxePN@google.com> <cf34c479-c741-4173-8a94-b2e69e89810b@amd.com>
 <Z8I5cwDFFQZ-_wqI@google.com> <8dc83535-a594-4447-a112-22b25aea26f9@amd.com>
 <Z8YV64JanLqzo-DS@google.com> <217bc786-4c81-4a7a-9c66-71f971c2e8fd@amd.com>
 <Z8d3lDKfN1ffZbt5@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z8d3lDKfN1ffZbt5@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:208:91::26) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|CH3PR12MB8754:EE_
X-MS-Office365-Filtering-Correlation-Id: afffe668-df17-443e-b9ea-08dd61ba0b61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N21naUtsd202a25jU1FZd2VSWnd6dVIyMEV3RUVBRDQ5OU1kNm5mMG8xOEFM?=
 =?utf-8?B?VUtOWG11bVk4NEk0S25wQlZPa0NBNXRnVGxTN2JIQ0l5blpsVWZKbE8xY241?=
 =?utf-8?B?eWtWYnBBSjBUSzZXL0dFRkppbG1MMnhHU3dDOFlaKzlTd0JQdm1KUFdxRmps?=
 =?utf-8?B?NEd6bWtzMzZPN2M5M0lEUHd6UG54emY0c240UndKZDhHOXIzL0dEM0pRZ21h?=
 =?utf-8?B?UzVCc0tYczJqZkRHUVdINzJaTEVrNTdrNHZxU2hiUi9YVkZlczFzaHF4Y0cw?=
 =?utf-8?B?cXp5d1NLMEpUb2xwVlc3RGFpLzhBWjVGUFRoL0tWYnFmV0lzOG5xcTQzbjVB?=
 =?utf-8?B?aElDQVFpQkhrK0xEZzJqV04wQW4zcGlkWmxndVVzNFFTd1pKblZ0RjY5NDVi?=
 =?utf-8?B?SU81WmFqL25XM3F6aUFuV1BHclMvNUdhd0VRQml5SkVaMG5zK08rR01UQXRu?=
 =?utf-8?B?S2h3QkFMTVV0bFZONVpXSi9lb2I2dWtHaFpFeU9LMVkxbmpZOS9MQzBob2R5?=
 =?utf-8?B?U2dDMk5ZR1ErSDlLY0x6dTZXNmx4cGg1bXVUNkU0QlNBZkM1WXJnbVNMcEp1?=
 =?utf-8?B?OUl5cUpKSHhsZzVVYzZ3Mmo4b2tpU2Jnajg4TG1vVEtOQXRFbDJhektkQjlE?=
 =?utf-8?B?UXgwWkliVEUxN0x1K1lFMlZ4cXo1YkhzVCtnVHB3WmtJWVlxbnpNSmowci9x?=
 =?utf-8?B?d2J4d0lnSDFYU2puM0haY2lqd3BRd3RLTmV6a3F1QWduZEVCQldYUkhDSHAv?=
 =?utf-8?B?RytBaUFKdUJXbE40eDB4TDR5alR0dFdMbFRUL25wcVFlQm9jdjZCSEc3cDRz?=
 =?utf-8?B?Tll6anlRUnJOajlkUkZYcnhSb3NnZzF1Z1pYUkNzZ3pCZUcwSG0vcUdLVjR0?=
 =?utf-8?B?bGJ3bWVsZTFlOUtFR3NEWk4xa2ZxbnJBV1Rmd1R0cDhwSkk3VnR0L1V0L3BV?=
 =?utf-8?B?eThzNFdLd0pJTk5ucXdFTUM0VURPOVc2VUJkdFROanRGMTBRT2dvbjY4RndQ?=
 =?utf-8?B?WWF0ZXFwMWFIRjJydGVJTGlyMEd6bHlSeFpKNERBcFRERDFPcXBnWEdSYTc1?=
 =?utf-8?B?NnBpTlZRS2w2bk9nUktTUEJROWhiS2JTc0FCZVVxR2NzOTBFQmxaQUlKZWR0?=
 =?utf-8?B?b1RWM1pNMnJkc2pZTjNVZWs5ZkV6VFpmMml5MTNxOXoyYkhCQVZLaExlK1Jm?=
 =?utf-8?B?SzdkY1hIL2VCS09Tc1FOZWFjNjNqejI5U0NYY0dZbEFQQUFYZ05vNVU4VzQx?=
 =?utf-8?B?ZlVzTVpiSFFJQUVWRkkyaW91dms4YTFFbVNIUVpHbXQ2TGluS1pnMG8xbGYx?=
 =?utf-8?B?TmtpVTc0bTZQWjB2MVp6ZXA0WnZjNFNja1NicHZqTTIxbVNvQ3FLU2Vqckps?=
 =?utf-8?B?SGwyZitudnNkSGNMamd2NUxNTE5BS3NKOXVSbXBtcnNyazdqTUMyYUV6RXJp?=
 =?utf-8?B?dGNqRFBodXlWOWpkVWttR25ZNjVVbWJCdGlIbm01N084b2ZNUUpHNk1CVHly?=
 =?utf-8?B?SVl5cklqb2l5UURvMFlneW5ReUdnTUkyZzVXR3lsL0dSOEFtZERCVjQxaGlB?=
 =?utf-8?B?QUdhUncwSytDWWowVzRlVFk2ZTZWWFhPY0hqaVlZcGZBSXo0Rk1Id1huRDVl?=
 =?utf-8?B?djBKdWExbFpEMDFnd3doYVpGNDZocTJvbzJkaHVxbG92aXVPY243NkxCVzl1?=
 =?utf-8?B?MVY4RXJjWmU5dVBockIrMDJ5WTdjTUxseGszTmVFTHAyWkpnL1dqOVU0ODRt?=
 =?utf-8?B?bWlvTG8zY1c2Q0dvbjZEN0Q5Q2tpZis1c2kwcnB2cVFiQ3l0b1hTUEF4Zkpq?=
 =?utf-8?B?L0xlMHNNWHEvL3dtNGxhZmRMS3Ria0g1VWpPMmlqQi9iMzdrMFJUYUNEUkJx?=
 =?utf-8?Q?0NqtRPbmetdcn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ci9DZjVDbjNPTEIvYTZ5NmlsTVRwV0pYdlFBSy9naktldnJuakswS0NMMllw?=
 =?utf-8?B?SUhERC82VzVEdVFYWWRHWjlJSDAzd1V4OVlDWWkrRjlRZTZlbWIwNGxRbDBS?=
 =?utf-8?B?Rk8yb1FtVloyK0V3UnhwbVlFZ3NQODNKNktWckdSRTAra1NzY0pMd1EzSHh1?=
 =?utf-8?B?VGkwMHZZekUzRmU3RkdhMnhrNlZJSjBzL1NvME1tbWZUdUU1ZmhUODYrcktY?=
 =?utf-8?B?UzhMcFZZejVRU01VQ0QwL3lCMTZCUDlRZndjS2F4YnVNeUozVGlLZU5OL3BO?=
 =?utf-8?B?ZVZiQVdraHp2blBzOHRBcFRTRCtDdlhJdmF6QkVJa0p4UmlUbkhnQThLbkVG?=
 =?utf-8?B?V2NsUW1sQm55OCttRU9SeEVOdTBkdGZVRjU0cnF2MVExZk9vQi9jUUNIb203?=
 =?utf-8?B?QmZIbkRXbDBwOWQrL3kycm50YWIxZzFSZE5DUW5ZZHdFWGU2RnRVT3RCeW9k?=
 =?utf-8?B?akRkd0xvQ2MwTUp1NFR0WTJlUUxOMjBPUklBRGtCYmhFbFlibDU3Ynl6UG9E?=
 =?utf-8?B?Ym8rUmN6UWZkNlM3M3owYzRnaTNRNUJ0blJKRHVoMjN1WmhwTk40a0VrUXkx?=
 =?utf-8?B?bGtPOTJORlNGT0Z0MTNERXFwU01ZR3pxQzIvTWtpS1RIUnhFTkFieVB0WkJq?=
 =?utf-8?B?cVNPU3QzcmVhb24zVGxTaVlFL2lsZGJXV2UvUkFQMWcwK2pTb0U4cERXWnNn?=
 =?utf-8?B?RlBnVU1KQTV1QWF0WWdxaXVwMGo4cjJLVmdxZmkrUEFqZUtQZzdNOWpoZUZQ?=
 =?utf-8?B?YUtZU3JlQjNOc3BleGRXU3NkZzlLOStRLzIvd0l1WEhKZHEvSWRJWE56YkRP?=
 =?utf-8?B?WmdyN2lzVHVzZDh3Sm1rVHFwUHlLUEo0end1ZnZFdXJmSWp5N2FLWEUzL0dv?=
 =?utf-8?B?cXN0R2lPOHZ0VFFWZGNYdHk3dmlNS0hnQ2dRRThlQU9KcGNpbExOUUFCMVVy?=
 =?utf-8?B?RnU0d0xTVmRVMHRZc0N0bng4K285b2ZqU1BZM0dZYVdnZDZkZWtPd2FjNXlJ?=
 =?utf-8?B?OEVwQ1Nick9OZVlSczRDYndMRVNWSzRjKzBsT1FYcFVLdmpqN2JKZnA3M0w4?=
 =?utf-8?B?NVJ5dDFZTlF0cEk3MnJtRlg2ZjF3NFMzUFdrZWVXYUc5UC9QQjI1cmxnamxW?=
 =?utf-8?B?VysxR2tDT0t6ZUNKQTFRcWxhSDM3cXZJNlAyQTRScmNINUhsYktPT1g2R29E?=
 =?utf-8?B?alEzWG5Sbjh3QWJSVkdEb0JTbERUdE4yRmt6c25xV2ZqaVdUOEdheE9aSXFH?=
 =?utf-8?B?S2NyemVya1ZyL0FqSXU0M3VOQzA5dFZaN3VRTmVQc2U0azM1Q0hCeEhHY1VY?=
 =?utf-8?B?YjllcTNNYmN2ZG11S0NIQmExZ0VLcnB0UkdiT2ZPQ0M3RmQ0cjk2aHZNamFz?=
 =?utf-8?B?RXkvbkJXZTMrWlhDalZzRnY5bTZ4REEvY245QjhDeHRCamo1Tk9aMUNuOHNY?=
 =?utf-8?B?RjNMcEdBUWkvd2lwUElwQjIvQm9DMm5qb0pqNHhOakRETXcrRGYvK3NQQnVR?=
 =?utf-8?B?c2tSTUhrMkQ4Z0RFT0Z6TUVVZ2ZDTHZyMDFkekVlemdaUzBZWHFySXRPNkVO?=
 =?utf-8?B?U2g2bGVROTluSFF1eG03MTZpVlBVbXNhaW5DdysrRGtTVExsUlpYUE44VDRx?=
 =?utf-8?B?b0xhUDluSkJ1K3crOXR3Lzh3cllrNXlENWt6aFlQeEdOQVFzcm1zRUt1dXNo?=
 =?utf-8?B?eExSMVNBTG5BSkZWbTVLZHp0aFhML0ZRWENZTHBSY1kzSVdYMXE4RXl1K2xn?=
 =?utf-8?B?ZElkbG15bFpldVl1REhzOHpoMVFIc2pYMU1nb3NIUWVrV2xBdmQ2a2p3d2t0?=
 =?utf-8?B?bjF4UjVCS3FNNlZQVnhNSUV4dW1vaEI1OWdpNXoxdW13ZWR3QW5EL2JRWHgz?=
 =?utf-8?B?UWVibjV4QkdSZWt1bGdySllzTlVpcmRQcmt2WG1HNmJ5dHpVQXFua2pLMzZK?=
 =?utf-8?B?VmZSSW8yVTRDR3F3ZDJreDlwd2tLTzBpVE9ZZFJPSERBQXJJWDA1QXhSOWJ3?=
 =?utf-8?B?Y3R0UXE4RWQ1cnE5UTlzcDk1VnpCeW11RzlxaG1ONzVCeHhibFhSVFAyV1ZX?=
 =?utf-8?B?MVZLRU85cnczdEdaUWVkVDFEdmRNY3NxakZEK2VOcGVTYWFDZnV2T05vSngy?=
 =?utf-8?Q?DreasCbWP0x8XRv5h1sKUuz0u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afffe668-df17-443e-b9ea-08dd61ba0b61
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2025 23:03:04.1916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wek5GC93qQJTdlxrI/5OVzxZwp3Ct+n7uf2L88vxGJR5xiobc231vlmNC00q61lITlxn8paTJwr/tN9cX4YAaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8754

Hello Sean,

On 3/4/2025 3:58 PM, Sean Christopherson wrote:
> On Mon, Mar 03, 2025, Ashish Kalra wrote:
>> On 3/3/2025 2:49 PM, Sean Christopherson wrote:
>>> On Mon, Mar 03, 2025, Ashish Kalra wrote:
>>>> On 2/28/2025 4:32 PM, Sean Christopherson wrote:
>>>>> On Fri, Feb 28, 2025, Ashish Kalra wrote:
>>>>>> And the other consideration is that runtime setup of especially SEV-ES VMs will not
>>>>>> work if/when first SEV-ES VM is launched, if SEV INIT has not been issued at 
>>>>>> KVM setup time.
>>>>>>
>>>>>> This is because qemu has a check for SEV INIT to have been done (via SEV platform
>>>>>> status command) prior to launching SEV-ES VMs via KVM_SEV_INIT2 ioctl. 
>>>>>>
>>>>>> So effectively, __sev_guest_init() does not get invoked in case of launching 
>>>>>> SEV_ES VMs, if sev_platform_init() has not been done to issue SEV INIT in 
>>>>>> sev_hardware_setup().
>>>>>>
>>>>>> In other words the deferred initialization only works for SEV VMs and not SEV-ES VMs.
>>>>>
>>>>> In that case, I vote to kill off deferred initialization entirely, and commit to
>>>>> enabling all of SEV+ when KVM loads (which we should have done from day one).
>>>>> Assuming we can do that in a way that's compatible with the /dev/sev ioctls.
>>>>
>>>> Yes, that's what seems to be the right approach to enabling all SEV+ when KVM loads. 
>>>>
>>>> For SEV firmware hotloading we will do implicit SEV Shutdown prior to DLFW_EX
>>>> and SEV (re)INIT after that to ensure that SEV is in UNINIT state before
>>>> DLFW_EX.
>>>>
>>>> We still probably want to keep the deferred initialization for SEV in 
>>>> __sev_guest_init() by calling sev_platform_init() to support the SEV INIT_EX
>>>> case.
>>>
>>> Refresh me, how does INIT_EX fit into all of this?  I.e. why does it need special
>>> casing?
>>
>> For SEV INIT_EX, we need the filesystem to be up and running as the user-supplied
>> SEV related persistent data is read from a regular file and provided to the
>> INIT_EX command.
>>
>> Now, with the modified SEV/SNP init flow, when SEV/SNP initialization is 
>> performed during KVM module load, then as i believe the filesystem will be
>> mounted before KVM module loads, so SEV INIT_EX can be supported without
>> any issues.
>>
>> Therefore, we don't need deferred initialization support for SEV INIT_EX
>> in case of KVM being loaded as a module.
>>
>> But if KVM module is built-in, then filesystem will not be mounted when 
>> SEV/SNP initialization is done during KVM initialization and in that case
>> SEV INIT_EX cannot be supported. 
>>
>> Therefore to support SEV INIT_EX when KVM module is built-in, the following
>> will need to be done:
>>
>> - Boot kernel with psp_init_on_probe=false command line.
>> - This ensures that during KVM initialization, only SNP INIT is done.
>> - Later at runtime, when filesystem has already been mounted, 
>> SEV VM launch will trigger deferred SEV (INIT_EX) initialization
>> (via the __sev_guest_init() -> sev_platform_init() code path).
>>
>> NOTE: psp_init_on_probe module parameter and deferred SEV initialization
>> during SEV VM launch (__sev_guest_init()->sev_platform_init()) was added
>> specifically to support SEV INIT_EX case.
> 
> Ugh.  That's quite the unworkable mess.  sev_hardware_setup() can't determine
> if SEV/SEV-ES is fully supported without initializing the platform, but userspace
> needs KVM to do initialization so that SEV platform status reads out correctly.
> 

Revisiting this one again and following up on it: 

Actually SEV platform status command does not need SEV INIT to have been
done, this command can be executed in SEV UNINIT state. 

Hence, qemu can issue SEV PLATFORM_STATUS command to determine if SEV-ES is
initialized (i.e. SEV INIT has been completed) before launching SEV-ES
VMs. 

The issue is this additional check in qemu to ensure SEV INIT 
has been done before launching SEV-ES VMs, as below: 

target/i386/sev.c:
..
static int sev_common_kvm_init(..)
{
..
	sev_platform_ioctl(sev_fd, SEV_PLATFORM_STATUS, &status, &fw_error);
..
	if (sev_es_enabled() && !sev_snp_enabled()) {
		if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
			error_setg(errp, "%s: guest policy requires SEV-ES, but "
					"host SEV-ES support unavailable", ..
		}
	}
..
	sev_ioctl(sev_fd, KVM_SEV_INIT2, &args, &fw_error);
..
}

So v6 of this patch-series always does both SEV and SNP INIT(_EX) at kvm-amd.ko
load. 

But also does keep the SEV deferred initialization support in __sev_guest_init()
to handle SEV INIT_EX, in case the file containing SEV persistent data is
available later after module load.

Let me know if you have any more questions on this.

Thanks,
Ashish

> Aha!
> 
> Isn't that a Google problem?  And one that resolves itself if initialization is
> done on kvm-amd.ko load?
> 
> A system/kernel _could_ be configured to use a path during initcalls, with the
> approproate initramfs magic.  So there's no hard requirement that makes init_ex_path
> incompatible with CRYPTO_DEV_CCP_DD=y or CONFIG_KVM_AMD=y.  Google's environment
> simply doesn't jump through those hoops.
> 
> But Google _does_ build kvm-amd.ko as a module.
> 
> So rather than carry a bunch of hard-to-follow code (and potentially impossible
> constraints), always do initialization at kvm-amd.ko load, and require the platform
> owner to ensure init_ex_path can be resolved when sev_hardware_setup() runs, i.e.
> when kvm-amd.ko is loaded or its initcall runs.


