Return-Path: <kvm+bounces-48282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE7CAACC367
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 11:46:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC4AE7A7361
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C6C01B414E;
	Tue,  3 Jun 2025 09:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BawkTc2K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8862C3271
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 09:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748943974; cv=fail; b=ZzcCpcJR9CqJI7xEHGOxsETIeP/joPFq4gmPVw93lKkDU7s8Ef/tc4w2Bsdd3vvAak5wmdtC2eFhpWNk5J4uC7OpBFiwiORzawej1HLubdMdsonRtHpEpA76iTfbQoxCrz9rzqmHhNrgKOmPZX4DAx9turpPAgZPb/xNFqa0gDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748943974; c=relaxed/simple;
	bh=+lkZyJVq/HiVHhfvVq3wWm+n5Nye8g3J3TAkh6qnDoo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QwpEGlSbQi86Llf/Jx9bclaGYTblBe+tCqaaqNmQBZPpgYyrINPPzGcfaCBcfJCmyWhTs8YJdj1zwq1zhv9f8xE7R5bRYTgC4YuUnvMuKwL6vwnpfgQTB4ydylcm/DMQTgMHoIVw8qQIBhA4PKWAuzBzwYtVjZYVpnBc1TpouYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BawkTc2K; arc=fail smtp.client-ip=40.107.237.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PzCEnfwE3sdvoArnJPpB+fniFi6YJVqG6pW7EgytKHmzxwvK4RMcF9Onb4kVt5fjIGbYkW1waPpq0ztugfMv9zu00smIQLEL3CBjpmkr2TIhX1SVItzbxjpqkA/86us8cIL/2Fbe0RtnN6q+bsPTfjlUHZN2k8vh2kjuTTDS+CN+o8jYJo/DRnbbMk9q+u3u7Lwe3HhLYemG6KtwtiJyIDOyyyGRXOMSnorNKub9kOvTtptH/QUhoX4vwyAVDVpVSgQVwNqVgstO3y2ksOZlPYCMZxQjbyq+s/YZCbOyQ26oyKjvrULjP4Ew+ejC1m80e2JUZhg8rLZpSfoZROuGgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8TUcoCnCRPbsS2q3LDm1mTQDyrG9Feu7z04+5AqtMA=;
 b=t8SSXLYOPu3kNLfmA5lPT1B+zBwAqH+zasatNi7neqqbg4E9sHq+amH89Ui5p5oBU3gZoPLcbSeZRCDHEu/Ck4LI7mmuQ6pe7OIlIq87Z7WOgTBu+iL5QD5EDj4ekYQt5EO+tt/1KVXkVMt/yU7meOgI7mEW1KzSEdt56llRh7dtlb4V5vv+YzY6jlp/s+iQ3G5jSp5q3nqU2by7ZmTrzCnRtuU/gNRcc5Exytti710dHbuaUDVfA4pwnpdIV2xI+DRP6Z0ae4/cRyLPBKAQDOAc03svQCIjq/FPsG38qkKpfMR6esmpXSDDW9LVSEml2XXm2CTq+6A5xz3dhQsYwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8TUcoCnCRPbsS2q3LDm1mTQDyrG9Feu7z04+5AqtMA=;
 b=BawkTc2K3TR0cWcvPgjVL2yS77aELXOkRQJWhaT2JgSEaakA9H+SMx17WBGrD6jJlht2vkrAJ4Nao57P/VoHz+vHfanHymbWl04LlaIKeou6L9Bi+EEP+sGW+TrxiXy1PRFJfu0p0HhGMZvvDVom6evzxAU0CYC8BC4QcAOtr1U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SN7PR12MB7249.namprd12.prod.outlook.com (2603:10b6:806:2a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 3 Jun
 2025 09:46:09 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%4]) with mapi id 15.20.8769.031; Tue, 3 Jun 2025
 09:46:07 +0000
