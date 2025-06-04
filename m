Return-Path: <kvm+bounces-48455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A04ACE6DB
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 00:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED7FB3A969B
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 22:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE371F4608;
	Wed,  4 Jun 2025 22:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QTajhQDm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7BF1B4145;
	Wed,  4 Jun 2025 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749077738; cv=fail; b=j69eAvs3/7IzajwPIQTpiZi6QMs8QVv8wBlqkBF6FhzVl6EhxAMZrT4if/piFyMQAVUcUncfAW4x50Ta5ZvxCtveP57y0mdzNHOEus8RpTdb9NQtdnHe7edKVn60pupJUJsNsqyvGYfHKusmmDTSOgUzJ0Ez539/SPPD1VpGqqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749077738; c=relaxed/simple;
	bh=Wb3zwbZb+zwYgsbFvyEEEuHf4fE7ZnXv1wNZeadVOig=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s/uQx/nLjPrWiqJpWXQzedaY8PjkA01aoSjNMPaW0mLKHrznv3MvJsUSXqvVZxXA6TUMdghDm/kRXHf7cws2ie/H/7JZ96hky674A50sThH3JmhKeWnmAwpECSca5C2HQALAFF/cLXGcGa+YdcAJkXc/cDBIE3oYU7vDECf1EeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QTajhQDm; arc=fail smtp.client-ip=40.107.92.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BFwWy8eMNqNVoejSt3MsuYX6+mAR8fPuxVs83qGJvkzJlz4ZVbIyyOTHk9BEnSjJqbBtrouYy/jLc3yLmDD7QRDqUEfy07twNUNIHRlNgKePWT6vB4asn7Goxr9GZ4wAP6EAC6kN8CaKshH7MdeezdQ9fZa1SUCYtcITJVE+0sWcmzrvKLrdcw1S023smTsIgGlFEQdDW2OHwlu2DzhgQkclobqg+SPxF0SeCSUPbxePv0LUyMn+fFSDRUImPLyAkYxvzHNXquHmB45R1sQWAc+GkiTx0nGj8w+aBwA3qNjI8Avjo+cu2frK8uX/eDMI8dsypDWcu0aMnoWTSs4fzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uESHO2/61DBGPsLOHM0sKDRy44PdBx/Ge3pIhkYCfcY=;
 b=vFzgLtU5SYp58S0tnBzIDF5xwf/vpaPkrty7QXiCT27pj6fFzM4O/H4xIkQlqXc2VfwTJYBTT+ixI34p+OUchi00QD+k6rfM96v9aCp4OALaEks2D13XehWLF8D+GNN5jBSGWsEThnfQWxKJVyzMW/SwFkjknNCbAajN7/WfryWWTVSN85D/Mp9XhgbbB+E9z+kCchBB1N9T/TfPRypWaTgjcUjjp7T0HFE+KWHceAxr09keE7zfrMavSwP2sxt3TYVvdFq4B1BJLIPon+RFEgkEK/LUE27A+1bgRRLxUfnd7N+J9VG/drT8mLyHij9E6H2SHe2EoouKzZctMDo98w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uESHO2/61DBGPsLOHM0sKDRy44PdBx/Ge3pIhkYCfcY=;
 b=QTajhQDmOwNtT+spTT5c8pwodDTfcm1YdhVREOXMta4dS84V1UHQIWf69OBVUmAY3W4yp/JjJDgV4nysr3H8pj0x9L2XPDznd5BQvSgS+y1+wJqDCscaHyBTOqVaXX2D+Wwtb3oIA9MzvzNUctkrAOsCL6ZwZJgi035qfDScNrg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA0PR12MB4464.namprd12.prod.outlook.com (2603:10b6:806:9f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 22:55:31 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 22:55:31 +0000
Message-ID: <484de126-872a-4b61-a30d-6baa73c9449c@amd.com>
Date: Wed, 4 Jun 2025 17:55:28 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] crypto: ccp: Add support to enable
 CipherTextHiding on SNP_INIT_EX
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <0952165821cbf2d8fb69c85f2ccbf7f4290518e5.1747696092.git.ashish.kalra@amd.com>
 <77350d09-1d51-2ae5-39f9-a62ec29675f5@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <77350d09-1d51-2ae5-39f9-a62ec29675f5@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR01CA0028.prod.exchangelabs.com (2603:10b6:5:296::33)
 To BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA0PR12MB4464:EE_
