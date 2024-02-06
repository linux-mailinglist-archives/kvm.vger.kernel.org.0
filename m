Return-Path: <kvm+bounces-8159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B498284BF6D
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 22:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B5AA28938B
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C611CD29;
	Tue,  6 Feb 2024 21:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yp1N2Q8h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1661CD13;
	Tue,  6 Feb 2024 21:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707255944; cv=fail; b=kah+2BD3BAGPRUOwab2nxttivC2lCTKWU1A+NU3T45A8spIR+vmcv+kiGOKhBwu64edvTJvV2RKsXf+UzgJ92gu67umJivOGUsNIhla3Ce6nhioeFU5+L3fGekAACawSM+7s6WMovyyJpjDRtTHE9qShmyTQHdOMsd6uvbqd6x8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707255944; c=relaxed/simple;
	bh=Gti50k7EMY07KoZ8bynSTWO4cKvKhf6Nz9AdUMonyfw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oVQSknnVzGOoZ7CM3p5zqk7jHMjNi4wvquJ6BAjjv375E9KrJR1Y5KwneOKFVmxe7hZliRmypyUE8BSsvIBjQweDzq0YYKqPnJ783aE9rZwE4ZM0DBGjb6zwHDPWsbwkBNrI8PjoqJnasnV5cCBaL40BAp3T9G+qrOFy9rBHWh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yp1N2Q8h; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707255943; x=1738791943;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gti50k7EMY07KoZ8bynSTWO4cKvKhf6Nz9AdUMonyfw=;
  b=Yp1N2Q8hRkhhhOu58NJ3CuHZa2OvoUVqDY+OEK6LAI6uLNJazEB6bGoJ
   0nAbROiIlFwmTGxg9EZkLUlQlPH4+B1PN5v4H787JdyaifzeP97Nk+SOZ
   Mljt1cshlb2xuBv4JKaWtHt5M6rZ/bXljHAncav9ZKxKIhRcNl/xxp5ux
   SqZoCefT/kBKo5nisbFsIOHBNcUQjPUrL1w3oFjMoc0fuULmKlUZ6HqW/
   pqyojorhwOjEB/7pg7i5NE+tWdRpz2wM3ZtO+g3qLdWmYr7xA5gWMRqCU
   uH5OZI4q6XKU43jftw2ti/HU0K8XNk5yKTOJkDQ3fryLol/KO8qujdMtB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="999465"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="999465"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 13:45:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="824303402"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="824303402"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 13:45:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 13:45:38 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 13:45:38 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 13:45:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5wMSdmaC/1QIqmWqiZP1RpVZGMA2wfB9jMQtwF+cnRZl4KUkgu0f6YaTD6UMZgAJWymqh8FBKwclzAd2gKgxHCYe/zZeRviGSEuoZAb7qC1SihJSgIP2esu+zOYHBMUNqo4QlZBahfAt/vG7S0nB4Fy5f8RDz4HQz2q9Dhb8Sum2uT3amKyXQxd5TAZO9dWoB4PC9UdiqEbhV+Hss/CuXe/caV75nsn0EEoWsYKZ8N82Ko+d/ixuCQh/LnIvG3a5tghP3Ha5dB5fCxHk28jnWSbqpIuZuQCPChl+iErcP5qy50RQkTvgiXM5b8YlDfJWh+D74OQQhWzXVSc3xywWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9j0KI6SdiB2CUZTM5RWileYqTfVILxueTg8E22dyY0=;
 b=QSB1h+n6TY6DosLTI5D6aO5ULiONr2D7jb/1ZdrVIxoucC7kE/hKNnNIyk36//Oc4Tcwq8rvkG3dXgbr6DdE41NJ4D1ufajzVRL1YCw79Im8xVn1azFB35WfRknJNx3aMtsj/EJJCIXzPAiZucKs2bbBPzyTPCdgwsU68xdpK4e4AwdM+WLgGM26JYeiopdqy4UWcHcVvw9QGHM4lN/rBLDlZNpvIJxIb1O/6SFBbc75rcDgN326ZOQ2IlHm/HKt9GzEMFJfg8L+dEDQEHf1JpltZyddlSvV5iNiuwMMKD3ETpmbtua4PY1r6jV6koIv0vn+ikEyMPwdctv9d/imbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB7367.namprd11.prod.outlook.com (2603:10b6:208:421::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 21:45:36 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa%7]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 21:45:36 +0000
Message-ID: <6319e446-0d9a-486a-a614-aae2b16b93e6@intel.com>
Date: Tue, 6 Feb 2024 13:45:35 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/17] vfio/pci: Remove msi term from generic code
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1706849424.git.reinette.chatre@intel.com>
 <0550572e64505df6ecff0b08f1eca869a79f6acf.1706849424.git.reinette.chatre@intel.com>
 <20240205153526.462e32b0.alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240205153526.462e32b0.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0021.namprd16.prod.outlook.com (2603:10b6:907::34)
 To SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB7367:EE_
