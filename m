Return-Path: <kvm+bounces-48468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B0BACE908
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CD4E3AA486
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 04:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C0F1DE4DB;
	Thu,  5 Jun 2025 04:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sFYS8yHa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784051A3BC0;
	Thu,  5 Jun 2025 04:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749098968; cv=fail; b=MoRiKfIkm78h5es+TCgJQFoEYvK6Jxo/cmyBpW/kilCCf0DKWjzs6+7qXYMcJZo61s7/6HjfBPF6UVqjbx4FmDrxm5P5EJzJECgRLYDJz3mcvo/hwq2dqHky0jGLeNDuBMaU+gGSIFzN/zkYXDrzjbswIvwgy/2R5VEdEjNzUXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749098968; c=relaxed/simple;
	bh=LX7U2mdX9svAe57Z8DXy6Ox4PtHLyWKrJb1SwAYLoI0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eLrFf5zYmCUjo2cooSX4pGOio4tBFmcTGsirwFeOF7Uo/CHQ8s1Ymn58y/u6TRPr5BJbOdK/ZIPR4SgWFgjyV5F8q+0qTN7GFf/QGaCW0guCfiaAUFn8rOCNYHKG2onUw8FGpezHnm1KdvJI+jRIroIUv18L+1Q9fZRmBZ4ZlxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sFYS8yHa; arc=fail smtp.client-ip=40.107.223.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AB6f6bhmiTBJlPzBmuYaRA8sxzgakqfNIk1lEoqBj9A/OjTd5OktBsfRSdeFiya6ykhimxHDT9nq+Yd1BakiHcBVfJonzpxElqrZPnydIhnIRlqrU2LZDSWSGZSVKK9swzyAI0MNTwft6lAN6PSNnS5R8ZBDL1CVq4HW38nbuA8vcKps+nsBSAJkPk1eQSIz3DUGr8Bp/gwQLAiFphu5gbsz1tul6Mt14DLsrWZOrie/V0ZnWj4vgJWkxtfoxcmljamQnd1YeW+ovKgtoPjXK2BEXcB0hMDr9ig7JPZTH2UPe22933mGCowYd69YaPzLTLKlq3xkfM1xc+/pLea5Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsrzHD2NTKagvkTjFZ/dQGywgwWS7CspoWcKm4Vx/dg=;
 b=MdqlLbDmI5wfkZTA/RgdVKR8b6zObzz5NoAACIPclHFLvai1/nL3fb4axwTa8HUNo8Oiitk1CeHDNWhwIS6T7nClnrdcZIYpqd544t0ge50+3mFW/Inq0ZqKkcRHnaDj2Kzwes+E2g0MZyQLLdYFLbhlrJ6i6+SvBtOsTX3mJWH/5XXN6c8nfv8MXlkekEWtd+fSH9s2722THomDAB57OLhPCXCp7gRVpHhUTIud9GEZn460qC9yM5eWL8MCKy0tgXknbaIhNk7EgYb0c97Cfoo83Ujrb8jGduBporsiO7XYHiD0AiusMqljyvKVMP8n5rfNBsyetQJp1C3rNW5s1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsrzHD2NTKagvkTjFZ/dQGywgwWS7CspoWcKm4Vx/dg=;
 b=sFYS8yHaloV+N4c5/H8VEmr4uyoF6oTIxDTSojmXgBNpnNXgKC9aqRgynpv8NzbLqpHxlXy0WwvicxH5IqAWQoIYMN1fV4ckTmcPWPTWJLfWOlXDrp8SZ9jDlYIuAdAwWNpUeJGaSsiqknYPclb9UYR7JMscdd6Yn4wtiP5Wy8Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by BL1PR12MB5705.namprd12.prod.outlook.com (2603:10b6:208:384::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 04:49:23 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.037; Thu, 5 Jun 2025
 04:49:20 +0000
Message-ID: <48e2199f-37e4-4ea1-b28b-23eb421444cc@amd.com>
Date: Thu, 5 Jun 2025 14:49:11 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 2/5] crypto: ccp: Add support for SNP_FEATURE_INFO
 command
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <61fb0b9d9cae7d02476b8973cc72c8f2fe7a499a.1747696092.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <61fb0b9d9cae7d02476b8973cc72c8f2fe7a499a.1747696092.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYCPR01CA0009.ausprd01.prod.outlook.com
 (2603:10c6:10:31::21) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|BL1PR12MB5705:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c366d69-ed25-4c18-78f4-08dda3ec557a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGVHVHlva0twQkdxVEhldkdIcFMzNlc2YWk2QXhiM0NwQlZ6VDArUUxoUTRy?=
 =?utf-8?B?dWwrMTIwOXdDd2JFWi9NaGdsZ0pkSkJRa0lNc0xQblR6ZGJSTi9ITjBTRnhu?=
 =?utf-8?B?T1M1UVA0TjMremhGanpFR1NJTmVBOW44NFlKcEEyWFVIbW8yMjduQUEwWm11?=
 =?utf-8?B?RFA5SDB3aVZBbkQ1RkxlTGM4ZUM0RTgvUDBxcWNnbHVWWjVoVUgwL0czVzhm?=
 =?utf-8?B?ZWhsWXNLVHIwSnBtU3lNbTVaUnAyRWVRVE5HV2xtbk9wKzBoSVVzRHdhV1VJ?=
 =?utf-8?B?UHJ4TTBHQ3FaSUQybkV2bUFmWWJHMWlwbVV3VkVYeTZrUFVWQVpUYW9QTnE2?=
 =?utf-8?B?ZXNOdVhFTEFLcmZtOFdvV1lVbE5WRGtYRFBOeTkwbUZKVTN2NWl2N0hSbUdD?=
 =?utf-8?B?M3Jidk9TcldwOVhNMHpVbCszekRHa1pPcXNrSXl6dDFuNjJIQm50UWFhSXpC?=
 =?utf-8?B?aUJjVXhzSGlNSG05MU5KR0psRnYzTi9sSHgyUUZPdHN1RnBDc1c5U1pNWW4y?=
 =?utf-8?B?c1NjOHBVVTNvN25yMTNpZmxiSVlYZ3prblJ5dFdIS3JHYTN2V2E1RG9ETDMw?=
 =?utf-8?B?ejB2Ky9EY1FoTVZCU2FXY3BBRGkrVTROVzVNb1dla2pmc2tPcGg0K0ZYd2pY?=
 =?utf-8?B?TmllRk8wNWtCSGYwWVdCMlpjUVhIVHdRNElWdlRQT3ZpSmw5ZUNPNVlMVlJz?=
 =?utf-8?B?bFRMNGRUMHFtc1VGRk5GN0V1enBqR25GdHRvWVkvT2JBQ0cyRzNPZFBEdzhu?=
 =?utf-8?B?Zy9mSXFnaWhhRTFuYU9CcWRiTjR0RFpKRFVwVzNxNXdWaWdPRFM1TXJocmtZ?=
 =?utf-8?B?c05jZWt1UHdrSWFzaFlrVVQ4ZEFHeVpGam1TRVV1amRpZHh6a0VDa0pqMnZZ?=
 =?utf-8?B?Q0JmSVVqKzNWeC9sSTZHYnlWb2Y4dzN3c3VuR0dzTzZZREhoa0dGNmhMbTdn?=
 =?utf-8?B?WWJyZk16L1QwYjlRNmNteExWdjNPTUFadkljVFAzVHJpdlJFZG1xL3R3U1Nu?=
 =?utf-8?B?NnlWRG14N1gxTkthUTF3MGdmeWw2ZngrWDUrMnZ6OHBtbDhsK0xlTGVXZ0VH?=
 =?utf-8?B?WmtYdWNlZlpJMktSMUk4VXlWakdJQjdjMVdXRnJ6WHRDMDlCU2N4b2xhVkJP?=
 =?utf-8?B?MnNQbkc1cXorU3lBWjJISFAzNFQ0NnhIaEFKaERHYjlueDFlT1V2cDJyUmQ1?=
 =?utf-8?B?K2FkRzRmUi9rRnFQTkJ3Z05iTEZ6Y21VTjBMZjg5eW5MRm90WjJFVis2dUFm?=
 =?utf-8?B?NTRpd2kzeVR1ZUI4eXJUVkFQM0F3aE5qbUo1RnkyWVZwRWJaNlE2dUN4WWdn?=
 =?utf-8?B?TVVzak5MTE04MXhIaXZKaXBXZWVOSTdBMDIxMFB4U2hRc1ZJUDByK0ZIVXVH?=
 =?utf-8?B?dDd3dlZ4U2JPeVBSRHhVLzR4WWhnMnNpdlgxbSsvSk9rVWxveGpHbkdyeHhF?=
 =?utf-8?B?UmZ6Qk95dmlwUy9WUUY2RG0xVGFoanRiVDVndHJlbTArRE1IalNXZmltZVJk?=
 =?utf-8?B?enRuMXBWWnRWQmV3dnNnbVFQMmlQK1lLdUJaQW1uU0ttZVE0dzR3RmdsTEpE?=
 =?utf-8?B?WDdlU0RDUFhIY0NTd0Y0MGJiVUd5eXdXanVYVlovQ1hkTkRlY0pTRVBIRTU1?=
 =?utf-8?B?VUhYb25BZFl5VTJpOGQ5RlRBUU9WY3JpK0liU3V1WE5aYTErNm5YUWpld0kr?=
 =?utf-8?B?cnJqSHZza1YrNThJcTBkYkgrSjZoakFLeTlJc0IwckpObjEyZDdjSFVpNkx3?=
 =?utf-8?B?RkQ1RHV5Rm1QK2pOSDhSQjZuS0I4Q2Z3UHJBSWs3NzdiUDZZbWNnL0pWdUQ4?=
 =?utf-8?B?TlZubHZndjVoSFo1ZlkxRWZrelBpak1LRmtSL0s5cG9aQ1JYVUNTNVNRQ3Fu?=
 =?utf-8?B?RzlPMEJFL0NkTlpLOVpmODZrQmgwVkZ1b2pDRlEyMWliVHZCZFl4QlBGZDlz?=
 =?utf-8?Q?EPO25LiZl+A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3ZtcHlkeG13WFJGSFdxTlNpcEdXbDV1TnhpQmRZWEV2Sit5Nzh4ejNmdGRB?=
 =?utf-8?B?RytUMkQ4WDJyQWxQT1F0UmgzT0cxWENwd1NIa0l1Mys3a09TS3IxZGRWTlNV?=
 =?utf-8?B?THU5cExkTFdGN3hxMmNnWGVJWHRWU1d5ZktQZ1Z2YWJFZmF5RXZwNTNSR0ZP?=
 =?utf-8?B?azkzdFVrU0FveXpBQ0w5RFUza2xidE44UTNTaCtlRGRneTIvNkdKM3VHQWw4?=
 =?utf-8?B?bERTeTNzMis3TGZBeGlqTXdnVDZ4NWU0eXRtZlBudlZkaC81M0ZkTUFFV25D?=
 =?utf-8?B?VVkzR3U2WWlSbW5JL2FKR1ZST1pIb0YyMTZYSlZNdW5ZR0hVRmFwSXlnSlpl?=
 =?utf-8?B?MTFlMG1va2FDbGtlbEVRZGpaN2hOS2ZJZ0ZzcnBsaTRHOFdEYVAvM3BRSFpN?=
 =?utf-8?B?N2ZRL3NYV0s2ZGlwUHJ1VXprRXZUMmJjcmk1SVE3TU1FNkw5a2ZXUnN5NTFz?=
 =?utf-8?B?eUwxbGFKVEc5M1JWaHMrZXdqbEovZFYxYTduWUtPOTRkZ0prM3N1cE5ueXR5?=
 =?utf-8?B?eXZYeTJ6bjF2LytjZ3ZuRlBNeWd2RmtURHMrbGZGbDY1Z3NxZVZNWjZtL1pj?=
 =?utf-8?B?dktBN1V1OURHZ09NK0I2UXIvckdWV3B4WnZQTmM0R0dsZEhMNlBkc0RaQVFq?=
 =?utf-8?B?enBlc1E0TkFFbzZoQnNqZFZRU1ZQOW1NVnAzMkN2MVlmeUFCUS96VzdwUEpi?=
 =?utf-8?B?VEFhdm5iT3dUejB5bjJhQk1ZV3d1RVB6NG1jc2l4R3gyekM4WXlBYTRHbHBx?=
 =?utf-8?B?bEpySDdhOVZBMFdUUWd0UlZkVk04ZlpIKzhWdldzbUpHSkxzRG9kMDByNlJS?=
 =?utf-8?B?Y0dvazcwRUdTTWFoOEJKeW9LTGhFeWliRGJYMzFFQlhxaFZMRFVBT0E4MHk1?=
 =?utf-8?B?ZE5tckdSajRPVTIySDRweUJZMmZtK0Y2WVlSQ0FVanJhbzRsUkpTR1kzY1VG?=
 =?utf-8?B?Umh1cm8wakMxSGdiK2RocTZNTWFOTCtCTGNFRnZpVUV2cnoyYytTVWE5bkRv?=
 =?utf-8?B?VXZCQ0t3a0NiWERjT2VhSVl6Z1FIM2VVYWhFMGM3L3FMSk9pZjVlUWdmTXQ0?=
 =?utf-8?B?UFpYNWUwV01xNWpJdU9TUGlleFVjVEhGYzViOVFmY0tDWklua2FjM0k4MWZP?=
 =?utf-8?B?NEtMRjBOVUp4cUlVZFp4bG1wd1FTR3Jyb1lrcUROa2VzcXZqV1FwUkRXeUFm?=
 =?utf-8?B?WE1yL2F1MWZpaHhQME5sNzFTcW1SdkZvWEdtaEMxYjBSRjNQNlRiNGNEQmUv?=
 =?utf-8?B?YXFOalphYmNqbEFQVlZ5NVNuOGo1Umk4Vm5NcWVxRW9OOXpqMHJad2FzTHNJ?=
 =?utf-8?B?S0Z6NlM3Vy9BcU5kWnRVWWtLc3hCbVZHamZYeTNFRXp1aWcwa09MZnNpK0RL?=
 =?utf-8?B?TG01K05EWkZlSHRlSjV1NWl2OUlmL3lXVVl0a29hWEV3S1dwYU9jOGtsRkp3?=
 =?utf-8?B?RWF1NFdGZnZ0V28yYmRmT1NEQ0lIdjlSdE10cllMdlExMjRWNnhKSGpRcWND?=
 =?utf-8?B?b3JWMFhYTHcwcVdWMW9nMTNaSUROVVhlUWZPOVBhQS9kMXJZb3RyZUtlQ1Z5?=
 =?utf-8?B?VU1ROGdpMkRiTlJhd1N6Mk5LTWZlYU8wU2ZZaWdLWGExR0VIUWtjaXl1SkVI?=
 =?utf-8?B?Yy9HcHZJUVo0aGdCWnFMTWpDOU1DSnhpeGYzQ1lFNFUzWk4rQ0hYVy9zKzhN?=
 =?utf-8?B?M2h5RzYyRjNBK0VNa1BFa3pkQ1hKL1YzTjBUSCt0ejBPeFl2bFFYTXphNkNr?=
 =?utf-8?B?bityNk1KTlRPbG5BL0pJWWFTcXBDckpKL0swUmZzUDBObzFzTDhQdkRRRUkw?=
 =?utf-8?B?MWJ3b0hEeXZpQkNsWU9Tb2hFQmY5ZGpDekxPLzNDbU5BbkhxeFpiT3JGK3d1?=
 =?utf-8?B?djl4TXhiV0JjZXdUR0kvRFFTa093QllUeElyVCtVOG5Ld0lZa2FaY1Y2NlhO?=
 =?utf-8?B?SENobXBheHdoRkYveG5iZ1pyaEhNeHoxVzVPZnNpMytOWmdFU2J4Z1JWQ2lP?=
 =?utf-8?B?dzRhSEVBSmdHQ0RXeWlDZGU0ODlKeUVuWjBHNmZjdjRtemc0c2Y3cnZkMGxt?=
 =?utf-8?B?djY2aVNUYUlsS0ZDRkNLRWpJS0xVUWRSWVlPbDQvL3NTa2UwT2w3eHhuRTBC?=
 =?utf-8?Q?7smp+yTKtDFVxcCfZdFnJ+J+9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c366d69-ed25-4c18-78f4-08dda3ec557a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 04:49:20.1624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZvOZqFp+F6GHGD/NbKeA5SjD6mF4HMf7YcDC8SKR4n4m4gRiD2UR4X60btrwv3aBGOzhaeQi7rDjkv8pUu0qsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5705

