Return-Path: <kvm+bounces-58570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08EB2B96CE6
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B411F445E6D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0195A322C63;
	Tue, 23 Sep 2025 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oHNLw0XX"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011039.outbound.protection.outlook.com [52.101.62.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B0B31E0E4;
	Tue, 23 Sep 2025 16:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758644609; cv=fail; b=sustKQBADHrE1P27cFi7A319vKM1QHDn0LLoFov/LIbPqAr9RFPHeG3X36NDEQULspvWDOUHPCu7ZcEqYwaSlyGn1j/HJijGh8+tb+NTELX5xqUlxEMvMTJPT3EgjzgN5OZwoeDguGFstDDJW7NjmJjUFhV6WtuYcC9HyhOGoIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758644609; c=relaxed/simple;
	bh=mgHWzlLO4GC9ikPUILcvdeggyyDRFheLUSbgbtiwgvs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MsVW6WTtYqRwS0ZAsmvIwWdqOVGuFkqvZIUE3I6o1GATLBV2ABIrrouUxbjxF40dxrxk76CbSHBrGdKZufKsRezlZYzSS401jSd8utPQll1jw7e2/MzoiHiSCDmBLeUOWw6RXRx8ubwPLZuTDpsMQimpdlH0ThuwgTYtetLel8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oHNLw0XX; arc=fail smtp.client-ip=52.101.62.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JbZn3cIUwfTxYoesI5Z7vpsftvchvBOp/ZpFT/WDspMxpECdbR7Bs4DwgwRsaKY4Mf0VCdeJEwaHsUdc4vc3kK5BRQTVrbcU0OJxuPS+Vdxb1NwDhlTDvV0Jdbcbw45xwpEtyuwR/iBWSINt1B7bf3++0uYOHy4IImPwPShGrgjbB1wdQkwpwJPGUlKoTliumQ3L+P/Xad/HK857zSB7cEL4wVzIhjNe5MyJvkfTB7WLA/t/MfuZmIyJmtnWs35KD9PXQ2weOaTKKIeaJhX0ay+ftjkAxkd6LLUdExuPbWI/5mhjdtVv7o0T5vm8MlfdRww/QvK21P1PLtRJ8Suc1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wS4xyR/CW4jUdCGImw0LSyeuj34zAXS2OfCwnstA9Pg=;
 b=otsoVQtqfnrxQ+nONh6MCbyZaz1Z3iaMMJ5zzxSELgtkNgrKwG2pHMdWkJo5o0lIA8Ka6crAe9VdN1KSf5XbTLEfUzOtVUx9Hgw1Myroyhobrgs2a9v+zuQB0KjPSZN6vSbsSLHgiwAlOe5up/1nsDtIb5QtjGe5pNBs/aDtuzq/xKTYhJ+3cVAEPoHbZSCiDTtVcUGG/pm5MW4dFIb4KhW+e1SD6INj9/p9NaHfQAbta29M7AxFUraLp7uzwTmyRFftlUuXmrh//2KIbQyVcfZWzuHSMY1GmTZnApDx5dcnr3OFDe3Ad0jce3MW7r+RKzQDpLWbzFhxPsO4axc6gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wS4xyR/CW4jUdCGImw0LSyeuj34zAXS2OfCwnstA9Pg=;
 b=oHNLw0XXoyyRJVCVr2chYnAQFzpgnBGY+Pz27rTBfKqR12NER/4UnoCyu1/LNkKfPjOS9CNRAHwBgl5FGD7Ah/2uQOie3M7te2gdFQFyXRFv2Rw0JMT+b0/nDcfTFf4rN9CnQIW9wzhAor0w8kgn/r+9r5y1uqw3xxMAZPtnCRU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ0PR12MB6757.namprd12.prod.outlook.com (2603:10b6:a03:449::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Tue, 23 Sep
 2025 16:23:24 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 16:23:24 +0000
Message-ID: <ee52786a-b6fc-2258-3816-25140cfb0dcb@amd.com>
Date: Tue, 23 Sep 2025 11:23:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 14/17] KVM: x86/ioapic: Disable RTC EOI tracking
 for protected APIC guests
