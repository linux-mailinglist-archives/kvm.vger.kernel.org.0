Return-Path: <kvm+bounces-24705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB319599F8
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:31:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27D3E1F2242C
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 11:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E673199FCF;
	Wed, 21 Aug 2024 10:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KxLRMGJi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2063.outbound.protection.outlook.com [40.107.236.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DA6193436;
	Wed, 21 Aug 2024 10:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724236906; cv=fail; b=JIYhYuZRGPwXda6r9xhJz/55H/v2n8V29j4+E95y6qEhHh1U53yVpJdrhHR7SOsBdw8ZloNeLGATOkt4VXBs4SU1tlPzIkYSH4qt2kcHjq+y6bnsotJ83nOgIw+Ydh64fzrDIaZ0CNjIrXW7fAy4FX6EqVMPixxDsTTvw0+LVRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724236906; c=relaxed/simple;
	bh=jnEu/kSy5hu+mNm/z/PsAGtfSerjcQsD2KIjo2o+kRI=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oUb2V8kjPN7npZZufMlZgG95ywx/Qt4/sSabvFVjp1+9kmJQMjqyD0YdeWFnLEFnyNmGJwCScEKSp2pQ9zkFklEsKQD1uMVeQ+N4eR7NQ+wtEFi6lSClwWSmx6CHWi66CTggS5f0CPXYAN++l/Y3GWHzXDEdxSeLQj44fSRwEd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KxLRMGJi; arc=fail smtp.client-ip=40.107.236.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FCcEDLH5AcRHsDlJ4eK47MQHFoJSTSuIdddw2LDi+/7JyMAvqzrk+V6UBuY/BrABsmBUge/BQ5rVy4E/3zV9IJOXalZuTN5SJbeBfdOot0n6XjikC+0IiXrGZErtYUJkol7CynTC/PTNrtUPEpOiSAgvw1031sG8Czz9NyAPlM8z7zFJmLMzsV6q5n2VirejJ0ndF2cDCLRKUIlDLSHzQ1OrWCityw/G/DHhR+5UxXA+caWtXcEiny8VvZmGfi1m4MVDA2FSZWMvLj57DGBKuFL8w1pEdzuRVg3/LPTXmJpzZKB7U6x3ZL6VSvE8R8uqetFLk0I6Bamogcm5ChGDiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVHrnQuOfxdwW2CuJTfff/aUdrqxOMt1lKXwzYMVmrg=;
 b=BaCCeCbCxoG9edU8TceVI5fIfj8TdUXhJXjU0v4R2DwiHlBWEv4InSk4qhQWQR8Ie7ZbBOiGjQnTFZFCmlk+OVuKXRHK7dLJHlmrXR/IGUD0GEW0Udki28uScjKC2vFONdlpdfwtrW5ETbeoAKNsfoY6Vfh2ChMu+O2iC3jGKcki0m7zkyEeOmeN05YYXHD6gGBjzC78UwK0PUYhTvEEUKPJs2J7qlSdMneZgviHuE00kH6DEylJZw5M+nWV1z5Op5VEBRQWzGo1sywfAz7gC9hdEgckwW/qvN2DvYkza9PFqRFab7kYTbmLGEdYcsp9dXDlH1gR9ix0XAk6fCpHqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVHrnQuOfxdwW2CuJTfff/aUdrqxOMt1lKXwzYMVmrg=;
 b=KxLRMGJiE+la8dqyBA011SfqrKan6yFGUVeqDvgkPCGRXYAiMsFk6r6iAo8/CfSh6bffZmtjP60zpyvy82sUOGAgFIKNcyDj/Q3ctoKUr4orG2ulqsFim7Gk0hoZGHk8R8y2Q5WROLTAExVbM+vMmdnkFoLN8G9cui54r6dKZ1w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by CY8PR12MB7099.namprd12.prod.outlook.com (2603:10b6:930:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Wed, 21 Aug
 2024 10:41:01 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%4]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 10:41:01 +0000
Message-ID: <5fe11dfb-2a33-4b52-8181-c82bc326b968@amd.com>
Date: Wed, 21 Aug 2024 16:10:47 +0530
User-Agent: Mozilla Thunderbird
From: Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH v4 4/4] KVM: SVM: Add Bus Lock Detect support
To: Sean Christopherson <seanjc@google.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 jmattson@google.com, hpa@zytor.com, rmk+kernel@armlinux.org.uk,
 peterz@infradead.org, james.morse@arm.com, lukas.bulwahn@gmail.com,
 arjan@linux.intel.com, j.granados@samsung.com, sibs@chinatelecom.cn,
 nik.borisov@suse.com, michael.roth@amd.com, nikunj.dadhania@amd.com,
 babu.moger@amd.com, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com,
 ananth.narayan@amd.com, sandipan.das@amd.com, manali.shukla@amd.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240808062937.1149-1-ravi.bangoria@amd.com>
 <20240808062937.1149-5-ravi.bangoria@amd.com> <Zr_rIrJpWmuipInQ@google.com>
 <372d5a95-bce5-4c5c-8c74-6b4cc5ab6943@amd.com>