X-MS-Office365-Filtering-Correlation-Id: a4f7c1d9-34df-4621-9bb7-08dda3bae801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MnlQTFZiZ1Iyc3Z2YlhpU3lVT25QN3lML09NNlZVWHVuc3dBNEtzaVowLzla?=
 =?utf-8?B?dzZ3dFBvc2YvbWxiTW93K2VnM3V5TWgwbjNjYUphaHFrT2tNUXVFZG5EaDRu?=
 =?utf-8?B?UmkxeDZlRHBINjNMbnVMNkVBWXc2N3VXTU4yZnowb0hQanBGeUZLbWNrUmNK?=
 =?utf-8?B?NzZ1TjhPbXMrblhmZUdSbVhuaVpodWUxUmd0MEYxVlROV0t1VUx4dGZtL2lL?=
 =?utf-8?B?SzBPOURKR3VzK1dRcmVoekJ4RWdaWTJhQzlTSjVrZnhzS1VlUlVhZkNUMmZM?=
 =?utf-8?B?cTVhMkg5Qno4dGFmWlFqbDB0TlFTd25ia2lxc1NiTDA2WFNHcDhITlIyc014?=
 =?utf-8?B?ZDdPS2twK0JHTzBCSyt2NHNpbW82R0F5bTRncVk3cUQ3ancxajQyUUZlTUVj?=
 =?utf-8?B?dzN6Z0x2cWhqZFpGMmg3N3NNQVJxQ2pEaFRhT0VPbkZxSkk2VS9KK000WWln?=
 =?utf-8?B?bzBDQVlBa1ZxRHFxSjQ0ZHNHam1YTnhvVm92YWtaTlRxVUxwK1AxdXluQUU0?=
 =?utf-8?B?ZEFvZWxBSzFrb3NSR2JVMmFodWdBSHlrMEtLbzA0bURMYTdZZnlobm9sTXZE?=
 =?utf-8?B?eDdnUEFUcWV2cEVJOUxpOWMvVVFEOGtjOElkczJ5T050cStaU3NTMUhvUE1M?=
 =?utf-8?B?RmVubW5ZUWFoOFk5SGwxdWtyTVNHUjNzV2VBSzZXZ2kwZUlBaEY5bzdzVmZB?=
 =?utf-8?B?ckE5TlZ0TFNDVDJBN1hkUnExQlZrODZtUm5BT2ovZ1R2Z3JLcmtiNzJqTXdS?=
 =?utf-8?B?MVd1bGwwRU9sQ0tpdVdGbXNiVnN2aUlJSVA0S2pKQmN4WTZPT2tkK2V1dGZH?=
 =?utf-8?B?Q0VKQTl1cnhJOUhXanlCT09ZSkVtazhnRnl4ZHdVL1g0Wk5EZXhwNk5xb1dX?=
 =?utf-8?B?UzVDVzh4UXI2czNpaFZlSmZvYlp4MXFSYkV0dEVPbW5jcjFCUnFsU3hlSk5Q?=
 =?utf-8?B?RUd6eS9PVm95N3NuM2FMb0VGMzhaM3VzdEtRRkd0KzY4aHBuZDNlbzJnREk3?=
 =?utf-8?B?RHcxMSszcTNPNENMUVJJMmJoenU4OTFYR1RxajBwU2dQRFFlcWE0M2RMR25H?=
 =?utf-8?B?NEpWQldSM0t3STBNMnlXdTZLcEtYQTdqSXFFalZPYlFmaWx1SDVpNnJsM0tK?=
 =?utf-8?B?WkxqRllZZ0o2SXRPdEZOTjhXMlhXNXdLNk9TYXRmcTFyTUdQbThCK1ZBd2tl?=
 =?utf-8?B?U2NZUFdIZGFkU2F4SndVVEx4QVYrMFd1ekhqNnRjNWk0WWZ0QnE4SUNYVlAw?=
 =?utf-8?B?bFIvZTAxYjBKUWxTdGhqVGcydDB2ZmV0U2lyZmJjRGN5OEFtamNQSmUwSitI?=
 =?utf-8?B?SkpZa1VVWnhGOU5NQWN4anAyNnZycjI2MXcyZmoraG00TE1odFNRaWZsdVJx?=
 =?utf-8?B?cGRIbW4zSHRQYW5kSTBvWVlhVkJoYzlwMnpINXRyVzJrTTg1K0VVRnpkajA2?=
 =?utf-8?B?U09nM2JqVm14Q1dRYWQwRjFwSlpXL0xzd0o1RXozc05nMnF4RVQrUUd0Y29h?=
 =?utf-8?B?NitjcnFOeWdBZTgxTTFoSVFON0EzbnVyaWpISnc0YTFteDkzc25GSC83SXBG?=
 =?utf-8?B?aHd2S0k2NE04YnZ6RDFsNVEzV2E3Qldja0s3anJxTkhBbll3Z1c1RlY5a09V?=
 =?utf-8?B?bHlVeEhVZ0N0OVhMTnYydExQK2RzNzNaTVRpN01lMkRMVUNISUxLdmdzazlZ?=
 =?utf-8?B?YWdQamNlWGlpYjM0U0dZc3E2U242Y3k5QVo0VnJNT1FHcmFyUGhHaE0yc2FB?=
 =?utf-8?B?Tk9DcjQ4cmhaa3BRRGs5Rm12RGRJcHVvM1JrQVlWanFYOUR3d1JlOFpmaHJj?=
 =?utf-8?B?azc4QVU0Q0R6UFR5RXFPMGJ2N0d4ZXZGa2tyYmlRRzcxQi9yazAvSko4VnlW?=
 =?utf-8?B?K21STkdsMDB0WHhJaGhmM2xNQndlU0ZQNWJ1Vmg4YU9pUWYrVHFpdlRmNDJs?=
 =?utf-8?Q?s5/EU1IE6iE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDVkN2RYV1BROXprVHA3bE9WSDNHWVRFUTJ6V2liT3l1dEx0ejNIemhXMTVp?=
 =?utf-8?B?WWNrNVhucTYrbUt0bUJYSFV1U1lkTnRpQ0ppVS82dXVlN1pUMEhyTUsyQ1lh?=
 =?utf-8?B?eldwTjNtN0xtUGtWUi9EaDJJQVdpTEl2K3RodmZPeDlVbnorT0pzT1RvVGpl?=
 =?utf-8?B?V21CTWYzN0g2TW5UL3ZHNGFJK1lKSng3djd0eDJ3RnJYWHpETFFNVUovVWds?=
 =?utf-8?B?WTBuR2N3dVlTMzJXTmFxQ053Qm9XdEhNYXV4RkdCT0twMGdUSXQxUVJ3ZWVG?=
 =?utf-8?B?cTNCdTBPM0E4ZHRpYlRzWks2QWdNUWx4cDV3bUdnd24yUjdPSURTMWs4OVpw?=
 =?utf-8?B?M3hoSzY1dkpVMmNDVEFuZFlBR3VUYnlveDZ4MG5Sa1VySnhjUVNSYmRVdWdX?=
 =?utf-8?B?T0hHU1MvSTN6SzU3SFJXR01kc2s2czRhL0I5dnVyUkNiT1FTb0VYY1RhWlRv?=
 =?utf-8?B?ZmkyT1l2Qit1NEhvUzNCOW1WMXBNUUpxQ0tXaFRYWWNyQ3FneGVrVSs3WUhC?=
 =?utf-8?B?QzBLQzV0TXdkQUVBUWsrdDBBblg5K25XQWFWWFRQRHQ0K2ppaXVnbHVUWjVJ?=
 =?utf-8?B?UFB0MXFtdFdob3g0anAxM3dCOGIrbXBteHEzK0dCQy9LamhnbVN3MUp5OWtr?=
 =?utf-8?B?aEh4ZU91eDdjaDczUWNuN0FHK0huK283aUVJMTRiUDhSOTY5TGRPTVN6c3l1?=
 =?utf-8?B?UmRKOWdKN25keVVBMWJsQUR6ZU9haEVydHBjOFUwUzc4azZUeUUxbWlGYktX?=
 =?utf-8?B?VnYwTmsxT1owQWhUVXV0VHd6S25lRGFia0JVYStVY21MZXNocVNBVXpSUVlT?=
 =?utf-8?B?cTM4RHZtNGZVMVE3TWJtc24rT2NWMzFodjZrQmMyL3ZRZ2wxZlp6bHdKVmg3?=
 =?utf-8?B?Yi83c1c5ckNIRHN0Nysxb2RhcXJuaGRFbEFUMjNkREVpd2ZHZUwrVW5TRnVJ?=
 =?utf-8?B?akEraEZyTE0rbjdIY1ByRXVlS29mUFVxUGNKWHpmNkprQ0xmcDNkL2FsQ2VM?=
 =?utf-8?B?cXZ2eHJJOVpZZmJ1UlpZQVRtU1RsL2d5L1I5UDRtSG5ESWtSc2w1M3dCb0po?=
 =?utf-8?B?Rk5YTmUrSUVhWnRJSUV3U1Y5d001RHlrc1dQbzdtYjRSaUc5ZUJaNnIrTWFY?=
 =?utf-8?B?Wmo5RDhjVmdwMXJLNTd0Q3hwREJ2ejkvNTdsM3dVUTBUWmNGVU9RQWdMVHRH?=
 =?utf-8?B?SkRTeXdSUHl4cEswR3l5c2o0bE92cEhkT1FxMGNkL1hoRzQ0amE4RThIT3pE?=
 =?utf-8?B?bEtCWmNtejJTNitLM0RnVG80ZlhlY0F0Z0JHYzFlaW1yalJwaVdHZzVIYzlp?=
 =?utf-8?B?aEFqOXphMjdNRUpOb2FmMzJlQTdJTmFSNXJXQnhKajJwNHd6NStFNytJTmlo?=
 =?utf-8?B?SWVmaXFZSGtzeFZWYnZiN2ZiUG1aQ3krMHR6aVdYdTkxc1NiYncwcVVobTJT?=
 =?utf-8?B?YWJNaXRqUnNXZ2pOd3pJZkVFeTRpTFZkM20zUW12THhVWWpnWUhNczEyQVh1?=
 =?utf-8?B?Ky9YL21LQko1ZGVUYklJTThCOXhFV2hoMGNlRk9uZVVpSnRQNG82OE1xZE1k?=
 =?utf-8?B?ZUNsVC9xeXBpVDVHeHpER0tiZXdMNDVXUlgvWE92WFdoRWRQVHBlZlV6eHp4?=
 =?utf-8?B?dktsazljeUJmSTl5VEZoYlczaGhCbXJrNGtUOU8zcGI4cXdoWGRZckVMODBl?=
 =?utf-8?B?UEkxWDJUcTI4TjdoYnl1ME9zaUZSdVZhZ1EyODVLamhXaEJ2bkZ3MnAyNmpm?=
 =?utf-8?B?Slgrek8zNGhqNU15Mk1mWHFvZnpQR3I3MnUweXFPN0RwY1NSR0VRUzA4VzRH?=
 =?utf-8?B?S2FuajR5dXlrZnF5a05hdU9pTVZKRUJvUnRIMEltTEhzc1NxTncwcjBzZVh2?=
 =?utf-8?B?L0NlYnlYY0hpYW9JNEZScFVIdzN0bFl5Qkx2VWtjcHh4ZDY3a2w0RWFON21B?=
 =?utf-8?B?QVE0aWY1ZndFZVoxN2EvSXhSL3ppaHVTc1lvQmw4VDBOV0ZEcWlEdjk0cmVk?=
 =?utf-8?B?b0lwYTg5ZHhBTVhyOVZWZjIrMHo4UU1NaTV5anBGUTdHNHl5Zkk2YW51N0Fk?=
 =?utf-8?B?MGFnbmRmNHBVMTBLWnN6RWtTMm1UU2FqeHV4MUJYaEJhTG9sclM1NkdWYmU3?=
 =?utf-8?Q?6I38VnpvB5lPR2Dayr4BSHVgt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f7c1d9-34df-4621-9bb7-08dda3bae801
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 22:55:31.0547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ybXg4JwRFEJxRbR/s6Yu3UXge5wdgfllliNNVCiuuygo4VIL1cf9IW3ycMXbIq9sGv5d7hTAKEnP1Y3I5if3Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4464


