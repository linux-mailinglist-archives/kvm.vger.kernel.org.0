Return-Path: <kvm+bounces-66846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A4F46CE9E8E
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 15:19:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CE4773016F8D
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 14:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6597B22154B;
	Tue, 30 Dec 2025 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DrXi4+y3"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013002.outbound.protection.outlook.com [40.93.201.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002F81D514E;
	Tue, 30 Dec 2025 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767104342; cv=fail; b=W8u1Mi0aH3wE2/8OAstEJRkj4kfmzABUwbabgAGLCU9EjBU0CgSD50bWAV80MUI+xwRHQTD3D2BxLcple/HDxqeLG9jufAjvIXhDodFfFXO2PhVeQhFT4Z6alZEYhZ5+801b8ml+GptEdYkbjqbffEDAYZIcRBgz3kR4lYn8JBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767104342; c=relaxed/simple;
	bh=zfR6P3U1hvzC9lpuh82m9s0yBscUujbllx0+0tVFR8I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SyRqg8D6QD9iEujXIeX1F1cj6ayNE+jHuRre9zszVCBidJizx/86sS/1KrLHtnfPflkJYysFkV0wGUDcBEokObNZh5iYlzjFsDUU2CKnS99pavaRO5xEZuOA96+BQuGUC4fl7VHJbEuhHJGoqg2eYUSrgH2mAbxVnOrmGV424bw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DrXi4+y3; arc=fail smtp.client-ip=40.93.201.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VExgCl40dPPhc+WLdRmizuMM2E7KXtRpfjqyVQooZjnb11hrLgxwYKZNQq8oUHg9KmWPA5vRsRESMxKDAR6VopovTHgZ+/O+xjTlB0yD3rrYWFjb4RHCesAGilnmy43dUsftltgF3XU5T5+5ZLvsuR3usR+54gUecLUyx16Ct6LL0Psh6enSAsZG9aifYSTh+TlD9bn/Ub581xjQOxyVdj9JoT6R8lEsu34GtEtO/2yhcdKXauVtcqnLOiXmmUZy+1OTMXKJbzCmtCHmK8vKx+oiv4tL+HcoR9I2G7u8KXGHwqAF3Ly8DgiagtgzcWRzeJlO1ewVP4NbdXTk25r/LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIw4zT9KsJQz6P0yD3L7gBzSFnEizLhOXLXuuqPjlWI=;
 b=aFXl5oGXWkOaQ7jYe8e54JEPd3RAxiHc0e3A4vFghCa5uoGo9us8bdeSc5uQBSsGmiXwOIOCJLb+k5juPVV95AazGRLc429zIKwrj7AtXW35+Kn8BdaLbA2y7TFxwDbH56qlgKG0PSSXEdPeJa/xjUP39guZukBrhbQvJkZ8zkueprMU+5ECnmUrf+PQgz/QeDBnFQxDC7/Q01XFq7AJAgdpSS6OGmpO7ffiCVTqtmGw8DywYDM4i5Sfl7u/kAk6msE8Y1wurReZw8v74BaeAGgxFeeDOb1b6wpDFSABGJ+63/83YjRXCnwdOwP6iyLDX/bqlNI4y0bWe9O3JwyLuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIw4zT9KsJQz6P0yD3L7gBzSFnEizLhOXLXuuqPjlWI=;
 b=DrXi4+y3e+pclLkQH+HEjzWnrm6INxA0Iz+msOkV2yaoiEdYBeKj1/A8ICzK/RMUC7x6LejiFDx0fKJxwNsyl6i0z1fDCrnxYQjFMkhGA0nh29MEAQ/zEOShSkPQ91kizq9b5lfv6JZkZ6hL0S0foxU5anOFIgoYUgZofa/L4/8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by MW4PR12MB7383.namprd12.prod.outlook.com (2603:10b6:303:219::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 30 Dec
 2025 14:18:56 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277%5]) with mapi id 15.20.9456.013; Tue, 30 Dec 2025
 14:18:56 +0000
