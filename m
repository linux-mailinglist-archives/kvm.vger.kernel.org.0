Return-Path: <kvm+bounces-15646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C8168AE60C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 248DE282AB8
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A9B8615C;
	Tue, 23 Apr 2024 12:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iTjWrcE4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08691D545;
	Tue, 23 Apr 2024 12:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713875422; cv=fail; b=kX/aSIhJ48plQ5ujJOzZsMn4QRPT4MeehiIwbLQ196rPFIzCba3hF+GLPlaX8FIsCMaPClK2H3mGiaVISfYqLifa0iekSYSWI0py4Jok+lMpS3+31X8xTPDhIHQDBkXtk3iNaPWAYfyOkMuXDpNUJcdh1bXD2m5Jrl55y3TU71A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713875422; c=relaxed/simple;
	bh=mmjOuNUQvGeGQM8J6jIsdACYACsHwylA9vBf56cnFpk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GXKS/vYVrGZxUlI0mg7U6WfU2tiI/7JmrnHlVItMkjn2+IVT4TatAXllU1ulO7NzeQY41wtXYVbl4cCcbKEeCLookbnHtP18mb9mccNtdEP+Zs+kbvzVdkUdC4V4VSmvoyFcC7ZplsfYoqTh9GXO7OtfehVaOI/oTU1Sa34XdoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iTjWrcE4; arc=fail smtp.client-ip=40.107.220.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApQe4hheciE1szA90mV65fP75+kkAlvxPV+4CZr9w5dgkJ9P8fZn9A66qmlfktL3KhAJY5zCGq5umZmL/e+7ZdZsKCCqGGiiCNMoJByfdom+WrOfaogjgbUo69esqmMsKP65Dc3hkwA2V7j7QZE2+QBtCArYZaRst7dF06OIcWp/FZYx1bCXwQxi3j8hdJdsakOGgIaFjzXP3gOAkbwBfBsbMSwUWmlFx2EoLhDrlTiiTj3GPkNFLr1zvPAv1rhr1t/H2FYwTB8UFUGxOeRlo7Rsgtb9J+cI6ISPNSXwQWyOUUodoIBPAKn66a+gbz/f5OxTnFViaBVltP8m7eghiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4VyiHQLBssfvZjb4lKrQXLIbwvlaOP7CL2ABoABbxZM=;
 b=H1I+EMehslpDvcTOTys0bKFBln2FAWhlC18rAOFR1g3zSpe7U8sRYix476OVhg0bKIhbjDw9xLOLG8Z4QLEUyjGdvzc3lVCpEzyMe+Ja2w9LwDgz/y4mNTiz1mLWZYhaPzjFI7YJ1bZTNWCMoNmwah2IpvqR4gbQlXu1LU/RcknnhpdLFYBHqEsG83nAskDXXB/CN5KxS2cd10BT0nP+hDfFkX4BrAyooxEkOZJ1O47DPAg2TkdpmDHGjun5XPjnikFM6d1jJ95dS3aJ7bPnQ8WfKw9o2pUjwUFid6h1GThW7YY2fMZ26NlMkwfgbUhTMaL0qpjj+zPY5ZdBQFdOog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VyiHQLBssfvZjb4lKrQXLIbwvlaOP7CL2ABoABbxZM=;
 b=iTjWrcE4a5w29pZvVTMww1qEcU4xXsLf84K4lenVpb+CIrtr+Q5AmgtKUEBvWIkxnTGpLzf89NFUoGnswb05Sy1FIvSzO/8K103lfWEyQ/84mgN/tLFWnTruhVMDrv64yKkKjBwlbnaXK3ijVSdZwqtzhzB4ADF+RYu1stl8RwULvxiE7uIgjUPkZZhIMvlk7lqiL6Nt5I3XYK757UTWGcV/GYe2rqFdLAd72XT7RMOckITsN4Kxp10Yj4F+Cb8HHzTVjF+xowVe/x3IvxL31h2Reb2f/UMp4rJxv0baj+NUHp0oxDextSN0NaGRvG2GXjDysrSq8QdgNglo2Bc/Yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 PH0PR12MB7816.namprd12.prod.outlook.com (2603:10b6:510:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 12:30:16 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%5]) with mapi id 15.20.7472.044; Tue, 23 Apr 2024
 12:30:16 +0000
Message-ID: <d0b809bc-7820-49b3-9319-18d6fbc419fd@nvidia.com>
Date: Tue, 23 Apr 2024 13:30:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/15] KVM: arm64: nv: Add emulation for ERETAx
 instructions
