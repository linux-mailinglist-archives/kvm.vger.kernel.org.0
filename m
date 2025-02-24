Return-Path: <kvm+bounces-39057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5447A43058
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 23:57:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8D493B53CD
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 22:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE0320AF85;
	Mon, 24 Feb 2025 22:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PWQ2CkZF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A761FCD07;
	Mon, 24 Feb 2025 22:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740437844; cv=fail; b=ZleBE9MQIhUZPM7HINWCaeHqiaW6kx4UUci27yUCRUl6wKMnSawkBBwWOhH1/BztRomKdpsg1w6syNwE7QsjbLhN70eeJcunmLIWXvVDP9ZlHoQFV99siyO+BGwf04DhYGukYVzvrxQ/chFwDbMu2B2u5xjJ18ZOs9Fj/xWRtNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740437844; c=relaxed/simple;
	bh=Zb642HZpJGLDAqShr8tbeJ+7txvuYOrPQpXRMFuJCiw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DZASq16hNYdEuSwhiqhc5ReRRT5rzI38vav7uqeenDivTTuCl3W0jQY9BOM5+GKu2eILI55JUzlTkld2Bt2MzqGCnPMexuOpD2hZWGUH26kVCw3X/Kdfc+mnXHlKPIVzDgN26Pv/7N6jqQo6LMzYamWejPk0qhbbfSRFJTulJo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PWQ2CkZF; arc=fail smtp.client-ip=40.107.244.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xBfJjnz7qvKzNMMobglnEqiWE61fH5frrD8ISnU4zXbJ/+GlbcTr4kOsw3LhtMVQowtnoQT98xh5GZEiJwIbSLLVGgGC2YEf1MgnL0ATNsDw7lEPy+8Ya81Y4LyRG+8aOku9YsYs7o7mAGVkLWfvSpWx1KoK5GP4A7moAPkPlKTDYAxDTb3L3Z/jUl4B/FOD5l0rcOdGsi6M34MJBfVn0o+tWfLyXuOSb6ucrcL2mfbfWVzF1+WAFzyWAHvGeSIYo4offTBIudlgEg2u4gREg+zLyw05FDARGOAT43xmPKbSp9e8NSl7n1mSFnPVVE4g8arf8LZhEEyXudeV54z38g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLIgAmqf84iged1S1z2k0GUsiSTxicIO2KTIchNLnYc=;
 b=KGguCQv8PBVJEJJ4qBwr8pwgHbRTnipO/QJkEsd1+23xZ/F5EO0Ujsakt42J+hfVtvmb4NK7IdS9/P3aCOWiKssNfzqhuB4546LjztutQ4xXt5MdqZHvXj+p57sxQ7O/CcaDT329em9Z7E0Q7UTY7mHeydmxAA3LwuuUziHAuX0cpYagdAkdqZhi32jg+ROtPuUECyJnDfFumhdhxGiF9BtcgTJ389WfZ2JePrARPbP0lkj3xLxm1gcBZDhtjn7AWhRDXcufRheAex2UkhivNSLXgkfMMBkxLKsgmzN6CqeBZzLaDManUJkOVnCzQgg9rpoMs26a9NIQXqIufqi7GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLIgAmqf84iged1S1z2k0GUsiSTxicIO2KTIchNLnYc=;
 b=PWQ2CkZFEezlCUKe4vS+LGCmUhWwNn/M5wrg0MN9OMZivzXuTo3rAN5NfS6lLSeXaW4TCzS7jJPKBMk23KdaT1VizJhqzmg8TIOUahifWy0XG+YVGPMg2IFz3bMq3s8iSgxE6UrM16QL7+dBdM7cnDeF/4ERDttmLl6ef2Vu4qY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB6133.namprd12.prod.outlook.com (2603:10b6:8:ae::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.20; Mon, 24 Feb 2025 22:57:14 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 22:57:14 +0000
Message-ID: <11daeb05-b33d-01a4-e84d-40148943910f@amd.com>
Date: Mon, 24 Feb 2025 16:57:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 09/10] KVM: SVM: Use guard(mutex) to simplify SNP vCPU
 state updates
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-10-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250219012705.1495231-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0048.namprd16.prod.outlook.com
 (2603:10b6:805:ca::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB6133:EE_
X-MS-Office365-Filtering-Correlation-Id: 1567ad61-235a-4c1b-ad64-08dd55269437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0hBSGk2d2k5UlV5Z2V0dkNEU2RoaVAxZUIrZjhSekZMVlNTbDg5VWZLc2pS?=
 =?utf-8?B?K3NRWkNna2RpcExPUGM0cDBNRFlCY1Vrd0V5ZGw3bWdPUm13V1VQbkloMjlK?=
 =?utf-8?B?WW5vOVBCQzRFdVhSZ3dHYUZDdXZXeWtWT0tyaURFaDY0OHBSNTU3ZGwwN2Zq?=
 =?utf-8?B?RC9oVDlUdUZieTVxbVlqa2ZiT1oxaE4wYThYcDIvQko1bTF0MUNGTjl3QU85?=
 =?utf-8?B?VUo5ZnErLytQcGZtWUF6K3o5cjViaElhVG1Od2ZlNlpvaEhMb1pBTWNwY1Rz?=
 =?utf-8?B?bTFTTVAwQ3hMSmxKL0hJM1ZJOUdGdUV2RDZIR2pSdmcranVDamdNdkFWdTZm?=
 =?utf-8?B?ZUdNNFEvblNqNWZyODJtY202Z2xvdm8zaVNoRFFKU1dPQ1REK3hwMTBFWXJP?=
 =?utf-8?B?NXA3YlM2QnJxNlRJbktvSmFLRjU4RUN4TDJSQlVlaUpmdkNlV2VHWFlTc3d3?=
 =?utf-8?B?OXp6ejZoUlM4UURKWWhuUFdEdXBWak02ckVtTnUyNXdiOWN3ZW5hWisvVmNV?=
 =?utf-8?B?RXVLcjN5dTJlbkQxOFRRMEQ4cWtrOVZGSWdtaWtFL1ZSV1luM3VLOUozOXFU?=
 =?utf-8?B?VUQ2OWRtdUZNUUROQWF5dVhBZ3hNS3ZaTGR3QzFKL1FzaURwNHZLRFlXOUkz?=
 =?utf-8?B?OEFHODZIblRxcEVmTEVFeWh2T2dYMGFLRUl4aXRqWC9kM29oUXdDMllMd0or?=
 =?utf-8?B?TVEzNmxaclBZYXpoRjdud0hETlY2VFlvQWVVQ3ZhT3dJSHIrQnlmYnlVdzFN?=
 =?utf-8?B?alBqbVM0L3VGOE9SZXRBak4xV0llS1pBaUdXL1JwZURWcndYTzNaVTNla2Ev?=
 =?utf-8?B?ZjFyWjVvQXMxM3plMXVUZ3FRSnBwWnJibzk3RVR4MUtrUWlra2VIVkVlRUQx?=
 =?utf-8?B?aXJuc0pVNU0yTm1qRVdTWE9yVmJJTnJrNVpuRW9OZDJ1MWRzM0xUbzVueEtz?=
 =?utf-8?B?c3hrYWg0RWZId0pnNm9LRGlaQW5TdFpuOWpqdjg3R3NOcmdSZk1MQ3JWM2xa?=
 =?utf-8?B?VlEyRGp1NjAvMENJSlpRSXBYRmR6QmF0Y3Q5ZEhnNFpvaHR1ditPY3JKV3Uy?=
 =?utf-8?B?T1RaaWIzUXdUOGsvdDFRNkplY0gzRHBvY1Rzb0pwNURlSE0vQ0tRQTJSNlFm?=
 =?utf-8?B?MDk5SGxlb0ZqSGJ6aTk0aWhBYXlNSlo5b2ZFb2VoZjZwcEVHeFdFTXlsZkxk?=
 =?utf-8?B?dGk5eWU0OEZkdlM1SHFqaWJMR0RsTEZHaGJORzhnRHZjNTQrMysrOVF3VWU2?=
 =?utf-8?B?MnV5aWxjWFptQWNSSnY1VnNNYTZUVzRHc0pUbk5tQ2NpVjl3WWNnTVRpS0xZ?=
 =?utf-8?B?S2E4WHBFcWVnREtEZnJPS2pkNDJhYzhraUluaHBPMnVNWUMrUkxzSkpKZEtw?=
 =?utf-8?B?c2FFbDJwc1ozNFFhTVBGQk93dE5GTjNsWjJaL1QxMVRlbExkYkFZRTNsVkQ2?=
 =?utf-8?B?ZENXVlFWYmFTKzNacjVJbEdldHZWZ2E0ZGhFZEJMQVQ5S08vRU8xbTdxamQr?=
 =?utf-8?B?WWU5dFpwSVZhT0RDTit6QTZOL0Y2NnRISWNUU0pLK1I0TExPakJMMndLSk40?=
 =?utf-8?B?YmJxemlNR1hicURXSy83NG5vVHN0c2RBWjFKNEhNa2hyRnprZ296Tmd4aHZB?=
 =?utf-8?B?a284K3ZUNzRiNFpSbkEzeDI0bC8ybmt6U1oyTVFWM29CdlFSTEdQK3llQWF1?=
 =?utf-8?B?bldPR1V6MldnbWxVYTNnakNzblNFellXWmpSU1daWExaTWN3WkRYbHJ4K0Nu?=
 =?utf-8?B?Y3JGQWZpMTdsblB5V2dqOTRkYmhMRkhGdWhOeWZReXhScGJjOGZzdURvOVM5?=
 =?utf-8?B?QUFDMWJRUGtoeTQzbm1iMzhkTmV3U1JyOUlKOFRtYURXL0x5MHBjdWRjNXRx?=
 =?utf-8?Q?1wz4sSvsry+su?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1hKRmxxVGkzS2htYlhaZE1BeTgvaTBtSXhwYndBWUdZa3A2R0pZbVhYRlQw?=
 =?utf-8?B?THZuVWJTV1Y2R0plUlIwa2hqRG51MlJIc1gvSU56SWxxSmhsQ1dNOFV3TzVT?=
 =?utf-8?B?Zk9jbEhTb3ZYSzlvQ1FvcXZNVWR4b2pOdDBsc01vcU5kU2IyOWl5cWNSWlpn?=
 =?utf-8?B?MXJuSkljeHBuZUVMQm1TVHhUNU1VaFUwbmtGeHg4NWQ0c0FLYlU0N0VweW9N?=
 =?utf-8?B?RlFpUVVFbFZIT3BSdTA5bXlCZkRPRzl3alJOVGszN1laUkxXS2RwWUVSVURB?=
 =?utf-8?B?SHBZYklqaHVDdFkvWk9CWnZmeDc2bEU3ckJwdEswUEdjZDY4U082WmVmNlFl?=
 =?utf-8?B?TkZKcml3V0lwWnNpd0FMbnVCM3NDUGF6aFYwcitQS3psQXNqek4xZHdQS0Zs?=
 =?utf-8?B?Y3hKU2dnUVRaT0kwK2haT2dySDlPQU93SkFvdlJNaUF6Kzg4ek5IYlRkRG5x?=
 =?utf-8?B?YTgwaVVXTnEyZ0JLNnpIbzVIQlExZ2VWS0JNb2xMNnVJNnFBVUo0M3h2UUxQ?=
 =?utf-8?B?U09lenhISHNMSzhhcVV0bDNjTmdRWUZQelo2Q1lqenlROGtXTVBWRlpwRUpV?=
 =?utf-8?B?OEFWSmRGTzlXS3hVZTRCUm8yYnJMZ1dzd3VxTnNTaGQ3b3ZnK1NETGFRT2R3?=
 =?utf-8?B?TDhqMlU5WHdrb2ZSV05JRmlQMlpKNUxleS9neFBjdy9LUnI4NGpOR3cwUE9z?=
 =?utf-8?B?S0lVRGF1N2ZIbExxOUZVc1llQkVOMmk4dzBxaW9jUjZWMlFRZE5DSmMwbDND?=
 =?utf-8?B?VDFYZTFIY1BDZmljRk9uN3prczF2Vi9XOVJRZHRZQnZrSjhNN2FmZmx4dTZM?=
 =?utf-8?B?M3hsY2dVTC8wMTltbkx1eURMYSs4eFpPejFZZ3hqaVhHR0RVdmNuTEVLVDhm?=
 =?utf-8?B?cE9RaGpiaFNwN2NSWi92L3B5ankxTWhSU1F3YnIwc0JKak9wV1QwTkM0TENK?=
 =?utf-8?B?Y2oxaVRUREx4TGpwdkZDWWFaclJPTXFkVXhFS1FZRHJ1Mzc5UElHa0w5NkY0?=
 =?utf-8?B?c09GcEM1RGFxS1ZLSHNJYmp3MDBNbnBPWlI5MlZKNGh1YUVvWXJneW5odC9I?=
 =?utf-8?B?Umxka0c0UkdjN0VwMkZtNVJyME81aThqZndFV0hobi9ETkpwTUMreDJjQW1R?=
 =?utf-8?B?N25tc1c4UTJTOG9CSHdEQmNZVEhuMVQxdHZESFhobXg2SVhadzhKTFNDNzBM?=
 =?utf-8?B?dHpJMll0cmlHeGd3K1dkTE1pdjB5bVhHT1hvbTk0SFB5WWVqUFYxQWhSMXhX?=
 =?utf-8?B?V2ZMTmp5STZVU2lNVlZEUkRqTmN0VXpHendFdVBuRWF4SnhUcFQzQkFiYi9U?=
 =?utf-8?B?S2ROdmxuTm1oRlZ0N0FOajlqSVJlR3dteE55Ly9HMll2VGpac2pVOFlJclhS?=
 =?utf-8?B?RXZmOWRnY0JUT2dpWjZmRXh0VDNiT0dPZ2x6ZC9kdHU4am9NMEZzTE9MRklP?=
 =?utf-8?B?SjFIU1F3bnp4d2Y3a1EvUk9QV09INzBhQWVoaTlrQS9aYUxYZWUrbHZuMThW?=
 =?utf-8?B?UGU2UkNUOGptUVlicVVyQmtWMHdDT1UzLzhHTzY4SHdDZXRTaEFQNTlPUEZK?=
 =?utf-8?B?WXlYK2dWTE1PWlhRVEZCc1dIM2ZOcE1iK1BYZGM3Uzlyenh4bXBqNlhOL2h6?=
 =?utf-8?B?SnR0eXhNSHk3SEF1bkY3eUlVZ3k0RnBNVWovR1hPelJ5azB5VVJkTm5ZV3Fj?=
 =?utf-8?B?TDBWOGNRWjYwOHFOVDV3YVJ3c3VFdkQyOGQzYVdiRG5mdUNaUWd0eGlBZ2R0?=
 =?utf-8?B?eEZWYUZqTjU0WGVQVlYwK3NTRWZoRW9RZXZHdEFweTZVUXl1M3FRWExZNWk1?=
 =?utf-8?B?Zlczakt5Wm4xWFhSdldLcEp2MnQ2dmIzdWVtN1dZTzg1RmF1OGxEMllLQlZh?=
 =?utf-8?B?SmE2U2JiOE5QdTdJYUtHSTFhdSs4MEMzTUtIVWN0eUxKTzJMcjZ1d0FiNjNP?=
 =?utf-8?B?RXN3R0RNN0wwMCtsd0NUZnBTbkVYUmtsWWF2a0p3OFdmZW9LMFVzcWRVMmVi?=
 =?utf-8?B?UitGTHZldTkwOEZYN3JCcFFFakNwSGpXaEtkekU0U0ZUaWllRk1kbjBZQkNl?=
 =?utf-8?B?bGRPVnp0M2txTjQ3YWkweCtkNmdwVGV5clJOVDlOQ1Q2ZzBUTHlGNEMyWFB1?=
 =?utf-8?Q?IUV04O+yoHVmmIlY1CmP7wdFw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1567ad61-235a-4c1b-ad64-08dd55269437
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 22:57:14.2235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WiHl8PDfdT6w/cuzBMI17FA0/mlbOF8zUv10JwwffqQ6DgcEM1999cw0lT36s9M3l6IS841E2AhaQ7ZZ8+EZRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6133

On 2/18/25 19:27, Sean Christopherson wrote:
> Use guard(mutex) in sev_snp_init_protected_guest_state() and pull in its
> lock-protected inner helper.  Without an unlock trampoline (and even with
> one), there is no real need for an inner helper.  Eliminating the helper
> also avoids having to fixup the open coded "lockdep" WARN_ON().
> 
> Opportunistically drop the error message if KVM can't obtain the pfn for
> the new target VMSA.  The error message provides zero information that
> can't be gleaned from the fact that the vCPU is stuck.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++-----------------------
>  1 file changed, 53 insertions(+), 69 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3a531232c3a1..15c324b61b24 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3839,11 +3839,26 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
>  	BUG();
>  }
>  
> -static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
> +/*
> + * Invoked as part of svm_vcpu_reset() processing of an init event.
> + */
> +void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct kvm_memory_slot *slot;
> +	struct page *page;
> +	kvm_pfn_t pfn;
> +	gfn_t gfn;
>  
> -	WARN_ON(!mutex_is_locked(&svm->sev_es.snp_vmsa_mutex));
> +	if (!sev_snp_guest(vcpu->kvm))
> +		return;
> +
> +	guard(mutex)(&svm->sev_es.snp_vmsa_mutex);
> +
> +	if (!svm->sev_es.snp_ap_waiting_for_reset)
> +		return;
> +
> +	svm->sev_es.snp_ap_waiting_for_reset = false;
>  
>  	/* Mark the vCPU as offline and not runnable */
>  	vcpu->arch.pv.pv_unhalted = false;
> @@ -3858,78 +3873,47 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
>  	 */
>  	vmcb_mark_all_dirty(svm->vmcb);
>  
> -	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
> -		gfn_t gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
> -		struct kvm_memory_slot *slot;
> -		struct page *page;
> -		kvm_pfn_t pfn;
> -
> -		slot = gfn_to_memslot(vcpu->kvm, gfn);
> -		if (!slot)
> -			return -EINVAL;
> -
> -		/*
> -		 * The new VMSA will be private memory guest memory, so
> -		 * retrieve the PFN from the gmem backend.
> -		 */
> -		if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
> -			return -EINVAL;
> -
> -		/*
> -		 * From this point forward, the VMSA will always be a
> -		 * guest-mapped page rather than the initial one allocated
> -		 * by KVM in svm->sev_es.vmsa. In theory, svm->sev_es.vmsa
> -		 * could be free'd and cleaned up here, but that involves
> -		 * cleanups like wbinvd_on_all_cpus() which would ideally
> -		 * be handled during teardown rather than guest boot.
> -		 * Deferring that also allows the existing logic for SEV-ES
> -		 * VMSAs to be re-used with minimal SNP-specific changes.
> -		 */
> -		svm->sev_es.snp_has_guest_vmsa = true;
> -
> -		/* Use the new VMSA */
> -		svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
> -
> -		/* Mark the vCPU as runnable */
> -		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
> -
> -		svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
> -
> -		/*
> -		 * gmem pages aren't currently migratable, but if this ever
> -		 * changes then care should be taken to ensure
> -		 * svm->sev_es.vmsa is pinned through some other means.
> -		 */
> -		kvm_release_page_clean(page);
> -	}
> -
> -	return 0;
> -}
> -
> -/*
> - * Invoked as part of svm_vcpu_reset() processing of an init event.
> - */
> -void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -	int ret;
> -
> -	if (!sev_snp_guest(vcpu->kvm))
> +	if (!VALID_PAGE(svm->sev_es.snp_vmsa_gpa))
>  		return;
>  
> -	mutex_lock(&svm->sev_es.snp_vmsa_mutex);
> +	gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
>  
> -	if (!svm->sev_es.snp_ap_waiting_for_reset)
> -		goto unlock;
> -
> -	svm->sev_es.snp_ap_waiting_for_reset = false;
> +	slot = gfn_to_memslot(vcpu->kvm, gfn);
> +	if (!slot)
> +		return;
>  
> -	ret = __sev_snp_update_protected_guest_state(vcpu);
> -	if (ret)
> -		vcpu_unimpl(vcpu, "snp: AP state update on init failed\n");
> +	/*
> +	 * The new VMSA will be private memory guest memory, so retrieve the
> +	 * PFN from the gmem backend.
> +	 */
> +	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
> +		return;
>  
> -unlock:
> -	mutex_unlock(&svm->sev_es.snp_vmsa_mutex);
> +	/*
> +	 * From this point forward, the VMSA will always be a guest-mapped page
> +	 * rather than the initial one allocated by KVM in svm->sev_es.vmsa. In
> +	 * theory, svm->sev_es.vmsa could be free'd and cleaned up here, but
> +	 * that involves cleanups like wbinvd_on_all_cpus() which would ideally
> +	 * be handled during teardown rather than guest boot.  Deferring that
> +	 * also allows the existing logic for SEV-ES VMSAs to be re-used with
> +	 * minimal SNP-specific changes.
> +	 */
> +	svm->sev_es.snp_has_guest_vmsa = true;
> +
> +	/* Use the new VMSA */
> +	svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
> +
> +	/* Mark the vCPU as runnable */
> +	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
> +
> +	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
> +
> +	/*
> +	 * gmem pages aren't currently migratable, but if this ever changes
> +	 * then care should be taken to ensure svm->sev_es.vmsa is pinned
> +	 * through some other means.
> +	 */
> +	kvm_release_page_clean(page);
>  }
>  
>  static int sev_snp_ap_creation(struct vcpu_svm *svm)

