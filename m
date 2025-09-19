Return-Path: <kvm+bounces-58204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86D5FB8B638
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:45:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DA4716D10D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2852D3731;
	Fri, 19 Sep 2025 21:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UyqTX2pf"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011071.outbound.protection.outlook.com [40.107.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B267209F43
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758318348; cv=fail; b=H1UcPe3QZBQDJAGZ4N5yJBSmeLivI6ayFx/46J7jBg+i1mtTOazON7gSQjNZqBBVsm9hgU1vQ9zn4umq55hS0DCQJMNGXSSy4rkEQSJwsxQHf6qy/nR9vZVu1K+1cfTQg8LL5fTFwS2ri1rR9Mp9TBVI7Xiivgc8CBw2vCu1jiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758318348; c=relaxed/simple;
	bh=c+FOQ50wEfPl7rKziQbEc2gFPyVLjZ2OrLrZUJ0T8cw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sVO3cwdbbvXSTHQQn+vbQIg258oQmPrVHNqPU9PA5LlDtcXstSBD7hm96Zd66W9Pzfw7avqfTAnxoG1JIbx4CNody4nDjBcPTRkK/7hVHGLbTeruxCY1ncbk0KnLTf/ZZZIZSSwylCI1M0ts05EP9GMaAT9NJu7W1mcxDxYBnso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UyqTX2pf; arc=fail smtp.client-ip=40.107.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y7BHgbIpfLPiZ1TMf5y14/KGslnlJZE/46ob9tyXNgNC4cxSCTF+r2lDPczLfxYWpfV3mNsyaiKd4ZIHGfGINzcbgHy8Ovc+BOur9xBIkZ8j48dV9kYDBTeOtYhby4FB/An1+s/XzI1sOlQMDrKgtqhDCwoOO5HMhQ21QR9W9CKYA/yaTN1j/P8TNrbc90E+HPQYHHxPsMt+245ezt6tyLt8tPTMng5a3BNya+Rno95OUlKlr70uAW7KAqiFg47f7TwXncfqb7L/zRiGepetAvo17nGN5gKRFu2JtTxhJjqeJMsSO2RoV8xREzc59qNTte1bkycNjD8KjOrhXfDinA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+x9YZi2FoQmLLjxS880EAJHXbVSWt4BsB5doyg8eb4U=;
 b=RT3HPcNwZtyhvI7b7vJFrfnfMjmGxqIbD6tGSP8A42nSL8NH/vuq3kcvS6hh6RAB1cAuIFvi2pI3zrg7/1ji8QLFgVOJ8nUPOcn1oDkrL7JvGdRUUzqcGpt64bZSjJofi+3NxOPIILgipwkzfms9zhq7c1YbOQHOreTsmrNQ8i378WCz85e5Ws17AD0TYvnNHVOySFYj2w13ybjRtcESH2yWzVfMILTD0dicEbGq0PQzr64YaTiOQvF6e0sQUst1yy8d9YX1Vez57JmzltYXnhQC49lqZXLyJfl/dmkbWahrobTt5va8o1dPRp2VT7cc+QZLgQ/U1PuhiLYpC+7AFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+x9YZi2FoQmLLjxS880EAJHXbVSWt4BsB5doyg8eb4U=;
 b=UyqTX2pf8JFU/bJ7IPGWhTsm3rHC8n8A94bnzyDJaZPpZmXAJhx++EUMZeXAofIOVPiDhhnqiYkqy/8gfxDgw/QtytyWNXaqbeYDmvdfPVJSvQXbZC1G4eYsH/GYHqlE0IkdmBjzwVVA7zWU0JDER7sK4KvbmX1vMk7FnzPiju4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW4PR12MB6899.namprd12.prod.outlook.com (2603:10b6:303:208::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 21:45:44 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 21:45:44 +0000
Message-ID: <0e535976-7156-4fd8-9d03-cbae41c1d7cd@amd.com>
Date: Fri, 19 Sep 2025 16:45:42 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] target/i386: SEV: Add support for enabling Secure TSC
 SEV feature
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 Nikunj A Dadhania <nikunj@amd.com>, "Daniel P. Berrange"
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1758189463.git.naveen@kernel.org>
 <9ef2a9ef63f4737efe7a926703222b6bf51b7bad.1758189463.git.naveen@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <9ef2a9ef63f4737efe7a926703222b6bf51b7bad.1758189463.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:806:a7::18) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW4PR12MB6899:EE_
