Return-Path: <kvm+bounces-15054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB6A8A939F
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 08:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C890C282771
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 06:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B659038F96;
	Thu, 18 Apr 2024 06:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OTzJn20N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694EE2CCC2
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 06:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713423559; cv=fail; b=K47LTSUbk18GEvFS7XspowjxGqD42312otldZySqfXHmfqaZQ8ffIER1JJely8hUJ+WF4tNluFt4vVzw/Tp+EIYmsHm3YsAO6Vh8EduMsy9M1GPcWwdicahY7ZW2ZPBRT6t8KWyVA/P6iWlYngrl/4k5LM6xDgJ3tpkXP7sYLX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713423559; c=relaxed/simple;
	bh=JO9YPAKDBpVzLsGC4GJI+EAvE6CzkM95C263KpkWZ+Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kz+pp6lfrTYzZAIMvYcUwy41zwj5+FT1f65pjF9MhropvlFur4Q5gwK0UzvKnAzj/y/ZW51iLTTdJ9Md5bEB7p/QlZ0g/UIH3sRCuZ88rYU09Ts2JYPRaFuYLWywzpkEVwDYZgFkr3Jy2r0uDl+rqSLK8QCV0gKVA7sCSoXIF40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OTzJn20N; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713423559; x=1744959559;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JO9YPAKDBpVzLsGC4GJI+EAvE6CzkM95C263KpkWZ+Y=;
  b=OTzJn20NYPo9mGztp8qijNgNx7R/qOoHyJJEJ2ukKIXeDVQvXocwSafC
   HncwdTX+GQvcnFZ/K67wKNRZ48oruiV+7JM6Bbf9BtkRjNXc4ByJGVvNi
   QieN0lLE67/epfQSo/O5aNMP7WlaLEiUEJHdGrPoSdaiEvRfWOvkgO2TN
   lnks2Vo9ORse3n8lwWaMSlFe98jDJ/f2PPORlhZO8HqSjzxGOoknnllVN
   sBSCgl+IAF/FGzh79QIpgJpyy/NP4fYBu1z94Ee4q2wMTQpkOH4bjyTEE
   CAmv2b+/83OlR6V6wvKxrXWVDJrpxKFuyvfDJ/Dy/TbmZ3oIRCWkyY14c
   w==;
