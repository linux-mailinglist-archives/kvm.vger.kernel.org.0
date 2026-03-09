Return-Path: <kvm+bounces-73352-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uJ70MXkUr2nJNQIAu9opvQ
	(envelope-from <kvm+bounces-73352-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:42:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 616E923EBB3
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:42:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 677F73064F21
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 18:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE933CD8C9;
	Mon,  9 Mar 2026 18:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Fb0fFqfE"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010052.outbound.protection.outlook.com [52.101.85.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190173E0C5A;
	Mon,  9 Mar 2026 18:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773081628; cv=fail; b=NSVUM03jvTKxlAD/7n++823Nt/Z3BapZBmqQdLhWEqtWHwb/KYDk9+FuSGAT4kTnmnRT8Ta/p5jhv5lEV8ow0VJs04GX7drdZxNV+pAApBaMTcq17lW9V+F0O9q4VLyOTXXSfu3xcteBiYSKwCKPM8pQCCzpjr/8QjmIfhrfdWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773081628; c=relaxed/simple;
	bh=qKBT09xuCPZPse//o4XAtqViAPc6ZuJ3tc9ttqbEFKU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OVYjcY6B1Q45d1Sk9mrz7nclK0LwuAsjZVzZnBF3VxcxTmA3l/br+YoQ/3m0pymJ4ziXLlyoatorz8i7auCmuUar7r58n1Dr6Gf++MYU6LbThXSVNp6rXLWlDVw1ipitG2QxLNgxDPVHUDmoW0iBFxbBGxckRDow6iLGC4TVkr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Fb0fFqfE; arc=fail smtp.client-ip=52.101.85.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aRqwmCwsCo3NTx0JSnVIy65p2PabLiPkOC9QHJCNAj31JiUTPhegVl0sUR5fI16E1fnbL4AjxEM76OhhP14TIRi9hiVROyE4pT36R6+4t4Ot5VXusyWBWiPRDynfNdsV/Ou8NE+MyZC8vhxoW7ogfKU9TTdfJv4H+vi7dq3Fj0X4UwHtaiC0lGguD8k/TJ7DEj4afo+NOYGnAG8j3eXT9ddAgPVbVHs1j9gdgYf+KfeSNJ/WY2dvDIG6BbWISBIt+OGWA+mFBqqU8OnAFL2ObMIM0dozzBDAs2E3Y2iGbTL43qGg4CkHwumep+QF0mjAd226F5uCSYrnQ9DD26rJPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hcb71I+oN6Rs4CUQ5HCdBCEeLDtCUCoCNPwB5E4VJyo=;
 b=YlnKxjnxVlIYyYFzZ0oTxs5TRWMIDbsJRmhXOAks5HKIvfi63I86rCwOy63E4CtcARvO1aKSXoBrshpPMoJl8QpbfJn3IxCSPZ2eTu21Gl/IFlIGSdNChHheRP6oKKxJFSlTsYa+bb7s2jUrrpVgdfYdwjosVYyx5lLwUI2Y2BGuqel9ADr4jTz2AawafXBIMTZk0WpXrQPDuiIsO6+rjkpW4OeJy5DgU3Jk3RV+GDVQYg1Q+T8rYzn9mm0bND6rneOKw64tjHiYwNLnUyGoVYW8KK1Q3fM5e1ACpt62J2k9jDprYzhrRJjwrLTAIf2X1LQINIBqWkOOIhwXn7jKuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcb71I+oN6Rs4CUQ5HCdBCEeLDtCUCoCNPwB5E4VJyo=;
 b=Fb0fFqfEWxIhoCYgibZtjWCNPAdjzThZtABlSUiHMEikPkV7CVkYttXRCZY/ufpVjgscwS21WkplbUlAWDkwJcNxMpDGCSXarSjCpm95PK5th8onFDgb2TWYH0EIybfFt24saFrwRDYnyzq/4RcVInDoFjz3pqD7NN78K1SzVJk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SAWPR12MB999139.namprd12.prod.outlook.com (2603:10b6:806:4e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.10; Mon, 9 Mar
 2026 18:40:23 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9700.010; Mon, 9 Mar 2026
 18:40:23 +0000
Message-ID: <7ca205d6-b01b-4ed3-959d-db31a6496d79@amd.com>
Date: Mon, 9 Mar 2026 13:40:21 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/cpu: Disable CR pinning during CPU bringup
To: Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, tglx@kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, xin@zytor.com,
 seanjc@google.com, pbonzini@redhat.com, x86@kernel.org,
 sohil.mehta@intel.com, jon.grimm@amd.com
References: <20260226092349.803491-1-nikunj@amd.com>
 <20260226092349.803491-2-nikunj@amd.com>
 <20260309134640.GOaa7PQJli_C9QATGB@fat_crate.local>
 <cde957ba-3579-4063-9d17-3630e79ea388@intel.com>
 <20260309161516.GAaa7yFMulhdzNQ-pt@fat_crate.local>
 <70644e1d-dd0e-4f0f-81c0-fd095e46e50b@intel.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <70644e1d-dd0e-4f0f-81c0-fd095e46e50b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0060.namprd13.prod.outlook.com
 (2603:10b6:610:b2::35) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SAWPR12MB999139:EE_
X-MS-Office365-Filtering-Correlation-Id: e8b9466c-4bd5-4bb5-9355-08de7e0b52ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	1v6LvrVyZOxHUT2CW30TsD+Seq6io5N8L4qtpv59QGSnenGU3tDjlBX73C0j3fV2INxhcpZnOsrIPoNx7+PlGlh+zKAhFUUO+a8PGtoG2pqz/BtqVO2jxJyW6j1qHYFLxgjbDLTp+blMcaj8w2y4zut8jvwcclFXq8AmP7sxKN3oh6a4D0A3VPTkPeZ/efl3kfSuPhiTQVcsC1Js7XN5sTnH8eBoCGjKZUEv/3kIqiWFQ098QQOq6gSBqrurp5ssYqaKXbTvVnh1tIMa+fcNgriS3lyuAB4WW1kIQmT4sE/HjfLJsH6TxVG28/UsOXUp9iAZxuVAqMxMgbNz8pam93BkmTPTMhmp+wIxqyT/uNEkiX8X4ywC0pp3fUqw166cbb+AVFUeednYmXD/FfIDwB0Af25pWJGgdm04x+35xHtFoCh6Uqg4ldC4xgWtnNc4P2nuqLlOGY2aITKAN3Ar4oZS8CikTiJxzSUpn6SUDxlGL96BHa7DtPWsck8c5qsuJIKIY+4GBlOYsuRS8P7NwRYFUfaZ2I0GyVZnRUCDkr9QoBJnvzoUgY+YKJOZ8XF8a0gpiA2g7R9oLzDmK3SC8/nQ8xlzYni8XPqju3Oo9PYl7ofVV9FrYF9Ju2nDVrz48icbhIH8OAVJRgvqD/fBRiW6h/RReU9H1E6CIfzUUSmRGc28iM6md5Qy2mLlefoFqlmR5GkhU1tbJ/cVbaYxDi7spfKP0PEzFSv095xunHk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nld6T3hRWnNPTlR5RXBLeUI3UnVhZlRyaFJqU2ZCR3hCUWxoeHN4aGpuMjk5?=
 =?utf-8?B?YmZISWYzazM2ZTc0SVJhZmNXSmVONy9CSXo2WkFsaWFLMnJQbGw3OWRWeEhF?=
 =?utf-8?B?b0lTeDQ2VzdRbjRDUVNBTXJaY1lDbW9PMDZrL0ZqNWgrM2lRTWVXYldLVENv?=
 =?utf-8?B?Q283cktjbTlDcnV6dEtESXVURXF2MHNkWWp6b0paUFVkQ2ZrNzJSL3BoNFRT?=
 =?utf-8?B?dlpmUDNQVDY3ZmtmM1kxMHNRSUIwN0ZTbWo2dHR3ako2OW5jdnB5MEx3dGlD?=
 =?utf-8?B?SWswVnNpT2NYbjc1RGZ3TE1DWkpKajEzZVFIV1JLWWFwakRDL1lvS2FiYXpr?=
 =?utf-8?B?cjRReXpqWXlXd3M5VTE4ZWdGSXJtbTJkbUNSQjdWbktBVGdBNlJXTHVkQTBk?=
 =?utf-8?B?TnY1MEpjc0ZPaXlFL05oMkpVbDZBNSthcmRNVU01OUZvUnhBamJ6Q09uaXRa?=
 =?utf-8?B?elE5bFdueTI5b1lHY1FYOWE2b2paYmE1SkoxNVo1RzZqeEZrb1ZyNTNwVlk5?=
 =?utf-8?B?NXVxY3hyd0l4SEwwKzZ2OVUwZ2RoWWdUcTZhUWN0MlQxL3pwN09udG9pR2R1?=
 =?utf-8?B?eklIb0E3ajF4YnF1RTcyUFR3SWJSODRTd2E0TnNNK3RLeEhZOE8vODJreFNI?=
 =?utf-8?B?SmNXWTJpUlBWWXZkQWdRYXFPLy85eXUxcXJzeUNrQ2E5LzFPdmxFdmF4UFZT?=
 =?utf-8?B?NngxSFRnNUVTU1ZPeWNNNkNPbVBsZmRqSnV1VmordFBzREFtbUhKRnF6QWZK?=
 =?utf-8?B?WGZnRlQ0NEowS2RsTTlLa1NwbTdFdjg4U3A2MXE2SFdoTTdIM21PRk85aHBI?=
 =?utf-8?B?OHl0dmhyVC9TUFRLQVVBa2pBcThzb2o2bSt6QnBSNFpNQXovWmNpSE5iNWhF?=
 =?utf-8?B?L0NNZ1dHQTAyRkg4dDhzem5oa3VwMnFTa3ZzUXN1aEo0b2Q2ZHJxaHBsVEJq?=
 =?utf-8?B?RVJRejRvTHJndlhhQjk3ZlI1VnFJdGtNeDVYOENEc3Q1OS9jV0I5NXh6L2Fr?=
 =?utf-8?B?MzVacndlT0l1VEx6aDZuV0JoR3Rwckt3UEF1Ylg2dEUrYVdxTmFXSE5Da0t1?=
 =?utf-8?B?TjlxbDJmQ1RJOUhyM3hpNjNnaHp3VUdIejhOK3U4dDdpV1F2R2M5MnhSZGRQ?=
 =?utf-8?B?NXdoYXRQcG9lTjlHNUtGcWtya1ZnU2sxaE9hV0k1RWlZWUEvVHNqd3U5eC9v?=
 =?utf-8?B?aVBSQ1hvcytRQ2xGTkdjM3FqK0N5TmxSclV0RVFxS1hHRlpFUGdhTmMxUTBj?=
 =?utf-8?B?RnlWNW0rTjlYOC9Ub0xROVplQ1NKbUZXMHEyNkdYTGFwNVAvQ0g1ZmczVzNY?=
 =?utf-8?B?dzJYTUFoemtGbW8yZW1jdnQ5a1gxTkl6K3RleElQcUlCK2UyaWxyalhmeG5k?=
 =?utf-8?B?Q3Byby9YRXV2ODdzRFFrMTErdmZuN2sxc1NZWlQyUWcxMTc4aGtNaW96Z0RT?=
 =?utf-8?B?K3dHR2N1VmJwZkJZR0d1OEdTNnFGcDhXbVJZQ0tmVGNpeERNOVpFL0FDYjRQ?=
 =?utf-8?B?ZHlKUE96NThybEpMRG9WQ2t3OU1qRUtLcTJrbXM4WjFvS3NBMERsWk1IV2NV?=
 =?utf-8?B?MXBlKzlhdUkwdE9oays2bkoxNHJmZ2s0Rm5HeVdxTG9JZXlLWVI5dERDN3hy?=
 =?utf-8?B?WkpSNSt6ZEVFK2x0MWkrcElPb0tCaFhGL253K0hqQTg0cUljaXdjSExoK3ND?=
 =?utf-8?B?UmJGWWhsYWJCY0VsZjI5eTF4MXU5bmMzOTVicjVEdGg3aUF6UjZXL054V3JT?=
 =?utf-8?B?cFlXdmxtbzJhNHVROXhUQkdUWHRMaTRhejVhT2xLMGhSUXp0VVIwQW10MHpl?=
 =?utf-8?B?VGExZ21kZE04QUxES0swdEEvbkdxRDVSeDFjOGlub2JZOWpKNjFOVzFDbGhk?=
 =?utf-8?B?Q0d6ci9yNUxUT1BQWjVZdHYwSHEzMmkvbE45N1A2YUhtdjJmV2krSyttSDNx?=
 =?utf-8?B?TEpXczFOZUZIOTZMUE9LVllRNE9Ea05TT1ZOcnRVTXRUQTBvVlczMWZXU0JM?=
 =?utf-8?B?ZGViZnpsYVhMb0JIN0wxc2NNTHJhaG9NTmoxWUdmdlVCclh5eTJmR2prU1J0?=
 =?utf-8?B?YzczaHY3ellHSVpJaTlHbGpCOWpBNU5OU2NSSU1uQTdWOFkxZElacG5MWnVP?=
 =?utf-8?B?eDlHeWZBTWkzNURLdC92UEFVemlOdHM3SHVsZGVPWThvdU1Oa2VFY1ZyZnIv?=
 =?utf-8?B?STRrUUNnUHlIRlZOZDNsaUN0NEV0ZjNsWnB4WW94Vlh1aS9qNEQ5enBLY2Fr?=
 =?utf-8?B?ZGpYdmFCZWRsS1hIa05xRXRwSU1nUnNRU2JqT1NCTHp0THFUZUxHSmpVNUxC?=
 =?utf-8?Q?0QvbaHI+U7pkMo+wLI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b9466c-4bd5-4bb5-9355-08de7e0b52ef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 18:40:23.6358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p0U1E3R/eEWABQHd65qfNiNYRhmoAHV111YoW2FFa4iH8v3q7n/ntS9Ua+kotkGmCG1k3TI40t2vdoOKWarZ8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999139
X-Rspamd-Queue-Id: 616E923EBB3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73352-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:dkim,amd.com:mid]
X-Rspamd-Action: no action

On 3/9/26 13:03, Dave Hansen wrote:
> On 3/9/26 09:15, Borislav Petkov wrote:
>> On Mon, Mar 09, 2026 at 08:38:10AM -0700, Dave Hansen wrote:
>>> On 3/9/26 06:46, Borislav Petkov wrote:
>>>> My SNP guest stops booting with this right:
>>> Could you dump out CR4 at wakeup_cpu_via_vmgexit() before and after this
>>> patch? Right here:
>>>
>>>         /* CR4 should maintain the MCE value */
>>>         cr4 = native_read_cr4() & X86_CR4_MCE;
>>>
>>> It's got to be some delta there.
>> Looks the same to me:
>>
>> before:      31  SEV: wakeup_cpu_via_vmgexit: CR4: 0x3506f0
>>
>> That's 31 CPUs - no BSP with the CR4 value above.
>>
>> after: [    3.354326] SEV: wakeup_cpu_via_vmgexit: CR4: 0x3506f0
>>
>> That stops after CPU1, i.e., the first AP. But the CR4 value is the same.
> 
> The only pinned bits in there are: SMAP, SMEP and FSGSBASE.
> 
> SMAP and SMEP are unlikely to be biting us here.
> 
> FSGSBASE is _possible_ but I don't see any of the {RD,WR}{F,G}SBASE
> instructions in early boot where it would bite us.
> 
> Can you boot this thing without FSGSBASE support?
> 
> The other option would be to boot a working system, normally and see
> what is getting flipped by pinning at cr4_init(). The attached patch
> does that. It also uses trace_printk() so it hopefully won't trip over
> #VC's during early boot with the console.
> 
> For me, it's flipping on 0x310800, which is:
> 
> 	#define X86_CR4_OSXMMEXCPT      (1ul << 10)
> 	#define X86_CR4_FSGSBASE        (1ul << 16)
> 	#define X86_CR4_SMEP            (1ul << 20)
> 	#define X86_CR4_SMAP            (1ul << 21)
> 
> *Maybe* the paranoid entry code is getting called from the #VC handler
> in early boot? It has ALTERNATIVEs on X86_FEATURE_FSGSBASE and might be
> using the FSGSBASE instructions in there.

Could be... before the patch the AP CR4 value is:

[    0.020362] *** DEBUG: cr4_init - cr4=0x3100f0

after the patch it is:

[    0.020284] *** DEBUG: cr4_init - cr4=0xf0

The SNP guest is dying in __x2apic_enable() when trying to read
MSR_IA32_APICBASE, which will trigger a #VC.

If I set CR4[16] in cr4_init() then the SNP guest boots fine.

Thanks,
Tom



