Return-Path: <kvm+bounces-33698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C12AC9F054A
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:15:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D42F282652
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 07:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 404C318C018;
	Fri, 13 Dec 2024 07:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gDDsTwZT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B5A1552FC
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 07:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074150; cv=fail; b=YH5y8SI53CDNa8YC9Yr2/u4BX7lMHWW64mnN4kKCBAB/b5lFA7aqYfy5ZuqmuFPxU9AZ1SgGVYgKmZDdN//l1Lv3kWSF4JKHJsKQ7zxdZDIayClYKfGGDMxHMowklvcrMzNsWpg84F4iCP/lSM8Z6LuvUcE1wtfTNEYHkiW6r2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074150; c=relaxed/simple;
	bh=GnP8kAHjjQXv9z4XewKKgw9V11+eQtMGFd00RMXeg8U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XPxzG9hQp5GimztjpFZAHCbELZyvJuzWAxMCrxQS/G4dSqgXl+cCW3Rob474P1FW9ipovNqB0miheDPr8GIqCuc96e0Dd6UI1GTfnmwygDMipW1DFEnDv/VwxIaJoEBgTZkT4ixfACcd642bY977eTb3Mfy50BS/8L8z/9Cvk70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gDDsTwZT; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734074148; x=1765610148;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GnP8kAHjjQXv9z4XewKKgw9V11+eQtMGFd00RMXeg8U=;
  b=gDDsTwZTkG8mRgt2AFP1TYpdbc0YehHOJqIvopwBbrP+eVuHqgc2Fapk
   J/t0TBQXCtuuzUM/uF32xJCOtGm76G9c1OECTRkuO7pVcuB7whSdTY+jN
   TPe5URRoOSNN7H50pBhryRchYz/Jn3MRzgsBCu5WTPN2iaVGsUH8EClAm
   qI0sIP46HBCRjVno26JyTpWry3EB5iOLsGW1eD7m1mi1kYLIZW6W2vp1t
   pO8aFwW5zY5T7oW0SgwitzDQizzTNHkUIS+pu86wgqhXjLl8qaPIyBhnt
   1Pnsncs3oSIalt4ATND+9Lbf+wOK8yILn1VfN5/FrW9mTS25wtKvFTBt/
   g==;
X-CSE-ConnectionGUID: UxSlT+AeTqyq26Vfl9rMBQ==
X-CSE-MsgGUID: ahQTo+RATX+mrCu894GyCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="34660330"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="34660330"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:15:48 -0800
X-CSE-ConnectionGUID: bb0hT2c3SeCA8fqMHnZnDg==
X-CSE-MsgGUID: 6LiYHKDDQ5uVXvwbC7n6QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="96318307"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Dec 2024 23:15:48 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 12 Dec 2024 23:15:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 12 Dec 2024 23:15:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 12 Dec 2024 23:15:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=chgbONWJkXWNTsTu5v7IWxHRMuplAXCDbkP1TqHxvBIIgeA6VzlO+5Zy8rSaAd7pK+/zOLU9FOwrI2Uv0LwWcfOdpXz+0/ELwGcJ4hLIyluNBZy4lQHfSdLqA/NE49D49pougz38CQl1496dIr8FRkqIGjfy0HKVyGYtCGSRvDf7Rl5ZRU5/0qFQeDNlag7KSweckfXhyMOuYg1Zt8UmXF7kPKWqJf+O8wYqehw5b+9YpgCNSZhQ/rypBZWj7lUDVY83WpQhBislJto/y+6C7l7Pr3igqFdIEdWovX5DZEs7peHXVEumjicNVdsE0l7vRhW08ghwfXH925fXZbYf6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5k0tA64QxPLdQPP2CXROcfS7CurMqgooJPdKYiwxvA=;
 b=kSgQeWe0wq9yjtlnUqIRLseLz/oAvvhA69Q72N1SVADYAkpcbOPAFS2g66ECPLXySctn+l9qZFaW5RnpMywnRn2NLQGhu2xQtE0MxufmTexoHmap6k0jrx53KQ/1tk3oOR2gdTdWk6MsxA5c50KYj7fQyvtDlWN1CBdP1RlPT90PkJ3y6IioTPV2LuphLszzbC/i80j4eCyNITU+oAAGUXbKuiNKWLBJdBXaJIvr3TsxLkKgqFJP6IHMLdMDrXY6lJfwlK2eVupAEBlvycNIph7KJsbbTnrF0umfUXdNoSC5/7P3RoFGmK9Ae0eLZ8ga0+4gDr5kAIyky/BliOww2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB8522.namprd11.prod.outlook.com (2603:10b6:806:3b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.18; Fri, 13 Dec
 2024 07:14:56 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8251.008; Fri, 13 Dec 2024
 07:14:56 +0000
Message-ID: <c91ea47c-ca71-4b37-b66c-821c92e3d191@intel.com>
Date: Fri, 13 Dec 2024 15:19:55 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
 <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
 <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
 <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <98229361-52a8-43ef-a803-90a3c7b945a7@intel.com>
 <BN9PR11MB5276E01F29F76F38BE4909828C382@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276E01F29F76F38BE4909828C382@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:54::21) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB8522:EE_