On 20/5/25 09:56, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The FEATURE_INFO command provides host and guests a programmatic means
> to learn about the supported features of the currently loaded firmware.
> FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
> Instead of using the CPUID instruction to retrieve Fn8000_0024,
> software can use FEATURE_INFO.
> 
> The hypervisor may provide Fn8000_0024 values to the guest via the CPUID
> page in SNP_LAUNCH_UPDATE. As with all CPUID output recorded in that page,
> the hypervisor can filter Fn8000_0024. The firmware will examine
> Fn8000_0024 and apply its CPUID policy.
> 
> Switch to using SNP platform status instead of SEV platform status if
> SNP is enabled and cache SNP platform status and feature information
> from CPUID 0x8000_0024, sub-function 0, in the sev_device structure.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 81 ++++++++++++++++++++++++++++++++++++
>   drivers/crypto/ccp/sev-dev.h |  3 ++
>   include/linux/psp-sev.h      | 29 +++++++++++++
>   3 files changed, 113 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 3451bada884e..b642f1183b8b 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -233,6 +233,7 @@ static int sev_cmd_buffer_len(int cmd)
>   	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>   	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>   	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>   	default:				return 0;
>   	}
>   
> @@ -1073,6 +1074,69 @@ static void snp_set_hsave_pa(void *arg)
>   	wrmsrq(MSR_VM_HSAVE_PA, 0);
>   }
>   
> +static int snp_get_platform_data(struct sev_user_data_status *status, int *error)
> +{
> +	struct sev_data_snp_feature_info snp_feat_info;
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct snp_feature_info *feat_info;
> +	struct sev_data_snp_addr buf;
> +	struct page *page;
> +	int rc;
> +
> +	/*
> +	 * The output buffer must be firmware page if SEV-SNP is
> +	 * initialized.
> +	 */
> +	if (sev->snp_initialized)
> +		return -EINVAL;
> +
> +	buf.address = __psp_pa(&sev->snp_plat_status);
> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
> +
> +	if (rc) {
> +		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
> +			rc, *error);
> +		return rc;
> +	}
> +
> +	status->api_major = sev->snp_plat_status.api_major;
> +	status->api_minor = sev->snp_plat_status.api_minor;
> +	status->build = sev->snp_plat_status.build_id;
> +	status->state = sev->snp_plat_status.state;

