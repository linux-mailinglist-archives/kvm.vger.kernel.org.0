Return-Path: <kvm+bounces-12859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FFCA88E650
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:36:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C75FD2C2A95
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFF3B13A254;
	Wed, 27 Mar 2024 13:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E6qiNTTV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B931112F581
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711544847; cv=fail; b=eTdfCLXjOiidAZB41jS3PZEcLSYcCRDpIJuhRlxMxLSg3A/k3FoPytUHJsA9HYlMghAswToiHddxIaakHBnMrtjPXygzkUeLrGo19WYf2Ik6wnYx9qG7IpwizMS80EFYCClUwsPsDvYk9/XiGp/SBU5paj7wfT+UMTl2Zc8arHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711544847; c=relaxed/simple;
	bh=ISyPnmbNZCuBIduo1vywftHQ/Xs+S2RyIB6fgtmN9q8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m0MPspx789IKF5PhQnAIXBozCtLO2TIW570V78JV6VBIwIHUlhsmx8nqoq3/oCps4QWJIg/PjMBUW7cFNsThm8PISShJWl12t1gn/A2UJyzq6p80KNxdIVtAAamjgn01fM9LgttI4G1RNTZH+zm7qFa6IuP9ezOYOmEa3Qx4seI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E6qiNTTV; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711544844; x=1743080844;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ISyPnmbNZCuBIduo1vywftHQ/Xs+S2RyIB6fgtmN9q8=;
  b=E6qiNTTVIxsVzzw4Qcs8mY1PD73Y7mPyMG+YZrdXihR+OpUTlAcYedkv
   MBYlLJr5pOeJk2BZmgrnII0Ga6EWbQqGs3xlwov4OHl+Don2K2dIZgnuu
   BOvKIy9vbpwHXfxnWflOvs3vrlN4C9BCRBz2CGV6GIYJS+F0wTKUgHVuU
   MIszLGynC3XKnHFo510csQnue/YEBCoxfqBn6i0nprVaEjmccbREjKWZe
   p4t702rEqgbmX8hkWRSQFuh/rsjK2zbIAP8uLsf03T1NWrptGY0pQyJ1g
   Wwec4pTr3D3PckkfrhSNt6HfWycq1AUt0S0RnCg6iROeVD/r8jXycv5iP
   A==;
X-CSE-ConnectionGUID: hS53HyesT3+jAuYxSowUCQ==
X-CSE-MsgGUID: MXGxzp+lQbSRgpepCsITZA==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6469773"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="6469773"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 06:07:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="16242573"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 06:07:23 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 06:07:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 06:07:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 06:07:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 06:07:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHcXRTxvUof7HIse0Qw/0PZYWwaaYhOpX1pLQUeplVBML8LMK3/0Mfv17szowbq+xw6MnnXsjixO3/qgoemeLaYmkYvqPto/chU5MU/Dm041m8EHXTpQ9gV5GyahghefA2XoXSKJzX9bln1h7CUVeg+ULIL0M0y5WJ8JCoJ9C6LtOg+D1tEYG5Hiwqc+gQZ6V1o6rNAqihRyuf3KmmcrZBN6vGs93dQ1ofob37+a8YLXjEuhGQSYLXOeZ9BTgGp4/roGG+p9rUPLq2eMTtYS4KFkn8h5kQwQZ9i8XIuQycKmcccrpYTivBtD0twtnU1XvsvLITSS6c0HDHvulTickg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daCkXhzYgd3FY1h0CKdvW/iUpSlg2NPP85ovdAuXwZo=;
 b=DyyC6j0W7Ko+SULBH815lsgW01nKoq0Z/iHUcXNfq3d9WlIcM0wTeE18nQl0SgdGgmpkA+p3vbm3XIEH7nlZ2VH8/J+9Cxobd/ZIb93d7F0bPbloEV3fplvu6paDLanlQF9Y2JtWhid+SxKpSRz6qgWpNO2+5o/xk5cp+UKEO5StIEkSmASZ4cISY42tbNxgmCZW6A6B8gz5f+B0q198InWocAhmjGYjZDj8FYiBe/yn0++hmJ5iNQNEayuQh+TMwDOqoOYr6jyBoo4oZq+iWbEGfl7ykVprJqNSSnlSuNjD6fBuQzuYHXstGB+/mTkG2/GrfzfwoAxYe98xAX3DDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ2PR11MB8539.namprd11.prod.outlook.com (2603:10b6:a03:56e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Wed, 27 Mar
 2024 13:07:13 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c%3]) with mapi id 15.20.7409.028; Wed, 27 Mar 2024
 13:07:13 +0000
