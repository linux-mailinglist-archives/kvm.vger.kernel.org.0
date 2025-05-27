Return-Path: <kvm+bounces-47757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 599DCAC48B4
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 08:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 159EF179BFF
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 06:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4472D1FBE87;
	Tue, 27 May 2025 06:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="26qTIZR8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA101AA782
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 06:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748329010; cv=fail; b=P+82yEcGEa4353IPB81Z3iNlbrOP1XAY36ItcjgB6O8At4/WHQOts2j2KYkoRWQSe4H9Ty/oH4uKRz+6Luev2xdBgnW20On1Y9onveSFN+sw1uci6/T0sDoTYPaK/b8xpO8zw0wlJr3xlY1BvpCstVp7wyy9mBISA9pC4O3vmhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748329010; c=relaxed/simple;
	bh=maJhFnHtfYOkitkwVeILAFUJKXqvvHJZqWKIntanL/k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lpDCPgEAc2yi4HTR0CoG8TEV+YxcZJH9SIj0OI6W+Ef7k8c4yuyZiNr0f1nzYFEh9+MruqgT5GCOliipIgwP1djCHpI5yblo8gjB/Clz7bM6XI2+8Kpsaf5JUqXwsF+jw4Nm+y81vxZYsBR+X/hcH0qFFP5jm6zDgG32Bu4ejtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=26qTIZR8; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zJjjJvBnCNeIHFfNybUnOde25Zx0j1QHjkIaTnv2afP5zklrn070ukTm8BifiJc2BPJER6XsmaPLysBb0y0+eYEAIr432ARPnr35Mo4Wyj5opWL8Zqsr0G4lOTUNp8PHYcYAN1TMBhvN6adnkyIr5oqiAWws5LHJmW2Nti41OFMXhXEElFKHV18vuptJ/+qFK5qPzMfmkGI9QW4YAJ1kVLWjGcrfWn6arCyB3AQzxf4ZtGk2cHDkdzjMzE0WCvvSccgkqob9qAjLNdyfQzk8MrhKBzmvYwdb2HD0cftoJEttZ2HXkjCcToDBplXhFlEUe6WI8BsRGV7xQ+vafkDBUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZnhkSXswu0GTWmjjModNh7vTl5d/zmdDcLB3scCHfAc=;
 b=PIKta1RqEFOmTbXulBCFW2+1mq9zuPA+eIBczTd7akSq4U2b97jAwKxUoOJPfqkicr1otVcjJXF9q+CN9t1BvTbNuMvPE354mgdTEdEP6i0h4dCZrwj6NPYo2M5eVNgjWdSgYzgabk+cr0Dy2Kj1xf+T4XXgx1qRCXzygZB0egQgKKss9p9aIuVswcnxKr6FLsQUaMYKCFLGYUeholSvU9fTKE9jV1gcX7A9m4PRrD4K8iOQhNSJMF8V5mCV6LYj7JXdzqszyF3TjZ4aFt2DfLmsCgDt6Hvgydbl+v5THV8SRbakHlwpYVTy/s8HQdlTtTpQnKctud6OVl3GMgimjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZnhkSXswu0GTWmjjModNh7vTl5d/zmdDcLB3scCHfAc=;
 b=26qTIZR8GmxASJZN5sV4EPE99vQvpn8GH8U67QpWiVahZaacqZDoSqGwU74N7ceY84YX429G2PD/xGILugiP53NEgHjLI7jsQWoYVYw4Ojtb2tPasEti+JPiRbWmvrUedv9hWdHz2qIS9NIDqUSQsdWmBqP51afyFpk7Iz6WYko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB6752.namprd12.prod.outlook.com (2603:10b6:806:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Tue, 27 May
 2025 06:56:45 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 06:56:44 +0000
Message-ID: <001c8e69-4a12-416a-8c47-4112cd18ff06@amd.com>
Date: Tue, 27 May 2025 16:56:36 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v5 03/10] memory: Unify the definiton of
 ReplayRamPopulate() and ReplayRamDiscard()
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-4-chenyi.qiang@intel.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250520102856.132417-4-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0087.ausprd01.prod.outlook.com
 (2603:10c6:10:110::20) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB6752:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e33b9fa-783d-4317-e570-08dd9ceba441
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RENoc2UrbTBoM1VNNW9xUUk0WlB4cG40dHVyOFpFQjhTYmZ1VVhlVHdkWE9Z?=
 =?utf-8?B?UzVJSmVTWWw0aDRKUjM0RUhXcWpwTkJRUWl0UDlXYmdDS2s3S1RPVXlpd2R0?=
 =?utf-8?B?enNKM1VHalBRbmpTRVU3UmNUTS9xc1Q2Q1NvdGUzT0phaTNjZzNXT1BVdnQy?=
 =?utf-8?B?YU0xOG9ENThPUjA2ckFteXJmZTNzU1ExVFZ3cGwzN1lxQUpFRFJ4aExpNHhV?=
 =?utf-8?B?OVVZcS9jeVFnbWJzVGN2M3VIR3ZkdHF5NFRoK0VjLzJRazRndEZzRUt6Vkgr?=
 =?utf-8?B?eWlJcW5yL2x4UzNTSDlSbStEaldad0VvV3p4WUtoQ2thOWowSVdJdVAxWlJq?=
 =?utf-8?B?VE4yd0pGdEdZOGUxc0VZTGtkbTFlMHVVR0dLMG03MzR6QlM1WTlXQ3plTkNP?=
 =?utf-8?B?SFd6blQ3VVUzK3VzeUtsQXdjai8rdjV4ZU50S3VFdHNHbHd5eHp5N1F1WW1K?=
 =?utf-8?B?MzFTQlRxUG1nS2FJcUhOYmJuTEx5YWZmZWlkNm5WSlJWMjI3OS93SXJpVENx?=
 =?utf-8?B?Q2dCbzFRL3BDdkVkektiSVVkNFc1NmxLY3hQYTZpTXNPaEgyTzVZcDF1TWtl?=
 =?utf-8?B?eWRGR0Z2VEYrMFFYOHhFZzFLTytYSkhWT3ozN2pvbGZ6WE9RYWZZeHkxS09y?=
 =?utf-8?B?aDRYNjRGeHY2bzRlcldSL3BhVDdPVTR1SDcvaDhadjFYYnB5SmpycEUyV0U0?=
 =?utf-8?B?WW1lLzQ3N2dTQjNuVURvNWxFeFdpc3o5cjc5a3JSbDhTZmxVQURoN09WVXFO?=
 =?utf-8?B?QkxidkJmS0dzL1ptSkhjWXBCYzdLK0pVWFJMbDVKb1pWWmUxUW1PczZtaVdX?=
 =?utf-8?B?VDcyS3FTUVB1Zk5ERWE1OSszeXNwblJ3V2pCakdSZlNoRWFzT25yYzczbXZH?=
 =?utf-8?B?eFZ2eVNWY1R5ajk5MXhVMnpydnVBVUhlQWk5bDA2eENQUnBVNXduRFlQNmpY?=
 =?utf-8?B?MHFxamxiUFVTTGIwUkRwMVE5aFJzd3pFeDFOTk05NUt0aUFidVlCMWE0THFy?=
 =?utf-8?B?SlV0V1h4ZDlyQnFSVE5zWlQ5THAxN3I1dk9KSHowNDZDQ3M2ejlxcG13ck1G?=
 =?utf-8?B?aHRnbCtyZm5JM2htc2pndWZnMUE3V2tUVTd1WkhjdEp2STNWTU03MXl3WW4x?=
 =?utf-8?B?QWoyVjN3ZS90RTUza3BaODVzZUlhTFRCUzVKYWF0WWdiV3gzajBNbTZyMVBz?=
 =?utf-8?B?OC9Yc0hqcGwvZXFtSFkxSmgxeHNXcGcwS2NwVjBXdHlMNG4yM0l4NU5XK1Y3?=
 =?utf-8?B?cC9jb2VuTkVIbFhXSWRPemtXY3hUUCt4c1ZZTW5vbGw4c1FBRW1JL2tVMi9P?=
 =?utf-8?B?Z3BTK2pQbkdZK1JodE5hc2hnQnMwYnU4SldJUERNb1NnMExzbGVLcDVBK3FY?=
 =?utf-8?B?Y29kNDJLSWJLSExrbU54WHlOejNHOG8rbmVoeEQ5YjNhdnRIVTBuTWMwWDlP?=
 =?utf-8?B?UkJBMFpmUzZlSzcraHRxdGpPTXZBOGExck1sMEd1dnp3bXJUdFhzYXdBaEUw?=
 =?utf-8?B?aUJzQ0oxdDhOWXZtMGN6cXh0Qm52OEZSV2JqcnJKa25xMzdnc2RRbmRrVndr?=
 =?utf-8?B?N1lEWTlpNjlhR1hiNHFrb0t5clRhcjdyWGFCcSs0ekhqK1dFYTZ6RTg0ZTlz?=
 =?utf-8?B?YXVLZWRYWUVwN1hsOUcweExzeXd0bVNrYnp0NzBHT0pSeGd0RU1heGlYWnA3?=
 =?utf-8?B?MkJzdmg5cTBjSmpNK1BxRisvNEo4Z2ZuNktXdWZseTZZZ2VYVWEveTRQSnVZ?=
 =?utf-8?B?Z0MvamtIMzd0bzlUM2h0Wi9ObUNDZnJFbURxY3lvSXVpV3BERmtFKzhiemVr?=
 =?utf-8?B?TWdUd3Vlak9ncjZsbWVPdm42THVFSEkvN1hMdFJMVmJyQ0x4MEtBVkZxSkp3?=
 =?utf-8?B?SHpJYkJac1oyY1EwYzVQQWx1M0JXL0FrRzZSN2ZaYk9kVnJDR3NxSHNOME95?=
 =?utf-8?Q?xh9tRiLYIhU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3NnVGRMMXpXMVVzN0p1UXJ0YlZLOUg1YUhUbitoOTkzeXR3L3haT2dTcHIv?=
 =?utf-8?B?N0xZUnlNRUk1b0tDN1RKcG9kY2plY1lvWk42SlVWZHp5bUl2dU4xdDhUNTVP?=
 =?utf-8?B?SE5DeXpxY29ZUXNvdy9KNTRQMzhNUzVLYzhWNElJM2NocUZhYkZnekM2dFVh?=
 =?utf-8?B?bGNUTHJiQkx0MDhQOWlYSko1d3VPL1hsK1M3cXQvaXhCeVNMUzhKWkhSTUR6?=
 =?utf-8?B?V0ROcmxMYnV5bWRJcE9Ob3JXZVdac0hWZllhQTI5RVd5cVU4blFqVlZkWnh1?=
 =?utf-8?B?bGY4WlIweWMxb0lXSE1STGFMYzRxTnVRQk5wM0FGZW5tNnN2UzNsZjVPdk4x?=
 =?utf-8?B?c2FPai9kVzlXZjJLQlF2bEtsTUpMSjRQZEpiTHF6eFpDRnZUZE1kcUdZeUFz?=
 =?utf-8?B?SHArWUJjSG1lUmEyNndVK2ZoWTNIWU9sbG0rSHBFLzZ2cjBrYWVwVDRQT1lP?=
 =?utf-8?B?Y1d2RHRXNnB4T2tsWXFJeXdEalNYRjVUUjBJYktoMGN5dHYyU092RHZsck1o?=
 =?utf-8?B?RVJHMktLZGxYUGN2MGNZODNuaEZrWHp0Q05XV05XN1hwT2JmdFFPN3lVSVlZ?=
 =?utf-8?B?U3hKK0xjeitMdW9Mem5hSXZ2aTI0WXVUeE92bmtzNThDeEtCc2ZnSlYvWnJD?=
 =?utf-8?B?WThFSjkvUHNoNmhVU1huclRzWml1V2FQcWxhOWdvYmZTRjBGUFA5VTh5SDl0?=
 =?utf-8?B?QTZrUTJsREFaQ0lZeE5sQ3BtR3hVbkNIcG9PVnNQWDJuWkNpdDNLT3VvL1gr?=
 =?utf-8?B?d1RDMjdRQlNPN0FEdlRuSGkvbFordHRsY2hlNHRDM29YOVJzWGswdSsrbWVv?=
 =?utf-8?B?VXE3R2lLU0NMOHZaSEhnOEU3S281VmlLQnhkUlFBMjVCNWVhbzl2SjZSNC8y?=
 =?utf-8?B?a1lrNDRydHdFUzBqeUFZbXNhcTRSVkE3U1pPaWxGZ1RZYU9ucjFRbTRUL1ZD?=
 =?utf-8?B?OWtvSWJ5bUFjdzQxeG9Bb3ZhdW53cGRwTjY2eE5yQ1g4MVhUanlBS25zbmE3?=
 =?utf-8?B?bmwyVi93eFJOc3o5TWZyN0M5QXBEUTFKSjl1TDN0RmpCc2xYb1g4Z3B2aXV4?=
 =?utf-8?B?TGRzbXZJaUpkUEJUenlNMjRDbzBucnZ4YmJKWHFGV21BTXR0emdRSXBPT1pn?=
 =?utf-8?B?NU40dGRhWGQxQytMT1B1TTZYUjlFM1lOYUxBR0h4RXcyRGJRTGszL3Q3bVNO?=
 =?utf-8?B?V0cySXluamZaS3ZSWG4rcHF0U24rMU40WXpJRzJrSEZUN0N5SDl1aXhFUjgw?=
 =?utf-8?B?TitKZkJ5ZFNSeDVnazR3bjNhTVRHejI0K3ozUUNEVmtUM244QnBCZFJtcFl6?=
 =?utf-8?B?Qk9YVEpDNHloenFiQmZGRnNEeUtzN1F4bENJQzI2WnppZWtOVy9ZMmJncGVU?=
 =?utf-8?B?dm1mVEg3OVduelRheGlmd0tHeEdXREh2d09QanJqNmI5NnFsY3hqdy9qTnZP?=
 =?utf-8?B?Q0t3bkRuUlRVWThhd01vRm5kZUFFSEZsUmJCNm1tWWVja1BBaFcyOUpIWVY2?=
 =?utf-8?B?K1ZGR2ZXMTl4ay9sY1BmR1JMVW5SaWgxRDhBLytneEV3SXhMS3dtc1NEdjBZ?=
 =?utf-8?B?cDlEaEpzVndsMGFOOFJtaTNkS25mcXBOeHFvaUtLT0lUMzRCQlRPR3JtcTVv?=
 =?utf-8?B?YzdBMTMwdUE4aVFBUVlnRmltejUzdFlIaHJlSmdtSTJQeS9kaFEwZFVyTW1R?=
 =?utf-8?B?K1RucFcyWCtUcmpETWN1aVdnMHVSRW5wcGxOQkdKMzJUWHh5ck80dUdEVzZV?=
 =?utf-8?B?RHI3a0dWMmNsN1RGUi9oWUFGaVN0eXFmd1NOemxmd2ozL1lXTEVqc2RCUUJC?=
 =?utf-8?B?S0lQYitvUWllVXk5NmlaaGNlMUpLMmlKOVN5dmtjZ3FoaU5NeGxlcGo1eUla?=
 =?utf-8?B?V2puc1JGaEh5NS80SDlkYXRtdUlaUkMrL3pVWmlZQjhIblFXN3JPQkxBRzZw?=
 =?utf-8?B?NWwvOXI3MHJia2s0YUswUzRzWmlGeEIwWjB6aUV2RFVqTHBDMmJDYVRVVVNz?=
 =?utf-8?B?b1NyL1RTTllvdjc4d0RIM21Ka21Ic0sxN3M4Sms1OGdKbWtHL25yTXptaGFw?=
 =?utf-8?B?TGl5WUNuWGlHakdwWjV0S2trZHlTcndCRnpxQ1JjT1lKNmdJWjFQYzlZUEhz?=
 =?utf-8?Q?bxM5g7qVzcbXZR4k5ZdIYvixl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e33b9fa-783d-4317-e570-08dd9ceba441
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 06:56:44.8024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dvAbO00u375MhmE/wyLEvmQicvjCgRDcBN+XgUAR9X4zo6bFYE3fs/rt+PT33mYti9EcV0JjTamFzrh4FYDB2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6752