These 4 lines should be ....

> +
> +	/*
> +	 * Do feature discovery of the currently loaded firmware,
> +	 * and cache feature information from CPUID 0x8000_0024,
> +	 * sub-function 0.
> +	 */
> +	if (sev->snp_plat_status.feature_info) {

Could do:

if (!sev->snp_plat_status.feature_info)
	return 0;

and reduce indentation below.

> +		/*
> +		 * Use dynamically allocated structure for the SNP_FEATURE_INFO
> +		 * command to handle any alignment and page boundary check
> +		 * requirements.
> +		 */
> +		page = alloc_page(GFP_KERNEL);
> +		if (!page)
> +			return -ENOMEM;
> +		feat_info = page_address(page);
> +		snp_feat_info.length = sizeof(snp_feat_info);
> +		snp_feat_info.ecx_in = 0;
> +		snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
> +
> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
> +
> +		if (!rc)
> +			sev->feat_info = *feat_info;
> +		else
> +			dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
> +				rc, *error);
> +
> +		__free_page(page);
> +	}
> +
> +	return rc;
> +}
> +
>   static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>   {
>   	struct sev_data_range_list *range_list = arg;
> @@ -1597,6 +1661,23 @@ static int sev_get_api_version(void)
>   	struct sev_user_data_status status;
>   	int error = 0, ret;
>   
> +	/*
> +	 * Use SNP platform status if SNP is enabled and cache
> +	 * SNP platform status and SNP feature information.
> +	 */
> +	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
> +		ret = snp_get_platform_data(&status, &error);
> +		if (ret) {
> +			dev_err(sev->dev,
> +				"SEV-SNP: failed to get status. Error: %#x\n", error);

Drop this as snp_get_platform_data() does that too (and even better as it prints @ret too).

> +			return 1;
> +		}

.... here, and drop the @status parameter. Which in fact is pointless anyway as ....

Let snp_get_platform_data() do just SNP stuff.


> +	}
> +
> +	/*
> +	 * Fallback to SEV platform status if SNP is not enabled> +	 * or SNP platform status fails.
> +	 */
>   	ret = sev_platform_status(&status, &error);