X-MS-Office365-Filtering-Correlation-Id: 714897c4-68fc-4849-d3d6-08ddf7c5e2b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0Y0MWxNL0lMblRNcFNKVTRwamsvQS9PRU5xa2pnaTV5TGJva0ZpZkxHUDN6?=
 =?utf-8?B?NjR2Ry9kNFhRSDFNYk1SZGZBMTB2WW11dlArVWZ0aW5uOGRKRUdNeU10U1lG?=
 =?utf-8?B?ckl0OWZCQkZESzVqL2hFaDVPbnowUk9NZFEvSFY5aUtuZlhLMFc5dU56NzNC?=
 =?utf-8?B?SVBBQjhzYnRvVG43QTZsaFJtK1JkUWtvamlCeXowVGsvMGswcENlVHlnelJN?=
 =?utf-8?B?OTcvUDVFODFLTUVFaWNyQldMYXl2SkhTYk5SMFl0U0tkQW5zV2ZRVUNrR3RB?=
 =?utf-8?B?UVV5RGoyMVAyRlE5TXRMaTJadmxYM2EyWTdqdGYrUGhYb21XbXFNZVZONXM3?=
 =?utf-8?B?bTJjck1Qd1hnY2szdHNTZ2NjTWVRWERVVUJ1aERzdU00NjRrNlVEQ1d0eTUw?=
 =?utf-8?B?NXQ1ZWN5RjNNbGxoRFJSMG1peEJiMDNlWWdLc3NzdXpka01OVmFTT3l2d0FJ?=
 =?utf-8?B?YkZ1SWhzTCt3SnJHKzZpZlZudlJCOTV2dW1IWk9JeSttV2dHM2YycUhlb1o0?=
 =?utf-8?B?VGVTaHRVUHFuemQ2akIvSldBT1Q2dDRSK3VERmtZN0lNbzlZcWNIcjIrVVZi?=
 =?utf-8?B?K3F1YTRUZjkwanZTWHMwZ0RyZW9HeEloYjIwRmIra09hMTE1VGJ1UDdFM21C?=
 =?utf-8?B?bW9LcWo0bVliTjAzL0tEZlpsWVQ5OFVaWDM0M0x0UDBYbGYvUDNCZGMwT1ps?=
 =?utf-8?B?bm1SYytTSmJEUzhBU2RVYjJ4d25aSmdrQk1hclFrZWRrTE1TLzBaeE9LWlk3?=
 =?utf-8?B?cysyZmduWmZhQVFLS1BiN2wyOVB0bE1HTlZ4V3czUzc2cG5rbS9IQlY5VnIr?=
 =?utf-8?B?cjdUUUhFMklFMzNaWkFQdTJpRmp4RVE0ZmE5VVVNWm5NM3JwMHZMZGJxNE9w?=
 =?utf-8?B?NUs0dnJLdmFXOTVWZUxBbDJiby9YNUFMZXVBYU5icEFwVElINjVMWDBxdm55?=
 =?utf-8?B?VGdSdzhHUkhlV2JQNTlQNCtuNDlqSmR1Sytjd3BlSzZDNVhrQmpyVFNEODlz?=
 =?utf-8?B?VTNxK2k3Ui9TL0NGNjFvTFZST0xSZ0VodUNseDlaNFVycTAvNERvaW9acEhs?=
 =?utf-8?B?b1VJRHVnWk8zdWlyK1gwYmFyTHZGczdNSG9RdkpuMTlSZGp4a2NIUlpKMlFy?=
 =?utf-8?B?UmtVeFFidWpzSyszWmFMN1JNMVpEcE9pSWxtRHRFVnMrT2VhTjZpaXVOc0dH?=
 =?utf-8?B?cEdJbHZyeno1TzFlckNNemZaTUdneXdZOTc4NkthVktBWkFpaWtYSlExQnhI?=
 =?utf-8?B?dTRQWkF4UTlYSVo2WE1kNHdNOGxLek1mZXVDMzdqRkI5cjdvUmZ0OG80VHQw?=
 =?utf-8?B?VU4rc0w4V2o5MzBKTUo5Rm5NbjEyZzJlalFLTzRPODBIcUs4eDhEQ0lJdW1m?=
 =?utf-8?B?dHBoWkk4cU5PL3lRUXYrMDJFbVM0K0FkZFQyam14QVNjWjNHRTI1bVBMZW5G?=
 =?utf-8?B?cGxmaW9iZkdmOFIyWEo5bllOWnBVd3Y2d0hFbjNQNmtaNUJvc0UrTy8yTFlS?=
 =?utf-8?B?SHNjanFyNUcvZTNMN2NNclRpMCtIV1loQ1EyQUxmNGd1OHRkVTR3SW5iZEx6?=
 =?utf-8?B?RWVLb0h0SU83eG5ZY1MyanFUWGtWelk4c3pVMGhzOGlScjgxR1ppU1NrN252?=
 =?utf-8?B?N1dXeDYrUTZsSU4zTjVib2Q4OVJZQ0U4cEJqSEl3MXhBQzhtT08rMzdxbGxJ?=
 =?utf-8?B?d3FUTXMyVjBLSHJxMG9RMGZkZk9QU0NsMi9lQ3k5NHFZS0VZcVV2RU9maWJ1?=
 =?utf-8?B?MG5XZFNGazQzOFVNUFZOdjVpVmtjVGdBVmJaenRab2l0eC91S3ZtRHg2bFc1?=
 =?utf-8?B?K1J6YzBDckV3emViSlRsRmhIS1NSNUVvY3lUQmQ2V0xtK1Bhb3p6aUxpaEJ4?=
 =?utf-8?B?Wm5ZRWNnTU1zREdnQmNNRDI3N2ZHT0E3eGFGV1MwNzB4SHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2lBS0hxYXJJdkVocVFaVE5DU25POEJHL2Z3MDk2MndOZXNnNkVEYlZocG54?=
 =?utf-8?B?L1FhRGtVMHNzUHIwVkpNLzhSVWFQOUIwSjJ1dGltWm1zUnRldFkrSFZ2bjl5?=
 =?utf-8?B?b1h6ZHd1L2lCUmxSTkdmT3IzTEoyS1NycXVjZEl4UWZCTHFUQ2tlL1ZWaHZn?=
 =?utf-8?B?K21OTm5mVGJWNkFKamRZc2FLcjJ1UndvSHdiQjVuUnlKTU5uQW03L0FuWTFs?=
 =?utf-8?B?ekNYUnJRekxOMGNUSU16YTB0aDRDdG9pQUo0YVlmWlJOSjIvNEZUVDFKVnB6?=
 =?utf-8?B?a3A5elUzTzhlRUpGMXQwV0ZDNDBWMGRoWE5IekZFQVVucEVCQ2p0QUdQMXoy?=
 =?utf-8?B?bXFYSFVHdFhob3Fabllhc2xxSHpxd0JydlNSODl6WDk3bVcrcDkvQXRtRXEz?=
 =?utf-8?B?YVdkZ3c1ZmRVUFE4Q01GOTJYQnp2bVhpUFZwRk1RKzF0Mk41V2JPcU9MTkN0?=
 =?utf-8?B?Q2JEZjA1RW91ZEFFaTRKOTN6VFlpbm1vQlR0VnA2SXlJZGJWZFB2V2hiZ1hM?=
 =?utf-8?B?RnEvR0FGbXVjVDFpcnNsMVlUemp5YjRVV0NjZkVDeHBBaE5QVDlwU3k1UkUr?=
 =?utf-8?B?dUF0MlpRU2lDTFRGSlNCMEZwcVRnMDVLbmZWS1BGdjNkZ3RFQlJGU000d0Rz?=
 =?utf-8?B?dmhwaytScXJ2RlY4OEhwQXBZVVZ6bTE5Q0Q5NlBabGZjb2hGMkY0QnpTbTZY?=
 =?utf-8?B?ZXhkWXhzRjIvekdBUStIdzNUVllsV2ppUFhnMUpGUkdyTit5dXFyMlQ5eTk2?=
 =?utf-8?B?YW9SSHNEaU9HWGcycW1HRFY2bDVqVG16Q3M5WWxnbVpPZGc0Mnd1SS9hR05K?=
 =?utf-8?B?YWFCRzJYOVZ6dU92VWNMQXFYS2ZRZ0JFNXhodVBaQXJIdXJxbkNuUlRHdm1P?=
 =?utf-8?B?OURIQjIvak5nY3BOR1N6TW9CaGVYOVZ2ZXVwVmJ4RmxhZVdIcmVVRmpSWDFT?=
 =?utf-8?B?MlV0ZU9aWDRESUMvLzA3T3Q0Wmd3SG5xTU5VM0JDTk1PNnJ0dDFWbjBYTmtl?=
 =?utf-8?B?b2szRURlMEhBVlBpWStxRTFkOUlXR3hPSVZZMlNnY1hETUo4SWxaYWx0N0lk?=
 =?utf-8?B?VWRNNDJSYmhpQ1ZObXhoTkxCbWY4UjMrREdTY0FLYktHVlo2OVlYVHlsM0Yx?=
 =?utf-8?B?dG9yY2tsSm9sL3ZyeExtSXRZajMwc0NoTzEwaEs1WW9CczBUR1lSOFFQK1RD?=
 =?utf-8?B?d0NaN3Z4UHFhdE5ieUJHNHovczZUeGFSL0F1MjJUbmNMVWdJcTlsaTdiYzBM?=
 =?utf-8?B?UVV6b0UzaGJMbjNEOWk3b3l1emtYUnU5WVZwclhOeFh5ZnhaVnN0TGZZNERz?=
 =?utf-8?B?MHkwRnpNcHBkWjVSMW5tL3gvbVJSM0FaOVpKUUJUaFFXbmlZeVRUVUdPWGNQ?=
 =?utf-8?B?V3ZKYnd5UTVSaXNpWCswdUNLQTRyOHJvVW9ncENZVVkxa0U1SE1FTnNSNUlO?=
 =?utf-8?B?SnJlSnZpWVE3UmtEMXByN3RBa1NJaHB6emJYbVRoL083d002bDVVZytmdmtB?=
 =?utf-8?B?a2MyRXgzUVdIOTBBb1JpMncxa2lVcHRnSE90eDQ4Z2dxUGlaek5EQ2ZrVklP?=
 =?utf-8?B?VlZaaXpydk1BaFNUQ2JtK3lVWnNMaUtZYytnS3g4dWhCS3dRcEp3UzVua0Na?=
 =?utf-8?B?VGdld05yTU90Y1FNSUt6Y2E2bzQ2VGtnNkNuMjREUmRvM0l6OUFDMUp0UGtI?=
 =?utf-8?B?eElKbnJWclRKYVVkQ2hRUDRJWk81L0ZYK0RlN1o2djZTVTVVK1JielZqYVkx?=
 =?utf-8?B?ZktzVTRTaXFYd1d0ZFA5RlpLM1JSSDZaQWdianVBbFZmZW9uenQ2THkzUVg0?=
 =?utf-8?B?VXVramNOS3ltanJmSFVQZk9zakRoOXcwOXgrZmZHWUM1MFc1VHhtQ0gweCtv?=
 =?utf-8?B?aVE0RTR2R3VCa29ocEhwUnNJSFNpSDh3K1ZiZDNTcVBvQU5ZUjRPK3prdUxC?=
 =?utf-8?B?b091bVNNQWY2UGZmZksrTVEreFFaWThwcVg5YzlzZ2d5ZUJ5eXYvM0dydW90?=
 =?utf-8?B?dTJtWUdqZ0VtSndiU1ZpVU55NHhzS29qSzhJelh2U05iR0JrWmJKdHplNGVm?=
 =?utf-8?B?emlkWjFJMG9sQ2hBRS9LMWZWNjB6UUMrU0V3NzdZUlg4TDQweXB6SFc2TDF4?=
 =?utf-8?Q?19h9nRb92JrxpBil+KkqAnQij?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 714897c4-68fc-4849-d3d6-08ddf7c5e2b4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 21:45:44.2057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WneRKfnUDG0pJQHUz7ymvCbr3sT9X5t1wn2ewfi/0aKfHGtiHdAwq53CEGyRjI2N7Uw5Jp2eLrFPDRv3YI93TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6899

