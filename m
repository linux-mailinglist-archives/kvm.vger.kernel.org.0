Return-Path: <kvm+bounces-39071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3B1A4317F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 01:02:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90E6E1893F66
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1863D6F;
	Tue, 25 Feb 2025 00:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IoBaC06H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD384C76;
	Tue, 25 Feb 2025 00:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441759; cv=fail; b=E+hqJpX90KEVPW9rxFfMkvgN97NuJ15Am2n2Ve3AM0sPzu9LCd6anpRvqNsNukihT+H4Z/oWTKgXBdC5SlehW1pwF1OaK9MwMBI9UEIzOwyt6K7Nnrb0zi7qtMuhTywRu2r77/v72D9cGRMhULgPPWP2zwm6R3sA/VVhL2uT7n8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441759; c=relaxed/simple;
	bh=+mxPeRQJFu8XTeklIvc/pkJOdMlEH2xAjSGEsA918jg=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MUxRl9MOFhnIzE1yqkM/+6nWf6TIWBLSIrGZ55Aqs+nyLrF2rlFgCKTPdeH2zQZoVZWl3yhz7lIIXfFY6jQXTLM6nnyLyr809/lvrSNfUF3kqrNCtskOQA9XODhJyDixE52qXyaVnLM2uluyKQdvz2IY9Jx2uMz+DbHh9QQPkPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IoBaC06H; arc=fail smtp.client-ip=40.107.220.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W3SyFv9PJ3onS3ha9GQu/oXPfqHaTdPrO2yd5seO5jdhcdP8EOy1fwVCp3IEvFkquTlefrQQ142vjdcmHfgwBgjFDlhA0GQy2GYQa+Mok6fOuKTJGEFKwSu0WhJZa/CP2EHCiSqz/bzdCIwmXFKyvpnv9lR4JOR1z6txZjR2SwQA3sOzNarl2EAvy8HE8FdIFa6d0040GQMAyNUiBke6u2jR0lqH+b69MgjL9sZtbg0UibZ0NcmVhMFp/Xs9TT97jhprXvRGuugCOo8ppt3LWxFxW8m9slHGeAY0F+J+HwL6u953uwkiWbmJXm2CdIIUxGYfczYJKy68wh83tdN/4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MP0M8Cf7DO8UiZOIm29MJmGCiqjOO9CSpSK7SOmKGeE=;
 b=pIJXUBPBavdaiqUWganL2syC8dlrMjO+WnT1zeU0oySCYDQ+Y+4s71PoZMe0DTiCTLi7mMFYQ3hQg8jmvrXIuKlqTHH00l9F5TMzIJbamaClqOF2VQ2H5WzuqCKxIglZtcosGDBaE5GfB97ac0LovhFaypdWiKW9xuE67f+uDDXYgGXryPyQ9cBa5qCA7vmjNzfxsHMcJlvVp7RQnL28rMetnPLsxb/Y9Vt52d9GvKucYaOIywpII909egc/cIa3saGJ2JYvkkyWZS9qMrKr0cfkHchHqLNYf789jzRtvEru1EzLOguSuSXJHzsAF9b94oKPXAL+fzd9i05B3VsMJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MP0M8Cf7DO8UiZOIm29MJmGCiqjOO9CSpSK7SOmKGeE=;
 b=IoBaC06HB2Uw7UdORNdfWeQ59QhD9B7X1Zt0U9SAJH4ap0VvDMc84gyVCz44oTrIjFc/GbYEjqdpvK5LZh/7lPq79yxWT7txdMsfojhcbLmdSqU4y/9x/OrA1bmdqW3h/LUyRk7qR2WTSwP24Q4DMS30Fy5urpmHR5MjhTZkPqo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH0PR12MB8775.namprd12.prod.outlook.com (2603:10b6:510:28e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 00:02:31 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Tue, 25 Feb 2025
 00:02:31 +0000
Message-ID: <81949e94-9b7f-0b04-d673-cbc16fc646a5@amd.com>
Date: Mon, 24 Feb 2025 18:02:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 00/10] KVM: SVM: Attempt to cleanup SEV_FEATURES
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <a9d70abe-d229-81cb-4d9a-6106cef612a4@amd.com>
In-Reply-To: <a9d70abe-d229-81cb-4d9a-6106cef612a4@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:806:122::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH0PR12MB8775:EE_
X-MS-Office365-Filtering-Correlation-Id: 185a2f40-a037-4d0a-39c4-08dd552fb2e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0xVOWZkcXZIbHJUK1ZYcjJaVDV5cHA2a1cvRXNNVlpOUW1rY2dTQ1hjREp3?=
 =?utf-8?B?cXozM3V3NjlxMGxoVXhxUW5OK0NENHlxcHVDT0s3OEx6TGE3ZkRqOTZha1FJ?=
 =?utf-8?B?RmFOaVhVUW1aeWhjaitHMjhPYjdSNnlKb2hsZFp3WlZwc29oeXQydVBzTVhM?=
 =?utf-8?B?QXdxUkJSNXBlcXpFd2tJTTY2czZSU01wbDBtaVJac1pPUXpoT1hhNGFTT1o4?=
 =?utf-8?B?cnI0Q1hqVUJOajBCcytuYlZsbXVuQnFLRGxlUStuT2l6c2wzK3FkSk5RbHdu?=
 =?utf-8?B?SzM4QnFJZTdSQ3pVbmdsUHZYTXl5ODR6bjhQaGJlVmxtRWtpeXExcnFLT0Q5?=
 =?utf-8?B?ZDNhejJvbWl2UDNYNzdsRC9ZTkV3NExSQjJzMjE0SHlXd0YxS0NmUlVWNHd3?=
 =?utf-8?B?TlVUQWxtUnl4SlhTUTNxVzFSTkNLc1JnK3YzNjNZb2Q1ckdFaU1naVBvdTQ1?=
 =?utf-8?B?Uyt2aXo5Z09qL1B4NGdEWk1Rd2p0WDNmc0kyZ1FyZkJPQ2dHVkJlbXIrWVZW?=
 =?utf-8?B?dENqMWFpUElIaE40OHpxMUVmaGMyL2c3VTJTcDVCdWtMd1BiOGhyd0FhSUdv?=
 =?utf-8?B?QTE1OFpxWVJ0NjZJZzc1ZVFYeG44cjkzOVkxTkJRL05WS1VJVkI3bTRiRjdN?=
 =?utf-8?B?VElWRi9lREt4NE5Fd1RKQm0zTUMreHF6OUJSYUNYbXQ3dk81YmJkaXFHL21z?=
 =?utf-8?B?alpNZ3JzbmQySEJPVXNjeGRTZ3czYWJNVGdHeW5EWkVra2Jzb3d2bno0Q2dw?=
 =?utf-8?B?VENDREp4d2hFMXhaMzRJanFpamkrNkZGNG9qS25RYU9FbGtLdFdVWkgrZnVs?=
 =?utf-8?B?cnJuSVRnOFBwdkdxaEVhbWVVeEFaaUVYU2FCMUJiN05JNDhiRkFZcGhtUmJw?=
 =?utf-8?B?c2VYNmFRS3ZqdVlrUVF3VkF3NlB6SlNtRG5RQi9aaGtjZmFoTmg0RUs3ZWNO?=
 =?utf-8?B?NVg2UklQMEpLbWRMMHIvWktoY3NuUmdzODlsdmhQUXVRTndQN0pSdjZkL0hB?=
 =?utf-8?B?ZXNlQlp6cm8vNkxHVVB3TG9WSjJlL0s2RHRza2U0b0F3ZW5iQk1xQU92enVZ?=
 =?utf-8?B?cHBnVlhEWjdyU3NKaUpGaU4wYUNGbUt6eVRFV1hyZ1EyT09nTjZRVmFHZG1q?=
 =?utf-8?B?empleWJQS1U5WHlxV20xSHllWTZ5RnJuSmFQa0srY2xxZWFvRlJROHNZU2hv?=
 =?utf-8?B?V3lqV1d2bjlNMm9CNmtNMU1GbjlyWkQxNDF5eWk0eXlmRDJ2Z0crbkJuaC9E?=
 =?utf-8?B?NEt4UElJblp1TmVzM0VGWmpGOWlaYm1DMXdjeXNpQ1JuL2UwQ3Z5b0cyd1R1?=
 =?utf-8?B?R2oxSUNGMDRNYzEyYTNNVVlCc1dudlF1UjFVUmlpVENsbDM4WjJROWwxdEEz?=
 =?utf-8?B?bVZFMXB4SlQxTXZiZ2RZUTJtRVQ1YTU5MU5JT1l1cGVwdG5YZ2JiRGpKZndC?=
 =?utf-8?B?RVpVVTF0Vjl1cVJEWTdmd3h3a1IxY08ySEtKb2tLUEhGK2ZqdUNXRE1NdlhE?=
 =?utf-8?B?L3NtMXRIR1BnemQvNk0wQTVKM3ZWNnF4b3VjYzc0QTFFa21KVlJMSk4wQ0hE?=
 =?utf-8?B?ZzBFaEVhWGcyRHZmSjZLYkhtR1pnY1ZzK2ZtaE9aMGZ2QWhab1p0MExxQzNS?=
 =?utf-8?B?UDFwNlNrZDU0YTNTMVpMYjgyMmNSNDBMQ25pTE9nNWg4SUdHaUt1K0dBWlpZ?=
 =?utf-8?B?VkVuSXYrOVNxZURaZzhxeWJRMGxVWGJxcUNXS2NXTFVSOVpqaW0vNEVEOWpR?=
 =?utf-8?B?cEdmZjJHT2Z6Z09XYXBMRmw4VUVvdGxtQXEvK2pGTTBuWXZtc2I5R1BqMXcw?=
 =?utf-8?B?cE5TYmp5ODVIQmF6cjczSUtBVnl3V1NuQjNBYXlVZkQwRThuTWR1ZVkyaHBW?=
 =?utf-8?Q?5GT0OOGm3Ucxj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3lFaDlvOElIM09FNjVVc25JbktldzhXRk40M1lpcGY3QW9PMCtyYXdOMVpv?=
 =?utf-8?B?VGxvN3kyU0ZwL0V5K1pMeWJGZHFLbzAvZnd5YlBhVFdKREpYaGY0QUFndnA4?=
 =?utf-8?B?YXEybXgvQWpCbWwzZjNER1NCYjQ4TmMyYjJNMjZ0UG1STUpjNWRNOHVsb3V0?=
 =?utf-8?B?WUJBTTRFQWxJNkdwMTJ3MXlEQnpMc0pjUzQ3Rjl0Ylg5VkFGMUpDaWRTVnFy?=
 =?utf-8?B?NW1oQ0phV3lrdTAzbzYzb1hjanFTbWZIcjdxMWJsZVJKeXRjYUh6Q3JLbkk2?=
 =?utf-8?B?RmxiR3h1eWNCdHh0L3ZUVmNtcVZRc3lFd3A5SUc3OEdpSm5Od0loUmZWaUow?=
 =?utf-8?B?MVE1NjdHNWd0T29qNWt3RjMxdGtNbXd1NERjM3VYVkovLzJVaEw4WWJOV1Bn?=
 =?utf-8?B?OSsvb3NkRTdPc2xjbm5jN2tQYkwyalp6NUNPRk4yd3h5bGlacEZIdjU5TCtW?=
 =?utf-8?B?eEdCaUNjUlprWW5NWEQ2a3VxS2lRVTVreUo4Y1EvdW5xSEM2eXVBbkpiL3Z0?=
 =?utf-8?B?NFVWK3NnVllpQTVXY3kvVUZVbjU2R211Y2drYyt1d1ZyYzZyWTlSQ2FPZ0Q1?=
 =?utf-8?B?dGRHbFhDT2xRS2FVMUVOSjRleTBDTUU2WjN0cEJPTUF5eEFNNzdLajZBa0sz?=
 =?utf-8?B?U0VZUDM1VWZCaDhYai81cVVZSkxpMVVRQmF2VnYzcVhlS2g0SU9OYW9lM1R5?=
 =?utf-8?B?U3BiMDZ5a1IzZFZVbFY4MVFiMEFlZmZOdUc3VXlxaG91Y2ZJWk00Rm9YU1NS?=
 =?utf-8?B?N0p0VzNtdkNjR2Y1YTVCMEpKVmRFdUZtcUk4WTRSMjM2TUFiUVZnUmdEKzhE?=
 =?utf-8?B?djlOaFJIRHd2S1I4U0EzMEQyTFRydDRvdStBc25jVFNaTHZVN2U4bnp3Wks0?=
 =?utf-8?B?QVFOWlJ1Yjh0UkUvREhlNDZ6R3kxTVZvNWN3Zi9oVkdpNW9nWlNWQjFtd0VC?=
 =?utf-8?B?ZVk0Q01TQ1JtRmR0VUIvQnF1aVY5QW1Jb2ZuUkZNVlFVNkRZNGpIaGJLc1FE?=
 =?utf-8?B?UWdHRi9QME81MllUalpVZmJhSzJjektrRTBiOE00REhNSlFnYjEvdFF6TkJO?=
 =?utf-8?B?WmQxMjc2c0hjSWZTczkrKzRtY2ZLbjlFbldyWlpuWnFrL0ptKzFTSEhrRXZO?=
 =?utf-8?B?ZXN3UGVzN3U1ME85dzVGdzE5MXRMVHlBZjVtbXpwKzBzNE1NMzZud3drRmNC?=
 =?utf-8?B?dERKR1J6YUFMdzkvN2FxaWtrYjdJZFJEcTZTL3cyNHZESmxlb0dJQTBVaDU1?=
 =?utf-8?B?aWVTUXorK2tsMTdJRHUxQ0szeXZpaTdBVG1NNWJOdi9hQlljZWdmeU9aMjR1?=
 =?utf-8?B?ZTI1OTNmRmJUbTE3S3dtaGErZFFUZEN0U0Qyak9VamdYWC82VDE3MUdzRjdL?=
 =?utf-8?B?T3QyR1g2cnJzUmdaTDU3SFQyUkV5bllzdjVHZmR6QzNab2MyYmlnbDNlajlU?=
 =?utf-8?B?Uy9tNXJNSlJ5QkJzZldsaUFBQUNCSnpFSDg5SFV3NEJGNVh3TVY2bXNSMk4z?=
 =?utf-8?B?N244Vk5IUE1lWHh4ZU5USUZhb2QvWjdQbEFFTmwvNkM3cCtUVHVBaWM5VVEy?=
 =?utf-8?B?MUM4ZmQyc3FadTBwTG5VWitTY2hFVmlUWmtnVi83SG5pQlJKU0F5djNZZVh6?=
 =?utf-8?B?d1lCbFh5em9pLzBWT3FHVDhnWWZqTVRsNzFselZSWHFwaTJoSC9sQmZHK0JY?=
 =?utf-8?B?b0pISGQ4eDJ1UFRFTlRMNGhKc1VRbmpUN3JiOFRldFd4UWR6M0Q0eW9EUVlP?=
 =?utf-8?B?bGR2ZUlUTmZmTUNEdklOeDN3NGV3VGZ3YXQyS2orUnpRaTMxNlBPWEZ1eGtN?=
 =?utf-8?B?aHRpdHd3M244Y25hakRhZFFVZlFJRys2b1R4ak01RnJrWmk5czFUeEhMUkli?=
 =?utf-8?B?cW5ETlVDYisydW1DL3R1MXNqTHl4YjNwVXdkM2xOdDR5VGZGMk9QVnIzWStC?=
 =?utf-8?B?K1lLV3kzdVppM2RqaDlmMTF5K0xVQkxyK3NjRzlIOWxWakRKN25ucXJMQzRX?=
 =?utf-8?B?aHdibm1EYjlqcFlpR3FQdE5CaDd2eWt1ZkFXMDZYYXpFNWZIK2tFeklsMDRz?=
 =?utf-8?B?QnRjNG56QUpsRGJjZ1E1OE5udWNzRWFvQUZXU2tqK2NoTUlaWHdSRGNOaHJi?=
 =?utf-8?Q?ErFNYRTPuGBBSseg8YKaUP/T3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 185a2f40-a037-4d0a-39c4-08dd552fb2e2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 00:02:31.1018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4oP9Dk8OpnaBoh+fw9PgPtD8R625ZW6C5VA9XYNLyd8aLCDpR2M1t3d0vatod3OKiVgs1AD4invhK0jLzOoFXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8775

