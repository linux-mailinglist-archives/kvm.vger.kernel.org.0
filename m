Return-Path: <kvm+bounces-28237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96664996A35
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 14:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1845B1F249B5
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 12:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB4F197A77;
	Wed,  9 Oct 2024 12:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zN+hHPqi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2086.outbound.protection.outlook.com [40.107.95.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780211E4AE;
	Wed,  9 Oct 2024 12:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728477516; cv=fail; b=MdCu+a7I2Q6olRq2tRU1USe7njsHCQZSmmmgG6e9QFB7K9jaQEiFR2jfD9fv+dYIWbkmbQWSG5TaqOPC3FqT3wdwViCEIrWlg9bmKh2StgGMlatvaY6z0Lb/wEH/VNMrAxED4sV62T5UWyIsrR9LNtXCO/3lDEiY+9FURCEQalg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728477516; c=relaxed/simple;
	bh=OrbRR8UGFTWPp8vJmZaY6jxXhJr58D87n+1d/RgbW34=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LCr7J1Fbx9tOnKoMzIMg/9m06hrJAU0B6ekOeTyfRVXddYdRkUHxvV0bYgli/yioteTme70wiZCHZTdQteuvLzaymstv9DneCHS5JWA46OeqSJdUneM7MWyp895SrgosTxUK23zzvHSCXc2qZMjOCKoy+SxnHkfM9CRF57Gmiuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zN+hHPqi; arc=fail smtp.client-ip=40.107.95.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rOgIDC/2HzQZVTG2LQK1/o3jLAutCsRj8iJf0qb71vMNfBPz6Tg4xUr9KcL/dGFE+ZraGwhTSe3D/GN+xaYMoRBUTXqv/PGppjW1ISs+Tk3ZPT78NfgZWlYmY369shlhmsV+gWY53BzxFBq2VRKoi8wlm00uT0v6ofrN7ZcnFxBTuoX0fDMjJkJChfE757hfnH1aq+HtNcGo2x5nOtPrIDunHccUgHlPkTBf5aomzfOI0ang5DXVmsWTXn9GVeKppyUT3irpY1YWwhr8xTeYFHaG4yJOL4yRgeUbm9dABGCRUXtkx2uaFX8zvRphUFlvdtR65eBkEnwR7fRtApykVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=otVhqmfsa6kHCxiZctiAMQn/9Se2AMwdRbY0Ogo4lnE=;
 b=ozzWEu9sq9Zgj2PGczijvx/ZjlqRQ5gfhVQ4vGwLq6rxqa/AgRTkx1hp1umuR6ZCmDnKdoHKZGr/OLOPZdnkv2PJHG1m/1X85aqiYUe8MtxepgXtA5ZCmQOTgqR1KWwyQCDopGLkGuV1LGuszKM+MRhpcmYLWlR+oWUWU5u6lUYxlYuPJ4cg97jwifAubaUCfTEU0kKlQTaYdGBvwqv4/gB18m0IjK95r2mEMVLv/RFJoLTMMOp2coG0FBUU+n3PcdjaigclV8wwR/y3rRlmBJnT41SfyJTr7DfECBiphMenMiCRtSpQk5kqoYokpPGdGOej0zVXP5nmQQccA+6DLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otVhqmfsa6kHCxiZctiAMQn/9Se2AMwdRbY0Ogo4lnE=;
 b=zN+hHPqisNH9Mc2ULZQ3FEt0f5ANHthgd35VnzeS+tuxqwVbvcgI16T3WrlVc7VyOY6nwxyYT/kxE2idouvey3vjZ3d6whG2R+Hd8ZF5Rsf3rIzPZgnBNyCzRNp0JWnjml+5acsTIPMISRChdva6RyJjcm1ULDZeRXjtj0q7v14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 LV3PR12MB9265.namprd12.prod.outlook.com (2603:10b6:408:215::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 12:38:31 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8026.024; Wed, 9 Oct 2024
 12:38:31 +0000
Message-ID: <dff3c173-e62a-4ba5-8041-f01de0070344@amd.com>
Date: Wed, 9 Oct 2024 18:08:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <20241008191556.GNZwWE7EsxceGh4HM4@fat_crate.local>
 <8d0f9d2c-0ae4-442c-9ee4-288fd014599f@amd.com>
 <20241009052336.GAZwYTWDLWfSPtZe5b@fat_crate.local>
 <a1b2eba5-243c-4c7c-9ebd-3fce6cd4c973@amd.com>
 <20241009103821.GEZwZdHeZlUjBjKQZ5@fat_crate.local>
 <20241009110224.GGZwZiwD27ZvME841d@fat_crate.local>
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241009110224.GGZwZiwD27ZvME841d@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0246.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::16) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|LV3PR12MB9265:EE_
X-MS-Office365-Filtering-Correlation-Id: 2137f4af-1541-4136-898b-08dce85f4820
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHB1Vk53aytZcTdYRnlSZVY4dlIvVDA0aWd0NXV6UUM3RUZ0RTBrOTNmcnRo?=
 =?utf-8?B?OHJJWURrSHlWcU1FdmdpczhScXVWRTJCSHJkVlZtSWJidy9CbWptMWpXbXdB?=
 =?utf-8?B?NHEwTFBmcExOaWVTVjRySEJsOFBoUmFqSHlaS3RWTDFHZDZGS1ViaTcxMmRM?=
 =?utf-8?B?ODJqY3VHcyszZEowWWJUcHBBdEFMQU9tYktUa3l0R25oTU83SE9rK0ZDRHpl?=
 =?utf-8?B?bHgwTzhPdmQyRlRTN1NOQ3I1ZmpweG9jK0ZFZ0pwOHJqakJoNFFZYkdDT1JC?=
 =?utf-8?B?QVo5bHo5WEJPUHExeVRVd2Zpcm5sQTJlb0RLclBmVUlGNVJqR2FuVHhJOGRF?=
 =?utf-8?B?ZVJLcEw5YmlZS081M0Q3RlkzOEN1M0VIRHZIdndIWGFzM1RVbmMxNE85SE12?=
 =?utf-8?B?Y2NTTkQzR3QwcHNYUzhtTitSQi83amNKZHh1VVYrZWN0RmhVMlpoZWZTOTZO?=
 =?utf-8?B?ZmxGNTQ2cDlwNjlaeTZOMnVuU3NOczh0UlZkUzduUHBoRU01ZU5QSUwvZ3Nl?=
 =?utf-8?B?eDNJSmVqQjAwQmUyVTIzYmZvM3phTDFuVlgrcjRScW5OZG9Udm1VcVlCOTd5?=
 =?utf-8?B?QWtKRTA1Z0NVRHpRMVBsdzJHTGNOZVhGckZNdlJMeXVZM3krUjRycG5xWjV5?=
 =?utf-8?B?dmpodlIzdUFPUXVENktaTmczL2pNM0tXMWxHZ1ZzUS9VeW1SejN0Zm5BSGNr?=
 =?utf-8?B?ek1PUU55Y0QyOWxPRlF0RS9iTDNyaE16ZTJoOFhuNXkrQzZwVXJ6eEcwWlNU?=
 =?utf-8?B?SDhRQjFQb2ZtS2FlZXp4L0F1M3dzWHJPOHdERk1EY2EvcFVkVjZNS1p0SktF?=
 =?utf-8?B?T3lyK0p5SGYrR2RsNkphN1ByVjBWbEwyemcvWFA3bEoxVUxjRW53ZjRsTXJI?=
 =?utf-8?B?aWM2RmVJUmV4Q0Nob3lLYU1ha3phWUlmNVVuNS92U2Y5NVVGaEhDMmZvM0My?=
 =?utf-8?B?eGZacklMdnFrU2lIbzMxT2VGY1l6RFJwM1U2ckx2amVqS3d6dnJ6eDFPblJh?=
 =?utf-8?B?YmROSE9yaWFTT0tBSkFzVEgxQm9iRnpVYTJNd0F4Z1doQW5NVHlZcWFMa2tZ?=
 =?utf-8?B?SGlwNlpodU5uNWFnTHdGRzJpT2c3aXJUV0s3S0IwZXY2ZVorVXo2RE0vUW5u?=
 =?utf-8?B?Mm5mYXRzbzFRUnVGdjMzTWJQMkZvZ1Z3Y0lXa0hpQWtvdWN3WmpUcmp3NWxI?=
 =?utf-8?B?QjhRaUhjZDRDWXlJQlAyT0dtenF3VTJlOTJkNjNhTEE3WFNXbjRoeEN1d2FD?=
 =?utf-8?B?YmZYVGVTTnZmeDZWMHNzWTM0bElndWxFZXQ1ZEhvN01CNGZvbzMyZEdKbW9S?=
 =?utf-8?B?NXBjRjBlQWpuTlN6bGF4dTcwWGZkdVRuRDZUdUprdXRnWkxrZWR1dkdHOE9E?=
 =?utf-8?B?YjJTNUxTRVZDcUdUY1VNYW5FaEdvUVVIeTdsTVd2S3VWYjkrc3FHSzlRalpr?=
 =?utf-8?B?RmxVb005SzZ4alg4NGo1d294ZkljK2FTbjdQMTZRTk5MZ0VMNTladTg1MW1B?=
 =?utf-8?B?RStndWd4UjVweUk5S24rTkpZZDZIWmM3VlVzd3cyV1cwbTkxaDFRSXNFK3lW?=
 =?utf-8?B?d0RnMjUxTzcwZDhYc1BuVjBLNHJYMDR5MkJETnhlS1pveDZWZEVReDhkYW1l?=
 =?utf-8?B?ZzNzNWRjcUNRYTloTllYZnNnd01hSnNCTVVzUVBnK0F3ZGdqNSt6UWRJNDV4?=
 =?utf-8?B?UXlsbithaWFxNXE2Uk5sUGNPRmZQVGM4WVNhY2xzcjZjWTV1c3h1RWFBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUZQTnRYQzNoRk40MHM3Rm1lMUhta2F6aFhCUlFKa0hCbzZySGhUaHZtY0Ju?=
 =?utf-8?B?L3dZc0ErUGh4MXgra3Jlc1dIeS9UUW5URjFaRmZMTFVVMTJlY3I4d1dCSko4?=
 =?utf-8?B?bXNuQmZVQ1R5UEpRa1k2VVR3MEg1dkNYUS83Z0I2akJ5WmcxQmhKTUpCRi9R?=
 =?utf-8?B?QUo3RVkxaHEvMXdtS3VoYkRKcjRMZk5Nb3RTTC9aQnhFbnRpdW8vdjN0RHlu?=
 =?utf-8?B?S1dCN2pVL3dGdmxleFBvbTlTVFlmUVdLZCsxN1BqS241dlY3ajUzTmFUSkpB?=
 =?utf-8?B?MzJlUGZqVko3aktNMlcvcTBhbWNqVEZUMkEvSXdUSWZ0VWJjdUhDNGRKVS8w?=
 =?utf-8?B?OWpSUmNNbHhGMzhRR1ROanFYUVhvZWhta1VMU0x4NjBYTkRmMU40YU1MT2JW?=
 =?utf-8?B?ZWZwMWZmMmxhby9BMUg2TTR1OXFNZnBrNU5Ua1k2V3ZoZENiYkc2Q3I5b2oy?=
 =?utf-8?B?QmZISkV3Wk8xYSszYXJRMWk5SEFUMmg4bGZObk9oRHlRTEh3NGRXNS9vTE00?=
 =?utf-8?B?UE5vT3pjd3djQ0pUSWRoM3FLRXVRSG05TVludUZQY2JOdGZpTTZYNy9ZNHhM?=
 =?utf-8?B?eUV2aFUyN2trMWRreEVReHk3Rk02L0ZManNkcnN5QXA1ZjBqZ3ZwWXJSVzFm?=
 =?utf-8?B?d3BxdnFibWUyZEVnQW9ISE85VkhiUWY0dlk3WVhvOHlEOTBUd3NLbzVFUTBQ?=
 =?utf-8?B?MFVWMXdudncySXd2djhlTVhuRkZhOE4wSERvU3hwWS9uUU9JdFhwQ2IvNWVE?=
 =?utf-8?B?OU5ETitDblhuZkxKYjdnRGJGcWQrazkyeVBzT1hKV01NUElKMDdYaDhMcHBl?=
 =?utf-8?B?bDhsZExkSFhKRi9VWTY0eXB2SnovenZOTEUzNEw1L0MrajdXZ0EzUjgvRjB5?=
 =?utf-8?B?Y25Ed3MvSWU1NUF4QlZGOXBxdkp0V2NoUE9LY293QWpGekhsNHJsZjFCZm84?=
 =?utf-8?B?SmtmK0tBMDk3Uk1sU1ZvODBMOW5QM2x1UGRhbUxGdytmc0NvWGV4YkQvV0pz?=
 =?utf-8?B?Rlc4bW9XV2xoWE5NVWJNWDZwVkgzRGdLdWRWcnFENjRCdTZONVBHNVZTRXlt?=
 =?utf-8?B?SWsyaE9vcnI1U0NKNmlUUWlPN2RHQzVoNXUvQ2ZQNURWcXJyZ2Z4ZGljQW8x?=
 =?utf-8?B?NXIwY0FvWWQ5STVsVjAvZEd6MmFZSER4cm5ENjJwWk9FbnhuNHRMbzhldjFu?=
 =?utf-8?B?M2R5bUkwNFloVThDWGVQb0wyaDloSWcvcTB0NWZrb2t5eWpuRHYyWWp1Vzdy?=
 =?utf-8?B?dVg0N1N3bS9MZTc0Y3cyRkl0NHp5VWRIbXp6V1NiSDU1ekFsdkNRbFBCRkZp?=
 =?utf-8?B?N0ZrSUduaWJMcWpKQnRNaHBKRllUdWlaOGRaOWhKVVBIRFdrc1JoN1A2cElE?=
 =?utf-8?B?OFAzMVRHZ3JiY1NYY0t0ZTZibzhJRFpLTUNDSDdtcXhuZjhBMk84T04rN1pV?=
 =?utf-8?B?SlFhaFhWZzZ5SmVTNUdLQ09DNmwzZnVEU3NkbGVPT0hMUWhrUWc3OGdIZDZZ?=
 =?utf-8?B?dFFTZVIvVHFBU25seUVBVFVOcS9IeXBRbDNPY3B0RGRlSHNKdTN2TXRjWnVh?=
 =?utf-8?B?dVpYWEljWUk4WXFwVUNYL2ZLMFdIam5pVHlRNXVCS3dWLzZtQkluQXJvYWZW?=
 =?utf-8?B?SjhtUzRpRlZXQ01oQzBaSkJxZmE2MnI2UG9xZUl2blplaGZmbXNrSUFpZFIz?=
 =?utf-8?B?dVJ4NHNXckhtbGFrSThIc21jNFd3NTlDZFMyRk9qOVVXMWJGbllHRXVIY01v?=
 =?utf-8?B?bXJESzZ2ZnlGRFhtaUpkTHlacHdSVjh3TVdINTZ3NkVGL2MxdDlSazBXVU1C?=
 =?utf-8?B?UzlqeVA1SmF3MG1LNnQ0RHRQaTI0L3BlUTN3MkxaQXQrSk9PaTYrelhkZ1lt?=
 =?utf-8?B?RHliaUZLb05EdkhZNzBTWEN6VjFwMXFJaklsUVVWeUNTZmpMcVJ3NHJ5eUo5?=
 =?utf-8?B?dVVrYnV4Rk9OcDJzaXZvMTVvK0F0V1ErTCtwVWh1R1dudkkwd3JTTVp6d2h5?=
 =?utf-8?B?NlRXdGJjOWVSZ1dMWFBSYUhFSVcvOE9iRk5BR3F3V21PTzZGNE4wOTBBT0xM?=
 =?utf-8?B?RStMZFpESHRMUkN2bzVHdlNnNWwwdnlmL0tDVG9Obmlac2xrMzZNRGZ2MW5S?=
 =?utf-8?Q?YM15aH7AKfVQ18gVNQygPNGeg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2137f4af-1541-4136-898b-08dce85f4820
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 12:38:31.3090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /fY1WtzFqnQA0X5ILfubrndoNSMEC52XG7efc6bNYi44uUChs3Z0RC13ZEAsyS2bonPWPVNr4djG8WGym0DxFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9265



On 10/9/2024 4:32 PM, Borislav Petkov wrote:
> On Wed, Oct 09, 2024 at 12:38:21PM +0200, Borislav Petkov wrote:
>> On Wed, Oct 09, 2024 at 11:31:07AM +0530, Neeraj Upadhyay wrote:
>>> Before this patch, if hypervisor enables Secure AVIC  (reported in sev_status), guest would
>>> terminate in snp_check_features().
>>
>> We want the guest to terminate at this patch too.
>>
>> The only case where the guest should not terminate is when the *full* sAVIC
>> support is in. I.e., at patch 14.
> 
> I went and did a small C program doing all that - I see what you mean now
> - you want to *enforce* the guest termination when SAVIC bit is not in
>   SNP_FEATURES_PRESENT.
> 

Yes.

> Basically what I want you do to.
>

Cool!
 
> Please call that out in the commit message as it is important.
>

Sure, will update in next version. Thanks!


- Neeraj

 
> Thx.
> 

