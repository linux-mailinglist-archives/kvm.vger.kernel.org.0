Return-Path: <kvm+bounces-36962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F19CEA23909
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 04:18:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67199168422
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 03:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30BE07A13A;
	Fri, 31 Jan 2025 03:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="W8f51PRN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2058.outbound.protection.outlook.com [40.107.102.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59A120EB;
	Fri, 31 Jan 2025 03:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738293498; cv=fail; b=GjCddjfqsvUuHNK/a/sFhUja8ssHHY1j9oqnJG29tSqQ3vXvYX/2F1l6ngDntUPlCOQqxHjmA1/xJzBVaKoFSlBYn/cVVyM1xaq/fmG6hAbCXq4lDys89Sd1KDo2noXHauLuzfEBZevutNP7JnEcW6KSstmZL3qa7yqXQsUX6Gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738293498; c=relaxed/simple;
	bh=oV+FFKYYAfa0mGOeoRV/xVSlXHPOiLslpZRIlyeI+x4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o+Wyscd5ckGWr8vwaBxixMtuZhLf6s436Cwv1GIZ+edou31fGZA7NWhobwCe6VTitRd5HeQAFe1w9GPdD1SHaME/H6H7m+15GGIz1xU3JeoOEpKKzm5bySs+WaaaPQQX1ODcPBnDtcGY6cDdvUsd2zEMAVMGZ2ATp3+ns0W2Kf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=W8f51PRN; arc=fail smtp.client-ip=40.107.102.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YY28BOY+EEeYsf6aLpY6v4xxtGU+miS/pgd74iHlj9mAmiAjW9NXVbgrQkoPzl5Uvp+EUlDqNlya7iKyVy3yXnqFa8/p+Xtyx/27zYmdCOxXRsBEBZHgMDj4tMk1/zZiZ57iOooMFhkSmD+/vtMf3T3wOym5EUSnweD03h/LAC9wsTU7NS2MjKz7eJHaHCsbAsbagS9Sr5DL1+zuw6nYvGgFOpCLrs08S3NUcZExQG6BrO4vOAgfoIJFyBuRnk4n+ZukwUK/aV0yjNcMhRBBqB3i7EQaNuUN9cijiqhLjwf5UR6GDBtohKe8nN3XQFuA4HO/BCvefHABmL3vTRedww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wVTGbioiwEqERBIgfy7WwbEHTd+DQ1dV6qdAVZe4iYg=;
 b=qHnE3B4zBmbqIIil+d4xMfOQSk9qBukyZMnLfJZ+J4G90T7uj+f9/A/zZOWXUCgxHm8EXOhWFsE1qmsXXVFySMZSzOAjguO0CwgqoS8T19gLcPsoH3blBJogtKfI+80ssLLzz2GrBxD6fr7lvUi1oekicS9pNPHuq+oJx2TYqdG3bhOE2xqYMnBWGkrIotiK50+IxwYw504uvn76PrMXuRQYoFQ28FWTRNY9UUzqRygLtLfz4nCH0AY3XEYQqVRRp4Vpp83JFVNwBborA/rPE802kKo79bm9W1pSpBLVXg0LmsB4u63z6v1fM2odauG5VmAcGtbfHSleqgrMrhNQYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVTGbioiwEqERBIgfy7WwbEHTd+DQ1dV6qdAVZe4iYg=;
 b=W8f51PRNiIRNVpBgv14Ez7wZOMHr3REfJYTvLD+XKrkFLMnulJtXqZ9mhskTh2GOl3DTOyqG4+w6NtSIIE2eXQSC0KXkWeet0/n1KFn/02o22M8Jc6WyxBmz8EIQShdPR7xVo9fxzl6zYuNyT9SKQGydAio+k34If7FF46DXBv0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM4PR12MB6614.namprd12.prod.outlook.com (2603:10b6:8:bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Fri, 31 Jan
 2025 03:18:11 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8398.017; Fri, 31 Jan 2025
 03:18:11 +0000
Message-ID: <93e8a84a-d4cc-4dbc-a593-99995b000947@amd.com>
Date: Thu, 30 Jan 2025 21:18:08 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] x86/sev: Fix broken SNP support with KVM module
 built-in
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com,
 will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com,
 dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org,
 kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev, iommu@lists.linux.dev
