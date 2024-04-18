Return-Path: <kvm+bounces-15058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B0688A94CF
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 10:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A46A1C20CFC
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 08:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5587985659;
	Thu, 18 Apr 2024 08:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JJ9RhyhB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEDD757EE
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 08:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713428381; cv=fail; b=KqrxFmjU2VVfhJIqx233jQrsTSG5bhOB7G/pXSS2PP5nmdhfjQL+5XdOC4sQJ3uV4jaiUZMukl7FcFUX27RFiC+V60GKKdVZ1Rz/KLY7ovFxxwMmU+ACl3IOrNBOhhzfMd4MAeBu++X9tqmCdiexGpAdXDwUWcTkNFeEdMkD8lw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713428381; c=relaxed/simple;
	bh=Am8xspRPKDkxEEAZWtLFK4LFN3USIz89BglnvyxVoG0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tQ62+r6+/yGQPnSgiLiZx2sP9x8Idl/jOf1TvaMW9hbMzJckr7+puhVcIYVOj5smx/aCmp2jhUuNYM1cxfU7r+fcO6sYR+y920w3hXYGGy7G8Kahzv7GbCj4Thzf4AaNicyJXUHqnyxBkspB5DZ2jb78iYvEX4s4lN2Z5+WL7UE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JJ9RhyhB; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713428380; x=1744964380;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Am8xspRPKDkxEEAZWtLFK4LFN3USIz89BglnvyxVoG0=;
  b=JJ9RhyhBwQxOcDudZM3q74M9yyLxFl8OvdCldOSzTEmTiIjxxUBn2WqD
   e5FlwVSMvJSnaWWOxyvjeP1ykXDJrnKEpI0uM+cTH/nZkJ1MSaEZmDeb9
   2R3tCp+luDaCOIAet9AdtQ8yiogBh17L3//ChpaqQU/SSTNyhqUaNgH7S
   E/FiYXHsrIECxCg//ogLxv2Yn3TQhoXF/viYCHhWV6sxqxvBwWWjvT/1D
   SnL4VuxqZyupY85FqJEdo/CbfLrDl8i0v9YwVO3o+4r6dCPnrmATAGFSN
   wFcXMVNx+Vce/pXlYbefr83TerCHbq8WuxrqGAIpj+EwJBceAV7fAehlm
   g==;
X-CSE-ConnectionGUID: E44TXj9BRr+tO0s5ZtfPTA==
X-CSE-MsgGUID: Sieh5LiYTUeAezFjzxWrGQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8833490"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="8833490"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 01:19:39 -0700
X-CSE-ConnectionGUID: zVmDcXEGSS2+TRjJwHXE2Q==
X-CSE-MsgGUID: ZSNB3DjYSzKk3bCjjgX4mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="53840504"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Apr 2024 01:19:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 01:19:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Apr 2024 01:19:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 01:19:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyz0ntOAQwbwCcPrML1rEnWja9BIv3W2xGAAlDzfCOz6NO9dQXpvuwWXspU4Vjz1PHmH1Wcp9ZtqTu3MmMDkAv92n/QJpe3sQvYGKsVLuV9gN2zH9TTkYtJUKJ29FkWVXnuS/t8Zyn7frX3CEd/Cxx602T6S3nyJy7NrjYpkvyCLYasoCnDbh/YlyOukzg7XdCwWrXN8DfZyuJjCTS75Jq5IPjttKW0lp4gq5BaulgsjfVurgxcFKaRFSZFZ9Hlm0kRGzjuQccHN50ybPrQhmLTKhn9spr5gVpGtTjzOOvxuhcmPIXzc7c8e0l7GTUmAY6Rue/z/lrdkcO0MHw+fsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1FSzU3y4wjzCKMI7b9BztwSTkzVLnLN6gR+hKaqCqcc=;
 b=MFoNGl3cuq6PksPssT3gRImZdgMtfa3rb8mdSYktbmU6vim0urUo8XzOhrgcZYw31u3JjY6Ia0N1c1n/ykN1ZSkAbyg7zZrcRfI+EDmUhAaI6rXM2lCYjWoUpef7kQTPhy0XKSiluDfqP6Fx5T90MLZvHSE4I1CxjRkViQLf4qtOxbpo9Ma/heoEH2Rt4tP7INxee95BZt7fTcgZQX8ixFigD2ASpRUEvXWTwmo7qsXkvsgadF/ku0DYmlGFF9PC/3l9otr96I46GoXfPZqNnXf28CYPRGzO0RXtKNIIfmCI2L5UwZNlZe3yNIKMBpmrC/07eaK8RT95pF4eQc9ODw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7310.namprd11.prod.outlook.com (2603:10b6:8:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.38; Thu, 18 Apr
 2024 08:19:35 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.7452.046; Thu, 18 Apr 2024
 08:19:35 +0000
Message-ID: <53e06b21-a2ba-443a-b8a4-87c4826b0798@intel.com>
Date: Thu, 18 Apr 2024 16:23:06 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-5-yi.l.liu@intel.com>
 <20240416115722.78d4509f.alex.williamson@redhat.com>
 <BN9PR11MB5276D245515E81844B5EC1068C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240417142552.44382198.alex.williamson@redhat.com>
 <BN9PR11MB527690902C6D7D479C16DB3C8C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB527690902C6D7D479C16DB3C8C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:196::12) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7310:EE_
