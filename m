Return-Path: <kvm+bounces-24382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3387295483A
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 13:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E813B283692
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072F719FA91;
	Fri, 16 Aug 2024 11:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LwRNkBd7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182F713AA2B
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 11:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723808884; cv=fail; b=ZHjjNQ9g+FyUWpvhHg8yQVoYg+XQUq9c9G2kSNx5QVFc76jdPxS63Va/K1ksmJt3T9gF7kenLu9zJb66x2RSc9scPu2Gi6iKlbhwDi5Eyzv3m/fePRRx0wF7Rpx6xIosEXQnHycHJCMlz811vEUTlaJUJqBzcDmrEVGWnT8V1BM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723808884; c=relaxed/simple;
	bh=P2yjzdz13ogL8gBK1W3+b//edJ6lHERk/9For7h3ETA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D4u8AP/JjEIKsY9GTbyAYPCeIuPpPviGDA2Z1ycOo/VHJO3ZJ8RqsMtE81NeWyUirWNiguMbS6mfoWS+aslLEKDKAN319SHoHKw2TsoD/3/Y3U49MdOJeAmnIEra5rkAclwC6K/E3A8IdbDdoizgenb6t2YP/l/fXeezERbj1/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LwRNkBd7; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723808882; x=1755344882;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P2yjzdz13ogL8gBK1W3+b//edJ6lHERk/9For7h3ETA=;
  b=LwRNkBd7qpPPqEuLZT0Y27QWSprvVO9u321HVx3NUo4b1uGNYxjlp+Xr
   NhZWJ3emld7rrDyscdFaSE/98ZT2iDzQWBVyEtE9kd1P4QjQp2uVRGFIX
   w2/CpKmrOFSsBb8A7c08WOW172iPl8bGsgAy/Ovke6ywsWaJg29ZTnUa+
   sqyMYy2Szev1NMldM7KYgul0Q8NS2dfYq1jvppRtkZzECKF/cWBpjyEjR
   kXG0ZuVpVLHxugKBaNGf5DMk5lz8NFSE6tPv72KyBRzSNkSDsJ7UwXsqh
   2w7XFmALmzo90cjOs0FVwVWEHphyAa95x1z0z3yPvxSUCMRcH78Dw/p8U
   g==;
X-CSE-ConnectionGUID: XD8I6ORoQY6mwYEUhkScag==
X-CSE-MsgGUID: BmE6drLHSYWKDQ8e52gWxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="21914767"
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="21914767"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 04:48:01 -0700
X-CSE-ConnectionGUID: AVhzijuTRmSir+PWKb1iXg==
X-CSE-MsgGUID: G2K7l4TwQeylDrKg5HCHjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="59610108"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Aug 2024 04:48:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 16 Aug 2024 04:48:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 16 Aug 2024 04:48:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 04:48:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJGbPNk1L/Yf4LYPM8cS94g/ciiRHK6UX2IlWX9r8uerxxCbfzyUPSKFxgNnILofxe4vG+8c5zGSYY1yo6qT8QC7ub/9Za3hka3YwLQU4+/d4d6QXtkSB/shPcC2FoDOcAxBUHpduHpOyYJhtO5KUfskbUeALd8CBh18IUesdKlT3f+nadnF4mRoGXpNL19iU5qv+r2hO55O37YTEDUY70aoGiuYo8i4v4nKXq7Za5yuQCLgFE13yOqcF7wuX87X81vrV6spnELHyFHoAHFs+HwlcKAwXIkMgmfBPbL/I3rlTPe2aVQx9OfFwEuu/9XMDm6S/ZFjeRwDXSW5uXqkew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfQ1ApS15bGrqcsLyOgrGtTJ4v+kQwR/Zhp5DKjxwu4=;
 b=yV4MBhJtFqbl5mV6FVW4Uw6D4i9AyUhTvhx7mXP7e6X73ISF6On2cBI5k7WRLxpByYUkW+S/xPWt2nWP/Shvh8X1jmJHnDo0rHjRraJYgtOLe83cugzamroSDWIGfrhuDq+mqt4DZk69G+csanaTNrdVw5oxA9E7STpVqrViwa78EIbCy/+mYuI23cNc00Lnh0cxYDC+Gf5XU5eNQmcUyQZFU4bvXDVGoehSWs3I5X8A2+sgsX3OlQZ/9XTw5n0xFZsP3lXbrM+sA+7AAEZPoU6t3xoIuFvP/cpL1aMtStsprXdwfpfQjULJLDQcqjH4NKYtgjUBWBpJQUY30bkDfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB7201.namprd11.prod.outlook.com (2603:10b6:610:143::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 11:47:58 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 11:47:58 +0000
Message-ID: <8a73ef9c-bd37-403f-abdf-b00e8eb45236@intel.com>
Date: Fri, 16 Aug 2024 19:52:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: Vasant Hegde <vasant.hegde@amd.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
	<clg@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
 <20240814144031.GO2032816@nvidia.com>
 <b37a7336-36af-4ffc-a50f-c9b578cd9bda@intel.com>
 <6f293363-1c02-4389-a6b3-7e9845b0f251@amd.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <6f293363-1c02-4389-a6b3-7e9845b0f251@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::16) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH3PR11MB7201:EE_
