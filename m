Return-Path: <kvm+bounces-12967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A2EC88F7DA
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 07:25:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C7981C23801
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 06:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5074A4EB5C;
	Thu, 28 Mar 2024 06:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CX+PGRNi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF082913
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 06:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711607146; cv=fail; b=sSktvRSSbM0843sfFfN7mwmiWSUqY9OPnFva/Go3qfhCCx7ztpquRaSiF+365yCBJrSW3FsWTYPvMiSg9GziWs7KQmL3NkinJOofWToqRwKhCViwXf7E9tu6kvDCNHm3Cp5FUpLkxlP/Kls7pLYwh2grwMiOweQz7v+nGSLqN+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711607146; c=relaxed/simple;
	bh=SYV3y+maHAaX1soHhuQhWRI1suaBRJ/oeKLEmhzMx3c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ra7kihUC7qNj7Gg02REQKH/nYBIBoa2uUzlSdFRsnUeK312kqat5FU/h22oSWUQyD58L4lee0y2ay3cMLxGrZYMVxg0csBHikyMg7YH5tlUl3UQNYS3Uot5SD7piMbOn04IUi6+gVmX0GC3Rk6LsrNFq53FzbN/MVDbpksTCc10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CX+PGRNi; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711607144; x=1743143144;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SYV3y+maHAaX1soHhuQhWRI1suaBRJ/oeKLEmhzMx3c=;
  b=CX+PGRNiTuWcTGBlLNBWWOmeSfyrDiSZZAAHAMHbVWw01ml8jWGxpE7z
   K5yjnVu0BwMYYqUClCiCIacB/dtKosgrcu/wZo2vwWae/a7ZWNOUDbIoR
   4xug5IvjtDNRLMMHaw6DpWz+Bq8BjxZVuiaxnFLuPeNJTTVIrdbGHn8Bo
   kDV3ZEZ2nQvecTihplJQZjDuMgr/YguS7g96psyAjAPirYxUPVpuIgD6f
   eysEpgKbLP7n4iAS/gt4pcKAB6Yod5AgL8jNU2lWbF3GuzkCnj8F9F4Mg
   xVs6AKNY6og3F9+2JcoNDHQ0cdBBpTZYLR5mXhbrCxYpR+HxWFYB8vA97
   w==;
X-CSE-ConnectionGUID: PxNiVJ6aTDK04ycWNER3UA==
X-CSE-MsgGUID: NcmtcrvUSOuwxvAUFafg4g==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="29224338"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="29224338"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 23:25:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="16574859"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 23:25:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 23:25:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 23:25:42 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 23:25:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brJFBC6QnOwdSS0OpGvZwuNIEMQYYOyIsyMoSfgDhPlnENW1ZWt6WnWzuQWmXoLsMKfiQvDvc6aGK1+6JgScHeme2N4nKPtGS7O8KT8qOJ0e2mDYz38KhaoFsjkanLj64RnH9Wv6nynsFASJCbL0ujr8Vr26HCs735V0I1ZOdzjwMMht89Le4J5nEX/u4d4GZ1cFD5cXHZkhZZf8uUNKsnN0mCaqZdrplyP7UuPBr1F7118wbbChOEscwu7eze3JWXNuuatiCbe2xF5vzid4kXw1TX5v7Mz3Ko7khhQ7c1slA8IzC1ug7d3OS55fzME+WRf/UFB0rC8bMVPiISbKqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwBOr3LJcs8nO3CT/MydMPHgumOxpWiYxTOW5QROEuE=;
 b=Ecc1PHRmTK+z1DMGYSkADbhVHlM6T0xbXXd+ryEGAAifJg5H/0woqbHdvINi5jMWBZ4xM94zH999Xx/p48GsGHYRtJ1eVk7x5Fsul20UdYGAp7x1mt7Ok6bGiK9GDHtU0VzBPf6Yb/aE1wu2O+O4DVGm8KgI9LZUm/K2F/v+IO3JRqyjlxqIWR7morpipn4LRZepXCtK/6AtLiJMHsCNjS95xvdAYmLO5YsS9OQU1yNZeu2C8eZz+y7LKNHnOyXbMc7YZtUBZxyAkLOZnIYZmOkcP42EBNbpR5MABx+CqmSsy5U2C7tFmTaUnPcbeLYPt66/uFIussPzBZh9QD0tuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM6PR11MB4548.namprd11.prod.outlook.com (2603:10b6:5:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 06:25:41 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c%3]) with mapi id 15.20.7409.028; Thu, 28 Mar 2024
 06:25:41 +0000
Message-ID: <e234b46f-e886-43eb-84f1-1eb1b7eb4fe4@intel.com>
Date: Thu, 28 Mar 2024 14:29:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] iommu: Undo pasid attachment only for the devices
 that have succeeded
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Pan,
 Jacob jun" <jacob.jun.pan@intel.com>
