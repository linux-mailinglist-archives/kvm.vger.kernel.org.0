Return-Path: <kvm+bounces-58156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2061BB8A5FF
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 17:45:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0D3517A48E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 15:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCBD31DDA4;
	Fri, 19 Sep 2025 15:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5l06imIx"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010023.outbound.protection.outlook.com [52.101.56.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2312609EE;
	Fri, 19 Sep 2025 15:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758296725; cv=fail; b=LQqezFQvTrM5KmGdDi+MaBeQvm3ag2nimXItjFe/g9N1Uuqirgjh1LJarFVgL8M01U82d9c4b3WmGBKl43fiQhLIRvfcuHLRL8Ul1yybX4xecDRQ6aabUz6dsCsdATEy0guJVukwoKq5ffjR5lW7sjR22oleKatgrttHZ11EZFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758296725; c=relaxed/simple;
	bh=unPtWHc+4BkQY3PTJDSDOFxfOgvbQd4aZ3uu4MPrKuk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c5Cxw2jH8c3KqhpOTUOUxdD0s4tf/eKLCDggkH/KsbBHV91mfNRCdSbTj58r7OtAvHoFxPyZ38Qi8V18jpl1xcAgul1Jgj0+xfWH2d3H5uYsf116pma2eLO9gyzjeHr/gBOE8HIqNB3NPK6Wcbp5s+1+IOt1ueto7GEuwV+H2Xo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5l06imIx; arc=fail smtp.client-ip=52.101.56.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tw/pBGW/Fs4JwXyy8vBzRqSA/OJLI+6l/G6rW+3pJ/ALrIGkODTEUBi0jbqvA7vNP3877NJnEjKfKePbxdGDXHoLM7iuuklvhBGFhX9dHTA0zH+TaNmZ0r9zJtEqjg2E2pdXHk5tqi/MApy9rptiERtga2NtirDKjIOGGt7TvDjNIfATcnWHkpHqcc5+/CpXG8ULFhLCUZevM3nqRDzUx3HuB4ZmPrWzdly7PSIb2UD9Nazv2gERKxhHgLHO5Lr0ZsSniH6w8GQtq0Ox1ySXseHiVhjz5JjJgJ8oghXaK6bAYDdkAC5r0eJgHP65uObg5dMBRKw7Fd7f1COVvFUARQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJgPISUtLAksdeOkpwo7QEcaNDYjWQIyN40nJdzabvI=;
 b=yF86wk4HbNqkpDmZ7ufKBDnhAd9V7uTLNVG0Xt077XBY+6GNKDSOl4k5p9QfW+d8X9O6dP2mBOpMx7UQQgmTFibZOtf25aZ6KwnTYph/q358StDKuvSXT1+ysWFwWgzFsacbOaOonX+QdjwEXUtS5QAfNV29QdA96FbKUnpQ+YoDxuUaFNv7rXDcpUcLW60gzUfIRV4z22K5PaGlBUTvCpbkj89UMw2GTGK4BoNd0ns2UgNclcjePRdcX7SgmI36EVPC/3yHgAQ/mJF1uM9g5C9wigkBE+sSHYtoWzHkoTUqc5sSvOz2dzcBSgbXpIHIfzqNOEvZlDfZxMLYnnJU2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJgPISUtLAksdeOkpwo7QEcaNDYjWQIyN40nJdzabvI=;
 b=5l06imIx7X8nsqtcoO8fiaAJ8fSaf7YbvWOBqg5X2EyBgXucLO4E3zsGVvuG3RCyVJLSTAxlbxKCK52jnQbdiMJJg0nSjanyghkvD9h+kjqKmNwbXp1DwufDrtZoBkqD2taVmDZ4K3GaBEOkZyM1sxl50nVr6CRF/3LambVGiY8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by MW4PR12MB6755.namprd12.prod.outlook.com
 (2603:10b6:303:1ea::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 15:45:17 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 15:45:16 +0000
Message-ID: <55592492-bd86-45dd-8262-a34bc74d849f@amd.com>
Date: Fri, 19 Sep 2025 10:45:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/10] x86/cpufeatures: Add support for L3 Smart Data
 Cache Injection Allocation Enforcement
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, akpm@linux-foundation.org, paulmck@kernel.org,
 pmladek@suse.com, pawan.kumar.gupta@linux.intel.com, rostedt@goodmis.org,
 kees@kernel.org, arnd@arndb.de, fvdl@google.com, seanjc@google.com,
 thomas.lendacky@amd.com, manali.shukla@amd.com, perry.yuan@amd.com,
 sohil.mehta@intel.com, xin@zytor.com, peterz@infradead.org,
 mario.limonciello@amd.com, gautham.shenoy@amd.com, nikunj@amd.com,
 dapeng1.mi@linux.intel.com, ak@linux.intel.com, chang.seok.bae@intel.com,
 ebiggers@google.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <cover.1756851697.git.babu.moger@amd.com>
 <b799fb844e3d2add2143f6f9af6735368b546b3a.1756851697.git.babu.moger@amd.com>
 <19fa188a-bd1d-43e6-bed0-1ca35cbf34ac@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <19fa188a-bd1d-43e6-bed0-1ca35cbf34ac@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0095.namprd04.prod.outlook.com
 (2603:10b6:806:122::10) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|MW4PR12MB6755:EE_
