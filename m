Return-Path: <kvm+bounces-25904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2172896C7D0
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 21:44:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A43951F2631B
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 19:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0F91E6DE7;
	Wed,  4 Sep 2024 19:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DOfvnLOd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B768684A27;
	Wed,  4 Sep 2024 19:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725479081; cv=fail; b=f6ELlDZHGMRUAkUYqomCcaJcEyv8SXOUzc0sD8eHvR1AuMwtmwPILnz6Ujz8teCLuzFRn6z5+VV8SwNqFXhERJbuF/UYA5N09L0fY3yUC7ou5iRltBYq1FrAvxeouXch1uPVr8arCRqPQovuN3vVZMp3ah7oloQl0zj1E5+S3yQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725479081; c=relaxed/simple;
	bh=EjYCAIO6s7wRvdStOsT3+lbLTegRy0Sxj7CNOy4m0cQ=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YYP64TDKg1F4hLyeCUL9I7S9G4FzCCBFStTOqGKYAHwo6iTa9R7A31BFnxKdS85PQah+3FHqSt4mR/o8iolldviZzlCTlRywvulCTTolej3XPflM3/Ybheek3eKwvvwxoRPTKZDFkVSi1VZprL8dwCoNdEUke68/Ya4AX+WvnFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DOfvnLOd; arc=fail smtp.client-ip=40.107.223.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XuCuhKBJIA5llSq7UBokYAHZJCi6xEcsUrTrS5K+ujurGj7ybHo2LlLUtlH/qtkkwnK0jB3q5oU9s8GlCNB7jyg3Xc3j9LP7Q4JUIX5C6F7Fl3p25kFf04afISTMUs/5EmugB8WYmLEuVxM9IBjm95oXtHB28AYYZXZcaRC25RZlntnGGHVJ8AXHxIRnrP0n1Gww+4O5NJGwDg4Vdld8ioF4QUSFzPCAmEcrfAOWS60aam7byvmGYWNoF4VEF24kwnnTtGn4wRxByBv8B7RbdLJKmijI4R1pce7STXXorewH7L+2Fd8/wp9xk31gp/J0fy8ntip7wGU91lNgxObCIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsibxcKAXN+bv18fkS85nWEFtgQgqC+Gu/L2q8r5ixk=;
 b=u+o6LywKtBKegNNL9iLa30byIQb2Jq+q1VOyAAziUD39/PCB/NJtD9/qXkHNelXB4YV4zmoQSsoOXZZDVSEC7fNSaNTrM+vnfMOWiS+DPwZfayT6U0Rk9r68ivJoxeIjSuiEO3kr4pXI2xXo0NMa303OOnpnDanS3cDzdx1AU27PLbzOjqXTpeUuLjJM2+VDchmJpN9fqCEBBYuUThwbIeKR9GYxO7l6a74u4qMXIEwS5UBVqARozCkl3niPGzhvudVQo4tH87G6qaU7uHiou0qcKZlrV9a9AQpHbrMCClpBtPgvrfz5dtetLkc1DlxVWtCpLzQYxsmKhgXW5kdWfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsibxcKAXN+bv18fkS85nWEFtgQgqC+Gu/L2q8r5ixk=;
 b=DOfvnLOdMThku2eCqcKDEmLLhXA4+6z/J36rP6a2BcxftAsej0LJ7sId5j+kFXAOKJzCYvzNfxTw5rIh7l6QbSa4NNRvgmpOS5R3uCCHJfoVnWbX0GK6gFUSExKvZCdRb2ZH/kOD0Uljsq6DEbGW+zNvTLmItaDbT2o26y5OxAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Wed, 4 Sep
 2024 19:44:37 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 19:44:37 +0000
Message-ID: <89cef849-4309-478c-8250-3e668943fa15@amd.com>
Date: Wed, 4 Sep 2024 14:44:33 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/sev: Fix host kdump support for SNP
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, dave.hansen@linux.intel.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 thomas.lendacky@amd.com, michael.roth@amd.com, kexec@lists.infradead.org,
 linux-coco@lists.linux.dev
References: <20240903191033.28365-1-Ashish.Kalra@amd.com>
 <ZtdpDwT8S_llR9Zn@google.com> <fbde9567-d235-459b-a80b-b2dbaf9d1acb@amd.com>
In-Reply-To: <fbde9567-d235-459b-a80b-b2dbaf9d1acb@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0161.namprd04.prod.outlook.com
 (2603:10b6:806:125::16) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH3PR12MB9194:EE_