On 6/3/2025 10:41 AM, Tom Lendacky wrote:
> On 5/19/25 18:57, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Ciphertext hiding needs to be enabled on SNP_INIT_EX.
>>
>> Add new argument to sev_platform_init_args to allow KVM module to
>> specify during SNP initialization if CipherTextHiding feature is
>> to be enabled and the maximum ASID usable for an SEV-SNP guest
>> when CipherTextHiding feature is enabled.
>>
>> Add new API interface to indicate if SEV-SNP CipherTextHiding
>> feature is supported by SEV firmware and additionally if
>> CipherTextHiding feature is enabled in the Platform BIOS.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 30 +++++++++++++++++++++++++++---
>>  include/linux/psp-sev.h      | 15 +++++++++++++--
>>  2 files changed, 40 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index b642f1183b8b..185668477182 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1074,6 +1074,24 @@ static void snp_set_hsave_pa(void *arg)
>>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>>  }
>>  
>> +bool sev_is_snp_ciphertext_hiding_supported(void)
>> +{
>> +	struct psp_device *psp = psp_master;
>> +	struct sev_device *sev;
>> +
>> +	sev = psp->sev_data;
> 
> This needs a check for !psp and !psp->sev_data before de-referencing them.
>

Yes.
 
>> +
>> +	/*
>> +	 * Feature information indicates if CipherTextHiding feature is
>> +	 * supported by the SEV firmware and additionally platform status
>> +	 * indicates if CipherTextHiding feature is enabled in the
>> +	 * Platform BIOS.
>> +	 */
>> +	return ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
>> +	    sev->snp_plat_status.ciphertext_hiding_cap);
> 
> Alignment.
> 