Message-ID: <93d48fc1-9515-40a8-b323-d3e479d30444@amd.com>
Date: Tue, 3 Jun 2025 11:45:53 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
To: David Hildenbrand <david@redhat.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Maloor, Kishen" <kishen.maloor@intel.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
 <4105d9ad-176e-423a-9b4f-8308205fe204@amd.com>
 <9a9bb6bb-f8c0-4849-afb0-7cf5a409dab0@intel.com>
 <d0d1bed2-c1ee-4ae7-afaf-fbd07975f52c@amd.com>
 <c646012a-b993-4f37-ac31-d2447c7e9ab8@intel.com>
 <219c32d8-4a5e-4a74-add0-aee56b8dc78b@amd.com>
 <828fa7bb-8519-4e3f-a334-c1b4ea27fee3@redhat.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <828fa7bb-8519-4e3f-a334-c1b4ea27fee3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CP7P275CA0009.ZAFP275.PROD.OUTLOOK.COM
 (2603:1086:100:42::6) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SN7PR12MB7249:EE_
X-MS-Office365-Filtering-Correlation-Id: 794c885b-8e98-474d-ee85-08dda2837644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEtiYlYzbDVVUjQ2RUpJSTQ4NzJFdTRzbGdBVGpGMm9TbFc5TkorbER6VUlF?=
 =?utf-8?B?d2NKNTdJa2RwdjFicEdpN0VVRTdVQ3F1WWZEdjhud0ozL3EvZlZoRWV3NEZt?=
 =?utf-8?B?OTdTNTU5Yjk5VzVhamFoMUNlbFhSOWhOZHdUZkhXRFQvamtQeFRSQ0FXZ1pS?=
 =?utf-8?B?NThFa0hRRnBuRlZ6WDdwbTlTaU5KcUhGaW56UXkzK0M2TTNja3l5ODNqbHMv?=
 =?utf-8?B?K08vVG5Wc3FESGU4ZnQwMWhLUDNRZUIzeW1rTE1XUmhvNWFxaFFxTkJjbTk1?=
 =?utf-8?B?TWJOMWFyUVpSUWFTeHk4ZDJwYWREMkVSblRST01VZ1U4YkJ6QlRNNERIUXB6?=
 =?utf-8?B?cGJNVSt4MnJLN0l4a2ZuUVBqbzd0eG9mVXNmTFR4eFBqZFFSMnRPcXZkTFRE?=
 =?utf-8?B?V05rSFVSWlJUUHpJUHpLYkZWaDhzd3JGcFBmNHIvd29hUzZUNk9TdlI0WlZD?=
 =?utf-8?B?TmRROVlreEZtN3lxOVBKVUppNXRjUm54bngveTRvUkJMeFhLWEZSOGNtRkcr?=
 =?utf-8?B?N1AxaytBMThNaVhVTlU3azJjQ2d1cnRNTk53WStPSXBjMFB0MHJxVWw0OUt3?=
 =?utf-8?B?Q3FTcDdvTzl3Ni9rZldmUlBzRzF6TEpPZjE2TWRpRjNqM0tkRHpWMnY3K3FG?=
 =?utf-8?B?SHZzVktnd0ZEbHJESHhRR1NvSitmY1hreTl4VFdUNWJJbWNUdzNQY2dtYnVZ?=
 =?utf-8?B?OXFCU3RPSmFlZGNxTTJnT2dWY240YTBiVTFsV1JWVmJGY3VGaTFITDdBT05t?=
 =?utf-8?B?NXRBeW5obkVCUllKbTNlNmhYUS9RRHdBbStSM011SXdUaHdDbWY1VTQ5ckRv?=
 =?utf-8?B?TEl3dldHemNFbFovN0JQNXptSkZjZ3lMQ1FKT1YzcXFONHkwakVtSk1OdGMy?=
 =?utf-8?B?anhjejVkcGdRelFQdWNDL2ZST2JXa29kSFBFNUlpUDNXamR2clBNMkVQSi9l?=
 =?utf-8?B?Njg1Sy9CYlpXMXdWVkQwMW1CM1ZxMWhwNzBUWm0raUxieWdvZjBOUHpXU0Jx?=
 =?utf-8?B?c3NkZWxOMUUrTXd4QUJOWXIrelhHRUJ0OGxGR29IdUlpaC94TkVtazYyQ25R?=
 =?utf-8?B?WHl4aUVBZm9HNU5rVEx4YUwydUx3TEZrQnJSaWxMQUJGRTIwMGRWMnZFZE5p?=
 =?utf-8?B?SXh3Z0EzVGRJU2RNTnZFWEhHbnFDQTVsN3I0SVdNMmpUS0N3dDg3T3hpdnlK?=
 =?utf-8?B?c0NaS1YvTmF3MHh0TENxKzZkVGJGRng2WkRWY3ROc1NuNFVjeW9LZGdqUGNT?=
 =?utf-8?B?RHB4WDUyWkNNb3BianVRckYrOTkwMnpZWnIySW9OaTkzSHloQnRGNWJnMU56?=
 =?utf-8?B?YWFLbzNyU003WC9oRW0zY05STTI1RHMreFovRlo4cm9XU3pTYlhqTVo1a21n?=
 =?utf-8?B?dUxCdENZTVNtY05WUjBGSHJIRnZpeWwvWHFhN1l6NUlKS0RSTnpMRWMxRzBF?=
 =?utf-8?B?dWtxOEFWOHhOM3Q2eklUSnBGVjlXUzRHTlhoZW12QkJycDRnUDRXZWJtTFBE?=
 =?utf-8?B?eWozWDhlVThUekc3NVk5N25XdVBQcmhOTXZ6ZEhFK3ZNMWpCUk9YaURhUHM0?=
 =?utf-8?B?TkJVa1hDSGdKU0lINDZGb1R3bWhBbmdETTFkVXBpNDhKRjR0R285RGVMZnJX?=
 =?utf-8?B?V0lKN0xXSVExVk5RZ09ZUlNQUEtKeTVrNEJtdEY4VStJL3c3RW92ZzJNTmx5?=
 =?utf-8?B?Tjh6NklzeWt4VmdqNnNGNGFBU1ZPeHJZaTRDVmg2VldNekRsK2JUNUVvSm5I?=
 =?utf-8?B?NHJFNUQwZWdaUGpCOHVsaTZqQmNvVDUyb0puamFrSTQ3Q3BneEtYREhBcWpR?=
 =?utf-8?B?bWM5NjFpdjRoNjNsbEE4akVOMzlyOVFYSWRQb3RaRjZwRkM4LzFRMU9nNThu?=
 =?utf-8?B?TDBMSkZwSk1UR0Z6bUtjUzIzQjVtNng5ZjhLcEczZ0J0Tm1XbFpxTXlhdGxv?=
 =?utf-8?Q?yKTMMY9qdrI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVBnM24vTmR2UU1uZndlTWx0TjNBU2ZrdHBNYm9tWGExcmRZWmd0RnluWW83?=
 =?utf-8?B?V3M3MVhMWU1ZbXRzcGJBd2FLYXU0clE3cnY2YVBaZHVia0RZZ1ltK3RGRGty?=
 =?utf-8?B?VFVadlBHMDVoRlIvNjZrcFFCN052TU9IL3ZnM2ZJVmhYQjJoRWNvLzduUzl3?=
 =?utf-8?B?RXgxNWc4U2RIdHNrVkxMUnUzRU1MNUwzeFRPNTczSjhDSjN0ZzdoeFM5TnRk?=
 =?utf-8?B?L3Y3KzZSZit5TGRUWmh0Q2VQbSt0N1BzWW1TaFFkdUVRc084SThjcjdONWZI?=
 =?utf-8?B?SHlFSUNUdzBaQTVkNXVYU0ltb05JKzEyWnFMRnZnWWY2R1ZvYmhtTXh2QU9s?=
 =?utf-8?B?QnkvZFk2R21OTjRaQk9JWWlOaE4weDhMekswa2dpT2grOTZ2N3FxaVVpWVlI?=
 =?utf-8?B?d1lURk13RFo4Y3dtQlNyWlpMdHpxYkFWQU1uSGlWQ3luVGo5dWpSY2ozUjFv?=
 =?utf-8?B?NlpFNmNLcmtmTm5XSkZnK01ScUkrQVlXWm1oY1dLeWR1KzFPOFhlNGYxWGxs?=
 =?utf-8?B?Nk44T1NQdzl2bUtsa2swWGR1cmhsVTVhcXZDNlJnbXdoa0RDaEVhRUpCUmE5?=
 =?utf-8?B?NVlCTlFSTEZ5ZWx1Zk42aWw4QnJuaVJWY3hDVFpwVUhjdXJFOGVJT3h6WTE3?=
 =?utf-8?B?V2o3bWJIVXB6NkRxTy9LVHNxekFhU295YjhJNDZybkI0MURrZHBwSWd0VWp3?=
 =?utf-8?B?STJ0WXFQSnZER20rZEQvTk5xamo4MG1aYnBuSmFrV3lLb1ZuWHBnU0prajJU?=
 =?utf-8?B?c0hSaWdueFFvc3dvL2d1dkkwazlkSG5jTnNCREVDUk9raEMvVk5HNTJYTVNt?=
 =?utf-8?B?OXo5YVAyM2lqSW9QY1hKSCt5c0d4TjRmVkFmdDBGa1pLb0RHdkpnaUxWQ1lm?=
 =?utf-8?B?NDBXMmo1dTNDSHkxcWhXKzJJT1NWZndMSzUzbjVHcU9BZ0VNSnFwSWR0Y3FQ?=
 =?utf-8?B?aW9GRFA1aXFueTY5RERhTnVTSnR1MnpsdC94Y29yZHNQZTFVRVV5VVRyRUpp?=
 =?utf-8?B?RmRJeE9Kdk9xTjN0bG9JS1QzNGE5Nnoyb09MNFZJaHVzb2xtMnU0WGJtUWxP?=
 =?utf-8?B?bG1tOTBhZk15YVBUWnA4TkROL0tmMzZzUmVKQ0dBNnpxZkQ1ZGRXa0V3S0lh?=
 =?utf-8?B?VnRJL1g2dUVCa0dWWWoxUndFdlV0b0NkTkx6SzVVdjA3c3BialRsdks3TVlk?=
 =?utf-8?B?T2VkRHhxTm1tNk01clMxeE9mKzdQWmMyNkszZ2hKMjNHSmN4a1VPY2NFc09Q?=
 =?utf-8?B?WDBrODFNa3NqN0hWd2ZISFN4eVhydlZpZ1VsNFlyU0N1SVYyK1ZaV0xOeERk?=
 =?utf-8?B?RzgyYXhRUmVXeHhQNFFvMXVRMlJUNmtLK1dnZ3djYTM0ZDlrK1YzNC94M242?=
 =?utf-8?B?bmZWL3BHb094SzNTRlFpTHY5TXpqOFhPRkxBV1pJU0tpbDZGa1FCa2Z2NWY3?=
 =?utf-8?B?eTRoYWFyakRpRE1kR2J5MXRONzRNRTFVcGF4ditLZlRUUHFrVlhVWUNqT2hq?=
 =?utf-8?B?UE94ZU5tYmJNZjNwb0lVVzRLUkIrUk96SFFRekdyRUVzTnhiank2OGFWSmpk?=
 =?utf-8?B?akkyL3c4eVA5V2VMZjFzVEZWL2hYbCsyakhPNStzZDFMT2pMZnJYc3VrTHUz?=
 =?utf-8?B?eEJmaGo1WStUeWVjak4yUXJGNG9aS1VwTmVrbXliQWlGUnBWNENkUlJGaURZ?=
 =?utf-8?B?emRhRDBnVUNrdDJuVUlxbGduMFc1U3p3ek9ja2ZmMUFPZU8rOHFVWVd5amVH?=
 =?utf-8?B?ZStkL01qMFZ5Qm02UlkvZzRTQlhOVXhyeXZra09udk5WdXhTT2pYTHZ6enZy?=
 =?utf-8?B?Z3htMHBaOE5mR3pUOE1EMkxWMmw2enlWZTBzVWFlMW5XNHdmTmtHcVFteFFB?=
 =?utf-8?B?ZlJLUjNXNC92dWw4OVM1YXYvVzN0OGZFRUNWQlNYbmJRYTFxV0NFM0d2NXhP?=
 =?utf-8?B?MkRDbHF3L2hPYU1jNEZ1SHBjUUtBaHppb254RXUxbTFaWjR0VGFubHV2YjEy?=
 =?utf-8?B?RUFJSVpNVGNUN1pZQy9JNWVmRENWSkprUWZEbTRvazNiZVZkUFlFSmM1RHFP?=
 =?utf-8?B?SUMxd3A3c0szamxUVGhnVGd3RFJBdEU4ZFFhdHMvbDdyVEJrZ0FsbEhGZHpU?=
 =?utf-8?Q?O01bF1uu5Nwn4roFLs3/RsCw2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 794c885b-8e98-474d-ee85-08dda2837644
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 09:46:06.9335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4GtZMNUEyZ3bWMTwNej6b5AiEUWB0ZgkY4Ur9Yl7rVxhsMDTM5ih+9LQz64JYs+GtcX/w+4DZ1oOjeuGG3NKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7249

