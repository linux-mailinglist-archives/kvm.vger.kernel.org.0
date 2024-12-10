Return-Path: <kvm+bounces-33383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5449C9EA77C
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 06:02:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57924166413
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 05:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38E71C5CBA;
	Tue, 10 Dec 2024 05:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4SKDouS/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2043.outbound.protection.outlook.com [40.107.102.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBC8BA3D;
	Tue, 10 Dec 2024 05:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806957; cv=fail; b=KS5Z78/KMCFFSUjuMOi8zgY9lohDEKnIR11r0dMLfyas3dD5ejQGeJ2Xw6nSW2MYnfVV3VvvIm2o3kQma1jM4feUAh87/ZxIQnXQAEZTinviM5+fStE97IqwheoyzEo4/PKer253h4CBQ4mzCsoI5OSDJHmELIZR65YgbVc6lNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806957; c=relaxed/simple;
	bh=d+5jZORjUYXwK1NE65zxN8IHyXmWNI3etdxgn54ZZSU=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HarufaPGXN4QSVjbIHkRA2Ig0n3mhdBaIWPLQkaDoq/nPy5bcBcrMq3bIbA6GNVeGr6EKi6VdWicLjHKqFb1P1rJb+Lr88LCDPqabo8rSDPfBvKnmGk9Vlx0/SlhjK0Kb9lVTcMefKvQM1WvTMXhPAdJ6rUWLq716MpsIssqhe4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4SKDouS/; arc=fail smtp.client-ip=40.107.102.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aBsEzxci3x0g0AjcOkZ1XeZ/K8H9cUs+Jq/mmO0bgAvpO9/Lv43RhdLe2F4xqpCbRFiMWofD7ZJe2wN3U0Ek7WDX+KTEzV5s4P0vJge9021E+ZGhZPPRiHUdLFK/doJY08uzI7QLdurtfD8ZdXF3MAxnfEXxnDgy/sKJPn9fOQAZrK7+mPZECtaxq6stWD6YoF3PPwE0RgIpabbe4cFvq6AMGJD0KXnFV1yvL2nckPxQycn4Kn+pjE8/0ixGa4g5woKLPRa18CSVxtK9LOMw37GytiAcGsvxAyNk8l5uYDB71ebmIjrkK7xcADe3yo8FNDaVsKojnIms2AMUmwx5Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ijj+ji6U5t43IK+pmBjRe66WFdMBVZ6jypVtp39y1ok=;
 b=xfU10SNUEoQwZCnId4uDzaBGTzxJfrQxne9c4IAnNL3z/8KsJo9kV0E3aM5mTtinSoClzpnlIFPlCMsEuvn7o1CIEcQd29qjI8puMyWHPWIHWfNpPACOjwJhCd8FYwPtdmYd3rQgsr7l+rIU36IRRyW7y4JZ1iVbn428J/fEZ13/Pt8oVwK3A1Y3ockDwHoRuwJh/c90QErUwiEBMcbv3+fUkIqqRNp1g3avlTF/L65zkOwhICv4vkVIVxW0+Ge17kWmTT4X67njkOLqahR0jHxUqza+SLzFo8W4e6aHYW2fQeo00Pn3m+J08luObbJWpNGMet163+ZncsTEA1bdJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ijj+ji6U5t43IK+pmBjRe66WFdMBVZ6jypVtp39y1ok=;
 b=4SKDouS/iA4vlWPXNN9si8b3LqRthQETUp13+LZBVVYj8tlldRGXLTxo9XGtcyjAv6EapFkYm/iJ+2LNSo0OTOoEYDkfRRYqqhGfjyhrZG6tMgP3vUdRzL02EZvAMnci4Jjma2qHRKrp1qMKncu5UOtu4s5tTWvNqbiGCtxdVqo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH3PR12MB9429.namprd12.prod.outlook.com (2603:10b6:610:1c9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Tue, 10 Dec
 2024 05:02:32 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 05:02:32 +0000
Message-ID: <0477b378-aa35-4a68-9ff6-308aada2e790@amd.com>
Date: Tue, 10 Dec 2024 10:32:23 +0530
User-Agent: Mozilla Thunderbird
From: "Nikunj A. Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v15 04/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-5-nikunj@amd.com>
 <20241209155718.GBZ1cTXp2XsgtvUzHm@fat_crate.local>
Content-Language: en-US
In-Reply-To: <20241209155718.GBZ1cTXp2XsgtvUzHm@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0033.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::23) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH3PR12MB9429:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b1f3e6b-bef4-462d-660e-08dd18d7da7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlRieHhrVXlnQmovM1I5bUp1Njlodm93YUNZOU1MM1A1MTc5L1ZvVmdiTHRm?=
 =?utf-8?B?VUQ3SXFrb2o4Um9TVjZhWFUwK0w5QTVEOE5SVWxVRW5IbjNJeWR3Tlo5WDUr?=
 =?utf-8?B?Nk1rTEU2b3ozd1ZXc3hJNUllYTFtSVFZQm96VndZZ1FETlFxZWNkY21aamN4?=
 =?utf-8?B?enRSeXpKaWlFRW96bjBxSng5WWNsdmdRSWRtN2hZMTZkbnR6QlVoTVhsVjBp?=
 =?utf-8?B?WTU5d2tMTVI2UTVLaXJySU9rSnJKWFlqaUJlOFVtam5LN0NONG4rQm56MXV5?=
 =?utf-8?B?VHJxakVmWGVveGhmT000OWc4dlhhdENlbmhrT1VPZ1ZLa0c1dFpyMlNuMlRh?=
 =?utf-8?B?d29PZnhqWExVdEVUOXlFN2JZejJ2eE9XVEVBdjZlM3NvUnVhV2hYVHhPd0VL?=
 =?utf-8?B?WVpINzRSSm5TaWJCMmcrUkNlK2l2alZPdFI1Mk5YUEdhdG51SVhsWUJ5a0dZ?=
 =?utf-8?B?STRFdGovSlFoeG5PNG5LbHFJQU01dmFUbTZva09PVWl1L1pmQ3BzVUpFT2N0?=
 =?utf-8?B?bUd2dzFYS3lXRHZqSTlVUlJLOENua0ppY25mSDlSamlzTjQ0akVVQlExNk11?=
 =?utf-8?B?cmFRNEV6NkRnZTBlQVpFdU9FNjJtbm9JekUybTZiWUo5T296ZGtWU0dMNXRL?=
 =?utf-8?B?WTJtVWpvUEZ6VWNhUzNaWCtQa2Y4Z2p1Q2J2UnhpYXprbGQ4YnF5cC9MeU0z?=
 =?utf-8?B?Q0JpN09Bb3BsVG5ZU1VaN3RMZzdzZURlQ2dta3R6YzdUeDhiODNJU0gvVE5Y?=
 =?utf-8?B?NGU5R1dYcGpiNXg4cWM2V0VLckdPdFZnN3JEbnFqbFhjS0ZveFJLUGZzUkk5?=
 =?utf-8?B?NW5SVGJiNzNJUTVlcHhSNFNuRHJEQkc4YSs5M0dPM0xsVjF3cDlmbm12eVNN?=
 =?utf-8?B?Mk9GZk5OR2FYRS9ud2tBRnVQUFFBMHJVVjF1Vkg0Rlgwalljek01R1ZXd0k2?=
 =?utf-8?B?RXhlazZaZ2J1QldPakJmU3NxSjFrYWpNbnZQUmtsd2l5UmczcE1CVWRlbkh5?=
 =?utf-8?B?aThXcHl6RG5obWJQSCs3RUJySVpyMXMyT3NSUlNENGNlc1FITGpiaDNCWEQx?=
 =?utf-8?B?WDBTWVdqMXFHVFpMT1JCdnlOWWtlRGIyMWcxSXNBZWVEVEs4M1N0Q2xxM2N2?=
 =?utf-8?B?ZlAvR01FVm9yUmNoNjQvem5zT2swLzU1MlNUOVM1QktvTExuLzRabWl1enFM?=
 =?utf-8?B?ai82WS9MaHhIeEQzeDN0MkFyY0ZuQSt5NU9wZk0wMS8xUFhGNjNzRkQrVC9I?=
 =?utf-8?B?NFlTbDJtUUxuVFdqUjNsQUZVUVFWZXI2UEE0bDV5QXRUNjZwY3A4TmdZdUpE?=
 =?utf-8?B?bEhHckhwV1lrOW5NVkhQYm1CWTNYVlBHdkt6T2taN2JYWWRrVkEwTG5aOTdj?=
 =?utf-8?B?UTlkM1NHSXVxWnhBTmQvR1RiS0JSQkxVUUVwT2VObVBLeitpUmFNd05ob2xI?=
 =?utf-8?B?dzdhQk80S0JLbzhVUHF0blVSR1k2Wk5ldUdGZUsvWk13d0lXT2gwbEwxd0Zz?=
 =?utf-8?B?aDRrMTdnMVlXWkFkYzlkTHhmeUtsMmN4SFZQOXRKb3U0cHdVRXlRRWFCZXZz?=
 =?utf-8?B?R1M5eFV4aXY4YnY1dDgzeml1NU0wTnQ1L3F1Vm90Vk1pUVZnOHc4NE1rSTBB?=
 =?utf-8?B?MUU2SU5uNC9FQUlNcXUvZVlqVWhhV1pZU1VLRmI4K2N3QnJoc05mcURVYVQx?=
 =?utf-8?B?enNXYnZVQ2lxdHpUbmdsNkM3N1RQUytubHJ0Ym5FM2d5Y05oTjRjdFhsSXBM?=
 =?utf-8?B?TTUxMHZyVG40ZkVvU2hPVS9La05ZL2VnRzYyazRWcFFVem1vZjVRbGszaVQ2?=
 =?utf-8?B?M3pLQXVjazFaeEZmT2pkQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnJsL2w4dm5OWGtrYVlSTlF5aGVkZ0I4MnNDQ3d0bkM1blhhWCtob1NoSlY0?=
 =?utf-8?B?ODRWN2YxS3VKTDQxZGl0eThKVnM3MEZxNXFJNktRRzJyNEt2ZTRMbGNvdGcr?=
 =?utf-8?B?Sk9ZSFNmVjZHRnJITm82bDg3ZU9vNlo1VFo4dXY1eTlkZDBnRUsraTVlLzQ4?=
 =?utf-8?B?K3kvd2JCK1h5TXdFOGF6V1BqNkR4VXlxZy9ZSEwvZm5McTdFNk1tYm43cmlu?=
 =?utf-8?B?T0VxUStJQm1FeERaTEVQQ3AxOURFeU5DMnhkbmV3cHlwT1Y3S3ZYbk5LQlk0?=
 =?utf-8?B?KzltU002eVgxWmNkMHZNWEM5a3VjcUliYnRLcTg0S05MNnBkMXlERUh6NnVB?=
 =?utf-8?B?Q0RUTVBUNzVJWnhrVGRjZVRXb3F0SDdXaEQweVNSVGZPYzBUeUtPMmZ2L1ZS?=
 =?utf-8?B?aWt0VE95UkhEUjZTeks4RmVDQUFPQmU1c2lBNm14UWxtY01sWTdBUHlZSy9G?=
 =?utf-8?B?SUtsbHI0NkVJUmg3UGFzWDZKRW95L0RMRHBlMDUwYnlTUGh2RmhMc2QxNXZw?=
 =?utf-8?B?SUpsQ2YvNHd6T1VyODRpNTVsSnNpQUVBWlZRcUxFRm1pMjEwYS9WTnhtSGxm?=
 =?utf-8?B?OFl1OFFJa3FDeGQ4YWt4L0xoTVVhb29UdVlNVUtVK2NhM2RUNytNcW5hMTl2?=
 =?utf-8?B?QjBjQ1R2VjJ6T2oyVlVsc0gyMnNjajYrV1pKWnFYWGc5Q2FlWnMvOUt2am92?=
 =?utf-8?B?SnRUTkt3NEZuMktQSm1NalVxSnlLRVVxMEdld3NINzRSdjVLczFqdFRHSXMw?=
 =?utf-8?B?Z0Y5V2owRUhFZlpRTyt4TFhQU3M4aHJSQTV4MjFIL2liQzA5THBTUVdITHdV?=
 =?utf-8?B?THA1OUZkZit6alZLd29sZlBVRXAwUGtDeHVCZWhlUll1TDgwSzlzbTJXaFhx?=
 =?utf-8?B?Y3YwYXBhdVh4WTJxYzBneGIzQnhySGMvUUZVdE9ja3d2bXgycGZVZFNlSXVD?=
 =?utf-8?B?L0pXMnN3Vm9EOTNhMTlWcDlUemVCY256U3NjVGRFaGJIclBweVVjQjgwY0pv?=
 =?utf-8?B?WmN3cWJoeFFqamRBUkZOSGhzdEloZGRFSjc4clM2VmZNSW55NkFnbmFzT2NX?=
 =?utf-8?B?dGVzdm1GVW5Qb3RYVmV0K0FmdWxLVGtxQm1tWlMzWXlreWE5Z1lqQXp0NllL?=
 =?utf-8?B?ZndaZk1NSHIwdFhxL1RCeUMyelNGOVhxN3FDWkJGZ3pyRnpvTXR0VXlKT2Fs?=
 =?utf-8?B?dERkeS9jQTlyWDlTSklMN1k2SzZCMVU3NmlqV3d6aVM3ZFZVb3BaaGt4aE9u?=
 =?utf-8?B?dHBMK3VWTnFyTzFNc2U5S3Z0K1JnaE1mY0RLTTBmWTc2UFR2N1k3QmxLUGJ1?=
 =?utf-8?B?NDFiSE93RVN1MUsxTUJVZEl2aUcreEdsbWxYOHNmeVh4MDVLcVR4eWt1dlZQ?=
 =?utf-8?B?a2xmaHZOM2E4bXp1cFVpOVZGTW9sMmhEbkdKU0dLNXRpU1JFWkFpWWdKUFdR?=
 =?utf-8?B?MnlUYnVHQk51TlRrN2RqSjBWVkN3MUdHTHhJK2s4VXBFUXJIQkdnenBMNTI1?=
 =?utf-8?B?UENhZWVST3B5ekdHZXdkRXRRWEJodnptcXpBV1FaVTREeGNoMExCN3d4VWRL?=
 =?utf-8?B?L0dWTmp3Rm93bnZjR2lWYW03U1VPTGttRldWdkJ2ZURPQ2tSNThNVVNiSjZy?=
 =?utf-8?B?amk0UjhlSWlReWpyMmJyUXNhNjZ0aHZFZXBkSXloMkUxS1FrZmRCT2ZNTmcx?=
 =?utf-8?B?WWFuT1RkcHh1Z2xQRHRjbWY1ZDFIRkwzRkYwbEVXWUJLOEVWWUlCQ25lZ2ph?=
 =?utf-8?B?Wkg4T0JiWkZXMUx3S0Y4dGlsUGd4cURnbmpVUEpQVkRZQWxDWmtBUXRVRlFS?=
 =?utf-8?B?eVlkd1RxMG9rN2EvbEVpcWYxVC9VYnp4aWt6NFRDdTdXaHFIOENqak1rUG1M?=
 =?utf-8?B?bU40WU1sWUR1U3dabXBES2tYR2tJTldwQlZSdnUzVWorQUZaT0dBcGRoblA4?=
 =?utf-8?B?cmR6SFpyNVFDeHM4OVppano1VWxmbVBPZ3oraDFCUi9IOUVLaTZtMWZCdFQ3?=
 =?utf-8?B?dzVYK0xEbzlrQkdLYnhIM3BmOWllY0hwTG92alNOOGlxWGtWK0NoR2ZBQk1j?=
 =?utf-8?B?bWx0UFZTWWtySGJjOWNoM09BL1ZsUHlpRG5ETUczSVJtdjlENGNPSTZRUWdT?=
 =?utf-8?Q?CGV4eLPxHyAR7SyDHV9+thAlh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1f3e6b-bef4-462d-660e-08dd18d7da7b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 05:02:32.4380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fYxC35OyDwml1C/EpEe9FRwaBTxDk5zPJywSCvdVMp0ctwNWmcL/iPVXih8UnRURTbMeRvAmLGU6yAYvQWD/QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9429



On 12/9/2024 9:27 PM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:36PM +0530, Nikunj A Dadhania wrote:
>> Secure TSC enabled guests should not write to MSR_IA32_TSC(10H) register as
>> the subsequent TSC value reads are undefined.
> 
> What does that mean exactly?

That is the warning from the APM: 15.36.18 Secure TSC

"Guests that run with Secure TSC enabled are not expected to perform writes to
the TSC MSR (10h). If such a write occurs, subsequent TSC values read are
undefined."

What I make out of it is: if a write is performed to the TSC MSR, subsequent
reads of TSC is not reliable/trusted.

That was the reason to ignore such writes in the #VC handler.

> 
> I'd prefer if we issued a WARN_ONCE() there on the write to catch any
> offenders.

Do you also want to terminate the offending guest?

ES_UNSUPPORTED return will do that.

>
> *NO ONE* should be writing the TSC MSR but that's a different story.
> 
> IOW, something like this ontop of yours?
> 
> ---
> 
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index c22cb2ea4b99..050170eb28e6 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -1443,9 +1443,15 @@ static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
>  {
>  	u64 tsc;
>  
> -	if (write)
> -		return ES_OK;
> +	if (!(sev_status & MSR_AMD64_SNP_SECURE_TSC))
> +		goto read_tsc;

This is changing the behavior for SEV-ES and SNP guests(non SECURE_TSC), TSC MSR
reads are converted to RDTSC. This is a good optimization. But just wanted to
bring up the subtle impact.

> +
> +	if (write) {
> +		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
> +		return ES_UNSUPPORTED;

Sure, we can add a WARN_ONCE().

> +	}
>  
> +read_tsc:
>  	tsc = rdtsc_ordered();
>  	regs->ax = lower_32_bits(tsc);
>  	regs->dx = upper_32_bits(tsc);
> @@ -1462,11 +1468,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>  	/* Is it a WRMSR? */
>  	write = ctxt->insn.opcode.bytes[1] == 0x30;
>  
> -	if (regs->cx == MSR_SVSM_CAA)
> +	switch(regs->cx) {

Yes, I was thinking about a switch, as there will be more such instances when we
enable newer features.

> +	case MSR_SVSM_CAA:
>  		return __vc_handle_msr_caa(regs, write);
> -
> -	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
> +	case MSR_IA32_TSC:
>  		return __vc_handle_msr_tsc(regs, write);
> +	default:
> +		break;
> +	}
>  
>  	ghcb_set_rcx(ghcb, regs->cx);
>  	if (write) {
> 

Regards,
Nikunj

