Return-Path: <kvm+bounces-30884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 229FB9BE23D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:19:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0B501F236A7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A541DA622;
	Wed,  6 Nov 2024 09:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZdHfiCVW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECBC1D8E1D
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730884703; cv=fail; b=UXNbL3lADcjSd/t4zRu2iIWRC8zrPvmc81xi5J6mjzOyu3l35aEGoldKTFPWszhqoQbCrQId35F94Rn2QCxBoa/q6k0wwFzgsh6zo3QxkdhI8xydWfPfgjg2Ut34uIqeWfYJ6vDF0McN4v5hTv9+pJbFBhIdrase3vmy28/kWbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730884703; c=relaxed/simple;
	bh=E9yjyoJVn4RDKUW1seiOFbUYlAkMJBK3ro8H9lWtjcQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QbcMUV5hRzn62NAvDYngCEX71byKqx2GyQ8JFeLekyhBZO1HhC1iPXiENZFOr0NYMKkE7LJCB9hcyE8wbeeoa2AdxetotH5UsRp6iuFcCabejjXfUBV1x0VHqVWjMbRXuY8Rmc9/OtAZMMSPYfauR61OcI1sFC+7Hu7oYNu0Bac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZdHfiCVW; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730884702; x=1762420702;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E9yjyoJVn4RDKUW1seiOFbUYlAkMJBK3ro8H9lWtjcQ=;
  b=ZdHfiCVWb3pfyezM6muZ5XzF5PdPspL5A6W3ycZDovptATTgz8YU6BW0
   YOf7VpkAs0ZRk8hP+AR4tBisFZqQlggkMHYui84TYNnLilkj8SRphHH0t
   /kM93ky1F/R80XBgKG9nmSbS9OPkCYUGZZu7zbTtmstGcovRJ7b60tlqd
   NbknqX1/20nZk8wM1VcB0WKDElxxwwuPg4kOnrMVziYJycNVnf4SF5jbM
   4vioxd516vgLISF8uYzKaDvLg+3KuzS3NZO0Ai0JfWk7Om9/JOn/uns04
   BrC7NBWe51vfw2m9B04vash0c/4enGqxVemRd0ZnaUYC1BsRtfQYTd31X
   g==;