X-MS-Office365-Filtering-Correlation-Id: f4f7b77a-2a62-44c9-b8e0-08ddf793877b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWxDQmlxRExnWi9rUlZ1UWpHQ2pSTVF4TktRSnd5eC8zZmJUR2p3Q2JQdHhH?=
 =?utf-8?B?bFR3eHZGQzFPc0daWG1SREdLY1RuU1o0bSsxVWRRcmxsc1dpbW4xV0NnWlJz?=
 =?utf-8?B?bkFqVUkzS0VXK1doMFoyWHlqTHBkaFNYK2V1c2puTHh4cjhHT002SVgzcjlh?=
 =?utf-8?B?UVRUclNBTy9iTTVFdzhVZW9yRjNjRldwYjdiTnF5RFYyVFVGU1ZpaEVUdmlq?=
 =?utf-8?B?RkV6eWFPM3A1bUwwWG5ML1l6OTJQSTdlTTJUb1ZRSjJVa1ZybkRzUTYyVjM0?=
 =?utf-8?B?NmNyWEt6T01XeUxIV1pkNDVSS3lDbVIzZThBVzlUN1hyNzc5N3hPaUlLQU9M?=
 =?utf-8?B?c25uVC9DOVEvdDdicktGZklTbEdSL3dpb3FQbUZ2cTJ6SkZCVVI4S09CVXpz?=
 =?utf-8?B?NWsrM2FaQWFUdTJITyt3VU0xQTVOQ0NmUTJtVWVObmRNUWVtVmZ5TWFReFcz?=
 =?utf-8?B?MXR1aFF6WXZwOTdYZXhLcmRGMEtoMVFhUkF3YzM0cHYwS0VNeTgwVW9MaFZz?=
 =?utf-8?B?eVVKeTRNQjVYWjZXdUVxZkZWOC9WK2kzZlJWaXJ3d0ZIVmprRy9PZ1c2RkRk?=
 =?utf-8?B?WjVyUUIxNEYveVB1UXNUSTZlZDNHWHZ5aDVmaUYvL2JiK3dheXpzSkFHY0Nl?=
 =?utf-8?B?dk0vRktENFlnaS8xdnFIbFBmWS9MVGFqcmxUYVorSTZvcTBJSTREZGNqS2dN?=
 =?utf-8?B?VkFaWU5FaVA4QTA5NG5MWHUzQUsxaGJJUmprRW5ra3NZNVJWL3JjQ0hmOUJj?=
 =?utf-8?B?SlRMV1ZUbXpyeHhkMzRRcnNMMTlPclBveFBXVWd4WjZBSUQ5dTlqdHQrSURW?=
 =?utf-8?B?d0ZmakpjaytVczVJU3dHRFRVdTlnV2Z6TXlyVTkrL0NkZisvUXY5b211NC9s?=
 =?utf-8?B?SjhFenhkNHU2TlpRcGdCdkRoNHh4OGllV0ZmZUZma2RlNVowU0JhUUpGc0gw?=
 =?utf-8?B?OEFiZXVFcnZYR1VMMCtrYnE2cmt2dm0vNStlc3JEdkN4b0sxd3hIV1FhRVNx?=
 =?utf-8?B?c2RGcGErNTE4S0tYQmx3OWMwSmZETDVRUDdsZ3BRMlUzQ3lWVW5UOXFkTElk?=
 =?utf-8?B?WFVLMWx0VVJmOHVhQWgwZ0tkY28vYnRmdWtzenRITnVVck5vT2s0b2ZUV3R6?=
 =?utf-8?B?RDN3cGtKQ0R0QjRYcnZOQzA5SmJWZ0Q1NUxBNG5GVVNhMmREY0VlQ0wxMUdH?=
 =?utf-8?B?VHE2UnZTRWNPWWptZzRFL1NSNzlMRjg1bEZwZ2lwWXcvSDcrSjRySHpKcGZU?=
 =?utf-8?B?WmVWMFdDMnFGbml6Wit5MWJTNlFVMkNlTTI4N0J4QnluaEFlemVPNGxweEZp?=
 =?utf-8?B?aGNqbmRLS1NjbVpVTTNSVURETXFCWFpBbWtsL25peWpKZWNxSUJralNUeGk2?=
 =?utf-8?B?OW9zMWNnMEJ5ZkpOaDViaksxaWt3UHlOQ2E1RGdOa2h5Q2hlM2FLL3NmK2c2?=
 =?utf-8?B?SzEvU2IraUFBYU5CTkxzSEFCZ0tXbG1RczZrNng1d3J0RE1RNCt2L2U1eFlx?=
 =?utf-8?B?MnBYaVlybTZ0cnFGdWlMOE9PazVpTFRpejU5bWxoUkZvdUdHUnJNWUJvbEJM?=
 =?utf-8?B?RWJFRmRlNExpN21uUGlDcXI3b3QxY0lVOVJoZXRWZ0IvalNmRzFJbjJKWWRn?=
 =?utf-8?B?bmE1TDRiRjdKZEpOTWM1RXFZb2VzNE9XeTJMSkVqaDB2MDdrR0J6WW9PNTBV?=
 =?utf-8?B?Q1JZYjdEVWNxNTMvckpCdzFwbE1pMFhYMDRYV09MWmdWTFlzdmJaMURBaHVj?=
 =?utf-8?B?ZDBhUkVJMGpKZ3RYQWlMRTNOdnd2VlJKbjV4bGNkRTBZS3ZXOWFkK1Z0Mndj?=
 =?utf-8?B?czFVSnVXQURrWWpDbmt6Q3RkcDErZTBZK0Y5Q0Y0SzZyeld3d0w3a1J2S09y?=
 =?utf-8?B?WldCTVZabDQyblhhUHBPL3k1S3dHaFBxSmY5RE43NW9oOGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFYzbHNNaVY5OXVLR3VUUlFhTVF4dFd5V2pxVGw1bUc3dkgvajBabGtCUGRQ?=
 =?utf-8?B?enpaNkJVaGNjYUZ4Q2loUGc4NFNpOGowbEVvMVJTdHBPZjM2bWpjZjBBY2Vp?=
 =?utf-8?B?aldZdVhldVZiSlVWYU9rZHhvM1NMTDNoNWx2ZWJuWkVnZFVaSFpBeVJ0aHZ3?=
 =?utf-8?B?UVRrRWRmOWZvU2dDdUZOc1ZzdTR4bnViSFJWc0QyOXJhR2tkQ0VSRElrd2hP?=
 =?utf-8?B?U3ptVTBOTEErU1ROVGFDcTVhelZERFk4cGl1dloxempCSkFkc3ozTkI2amg1?=
 =?utf-8?B?WXpSdEVodHJOWlIzdzI3SlVNYnd5SVQyazk1b3g4Y1ExOWN6S1dMbVZJM0c1?=
 =?utf-8?B?dlRuWm13ZlhPTlA1SGk0WlVUaGdjYWtGcUwvQjVnTit6Q1dBMi8vcm1SU2FG?=
 =?utf-8?B?YzZFcld4L1NZR3Bnd0gzb1BpNjRCSUx4TmNBWi9hSnlqaUFxb3RrUzBZU1Q2?=
 =?utf-8?B?cFlSV2VIK2JoTWc4RVRHUnU3d01zM1NXZ0E5VnBhVjA5L1BoMlFIRWFzbjZG?=
 =?utf-8?B?bS9pZ0U3cFFrVDlGSjlMTzF2ZG5MM2NNMFdJOXE1QldDdHNtcnNUeHB6U0Jp?=
 =?utf-8?B?cWdwUGFaakxFYXBiSWZUTFBkUVRKV3YzSXQ1L2sxQU00OVc3VWFQU2VhclQv?=
 =?utf-8?B?TFlUS29zUCt0RTQzWXRJT1ZFUklFVEtQRm94VjUvV1cxWmVMZnA3S2xvalo4?=
 =?utf-8?B?S28wSWRNWlVXeU5Qandoa3pOb1VrUnc0Y0tCdWtsMDNaVkRGc1ZZTEJFZXRr?=
 =?utf-8?B?Q0NERXJjTXpEK0FrVlBKOEZxVVdrY1dtZytoR3VxTXNZMkNnRlFPNng5M3hD?=
 =?utf-8?B?RU82eGkvdk1OVm82cG11SVpYdFFmdS9YRUJzVDVrWERtWm5tRHhDSWtoaDdM?=
 =?utf-8?B?bStNQ2UzTzFUeW92MXphWjRQRzhuaURRUXNyOGtKY2NaMGI0M2paQWFDRi9n?=
 =?utf-8?B?SFRsUnVpUnpybmNYTjViTFc3OUdzVGFUVXB5eS9jbU1taVhwUVpBYW5kQXAv?=
 =?utf-8?B?UUdTUE5xL090aW5ISVY0anpLMkhtbEhSSTJ2T0wrVG5jWjdrc3IzNnRqbWFB?=
 =?utf-8?B?UzY3RkMrVnNkSE40a0pvOU4zZ1k2MmU3QjRxSzZMSWlGM1JCTEZ1QzNjKy9W?=
 =?utf-8?B?YU1VeWhPSTh2aGRNSHZXTndCY1dwNUxZTzUvWXN3U2FjVFRQOTFrdDZFOHBp?=
 =?utf-8?B?RWpYMXVzOG5Wa20vRFZicWNvMkVmVHhMb3hpUjNoc3BqN1MvMTRJbWx4ZU1J?=
 =?utf-8?B?RGJJSGp2QklzazdRK3lURG1ZYTFzY2xzUWt2eEtPbWRYZ0JGTzVybG5NbU4w?=
 =?utf-8?B?VE9MT1pVb3ByYjVNd3VGeVM3UDNHUU9jeldCZWZWcVVwb2lncllxK2hDbjJk?=
 =?utf-8?B?Umx3akdWS2ZZb0hQN2prNkI5NUkyWHJobWZRb1JNakllSWVLYnEwNWhFVnFk?=
 =?utf-8?B?NENPbi9yRGRjNFFlUVhmUnBld1IvR01ZU3VhbG9Xc3RGVm5tb3Z5V1FwVU45?=
 =?utf-8?B?OXUxMG10eXAyakdmVWxGVm9DL3dTcW5NWFpFd2dHdG9aYnMzbFZZTTloUDQ2?=
 =?utf-8?B?WWlULzk2a1RJNWg3MmxDZHJFNnNZMW9obzhBVWxkVXpVQUxLOHZvWVQ3S2kx?=
 =?utf-8?B?NHY5L3paWjdJakRYNWQrQ1VMaER5YlpPR040b1ZzK1RrODU3TXo5RkxySDZh?=
 =?utf-8?B?UzZaeGtYVHIrTGE5aGF4RVp6M3BVaENjOWRMNTRxWWNnc0R0dWtUbTc3TThq?=
 =?utf-8?B?Ukt4SmdqNTQ5QTk0OVQrRC9jck9LVHh3cmpET0R4WEx2c0l3UGJEQkNmV0x5?=
 =?utf-8?B?TnZNTURQOFVBdnowbEJzYVNyQkZWdGJkVFZLRWpGdmk4ZjBkZngwZ0Zkd1oz?=
 =?utf-8?B?T2RzdXlYS0N5UllRUUx6S2NHZ0dZQWlCYlM3TE4reU9NUyt6R1FQb0VtcmQ3?=
 =?utf-8?B?ZjN2VmpEMTR2VUdzRmFKaE5rUHI1NksrQTBjSHBlcTRqOXY2bFo3UWMrZE9N?=
 =?utf-8?B?YlhFUGw0TktMTjJ6YjdnSDROOHdMT2lzWVkvU0FZbzBLTi9GNHZMUUFSbWk0?=
 =?utf-8?B?Nkk1d2VsaUVwVVFHWGhibE16Sk5HUmNXQXdnZ0NVMzlCaGoyL2lPd1JYeXpt?=
 =?utf-8?Q?ZFsI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f7b77a-2a62-44c9-b8e0-08ddf793877b
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 15:45:16.3591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jChrvaMDTuy14Gg4Ee3tDMGwmVm2FRm2aILV7E6cgBejRNbnqsFjdpqVDZXEaBG3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6755

