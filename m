Return-Path: <kvm+bounces-26837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5632E978638
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 18:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA636B20C7D
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 16:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73EF081AB1;
	Fri, 13 Sep 2024 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JLDCagT3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333877E0FF;
	Fri, 13 Sep 2024 16:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726246387; cv=fail; b=WWW1V90O/i8ANeLBWBFuoP2typJGHy+FHr/hQUezPeV2roM0EZOaB1glsPiKrQXKOhUmoS2UbrM2PQY+aQVcNZdOQK9hUU0eW+hMooLvie2KyFtLLju1Jz6tFAaomBHy14ngTdZIngJzXf6wNsB4YkdGGnY1WZb9bM7dDxGFMxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726246387; c=relaxed/simple;
	bh=s3WGkqQhF/ffIqnLUR1kOJH8fvpq6SpI0aCsc2W5PFM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f4ldam+m4Y1/VtjJbjA5Ui3dJRMJgEEC6py7gzC+M+Lfko5tjdO1rUiMnCVsxNKnSogps+WTQ+MADjvUGzCKz24KVRfD9mScr1v8tnss50qacKbP3+nduOEgmV7Vc4XUJE9cBgDDJY1wZE48mqBeoBSedCffGfJUHMD/m1auHDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JLDCagT3; arc=fail smtp.client-ip=40.107.220.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TO77X/sTDdCkmb+mCTgvnflUnMZiw9dPeSXkXqfXC8uWzC522VjWVvZix304gYXFz2fAwEL2mPvwYYxp4iQ9Fxr+Cu1PVna1wrKWhWHo3CyL5HVSmcCPsQgBVeDZ2bTxIyTof9xWlPbIMXA1G3Zd/9N4PCvOp33tWpOKPe7QRtNiYpl921ljmW7O80BbDcCuTnw0eDACMYXbkZtTUodXg/YCkDVq10vBZLt0Z11osBAhIkiwxKnhHyzbTB4mqQ1tAiD0+yc4nFlk7cJzOYmKnHwCXFbcxCvZZiMlyft1QSR9ow/04nYZwEb/4Nzg08tW+Zhhn9oryzL3pHlhf+PnSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQ0iETtlrD8SkdMTjTodBurF5T/zD0RonPhVGYieit4=;
 b=YGrhFMA0ekhCuHXNEPS+8F90XS0veFcyXBPRCvBZdGWN/UBvG6T4YdJEgeDQ4uZst8Cl5GMRaaIWpo7YeLrgxcMsGT5HUcOjHfy1eaP6y/b0SfJKrKvqLT1+nH1235MWLkONsxxsuYsD3pqSrie7FAWDUxtq2ZCMcpvmsNthqeKfgPPhYzAK+nS4J704JUQrWW5pvueqjQU/CtM4uhzRUMVFEr6PajdPr7QlIuRNx2NiWJyALaoPP0u/cRtYwTQNc2JAi++TkZ/LgEnWQl6Q/h6D4xvfqbYH1PbIpSaexjKRnDC3ILAxWLKj0N9wUqhv7MDcEoqrMjjlUqeqmYL49w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQ0iETtlrD8SkdMTjTodBurF5T/zD0RonPhVGYieit4=;
 b=JLDCagT3VxHQULhaSFUAw4K9hbYOMM27fYFEU1PWavQ6Xr975DvLx1bQUPIr7PYmCel542hxrZSN45+1BdYe+m6NSZYJid23jgZYZdoHNwZT1CtVkPdLofnSgfgUdWFJORsYl8Zws9e+skYuZzWX6AbaJtBulS4VPTVM7hP8FDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB7497.namprd12.prod.outlook.com (2603:10b6:610:153::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.29; Fri, 13 Sep
 2024 16:53:01 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 16:53:01 +0000
Message-ID: <ddd3dfe3-986d-4433-13c4-c65c15673e9a@amd.com>
Date: Fri, 13 Sep 2024 11:53:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 17/20] x86/sev: Allow Secure TSC feature for SNP
 guests
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-18-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-18-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0067.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: 2070f9c8-8fc5-4d23-7bd2-08dcd4148765
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dkRWNlFwSG9MTG9lM0NEb3dPMmFjenJ2Tis4S1RWdWw3aG1GK2J6cWJnWlRy?=
 =?utf-8?B?VWtqZXI5cWpIM0JNTmNMSEdGN2VNL1AzQUVRcSsyVEJaZUdwYXJHU3R3RklZ?=
 =?utf-8?B?ZkJlUmljRy8xL3ZmaVFjWDAydU9zQkR4MnhHSkc5Z1NuYi9lTGlhc2tCS2xU?=
 =?utf-8?B?aHV0V3dEOGt0cERZQ2hyK3BFMWoyMEJvbDZnOW90NnY2TnV0RlByU01BODJy?=
 =?utf-8?B?dWtQamNjVGt1MGVla1VjSWR5bVBoZzJJNzZKek56dWdIK1dCUzFhZUhPUkxI?=
 =?utf-8?B?VmZlY0ZoWm1DZUNIaDB5b0R4WGhMTmltMkg5ZXltaW0wMTNTUE5MVkViTWo2?=
 =?utf-8?B?ZXRiZkxqK0twRkpFY1k2endySDZiMlZBYk9kejZuaHFvTFFYLzB6SmNvREYy?=
 =?utf-8?B?cDN2ZjVyd2tpUSsvOTd3RkNtUVNFRlVQNk82STJObW5KYVlZRUVoQ0kzTEZQ?=
 =?utf-8?B?Zm42aHhMUFF1dnRvd3R3eWJsM3h2V3JJNkVsV0xlUTVpZSthUGFuVkJVVjJx?=
 =?utf-8?B?amFxREJ1cExzcWxPMWZiTFJnRGxlTzV6SERNalduZU1XVDF0dlpNU3BTV2ND?=
 =?utf-8?B?dUk1Q0xjNS9HSHdUcVFaSGF3ZmVCVC82cGpkOHBpQXZPdFgzSlZvazJKN2Rx?=
 =?utf-8?B?SUlNWVU0SEkxNmhqcHdsc1JDclJjdTJLZXl3dlJZaGRFUTd3enNtTnVtcmN2?=
 =?utf-8?B?eHRVSE5malJOUEtURmhXcisyZUduNERHeDBDUUlnQXc4TGpSTDJmNVB6ejJt?=
 =?utf-8?B?YzRXZjhzQzhMLytJN0ZkR2t4a3JKVWh3d2tsd2ZxSmliZVhIdEFnak5Sc3la?=
 =?utf-8?B?T0ZieG1wUVMydkdiclViQ0dhbWcwTk0wU3V0OUlPOXpOODQ0akMyV2FaUE5n?=
 =?utf-8?B?M29nM3ZZNTJPT2tPaE1iVmRETGhZSUdQWFV3VER3NlUxOFZ0b2ljb3ZBYVBF?=
 =?utf-8?B?VzFhNWxod1MvMzRiVHBCWDlNSXVTN1JLNXVSNVIxc205Ym4xb3ZselN2M3Jq?=
 =?utf-8?B?bHkrWHFCQjNQeW9UaHFxNlZNSG9jUmkyT0FGdEFvd0pNRUFCUk5JOFRiTmZq?=
 =?utf-8?B?Z2tTMExiZUpTaDZqYktTcEtWSk9nb0NxSGc2WldqUFJ5a2FqdGJoUDl2YmZJ?=
 =?utf-8?B?STNUVmRkd1N0Mk84WXlyRkozKzNaaTc5M2x0YU5MaS9wLzdQeVByTXdvQjgr?=
 =?utf-8?B?UmpaQ25wc0pNRzV0b0p1bmpsbnVRUGw2cDk0dk5QSzRvWWZlbTFaQWpKclF6?=
 =?utf-8?B?RmpheVZMRzl4TmwxVU8zVkdCRWorME1HUC9TMHZiUmpjTHFhNkxrL0ZLTmFk?=
 =?utf-8?B?R2ZWQmc0aExBdHpaM1poT1FGcjBkT0ZNTlVuUjBLY1NReUZxMzV5RzBOaUhj?=
 =?utf-8?B?TlBDZTFvRXh2dXFzYU9VYjYrcUw1eGZpc0lUakpzVkJCY1VHSWJWNk95d1g0?=
 =?utf-8?B?dnV4a20zUHdsQjZVdHUvL09mZVZyam5nZU92bjc4a0FrUVRLclE1US9YNXNE?=
 =?utf-8?B?UkpFM3lxbnppejY1Q0RGUUg4ZWh0cHVONkhNbEZsNEw1WWY4bVY0Z2wrd1hq?=
 =?utf-8?B?dkt5M0hoWVYyTkx6SjJHbHZZbFdyQjg3bUxUVWZPM3daQldQMmhLYXp0OFB6?=
 =?utf-8?B?VGZrVVM2Qk13WkI4VG1GNmFqTXpUM2JoSHlTNWppa1d6SUkvNnVlSWtyUHlp?=
 =?utf-8?B?c0hOZXNKbFJSa1djT1hZbmFTVE9qWWtuaFR3Q1pnMVF4S0pYT0J6aDR5K3NE?=
 =?utf-8?B?OUd2S2xuQWhSb2w1Um5IbE83Z0FYaU53UGZTOE4veThJQTBCaUQ5MWRsajNt?=
 =?utf-8?B?Y0FmYkQ5SzE3cTFPK0lhUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VDRJSHNhSVRMdGtENGhiUDI2NFp4RVBYN2NHcWwrT2RTTGl3eCtkc3dadDkw?=
 =?utf-8?B?Z0pOaUJ3b09TQnk1YXFQY3FBMWlZL2xtUU4yZC8vbGJZdUdCMXB5NHRDZlpP?=
 =?utf-8?B?Kzd4d0J4NnBXTDBQQ2htNFl0d2twaUk5MGNDWmVDSlpEc3RHS1hiYUZva05N?=
 =?utf-8?B?enBWVGhoZGU2aUpMR3dVVDh2QkFHaVF3MTlZRVhNRW00c2Q1M2hzYWVVa3JX?=
 =?utf-8?B?S3o0MUl1UER2OFJDWnNGYW9xTXVDTVQ4SXBEdGx4WGM5Tkg1MW9seDIya0Uv?=
 =?utf-8?B?UzBpRVVuajZGMW5xbTNHMWZXTUFwanlKVkUzeTBNVFM1M0I0QWRwZmVJTlVY?=
 =?utf-8?B?QU5wYjVFSG01MGs1b0Z0dStibms4aFRKQklBT002SGdDTnAvTUZibjhYZHlT?=
 =?utf-8?B?cExINXFwTmlUbEora0xhQnFPdU1GT0RVQUVIR3JwM2UxalVJQ2IySG9qajNN?=
 =?utf-8?B?VW1KNjA5UzBoR3ZzYnAwem1HbDhwcGkrUmVhcjc2czZaZGE3VU1LSWFoYzdm?=
 =?utf-8?B?MWpmZ21VaFBlMVpNSHdnUElxdXNtWGJPMlRxdWMwRldqYkNTTDNQTVdpNVhG?=
 =?utf-8?B?emRtc0pKVHkzdjR1ZGlnNkVTK1cvTjgyVTJidTA4NEN0VHc3THBSaVVaWURw?=
 =?utf-8?B?d3pKUGl5d3paZ1RhWnpVQ1hPbEJCeFJRaHhybDBNTHdYb2hYUHROUERnTDcw?=
 =?utf-8?B?SXE3WGIyZ2lCcXI5TDBxMDRTd3VNODMyaHYvNEJlQ2ExSTZFeXdGa1I2cmcy?=
 =?utf-8?B?RGpaY2lpUTZQZzBBMitxTWYxR0U5RHJkbHBCaEd6MUdBTklJUFhDK1hzMzJM?=
 =?utf-8?B?amV1SGFkbnA5bW45dDY5aUxxUlNjMm5NTXBWT2pETXBnSERVWkVCK1o3cEFU?=
 =?utf-8?B?UnZ2cEVKbXRWVFZlbDJYWnVDV3Y5RDRwN3Z1TVUrMGhnU3d4bXl3RHFRYWxw?=
 =?utf-8?B?UEZPVmRqdnRmU2ZmNlgzVmNFQ0hkTkxwckRrWjdqdXFQNHJPaUpuakgvTTB0?=
 =?utf-8?B?NTVVNDROREYwRmZya1c0YnBPV0k4eG05dXdDK291M1BKVHV4L0MwZGpEblFo?=
 =?utf-8?B?MEM5dUppRDJhb2wxS3RwZlQ5b0ZmbS95Mks2eEhPQmhwWmhVb0V5b0pHcDcy?=
 =?utf-8?B?aG5tV05BbnZHcHl0dTZRVE42UW5Wbk9VWkxveE8yZGxTZzlOWncxT0phUXR2?=
 =?utf-8?B?QkJYRkVIUDArNGJOMW96bitLb0JWUjNaNUNia2orSi91ZVlNSitjSmF3T09T?=
 =?utf-8?B?QlpnN2x5N3I2bDFtOXNiQlVDRnUvYWJJbmh1U0hJZGpvTlVIc2lRKzRxQ2hZ?=
 =?utf-8?B?Y1JNRitCdVpXUlFyMGJpMEN2WG45R1JNczVPejNsTzVKbFJobEpPaU94Q0dw?=
 =?utf-8?B?dmc5QWpEVU9hQnEvT2l4K1RmZzU0NS9ab245eU81T1ZYTjFqb1VVOWxLTk84?=
 =?utf-8?B?UVZHbWJ6dmFlaXlodE41SWNQNGd6a2ExWFUwcTVjMjgyaEFySjliV2M5L3Ba?=
 =?utf-8?B?VDZ3N2hMS3FZb3N5MHJPSUsrSmV2MzNZQTBpUVpGY3pvb0pwVFdETFFERGFa?=
 =?utf-8?B?TTBOb0oybzd4M2hKZzU3UmZ4d2JJRE9tWEpZZmovMDBoZjhLZks5MUNrWmhB?=
 =?utf-8?B?aFExU2MzdmEzNmxaZ3BXOVJzT3EvLzJvekkrY2xPb01CN0Rsd3N1TlZkZmFR?=
 =?utf-8?B?em9xdnowU0l0WXBpR05kb0xuUnQxMGVPWFZUSTAxdDFYNWVEM0lURDhhOXdR?=
 =?utf-8?B?eUNmMTZLYUNGeUIrTmlIYjBMSjNYQUJGdFpnQ0JXWjJaampUNGFUa3VuK0Rv?=
 =?utf-8?B?R0ozdG4wcU5ndEVOR1orNURCYWVsQmpqUFJyUW1RMDVhdWhiei9KanYrVS9t?=
 =?utf-8?B?dTdDdGo0cmhMR1ZhRE1SVGVkRzRzSm9yV0xDNC93M3pyYzBuek52cjRqYVpw?=
 =?utf-8?B?U0dUcGdLd09FMXpSd2FKMlRlV09oK2Z5VklWY0xSNmgxb1ZmTFBSbVdBekNK?=
 =?utf-8?B?Q3lVZFVqR0hnc3VIVGxyRXJCYmZHeWFRVUdwQmg1WGNyaDNOVDhmUXB1N00z?=
 =?utf-8?B?cGllNk03QVdvTENBWEZnQTQ4aGNrYmptaUJ2Rm5RTjZMMnJrZFRvYUc1OW5H?=
 =?utf-8?Q?CimBeVvX8YkzztuAUAmQkk/Fz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2070f9c8-8fc5-4d23-7bd2-08dcd4148765
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 16:53:01.7351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: do7pK5YnCSSYyXRFH9pH47TTVeIXDUBQNa8EvxUUyFiGC8iGhvPrIAXR2VtuhLRZBXqrcQwrw8WLuIVez5WAGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7497

On 7/31/24 10:08, Nikunj A Dadhania wrote:
> Now that all the required plumbing is done for enabling SNP Secure TSC
> feature, add Secure TSC to SNP features present list.

So I think this should be the last patch in the series after the TSC is
marked reliable, kvmclock is bypassed, etc. This way everything is in
place when the guest is allowed to run with Secure TSC.

> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/boot/compressed/sev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index cd44e120fe53..bb55934c1cee 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -401,7 +401,8 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
>   * by the guest kernel. As and when a new feature is implemented in the
>   * guest kernel, a corresponding bit should be added to the mask.
>   */
> -#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
> +#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
> +				 MSR_AMD64_SNP_SECURE_TSC)
>  
>  u64 snp_get_unsupported_features(u64 status)
>  {