On 9/18/25 05:27, Naveen N Rao (AMD) wrote:
> Add support for enabling Secure TSC VMSA SEV feature in SEV-SNP guests
> through a new "secure-tsc" boolean property on SEV-SNP guest objects. By
> default, KVM uses the host TSC frequency for Secure TSC.
> 
> Sample command-line:
>   -machine q35,confidential-guest-support=sev0 \
>   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on
> 
> Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  target/i386/sev.h |  1 +
>  target/i386/sev.c | 13 +++++++++++++
>  qapi/qom.json     |  6 +++++-
>  3 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 8e09b2ce1976..87e73034ad15 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -46,6 +46,7 @@ bool sev_snp_enabled(void);
>  
>  #define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
>  #define SVM_SEV_FEAT_DEBUG_SWAP     BIT(5)
> +#define SVM_SEV_FEAT_SECURE_TSC     BIT(9)
>  
>  typedef struct SevKernelLoaderContext {
>      char *setup_data;
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 6b11359f06dd..679bedb63c3a 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -3117,6 +3117,16 @@ sev_snp_guest_set_host_data(Object *obj, const char *value, Error **errp)
>      memcpy(finish->host_data, blob, len);
>  }
>  
> +static bool sev_snp_guest_get_secure_tsc(Object *obj, Error **errp)
> +{
> +    return is_sev_feature_set(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_TSC);
> +}
> +
> +static void sev_snp_guest_set_secure_tsc(Object *obj, bool value, Error **errp)
> +{
> +    sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_TSC, value);
> +}
> +
>  static void
>  sev_snp_guest_class_init(ObjectClass *oc, const void *data)
>  {
> @@ -3152,6 +3162,9 @@ sev_snp_guest_class_init(ObjectClass *oc, const void *data)
>      object_class_property_add_str(oc, "host-data",
>                                    sev_snp_guest_get_host_data,
>                                    sev_snp_guest_set_host_data);
> +    object_class_property_add_bool(oc, "secure-tsc",
> +                                  sev_snp_guest_get_secure_tsc,
> +                                  sev_snp_guest_set_secure_tsc);
>  }
>  
>  static void
> diff --git a/qapi/qom.json b/qapi/qom.json
> index df962d4a5215..52c23e85e349 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1100,6 +1100,9 @@
>  #     firmware.  Set this to true to disable the use of VCEK.
>  #     (default: false) (since: 9.1)
>  #
> +# @secure-tsc: enable Secure TSC
> +#     (default: false) (since 10.2)
> +#
>  # Since: 9.1
>  ##
>  { 'struct': 'SevSnpGuestProperties',
> @@ -1111,7 +1114,8 @@
>              '*id-auth': 'str',
>              '*author-key-enabled': 'bool',
>              '*host-data': 'str',
> -            '*vcek-disabled': 'bool' } }
> +            '*vcek-disabled': 'bool',
> +            '*secure-tsc': 'bool' } }
>  
>  ##
>  # @TdxGuestProperties:


