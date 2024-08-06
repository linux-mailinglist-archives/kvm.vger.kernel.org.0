Return-Path: <kvm+bounces-23377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8533C9492A7
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:09:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E79E21F21AAA
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DE718D635;
	Tue,  6 Aug 2024 14:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GaZ8OIDR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8032317ADE1;
	Tue,  6 Aug 2024 14:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722953325; cv=fail; b=N6SaWt6p3c9PfOyCxh7T9p2rEm5z1tuCoVGa7903WB0thiqwygnPvbBwlfdmkemZhOPwmR6FGUc0afFSMdGbd2STqn25ea0nySvp795YG/Bk0SyIycr9kuykHDBIX0SyJIJPE1YS/0LIbuC2HopeIz9WbX8wS4JFDkaaLd6Cmrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722953325; c=relaxed/simple;
	bh=HE8Qf3dVvmwpmtjYpaBl4Rm8pyCqO5YgFMyxNd5ZDwM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Egclw4nPKQIbxcHe5HvD3I1gLfopKfJz2hwtQcFKOrfBHUOvZiLzJbW/KaMuv8w5/h11uSwNKyyOitXfSxcXtAXcOyqyZzW8kLAuVteX2+vuKHs24H9OxguRco0KhFL2uJ30iseyTFIwMwT9tfQujBhbTLvqTWj3do6lUEwCVmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GaZ8OIDR; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jq0G3akLHqxjwFS6uUmzaPha+HR78ShdRvs02bpo7hD63dL0gI876Z1VYWYOjUPniZGQ8v5Wclmq1LGnm+xuK/keBQOMlno4dqy4CWDYQqwsJdCmlr5UBA5e1HuyC/HfpJkDEjZWc0UX3A+NtmhUr4tB0jwUnp8RerSmkcTHv07Ei2A708LnXFJLkU0WMY/QzAKQ2ygScSX4Y7L8OEcpkd8bky1Z9CidRvitE/Hv+XM52q5Lwvvv/jpQ9McGqDlgSCZXyztO4pdKm7ze92j7faAh4tBoAI0OOV3pOesJdnncC+qGOpYVsMONRhft84Xkb7nAnkcouPX3SoNsBelNfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sv+T8kOmrzoStPBAiVPZOUu8Usc1wC+3NS3v7K6WVdE=;
 b=MReOHM6VRhkD6t0f/35naBfNwqovEBhFZa78ReXAJz98m2LXchcSk+x0mXogqDQscUs0QbJGXPSrcW1Sat+2kt4Jp716DzNAXvLqV2XKGdWL9pkvVxSB4zAU19NAfIlXfJD+76NDzr9c7JoaFGr64NtwP/lzsdmYVh3hghHUW1owtTnG4R6YDblzwFkO9lsfoHob+9WYp/5h0yM+/5Wkyff49HHArFoNt95lu3aucV0wuCbYtbb8m2O+MJbHp1gcMYxGZvuMq72ZiaE1vPksnQ68eS8fSVgptW1d2ef7/p9GXqBqR7L/Tz/uhJemjIwgH7DFzOKIHX090/RQ0KdjMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sv+T8kOmrzoStPBAiVPZOUu8Usc1wC+3NS3v7K6WVdE=;
 b=GaZ8OIDROancj2hY7PpMLQTPttk0S98rUI44so0E9VHJ9s1JmDJZQ6jZ4ijeqOOaRGzdI4nZT0uClciztptowRPSTWFoZlvDIeeHKpzfnDXsOiniGZvGU+04NczzBf16mUbDIeUr9+Bzpnc11c3OIf4O3lOlKa3w2aGwHSuFB84=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4273.namprd12.prod.outlook.com (2603:10b6:a03:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 14:08:38 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 14:08:38 +0000
Message-ID: <240900d1-b9ff-7bcb-9cd6-13a511492874@amd.com>
Date: Tue, 6 Aug 2024 09:08:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 2/4] x86/bus_lock: Add support for AMD
Content-Language: en-US
To: Ravi Bangoria <ravi.bangoria@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 seanjc@google.com, pbonzini@redhat.com, jmattson@google.com
Cc: hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 manali.shukla@amd.com
References: <20240806125442.1603-1-ravi.bangoria@amd.com>
 <20240806125442.1603-3-ravi.bangoria@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240806125442.1603-3-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4273:EE_