Hi Reinette,

Thanks for the review of the series. Sorry for duplicate messages. 
Setting the email on my new machine.

On 9/18/2025 12:08 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> (Just highlighting some changelog formatting that was needed for ABMC
> changelogs.)
> 
> On 9/2/25 3:41 PM, Babu Moger wrote:
>> Smart Data Cache Injection (SDCI) is a mechanism that enables direct
>> insertion of data from I/O devices into the L3 cache. By directly caching
>> data from I/O devices rather than first storing the I/O data in DRAM,
>> SDCI reduces demands on DRAM bandwidth and reduces latency to the processor
>> consuming the I/O data.
>>
>> The SDCIAE (SDCI Allocation Enforcement) PQE feature allows system software
>> to control the portion of the L3 cache used for SDCI.
>>
>> When enabled, SDCIAE forces all SDCI lines to be placed into the L3 cache
>> partitions identified by the highest-supported L3_MASK_n register, where n
>> is the maximum supported CLOSID.
>>
>> Add CPUID feature bit that can be used to configure SDCIAE.
>>
>> The SDCIAE feature details are documented in APM [1] available from [2].
>> [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
>> Publication # 24593 Revision 3.41 section 19.4.7 L3 Smart Data Cache
>> Injection Allocation Enforcement (SDCIAE)
> 
> Compare with how indentation of ABMC "x86,fs/resctrl: Implement resctrl_arch_config_cntr()
> to assign a counter with ABMC" was changed during merge.
> 
>    [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
>        Publication # 24593 Revision 3.41 section 19.4.7 L3 Smart Data Cache
>        Injection Allocation Enforcement (SDCIAE)
> 
> (also applies to patch #4)

Sure.

> 
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
> 
> Please place "Link:" tag at end to reduce needed adjustments during
> merge.
> 

Yes. Sure.

Kept the Acked-by and Reviewed-by tag as is.

Thanks

Babu


