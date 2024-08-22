Return-Path: <kvm+bounces-24848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D9395BEB7
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 21:16:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 658BF1F2642D
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 19:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732031D0DC3;
	Thu, 22 Aug 2024 19:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="acVW82QK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF99E101C8;
	Thu, 22 Aug 2024 19:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724354173; cv=fail; b=ZeKot1jv/H+2lAF5dcX8cyvpPfh9WYW3LYes/EeR2vmfvluo2M84PBzPtFrcMGRs64I2R9dGE/9cn4PHABvLwmRe470jj+9QlZEcpZG8/eYQZEp9bqHWGGxxX2VmAoBcW4zZqf5Ob4hPBVABbQFvNQKlLOa09+mqA8o/fPS79z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724354173; c=relaxed/simple;
	bh=O/9oFCFiNQfNjoSLjqQvkTmj16DsqWwz+tCAANkd5oQ=;
	h=Message-ID:Date:To:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=fcS2MBCdgc+8P+3ZmFCHy6aSjtN004soj0Z2eV3c/wyZnG7IUKm+AlNHFtTZdiYByLTdmxLcERYKejBxnICT+mYHs2Wxfjj3oS1HSiV94kdpozzwttXRkvNNiTXpEieUVVksvoIpGX/xKM3aT1oIyiyoZpA8sDuoDBEweWP2pg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=acVW82QK; arc=fail smtp.client-ip=40.107.237.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=At2DDvmORjRYm1oc1vcVc0YuvbbGmFiFrDNNzbiIlJ2HtLzp6vnIb5Z8/Atnk/Z1Rq/LZgBAAVxNKCPQtzTQfPT8yfyrXFoK//etqDM0vxhRaOabjyxLI76y+XZXldcOsB7pje+piwpzOPjnuyGuxmbZ6MTgtJsZmDT14fnLt3Kp68N8j0IhtMMP/C+1b8wTJxtzNz3cjR0xAvqC0Mgpw0F86Zc8y/fI1fDXTlKdh0J2AOIdvy3DMBCU7xi66oa0nYIDEKDBOtBZZNiTgnlWlDWVu0/cF8vIInVIBp5DfsEn3tSdR6sb7C3RcisxLtQA9ktha0KvzcKsrK18D/EKyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u04HNSUFlpUbwHS8ov7jrU3csiQbsX2NmhpLJVcADtw=;
 b=dRVxkj0V19azVX0TVNJaU4chyRBDi9w19YMt62gfu5MYx7nY3GJnuNfWQwlO0oeM5xpQD1bPJH2YWg+mm0mXbMGKYSAIoClxIJXA8zj5p1uGa+6JnW8yO4zwZ+lAj4lUToiXCsdkfjKLeyhU+tBUQy5hWTv6nNExdkfgeSvo4l5RJpnrYbj+q2cuhJpRceO5ql3th+ngihDbZeGQ0ZsQNK8f2xSWAeT3ID3tAGNrjhHNHqX414ldHZ3mrEaMAMPLKWp/BnRjTPZaCnEWvyIFAlFUwKzNJ5eFL/yejYZGjVsUubVrfYEK0B6qr9qb2mFJinB38NEu7Oo7mTbOAl390w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u04HNSUFlpUbwHS8ov7jrU3csiQbsX2NmhpLJVcADtw=;
 b=acVW82QKxGc6Gzd+jjCqgFfJGGaTbrCvtbBJ8utaXBha3PJ95i1r5iEF3BAyQn0KHn5WDVqAScW9XRf5HHBDpzCyeVMTbJmma8knqit+2wcGtU6V/4GLAsUXk5A4cc5bYRH1DeTggT1S3Gbuzmjkv0T5JzTWOdgARt1+AugQgXc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB8838.namprd12.prod.outlook.com (2603:10b6:208:483::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Thu, 22 Aug
 2024 19:16:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 19:16:02 +0000
Message-ID: <2f712d90-a22c-42f0-54cc-797706953d2d@amd.com>
Date: Thu, 22 Aug 2024 14:16:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <20240719235107.3023592-1-seanjc@google.com>
 <20240719235107.3023592-4-seanjc@google.com> <ZseG8eQKADDBbat7@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 03/10] KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for
 AMD (x2AVIC)
In-Reply-To: <ZseG8eQKADDBbat7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB8838:EE_
X-MS-Office365-Filtering-Correlation-Id: 593c076c-3c7e-4784-ba97-08dcc2dedd16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WjU0UVNaR2JrN3NZQTZabTRYeXZ0YjU3VDNId3lIS3JaT1hYTUdjK2Jzd3BN?=
 =?utf-8?B?MmNMdjFqM3hxdll4Q0F6NkR4eThSTUErVlNFb3BmWmgvM3M0TGVaSUVNaVF5?=
 =?utf-8?B?WTNPNjg0cHIvQ1p4Z1BlaHE1ZU44VE43VEE3UUxkZDNDdmlCSm80WUQ5dUI3?=
 =?utf-8?B?UGkxMVV5Z1lZSlI0V29DZk1IZCsyZnJ0Uk14Y3RBRmdOdzhJTTFOZWV1b3p2?=
 =?utf-8?B?WnVOWGlhR1hPdmdtemljNUhrak9ZNmF2bFM1WTN0ZHY1U3NpTHpJYVh2bjZ6?=
 =?utf-8?B?WnlBQnJ1a3RZTTBvQStjcnRoUDE1ZFJvbDFobWpsaXVWbUdNSEZVOVphRllU?=
 =?utf-8?B?TitsQW1mTmR3QnI2bk92Z2k1UUY2YWdVY1dGejkwQkk2dzBwQThZbWs4YlhP?=
 =?utf-8?B?UG95S1ZXSTZYa2hBWGdCbHpsOXpOTUhpNm9BQmlxODRVVVA3dVZNQ1hWT0pl?=
 =?utf-8?B?S1FuVXpudmkzcy9VaCtpWnFyVmpWT2JIMGM3MjBIQXQvUE1iMUk4cjB5dzBv?=
 =?utf-8?B?aHY3cS9IS2oreEI2R2g4OUtkV2E0VmoxTnRVaUdtVmdCc2tqeDkvazJVeFNv?=
 =?utf-8?B?NExCck11SFVHK0RUWVVMVUFvbDluWGpwcFdLcUxYbUVud1NFSkhTTnhGKzk2?=
 =?utf-8?B?eVI4V09IV214VkNQem04aEJtWUpvb0pkNk1nRTZlODJLMnExb0lMcG5JSmUv?=
 =?utf-8?B?b3dnWXlyeEplYVVPWmxPcmMxbjhVSW1aTm1ORm1FT3ludVBXUDlvaGJ6bWNK?=
 =?utf-8?B?Unk0c1VGMUExL0JVUURtTHV3dWZkOWk3RGRRL2Jna0ZwUGY0WStXMVF3R2Nn?=
 =?utf-8?B?UnVnQUJ2dG94WE9GVzVabXZvNDNteWhZSHZYSjcwaXpjMnlmUE15RG5PeHRW?=
 =?utf-8?B?dmhJbDhXM0NsTUVjcURPekFRVTR5RHlvSnBQY3hEaS9xMDhzK1h5Z2lPa2RF?=
 =?utf-8?B?aUdhQ0dYdmVnV0dhTmcwVjVwSmh2WDh1NEFxcDRQNWdqZmN1bXNzdnFCbkZV?=
 =?utf-8?B?YnVFL1pBWjdCUGtlTHplZG5ob0xsNk16T0xGM0N5aFp5d3htM1RWbU9DRWxh?=
 =?utf-8?B?K05PRFNQWithbXA3ejNwa3NLQUg3cGpqTTUwM1R3bmNFYTBJM2VTaEVrUldu?=
 =?utf-8?B?M1dxMDE2YXlMdXNBOEl1N2FoTE95Ujk3Mjh5bnB1Z3hHanJIekgwN25vSEJQ?=
 =?utf-8?B?ejNmMzBrSzBlSXhTaDJYdWprUEdCWW5TUjBKbzZOOUJlb3NWZS9ZOHpGY2NZ?=
 =?utf-8?B?dndUTWhwSGhwdXFTcFZseUhJcmJlQmFyRW5ZMTFpL1g2T2ZHRWI4a3B3M3NE?=
 =?utf-8?B?eXAvUmZieFhMYmFrRktQdktZMXNuaUczcG5BVTJTODJtNzFsTkhJaTN0SjVU?=
 =?utf-8?B?MnM1bGRpbjBRcUtWT3VJYWs4dFJtM2ozVWFHdE52NGpQbWxhZ2dUQ2xKNmdh?=
 =?utf-8?B?K09KSllTeFVKcnh1MmVSYW5ibkY5QUJLUEV2RU44RWRBN2xqYWlSaUlxOTJT?=
 =?utf-8?B?Ny9qYytuKzJVQ1VhVWp2UjNVdGxXTnZKeUNzSzVqd0ZrOFJJS1ZpNVZjUU1R?=
 =?utf-8?B?OHBiNElnU3dKakwxWFFFV3RsVTk1Uk8yN1FSR2RHU2dQMGNSY0o0bmxUdWM4?=
 =?utf-8?B?aGFmZkRSZmQxZkRCY3BFNXZYeUJJV0lCV0p4d2pJQzBIK2U3elBoWFNxUUR0?=
 =?utf-8?B?V2xwZ3hQVVBxTDQwMTJPR2I1K0VyWDlEUkVIS2hBQWlUbmUxZjRncmpudElt?=
 =?utf-8?B?b1Z2aW4rSStZRFA0YWRGTktLblB1ZzFPMit0eTFUbXU4bWRYR3IrOWtVOHY3?=
 =?utf-8?B?ZldIUW5nc0M5L0tWMWU1QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmVMQy9zS0pUcm50OGFRejQzU1Y5cnUvb0dGT0dRS2JDVnVOdTk4aDVXOStJ?=
 =?utf-8?B?dWZZWCt1aEkzNUhEV2g1ZDZqczFveHlNaFJzTUlXMGNiaDkxUHYyRVhCNmFR?=
 =?utf-8?B?Z3RTTjIxeUJWK2ptSGNkaXhodGd5bi9Pa1NPY2Q0MVNvUkpWU2NycHZhaCtq?=
 =?utf-8?B?NUlpNktoMFFNTmZGZGhucDBZNVh5SDZjemJ2cXB4ZlhLcGFqM1hTdXYxdjFL?=
 =?utf-8?B?U2psSG1reUs5d0VuWnhheGl1MjF4Q3dkVjR2R1JuY2RaMkMyMDFnRi9aNWww?=
 =?utf-8?B?OUc1WmNHNnpxb3pKdlVGTW1oRUs0QUE2SlJUcHF1bC9LaE94Y0Y5Y3d5VG5Y?=
 =?utf-8?B?RDhKMzM0VVZtVndQVk5LZU9teE9LM2hCZTQ0RnRXS2ozaGpmc1ZaWUpYYk5m?=
 =?utf-8?B?Wk50WnF2VXEwdVpPUEF2VW9VUXhQKzlJY1JXZ3o5cERUUEI0VzFseUhuRER2?=
 =?utf-8?B?aHBQR1RTb2ZuQnU3MGtvbXUxdnREelBHNXZnOXpZRGNPWkwwOFR5WG9vTFpP?=
 =?utf-8?B?Yk1mR1pXK08wUWc5R201bTVCWHZKMVhDQnpzcGF1M0ZYeGlOQ2JVREs0MTZU?=
 =?utf-8?B?SXFLYlpLM0ZLcXNBUlFDbCtzZEdjRzV4TVZzbFZuMWxrUmtLMCtxNTdmRTJh?=
 =?utf-8?B?YjVyQVRjVUsxUXFqR293aG9uTXZNbzVJeW40NzJiMWNSakJTamMxU1R1WVdi?=
 =?utf-8?B?aTVBWDhpZVZDOTQ4cXZtSU9TNEpTWDhYRkFqZVFpemVjeTc1N3NOYWpSaENB?=
 =?utf-8?B?NkR1ell2bzF3UE9Ob0FQZWNuc0w5L0xUcFVtSEVrWGJPUi85NWJCdUhYamNt?=
 =?utf-8?B?MmUxa2ovUmZPb0p2eXFOaHh6bUZnQUpxR0h4UUlsR3pzOVlKSndQQXg3Skkr?=
 =?utf-8?B?TWxSeHYrNHZnWnRySm00NWVjVmc2K0JXeU82MTFOOGdjbmg1Q1BRajJnb3hr?=
 =?utf-8?B?dWhFOS9OYTRvdjVGbVdkaVhmVnBPY09rMXpUU1Y5YmlucUtyS3l2aUgyMzhx?=
 =?utf-8?B?ZkN5Q0pNWHJObDFlZ2R4c1BHSUtzRS85em5VdmpBSDhBcUQ2bFZXNGtOTlVY?=
 =?utf-8?B?cXBzaE5iZUUxdGNFNDdIa3NYYlNBREgwSjJTTlpXMkpud1ZNOGNLYVlhdnBa?=
 =?utf-8?B?Uzh6ZnpQdHNzM050bmNSZWRoRzgrck5xVzQ2aW4rWFhrS1hnK1lkRGNrVFJP?=
 =?utf-8?B?bVIxNjlPdXVueG55bklUSWV5OHg1WHFIVm13S3pKQUlxRVdMa3VTOVFZYnFI?=
 =?utf-8?B?dGp5eUpvN1BMZ0FZRms4OWxWMjVoSGU1ZzgyT2R2YS9wK1Y2U29qQ0tSWiti?=
 =?utf-8?B?cUg4RHE3V1ZybVlzR2N0bHVzR1dJa3prc3FWM2cyS2FhTFU4NGROMlJyamlH?=
 =?utf-8?B?M2xTOEN0c29IV3cyRms3N0ZuNFp3Q1l1R1UrdmdoVFphdW5UbmlYWC93Z2JP?=
 =?utf-8?B?VFErbmxWb1BZSjZ5WXFIRjZ6MkNpTzc5VVFWSERTWHlYUmxHdjl0NzZWUlMx?=
 =?utf-8?B?TGs1OHAwcENrOFBwOU85QmkwZExieWRjdEw1Mk92RlY4U2kya1d2Y2p1UktY?=
 =?utf-8?B?YkZ1dG8wZzBQQmE5dWxHZDFQY0xsaks0cjZ4Q3Y1YVFQWGdEaUJYdUV2YnY0?=
 =?utf-8?B?R083YW43WE55REhpcDlSZFBoU1Bwa1BlYnRxZkJWeExSekd3a1V2ZndONFNI?=
 =?utf-8?B?TGhCUzUyTjRtV3BFeVlFUWJrQ2FMMXRJQkdBS2xOVW5KWmpXaG9YbjJFR3p4?=
 =?utf-8?B?S21FVjJ6aWNPeDdFTHZqbkJmWkZQRkhrV0gxNUxDU0VCMHJIUW45SXhqYU50?=
 =?utf-8?B?YXB0Q0ZHaFUxMHJibU56NHYxNWl5TUR4SlNlRWdiM0lNZzhRTHkwWU1DKzBC?=
 =?utf-8?B?MjdJK3hmUm1FVVhSR25kdGdKcDlNWDJ4VnBFdGxOSDdxUm14cTlDMUlrRUMv?=
 =?utf-8?B?L3pLT3RXVDNuY09xMlRNRkwrUDBFVW15Y3ZxYmJLTWxOMUJlekMrQjY5SmhS?=
 =?utf-8?B?ZHp5QnBxeXM0MS9nWkY4UUpZKzRvQmNyRmU4TlI4VWVtOTFDY0VRdWVyOWdQ?=
 =?utf-8?B?dDN2ZEdybldyTVBhWWhDSXI5eEliVnJkMCtiOWEwamxQT0kwWURNOXRVY3o2?=
 =?utf-8?Q?iDrb6LiVdL9flzdq5qy8RgoYd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 593c076c-3c7e-4784-ba97-08dcc2dedd16
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 19:16:02.9101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pTuFNns0Obdwy65xZu1Xb3TKfoqkSaR05GOb6YsJGrpvVua5cQrf3YGWQVdRxdxQERMWfJ3KX7BpFkEJFbQ+bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8838

On 8/22/24 13:44, Sean Christopherson wrote:
> +Tom
> 
> Can someone from AMD confirm that this is indeed the behavior, and that for AMD
> CPUs, it's the architectural behavior?

In section "16.11 Accessing x2APIC Register" of APM Vol 2, there is this
statement:

"For 64-bit x2APIC registers, the high-order bits (bits 63:32) are
mapped to EDX[31:0]"

and in section "16.11.1 x2APIC Register Address Space" of APM Vol 2,
there is this statement:

"The two 32-bit Interrupt Command Registers in APIC mode (MMIO offsets
300h and 310h) are merged into a single 64-bit x2APIC register at MSR
address 830h."

So I believe this isn't necessary. @Suravee, agree?

Are you seeing a bug related to this?

Thanks,
Tom

> 
> A sanity check on the code would be appreciated too, it'd be nice to get this
> into v6.12.
> 
> Thanks!
> 
> On Fri, Jul 19, 2024, Sean Christopherson wrote:
>> Re-introduce the "split" x2APIC ICR storage that KVM used prior to Intel's
>> IPI virtualization support, but only for AMD.  While not stated anywhere
>> in the APM, despite stating the ICR is a single 64-bit register, AMD CPUs
>> store the 64-bit ICR as two separate 32-bit values in ICR and ICR2.  When
>> IPI virtualization (IPIv on Intel, all AVIC flavors on AMD) is enabled,
>> KVM needs to match CPU behavior as some ICR ICR writes will be handled by
>> the CPU, not by KVM.
>>
>> Add a kvm_x86_ops knob to control the underlying format used by the CPU to
>> store the x2APIC ICR, and tune it to AMD vs. Intel regardless of whether
>> or not x2AVIC is enabled.  If KVM is handling all ICR writes, the storage
>> format for x2APIC mode doesn't matter, and having the behavior follow AMD
>> versus Intel will provide better test coverage and ease debugging.
>>
>> Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
>> Cc: stable@vger.kernel.org
>> Cc: Maxim Levitsky <mlevitsk@redhat.com>
>> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  2 ++
>>  arch/x86/kvm/lapic.c            | 42 +++++++++++++++++++++++----------
>>  arch/x86/kvm/svm/svm.c          |  2 ++
>>  arch/x86/kvm/vmx/main.c         |  2 ++
>>  4 files changed, 36 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 950a03e0181e..edc235521434 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1726,6 +1726,8 @@ struct kvm_x86_ops {
>>  	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
>>  	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
>>  	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
>> +
>> +	const bool x2apic_icr_is_split;
>>  	const unsigned long required_apicv_inhibits;
>>  	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
>>  	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index d14ef485b0bd..cc0a1008fae4 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2473,11 +2473,25 @@ int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
>>  	data &= ~APIC_ICR_BUSY;
>>  
>>  	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
>> -	kvm_lapic_set_reg64(apic, APIC_ICR, data);
>> +	if (kvm_x86_ops.x2apic_icr_is_split) {
>> +		kvm_lapic_set_reg(apic, APIC_ICR, data);
>> +		kvm_lapic_set_reg(apic, APIC_ICR2, data >> 32);
>> +	} else {
>> +		kvm_lapic_set_reg64(apic, APIC_ICR, data);
>> +	}
>>  	trace_kvm_apic_write(APIC_ICR, data);
>>  	return 0;
>>  }
>>  
>> +static u64 kvm_x2apic_icr_read(struct kvm_lapic *apic)
>> +{
>> +	if (kvm_x86_ops.x2apic_icr_is_split)
>> +		return (u64)kvm_lapic_get_reg(apic, APIC_ICR) |
>> +		       (u64)kvm_lapic_get_reg(apic, APIC_ICR2) << 32;
>> +
>> +	return kvm_lapic_get_reg64(apic, APIC_ICR);
>> +}
>> +
>>  /* emulate APIC access in a trap manner */
>>  void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>>  {
>> @@ -2495,7 +2509,7 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>>  	 * maybe-unecessary write, and both are in the noise anyways.
>>  	 */
>>  	if (apic_x2apic_mode(apic) && offset == APIC_ICR)
>> -		WARN_ON_ONCE(kvm_x2apic_icr_write(apic, kvm_lapic_get_reg64(apic, APIC_ICR)));
>> +		WARN_ON_ONCE(kvm_x2apic_icr_write(apic, kvm_x2apic_icr_read(apic)));
>>  	else
>>  		kvm_lapic_reg_write(apic, offset, kvm_lapic_get_reg(apic, offset));
>>  }
>> @@ -3005,18 +3019,22 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
>>  
>>  		/*
>>  		 * In x2APIC mode, the LDR is fixed and based on the id.  And
>> -		 * ICR is internally a single 64-bit register, but needs to be
>> -		 * split to ICR+ICR2 in userspace for backwards compatibility.
>> +		 * if the ICR is _not_ split, ICR is internally a single 64-bit
>> +		 * register, but needs to be split to ICR+ICR2 in userspace for
>> +		 * backwards compatibility.
>>  		 */
>> -		if (set) {
>> +		if (set)
>>  			*ldr = kvm_apic_calc_x2apic_ldr(*id);
>>  
>> -			icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
>> -			      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
>> -			__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
>> -		} else {
>> -			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
>> -			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
>> +		if (!kvm_x86_ops.x2apic_icr_is_split) {
>> +			if (set) {
>> +				icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
>> +				      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
>> +				__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
>> +			} else {
>> +				icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
>> +				__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
>> +			}
>>  		}
>>  	}
>>  
>> @@ -3214,7 +3232,7 @@ static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
>>  	u32 low;
>>  
>>  	if (reg == APIC_ICR) {
>> -		*data = kvm_lapic_get_reg64(apic, APIC_ICR);
>> +		*data = kvm_x2apic_icr_read(apic);
>>  		return 0;
>>  	}
>>  
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index c115d26844f7..04c113386de6 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -5049,6 +5049,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>>  	.enable_nmi_window = svm_enable_nmi_window,
>>  	.enable_irq_window = svm_enable_irq_window,
>>  	.update_cr8_intercept = svm_update_cr8_intercept,
>> +
>> +	.x2apic_icr_is_split = true,
>>  	.set_virtual_apic_mode = avic_refresh_virtual_apic_mode,
>>  	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
>>  	.apicv_post_state_restore = avic_apicv_post_state_restore,
>> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>> index 0bf35ebe8a1b..a70699665e11 100644
>> --- a/arch/x86/kvm/vmx/main.c
>> +++ b/arch/x86/kvm/vmx/main.c
>> @@ -89,6 +89,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>>  	.enable_nmi_window = vmx_enable_nmi_window,
>>  	.enable_irq_window = vmx_enable_irq_window,
>>  	.update_cr8_intercept = vmx_update_cr8_intercept,
>> +
>> +	.x2apic_icr_is_split = false,
>>  	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
>>  	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
>>  	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
>> -- 
>> 2.45.2.1089.g2a221341d9-goog
>>