X-MS-Office365-Filtering-Correlation-Id: 81b3539e-db91-41d9-662e-08dcbde94617
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U0hjbGdnb3FVbWxIbEVPV3BGOWdjNXA1OHpjL3p6NDV3M1RKc0ZUTzZ6Sm4z?=
 =?utf-8?B?SU5WamkvR2FtVFVJbERjU2ZYalg2OTZVVm5IckFkbE5lTUFtaWJrSGtDVW5R?=
 =?utf-8?B?eXhhMGJHVEdUMnFiSGhqODRuZDZUaStBOFJUQWEvZXRqSHJWL3NHQkh5WjdV?=
 =?utf-8?B?UnM5ZkFQVjFUaEdka1hMM01haTM4MHBEUGRkTzYvS3MvcTVRLzJXNCt3eUNU?=
 =?utf-8?B?YW9FQ3ExZFN0NEcrclE1Vnhlb3pHcmNJTDM2c3JtKzJCQWVDa1VxNU1xNFRF?=
 =?utf-8?B?WE1GQlU1YlJ4WllrSnlWUDZlUGhadWdjejZiZDFBajc1SzJtRlUrSHo5SW41?=
 =?utf-8?B?RkV5dHYzNEdESldhajZLemJ3Q01RM3FMQW40aEt2MXZ3OU55Mnd1djNUNExs?=
 =?utf-8?B?bUUydEUyS2ZyTWZPZ0FVNERIN1hDR2dwR3VlY0VYRUNkUjNQa1Y5RTNEaXFx?=
 =?utf-8?B?UVpjSXpKampuL3laZHZlTFBuMGE4aTN1VmNMQWpaL0liNUlQMW9jSm5XVU1w?=
 =?utf-8?B?akl5OXIvYi9uZktISmxkbGMvU0t4bWJWazE3R1RLakoyeGlnNXZlR0NaTERt?=
 =?utf-8?B?MzVaMHFqUTBoQUdrbUpnWWhDak5TWjBnTlljd2Q1a2xJcmdOdDNWbUprZ1RK?=
 =?utf-8?B?ejZiNkRFa0NTeGJEWHdzMWtYYTdkV054aWFzbGhsa2lVdVRDNGlhWm02WHdC?=
 =?utf-8?B?cUNGMWl0R0pobmowT2tGYlFKNDl4U0xKZzFMd1d2RkRsOFhYZlNBQlE1ZWdS?=
 =?utf-8?B?S20zTTlDZnRiaDJ2bng2S2JSVk8rNVh6RFNPMVZoem1OYzg3bDAvU0hUd0lI?=
 =?utf-8?B?c1FndEwxcUlrVmQxSEgrZzA0b1dLOWcxaUZ4bi80ZVRtYlJPY01MbVBQaGJj?=
 =?utf-8?B?ajlxK3FGSjNNNm10NWRmR0E5bVhTaUtkM3g4K2g4VEF0NzNZVFVLbUt0V3Js?=
 =?utf-8?B?eS9rNzFOOUpqckFCdnZRb2dpU1FzVFhqaDREQkh2MnpDKzllalQyQXk3eDVj?=
 =?utf-8?B?QkVxSmN3eEFRcDNRMTZ6NFNXT250UlNwQkp6ZC9kR1lVbTFoYmVZVWJRV0lV?=
 =?utf-8?B?dUw2cG9aNHcyb0FzdTM4QWc0MzJqUlRvaHBqdXRXUlFZdWZVTTB5Q0llcEY2?=
 =?utf-8?B?bUR5R245dHQ2bkF1WkQ1ekN0emg3RGw1N3BQUDlVWkpwZHhJcHFBYVZkZVRn?=
 =?utf-8?B?R2FJMEkzdlp5QVE4WVo5em1WS05iOHZtZFVaNWdiVzVkQXRYMmVoYWVNRE1V?=
 =?utf-8?B?ZlR5OGNoVk4vTmU2TlNaL2tOZ1lla0VZbEZJdjd3V2djaUJpS3ZYTFJUM3I0?=
 =?utf-8?B?ckNSWHdwbUdCU1ViSHhWZGpVcG1PQ2krMU1UR2d3cFgrQ1hOdG14ZTV4WnNy?=
 =?utf-8?B?NlRoMlYvMVh0ZUw4aWhTVzVza3JOZjFkcFJKTU5KMnVjWUJqWS9JM3p5dk5p?=
 =?utf-8?B?ZXdxSGcyMTZjY2dSOVB4eE1ZTXRaNGpXSlkwb0RhamVuMkRrZlN0MFcrZVpa?=
 =?utf-8?B?eHMrUEhBZ2NiM3lsM3Z2aXVzTnhrejcxbGU3N25TaVlJdXBLRE4zL1BpNWhY?=
 =?utf-8?B?LzlFV3BMN1llOGNVWVNRTkVoQmpKdUUzN3RpdmR5TlY4THZGcWlIT0FsUS93?=
 =?utf-8?B?dGdxVzI5VEJ2R0M5MTdnM0hGRzJQTGlZTit0RzdLMHVBU1B5eGt1enZYV1pJ?=
 =?utf-8?B?ZXF5cmhLR3hzeUFySVJ4UmhHWkJmeEdMQ3ZMaEFpS051YW9HaENkN2xuaUFj?=
 =?utf-8?B?bXVWa3k3NXFJTVNnYjFkMy9ISHViSkprdERaUFhRWkhVOTdnUDVEMEJTaTlR?=
 =?utf-8?B?aDl3V21jdm96eEo1blhpUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0NGYlloeWtrQllIWWZ3WEM1YUdBckZtR1hEWk1QQnhvTmdWY3VWTEJJUlBu?=
 =?utf-8?B?L2ovM3VFUVZOdjFTZDdFYXBkN3NVNUJqdHEyKzhCT1MvazZwY0ZmdkVzM0hC?=
 =?utf-8?B?VkM3SEdteDdnTTZwN0RjZ3IrUytMK2N1K0dHQ25OM0h0WEdYQkNrZnRwWUxm?=
 =?utf-8?B?WUJQN0RoUml4VHZxMDZreC9FZTNIcVdlekFVU1JEdzJsRm9maWIzQVl4TDdz?=
 =?utf-8?B?Y2RKeWQ4SWNTdC9qTDIwVjhCUTJXZm41Y1BiTERoUlVVYXk2VWNWZzJrTUJq?=
 =?utf-8?B?OTNsRTZSMUR4cG1MeEc4MnBpNjgxOHp0UUNYdm1aNGZXRUFRZTJab3IwNWor?=
 =?utf-8?B?Snd5R2ZxUEk1MTZNY0p3MndPMHhmUkM4MFJJcW1tUjVrd0d5dnRHY2dvVDdB?=
 =?utf-8?B?c1dFREc5NWNkNUlKeGVDYWR0YW1uanJQbER6ZU1rbVlwWjhJcWM1bEpiSFc4?=
 =?utf-8?B?cTYrTnZEQUk4REJ4WEM1Z2FNdjZGTG1GTjQ0U3VSeGhaZERCRnozQmN6SEt5?=
 =?utf-8?B?ZFl4V3Z2V1djNHZmaXAzQjZXbkdIbFhwd3Bmdk8zK204cnF4MmJnNTM5bkxh?=
 =?utf-8?B?QVc2eXBLT0c0Mmlac0Y3b0FtUS9CZnRVM3I0Mi9xQWdTT0pDNnJPZGNmNE9E?=
 =?utf-8?B?Z2tMQnU4TGtIR0c3alhRaHNQcHQ2RHgrdUNFVUdFcWxrdi9MREFVRlFJNndo?=
 =?utf-8?B?WkowL3FvZ0JzMlJsK0J3ZXVJdVV6OFAxMm5nQkowQW14ZFRiMEJuMHFJc2VO?=
 =?utf-8?B?SzRoaW9mL2RjVUEzcU5zQWpoeTg3WWhJVnliaGlZb2FXc000MzNPc2pUaks4?=
 =?utf-8?B?V2x0ZGJxZ3lhVVZzMFJKb3VSRmJRVWV2ZGpHeW5ENUJKSGlzaDFwZE1tY29F?=
 =?utf-8?B?QlQybWkwTmh1dDBiVlhuMFNMZlVEcGRWZHNzSm1QV0dlNmpFNHFITlhSUVZI?=
 =?utf-8?B?Q2FiT0ZUQXF6dkMxbUJhWURaRkpQeC81TCsrWktOUDN4NVNnc3AwSk1CUnNl?=
 =?utf-8?B?bWFmK2VKTmgzbnNNbGNUUlR1ckl2NjdtZ0p0ZHlqbjVFMi8yTm42UDZLKzZh?=
 =?utf-8?B?STZuNjduek9qL3JmQ2wrenpYVW5qd2JDVHJkZGkrN3JCWUtwbmNYNkFJTDQr?=
 =?utf-8?B?UFZvcTVFdkpjSmRkS1VUbysxWHNTNzIya2FhRU16K2ZGNHdORTdEUjZtWVIw?=
 =?utf-8?B?U2Z1L3Q3UGhoZTFpbzdDMW9xWXVFK0RqWHJ2TEpnMXYzY3dqQzhabDRsZFRC?=
 =?utf-8?B?S285dXp6SFlORE16eWFzTXBsL2R1R2g4ZDFuK2NEM3M5Q2lpRVRqVkx3bnFi?=
 =?utf-8?B?aysxYjZuT0t5ZFkxQ21LbG5QLzFqRjRHS2gwYnR2MEUyamd2bG9iWnZZblZ5?=
 =?utf-8?B?dm5HUHY5QjRkd0RIT2o0Nkhoa2liV1VYeUpHeGhnRDFSdzBSOHZnTU53Zy9u?=
 =?utf-8?B?RmRjMWdjakF3WmtqbU1ZV0dwWHFmL1NPeVlLZCttaGR3dzk5eDdVbmdLN0hv?=
 =?utf-8?B?V2ZwenZQMEhDNTR4NWY2ZmNNdDVVRlNFclBuOW9YOTVLN0I5d3BZUno0dzBN?=
 =?utf-8?B?SXhESnZMY2p5Q1N2eEhUWmpMM3ZhUEoyc29yTHVVcFhuUWpYZDMrT2s5emRQ?=
 =?utf-8?B?SDFuai9PYlhkbDluVkVOYWJpUmJKNzlJczlsTWs1cnJGcFRXZVNQM0o0MmNq?=
 =?utf-8?B?cFBZenMvUTN4L2lWN1cwSFhtRGhSaHZQZTBteUVrTW81VkJrdGw4NUMycnpk?=
 =?utf-8?B?NGtrbnpIa1hVYnQ0azlvV2NGS0ZKbXY3a2pBYk4vZUFQVjY3T2RpY0ZRaEFW?=
 =?utf-8?B?THZ1WVl4SmZFd0F5dHdQZnNNcDl2VzM5TWJKRzNQZVYwakMzUFd3bkpHN3Zh?=
 =?utf-8?B?T29uKzhRN0ZiUlVlTGZJVWNhMGZJYjg0bnc2S0JRc2dGcko4aWhyMi9vK0J5?=
 =?utf-8?B?VjNFN2Y1eFRWVU9GWFRkQ2tzaDdsSlJjWU5VZ1RBRlFqbUJ6RDhnZlZvc3Rr?=
 =?utf-8?B?eGVUTlM2aWl1UXo3LzZrdUoxY2pIWGZpWkhQZ21DYkhIVFZLL3gzYW9qeWYw?=
 =?utf-8?B?NFo1b21pMEdLcXdYV3FjQVR1TytOVzY5N1dMZWtRRlFUdmZFcW9lMUxORllR?=
 =?utf-8?Q?kpfR4c7GbHQWpHRqRSRc+hyS6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b3539e-db91-41d9-662e-08dcbde94617
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 11:47:58.4153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcf5SjQkZzpjWYBaieiL/QthSOzEJL15072+uJffqUE6OGlNU40RF31Y0UBapm316JWZGu3ZX8UJhUTn79KBXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7201
X-OriginatorOrg: intel.com