X-CSE-ConnectionGUID: URo/EQ7MSce/AzZAKAILsQ==
X-CSE-MsgGUID: dUxHJV4SR4qJyuLHjcPFfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41219399"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41219399"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 01:18:22 -0800
X-CSE-ConnectionGUID: FushhxByRyu3sBGwq5+P1Q==
X-CSE-MsgGUID: 2cvHUFuNRquODoOXMER9cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="88383747"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 01:18:21 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 01:18:20 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 01:18:20 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 01:18:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+tIfIBWC1epYhDDFiX5ZJxlTmpkDPDiWMenyTexg81bBbKFTET2p2QBsJMMIRXXiHhPr5W/Ld4LQnr+5+vofHvKoys/2XxDXYwvtEfF82mDtaW6Yx6w3jd336mK/IVSD2aAX/T8eFbkShpCLw1D9PWiL4aZeBOz+j2xDcedNKCUicsSyaVFSvKyhUPv/J5IGcs3PHo9aU0qltW+6BORO8llEWHkTyg00T3SmFhJljWX6TNbi+O9vOeZVYDB3lUiJ+UbrctwnBqqFcanAY7AsbpM7GoZ0V4WJp9cruTSV8VvUIc7mIZc0YzevnlgoOCSQQENLbX3dZaG8oEvPbEFsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3eEJMq7IonpBfNKRiq/e3waww/k2PQad1McaNuXpvEI=;
 b=fLpRBaG+GN9/TAHierS/rmkVWtxjfKJChycu9frHE7b2VaDL06xszubPfEQ9K0tbkf4hpdZNZPWE452DQ+sStmPcPdwzKdoWqwCiNAmv+uE8AItiI73hX/VSWyWHdvpCoWCz04qIjuumNeiEWYiHOKg2EB7DHG90p+M3RYR9Y4HidrsI9KWQ/ZH8b+Bsl1rO946mwVFVsP7BUXI7YeytlXcQVw3xejUarvUfyyEIeAFZr0TRZRDLflAHST1qDtNZ0i/X6Rljq/lUuxVsxyM9EN0o16ukJwxd89JAwMZCdnJJW61FjHSX80BfaNLoYXh9y8c3acUaKDCwViK/VtQ+Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB5239.namprd11.prod.outlook.com (2603:10b6:208:31a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 09:18:17 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:18:17 +0000
Message-ID: <f6acf1f7-ec6a-4e70-859b-a562327a176b@intel.com>
Date: Wed, 6 Nov 2024 17:22:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/13] iommu/vt-d: Refactor the pasid setup helpers
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-4-yi.l.liu@intel.com>
 <BN9PR11MB5276A33DEC84EE55B4E6DA9D8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276A33DEC84EE55B4E6DA9D8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::15) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BL1PR11MB5239:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fcd970a-9d44-4c3d-f44f-08dcfe43f2ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bHVRMm84UmhENGhhei9PYnZVd2tCSmhkcml4Z3lGN2NPU2xjbGxjczRrWTVR?=
 =?utf-8?B?N1lLZzgvOGc3czNsNVd5dHJHSTRoaHdBc1oyaUNpVEFBUjdEM3Nya05UclRm?=
 =?utf-8?B?WmNOcjJOK1hWMXNKcUIreXJUN1VmYkJFa1dMeXdvY3MzdWYycDRjMGZEUVpy?=
 =?utf-8?B?OVRvL0hSKzErNU9PNzQ2TU9hSTM2NnF6aUFJdU9BeGVjQ3ZHUnUwbmFIT3Bp?=
 =?utf-8?B?TVc4UjFoby91OWtSekdUUEQ1TWc2ZGNFY3lpMDk1Zk50aTJtU28zYU8zMnlr?=
 =?utf-8?B?NXJXaXRDTHVnSFQ4ek9VeXh1VkhHb1NWUDUzWHp2WUhIS1lzSzluSi8yaTla?=
 =?utf-8?B?Tjl4V0U1RlkzNXMzcHZ3MXZFdnhDcGUreGxwKzk0ZGh3ckdHVmZjNUlIUVM5?=
 =?utf-8?B?UGZyWWdYRDRRTGMzNjJHYXhBOVZib0l0c1JDY3Q2Si9pSWZ2OWdDU0hjMGd1?=
 =?utf-8?B?OHFOYm5lcVdoTHJQR3BsblhhK011QktpakV4SDJxbzJZOFgxRGVKeTVLV2th?=
 =?utf-8?B?SWwzVnFDRE5HdmpvbXdxRG9janJKL1RuaDBvUmFXVTI4WGdIMHhCa0Y3ZVNr?=
 =?utf-8?B?MGJsRXlsODRoeHkzOVJaS25ORStzNkszUnByalkyN1Nyc0xvYkJ0akphclZN?=
 =?utf-8?B?elh3QWhqcWRiVExXSVI5RFVDb2lJeWRQNU9RN2M4ZjNYUWQzQkRCbURrb3Jh?=
 =?utf-8?B?amRYRHFTbkNBMXQrUVpITVNYRG5UaHdZWVh3b1VBQks2VEdxRmFDMVVlbXcz?=
 =?utf-8?B?bktOR3hCclA4cVE1VHRDRlNIbEdTVXR4TlluOVo4VjFXTkFkZnVBdU9qQVRP?=
 =?utf-8?B?cDEzTmdic0FyeXZqUUVlSGFiaEZ1T0JCNTArMXdRdWlUWXh4L2p5NHAzbW5u?=
 =?utf-8?B?ZGM1Vk5uTmxJQ3R6VkUzV3lxTmpkUEF0UnJ1NEdoMFdpbGlldkxhSWxIY3lU?=
 =?utf-8?B?TXpzS0hzZTlOSWFHdnlrMUhva3E2dm5kVXNxYW9OZ2VPWFRUdWQzUUZZUElQ?=
 =?utf-8?B?WWwzdm9TcVJ3NWpEQ0h1VjZNMkV6L0ZmS1dDaDBWRFVmRkQ1ZHNTNm4xVFNI?=
 =?utf-8?B?bW1pZEdCWjRDM1kyaHFyN3dlbVRtZzJkMlJtZFcrcCtacCtBdWZXdHk1WlpR?=
 =?utf-8?B?NEl3akk1cTZmMENoTlZocEdTb3B1SnhhMDJLazlRSCtWeVFrWjZweStMakd3?=
 =?utf-8?B?ZkR6cE9hRGlGeXVBOHJ4VWJ2b1ZpMkE4M2N5WDdYeFIwTmI0bHBOQTlYa2R5?=
 =?utf-8?B?RWQ1dWhuZWQ1TUMvWjFIZ05nenZrVEE5ZzJoTEg3NVJ6bXdLdmNWSFAvVXdx?=
 =?utf-8?B?aWtmc213U3ZxU2t3WldhQnh6UVk2aCtldEVicm5jKzU5U3luaVVDMHFBU0dN?=
 =?utf-8?B?YVZqTTFlTWdFcmNNeEhnK0RFZjBwVWtLSFVUZFhFMGE3bXJnTDNMamIxMmFF?=
 =?utf-8?B?YlpBdUYxbjA2WXhRT1RlUXVUcXJPYWxTQm40M2FLWStLeVBGdklUTStiVWps?=
 =?utf-8?B?N1l5SklUVzdUWEFsbEd4U1YxMTlWaWdVRjdKL0REQkhNSUZGNjVEVzNkdGRh?=
 =?utf-8?B?eXhSMjF1SVI3VWJzbmFCSmZ3NmIvL1JkdzBROGwycUc1dkdlMDZYRjdEcCs3?=
 =?utf-8?B?OTVkKzlpSFpZR0pmSjVhUXRzaUZVZHhKcFpPZU9zRFZ5ZklsWFh4dFQyQ0ww?=
 =?utf-8?B?dUdUTXBlWWFCSVQ1WmJtblpXbTNmZEpDeHNMWTZQUTBhUVNQTXFsWTV3NGF5?=
 =?utf-8?Q?vBQjkKN8z+uKOPLbLm50FRoALVaMycLC+SShvQO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnR6cThkMXN6RGljRTlUMC81eDRtT3hSemhqNno2TmgrUzladFFqbmI2dStI?=
 =?utf-8?B?aElKVWZqS0h5UDgvQThvcU4zc3RMU1YvWG5UenFGcU9TeFZkYlM4WllxZ0xw?=
 =?utf-8?B?aUpubFY5ZW5seDBkU0NCdmJ2bklMc0xRZmtlM1ZTNXFCQVExWnVZaUlKQ25x?=
 =?utf-8?B?ZjdQNWdWTnBhL2hIS2hzb2JJWnJLQVd1MitGUldYYUZJZjdkcHE2Q1B6dUh3?=
 =?utf-8?B?L1YyTVdBVFhYUkdwbjNtKytEZDVibEdPeGVhRmVBRHFxNkdMMWtwLzNXY0Jn?=
 =?utf-8?B?bGFzay9HcGI5NjlkUXhZWEswNWVtUFQyaW13cHNVdzJXaC9GY1c2YkhQbXQy?=
 =?utf-8?B?MUpnTnJWc2M3K1RlUkFNeGhXRkRvb2EvVmhkYVcxVnJCamtHd2NDZkVLM0hz?=
 =?utf-8?B?c1FrTVZkblVWYUJSb1IrMWErdmwrQ3JwR29DWW8wUzF4a0Y1aWk5V2Z1ZmJQ?=
 =?utf-8?B?YURpZ1R2NGViK3Y4RnJHenkwVmJXMnJpaDdOUEFBU2RhdEQraEFFS1pxdERm?=
 =?utf-8?B?a0g0alJETmJpclFxZFNjQkZnMTk0QzdrcFE5M2d5NTQ1SytSRGtyczU4TGRi?=
 =?utf-8?B?Mlk2cWwrRkdUVXpCc0VXL3BTeUdWaURTUlMvVFljRk5pR0RZNzZwRURKN2dE?=
 =?utf-8?B?bEFHd2tRNjg0QjBOR3BkL2VUZ1gxR0tiM1BUbUpEVElPK0I3ZU5ZUTM1UUdm?=
 =?utf-8?B?Q1NoNTRLais3b0QxbTJkdVg2a1V6M21OZGhnM21IZ0E2RDZKdU9NUHpESGZl?=
 =?utf-8?B?R0lVWExHa2Z0NFFjYlNZS3hqZVNZMzhXb3lKSkNxd1NGYUtKeE9uN2M5WFJV?=
 =?utf-8?B?SzNpQXBFNmxVeFdjVzJaeDlZQ3VtZHZXRytuSlZ3eE45M3ZLNWc0ZmFISmJl?=
 =?utf-8?B?UlVZTmNiWVBmOWRzeEVFSFNFcVR0aHM5ajZoQzBMR3RNZVQxam0xUjZscWUx?=
 =?utf-8?B?VytRQWdnbWpRS3VpaGpZQWtRWE1MMjN4T0dZUU95cXdUb2xvY004WGFYSWIv?=
 =?utf-8?B?ZU5xYkRYSXRSb2FkM2E1VmNzSk1ZVGkwcWUyN0RPUmpqQkRIUUFSOXI5QVo1?=
 =?utf-8?B?b3IxWEVaOCt4WlVHS3IxOWdOVWJxWkpSNjVXdGZUazJ2ZTA4amZHejBBWm1m?=
 =?utf-8?B?VDFDRnRGT0J4UDErTDdhcThKZXkxQVBXZnpDQWxLdEJBdUdRT2t3NkJZQ0ph?=
 =?utf-8?B?VDF1RnBTbkVSWjVGc01udHY4dW9nMlB4WTJWY3ZZWFhFS1g4L2ZxazNRWXVN?=
 =?utf-8?B?UzRFYWNvT3grQXMvenhBanNiaWk3cWtlT1JiWmg2b1Z1aE9PZmU3WkpSMjIv?=
 =?utf-8?B?YTlyT3VpSHo2K1U1VmlOWGx4KzM1eW42b004am4yRVBObUxuZ1NwU2F6S1lj?=
 =?utf-8?B?OEZsai8xdXZ3MzZFNHFUL1FsZWFleE1hVTUzazNNWVNEYjRMK0hXTGpPN2Zn?=
 =?utf-8?B?dTYzbU9GeHY0NHQzNXo5MGcyVWh6WkdzclE1TnZ0elJrd0IvN2VLSklTZEtJ?=
 =?utf-8?B?aVZISURWbUtGdm8wS1ZaMHkvUG5Wa2wxbTQ3S0Z6UnU5ZzZqNDlYU25Yc1BG?=
 =?utf-8?B?UWl5ekpkV3ljeVVKU0puS3d6RDE3K0hUbDZkSmRkUmJOUjE4TytwK1I3ai9p?=
 =?utf-8?B?Q1o2K2hQMUpKZFJtd2xoWkprOC9KQzJiaGQzQitneDg3ZVFqQmtJMzl0R0ZG?=
 =?utf-8?B?bVp3Nm8rZEZzNno4SUVPUFZvdUJiUm9STElWMWRFeFZlOWYvc3R5cHJKRDhm?=
 =?utf-8?B?Z1N5aE5kcWxkOFY5Uy9ZdXZ6K3FVRVRpenNuK2Rqd1EvcmVPV3VrSDNqeHlT?=
 =?utf-8?B?V0JlOWVYNUljTXh5Mlo5STg4SXhnRnBNNFA3TUhCQngxTGhnaytNTW1oNWNQ?=
 =?utf-8?B?eUZJNkxZRnEreGgzNmQ3VFJ2ZVN2bEJoaVhpZVU3MGVCRmIxMzdVa29MRHQr?=
 =?utf-8?B?VGZ4cTJTZE5qQkw0NDdadnJ2TkU0d2t2NGdyQ2kwWXRRQXNHV1V6R2JJcUpx?=
 =?utf-8?B?anpRY1gvNjNQclpGcFpiZkRYd0RmcHAzSFA1RWFneW5TWkpDMDEwZWlZNU5L?=
 =?utf-8?B?SldLZmd1QllUaW14Smp5RmpETHV6cVNqRS93QUdmbEp4QmtuMjhleTlvaksw?=
 =?utf-8?Q?aBiHKV/nB5O++lh8fpUpM49yO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fcd970a-9d44-4c3d-f44f-08dcfe43f2ed
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 09:18:17.4846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Id25VE0yWkMjj7NSje4qQtjNaQ7KKNvVaZnYqp6bmkzmbMOm7k/c0EzFXF8qhBVGEI5SaK99wudzE6lKGPWX1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5239
X-OriginatorOrg: intel.com

On 2024/11/6 15:14, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Monday, November 4, 2024 9:19 PM
>>
>> As iommu driver is going to support pasid replacement, the new pasid
>> replace
>> helpers need to config the pasid entry as well. Hence, there are quite a few
>> code to be shared with existing pasid setup helpers. This moves the pasid
>> config codes into helpers which can be used by existing pasid setup helpers
>> and the future new pasid replace helpers.
> 
> hmm probably you can add a link to the discussion which suggested
> to have separate replace/setup helpers. It's not intuitive to require
> this if just talking about "to support pasid replacement"

this came from the offline chat with Baolu. He shared this idea to me
and it makes sense that we use pasid replace helpers instead of extending
the setup helpers. How about:

This driver is going to support pasid replacement. A choice is to extend
the existing pasid setup helpers which is for creating a pasid entry.
However, it might change some assumption on the setup helpers. So adding
separate pasid replace helpers is chosen. Then we need to split the common
code that manipulate the pasid entry out from the setup helpers, hence it
can be used by the replace helpers as well.

>>
>> No functional change is intended.
>>
>> Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

-- 
Regards,
Yi Liu

