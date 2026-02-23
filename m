Return-Path: <kvm+bounces-71468-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id INOMIPVUnGnJEAQAu9opvQ
	(envelope-from <kvm+bounces-71468-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 14:24:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D74176C27
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 14:24:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6177A3043D96
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 13:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86F61F3FED;
	Mon, 23 Feb 2026 13:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SLPTReg8"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010006.outbound.protection.outlook.com [52.101.46.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C953A1D2;
	Mon, 23 Feb 2026 13:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771852922; cv=fail; b=vGNoD3NONfgcqfHZPsWIMm1lObMytaytCWEKXf3p9C1v5OO4nJTLLT8R8G3uxpc0k389SSlwCrzUl1nCw05vC6noUtiwKLRgpgWNOZZEcqR/oy0PLoyq4WArvZAx9EWkliXowtMpDT4VdVQZYNNxbYSzU4K5NsJ6sQt3wqV+G8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771852922; c=relaxed/simple;
	bh=9RwgVBy3w3CViyDM3VRb1UB1HGdKgPbqlTnS5q9STkw=;
	h=Message-ID:Date:To:Cc:References:Subject:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SSEu7YsUbKAI8EjUAX25ljED10bEioL9Hq7VO491xic2FnyKsPp2ykRocTBRv0+IFs77v8g8SVBbe+4NWZlsAuXkSK9DJOVyzZHs1zqLaNo0irjdZxNUhqWGOxXfup++C/zhNYTSj4xZzoJpJ3pYGpT3mgSzAu/DqwqeMYLUWeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SLPTReg8; arc=fail smtp.client-ip=52.101.46.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epJOKUDx25/Gh4InXooXy2msC4CsPuiXH8MjbHgtY1ztZUpwnhCkL/vFne4g+DPR1278Vl4mo6IVaLRnY7HlKVHPkaRq7Z9VzQbR+amqPR686vISYcGr3xLp+zHctMCNXGwVa1rMmAwIEIEwd5Z1d7gV56ynGtDvcEeBA1IhMMJRxXNDCwCJGHSz6EOfiYoVSE4B2WQ+AQKKUalLfBpKuFb1OxoXNrY1ridukuOkcLGUelVdMlKzwbceVrLRsIaeYhgqhVHk6ytVDEX/zehEKtLoWjmFzMbZoEdIacr7Y4eNaC+D6S3FcS4ijec013XT0Di6kLy8nHOPyhGVp0dtsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53NXDp1K+1pjINh28+tR+02cSeDFN8z48vTh6wyEvYk=;
 b=QUN6fCnRPLBtR7z6BDiVkENj170FUNjb+ufGVrsemuvYZ78FLi29Y6zFdVye+7/70n5eQ/i9lUtqsNPmaSogQ1gSB5QWVYeOQXVFpK2Y0N2M3NZgtxMij+vV0ERCOAx6lG4NPXiHziGCVGXWdOE+0N52X2+4IsG1RzoGVD1ESKjBPXqXKRldaYci5PFheR8y1Qny3UnrwV7FpDkG9mxPCDV44MLOk2BhvY5+mZMdbTjgTZfoKeg4nmc/TkE24CScBi+or6FbnhGwmcRgsQpX0lq5ePf8zGKh0ZEFzeUUnLiDYk744YzC7QnI/1oJkHr/9EZEczkQE7Og9cqrBCmBHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53NXDp1K+1pjINh28+tR+02cSeDFN8z48vTh6wyEvYk=;
 b=SLPTReg8DLTkrTGKDj2UbfbVj+Yz9feoiBbTusQ6+KxFHBdiIlKpUtOqYug7dT6AiT6NKcEWjk4Yg+dVt196hHrCpj5TouuPjTGm1PD5z7gYoZ/5pxsGrRujt+TQQ15us46GQOZUlord8godCr7kFQaVYZEJzhe7tO2d6IcDn/K6FERzkmYeNcwfqxGNlEPaVz/dIHWX3T5H6YWYGWwawW6FKaFPBmI+9ZWKIFQRfyqZGqjatvjhSK4impeVSXfRWY4tIqhR6sWzqWnzZyXNUIuaXpJIu5hjoAoz+hV86XxGPfDH4pB9ikXDCza6lTxZ6GlHL1X7KiUhJFMDDB4e3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 BL1PR12MB5707.namprd12.prod.outlook.com (2603:10b6:208:386::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 13:21:58 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 13:21:58 +0000
Message-ID: <593d772d-4fa0-4d52-9ecb-9526bdf47ffb@nvidia.com>
Date: Mon, 23 Feb 2026 05:21:55 -0800
User-Agent: Mozilla Thunderbird
To: reinette.chatre@intel.com
Cc: Dave.Martin@arm.com, akpm@linux-foundation.org, arnd@arndb.de,
 babu.moger@amd.com, bhelgaas@google.com, bmoger@amd.com, bp@alien8.de,
 bsegall@google.com, chang.seok.bae@intel.com, corbet@lwn.net,
 dapeng1.mi@linux.intel.com, dave.hansen@linux.intel.com,
 dietmar.eggemann@arm.com, elena.reshetova@intel.com, eranian@google.com,
 feng.tang@linux.alibaba.com, fvdl@google.com, gautham.shenoy@amd.com,
 hpa@zytor.com, james.morse@arm.com, juri.lelli@redhat.com, kees@kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, lirongqing@baidu.com, manali.shukla@amd.com,
 mario.limonciello@amd.com, mgorman@suse.de, mingo@redhat.com,
 naveen@kernel.org, pawan.kumar.gupta@linux.intel.com,
 peternewman@google.com, peterz@infradead.org, pmladek@suse.com,
 rostedt@goodmis.org, seanjc@google.com, tglx@kernel.org,
 thomas.lendacky@amd.com, tony.luck@intel.com, vincent.guittot@linaro.org,
 vschneid@redhat.com, x86@kernel.org, xin@zytor.com
References: <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0382.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::27) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|BL1PR12MB5707:EE_
X-MS-Office365-Filtering-Correlation-Id: 73d75222-80bb-4b0e-cb70-08de72de8569
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qlh3UFVOL1ZsOFg4YjJYcEJYUmVHWXZ2c0orVlg2QkNsSUpXajFSMzhOaUFt?=
 =?utf-8?B?K0I1bTlxY2tqM0ZjQ1ZWa3QwL1BQUjNPd1k1S3NXaVdnbWpQY3NnUHdPY200?=
 =?utf-8?B?Snl3clZETnJQQ2d2eUNhbFprN0Q0dnE3YUxoSzlFRnpKNlNSMGs0aDJuK3I4?=
 =?utf-8?B?cWJFZHpmbXJqQVROM2NPR2RaN3N4NzRXZ3ZSenU5ZmpIWERWSjJBKzJ5NWgv?=
 =?utf-8?B?eWhnU3RVTzNlekszbXJPcjk4YkI5Z1hpcFRaK0JwbjdIVTdDMDBhVzZFcThC?=
 =?utf-8?B?ejU3L0Jtb00wYU5vSjA1OGd0cTBuOXhSWFl3aHdHcUJDNzZzWWZzMC9lRmho?=
 =?utf-8?B?SXBuNGUzVm01NWVkZzRXenczU1NBelBXdmxXQTNZZmo4N1JnM3dkalIxNk9P?=
 =?utf-8?B?NnJMR1E5V3ptSVFUcU1tSHU0b2ZoeEg0Q1psclA3TEZ6YU42ejdjWFk5cy9s?=
 =?utf-8?B?UUZodG1TenJUSW13WmRGUUFWQm85S0gxcjZXODBpdGpBVXBoOVRneWV1Kysr?=
 =?utf-8?B?azVLY3J3dGMxQW1qeXJ4eVpON0FlbURxL0w5NGVuNEFoZlNDQm9HaVVWZm14?=
 =?utf-8?B?dVlSNlc3MWVFSkpZdmZ5SzF6OU16eXo5M1hrSFJjNnNWVS8zL3ljRTdsdnBa?=
 =?utf-8?B?Q1FNYzJDcVlVdnVmdFd3ZzNONUIvbFVIMjIzT1ZYZDlLMWZDYnpjUE9NZU04?=
 =?utf-8?B?RHJoUnRYSHFmSVdtczhxdnQ3aHZJRkRwdVQvaEpJY0JUaHF6ZVcvM2N3Z3pX?=
 =?utf-8?B?REhqbE91Q0gyc3g0OFBkbGR3V1ZwTlZDa3JYQlJpQVJvK2I1K2d5Y0F5dVJ3?=
 =?utf-8?B?Vm1qL0JNKzdoUWZ1NWZ2V3J4aUsxYktEdW02N2FnM0NJWXNPb2tNU3dadWVm?=
 =?utf-8?B?c3hJclE0QUxYOVBBM21NVjk1S0RzcEtMNUtqYjl6L1JFaUVlLzVQUzNoRkVO?=
 =?utf-8?B?VnpnbDFDZDZtaWNaMmZGY05IbVhvU0ZITmpCV2EzME9uM1lFcGVZV2k0cXM4?=
 =?utf-8?B?a2tSUUR5dTgxa0JYajBuaDVlSUpMcGJmUU1kV0dpSFRJSThXTm45N1NBNEtM?=
 =?utf-8?B?S1VKcWFrUnBQMEZDODZNWjIzVXNhY25wYU5TTHV0T2U0NzNrWURGVzV5dy9S?=
 =?utf-8?B?SXYvTmExRkpYbWtub3MxSlFJVU1EMjBTd1A4bTJVQjVQVW11aDNTSDMybVJB?=
 =?utf-8?B?TnM2akIrS2NOSHRZSUxoNnMrY01nUGs2dThPS2hsa0x3dGk1aStHSm1nSWgy?=
 =?utf-8?B?T2ZXMmNtNVBMNm5oT1FjYkFhRzZidmgzT0VKOFlWNEdXUStaalMrVWFPQWY3?=
 =?utf-8?B?THdnRUNsdkpBMktSQkJhbmM3b3d2djV3Z040M1cwVjBnWmpncE43UW44WHZZ?=
 =?utf-8?B?NUxPNDN6KzZWc01hZ3ZuRVc3aUVBZU4xTi80MU0yUGpBT3RWUTJ1bnJaUlhZ?=
 =?utf-8?B?QkNuZ25OQ3BiNnJXV0JlWk5RMzN1aG9LdUdYdzlvcXBXTnY4Rks0R2kvQ0lD?=
 =?utf-8?B?bHc3RlV5SFBYS3g4Z2pONTRFUjk0UGxqQ1RiRktCWkhZMmc5OUNNUUR2aEpX?=
 =?utf-8?B?VnJJMDlSZllhcXYyM2lXdEZYbm1iUzFRL2NuY0NrOHNwWmttNEo2b05SK2hx?=
 =?utf-8?B?Q1VDTnY4QnExcW5nTjVSU045NlZxcDNNNGxaWkFiamJYK0JBN0FiSEdiSW05?=
 =?utf-8?B?ekpoWENtTmhaNHZZcGVXMzhWRWdrUTZLcHUrZG93N2I3d3V2VGRSUkdpbGU5?=
 =?utf-8?B?T0h6TzJieS84M1Y3TzZSQlFvOFlhRmRKaTM1NElKSWpqOXhlQ2cvWXNQNytu?=
 =?utf-8?B?QUs3WE02aThTY1h6Y1dwQU1qaWc5ZGdhbkFJek5EOTI1RnlWYmlMK2MwdjFC?=
 =?utf-8?B?c0RPdkEwVkJLT3YzS1hIblN3a3BVZWY5OFVyTS9OUHY1eXByejB5eVBIU2kz?=
 =?utf-8?B?WXl1ME13eG9QMUF2YndYYXVtUlhvU2pmTzgwM3VoalNNZ1J6ZEcrTis2SlQv?=
 =?utf-8?B?alV4cjFaWmwrM1RjTmZiR0tqajdHeStMM3NtSVBzd3pMcXVlNlo1RnVFOGVY?=
 =?utf-8?B?WVZ6WHFoRVRHT1B6NU5Nd2d6UVB0eU5hK1VoQlhySjZhVmQrcnFNenpBYi9F?=
 =?utf-8?Q?uYeg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGZjdHVrVnV0QnFPYUNQNXVGWmROQXArcWZOanNSNTJlTCtQSTRjZ0h5cExD?=
 =?utf-8?B?S0k3cGhialV5Slo1SWRkUmIyMm9BczJqTVhjdkpzMURuYjZNSmxOM2Z0UWxz?=
 =?utf-8?B?dGRybmlNb2hwSEYxVHJoc1RBSWNOZHRBZURFQjVEU1dmc0Z4ZFNUQlM4ZC81?=
 =?utf-8?B?eHFyeGVrTHlhMDJ6S0orcEh0MkRxZnFyUzdZTUVFNHd4QStTZVdKVXJNSXlF?=
 =?utf-8?B?NGlNcXhrRW8xbDI5dTlEMHUrTDNxR1BabFcycWxEVGM2NUNTRkNDVG1aSjBw?=
 =?utf-8?B?OUJRUmd5dFdkaHNRUGhtcnRVRFc2VUwwY1Nuem8rNW4xR0E4QkJONnBHVWd6?=
 =?utf-8?B?NHpxR2MvYVduOXMvZEZveThNSGV2VE9iaFhMWHVsd25FaDBmSzYrZWdtRmRx?=
 =?utf-8?B?S1RKOE5zRk9oRHFITU5sWERaYkNzR045NFY5VjlRcWRIUDhIRk5wbXpjZzFO?=
 =?utf-8?B?SGhOazczVk1JVUtGa1NoQUxEYXExNGxtaE1DMVRRdC9pNmltOU56M0I3SXBF?=
 =?utf-8?B?ZVdTYUFqaU9aZ2tpNHFBVFNKOWVnR2E1aTB3dVZzY3RHS0dHdGh0TVAvUEUx?=
 =?utf-8?B?NWZ6UVdKWkIwSTV2U24ybzY5SS81T1hoQlpyTWxtSXNSTENBSHkwVFZzcWVa?=
 =?utf-8?B?M0ZubkQzZXVXTWhIOHZIOTQ1azRCK3lVazM2cHp4Y2JHYnR4RUFNWWJxd3I2?=
 =?utf-8?B?SDYzcW1UTTZ6MkhiaWVZNVBCLzlOMm9NZFZiNGp1c2lNTEZsWnh4TXdrVHlj?=
 =?utf-8?B?U0U0dHE3aWc3emFUREIrU0s5KzE2eWZUaGxkNVBJdUE4c1I5ZFhRVzFac1o0?=
 =?utf-8?B?ZjAyb3cwWCtjNUtVaTNTWEJSeDNkS0F0SnEzRVJVRGltcW9tdHpSblc2MEgy?=
 =?utf-8?B?eHluelFZQW11c1JCUVp1WnJkWmFzVG5INzhQb1NrYTV4NXBnMG1EV0VlRTZQ?=
 =?utf-8?B?ZEhUUlVPOHAwNnN0a3l0WVM3QUYwYTFmS1RGc0NmbXA5azVEaWRndXdwVzNx?=
 =?utf-8?B?NW5Rc0dsZStzb2o4RUlrVEozaTRVN09tUWxucVlMSEMxT2dZVUNkR2tVc1M0?=
 =?utf-8?B?Tk9hdEpGcHN4S1U0MEtncXh2L1NHNFVDVC8xb1NjZzl4ei9SZEZSMURTWVNN?=
 =?utf-8?B?a2YxUTZsRnRscGQ1RDErcWFQMjRSUzhvZ3pPK2pTYXFCaXllR0pIUzBUY2lO?=
 =?utf-8?B?VkJidXNQdWkxazNmTENiTlllaGRwWmpHZTlwLy9sRGV6eWI4RndodURTNjRN?=
 =?utf-8?B?dnVKZE5HblB6YmZQNnBuQnk2T3c2N2tGemN0VVlMd0duVHJzY0Niekw5NEx1?=
 =?utf-8?B?aHd1SkNTRHNOcXZlZVhCa0hDUlVlbG5BK29PcEVwaDkybEZ1T25yNXgyeHQv?=
 =?utf-8?B?SDRVTnBNWENjZVBEQS9YZ1dFK3FaTTRWanBlc2w3YXJMMExSMGw5K2l2Mi9a?=
 =?utf-8?B?RnRoVzEraGhwKzlTdE5SL0NsNmh0MmF5OFpGREN3V2t3WFBPR1hvQ0p3YW04?=
 =?utf-8?B?YXZ1bDNkejNROHRVK2lQdG1Fd1FWS0haUDRkVzlRTkkyMDJTelZEbFoxR0ZY?=
 =?utf-8?B?WStNRjFTQW1tditPM3k4RlA3VWQ3TmZMdGNFMlJhMjg4bmhDZDNnb2d2NkN4?=
 =?utf-8?B?ZWN3YVhNN0s1N2JLbkkySUJvZmxjR0lXZkowRHJ1SXB3V3k4OWFTcWp5amFx?=
 =?utf-8?B?Tk5TTHRBWFdYYlI4RENyN2dOVkR2Y3kvbVZjN1dmU3JTMjhqZTdoNVJGV2o3?=
 =?utf-8?B?UzRQNEhnSHh4ZkJMS3pVNGpiYytGNzFPYVpvS2dPdVlZT0FUaVVTZmZMZFkx?=
 =?utf-8?B?UUV0TkpBOHUwUGJ4ZW1tVkdXNi9DU09sZWMzbFJqbGJxUW9NNU9BSGJiRlBQ?=
 =?utf-8?B?TzJ6TkRtMVF0VWUwU2dETGtGeFczb2JuVHpFZ1NJeStIRDFkcWtUam5kUUwz?=
 =?utf-8?B?YzU3bUFZVUJVVVlTUyswRm9EWlRIU3JYUXJvRWZwdlBzY1dBZm5HeFBQMW43?=
 =?utf-8?B?WFRVUTZsZStJUWgvWVpmdTk2WG1JbE1DQzhHdlg2SEIwVEFyNVc0Zm51Z2lw?=
 =?utf-8?B?SjZJTEFKN1VlRm10UVRIbjgvOHMvUjJtakx3ODJxcXlzV0p5VStvTGkwUTFn?=
 =?utf-8?B?VDRad0U5ekxubnhZYndTblJYWnVtWm1pSzhPS1VIYmFMNSsrZUNCbnl4OTJD?=
 =?utf-8?B?ODVwcENhVWVIVFd5Y0kxdWpCU1c5c0piOFA5dUZnZFVBOFF6RFZ1Yjd4L3pW?=
 =?utf-8?B?NnpIMU96aWVIdFBLdHlWd1AvcW9GV1BkWmVibXFTSmROT1hhVkpZb2xJNVpO?=
 =?utf-8?B?WFQ0Yy9iMTRIN2RaaURadnppMlNtN0xacXNKazFsYkx4cGQyNE1wQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d75222-80bb-4b0e-cb70-08de72de8569
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 13:21:58.1934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zpmpqi/n0dZigvsIkd+WJZpQJLzE6YHE/WPEQ0p3M34ytDaRGmK8Rdc8iv/8PZAuTt/WdY8EaZyhgs+YAL1dVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5707
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71468-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fenghuay@nvidia.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,nvidia.com:mid,Nvidia.com:dkim]
X-Rspamd-Queue-Id: C2D74176C27
X-Rspamd-Action: no action