X-MS-Office365-Filtering-Correlation-Id: 33ea9c85-b863-41aa-bc14-08dc5f804816
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YmIwpDCApVQvrZBCu/MJD0WWWGIoW+FkByw1w6xb71tg3IPRUDKGxuCImgNV/+Y3Mv+571pwK4BUwBYJOeVUWUWiSlolpt1TC1wZM4JLw0JW1y4eoFl2k2XqvvyniJnzAuRW64V0FA7lQ75hQtXPIfEF3Y+0MomAAE0fDVvaCQIp1dAXsBrPyJq6TgREnjpIVdYQNi1zEXaHBM7hLKu8L4/TAGIMQRknPBe0Cl+zWV9e/a7F7J2aLBdj9aPCHVnYIyWSE94rrurnUyp96+VPGU4cpYyUvL0JwIwDlBQBxynkG7GdkcGojYOdvl9gkoN1czsHS5c2gAHhgCkWD3WWTA2V7/TkEfscLTLnSxeYRtKI5bSO4zMSPaPwkq1ZolmOzOyCW8c93Y1wVR51NQdCWWY/O3oakkJlLMROjHIZs+RY5zXoHRqKlh1H4fonnKe9yJVn52cVJrpWXr9SOCVblgtJsFGqUBE8GAWPxbbv+IDkpJ+pGwyKxi3lA8uzxmwSJyQpH43BG+voToeLCKBuXfWg5LGjLttinZbF3dRM4+eaOkoRrURkFRmgFFOofxaSHTkXwHbTRH9UaHytf3XJ/hQ+qOKQWZDcPIBugRPbOt2ZC46d9ix5oSMIBBfga9SuDJVUXcd9Rh5IadYcNHehbUkN8krIb99mg/4aTDMN4YM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2ZmUTJxNlZVOUtKaW1pOFV3MmExRkF4Z0FmUHpZRW43OHFjS252TmZuVmtT?=
 =?utf-8?B?OHcwNnJWdWtmUi9sMFlnN3BIQkJBMDhlT0NXWHRVMVEwRXJMVmpMbWtBUWJq?=
 =?utf-8?B?R0VpN1BKbnNHOThuVHJPVWEzc3Z3dmR5NElRS2FkcWVGSzZ6RzFadzVzR1ZV?=
 =?utf-8?B?SXI1cURDV3J0ZHd2WDN5NmRpenhNUzJoRWdhQzNxdDRqZjhXdDdPRU5lYWh0?=
 =?utf-8?B?a2JaemNYQTU3dHFDM3BvTG05azFjcmV5Z01QZDVUZGMwRDA1MG5NQWoyb1la?=
 =?utf-8?B?T2xkOXI2TDk3a2tHZUZxSHRnOHRTanh4OGFWYjJVZ3p0RkhlRUU4WnBXRVJw?=
 =?utf-8?B?WW40STlWbWtYUXZHc0RrZnVrd2NWeno0K2UyMVNOY0Q2YTR2ZWg1YU4xU0pC?=
 =?utf-8?B?eTQ4Vk1RNnBWb1dIV2tVZTQrUFNVUjlUN1JuMFpGeCtFcXhzaEZzUEZuWFdk?=
 =?utf-8?B?WXJmTStqQ3V2NmtSbnd0QmdLTUw1ZTNzV0V6OHNXb1Uwaldrd1VFQzdVaDdL?=
 =?utf-8?B?cXpkVzFyU1UyU1dVYURQWGU3Y0VPOURmTEFjR1pUL3F3U3hQbzFMditMSWZE?=
 =?utf-8?B?SGI4ZVM0SUJGdHNKcXNzQ0ZVeU5wSnhtWHRoY0s1N1VDbzBCWUJ0ZTlhVmZ5?=
 =?utf-8?B?d2YyUnMxZUpRWVBLZUVERUt3UWxtVzhaL05xcitHM3BMS1JsbzVjUlpUWGFs?=
 =?utf-8?B?cUhrWW9aZUw3aWJINnE2YXZvQ0I2MTR3TjM2dzJuTUY4K1NjNFdFd1hUSHBv?=
 =?utf-8?B?QVRLWVRLeHdHdjM2VGI4ZmpzRWtmRzJodXhib21JQnAvMEVicDFQVFB1QWFR?=
 =?utf-8?B?QlBNVitVay92bHBSTmdBN2JreUxvcVVPWjB4dnNKQ1ZFaFV5UlAydGttOUMr?=
 =?utf-8?B?RnI4V281cUh6UWloU3NaWGhFdWdIUGxuTzVqL2FhZGJoeDhmL2lod3ZiT2s1?=
 =?utf-8?B?bDdqcTBoODhPRkJpUENISzNLWlovVmgrTmFqQk9UenBIdEpDVG1hbEJBdDFw?=
 =?utf-8?B?ek5BcWNrS2NDNlFDTk1keVhrZGRqT0RMZ3NSOWlJcllsVVV6MUFVRDFMRGVj?=
 =?utf-8?B?RGpIbUplanJxMjRKbk1vMWN4eEJNbDloYVdKdVN6N0hoT1pjY0NkeFd4dk02?=
 =?utf-8?B?TlVNNGE2bUhEdzFzMHNQYnU3RXJabnp5dGp3TTBtMDZCM0NzcXlhRGUyclVF?=
 =?utf-8?B?WlpsWmExaFIxeWhNRWJ6NDNwZ2ZhY1VUektGQlplK0FneXlUaTdZYmNXK0RK?=
 =?utf-8?B?b0VRYndqajByTnk1U0Y0czJ2VjRuejZKY3JYZVl2cWN4L3R0KzhkU25BSjFU?=
 =?utf-8?B?dzNvWDZXSHlqS0VwdnRobHBVdEJ3cEVlQUlyM2J6L3BiSHcybGZyVUhHVnJw?=
 =?utf-8?B?WUQ2a1hNWnJ2TmhJNzBMUSt6a055OHNZOUVxVkFIZHhPcUMzMUdXaEgzWCtX?=
 =?utf-8?B?TzRuZW55WEljNklrNml1cUlST2hmbkYvekh1YmYzWmhMVE9yT2tJMDlqemU4?=
 =?utf-8?B?aUNBUDQ4MWd1NzBPQUVzM1lMbHJmRyt6aENoNWlpRkRFUFJkNWZNcmlXZ1d0?=
 =?utf-8?B?ZmNUdERWc3FHMFNqUVp2d0pveVVVam9SUVBTcG1VbXBCMzlqOHRFYUVEMEdP?=
 =?utf-8?B?Q1RMUDdnK2xobXQ5SCtkQm1kMnRYbnpqTGVRMENyYm5DWm11L3U2M245SnFI?=
 =?utf-8?B?UlBBUVJlc2dxdW9lK25Uc25Jek5meUZIMld3R0lkY1laZkNJaTRtOFRXVGFl?=
 =?utf-8?B?VVhBS3NhNU5YMy9mb0xwTlVDRnYvN2lKbWdFNit0dmRYUm92OWRMWHBjSnA1?=
 =?utf-8?B?Y3p2U2RXcG1uTU9zSkExbzZMV3gxRk5tL2ZVRFBUNG5rb0R4eHdDcVgwcmk4?=
 =?utf-8?B?ekNZelg1VkJBQnZYbmhZZTZkMHJMelJGbmY1S1poQjV3TFgzL3JTckxja3ho?=
 =?utf-8?B?dUhQRWNXNVlOSHEzbFg4SDdXZHNHbmxkUkFPcUlmUjY0UDZya2lzN3lONTBK?=
 =?utf-8?B?d2FBYmhYeVVoQWk4SWhrK2FUQ3JYRDZsUlpIWFFRdmRvdXpGUlh0ZjZ4MGtL?=
 =?utf-8?B?WXFLeUQvZ1MrcVdlSm9NS2VNMnIrRitmanJIMFVtMVg1Wk5YdVpsdi9SeVdj?=
 =?utf-8?Q?VJBdFGNYDpTNnPiFKY3G+CyEZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ea9c85-b863-41aa-bc14-08dc5f804816
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 08:19:35.3009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /R9iPIbpcWlGe3thfXbxn0jnY72haL2ezCFGP1+LserI+j4gToN6ujlDcJy22tybPBe9ARJHjP4POXvJwNuE6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7310
X-OriginatorOrg: intel.com

