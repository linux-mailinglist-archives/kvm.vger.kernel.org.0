Return-Path: <kvm+bounces-33541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6BA9EDDD8
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 04:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94A53281161
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 03:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06161442F4;
	Thu, 12 Dec 2024 03:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AtI0xlvW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4DE7E765
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 03:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733973033; cv=fail; b=ml+bsOXPmSv0gqgQI3Rr1kSuFvDIUgJWdg7Dd7ChRiKc/VzAGS1C+yk2raNUi/scSQlvhb7/Uwguv30wI0iD3fARcTrJ6tWLCv6zbMMbIvKJ13T3gWTyKF/M5rflQdxb+SEDuGPCDZYCtiWcrqK2YZG7WPBOiwylOHK+X6fs/Vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733973033; c=relaxed/simple;
	bh=bB0Vu79aiKCnJUKVrDToy3JqxFoKVLrH+OCpDx18z4M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IYM0J9l8HA4q7DdGjR9N1Eb6lxttIwnpzb0mSbIE8aHOWawjH4hZqPwzgjDb1IqCt5+o35/Er2OikLQoeA7Y//oAIx0duwNkRM6Je6r/U5+/ljByebApeQuJRLYjO6107MaMuOATeGDcQQhq+Sg1yc7+m+CHsJUNJwHK/QAeRDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AtI0xlvW; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733973031; x=1765509031;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bB0Vu79aiKCnJUKVrDToy3JqxFoKVLrH+OCpDx18z4M=;
  b=AtI0xlvWhYVgodXWAnAo2zCUO8RJGaHgOt2MHALzzzayVA0vAYxUAl+e
   LVWl4whZVOkDm7sa768mXJZhNxrY2YLXqGpRIJiCUaL5hDqLZEkFvewfg
   mzXJfe0b683uFqmnHa5Siax4z5ysw+Qj+OTAaCRvM2/irxZ+SK+bZvDse
   DNORNufnmDJ1tvzbwICKHxaocXqfy4A1M4BP6TLkzYNTiX9hNyFfGyygT
   73sdLx35pxt/2nOsVcsxKYd2dHOBfkCrlqnrR1bHCrEFSCY0jKq4lSF7g
   d+c7dcWgCsRzm5Yx9W3FAiygkWQcRDnONKHaNo3/7BsUJofSl+MRWfKpC
   A==;