Message-ID: <0f56dfe8-f343-4d43-8695-48222d8e3707@amd.com>
Date: Tue, 30 Dec 2025 15:18:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] KVM: SEV: use mutex guard in
 sev_mem_enc_unregister_region()
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 linux-kernel@vger.kernel.org
References: <20251219114238.3797364-1-clopez@suse.de>
 <20251219114238.3797364-5-clopez@suse.de>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20251219114238.3797364-5-clopez@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::7) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|MW4PR12MB7383:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a4c3daa-6ff8-4d2a-fb91-08de47ae5e1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UHJGMEs1OTZCaXBwYVpJRE5GV25CR0VuZWZJTnNTV0w5SzRHMjQ4OXQxNGRs?=
 =?utf-8?B?dkRMa0x4eEF0Y2daZFd4TXpuQTJmTVJwbUlhaWRwdTh4aG5vTElCMWNEU3g5?=
 =?utf-8?B?ZHlpZS9GRlZ0ZzZxcFBNc0VSNG5rR283SEtTblQrK2ZUbGtIVFVxZFpIL3Vu?=
 =?utf-8?B?aDR1K3k2cnppYUp5WmoxRENudnhsU2hnWDVWRmJzdWtvSzJGaHZDV0Jxb1BE?=
 =?utf-8?B?ekVzRlhXQi9PNHJncHc5MGJSdTFpQXcxcVpYdFdJNW14WWZEZEtHSURuci8y?=
 =?utf-8?B?YkU2NEZRYmtMOU5Rb094WUJsaXFVTmdvcDd1MHkwdllnTEs0U01QbmgzMmpY?=
 =?utf-8?B?a0hZdjhhakYrenFYdllhZEpXSy9LNFZlSThGMlNiLzFwdk5PUHV6bHdqUVFF?=
 =?utf-8?B?bXVacExYZXhPYnVhZk04d1V3Tk5VMnZrRkNhK05RR0Nnd1duTktSWmhKSDg5?=
 =?utf-8?B?alpBeDV5elhydlM1ZmZtT09mZlJKUlZHdzZLWW9oblVSWUZyLzhlR21YV1ht?=
 =?utf-8?B?ak5wVDJ4MnVxTVBuSHdBZWEvd00zWXpzK1VYQjkzUmUvalRTOGNtdUs4c1VW?=
 =?utf-8?B?T2FEaXBNSkJIWGk0WmpOMUlXWGZPc05IVU43V2RCL1BJWWZDSGF2OVgxZ1FM?=
 =?utf-8?B?NmMvZU56dHgvN1RaVlllT1BzYUVxRFBhekdUWGhHdXExclhsTk9aLzlIdnV2?=
 =?utf-8?B?eU53bkIwdmhhakZCc0J5OTloUm9ENjRVVFk4d2lPMStGUEI1eDdnU1FoL1Fq?=
 =?utf-8?B?c2VCN2JjbHcvQUF2YTRhclhxTnFacHZyVFhmTWI1V2NkRVpvUE5RSEZtYndV?=
 =?utf-8?B?bU9oVDBBV3lOUThuQ212aU9PV2RvdmhHUHpycXVhdWhVK3RPa3MwLzdlM0hj?=
 =?utf-8?B?NEIweUJWaFc1QlplN09LcTI3aURoYm1jNEZmclVJL255TFEvVm1QZzNKMDRZ?=
 =?utf-8?B?aGR4d3BIVkp4VkxKZVF2NFNwMDJ1YU9JaHRabjZLTyt4VWVvQmhteUgrbFVn?=
 =?utf-8?B?ZjhlMG0zSnQ5RGcxL0VaWGlvM1FOMFZrWCsrZHRkTGozc05FanNzUE5KcUJJ?=
 =?utf-8?B?QUdHdlRkZ093VnZzdDBMT05MbFh4UzNPRURoTmNzNHBLZ1dlTVcrTEpSRUd3?=
 =?utf-8?B?QnlTdDIvbGVDUDJ1ZkR3WnQrZm5XcVBJY2N1UTgzY2M1RmNKczBGMWI3cFFG?=
 =?utf-8?B?UGYvMDZKZzdwWTkzcVl1QVhNRDRLR2xad1owaU42MHJlWmNKK2lUSnFQN015?=
 =?utf-8?B?UmtMN1VpczdNd3QwK05kamJRMCtIY1FDOGl1UnRCQ2o1Q3J1a1NyZE0zV2NR?=
 =?utf-8?B?RkhzeXdzS1MrWlNhSkFORVJnSVloK1k1cit3RHdGM2k2cHVycVVjMFRNcExZ?=
 =?utf-8?B?RlcrOHpzN0I1bWE4U3AzcE90RmJLVnBJOGVlWXZZYkVMN2Z3ajY2cjY2UXd3?=
 =?utf-8?B?OEVOTVBLZGdGN08xZloyS3h1RHEyS21SUEhZRWdmRFRrT0JZQnkrZTBxVlpY?=
 =?utf-8?B?cW0ySW5iM3B2elJVSlY2Z2dNV1FEYXo0KzNiY05QdEp3VVFYR2dud056U2RG?=
 =?utf-8?B?dXNzSUM5bzNaQTBJc0tFRElNaVZhNzBCUnU4Nzl0WDJYK0ZJTWxEbTRDazdo?=
 =?utf-8?B?VmFwWHpsQVZEM0VrdHBlS3JhanZxSDBXZXlRWTFZOWJHa282bjg2akRBWDlE?=
 =?utf-8?B?NEJzdGRsYWFPVGEwYUd1RUU5T1NvYzlLcngxaTIzL1RWdXlFci9hK0d0MmFW?=
 =?utf-8?B?Yk5hSzJYMDRac1Z3N1hJRTBqOThYVmJCbTFoNTlaR05RaFBOa0RqNVU5WHE3?=
 =?utf-8?B?c0VrU292a3VKMHN5eGtZRkh0dUMySzlmQ0Z5WlJZNnlwZ04vbnhNK3VUa09M?=
 =?utf-8?B?LzVDcVp3M0YrbmI3Y2VVSURSQzVPUlZxekVBUFptZFdrcFhzSU5vWkZvQkVm?=
 =?utf-8?Q?n/b38yvVIhzk3D+fS2+vQwyIWwoeuJje?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q202TElxdFhmTzg4WEpvMkw2dk0xbGU5WlltdFdwS0owc2FQNVJneit4SjJ3?=
 =?utf-8?B?TDlWeXIrZi9XVEwxT3EremlLWEVMbW1aL2ROSHc5YmhtaUJxbkxoczF4dzlD?=
 =?utf-8?B?UGE2YjJaUGdwU3pob2RYODZJTEhwYVFLemIvdU1sSmlvOUwvL1dWSmlvNGtW?=
 =?utf-8?B?RzVGSnMvMEl2NDRBUHhtcWFNNFB4dXE3blNmSUpLTE9UR2owQythSDh6TFUz?=
 =?utf-8?B?UnNYcmFLMTFGaWVwNitXMWJrVE8yelZUR0VrQUJxWUdnM1prSlBPNWNSOUlM?=
 =?utf-8?B?NHkzOVdZWGwvdm9JdlMwNGhGZjF5N09WVEIrd0srZGZFM3lJUVRldnpUMmFi?=
 =?utf-8?B?dlpTNGpmMytsa1BBVzUzdW1MSzc1VHFwelpMblVLRUdZKzZsVmN3L3NRdXpC?=
 =?utf-8?B?UklEZ0NkNzlOdUdjbWwwYUJlcXM4MXpVOUhRenlqdmpPSmNJUFNISm5GQUh5?=
 =?utf-8?B?cGVyd09wZkQ3ZkllT3FnTytxcEtPcUI4dUJ1SXo2MlFBbWNnR0dzRmVMRzVp?=
 =?utf-8?B?VHVaa3I2WmpTOU5JQjNCMEwzMnU2WFpxWGJrajdYMHYyaDJMNkQyTkplaFJI?=
 =?utf-8?B?b0kzdUhIQjhkaVFCRnA1U2xBUFhpNzREQU1XZFRueGhwZVc1NTh3TDB1dURU?=
 =?utf-8?B?RTV1cDl4RFJ6WUNaTzRXVVI2Tm5mbTl6RlVyQTRrL3JuK3drMEoyTUQzeFQv?=
 =?utf-8?B?RXNVMFJmUTIxOU5lNmdHQm1MQ3VxS2psYjdteCtEcSswK2FHamcybmVMdDk1?=
 =?utf-8?B?dEhQVnhidFJpaGFkbG1LK29WbVVIZldmd2ZPaTA3L1VwN0hzSHV3czdNT1pm?=
 =?utf-8?B?WWtleWhpckY1NnBPNlgwRWo4OXZMT2E1ODlmcHhraGJkVmMvUFIzQkowSmdO?=
 =?utf-8?B?TnRlUHhFbkZBc3hJV1hlZmI3bUpKS3FTTFoxSlhjaU15RFBvQ2pQRU9HNXpE?=
 =?utf-8?B?YnB4VndqTHJTT2E4SnViYldyR01xQVQyd1VDdkFydUg2ZnFIVnlOQ0cyMmVx?=
 =?utf-8?B?ckVabmNmb0pBdlhycmZuakNMc2RKY2RKOXZkUHhQMHRHZWI4ZCtkaCtaMzRC?=
 =?utf-8?B?aVlUQ1lHM2wrQStYd3NsSUR5akNrZCtSTU5FMWQzVnNUNVZxOEZlTkg4dEIy?=
 =?utf-8?B?dkF3M0F3aFZSYVM0eXJDVjZENWRtY05HTWkySXJqWUtTdlI4dEd4M21CQ21I?=
 =?utf-8?B?ZWtBWWREMEEvMmtxMVUzV0w2RnRJc0hhMEZwaytTYVVKWGlpZldIRVcrVHBp?=
 =?utf-8?B?cGF0Q2ZvNE9PNnNrN3VKTWFsZFdwd25YZEJydy9FSG83VHA4YzV3N0MxM21a?=
 =?utf-8?B?MkZ0eTJxQlNhQjg3aytSeWFKTWVuQmt1blRVendJYjVGTDl2K2cvSjJoZUZM?=
 =?utf-8?B?a21DUUVnTU8vYmFiZVRMOVNaQno2N2VDZ2swTVFVdXFYdVVlZHF1RFhLcTM1?=
 =?utf-8?B?S0dGZ3ZQTFFJTWhxanpkcVZpdkhDbHgxSmJQQTRUT1FOdkgwUzZIK3drY01r?=
 =?utf-8?B?U3FVdXA2WmJaOE5hemw0c0cyTERybER3NHVVREp3Y2tUZTNzY1REb0Q1aG9v?=
 =?utf-8?B?WkIzeWk3Q2o2ZVZPbFlKSGQ2UGtHRUppN2toSkJtZ0NrWjhvT3AySk9iaGNa?=
 =?utf-8?B?b3Z3LzhQZWtJSmF5Wm1MUVhlT1gycDNrWjFTS1l5OWl3ZjZLZlVGbmw3OXZk?=
 =?utf-8?B?cjU3MEJ0cjNlSG1KODdDbGVVL01PZU5vOHZIZzl1TktTaXlhanBTYkppeVNm?=
 =?utf-8?B?V0JGTXR5WmlSeUJQMEpRcGVkU2hLTWh0cWhNaXZYN2FRSnNPcncvNlR5cmRR?=
 =?utf-8?B?VEovK1JUMWtSU2lvWFVPSmFLU090ckM5dzkvOC9qU2JNanNQL2pjQ3d3Rnlm?=
 =?utf-8?B?RXR2aUpiNm53Q0pINGdsM0JadjZKNm5nZVhCYitUTGJjRndreWV6QStQUmMr?=
 =?utf-8?B?MnUvNGdIaUJJNzM3ekl4MDQ4L0dtT0cyNTRGME0wZ3RteS83U25mWHhxMjVs?=
 =?utf-8?B?ZE5aTTIrbFB1Mk14amRySXpsRzdkdXUzUkVqcFo0aDZmOERkSmx1a2JDeldZ?=
 =?utf-8?B?Z2lSU0hPMHhud1V0YThHandQTDZMc24xbUhoNHNHdzliUlZsL2ZvLytXQWNx?=
 =?utf-8?B?aDRlTXE1NkY1T3pRalJ0UmZBMDJ1U2VoUVlPS2N6cXdJWkd0bjYwTlMzSGl3?=
 =?utf-8?B?TUNzRUE5eDhhS1FMb0tuc1VjSWJ5aC9yRHZOOEpzdXhLSkpLbEE1WDlva1F5?=
 =?utf-8?B?bDY0M3RDZktWWnU1Z3hwWlZ0Mk1PeVM1WkgzaWF5aldaRHEzbzVSK3hiNWl0?=
 =?utf-8?Q?zG5aEySPnVSS2LX7sK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a4c3daa-6ff8-4d2a-fb91-08de47ae5e1d
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2025 14:18:56.5876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7tiK4PPX2/xUP7vJ8T4op3BtsnxZaHptHbO9No3vJzgWjwCR5yzYhRpCjvO3I3/Pjlut6chBZog05vhAH7Uy7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7383


