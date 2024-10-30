Return-Path: <kvm+bounces-29996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D63849B5ACA
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 05:45:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD8FE1C2276C
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 04:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC0119922D;
	Wed, 30 Oct 2024 04:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KiF9aPrA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2073.outbound.protection.outlook.com [40.107.212.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34DF33E1;
	Wed, 30 Oct 2024 04:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730263506; cv=fail; b=Ls1wKPgt92m6Hnp2x6bww6xHeoZohgCUamhTJnhXjuBr0RO6Jd9LYF2SnkI0Ci4P9GYKiU1ulDQR7eASUieItENfYyppM5HdEFSuTNAf5AeiNHmvPhTFfw9mE77EU94MTmH35sOgygU8aPN77wq8zwA/tK7GPMWpb/c23df3ulw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730263506; c=relaxed/simple;
	bh=rliAtZ4al0YLfskeI1ulUJd4q/Nku5D4UibU+SlRLfM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FM2tKyTcEOtEFADxkgfvkYbFvZN6kB2mxmAdqVryOwfyDZts7OSdXoqm9F8WfpP5kM57jXolz4z/eZC5RGt5tUCM/3EMh7IB5k+RJuoSCbro2pHcO3duFdN/Pb2pISTzNccGRI6eEL3llewBhd3naHeF5NZTazvh5GeWJnnKt+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KiF9aPrA; arc=fail smtp.client-ip=40.107.212.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VXZyXvZvv7ogK8ItOtG3vC7hHz2AX0LklkFwlZRH81O0ucMjSq8I4HAA5zaFIXwnG105ERpIybGxS3p5eqCzSLbJ5/h9i31WZ9Iu5nlv/+gx5sN5ISWKOaAUdiMl1MbMYIHtbDmLH6YKejAor5/OW1xc6zAlRChS2noxTdwde5Sh9EE4ZnLBnPSnyy4oQSmKDTFzVBheRFJqmxJ+F9hoJOi8XzdUPusvnyqO1hN1Rz4/dp+PL637baZqgzHmYqrhBPFjTRm3g+c8STLvnpAvDnCJTiGh8fyz2QF8FR6VduTdr9fiNOUW6IGTiLcM2QrpzELUNkJSphecKLdl3lqBcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mABbqX2OScsPMHThCZMHRyfgMFa03MHTf3OYJjZV8Tk=;
 b=pjlshP8MPXIaJWkE4pb/kfrHpESrcJfAE3bvGCqiZReXtfYRnJNQkAXbl8Yi5nt8hzHDyessNah9Fdek6kll8eIn4wG2q/a50qPH0aEAJ3070yIDXFKf6OobdSN6QdOm3l+6Dg+82vVNf28LvXaRO4tmw/TIer9d+PF79SnjWYs+ZPo4VXEmhFkq5KpmJiW4jIu7voGZxilJ15UsLgtgF7B1EQhJmv92u+HHJhi9PYQVjodHGInUncQyRzIxubYXFppxnVax4gMPjAb6SUeKVk1fkJA095XaUxivi07x7Yhnv/IBbrXODi32epEzYCw5Y+vvA52SeuULoa/uj+89KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mABbqX2OScsPMHThCZMHRyfgMFa03MHTf3OYJjZV8Tk=;
 b=KiF9aPrAHUO73gAXoCoPIBoRIH1yQ3Icp8M6DV801AmLeAIDQ2IJwxj34bT+o8xU23jmY9mnJDEHMY89DhgnzU91P3ne7+vSKYLkbP1o/gag5OILExN69ZApdJxtdW8CgSsUIe8CAjyid7duRbs5IGQOcPMhAlbAk39Boz6346Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB6694.namprd12.prod.outlook.com (2603:10b6:510:1b1::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.27; Wed, 30 Oct 2024 04:44:55 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 04:44:55 +0000
Message-ID: <733831ed-8622-de7d-a2e6-8f6c9ad4bc96@amd.com>
Date: Wed, 30 Oct 2024 10:14:45 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-2-nikunj@amd.com>
 <20241029174357.GWZyEe3VwJr3xYHXoT@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241029174357.GWZyEe3VwJr3xYHXoT@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0007.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB6694:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f0d9f7d-13a7-41e6-a935-08dcf89d9960
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dkowUkRaTnFQM2JoNWFYYUdBZWRvcmhQOXkycWVRME1ocXVocDBPdmNKRTRS?=
 =?utf-8?B?VFhYemgwYUVFcjU2RHdRT1AyM09qRmFPOStXdk5vTmttMjVVZ2loS3RzVUlN?=
 =?utf-8?B?WFR6Ty9TWXZsN3hjNzgvaVNxb3lJZkdqZlI1My9adFY5bUN6OFJkdUFPbS9D?=
 =?utf-8?B?U1FRdnpKRmplZWZuZFhjaHEra1JwZkhGdG5PRHJrSlE1RkI1aFJSVWtGcnh6?=
 =?utf-8?B?YXAycU1UYUNjWm4xZHdKNlA5MHkxbVpmMFl6bVRwQ0NwZHhqTnpXTzBGcDRM?=
 =?utf-8?B?ejhLTWFkc2pMd29Ubk9KVHk3bTgzSXNIbW5na2xlMlJDTXNiTXNTL3B1MUFZ?=
 =?utf-8?B?UFl6bDlPMDUrKytoVFNGYVB5MnBlYUYvem1JNzY1ZFQ2cnRHaUlZQldSVWxu?=
 =?utf-8?B?YnVqZlFGc0I1REd2SDFaa2d2N2ZJbTN4UVRhcTY2T3JPcUZ0QWw2bzF3TXFL?=
 =?utf-8?B?NlNJSkY2T25ZbkNMRXU5VVdnSFZVVDZ6SHF5dDd5eDc3ZDhjM1dLbmU0Vzl6?=
 =?utf-8?B?NXlTcTZhelhFZ2NwL1hjQkx5NkNqM0kwVC9mcW5PaUIxQ0lwaG1qWFdHN3gy?=
 =?utf-8?B?S2ZaR1lkSGZYcG1yTUZDcElSOVcvVllnRStjVW5leVVmYnU4Q2pZdXRWcUlu?=
 =?utf-8?B?dEZ1TXdFbTZGMFR1SUNTcTVhb1lRakJtM1VqazhWVFpva3pTS2NMVTVQdHpX?=
 =?utf-8?B?R255cnBSTUYxcXNFZzB6ZjJIcWwrKzd0TldnTmFoOXg4NzhaUHBSYmlNY2Yx?=
 =?utf-8?B?MWZWY0hPdmVEWjdLaVVrU1M2bFp6MmlqY2FMQ0VuQTVHbnhzMkNpS25PYXFI?=
 =?utf-8?B?UGVrRjUyeWs0a0xQeG9tbHJKN2F4Q0Zpc2NPY3lJalJzOTJaN1dxREFncWlU?=
 =?utf-8?B?R3J0N1VWdnJ6YjZwM0pITDVTaHptbExDSmFxanNxVTcxUWpHR2ZhOXl5aXBH?=
 =?utf-8?B?YjFQUVdFTmNKOUtvSllsREhCdWs2Q1g5MENCV3BzbmJvSU05UVhFSWI4Qkth?=
 =?utf-8?B?OFN2TWIyeW51T2FBa0JkUTBGMWxkTVAzSVM4ckdOSDE4WTBoWE96OE9IdlFv?=
 =?utf-8?B?Z202alFJV1VHTEZKMHFYQUNhT2gyYStIOXBXZGw3QkV5RXJ4N3dEN1k3UEh6?=
 =?utf-8?B?ZW9ldWJuV2o2cjllL3J5MlhMR0h0YlBZSUdoa1UvL2ZwRUJRa2VTQ2JpRWg4?=
 =?utf-8?B?L0htQ25wRHVHTCtvSWk4MVRQYStJTGFFcGtaL1RhcUhIRmtwQzdzU3h2enZN?=
 =?utf-8?B?UDdaeW5oUG9IZ2UrK3dKY1dxUzNrSFdGRUdrbnFnK3NVTHRCTHFwU3FyY2x2?=
 =?utf-8?B?SHR1YXZUZlFoMktRTnB0dGRMY3VtM09tZmZqUElHamhSY1pZbXZocGdKT2N5?=
 =?utf-8?B?Um1iRFRxbTc0OVRoSCtjUElsU1N4VTNQUURXR2xrb0hpZzBlUU1PVmhoWGNs?=
 =?utf-8?B?UXl2ZXpmMmcyL0ZrZHF3M3ZPWUdiNy9Scys3TThJZ3AwR2V0WThIWFFnb2hD?=
 =?utf-8?B?cW5BTTVzaFVZTW1lOFdoSlFoeG1HSEVuYUlsU3kxYXVPZ3NiZlhibjdkNDhI?=
 =?utf-8?B?elJyVEUzUGhpMWwweVF3RU9wSzlyVGMxWWp3cWFDOUxsc0FXMThrdFJIeWNV?=
 =?utf-8?B?em9pR29Gd29pM2dkcCthMDFMRVVtSUIrWWs5R3NkOG8rWmdXREYrZHZnTGZV?=
 =?utf-8?B?M0s1eDJxU2ZCOU1uWm1JMkFDNThYZWRoQS9wTXlVcStRVzRrRUw0ZmwxOWYx?=
 =?utf-8?Q?y4z6DgnSWkhhP2tbmxGStSJRj1MnNbXx4SERFUV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDI3N2kxdEQ4M0xTUEY1U3NxQlQ0OE90Q3QyZ2Y0UWdMVTNHUFp5ZWdUS0Vj?=
 =?utf-8?B?N2ZQaHpRNmI2VkNaWmo3d2hrTUFvdWdRRmFTaHRuOFluSkR0cWtIWXg2L1Nh?=
 =?utf-8?B?dkRWZWtHWE5sOHJrcXZBRlBraCtSTC9zbjgyUGVOKytCMTRtVzJkLzI1R2tT?=
 =?utf-8?B?OEc3Q04wWlZTcXVMM3BJdjhLNllnVEpLM3luQjRnVU9rR2RzL1dZRXl4TzI0?=
 =?utf-8?B?YmhhNm1ORFo0NTZocEN1Uk0xZTlZSkhWaFFObk5zL3hjaFc1VWthb3pFSkRS?=
 =?utf-8?B?MkpTUkw0Z3lTd3VmSnlJWCtkK245RW02ZVhDREhjakJVczBZY0hZcGhwZmdv?=
 =?utf-8?B?NGRpOWVaMjhUOFQxeCtRcDIxZENUQzNORnp6dlVaU29yTTJiUytQMEhZNXIz?=
 =?utf-8?B?TkZGYVphQ0o1ZnRWZkg4S0xUNkRtNTR6RWY5VjZyNXNMT1BpNFJGR0hSUVZK?=
 =?utf-8?B?bTZPK0RNZGdlQStacVE3R0xpSFE0TllGUWxra2Zua2ZmZU96V082bnd2cENT?=
 =?utf-8?B?M3hkNllCc0xaR21YekVZbFZrSHFhTnJIanU1S1U3V2hFK0FOUURFOThRMW42?=
 =?utf-8?B?VzcxTDYrRGRHNzBoR1NxMXYwTkZMWXhFTW5SMmtDNTVMY0p1eXNteGdrZVU2?=
 =?utf-8?B?OXd3SVY4T1pINi8zVUVBYmRuRFhuS0sxVmJzN3pDckIwOEpzVkRIbndIVkI5?=
 =?utf-8?B?SWtLVlIremg4bHREZHJzWUx0b0l3c2lwU050SDJrVDVLOWdnMmtxRjYwMDh6?=
 =?utf-8?B?RWlQNkFpZ0tTTzdCaHAzdmk2Nm84VHBJSnpIZEVKL2pNWnk0TTl0SjdMWTBt?=
 =?utf-8?B?c2x6UVlLY0s5VlpLcGhqSTJLTm14ZXllNXFtUlJucVIzUm9ET3JYWmlxUHdK?=
 =?utf-8?B?cTJucXB4YzFvbUJKUURyY1U3Y056RU1GSkJ5THlkRVdCOFR6bkxOdGc1WVg5?=
 =?utf-8?B?RGJWWlRqSHhXRFd4QW1RUFR0cDNaOHA2bHZqS05WY0NveXFDZGtBdDN3eWdl?=
 =?utf-8?B?NFV1MytaSjRoYzA1RUc1ZkRxMEUrdXlROXZudTNnQndUQWRadGM5RUJHWm5R?=
 =?utf-8?B?RERWbEdkLzZVMEhoYzgwdHk2Q2hMMWdGSGhkNyt6RHIwZ1RYWFNIcDk3Smta?=
 =?utf-8?B?WE5BQW8veWNrMk5ldk1WMytBbVBVZlNFMi9ZOHJRaEJYaHlucHdBMG9TV3FV?=
 =?utf-8?B?Z29iS2xRdFpTYzR5NlVrZ3U3SCs2SjRsOHBzMlJZdHRnMEJaaWN1VDJucnZY?=
 =?utf-8?B?bDNoS0o3TGJld0FZbE5xSGJ4WEt4eElONnNIdC9uVCtWS2tpV2FUOE9ScnJ1?=
 =?utf-8?B?bDh1Q0p5clcza0o2aUZiMmJjcjEvcU1lUEdrK3Znc2svalkrL1ZvcnVGZk43?=
 =?utf-8?B?YVRXdVFXRVh5Z0tNNDlzL2dlNVMrWUtVdk1OeDQ1ckJGZVUvNnRMSm5KT0ZM?=
 =?utf-8?B?dFMybGttclAxVWpybUFEeVRvSWo3c01TVW5IVWZScTliTDVxT1hmNzNSRzhD?=
 =?utf-8?B?MEhKRGM5ajBsSXQwSVQ5L2ZyUDl1Q0hOL0RxOGhLWjRCaFRSTmxSZ3p0dS9T?=
 =?utf-8?B?dU5XTjd0THhyM1IxelRLcXRVK3dmNG5xVGM0SGdjdk9WRDRuMHU1Z3l1K0c5?=
 =?utf-8?B?RWV6TlhLN01QMmlBL1VneDJpL2JtdU43ZFpkMER1S2tLY3hhRjBLSXh4c2Ir?=
 =?utf-8?B?SkFQdC9DRFFhNFp2dFVUQlREMWhPS284VzI0b0JrOG5zcFJLOWhNYnpQUUFa?=
 =?utf-8?B?QUdHYk9sUVRlS3BUT1Z4VXJwcmFkaFMxVmRqRCtEekZGcVphTEhwcldjZGQx?=
 =?utf-8?B?ZVlSc2JDT3NmTndsTnQ5ZXR3dGEyRStWeVpXRzhNVkV1RkxsUjJQMHBLVTJX?=
 =?utf-8?B?MkVCNkxmVjZRU3owT3VueU82aFZycStRWlREeDRrNXFCQkN1cWIzVnJLeDRP?=
 =?utf-8?B?d0tqYzB2K3VqVVlGUENmbUNTMzZ0eEJiQkJWdXlWcjVHL0FOd0UrZFNmNDhk?=
 =?utf-8?B?RUdqdWJGeTVaOC9TWUdabTJ0SU1mbGNBZkh1WW82b21sQThMMCt3OThZU1ZP?=
 =?utf-8?B?QVg1UWovbkIwc1BDbThBVmRGN2F0eEFxUE9CNUVsdG1jVS92aDhDQ0NteU45?=
 =?utf-8?Q?xTj09RmKlTwRhOUaO6no2OkQm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f0d9f7d-13a7-41e6-a935-08dcf89d9960
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 04:44:55.0096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /PvUZ7Q+SN9Jvk30EKnF+GNZ4p04AHN4dsIFCPLy2VykVSjDTeYFn3QkBGjAhufG9iLfTS/R53OIGZaIvy7nyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6694

Hi Boris,

On 10/29/2024 11:13 PM, Borislav Petkov wrote:
> On Mon, Oct 28, 2024 at 11:04:19AM +0530, Nikunj A Dadhania wrote:
>> Currently, the SEV guest driver is the only user of SNP guest messaging.
>> All routines for initializing SNP guest messaging are implemented within
>> the SEV guest driver. To add Secure TSC guest support, these initialization
>> routines need to be available during early boot.

The above paragraph explains why the change is being done.

>>
>> Carve out common SNP guest messaging buffer allocations and message
>> initialization routines to core/sev.c and export them. These newly added
>> APIs set up the SNP message context (snp_msg_desc), which contains all the
>> necessary details for sending SNP guest messages.

This explains how it is being done, which I think is useful. However, if you
think otherwise, I can remove.

>> At present, the SEV guest platform data structure is used to pass the
>> secrets page physical address to SEV guest driver. Since the secrets page
>> address is locally available to the initialization routine, use the cached
>> address. Remove the unused SEV guest platform data structure.

In the above paragraph I tried to explains why I have removed
sev_guest_platform_data.

> 
> Do not talk about *what* the patch is doing in the commit message - that
> should be obvious from the diff itself. Rather, concentrate on the *why*
> it needs to be done.
> 
> Imagine one fine day you're doing git archeology, you find the place in
> the code about which you want to find out why it was changed the way it 
> is now.
> 
> You do git annotate <filename> ... find the line, see the commit id and
> you do:
> 
> git show <commit id>
> 
> You read the commit message and there's just gibberish and nothing's
> explaining *why* that change was done. And you start scratching your
> head, trying to figure out why.
> 
> See what I mean?

People have different styles of writing, as long as we are capturing the
required information, IMHO, it should be fine.

Let me try to repharse the commit message again:

x86/sev: Carve out and export SNP guest messaging init routines

Currently, the sev-guest driver is the only user of SNP guest messaging.
All routines for initializing SNP guest messaging are implemented within
the sev-guest driver and are not available during early boot. In
prepratation for adding Secure TSC guest support, carve out APIs to
allocate and initialize guest messaging descriptor context and make it part
of coco/sev/core.c. As there is no user of sev_guest_platform_data anymore,
remove the structure.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/include/asm/sev.h              |  71 ++++++++-
>>  arch/x86/coco/sev/core.c                | 133 +++++++++++++++-
>>  drivers/virt/coco/sev-guest/sev-guest.c | 195 +++---------------------
>>  3 files changed, 215 insertions(+), 184 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 2e49c4a9e7fe..63c30f4d44d7 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -14,6 +14,7 @@
>>  #include <asm/insn.h>
>>  #include <asm/sev-common.h>
>>  #include <asm/coco.h>
>> +#include <asm/set_memory.h>
>>  
>>  #define GHCB_PROTOCOL_MIN	1ULL
>>  #define GHCB_PROTOCOL_MAX	2ULL
>> @@ -170,10 +171,6 @@ struct snp_guest_msg {
>>  	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
>>  } __packed;
>>  
>> -struct sev_guest_platform_data {
>> -	u64 secrets_gpa;
>> -};
>> -
>>  struct snp_guest_req {
>>  	void *req_buf;
>>  	size_t req_sz;
>> @@ -253,6 +250,7 @@ struct snp_msg_desc {
>>  
>>  	u32 *os_area_msg_seqno;
>>  	u8 *vmpck;
>> +	int vmpck_id;
>>  };
>>  
>>  /*
>> @@ -438,6 +436,63 @@ u64 sev_get_status(void);
>>  void sev_show_status(void);
>>  void snp_update_svsm_ca(void);
>>  
>> +static inline void free_shared_pages(void *buf, size_t sz)
> 
> A function with a generic name exported in a header?!
> 
> First of all, why is it in a header?
> 
> Then, why isn't it called something "sev_" or so...?
> 
> Same holds true for all the below.

Sure, will update it accordingly in my next version.

> 
>> +	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
>> +	int ret;
>> +
>> +	if (!buf)
>> +		return;
>> +
>> +	ret = set_memory_encrypted((unsigned long)buf, npages);
>> +	if (ret) {
>> +		WARN_ONCE(ret, "failed to restore encryption mask (leak it)\n");
>> +		return;
>> +	}
>> +
>> +	__free_pages(virt_to_page(buf), get_order(sz));
>> +}
> 
> ...
> 
>> +static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
>> +{
>> +	struct aesgcm_ctx *ctx;
>> +
>> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
>> +	if (!ctx)
>> +		return NULL;
>> +
>> +	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
> 
> ld: vmlinux.o: in function `snp_init_crypto':
> /home/boris/kernel/2nd/linux/arch/x86/coco/sev/core.c:2700:(.text+0x1fa3): undefined reference to `aesgcm_expandkey'
> make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
> make[1]: *** [/mnt/kernel/kernel/2nd/linux/Makefile:1166: vmlinux] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:224: __sub-make] Error 2
> 
> I'll stop here until you fix those.

Sorry for this, I had sev-guest driver as in-built module in my config, so wasn't
able to catch this in my per patch build script. The corresponding fix is in the 
following patch[1], during patch juggling it had landed there:

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2852fcd82cbd..6426b6d469a4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1556,6 +1556,7 @@ config AMD_MEM_ENCRYPT
 	select ARCH_HAS_CC_PLATFORM
 	select X86_MEM_ENCRYPT
 	select UNACCEPTED_MEMORY
+	select CRYPTO_LIB_AESGCM
 	help
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
diff --git a/drivers/virt/coco/sev-guest/Kconfig b/drivers/virt/coco/sev-guest/Kconfig
index 0b772bd921d8..a6405ab6c2c3 100644
--- a/drivers/virt/coco/sev-guest/Kconfig
+++ b/drivers/virt/coco/sev-guest/Kconfig
@@ -2,7 +2,6 @@ config SEV_GUEST
 	tristate "AMD SEV Guest driver"
 	default m
 	depends on AMD_MEM_ENCRYPT
-	select CRYPTO_LIB_AESGCM
 	select TSM_REPORTS
 	help
 	  SEV-SNP firmware provides the guest a mechanism to communicate with


> Btw, tip patches are done against tip/master - not against the branch they get
> queued in.

Sure, I will keep that in mind.

Thanks for the review,

Nikunj

1. https://lore.kernel.org/all/20241028053431.3439593-3-nikunj@amd.com/#Z31arch:x86:Kconfig