To: Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Fuad Tabba <tabba@google.com>, Mostafa Saleh <smostafa@google.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
 <20240419102935.1935571-13-maz@kernel.org>
 <14667111-4ad6-48d2-93ee-742c5075f407@nvidia.com>
 <4c2fd210-fa36-8462-8a4d-70135cc2f040@huawei.com>
 <87r0ewtie9.wl-maz@kernel.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <87r0ewtie9.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P265CA0013.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::18) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|PH0PR12MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 11025c0b-590c-4f8d-1679-08dc63912185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmRNa1JaVnV1a2xUejZkYk9GSU5BU0NXQndsV255OVhLQ3VTMVQzcXNKKzJy?=
 =?utf-8?B?dTR5VWZuYUx3c2YvVUNKQUlaWWcvSmplcEhGWXJmWmNCUXBaOEQ3WFlUNkVN?=
 =?utf-8?B?Z2Fha05Pc2M0MERpMDRTZmtEa1NTZyt3RjRXKzdZbWxWQVVqM1FTaWIrT3gx?=
 =?utf-8?B?bSs3ajFGRkR0b1U4M1djcXNocmpvWGYwaGphQVVLYTFSK21uZks5c3ZJaHF3?=
 =?utf-8?B?MTZxWVlKQnBPK0xqd3NWREZzMU9FTVArRG90dFIyRk9lNGJacCtXNUhmNDBy?=
 =?utf-8?B?ay9BSjZXaEdld1VVWS9EYlpPUERBckJoL0dQYTIyMm1nQ0tOR0JnL0prTkFX?=
 =?utf-8?B?TS9XSGZYemZMUE1QcitPVTF0WFJJK0FBV2I5VDR5aWpoVEJaT1I4R1k2TlQx?=
 =?utf-8?B?aGQ3ZjlFK3V2d1RrMFhBaG1qNVJ6dTFwaE9UTmhGeWMzN1QwNUU2bUxTZk5q?=
 =?utf-8?B?aENDTzRGeHIwdit1Nmpqc3pEeUhPRk5OQXNXdzEzejVpQmZqR3lDNHRBSzdm?=
 =?utf-8?B?UTliK1llN2swVHFBSm81d0VwdFJSNkwrY0VUVUpMOG81bThSa1Nod25HemRR?=
 =?utf-8?B?bTU2QW5MVXdKSm14SVppUEVoR282d0l5K1AzcGhqTDZQdkp3S0tKZW9OdENY?=
 =?utf-8?B?NmZ3OHBqeWNFODBzblZRb213dXlhUjQwcnFSR05RYTAzTlJBa1lLbkJhTjNX?=
 =?utf-8?B?UG9ORXYvUHRac1h1TFFROUFSeGFkcjZSdnErbEFjVkFCWm5CZVBSZXprbGRD?=
 =?utf-8?B?UnVEVlpiYUp3RnlsdXlBYmRoVWNXcXhJMWIxT293RGErbC9DWk1rdXBMclJX?=
 =?utf-8?B?TFI5bGJ2MDVVNGc1S1ErRlFMNTJWckxuUzhGbXVJWm5neTFlRmxTTWtoS1dL?=
 =?utf-8?B?ZGNoNlNnRVhzZnRpdW1IQ0tUTE9wWEM1UTd6bjU3SDZDSVBLQ2ozNGtwdGZU?=
 =?utf-8?B?em11d3JwREVHRHk3RU5KZHlVcXhwR0MyZjNEYmkvWVBKZ0lvQzF3K2QzckM3?=
 =?utf-8?B?SnJRc0Q4WXZqZWh1TWdwRU0vdWVzbnZqY1B1ekZja0RJamFma21Ja3FldnBv?=
 =?utf-8?B?V044Q3JlQmVnUjhabFpuNFR2bXJlUVEwWE43cEtKOGtPYXpjWUZLQWl3ZXZn?=
 =?utf-8?B?WXYzTzFvUnFxYWpObTZLaGFjVEpZa1k0T0RoVkdXTjk2ek1LejN2ckIyNWFN?=
 =?utf-8?B?NFoyODdqbGJTb2dKRk5Qdk8vaGJZM3RuTllXNVF6cWl2Z2U4ZWdKenJXZnFW?=
 =?utf-8?B?VmVUMjNEZ1M2WFN1cGVabGNTanB0bUVMcVRrMU1nbVd5T0VFdnBQQ20waHJ6?=
 =?utf-8?B?SGdIcUYyVmk1dlk4SDJvZEczTTFSdTJrSGFFWkF4WmZmRXBrdk9DR0hqTWZm?=
 =?utf-8?B?My90SHV3YU84TXJrVEhuNklnbTVBVW9EQll4QXFnVnIvajZDK0dUYmZqTi8y?=
 =?utf-8?B?NnRLcmhBemUzYXNMK1N0N0ZWVTJJRi9mRWRPVlZCUzIxejFKN1JETFVkaERx?=
 =?utf-8?B?TEsxWmEyWFdWR0l3VStOYUxtRDJLRzBHd09ab2FKbDlIU2svNXBpalArbWI3?=
 =?utf-8?B?aHl6QkZ6a2djdUxkSnFGUEZpa085Y2hIdmorRDR6czhHTVc2K1A0Y2YzZGU1?=
 =?utf-8?B?c0hXak9jWktvUkYwVWtNdDNTRy8vbE5aTDdJbzd3Rnl2dTMzSXJwcDk4RkZt?=
 =?utf-8?B?STN5S0tYSUFEWFVKdjYxQUMwK1c2dzg1N3MwZWoxcUdGVjZSS0Q3emFBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dENEdlo3cXJ4TnVnOTVta1NkcjRtVXJ4OVVTcEdvWWhTdm13SkpuYS9UMDVV?=
 =?utf-8?B?dk5xRjNYbi8vKzJRQ01FcGNhcXEyb2tpRmJLRDVpU3hSWnp1VWNmREdmdzdl?=
 =?utf-8?B?emJubmlYQ25oYjNsOXNweWcyME5HZTdIbUlFRDJkaG1qSkhPYkxIZ254RGQx?=
 =?utf-8?B?Wm01aFlGeFZNVFdJK002SVB5Uk0yVWdmOHk2QU9qRWhmZmJCOStodUQvODh4?=
 =?utf-8?B?ZThVSzZkc1JMNnlhSnVOWWxQUW5LVDZhcjA5QUJCbnJFNGtRc1dzeVNDaDBV?=
 =?utf-8?B?QWhRS1ZJQnJOWnpVLzh5am1ValRXZTJJeFpEUEJheDdOTHNVQVdCeW9qdUdV?=
 =?utf-8?B?SmI3QmxYQmpEWnE3dFJMT1pZUFdHT0NOcjJjNTBwOStNdSsvUmpOcjdpWVZt?=
 =?utf-8?B?Wk1BWHJnYVRIY2VDNGZYRyt5UWhlUW1kVERrWXVsVXB6OThzSzQzck01SVJn?=
 =?utf-8?B?L085RitpRk9FZUtwdlRRdmFTaDJ3cEJpeWcrK1ljR0dTSmNzcWpadFdJUEJo?=
 =?utf-8?B?OEZ4MGtBWHd1OE1ma3p2OW4zMXRPNmZQajYyQ3NuY25YZ2ZCSi9RNCsrQWw0?=
 =?utf-8?B?Wmtra01CWHNaR21OQk9QemsvVzAyeVFXTzZ0Z0xlWXE5RzdQaFNLVCtFSnJF?=
 =?utf-8?B?ZlRBMG5BMHlOeDc2VFhDQ3MvSXB5aXJGL2d1ZE5KbnJ4cWtWdkNOMUhCcE9G?=
 =?utf-8?B?NGVRckI5VGNIVU50VG9zQTZoU0VvNG1SZXl1UGFBUldVRjVKdXppQ251SFY4?=
 =?utf-8?B?NURtb0owNEZHcWtYaFBFOFBNUkNoSUdnU1o0UEhWL3hYdmZwTmZNbmYza3Ur?=
 =?utf-8?B?WDUyVDlha3JyV0lydzAwcTJlbFJPQlNqdXZrc1RKUDVlS2ptTVJDR0s2eDRL?=
 =?utf-8?B?WFBWbXlIcG5PaEJYRWFvakdreklNQnd0VUJsNnBQQW8wZmpSSXQyUU9LbDYx?=
 =?utf-8?B?ZVZKRW9mWHY0Zm1EYjZFdlJDQU5uUTJvVXB6TnRFSWRGVlZOT2JtRnR6aXZS?=
 =?utf-8?B?bFMrTmlPUUZxT1lRMm14KzAwMXMyUGF4WjZ3a1NGTmYxbk9qdGlpSHpvcDZZ?=
 =?utf-8?B?endpbWlNYm9TL2xqcDBjaFFSZmswMG5UNzExcE9HZTNrbTh6U2syK1BYY0JK?=
 =?utf-8?B?ckNPMCtnYVFOaUdnYmV3UFhwWlVUKzIzK0tZVG15VzlUV1lPNlFNUHJxUGM1?=
 =?utf-8?B?MWlOeVVQR0NNS3FuVCtkUm9GWkJWVjBTT2FzNnBrdlNBWFdremFzTzY4V25K?=
 =?utf-8?B?MC9STmxWaDcwZGR1aXV4bkhnUHZ4ZEl0TzhobkFZSXlOTllvZ0h4YXM1SHJx?=
 =?utf-8?B?K0ZlUDRlUFhQNmdTV3FhY3MxdWYzZ00yek1Gek45dUhoOFpQV0piYzZEWkpB?=
 =?utf-8?B?NHF1TTVUamtqalQ0ay9iRlBYSHMxMjJyUnFiL3BBZTVLM1ZCUGxlcDUxcVJp?=
 =?utf-8?B?eDBOaXNGb0tBT1pVTGpuRUt3ZnVpTzVPUkV1TnhwMnFxRnJqWWVIU0QwdExC?=
 =?utf-8?B?eSszWDFFUS9RWlFyd2hpYjZ2ZmxtRmNiS0hvQWV1Q2RwMFQ1T1dCeFRDT2J6?=
 =?utf-8?B?am90WDFWYnFObi9vM0pGR0U2WUtFSERxVmtTWld3cXNUcUNXcWQ5bElkMEpn?=
 =?utf-8?B?QVEwSW1VNVRBT0hBdytEeDV3WEtBZWdsMUhWSEZVeU1aRkhBMFBlSEdWME1F?=
 =?utf-8?B?UmFncC9SaHJsK2lZa3EycVZydXVzb1JJVktGYjI3NktiU2dGdVNqaUdzY1VS?=
 =?utf-8?B?b2tsZjhQWmlmeWwrdzlsdFByUkZrS1JjTS9WU1FUM05XeTdEY3hka3ZCYTFC?=
 =?utf-8?B?RVFCVStDN0Q1TlJmTTJUMkdMWTlRMHJZMWJoZWNOSGdNQnJHb29iNGJVdkw2?=
 =?utf-8?B?cldaNVdLWFVYRjNOY1lqRzlyTS9PRng0Qkh2bTdRN2t3RDduK2kxdUpEQmlv?=
 =?utf-8?B?bSt5ZWdNQVkzcjJuRWZINDhoK0hvN0JzU3dWR2ZUb0tNQ20yREhFNDk1Mmor?=
 =?utf-8?B?MXY0YXZwSVlTdnBSQXBKcjFkSUwyeXFEcHA5Z3JJTVFRVXVGbEJPT0ErQ2ti?=
 =?utf-8?B?a0pDTFJkdDdwM2xkdnh4V2xNczVGSTlleFRVekNBK3Roa1lRZ2kvUzg3Sjg5?=
 =?utf-8?B?NWYyU2d3WTZkNzdCbjl2QUdSSTNqU2pCbXZJZDZMUUZBOHoybGE0UHRGMFFt?=
 =?utf-8?B?c2dySlNmUXp3YmZ2Z2Q4VEV0amtRWGxoOVJuVFoxV0szM0c4dkppT0tMdEUv?=
 =?utf-8?B?bTlRbTZUQUhPRW13WVBrbCtIZ3RRPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11025c0b-590c-4f8d-1679-08dc63912185
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 12:30:16.6686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skWbTCAau5nOfZKdnDJAyuMJqKFDNU2Wz+THDKgvd5ktoG96Cc1SMZ/KNn+taYrb5TYyqQn0iiecwQ6EKUiMAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7816