References: <20240327125433.248946-1-yi.l.liu@intel.com>
 <20240327125433.248946-3-yi.l.liu@intel.com>
 <BN9PR11MB5276AB09D5A9E183C3492AD18C3B2@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276AB09D5A9E183C3492AD18C3B2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0131.apcprd03.prod.outlook.com
 (2603:1096:4:91::35) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM6PR11MB4548:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d3e7187-2286-40f1-d175-08dc4eefe3e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9DP0m1b3/jCqjWtM+4aNuQxvuyzyEkkfitE0z71WGoO1oPrQ3/FyBDpCfzbD5Jxu3cUTYv46xrf5W2iLDXyrYMeeUN5uFRFkpjp/RqqqoZlNXcjHq6h5O0sql+KWx1JVAU4JnRxcBdkmjeGW4JsnbxMzU8ak8WRc8bvqGaUxBqg0dC/bZEI1hD/OsiidQM8ZhNmOndzEBpAVa85KRVNY8nKjKoJHrMt0D0l3j9rdqSlV+ohKttZ9ur7woIHtk8gIQY26M3E0cS5yzCmtDUVvyVSSjzddM1qlWGXfuWAMhCk1hmwzl70WiUSxR5VpXlckbh7BxlUKFOc3SZrp6gGnFvhHOT713eOvI2PCUkdiyBr0yT1RNwm+fy5RiRO3y2fKCmPUNiqssjIKk7Le4seSzJ9tW5nNVZRYZKAOCsBNNfxbImtxRIROrLo16IvCa3EdAT7V2Du0t7F0HZD+rBIEdLnah494zZqzFzoi0ODVcFZNQn453MN/8eJgXNhCfazvrYsWWthJ7j97i7OIdSWLQBDgMhfp6iCMlkscZv2hgdliXZ/5xoLlPtdmWiNGUIju7NF+BdNiYV8tybvT/M+nTlAp86SlEqCnlyWVg4udxXofk47tWIy5XpewQuobyxjTVwTpRv/MdMqUXekZt/4I6jzYfH1z+Pi2YxL80PujOg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHdMYklMZ1V3Y1FROWJURUVJVVFXenk1S3JVMDJ6R1BZS1NNR09RTmlIWkk5?=
 =?utf-8?B?YU1Oa2gwODBzT0kvL21oRmlqQTI0d05YdDBHanl0ZThSWlFWdWNhVWFGVGxo?=
 =?utf-8?B?NnhKMEM0QzBWVzdlT3pEOU9KMko1b2dHZDF2akZzNENrTnR4TkZGWXZVUlVC?=
 =?utf-8?B?TXFLekJJSUpFbHhCeE02ankra1ZZN1pyYjl4eWU5Y3BZTzUySzllVlNjQ211?=
 =?utf-8?B?TU9iMllhS2FNVURwQUtCdTExREtTNUw3elgrYjB4Yzd2a3hRZUV0UHZvQmtE?=
 =?utf-8?B?N2R4WTNjVmRHUXRPNE5temNFaTV5aEtoY3JlbDg4dllEYmlwQWxaLzZZZUw0?=
 =?utf-8?B?cHVGRzBHV2dVSFpRWDJudUZrMk1vUmdTMVFlN0JBbGY4N2NFd0xabGtYcjNO?=
 =?utf-8?B?RkphM0lVc3RpNXFmY0t0OHNEQmFQVFMrM2tZMkloUmJtZE9VcTBPMTVkR3Zn?=
 =?utf-8?B?Sjlydm8zL3NEbmRMWnJDQzBYY3hpMXZvclZSK1lubU5VQzl3YWxWUVFtR2dh?=
 =?utf-8?B?ZDlibXVxcWppVVd0ajBZM1RnN2tWSHNTamRPeVFzLzE3Q2wrVVJ5R1BwazVj?=
 =?utf-8?B?VG1RUFM3VFJHMW9MbnAzYitnQzZVS3BuQVFFVlN1enEra0VpVDZUYXl6Wkdv?=
 =?utf-8?B?Skpid0p0dk84ek1XdGNVSUNsWXFvOGZydmxsRUhrcUswK2RWYVY2WVlidlI0?=
 =?utf-8?B?WFdIdEF1L3J0ZTVwOTg1VVcxbjNqd255U3JJTVJCb1d1TUFnNVZNSXRLMDFE?=
 =?utf-8?B?OVN1SzJNOGZ6SmJkVU9kWDlWaTZjUDM5UTlCeUlBVVpFeUVlM1Zoc2Y4WUNy?=
 =?utf-8?B?L3hON1pOdjhzRkt1d0RGeE5mcUMwc01sVHRPSmNpRithQUlSRmd4Q3JFOEt0?=
 =?utf-8?B?R011TURBZGNidzBWcTAxdkRiQmpLNkJTZzhGclBEWUFtL01ac1dyNnloVnZx?=
 =?utf-8?B?KzVrSUxIUWlsM3JhOXFXV2o5eW1yRTJrL3dOdVpaN3FlSHpLclR3SWRRMEVQ?=
 =?utf-8?B?Q0E2MDNBNHBvb2tEN2toSEFPS1NVdkFwa0NCZEtkWGNNdkVRRUNOWFI3d2NO?=
 =?utf-8?B?RUZPdkZSdHM4ZVMvakltNVRYaHAyQXBYVEdvQWVkTkxndytmRVJ3bkh6V3lN?=
 =?utf-8?B?UVdFa05zQWRqZmVockFhSEFoVXB0ZnJraHlmQjZ2Rk1EZTQzUVZiUWI0U0Ew?=
 =?utf-8?B?K1FLQlpDK1VoRXdXZnN0MXpWWEN5Rk9PeEQzRVN1VE1XL3BMMWdwWmdQZlJr?=
 =?utf-8?B?dWZjNlpKYW03STJITnE1Q2YxYkNmSFlLN1cyUWdidURtRGJEYzArNXhkU3pN?=
 =?utf-8?B?NTFndis5OFBYckNiNnJ0MHVQNGd3UkZTOUVtVGxHOU1GcmtsMTNVTFdyZmFW?=
 =?utf-8?B?eGVQRUd1MjVCY3lZcU5ibzR4RFp6b3ZUU2dhbVFOVzZMamYyQ2IzZlRmdy94?=
 =?utf-8?B?aExnRTc3Ynd1VGk1cnQybkF0anQxQnQ0UUNzVFlZVmhsYkJPNVRFbE5mQWc2?=
 =?utf-8?B?dTRQaVJ2ZzJ2ZFR1VUR1R1p0b2Y2MmNPVXRKS0hYNnovR2dNazdCKzBEY3Ey?=
 =?utf-8?B?dnB4V3N0U2tndnd2bTNNM0swSEI2YU9FSFhuNEdLRTU5Y25hc29ReWY0L0VO?=
 =?utf-8?B?K2VlU2ZFZVVuWFlZS2kyVC8rWFZaR1piREpqZERmVmNQRnVpdWwzQlBDTjlS?=
 =?utf-8?B?amhTeVhFb2JicytJakxMTzR1QkMwNDBLQlVTVEJIWTBZZE1QcWVsZEg3ZFBP?=
 =?utf-8?B?bzZGV1c1cWlWc01YTTZ1ZEQ3NnJ6RklCeSthTEZGK2V5NHBpZmw2OEZNaXda?=
 =?utf-8?B?NWdjSWtmdEsyaGsvMXFrYXNIZ29EN2JLZ09weFdNVURlRWdTTUZzc3MrUjk4?=
 =?utf-8?B?V1NDZXRBRHZ2dkt0ZzdHZkpRcmkzU09NVEdlYkg5NGllSW9kWnlYM1VWd201?=
 =?utf-8?B?ejJlVjlhMEZuZU83SStCR2U0VFhWMFFFbkF6Zmp3ZTJxRU9zN0FZcnc3TnY2?=
 =?utf-8?B?TUdEclZvRU1md1hxdTVHNFBFVnlGc2N4YllnZlpnRW1jR25lWFpRaXhXMHhM?=
 =?utf-8?B?VGxTcjE2eFNwTXNHNjZSRGtHVUtqelZHUlB0dUF6Z2hoN1VlM2V3NVlVb28x?=
 =?utf-8?Q?/+RRzLMq1qS8f8toRnkwFIC4C?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3e7187-2286-40f1-d175-08dc4eefe3e5
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 06:25:41.0318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DIb8n2FLKrM/TR5LIIMqrGc0C4YvJdT8yaBMJYySiJvoMZOuffSHxaBXY9vcNCQMKyS4VVSRJ0TJgU7JjKHl3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4548
X-OriginatorOrg: intel.com

On 2024/3/28 11:15, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Wednesday, March 27, 2024 8:55 PM
>> +
>> +err_revert:
>> +	last_gdev = device;
>> +	for_each_group_device(group, device) {
>> +		if (device == last_gdev)
>> +			break;
>> +		dev_iommu_ops(device->dev)->remove_dev_pasid(device-
>>> dev,
>> +							     pasid, domain);
>> +	}
> 
> break the long line into:
> 	ops = dev_iommu_ops(device->dev);
> 	ops->remove_dev_pasid();

got it.

> otherwise it looks good to me:
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

-- 
Regards,
Yi Liu

