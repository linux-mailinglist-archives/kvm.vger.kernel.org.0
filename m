Return-Path: <kvm+bounces-55565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06FEBB326CD
	for <lists+kvm@lfdr.de>; Sat, 23 Aug 2025 06:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD91B7BB98D
	for <lists+kvm@lfdr.de>; Sat, 23 Aug 2025 04:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE6521B1B9;
	Sat, 23 Aug 2025 04:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HpUHe+2r"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2087.outbound.protection.outlook.com [40.107.96.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F8C393DF4;
	Sat, 23 Aug 2025 04:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755922835; cv=fail; b=q3LUxaPu/4oBIVxzqSvMcuToXGANBxTmZg9JadOR2YtTWJVr+dOk0sUzrIo4tj3xLQtkO2RgfTbqFYIXU9N9r8pJ5Dmr0mLPLkYAzAK0fKaVSwool7XUGwo2aXd2QOuX05tJ2eoVt/IEc175T/v7ujp7JCufv55BPQKZNoxN4Ds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755922835; c=relaxed/simple;
	bh=1xmuWgk7P+M91fUW81l+4nesEm6cNw3wnzAwbcThdqc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bqCGArryyj1U4h/uwA1OvJVQT51PHxsBEukS+Pf4Cl1gtvckCo57gNTrKpx1Zo8JxNgwG/3F2cdjIaey0pu9QkSsNTGSAeNa3Te9Z3uQ9IXWFJ04jvQPydohlsWQrhjENRCX+8/MVCpZizgNHDG9dSJkox0hTdiLg03XcfBvcRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HpUHe+2r; arc=fail smtp.client-ip=40.107.96.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yawfbwp23oU0qLWM8AdwiOyEPgPPY68Ca5rBGfJBltUAT4WlHYdcyLyDU1IKMubTwqnRvwj5jcUTpQlUAAkDIg9MSH+ItnzuloQOvoGX61/4Qnk8Nd7dIgj47fvCu7dU3axHNYcvPt9EtB4ekH1YiuaLpHt4P/Oq5wvxEs/jx8i/e0chWXZ5TOI8xGtC+I/ASibBDXEbZOget76cg68YW7xhTHYHZ1XBZNlyPQB0DBzXas+ZlwN/Lvk+zxgALugcxDcCK/JcSHmp8ls4EK3PenHDydMAd38XxnW3E/OU89sV305EwVEUD1jyayjNnnPwNhxJEMqvPhfkWX9C9pUEOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9c8PmbS1xhGuRy8mk1tyb2gY5yQtAZjaVWnhKtq/pc=;
 b=PopoHSXHyftbUKo5qzxDTsiGQhGof/Nz+npEu4QLJpuW5D9NxGnZAgdA2gfwSXWBxnqzEita9zP4WWg/6zDGNd3ljYP+peK419YehPqOtH/ipKWjG+rbARxc7Pyx6wv9AXN8w7YnY4zEzlrGETNAAF4AaGUXcZofNoGL0wUKJca5BYFJJwm6C/Wtj97r/niptngRrYQsL42kySNQamNqaIVXX1OfmIjcXah7IgwmYt8Cgz1nbFWICa1OkMvIgO1OPmxH0KJS7ycRnJJoMhmHtqz97+LFxK/o9LlecBaiFtmzBdYr4KLGGRbEeTZmu5+T61AMYeuKKzb4+Hxc8GhS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9c8PmbS1xhGuRy8mk1tyb2gY5yQtAZjaVWnhKtq/pc=;
 b=HpUHe+2rdUEz77grHw6aB4QmtBcKfLK158jc4kznxt+8zbvhsYBK3F4W8lruNp9DGe7MQzNX4d3rjSH6l0W2R9DHKgL44k7SPq6DLmJYmArQ1b22nXHW5IFZcnnObVgo8884gHxKXbsPMgGgBjoPRs0R9FGysCnv/vzY2P0wDNE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 DM4PR12MB6542.namprd12.prod.outlook.com (2603:10b6:8:89::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.17; Sat, 23 Aug 2025 04:20:31 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9052.017; Sat, 23 Aug 2025
 04:20:30 +0000
Message-ID: <38a97d8c-ab5e-4d47-b379-5d114ac66c09@amd.com>
Date: Sat, 23 Aug 2025 09:50:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/18] x86/apic: Add support to send IPI for Secure
 AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-8-Neeraj.Upadhyay@amd.com>
 <20250820154638.GOaKXt3vTcSd2320tm@fat_crate.local>
 <29dd4494-01a8-45bf-9f88-1d99d6ff6ac0@amd.com>
 <20250822171441.GRaKilgR4XCm_v-ow_@fat_crate.local>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <20250822171441.GRaKilgR4XCm_v-ow_@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0010.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::20) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|DM4PR12MB6542:EE_
X-MS-Office365-Filtering-Correlation-Id: f6506df2-b7e8-4cf4-55fd-08dde1fc6541
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S3dtdlAzN2FLMlc2RVFibUdiVWxYazMwRFdNRFJ5SFBncGdXa0ZYTHRpWVg3?=
 =?utf-8?B?a2l3VHBLS0Y0cm00dTE4SHFKNmFXdXJ6Nkw4bzFDMTk0MVQyZDltUldNM0NJ?=
 =?utf-8?B?TVAvWE8rUm5lNHJnZjlwSVJycXJDdmZZQlpCN3NjdGtySVZNemJraVBuY0pi?=
 =?utf-8?B?NGFBTG1GSXpYZjJ5UWtIRElMNk8rcE1sUE1UNDM3NS9leVRnQmV5UjRsS1di?=
 =?utf-8?B?R2lERlBvbW9USURZSHV2T1pyOFI5ME54bEF6ZjBkeVRCdytZUDByVlhCMHd1?=
 =?utf-8?B?RzJWYmZWVHNIbU5lckQreWgvY2F1dDZZdEZ5anh0U2tOSFRXYjBVTEFpaVlU?=
 =?utf-8?B?aXVkSVZLNVhtNkF5djd3QVI0M2kzbHlIWXVNbTkxSmhDZVNsZjhhalEveHpL?=
 =?utf-8?B?TlU1MjFlUitCcnc4dDBEYVl2U0g4elZablZ0eml1Q1g1WnE3dVBWVjhINlhu?=
 =?utf-8?B?VDh2QWFTNmxKQU9PMFpXMEp3ZjNvSWp0MVV5R2t5cE1nMXcrYndhc3d2NGRo?=
 =?utf-8?B?ckJoYWcwc0lkSnVYQUxLMUFnL1JKYkw1cW9Sb1cwVGwzYkFhSWYwOUxIUEJH?=
 =?utf-8?B?bU9FMitubjRhUmc3c1BkRXJxODQ3eFA2bzMyUTJIMlhZK1Nldm9zY1FmeExr?=
 =?utf-8?B?MG41MG45KzEyT1NmQjhGSUJUeU82V1NiSmtlOFovaWF5Qk5xcXRpWmhWZGFq?=
 =?utf-8?B?clA0RWJ3TVZ5OWxuVW0rYVFURjA2UGN5REo2SEM2cVpzWXEwS0hzd2JzU3Fa?=
 =?utf-8?B?QUcwbWRVS2tpU2FxeFBnQzVvZ3gyUGtqVTlwUXk2S05NRGtIcTA4ajl0Q0I4?=
 =?utf-8?B?dFFUVlFQMUhTeExFY2tySzVmN3FocGJWN0N1TzNEaFdRampKeHNJTmVlN01B?=
 =?utf-8?B?WWFtSU1CaFFEZXJtVmFBbjBhZjN1TWk5UHA3K1o2U0g5WVcyQk81WjFRVkIr?=
 =?utf-8?B?RHhmVGFDWmg0bDd0R2EvSTJPYXBDajRMczhiaE1rMmdlYlhGbDNJTFJXS25l?=
 =?utf-8?B?bVRUWXhpdVhZai9pU2ZmbEU2SmVPUTlRcmI4VWs4UU1WS01PWHltTnR0S3Zn?=
 =?utf-8?B?Vm5ndVBGSlFRZE81eEUxZ2Q1UTRzVVhRaGhBSUYzRStldFFUOUgwajZ2bWFt?=
 =?utf-8?B?bEVXbCtCRjBSVThnY1BXV1IvQ2FEUmdhUVdjVXZVMzRSd0J2ZEZ0S3pCSXNT?=
 =?utf-8?B?T2NNM0lyNUNHcy9HRFhzTkdaNDBqSHlGay9YM2FDWFBFeThNcFQ2bzJ6Mm1L?=
 =?utf-8?B?Qy9HY0Y0bGFCQkNzU1JvUGVJM0dHdUdhMitmZjV3TndvUHIxcnFWaDUwdVI2?=
 =?utf-8?B?SWt4VGRaNit6cHlSRkhQQnVBcmNEdXM1RDN6YUR1b1BvY3JaTkVhUThKekVM?=
 =?utf-8?B?WldlTURZeGJFZVFqR055WDlpOXcrN3ZEMDBiRkdkc2grT0RQQURSdnhKaWVS?=
 =?utf-8?B?UGV6Ri80emJtY2d6OGJOU3dnSnBWdlpZeEhHQXg1QllXbE5iNmplWTZMaEtE?=
 =?utf-8?B?U00zTk9OQ1RUWitFOHVOVjRSY2pWQnVLSE0xcDlVS2pkRHZxM2JEY213OUVi?=
 =?utf-8?B?MUQ3UFNEcUpic2Noa3hCS25OYk13NmIzMzNnNTFCREZlQm1UcitZVjB1bTF3?=
 =?utf-8?B?cWVLS3hPRTJNU1NLaGJZYnNCNE5OYy81NVBZRGt0RFM4eG4xQzdCenNBMmgx?=
 =?utf-8?B?c2x4a3I2L3VVRm5YWFNUYkZjcUV4NGFZbm1melU1YktHakpCZURhdm9pNHA1?=
 =?utf-8?B?ZWtudlVwajJWWDlZVlJEME1QWkdNZjhiOHhlS3FIdktsV1JPbjNMNDlxRTN1?=
 =?utf-8?B?MlFXelFNSCtjWWt0clNlTUFYLzhVdFZJSmxuQzcrdlBYWnU2d3hVSEhFQ3Nh?=
 =?utf-8?B?UjE0QVBoWjNvUmw0YnY2VU0rT0dDb2tOeTlXV0RacHRCOUNkL2JETTVzbXVO?=
 =?utf-8?Q?N9y/0yNAVgA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUNWM1gwY1BObU1GSEVUUFBtQU9ScWNFUEtxT0kvQ0g1YlpyeFVnUW5aZisy?=
 =?utf-8?B?bERPUmRROThaaStKRCtJcVYxYitQRWpMaHhpeVFzdVdDbjIwcm4xalBRc3VD?=
 =?utf-8?B?NXI0SXBudzUyVjdLTFVVRlRzUGtiajZyWVc1UG9KL0hxSGVlM3VwdjFwV2Iz?=
 =?utf-8?B?ZFkxbTJybS9lL21vRUdQa3FWVW1QR3k5dDZlUVBldGQ3ZmJ3VktMYkxqbWJ4?=
 =?utf-8?B?ZUMrSzBkOGlyQTA4VmNnUkNPRWxTYkFrWkRVRW1pVVNVN0xNcmVydU5FNUVm?=
 =?utf-8?B?bWVZY0JyQzZ2Rlp0MHhqZWtGaWJ2QkQva3FCTmYvaWwxb1Brb2QwQVdvUncz?=
 =?utf-8?B?YVFFTytkSnpaNmZYQ28rbE4xL3Yya2tEcHZxOEc4eGQ1UUR0Q2w4cFFSemdR?=
 =?utf-8?B?THF1cUt0M3V6SjZFNGxaWXlMOUdiZXpqZE5DTFhweXZ0Ykd2V3Q2MUhSV013?=
 =?utf-8?B?dXBZOVZtT0ZIN0ZTdjFWVFdHcVlHTFRzcWl5QTkybVpqMFRMVENSSWsrVnBh?=
 =?utf-8?B?SUNlWks0TW9qME1qakQrS1J0N2xpNFRpWDdFMXZkWWFmUStUUUxMSW9MSjRL?=
 =?utf-8?B?NUI4MWdwSmc1THJ1a2JyRVRrZWQ1NlBMSno4WCtndDRkU0FkckROOFpVSHJL?=
 =?utf-8?B?d2VkS1N5STBhYnhuMi80UVBEakxwWTlkQ3VyRlNZTDFYeGZUR2ptWWE4ZExW?=
 =?utf-8?B?UjRvVXZBdTNwZjl1c0RtZ2s3TkJJS2c0SVBDQSsvUU03RkRUQ0dzYzZ4b3Ju?=
 =?utf-8?B?UE1wRHVyN01WbUR4VnM1VG5sZ2hRVUhENFlDWTE0U0VSanBzVTlaczM4QWlw?=
 =?utf-8?B?elpQN04ySDdTb0lkNlRrU0dQSWs2L3hMN3pXQW9OZFh4bU1SRFdhSmF6aEFM?=
 =?utf-8?B?eHpjWnZBRndRcy9sRzM2S1RLSHpva1RsTENYTUd2eVkvdmsreXFVV0Q3Zmcw?=
 =?utf-8?B?UTlJMmh1WDhlVUIwYVBkNTR1OHZ3WVlNWWNLRVBXZmJvYU5OdUR3K3Z5d0pq?=
 =?utf-8?B?c2RYbFhUTTIwek0xRk05aStWdzVRSzh2eVpPVktIeVE4YVZGdUhPenZEbEkr?=
 =?utf-8?B?K1V1VFJkK0xWSy9VVld5QjdZVkNOaXV1QlZrZUU2eVlpN3I2TTBUQ0J3Z1BI?=
 =?utf-8?B?V0dseUZRRlpialpFWkk0cnJab0kzQmJtcUoxVVplRUQxenlDOHlEd0FTTVhZ?=
 =?utf-8?B?alNnN213ZS91SWpaL2hDTmJJL1dMMVlXWFFrbXNDT0FzekhXTDY5S2RJTHBs?=
 =?utf-8?B?ZGcyMXhhQlVZSVhIUmJOR0trdm9VODRnTFRnNkdPVUR5TnorNWVrTzRwRnBw?=
 =?utf-8?B?NzhUeWo1V3BLWVlzRm1BS2pEcWJnVnR0OExzUURna3lLWTZEcGM2eitFZ0pN?=
 =?utf-8?B?K1FodlhaSFNibU0xMkMzTDNDZWppZTNpOG92R1lrUDlqVC9jVDRPampJV3dS?=
 =?utf-8?B?ZHhydTJRSXA5MStQa0loOVFhY21UY2lpdS9yeUZWRE15Zm43Z3c5L2F5WU9Q?=
 =?utf-8?B?T0UyQklQSVpwSkJJQmZ0eFhYMnhydlVFSjlQcUdIenlBcDlEeXMxUG1WZnFL?=
 =?utf-8?B?OXo3cnVtdld3VzFTVDVNVFFvZ3dweVZGVTUyT3dBNk5odlM3OXpHcG1LOHBm?=
 =?utf-8?B?WWRjSGNGcGNyWEZwd3ZkRXNVajRtMU5ZcVpnQWVWdlFrZGF5bm8xY2Z0TmNq?=
 =?utf-8?B?YVVBNnFRTHpEeTFxRTk4c1VTOTg1SGlBNlpWWWJ1V3JwOGZYVVRjVXJXbVk5?=
 =?utf-8?B?SG04dGNGelNJbWxUREFPRllWTm8zc2l5YWRxZkwveXl5SFppcU5ZaFpzQTYw?=
 =?utf-8?B?ODVKZmw5cXA4dTAxUkE5YkQrb3M3VTR3VXp0T3AwL05hNmJKc1BLdkN6b0p5?=
 =?utf-8?B?OWxVMXAxSjFnUm16Zyt3QkVvdFpiQkhiOE1kcHVvZnA0RzdLT2ZpZDcxWkVH?=
 =?utf-8?B?Nloza0lXZG8zdzMzaDhweVBGWTR0QWlneVE1TGFLcmlUNExoaFNpS09OdU5p?=
 =?utf-8?B?NkFCWVpndlFPbWJqNklNbUxOTlBpVzRrSllaUzIvSmtLejFXejN1MjNGWGZy?=
 =?utf-8?B?cGJwQ2MvaWxqUmtLdHdBWmVXZnNVOEZEaXRzR1RRS29YOVNOMTk5dnBseCtj?=
 =?utf-8?Q?gRiG++Tr8pWmXpxXwulL5K1fG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6506df2-b7e8-4cf4-55fd-08dde1fc6541
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2025 04:20:30.7269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMrGLgRafM0txSFi60nAN2DuTi89ynimglnOwF9E4yW2x3hbIv8gO9lySKEjh8mSWGIaZnHYLRkJFRi8+XPAGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6542