On 23/04/2024 12:42, Marc Zyngier wrote:
> On Tue, 23 Apr 2024 10:40:22 +0100,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>
>> On 2024/4/23 17:22, Jon Hunter wrote:
>>>
>>> Some of our builders currently have an older version of GCC (v6) and
>>> after this change I am seeing ...
>>>
>>>     CC      arch/arm64/kvm/pauth.o
>>> /tmp/ccohst0v.s: Assembler messages:
>>> /tmp/ccohst0v.s:1177: Error: unknown architectural extension `pauth'
>>> /tmp/ccohst0v.s:1177: Error: unknown mnemonic `pacga' -- `pacga x21,x22,x0'
>>> /local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:244:
>>> recipe for target 'arch/arm64/kvm/pauth.o' failed
>>> make[5]: *** [arch/arm64/kvm/pauth.o] Error 1
>>> /local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:485:
>>> recipe for target 'arch/arm64/kvm' failed
>>> make[4]: *** [arch/arm64/kvm] Error 2
>>> /local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:485:
>>> recipe for target 'arch/arm64' failed
>>> make[3]: *** [arch/arm64] Error 2
>>>
>>>
>>> I know this is pretty old now and I am trying to get these builders
>>> updated. However, the kernel docs still show that GCC v5.1 is
>>> supported [0].
>>
>> Was just looking at the discussion [1] ;-) . FYI there is already a
>> patch on the list [2] which should be merged soon.
> 
> Indeed. -next as of today already has the fix, although I'm reworking
> it to take Mark's remarks into account.
> 
> Jon, can you confirm that next-20240423 builds with your setup?


Yes that is building fine today too. Thanks!

Feel free to add my ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic

