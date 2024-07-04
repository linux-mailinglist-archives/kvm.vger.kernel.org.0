Return-Path: <kvm+bounces-20939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DFC9927126
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 10:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7397281D47
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 08:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E541A38F2;
	Thu,  4 Jul 2024 08:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZebhSu7M"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2084.outbound.protection.outlook.com [40.107.101.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984FB18637;
	Thu,  4 Jul 2024 08:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720080171; cv=fail; b=f3EghHFbFdk2BSFa7YEkKILHdJ+dyPAVlFzUU9e3fkfx5meGqBz4+SQt2YE1E8/BaOJnXpDp2PO1b1x9hgNVM8FnkI82Q1Gmpsim4vW6z6p3mmy3R9DOJJNfEHUQwSMc6IdjBlGhpxnzFjhwe3zB/4aBZMuRV0+lehSRj6exL9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720080171; c=relaxed/simple;
	bh=sMUKhd9GEGl+s4nnPupzJaD/T95whp7h3qRcuJlLzXY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b2jWI6UHY4YvM6kIP1XiAzLbSrs5eoTyN65Ctvzb2mb9hQt4pSSZZJdhH5Tiq9Tiu4Ffvc+/5XoaW6owG/7AtsblEQlimpejMnJ8PAo2DwfV+Rep9bUZVnR+p7lYm4CCWo7hxkW0GwV15de7ySZFPTeS7Hv0gyCNjfRn7xLGI08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZebhSu7M; arc=fail smtp.client-ip=40.107.101.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQxGK3FjIq/Qg2ohXsn8QXeAhS7nCIXeSRYKS8b3wbTMLGyr7ED0kM2USJ+5qt9WimH0Gey95lDb5LvOdNhvZY90K02dZpCv37QgXMJXPjc6e8x+/FEWASkrgWx8hOFh/EB7IkT8zMNkiElcnTXpTz7wp/8pQfKYbnF7lYS531ltGVk/ErRaHiIsrEXH/T+GMdVcypuo1fuxL4l582/RXfuFTCDKs2Tn0eOl4F1E/JJ1sEt0mjflfmtn8saxMvA1zREWVnZMlurBFY2Sj1QEQHEw+hmbGcC6rpFIK5s55f6DUNYGt4IOzhcS8cbRaQfE5Uw/h9WTLEt96Z1qvQ0R9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Myve2wX9Bkp/YBxA9u70AXefGxUj2g94tzqS6+Ut8aY=;
 b=RsZIkDFqatyhiSIABpaz2DCOI5lejqOLypvcmKs71+oVZczSzxnaaswsAEpqu076m7Biec4aM5TsNNgoti0aUodDwd38XryssKjo5Ojam+gKWp/EDFreZh2nvIqr9uMQIVQcXd7+EBvCMsvOJdRIt++gskyd4VFL5ckGfgIh8Qt1IBzR68Aj0OZyjKlp1dWQki456O/iZl+7JUghp1NWttX8lQaxGjSgxomPyR7hggqVDgCPVfX90DyFeKf1QuANbGDkeIt+VLFp7mdN1+xxD+RzFOO6xhWEDaOxkjvWbk+buxvoJzZaKS8uQgzV5ZfTYk3QItx8/QxEF8qLTMmaYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Myve2wX9Bkp/YBxA9u70AXefGxUj2g94tzqS6+Ut8aY=;
 b=ZebhSu7MIws2A4fUKrQzIcjewZ11aAbgVxoiAcnCUClTqlRLfFA6fBCsCR6X9+HqxLDwjcAShLzBtfm1wjg2fxgWHXLNoz15wjayNw0y2KMmUtRNWom8OIrNLG/hL4qTGJ84mfMWeGRVe0apNFrChDWP4AaaQnar/wEFPdeZ13U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by SA1PR12MB8858.namprd12.prod.outlook.com (2603:10b6:806:385::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23; Thu, 4 Jul
 2024 08:02:47 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.7741.027; Thu, 4 Jul 2024
 08:02:47 +0000
Message-ID: <6d512a14-ace1-41a3-801e-0beb41425734@amd.com>
Date: Thu, 4 Jul 2024 13:32:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v5 12/18] x86: pmu: Improve instruction and branches
 events verification
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang
 <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 ravi.bangoria@amd.com, manali.shukla@amd.com,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
 <20240703095712.64202-13-dapeng1.mi@linux.intel.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20240703095712.64202-13-dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0031.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:b8::18) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|SA1PR12MB8858:EE_
