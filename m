Return-Path: <kvm+bounces-36281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34029A1972E
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 18:08:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 134583A370F
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B7721518F;
	Wed, 22 Jan 2025 17:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DczLggCH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A1C1527B1;
	Wed, 22 Jan 2025 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737565663; cv=fail; b=aUQFbHHb2QDmdaM72w3j1xM+o5KhMlaMneF+y9RqYfpbniyDc1xnVK/MyuUry6fNOorRpASM85aJNlqXZ0C6nZzAtfl1YURgjxs5cUPvK476lq4jp6NgFfxfdEO04ctyzXlwrMKnoWYFYA4g7qUizLZZVmFThUe3x5lkITmSRC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737565663; c=relaxed/simple;
	bh=3SrD3wb0R7v5+EoecAMOWnCbjxfBngfl8b/Z0mVZQiI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lkKHSnl34EFmARQQJHOHvMdMIJStf1YSFf8ouvYzGlzO3J82cbifP6Pm8XDvZgHuzwwNWZnT5Ur2+ciAMZ6vCSlQ4l67iX3DwnQpo7vovg6ZUCYzVy8zMH8WJ9Q6I8q1kstsax02a3IlP30zGPLGVYLDVN7B+7B/qOf7Fd9Auj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DczLggCH; arc=fail smtp.client-ip=40.107.93.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q+gF7AOeJ6TwJK+fsvL7yT9Ej9crsSXRhJE3Ufm4TfitidN2ZC16Q+IXHSNt1q7mPJU6eP9Gsff1e0Gp78FQ2bwQDy3KLF/41rE9/R52g9YDESFCzt4Tf3S0CzjjwMWeqn8chCj5UgwV9JPJMqfM5AIbnDriBOB8y0/IEXtaeqnNjXw0y5ZLut3DfVyF1RcCgI20RVQ4vHVi+sd6yMJZBTJI+x5myE6mor/m+u7CVuWCT7Kc36T1aZirY62ifjplii9l/5BYhS+SS6HEJv04umkmvKH9qMceMDsTNGEu1XS00L0OwEZIgRxHMYjNUaRO4pYO2MqmMEGNOEIdJg/fHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DTWVIPa6ulYvYkgnoq42XUE2HqRVDvFKWVjwvyZDOLc=;
 b=D51rZrSoUENb+7qj38tRlPr4tlVZzw1xyMxAs3cXg/Y5RS/WxIICbXveXvPxD2ZSKfoirSuZOMbS1HWxe3EdQCaa6mkOgbrn+sAeEiIxfEsHVDdtgdg80KPf6FrwyMBi5EiziWziP0EV1LXwlmpZgxGWu2oWO6zcSPhmmYF0YS4Wo045jxpFm49K85HysXdEXiC8judBMbSqvKmfLtnHumxXgmmG1qUDTsZpbhrbBtaHYjqw1kzReMirQg386wkz7Cn7p2Y4Kh8AjCslAie9qItuMETUVMhgTRUKlzCmDCQSA6IaIvMdGI0lPF7Qb3Xvwj5DLZzbLEGIg3fgVOzhWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTWVIPa6ulYvYkgnoq42XUE2HqRVDvFKWVjwvyZDOLc=;
 b=DczLggCHdQVyAoZu9CC8tGFSMtkW5/wkw41hiADW//SeVgfY4q8uuF9MCOPdMPxt2VU7r1Xrkjx3lMciEjkGofW7A+GRgcPri82NmR5Wy5LbuMdunFpzN+d3hLWhkc57lhImunWDfuKza2rOT4Nydf2V+jgmQGqsSPiedkcsIEs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 IA1PR12MB6387.namprd12.prod.outlook.com (2603:10b6:208:389::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.21; Wed, 22 Jan 2025 17:07:39 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.8356.020; Wed, 22 Jan 2025
 17:07:38 +0000