On 8/22/2025 10:44 PM, Borislav Petkov wrote:
> On Thu, Aug 21, 2025 at 10:57:24AM +0530, Upadhyay, Neeraj wrote:
>> Is below better?
> 
> I was only reacting to that head-spinning, conglomerate of abbreviations "AVIC
> GHCB APIC MSR".
> 

Ah ok. I thought you were not happy with the commit message 
wording/structure.

>> x86/apic: Add support to send IPI for Secure AVIC
>>
>> Secure AVIC hardware only accelerates Self-IPI, i.e. on WRMSR to
>> APIC_SELF_IPI and APIC_ICR (with destination shorthand equal to Self)
>> registers, hardware takes care of updating the APIC_IRR in the APIC
>> backing page of the vCPU. For other IPI types (cross-vCPU, broadcast IPIs),
>> software needs to take care of updating the APIC_IRR state of the target
>> CPUs and to ensure that the target vCPUs notice the new pending interrupt.
>>
>> Add new callbacks in the Secure AVIC driver for sending IPI requests. These
>> callbacks update the IRR in the target guest vCPU's APIC backing page. To
>> ensure that the remote vCPU notices the new pending interrupt, reuse the
>> GHCB MSR handling code in vc_handle_msr() to issue APIC_ICR MSR-write GHCB
>> protocol event to the hypervisor. For Secure AVIC guests, on APIC_ICR write
>> MSR exits, the hypervisor notifies the target vCPU by either sending an AVIC
>> doorbell (if target vCPU is running) or by waking up the non-running target
>> vCPU.
> 
> But I'll take a definitely better commit message too! :-)
> 