X-CSE-ConnectionGUID: I/C0QW/uSviQUlHDZ8dE7A==
X-CSE-MsgGUID: XMaplvPzQZyAx7Y4hJOV3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="45387574"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="45387574"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 19:10:31 -0800
X-CSE-ConnectionGUID: PjwvlFlMT+SDWdh1FHLIMA==
X-CSE-MsgGUID: CIVrOOOtStqfdRDVY2uXQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="95838292"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Dec 2024 19:10:30 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Dec 2024 19:10:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Dec 2024 19:10:29 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Dec 2024 19:10:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j6dIgAlG0IbqSLReUwuFvy57v9Q6Ux528Y7/FIN2L2KjMgW11pRpu+fmrG/wLvI0pYt7zC3IvuHmFmzvoPJrsHsglxEYyfIB6mxt+1iP0ISiJ4odJo11TZ9TKsaN6o1mg40mNJ1VOaeKVSY+xlaPPj8tHseSp1uWuGOt2Zu9vZvV/nyrsJe7N0DtMh7NNhhspK7Tp2q4Yy3Q6hroCpzTDltGK7pnT4x8iKaw55h4bP4l/zyky6pq9J6C0kuzKgqxKq805Vianb/WBCOVYedRUdwnvNZA1WRvovTzBUX+ArYUEWPrCP6maY/uN8q+n0GnG4qnqt3vjB3DVpQIPBONlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83KqK79kM/TZKtv/mDk5LCCZDz/uhNFeZaagdHk1Zpg=;
 b=Cj+MKmBGMZh9dwd9ru3jjS0NIGP00tS0RCG9KDIqalCyHyY4Q9/cDWy9E+b6HfQIA9RW+wY/B8FaF0s93Z5if/qIlNYZvSAk/UZrHcwaSpIsw2EhfZFZ+4Y4a88/aeX82NwaZNAAHdLbX/3ujMTRmrR2qN+LCecAIRz5VrvzqDeLVGXnsIXe0oEXr/RmtJXnYmuuCHfnf6dJeZ4mXtf5SzxCo5yGRoMhZJoh37lIDJURuOV5rh7sMyoYuB0HsM6erS+5K91S3m6S+MT5F39/po4sSvfsS0RDF8b6x9Kbu2O9T636IfV6qyJKDol/D3iTkkk3BGx/HYClIPI3MlhFOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB8838.namprd11.prod.outlook.com (2603:10b6:806:46b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.16; Thu, 12 Dec
 2024 03:10:26 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8251.008; Thu, 12 Dec 2024
 03:10:26 +0000
Message-ID: <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
Date: Thu, 12 Dec 2024 11:15:24 +0800
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
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0168.apcprd04.prod.outlook.com (2603:1096:4::30)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB8838:EE_
X-MS-Office365-Filtering-Correlation-Id: c5d055e2-2791-4f3e-60e9-08dd1a5a863d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OG94OExPY094cTAwdW5CZ01YYlcvR0JRVHdJV2hwd1YwY3B4Y2tZTy9xZW5t?=
 =?utf-8?B?MUFDY1VkNzlYK3FuM2ZLc3JXTmJFQll3KzlrR0JSeFFaa2laK0pzRXhSMnVV?=
 =?utf-8?B?RzAwa0xrSHNPMzhCUXpiTzZQZll3ZmNNcDI2czlVYlZFS09oTk0rVlBkdFUz?=
 =?utf-8?B?OUJEd2lhSzNJMUh3cGRsbmQxVHN0a3h2a09RRnBqV2E3MHJvWlc5WFlYVS9R?=
 =?utf-8?B?SjFEOTZRcEFKeG1xeTIrU205TDJWSGdjZW02dTA2bUpJMHlBRkhkTlNQNzVC?=
 =?utf-8?B?K3VOcjI0V3F0MVlsK2dIZlEvd3hBTm1uSG1aV2FDQXZLd21yZnNwTkE5VGNX?=
 =?utf-8?B?RHoreXhxZlNTMmNBN1NwS3VDbVJxY2JQS3J5SCtRTEExakhISEJTK241UVpz?=
 =?utf-8?B?d0U0dDVWYVIzZUdnY3ZpRDZsR1BlWGFtQURsRXFNTktzRnVwNEgvUWtsVEJx?=
 =?utf-8?B?c1ZCNWgxcVQrVE5pVnZDbHZ0dS91UkdXTVVRUGZRUXF6RWdTNmxJZ0JuZHZr?=
 =?utf-8?B?cS9HNlFoVkkxa3JYWHBUNnBTK3ZENVlTOWpvN2Fvd2JHQ2pnVms2bkdxVFlQ?=
 =?utf-8?B?RytETXY0YkFUNHpoVWd4Nm5md3VKRmE0UkpYem1ZVEZablpqOHAvSkVkS1pa?=
 =?utf-8?B?eTVrd29aZGhVY2RHai9WQzdvdmxReGpwcm5jcnhscDMyS0NjUkFqb2xQQkRK?=
 =?utf-8?B?ZkxQU2kwWmw3clFkdUdRRndGUDVrT1RRRXk0VHM1bTFMTkdwY2xQcGsxVVhC?=
 =?utf-8?B?UE40a2pVbWZvSXczZGc5MTM1S2xDT2d0ZTg0VlROY0NIejh2UVk2RlNyUFI4?=
 =?utf-8?B?MUFvWDVKdXowK1JUMnJ2dW9JRjZyNjMzVTVvVDZiaUtGbEQ2TDVuNFlIZ0JH?=
 =?utf-8?B?SDBQa0xaREIwQXlLdnFxY3F2dWJGR1hmVmwzVFlua3dHTjdtSXA1azQwS3Jq?=
 =?utf-8?B?UW5BdkJEUFFBT2NrYk80WTZxMTA4eElaOHNIekVMNWMvVGtmZ1NyUGZURjlE?=
 =?utf-8?B?SDFJYlJzalNkYkFTeHVUZS9QS0NoT2dZbXJ1QUtSK2dGMGRXaTY1VlBsdEdo?=
 =?utf-8?B?a1p2bmhURC9qcEtidWFWMTQ1Q2lLeUw0Ykd4aTBFb3daVGIvSmptcVdZZG9L?=
 =?utf-8?B?SWNqWi9DaXZzdmhEeWtJbzZUSEZ2MDhqdWFmRENHbkhxeHd4YmpxcFlnSlVz?=
 =?utf-8?B?bnN0anFOUjVEVU5HRWVPclRKbmllM0N2RW1Ha0hmZTliTFE5UFByUDVYQllt?=
 =?utf-8?B?OGxVSXNZZHh3TG9QWmlSRFZscWdpQk1ETXRWSktscXBxYXFFblVIVzVoNExY?=
 =?utf-8?B?MVc5MktzZGg5eDJsS0cwQnczTEpqM3J1TEIrY1ZvcnE1ZU5XQ3RXM1VWYlRy?=
 =?utf-8?B?c3VUWXBCZnhIWERkVms0MHJsYXpIMVYzWlk0TjIyWndKbkNWLzUxV1RpYndX?=
 =?utf-8?B?S0JsL1h2U1JpT0U3ZlowTk1aZVJuQ3I2SHpGS0NIMjV0dzNzVzBMRytUb2Jz?=
 =?utf-8?B?S2RBdDZoMHFKZlZvTzRPOGE2cWdQSkFrVkxPcE1BdStEblY1alJqdE9pVXYy?=
 =?utf-8?B?NmNNa3NpVC8zZXE3TDhQNjlzQWVKUlNPZjBBSEFxOVlyNjdqMGF4UzBEUWFE?=
 =?utf-8?B?VGpMQ004cDRaQVdIanpTU25veHpQbkhiZUpGTFZOb2o1SHBMVFRYRVBnUlNO?=
 =?utf-8?B?bVI4MVR0aThvTEhzbHppYUV5M1ZZTkhLZW5LMHYxSXhmelRwdWVpa2paNjRU?=
 =?utf-8?B?WnczbmNkblNsbXA5S1UxYzNSMEJOSlY1UStHbmN3alNLdDdBS1gyZFpkS2tN?=
 =?utf-8?B?eHJGMGRtRUI1TkphZGxwZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3l6WnQyZTlUV2UvR3djdmJJTUZiNmFEYXRlZnIxM09GeUM5SXczNDFNV2gv?=
 =?utf-8?B?RnRDMUx4VlhjMjFlWmFpR2d2R1Q2WEg2TFJLa3RoeWhMSkZaZUs1Yy9rWHhW?=
 =?utf-8?B?Z01UbEpkL3E5OEpNdjhvdmFycEpKWWd2NWFQWEdzNnhqN2pNNUlzb2xjYlF5?=
 =?utf-8?B?NnFEMWlPdHkxY1pqRU5FWmEzQXRvdlcwdjlaanV0UFA0aHFlVGFzOXRkdHYx?=
 =?utf-8?B?S0tXcnduWFV5cnBWbzg4Mkc5ZHE5VGhqNnQxTnh5aUphcXA5S0FJa1ZlQzNm?=
 =?utf-8?B?R3hRcUFjakpBZzA4TGo2OFNQaGsxQnE0SC9mQnFSZm90aGhYbnMranlTajFu?=
 =?utf-8?B?cC9LVU5wdHkxcmd2NUQ3K3ZSajNiZGgrUE9nbElKWXNtVWg4MERBUnE1Q2pi?=
 =?utf-8?B?K29UbUdJZ2VZWHorQkdsd2ppRFdINFNlUERoUGF6L1BETTJHWWl4b1JuTVdn?=
 =?utf-8?B?aUhrM1RTcUN5bEU3SjBTTVRVMUZQLzVxOHlXSXVFaGpuS0JSbFllMEU4dDNm?=
 =?utf-8?B?anZGOWdKMFYvQWdrN1FLSjgyaXQxb0VoV29jYkU4YmZXNWF6N2VQK2JFKzh4?=
 =?utf-8?B?NFNIMmh1Z1h6OXJRUnRBTHJjUUlPaHZ0Y09rOWtGRUp6TVhlemRZRjJuNHA5?=
 =?utf-8?B?MVNQZ1BHYzBTdmtKWTd1ZW4xQUk4cUhoZTlzeVIvLzFVVFVxbFhlL2lFeHhR?=
 =?utf-8?B?cThKanIzODlocHZIVDZWZXZBcmVvUkw1M1E2YkJ5d1RGUVNGWGVmYTIyWndC?=
 =?utf-8?B?bEEvbHVmWW5qNUhGQi9LVWRQMnp6R2VlYWlOWmo2OHB2ZHBXS29RU1Z1bE9Y?=
 =?utf-8?B?b1VWMEY4dnlUcUpMczRsVWJBeWlpSTZrZHRhQTNuS0M2OEtxRmIxR3FyUHRt?=
 =?utf-8?B?djhXS3VRem8zL2ExeGk2TDJ4VEQ1aUhEZFFiY2NZQytYWEQ1Zi9oNXZOcjhT?=
 =?utf-8?B?YlZmeGN3cEppNHhmNzJvME1PRzlWNFBwUURCb0xoZHhlY3E1eEFNbm9ORFNJ?=
 =?utf-8?B?T3d3N29rb1VFOTZHaFo2UUwzbUl4a3ZOZDRiek11NlhydDAvV29Tc3NqcHhn?=
 =?utf-8?B?Q1FxY3hxYjJRZDBmUW55c000WkhNM0FLVFFMOVhmRUY5Y1NmQUMzbmRhMEEy?=
 =?utf-8?B?cHIwSmNObWpKQ21OMlc2cnI5bm5GSXdiakpjdDdSSlFiR2lxZ25MbW5QV1VL?=
 =?utf-8?B?Zk94VXhNNGRzVWl4OU5UOVhBQ01xRWYweUFEZ3NLSURacmIzSjJLRUUyeWxB?=
 =?utf-8?B?NmxFQmJrSWQ2SkxTZTh1SmZoT200UWJUM0tJY1VGYURQYmNzeGZJby9ZUVgy?=
 =?utf-8?B?U2tqNW45dUpmcXdVVzhxZUREN0RlOFBQWENNK1F5OVQzMkNiRHFLa3NDQ1Jm?=
 =?utf-8?B?L1B1WDU3VmpFTThmQzlZTDMvNTh1ZGlYVE9PNEtlaGwrNlNCeFpuQmRQUmg1?=
 =?utf-8?B?bnQzQ2Jxc0M3RVlWWU53ckZjaFlTcURQNy8zOWV4YU14UmRYblo5bGttbUxQ?=
 =?utf-8?B?eUkxam05RjBBWVBvenBpa1czQ3RKNWEzUnh2ZFpES1lRbDBXbjYwYTBaRTdw?=
 =?utf-8?B?TUc1dWt5SmE5RFNSRXhrZ2R1ZXBXMkQ2dWVyZHFKQVE1RHBoNkN4SEFWZGg3?=
 =?utf-8?B?clZvVU1YejdsU0VDTC9XZEdKYmplV1FZa3Y2MlVUVkpVTWphMjhLZ25KOEVz?=
 =?utf-8?B?c1VGOXpiTWdlRElpV1VPeno0S0dWT2FaVDgvVzZkNFVTNkh4WkFCQ3dRdFRt?=
 =?utf-8?B?OVEzWEhQbUhQYWxJckpFRlM3V1FlWVNlN1FFUmdnRnB5TE1wMkN6TkpqOWll?=
 =?utf-8?B?emd5WjRFMUJmZ2RiNThoWDFZKzJmWlpzaG4zbEN2cFMwRkhUR3hjMEs1QlZN?=
 =?utf-8?B?MWlWTnk4S0YzR1d0eU9lNmt4UTRzbEk2WmxTUldpUHdCNGg5N0lWa1dwdnZQ?=
 =?utf-8?B?UEJrekNaRFNMOHE2WUpmMGl0SGI2L3lKQVoxbDZTbUNLOTJ4UTZBaHU2OElm?=
 =?utf-8?B?OHgzTXZVNmJkVGZHZ2V2dERzbnZteVp2bUxOOUtmeEhFek9YaUxKcnY0Q0Q5?=
 =?utf-8?B?NWE5MUJ4dWI5L1NDU0hxY21Ebzc0S1JTbzRFd3BIL1dCM0pWVU9nZVpXeHpw?=
 =?utf-8?Q?wDNevkdbIsu+DyVAwjyfHb3Ve?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d055e2-2791-4f3e-60e9-08dd1a5a863d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 03:10:26.1299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hnmp5vhZjqWrbwRDMfGSSH0A6TTn2fqLlx0yNuOYgviNgjiFi9yO6lr5jiV5FtCVcEu8wmwpju2/39VK9xw+Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8838
X-OriginatorOrg: intel.com

On 2024/12/11 16:46, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Tuesday, December 10, 2024 11:15 AM
>>
>> On 2024/12/9 22:57, Jason Gunthorpe wrote:
>>>
>>> I'm not sure, I think we should not make it dependent on the device
>>> capability. There may be multiple devices in the iommufd and some of
>>> them may be PASID capable. The PASID capable domains should interwork
>>> with all of the devices. Thus I'd also expect to be able to allocate a
>>> PASID capable domain on a non-pasid capable device. Even though that
>>> would be pointless on its own.
>>
>> yes. I also had an offline email to confirm with Vasant, and he confirmed
>> a non-pasid capable device should be able to use pasid-capable domain (V2
>> page table.
> 
> It's hard to think any vendor would want to that type of restriction.
> whatever format adopted is purely IOMMU internal thing.
> 
>>>
>>> We want some reasonable compromise to encourage applications to use
>>> IOMMU_HWPT_ALLOC_PASID properly, but not build too much complexity
>> to
>>> reject driver-specific behavior.
>>
>> I'm ok to do it in iommufd as long as it is only applicable to hwpt_paging.
>> Otherwise, attaching nested domain to pasid would be failed according to
>> the aforementioned enforcement.
>>
> 
> IMHO we may want to have a general enforcement in IOMMUFD that
> any domain (paging or nested) must have ALLOC_PASID set to be
> used in pasid-oriented operations.
> 
> drivers can have more restrictions, e.g. for arm/amd allocating a nested
> domain with that bit set will fail at the beginning.

ARM/AMD should allow allocating nested domain with this flag. Otherwise,
it does not suit the ALLOC_PASID definition. It requires both the PASID
path and non-PASID path to use pasid-compat domain.

So maybe we should not stick with the initial purpose of ALLOC_PASID flag.
It actually means selecting V2 page table. But the definition of it allows
us to consider the nested domains to be pasid-compat as Intel allows it.
And, a sane userspace running on ARM/AMD will never attach nested domain
to PASIDs. Even it does, the ARM SMMU and AMD iommu driver can fail such
attempts. In this way, we can enforce the ALLOC_PASID flag for any domains
used by PASID-capable devices in iommufd. This suits the existing
ALLOC_PASID definition as well.

@Jason, your opinion? With this open closed, I can update this series.

Regards,
Yi Liu