Message-ID: <5df43bd9-e154-4227-9202-bd72b794fdfb@amd.com>
Date: Wed, 22 Jan 2025 22:37:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] iommu/amd: Check SNP support before enabling IOMMU
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
 robin.murphy@arm.com
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev, iommu@lists.linux.dev
References: <cover.1737505394.git.ashish.kalra@amd.com>
 <0b74c3fce90ea464621c0be1dbf681bf46f1aadd.1737505394.git.ashish.kalra@amd.com>
 <c310e42d-d8a8-4ca0-f308-e5bb4e978002@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <c310e42d-d8a8-4ca0-f308-e5bb4e978002@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0032.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::22) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|IA1PR12MB6387:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b94aa58-66a3-4539-942d-08dd3b0745d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGpiVlBEek1yL1JOa3hITEtBRTFYRTg5aGZ3UG80THNHQzVnY0lPWFRPbjZB?=
 =?utf-8?B?YWQ3UUFidkk0T2tnMW0zQnZDemtOTHhicDBXVGhZTWhoRFNVZ283S2xiYTRW?=
 =?utf-8?B?R1hVaDQ1b2F5bEhZazc1NnhieGNOS3Z5YzlOSXdORW9pT3dUczh1b3gvM2RV?=
 =?utf-8?B?TTcvUmNBR1hrd2FIRksranFtOVVwT3NhU0tCajJzS2dIT250bGtlVDNqcXR4?=
 =?utf-8?B?bDEyS3F3eDRna3lRay9oYnRzUEpOaUNvbGdYNFVUY09CMkUvRnMvYVNmQzF2?=
 =?utf-8?B?a0h6cXZvRzRVY1c3eld0Q0ZMT0cxWTZjNTAzdGdzMEcwRXhVVnBOUTlkWWUv?=
 =?utf-8?B?c0VHek9TR1N2V1FJbVZTdzJxc3kydGtpQ1RWWnRuaDBZKzRHZHh5TDljMEky?=
 =?utf-8?B?K09SNy9LNEkxVnF5RUtHQVZ2dGhJM2hDVHVDNUgxUG1hYWU3ZHc1Y1ZrN0dF?=
 =?utf-8?B?bllYNHhSRmF0K2NoVE9HczFYU1VUdEZFL1JiMDNkWDhVdzNUYklUYjBneWxw?=
 =?utf-8?B?cCtLenVvUWszM0RXSTl3amR6ZS80Z05KZmtYY1NuMWpxaTBSeVZjWGtJempz?=
 =?utf-8?B?Z0NRb0VPUWNvekY5TGI1aUZaRzdpZVpFbkFiN3k4RkNtV29zbzNLTzFxdVZL?=
 =?utf-8?B?WFZTcWlyTGhpeDNxbGNCWStMVnNWd1ZvWEZ0T29kejczL0dDVkYybHFzVFVI?=
 =?utf-8?B?WERWVWtxZ24za1YvR3lmVHNQSFJaVUkya1M2bmdsNE9ZNm5tTXJJWDlLT3Bi?=
 =?utf-8?B?ZjN0QVVLL0FuaVU3UTQ1RFM3Q0JPaHZrRkhBclo4bURkN3VZdk9xMm53M2VP?=
 =?utf-8?B?S0IrTjRMaDlKclRhakJ1cDIzSHRIcWNxVzFOdkIrR3lIa3ZlV0hlRlp6eTl5?=
 =?utf-8?B?Mm9FVStUNlFTTk8za0tiaHcxaDZtWWw0ajB0cXExNVFsMU1pZkMzNVhkOCtK?=
 =?utf-8?B?T1daK3grWWh1VXZabHc5WUt5RDQ5OG1JdEpCVTUvRnNJTFhpU2pFRDZUbzN1?=
 =?utf-8?B?NHVBSGhTUGttaU1qb1IzSXQ3eEVCWmx0aWswK0htamVDYytST0x3WG1BS2Vp?=
 =?utf-8?B?VjdHUStMUmdiZTdtTjZCcUk3T3VYVG5sTE1xYXZVRVVza1ZVTzNJdTA0TUMv?=
 =?utf-8?B?Vkp0VzBuL3lENHBSdFNlN1ZTaTZlU1dUMVpCVFNWdlNzbVFjZVh6ekQybG8r?=
 =?utf-8?B?ZXRwbHUwVmszVDZCaUZnTkRyN2hUSFlIdW55OEtQMDJ6MlFTNE43ODZhNVF2?=
 =?utf-8?B?MmgycUFFdGZYQkN0WjI4M0JrWlNjOWlGOC85MWp6TFYvaGNkQ0NhWE5wZjhN?=
 =?utf-8?B?cVVvMU1ETzhvQThTQWJma0ZaVlhtMHZTdDN5SXRUYzR4bjNSMzgwZGxWUXFW?=
 =?utf-8?B?bGJPYlRLaFZxZWtRblZsS003REFvYmprSUIvSWw4SDZ3UjJUdlFCNTJxc3Fo?=
 =?utf-8?B?MGJseDN1dUk2Yk9sRzdkejVZaGFnS0FnbTdjNFBLcCtZbkhjSjQ0SmVoNlRD?=
 =?utf-8?B?TTdMME9jWmZGVGpBRU1iTTZXZjhMRitZRVk3R1NvenlDZlh0OEJTOGNLVGhH?=
 =?utf-8?B?NUVYQ3p1MXl2aWdkcmtadkpjYUtxYWpWSG1zK2c3M3dsTDNlM21rZXY3WEFy?=
 =?utf-8?B?c3NGZjA5Zk9OM1RoenpTd2hTcWhJeW1FYUgydVlHd0Y4cGpIenJQUTdycGRL?=
 =?utf-8?B?WWFST3hNTDh5K3dHeUxLQnFTSGZDRGVjRHkwU0NNaWxjWmZxMWRYenBESzh5?=
 =?utf-8?B?MC9GVWttczNWYmxKLytpSFVhVmE3WFVTT1BpZkcyREptTVZoTFhEMURFWktp?=
 =?utf-8?B?RHdQNTcyVC9xTEhraGVQN2RYY01obEkvMjRGZCsveEpjd25BeWtyRHlnZE4r?=
 =?utf-8?B?ZklGVFl4YVNKdFp1T1E2cEUreXhkOWtnWW5PN0xGdUlEeG1lWHhTZXFHbm9M?=
 =?utf-8?Q?3lBtz/Hh2Sc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THZmUEVZQXV3NGFjYWlWZm83U2lJVUJpZXpZOUtCVHgvNHVzK3RNd3Q2b0hW?=
 =?utf-8?B?U2wzeDZaUm43R0c5UlNPSmhwbFNqU251eFV4eTFxZENTRm81K2FWRTY3K3Fa?=
 =?utf-8?B?SUoxaHlsaEJHYXVyNEx0cU8zVnhSeTFCdjJmR3RlZ2ZIelRGUU84NW5EYW04?=
 =?utf-8?B?SGd5ZTYrNnR2cVJoOXA1V0RLWWc4cFQ4anVvZmU0dlZaKzVhalpmQ0czTERs?=
 =?utf-8?B?RkpxS3pVWm9CYW9zZmdQZHFlUGRaczNyL213T3ozbmMrQlU3amgrMWxZV0d0?=
 =?utf-8?B?UWxncWprKzBvMGo3YzJpV1B2NUFISXI3UDVsaGppeEhLdmpUZnp4ekJ1enFT?=
 =?utf-8?B?Q3ZPdTlkTDFiMEhQdHJKYlF2eFBoTy9UYjFtamVXMVBrVEF2TXVpZ1ZQekYz?=
 =?utf-8?B?cGxQWHp0WVQyOUNZbGZrK1pJMHpLcWJBeGZmcDN3MjBQQmpoUnBFMzBHcGdY?=
 =?utf-8?B?N2xJUy82NHRaUnYyQnZHR3ZUa2MvNC95Vnllc1pYQllBU0NNVEQwNUlHQ2JP?=
 =?utf-8?B?YUVld1RKSmtkbTJUWGNkMGptcHNEQm8vZzdhNDU2eVVkcFpvR1RzbHRvd0ln?=
 =?utf-8?B?OEZneWlkczZqTHBYYXllL0JHWlVZU3dXOFdTY3NkdnBVVUNzTHI4S2RoTFZw?=
 =?utf-8?B?c1VaL0pqS2pzdVpxMHVQN3Zna3JMNTlCNVFYazdQem56bzA5QTFxcEpzSGky?=
 =?utf-8?B?LzRvbzZwWFR1cDN6djhtSjgwK04wdnVmMXVwd1M2M3dKMnVvQklGazNBSTha?=
 =?utf-8?B?ck80d0U1M05iSVl6VytoTW1jTTVQZHg0aUx3S1NYa3N5RDhsNkhDS3UxSWxG?=
 =?utf-8?B?QWgwUW9mQWoyR1VQb2U1YlRHQkEyU3RGc1prY21sN0U3MnJlNzFIZ3gyTERI?=
 =?utf-8?B?SWcrSGhDemVhbUduN0k0QmJGdGV0ekVwaHZBTWM4WGJQdk5keE9iam9OVUUw?=
 =?utf-8?B?dHF5Q25FRU1JMTJDUkY1YUFaWnY3SmpCMjdNWlFRUG0rVEZwUFg0ZDJRWlk4?=
 =?utf-8?B?V0VMdlZ1SWJkSTBHRzhyQjRsN3l3dlY1cFEySG9qTXV6MUQ2UmdhNWZkNVlt?=
 =?utf-8?B?eEVSYytuMTZ0L2FzSFJnTys3TFdtcUx2MzFhNit1ejM0bTZlYTBlNEhTNlhj?=
 =?utf-8?B?OGRseXIrcitKMmN4ZHNaQ3RqK3YycWZuRklCWjI5b3BmRkF6SWxFdlJWcGNB?=
 =?utf-8?B?T0p5WVJMZlg1S3Y3YzB2bE95MmhmOFVlQ1hGOGVXT21jSFI0VG4xUGl4c0tV?=
 =?utf-8?B?R21CS1dYUVNabFNWQjZxV1FWS2dyYmpYdUNOOE4yUmVVZi8vU29FSXJYckQ1?=
 =?utf-8?B?Ujh6RHFuS2R3S3J6QVdOUGovVVYwVzJ2Tlo1cGM3RFdLendybzRzYVBKSi9F?=
 =?utf-8?B?SDJjQ1ZYWTVWanUzejhmcEZVczE2R2xuMlA4RFJtNlBVNi9IU3BlWEg4QU1m?=
 =?utf-8?B?TGJ5VElrZUd2ekh1ZmI5NFBDQ3F2OENHb0NtbHd1MUxJc21Bd1d0TEpKaldQ?=
 =?utf-8?B?MUxaUlNvbCt2UDJvWEVNcXRFcVErNGJIS2grNUo1RGdqMTJ6QU5FYWhrWGp2?=
 =?utf-8?B?ZmVNemphMmVnVEhEME9venA2ek5TaHlqYTZlYzJsYW5DQUozcThZeENFM2dE?=
 =?utf-8?B?Qm1NQklSUjIwcTNiNkNrbVdiYnpmSnF5OGVKUUNBcWpoUGFSZGJkNDVqR1VN?=
 =?utf-8?B?Ump2OHFqMHpqQmZINEZjLzBlNDlsdGIrdXphRDZ5OVRUckFqQVMxeUNLN0RG?=
 =?utf-8?B?NTNpTW9uVG1nUHBDWmZHMXV5SHBsaTFLMjU5bGRQZGFMMFFRQi9vQktXVzB4?=
 =?utf-8?B?SDdCWGp2VFZBTlFLcE9WemtZZm9IcFlpOVR6V2czclBYQkVNRXpKcnkvN080?=
 =?utf-8?B?dFFTQ0pjQURmb3JFQ2dMZTQ5U3h5dytzVngyTmN4M2pmTFArNTRKUTV2UXR3?=
 =?utf-8?B?YlFLQ0VkZzQzZTZUL05tZFZlSmpvVzJqbnJEZTBNTldNNHhRTmgxYVBwVlRS?=
 =?utf-8?B?aHNUTUMyMlZnemRhUm1CTmc0QWtyeit0YWRaYWxCeVlSMWlzWUk5V0gzSEpV?=
 =?utf-8?B?eVp0ZjExL216MWNJU01UaFhhaUZIc2N1aUdhN2J3bk1PNVFjM1lrUGZ2a3NI?=
 =?utf-8?Q?j2ivUSCIMqdA9XNfv1sb0K3D0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b94aa58-66a3-4539-942d-08dd3b0745d1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 17:07:38.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GoeCBKRQ/Q9XiU+V2As8XUoNCRhIE2DQ8UXA2feWcXwRgQsYZW1kd13Fy8lVgDG7ffqsvs+LIzXkaeSNvfqMnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6387