X-MS-Office365-Filtering-Correlation-Id: 59a74241-03e8-4117-85de-08dd1b45d8d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NDBmOXFYZVBaTkhqOFA3My9kRUQwbUVXUWxLem9KWTB6eDVLM1daYUwraGxy?=
 =?utf-8?B?NlZHNDJYMWdoazhrSGlVYU1Ea240Sm5LQ0d1K013dkg1U2prZnJVWDV5Z3V2?=
 =?utf-8?B?OXhHSmU0N0hLYzJ5U1pOd1Z3OGJ0Tm5LN01sWllRSVBqamNhVFVONVRJRUlN?=
 =?utf-8?B?OWtlM1VyUU1BTnpYcXp1ZmVadk9jdmRpK1hxemY0Ry9lcllqZHRsZElzczdP?=
 =?utf-8?B?TlFkODI5KytqU2Uyd3JRanVDOHdSa1pyamhnc2hjb2toUWRVSGRKWXJoaVI4?=
 =?utf-8?B?VzB2SytWb2lNTEQrSUNxV3RUbTRtdVBTWjBwbWdlbkFxM0l3RzZvQ2M3cXow?=
 =?utf-8?B?OXFvKzRZOGhHb3F6Y1F0WXdPVEh6TTUwd1pQTXNpM0pQNzB2MzA4bktxbW1q?=
 =?utf-8?B?Z3BjVDA1cnFaUUdpdnJvazFFaEZSaHRlSzVqRmtKOW1wQjFsRkVqRzVCdnpu?=
 =?utf-8?B?SUptWVFqazhiZE5sVFlwcFhxdjBVZXB4c2FUYnJUNWd4NHpIelBHZ0FHUExv?=
 =?utf-8?B?elBMekNLUHh4MTREenBwSFBObzZGaG56REN3OEVhM0hSdDZHMTRBd2dFTmpC?=
 =?utf-8?B?V1lBMmZqblM4OGozNVNYTk5tV2xqdkorazdRZHZ2S0IrQ2hnNk5ZZzl5Vkh4?=
 =?utf-8?B?SHlHZWY0UkluTGZkSDIyb2tweFlBQnpVdUZqTi9lYUs3VDVkL0ZwWis3ek1m?=
 =?utf-8?B?UzdITTRxbDNyaVVyUTdxYUh5cVFuVHV6UmJhNXdwTXFYRGhXMzA2SUNRdXhm?=
 =?utf-8?B?aXM4WWJ1VlNiVVRvRGo5YnlJV0pkaHUwOXhWaEpZNmRsMTRUWGVFSDNiTm1j?=
 =?utf-8?B?NVVVc2dVUUk2RVdnc0t0VHYzM1pvRVJNTmJKOEpYTlR3Z0crT1YzdjJyTGxU?=
 =?utf-8?B?TzdwLzlxajFlSVk5a1dzWjg5alRqNTI0Ykhkak5CSUtxb09LQ1BDSHZtdDNV?=
 =?utf-8?B?ai9aRlhGREFLN1JHWHVLazAyWGRXZHBIUDFUTStWSEkvbEI0Z0RnSGVNZ3pT?=
 =?utf-8?B?SFZxeHVPelE0ZVZZRUVWbDBzQXRHSnh6V1JHOGZXRXJzS29LakJodEI0cDVl?=
 =?utf-8?B?ZkExU1M3ckJHOHA2MnZ6WWcrWDhGSWc2VWVEcGZVQ2h3cE5kZ0dFbHNTMWJu?=
 =?utf-8?B?dENFQitNYmdBODFGdk1FZVNmcEpwSVN0U1NnNW5RY3Z5dFE2VzRobkU2VzhR?=
 =?utf-8?B?VnAxYmNuWjZna0ovSURTUEFJeW1WT3p1WFlNSW41QXh2elBsZmw4YjdBMDcv?=
 =?utf-8?B?UWNIZU5VOHdydzJXUldqOUpveWkyYWg3c0xTS0ttYXlha3V4VjJuais1WXZX?=
 =?utf-8?B?YjkrNFR5UHJxLytZUU9GL2NsTXNuYm9MK1JoYVZMNW12bGJHVzJ0Y2ZZNEVu?=
 =?utf-8?B?SE8vdEJyaERsM2xpQkg0enhvcHdUYjJEMlZTV0NmQVZ5KzNyWjdubDZ5RGVG?=
 =?utf-8?B?K0JGTndvYWk3K0ZESWh1Skl0SE1tYzBTeUpqR1k0K001MTFkSnJUNnllVUNK?=
 =?utf-8?B?T3BpZ1VRZGp2cXczU2FEU3ZydEkxbG9zMDVYUUEzUjZocHhJUVQ3Kzd2VFoz?=
 =?utf-8?B?cjgxVXZyRy9JRHp2T1JEOVBsbW1yY2MrbGU0YU80ZWhSN0hLTHo5cW05MUU4?=
 =?utf-8?B?QjZBcXdMZGZBVHdkY245UGZvejlYcnl4T0NPSElGNjFwVG5FSTVZaUM5U0dO?=
 =?utf-8?B?NXNPeHRMMEsrdFRnN2lwcThHOWlLNzh5N2tXeTJITGdpN1hWeVRPMDBFSjcw?=
 =?utf-8?B?dG1iSlhmaHVVajFZZkNTWEVNRGY5QmlGWUErNTVrbHlpYXN5QkVsZzAxSkVY?=
 =?utf-8?B?MDluc1hMK3dtWFpyRWpldz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmdkN0pPSStCdnArOGQxeTAvYjhobDdEcURpYTR5WjloRk1JWis4T1JkOHZm?=
 =?utf-8?B?TDVlK2plZVFsQUZEVnFPSVR6dGZzbVpwQjhQNWlqY2JGVWtzeWJtcnRvRGV6?=
 =?utf-8?B?c3d3eXFHalYzdXRIRnVBNmFnc21HMkdNOGNYVVJJMGNENU95K1I0MVJrNm83?=
 =?utf-8?B?N3ZCNVZIMFVrRkx1WllSb1dnU2p4amw5SFdoL2RBNkJyd0w4R1ZWVXpEQi9C?=
 =?utf-8?B?SGxQQUdkeHdER3NiQ1FwYm8xTkJkUEZBeVBRNzVPeUlFR2RqOURqc1pWUlov?=
 =?utf-8?B?MnhCQUFGZGR0aFBKWFQxZGhHR2VGU2JOSlFDRzBRTUtKemkzc2Z2emxXQVJR?=
 =?utf-8?B?SEJaSjZLZ1Frd0VNRnBPM3VTNDFZK01QWElCbE1uQVExQnJZRnpHT0RaKzJX?=
 =?utf-8?B?N2x5b3JoS1FJVzBSUHhMK3llclJDa1gzT0NiTXlkOTVnczdiT3l4dW5GaE9N?=
 =?utf-8?B?c3NrWk9ndlA1Vit3L3MxQm40NHhBMWtkTTc0cExzbk5tR09FWjFSR2h0YkYy?=
 =?utf-8?B?YnRHUEVwSkpvSWk5WEJLRHlxQ1FFQ2psTVpQdTl4MUU0VzFqbmFPWjd0aDdv?=
 =?utf-8?B?bHRoRVVtS1d5OGlKLzVUZ0dXQ1ZITkd2UmpIOUI0Mmp2SDRzMjlFT0pRUUJS?=
 =?utf-8?B?d1hQWmR0dFhtWTJjK1dhT091dE5CdDRELzIwNXkyNlA2UWZHcW10akxnZ1Nm?=
 =?utf-8?B?ZFpqOGp1cTd5SFFwK0xEaWx3MHcyZ1lXSktBaEtaVkpudjBDTGx5QXhsdGZj?=
 =?utf-8?B?Q1plY1BUWnVTL1lRVEFVZEFQdFZ2cW5EUUZTZDQvK0I4cGw0aTB5clM5akNa?=
 =?utf-8?B?WTZQYmRabGErbDhrcWM5b3dpNExsTGhURUlBWW0xUnY4R0ZkbmVwcDhydVlm?=
 =?utf-8?B?RlE3ekMyOUc5emNFLytCS1JPWWRnRmJPem4yMXZQNFBieE9qYzZHNW45NmZK?=
 =?utf-8?B?WjBtQkFhS2lMcjFZZEoyTmV1TXRmV0xoZlpiUi9xSzk3cTRaN0RVSzVBc0d2?=
 =?utf-8?B?aloyVm4wOXNWSjZ4TEZ0b1BmaEJ2M1RpbzFZRjdMbWZUY1R0ZlI1VGZvN0Zk?=
 =?utf-8?B?ZnJBdkx2SS9KRDRlOWZZaTFvRlVjRTRha203dGJPTU9SYXcwT29VVG5PTnZC?=
 =?utf-8?B?Qk5GMi9hL29GRU9VY1VqV05JaTBDQVBxbVA1L1o4ZWhWWjQyNnNjTnBIeVNK?=
 =?utf-8?B?dHMxSnVxSng3UFV3MWJSSjAvQlZwWFQ2YWVTV3ptbzM1WE10dGRkOVQ1QW9j?=
 =?utf-8?B?ZTJreGxvV1B5KzBYNDN4K2drczhKZlR0SktyU1BMdlBkcmJUMHZxcDhaRFZY?=
 =?utf-8?B?bXZuSldrQWQ2bXppNGs0OFAxYVBIc1hLbjVrOW1iT3VFR0YvZWVrVXBPMTZG?=
 =?utf-8?B?KzZHZi9HZkJGV24xWFU1STRMUnJQNFo2THYyZVF3Q1hQQkpBS2RSU2JiWjlF?=
 =?utf-8?B?Z2IremQ2MTUxOVBYNEkwTkZTMk0xL0ttaENYY3UzZEZZVEZMWXp1VDJDVlZX?=
 =?utf-8?B?aThadlVDSzlBMDBNbEZZWU5hSUNpTEJMUE52aHFFNWJnVXd4MGZqUVlLdWtx?=
 =?utf-8?B?ZjdjVnViOFQ5eW52em1UbjJkbCs1bFYzNVNiRzFqTjlwQVY5emhLMDJlVDVL?=
 =?utf-8?B?ZUtDU25pekVHWDdZUFlNWmRkZmdYUEZlS2hydDVKdWpNUDQ4eG4xOFF3Zjc1?=
 =?utf-8?B?L05YdzFaVWVKK3M1N09oMGw0YmpPODZwR2xSY3dqdFY2QjVhd0pJamtRRCsv?=
 =?utf-8?B?MFl4RUdtZXpNS1lqU3lYUmphUWJQZmw4aUM5Q1JhSUZ5TG9oU3NTeHJ2d01q?=
 =?utf-8?B?eDZmYmI2WkV3Yk9pa3FKdzRyYUFNNmNQUWwzdWxEeXpyYXNHYVlnM0pUenN5?=
 =?utf-8?B?b3g2Mjg1R0FqUUZQaUxWYVcvYVF6Q1BvNjY5WHpMVkNZV1BzSHorenpGelRP?=
 =?utf-8?B?Uk9GNjBQaVBvSkpaZEhIRXg2V0ZwMTZQWlZnaEl6NCtMRU9Db01aYVBhQVc4?=
 =?utf-8?B?eXcydTMwcXd5WllkNEJrenVVcFZGV3pVVS8rejQvK0VPSGN1ZXd0NndYTEh2?=
 =?utf-8?B?a1gxTWMyb0F5RWxDbGI5QXlNWGhRNm1WUEt2cHRvTmdrUUtSbnAyMHVZV2hO?=
 =?utf-8?Q?5/UJPiBIH/kft9LRz+tL4L8Gh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a74241-03e8-4117-85de-08dd1b45d8d0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 07:14:56.3961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZCEh9Cx+qhYhC7wuHMAC1CZ2+z21ffLDp6pQDPlCzEp1YBJOV7GEKiDgvUtbBxk4PSIuKdeq6avobYhj135p9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8522