Message-ID: <853e292f-a4ad-4d38-b806-c223c441295f@intel.com>
Date: Wed, 27 Mar 2024 21:10:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iommu: Pass domain to remove_dev_pasid() op
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <jacob.jun.pan@intel.com>
References: <20240327125433.248946-1-yi.l.liu@intel.com>
 <20240327125433.248946-2-yi.l.liu@intel.com>
 <20240327130234.GE946323@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240327130234.GE946323@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0052.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::21)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ2PR11MB8539:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b7b7b30-2802-420c-56a1-08dc4e5ed1ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RUl3VanEAVPQACBIfz5mE+wGJctj9OVvvu+nrStmBY7A4yw4Q0fCLsid4Ewxf2FsCdfWO84PW4PdnrypZ/jsWjm8ZcuyjMWTEAzUHtPdiyE/V/nON3yAxMrPv+slRVt50tUgfIRZXdXSJzetvh/7Lrg6prSz9GPv3F6wuxbGcRDpOVa1PF7e1MII6oyeAV0XzJPu6mHlZH9IavnthkEHNcYD1Dobj42KJ8H5SPaIaHv6tqvv4Kdr09nCm2MdecNadDWrFMr29vRO+smM/q7bQOIOQRfIbiUopwiqyOGm35r66iWu9O48ZNA252IWmNg+h/H4dsPNazplklN2PSARH/E/qF1nKZ8+KfQKx9HUTYgN9RjrfQ3ABkwPQhw+qvZdEXM6RegCMhfOc2gnwBGu/0ZGccz64vgInYaxZRYk6FzrH4htRxiJZ9yuM6JZyp8pjinYhLnwPLkzjtJLA9DhA74Cxg6O/EJ6POY9H6BkpEBqkjI3RYd0G6vaqitum5lneeFD9QzhdfpZAr14VCrj0E7K7vy9Ozdnm7lolCDLZP+lfrligTJGsTwgcZ2NJsDbbpUFL/erb4uVBAhoT/enmneul12UfzPUt7tz1xXF9OA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG53eitYUEo3S2NXcDl3bnQzTmlNU1kyMWJYK0l1UXpDbXpRZlY1K3pjQXEz?=
 =?utf-8?B?R0lMd3VQMzJzUlkrZ1RPNDg3akROdjVxcVpoazJRcDVTbHU5azZMclExdmk2?=
 =?utf-8?B?TC9naVBYTTMrMHkzMjJKcUhJSzdTWW9pVUM2VzUxTEN4WVovYW9yMkJjbTFa?=
 =?utf-8?B?VjVTc2pLdFp6aFVESzB4M0lVbUx5ZzR6S0h0VkcwMXQ2YXF5L0xrVEFGMjhn?=
 =?utf-8?B?R3k3TGV6WnFwSnpXYU1QRjVueFJmVWRxMVBwM0NIMkE5dmlNeXoxUVNSb3Ur?=
 =?utf-8?B?RllRTG1LWFgybnlqS2wwRExLK2s3eHlYWmN2TnpReTFGVnFZNmYvR1czWlZD?=
 =?utf-8?B?QzJPR2R0aHQ0RDFwV2x3TndTNk5JNVp4cXBTb25WUjNOMmt3WjAvcnB1SCtT?=
 =?utf-8?B?MkVHWDIyR1ZOb3k2dzRFNG5CV2VldTBaL01lMDBhMWdIMlhHYW9OQVAvN2hJ?=
 =?utf-8?B?eFBsS0NkNGlyYkhIYXZscFdITUFSZFV6aTl6SStLNnB2amFuM1NyZm1vNk5u?=
 =?utf-8?B?S2xTZnYzZm8zQ1lOcm1lc09HaGQwYXd4L1Z4WGY5QnZjS0FMQmd3NVhtWmY2?=
 =?utf-8?B?bk9xTFhjUDFiTzIzTXVuZ1hzeUJvd2MzanliTE5yZlppMFB4Vk1idU1FdVVP?=
 =?utf-8?B?dk5yVFFDdFRMNmpaSmdvVVJ6THIxbGpMVEpRT3JmSnZqS1FLYzlkUlBZRDBT?=
 =?utf-8?B?bm5hc3hIU2tmRHV4MHZSWTNHRGlYUXRwUTBFemFNV3BySXV1aS9udjV3eGdZ?=
 =?utf-8?B?VGZVYXdmMnJROHpsQnZRcVZNRE5SOTFPc3FxZ3czbVY0Vms2dXFWVkNKeHNQ?=
 =?utf-8?B?N0lvRU1lRjRVYVQzMm1mVHJsYi80Q1p4MkhIM2JqcTFRS0dhUTVTa2hIWXNs?=
 =?utf-8?B?dk91UnJrbzdFTDlRY0tZNzVzK045MHRqS2duQ2o3bmkvbjBXZHdlNnVjSnR2?=
 =?utf-8?B?TTNIT3M1dWRxaC9SVEtqVVMvSEhDc3l3TGtOUFN2RCtrYjIwbkR6c1lPTWhD?=
 =?utf-8?B?dEZQczZFR0oxVUxFaDhyRjV6WnZsMHUzMXlzOWZnYlVPcmZVNjhtMmxLMm1r?=
 =?utf-8?B?SGMzOEEvcDNaLzJQOFl5TWdKbW5CbVkwWUo5Z0h0aEpqckVUc2tOVE4yZ2M4?=
 =?utf-8?B?T3FlaGZoSXNuSnBmYy8xTXhrMlJmSzdHMHIxY3pNeHF2bFJnT0srVUJ4UitV?=
 =?utf-8?B?QVdIRUhlRlgyTVpZRUpoY3ZpdEdrUGFUQkZLSXVpRStrclZ5cThhSGtsQ2I4?=
 =?utf-8?B?TE5rSWt0SU4wdlhPdlgwYU1LMmM2MHJCQytyUEl6NVVEbzQ5dHpITnV6cTdr?=
 =?utf-8?B?NTM1YlBEOG1UUTI0enNBd2xjendiUXRUUHU4NTVHVHFUUTNuQWhlTW8xQzdI?=
 =?utf-8?B?dnV2aUlvbGdOblZiMlhaS1l3dVVJT1VqdVBVbjZGeE1yb1k4ZEZXbk1QR05V?=
 =?utf-8?B?akI3bkxBTGYxY1lwck1ZNjMrU0VjazdKYmx1V0FMRmRGN2JiWUtDZUhyd3lw?=
 =?utf-8?B?MUh5UGsvZGZRRjFVeDZnc0pOY2V0ZFBsbjRrWXNzSjZvTWRiSTIyYUdqRFQy?=
 =?utf-8?B?TUhScDZIM0xMeVZRc1BQNW1WVW1ISTFzbUIvby93OXNzUW55eDVJWGhVVzlK?=
 =?utf-8?B?T1VrNll3MGt6azBTN0phN2k5OXZJeWxtVlhYQ2V6YUlXN01va2lZbm1wUThr?=
 =?utf-8?B?MjRDWFg2YndZSWlFSHBweE1RTldUOUhaaTc0Ulg2VWpWeVEzRXo0bWZ1OGQ3?=
 =?utf-8?B?dmF1eFR3SisyaFZnUDFlc2U5OENER0JtUm1hVVQxeDBVQUpXYmI5c0loR2VG?=
 =?utf-8?B?L0l3TFFvTUdTOWRaRWtRaTlKK05pcC9jOXl0MkhXNmpRTGFIaGlQaGZMb3FC?=
 =?utf-8?B?YXN5Mlg0MTRaRVpDUEhyNzJjd3ovYWJlb3dMSlZtVXZ3Sjh6bGQ0Mm85K2FG?=
 =?utf-8?B?Rk4xeFEyaHRON3M3RXFVVWk2MVNXUE9WUFdQM2M5eWpZNnhZWElodGhQNGk0?=
 =?utf-8?B?WFJUcWFMd0gvUEt0akhmV2NwcEp2Z2xodFg2ajdneWZFSldmd3lSV2ZJRHJq?=
 =?utf-8?B?cElVbEs0QzlqU3BWU3FIaEFYTmRDa0VsYTkyWlowRGxDY3pHMEJPeU5wMjhi?=
 =?utf-8?Q?7+NDcyk/QAQnqo49tHpykjKdo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7b7b30-2802-420c-56a1-08dc4e5ed1ba
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 13:07:13.6116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vfQE1+lrPYJ3wI7BOMvjfpAsTg4UFyMIoqzMSmOo5ImnvUZGI/ZE2RWF8OIwUnKVejRKCkkfwwApKZ2IuL/kXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8539
X-OriginatorOrg: intel.com

