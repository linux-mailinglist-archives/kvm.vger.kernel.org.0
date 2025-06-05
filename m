Return-Path: <kvm+bounces-48488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F4046ACEA35
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:33:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CD0918993E3
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845C18462;
	Thu,  5 Jun 2025 06:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f3Q/HbRX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2073.outbound.protection.outlook.com [40.107.101.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6E01E492D;
	Thu,  5 Jun 2025 06:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749105188; cv=fail; b=LtZ7QUEe627VGH01jCS50kMW/0j2ICpLhhOoAGSsC7bYKbVLKgSiXCP9Kh2CLBY+qFYU+KmgtlP9CepFwUxUDBkNBBpIZ+FY3VBUK1lPevZcpWb05ulcm17EILPn+6JHnqVGPiELabVvI1cnAgqDku//lGua72W2PF9hTRP7T3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749105188; c=relaxed/simple;
	bh=GBPYLwD4a8LLZDsBnOmAu5PYlrTaAAQXEYorSN4MoGM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bDwIm66gJbV8QPn8kcfWy7HutU4v+WWGDi5Gw8U4znas7xwnDarp1UtFjKm2/lbkGzxTUGeln61yYqreg4dHM08tOa35VIe20cdsBXBhgDv3oB4CUfS5OL1SXYUjqjP/KySv9H0IDF6g/BPjuImIkS57gurucV/DLKd8/vDpbDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f3Q/HbRX; arc=fail smtp.client-ip=40.107.101.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QWA/pEQ2qMPeDJyo3puAy34o1dT1z193rZUn/8esgDxlHjLjE80APX1ufxSFviqwKk4mAScxoN9DNxVsWOKo8SjDiTIfrLoJB40k17jtCPBGXqAzw17sfY3hH6jT5YpEsVRrNu5FqBAmq2Rz24jMP/tkbBMiFgAv+A55sfHb2miIsn0DIwhmpp9bSiAPenr+8ZrkZ2UVPPO12wPz0rnQsOdzQdMVwbwr+b2fW7/c+lvB+pu2FxLIGg7fa66iMDsjaWiEFr9eHPLrb1lZIVRH3sLsA6wM7XAQp+i1M8jgBcPL66i/eD50qsFYjY0JgStmTfN37dDKtmrpkYrFs2oZjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4C1w9lMjpihb51KrUkvvDb5KYriMsZ2w1j4LakGQ34=;
 b=sXLGyxngtcmwPTi4shKZgIRo8rUnDt9WqMq1T9pQiMio0oHDvJ5b5I24JMsLIEPWUk+HA2YWe2I0H1LTBMt0OJpvm+oXoU6je5AIqi1KEhJiMdw7OllqY4nnw3eQwc7s4/f4sVjsNuQMAIIemCjY40aND/79xEBMv64X860ZyszwuNjLs0VKs79fSdfwfNhu8NES5qDC29MEwaoenqaDJ7fyyRy2hNpW/oCVpGNNWv6TWh4kjEjTOmdA6JTCVtqG0GNZro8/s2pAlg9BNRm2hVVmAkTWLRHl9dedb+wojsmVlDgRYsspNAaZHW/VXWhVcZ6NEL6W/Gdz8LwzXXjv4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4C1w9lMjpihb51KrUkvvDb5KYriMsZ2w1j4LakGQ34=;
 b=f3Q/HbRX0pYjhifFEwzfcd01Qo3tQqQOK2ItJ1fMp2CJRpE1lcYjApf6AbfRZEyf3Iu+I+V57VAlMGY/JRCXerNC+anWJcMMYkJHNuLDGbyhqGZNnDWEnLO0KYRoWD/ckR3y0ecpXkKgAUBMq2Z0vFzN+WE6ivUFAH/p3Zqvalo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by IA0PR12MB7508.namprd12.prod.outlook.com (2603:10b6:208:440::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 06:33:05 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.037; Thu, 5 Jun 2025
 06:33:04 +0000
Message-ID: <e59803e9-017a-4257-ac9c-7bdafbc624ff@amd.com>
Date: Thu, 5 Jun 2025 16:32:57 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 3/5] crypto: ccp: Add support to enable
 CipherTextHiding on SNP_INIT_EX
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <0952165821cbf2d8fb69c85f2ccbf7f4290518e5.1747696092.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <0952165821cbf2d8fb69c85f2ccbf7f4290518e5.1747696092.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYCPR01CA0033.ausprd01.prod.outlook.com
 (2603:10c6:10:e::21) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|IA0PR12MB7508:EE_
X-MS-Office365-Filtering-Correlation-Id: 5957e9c6-00b3-4414-df1a-08dda3fad3c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?REUxLzgrSThZVGVQaHN0Z3M4ZlFxY2w1SnpzdmJaeGwzaGp5cCtlU2xjWDVt?=
 =?utf-8?B?YW56VTlMVWNuUXlMdDg1dHJxUE5FbzBDUEZtZDJGMmt4dnNkTGd1S1JBVXNL?=
 =?utf-8?B?WUE5RU8xVzNzSjZYVmd3SWw0QjFtNVRDakNSUktnZUM1cXh1b0JEUHBhdyta?=
 =?utf-8?B?YWVMRkNFZTJ2c0lZNnVmTmlKeXBsS0RteHdvN0IzK21QOWZZWURoOHV1WUNH?=
 =?utf-8?B?Sk5QeFk2aEtOOXRqRnQ1aHd1ZmZJL2pwT0ZHdTBBMUxURFlibkZkUnRoMUtk?=
 =?utf-8?B?T3VYM0JDTjh6Z1YwVzdRZEFkQmVOVlFGeGJEWjUya1NlUklJN0Y2T2lpM2dD?=
 =?utf-8?B?UkVoNzZDczVRQnRwUkVBeWp3NW1TSFJuMmxOQStMZ0dtcjBrYUZ2UTBuR0lz?=
 =?utf-8?B?Ty9BWStOSFBQSWIvVjhvT0tTcFB0RkFWa25Qd0lqQUhGNHZydXVtT0FCRFZQ?=
 =?utf-8?B?UTZqVS92RVliayszd1djNU9ZSnhpRmZsY0RobzVMVnEzbDYvd0w4b2ZucktG?=
 =?utf-8?B?YVZmbnFQUEltc3AxSnpqWnVzZDYxdk5OaHhvSjErYy9TNWFTN3pzL1ZGR0o1?=
 =?utf-8?B?UEtUaFdieHN6MGwyTFBSOGZuQlJWSXNhRmNaeWcwZGJiUWxnQlBYR2NMZjB6?=
 =?utf-8?B?UTR0UVF1UEgyYkVkdXVMeGdCVnl1V042SHR0bHAvdXdUSWx5TjhUMlRUNnNN?=
 =?utf-8?B?d0xFU3FnZFBxUEMwTmVJSlY0YUI3SVRacWpZaXloY3MxeS9wcG9Zc05oanRP?=
 =?utf-8?B?MUw5Y2w3ZllnaXFTNjZMYkprMjkvczdBaExlZ1BVcWt4MzhNKzFNQzdod0Zu?=
 =?utf-8?B?SG9LMjRnUGNMb0hjZjFaU3ZHYUpZb2hqSDBrMG1pQVdEQ0lzL3FmNVVBZC9R?=
 =?utf-8?B?MWhzZVJwSmc1clcrN2RmWUN1NUhadHgwcnMvcThwWTZIUlhGSnhZcFdYQi9u?=
 =?utf-8?B?alY1ZnRZQU9FQ2xsOTVFTHNwMmVwQ3ZpZE1ua1J5MzJSbjdVS2k1RytYWW1H?=
 =?utf-8?B?RFg1TUNrS3hCSzZnRG03dm1xdDJoRkpxZkNjSHBqSFBGTTVGOERIQS9jb2VU?=
 =?utf-8?B?N2MzNWVFMHJMMVpDYitlVDBMN0NQTXNKYXp1cWhQNFlhMW1Za1MxOWIxYlRu?=
 =?utf-8?B?cXhMU095eGZUbDAvSUxCcjZ2aXVvYXZvTllCUFVaeTZFMXJ6bzZUanFKalhv?=
 =?utf-8?B?VDhKeENGQkYrbDluSkZWVERFdG9iWVFCQTZ2bDFnK3BYS0tIdE9wcGcyK3VO?=
 =?utf-8?B?eDBBdks0SlNVNmlLMnJON055VE4wL25WMHpheHg4dld1SEo0M3NvWWpqSWlC?=
 =?utf-8?B?ditFaGN1cVBxT3lSdko3L3pyUmZsU1lkcWZyM3BnV0xHeVpYRHpxV1Z1LzF2?=
 =?utf-8?B?TlgwNGVtYjlVQjFTRU5PZ1ErS0F0VFpDWjk5aktYd3ZEZTF5TnkwMlN2SXQ1?=
 =?utf-8?B?eThBUlo1R2pwMUNMS3Bndks5Vmk4clFHSVl4a0pNZHVneXJiS3BoRWtBWUlt?=
 =?utf-8?B?VksxckVpVHowc29SbzJwVTZoTERYb3FDeWkycUNOMVJ2R1VqdG5NMlpJcDhL?=
 =?utf-8?B?WnVWcjlLeDdPbWVrZzJVQlBQUSszQlRkVm5VZXc5THVDT2JKRWFtSSs3d0c2?=
 =?utf-8?B?eTljTjg3YXBra0xDTWZYUkNxVDhocHdiVFhMdGlXbTdMSzBFQktRSW9Rajl5?=
 =?utf-8?B?bVJDQ25oeTBOWmtzbmFYS2JWN2UxcjljTHM1aFRGWWZoakgwZUVBQUhkS3Nn?=
 =?utf-8?B?aUJrNm5vZHN6VUYrbk95bjBCYXJ4V244SzNtbzlBODh4bTBHRzFBRzRhdHls?=
 =?utf-8?B?b1lBa05UL1Nla0E5dU44eVBhZGVZc2YySmlTd05CakpkQ0xiREJ1OGNlNmQw?=
 =?utf-8?B?S1hRQzNHMUlWZlExWUJ1UDhJODFXbURWcVNyWGxpQVlrWXBYaFRuY1RzZW9i?=
 =?utf-8?Q?W3rUjoUCAjw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXA3NDVReEdGZFNYZmlWVWtWeGpRZ1M1UTdRamtZV1E5UWJyTjZsTHRsbjRU?=
 =?utf-8?B?a2wvajVDN0FDd05rSC9USk13djdCNTNiR04zZExyQmowb2oyU1JmcXorK1Jp?=
 =?utf-8?B?NURCQUw2Yy90MExNcmZOUHZaQXFCS0xHRlBGVXNjZkw1R1VyRVpRVjV5K0NG?=
 =?utf-8?B?WkwweVFjMHV6YTJoQ1lrUHB2S0p4WHZ0eUZKYWpMVk5OYnRMMEd3eXdrTFBJ?=
 =?utf-8?B?RXdSTmpTVWVkVXpGL1ZSSStKSW03WlIxZ3JnbUYyWUNOTzhKMHNFNE1EVnQw?=
 =?utf-8?B?czV1QWJ1UDJxRlBINXdXQVF0WTFNMm4rNnVFTTNRMkZncktDVk9KSFA5M0Vp?=
 =?utf-8?B?UitZQkpuRWVHaUFEdFNvSHhkenJFNkNBQWdrNjRodE9pdHFrc0VHbUFrK2Mx?=
 =?utf-8?B?ZklWMi9jaHE5UmpPZ0RjT1BjV21Db2llbE1xLytyOUtUbCt1T1lzOFRqWTJW?=
 =?utf-8?B?VHFrVkZiSUdJQmxqbDV5akpSYmFHUld4dDR0RnAvUHRPNW5jaFg4Q08xM1dk?=
 =?utf-8?B?bDRGSWdJQ0tkSlErYU1DdlphcVprbEhuUXJ4dWVZUWJtMEhHcG9WYjdpRkxi?=
 =?utf-8?B?Q2RwRkdHQTR5TXRBU1VyVVcyY3R5c25jZWw0bjdELzFyVTdXd0R4bUwvOTRL?=
 =?utf-8?B?YzNoc2x3UkhYa0UvWFVUSXVPR0l5WGlFaklwekdTS2c0Zk4yYXZtV1dUcDVV?=
 =?utf-8?B?M3BHTUJGS0NidGZlN3ZmaEpMcWlsRTVMUEwvTS9ZN1JKVEY1SzFQT1RUK3ln?=
 =?utf-8?B?VUgwUVVOenpxdUVjbTRkY0NaL3Z6UHVUR3Z0NHlmaU5tbytva0hXeGgySHM1?=
 =?utf-8?B?VklPSmp1TGVtTlMvOEhHYk5KR0Zob0RGQ1lTMVpXeWh2R1g1N1IrWGd2blFI?=
 =?utf-8?B?ajFidmtrR29KN3B4Z1l0L1ZnVUJqdHgvTytvbHFMTHRIeXFzMWxiOEkrS21p?=
 =?utf-8?B?ZmphWnBVT0xsTTI0UlpkblNxVG8wSmZTbVgzSjBXYUFJVU54RFFteXExQ2lk?=
 =?utf-8?B?Zy9rSXdEYktOTXRneEhSMW1DZDVrSkxQRFBhSTNyZmRTc3BFL2luWGxhaUZS?=
 =?utf-8?B?ZmxZNk9QandLR0ZaZGw0RzRESWVhdnkvTVJrZnNSNVI4bWcyV0E3WEZETGx4?=
 =?utf-8?B?bHNscldSdHpPcWlHVGhIZWEwN09oa0t4OFljdy84TjJ1eDB2TGsrWmoxY3Fw?=
 =?utf-8?B?VTFLZWJxRWZsanFQY3V0OFJudmlQTHhYakc5SzRRSXZzdWNKTTQyTnE5VkVP?=
 =?utf-8?B?SGV0MkJ4ajJwTmg2bFIvVFRBMi91eXUrR0M2R1JkampWZUdSNi9xSVhZUGVN?=
 =?utf-8?B?OUVlKzU1ZWIrZVJUc3dVMHpIYlpXZDdFcTQwT3oxZ1dYMTJkcVgzaktpWktI?=
 =?utf-8?B?Q3pFemN2TVh2OThmRUF4b0QxNzdHb3BXT3k0TjA3Y3pyN3QwTkFzZFJhOUNu?=
 =?utf-8?B?SEVTV3BKcm82YVdKMGEvSWlKK3N4Nzd5SkZmL050U2k5ay9yMWRaQ1hsT1ZC?=
 =?utf-8?B?SzFkamNib3FvZnV5bXVOcVEzS3N6VDNHbjV1cXgwcnNBckdIQ1l0dFFCV0N0?=
 =?utf-8?B?Q3dIbkZOaG5keXNPc2Nield5amFKMW81bEZaVzBma0hiWW84UTRwNnVwazJV?=
 =?utf-8?B?ZVQ1ME8veVlLZTNmQ0lYTGoxTVBJRmU3YWVhRXVNOGFRY1JEbkNtNmNUYXBx?=
 =?utf-8?B?SEhrRVhRQTNQUTE1OFI0WHpGdlR2Z0RycllLcmNDZm14bitLOFhHcHErOFhm?=
 =?utf-8?B?QUVaQU81ZklSczVqMWdRVkNmYVBXZDQzamR3cUJkRit0SW1CaWxjVWZydkZp?=
 =?utf-8?B?ODlqb2krYmdJZEFQOGEzUE5ZejJ2Y1Y5cXhKUTNISHkzRWlXY0VWekFaS0RL?=
 =?utf-8?B?UkpmWnd4QytnWFIwRnBVV2haUlk3NExTOEdNbW00T1pqS2hVYjNEeGNlUktL?=
 =?utf-8?B?QXNKZzhXbkhMRTMzMlNhQURtV1Q3dGdwMjRwNFh1dDVadzY4WjdyQWQ4bEo3?=
 =?utf-8?B?dUNtVWphWXdUQjR4Z0FVZ0FTa3N1c1dQN2cwZEtiMWlZNm5aUFNOZ3R4S0hR?=
 =?utf-8?B?ZXZwS3ZXelN0MDUyZ2hZTndIa0JxWDZnTC9DU1FDWXZjanpqWms5NzQ2Z0s3?=
 =?utf-8?Q?X5oJkrU4fE8hmL00l3gfrBKT8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5957e9c6-00b3-4414-df1a-08dda3fad3c2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 06:33:04.9143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U81HRWW5eVxALRpWnYM8j8t0ftotxsQarLWo7uj5mnsDQzTYpoSmrHXLJd99W9VlKAurScnkAeENQkiVXixmPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7508

On 20/5/25 09:57, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding needs to be enabled on SNP_INIT_EX.
> 
> Add new argument to sev_platform_init_args to allow KVM module to
> specify during SNP initialization if CipherTextHiding feature is
> to be enabled and the maximum ASID usable for an SEV-SNP guest
> when CipherTextHiding feature is enabled.
> 
> Add new API interface to indicate if SEV-SNP CipherTextHiding
> feature is supported by SEV firmware and additionally if
> CipherTextHiding feature is enabled in the Platform BIOS.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 30 +++++++++++++++++++++++++++---
>   include/linux/psp-sev.h      | 15 +++++++++++++--
>   2 files changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b642f1183b8b..185668477182 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1074,6 +1074,24 @@ static void snp_set_hsave_pa(void *arg)
>   	wrmsrq(MSR_VM_HSAVE_PA, 0);
>   }
>   
> +bool sev_is_snp_ciphertext_hiding_supported(void)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +
> +	sev = psp->sev_data;
> +
> +	/*
> +	 * Feature information indicates if CipherTextHiding feature is
> +	 * supported by the SEV firmware and additionally platform status
> +	 * indicates if CipherTextHiding feature is enabled in the
> +	 * Platform BIOS.
> +	 */
> +	return ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
> +	    sev->snp_plat_status.ciphertext_hiding_cap);
> +}
> +EXPORT_SYMBOL_GPL(sev_is_snp_ciphertext_hiding_supported);
> +
>   static int snp_get_platform_data(struct sev_user_data_status *status, int *error)
>   {
>   	struct sev_data_snp_feature_info snp_feat_info;
> @@ -1167,7 +1185,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>   	return 0;
>   }
>   
> -static int __sev_snp_init_locked(int *error)
> +static int __sev_snp_init_locked(int *error, unsigned int snp_max_snp_asid)
>   {
>   	struct psp_device *psp = psp_master;
>   	struct sev_data_snp_init_ex data;
> @@ -1228,6 +1246,12 @@ static int __sev_snp_init_locked(int *error)
>   		}
>   
>   		memset(&data, 0, sizeof(data));
> +
> +		if (snp_max_snp_asid) {
> +			data.ciphertext_hiding_en = 1;
> +			data.max_snp_asid = snp_max_snp_asid;
> +		}
> +
>   		data.init_rmp = 1;
>   		data.list_paddr_en = 1;
>   		data.list_paddr = __psp_pa(snp_range_list);
> @@ -1412,7 +1436,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>   	if (sev->state == SEV_STATE_INIT)
>   		return 0;
>   
> -	rc = __sev_snp_init_locked(&args->error);
> +	rc = __sev_snp_init_locked(&args->error, args->snp_max_snp_asid);
>   	if (rc && rc != -ENODEV)
>   		return rc;
>   
> @@ -1495,7 +1519,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
>   {
>   	int error, rc;
>   
> -	rc = __sev_snp_init_locked(&error);
> +	rc = __sev_snp_init_locked(&error, 0);
>   	if (rc) {
>   		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
>   		return rc;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 0149d4a6aceb..66fecd0c0f88 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -746,10 +746,13 @@ struct sev_data_snp_guest_request {
>   struct sev_data_snp_init_ex {
>   	u32 init_rmp:1;
>   	u32 list_paddr_en:1;
> -	u32 rsvd:30;
> +	u32 rapl_dis:1;
> +	u32 ciphertext_hiding_en:1;
> +	u32 rsvd:28;
>   	u32 rsvd1;
>   	u64 list_paddr;
> -	u8  rsvd2[48];
> +	u16 max_snp_asid;
> +	u8  rsvd2[46];
>   } __packed;
>   
>   /**
> @@ -798,10 +801,13 @@ struct sev_data_snp_shutdown_ex {
>    * @probe: True if this is being called as part of CCP module probe, which
>    *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
>    *  unless psp_init_on_probe module param is set
> + *  @snp_max_snp_asid: maximum ASID usable for SEV-SNP guest if
> + *  CipherTextHiding feature is to be enabled
>    */
>   struct sev_platform_init_args {
>   	int error;
>   	bool probe;
> +	unsigned int snp_max_snp_asid;
>   };
>   
>   /**
> @@ -841,6 +847,8 @@ struct snp_feature_info {
>   	u32 edx;
>   } __packed;
>   
> +#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)

SNP_FEATURE_CIPHER_TEXT_HIDING ?
or X86_FEATURE_CIPHER_TEXT_HIDING ?

In other words, mimic X86_FEATURE_SEV which is a real CPUID bit and FEATURE_INFO mimics CPUID. Thanks,


> +
>   #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>   
>   /**
> @@ -984,6 +992,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
>   void *snp_alloc_firmware_page(gfp_t mask);
>   void snp_free_firmware_page(void *addr);
>   void sev_platform_shutdown(void);
> +bool sev_is_snp_ciphertext_hiding_supported(void);
>   
>   #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>   
> @@ -1020,6 +1029,8 @@ static inline void snp_free_firmware_page(void *addr) { }
>   
>   static inline void sev_platform_shutdown(void) { }
>   
> +static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
> +
>   #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>   
>   #endif	/* __PSP_SEV_H__ */

-- 
Alexey


