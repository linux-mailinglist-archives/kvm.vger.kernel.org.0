Return-Path: <kvm+bounces-33535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 861629EDC5B
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 01:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC8E31888A63
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 00:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4972223CE;
	Thu, 12 Dec 2024 00:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FIrjW113"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A94163;
	Thu, 12 Dec 2024 00:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733961784; cv=fail; b=mMvmH/mEqH75pRUWc61kMwuWTiBBBKkXk/WBdDE/tOmwo9mBu5Ue/bS/83tbBt7sogPNkqDuJ0k8VBFNiLScOqJi0mUNrimH+OB544T5CC60qFfRgHDBzNnz4ParAu7DIb41u/2dtAbNz0C3tHsJEjvpAcI/N+l1aodxikuZF2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733961784; c=relaxed/simple;
	bh=1WDB77vS4Yht+b1dZUsQ0hbFWL97Wr+fgEcn1xnONHE=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T+Vn3A4zpYxdC5B+HvA2/s5fD4O3tG2mIRO3z6ZcCB5OVTD3QSIiNnz7BIgst5cnxguO+urNajBd67uJ4Yb/Gv4pgc70eXFg2eqMgM1+4TXxHO6MS0+0a2pSl8hENvYkAvTxRIQ5NMi45NOu5xR6cEwdByazFaog6qjICj2urFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FIrjW113; arc=fail smtp.client-ip=40.107.102.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ogb1LnloPWnny+HYBLePuoF6o7bRTPTfW//NpERrx3VwgxpmDmv04nT38dOguil+thujoV+J5YgnwR6T9wzlJXA6hALVesPxaSxGLHUeGhwkdSu27iXyqZZvhkEvNvaMKgiLZ93UjoNL4N34Y2MUybml+CmhktTxQQgo6Y4Nw3wor03++/ZCL0pm7xQ7txGzQqwkdO2ACrEjAJ8ZoFEMcRLV58vtJZHmRCpUL9UrKS4m+6mKGs6xm/uhVdTZDmxQwvVJWcgUtn4dVQjwd1XCrty2TD4Cfsj+9E+PkTpzg6fTvXoIWCAuzLf8wU4zDk/qK3HmzkdSkY/VLhuGqDmS6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/fngk/On138GHJUiZF/t3nd31IjJc9yuMaTkIibYzU=;
 b=ECMawII+ZuUAz3Fg5wuH8DgV87Z3KFNs5U9zNHO4ExJLoAbW4I2FclQjo+dSWGFy1YYx0CVGV5np8/AKxMh+XtmAdOU1z/yGdes13aLm2aElEsq+8gyWN5P0daHou8dChSMnA7LLDGqdzZ4YfwTcqnU0U+7GbFdlnLfAoXtcM/+bdY9ptaVVxoi8LRyWSqMZWYYUHc8HnpukgsZZ326iYiB0SgxZAGXBDNY9SuWvun6XMvdc2ob/aM3DCMBd0BgD11r4Md3petDHe2/SWL5YdDyUMIcx3meuaqeelDonVxtWDP1DqssWeD4VkFaIhVZIDczS/B0iXLlQJeT4nuVeRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/fngk/On138GHJUiZF/t3nd31IjJc9yuMaTkIibYzU=;
 b=FIrjW113qWDazd+LBeAPn8qXeavfXDT44EcMyJEMp9sSHbgWK0BzsX+VHQLQv3hFonjfEtgRrFe9MGy7lZhM+COMl/+f2XezQqjXVXFAtOUg4gu1hkr769L47qH173GBijXRqdCrO6Vap9HfddG9mfGfNSAEeloC0/iF/9OQS7Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM4PR12MB6616.namprd12.prod.outlook.com (2603:10b6:8:8e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Thu, 12 Dec
 2024 00:02:59 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8230.016; Thu, 12 Dec 2024
 00:02:58 +0000
Message-ID: <423b28cd-436b-45ff-a82c-ee3112b425d7@amd.com>
Date: Wed, 11 Dec 2024 18:02:54 -0600
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
 <e27a4198-ee94-4ca1-9973-1f6164ed4e64@amd.com>
Content-Language: en-US
In-Reply-To: <e27a4198-ee94-4ca1-9973-1f6164ed4e64@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0120.namprd05.prod.outlook.com
 (2603:10b6:803:42::37) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM4PR12MB6616:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ffcb6d9-61f7-4889-d09e-08dd1a40564f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U255bXZ5RXRsRVdCY2NKV3kzVldXa0t0dTlOa3BxREdmZVlpSEN4VlYzcEhL?=
 =?utf-8?B?R0ExOFBIWko2Vi9aTWdZdmhMYXRaMWMxMnBQSUFTN05xNHFJTkF5QjZ2Ni80?=
 =?utf-8?B?aWQwT1RUemZaaWp2UkplZW9SYTZ0c3ZRQXhZcjRwZlFxNWM1ZTBDOGJ0RHUz?=
 =?utf-8?B?Vll3Q0xlS00yM08wd1NybFRFQ2VMWGVzYkEyWnpCdHVUU1o2KzVzOUVCMTdz?=
 =?utf-8?B?QmZobGxPRCtoZCtXalk2Z01CWDNNME5JdWphODNmRjB0bCthZExLcGxIUlla?=
 =?utf-8?B?SHFhSEdGTnAyOGZvcmhGMGdCbXBCZS9CaXhjSTZHN0ZLS2U0V0g5aGgxK2RF?=
 =?utf-8?B?TUl1cCtYY0pmNVpRY2JnNXJHRlFwaUNhRDdkYXVlUkN6cGlZeHpIem0vWmdH?=
 =?utf-8?B?ZitZRVBVZExpQUZVL1ZiUisydGVUR0d2SU9Fa0pBamJrUlVvWWxtRnhDQ0s0?=
 =?utf-8?B?QlROeUdvZm5FU3RjcDlFc3VKcnA5OEN1UTJraUdFWHlweiswUExWSzFOUGFa?=
 =?utf-8?B?NllwTG5FUy8rM0x3c3R4OUhUbXM2TXNJV1d5dEdLRCtaazg4MXA5bk1yakdN?=
 =?utf-8?B?VTYyWERmK0ZMRjlwQWJEU0J3U3o4NVU0UmRVNlh1QkxpYlBSeG56eXcxcUJF?=
 =?utf-8?B?VCs1NG1SWFhnOVZQN0hrc3FBYjFTeHhhRlRqYnNraXFibTRnVkVaRjJIc3pQ?=
 =?utf-8?B?dEhxemd2L2ZjT2p5a3ZieUM2cENWOGo5TCt6YjhxUVcrMmI5bVgySndlT2Vs?=
 =?utf-8?B?b3J0b2MyelBZclNFQWZ1N1pHZFFKUUlTdW1sM1ZuRFNCNmZ0N3RRc1o0cGc3?=
 =?utf-8?B?aHNPMTFISG1JUFlMTjlJQkxkTWtYREVaaXNvbzAvNzhzV09mblJOVWxLZkxP?=
 =?utf-8?B?TmUxVUZmRXBKOWNmc25SZHp4N0hlTUNLdFQ5ZklTbkdRQllTaDZGaWlSL3JY?=
 =?utf-8?B?R2FsL0wzbXlnMFNOMHdXbGNpTlBDdGdmM20wOC8vUnZHbWJPRHhzY2Z0ZUFv?=
 =?utf-8?B?dFJvcFlVRGNlUllmNThmVnFKckQxYzJFNWpoSWIxNThpWUdOOXQzQ05UR0Rm?=
 =?utf-8?B?anM2a052eWo3bTA1ZUlodUtoZmlFWllxNTE2L2puYWcyWjllV2dwSWZjQ1By?=
 =?utf-8?B?NUE5S3pGc1lDUW5kNUczQnhzdGtIN21uYWczMVZndEpzTEJFL2FOYVhQM3N2?=
 =?utf-8?B?ZUZqcG9rOWVIandpTG9Pb0NhRGl0Q2xRclYvZERzZUFFUjVFbDd1WUQ5bXJR?=
 =?utf-8?B?L0hNVVNYcnJFRkxWODU4MEFOanhqMC9QdjhxSngvMjVUZ3BlYkVzVzhsd242?=
 =?utf-8?B?VTcxWDR5a29vZ1FBdDhLYjRYZUMzWFdQTHMvbzJJWWFkMitNckpxWHpGUUFW?=
 =?utf-8?B?NG9sVSswQkw2c25TakVTSlRyUStDUmxnckpoemdkNVhKSm92a2p2elNzN0I5?=
 =?utf-8?B?eVlPVmYxQi9SbjZNWUdTRTFqOVAvTUE5dlVQV3BQNCsvS3k5L0pHK25ndlFB?=
 =?utf-8?B?TGxSUUlyQ3Eyckc2VnNsVjd6NjkyWEs3TjQ0MFVYUkJOdDFLeGl6RHV2UGl4?=
 =?utf-8?B?Q0QyODh0STdDSnVsYjYwMXlZMi9OM3NpZ1pZVmlQUFFCTS9US2tGOGR0OGdR?=
 =?utf-8?B?R1J1SVAxT1BCcm8zTUkrYkdva3YwSVdSQ1pWeWl6eGwzVXNKZjlKOGUxY1B6?=
 =?utf-8?B?S1VlRXc0U1g3bnFGWXBtb1doV1gxcTMwd2dmd0IxNFNXSXhsMG5RV0R4Z2Zl?=
 =?utf-8?B?Ty9WWVVseVA1V2RlRisvZmF1a1I2aVhnYjVWUlFJYi9ZSTZBMGtQQ0hxVHcx?=
 =?utf-8?B?UGlGK1AzUEI3aGVzMmFMQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnZkcnRIbWw3MVRUVWZNeXpNUFBYM3E0M2hQRlRIKy9pMHNiOXpmREVyUVg3?=
 =?utf-8?B?S2hLMEdvTmpuck5sWmJOQTlYRUkzdVpvNDV3TGtnTUpXSnFDRk9hNFMxcXA5?=
 =?utf-8?B?dzVLM0I4My9tcGVrOGd5STkxT1drbVhaRzV3c1VObFdNMHJ4UjNsSDludlRD?=
 =?utf-8?B?ZllnVWhwdkJOZlQ2cnU1Z1EycUlkYi9hd1BLSzAwOEhpVWdxUmFOZnVIOVE1?=
 =?utf-8?B?anpJNzlzQW9rRDRzU2lTZ3lHM0dndy96NkZWR1I2ajRkNnA2cFVWNDFoVmls?=
 =?utf-8?B?bHRQQmtVaDg4TERrT0h1OHdSQ0VjS2N5ZGg4SkMrMjdHV3I4clptcXhadlhk?=
 =?utf-8?B?Q3M1RTdCREZmdjlrS2ZNQXBKeGdJVTFjVWxvSmhobFhmZnU4L0Q3RHovR0NQ?=
 =?utf-8?B?OHY3cU9SZ245anZaVzVDSnVuV2hldko4UjJTNTNrZWlyazBvNTN3M1diMVF1?=
 =?utf-8?B?dEhZdVFuOTNicHJLZlNpMllnak9Hay9TQzV3ejNQNHJYMzBkZTFBRXhDcTVD?=
 =?utf-8?B?OEE4Njh2U1lib0srQ1B0b093dDJQMEFOWUdFTG42Qzh1WUp3N1NEQ01GY3ZV?=
 =?utf-8?B?T0x2enhkZFNGWkpqai9xQWR4V2ZsTVQxazVLeGVzMFYrUmdKWHE4THdHZ1NT?=
 =?utf-8?B?RmJFUWNWY1dKeXkvaS9oZzdLUXlRTWR2SmJLc3dyN3NoYjNFS1hXcUtjclRI?=
 =?utf-8?B?YjZvUEwrNUk5OVVDMEZ1YlRIb2d2NDVOMFoxQkJrditTNE9iNW9YbXRRMmZV?=
 =?utf-8?B?R0dzek9XZ1JHVjR5RlJPNURGVHZJQzNqN1pDQVd5WEtiVHBOSWMzRGh4YWRN?=
 =?utf-8?B?UGFqUGZOYm5yNnI2bVN5YjV4Q0xtU3FNVWlPUGZsTTB0TytmNFFqTzZxQnVC?=
 =?utf-8?B?N2R0dy9Bc09hRGJjNFB0WFRpNGpZNTFTak9IS1Rad1AzVmZCRFdKQTFzUFE2?=
 =?utf-8?B?VE8xbDUxTEVkczY4Tk5hVmovQUxZU1Q5UFF6d2hjaWJmT1l3bWZiTHJmSEhh?=
 =?utf-8?B?a1FqeVpmRXlPR1E2bTY1KzNVbWdBVW1IOGF5U0VJMWJDU2NmSngwMWFGc0Zm?=
 =?utf-8?B?VTFvaGkzYzh6bm1jQjAvM3Z4ZHRuTUFNQzF3Q3MvM1JDaWJkYnBwdzVGREFX?=
 =?utf-8?B?R2JSS3dwMG1HVXcxbCsrTkRwMlRjdm9taEZhVGMwSnJmbXc5ZlVhWHpqOVFu?=
 =?utf-8?B?NXpLREthbjdxb29GTGJIYW9Mb0dFV3dzSW83cVZxN09zajdQUzJwWEYrUDlh?=
 =?utf-8?B?azVHZk5OV3BTTW8yVk1LODZTSEEwVC8zQ0NFa1VLUVoyMlcrZDYvME5IelFZ?=
 =?utf-8?B?RWlacG1oQ3dLQld1bldiUVVmazR4WndUL1JxQTdBOEM3bGdGenl2K0ZleldP?=
 =?utf-8?B?OTByZDgwdlBBZS9mYXJDU3UyTmlvczJQalJIdlJlT1Q2Mm9USGh2elphaXNJ?=
 =?utf-8?B?SHloOXpKSGZwUDlqRmNUR0lKVGw3OFBPRVE2Q1dtRGZSV2t4R0MrNzFnZW1X?=
 =?utf-8?B?MEp5a3BRZ0VBMkZad3dpOWJnenhwZW1yTWt4ZFdnemtqMUgzVTVhM1Q3U3FD?=
 =?utf-8?B?YnR6SHpWY2hSZVAwVThzNnVJcXJpUzNtbHBSekVFUy9UUTl6RytjTUlJd2VR?=
 =?utf-8?B?WWZLTUdmQnlsMHJPbGY5dDBHUWowR3VGMjhCUlVIZk9kYkUyYU93RkRwUk1D?=
 =?utf-8?B?dnpMa3dKYlgzRHE2TjVseDlWYlc5a3o4bXNZc0E5ZFovZUJoL3dBQTFTMVlM?=
 =?utf-8?B?QlAzcWVrMjNkYWFGUzR4TjI4enk1TlVFb0NPRXhTVHdJRURIaHdvUSt2Mktu?=
 =?utf-8?B?ME9jd1FLcjNzMzk0WCtDT0kwRy9sWXpQa3FLcjRtVVltVHBDN250RlhsRE8y?=
 =?utf-8?B?TUI3R1AxUVE0dFk4ZjRYdS9EdSswcWEwazl2WU4wRWI4MzN1SmFWbzA5OS9p?=
 =?utf-8?B?Qmd0c2tVcldnczBpaEVEdDJDQklFYk5YUjVpVitLTVRWVXFpczhRaEZJWlhh?=
 =?utf-8?B?cFFkdGF3TzRvZURKbEhBRGllcmhnbWZFK1ZLTGh4TGVORmhhSlBrcFBDby96?=
 =?utf-8?B?RmQyR0VmZzcrVWVCNGpzSzVwbUVYcFlDNEEyeE0vNlBNQlFNZHRiRmY2K1lF?=
 =?utf-8?Q?aotmqKNPgUElS9MR5hz82GXOG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ffcb6d9-61f7-4889-d09e-08dd1a40564f
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 00:02:58.6299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHaZXDacmwPs+bvPpUTnIks5PiucSEXbh8tYLkCgG7LTBEYlLHck8uhCyJzUsIBkXG4VIMc1CktcOvzit+8pRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6616



On 12/10/2024 7:01 PM, Kalra, Ashish wrote:
> 
> 
> On 12/10/2024 6:48 PM, Kalra, Ashish wrote:
>>
>>
>> On 12/10/2024 4:57 PM, Sean Christopherson wrote:
>>> On Tue, Dec 10, 2024, Ashish Kalra wrote:
>>>> On 12/9/2024 7:30 PM, Sean Christopherson wrote:
>>>>> Why can't we simply separate SNP initialization from SEV+ initialization?
>>>>
>>>> Yes we can do that, by default KVM module load time will only do SNP initialization,
>>>> and then we will do SEV initialization if a SEV VM is being launched.
>>>>
>>>> This will remove the probe parameter from init_args above, but will need to add another
>>>> parameter like VM type to specify if SNP or SEV initialization is to be performed with
>>>> the sev_platform_init() call.
>>>
>>> Any reason not to simply use separate APIs?  E.g. sev_snp_platform_init() and
>>> sev_platform_init()?
>>
>> One reason is the need to do SEV SHUTDOWN before SNP_SHUTDOWN if any SEV VMs are active
>> and this is taken care with the single API interface sev_platform_shutdown(), so that's 
>> why considering using a consistent API interface for both INIT and SHUTDOWN ...
>> - sev_platform_init()
>> - sev_platform_shutdown()
> 
> Which also assists in using the same internal interface __sev_firmware_shutdown()
> to be called both with sev_platform_shutdown() and the SNP panic notifier to shutdown
> both SEV and SNP (in that order). 
> 
> Thanks,
> Ashish
> 
>>
>> We can use separate APIs, but then we probably need the same for shutdown too and KVM
>> will need to keep track of any active SEV VMs and ensure to call sev_platform_shutdown()
>> before sev_snp_platform_shutdown() (as part of sev_hardware_unsetup()).
>>

Worked on separating SEV and SNP initialization and got it working, but it needs 
additional fix in qemu to remove the check for SEV-ES being already initialized (i.e, SEV
INIT being already done) as below to ensure that SEV INIT is done on demand when
SEV/SEV-ES guests are being launched: 

diff --git a/target/i386/sev.c b/target/i386/sev.c
index a0d271f898..bb541f9d41 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1503,15 +1503,6 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         }
     }

