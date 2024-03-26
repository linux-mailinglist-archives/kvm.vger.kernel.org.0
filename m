Return-Path: <kvm+bounces-12693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3224A88C0BC
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 12:34:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DF4B1F651FD
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 11:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F44870CDA;
	Tue, 26 Mar 2024 11:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="oGmxAzIT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2133.outbound.protection.outlook.com [40.107.220.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66B46F51F;
	Tue, 26 Mar 2024 11:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711452821; cv=fail; b=Z6POXF3VKwaDpzS8N1kzNbYJgwuudxd+7EVX0oaBv8GMk5HulMGOwac2Di1kqqCAgOxd8A2XQdGOyG97FOeb6PL5JrQzyhUL1byNYI7PYjIxvSMgg+Ib1qJznm/K1dBeaJ+0NsOsvzNh/DO9lWJxwBO5zZ8QBjzNSqQbNRhGmh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711452821; c=relaxed/simple;
	bh=cQBfU+1E0cvZyuZ8Cdi4zN/FxBa9UYsz76UH0Kjtqy8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kK9DgJyLS0p6w5XMOhod1S9SvqN0z0fZwR3kMZn9fQmz6uwl5OfZCb/DKWtEd+jekIX2/xVdMYnygVoFPojeywx/pdPYY7m6gIAPfPxPa3t3c1sNklicCyEvXNYgJH0sDDhzcqIDiSqxZogqcnjLm/MFclPQBdVboIxaOlCoAWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=oGmxAzIT; arc=fail smtp.client-ip=40.107.220.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAaT2Amb7oQUFaqKNAfANG1TYlPMYglppW4NteSit7wjrLyIXKqLoz6URE/CDANyaCqDZy2cna4Hrn6uf3FOSSwB62sGNp6rKaK0HztYq+vCHvaxnai3DX7TLwGCOp1FLuyv8Wnjo6fatv+wsfbdqd7MGZNKG2wp0WFcJmJL9tMerKuAcTE3XKfCRXAOz1FMa2B8MgoMuKJEO5szI0t38RG6G51Qov9SHFubtK2bpAvi4IbHYjZyas7afmcrCz2uwdCcLnAhhth9DPsGbvsY3s++KGJIUMAYUwiChldTPpJKmd3H6JlPCmHzDqohKikoqn3GNDBChv+wLq/FEroriw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8DcVbZM19hPJLM7Nlz39a6TenHeQNDuFjVoVMq38cI=;
 b=Bd3291Y2S0gFdmq4oLIBf0XmjSifcdyoWXG0rAG1NquHSyXkSvJnwDAXu46tZNrU/vLtlY5qP8pFyrzn5AJQFBvXbGqpd6r78El5cOgrBM2buOF5ljuwLq715ofNB1FNKvHU+cqtTsdq3qxvef/ymx/ViIjuVB3fYvOOuMn4xNp4eP72PZGjGGFqD8iYi1+rM8a+/gRUvWcvEkCJgGz8bCfc1lmFi/jlXKm5KdlDbfZmx/VUewP92PLVymRqnORjmoEw8BrOhLqV6QYNerCgayAiQBJWUgbK1mlTngfC2Y69xq5fUgCaVdHX+la23wcESGvkL4VEKFQmNW46BL1whQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8DcVbZM19hPJLM7Nlz39a6TenHeQNDuFjVoVMq38cI=;
 b=oGmxAzITGAUq1Xoo5zn0V19sn1hN/guPuWX9f6wfNcKJoZfoNrtOcseNSsjM/8qXOm93hJoVmAaUbBWcYWCzCWqvG4DTLH/XQjGYjb42Tqanmwy+3xinMNer8jt9GXwtRONSmRU1EK9a6mbvluqdTfSdxcZ3KVHvuTLb9yaODFk=
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 PH7PR01MB7702.prod.exchangelabs.com (2603:10b6:510:1d5::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.24; Tue, 26 Mar 2024 11:33:37 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9%3]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 11:33:37 +0000
Message-ID: <92117ba1-54ff-4752-b446-0ed09bde7201@os.amperecomputing.com>
Date: Tue, 26 Mar 2024 17:03:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] kvm: nv: Optimize the unmapping of shadow S2-MMU
 tables.
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, darren@os.amperecomputing.com,
 d.scott.phillips@amperecomputing.com