References: <cover.1738274758.git.ashish.kalra@amd.com>
 <8f73fc5a68f6713ba7ae1cbdbb7418145c4bd190.1738274758.git.ashish.kalra@amd.com>
 <Z5wqN5WSCpJ3OB0A@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z5wqN5WSCpJ3OB0A@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:806:d3::33) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM4PR12MB6614:EE_
X-MS-Office365-Filtering-Correlation-Id: d4fee458-047a-43aa-3dbc-08dd41a5e445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NExBNlFycTdvU05OMzdJU1U0Zm40MkdjaHA0SkpsQWJIMDV3NnNBSEIxQkZy?=
 =?utf-8?B?cFhkbHl6ZzRDbU0rYWYwanlDUG1TL1JLclRCeWNWbHhpVU5qNXplb0RTVHlO?=
 =?utf-8?B?WjZwcXM4cWRweC9NS1RrMU1YQ1VlNlBrcEZIRGIxT2s5M3NQZURUQmlHVVJq?=
 =?utf-8?B?QUwwN3R0dWxHOHFrOWJWMHlrL1hkbUR3Zms3M095T1RFL3lRcUE3Z3duRHlK?=
 =?utf-8?B?UzUzdnJ1dzFqdG9EOW1XcFhLT2dYa1VSV1BYTXJkMHNlK1ZrdjlTaFBhb0tl?=
 =?utf-8?B?QXJnRjE4MFZQRE9ONWtZZlhhUkliNkg1REhRNGxqczd5UlZBa0RGVDJYSjc1?=
 =?utf-8?B?cUIyTlFURVpVYzJLVE9PRThjYjE3YTdKM1FVamFCZW5maHVnT3JSdGFhZ2Uy?=
 =?utf-8?B?NWxvRE5MbHROcHpGK3RkdDFOczBOczFXUmVkZ3kzU3RKWWtrdGZYYVZOVUN3?=
 =?utf-8?B?SW9FUnpuT3hWcUpYanNxdGVnNkUxZmFPYVI1cU9TZFBobVdPVDExaFBBeVpY?=
 =?utf-8?B?Y1BKTDFTVXg2c0hvMzFaSGFFTGUyWEJoYnNtcWJaaDFtZ0txOHZCaytMUGE0?=
 =?utf-8?B?aWlNVU1qK3FYMkRJazdGNTBGd0VsejJRRGJGTFZVbWZvRElmMUlINzVXa1Bm?=
 =?utf-8?B?YkFUNW1mUzlsREJJcWtHZmZKaWRLNzNCQXNzcHJUemNtZHNhUkFrUExLTytx?=
 =?utf-8?B?N1BXY1kveXRqRjFWdzJwZVp6QVc0dmNOV1I5WnZUak5LMmh1ZTRkRklaUWt6?=
 =?utf-8?B?WWZiNDBwZG9pMi9oRWljRXJCTm9JMGFYZHp6OHo1bEluMU5Ob0l5M25Ta0V4?=
 =?utf-8?B?SGlaSkYrNys3VERVSnYvSHU1YmlERlR1dWFGWDlnTjRueTkzUTZhc0JXK1Y1?=
 =?utf-8?B?UHkreXBjL3FIenh1ZE1tazMrSEdTYXNBUjFUM0xvOW01eC9aYjZ1RVBVbEVR?=
 =?utf-8?B?bDBDTGhhVmRUZTh1YW1uU2FvQ3hDMGZ2c0ZmUlVjT1NQM2V1ZVhFblUyeVk3?=
 =?utf-8?B?dGJVMk8rK0VITWFOVGdTdmZJM2VQdFEySnF5NmZJcXFnc2ErN1ZzWnJxMU5a?=
 =?utf-8?B?YkVWQXM4RTB5d3A1L2d0c2VFU1U5all1dTZrdm1EK3JLck5WVG85Z1U2S0cw?=
 =?utf-8?B?UTRaaTlXMzdoTDNXajNjYzdoRGMwMVRObkhMZlpMd1dpMlRSRDc4YkFiMHhk?=
 =?utf-8?B?d1A2WTFhUTl5cUdIZ0s1dEJ3OWt4UjZRTEZOQ0NPRXVNTG54NzRxNEpYbXIy?=
 =?utf-8?B?Qy9Edjh5bkNxM2dNOFFmL2VvdlQ4YlRLUUM2VVhPOUpnUit5djA5VzMyZmEv?=
 =?utf-8?B?UW5nNnFuQTlFdlMydENOM3VoVWk0aVBNVlB3cnBQOWQ3MVRFeWxIa09tN1Uy?=
 =?utf-8?B?MVNOQkc2UFlhRnh6K2h6WnJZVkNRNkpUT1A4S0drMkdVL2Z3cjVDSzdpaTB4?=
 =?utf-8?B?UTdvcndKbFk1QzFhUWJGK2J0RElLTlVGZGpJTWNmR0lyaG1XemxjdWF3YkNw?=
 =?utf-8?B?RFRqNWVNQnc1dVB0WXpmN1ZhNm9jUDY1UFYrVmhEbzFxVmxVYlV5amdwN2dP?=
 =?utf-8?B?Y3IwSTRmdDFRaFVQdVlQMlEvR1AwRVFtWllOUWNVZVg4U0lYRmFNc3VZcGJW?=
 =?utf-8?B?MXY0WjdnMUlmMzlzcWNGZUVVZWVoN3BJNERod3JTN0lzUFUvVElxWDZtVmpH?=
 =?utf-8?B?TGV6ZXZsNzdvalZtbjUveDU0cThPZzlFZ2xMcHZZaTN3VURaajdFSVNtMHZQ?=
 =?utf-8?B?cHpYbGRucUFuU25saDVvTGpPVFRMM1RrUk9jdVg1Y2VaUGZQOUI3aHRUb2lT?=
 =?utf-8?B?NCtYd0hpWDN2N0gvWGRzVC9mNldGSGd4Z1VRb2xkMDlqN0h2ekFlNHpad2tO?=
 =?utf-8?Q?B8Q5uDCSNUVqg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHI0ZnN4T3J6UzBWb2wvT3hWYW9VTWlUVml0Y0wvZVFjeWlTaFpHSGpZUWFG?=
 =?utf-8?B?VDNEaWVxeUF0QUp3NXEvREpzY3ZmbzJ4RC81UGJYK3J3R3hVWEx3TEg3TDhy?=
 =?utf-8?B?cHZKK0NDdU01d1hLLyt2cmFFeThnTzBZODUycmFETUQ2dk5nU3dtc21BU3pl?=
 =?utf-8?B?bmhJWFpxckJsbkJBZkpCby9ZVDlzc0RVQTNjTURvV2VLbldrTS9USnBnc2NJ?=
 =?utf-8?B?aVlNKytPOXhOOUNyYk16MXZiYldEcWt4eEkxTEorMTRLK2NFVC9LdEpZaWVy?=
 =?utf-8?B?UGN4bUd6aFdzSG1hLzdZWVFNcVdqSnM4Skk1QmNDUU0xZ1pSNE93cEp6bGQ2?=
 =?utf-8?B?RWorT05UVmNTSWtpL3czVWJETnhzOG9GTjBXTXBBMnBKdHBhcTE3Zk9Gb1Rj?=
 =?utf-8?B?bEVwQ0tOYVBUS21RU3lIT3czYkw0Mk5kZGdURVJSNTRiMDdNVGpGV3lUTEtB?=
 =?utf-8?B?R1p2UFFZQTBOckJEK0N0TFZNVm5TazIvSDBDNUVnaVBHeHp3Qk1GOURNNVRD?=
 =?utf-8?B?UXl3WEtYaFloM1NHRW5yOFNkZVVYN2JocUpWeE51eGFVMHp2K2k3dm1XeUE2?=
 =?utf-8?B?MVBWTVVUUlNqRlFGYlExbG1hSjlhV3JUWE5DelR1VmhxWHZzRFp5UDJwSXpT?=
 =?utf-8?B?bVI2d2VGamo5eUpWWHpjNVVsR0lXWWIvbElmUmJURHE5M2RLTm95ZGthRk12?=
 =?utf-8?B?WS95cGs1dmtXZjV3aUNYTjBaOVBQVGx6eWw3TkNKbkNaR3dHVm9ia1poRE4r?=
 =?utf-8?B?S0VQdDdVSjFBN2VRQTlPRGdST1BjaWR1TFE3Ykl0SytobjdEWGtmTDFBb3Ey?=
 =?utf-8?B?YXdKYkl3YzR6dk8wVzhBd3hFdkhha2FRWmpFRythYnUxY1JhdFpoQnhxUXBm?=
 =?utf-8?B?TW1sb3d5ZnNKdHVYM3M1S1lJWkR2ejc1dTh1ZjhBdUlLSnl1VGoydHBKT2d5?=
 =?utf-8?B?Rkg5NldrYy92azB3T1dhdnlYYXZiVy9qTlB3QzBqRkc0QkxpQkFTVmU2S3Vh?=
 =?utf-8?B?bXRhbnluVzNxbXpwQlk4NTl5Zm1iNnN0SXRzcmJybHQrSVFPdWNiMDdIZ3Bq?=
 =?utf-8?B?TnlrUUlaaktjSmlJQ1M0YjFNeGdJQUtFMkZtbXdVaHpUdHZ0WU9qQzZVSFpm?=
 =?utf-8?B?SGxuRFZ0Nmk4cXFhZGNjcTl6SUpNZElVTlJyMnZYZ0k0VDg1YktLTHoyTTF1?=
 =?utf-8?B?REtuNmFRSEZ2UDRMa3lhb0h3NUxBajdFdzdqZlk1dzA2YlNjSzVYNDB5Wmlz?=
 =?utf-8?B?UFMzSzdtUHVvYm5odWtadytISklSZzU0Vk5aWGpMWnNHR3B5V1k4eXBNUFAr?=
 =?utf-8?B?K05hQ3VuQy9LeHBPVHpKZmdlSVd3WkIzQ0E4K0pFODY2RnpuSTMzWEw0UEFC?=
 =?utf-8?B?K2hCbWxteTVRdXFIZDJpTzUzbWFrd2RVV2RLQS9SU1J2YnFTbFZFc085c0JJ?=
 =?utf-8?B?QUN5QUY4Ui9HVWZHMXNwdkJkVWMzMlMrcWtyV2xrcFVudUVnbms4TkVHR0Zm?=
 =?utf-8?B?TExTKzA0TG5oU0VpQm1oeFAwNlpxckhVUk5tU25CNlRJK2YrZmkzTFQ4dE10?=
 =?utf-8?B?WEhxRHNlZlhGQm4zNXkydWdFdldTSnlUdlpROFVONlZubjRFeERMSkFkaitv?=
 =?utf-8?B?bzZpTGdsZlRVNFFnYVRiUHFPcGZJdkpKSEQ1RHZxTFVlOE1LdDJxNVBnZndp?=
 =?utf-8?B?NlBwSGthdWQ3M2RUWGZRdEJoam9hQWMxTnFjQ0UvYzcwV21qQkQ2bDhibVRJ?=
 =?utf-8?B?SXUvU0hWRHNsNnNMcDVEWlpLY0FhR2szVHlsY0VEK2ZCWlAvNG0xQk5hT0Jw?=
 =?utf-8?B?TUdrS3NPb2c1MW1nZEVuLzhEVmQ0OS9wdzVJRDIxZzFrdUNEWjRuRjl5WXhR?=
 =?utf-8?B?NitvMFllbTFzZXFpSzd0UU1nVmQvMk1zelA5bTJmdlhDMmo3N0k4TzAzSndZ?=
 =?utf-8?B?S21BWFhSK3ZwUnJKejhwd2M5QmFYT3lzY2pSTmFUU2VqYXdmYytoSlJ5RStX?=
 =?utf-8?B?L3pjNEdCcmR2b2htNGFXZmxLUVdNQ3ptSUF1dEZHeEl5UWNZb05ZZnUxRjZj?=
 =?utf-8?B?QVNmOUswdGVyVTQzTkpUWVQ3TXF6dVYwb3JTUFB4Y1NVTE11clNRM3JjdlRa?=
 =?utf-8?Q?6ABZg/A+ZoR0efw4LdxAL5B8U?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4fee458-047a-43aa-3dbc-08dd41a5e445
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 03:18:11.3736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAfH4F1iDXradGvc3sTNKtxcQdWZo5jSiN4qULtyCbFjZqgVM7RGXt2txPSA9PSnj+diySeYrnByp+jqGltAAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6614

