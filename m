Return-Path: <kvm+bounces-39077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A747A432F7
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 03:22:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3062189E3A7
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 02:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1E113A41F;
	Tue, 25 Feb 2025 02:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TLE9TPvf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDB6364D6;
	Tue, 25 Feb 2025 02:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740450130; cv=fail; b=EUJV+IvzlAO+olIVRk2qi/fb4hck8fU0AfS7U9mgAKuV3SaXSWvr9bFUqh/8327JNTNRqxx2LltKsvMLdruwkjIrDm6T6F0g5C8bPOGafzZjLbL1HF+8fkt4f7+wFne2agZrzwxXKFYBpM2jhasUMRX5DbTyMamE+DFL8Sm9/BI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740450130; c=relaxed/simple;
	bh=5PspK1Aah5Z8ucOzWOHPUF8atiib9rsCl6SwZzqvrNM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YNsJy8fq1+0O3FK1owhkR2roEl9bcekTOiUL4MDQ6q+RUiPPHJGqXo/AX+H2Sc69/+YK6TUqJEOaVYjZCCerYmui3d/lQ0WGPiqrGCdsadol8/99Cor3dNUQbjPZ1+S+JKZxMGRt6uIMjft4ITMvwPHDj4u2p1H9SdEDoPhAMSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TLE9TPvf; arc=fail smtp.client-ip=40.107.220.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dgXfjDtma8x2XP+efC7qpNUY+xcWULl1AY3Jl0XpX32vJqiOY/Jgv1umig1lh6DqE+Ey9f/+APLhWEKctEAT1Zy5JZW/a9tiGpfWvG7KlR+z9jNfd7FxUKnXgXk2daxk72tRJsToMooVj21I2n/EyzOyLSfe39cTql0hqCTzw7V90XiK6iW3khXNK24Wlkhb5mraBWYetcHD4OHXe4gFF2joT9y4bd0rE2pniK15ufd33MJl9wPBshubpGGpkHuP93joeiIY6I8pFuhidzDjgUoY2cnJJVuaCYjRsl2aDsDDt9ZErh9/shSozi5WDUmqrTMhvWOEkdCG96norKqghg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9QzDak3VXKhgN2fCRYUaYpG6tfliXNbuCYENyhzKv4=;
 b=J2fn0oGJ8psadeoDo0LOpdZyTQaaJM9EuU4zfepw1eRdoxiK3l041MDhaOFYRKNXc4OEI1UEJOcJ34xaydC7anD/Y+NtgFvFavxjWY6chZ8fzl+FYm/+/EyFRKRnA3KMy02mMsoWXkN751tPVnoYM/TZbajOlHba2n/wsGV/4BYOvjSzpZha7WD0Nk3xIQwIpTrZMsMbLKwvb8s7CAmrEtHcgTvJfFEW29S7Cw9Q7Uqyx3LfEEyMFBrDO0cME4hfDLFKvTMSiY0y4bPZ+dygUKKowcFcs/I0mII6bIjRZpYPAInLNC5J7P+UVrFbpLkia2JHM+NP1U51tN81dH9d0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9QzDak3VXKhgN2fCRYUaYpG6tfliXNbuCYENyhzKv4=;
 b=TLE9TPvfyHFDeHoMdefwmA8lT6+N64ibMzBLwnS8nyMG8G1zXPq2qQ5JrQ6+Ao7aV8QFUPT5KUZtHQXpEJtHP1xlygMGL8YV90Xxkn/QmdbST5RHuc7OBfa0WbC2OCMgvrZHKtuH+OUmYVWlGW85vo/RU+7Gz9rLjnHU0mGIUFw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 DM3PR12MB9436.namprd12.prod.outlook.com (2603:10b6:8:1af::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.20; Tue, 25 Feb 2025 02:22:03 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 02:22:03 +0000
Message-ID: <e827f9cf-c7bf-43b1-96b4-2b7a7ca550af@amd.com>
Date: Mon, 24 Feb 2025 20:21:55 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] KVM: SVM: Attempt to cleanup SEV_FEATURES
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <a9d70abe-d229-81cb-4d9a-6106cef612a4@amd.com>
 <81949e94-9b7f-0b04-d673-cbc16fc646a5@amd.com>
Content-Language: en-US
From: Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <81949e94-9b7f-0b04-d673-cbc16fc646a5@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0054.namprd04.prod.outlook.com
 (2603:10b6:806:120::29) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|DM3PR12MB9436:EE_