Hi Tom,


On 1/22/2025 8:52 PM, Tom Lendacky wrote:
> On 1/21/25 19:00, Ashish Kalra wrote:
>> From: Vasant Hegde <vasant.hegde@amd.com>
>>
>> iommu_snp_enable() checks for IOMMU feature support and page table
>> compatibility. Ideally this check should be done before enabling
>> IOMMUs. Currently its done after enabling IOMMUs. Also its causes
> 
> Why should it be done before enabling the IOMMUs? In other words, at
> some more detail here.

Sure. Basically IOMMU enable stage checks for SNP support. I will update it.

> 
>> issue if kvm_amd is builtin.
>>
>> Hence move SNP enable check before enabling IOMMUs.
>>
>> Fixes: 04d65a9dbb33 ("iommu/amd: Don't rely on external callers to enable IOMMU SNP support")
>> Cc: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
> 
> Ashish, as the submitter, this requires your Signed-off-by:.
> 
>> ---
>>  drivers/iommu/amd/init.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>> index c5cd92edada0..419a0bc8eeea 100644
>> --- a/drivers/iommu/amd/init.c
>> +++ b/drivers/iommu/amd/init.c
>> @@ -3256,13 +3256,14 @@ static int __init state_next(void)
>>  		}
>>  		break;
>>  	case IOMMU_ACPI_FINISHED:
>> +		/* SNP enable has to be called after early_amd_iommu_init() */
> 
> This comment doesn't really explain anything, so I think it should
> either be improved or just remove it.

Sure. I will remove it.

-Vasant