Ok.

>> +}
>> +EXPORT_SYMBOL_GPL(sev_is_snp_ciphertext_hiding_supported);
>> +
>>  static int snp_get_platform_data(struct sev_user_data_status *status, int *error)
>>  {
>>  	struct sev_data_snp_feature_info snp_feat_info;
>> @@ -1167,7 +1185,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>>  	return 0;
>>  }
>>  
>> -static int __sev_snp_init_locked(int *error)
>> +static int __sev_snp_init_locked(int *error, unsigned int snp_max_snp_asid)
> 
> s/snp_max_snp_asid/max_snp_asid/
>

Ok.


 
>>  {
>>  	struct psp_device *psp = psp_master;
>>  	struct sev_data_snp_init_ex data;
>> @@ -1228,6 +1246,12 @@ static int __sev_snp_init_locked(int *error)
>>  		}
>>  
>>  		memset(&data, 0, sizeof(data));
>> +
>> +		if (snp_max_snp_asid) {
>> +			data.ciphertext_hiding_en = 1;
>> +			data.max_snp_asid = snp_max_snp_asid;
>> +		}
>> +
>>  		data.init_rmp = 1;
>>  		data.list_paddr_en = 1;
>>  		data.list_paddr = __psp_pa(snp_range_list);
>> @@ -1412,7 +1436,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>  	if (sev->state == SEV_STATE_INIT)
>>  		return 0;
>>  
>> -	rc = __sev_snp_init_locked(&args->error);
>> +	rc = __sev_snp_init_locked(&args->error, args->snp_max_snp_asid);
>>  	if (rc && rc != -ENODEV)
>>  		return rc;
>>  
>> @@ -1495,7 +1519,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
>>  {
>>  	int error, rc;
>>  
>> -	rc = __sev_snp_init_locked(&error);
>> +	rc = __sev_snp_init_locked(&error, 0);
>>  	if (rc) {
>>  		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
>>  		return rc;
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 0149d4a6aceb..66fecd0c0f88 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -746,10 +746,13 @@ struct sev_data_snp_guest_request {
>>  struct sev_data_snp_init_ex {
>>  	u32 init_rmp:1;
>>  	u32 list_paddr_en:1;
>> -	u32 rsvd:30;
>> +	u32 rapl_dis:1;
>> +	u32 ciphertext_hiding_en:1;
>> +	u32 rsvd:28;
>>  	u32 rsvd1;
>>  	u64 list_paddr;
>> -	u8  rsvd2[48];
>> +	u16 max_snp_asid;
>> +	u8  rsvd2[46];
>>  } __packed;
>>  
>>  /**
>> @@ -798,10 +801,13 @@ struct sev_data_snp_shutdown_ex {
>>   * @probe: True if this is being called as part of CCP module probe, which
>>   *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
>>   *  unless psp_init_on_probe module param is set
>> + *  @snp_max_snp_asid: maximum ASID usable for SEV-SNP guest if
> 
> Only a single space between the "*" and the "@"
> 
> s/snp_max_snp_asid/max_snp_asid/
>

Ok.

Thanks,
Ashish

 
>> + *  CipherTextHiding feature is to be enabled
>>   */
>>  struct sev_platform_init_args {
>>  	int error;
>>  	bool probe;
>> +	unsigned int snp_max_snp_asid;
> 
> s/snp_max_snp_asid/max_snp_asid/
> 
> Thanks,
> Tom
> 
>>  };
>>  
>>  /**
>> @@ -841,6 +847,8 @@ struct snp_feature_info {
>>  	u32 edx;
>>  } __packed;
>>  
>> +#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
>> +
>>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>  
>>  /**
>> @@ -984,6 +992,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
>>  void *snp_alloc_firmware_page(gfp_t mask);
>>  void snp_free_firmware_page(void *addr);
>>  void sev_platform_shutdown(void);
>> +bool sev_is_snp_ciphertext_hiding_supported(void);
>>  
>>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>>  
>> @@ -1020,6 +1029,8 @@ static inline void snp_free_firmware_page(void *addr) { }
>>  
>>  static inline void sev_platform_shutdown(void) { }
>>  
>> +static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
>> +
>>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>>  
>>  #endif	/* __PSP_SEV_H__ */