On 6/3/2025 9:41 AM, David Hildenbrand wrote:
> On 03.06.25 09:17, Gupta, Pankaj wrote:
>> +CC Tony & Kishen
>>
>>>>>> In this patch series we are only maintaining the bitmap for Ram 
>>>>>> discard/
>>>>>> populate state not for regular guest_memfd private/shared?
>>>>>
>>>>> As mentioned in changelog, "In the context of RamDiscardManager, 
>>>>> shared
>>>>> state is analogous to populated, and private state is signified as
>>>>> discarded." To keep consistent with RamDiscardManager, I used the ram
>>>>> "populated/discareded" in variable and function names.
>>>>>
>>>>> Of course, we can use private/shared if we rename the 
>>>>> RamDiscardManager
>>>>> to something like RamStateManager. But I haven't done it in this 
>>>>> series.
>>>>> Because I think we can also view the bitmap as the state of shared
>>>>> memory (shared discard/shared populate) at present. The VFIO user only
>>>>> manipulate the dma map/unmap of shared mapping. (We need to 
>>>>> consider how
>>>>> to extend the RDM framwork to manage the shared/private/discard states
>>>>> in the future when need to distinguish private and discard states.)
>>>>
>>>> As function name 'ram_block_attributes_state_change' is generic. Maybe
>>>> for now metadata update for only two states (shared/private) is enough
>>>> as it also aligns with discard vs populate states?
>>>
>>> Yes, it is enough to treat the shared/private states align with
>>> populate/discard at present as the only user is VFIO shared mapping.
>>>
>>>>
>>>> As we would also need the shared vs private state metadata for other
>>>> COCO operations e.g live migration, so wondering having this metadata
>>>> already there would be helpful. This also will keep the legacy 
>>>> interface
>>>> (prior to in-place conversion) consistent (As memory-attributes 
>>>> handling
>>>> is generic operation anyway).
>>>
>>> When live migration in CoCo VMs is introduced, I think it needs to
>>> distinguish the difference between the states of discard and private. It
>>> cannot simply skip the discard parts any more and needs special handling
>>> for private parts. So still, we have to extend the interface if have to
>>> make it avaiable in advance.
>>
>> You mean even the discard and private would need different handling
> 
> I am pretty sure they would in any case? Shared memory, you can simply 
> copy, private memory has to be extracted + placed differently.
> 
> If we run into problems with live-migration, we can investigate how to 
> extend the current approach.

Not problems. My understanding was: newly introduced per RAM BLock 
bitmap gets maintained for RAMBlock corresponding shared <-> private 
conversions in addition to VFIO discard <-> populate conversions.
Since per RAMBlock bitmap set is disjoint for both the above cases,
so can be reused for live migration use-case as well when deciding which 
page is private vs shared.

Seems it was part of the series till v3 & v4(in a different design), not 
anymore though. Of-course it can be added later :)

> 
> Just like with memory hotplug / virtio-mem, I shared some ideas on how 
> to make it work, but holding up this work when we don't even know what 
> exactly we will exactly need for other future use cases does not sound 
> too plausible.
> 

Of-course we should not hold this series. But Thanks  'Chenyi Qiang' for
your efforts for trying different implementation based on information we 
had!

With or w/o shared <-> private bitmap update. Feel free to add:

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>


Thanks,
Pankaj