X-CSE-ConnectionGUID: FCfJoXRcQ7yquBM3ZHKCiw==
X-CSE-MsgGUID: OpwNPYlzSmOvNUbWOWw1Eg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8784896"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="8784896"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 23:59:18 -0700
X-CSE-ConnectionGUID: JO3fAaD6TzGRL4kN+niOhg==
X-CSE-MsgGUID: HUHdYFD6TLayMjJN2f+mEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="60313125"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 23:59:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 23:59:17 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 23:59:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 23:59:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 23:59:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KloHrBXrrA0g8VjLKxC50ZsugEz02SG6mnAdbw6gjyUJ+4dEiyZC7bQnQtCs84w7qy549N6aA4/rsbBmnh6wzB8gBGGeFNLZKCGnIUNPUFU8Fw2D/qN2mya3N21eTn6Rcyps2xAtLTyqFOb2+WDaxtWt+tFjoRf1bmi4hvP5qOJ4Crx0KsbGlw8QdqNs+5XuW+OVE6ARLmCTk1xpxFDo9ijmPxNrv1ZSlBsM2AUYJ57C42UcaYBhO2a6DdwCvaNK8S4xCM4N74ZOtgoB8kfq8UIYWnb+8cDqi75dkb/LQriF56hh1aK40JG2CGLHDG9em+KEz03AAfskNuX+NG0DhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcPZFXWzFtnjrY+0ui02H8KW93yKRb9k7qvtuBmRWPU=;
 b=ipBmRo2wocgaHjuFOS29YUnwkMSNjB3DduYcdAaI07bw1oYCjBO+pjitMSMknehBEPOczdD8fQ1W7vUrUfic7PPStNIKzQg/rr1Vpi5qo8g+bV38nvdoRXlHSHzqJgOm86aO+LyixeGcm59BU9HdZJObD0MGdGOpC9lD0K6xTbmzbQfaHMTJkRf+Ba+9P7VKUUxHKTbJlolI6oCy0HEKPoiK+H6oO8lXa/YEn/XknG3RclJqCkH79nyeiIFki68Z7Vo72ydylt/aixxbYWMg5uMxHdYBgeaJIx8htnpt4cZGtm7MhA6XUChlbLqf55EDyRACvrp+nBFENJi2yA5HDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA0PR11MB4639.namprd11.prod.outlook.com (2603:10b6:806:70::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.27; Thu, 18 Apr
 2024 06:59:15 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.7452.046; Thu, 18 Apr 2024
 06:59:15 +0000
Message-ID: <e3531550-8644-4a7e-94bd-75bdb52182be@intel.com>
Date: Thu, 18 Apr 2024 15:02:46 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] ida: Add ida_get_lowest()
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <kevin.tian@intel.com>, <joro@8bytes.org>,
	<robin.murphy@arm.com>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
	<kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <baolu.lu@linux.intel.com>,
	<zhenzhong.duan@intel.com>, <jacob.jun.pan@intel.com>, Matthew Wilcox
	<willy@infradead.org>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-2-yi.l.liu@intel.com>
 <20240416100329.35cede17.alex.williamson@redhat.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240416100329.35cede17.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0194.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::22) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA0PR11MB4639:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bad3eb4-8281-4210-44b3-08dc5f750f25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1U8WgakSQjXaxviQq+aIMRHg+6G+FRBMmNfwkTP3azHZndlbsHIueG/2j8PzPRfWERKEHQWaE5n3oQyxIXiQzxCDriG4lEMLDoS2iL+cyramA7P1MYTzjm/aEmaeOVSsruHJPj5EoBhCqbT/QI7Ivm0GtzjdWvcFZZrbp/VoLy/PnWmMUNFryzDlWq+yA0A5mX9zOC7jWHoo+rgJyTc797FoDaySSCuScXCxQ2Z3DoU2PqH3cbgiI6TX56ruxolLDBDhywAM/OEg0jtslr5Rao7SOjtQqEz7+FNJufol+a9q+yFizDgOPIdraB6yrmkiBWyk9j2sM99g3jBpsWs80YB2+ZnOWP9ekiodlPn8l3jdf5uW0gzEkOpNejg6KI+DsvSekjPhT8b5QWHL1+HjnVtPfH/Sp5kDAv00zNB9+fvAIzxsSNEnpXaWdR4Jfcarq/kHbWUCXRXakEuy+c/G98mvYlIMweb0BJH2G+oFNRgkZ2Up1FVVlbYe7i1jGdljQzvyTJzYA21mvZ7vtC6Wjl6J8ppLwO0ckg5uoAKy+9VxSu6l/TABpkk5IbSK8lNwPw+NiwzLDGoPthXrYlUzYYHVszUUwXk1EJaN9ETTRWwBB9s3CHk0pgRVicgu8IXfZo6O+vrDEA5Usx55sHnKBq076idgj4XvyqYh2aLgcqQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWs3Z2tTWERvbW1RQm9CZkVWdHU4ZWpWa2RmUWRmekM3cXRQNkdUUzNzckFP?=
 =?utf-8?B?akpPdGlmM1pkd3NFUTVHU1VUOFNQSG1mOUJpM09ibW9Ta0pkVS9oNHpzODJa?=
 =?utf-8?B?VEJ0ZGh1UmNjSFNOUVlla0p4OFppckxjS2NlYnJ1ZjNQbHN0cTU1VzBQQ1Bp?=
 =?utf-8?B?Zm1QY0dFcHNpS0twbFJYTmdWWWUvZHArOHFad0dJOTVyQWJNaVNjTWs5S2lj?=
 =?utf-8?B?WURVZm8xMy9qZ3JoaU52a2swcVduY2M5cTRON1p3bXJnL1NrZzhybXc4SkFN?=
 =?utf-8?B?WkFOaVV4RGk0Qk56ck1POWF4UVkxUEdvMk5YUmRZTXl2MmdYNHJPbFNtYnlT?=
 =?utf-8?B?Ly9LbkpQQ0lKSUkyU3poOXFzZlVNR0h0TzJnQVcyangwYTBEVGowbGpZb3Q5?=
 =?utf-8?B?cCtwUmN4eGhJS3EyZ3gvTS82MWFmY3pPRUlzKzFvM3ZOVkh0SEdab2hpSzRC?=
 =?utf-8?B?MHQyUzJlT1plY0NPdnIwZDdQOEQ0a1E3VWVFS1A1YVJlOHFjczZ6bXMxZVhi?=
 =?utf-8?B?KzU2WUtTQk9ZOUMwZjMzTnRvUU1PYmdqRzNKUTd2aWlSS0dMSng1T0x6L0dW?=
 =?utf-8?B?NG1QL3RXYW1USW44UWJhTS8vSEFiek9weTdURUloa1haKzVnMWp1VURwVXFV?=
 =?utf-8?B?MnZ5MFFvaWlkb1JkUWwwY0lrWnVnRE5aVlJML2dYWFpYcGxlMlBQQUh5ZWl6?=
 =?utf-8?B?empNd0Y3dVZ6NUNycW1lLzV5NE1mR2lDb2ZBaTZoZ05IUmNZcWRZNUFEOG56?=
 =?utf-8?B?Ti9PdjdXREJTeWdSOU1rcmVacWhlajNQMFlTWlA4TXBDWUw2djlBVTZGd2F6?=
 =?utf-8?B?Yk5kOXJadXlOZWg4ZzM3ckUzcDQrd0JjWElpeUVnRUR2NENBNHVOQUZ5U1V1?=
 =?utf-8?B?ZEkwWUdrQ1J6VDZXdFpYTWgwUFVhL0h1ODVnN1UwVVkzTisyQjdOb25vVitY?=
 =?utf-8?B?YmN2c1lNZTVzT0tHTmpzUjFBNnhsdSszOHhRRUpqZ1ZRRkhwRmcwKzRSRDh2?=
 =?utf-8?B?cGR6SGkwaG9mY1RtY09JNnZaejBBaHVlbHRka2JFakZjbHlpZ3UxbDcrdCsw?=
 =?utf-8?B?OE9mUkpzY2RURG9aZjNZcXpVeHJFV1lYK3dkMGNYVUROMDN0Zi9pRVh1Y2tH?=
 =?utf-8?B?cHRNOGYrMUdCd1k0ejViSWhJdC8vSGZ2VnNZTVI1c3pYWUJGcHhPWXFrRmJM?=
 =?utf-8?B?YXRDN085VmI3cGh3TnBWaSsvaW1ORS9VZVFiejNFMkFIQWZFZ1QydU9SR25K?=
 =?utf-8?B?QWxTQ0lqK3BwcXM2TnJVVzNTRWZjeUdvVWdMclZPUkZvN3NYTWFqSUV0S0JQ?=
 =?utf-8?B?STFqRkpqRGF1TEFheWxCVlZPOGFmZlI3VTV0SE9ub2c5N2lDMUkreWN6K2ZM?=
 =?utf-8?B?bjU0Y2hQMXhwalZCbjYwQnBWbzVwWUZVNmR5K3JkTTJzbmkwd25tUTY4QnRE?=
 =?utf-8?B?cXMvNS9vQjM0eFU1V3BmLzJJOVlJdEcyalFJZWJrajRVb0FMRjM0YnVCSVdX?=
 =?utf-8?B?ODQveXlZeTJyUHhzV0kzU25UZ3JJRCtpWTZlT253aFIwU1FFaGJOSXVCVkUw?=
 =?utf-8?B?Mm1STkNTWDJxN2VscVFUR2NtckhmQXN4NCs0SFROSG5nWDBRVUxHSjdVM1lY?=
 =?utf-8?B?MFBoNURRQkI5Q0kybE5uNC9VRmliOURWN0xOWmtGNmZkdllNSVE5WHMxZTZT?=
 =?utf-8?B?ZWI4eWJsdmpZVkszWFZZS2xsczB1eWFsVmdlSjhhbDBKV2pvN0ZBZUx6d25h?=
 =?utf-8?B?U3V1dlBEWUkvRXVoWjhpSFlZb0d4a01BNDEwbTQ4bHJPRDZSYzVxVTRzWm9Q?=
 =?utf-8?B?ZkpIaFdmbGtFNi9YcFhyRDBnQWpHV1hqSitsYkU3TURmTHIwK1M4K1gxRHMy?=
 =?utf-8?B?eURoQzduM3JtUlg0RWE1cE5Eb1pTRkxjT2psWTNRVzBCVVBvbXYra0VOTWIr?=
 =?utf-8?B?VFkxZzg1MFV6TVZnVnRlK1NJcW1ma2hUa1VMSmFtRWtiUXl4bnhWdlloWStW?=
 =?utf-8?B?Vk9YK2VXcjhkSTZtZ3BEZ2FZalVMdE9ISkZPTEhpS09rNUVTQnlIb2g4N3lp?=
 =?utf-8?B?MjRNckFUZStIL05SK0wzQXRZQ290NnU5UkpGK1RUUVZWbWVlNXptaFRYWnRB?=
 =?utf-8?Q?QPjcbOnDIOq6fSf8JOS8Fm/jA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bad3eb4-8281-4210-44b3-08dc5f750f25
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 06:59:15.2666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ypZSfTwS23Znojyu7h+XARs4NDW9A7eKTifMr/dlf7nkgkxTXjO0lPIBl8VZIA6pBD6IP+X+HBoHk/RPGHP87w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4639
X-OriginatorOrg: intel.com