Hello Sean,

On 1/30/2025 7:41 PM, Sean Christopherson wrote:
> On Fri, Jan 31, 2025, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> This patch fixes issues with enabling SNP host support and effectively
>   ^^^^^^^^^^
> 
>> ---
>>  arch/x86/include/asm/sev.h |  2 ++
>>  arch/x86/virt/svm/sev.c    | 23 +++++++----------------
>>  2 files changed, 9 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 5d9685f92e5c..1581246491b5 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -531,6 +531,7 @@ static inline void __init snp_secure_tsc_init(void) { }
>>  
>>  #ifdef CONFIG_KVM_AMD_SEV
>>  bool snp_probe_rmptable_info(void);
>> +int snp_rmptable_init(void);
>>  int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
>>  void snp_dump_hva_rmpentry(unsigned long address);
>>  int psmash(u64 pfn);
>> @@ -541,6 +542,7 @@ void kdump_sev_callback(void);
>>  void snp_fixup_e820_tables(void);
>>  #else
>>  static inline bool snp_probe_rmptable_info(void) { return false; }
>> +static inline int snp_rmptable_init(void) { return -ENOSYS; }
>>  static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
>>  static inline void snp_dump_hva_rmpentry(unsigned long address) {}
>>  static inline int psmash(u64 pfn) { return -ENODEV; }
>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>> index 1dcc027ec77e..42e74a5a7d78 100644
>> --- a/arch/x86/virt/svm/sev.c
>> +++ b/arch/x86/virt/svm/sev.c
>> @@ -505,19 +505,19 @@ static bool __init setup_rmptable(void)
>>   * described in the SNP_INIT_EX firmware command description in the SNP
>>   * firmware ABI spec.
>>   */
>> -static int __init snp_rmptable_init(void)
>> +int __init snp_rmptable_init(void)
>>  {
>>  	unsigned int i;
>>  	u64 val;
>>  
>> -	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>> -		return 0;
>> +	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
>> +		return -ENOSYS;
>>  
>> -	if (!amd_iommu_snp_en)
>> -		goto nosnp;
>> +	if (WARN_ON_ONCE(!amd_iommu_snp_en))
>> +		return -ENOSYS;
>>  
>>  	if (!setup_rmptable())
>> -		goto nosnp;
>> +		return -ENOSYS;
>>  
>>  	/*
>>  	 * Check if SEV-SNP is already enabled, this can happen in case of
>> @@ -530,7 +530,7 @@ static int __init snp_rmptable_init(void)
>>  	/* Zero out the RMP bookkeeping area */
>>  	if (!clear_rmptable_bookkeeping()) {
>>  		free_rmp_segment_table();
>> -		goto nosnp;
>> +		return -ENOSYS;
>>  	}
>>  
>>  	/* Zero out the RMP entries */
>> @@ -562,17 +562,8 @@ static int __init snp_rmptable_init(void)
>>  	crash_kexec_post_notifiers = true;
>>  
>>  	return 0;
>> -
>> -nosnp:
>> -	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
>> -	return -ENOSYS;
>>  }
>>  
>> -/*
>> - * This must be called after the IOMMU has been initialized.
>> - */
>> -device_initcall(snp_rmptable_init);
> 
> There's the wee little problem that snp_rmptable_init() is never called as of
> this patch.  Dropping the device_initcall() needs to happen in the same patch
> that wires up the IOMMU code to invoke snp_rmptable_init().

The issue with that is the IOMMU and x86 maintainers are different, so i believe that we will
need to split the dropping of device_initcall() in platform code and the code to wire up the
IOMMU driver to invoke snp_rmptable_init(), to get the patch merged in different trees ?
  
>At a glance, I don't see anything in this patch that can reasonably go in before the IOMMU change.
This patch prepares snp_rmptable_init() to be called via iommu_snp_enable(), so i assume this
is a pre-patch before the IOMMU change.

Thanks,
Ashish