On 12/19/2025 12:41 PM, Carlos López wrote:
> Simplify the error paths in sev_mem_enc_unregister_region() by using a
> mutex guard, allowing early return instead of using gotos.
>
> Signed-off-by: Carlos López <clopez@suse.de>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 20 +++++---------------
>   1 file changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 253f2ae24bfc..47ff5267ab01 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2746,35 +2746,25 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
>   				  struct kvm_enc_region *range)
>   {
>   	struct enc_region *region;
> -	int ret;
>   
>   	/* If kvm is mirroring encryption context it isn't responsible for it */
>   	if (is_mirroring_enc_context(kvm))
>   		return -EINVAL;
>   
> -	mutex_lock(&kvm->lock);
> +	guard(mutex)(&kvm->lock);
>   
> -	if (!sev_guest(kvm)) {
> -		ret = -ENOTTY;
> -		goto failed;
> -	}
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
>   
>   	region = find_enc_region(kvm, range);
> -	if (!region) {
> -		ret = -EINVAL;
> -		goto failed;
> -	}
> +	if (!region)
> +		return -EINVAL;
>   
>   	sev_writeback_caches(kvm);
>   
>   	__unregister_enc_region_locked(kvm, region);
>   
> -	mutex_unlock(&kvm->lock);
>   	return 0;
> -
> -failed:
> -	mutex_unlock(&kvm->lock);
> -	return ret;
>   }
>   
>   int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)