Content-Language: en-US
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, huibo.wang@amd.com, naveen.rao@amd.com,
 tiala@microsoft.com
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
 <20250923050317.205482-15-Neeraj.Upadhyay@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250923050317.205482-15-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0161.namprd02.prod.outlook.com
 (2603:10b6:5:332::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ0PR12MB6757:EE_
X-MS-Office365-Filtering-Correlation-Id: 1816448e-85b8-45cb-ba99-08ddfabd84cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MU52S1Rsa0plR2JSdTBvVUZIbC9ZYWZoQUZqOE04WTFuN3VTb1RmbWJQUGta?=
 =?utf-8?B?VHg1eXNxcFdBN1M1azd3bXNIMjRGdEFtTVZGYUs3ak9xVjNjdnB5eEdDcUlw?=
 =?utf-8?B?MEFpc0hGRmQ0aURjVGFIc20vZ3AxRk95UENKVmt5Y0tGa0NLY0lCSThOOUZk?=
 =?utf-8?B?RGVFdTNrcVM0SitMTVFESndZMGpYZFJ1VFlkSC9HT1NUbUsxbDBsS3FTdXMr?=
 =?utf-8?B?b1RSRVhWY3YxMVFRbkxMRHZlMmpKRlU1UTdSRzN5ZDBvamx0Y2I0aUxIVVYy?=
 =?utf-8?B?R0JyeDRkMEY5dG5LU3V6RnlwVHc3R093NjZsYWowSWc3WlkxWlQ2WEVxUXlG?=
 =?utf-8?B?RlNCbEs3UnRPVW0rY0NQWkRwRHlRNEEzaDNsYlhVYnNnbVhhb2NRckxVSjlX?=
 =?utf-8?B?SDhBWXRrU2RvQW50MzdtcEJVbitNSjVDaDVVMk8wSjVMS3RzWXJWckUxQnJT?=
 =?utf-8?B?ZzdsekZGSGRqVjk5bVQweUwzSVIzWTFWQVE0TjdWWFJ6MEFzNWdjeXUxL1Va?=
 =?utf-8?B?Q0hleXVERTdTYjB2UGphWTdnSTA4Y3puSWEzajdobDhEU1JGeE9HbERYS1BJ?=
 =?utf-8?B?V2hvQ2gxaE90TC81K1JvYTdpNmNLQU1LYktrTnpjcFdaZTZoKzlNQmVxd0JB?=
 =?utf-8?B?VFlIY2xFd1ZlamdaSEthZ0tvM1ZVOVJ2RGNPTlE3TjF2RzJ2VjFCSjNxbkYv?=
 =?utf-8?B?ekZRRXpIczlpU3AvTSs3YTBtMk9mdDBWeGRrQ0ZOUmM4NTVNeTJYbWdoNEN2?=
 =?utf-8?B?MUZObWpVczVzQmc3NkZVZkNFMEZHd3NlbTFzRks4Q2w3TWEveXNuUkxrRmNH?=
 =?utf-8?B?ekhBRlBXSVFOd0tESi9YazVZT1hvMWxOV1FtV2pTb0JCK2dQRWhCTmxzVmpZ?=
 =?utf-8?B?SEIxWWpoK2tKOEhyMEtyTHNmQzRWVGY1YWVXWlVWQ3QzeEVrMFdQSWltbGpI?=
 =?utf-8?B?cHNmTGJDSWJmUEdBcEpBTjFCTmkvMmIySkM4QTBBTlI1TTAzalRLUmZYNENh?=
 =?utf-8?B?YVlXWkhzemV4UTdIWFlycGhDTFNTM2tFMW9WalpZdGtVMEgyZ0tUWHFvZ1px?=
 =?utf-8?B?ZHJ0bFpQbThYTDJzTE84R3NibnBsSklIUUpJQTJLRHV3UkVFVmVKQ1F2OGs3?=
 =?utf-8?B?SU5aZktHSnZyb2o2UGNJaXFZMU83eHBIMkd2TjlUbTlQTGY3S0Nmckk2K29I?=
 =?utf-8?B?N3NlUnZHREoxQjU5NWFwMWZqVWZvUUV6TlhwdzFZSGhHQ1FIKzVvMHkyblFr?=
 =?utf-8?B?L2I3MGd1aW1rWG91YzdlOVhnYU1VeEQ4c1I5QjBmUExldndyczRjMnZDcVFz?=
 =?utf-8?B?TmRrL05rb3dTTlc1OWR4R2ptbHFrNXAvNzh5eTBWVGR1ZHZWRFpKcUlOYUpo?=
 =?utf-8?B?ckEzMmdmUzhvNjhPVE9MUjBrMUdrUGZ6Vzdtc3F4cDJaWkw4ckF1WXV4Q3Yz?=
 =?utf-8?B?VjhjcFgwcHNMVEJlaW1EaWh4cHZrSnkyakp4L2ZJbUJBY002OHNSRXVlZUFG?=
 =?utf-8?B?bjZZdUhwVEJuT2tVVEw5bTFXa1RMb1BHZzl4bDRFeWNxSmx5MjhocVIwUS9V?=
 =?utf-8?B?U3cyUUJhSGlobHFrNk5pWHM5NDhCalltYTlzTHozQk1CbW5xN29RK2VsRWpV?=
 =?utf-8?B?UnZNc2tDVFhuamxoUlNGZHZaM2JsQkloRlQvWmpKYndPZnp2L3NPOG5hY2pw?=
 =?utf-8?B?em8xMlUwODdVZ3hWYVFBVjlEbHhta0xibE9BY1FwaE1RV1NLc05HbzM1SmVJ?=
 =?utf-8?B?eG8rR050UW90dllac2IwbEdCekdGanVDbmlSQU1qR3k3SEFuOHQ2a2UvR0pn?=
 =?utf-8?B?clVYNTFMRmM2czN4SlVFdEg2UFZNUDl2ZkdOTFg4cHZPNGJaenRrN1FWcG5n?=
 =?utf-8?B?MHVoRy9SQ0VKcHNZcjFlTVZWSWhkZ0NvczNxODZTZHJ3dTJwV1h3UHpuaGJ2?=
 =?utf-8?Q?qBXKAjvPrLk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXdXb0h5TW96d0s5TkRLTmNPVFlDbVU3c0F3T2pxakJRSUtRcTFpeG1COEZ5?=
 =?utf-8?B?SXRKM1ljMkZJMWNBMEd2TDJldCtiQ1plaUNPK1lCMUkxYlFETlhCdGdBSlFt?=
 =?utf-8?B?SnRSOXAwYjFTdE52QlQwd3h2TmJGQmt2L0U1Zk5VWUZDVm1kbHl2WExPb0N0?=
 =?utf-8?B?Um1ZY2t4VUNPVUtSOE4xK3l3NGhqb05kZW0zTkR1ZHdqMGF4eGNaUkMxR0xy?=
 =?utf-8?B?V1cydVpCaW5rUGpENlJ4TjM5cktjNlpLWWlmNXdWT2Y1Qk8xU3hxa2tXY3B6?=
 =?utf-8?B?NGZrd2YyVDR6QkREVnNWcGIwRXFGY1Y5eDRDbExQV3FyN3lwSHZ6YUZobWlj?=
 =?utf-8?B?SmN0L0MrSWNrOVh4ZkRlSzFMVDF5T0J0U2FQTXRXRHFPNTIzTzdHUmVxZFZY?=
 =?utf-8?B?YktjWjJCaEVycmJDZklROWVCK2ZJUUJBNFBVdktCRnkwVlR4aTZ1aGJkUXB5?=
 =?utf-8?B?WWd5YnRBR0RzNlBkRE9JV0FFQ3JMYm5SSDRrYXU1MlFmOFhrNHVVcEJQUHBr?=
 =?utf-8?B?RGJINTc1VWowVXR4WDhjRHpYVmw0TU1YQ3o1U0VIdUVIRXlJeEJmK2dlMGhR?=
 =?utf-8?B?TStabUFrNjF2b1V1Tk9zem1zZWJydjAyK3p4N3ArVVRIcUR4cHMvUCs0d0Fh?=
 =?utf-8?B?Qks1czFxZ2xxQXF3VVJYVXNNYStVenVSTjgxVDEvU0F1U3VCcFdPem9OejlL?=
 =?utf-8?B?NW1raUdqdjVidFdPUDRGMFR5NUc2QmFQa3NNeVYwc2t2SFd4a0oxTW50clYz?=
 =?utf-8?B?UzJ0dmFFNCsvWDV3VXJUQVdWMTF2aml2MEMwVWxrdG1xS2JhbFhveDVSaDZT?=
 =?utf-8?B?MFE2eVhVL3FNc3A5N0RaRnk5QWZrdW9GYXNwSTBHUnh1czhZRTVRbGxUblVD?=
 =?utf-8?B?MWNlc09xVFVyd0QzWTQvd2dyc2V5aWdackZzY1pxaDRxL29tWlo5ajA0eFlv?=
 =?utf-8?B?aTBxRFR4WkZMT0JQcWdzdTFCcmh3bm5oZ1pFclNMeEZGWXJVQWRrMHlTdG02?=
 =?utf-8?B?UVJXSDBycE42TUVTb1NlZ3FMREZvMkxUMTlVSjcwOTJzbGVkS1VtdHJmQ0ZW?=
 =?utf-8?B?YUI4SnpremJZTVJ3VzFabWtadHNCbStDZ2s1dHN6U0VWdXU1SjZhRFNVVUR6?=
 =?utf-8?B?ZVdlWHBTSkV3NWgxTlRFQkJ1aE5JT2llVWR6QU9rZkdDcVkvRnhaZG1vU242?=
 =?utf-8?B?eGsveWVYbDdoNExZK3B0VWZuVkdpZjRRY3N0RDJtbzBISkd0MGlhQmVVV1li?=
 =?utf-8?B?VGVacVJna1NDVXpDZmFNUHJicmNVQU0zYUJsUks3cE9PV2VRMVNkdHB6dnBF?=
 =?utf-8?B?dVFibmtmSktZcmZteE8vdTZKeFRGcExveUlHU09EUVA4U2sySmZKdFdMR3pH?=
 =?utf-8?B?MGdaK252WVM4VGZIUjhhZkN3czluZ3B6MU5vb0hCaS9FTXBxRUFzMXBpOXRB?=
 =?utf-8?B?K3hIVU1ZeHB6U1g5d3ZkZWVOcjF1Q2FFSC8yRzNRUnZ4bDFpTjMybDFwbkh3?=
 =?utf-8?B?RGxIRGFGM2oxV0h2WjJjZVV4dXpMTFJBOEVZZDR4SHBwRGtSdVZMckRlSTFS?=
 =?utf-8?B?dGxoOVhuWUV5RXd5U2FVbXlMKzhYdmFJSUgwbVlKRmpkMFJYcGVCVk5MbHM4?=
 =?utf-8?B?d2NieDRqWGxGUllmb29KbjJSUExGT3EycVJhbVBaNjgzZGhHWi9RNVJ6ZE5P?=
 =?utf-8?B?Z2RKUGR2ZkcxWFM5WWlQMWdtZzl1NENtL0loc3RPNFp1ZFQ2SUpxYnQ3dVFu?=
 =?utf-8?B?QWQ1TmRkYmI4ZlUvSlJuVVlDSUdvWHpvYW9SM0hDZG5YcUNqeC9WdEpJM21H?=
 =?utf-8?B?L3F0QkFrTWRYNk9vWk91RUFsOFpWUTNaUi9NTllER1l1UlVtSzQ5b0kwMzNk?=
 =?utf-8?B?Mk1jUlhYc2pmZFBXU0gvZmpjU2JFNk1HVTFnaVJPSFdCdHI3K2FGYUJUSjUz?=
 =?utf-8?B?MEQyZlNpVEk4SUV0TlVMMFBKbmk4YmhMVU5rdEVmcTJJamlBTXg2Syt6RjJs?=
 =?utf-8?B?N29NRjlWUWNtcE9MQ3ErZ1ZVZkc1Z25ncVdpVGVHSTJsYU5BQytMeHpJbzlh?=
 =?utf-8?B?bStSTDFEY01BOG1RUSt4QUhvY3ZlR1ZZWENiRjg1bmp4QU5XRWVEdVpnMGlK?=
 =?utf-8?Q?1zDzWM8Oa90CtLOzNB0jBBQ88?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1816448e-85b8-45cb-ba99-08ddfabd84cf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 16:23:24.1932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GzZSXLUWQbLXVJIhFSq+PJuVYUodakoBLOYc2ZDpxE6iwnqb0LBhwXOkTj0zEu7LCVB+UUGxG44oxDbAHgT2fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6757

On 9/23/25 00:03, Neeraj Upadhyay wrote:
> KVM tracks End-of-Interrupts (EOIs) for the legacy RTC interrupt (GSI 8)
> to detect and report coalesced interrupts to userspace. This mechanism
> fundamentally relies on KVM having visibility into the guest's interrupt
> acknowledgment state.
> 
> This assumption is invalid for guests with a protected APIC (e.g., Secure
> AVIC) for two main reasons:
> 
> a. The guest's true In-Service Register (ISR) is not visible to KVM,
>    making it impossible to know if the previous interrupt is still active.
>    So, lazy pending EOI checks cannot be done.
> 
> b. The RTC interrupt is edge-triggered, and its EOI is accelerated by the
>    hardware without a VM-Exit. KVM never sees the EOI event.
> 
> Since KVM can observe neither the interrupt's service status nor its EOI,
> the tracking logic is invalid. So, disable this feature for all protected
> APIC guests. This change means that userspace will no longer be able to
> detect coalesced RTC interrupts for these specific guest types.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/kvm/ioapic.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 2b5d389bca5f..308778ba4f58 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -113,6 +113,9 @@ static void __rtc_irq_eoi_tracking_restore_one(struct kvm_vcpu *vcpu)
>  	struct dest_map *dest_map = &ioapic->rtc_status.dest_map;
>  	union kvm_ioapic_redirect_entry *e;
>  
> +	if (vcpu->arch.apic->guest_apic_protected)
> +		return;

A comment above this code would be good.

> +
>  	e = &ioapic->redirtbl[RTC_GSI];
>  	if (!kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
>  				 e->fields.dest_id,
> @@ -476,6 +479,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
>  {
>  	union kvm_ioapic_redirect_entry *entry = &ioapic->redirtbl[irq];
>  	struct kvm_lapic_irq irqe;
> +	struct kvm_vcpu *vcpu;
>  	int ret;
>  
>  	if (entry->fields.mask ||
> @@ -505,7 +509,9 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
>  		BUG_ON(ioapic->rtc_status.pending_eoi != 0);
>  		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe,
>  					       &ioapic->rtc_status.dest_map);
> -		ioapic->rtc_status.pending_eoi = (ret < 0 ? 0 : ret);
> +		vcpu = kvm_get_vcpu(ioapic->kvm, 0);
> +		if (!vcpu->arch.apic->guest_apic_protected)
> +			ioapic->rtc_status.pending_eoi = (ret < 0 ? 0 : ret);

And a comment about this, too.

Thanks,
Tom

>  	} else
>  		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe, NULL);
>  