Cool!

>> Ok moving it to x2apic_savic.c requires below 4 sev-internal declarations to
>> be moved to arch/x86/include/asm/sev.h
>>
>> struct ghcb_state;
>> struct ghcb *__sev_get_ghcb(struct ghcb_state *state);
>> void __sev_put_ghcb(struct ghcb_state *state);
>> enum es_result sev_es_ghcb_handle_msr(...);
> 
> Well, do you anticipate needing any more sev* facilities for SAVIC?
>

At this point I do not anticipate adding new functions for new SAVIC
features.

> If so, you probably should carve them out into arch/x86/coco/sev/savic.c
> 
> If only 4 functions, I guess they're probably still ok in .../sev/core.c
> 

Ok. I will keep them in sev/core.c for now and move to sev/savic.c if
anything new comes up in future.

>> This comment explains why WRMSR is sufficient for sending SELF_IPI. On
>> WRMSR by vCPU, Secure AVIC hardware takes care of updating APIC_IRR in
>> backing page. Hardware also ensures that new APIC_IRR state is evaluated
>> for new pending interrupts. So, WRMSR is hardware-accelerated.
>>
>> For non-self-IPI case, software need to do APIC_IRR update and sending of
>> wakeup-request/doorbell to the target vCPU.
> 
> Yeah, you need to rewrite it like the commit message above - it needs to say
> that upon the MSR write, hw does this and that and therefore accelerates this
> type of IPI.
> 
> Then it is clear what you mean by "acceleration."
> 

Got it. Will update. Thanks!

- Neeraj

> Thx.
> 

