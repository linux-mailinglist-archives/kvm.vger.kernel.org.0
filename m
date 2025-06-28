Return-Path: <kvm+bounces-51045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 497D6AEC931
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 19:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FCF23A3A8A
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 17:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85FFE285CA4;
	Sat, 28 Jun 2025 17:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zvBZc8MN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4657E2586DA;
	Sat, 28 Jun 2025 17:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751130264; cv=fail; b=Rc7y45IyfG+MKFVKvFq678nDN6z8rxg0b2ZPV0olioq5WevavA3YcRnYYgJfvVslkh7xDRqD3Fu+bSEp0+5fiXX1D9qCeqbTP7wW0x6P0mjB4aPNpiVC3lAv9GT5wTt66ncqEa/fGJR3rSzPcuLaZr6aX0vTwfvWwcBTi5TJD1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751130264; c=relaxed/simple;
	bh=T5LY0yOUNFqVF63o4GwwdKWaF5/atyjLOT7Duhhn9O8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eT9G/DbBXGqMeaIg8Tnvzc/NB6UA65WaY/3GDX0d6CifN5ynx9whJNTie86VcSek8WXuum3yAiAFVunDbMAFZH/8zJN685Qc4pmMHl9kUYK6/vCpDYdsW93duhEHbgysY5q1RFrv1qESxJ7tpa/g13b2Ym1MlCp3E1CgxogchrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zvBZc8MN; arc=fail smtp.client-ip=40.107.220.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QAlSWRYh7aDthU8M9Qsi99Ekil83J0INkY/q+VaJdvndLX7vuPJ73VsbxOnoXftRcT+l+dW3htMxN4mgILbSM54tzLo0mxkAmCDWztFS+I1pPUZXtHZ8lreCco+I3KRxaILHwhqFFfrNz3JB+V73gkmcoWREBzQgeUyIHVVtfQvJLHOB856wFiFFELf3fXuo2U6ETCuVHacr/crH4Mx2UW5ebYN5OeJxYIZxeuJkGmjw4ZTgVpjTX5soYJz+NljVC4prEfS4mDModT9woDEV+ZdQPNFCbLUhlCVobpUgrQ+FXKxdEOJdBdnJLusE0RqWo3ybQ1QsaXuLAfHlhK8IPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwkbNqYaw/BtxZj+lPgG4LO0hZfLJ6aO+5Q6d/CiOnk=;
 b=RCXJjeBoKGPzeGJI5T0fwNlNx49BOrKXMTiGRclyM3eIKzgCvmYkrruhVJAh4h8HNdg9ZcSdkhD9ToqPHgp/v03dc8A8Ymoj1NeSHTxvB7vxcpuVjFh0fgTBFIO1RQ44wSvzZE0nOLRsUrC6BEn50JsqajzXv+gZLx6b7hVvYU5IXVop2YrVbMnW1zy9jp9ov2EatLAYB1ouR/v8Hfq7M17V08W8+IIivmK3PJ0rTzglo+LucyCtjCaCfRjgecDaUIicRuuNl+3SVRki02jJKjMVEAH5hZeADurId6qD8Mo6Zz9xy3g2O6mfAiGXKq1DD6uJN8SLeOdWGCh3fTzC5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwkbNqYaw/BtxZj+lPgG4LO0hZfLJ6aO+5Q6d/CiOnk=;
 b=zvBZc8MNKkvsfk8i5zrmaKrjeG6DHqczK+JKtrwT6hadILwMWTEXZPeUlgA9iCd2KyZNVgoLMIJHoLTcTZOZyzpiw/kgah03Tzks6COvNNJZWVnIfPVPtDqe1CroCAwlZf2j+q3Ze4bRng5ITps9MVlG+HoESPhudzhye7auhcY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB8087.namprd12.prod.outlook.com (2603:10b6:208:401::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Sat, 28 Jun
 2025 17:04:20 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8880.021; Sat, 28 Jun 2025
 17:04:19 +0000
Message-ID: <92c7f4b9-5f08-f01e-a711-69fef94c2628@amd.com>
Date: Sat, 28 Jun 2025 12:04:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
To: Borislav Petkov <bp@alien8.de>, Kai Huang <kai.huang@intel.com>
Cc: dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
 mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
 kirill.shutemov@linux.intel.com, rick.p.edgecombe@intel.com,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
 kvm@vger.kernel.org, reinette.chatre@intel.com, isaku.yamahata@intel.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, nik.borisov@suse.com,
 sagis@google.com
References: <cover.1750934177.git.kai.huang@intel.com>
 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
 <20250628125001.GDaF_k-e2KTo4QlKjl@fat_crate.local>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250628125001.GDaF_k-e2KTo4QlKjl@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0006.namprd21.prod.outlook.com
 (2603:10b6:805:106::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB8087:EE_
X-MS-Office365-Filtering-Correlation-Id: d2232b5f-7e36-472c-9caf-08ddb665d250
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2hGNTdqRG1YV3RYODBqNzZreUU5NUJ4R25oQmVtVTJNMFJBSWFiMEZ0OHho?=
 =?utf-8?B?ckd2eVJxRDZ2c1JEOFl6aXRPTm9vV3dSakkxb2dZWFp6MDJ1cnA0UExSWXcy?=
 =?utf-8?B?Q3hRSlFESzc4REgwS1l2K1o1NzJDdXpZWXNhM2x2dUFRRFdkV0pTQlpNeFhD?=
 =?utf-8?B?OHJQZHhoT25KazVlZU9QbjdsRkRsS2pGWmgveWs0V3JUanBxVFZiNVVINEJn?=
 =?utf-8?B?K05DMzFJbVA5Q0ppM0xnT3B3ZE02QlNueTVrdnZBVDVFR3RQdG1NL3d4elNr?=
 =?utf-8?B?cnZ4QjZkdmpNQzMvdVU5ekdTRWFtaks1SG5jOTN4MEZMdFNNVDIzZXJFajFm?=
 =?utf-8?B?REV3NWt1alRlaTdNTDdvT1g1MjUxT1R4cS8xVE1QZGFmbjVNdzNKbEJ1MWNV?=
 =?utf-8?B?TmkyNDlITUlPcE5KeE9uK2xUeVgwblM0K05ZRXNOK0lwVzBsSE4xSkV3RVZF?=
 =?utf-8?B?S0pINjRZRlhVdHV6QlJSNkVTM254UVB2S2djeXFzQjRZNkdoeFpVdXZtRk02?=
 =?utf-8?B?b2t2TzVqY0dTMWVkTDR0bVlQUU9MKzVSMzN1YVFSNHRsb1hTT0hlaGhuTHVt?=
 =?utf-8?B?Sm1xT3BDcVVLdEFDWkk3NWF6WlEzMmpUZkYrazI3OTA5YUZaRDZVbUZ1TjdJ?=
 =?utf-8?B?WU5FSVlUSFVWQU1YVGswSVRQUTlBSG9PM1FyYmN3SklyU0tHWnpxYnNiWStS?=
 =?utf-8?B?Y2k0SkNoNnJubU1LVVBJV2Q1Skh4Mlk3WWJEWTN1ak9ZendNb3E1SnZ1Tm9j?=
 =?utf-8?B?L1RtK0xuY1FzTC80Y2duQW5DbkxJYmt1ajJtU09VU3pyQ3JzRkkvQzd2czR6?=
 =?utf-8?B?aXpqL2Z0bXJwT3A5VW1iV1pTa3lKallzNkJ4aHNFS0YvcUhWdkVTaXd6T0pU?=
 =?utf-8?B?WldVMGN1MlFJSWpTZUg5QzdjTzg1VklnVmdHQmkrVDZxV1E2SFhPUk93bXdq?=
 =?utf-8?B?Sm5aY3pNTEgydWNSRmhDaGkxR21pc0U1SDJyNFlwSUNyMTU1U09YbGU1WFhM?=
 =?utf-8?B?d2IwOEt4bk9wT3FnRUk2RFBXbElBdWl6VzFzZG9VaUd5ZUVIbllUdzczc3hp?=
 =?utf-8?B?ek9qRzdHNHJVUGJEazhDZnRydWRCUklid3cxYkkxTWpwS0RwYm9seVNlNGRO?=
 =?utf-8?B?eVBtMnAzNEd4Y2ZENXJjelErOUZWRnEyeVk0NzRuVUg2SHVhQjljQjFzRkVr?=
 =?utf-8?B?Z2c4TXRzTkhUT3VEa0k1aWlzd2NNVFpYeVpCOFZPUjBsNEppL2kyMFNJVkZ6?=
 =?utf-8?B?bVFDcnkwNWwzbkNhS0NLbml4U1A4SlRhQlhMdm96UzNPRUNod24zcDhVU1lX?=
 =?utf-8?B?eDNNb3hVbGo2R3dwT1p0YXJDcnpCaVVvRWZwZDcvOUlIT3dadGRsRG51V3d5?=
 =?utf-8?B?UGMzaFUyY1A5cDVwdzZybytjQldIOXNDWWFCeUd3eUNxeHNCY0kxOE1jdFBT?=
 =?utf-8?B?SEJlV0ptZzVmNERaZ1hOMmlWTVFjVjdEcGozVkUwSmlHc1hIQ0hGcXRLRzRY?=
 =?utf-8?B?bThCYjlWckR1MlR2R3l5KzdXVlBQQjVpaC95K3BVdCswcHRTZ1YxeGwzVkcy?=
 =?utf-8?B?bkdUNWtzZVQrdDBoMGJXRCt6VHIrNWoydHN5S2hVTnVIZkJaZllZeWJVTjZT?=
 =?utf-8?B?SVZlQTRRd0svYWtBVWlSQnFOcDd3YVlrWVM3SmJGdkh0MGlpMlVWeXlXVWpk?=
 =?utf-8?B?ckRkVWduVFJqY0QzcHdrcXJjMmc5YnNvVFdsaUsxaTgvYUJ6bncwMGVSQkRT?=
 =?utf-8?B?ci9sODIxQ1Y4TkxtWlMyMHY0enpuWHE1RTJiRkFDMTlxcVlHUU5za29Ldm9N?=
 =?utf-8?B?b2RYREtuRHJZUFlWVWcyWmliZElSK0xxekhPTkJjUEZBTnFkVmlpMHVyMHlq?=
 =?utf-8?B?Z1pVVEVRditlUGRyRVdoNDE4MVRtekRnL3Z3YnRIV1lvdGozRUpVNHBLRHdh?=
 =?utf-8?Q?64AJO0DyS0g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2xqcFlHTFRIbTJ2L1RCejVyb0VuR0NJQ05HaFUyZldST0NNMHlYeXhKemNi?=
 =?utf-8?B?ZlpFb1UrRHJSeFgyaHgybWFOLzNMeG9scHNocjIxV0NjWll5RlRPQ0YzQ0lC?=
 =?utf-8?B?b2YrTkU2b25YWHdyKzR4SDdOOXI1MTl4WUd0QmVqMmtDTFpQcWJOZnRTcEtr?=
 =?utf-8?B?VDlDbC91NmhuVkNXZkRBMS84cVEwZmNnNlhpSUoyTGNKN2tlWlBXcjRnSTNC?=
 =?utf-8?B?RVowSWovMS9tTU02UGdTWUtVeHN5cnFEYmlnTFdkMy9VNDR0UWljNnROQTA4?=
 =?utf-8?B?bzQ2RXd2dXk1WHZZMVZmdllHdGo5Q1h1Z1JFUmYxS29SM0lZSnA1K2NYd3ZF?=
 =?utf-8?B?ZW1pbDNxMjVsZmNuQnVKbzExOHgyajFFekRTY1Y0ODFIOHgwSngzWDN4czJz?=
 =?utf-8?B?eGZzMDlnejVYU0YzUmpieDk1bS9nQ1ZyUVVKS08weGw1Q3czbjJVWU96UUtl?=
 =?utf-8?B?bkM4amJ0cHZDWHZoNEp4cktDSGhZNkFiZXczcHZoQkhTZVdUWWhoVWtrQ3Jv?=
 =?utf-8?B?MlY3OU9zZkx6Q2JsaTRaR2o0ZTYvdnh2dnh5Uk1vcE1zSkF5cVBJVkZNUy9U?=
 =?utf-8?B?UGxIVER5UC8vUGdCbWgrK0FndStxWjZYbFhRRDcrZzBqZlpySmlWaDZUMHlj?=
 =?utf-8?B?THNQbE0xb0J3K3RnYkhsM2svSnh1NnF1cDV0dGRMQk9teHYrcTRxa3dCS3R6?=
 =?utf-8?B?SEt5Z09ITkVSNGViMkRVaGhQM0I3WGl3S2EvVVkzVEdTSUM4TUkvZEczOXV4?=
 =?utf-8?B?UlFKN3hMdGRvUDNHUnNKOWVaRUFDbENrSkgyQmNlYkFMOVAyU0hOcXlJUXZk?=
 =?utf-8?B?ZkcreHFNK1lGeHV2NGo1QS9DVndVcGNpQWdxU3BNbGNFS2JITWxuNHZxK250?=
 =?utf-8?B?OGtoek9QZkRxVnhuVDZlYUJPUGJLc3RJanB5N2NqbjNiNkJBdWFRendXT0xn?=
 =?utf-8?B?ZW80c1Jad29mTGZjOTFXWkdEbkZKb1VDaXdRTWRkZk5OMjdyQUo1NVBXU255?=
 =?utf-8?B?d04xWUtJTm5FbzhoR3NvRjlIUkJwMDh4N2dNb0RrUkp2S0tRVStybWgveFRO?=
 =?utf-8?B?S1BHNWw3WDVMdzhvNFIzMDYyYk9nV1hYUk1BalRBU2g2L2V0TmhwVWNRcDd1?=
 =?utf-8?B?cWRSY0dkZUVYbWdGamdoaWgzWjVVaXlzQzNvS2tiaGRhblNMZGVXMlUwRkJq?=
 =?utf-8?B?UHlXQ3dteUZGamZoeVBxanFrMTBxOG4zMlExRDl3WDJLK0szRk9qZjh4QkVo?=
 =?utf-8?B?d1FxdVdnOWFtSVFDRGkwQnV5TUJ2bjhTbkFGUnlCc3VHVFdYMmJIQVFwcTYy?=
 =?utf-8?B?SThuK04xU2NiM0Q2OTFva0FsUFBUTllCTE1FcjNWK2RRdWxQVjE4bWx2Yi9D?=
 =?utf-8?B?Q2xOL0tOY1l2eDN6aU5RMzhRdXlaN2lWUXJxMEZKQ0F6TVlINUJhNlEvTzJw?=
 =?utf-8?B?VVZFVHlUc3hIb285LzRCd0ZuTFBSdVBGaVBteUx4cm1pRS9BYlhlSU9nazJM?=
 =?utf-8?B?bWduM2FIb1RndzRWVy9UUndETmtJYlprQnlNMnBYSG43ZzhCUm1xYzZZSHFk?=
 =?utf-8?B?Uk83aFp3dGtlWnUyempobjRpbTI0ZFNWUjQ1SEI3dzhoMFBWclY4c3JrNk1T?=
 =?utf-8?B?bnB0UmJCei9iaWlKT0lVREYrSXQ4NFpXci9TdURxUlVvblN4TndIejR6ZWQr?=
 =?utf-8?B?aU9pTjRZb1p0TjNwa05wdFExUTB2Wjd3QTR6ZTZFeExFWllycjR4aExWaUlT?=
 =?utf-8?B?clNULzlvcG9POWM5eGh6dlJaaGJYUmtSUFgyVERpZXBGSXE1bXVOTnhENTJC?=
 =?utf-8?B?cDBERFFMeGszTW5wNFBtZWd0UjNCQlB5SkhVVE4zMCsrSHdaeEYzTmw4ZUNP?=
 =?utf-8?B?OTJRMC9Xd2xWU1dPbVh1OUNpMzFVbzRHRitVS3ZmbStSMTBkaUpiSjh0cjZy?=
 =?utf-8?B?S0FHRlJCSEprNmNhczlaV1JhZEd2S0VLSGI3b3Q3MUo2Tm1nSmVqb0ZxR2Yr?=
 =?utf-8?B?TWQ2QjRud3VhTzZHNys0cHNXTjF0R3BIRDdUS0svSzRpb1gvSndJVVhwOWlu?=
 =?utf-8?B?eEtzZERZOXRwejVOQ1U4V2RoVHhZcXBCSTZoc2k0cHc5ZVlvdzRwRjRTQ0NU?=
 =?utf-8?Q?dTW6vqeqwBj76ENaCGbgNNnQJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2232b5f-7e36-472c-9caf-08ddb665d250
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2025 17:04:19.4788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2hjvJneakYydz+cM2MD74y8ivzobDTWZvhgqKf1L5/RM/hacrlqLiOKlHaptopejJg5PRsKT4Ee20BdVXBhPPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8087

On 6/28/25 07:50, Borislav Petkov wrote:
> On Thu, Jun 26, 2025 at 10:48:47PM +1200, Kai Huang wrote:
> 

>> +	 * support SME. This provides support for performing a successful
>> +	 * kexec when going from SME inactive to SME active (or vice-versa).
>> +	 *
>> +	 * The cache must be cleared so that if there are entries with the
>> +	 * same physical address, both with and without the encryption bit,
>> +	 * they don't race each other when flushed and potentially end up
>> +	 * with the wrong entry being committed to memory.
>> +	 *
>> +	 * Test the CPUID bit directly because the machine might've cleared
>> +	 * X86_FEATURE_SME due to cmdline options.
> 
> Where?
> 
> That same function does the clearing later...

I think he means that if this function does clear X86_FEATURE_SME during
the BSP boot, then when the APs boot they won't see the feature set, so
you have to check the CPUID information directly. So maybe that can better
worded.

I did verify that booting with mem_encrypt=off will start with
X86_FEATURE_SME set, the BSP will clear it and then all APs will not see
it set after that.

Thanks,
Tom

> 