X-MS-Office365-Filtering-Correlation-Id: 93178e96-1837-4d37-1ffe-08dc9bffb138
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkhVZUpSSllBNXAwQnVvZnFpVjd2UHNUWVpCU25ScVMzYWtEaERZV0t6OEdy?=
 =?utf-8?B?L2hNUm4ycXJFYjk2TnhkN21KK0REZ0FBN08wMk5DWG4wQVllQmowRVdSMGtT?=
 =?utf-8?B?Y0VkM2Q2R3ROWU5YRk5GdytubGdza0xtOGxuZ2pveHovdk9xNWRQc2dSMFZ1?=
 =?utf-8?B?eXFBdmJOUUdrb3hMZDBONG5UZHBrdk5pSGEvODhWY3plREg4SUkwQ09DSlAy?=
 =?utf-8?B?WmdDVTdLZlBoV25NUlJXNFZPTXRlRVlJMnpHc0E0WW8wY3V0TmtKL1lWZm1u?=
 =?utf-8?B?bXcvU1JPZHI5Y2lhTGdRVFZKZkJOMm9tWnBkeDdXR0hVcW9RTE93NDgrckZi?=
 =?utf-8?B?MnZxYUV4UzJsRjZsZE1pTjRpb09PaGgvU1N2SUxBeWRtWUxXU1lROUZjUW43?=
 =?utf-8?B?aHBaZ1dIcXMxWWFLamZ6ZWUvMnphWWJEM1crWUZoK2xHdnVIMGRkbHQvcUY2?=
 =?utf-8?B?RUt0VUE3bDFlY01INmQyb0xuMndlbkU2SEluV0h1NmhXTHltWmJoRjNlMHhy?=
 =?utf-8?B?K21HamMxd2FSVHJqSmkwdFRiMXdVSWtBUU1YRUFPQXJka0dmSEhuMDBEN1hS?=
 =?utf-8?B?ZHJVd0docElpNGFUcGt1RDIxZHhXY2o5ejJjdUFOTlpzc2NHTmJQak1Menhh?=
 =?utf-8?B?UEdacFJOdVNPVk5tdEZzYWpWcVYyUmQ0bWh1Q25XQUZIMWQzSFhuRjcxbjQ0?=
 =?utf-8?B?TUNXSWUxakJWVXBXZkpmQVN6OTRKN0RhRENtK3oxdWZVRkM5MlMrenJaRUpa?=
 =?utf-8?B?Vkw3Y25CdkQ0TGVyUWdIclRreXdoNS9kNXovTERiVWZLR0FkNHpkbHIwZlF0?=
 =?utf-8?B?ak9xL3FQWjZkQTRsTWdVSXVNVEdFUFB6QkdmdWlzRXJFZzNwZEw3QldCc3Zk?=
 =?utf-8?B?aForYXEzVXp0MFUveGhOanlKQ0ZOWGx0M2Jpai8rT1NtdHdac08reE1tQ3FO?=
 =?utf-8?B?THlUYXJhN2dJUGU5dDlreDZ3c0ZtRjZrbUpEOGdDaDhWbjl2eXdnelIvNkdS?=
 =?utf-8?B?OVQwMmZNdTQ2UERYSjJvNlBNaVpjdDdsVGlPazlLN3ZCQjBZaEc4ZzVvZXpZ?=
 =?utf-8?B?T2xhcEp6Z2pxVFJYckdiV1hzbjhJUFR5UHFkM241V1pieGFMWm5hVEQ0NlRo?=
 =?utf-8?B?dG11TnllSFQ1dllOVG9iZCtXa2QrWTBydUMvYUNjNW5pZ0lGbkZmNUJMK01I?=
 =?utf-8?B?bnBGbVpvU2xHdFI5UUtjOHlVTURGVHkwYnl6a1RJTGEzSUc4Ui9FVnN6ZElj?=
 =?utf-8?B?MStBa3VaajlVajBJOFB2SzZmOEs2YVdHQTlNUUNzS3hIeW4wbjJkSTFPSXN0?=
 =?utf-8?B?RkVFWlQxZ1N5WnBhdmM1ckZYM3FKOElwWkt2OWhub09LNG9KNXhWQjFIMGVG?=
 =?utf-8?B?cG02Tk1CRUo0NXE4dDA3WXBJdHo3aU9nbmIyaEp3c1hhazB3Wkl5d1dOb0lZ?=
 =?utf-8?B?ckxWSmFmZWw4ODZZaWtoRmJsanZPWWZmRVpuLytLWVk0dXNkTlpQbllxcTNq?=
 =?utf-8?B?dnR3M2dGVDdkMkF3R2RuYm14dU5Sa09UM29YWDJKQ3o1cGhBeEZUTTR0STdz?=
 =?utf-8?B?OUFXTVE5RVZFTnFQclU4QzE4T2N3TlVlRGE1V3NEMDk3cGdoRkVoejZyZ0Nh?=
 =?utf-8?B?TUdORW5GdDYvSy9OdUppbzVyZGVGMzNXTUdJSktKQ2dZenZnYVd4aWE4S3Fw?=
 =?utf-8?B?Q3V2QVNOblNXa0xFTkprWXMxdlZpR1hNNHlOZU9UYzRRSks3ZS9MWm4rTFNr?=
 =?utf-8?B?V3d0OFZhd2dEOGNzMXRQUDBzdXpMK2FTK3kxQUlaYy8zZ3FxaUs2TS9TVEd3?=
 =?utf-8?B?RU5pOXEySERXVVlGalBUQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OG0wZVRJNFVMMEJuajZsU3JhUFg4Y3lJbVJCVnRxUmxNS3RyMldaQmVwOVRC?=
 =?utf-8?B?bEpHWmgvOStIalUwWlplK3p4OEdUbElkTVJDUys4M0pBYjZTMU94QXM2bmwz?=
 =?utf-8?B?cFZ3RnJFR2wwQXdSZWtXVUZZR25kYnRlY0Yyb2czVnk4Q3N0c25iOWpoVzRp?=
 =?utf-8?B?TnYyRlA4VGp0TFBlQzZ6R3lQS2tWOTZpOVpXeVl5OWR2T2syNW81RThOcnVC?=
 =?utf-8?B?TUN0WDVvekpoN3Q2OEFLa1ByM254WXIwN0xOdVRMMXJpYURlSjVmNWh1cldP?=
 =?utf-8?B?bDlNWWRYdEp6YXNIUHAwakptNFBNUFZrRERydElKTGN6WDhVKzhoQ0pVblNT?=
 =?utf-8?B?R2d2UU5SQ2JocHA1ejkzTUFvemhQc3NvaEx1dlNWUVV5SzF5RnRJMy9Ybnlv?=
 =?utf-8?B?UDQxMG9tTXNIV3BVQjlzb0xGQ1VJUEs4TXJOOU9PM28ySUNBSWhHQzJ2ZlNY?=
 =?utf-8?B?WVppVzZlVTlhc003TnUxSFRRRUJYd2NjM05QM2d4S1ZqeW4vYmtDck00V28y?=
 =?utf-8?B?eU40eEV1U2JmaWRmTGdlWVZEZm5PTEJncC95eTBqV2ZEK05PMm43VmFLUDFZ?=
 =?utf-8?B?NmxSWTkzV25WeEVmTDIyNSswanpjRXFJM0QvY3hXa1V0Z0ZGV044TUVoQ2Zl?=
 =?utf-8?B?UG1vK3ZnWEVYemRnSHFHaW9MOWpCeEo4N0xwdm5HVm15Z0wyTTZFZ3JXcHJC?=
 =?utf-8?B?TWFFaDBVaCt1cUZ6cTNPZWR3SC9lVXFZZGg4c1FQUWEwM3RxMW51T2J5aGIr?=
 =?utf-8?B?ZUhHVitIL2NYa2w4Lyt3RFRsZTNLWFVobVNMR21rNEk5cEQ1OGNJaVRJek4w?=
 =?utf-8?B?K3BsWk9HV2NvdFp4UDJvMGpxOXpwMzYrTXJNT1ZKREdld3laZDIxN0JXZFg2?=
 =?utf-8?B?bG9nMXUvQ210NHF6RkloMzlwUk5qaUdkQmU0MHJ5bGVacmJDb2lYREtuUGN3?=
 =?utf-8?B?c1l3ZEJlR0dCeS8xcWV4aXlMakRRNFAvT2p0cHpSNG1Pd25JNzhzOHJiK0Jn?=
 =?utf-8?B?NVNxQk9reUt0OXNVTzFxcmhHWU1QUWQwL0lJdkhwekM1QzFrM2dHUkhLNTZG?=
 =?utf-8?B?OCt1MGNxTk5IVk1naER6TldLRnV6N2l1QTBoeUpEanFMVy9SV2Y0MTd1K2pp?=
 =?utf-8?B?d2NLUER4VXc3RzlVM2RrellTQTE2bVVnZnpMRzUxcGx3a2w1OGcrZmErN2RJ?=
 =?utf-8?B?N2p2L2o2OUI1Z0Nid1dYMjJXbTAwMjVYODJUUVpaNnhqTkFRTFBFZis0REEy?=
 =?utf-8?B?cUZrSitkaFN2RnduUVFWbndvVUFRUUQ4Y1hiLyt0bXdjdnRoNENNZ0k0OSty?=
 =?utf-8?B?Tk9tTDBzM1VCNkZjS3FOTEo1MDIwbGNNYmoxeFl0bm1GYUgzM0dLeTM2Z0lt?=
 =?utf-8?B?bkdlekdlNXlQUWY5K0x3czZueVNWZmJEZnhPYlNIQ2hyUzM1SFAwMmdWOXFL?=
 =?utf-8?B?QkJDT0hNb0dQckNLQWdHdEM4eWRQanJVR0ZyemFnc25DVW5rTWVHOGtlc2ha?=
 =?utf-8?B?ekxZZjltOSsrL0RKRXlGZ25RekpETXluSjV4cFlJcVJ4aGk0dGIxbDR4dG9Q?=
 =?utf-8?B?cGpkM05UYkZ5Qk5UNEdpRW1IeHZRRUYzbWRHOFFmSzlaOW9BT1ZYTE1LMnlx?=
 =?utf-8?B?bzRSVVJveXdxZGJmZmZUOUcxUS9XbFFKTFlmNjBuUE1rNFJjRHd4eXdhekFN?=
 =?utf-8?B?cTM3cFMwdDVIWFQvZjVHR1dyVnZIUDYzcVNneHN6RW9DTGpZK0l4VitNMkNH?=
 =?utf-8?B?SXY4b1ZtRCswcS9hQ0YyR1NWU25VRHRWQzJrSXluS0VqeExWZUxTbmZmSXFR?=
 =?utf-8?B?N3ByYlVVU24rZDJFT1JRc291dyttcENRd09WOUpFRmdQRHBkOWY0QVpkVjRq?=
 =?utf-8?B?YzRnSDUrb1MxckNhMVNJTXJuQWI5SG1EejNKL0tieWhpVHFjMjAxMWczWklw?=
 =?utf-8?B?bU9EWW96Zk9GL2I5TkswNU5yOXNuRlJiWnVjVXRNbGVxUmpBSjRCWGNDWVYv?=
 =?utf-8?B?VVU3YmF3ZnlKWkZPUkJwOEcyRlNhS05FUi9rY1VhYXhCRk1ESXBYMXlrOE10?=
 =?utf-8?B?OFUzM0hJOHVjSnljMFk5VG5lcUpnbUppUDN6dkExbVlpdW9kQW55OVRHZGMx?=
 =?utf-8?Q?kxel+u68i2jmgzRnE2NCIPt9u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93178e96-1837-4d37-1ffe-08dc9bffb138
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2024 08:02:47.3270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1E/wrCsaCcgI5CNeE77rL37yWh8vGs6qM1S6gA77EGRhbXO3RkiW/Up8Qs806VSI9k7xxbKb5lRfy4Ti6tk6Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8858