References: <20240305054606.13261-1-gankulkarni@os.amperecomputing.com>
 <86sf150w4t.wl-maz@kernel.org>
 <6685c3a6-2017-4bc2-ad26-d11949097050@os.amperecomputing.com>
 <86r0go201z.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86r0go201z.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::12) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|PH7PR01MB7702:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ym4f4cXcJgIgpR5PhFy0bAz+f1R7hjuJeoQOLMorGh5VMseJIXlh2JLXOOQ2i2h1z+N83DNYvnpNgXoLQeeYUMlKDhRq/jUHjc9Q88RVaZOzoaiIsWulcQRSkZcTB3FahK/pR8oxLSP2MsE8gZFLOBXxwIanOoZbrPq423oCuISeAn2trzmeEZvquxu7FRAGn5c8cyftrvZoZ5wuvrZCoaZhzZgdwUBernKK7AEb1EdwMbsESGeCrP49dOl+GQexGyhPuTPjYF4q3CQbemlkjqivvazWScAnoSKkYGogQoutT7+2zN3TWjC9L+O3K7wNZzZMKrsMkgBD5oPvP8ONWX5CCQLoQRKYBGtd+pr8ipCLmMjNVlcVF97x1p0lW1L6WfEM6HJrAPjeCsjdEXZ5weBQAH0KZ4PlOVM8x2H8wyowiQ9f9EjibKk3az55j9rjlOBpCOJddNTqPOvPl6UkMbTyNoOofawgH9sRzmFJcITKoi5l3HTvfm5EDx3yn506MMppa1oAA7r9EoKN666LvcS3s7dsy2kox43U/2VytbTxEMwV7QnWcX9vVC0v+ax2ZORNRoOD4VU10rQiSOUZ8NjAM2zgrABphWdCpWhGgPCorcHxw0vGYwoDWwDeTZhj3NPweF2e27BRzgtJn0IOYF7oAmETBKBIxHhSPko0D9k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckM5YXVjWHAwTnYxVW1pSjZ3R29tSzYwYU1neUdqTFhndDF4eElVYitDUEYz?=
 =?utf-8?B?bUd1VWFNeTVYdWl2MkdsQWg0MDFwcFZ4cVB1OG1iWU5JaERWYjhzajFMZGx4?=
 =?utf-8?B?OHVlN3BHYjhUa0IvV2MrQVhxU1FVbmZJc0RmamtHenFjT3pPMnNHTjJKMzhj?=
 =?utf-8?B?eVpjTHhMTEd5Mjk2MkkwSWYxMVBQVlVhWFBpVFQzbWdmamFrWjdDVXMrMWVQ?=
 =?utf-8?B?cWdaZ05PbnhocmI5VmErRmhXZGo1elpFWkNFeXE0cGtxcDl0blVJcWRsU09a?=
 =?utf-8?B?a2luN21Jb1kzeGFtZnByOFpQdmoxVG1MV2EzYlZxREZjdE04WXgyTXJ5TlE1?=
 =?utf-8?B?ZUE2aU5WU2psbDEvMmI4QmFWUWRXMUJpc1lteVJMcCsxamFYVlF0T083YW5h?=
 =?utf-8?B?M05FckRuQ0Y4eHlGbGpwbmVnbWJaZ1BMc2h2UG1iMlluVnJWbmpJd0F6SERz?=
 =?utf-8?B?YW9MZzExMnhXc1JjektYaXVaTTFhT25ZLzZyZzBTbERRRFBxUHgzZytKSVRw?=
 =?utf-8?B?WU5WUVdmVEhRZlhWZGdIZ2xLbmduL3BjMWM0MkltL1hQVWIrZmwwM2k4SG1h?=
 =?utf-8?B?YmY0RVpBQUszU3h4K3hKYklvUis1cWVKYzFaMWRVcEhYVHpmbDN0RHJuMURn?=
 =?utf-8?B?MUhNYzB3Sjd6WjFmSnpveUx3S2tZd3Qxa1ZQZjZveVo5S0hFNHk3bXRtdXIw?=
 =?utf-8?B?WVM1V1pNZGhNeW1nODQ4UHFGRVNFVzdtSHdTNjFrd1hqOXJudGpGTU8yRU5m?=
 =?utf-8?B?VVhpMTUwVzZ2d1l3VXNCY1VjaVMwd0RDNlBjeSs2ZTRwdDVWaldwdVJqTmNU?=
 =?utf-8?B?YWhTOEhGalZTZDdiVkh4K1BZcitRN0l6dHJwRjRuQ0ZrdFFYV3hzTWlleVND?=
 =?utf-8?B?eStObENkbUpYRHR3U1NlOVdZUGFVM1d1V2t5WFFWZHA4clJpWUxqR25jYXMw?=
 =?utf-8?B?MXhvYWxOUUNpcytmdk16T1lEV2NaLytYUUF0dnA2eGZaRHNaZ2pKQWRKS2RZ?=
 =?utf-8?B?TmZERkNmUy9peGhHSHVwclhGaEIwWWE0bDhlRzlKNXI5ZTIxK2QvOG1aQ1E0?=
 =?utf-8?B?dHpnMXB0d0gvUnBGUkNCSmg0RFhxZTJwaCswczRCTzZQQ1hmSWwvRHNMZk5l?=
 =?utf-8?B?OWplSzhKdVRoaVlCRmNhRmhjZmZCTWh6RFZ1ZnJaSUlEalNBbms0WkRWellB?=
 =?utf-8?B?VnJVcFIvQUZaemxqSXVwcG5pQkMzVStzck0rMWswZTk1bWVlVWdvSEJXVktj?=
 =?utf-8?B?RDhyejM5eitoam95aTBMQ3F2dGJ2UG9mZXhuTUdRblNkTERwUnVGMEd6ZG4r?=
 =?utf-8?B?UXB3NUhZUThpODFzcW1aeng1K2R2ektMN0FPTElsZERJRndUR2IydzJkUkV5?=
 =?utf-8?B?clFVcE5XTHNYTk9Md2hjbkF6TmxQTmxRR0xoN2E0ZFQzYUQ3NGc5OE9qcmpK?=
 =?utf-8?B?cUxKWTg0dmxiTG5rVm1rQUkyWDJxVTg1WHY0V0hhNExFcExPc0F4TU1KbE0x?=
 =?utf-8?B?RnltYWFuZUxTbEdETVNVR2xUbURFUFlMSVc4TFB5dmgyWklEUW9NMHB0SE9V?=
 =?utf-8?B?dkZSSC8yMFo2MkJlQWxVTnlmRE0wODlWUmRFN04vWkpndE8xVEdMM0ZVVGlN?=
 =?utf-8?B?SWk0eVdpK3RRN3pncUszcmZpeW0xOEN3TnU5aXRyZW9HbFFkVjV2WUloMVJo?=
 =?utf-8?B?YlZYQW04U1FZUmlySzNFYUdPeFZMaDA2QnBCQUpxWSsyNEFaZGl3OHU2eWF0?=
 =?utf-8?B?cC9pZW0vTnJOWGgwNkZHeEQ0OFcvcTFFMUwxWnk4cS90ZEl4RXZPVGw4Y3NK?=
 =?utf-8?B?R0FzS0R3dGw1bUhGSk1VK3hhRjdGRXRGT0xFK2tkYnpKRkRjb3VLRVRtcFZk?=
 =?utf-8?B?QXM2WkZvMy9udGUvQnlXRlBMcnlUOVhGQm1IM0doanJVUXlib08rWENuV0tu?=
 =?utf-8?B?dEZOdWQya3JzdmZyaEo2ZnFBMzZrSE42K2I4RjlZWjl0bmxFN0dLVm9ZQXl6?=
 =?utf-8?B?enJaaW9VL29GK1lITDhTOEFKcy9pUmQ1YWZBNWxHUTllR0oxd1VqWWdncGhv?=
 =?utf-8?B?MzAzc1d3dUxPQ1pQVHZkTXovWFI3emd1SDNTWTJ2TUI1ejZ0UkF0RUZXaUEy?=
 =?utf-8?B?VHpyRThhRElsTXQyUmV3Y0hqM2lNcGduMjEyV1B2WXRhMTd1aTEvUWRIZHBt?=
 =?utf-8?Q?GP+37CZ3mCzpeJX9OvPPvOYu3iWkpxIwHJfZnEjiNSjJ?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd694d4-50b0-4a6d-1172-08dc4d8893c6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 11:33:37.1542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cyq1oISPCGnCLol8GebSxnU6fKXugwF+Q0exMksBwum8dJoffvDQfhh462Xt75kXlwzNjB5v4iSmP27lwuSMTpY8ftN9F1ZqR3RdYzF3gbWdFaUKGxKWuliu8Du0Swte
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR01MB7702


Hi Marc,

On 05-03-2024 08:33 pm, Marc Zyngier wrote:
> On Tue, 05 Mar 2024 13:29:08 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> What are the core issues (please forgive me if you mentioned already)?
>> certainly we will prioritise them than this.
> 
> AT is a big one. Maintenance interrupts are more or less broken. I'm
> slowly plugging PAuth, but there's no testing whatsoever (running
> Linux doesn't count). Lack of SVE support is also definitely a
> blocker.
> 

I am debugging an issue where EDK2(ArmVirtPkg) boot hangs when tried to 
boot from L1 using QEMU.

The hang is due to failure of AT instruction and resulting in immediate 
return to Guest(L2) and the loop continues...

AT instruction is executed in function of 
__get_fault_info(__translate_far_to_hpfar) in L1 when data abort is 
forwarded. Then AT instruction is trapped and executed/emulated in L0 in 
function "__kvm_at_s1e01" is failing and resulting in the return to guest.

Is this also the manifestation of the issue of AT that you are referring to?

Thanks,
Ganapat

