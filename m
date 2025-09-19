Return-Path: <kvm+bounces-58173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FEFB8AD1D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:51:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D72E6589084
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 17:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E823233FD;
	Fri, 19 Sep 2025 17:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="syfxA6a8"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013010.outbound.protection.outlook.com [40.107.201.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64F2322C85;
	Fri, 19 Sep 2025 17:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758304186; cv=fail; b=YJiDv9J6jcSZyX+FN4wlyWopkAwqjkSZ+Xyij55QHBt58Ml+4Tsp7IfVwa9VCb/LsQyOxhdznSZllvAlrADRNlOw3MmOfJsRcAs9tk6mAxzCcEh+CAtygxqciPIAFOo8prrj1gi06rgVUIp1CrVRh2i+aucquhFkSKa31Oors+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758304186; c=relaxed/simple;
	bh=/lOVLda1Fv6ajdgzjbht8fw1TsTKyy6Ylv/sNHkozwA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jzUTTRfcbcTUGJFfO3QY6vpQMNLxI08yynRZ7WFHDwIrnWG3KlPqNeFv7T7j4zNDgmCYq/v+iK+xNnevz79yocZYeiHw4PumdYVPwxfhHl469Bz+BqbQazPE9AiQFHxuUjHQCmolx85aFfAbOcPzl46IAawYELT9/6RSz3TGqVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=syfxA6a8; arc=fail smtp.client-ip=40.107.201.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dbVUrPCEK1Oa5Am1V+ogLiNrRbf0Hww9tHC5UNzDFOSz6P5QDNkxZ/LgVLOy3p26S8+aAW1eLlo1Whm0bVBF9qCW5Kl0DgdiO5/fjgyydd2C1hm03v/1ZkZT6j/CI1oZprG+DIIXncsEjezG/1jbmF4LInLS/OtLfOQmDHcIMJSU5BP+BY3YBwVhh0aEzHNnV11zns3obLKXTsIWKWx/SuYjmaUDAO70s4eKdgmxKu6bq8/oWMc7OQzf9dCmBmpY0wJhZkdDP4D+fYfX91NpycgXK01tEv03sz0Q8vOayLTv2UDuQ5PInrI+ICQmb+89BGVP+IY4b3c3CF7JZOmR/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tUJ7ZrVnVCvCSdaFa190kRY9yu1xGdpVMGKgoHIryno=;
 b=IQC8newwO7fkkaNPGPSEjErIXQ+S7afPfwI6vSOzrsv35V26uVoDRn1hWx6l+c5m6V4yc8g8TDPgXq2KLuswjASa0j2bECf4yMtGS3Ddh0Y63bc1R6QPlrBsutw63J4jcKZIPhYvrL+GuoIo49KNVoAbW89f+zHzEujSic+fE6dL4vcDlCrqU4RYu6YYCA0FSv/Q4gIftlyJIabKWgXLEbJzcq/ZkqlkxCOccWl+3Xvak6Wzhhv5S0nBWAPx/SGy/sJ2PHbsTHAnmL0Q8ajDpWVOLoR6XvHAqK2RlwD6rsyeakaD/vmlbHdElgmsrxbBB7fF6s1a/1kyv1bw81OtnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUJ7ZrVnVCvCSdaFa190kRY9yu1xGdpVMGKgoHIryno=;
 b=syfxA6a8iiDvi/MNczh5Xgxrfv/quEdX6KrH7R+QNTOmMcbbiZ90J7zzSlQWHFX8pHq4hLdAJeKbb1HdEnB31HqXNJUPSq2/DvVcGnR4KuSpAnnQA91hZbxEQb0ZMSJ52sn88EHfmXLllo6j6znvmSWekrmi/2vzvyoX0Fhkrt4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by SJ2PR12MB8157.namprd12.prod.outlook.com
 (2603:10b6:a03:4fa::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Fri, 19 Sep
 2025 17:49:40 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 17:49:40 +0000
Message-ID: <c6102b72-3458-41c6-8650-7e70b175cc2a@amd.com>
Date: Fri, 19 Sep 2025 12:49:33 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/10] fs/resctrl: Introduce interface to display
 "io_alloc" support
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
 <5f368e4f65629c5bf377466e9004733b625c5807.1756851697.git.babu.moger@amd.com>
 <7b1452b2-38d7-49e1-bd34-ea61eca01419@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <7b1452b2-38d7-49e1-bd34-ea61eca01419@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0005.namprd08.prod.outlook.com
 (2603:10b6:5:80::18) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|SJ2PR12MB8157:EE_
X-MS-Office365-Filtering-Correlation-Id: 2396184c-dc04-4dfe-b32e-08ddf7a4e821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q256eFhWSjlUM0phSWIyR1FJOTZVYW5ES1J4ZzF0alVEK1haOVpuWlhSR1I0?=
 =?utf-8?B?MGVqWVZBVnpud2NPNFRJYW1PU2hNSUlHN2J2VUdKdGJlM1FjK2Qxbm9iL2lW?=
 =?utf-8?B?T0FLd0hEQ0ZqcHFRSldPclRna1VjeDdLd0V3TmhqZWdKUEdoU0JsR3NWVW0w?=
 =?utf-8?B?U2pDaHhLZStnTWlNRW4xNW44V2pPTm05SmVEOTF3N1gwOWo3aWdCVlIyZkRz?=
 =?utf-8?B?YUFTUzU0R0NkTy8zTmt5RnpVK1NPa0hQbkIzanlLN2xQOENwUUl1dGp6TnJi?=
 =?utf-8?B?Tk5aUzV3bUdaNU43Y1hKbmdldUdUcy9HSmZxWjhZRWU1MVYrNGhUN1NGbjZx?=
 =?utf-8?B?WXlNcThiN3RoaklhQjlENlVzNmFaNmI2ZnVyOHJXMHVyN1VOQXZFU1dYTjFO?=
 =?utf-8?B?LzdrR3pNMzNQTXJHUzYzZC9obTdpMG9aUnFDaWZLQ2laNHQ3YkQ0TWx5TkVE?=
 =?utf-8?B?cXhveFRnNjU4eEx3NGhwV1kxeG1TYzFLNTAyWUFzQkFydTJMZ0FjRjRFbGpC?=
 =?utf-8?B?TExHc3ZyZG94bFNLeFBENkRnbm1nUGUrV2JvSHQ0RW8yRm5MMW52c09SRUZB?=
 =?utf-8?B?VUVkTzlXVThXblY2ZHkvekowRlJjeWhuQnZUWmJrVGNyaXNGb2hmdDVEWXJU?=
 =?utf-8?B?OVc4ckpwR3lwL21YamVBUjZ1UmlVNFJMZXltM28ya0t2ZnR1bkw2bVBxbGNn?=
 =?utf-8?B?dUJJRVJPNlUraE4zdFBvVndwclhkMGVudWMvaklsakV0dzZqTWtOVVFDc2VZ?=
 =?utf-8?B?Z25tbGh1UUliV05Mc0YwNHZPMVVNOGpTYTJlazFOeWhCRnV1aTlESHhTVklh?=
 =?utf-8?B?YWhvcXJHenNmbllyK29iZmppUFh2NVNXSzE5ekRJb1VGUFcvTVJKV29KcmtS?=
 =?utf-8?B?ckw1MGdraUF3RVlHcnZWMUlTdHc5aDRIYStJcHloUUY5Mld1bEJtbjlLdUQ5?=
 =?utf-8?B?ajNDdkU2SWdLai9sQ3BxaEhxU25BVzR6c2o4K05IbGdlZW04eGhGRFh3ZCsx?=
 =?utf-8?B?U3N3djFSMmUzaWxNakFMSTllYVZTVjFXdGQrWG5UMGZtVlBrV0REWHhIVGhW?=
 =?utf-8?B?Q2VHK3ZIeG0xUndiK3lPRGV2N1Qva3FTUGxVYzlOOGVTU3dVRmlXUFRkKzV2?=
 =?utf-8?B?NWdFcitFelpQeE1yTk9aaGJlNHZHbHdoVlQyUzJEeWE4TWMwaTBVOU9KSFhr?=
 =?utf-8?B?cnB6RHhvcUlxRkJxazExWCtEOExKL3QwLzMvSWI4b1lMSGdyQmZTbDhDcXNX?=
 =?utf-8?B?dVowVHZQbitRNE04RzhXcldORlYzcDZmK3poQ3Bwbk1UajFLQnd3a1dncmJC?=
 =?utf-8?B?Q0dDUGJCMWxwakVrbHNnVUFSVjhKTXlZVGlxclRqSkNjQUYydVZGTXhaaFE2?=
 =?utf-8?B?Wmd3UzFtVmV5YUVqVVc4MDg3Z1RVbnFPZytHTWw1clJoaHg4RTd1UUNjQWJE?=
 =?utf-8?B?MWdXdktUemRrNE0wUVFjMU9IZEdUeDgwTGlKS0N0Q0l1aGRnK3NvS29QMSth?=
 =?utf-8?B?dmhsd3JBNlpZQ1doUXgraUZnbGcwMWVBbnVDWHN5bkVDcVZMS3BVTWRrc3Nm?=
 =?utf-8?B?bENVMnhud0gwQ0RUMWRoQzRjY0JQN2Jid1lRWGdsQVUzVU5wMThab2YyMjZy?=
 =?utf-8?B?VUlmZUN1d2Ztb05TM0NMdG9qcVpRR0tnck9pUDI5U0pFNlNHdWRwZEsrRzFJ?=
 =?utf-8?B?Qng1bmdxOXdPRTlXeXQ4cHE1TWd6VG5iRnU0cERtalZOaDNYUm9HdjBoSytp?=
 =?utf-8?B?dkMzSTNzOUZYZTB2ZS9HVy9iSFpMMGszanlTRGF6TlhnbE4yS3lOeUlqRDhk?=
 =?utf-8?B?MFdBVlN5S1pId3M1Z01hMkxUK1MrVExkYlBaZGRCUGovUTFKYVM5UXZ0UnE2?=
 =?utf-8?B?YStwdk5CeXlzOVlXYVRidzBZRGlHT3FtckxEbVlXT3JkYXpLZjB6cEhnWU5n?=
 =?utf-8?B?VlNnUDdZaUpGVzl2RWowQ0QvalEwVENyU1dLcHl0cVVDQXpGY1pMNWpRV2wx?=
 =?utf-8?B?VFo2U092cnR3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnZwWkpVK2V5eDVMM0R1dU95czVkWTZQcGJ2TklLVTRuaFRFKzR0U1NOZ1Va?=
 =?utf-8?B?S1BLWkQ1dDFmaHExZFdwNGxuWi85V240cFhlbHhheUFWZ1YvM3F4UGVDczhG?=
 =?utf-8?B?K1Q5b3FjUk9wdnFYZWEvY0hKZkdpT2krNTd3Zzl5cWNPTnc3YXFnMktwZGc0?=
 =?utf-8?B?S3F0UXNjOGhNTXZnL0E0REJobHRKejhMQWpvZkdDcG5lVkZHSXlrRGt2bGlB?=
 =?utf-8?B?UEZVTTJ6SGRWTUNpbmVLNTBIa3VnQTZqQUQ2dHViekhJZk5hY2lQd0ZqSXZm?=
 =?utf-8?B?bWdJU3lENGdWSnN5TGFiQmtEVlpncWZaWlBuU2d2SDR2UjlyemFyc3pvRWE5?=
 =?utf-8?B?cE01eEc3MUR1OXNJUmtvYkpMMXhLMDRyNkJ5a1Ezdi9TdEtEUEVIOHY0U2Nz?=
 =?utf-8?B?OEZrZEs1ZzJKOEE4UlhHL1E3VE5LYXI0UnZCUmhEZE1lVjJ1Snc4cW1vbTlt?=
 =?utf-8?B?UmliVlNmU2JyZ0dKZWN6VXU0TFlHaGx5Z3RnYVhDaWUvQUFtN2xkZFN2b2J2?=
 =?utf-8?B?cU5RczlIc2RqVkYwWFRKVkxXSndLV3lGQmU1NlRLdS9kMSt4WTMyK2hJL0NH?=
 =?utf-8?B?cUR1b3BzejBjZDNQSGRjU1VjcFFFVXdDdWsva0gxcTBjTHNEN3B0bWl3aDIy?=
 =?utf-8?B?U2RHUU9iNThRSFFkNDEzV0pQSTBVdC8vbmFCQmFNM1dqUVU4MXNnNG0rVmIv?=
 =?utf-8?B?dE1YYXNUbEJabldtWlJ3dk9JdXpLVkEwOU43RkRZMnBFTWVkZ2t6cVhqVW5Y?=
 =?utf-8?B?aDl0bU4rMFpCRU10Y3Y5Q05xanRGNEFoVWJMUzZSQkNZMTlWTXpBQmt0V1ZK?=
 =?utf-8?B?UHJvdGdBYVZWMnJzVFRxcWhURCsxUTJQK3d6VVJDb0xTSC9DMzlVVnp2WDJP?=
 =?utf-8?B?VUpoYnMxTEI4VHdrODJvUTNKb0ZXSFJ3WHhxYTg0dHo0dVBBQkFPN3NyaWlP?=
 =?utf-8?B?MVZKeFI3UUJzck51ZmZGTVdWWjdUdTJtWHZjNGErdDF6dnE4YmdVcUZpejg3?=
 =?utf-8?B?YWpPNUNuMyttMDJJNEduNWJ5OW0rMlprRjF0OFFZa01NLzdNZzlIaTRpdXRM?=
 =?utf-8?B?WGpTQ3dwZWJkcU1BSlA5RGJ1andQMjh6ci9nUFdWN1NiZTlVMHNQbjljV0pi?=
 =?utf-8?B?bnpEL2ZPNnF0Tm53L3JCcW9NUWN0eXgwRXhNWkU1dWFUc0pVZk9qVXpmeUpY?=
 =?utf-8?B?bm5DaXRuNlNWQUZNbHJ5YTRNaFdjRFdOa0V3aUtGZndlS2xBTE5lMlNyUlFL?=
 =?utf-8?B?c05Nd250ODVicnhVMlcyak5CdXZocVJyYWRwZU5nMFczUUNUckVYU0FNWDl2?=
 =?utf-8?B?ZUw0cGo0bEZGdFZuMk1WbFoxMVovMUR1dUdTazZNNEFpa1dSTVBDejAvWmhm?=
 =?utf-8?B?V1YwZDZrZURnNE9Ua1VTM2tjanVjSWMzS3ZQQzFEWkgwR2tVSFBGWkg4NXFH?=
 =?utf-8?B?OHl3MHV3NDNHaExFaFo0WDFjMmlMcGpNeW9jZWE3S2xpaUxCR21hUDVwRTF2?=
 =?utf-8?B?eXg3SXhYZWN1TUVvbDRjdnBKd2tUdURZbnJ6U1RrZnlEQU1KeVFYWnBYeGo3?=
 =?utf-8?B?WVY0RHk0OHdkRmFDTkE4QU1DeE42Z2xkcGZCZ2hRbXZaeVh3dVFrWjZIWlVZ?=
 =?utf-8?B?NnpuZHU5UHZKTXR0MTgxb2xjRHJ5NlY5NWJkLzJVdjJGVnBld2FnaXdwOUFO?=
 =?utf-8?B?THIyaDRUaVpsdnVrdmRCbUZ3ZXNCYlR2bXJ4R0tnOUJPRUZmRUFaMk9lbEk0?=
 =?utf-8?B?WEIvaDJGNE5mMWRyWlRva1daNHFHUklWTTluYmEyMG5NZzY2ZjlWWmtObUhJ?=
 =?utf-8?B?Q0N4STJBT29OZ2llSWoybW00YlpJS081NkpMakkxUEpPenZTaWhtOHlwdUxR?=
 =?utf-8?B?MHBnenB1bzB1Y3lDZzYxVVE1akNIYXliWVV1MUJLU25nZGU2UmZHSkZyT1Jx?=
 =?utf-8?B?b3hqVEw2WGprODV0T3RwaEVlaTdhS0M5M1JIdFNvaEhiSmtoZ3A3bFpGOWdv?=
 =?utf-8?B?Q0tCOS9ZalhwakJzVlM0bEpPMWlFR0dUUjNuUUF0RlFqYXhEUVN2NXFlUjdH?=
 =?utf-8?B?S3ZSemkvWHl4Vm93cVpnWFRWSERvc3MvbDZJRndiUG1hZVdnZ3RKRU5pdDRS?=
 =?utf-8?Q?6xyQ=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2396184c-dc04-4dfe-b32e-08ddf7a4e821
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 17:49:39.9657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nU+xuxeh5jZUiZ8HtexFsEQYbMfqJDWl7qQccNNPaDMY0Dq3xIdxxUhY+2Rlb+tl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8157

Hi Reinette,

On 9/18/2025 12:28 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 9/2/25 3:41 PM, Babu Moger wrote:
>> "io_alloc" feature in resctrl allows direct insertion of data from I/O
>> devices into the cache.
>>
>> Introduce the 'io_alloc' resctrl file to indicate the support for the
>> feature.
> 
> Changelog that aims to address feeback received in ABMC series (avoid repetition
> and document any non-obvious things), please feel free to improve:
> 
> 	Introduce the "io_alloc" resctrl file to the "info" area of a cache
> 	resource, for example /sys/fs/resctrl/info/L3/io_alloc. "io_alloc"
> 	indicates support for the "io_alloc" feature that allows direct
> 	insertion of data from I/O devices into the cache.
>                                                                                  
> 	Restrict exposing support for "io_alloc" to the L3 resource that is the
> 	only resource where this feature can be backed by AMD's L3 Smart Data Cache
> 	Injection Allocation Enforcement (SDCIAE). With that, the "io_alloc" file is only
> 	visible to user space if the L3 resource supports "io_alloc". Doing
> 	so makes the file visible for all cache resources though, for example also L2
> 	cache (if it supports cache allocation). As a consequence, add capability for
> 	file to report expected "enabled" and "disabled", as well as "not supported".
> 
> 

Looks good. Thanks

>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
> 
> ...
> 
>> ---
>>   Documentation/filesystems/resctrl.rst | 30 +++++++++++++++++++++++++++
>>   fs/resctrl/ctrlmondata.c              | 21 +++++++++++++++++++
>>   fs/resctrl/internal.h                 |  5 +++++
>>   fs/resctrl/rdtgroup.c                 | 24 ++++++++++++++++++++-
>>   4 files changed, 79 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
>> index 4866a8a4189f..89aab17b00cb 100644
>> --- a/Documentation/filesystems/resctrl.rst
>> +++ b/Documentation/filesystems/resctrl.rst
>> @@ -136,6 +136,36 @@ related to allocation:
>>   			"1":
>>   			      Non-contiguous 1s value in CBM is supported.
>>   
>> +"io_alloc":
>> +		"io_alloc" enables system software to configure the portion of
>> +		the cache allocated for I/O traffic. File may only exist if the
>> +		system supports this feature on some of its cache resources.
>> +
>> +			"disabled":
>> +			      Resource supports "io_alloc" but the feature is disabled.
>> +			      Portions of cache used for allocation of I/O traffic cannot
>> +			      be configured.
>> +			"enabled":
>> +			      Portions of cache used for allocation of I/O traffic
>> +			      can be configured using "io_alloc_cbm".
>> +			"not supported":
>> +			      Support not available for this resource.
>> +
> 
> After trying to rework the changelogs I believe the portion of doc below is better suited for
> the next patch that adds support for enable/disable where CLOSIDs are relevant.

Sure.

Thanks
Babu
> 
>> +		The underlying implementation may reduce resources available to
>> +		general (CPU) cache allocation. See architecture specific notes
>> +		below. Depending on usage requirements the feature can be enabled
>> +		or disabled.
>> +
>> +		On AMD systems, io_alloc feature is supported by the L3 Smart
>> +		Data Cache Injection Allocation Enforcement (SDCIAE). The CLOSID for
>> +		io_alloc is the highest CLOSID supported by the resource. When
>> +		io_alloc is enabled, the highest CLOSID is dedicated to io_alloc and
>> +		no longer available for general (CPU) cache allocation. When CDP is
>> +		enabled, io_alloc routes I/O traffic using the highest CLOSID allocated
>> +		for the instruction cache (L3CODE), making this CLOSID no longer
>> +		available for general (CPU) cache allocation for both the L3CODE and
>> +		L3DATA resources.
>> +
>>   Memory bandwidth(MB) subdirectory contains the following files
>>   with respect to allocation:
>>   
> 
> Reinette
> 
> 