X-MS-Office365-Filtering-Correlation-Id: 0606b37c-a72b-4cac-8c65-08dccd1a0236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHppYlZxOGp5bFVDM0ZEWEZWeWlKeEtBS1dmZXIrc0RjMW0zTEk5QTRoWnJW?=
 =?utf-8?B?eVRXV0N5dUJtMXZZUEh6dzVISDdBdlM3VGxyd0ZqajBmS1ZQYWEzbllVS1lT?=
 =?utf-8?B?R3VGeWJzUktsN3I1eGhuMGdLK3VWdlJQV3BxdjI5aVBSOW0xdVJPektCSEVC?=
 =?utf-8?B?NW5IWWdyNHg0aFU3NUR1YmFDTHgxeFdaTVh6OENPS3Z3WFBaL3NJaTd3cWhr?=
 =?utf-8?B?ZG5Ib0RKYS8vTjBqSk02UXBTWVVpM0RHVStWZnJjLzNZVTczWnJ3VldsMEcz?=
 =?utf-8?B?WXRsRWFXTXBnQUlwRTRIMWx4bkFVRjQvQ2grNjRMSEVFKzE4VzBpY211bnVy?=
 =?utf-8?B?TEtVMWJ6NDFOMkR5b2MxRzdDZ1RVZ0R2YVAraEd5TnVSVWtrd0E1ZmlRRCsx?=
 =?utf-8?B?ZG00ekt6dnRBNTU1R011azh5RzRaTUpnZTdNSG1OZDVyUGt1WngrQXdGaGVa?=
 =?utf-8?B?b3N2TUlxckhxbDZ2TUZNeml6UVlVTy9Ra3kwVUZDREtmYWhDYyt0MUFxSkdn?=
 =?utf-8?B?M0VSZ2tPd3pPVklEUWpkazRHNktIVmtHQ3dvRWRSM1lqaHVQZUtRbHQzQys3?=
 =?utf-8?B?amcvdUdrWFJHcFkxWWZ6Ti90SkNkMVlrdm9aU25TclU0UTFJUCtEVURLN0Va?=
 =?utf-8?B?ZEpDdTU2UDEvcDdUNStMUjVNWkdBN1VIY1g1eUdrdVV3emJHUHN2anFtU21s?=
 =?utf-8?B?NHhGNmZJTkQrbDk2VmRpWkpveDQ1VVNESERyTHpZdGR0enRFc2RLYUdNeGNZ?=
 =?utf-8?B?MGs3MHJMZjI3TVY1OWJjQVZuSlVLazQvS1VheEEwZk1HOE1WWitxdXdNK1hX?=
 =?utf-8?B?ZWFJTmx2WFRVVzR3MVd5YnhaMCtpRFFrZkxKZlZpSzhUNk5YZE4yUnU1djQy?=
 =?utf-8?B?SDBNNC9lUVdValJIbWtQTVJhaXBDaGpqb1JmSUFka3dkb0JYOXhndGlvS093?=
 =?utf-8?B?c2dOb25QQUkwaERCRjhrWVJyTlVNTCtmM1JjRjNBNVJhODc4NFZONG1nNm05?=
 =?utf-8?B?Rk5IbXlIbDdiVitrRmdrYTFGOUx4cEszK29qU050ZFo1aUZ3cm9OTTI3Yi9Q?=
 =?utf-8?B?ZWU1VHVYVGMxWHFWMzk5ZmFOQzdtTkJWL2RXYStxRUxWRUJBNkhsR1l1T2xz?=
 =?utf-8?B?clVkbzIwaDh4RG04YXNqTjRmN0I0OE51dEQ5aGo5YmpyREJudlZkVDYwUlMw?=
 =?utf-8?B?NzhZOVJlMXhkd0hXMTN0SzltQVRUZkVaQ2VsSTNPQ3lLUmxnejlnbzlvYVpq?=
 =?utf-8?B?WUdoelZ1ZjBva0tQclMxYlVJTEFtaSthT1ErczhkZXlPVG5tTzRhZ2VaU1ln?=
 =?utf-8?B?N3lLRUxjQkxQZHh5b21aUE5YMGJnN3AwcWV1bS9PcWY0R2RvV01JSVorSjhF?=
 =?utf-8?B?YkVkeXJjUFBzcFpVMWF6dWx0RERVWGowdCtMRTF3WmhRMWw2cVA0OWx2V2RP?=
 =?utf-8?B?eWJ4cE9YUGdQdHB3bG5VbGlsV3lzU0RHd1pDekdvRXB3MVJHZVdIRURsdEVz?=
 =?utf-8?B?UTA3WWRRWmhBR0FyZUZEeVFIMWVEQkRQMUU4ZkRoK0QrODVZVWZzTlBnenBI?=
 =?utf-8?B?dGhNZ3REVGd3Y3BIVkxhVlBycnl3RUd6Y2Y3aDFJbUpLR1pTdW9OOW5PK2RJ?=
 =?utf-8?B?Z2I4NSsrdFBNNTU1VjBaRlNPTzJtTFQ2N1RqcmZvNHdwejF5SzFlWmR2L25K?=
 =?utf-8?B?YjZiSUpCSVV2NWxCZjRKb2NlZ1pDUkk1M2pib251ZUVhZXJXYmhVaGJFVUw0?=
 =?utf-8?B?cURqcHR2TlQvcnExeVBtMUpyOXhxWlB0WFJvbVBFcHVVM0ROOUJwMTdZOWJw?=
 =?utf-8?B?YWtpaDV3S3A1Si9uWXhyUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WENDZzRWYjhUa3p6N1JVWDJNWXc0RXFMelptSlB6YWdXNHNQelJaRXJoSXZI?=
 =?utf-8?B?Ym1lbWRlZlFQZGF6S1Jnc1FXNkZZMnJaek9NYUFBRGYwVU5BREIwbXZFUjE2?=
 =?utf-8?B?NmM4N01uMHdWT0swSVp3dE5uUFZBWlk0eURLcUtNTW9KTXgyQzYrdUpBdnhk?=
 =?utf-8?B?ai9IYVM2L084RDEwNDJrcTgvL2NubEhJN3dHR3hNeENJc3g0bHV0QjVUc2N4?=
 =?utf-8?B?YWdTWE1PNmZweTVsUE9rUUl0VlMyUit2YklLOW1jb0xtMTluSHBQeTRLZi9C?=
 =?utf-8?B?YXppQU5NVVk3SmxHbDdPbXM4YlVya1BCYjZ5bmhTTHNDVk4yeXovUjdZVWVm?=
 =?utf-8?B?UDhBM3UzNDdwN2hweWVFV0V4TU5qazNiQU03NVZqei95dlNMa01pWFRqMmFm?=
 =?utf-8?B?Ykw4Snk4UGtxQS9PTjkvWm5HSTcxLzZVdGxBNyt6NFJPT0k1czFFblp4eXdq?=
 =?utf-8?B?UTljU29UWjJORERSNThyMHdSNUFnNnpDT2dMMWdjYkROejFPODltR0RSMWho?=
 =?utf-8?B?bTh5YmNLYUlNMW1meTZjS2VhdUI1L0VYa3A0U011RisxS2JXSFVvNmlYYTJ4?=
 =?utf-8?B?N0c1U0g2eEp2dEVWMXdmQm1jdngzdStsRHcwNmdCbkRsbSt6ZWxLR3FBM2FD?=
 =?utf-8?B?QnE4ZWVJQi8rMEprR0dZN01hUHlaUjZZeTVydUM3YW0rOTRrbHJpcUg2blcx?=
 =?utf-8?B?RTliUkRjS05YbGtVRkhGZ29xSlI5SmpENDd0U2xwY28rU3FZWWpQNWZEUko3?=
 =?utf-8?B?R0NlRmlBQ3RoaEFxYldzSUZESWdsemRVNEFxZUNnb3RXVk8zOVkvZzdPTmVO?=
 =?utf-8?B?V2dyc1MyZi95ZU42OXRpOFNZQitqU1MwWmU2UU96SysrQ3Y3L2EwcDN2U2dt?=
 =?utf-8?B?ZDVMT1dpWEF1ZnZMY3R0RzVZQzVsL2FZS2dtSFZTMVZkSVRLZ2NvNVNPck8x?=
 =?utf-8?B?cmF1Ly84ZXBaVHc1dmpnc0VqaHBUc0NPY25aZTRCQUpwVmM5NlI5dTZzcmpG?=
 =?utf-8?B?MFAvVHRGQ0NwYWJoTjdqb2VIc0s2UXhlMFRhMkp6MFgyUXFzQ2JBa2ZIc1Y5?=
 =?utf-8?B?djJMdHYycE1BTnZBNWdFbUJxSm5WK0thOGFyVmdEaFJUYmxIcWFqWGRGWC9a?=
 =?utf-8?B?WFFOcWdMeEx3Ym5EMGs3UGs4a2NzTmJwWFFVUFFacGJXeStyeVdnY1JvcTli?=
 =?utf-8?B?YWgwZEhNUXFZWWRLdnV6MVo0MndqbjhCY01WaXZjbm9hVHc3STFaa1gwZHov?=
 =?utf-8?B?YnAxU1h5bjVxMzZXdE8vVTFHcnA3cGVoS2k5aEZZRk41ZzlzSGl5dXhJUXpK?=
 =?utf-8?B?ekVVckdXTWQzdWVsNkRKa0gyUzAzM2MxWnpocElFMGh3dS9pajEwQ2tHSm45?=
 =?utf-8?B?dHl3QTVsT2xCcEFGRXJaSWsyT2FabFVaSkJ6SUpNd0tLbm52cjhMYjl1SzJu?=
 =?utf-8?B?bFAydGNMME5NOWpWREY5WDRTOFVza3dNNllHWk1nRGs1U09WWEhrenVyNU82?=
 =?utf-8?B?aWJEbmtReWNCMmY4bWtFdnNMYXR5dmxORjl0WnMzejJ6NlcvbEJaWDBVSUU2?=
 =?utf-8?B?UmRVSm5UYXJUN0lraEF3UjlIZHlCRmp1VWdSdlBRSlhLQlJCa0VuSjdiVU1v?=
 =?utf-8?B?Qkx6ME1UMnF4OXQ0cXlIZHJRS3RWMXVwY1VETmhCYWxkWVVwTGNWS1lkc09O?=
 =?utf-8?B?T2VNZnhuUXp4alVhR0cyRmIvRDA0QXlvaGVIV1ZnN0JuTndHMFlSbHptRDha?=
 =?utf-8?B?cWswbnBLRmJqUHpLRktiMUo2R2pjZENPM3VXeEVZaXJLUk1FOFZMVHh0Zlds?=
 =?utf-8?B?Y2tiMzFHalZFVUZBaVMxT05PMlpqWGVBdGlaSFdSampYcFNPZ1B6ZnlYdzJE?=
 =?utf-8?B?TXhGQ0FHOEtWVjJORlc4a3N6Z0JWTVd0aWdwaWs3eSthNndGQ2YwZEh5c2Za?=
 =?utf-8?B?KzdxRk85SHRHYkNpTVM0NFB4RGUvRFpTYTBmR2FIN2ZNZjFNSlR3NXNYSkNn?=
 =?utf-8?B?d2I3YUxzeStMRW5EVm1yWTFjQ3Q4Nk55YmN3UWN4MHJCOUE5UVVwZU9yUjFV?=
 =?utf-8?B?MmlvbXRoUm5QTWsvclduNnBwczB6eDI0alc4Szc3UWlhY1FsQ0t6R2xHZndi?=
 =?utf-8?Q?hnAPkdhuyDNKp+gifDIYPKprJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0606b37c-a72b-4cac-8c65-08dccd1a0236
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 19:44:37.1653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/R8szOA/lcG3KEcdHVCafNprfKqnmqPqBLcAgluOaQQkRYCR8OOQ3zEU27PN2fa2/LbnLM6XP4NXE3iqnrG9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9194

