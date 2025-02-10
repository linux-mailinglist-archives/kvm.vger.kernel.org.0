Return-Path: <kvm+bounces-37730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F08A2F9D8
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:21:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02E66168407
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 20:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB1824E4B0;
	Mon, 10 Feb 2025 20:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pj4EvxfX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F083225C71C
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 20:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739218886; cv=fail; b=uus7IWq6neXg9KWloYPndPEGaSffszb0Dy0+d9xEGIsFtX6XVBSE91oZNX4QZwicuD/K6zNQ6df3Gcoc8e4ZLr/5EFfERqeRCUTIWbrnPwm0/6uNfhj++fij7l5Q8Pre8hs+9XErZO1yat1LtxjPzS5yd21MnCMENNUBJiCl1bQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739218886; c=relaxed/simple;
	bh=lSqCiFmhY+ufWZ5r2Ye3sx60nxhHuhwY0parIvSsRYA=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=YdCoKOnrjjFO8UyaNYLuUwYl6TgJlLJqU1vG7+ecA+/0TEzBO00j/78gG9GH4LpdcYfPcXbTJpgBqz8UOmbejkkTcqsZAKf/BDHT7qtTtmIC5Yg4gTgHsv5i1FDy6CrHA9NwT5Q+oA4utm/ouw9Nyl5gPIH7UrHq/KWtdO7QEbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pj4EvxfX; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tLTiszBFkJUvcG+ES6tFKGIGcECVbyL1QOCDlnQSnt9r9UMXqhbHdpMuKtESgD5PaHuPMM8l4cyj88goNo691eNP7vmEYp7YwILwrgCV8/hw27uaWyIjU9g0u+f1ybvRADFiqNov+Dn2MvTxhPEsPftI+OQJLrVWockRnrgPDju6GIfKruSTnJwZtJ3MTcYMn0tm3Z2hgdKRRYkMnuHZZCTlU2d/dcTIXIdT+UJ8Gradljr6t7fK9h8gI2zkG4DEb7LlbGIggw4yhXLi8fVLU80R0a05cDmaRkmaKi2MbEQvqliBVeGQ3yld9H3XQKyCEGUW7sPvl0GEyFeBbQDvJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nqv/tBKVhmKpuAQK/IY/K7cFunO7tXJ247Kv9cb3MIM=;
 b=oXsMj5QQyw+PrOu5bNTlrrgfpR2XKOjggswXLU6QPF7d/CQr7Ztvu9NTy1IisgDGQq4DM5tY1ue5rlL3RDZsTfT/8h0MTCWjVN6XE4qXxPwLxNQdekj27wtxVEYPnLshL0zW0KG8m7jR5d2BQXyJ8wih3Q2wkvt6/wpyGdOdlYvbMuCJxYAjqUkueJVgBCYttLvjQ3mnlug3scFmnwB+IdaOadgbVKDaeeRghKBzwbwdbmquRMcVuUvI3+BqceoIhaQisiuk+zX0FyphDhiwCjzCRfldWi1MNHfOHCBWIyrPB9dFJeM5g7ZKVfnQOqQ5BPXiKRwzznXbumi4WaQFew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nqv/tBKVhmKpuAQK/IY/K7cFunO7tXJ247Kv9cb3MIM=;
 b=Pj4EvxfXngdFVcJoZj2TyBGSc+MitPtzMyLrZsroGxz/x7HatCVfTDTU3X+pWPKGTAXMyY2Z/AbQ75qk/lMB0UjAQqOIlX8chRdwerxaooIjIIcF2S2z7CjLuNuy6rX5h5s1CvyL2swqjuvue4UULzb1s69dCCJBbUv7f4H0Jg4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB7541.namprd12.prod.outlook.com (2603:10b6:208:42f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.16; Mon, 10 Feb
 2025 20:21:22 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8422.015; Mon, 10 Feb 2025
 20:21:22 +0000
Message-ID: <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com>
Date: Mon, 10 Feb 2025 14:21:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, ketanch@iitk.ac.in,
 isaku.yamahata@intel.com
References: <20250210092230.151034-1-nikunj@amd.com>
 <20250210092230.151034-4-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
In-Reply-To: <20250210092230.151034-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0160.namprd13.prod.outlook.com
 (2603:10b6:806:28::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB7541:EE_
X-MS-Office365-Filtering-Correlation-Id: 0da1f33c-6612-48f0-142d-08dd4a107c22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VXlwOU9IK1R5RHRYQlo3a1NtN1lGdWtmTXY0elFZK0VlZlE4b3c2cFFYczZV?=
 =?utf-8?B?S1NxbFpXeFBXUFpIZGc3WnFVeVVodnJoNkxGb2s2dE5SR1dyaEJGajNnOU5O?=
 =?utf-8?B?Q0pRT1YwVkpTZEpBbHNXd3JxRi8wOURPTUdsMWtudUM4TXROUmY3Qm5wem5q?=
 =?utf-8?B?V2JobTRodUo2Vm5xUWlKUTBHbXA4cm1XQWpBeHRyUEJWSW4zc3NTWjBvRDNx?=
 =?utf-8?B?MVQvcGdSY0wwNUJnb0JMcUFwZUI3alE4WFJFYVVsRG1Ia2RaMnViUlo0WmxE?=
 =?utf-8?B?NEhNQ2ZVK3IrdTltRWR5MEVsb2NFN0t0TCt1Vm5MQWJzeW01bGhQdjZSSTFI?=
 =?utf-8?B?cDFxUmorOVJranhrL0pSM0orZ2hjTjR4ajBqUEtKMnZSenZ1cjhhajduQ241?=
 =?utf-8?B?eVZuK1VkYVRnL0ZveUtlS2x3L0ZFa1JZcXNmQ3dXVzlxUXpabys1TzQzMEpu?=
 =?utf-8?B?bW5Ud1pOaVo3aXdaRjZLaHNmY29TTWxNa3ZPbUNJZ3J0a2syNEt0amVsRXZY?=
 =?utf-8?B?cUFidUtwWVB0RzhPZjN2OS80R1lBYkdsTitMWVByQzExaEtNR0g4Ty9kY1pS?=
 =?utf-8?B?dlZINXpGdHdlQW54QzZpRVRZczBVbW0zajJHOTA0VnBSWUJGVlVhN1h2Z0ll?=
 =?utf-8?B?Y05nV2F6TUlwWVhJbmFKak5NdW1TTE41dzRVbkNUR3F5SkdEWmc5aERQUCtx?=
 =?utf-8?B?ZTY3cElvWkgvUXlLckIwejR1S2p3NlJiZmZBZ2JVK0JSSEJwRjZOYitJRERK?=
 =?utf-8?B?UW9KK0dpMVlqUzlRZnB6bXpFT0RhSXMyWEVsY3p6bEdENFh5OFV3RmJvWVJ2?=
 =?utf-8?B?Sm93U3VpeFozeUQrcG92anA0ZE1Oc1VqSTE3NUZIakFaWityUU1uWTNEeE5I?=
 =?utf-8?B?VU9MbFJJUUM0Ly9aellHMHNkcHBkbDRFbnMyOWJpRzhyWGJvZDI3djZuTVZD?=
 =?utf-8?B?KzVvaWVwQzE0aEs3ZjNlTkpQYkxyZDN3eDZuVW4zZEJHbXFOWUJHeDBUamZ2?=
 =?utf-8?B?MDhjeEY1R1NRMyt5aGQ0UXk5K1AyUTdGcm5XbmcxZk42WDdWVUZ6dEJzOEF1?=
 =?utf-8?B?MDJycElLbDZwRDd1N3RtekxnYmIyelI3dDVSQUY3eE5WQ3c3VlBTcU53eE9Y?=
 =?utf-8?B?a01aLzVWamJPbVBjRHF1Z0poelBwaWFqODl0azB5Z1dLYWcweWZTTCt1Q1lI?=
 =?utf-8?B?VHZEUmJubnRhSTR2djRsaEFUZVg2YVc3YzV1VWdtVDRBSGJBcjRpaUhPMmx0?=
 =?utf-8?B?TzRDcmZNWGV4N1k0bXl1TjFrZnMzVllqYXFyVS8vbmVqZUd6cWpmSFUvWUtw?=
 =?utf-8?B?SE10UjJnMkVCNXJwdHAzU05WcFV0cVp4MyszcmJBL1dkSCtOWFRWQ1M4RFZi?=
 =?utf-8?B?YVNLQ2k1eU9JckwxYVV1Y2xTbzd3SyszQUY3RmFCVGFlTjdNeG13THhEVDZS?=
 =?utf-8?B?aUVDVFIxdHRGaXBVemcyd2MveG4rN3ZNYkRPSGRkOUJVaWJYckprWU1zQ0NY?=
 =?utf-8?B?TDA5YmhoN2RWNjNPMDN2WENOellKb3VxckhMY0tuQjVSZERlNEJMdVp2K0k4?=
 =?utf-8?B?TnpxZ092TUMyL1FENGZtbUV1dlFoNG1VQyt6MzIvWWFmdzViWlNUTnpIRXZZ?=
 =?utf-8?B?dGxmOEhYaTVsWXNnOGEzUExaT2dlNGk1bzdud3cyZld6VXNGM29xRjVOYTlS?=
 =?utf-8?B?aStwK3JUTXVmL2R1NlQwcS9vakF5NExXL0NyeUNka1piVG42UU5SZUJ6aHV1?=
 =?utf-8?B?dEF4eG9QYmpEUUIwcHcwdDF2Zk14bktCVmhSM2ZwZjBFZ2hvSjRVb2dkbWpu?=
 =?utf-8?B?OFVnVVFkV285OUc3SHcraXpZYUdpOGt3MzFNMWRXUVNkTWRGOU9GZnFRNzVI?=
 =?utf-8?Q?1CuoZ/fFTlLin?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elk2TnpIZnFTaE1vcGwydmpVWDdubUVtM21zalFxblFvNzBlUEFZbk1IQTV6?=
 =?utf-8?B?c2VUaWdia01XWWRvZUxzMStRNGFnMWdoOXcrY3hQNTNWN1lxLzlOSG9WS0RS?=
 =?utf-8?B?M3NtVlR3ZWVyVnQ0bWozUXdHWXR1T3U3bGZ4aXJGTjNFYk5GdnVKMmFqZDBX?=
 =?utf-8?B?ZndWcGhTVm9lSzBkRUxvNkM1a1RPWTBZaS8yR0p6QXN6dlVtTDdSK0lRN2U4?=
 =?utf-8?B?TUpsR0pOWXlhS3FpVGhOTFJPNFBVSFVraUlBckZ0L0sycGJQdTgrYUxzN3hS?=
 =?utf-8?B?bVd3bWdTdm1ZTkY4YndVSVlvZitVc2NNek1aR0ZjQmpkUU1WajgvVHlVOTNG?=
 =?utf-8?B?Rnk2dkV2elZlVWpSR081NEcxbFJjdFJRSjVTZ3lHSUNqTGpiREt3WjI2ZnJQ?=
 =?utf-8?B?UVVwLzZGYUNRTE9TU3dLT0h5ZE9jR09pSlE2SWphWEJSZXFvRW04RzVvaTNr?=
 =?utf-8?B?Zk12TElsMzVDN0c3Vi83RldFa1dadW1zZlBHL1JOZVE5VDFCWURaNXdIQWdK?=
 =?utf-8?B?MERBc2J4a3A5VDhDaFZPbThyRnhwcFl2RDJQRlJ5TFd4N2xibk5lL0VVMGV4?=
 =?utf-8?B?TUtqNmFmZUxaUVBnRUJJaFJvQktjS1FKeVhVa0ZUZmE0SXJFN29ET1BtVEkr?=
 =?utf-8?B?QUFaL2gwRnRENDhxY0xMcTEyelRua3NIYzMzSmdPMU1sYk14WGFmWWd5UnVC?=
 =?utf-8?B?ekFzTWxPaGZEcWtKMmxlbUZvc1NYVVdNa3lGWkR0Ynd5UGRsbHBuWDJjeFZo?=
 =?utf-8?B?TnJIOStGSGh1cnZxRm9JSjd4dHhPVm9MYzdLWkdwUmR3alFBcmRMUVd4aERK?=
 =?utf-8?B?VlZxbXE2OGY1M1lmdXhCZEwrY3YwLzB0L2kzNUtsVnk1cTdCNmRFT25NS21N?=
 =?utf-8?B?UUdOMlNnN2hKN1lBb2FPZTB0SFgxWlRYNWhUTjRNdk1ya3BUaThxMTBZdmVs?=
 =?utf-8?B?a2craUp1WWxkRmZaVnh3eWJOdGhIT25DSmdaL1hVQ1VnS0YzN3hCZXQreDA4?=
 =?utf-8?B?bFhKMWN4UXlKdEF3QUxpV3NLRlNLTEdqeUNnUmlZL28yVmRVUzlWTGNuUXRP?=
 =?utf-8?B?K1lrNFN0THNoTStmTHcveU0rTlJGOG1BL1VnazJpZ3FJemcvMEZDeVFaQmJS?=
 =?utf-8?B?QTFPQUJSN1dmNzFVSkh2S1hXMWluR1VjaG9iQzB2VmF4b0xRdmxqcjBPNFNz?=
 =?utf-8?B?bTVYNlA1NUNYNXBETlNrYWk1TzdDZnE0WEpRM0VyY2FVR1JWU1owQXU5RDZR?=
 =?utf-8?B?dGF0WVFzWlZLSEpPNEtSV0lZcmllcWVKRjl1ajBDanhZR1BwVWdhZ05pcGh0?=
 =?utf-8?B?eHg4K2N2THd3QUtqV1k5bGUweVlIdjVscVBiZ211OXE0cklGaHdidUVtVFBy?=
 =?utf-8?B?ZUs2K1p5ODNWbTZoTmQydUZsa2dFQkUrSGhkNng0VzFUcjVWb0xXc3dJVnZ2?=
 =?utf-8?B?NnRvVlJ2aGRKUWx0cjl5QTU3NFU0bnFXTERkV0N5K1BpRFZaMldLWHhIZ0w2?=
 =?utf-8?B?Q3V6bTVRNkRZNFBCb2dyL1pFMEwwODlUeDNuNFBvZlJhVWE5Vk5wYXhRVFB4?=
 =?utf-8?B?bk9vektKeHZvK1FqY0V4Y1FHTGlNU25xakljc1p0MmF0MS9QM3lDVEIyVldy?=
 =?utf-8?B?T3JvOXc1VWJIeXdlRjRpRThFUktaQUN6aE1KT2d2c0d5eTJuYUtLYlZIZGkv?=
 =?utf-8?B?bVE3YWd6cCtTNHoyS09OTWxueC9kN0xnOGFDVHRNdlRQb2ZTQVRYSWo2YmYz?=
 =?utf-8?B?SloySEFBaEFYaTNKSHlhN1N6bGNtenZTZUxRdDhwL3N3WUQzZjI2dDUyeExx?=
 =?utf-8?B?MitVR0N2UzBtZ2l6cjRtN1UxV2plTzVqR01ad0I2SUFHSENzYldXcGdNWmU2?=
 =?utf-8?B?T2x2dXhvZ1BKT0ErWWxXcTVqZUUrU09QWmwyNi8zU0JjYm9JNmRGRlpRZVVM?=
 =?utf-8?B?M2NoYkpMaHhHdE1HVFdWVVpGNmNwU2Vrd3ZyaXdVMjBscmRlc2g2TSsrOGFw?=
 =?utf-8?B?MGtiWHg3WHhoeW1rSWRmeXZ3QU10ZGJhM2JGOUF2eWhJSUV2ZWJIbjNkeHZL?=
 =?utf-8?B?UUc0R0lnZkF3WWtpd1JiaXIvbFBNWXZLc2hUTWQwLzl3eHZ6bmJMNllEMHlq?=
 =?utf-8?Q?QXwq93G/YMkw0rgQiVfLW6FAQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da1f33c-6612-48f0-142d-08dd4a107c22
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 20:21:22.0572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMCmatWPQjE+zWGWX0TnRRd8v2xDduH7AY+9ng1r/ntGV6O8ksD5+W04oN2NeVvxmjZvCt6z4UaNYtWEDh6oKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7541

On 2/10/25 03:22, Nikunj A Dadhania wrote:
> Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests, as such
> writes are not expected. Log the error and return #GP to the guest.

Re-word this to make it a bit clearer about why this is needed. It is
expected that the guest won't write to MSR_IA32_TSC or, if it does, it
will ignore any writes to it and not exit to the HV. So this is catching
the case where that behavior is not occurring.

> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d7a0428aa2ae..929f35a2f542 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3161,6 +3161,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  
>  		svm->tsc_aux = data;
>  		break;
> +	case MSR_IA32_TSC:
> +		/*
> +		 * If Secure TSC is enabled, KVM doesn't expect to receive
> +		 * a VMEXIT for a TSC write, record the error and return a
> +		 * #GP
> +		 */
> +		if (vcpu->arch.guest_state_protected && snp_secure_tsc_enabled(vcpu->kvm)) {

Does it matter if the VMSA has already been encrypted? Can this just be

  if (sev_snp_guest() && snp_secure_tsc_enabled(vcpu->kvm)) {

?

> +			vcpu_unimpl(vcpu, "unimplemented IA32_TSC for secure tsc\n");
> +			return 1;
> +		}
> +		break;
>  	case MSR_IA32_DEBUGCTLMSR:
>  		if (!lbrv) {
>  			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);