Content-Language: en-US
In-Reply-To: <372d5a95-bce5-4c5c-8c74-6b4cc5ab6943@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0081.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::21) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|CY8PR12MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: 28465da2-a8e7-49ab-0b8c-08dcc1cdbfeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGtLMkF4WHkvMitRQU1pRllBRkFIaUVrREVyRitrTzJJblVMdFdZMWNWcU4r?=
 =?utf-8?B?MFcrWURUL0VBT0N2eHprM2RPaXZKOWwvOVpZK2JRK21NZkN0cmMyK2o2dVJE?=
 =?utf-8?B?U1hNYjBITktWRlpuSk10UFhoRzZ5T1NWeDl6Mmk3TVRkc09yOGRPbERvd3R4?=
 =?utf-8?B?Yk1QdFQybHlIQnRISCtTRmJLSE5rMmQ4TTRQNkk5b05uL2NrVWRNTFFaTEtv?=
 =?utf-8?B?S0dpV28wYVJqZU5aVjlmbEJRanEyalVDRm9KVm5HWkRSVGZMME5ZUVRyVkZ3?=
 =?utf-8?B?N3p0VHptZDFheDhXWWpMQmRzKzRxaktNWUxucHI3ZnVUZGhMWmhsR2w2SStv?=
 =?utf-8?B?anpEd0pnTm1jVENkbEV5VzNTSnBUdmlhbUYvTlBScytPdWc3V1YxSEdrRXp2?=
 =?utf-8?B?VVFnL3E4VjUvaGQ4NDdqN053dDkwNHVFQkFmclN6eUt4ZlJxTExmVnJTYWhR?=
 =?utf-8?B?SnVacWt5TlBtUXdXUFMvc3Q2Sk1CSXppYUdYdzFkMVhZeTc4R0hEZUNKTVpD?=
 =?utf-8?B?Q0xGZ2xCZERzemZTN3Y4c2ErRW1jcWpydnUwek1IZWRUVzBNQmdNRzNCdkJN?=
 =?utf-8?B?ckRnVmk1NjJ0WXU1aDYyczc5VFNKSWhHN3FISTY1L3U5NFBVNlZhNVRLdkVQ?=
 =?utf-8?B?dUE0VkVLc1RZTjFBNnZxb2xBOTRyOWlGTjBlci9WVHZnSStRMnZyZ1BsWm1U?=
 =?utf-8?B?b1F3eVIrTXlxUDdjVEVFK0dtN1ROZ1N5MngwV2NkRWczNVZQS2NMV0R5ODNy?=
 =?utf-8?B?QU1qeFI2WkVYNGk1RXc5QmJMYWQ5M3JGYm9hZXZwM3VGZlVpRk03MWpRd0J6?=
 =?utf-8?B?aVZVYTA0N21qWWRKSitKc25BVWJ5SEtMT0Era2pHOG1YaGlFcTNYOG9jR1Jh?=
 =?utf-8?B?bWY5NXplMHdwbndwWDZYRm5Dd2owZlZQMnUzUHNxMTdCbXJ1eWxQV2RnL0hY?=
 =?utf-8?B?WEdXVEFLeGFReXRjR0l1aHZ4TDUxTTJnam1HbzNNYlZ1ajFCRXJLVDFFdG1o?=
 =?utf-8?B?M2NxNXBVTVNGMUltbktrWnErc0ZDc2hHNGlSaUUzbzJNdk1Oa0dUWU5FcTNY?=
 =?utf-8?B?OUdsOXQrcDdJbEFrUU5CaUhNQzhaNGxQeWdVTFFsWnJNYlk3Y1R4SUt5VTJW?=
 =?utf-8?B?dHBkYyszNHJIbHVmVWtPZnNyUVZ0eXJQSk9TclZWb0FJZk1TSVQ2N2dhQlVm?=
 =?utf-8?B?STlQSUNKYmNKbnFicHp3N1p3d1VHQ05IbEs4SjA3aVRPRTVhRGxEUmxXOEZ1?=
 =?utf-8?B?QUtDeUxTQkl4SG9rS2hmN083RnI4RFJoMFNuRHpKSWg1MHFObFAvMHJXL3RG?=
 =?utf-8?B?NHVkMVdySkJTdGo3V2pTdmlyZ1ZibkxuN2cybEE2NHh0QzdKVWJ2enU1S0h1?=
 =?utf-8?B?QUlTOWdDRllUVWw1Mmo2WndSc1kxWVU5UGFXTTFoU1h0NDJXUjViUksyS0VO?=
 =?utf-8?B?Z3RGSXVScFFhamp6UndiVVhZMXdVMEwzTkxSZ3ByU2Q1ak5heURpOHNaMG56?=
 =?utf-8?B?OHJTVWVXTnBEazQwcDBwWDhPcjlvR20xbHcraWtZNW4rK25Ib1ZlN2QvT2xX?=
 =?utf-8?B?NEpMRmxqaStpOXRDbWljV214ODc2NEdNek5SeGZxL2pabzRTMENPOEprVGhU?=
 =?utf-8?B?WmtVeWt3TTZEVHlnWEkvRFpFUWd1Qk03L0UwNSt1Rk1BSUN4T3RCR2VpY0V5?=
 =?utf-8?B?NUxQVFhxc3dabUxTZHRiNjRqVE52Q3VhWS9ldXc0cjZDR2tMOVcwNHRmZktZ?=
 =?utf-8?Q?AQSCttJFSIg8288buAWj5LDHYnEGeA9A5VQUnf3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWFnazk4R0xNZk1EU0YxWnF6NitqaTJiMXZVdUZhbWpsNlp6UmFJTlQ4QUlP?=
 =?utf-8?B?bXNXbklQSmFpVlpNVGpRbi92WDlpVzBqaHo1aG1ndnh4d3M2YnZnQ2h5ei9y?=
 =?utf-8?B?eFpyRVdrZlBDQ0ZhKzNmamdnY1pLeU5DQVJ1dDVyT21GSmZ6YmNISW9LK1Bp?=
 =?utf-8?B?MW45YVYvMDZnMllHN1R1NTJYMFlONTdDUXROYkIxczVyNjM5eEp4WFUxaXhl?=
 =?utf-8?B?dk8zTDUzOFJFeHEzdXh2VkdTN2liaHZpSm1sYU96d1I5ZzY3NVljK2hCZnQ5?=
 =?utf-8?B?ZGlQV2Z3ZHI1Z0l5bWROcElzcWo2aEh0Z0xPMVFabm5QYVg4b25aNVJlbnJ1?=
 =?utf-8?B?Y0JwYW80Q1BwT003d2hEWW96bldFQlFVK1pSbHJMbzVoR0h3ZWRoVkVUbTRm?=
 =?utf-8?B?UEFVODQxZEczNFRod0NVK1pqdDBCWmZoNGppdHZQdC8vbGtjcTFsaU50RVBz?=
 =?utf-8?B?U3VzbGxxdUZ3bmZSa0Z2Vm1hNjBlc0huT2xNLzU4N2kvOHBlcWtSaDVOVTZ2?=
 =?utf-8?B?Y2c1eFFsWmF2N1FzcTJ2a2dpWjhINlVzNzM3K1QzcFh1bk42TUpnNGtTak9J?=
 =?utf-8?B?TVlWUURRcVNPUWoySTJIb3F1cURMd3h5Y29vU2JYNGNrbUdEU3EySVA3a0U4?=
 =?utf-8?B?c3ZRODNIVTVubWxLVkVESkRoSFBucHRnY3dDdWZPaHZRRnl3Y2tXbWZQWFhM?=
 =?utf-8?B?dTJsM3NlTnUvSzBibGRWbE9CVHZpMDJhdUtXOWFJTHpjQ0lUQVV6akgvQ0s4?=
 =?utf-8?B?elVTTGd2T2h4QjBIaUhhZ1RjUHZvUXlNWjBFVVBFWlZMK0J0cTRWd0xxYnNz?=
 =?utf-8?B?VHlybGV0YWh3Mzc3SDloY2pjZlp4a1I2dmx2S0hUSnNVMVhOaEJ1ejNERGto?=
 =?utf-8?B?bTRTcFlwUUlTc21xRjBVUlFJL3dMVlpzSmFaQ2REei9UWEUrUmd3eEx5UERO?=
 =?utf-8?B?TzA3MGhTVnU2KzZIY0UxdHBxNTZ3WWxQbnR1UEZBOWlkREE5Q0Z6YmF0VEpn?=
 =?utf-8?B?ZmJ1Q3hvbWIybEQ0MUt4RVllYlluMEl4RlhPdC82SEdIQUJscHlYbERNMit3?=
 =?utf-8?B?cnlYTzFET1JRckVyQURlV3VGRGR2dEFmYUdJdjdUS295a0RSanBNSzlLTUVG?=
 =?utf-8?B?WEp5cDJwRXh1bTJibDU3ZVJhY0ZzZUY0UHdlMm1RaHIrbU9BWDNGcmhqK1U3?=
 =?utf-8?B?elRjNXdUd004S3lCSG03b1NYMVVicy9VYjAxbjVhcVdncnBkVjFBWGd0QWh4?=
 =?utf-8?B?blh3TkZMUXlrZTVkZ21sbC9KZjhWamswTDR3OTVxWjFYVS8vZktCUnd6QVov?=
 =?utf-8?B?UVdEaUMvYzFUZ1JidTFWYlRjZVF3MjJ2aHNBUU12QzlLMXRIdWZBc284dGdy?=
 =?utf-8?B?K3Q4OTg3c0FtVGE3SkFsTFNpRkRtYTNhY2hBYmhsL2pZdis2Z1gxNEtybWdl?=
 =?utf-8?B?OW1qYmRveENydzZHV2tmdHZsWHI3TUt4RjA2d2gxZmRzaldsWC85VFhWLzI0?=
 =?utf-8?B?SFNSekpNVnp1a2trTzY3cStSOCtnNUdGWXRUaHhMaHY3Y3FjZEhCM0N0NE45?=
 =?utf-8?B?em1iaVI3WWNkWW4zQVNLZmhGbkhHeTdQYzJyVkgzMkVwQ0tOL25IVmxMYUcr?=
 =?utf-8?B?T1kvY3VxVU1TWXdhMGIyK0Y1WSt5ZHFFQXB1S016UHZxZHRHYm5vWDlQMnMr?=
 =?utf-8?B?Si9MdnR6TGZtbnVrVWEvSTZyeE16YllqbENFTDZBTzRELzhsWWdIL3d2TFVP?=
 =?utf-8?B?aCtIYVJlUEp5YW4vV0J6YnJ5Y0pmcHRuMm1qNm1SZWJwT2xQNlhqNzRMby9C?=
 =?utf-8?B?dCthaFhNV0ZCUmlnemQwLzFYVTROMGpCVzR6R2czODJKbnorOU1BaDB3cnEy?=
 =?utf-8?B?K2pTN0tHUGJ5SGEwU0dsaGcwdGU2d2dSQXlzUTNRMnVnSTU1MUhYdWp6VHMw?=
 =?utf-8?B?Y3pzdFIxc1ZxZ3BrSUFoMzVmV1Q2Q0ltMmtNOFZGV2RwR0MyZjlVVzlvVEU3?=
 =?utf-8?B?R20ycUY4ejZPdnRoeEh3N2xHVFVKQzk5M3FyUkdERjRYM1BnNDA0NGVZdE14?=
 =?utf-8?B?ODBXVEh1Y2psa3p2U2JLTVVRYmtoekc0ZnF5NGFTWWxld0ZwZEt3Q1JKbEpu?=
 =?utf-8?Q?E3wgCy7dc8ZjQV/HufSSGGrfR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28465da2-a8e7-49ab-0b8c-08dcc1cdbfeb
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 10:41:01.5721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JbPTIs7PPMVXe/9tYku7HO4HNeUqqR9y7ZdOF/S/Q7IZT3q7xyaZqw59oPieA027uIDI6GLCpvjQUj+hFYDKCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7099