... this sev_platform_status() is called anyway (not a fallback as the comment above says) and will override whatever snp_get_platform_data() wrote to @status.


>   	if (ret) {
>   		dev_err(sev->dev,
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 3e4e5574e88a..1c1a51e52d2b 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -57,6 +57,9 @@ struct sev_device {
>   	bool cmd_buf_backup_active;
>   
>   	bool snp_initialized;
> +
> +	struct sev_user_data_snp_status snp_plat_status;
> +	struct snp_feature_info feat_info;


"snp_feat_info_0" as 1) it is for SNP like some other fields 2) there is subfunction=1 already defined so need some distinction.


>   };
>   
>   int sev_dev_init(struct psp_device *psp);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 0b3a36bdaa90..0149d4a6aceb 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -107,6 +107,7 @@ enum sev_cmd {
>   	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>   	SEV_CMD_SNP_COMMIT		= 0x0CB,
>   	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>   
>   	SEV_CMD_MAX,
>   };
> @@ -812,6 +813,34 @@ struct sev_data_snp_commit {
>   	u32 len;
>   } __packed;
>   
> +/**
> + * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
> + *
> + * @length: len of the command buffer read by the PSP
> + * @ecx_in: subfunction index
> + * @feature_info_paddr : SPA of the FEATURE_INFO structure
> + */
> +struct sev_data_snp_feature_info {
> +	u32 length;
> +	u32 ecx_in;
> +	u64 feature_info_paddr;
> +} __packed;
> +
> +/**
> + * struct feature_info - FEATURE_INFO structure
> + *
> + * @eax: output of SNP_FEATURE_INFO command
> + * @ebx: output of SNP_FEATURE_INFO command
> + * @ecx: output of SNP_FEATURE_INFO command
> + * #edx: output of SNP_FEATURE_INFO command
> + */
> +struct snp_feature_info {
> +	u32 eax;
> +	u32 ebx;
> +	u32 ecx;
> +	u32 edx;
> +} __packed;

(not insisting) You could even define this as "struct snp_feature_info_0" with all the bits from "Table 5. Contents of Each Subfunction of Fn8000_0024". Thanks,


> +
>   #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>   
>   /**

-- 
Alexey