Hi, Reinette,

 > What if, instead, it looks something like:
 >
 >info/
 >└── MB/
 >    └── resource_schemata/
 >        ├── GMB/
 >        │   ├── max:4096
 >        │   ├── min:1
 >        │   ├── resolution:1
 >        │   ├── scale:1
 >        │   ├── tolerance:0
 >        │   ├── type:scalar linear
 >        │   └── unit:GBps
 >        └── MB/
 >            ├── max:8192
 >            ├── min:1
 >            ├── resolution:8
 >            ├── scale:1
 >            ├── tolerance:0
 >            ├── type:scalar linear
 >            └── unit:GBps

May I have 2 comments?

1. This directory is for both info and control, right?

"info" is a read-only directory:
dr-xr-xr-x 8 root root 0 Feb 23 12:50 info

And its name suggests it's for info only as well.

Instead of mixing legal info and control together, is it better to add a 
new "control" or "config" directory in /sys/fs/resctrl for this control 
and info purpose?

2. This control method seems only handles global control for resources. 
But what if a control is per domain and per closid/partid?
For example, MPAM has a hardlimit control per mem bandwidth allocation 
domain per partid. When hardlimit is enabled, MPAM hardware enforces 
hard limit of MBW max. This can not be controlled globally.

For this kind of per partid per domain control, propose 
config_schemata/control_schemata file:

partition X/
	control_schemata (or config_schemata):
		MB_hardlimit: 0=0/1;1=0/1;...

Is this reasonable?

Thanks.

-Fenghua