On 7/3/2024 3:27 PM, Dapeng Mi wrote:
> If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are moved in
> __precise_count_loop(). Thus, instructions and branches events can be
> verified against a precise count instead of a rough range.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  x86/pmu.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index d005e376..ffb7b4a4 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -19,6 +19,11 @@
>  #define EXPECTED_INSTR 17
>  #define EXPECTED_BRNCH 5
>  
> +
> +/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
> +#define EXTRA_INSTRNS  (3 + 3)
> +#define LOOP_INSTRNS   (N * 10 + EXTRA_INSTRNS)
> +#define LOOP_BRANCHES  (N)
>  #define LOOP_ASM(_wrmsr)						\
>  	_wrmsr "\n\t"							\
>  	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
> @@ -122,6 +127,24 @@ static inline void loop(u64 cntrs)
>  		__precise_loop(cntrs);
>  }
>  
> +static void adjust_events_range(struct pmu_event *gp_events,
> +				int instruction_idx, int branch_idx)
> +{
> +	/*
> +	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
> +	 * moved in __precise_loop(). Thus, instructions and branches events
> +	 * can be verified against a precise count instead of a rough range.
> +	 */
> +	if (this_cpu_has_perf_global_ctrl()) {

This causes some intermittent failures on AMD processors using PerfMonV2
due to variance in counts. This probably has to do with the way instructions
leading to a VM-Entry or VM-Exit are accounted when counting retired
instructions and branches. Adding the following change makes all the tests
pass again.

diff --git a/x86/pmu.c b/x86/pmu.c
index 0658a1c1..09a34a3f 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -222,7 +222,7 @@ static void adjust_events_range(struct pmu_event *gp_events,
         * moved in __precise_loop(). Thus, instructions and branches events
         * can be verified against a precise count instead of a rough range.
         */
-       if (this_cpu_has_perf_global_ctrl()) {
+       if (pmu.is_intel && this_cpu_has_perf_global_ctrl()) {
                /* instructions event */
                gp_events[instruction_idx].min = LOOP_INSTRNS;
                gp_events[instruction_idx].max = LOOP_INSTRNS;


> +		/* instructions event */
> +		gp_events[instruction_idx].min = LOOP_INSTRNS;
> +		gp_events[instruction_idx].max = LOOP_INSTRNS;
> +		/* branches event */
> +		gp_events[branch_idx].min = LOOP_BRANCHES;
> +		gp_events[branch_idx].max = LOOP_BRANCHES;
> +	}
> +}
> +
>  volatile uint64_t irq_received;
>  
>  static void cnt_overflow(isr_regs_t *regs)
> @@ -823,6 +846,9 @@ static void check_invalid_rdpmc_gp(void)
>  
>  int main(int ac, char **av)
>  {
> +	int instruction_idx;
> +	int branch_idx;
> +
>  	setup_vm();
>  	handle_irq(PMI_VECTOR, cnt_overflow);
>  	buf = malloc(N*64);
> @@ -836,13 +862,18 @@ int main(int ac, char **av)
>  		}
>  		gp_events = (struct pmu_event *)intel_gp_events;
>  		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
> +		instruction_idx = INTEL_INSTRUCTIONS_IDX;
> +		branch_idx = INTEL_BRANCHES_IDX;
>  		report_prefix_push("Intel");
>  		set_ref_cycle_expectations();
>  	} else {
>  		gp_events_size = sizeof(amd_gp_events)/sizeof(amd_gp_events[0]);
>  		gp_events = (struct pmu_event *)amd_gp_events;
> +		instruction_idx = AMD_INSTRUCTIONS_IDX;
> +		branch_idx = AMD_BRANCHES_IDX;
>  		report_prefix_push("AMD");
>  	}
> +	adjust_events_range(gp_events, instruction_idx, branch_idx);
>  
>  	printf("PMU version:         %d\n", pmu.version);
>  	printf("GP counters:         %d\n", pmu.nr_gp_counters);