X-OriginatorOrg: intel.com

On 2024/12/13 10:43, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, December 12, 2024 3:13 PM
>>
>> On 2024/12/12 13:51, Tian, Kevin wrote:
>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>> Sent: Thursday, December 12, 2024 11:15 AM
>>>>
>>>> So maybe we should not stick with the initial purpose of ALLOC_PASID flag.
>>>> It actually means selecting V2 page table. But the definition of it allows
>>>> us to consider the nested domains to be pasid-compat as Intel allows it.
>>>> And, a sane userspace running on ARM/AMD will never attach nested
>>>> domain
>>>> to PASIDs. Even it does, the ARM SMMU and AMD iommu driver can fail
>> such
>>>> attempts. In this way, we can enforce the ALLOC_PASID flag for any
>> domains
>>>> used by PASID-capable devices in iommufd. This suits the existing
>>>> ALLOC_PASID definition as well.
>>>
>>> Isn't it what I was suggesting? IOMMUFD just enforces that flag must
>>> be set if a domain will be attached to PASID, and drivers will do
>>> additional restrictions e.g. AMD/ARM allows the flag only on paging
>>> domain while VT-d allows it for any type.
>>
>> A slight difference. :) I think we also need to enforce it for the
>> non-PASID path. If not, the PASID path cannot work according to the
>> ALLOC_PASID definition. But we are on the same page about the additional
>> restrictions in ARM/AMD drivers about the nested domain used on PASIDs.
>> This is supposed to be done in attach phase instead of domain allocation
>> time.
>>
> 
> Here is my full picture:
> 
> At domain allocation the driver should decide whether the setting of
> ALLOC_PASID is compatible to the given domain type.
> 
> If paging and iommu supports pasid then ALLOC_PASID is allowed. This
> applies to all drivers. AMD driver will further select V1 vs. V2 according
> to the flag bit.
> 
> If nesting, AMR/ARM drivers will reject the bit as a CD/PASID table
> cannot be attached to a PASID. Intel driver allows it if pasid is supported
> by iommu.