X-MS-Office365-Filtering-Correlation-Id: 499a762c-7f4a-407a-5859-08dd554330e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WnVydnV3Szh0cmJxWGpMSFVxanFrVUFsZHNWMlpTTUV4L3pzQ2tob25rRHhV?=
 =?utf-8?B?OWUzNmhWMVlIYUdQVXN6cVZ0RGEvcTFlQWZaU1k0WE9STFQwbFRQNHd3ZXdv?=
 =?utf-8?B?SlVtRXl4OURlU2RIdnkxTjdWUHZYdmdCY3BlTHRXZEIyZTZnY0hUMVlONFpW?=
 =?utf-8?B?ZVVKTk8yM05jOFVYQ2Q0QUJYV3RJbTlHUFRlZ1g1dE9ITjlNZjFQS21qWFRT?=
 =?utf-8?B?YkQ4bjFwVjkrQ3lwR1l2RUpsODNYekRpNDJYL1VjSm9sYTdPbnlBTG0rcG5H?=
 =?utf-8?B?T2JyM3NWeUN1UXNzdmloa0NJVG5NS214TFk3aURjUm5hemZYa2JNbVFXb040?=
 =?utf-8?B?TWVWZ1FKUG9paExIdTZ0TDkzeGdkWitkU3VudGpVNUFKR0NHMXJTYzRhelpH?=
 =?utf-8?B?K1ZVMGdKWTd1SWdVOURobTN5cldYNmlCVWF3K1NtVFUxUks5ckpVN0Z1VkND?=
 =?utf-8?B?eXMyQ3oweWErOW9SaEM2UXJnZTNhcW1HYUlLelBYbXE2aEIyeFBBSHlUWG1O?=
 =?utf-8?B?cnpLVG5pMHkvSUVSbkViSHJEemJZaU5xY202NkdLYXFKTnd2T0Zqc2FBdzJr?=
 =?utf-8?B?cTNISU05ek1aZERYcFE3WCtIL2x4UkpIVzc2akJ1ZmJqRE9vMU5hcDBJUmlt?=
 =?utf-8?B?R1BBbXRoUVl0emlyS2tOd3pVNUh3VDR1R3kyQkd0MU5PMDNzUDFSZ2VpQ2tu?=
 =?utf-8?B?N1BLWnVwVVA2dnJrb0xWL2NXNExFdEM4eFRzdkhLalRHYkZwTGgwQVltQXNY?=
 =?utf-8?B?UFhTU3RkTFJmZHRlaVpNVFlvakw1OVJNN0E5NmExaVBFQmkrUEY2SVByZFNC?=
 =?utf-8?B?YzBidWtPNTFoRjNDT0d6WCtDS3NBakhxTm1EV0dtRzJCZ3ZZaW5UOGcyTllC?=
 =?utf-8?B?WVBVZUc3MFNkQVRyR2FIUk5tS2dVOVZKc2MxeXFSL2VtZDB1L0kzVTc5RG9N?=
 =?utf-8?B?V09PVDhEK3FyMlpBZUxodEMyYXFkNGFEYmhhbU1zSi9JZytzSndMOUNoSHpj?=
 =?utf-8?B?MUNkRlNTZ00rTzBESGFZdTNBVm9UZU9VTFN3a3lOZUlTTUppSFdwaTBTb2NR?=
 =?utf-8?B?NEVIVVdQZmh5OS9lKzJvbXhvSCtlZHBoOGVrZUZ0eGUrRmZTWGgxN2xaekNT?=
 =?utf-8?B?eWM0eE4wTXlIbll5VFNocmdtRHJ6Q2cyUjU5dGZLcXMzbHhlc0xEdTRBOCt1?=
 =?utf-8?B?VEQ5akl3a0Fnc0NNWitYNFozTWxnUDhZUnFLeklUMDZiL2VueDBwMkNqWEF1?=
 =?utf-8?B?Q1hPTkRWMjR1UHYrUGcvNnpRQWJxa0VOZ2twdkR2aG1LQW5jM01IWFJudnRJ?=
 =?utf-8?B?SUVMcm4rVDBpeTBWaENKck9PaVlTMGoyQ1o5QnBxcnIvVWx6REM4c2NVQjVs?=
 =?utf-8?B?RmJ2Z3dyaUlUeUh5dVo2RElCR2NzSFNhMTJiMDBJMXVyeTNvN2loZFdySHR3?=
 =?utf-8?B?YUdLNVpuSTJNaGF0NVVIRHNqUEhSbjFVd0hLUFJZYndmU0pEbC9rSGZKNVNk?=
 =?utf-8?B?bkhjbVpiaHFYSlplK3Z1NGpFckEwdktEbnE0VzhTYXYyMURYWTVFSEN3OUl6?=
 =?utf-8?B?NTNKK2grc3NjZmsrbStjSUdaWitpV0d2WGlPS296NkdmcFhXRDZ0dWJCR2d6?=
 =?utf-8?B?bE1ldVdmaWpvdFZuakpERTk3bFdkU2MvRVRWWTJBRGFEaGZ6N1o5VGVrZU91?=
 =?utf-8?B?UFBNZ2dHT1NNaDJ6RzIrR0NQREcraWZ0TXBYODVBQnlWUmNQY1NMNWNyZlND?=
 =?utf-8?B?bkRwSXA4K2c5OTZWOUVuVUs4QWVzMGIra0dNRXY1Z2xJNUw3NWhxSk9IbjVM?=
 =?utf-8?B?cE1TVHpjR2tadEN0ME1IanNiZ3E3UTI5b3FteUFhUFJqdGs4ZDBnTldOZU1I?=
 =?utf-8?Q?zByEkioTM+Y9F?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MzZUSmFaMU1HNnc5VUJOeVFZU0NrSW5QaGNRSEpwV0dXdW1XOFRZcG0xODBX?=
 =?utf-8?B?SlVwcnN6SHVxUCtaQlVwb3ExdTVjSmtzVEkrM0hOTWNrY0toa1FNNU9XdEh0?=
 =?utf-8?B?NlNwVTlSaDRRUnZRSHg3ejY2bWY1c29oMEEzRkxIMWpRK0xwK3VPQ2d3U3E2?=
 =?utf-8?B?Ui8yQldya1UzMktnUk54VzBnVXdwbGdxUVAvbEIwY1FJTGNuVzRlVm1RWldk?=
 =?utf-8?B?M3N0TjV5eFhXTW9zcWtoNkJUbHA1MHZwWTd3SXkrQ3ZSc0ZRdTkvS0crcTRh?=
 =?utf-8?B?YTU4c3pBSkFWeGlMaE1VUmxsdmtPMHJkcEI4eHRrNVlhaEliODZMWUFobTFr?=
 =?utf-8?B?cXoyZ3IxZVR6bE84OGxITkd5bER5TGRzdE1pRS9kSk5qelJ2NGo3STR3anpq?=
 =?utf-8?B?RStBQUY3VVdpU3pYbHFFNnZwa2lHZ0tSSEpXdU5tQ0pITFV6WlBsemw2VWRY?=
 =?utf-8?B?NGtrdXFOejFWYXlHYWhubCtuVjVJcmxuTWkwUUU1QmtDZU1kSm4vQTBLWG5u?=
 =?utf-8?B?cHN4TUd6R1o3alBCUko5OFdCUU4rN2xvQkRYcTA3QmhncmtxdG1XUHdiUFZM?=
 =?utf-8?B?MlBaSTB0RmVDZDFmdDRia1dpWVdoM09WK1pWcWt5YndEanFGaTRxTHl6ZUM3?=
 =?utf-8?B?SVdhS0RReEI5bWRHanBwOGdwWHJqTmtCU0pGaXExc2pBMjVBdTYrRXU2alNr?=
 =?utf-8?B?U1VjbytCbCtZMThuZDNNODZaM1F1K2xqMDN4emc1eHhNTXZ6NWtYa2lHZW1D?=
 =?utf-8?B?YnRsM3BIeVVYVnoxK1VLNDFCNy9zU2lGSXBNZURoMVlKZjFVMXl1eTB4V3kw?=
 =?utf-8?B?ZW1ubFV2NVZCSEJSQ2NJS3ltZzVRcHRQSStyOUhodm83TEFHN0ZUMVNuVGJL?=
 =?utf-8?B?TUU2TlJqMEFPREV1a0I4VmJCczJ6TjBCK081VHJVR1llOFY0cFpvc251ZFVy?=
 =?utf-8?B?d3JPRVhhM0hPN3hUVGtNeUtUVy90bVhlRUloMHkzRSswSlB6b2FaZUJ6em9W?=
 =?utf-8?B?NGpRejU1SzROT2NzQTlLQmxyOWNPMDBBUjBqZlRwZWhMOUc5QTVoelVleHRh?=
 =?utf-8?B?OEwvdWJJMVlicFNaTUl5RHRTK0s1NXliZE9PQjBSejVmZEl2UlM5S1NNTStF?=
 =?utf-8?B?bVhpWC9ISnQxUkhHVHIwUlhhSHBSYVBLRFh2TXNCOE1XWG8xVloxM2UxSXZj?=
 =?utf-8?B?RkcvYm9qNGVtbWF5enNRb3FkVW9aOGhDeHpHV3YremE2TUlGa0FZZlE5Q29z?=
 =?utf-8?B?VDcwampET05DdmxWL3pRRmswMEJBalBLTzVGT2xyc2gyUlRJZXI4bzNqY2FF?=
 =?utf-8?B?NmJnZUwvRUZIdk9FMlRuNkxtMkROUkk2R3BkcW9SbVBmY2YxR2tQcFg1MkFP?=
 =?utf-8?B?eGg1cXRUV1JaWjIxVHRVaHh1NW02SU5TYkNnR0txTnVDczFITTU0Q1JETFJ4?=
 =?utf-8?B?SDM5WjFUVXhIRmVSSVFDRGNlZmluTXRuTmQ2Vkl0L2pnM3ZkV0VCY2lnSm9C?=
 =?utf-8?B?c2ZYSG5wQVZNR3Z0VWV0aDhRUkY1dXRPNHhaUEVEaHNIZ2Q4U2dIY0E1Y0hO?=
 =?utf-8?B?bVNMZjFaWEdudjhtT3NhbXFXM2RHN3VzUE1rdlE2bTFMNkNmbmZSL1I0cG9W?=
 =?utf-8?B?d0NiZzRwSFdNUkRCckN1RHlERnpvRW9WS09yK2JVNFA0RG83VXdJVDJWQ3RL?=
 =?utf-8?B?MmxCM0JyTHg1SXFnNUhzSzBRSkhMLzhlbjlpVmNVU0NienhuSHJLTXVpaGg1?=
 =?utf-8?B?bFErekQ4RkJkL2JrdG8vR3hiM0h0czdpRmRGV1k2UmFtS01QNllnZ1lGZ1Ez?=
 =?utf-8?B?KzVyS2YxYWhYU3ZhSVVtcHZZRHA5Z0dSMTZ5cHZ2R3Z0TWJYWXFISW0xRTln?=
 =?utf-8?B?S2ZPdko3SFdoZkRZVzlpTnk1amE1ZVY0UnlubVhKR0pTL3piTFNtUURlSnVQ?=
 =?utf-8?B?ZFFzYkkydVpzd3psOUVzVGczd1F1KzNxUFRDcTQybU5JejJsVitXeTZ2dURh?=
 =?utf-8?B?UVI5MzkyR05xTlBRSkNaK2xqMTlVYldpUk1raEVrSGhWQUplak9oQzZRY2hi?=
 =?utf-8?B?YnFlb3Z2SHNLVlNFZFdpakVPOWxnL1dmdUpqUjFGTXJxVmoxc2ZoQlplMmlJ?=
 =?utf-8?Q?6iwRkn/05ZLPmYrXCBoyJSc3b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 499a762c-7f4a-407a-5859-08dd554330e6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 02:22:03.0253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYuV81XtQ55ewPJXq+nPji6/RfuryhasQ6ImCbe3jrAACeG7RSW8/jpUKYseJUAqhugvyYnbRzL8e3IkxUgkcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9436

