Return-Path: <kvm+bounces-33461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 556219EC137
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:02:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ECC82817D8
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 01:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1430A7E792;
	Wed, 11 Dec 2024 01:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aeM3UhAG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2055.outbound.protection.outlook.com [40.107.101.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2262451D8;
	Wed, 11 Dec 2024 01:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733878917; cv=fail; b=VgwXBpeYDxwdN0OM1cRevSIULqItwNVcqYp4TjIkXNLPhCTq3uCMFAF68nYmwfcOJW7LUZD2B3S8Sk6iA809kDMIVlz2Wk5Lf3m/UGBCmYYzW34ZvN1eiCxFiL/XPXhrytk1fygxYrKitsvH7ZY+Y8Eb35+tNY7K82fNpeWIIEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733878917; c=relaxed/simple;
	bh=2Y52+MT3mJw3meatKLZYwZl3xJYsUyUnWfOfOluHiN0=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oHSTk7CAfA9Lzo30Pygf/lE7DT8qZMIdR4u7YED0r6wWEUKCFobJo8tl+EQeAIUEBVBc7CRJJClvUxf/P+4PgR+9vHHggm0XdJlc5j81e744/du6YT8sfbBHLYPFHd5l9u6b9unf0Vg1WTCOahHb41VS0ZBTNEIOhriiOC/awjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aeM3UhAG; arc=fail smtp.client-ip=40.107.101.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MqKwMg4B7KRtMAJ8Pijdl61E7lUizugU5sMHSe6Fejh7pk/orLW41lcS3BqXzVkurRy/BsTP/ZKIBP0WYS4iCZTbmUOxUjqxsXarDESfFqwzWFYPKKP72QUy49iStbYHH8cOQLBuqaYad1A0ZxDncf6GkhtwLahS9ghxrDI4rk8iGYIT8cGUTNBqbYs5kNhQu72FgKj2n9wyitx1ut+G0hFCfz9lXtRQ2ObPQdDx5f517WLEjt8g9fGPiRKppqGZBXluTT7nnujDxHj/owXGqcJ8BKiwTWszZ4aqY9FrnmNpi/Wxf6Lp828pR6VQWcEq3fLiOW6CW6z/IW8xfeiuLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nYOb7cQKZJ9UTjo/ew0QrFw4oSISgdfJc6o5EYQFDw=;
 b=ptCNdfeL3BDt7hK8gzr/6lYLVHpveNZVsDmfQWdGjZECyO55XWW05QFgHfUPUqQfgVj/dL7HfSL7A5cPi8GF/aiUi6Q2F1sHxLz/fJxxxQjmLhPiTD6PopTLczs5oCrFZoFHsjaUfJkMK5HrULFdh4Z3TdD+1SQl6MW4tgj2kx0XGpIik+mjT1gehwi4+zu/bLSb07jfDovBEJKINevO+mYekKD/l7AnuFG/k9wHLJFqMeValBm0oBdNna8SCWOikxnUI9RKKNkED6Myt/+fL2j/2Rxm67HCRd6Alds1YRYpJW5B/R+JgOtvlwXKCPica5nPUv9FZYnTfJLdn9XHbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nYOb7cQKZJ9UTjo/ew0QrFw4oSISgdfJc6o5EYQFDw=;
 b=aeM3UhAG3R991NQ9zMoVyOUApwAkMira0bW/SUn13eoFIEVDiaTW0JRg/aFJEDgBSaBH7dVej3Ez4svoBBR8VsEAicn2Mpy1ewmdad8QvB+M15xaRsOVYFQeNMfpGOSaQPNFy17uJaEGZFUB6Bt5vKMHEz7GBnVtS5ntFhhOEjg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by LV8PR12MB9450.namprd12.prod.outlook.com (2603:10b6:408:202::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Wed, 11 Dec
 2024 01:01:51 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8230.016; Wed, 11 Dec 2024
 01:01:51 +0000
Message-ID: <e27a4198-ee94-4ca1-9973-1f6164ed4e64@amd.com>
Date: Tue, 10 Dec 2024 19:01:49 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Peter Gonda <pgonda@google.com>,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au,
 x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com>
 <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com> <Zz9mIBdNpJUFpkXv@google.com>
 <cb62940c-b2f7-0f3e-1710-61b92cc375e5@amd.com> <Zz9w67Ajxb-KQFZZ@google.com>
 <7ea2b3e8-56b7-418f-8551-b905bf10fecb@amd.com> <Z1N7ELGfR6eTuO6D@google.com>
 <5b77d19d-3f34-46d7-b307-738643504cd5@amd.com> <Z1eZmXmC9oZ5RyPc@google.com>
 <0a468f32-c586-4cfc-a606-89ab5c3e77c2@amd.com> <Z1jHZDevvjWFQo5A@google.com>
 <8dedde10-4dbb-47ce-ad7e-fa9e587303d8@amd.com>
Content-Language: en-US
In-Reply-To: <8dedde10-4dbb-47ce-ad7e-fa9e587303d8@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0011.namprd05.prod.outlook.com
 (2603:10b6:803:40::24) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|LV8PR12MB9450:EE_
X-MS-Office365-Filtering-Correlation-Id: 45768b1c-4184-4369-1542-08dd197f656c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3labjN3eGgvOTViVUUvaDZDVk1VTEdwOTNTNGNqS2I4OHN4NU9FeVkrQnJm?=
 =?utf-8?B?bmtzN1NoOEFpd2NFZ01MbW5WUHZDQm41WTBMb1R6RXdiRnBDeTFXUG10YXNV?=
 =?utf-8?B?ekQyWG9oRXFrUDhaVTJ6RmxMNDFMamhqUU45ZGRHNXNOSXE5RStCZVBiUHBv?=
 =?utf-8?B?SWhlcHAvdm90aWNweUZjckVkZnBmNGMwZm9XdnJrL21NOTlkZTlJZEVxZ1Er?=
 =?utf-8?B?aWJWYWJOanZOckRGVTNOUUpkRWpCNENaUDB2bC9HK21DYUdQci9VNFR1akhN?=
 =?utf-8?B?L2hMeEFGRlBwNGF5ZmRBTHpBaHZNelhGSGNMRXRjaEljTktRZkQwaGdxN092?=
 =?utf-8?B?SDBESU12SE9DMUlUcVZjT09ISW9Lbm54MExhMFdMdEtWYmdkVFp0SUE1Tzdx?=
 =?utf-8?B?d0FGaElTMlZCMzVFZ0IwZURvd1Y4cmF2NDN1c3FDNkFCQTZRdGVGb09odmhX?=
 =?utf-8?B?b3IyODUxckdmYnRNWUJaVkxoS285dHBUcnJrbWJ5REZvOUtUVHV3blhRT2Rq?=
 =?utf-8?B?ZFRycjVNeHVQdDlwRU4rK0xRSzFXOFMzZEVJM3U1eTY2M001Nk52Vnlab2Z4?=
 =?utf-8?B?dVVScWJTRW85blVWdmJ3aXFMRlJIMkZaeFR5MW5oZmdXbDcraGRLclkwSTIw?=
 =?utf-8?B?NWl3M3Fad0Q0VFg2SkhkTGhYNWVwYnRkWkJITXNRK0c1eHdJeHZHdytCejFw?=
 =?utf-8?B?UnVXbmZhcGZHaFFWWFFqYjgweHFUK0tXc2ZDK0tJeEsxMjMvNVRlRjhLL3p3?=
 =?utf-8?B?NVJPTzcwTitTdjJWaCt1ckZOUVE5d1lRYWNCZzlIeWVpanBLbzV1SkljbWZ3?=
 =?utf-8?B?QW1zQkJyenlkeEJhcXNQMkJKVThUbEFhdG0rbmd4ZWpiNkZsQTNLWGt5VU9L?=
 =?utf-8?B?MEh1dVE4K2YxSmdMeVBVT09LYmJNTWFiOXFQb1RFYjJ1ZHlZVW02QTAxOTJ3?=
 =?utf-8?B?VWM5WC85K3hMM3krMkF4eE9aa3dyVEUxNTJvSlcwcis4MG9rc1lYMnp1YWQ2?=
 =?utf-8?B?cC9WZzRBbnRsaUYxbnJldHYvMnRaSjlzRE5qMVJHUVVZRjFIK2R4NDFlM0JM?=
 =?utf-8?B?L2xOS1RPYnNGdHZoVUtyVm5IVmtINk5DblZCOE9pRVZKMWpTRnJNMVFQdStz?=
 =?utf-8?B?aEdRb1IwQjJ0K2lJWjRGRTBLbWtXb2VlcEhPUnE4WWNOczc2NXBQeThNVzlv?=
 =?utf-8?B?d1g5aWhjMzdGdEdwaXVJVHYvamdHcXQzUDAxRlB4dXBsM0ZqZ0dDWlQwN2Iv?=
 =?utf-8?B?Um5PN1BhbDhvUGVQTzNWaDhGelN3SE0waDhuWUsrUnBpbWtRQ3JTZ3NPY291?=
 =?utf-8?B?TVZWMDRrN0lUU09ZdjFVcVVvdDY2SC96ZXZiVDRwbU5YallUNlUwZUlpSnd3?=
 =?utf-8?B?QnpUak1CVDNzSWNLM2QvUXNkTEtUWFl5aWoxbTVyS2FqdEFoVldnY2MwRkFj?=
 =?utf-8?B?ZE5LTDVXRkJnSCtvejJZSkk0Z01MVHBaYkkveklSS1JVRmVZZGtkT0dUSldV?=
 =?utf-8?B?a0xYUndrNDRzN3Bpa3ZOOWhJQzIrenNZRTlsOWMrbDZmV1BLcDRzRGNoTkQ2?=
 =?utf-8?B?ZVZlSnVHSkg2WDFUZkNTZlBJbnBvS1dBN3NnbDJTVkFEUU1ENXRLV013YU5t?=
 =?utf-8?B?MEIrRzRRYTRqRURJSXNKL1pHNEpNb2JQVHJkWFMwNjRSSmhWZWtjdzJOcHow?=
 =?utf-8?B?TzJVdUNNQ2F4b1hreUx3TWJjN2ZHYmhTMlNkZnRDd1FMQkJXVDhjQTBGcXJR?=
 =?utf-8?B?RExtL2o3ejE0Nzg5NmVwejdlTHpTM1g2dDRFd2t1RUhOZnFZUlVNZXoxRDUy?=
 =?utf-8?B?RjduYmpVWE1mczVaSnhoQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3lrZGhmdS9SM0daekYzaTh1aU5wM3dJbk9ER2I3QnhlTk14ZWw1N0xSU2xZ?=
 =?utf-8?B?WE9VZ3Y4Ulc3T3NtNEcyYnMyRHBEVUJRM3I0dWZBTXVOMU0zdlNYbzVuSmFG?=
 =?utf-8?B?bENRN2J3L3Jud0R5bjBmaUQvNkk3d0ZkdDY0Nng1aSthdzhEc1I2SGRBb2kw?=
 =?utf-8?B?R0p6ajIwcWQrVzVIYkdYQVJqdENHOU1FQkJzUVR3bG8zVVkvQjlickFYaTFU?=
 =?utf-8?B?ZG5HVXo0NW9QSlZPVTlEdUF3RHVLY28yMENmdmVmR3h4YkE2WlVCV3hOU1Ja?=
 =?utf-8?B?eW5Na2s0eEhhZE1QZnFNQVlLaVhzbTIzUkdLQzI1UDNnOHp4bDIvQlVEN1pN?=
 =?utf-8?B?QWkwNEg3d3oyQ0dBL1BjaFl5MEhNYTBGeUU0QVh0S245bzVaYU9CRU5RQXVZ?=
 =?utf-8?B?d0o5WWR1ZmxYTVVIUE5KcFVQaWlJQmZBc1I5WnFQRXpVQkRtWDQyejgvS1Jo?=
 =?utf-8?B?Q0docHZudXVOU0psMU83aHNHSm5kajJJY0thVmZZQkVJS3JMVnJNdURDYUJJ?=
 =?utf-8?B?TlVVbmJSdWZyUVJ2KzRycktqN1BHOHIvUDlObjdRMjFjKzNmM1A0dVlpbzNF?=
 =?utf-8?B?MVFXN3c5SFI1SzJ1UlBnYytrT093enJTWkZHQ2dHemRsV3hwb3N1WlVjKzNI?=
 =?utf-8?B?a090NER4dDBkY3N4SDMrdDZVTEo1YVBncDVaOU9IbTFGZHEyazYrSGtQUUd1?=
 =?utf-8?B?VnF3Nmg1Ny8vUXhkMnE4T0NoSUxyc2FmbEZFOGxBamlYZEtFWVNpdFdDRTl5?=
 =?utf-8?B?NE9hQTZFZys4emJJZG5oYWFVSTJ1ZElLdzhFeVdEU3g2bk1DbCs4Q051b1Qv?=
 =?utf-8?B?YlY3dTNYdmpVVEhCTXVNVzFJenB6NitMV29TU1V6YWhzZkhMTExWS0xHZGI1?=
 =?utf-8?B?UDhhVDlJc2V3b1UvUlp0MkpFQmFZUDJTUXRKUnprUHRmaHdvRDc4eEQ4MWFs?=
 =?utf-8?B?djBmRW9TTDJSMDVkNnJqdm5YMy9JQkk2V2VGNlh6dGN4bHgwcllYbWVabTht?=
 =?utf-8?B?Ky9ZUHNDVU5talo5VThkWG9sMjhuSFhlWjB6WjlNT250bXlzdUZlb2diMHc5?=
 =?utf-8?B?RTBrTG9UNEhsbi85UXYrQVN5WEQzeVlhRXFKNHJrcTdJQ1k5KzNZOGpYVS84?=
 =?utf-8?B?QzY5VnlQeVUvZmV3VDV6cFJ4TCtyb0xnQkxUTTZoNVptWGdmd0R6N1R3Nkdh?=
 =?utf-8?B?ZGt4TlY4WE5pYnpGNCs0UDc4Yk9Ubk1UZzBWWHNQM0FxcmNjMmVJN0kzdHhw?=
 =?utf-8?B?UDcxVWg4TkhHcUpGK1JQVkoxT3I0UHJsbExnLzJKODB2MkZMTjM2NElXTnZh?=
 =?utf-8?B?b2ZTd1VTTjQvZXNaWGRYTjd6a3l4eWFRRytHT1JDSGt6bDBGbDFtMHFESGhQ?=
 =?utf-8?B?MW1NOWYybnlreTR6eVBvSmx2TEpQYW9DV3ZWMFdFZU9nTDhGWWcxTjhaWXpI?=
 =?utf-8?B?clVKam9vcHNSWkEwSm95REIxOWxuUTJTZzVXY3labHVqUnRKdUlyNG0yMnN3?=
 =?utf-8?B?ZFV2RU5KNGtFb1JEVjVCa0tobHBXTlJKWnRKR2p0Sk5zNm5qY0RrZUp5bTJV?=
 =?utf-8?B?bXVVa08wamZQQzJXb3dVWWJaSXBCdlQ3MDZPcEdxQjI1UDRpdVVIRHdQSmd5?=
 =?utf-8?B?MXVHazZUS3dmK2E1bnJLc3hGTGZBOExYUEJyUkp0TThkUUJjdXRiUzdGTmx5?=
 =?utf-8?B?Z2NlQlZIUzdXWXBlOFFiZ1FjclRYQ2RFWis1bC9TYmlpN0FrYzlhYzN3S1RS?=
 =?utf-8?B?dzZ0QTdhRlI5cWVVRWtXeUxrbDR2WDRKV240Q2JHUmU0L1JWaWpXTWFLNUhT?=
 =?utf-8?B?VXBOcm1IZmVRZUIxUjVOTDhHUFY2amZMV1hSejB2RXltcXJrc1RzYVkvMWo2?=
 =?utf-8?B?N09WZTlRazZtd2FFMWhDKzE0RERLalZRSnA1eFIvVHlQanVhbDMwWVo3cGdj?=
 =?utf-8?B?ZTJ6Y0JDdjliRlgzSnZMWlJvOXZGM3JMZWNiOUZuZE90R1FneUtVbmhCRjdO?=
 =?utf-8?B?ejNVMVYvaXFCOE1zamYxelh0ek94UzZlWkUycjVrdVZlMEZ1QllROFZxaXIy?=
 =?utf-8?B?K00xNmZVUFh1QnNWSHRhWHhxN0hYd2tjQjB4WWc1ZFU3NFc4eEtXR3Y5TnVT?=
 =?utf-8?Q?oDpdTKZqbr+Vt7Ukexj/NmnOa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45768b1c-4184-4369-1542-08dd197f656c
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 01:01:51.1003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KmH0J9alrBGTKQFgOpwvobe0rNPwJ1gCTeh2yGDXu4BDR2XRNkmLNVpMV3FoM8d18oEvlAXD9lkKY0lpr1xaEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9450



On 12/10/2024 6:48 PM, Kalra, Ashish wrote:
> 
> 
> On 12/10/2024 4:57 PM, Sean Christopherson wrote:
>> On Tue, Dec 10, 2024, Ashish Kalra wrote:
>>> On 12/9/2024 7:30 PM, Sean Christopherson wrote:
>>>> Why can't we simply separate SNP initialization from SEV+ initialization?
>>>
>>> Yes we can do that, by default KVM module load time will only do SNP initialization,
>>> and then we will do SEV initialization if a SEV VM is being launched.
>>>
>>> This will remove the probe parameter from init_args above, but will need to add another
>>> parameter like VM type to specify if SNP or SEV initialization is to be performed with
>>> the sev_platform_init() call.
>>
>> Any reason not to simply use separate APIs?  E.g. sev_snp_platform_init() and
>> sev_platform_init()?
> 
> One reason is the need to do SEV SHUTDOWN before SNP_SHUTDOWN if any SEV VMs are active
> and this is taken care with the single API interface sev_platform_shutdown(), so that's 
> why considering using a consistent API interface for both INIT and SHUTDOWN ...
> - sev_platform_init()
> - sev_platform_shutdown()

Which also assists in using the same internal interface __sev_firmware_shutdown()
to be called both with sev_platform_shutdown() and the SNP panic notifier to shutdown
both SEV and SNP (in that order). 

Thanks,
Ashish

> 
> We can use separate APIs, but then we probably need the same for shutdown too and KVM
> will need to keep track of any active SEV VMs and ensure to call sev_platform_shutdown()
> before sev_snp_platform_shutdown() (as part of sev_hardware_unsetup()).
> 
> Thanks,
> Ashish
> 
>>
>> And if the cc_platform_has(CC_ATTR_HOST_SEV_SNP) check is moved inside of
>> sev_snp_platform_init() (probably needs to be there anyways), then the KVM code
>> is quite simple and will undergo minimal churn.
>>
>> E.g.
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 5e4581ed0ef1..7e75bc55d017 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -404,7 +404,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>                             unsigned long vm_type)
>>  {
>>         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> -       struct sev_platform_init_args init_args = {0};
>>         bool es_active = vm_type != KVM_X86_SEV_VM;
>>         u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
>>         int ret;
>> @@ -444,8 +443,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>         if (ret)
>>                 goto e_no_asid;
>>  
>> -       init_args.probe = false;
>> -       ret = sev_platform_init(&init_args);
>> +       ret = sev_platform_init();
>>         if (ret)
>>                 goto e_free;
>>  
>> @@ -3053,7 +3051,7 @@ void __init sev_hardware_setup(void)
>>         sev_es_asid_count = min_sev_asid - 1;
>>         WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>>         sev_es_supported = true;
>> -       sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
>> +       sev_snp_supported = sev_snp_enabled && !sev_snp_platform_init();
>>  
>>  out:
>>         if (boot_cpu_has(X86_FEATURE_SEV))
> 