Hello Sean,

>>>  e_free_context:
>>> @@ -2884,9 +2890,126 @@ static int snp_decommission_context(struct kvm *kvm)
>>>  	snp_free_firmware_page(sev->snp_context);
>>>  	sev->snp_context = NULL;
>>>  
>>> +	if (snp_asid_to_gctx_pages_map)
>>> +		snp_asid_to_gctx_pages_map[sev_get_asid(kvm)] = NULL;
>>> +
>>>  	return 0;
>>>  }
>>>  
>>> +static void __snp_decommission_all(void)
>>> +{
>>> +	struct sev_data_snp_addr data = {};
>>> +	int ret, asid;
>>> +
>>> +	if (!snp_asid_to_gctx_pages_map)
>>> +		return;
>>> +
>>> +	for (asid = 1; asid < min_sev_asid; asid++) {
>>> +		if (snp_asid_to_gctx_pages_map[asid]) {
>>> +			data.address = __sme_pa(snp_asid_to_gctx_pages_map[asid]);
>> NULL pointer deref if this races with snp_decommission_context() from task
>> context.

Actually looking at this again, this is why we really need all CPUs synchronizing in NMI context before one CPU in NMI context takes control and issues SNP_DECOMMISSION on all SNP VMs.

If there are sev_vm_destroy() -> snp_decommision_context() executing,  when they start handling NMI they would have either already issued SNP_DECOMMISSION for this VM and/or reclaimed the SNP guest context page (transitioned to FW state after SNP_DECOMMISSION). In both cases when we issue SNP_DECOMMISSION here in __snp_decommission_all(), the command will fail with INVALID_GUEST/INVALID_ADDRESS error, so we can simply ignore this error and assume that the VM has already been decommissioned and continue with decommissioning the other VMs.

I actually tested some of these scenarios and they work as above.

>>> +			ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
>>> +			if (!ret) {
>> And what happens if SEV_CMD_SNP_DECOMMISSION fails?

As mentioned above, we can ignore the failure here as the VM may have already been decommissioned.

In the case where SNP_DECOMMISSION fails without the VM being already decommissioned, crashkernel boot will fail.

Thanks, Ashish