On 21-Aug-24 11:06 AM, Ravi Bangoria wrote:
>>> @@ -3158,6 +3159,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>>  		if (data & DEBUGCTL_RESERVED_BITS)
>>
>> Not your code, but why does DEBUGCTL_RESERVED_BITS = ~0x3f!?!?  That means the
>> introduction of the below check, which is architecturally correct, has the
>> potential to break guests.  *sigh*
>>
>> I doubt it will cause a problem, but it's something to look out for.
> This dates back to 2008: https://git.kernel.org/torvalds/c/24e09cbf480a7
> 
> The legacy definition[1] of DEBUGCTL MSR is:
> 
>   5:2   PB: performance monitor pin control. Read-write. Reset: 0h.
>         This field does not control any hardware.
>   1     BTF. Read-write. Reset: 0. 1=Enable branch single step.
>   0     LBR. Read-write. Reset: 0. 1=Enable last branch record.
> 
> [1]: https://bugzilla.kernel.org/attachment.cgi?id=287389

How about adding cpu_feature_enabled() check:

	if (data & DEBUGCTL_RESERVED_BITS)
		return 1;

	if (cpu_feature_enabled(X86_FEATURE_BUS_LOCK_DETECT) &&
	    (data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
	    !guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
		return 1;

Thanks,
Ravi

