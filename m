Return-Path: <kvm+bounces-49301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAB9FAD782B
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 18:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAAAE1881363
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 16:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7214C26FD91;
	Thu, 12 Jun 2025 16:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bT5Z2gcK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429DB29AAEF;
	Thu, 12 Jun 2025 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749745468; cv=fail; b=mEy5klWcN1Bv1aSstbbD9bRALhitxehwQrwrmUSeR42mGgxVmUFOguFWzG50D5gOnxAtwOa2BUih6lx8Qyi/dYos3wNE9uyD82+wRB0hQdPNL+Dan7YNpbt4JkzuPHsGEN0/7VRSTFvdE6FnMXnDKb+gYfISQE+S8tnKFxolyLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749745468; c=relaxed/simple;
	bh=xUCTIIxgXDiIYS7vh9yDLPqgPcIB4fPqEiFxEm330z0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tMH53HJX9zWmdrP8QF/cQlR1Oqa+87qWuM5Wzt1MRCvxkwEN5GvaQ3fdxn0YbNK0wbaNGXDHsfkjLt7riWZuom/yZ0E5NYjwjX7sa8T7ywI50c1gde5Tbvj6vVxzHOxzCIsi1IhetAuePgAHEhvUPbYJwWAiUc0brCnWCQlWIDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bT5Z2gcK; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bu4L5Ul4FpBTmnL0qdN+ufuC7XePNe9OwOT7pNNKxr9MJlGt4mlwrRrUEKVSdwyrjOmivRc5A8Pnoc9tEHN/55Sz8dU143j/u8QgizWv1BR76f2ebOuBHiOis/tUtET2rhFz+C8cac7NoKt/44fDe7HbC032aSJkr+c3jQnMPBdLl4h1HLUupLR7sl8nAeWET3PY8oXjvTes15Ws1kBgqkaZ9Y4B+b8lDNtX8xmVnuzh4RuKYSnZ3hkLjwnXWgJAwXkLv3BXEIFL+DhZYk8f0vK8icrHddJ5cw7/Jg1j3ULgGIm7odfP54r+x5KqNoLvuldPtHLWH68AOgGymfIGIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sHBJjw+JkbV7FX0ad+oBVeo/OoWA+gztGh1nPixvfu4=;
 b=Z8W4fHT862PbLRx1TAvmTYUjgfSbCZcDJK5fGPNKue53JX2tALxkG2WLJ2Xw4v5r+ZWsfV1W3JEv8udY2U+VsinRc5HlGdWCQnqtdJh7DobJtOAImASF8TCbVCAESUhvct1FdBYIQkxflxvYUWUhnmiff9wFYKmDu9ckizA7R3FD6uHXVqIZ0Q8cNbikPA1XOp4ygGzYGt8LWkz6MjobHc3upy7CBSpBzetxD6T5qwi9SeUSwHctVnwt85vlBZfdCwa1U/RGgR0nezNsuf5nUYtvEKJsf0gKnRH+HJonGjFLqc7tNxcW+J4LoWII6TzEcRlJkCFNnzNxwLDpcBnIaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHBJjw+JkbV7FX0ad+oBVeo/OoWA+gztGh1nPixvfu4=;
 b=bT5Z2gcKYEhSm2n9mJLO8nsZyLrL6P/QyYK02cf1GKazkjUDBnVvgEjckRc8iJculajSd4ZsQVVlGS/BGN6ceDd+zhBzrRPOrAjVs4Cu3Md3p3/6o+G5gxcJN8t10Enqnk1nXpqra6ZxpcQ6gWxMrY9tqgKhdVVikFwaEfd7rGM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by CH0PR12MB8506.namprd12.prod.outlook.com (2603:10b6:610:18a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Thu, 12 Jun
 2025 16:24:21 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 16:24:21 +0000
Message-ID: <63d8d857-22f0-424d-86a0-c74fd397da76@amd.com>
Date: Thu, 12 Jun 2025 21:54:02 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 17/18] KVM: selftests: Don't use hardcoded page sizes
 in guest_memfd test
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-18-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250611133330.1514028-18-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0059.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::34) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|CH0PR12MB8506:EE_
X-MS-Office365-Filtering-Correlation-Id: f04576a0-8dc6-4fae-3e76-08dda9cd966d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NSs5akVyRDFqaW01ZE9YcWhaeFlNcG4xcU5ISlpWTndKMit6OWt4Qm1JbWhl?=
 =?utf-8?B?R3I4K0VEWHhKTUNhZTltK0hDZDZNWi9Rei9mZC8vOEZkVG9WclJpWFZPQ2N6?=
 =?utf-8?B?NEM2UVhuSEt1eUJIRVpZSjhwTUVJd3NOTythUzd5Ynl5TG5PWVdPVXY2a1Z1?=
 =?utf-8?B?U0VLemcwSW93ZzFaSy8yMlB4dnhwblBFVTZNZ2VodjhuRjN6Zms5TTVQdkRP?=
 =?utf-8?B?dDUzSkdaNml3cUFsRVNLYU5HRkk4NnVhNWVaT3Z3NCs5ZDkvS0cySmgzRTZy?=
 =?utf-8?B?VkREMGI2bTlOenUzb0JacE5zeHVOVWJwNktKODZiQkQ3MXFtR040em84WGFk?=
 =?utf-8?B?TE90UC8zcHphOWdrQkdoUkNZY1R2L3JxaUhIRUpHbS85TTNFVElZN0l5N2tV?=
 =?utf-8?B?Z0xHdXZjalAzMEswYzlwZWRhbk5HeWtNQTdaTjN4N3UxNTh1dCs5MGhoS0tV?=
 =?utf-8?B?cXppcEsxRS9FR3FjNktlMXFIaGtFOUY1c2h6bFNyM3Y5WnFlaDhyczNDWUlG?=
 =?utf-8?B?REM0MFU5Nit0bkZiazl6L29zMURaT1pjZGFBTUMwT1pNWHNicjZ5NE41TVRU?=
 =?utf-8?B?Yi9DUVR6MTExRWFOd0J3cGRzUXROYWJ6RTRFUjNlQngwR0o5MzJhOUVGRmU3?=
 =?utf-8?B?TVFvTUdzYXAvWVZ0TWtEMGFIeEhGYnV3bmRXN0w3MzlxcWt6V2FUZEtqMlJZ?=
 =?utf-8?B?TXdiOVo5WjFMaXQycGVyeUZUV3MyVGF0OVlCdE1KTml3Y3JpNlNCY2Q4TVJo?=
 =?utf-8?B?SUxHWkE3N1kwbzB6SXZ5RXFuWTJPZGJQUzJkNDZCcTcrMTlHWGdKdlgvMi9a?=
 =?utf-8?B?cmRCYWZLdUljTkdvcjhjS0JsR0RWVDlpV1BJSDJZVERoQlhObkNsOHdVRGlH?=
 =?utf-8?B?azNpb3RsZkltRHpJeEZDa2ordW1uRnVlQ2p2cTNpSmJueENvWjFQM2VpVzhm?=
 =?utf-8?B?SEQzRGRMbXZZUHZqRWttejRrUUpqNVF2bDVhY1VDQm1OZDlmTTVSeE92Z2s3?=
 =?utf-8?B?djJQNWNVNnpuOUFWSjBHUXJFRGhEbThOY3BuOUE4NDh6MlVkWGx5WllSU1B5?=
 =?utf-8?B?SjA1OElyYXRaWWI5SEtsejFGZVhKTCt2WUNVOXcyd3FaeFQyanhXaTYyUWpq?=
 =?utf-8?B?bUY3WmZ6MHVST1RtdGRsTmFxU2d5QVNNTFUzamMxa09XOHRKc3R2RXVQSHJK?=
 =?utf-8?B?WStra1lyOEJ6Tm5hZUdHTmNna0JGbFNXTTVlb2ErdU9Ha2taZjcvVk0zL2tk?=
 =?utf-8?B?Wm1HbXE5S3hXY3lIbWMyRGJYY0RyVXNSd1FMZmh2RE1jOTRpNElOQXIvbGpi?=
 =?utf-8?B?NGtPREpjM0xZeXNLSjBuQ3NIU1RSaytlOXVxblJWMk9qSnRHMDk3NEdQL1ll?=
 =?utf-8?B?SDVRL2l2dHQ3VU5wckROMDdCUk83MngybU1SRG5oYlZwSis3dE5nRk5jeGRB?=
 =?utf-8?B?TWNZb3FkanJGa1VRN0lmcFJZQVhOQTFBVVhVREl3L1dkUUQyMmRUYlBGK1I5?=
 =?utf-8?B?Ull0bThsQUtveStWVFlQUVhXaUU2MnlOWnJqc0t0dnJGY3NwMHhMS1g0a1FQ?=
 =?utf-8?B?d05UbU0yVEEwQ0pNaTIxUmR5QTFJOHRpZk90R3cyRTlVczBTUWxlZ3I2Q3o1?=
 =?utf-8?B?RlkydE5FNmZoelBGWWJGQnpobGR1aURGR2JxMnFrc3Q5RHVpV1A5YUdUU2Nu?=
 =?utf-8?B?S29MVFJNTEltM3F4RE02dVRNNzkxOHczU243eGh2SzRpQTNBeEZ6VHpSbTQ1?=
 =?utf-8?B?enVkU3lPaTVVWEhkS0ZDS2VsZ2lVb043bnVrQzVjbm5NY0M3Ukd2SjA5cU04?=
 =?utf-8?B?NVhtVGZoZW53R3JGRnI1NXZlSk0wUVBHYnlsdDUxVlRxcXF0dm9OUW15Wkd6?=
 =?utf-8?B?alFtV0YzTjdjU1J6UHlQK2FTUFh5SlYrSmMvVkZ5bE1hb3BNY1pNTWtUTHZI?=
 =?utf-8?Q?JtbZK56jhdU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEhpMC94NzlLWGxhTzhOTkNkckJYK1FydkVwdDRielpvdTVOT2hUQjZUb1l2?=
 =?utf-8?B?ZGwrc1hVRW14Uk9KYlp0RlF6VGhwOURVYzVEdE9WZnVzVitCa21oS2xYRFVy?=
 =?utf-8?B?QkwrTzlaa0FrUjJrVXJKcWpQNW5GdW82LzJmVzhoTFBpWVpKWC9XRW5iczRH?=
 =?utf-8?B?K3R4QTFaN2tyS1JIU1phc0IxM213MEd5M00zeWZIZU9xYzlmSTcvUk9QSWJr?=
 =?utf-8?B?YUFwN000TmlpWFFtc29RS2ZLVW9EMTFVMkQwNDJNUFg3UnNmQktwc1pFZmVq?=
 =?utf-8?B?TWRnZEE5NEtjbnpNS2NRejdDdk5QMElWeDhYeU51elYzTGxqem9wbTBUMXBU?=
 =?utf-8?B?djRnM2h2c2ZCbjQ2VkRGdXFBQ0IySDg4ajRWNzh3WUxnbEdUZ3pldVg4OWxC?=
 =?utf-8?B?VllTNVlHL3J3djgydHFxeWJQZVd1bE9FQW8xWXN3L01LR2E0WTFPWkF4UUNP?=
 =?utf-8?B?QlFnN2hNZEovZVRrV0t4a010aVJGR093b0pXRlRXSVNWODVmV3JkcGhzRXdD?=
 =?utf-8?B?ZmxTOFNpbkp3SXA2RmxEc25oT01LMWRLZjM3dTNoOWcxQy90UUhRRlNKSlg2?=
 =?utf-8?B?T3U4Z0FvTzJiWG9vK2k1Yzd5cFIwdnQzaVFreWFIMGtmTHRCcm9GbXZQRk1r?=
 =?utf-8?B?bzdRMWV1T04zZjYwdy9qZTJWSmdMYTM4MVExS0NZbjkwU0Jta2NNTDllTVBx?=
 =?utf-8?B?WUltZk9xVFRaZXFaRDZrSkVGM20zRVBnNEJoL090ZUlmL2paQWJTd0pBYzI5?=
 =?utf-8?B?VEFNb2YyQlRXZHZZYTYyM1d4d05JMFpPdE5MRi92ZjhZazFCYTF4dGVRMFpw?=
 =?utf-8?B?U2kyZnVpcnZvNXBmUTBKUUlHU2R2eW5qc08vcVRkRC90alBGa1pOMm9CU25y?=
 =?utf-8?B?NmJhMXNLcmd2TU9FOHZod3ZmV1dzam4xb2NBSkJLRGF6QXZSUTVWeXVrSDJ3?=
 =?utf-8?B?c0JySXo1Q3dsVXZDQkwyWDJuenFTY0M4S3pxWHI5NUtsRTJydmlmdVRrRlhL?=
 =?utf-8?B?amhwTlpBWDZnbzhaaXZpVGlxVWN1YWFIdUJaUnJsU1FBN29UbW90UStHSTRB?=
 =?utf-8?B?a0xva2o0YjFTSC9CRXZ1T1hKdDIvRG1tUWdpTzNtbkVlS0NYZzFJcEdYbHFG?=
 =?utf-8?B?anh1MWRwUzlLOHpxWE9aVmlKN0hGczd3blFvalFSSGVlWkJidnc0d2VpUEJG?=
 =?utf-8?B?dVhETXBiZC82cHRPZjY3Y2g4dTA5azdsVjluMFVoSWF2WWlrc3R6M0dLbDFu?=
 =?utf-8?B?SkF1OUxDQXFORFhlR3IwcFNhckJnMDNXcERYRDVOdDZRbTcrNHJSekdlOWlB?=
 =?utf-8?B?bjJYMW9qdGRhbHR5K3V6MnM1Ukp2ZzlYMFZZaTJCZWYzcmp1V1BNQndiL05n?=
 =?utf-8?B?VGNvaGpVM0lYVGF6RVJDOWpEMCtBT1BBSElVaE1CaWhkT0s2Ymx2Z0JiUmZF?=
 =?utf-8?B?NktvTFNQZ25NQW5mK2tQOC9vNlRFS1V2R3Y1UDFsTUh1OUI1QXF5emF2R0hK?=
 =?utf-8?B?VGtYUzJNZjIxQmFqa1hERkZSSzB1Mlk0d2RZTEt1emdWQjF6Y0RJc1BhVVhk?=
 =?utf-8?B?Zmp2allURGV6aDNaK1dLbmtqRldIQzFjdU05UWpKUVRKRUI2b0tNcWhzRURr?=
 =?utf-8?B?bmlYUEtIcXdobjJienFnRkJ1Rm5DZGorL0hHWEQzLzM0V003OGtpaHpucmtD?=
 =?utf-8?B?bnI1aUhvQmtqbEFYMVRaNmdpWEwvZVQ2aHcwc0s1YkdyNFY0NXZuTzJzTHRo?=
 =?utf-8?B?OEFYeExaMXE4WmprbllXYlFDYjRGazNYcWlqR1dvSEpTRlY5bzZWd1pQa2Z6?=
 =?utf-8?B?endLSHhicThDUFVCZGFHMWJHWnFTYXRvMmZSeTBGRjRrdytyU2xiRHlTeVBq?=
 =?utf-8?B?ZGVtWS9HUnhFN0ZLZ0lRMnpnSGQ4Q2JxVXJNcUYzdmRRMmczOHBsNWwwd2ls?=
 =?utf-8?B?N3lwTWZiNVoxbDR0LzhpK3YwRGhRdllGL2dwZjU0cVZZdmFIdWYxempJQnI5?=
 =?utf-8?B?amhabm1EZXFYYkpOSDVwOWd5eUNPYjFNOHNuSlZ6V05uUHNnd1E1VjFNR2h2?=
 =?utf-8?B?R1dHalFIbW8rbVllNXJkU3pURU1uMG92Mld1clRYVWZPeXhaOG5UY25OWEpj?=
 =?utf-8?Q?vQ5F5MuepapPliDxA42p8Lgrq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f04576a0-8dc6-4fae-3e76-08dda9cd966d
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 16:24:21.7199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Acd/IvqdP5tiiPQPgNt9VGsHqkNkHSSFfUjZfi2FcN8HPLL3IdLZzx3fX9EcegGVAd7qoIuk4AlhraeCx50OYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8506