-    if (sev_es_enabled() && !sev_snp_enabled()) {
-        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
-            error_setg(errp, "%s: guest policy requires SEV-ES, but "
-                         "host SEV-ES support unavailable",
-                         __func__);
-            return -1;
-        }
-    }
-
     trace_kvm_sev_init();
     switch (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common))) {
     case KVM_X86_DEFAULT_VM:
>>
>>>
>>> And if the cc_platform_has(CC_ATTR_HOST_SEV_SNP) check is moved inside of
>>> sev_snp_platform_init() (probably needs to be there anyways), then the KVM code
>>> is quite simple and will undergo minimal churn.
>>>
>>> E.g.
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 5e4581ed0ef1..7e75bc55d017 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -404,7 +404,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>>                             unsigned long vm_type)
>>>  {
>>>         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>> -       struct sev_platform_init_args init_args = {0};
>>>         bool es_active = vm_type != KVM_X86_SEV_VM;
>>>         u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
>>>         int ret;
>>> @@ -444,8 +443,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>>         if (ret)
>>>                 goto e_no_asid;
>>>  
>>> -       init_args.probe = false;
>>> -       ret = sev_platform_init(&init_args);
>>> +       ret = sev_platform_init();
>>>         if (ret)
>>>                 goto e_free;
>>>  
>>> @@ -3053,7 +3051,7 @@ void __init sev_hardware_setup(void)
>>>         sev_es_asid_count = min_sev_asid - 1;
>>>         WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>>>         sev_es_supported = true;
>>> -       sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
>>> +       sev_snp_supported = sev_snp_enabled && !sev_snp_platform_init();
>>>  
>>>  out:
>>>         if (boot_cpu_has(X86_FEATURE_SEV))
>>
> 