Following your opinion, I think the enforcement is something like this,
it only checks pasid_compat for the PASID path.

+	if (idev->dev->iommu->max_pasids && pasid != IOMMU_NO_PASID && 
!hwpt->pasid_compat)
+		return -EINVAL;

This means the RID path is not surely be attached to pasid-comapt domain
or not. either iommufd or iommu driver should do across check between the
RID and PASID path. It is failing attaching non-pasid compat domain to RID
if PASID has been attached, and vice versa, attaching PASIDs should be
failed if RID has been attached to non pasid comapt domain. I doubt if this
can be done easily as there is no lock between RID and PASID paths. Maybe
it can still be done by enforcing pasid-comapt for pasid-capable device.
But this may be done in iommu drivers? If still done in iommufd. It would
be like:

+	if (idev->dev->iommu->max_pasids && !hwpt->pasid_compat)
+		return -EINVAL;

If so, ARM/AMD drivers need to allow allocating nested domain with
ALLOC_PASID flag. If not, attaching nested domain to RID would be failed.
That's why I intend to allow it, while let ARM/AMD drivers fail the
attempt of attaching nested domain to PASIDs.

> At attach phase, a domain with ALLOC_PASID can be attached to RID
> of any device no matter the device supports pasid or not. But a domain
> must have ALLOC_PASID set for attaching to a PASID (if the device has
> non-zero max_pasids), enforced by iommufd.


Regards,
Yi Liu