On 2024/4/17 00:03, Alex Williamson wrote:
> On Fri, 12 Apr 2024 01:21:18 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> There is no helpers for user to check if a given ID is allocated or not,
>> neither a helper to loop all the allocated IDs in an IDA and do something
>> for cleanup. With the two needs, a helper to get the lowest allocated ID
>> of a range can help to achieve it.
>>
>> Caller can check if a given ID is allocated or not by:
>> 	int id = 200, rc;
>>
>> 	rc = ida_get_lowest(&ida, id, id);
>> 	if (rc == id)
>> 		//id 200 is used
>> 	else
>> 		//id 200 is not used
>>
>> Caller can iterate all allocated IDs by:
>> 	int id = 0;
>>
>> 	while (!ida_is_empty(&pasid_ida)) {
>> 		id = ida_get_lowest(pasid_ida, id, INT_MAX);
>> 		if (id < 0)
>> 			break;
>> 		//anything to do with the allocated ID
>> 		ida_free(pasid_ida, pasid);
>> 	}
>>
>> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   include/linux/idr.h |  1 +
>>   lib/idr.c           | 67 +++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 68 insertions(+)
>>
>> diff --git a/include/linux/idr.h b/include/linux/idr.h
>> index da5f5fa4a3a6..1dae71d4a75d 100644
>> --- a/include/linux/idr.h
>> +++ b/include/linux/idr.h
>> @@ -257,6 +257,7 @@ struct ida {
>>   int ida_alloc_range(struct ida *, unsigned int min, unsigned int max, gfp_t);
>>   void ida_free(struct ida *, unsigned int id);
>>   void ida_destroy(struct ida *ida);
>> +int ida_get_lowest(struct ida *ida, unsigned int min, unsigned int max);
>>   
>>   /**
>>    * ida_alloc() - Allocate an unused ID.
>> diff --git a/lib/idr.c b/lib/idr.c
>> index da36054c3ca0..03e461242fe2 100644
>> --- a/lib/idr.c
>> +++ b/lib/idr.c
>> @@ -476,6 +476,73 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
>>   }
>>   EXPORT_SYMBOL(ida_alloc_range);
>>   
>> +/**
>> + * ida_get_lowest - Get the lowest used ID.
>> + * @ida: IDA handle.
>> + * @min: Lowest ID to get.
>> + * @max: Highest ID to get.
>> + *
>> + * Get the lowest used ID between @min and @max, inclusive.  The returned
>> + * ID will not exceed %INT_MAX, even if @max is larger.
>> + *
>> + * Context: Any context. Takes and releases the xa_lock.
>> + * Return: The lowest used ID, or errno if no used ID is found.
>> + */
>> +int ida_get_lowest(struct ida *ida, unsigned int min, unsigned int max)
>> +{
>> +	unsigned long index = min / IDA_BITMAP_BITS;
>> +	unsigned int offset = min % IDA_BITMAP_BITS;
>> +	unsigned long *addr, size, bit;
>> +	unsigned long flags;
>> +	void *entry;
>> +	int ret;
>> +
>> +	if (min >= INT_MAX)
>> +		return -EINVAL;
>> +	if (max >= INT_MAX)
>> +		max = INT_MAX;
>> +
> 
> Could these be made consistent with the test in ida_alloc_range(), ie:
> 
> 	if ((int)min < 0)
> 		return -EINVAL;
> 	if ((int)max < 0)
> 		max = INT_MAX;
> 

sure.

>> +	xa_lock_irqsave(&ida->xa, flags);
>> +
>> +	entry = xa_find(&ida->xa, &index, max / IDA_BITMAP_BITS, XA_PRESENT);
>> +	if (!entry) {
>> +		ret = -ENOTTY;
> 
> -ENOENT?  Same for all below too.

I see.

>> +		goto err_unlock;
>> +	}
>> +
>> +	if (index > min / IDA_BITMAP_BITS)
>> +		offset = 0;
>> +	if (index * IDA_BITMAP_BITS + offset > max) {
>> +		ret = -ENOTTY;
>> +		goto err_unlock;
>> +	}
>> +
>> +	if (xa_is_value(entry)) {
>> +		unsigned long tmp = xa_to_value(entry);
>> +
>> +		addr = &tmp;
>> +		size = BITS_PER_XA_VALUE;
>> +	} else {
>> +		addr = ((struct ida_bitmap *)entry)->bitmap;
>> +		size = IDA_BITMAP_BITS;
>> +	}
>> +
>> +	bit = find_next_bit(addr, size, offset);
>> +
>> +	xa_unlock_irqrestore(&ida->xa, flags);
>> +
>> +	if (bit == size ||
>> +	    index * IDA_BITMAP_BITS + bit > max)
>> +		return -ENOTTY;
>> +
>> +	return index * IDA_BITMAP_BITS + bit;
>> +
>> +err_unlock:
>> +	xa_unlock_irqrestore(&ida->xa, flags);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(ida_get_lowest);
> 
> The API is a bit awkward to me, I wonder if it might be helped with
> some renaming and wrappers...
> 
> int ida_find_first_range(struct ida *ida, unsigned int min, unsigned int max);

ok.

> bool ida_exists(struct ida *ida, unsigned int id)
> {
> 	return ida_find_first_range(ida, id, id) == id;
> }

this does helps in next patch.

> 
> int ida_find_first(struct ida *ida)
> {
> 	return ida_find_first_range(ida, 0, ~0);
> }
>

perhaps it can be added in future. This series has two usages. One is to
check if a given ID is allocated. This can be covered by your ida_exists().
Another usage is to loop each IDs, do detach and free. This can still use
the ida_find_first_range() like the example in the commit message. The
first loop starts from 0, and next would start from the last found ID.
This may be more efficient than starts from 0 in every loop.


> _min and _max variations of the latter would align with existing
> ida_alloc variants, but maybe no need to add them preemptively.

yes.

> Possibly an ida_for_each() could be useful in the use case of
> disassociating each id, but not required for the brute force iterative
> method.  Thanks,

yep. maybe we can start with the below code, no need for ida_for_each()
today.


  	int id = 0;

  	while (!ida_is_empty(&pasid_ida)) {
  		id = ida_find_first_range(pasid_ida, id, INT_MAX);
  		if (unlikely(WARN_ON(id < 0))
			break;
  		iommufd_device_pasid_detach();
  		ida_free(pasid_ida, pasid);
  	}

> 
>> +
>>   /**
>>    * ida_free() - Release an allocated ID.
>>    * @ida: IDA handle.
> 

-- 
Regards,
Yi Liu