X-MS-Office365-Filtering-Correlation-Id: 158056dc-c122-49a7-0baf-08dc275cf408
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XgL0xKNzT0yO0ML0o2yAasJSGTfaT5yNpTX8OmX8Ialn/9vLI9FSLh1CS6So4W0ZeZqlyCxbmN8AuAGhj6NCdUbsc/4PByGkNE2Lm1G7EasR2gMB1frHbsea62A2DYHNsTsCI3eL95VrMzltlAsEEBaey0BYNfvebO0uTRunvue9QwDCKKY82EzUhKsqp4jmZaNpiUtqChFw3YhhI/xaCNfnEcKoEcmYqiGjp68/Cg9q8lQT+OyPQ1rqdqSwGmqLwaQ+Gra8t5ufu0tEEB8kN/i/Ka16U+nOhdYSQitH6svTZUYczvRdV7fDwD+VdTqsrmXev6o9AKw06QzS+VtMRlustwWL1f+i2XlRypTVvbBdsd7ARKIvcT49gHBjTzQF8R03em58EX/XawTyZ3ll/Vbt9PJ//UgnkPUf9St/Whi3+YzPljPBxUGVwPJkR/vZWVC5+ElG0OEqeYM7Z5LaQIgdsD2fyQ5bEBkhDelEDrR21xfEANNBCpzy8ChxOZFIjXj/OpS6JdCvlQiXv7BhVChOyV2gqEEVr2jQX3B4i/4rH5NrHbG9wV9Q7ECKlasqrF5gZcVin9FVTgGN7hpMGZV+yfpogTbfoDy71u7xnSHfG5JpBr57Eh07dhLR9VmYpDEqcS7X3+n6DGhu61ryAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(39860400002)(366004)(136003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(36756003)(41300700001)(31686004)(66476007)(4326008)(8676002)(316002)(66556008)(6916009)(66946007)(86362001)(5660300002)(8936002)(478600001)(6486002)(82960400001)(44832011)(6506007)(4744005)(2906002)(31696002)(53546011)(38100700002)(26005)(2616005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wit6VU5LSy9DVm5zd3JxZUJzWTNZYktGNU54VGt2THRNT3FUbGxUVE1JdXJM?=
 =?utf-8?B?aHQ5V0Rqbk9Edm1wSjN1UXAzYlFPaDNQWVZ3N0FYb3V5dHhnQkpnMU1iQXZM?=
 =?utf-8?B?akJZcnFzK09xYmhPRVpRRHlDcUllUjJIRVFjQjNNZ0dhdFkxNjFIeEkwc2VN?=
 =?utf-8?B?VE5ldUlOK0JiVE9WbjJtb3loVkJFZTUzZFFPZzFrQmQxQmtkcXNJLzZmanF0?=
 =?utf-8?B?U0VCdnBCaEQ0RUVybWdtbTU4TkNndGV2ZEFBUmFYTE5nZktNaGZCOXI2S294?=
 =?utf-8?B?NjMwdWxJQzlHR054OVpPcDU3WmxPcVNEMFhmRTYreFVnNytZZEc3SVJVYVNk?=
 =?utf-8?B?THRIOTZaYTVkSGE5c2c4UU5CejR4bzc3WlRYNW4xTTRhQjdOeGlBZ0ZPS1Qv?=
 =?utf-8?B?bGE5TEloZ0NDODhpLzBERU1LaDg3ZGlGTmhzc3dUNkZVNjNEY3ZVSUljTG1z?=
 =?utf-8?B?aThITU5WREFuWk1CU3VOK01ydVZiNktNRW1xQ2RKVEJhcEdFQmFsTjdGcFlr?=
 =?utf-8?B?WHJvUXRlSXZaeXlGQlNSKzNqQzV1clhDVWV1TjJOYi84OHJCeFV0V3FDeEZ2?=
 =?utf-8?B?WkxYUjNKMlljNVJWQXR6Rkc2UjUrZTNYZDdiWEVEQTNyZXZqUzhsY3NzVG0r?=
 =?utf-8?B?ejdOSFd1NHk4NFRhclJTVjc5Nm0xSkYyMUIyRjhicEg2aE5IYWRreUpRdkIw?=
 =?utf-8?B?MDhPait0K0R0c2VKWExqVzlDckpvZ0NQUTdiVWNuQXVBcnBHRVVXL3pkbk1J?=
 =?utf-8?B?ekdURTFJOThDK1hLM2FZcDVPeFhIbnY3VTAvWEs2L3VKVUdDb0xab1BQRk52?=
 =?utf-8?B?MGJIL0thWm43OEp4TDNVeUF4bU11TnhrTm1WSHY5R3ljazZoMmVtTEs1TU1s?=
 =?utf-8?B?bDN3L3E0NXFDcWpZbFV3WndxaUMvT3lSQ1pGVlNDeFZaZ3lpRStMVzRvZnJn?=
 =?utf-8?B?R2dNZnkwYVBaZ0FOTzg3eDZPTFhPTmIvN2I4OG9CaWF0Z3htelBpRWljSnJm?=
 =?utf-8?B?ekZWaGgyQTZEWEVrYzJKbnVxK3V3RklGa2V5VXJCVlJFQ1Z0dVRlbnFlK2lP?=
 =?utf-8?B?eWtuWnBWdUV1NTFrTkR1RnNqNVZBQStNY2NZNFMzeEFpbzJ1c2MxWit6bklp?=
 =?utf-8?B?MFhIWkpQVXhmdk41RGxPdnJSMGpYS2NVODBrVkI2RXBEajFZTzQvMHpER3VZ?=
 =?utf-8?B?b0hpQjY5aW1rNmlQdVlHdklydEphUm9jNmJzMHROeWQ1SjJXY05CVGJVOHJX?=
 =?utf-8?B?MmlWajMvV3EybWovOWRCcEVaQTZPRXJHRksvLzMwRDVVOFJhUmhiS2lvTk9W?=
 =?utf-8?B?UUJORFlLRkt3Wk5tb0h1eHlmQy9sMmhkTThYVnd1Q1VJWlVUNTFGVXEwTXE4?=
 =?utf-8?B?UmgycUkyQ0pIY2NmRHl2UkRBZ052Z1hCL1ZLU3JrY2pwSzNycTJHYURpUmxj?=
 =?utf-8?B?NUVPSHpjZVduT05UaEw1NStxdkpWa1ZqSzM1REcxTHVqd3NmdjUxR1JnWS81?=
 =?utf-8?B?SWttRXQ3bCtBLzQ4NXMxaE1BVVpNa0trLzZybnlLUTZZenZCT051WWh1NzlF?=
 =?utf-8?B?SStDNXE1empldEJQZ29xanlFOTJCQS9yT01BeGoxSjBRUWd4d1VYT1RsQzY5?=
 =?utf-8?B?RWZtY0dpYTMxTThjRzliOEt2ZC9aQW5YY2hKZnhaWGQvV2lveWMwUy9CSEJE?=
 =?utf-8?B?bTFNblhNK3RVNms1NVlFZmR1UWR4UlM0OXBiN3g2aHc2ZFlobk1UT1R5U1pP?=
 =?utf-8?B?NGVMeFZHZHl4emZ2bWk3QUplM2M1WDl6WFc1UFU2WEk5SnRVMFM5Q054NDBa?=
 =?utf-8?B?UjE1WkNHYUNqMk8ydktaRG15YXVlRUZtQTI2eHFpSTRwNi9DTmZocE93ZVNC?=
 =?utf-8?B?U0VNYUlrRkMyQzRnaDYxMFBYbmxYdEYrVjV5ejhaVVY3eWNuM0lPRG42aG9Q?=
 =?utf-8?B?R1pOKzV0amVjWEtEbWovQ2NpRGpMb3hTLzh4MmEyMk51T2U4ZEtRbkpaVSt1?=
 =?utf-8?B?VVdxZkZWYlVCdFBUYmthMVFyclFta0oxU1RtQlROVUVJUnJvTlFlaGQ5NGNK?=
 =?utf-8?B?ZXpGOVRhU1B5VnNIbTEzcExOam1RSnEweHBaRFFHaWdWRWdVd3BtKzg3akkz?=
 =?utf-8?B?eTlLZlFDeno1MkM1dVNuZ215VDhtcVltNWxaSkl1dU5XRWVKeVNaYmVqbVhZ?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 158056dc-c122-49a7-0baf-08dc275cf408
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 21:45:36.5682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDVSYx1DijuzjACNQDNNCYtn1xh/k91Oi9w+98auyjS4w8qptASHX0v0g/XYQffZM7txJmqXmg46xc/oOabDmWazvrn8ZZOxzWCHr6RpZOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7367
X-OriginatorOrg: intel.com

Hi Alex,

On 2/5/2024 2:35 PM, Alex Williamson wrote:
> On Thu,  1 Feb 2024 20:57:06 -0800
> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 

>> @@ -786,14 +786,14 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>>  		int ret;
>>  
>>  		if (vdev->irq_type == index)
> 
> It's unfortunate that the one place in the code that doesn't use
> irq_is() is the one that turns into the central callout function, maybe
> we can fix it along the way.  Thanks,
> 

Will do. Thank you.

Reinette