On 2024/3/27 21:02, Jason Gunthorpe wrote:
> On Wed, Mar 27, 2024 at 05:54:32AM -0700, Yi Liu wrote:
>> Existing remove_dev_pasid() callbacks of the underlying iommu drivers get
>> the attached domain from the group->pasid_array. However, the domains
>> stored in group->pasid_array are not always correct. For example, the
>> set_dev_pasid() path updates group->pasid_array first and then invoke
>> remove_dev_pasid() callback when error happened. The remove_dev_pasid()
>> callback would get the updated domain. This is not correct for the
>> devices that are still attached with an old domain or just no attached
>> domain.
>>
>> To avoid the above problem, passing the attached domain to the
>> remove_dev_pasid() callback is more reliable.
> 
> I've relaized we have the same issue with set_dev_pasid, there is no
> way for the driver to get the old domain since the xarray was updated
> before calling set_dev_pasid. This is unlike the RID path. Meaning
> drivers can't implement PASID replace.
> 
> So we need another patch to pass the old domain into set_dev_pasid
> too...

yes. you've given this suggestion in below. :) I've already in this way.
Will send it out together with other iommufd pasid attach/replace/detach
patches.

https://lore.kernel.org/linux-iommu/20240318165247.GD5825@nvidia.com/

> 
> This looks fine
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

thanks.

-- 
Regards,
Yi Liu