X-MS-Office365-Filtering-Correlation-Id: 7091ace2-adb9-4316-a96a-08dcb62144d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cDA5Y2FuNk1iaVBXUlU0U2ZzNzFrUC9Ocnh1WFhDVTBqSWVNVDJKUmZnSVBK?=
 =?utf-8?B?NVFPRGNJN3NrQi8za3cvRG0xT1prdnJYS0p3eUxGdzBPeXAvYUtFRStWMFNp?=
 =?utf-8?B?WHlyRENqUVVDMzIvd0dTU200Rks4K1VPVnFWc2JWT3JiVFpPWkdYVCswMVNK?=
 =?utf-8?B?Z2pDMjFwdUFyVzcwM3FSbURxVExRQ3JhZVd0WU5Jclg1aVJiK3Jvck53cjB0?=
 =?utf-8?B?NGNBamt6ek5zaVRSWFpMWTFYUHhkWkhma3dOeFBkdWR0SVJ1ZFNPZkxZeFRV?=
 =?utf-8?B?RXZ0UEFkd0ptL0RrdXVRek9MbEhJeW4yazFHcE56SGEwdFR5bW9QSVYyZGJz?=
 =?utf-8?B?TXJxM0RtR0kwaTlIMXM5TlhPSHpucDJiYTN2VGtkNWU5d2Z5MEtLeE1wWVFU?=
 =?utf-8?B?bmNQQkdRQVVNdXhsUFByZ040c2xudFpXZG1RdVFiZnh2TUx1OTdCb0tVdGxC?=
 =?utf-8?B?S2pzU0J0eStnd05sSUc0Wi9nVkQ5UUdqS1dSTExPV0NWSERheDJCdTRVNW5m?=
 =?utf-8?B?YVdTSERnTzhKK0dDTnRRMzlhcGljbmw0dEM1WlZGSVE0TDlmRkpucG4rekxT?=
 =?utf-8?B?N3FNMEorTVVrakhMZUk1WllMZ3VjN0xDRGsrY0FNZ1M5UTZtVUV1MWpmY2Zo?=
 =?utf-8?B?NnB3M0p6cTlDVnI3KytlVFlJMXU5T21KazJoQU1VQjU1WGJFUkk3d1M4bURh?=
 =?utf-8?B?NitIN1gxWUozWmpGdlVvaURxb2hIUm5WK2JhdzlSaFprNUw1QzN3TjRMTEVU?=
 =?utf-8?B?L0xLZlFhMllmTWYxQWgxaU8wbTRUL0NCZE9EaktlczdHZkFVYUF4Zm9EL2g3?=
 =?utf-8?B?TmFYaEc0a1dRUjN1QzFjcWRoYnR4VlpTZFdmUzk5U2ZicTlmSWV4OXZjY2tW?=
 =?utf-8?B?ckRna2gzakJwUDUxL1NnS0hQV3NETnRFMFNCYjZBTkoyN1NBdDYxNEduRzZK?=
 =?utf-8?B?amZYQ0xIZ3M5QmY5a2FIeGZScU1xKzZMKzIwUHNJb3hRejdXRmt0YzdEQnBN?=
 =?utf-8?B?SlByS2ZJYTdVeWF5NWFocDBRZFBkR1VOVGRCQTRPYzlzbmM4czBaOVdXMnN6?=
 =?utf-8?B?eWxkeWlTREw0b2haK3BIWk13RlZsbnM0Qmxwdm5WempHRTI2MkE3SU52d0xH?=
 =?utf-8?B?a29zMWs1bXh5citTWFBQUFY3Z3ErKzg2V2psK2kyTDA5VWNYZXpTMDRtL09E?=
 =?utf-8?B?alVKY0FFeHBhV0hER3lndTlGMnNQUGUrRUJySENzS1pCTURoa3hEVlNQZ2h1?=
 =?utf-8?B?TDBRQU16eHFuUVlJNTlER25PVFZ5dVlMSHVVaDhBamlTMGtxbWxvaEtNd2Np?=
 =?utf-8?B?SXU0ejRkOGlXWVZRWG1ObDlUMi96Yjl2c2h4czRKbUQ4cENaTkJoS0NLSmxn?=
 =?utf-8?B?MDkzckcvNCs4aVdJeGdsb2tRWVhHdVBMeEZWOFVRMFFub3ArZ0ltZHh6akRw?=
 =?utf-8?B?V0lKVE9QRU1Kb1BEcml0SFdOYnczenp1RzhQS1ZscUdPMGNLREwxcHF0cmFC?=
 =?utf-8?B?M1d1SEpOQjFUYThZdFEzT3IyZTFCc0owcXhwd3ViRmtCS2dXVFpkTTUyZk1u?=
 =?utf-8?B?dllVQkc5TUJVeWZQQlM5cGdSYlhYRG5ZL3FFdEpyUEVMeTBZQ3BmWTVMejA3?=
 =?utf-8?B?dEQ4MWxRY2ZVM3o5ZVlpamRocGVXc0xqUlpiMkJldEh0a3pPVjBBOVRnZmpJ?=
 =?utf-8?B?MEgyeUdjR3N6TWJBS1E2UW9HaEc1UHN1SUE4V2pEN0p6NGw4bVVxMTdIekV2?=
 =?utf-8?Q?JJBhRg7Ac7T89e47OM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHAxK0tCT2tESE5vSFJRdnM4M2hnN042RU5KbzE5UE9NOGlmZjdhWHp4Qkoy?=
 =?utf-8?B?Qm5ZMUJHem1aMkV1THdaSWdFdmt2OFpjaGgrSGhwaHdXcEFMRlorbXhXc2Nx?=
 =?utf-8?B?YTdySHlSeThBL2JrWDN0RDh6QVBiZFowV1loYzFNYlA3ek0yWU0yOHV0UjQy?=
 =?utf-8?B?WWlWL0RKZVN5akl2RWpTK3ZRU25rMzBFMzlJTlFpYW1JdHpoMW9OajZUTlM1?=
 =?utf-8?B?WFNVc1JsNVBRaHEzMC9kK251QlpXNEpFVW9hUGhMRFZ5Q3hwQWwzOG5zMjRs?=
 =?utf-8?B?eEVpSWhacjI3ZCsrWVAwZDY4NExZQXo3dThPUjhidWtYL0srQTRMZ2xTdjNY?=
 =?utf-8?B?U0NpVUFmLzY4MjkxS2k1OXlhd0NmdFgzSW1wYjJlQ1ArZTRVTitwdWJLRXVG?=
 =?utf-8?B?Yld5Y2pFR2FleDQxVTRJMUVmdkdlbzdEUFNueEIzQ1ZtNjRFekpLMUMrTEpk?=
 =?utf-8?B?eE9wWHRNMmVXYXNHZDZ6T1VCYjBtUGtpQ1lVdVV6WkRxbVllVzlITDRNMEdB?=
 =?utf-8?B?bEt1RGJ5blVhQmYwQzNlb1Rna1JEN0FjZUx1WG5uS2VzdkNvZ0R4dnpWcWpt?=
 =?utf-8?B?OFdBc1FmaGV0bithb254RDFseU9OcGlkb0M3cUJja0JmUzNKVTNDWUpJRkJX?=
 =?utf-8?B?WEIvNTNyaEVQOUdzUUVMY0czb0s3Ylo3emhZak1CbHpYeVJkV3pySktmMVRH?=
 =?utf-8?B?REd2UGUrcFVYWlprQkUyRGw4L2YxMW1BS0ZZaldveml0UURNZXRnWWpWNG1j?=
 =?utf-8?B?VlJ0V3RlZVBuR3JSYlh0dGlnZThWd0ZQTjBvNmFmam12YnRKaVdZT0dZSEt1?=
 =?utf-8?B?YlBsdVhHellwODVyK1grVEJKNmx1cFBLQ2tRTTRNSWkvdzd0Z2tVd2w0WnpG?=
 =?utf-8?B?OEZoWTBoUm1tWGFwaEViNEdWeStlUGw1bEQ4NmpQV28vS0dDanVQbnVScGlS?=
 =?utf-8?B?Wkx4czdjaXA1ejVhY1NHc2tRWEx1RjdFTmtyRWhjang1ZzQxR29IZzR0dlhN?=
 =?utf-8?B?NWxmTEtGanlKRlhUcFEySnQ0NXZyRERFbmJCM01NcWg2VTFURlBxdjVDQ2RR?=
 =?utf-8?B?bDlhZ3ZnRGt4UXJra2ZzQ3pyQW5SOXJLTTZHNWFUZ3pVSnJGZmZ5ejdNdy90?=
 =?utf-8?B?d2R4eDN3TWkyMVZzMFlVTnBUbitDMmczcm1VdGJMa3ErOTdIem5uSTZKSi9S?=
 =?utf-8?B?Vi9lK0tvR2s2cjBKZVUwbTBLRmtUYmMydmd1bW80aHY1ZU1BWnpQdXkxekE5?=
 =?utf-8?B?Y0ZmT05UR2RQOE9jREdYTUZMMEt3MWxrVTNaNFQwU1NNbmVlWXAveTFkYTJq?=
 =?utf-8?B?QmJVNjdCRWJ1VkFLQzJGSDE1Nk5oNmZrRDVqVUdxTTdwVGlZR3UzdFZ3OW5C?=
 =?utf-8?B?cUFZTDNBWkhkajVudnJ2WVNacmNzQlNUNkJ1cURjMzV5MEFVSVlGOXlQZGxQ?=
 =?utf-8?B?WERQSnllUlF5OVNlWFVubGgwVXNQb1B1Q1lROEdFNnpsV1ZVOU5tQ2ZOdnFo?=
 =?utf-8?B?UndYYVZLU3lNRG1hTHRMTWNNYmNmM1Q2UHhNVzJ5OENya0orV3k0MzlKeG9R?=
 =?utf-8?B?c2dLY2dDajNWQ0RGcmRhRDgyekd4ODRkYjJid0hTN2VTK2srdzNUU2thMVVo?=
 =?utf-8?B?a3Zxc2NyQWtXbkFWS2NzNXUwd1UrcmZHSjdqWHQza2tONFJqUjF2UDEvSEd4?=
 =?utf-8?B?WllYL0p0Tmp1VnRTSysycGZkc3pQQmNMUTYwVXVXT0Y4dU5YZklSam5xZHRC?=
 =?utf-8?B?Ry93RlBFQ2duSUh0YWliUHNRQng4YTIwSUZhbGF1SzhhbS85bDVTSXBJMW14?=
 =?utf-8?B?eHE5dHJhdTQzOTJxK1FwMEtUc1U5RFlKWlA4NS9ta1BxVWtrbTVJODZORkx3?=
 =?utf-8?B?b3JGaGttbFo0NEpZWXhqZ21sSWtld21yaDllOXl2bUk1WWpmRGF5WTd0Ym5Q?=
 =?utf-8?B?eU1KYVNKczZaZUNXYUR3cC9pa09iczFGY0tsN3Q1SGZDNWd6aUFuZTRMQzRR?=
 =?utf-8?B?Sys1VlpzWWJOenhyNUplSGEzOHVkS015V20yc3RwL3EvelpIVjI0cW9pTDhN?=
 =?utf-8?B?ZlBNTWlFazAzMmZlekhqYTFEYktiVUdjWXh2Y0Z2QmZJZ2JCTndpWjF2aVZu?=
 =?utf-8?Q?P43PPmAEwi2yKcls9Mg8LpOcN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7091ace2-adb9-4316-a96a-08dcb62144d0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 14:08:38.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OC/q1orOfPaGx5aZ2rWPo9dpnLQnQC9XzwAqjr4y6dZEjUKbKL51Uz3a/sEgJGGVLgouWSF70HN1OggcBBS2ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4273

On 8/6/24 07:54, Ravi Bangoria wrote:
> Add Bus Lock Detect (called Bus Lock Trap in AMD docs) support for AMD
> platforms. Bus Lock Detect is enumerated with CPUID Fn0000_0007_ECX_x0
> bit [24 / BUSLOCKTRAP]. It can be enabled through MSR_IA32_DEBUGCTLMSR.
> When enabled, hardware clears DR6[11] and raises a #DB exception on
> occurrence of Bus Lock if CPL > 0. More detail about the feature can be
> found in AMD APM[1].
> 
> [1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
>      2023, Vol 2, 13.1.3.6 Bus Lock Trap
>      https://bugzilla.kernel.org/attachment.cgi?id=304653
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/cpu.h     | 8 +++++---
>  arch/x86/kernel/cpu/bus_lock.c | 4 ++--
>  arch/x86/kernel/cpu/common.c   | 2 ++
>  arch/x86/kernel/cpu/intel.c    | 1 -
>  include/linux/sched.h          | 2 +-
>  5 files changed, 10 insertions(+), 7 deletions(-)
> 