On 2024/8/16 16:29, Vasant Hegde wrote:
> Yi,
> 
> 
> On 8/15/2024 7:42 AM, Yi Liu wrote:
>> On 2024/8/14 22:40, Jason Gunthorpe wrote:
>>> On Wed, Aug 14, 2024 at 04:19:13PM +0800, Yi Liu wrote:
>>>
>>>> /**
>>>>    * enum iommufd_hw_capabilities
>>>>    * @IOMMU_HW_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
>>>>    *                               If available, it means the following APIs
>>>>    *                               are supported:
>>>>    *
>>>>    *                                   IOMMU_HWPT_GET_DIRTY_BITMAP
>>>>    *                                   IOMMU_HWPT_SET_DIRTY_TRACKING
>>>>    *
>>>>    */
>>>> enum iommufd_hw_capabilities {
>>>>      IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
>>>> };
>>>
>>> I think it would be appropriate to add the flag here
>>
>> ok.
>>
>>> Is it OK to rely on the PCI config space PASID enable? I see all the
>>> drivers right now are turning on PASID support during probe if the
>>> iommu supports it.
>>
>> Intel side is not ready yet as it enables pasid when the device is attached
>> to a non-blocking domain. I've chatted with Baolu, and he will kindly to
>> enable the pasid cap in the probe_device() op if both iommu and device has
>> this cap. After that, Intel side should be fine to rely on the PASID enable
>> bit in the PCI config space.
>>
>> How about SMMU and AMD iommu side? @Jason, @Suravee, @Vasant?
> 
> AMD driver currently discovers capability in probe_device() and enabled it in
> attach_dev() path.

I see. So AMD side also has a gap. Is it easy to make it suit Jason's
suggestion in the above?

-- 
Regards,
Yi Liu