On 20/5/25 20:28, Chenyi Qiang wrote:
> Update ReplayRamDiscard() function to return the result and unify the
> ReplayRamPopulate() and ReplayRamDiscard() to ReplayRamDiscardState() at
> the same time due to their identical definitions. This unification
> simplifies related structures, such as VirtIOMEMReplayData, which makes
> it cleaner.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

Reviewed-by: Alexey Kardashevskiy <aik@amd.com>

> ---
> Changes in v5:
>      - Rename ReplayRamStateChange to ReplayRamDiscardState (David)
>      - return data->fn(s, data->opaque) instead of 0 in
>        virtio_mem_rdm_replay_discarded_cb(). (Alexey)
> 
> Changes in v4:
>      - Modify the commit message. We won't use Replay() operation when
>        doing the attribute change like v3.
> 
> Changes in v3:
>      - Newly added.
> ---
>   hw/virtio/virtio-mem.c  | 21 ++++++++++-----------
>   include/system/memory.h | 36 +++++++++++++++++++-----------------
>   migration/ram.c         |  5 +++--
>   system/memory.c         | 12 ++++++------
>   4 files changed, 38 insertions(+), 36 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 2e491e8c44..c46f6f9c3e 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -1732,7 +1732,7 @@ static bool virtio_mem_rdm_is_populated(const RamDiscardManager *rdm,
>   }
>   
>   struct VirtIOMEMReplayData {
> -    void *fn;
> +    ReplayRamDiscardState fn;
>       void *opaque;
>   };
>   
> @@ -1740,12 +1740,12 @@ static int virtio_mem_rdm_replay_populated_cb(MemoryRegionSection *s, void *arg)
>   {
>       struct VirtIOMEMReplayData *data = arg;
>   
> -    return ((ReplayRamPopulate)data->fn)(s, data->opaque);
> +    return data->fn(s, data->opaque);
>   }
>   
>   static int virtio_mem_rdm_replay_populated(const RamDiscardManager *rdm,
>                                              MemoryRegionSection *s,
> -                                           ReplayRamPopulate replay_fn,
> +                                           ReplayRamDiscardState replay_fn,
>                                              void *opaque)
>   {
>       const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
> @@ -1764,14 +1764,13 @@ static int virtio_mem_rdm_replay_discarded_cb(MemoryRegionSection *s,
>   {
>       struct VirtIOMEMReplayData *data = arg;
>   
> -    ((ReplayRamDiscard)data->fn)(s, data->opaque);
> -    return 0;
> +    return data->fn(s, data->opaque);
>   }
>   
> -static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
> -                                            MemoryRegionSection *s,
> -                                            ReplayRamDiscard replay_fn,
> -                                            void *opaque)
> +static int virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
> +                                           MemoryRegionSection *s,
> +                                           ReplayRamDiscardState replay_fn,
> +                                           void *opaque)
>   {
>       const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
>       struct VirtIOMEMReplayData data = {
> @@ -1780,8 +1779,8 @@ static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
>       };
>   
>       g_assert(s->mr == &vmem->memdev->mr);
> -    virtio_mem_for_each_unplugged_section(vmem, s, &data,
> -                                          virtio_mem_rdm_replay_discarded_cb);
> +    return virtio_mem_for_each_unplugged_section(vmem, s, &data,
> +                                                 virtio_mem_rdm_replay_discarded_cb);
>   }
>   
>   static void virtio_mem_rdm_register_listener(RamDiscardManager *rdm,
> diff --git a/include/system/memory.h b/include/system/memory.h
> index 896948deb1..83b28551c4 100644
> --- a/include/system/memory.h
> +++ b/include/system/memory.h
> @@ -575,8 +575,8 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
>       rdl->double_discard_supported = double_discard_supported;
>   }
>   
> -typedef int (*ReplayRamPopulate)(MemoryRegionSection *section, void *opaque);
> -typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, void *opaque);
> +typedef int (*ReplayRamDiscardState)(MemoryRegionSection *section,
> +                                     void *opaque);
>   
>   /*
>    * RamDiscardManagerClass:
> @@ -650,36 +650,38 @@ struct RamDiscardManagerClass {
>       /**
>        * @replay_populated:
>        *
> -     * Call the #ReplayRamPopulate callback for all populated parts within the
> -     * #MemoryRegionSection via the #RamDiscardManager.
> +     * Call the #ReplayRamDiscardState callback for all populated parts within
> +     * the #MemoryRegionSection via the #RamDiscardManager.
>        *
>        * In case any call fails, no further calls are made.
>        *
>        * @rdm: the #RamDiscardManager
>        * @section: the #MemoryRegionSection
> -     * @replay_fn: the #ReplayRamPopulate callback
> +     * @replay_fn: the #ReplayRamDiscardState callback
>        * @opaque: pointer to forward to the callback
>        *
>        * Returns 0 on success, or a negative error if any notification failed.
>        */
>       int (*replay_populated)(const RamDiscardManager *rdm,
>                               MemoryRegionSection *section,
> -                            ReplayRamPopulate replay_fn, void *opaque);
> +                            ReplayRamDiscardState replay_fn, void *opaque);
>   
>       /**
>        * @replay_discarded:
>        *
> -     * Call the #ReplayRamDiscard callback for all discarded parts within the
> -     * #MemoryRegionSection via the #RamDiscardManager.
> +     * Call the #ReplayRamDiscardState callback for all discarded parts within
> +     * the #MemoryRegionSection via the #RamDiscardManager.
>        *
>        * @rdm: the #RamDiscardManager
>        * @section: the #MemoryRegionSection
> -     * @replay_fn: the #ReplayRamDiscard callback
> +     * @replay_fn: the #ReplayRamDiscardState callback
>        * @opaque: pointer to forward to the callback
> +     *
> +     * Returns 0 on success, or a negative error if any notification failed.
>        */
> -    void (*replay_discarded)(const RamDiscardManager *rdm,
> -                             MemoryRegionSection *section,
> -                             ReplayRamDiscard replay_fn, void *opaque);
> +    int (*replay_discarded)(const RamDiscardManager *rdm,
> +                            MemoryRegionSection *section,
> +                            ReplayRamDiscardState replay_fn, void *opaque);
>   
>       /**
>        * @register_listener:
> @@ -722,13 +724,13 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
>   
>   int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>                                            MemoryRegionSection *section,
> -                                         ReplayRamPopulate replay_fn,
> +                                         ReplayRamDiscardState replay_fn,
>                                            void *opaque);
>   
> -void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> -                                          MemoryRegionSection *section,
> -                                          ReplayRamDiscard replay_fn,
> -                                          void *opaque);
> +int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> +                                         MemoryRegionSection *section,
> +                                         ReplayRamDiscardState replay_fn,
> +                                         void *opaque);
>   
>   void ram_discard_manager_register_listener(RamDiscardManager *rdm,
>                                              RamDiscardListener *rdl,
> diff --git a/migration/ram.c b/migration/ram.c
> index e12913b43e..c004f37060 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -848,8 +848,8 @@ static inline bool migration_bitmap_clear_dirty(RAMState *rs,
>       return ret;
>   }
>   
> -static void dirty_bitmap_clear_section(MemoryRegionSection *section,
> -                                       void *opaque)
> +static int dirty_bitmap_clear_section(MemoryRegionSection *section,
> +                                      void *opaque)
>   {
>       const hwaddr offset = section->offset_within_region;
>       const hwaddr size = int128_get64(section->size);
> @@ -868,6 +868,7 @@ static void dirty_bitmap_clear_section(MemoryRegionSection *section,
>       }
>       *cleared_bits += bitmap_count_one_with_offset(rb->bmap, start, npages);
>       bitmap_clear(rb->bmap, start, npages);
> +    return 0;
>   }
>   
>   /*
> diff --git a/system/memory.c b/system/memory.c
> index b45b508dce..de45fbdd3f 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2138,7 +2138,7 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
>   
>   int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>                                            MemoryRegionSection *section,
> -                                         ReplayRamPopulate replay_fn,
> +                                         ReplayRamDiscardState replay_fn,
>                                            void *opaque)
>   {
>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
> @@ -2147,15 +2147,15 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>       return rdmc->replay_populated(rdm, section, replay_fn, opaque);
>   }
>   
> -void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> -                                          MemoryRegionSection *section,
> -                                          ReplayRamDiscard replay_fn,
> -                                          void *opaque)
> +int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> +                                         MemoryRegionSection *section,
> +                                         ReplayRamDiscardState replay_fn,
> +                                         void *opaque)
>   {
>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
>   
>       g_assert(rdmc->replay_discarded);
> -    rdmc->replay_discarded(rdm, section, replay_fn, opaque);
> +    return rdmc->replay_discarded(rdm, section, replay_fn, opaque);
>   }
>   
>   void ram_discard_manager_register_listener(RamDiscardManager *rdm,

-- 
Alexey