On 2/24/25 6:02 PM, Tom Lendacky wrote:
> On 2/20/25 16:51, Tom Lendacky wrote:
>> On 2/18/25 19:26, Sean Christopherson wrote:
>>> This is a hastily thrown together series, barely above RFC, to try and
>>> address the worst of the issues that arise with guest controlled SEV
>>> features (thanks AP creation)[1].
>>>
>>> In addition to the initial flaws with DebugSwap, I came across a variety
>>> of issues when trying to figure out how best to handle SEV features in
>>> general.  E.g. AFAICT, KVM doesn't guard against userspace manually making
>>> a vCPU RUNNABLE after it has been DESTROYED (or after a failed CREATE).
>>>
>>> This is essentially compile-tested only, as I don't have easy access to a
>>> system with SNP enabled.  I ran the SEV-ES selftests, but that's not much
>>> in the way of test coverage.
>>>
>>> AMD folks, I would greatly appreciate reviews, testing, and most importantly,
>>> confirmation that all of this actually works the way I think it does.
>>
>> A quick test of a 64 vCPU SNP guest booted successfully, so that's a
>> good start. I'll take a closer look at these patches over the next few days.
> 
> Everything looks good. I'm going to try messing around with the
> DebugSwap feature bit just to try some of those odd cases and make sure
> everything does what it is supposed to. Should have results in a day or two.

My host and guest kernels are based on kvm-x86/next and, following the
instructions under "Tested with:" [1], I don't see gdb stopping on the
watchpoint in the guest gdb session:

...
Reading symbols from a.out...
Hardware watchpoint 1: x
Starting program: /home/ubuntu/a.out
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
[Inferior 1 (process 957) exited normally]

It happens regardless of the kvm_amd debug_swap= setting, and
regardless of whether this cleanup series is applied or not.

Doing a break on main and running interactively makes gdb stop at main(),
as it should.

Am I doing something wrong?  Does anyone know whether
DebugSwap under SEV-ES (not just SNP) was tested?

Thanks,

Kim

[1] https://lore.kernel.org/kvm/20230411125718.2297768-6-aik@amd.com/