On 2024/4/18 08:21, Tian, Kevin wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Thursday, April 18, 2024 4:26 AM
>>
>> On Wed, 17 Apr 2024 07:09:52 +0000
>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>>
>>>> From: Alex Williamson <alex.williamson@redhat.com>
>>>> Sent: Wednesday, April 17, 2024 1:57 AM
>>>>
>>>> On Fri, 12 Apr 2024 01:21:21 -0700
>>>> Yi Liu <yi.l.liu@intel.com> wrote:
>>>>
>>>>> + */
>>>>> +struct vfio_device_feature_pasid {
>>>>> +	__u16 capabilities;
>>>>> +#define VFIO_DEVICE_PASID_CAP_EXEC	(1 << 0)
>>>>> +#define VFIO_DEVICE_PASID_CAP_PRIV	(1 << 1)
>>>>> +	__u8 width;
>>>>> +	__u8 __reserved;
>>>>> +};
>>>>
>>>> Building on Kevin's comment on the cover letter, if we could describe
>>>> an offset for emulating a PASID capability, this seems like the place
>>>> we'd do it.  I think we're not doing that because we'd like an in-band
>>>> mechanism for a device to report unused config space, such as a DVSEC
>>>> capability, so that it can be implemented on a physical device.  As
>>>> noted in the commit log here, we'd also prefer not to bloat the kernel
>>>> with more device quirks.
>>>>
>>>> In an ideal world we might be able to jump start support of that DVSEC
>>>> option by emulating the DVSEC capability on top of the PASID capability
>>>> for PFs, but unfortunately the PASID capability is 8 bytes while the
>>>> DVSEC capability is at least 12 bytes, so we can't implement that
>>>> generically either.
>>>
>>> Yeah, that's a problem.
>>>
>>>>
>>>> I don't know there's any good solution here or whether there's actually
>>>> any value to the PASID capability on a PF, but do we need to consider
>>>> leaving a field+flag here to describe the offset for that scenario?
>>>
>>> Yes, I prefer to this way.
>>>
>>>> Would we then allow variant drivers to take advantage of it?  Does this
>>>> then turn into the quirk that we're trying to avoid in the kernel
>>>> rather than userspace and is that a problem?  Thanks,
>>>>
>>>
>>> We don't want to proactively pursue quirks in the kernel.
>>>
>>> But if a variant driver exists for other reasons, I don't see why it
>>> should be prohibited from deciding an offset to ease the
>>> userspace. 😊
>>
>> At that point we've turned the corner into an arbitrary policy decision
>> that I can't defend.  A "worthy" variant driver can implement something
>> through a side channel vfio API, but implementing that side channel
>> itself is not enough to justify a variant driver?  It doesn't make
>> sense.
>>
>> Further, if we have a variant driver, why do we need a side channel for
>> the purpose of describing available config space when we expect devices
>> themselves to eventually describe the same through a DVSEC capability?
>> The purpose of enabling variant drivers is to enhance the functionality
>> of the device.  Adding an emulated DVSEC capability seems like a valid
>> enhancement to justify a variant driver to me.
>>
>> So the more I think about it, it would be easy to add something here
>> that hints a location for an emulated PASID capability in the VMM, but
>> it would also be counterproductive to an end goal of having a DVSEC
>> capability that describes unused config space.  The very narrow scope
>> where that side-band channel would be useful is an unknown PF device
>> which doesn't implement a DVSEC capability and without intervention
>> simply behaves as it always has, without PASID support.
>>
>> A vendor desiring such support can a) implement DVSEC in the hardware,
>> b) implement a variant driver emulating a DVSEC capability, or c)
>> directly modify the VMM to tell it where to place the PASID capability.
>> I also don't think we should exclude the possibility that b) could turn
>> into a shared variant driver that knows about multiple devices and has
>> a table of free config space for each.  Option c) is only the last
>> resort if there's not already 12 bytes of contiguous, aligned free
>> space to place a DVSEC capability.  That seems unlikely.
> 
> or b) could be a table in vfio_pci_config.c i.e. kind of making vfio-pci
> as the shared variant driver.
> 
>>
>> At some point we need to define the format and use of this DVSEC.  Do
>> we allow (not require) one at every gap in config space that's at least
>> 12-bytes long and adjust the DVSEC Length to describe longer gaps, or do
> 
> Does PCI spec allows multiple same-type capabilities co-existing?

For DVSEC, it allows. Below is the sentence from PCIe spec.

A single PCI Express Function or RCRB is permitted to contain multiple 
DVSEC Capability structures


>> we use a single DVSEC to describe a table of ranges throughout extended
>> (maybe even conventional) config space?  The former seems easier,
> 
> this might be challenging as the table itself requires a contiguous
> large free block.
> 
>> especially if we expect a device has a large block of free space,
>> enough for multiple emulated capabilities and described by a single
>> DVSEC.  Thanks,
>>

this is a good point. The ATS and PRI capability do not exist in VF as
well. They need to be emulated.

> 
> yes that sounds simpler.

-- 
Regards,
Yi Liu