On 6/11/2025 7:03 PM, Fuad Tabba wrote:
> Using hardcoded page size values could cause the test to fail on systems
> that have larger pages, e.g., arm64 with 64kB pages. Use getpagesize()
> instead.
> 
> Also, build the guest_memfd selftest for arm64.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm       |  1 +
>  tools/testing/selftests/kvm/guest_memfd_test.c | 11 ++++++-----
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 38b95998e1e6..e11ed9e59ab5 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -172,6 +172,7 @@ TEST_GEN_PROGS_arm64 += arch_timer
>  TEST_GEN_PROGS_arm64 += coalesced_io_test
>  TEST_GEN_PROGS_arm64 += dirty_log_perf_test
>  TEST_GEN_PROGS_arm64 += get-reg-list
> +TEST_GEN_PROGS_arm64 += guest_memfd_test
>  TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
>  TEST_GEN_PROGS_arm64 += memslot_perf_test
>  TEST_GEN_PROGS_arm64 += mmu_stress_test
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index ce687f8d248f..341ba616cf55 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -146,24 +146,25 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>  {
>  	int fd1, fd2, ret;
>  	struct stat st1, st2;
> +	size_t page_size = getpagesize();
>  
> -	fd1 = __vm_create_guest_memfd(vm, 4096, 0);
> +	fd1 = __vm_create_guest_memfd(vm, page_size, 0);
>  	TEST_ASSERT(fd1 != -1, "memfd creation should succeed");
>  
>  	ret = fstat(fd1, &st1);
>  	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
> -	TEST_ASSERT(st1.st_size == 4096, "memfd st_size should match requested size");
> +	TEST_ASSERT(st1.st_size == page_size, "memfd st_size should match requested size");
>  
> -	fd2 = __vm_create_guest_memfd(vm, 8192, 0);
> +	fd2 = __vm_create_guest_memfd(vm, page_size * 2, 0);
>  	TEST_ASSERT(fd2 != -1, "memfd creation should succeed");
>  
>  	ret = fstat(fd2, &st2);
>  	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
> -	TEST_ASSERT(st2.st_size == 8192, "second memfd st_size should match requested size");
> +	TEST_ASSERT(st2.st_size == page_size * 2, "second memfd st_size should match requested size");
>  
>  	ret = fstat(fd1, &st1);
>  	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
> -	TEST_ASSERT(st1.st_size == 4096, "first memfd st_size should still match requested size");
> +	TEST_ASSERT(st1.st_size == page_size, "first memfd st_size should still match requested size");
>  	TEST_ASSERT(st1.st_ino != st2.st_ino, "different memfd should have different inode numbers");
>  
>  	close(fd2);

Reviewed-by: Shivank Garg <shivankg@amd.com>