On 2/20/25 16:51, Tom Lendacky wrote:
> On 2/18/25 19:26, Sean Christopherson wrote:
>> This is a hastily thrown together series, barely above RFC, to try and
>> address the worst of the issues that arise with guest controlled SEV
>> features (thanks AP creation)[1].
>>
>> In addition to the initial flaws with DebugSwap, I came across a variety
>> of issues when trying to figure out how best to handle SEV features in
>> general.  E.g. AFAICT, KVM doesn't guard against userspace manually making
>> a vCPU RUNNABLE after it has been DESTROYED (or after a failed CREATE).
>>
>> This is essentially compile-tested only, as I don't have easy access to a
>> system with SNP enabled.  I ran the SEV-ES selftests, but that's not much
>> in the way of test coverage.
>>
>> AMD folks, I would greatly appreciate reviews, testing, and most importantly,
>> confirmation that all of this actually works the way I think it does.
> 
> A quick test of a 64 vCPU SNP guest booted successfully, so that's a
> good start. I'll take a closer look at these patches over the next few days.

Everything looks good. I'm going to try messing around with the
DebugSwap feature bit just to try some of those odd cases and make sure
everything does what it is supposed to. Should have results in a day or two.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>> [1] https://lore.kernel.org/all/Z7TSef290IQxQhT2@google.com
>>
>> Sean Christopherson (10):
>>   KVM: SVM: Save host DR masks but NOT DRs on CPUs with DebugSwap
>>   KVM: SVM: Don't rely on DebugSwap to restore host DR0..DR3
>>   KVM: SVM: Terminate the VM if a SEV-ES+ guest is run with an invalid
>>     VMSA
>>   KVM: SVM: Don't change target vCPU state on AP Creation VMGEXIT error
>>   KVM: SVM: Require AP's "requested" SEV_FEATURES to match KVM's view
>>   KVM: SVM: Simplify request+kick logic in SNP AP Creation handling
>>   KVM: SVM: Use guard(mutex) to simplify SNP AP Creation error handling
>>   KVM: SVM: Mark VMCB dirty before processing incoming snp_vmsa_gpa
>>   KVM: SVM: Use guard(mutex) to simplify SNP vCPU state updates
>>   KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure
>>
>>  arch/x86/kvm/svm/sev.c | 218 +++++++++++++++++++----------------------
>>  arch/x86/kvm/svm/svm.c |   7 +-
>>  arch/x86/kvm/svm/svm.h |   2 +-
>>  3 files changed, 106 insertions(+), 121 deletions(-)
>>
>>
>> base-commit: fed48e2967f402f561d80075a20c5c9e16866e53

