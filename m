Return-Path: <kvm+bounces-8161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D8E84BF78
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 22:47:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FA2D289423
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F31B01CAB7;
	Tue,  6 Feb 2024 21:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L0IyghpG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD2D1C69E;
	Tue,  6 Feb 2024 21:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707256012; cv=fail; b=iAJoAFaSsca/QW+YhGJGtS+w0R+yzprxtfxSEl0AFqnBdCBrgYcanTpC/neKefAPLDOXgwdI/jpPHUyTKe1CDBCfLKb7m96f4U5x9oqANhfGUKLWUbIWSqLzGE5Z30KTPsL+ybvqaFCPKpKo+wfQlKnn5hic5HbE6wkeky69oF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707256012; c=relaxed/simple;
	bh=GzZgHfL+4WpHU9aN3dlgN3pJvc+0hSdFNgyAaQ1BV1o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BP29cvHAD5xKPX6kcDhr153dh5PU8W2dZ3oysl5I5qvWIpTQkYQTJTfT3uGkzMo6kJjm0XYRoxla0UMj8hUOy/KxA6EBvYDrj+pYMLfKLIQlkI17ERfAmNLQg/D1etrzxoQOBlpvphjyrhbom7jd8pQq8fLb3RPd0B2pi+Z3Pto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L0IyghpG; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707256011; x=1738792011;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GzZgHfL+4WpHU9aN3dlgN3pJvc+0hSdFNgyAaQ1BV1o=;
  b=L0IyghpG2BvCHeIkIcDrtYrJj6sp6mxlQ2goyzmIjqOU9hFkEYImcGiB
   xObRCj2IOCav9p46N2HN3QuXuA3nJC+ewpHOwuYaj5lEG9O3Ssu2UEsHV
   ElVm/6MEM+JpJe1baVJJ9I2J1VYvla5xKxL9oVLvJ8RyuwyWV55IvvVci
   B+oVRRdvzratXEajm2qJsv/6FazvhruSuBcIMPtzlen85vTLix0OB+zbB
   KaqIfxhlQvQCu+ru2HyE+A5f36M9SpdnPcrMSkpUUwKAU/uu7vwuLG88P
   mtg8OJPTYPWGbOw/Z6bEWu+2udnAwX6uSSVhZc3ZMdlhBbAIpoLuDs956
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="760886"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="760886"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 13:46:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1486462"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 13:46:50 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 13:46:49 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 13:46:49 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 13:46:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etcQXOYWz71bhbss4KZ8an8toEsAgPOzWGqjnv4iCqh4ipH5UUN1SI7ZgrJOoIFrFgpLKgkXCgzXCC2HCLSF/Ry9O34QiPmkETQLFAL72NSvLyy+sYuRbnqd6wAkBNPlAFNV9+MgXaTsaCRHr1mAx28xTzK9pCcYi1sYn065WAoiKRHXNtzS4dhvixQDrMC9v7R9Muu0ermiju5gouWxZQGYbCpefhuDH/gIbWQysf5gGmKtgriTlgEXIMjKQWD0K6lanOsx1gpDN4HqUpU9OsrJHS6sLa2QAOIKB8s+4/VjP5mjXqpJECcnjadw45Kj0dqeGbJrXHf/0ZPwfjsXrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lga/ouk4N1NgDW1Wo+Uia7o+UckcpBIkNdLANpuliME=;
 b=A27Jq87p7PWf5LKUQ9ZkYTohlRnrq5yVUj26BkSopoPwtY9uwEFs6x2btRuwQ9IG4+COWvWHtuodofRxr9gx28boZhHNtSTgtVDUHPtD8IXJPuEiXiUiNFVuysIPKNiBUBNDcFvckCnypOAkPN3n6lRSpIAuaLBBaatzpJ+gqe8TZHmk8OXPvvOirjhcLQbC0GzccV9+zizptjU+m+zkO0PoFK1trZ08ZnWUC/oXtrVYb0I2N6cS1EYRsxupcOjE5d6++2FXF+xnYPTdmnbgWiH+hyKUa65vSDfG78oazNnpC9MNDliRMjeF9o4ic5nlg3UXRf5vDIB+/ZrJUV9NGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7073.namprd11.prod.outlook.com (2603:10b6:510:20c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.33; Tue, 6 Feb
 2024 21:46:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa%7]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 21:46:47 +0000
Message-ID: <541fcb26-8f37-491f-bec2-49efb0693c2a@intel.com>
Date: Tue, 6 Feb 2024 13:46:46 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/17] vfio/pci: Remove duplicate interrupt management
 flow
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1706849424.git.reinette.chatre@intel.com>
 <6ec901daffab4170d9740c7d066becd079925d53.1706849424.git.reinette.chatre@intel.com>
 <20240205153551.429d9d76.alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240205153551.429d9d76.alex.williamson@redhat.com>
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7073:EE_
X-MS-Office365-Filtering-Correlation-Id: 90c27cc1-52e3-4046-ca03-08dc275d1e28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wuK9pwqVp2vyH6qt6kbYYUUWnCee/qXOy6mlvH1xsGbkCla3jImuRmlDAPsrtdObxjKZtEkFasSuC/oOqeGEwdkC8BmM4sTr4engQeCtLs5qH5i+aM1eWuo4bXK9/SOjc33REDu3ImVv+AuXI+wBXdqNxD8sVLL7AnixE+2YcaWgyEbkw7PlW0WGTqjQUS8WV+jn37NslVq8tsuiOBm8O9+rDXR1lzmJuaf8jSB9lf/P5J/5BzxFhi7V0nICnyNH3HCxGgbblZZgUtnjmA917ZvVOctfvnxau9bp8p2YouzvuDyfgLuaaNopr4zln0vvIw6RdhbXYZ3pChwOb2RNWU3ovox3xB7aFXCv98ZelbokaBN8vdGA/fkgK/JtZ8D0j2k3j4Ib/YIyHf9l3ZT5pVllKrcWXE8pWtKsm3Y6IhLwhjPNSIFjUMXIC+y26ksf3v/W92liewXYFJi89q0jT2wGOFSgAA1SUq79/mBZC0og9poVB2t0gtGRFxxfhvSusPCvcK9atG2gok+f+kzHAoOE6//ba5aBKlNeWP8depwP8HbcqC7rPej15OfzMHYWuKchKC1vqjJVfJPlhSZoK4O+QTA6WztrIFU+V0mgs3N5x7HCyQgvSWNfcyWCvptUTkT96B1mR94hSVGQSwA/8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(136003)(346002)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(36756003)(44832011)(5660300002)(4744005)(2906002)(41300700001)(6486002)(86362001)(2616005)(6512007)(26005)(31696002)(53546011)(478600001)(6506007)(82960400001)(38100700002)(31686004)(66476007)(66946007)(66556008)(8936002)(6916009)(4326008)(316002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVg5WmtkSHN5QmloaHhFaVRuQWhpYmlNY0JZNXp5UEloU296eW1HUUFVREov?=
 =?utf-8?B?UUZGYVE1OXExUlQ3bFU3NjNQWnBFY2xOdHM1N0xkRWhsUXBFV3FYaDRDUnUr?=
 =?utf-8?B?RERoTXN1ZFNQbUJCdFB3RlRLVG5qVkVYcEgxbVI4WGdHQkZCOGdqSEgwbC9K?=
 =?utf-8?B?UUxnRHZ5dWVFVk1GVi9LOVI3aXFlR1NZcHE0b1hTTXd4VkMxZEJTUHlJRTR1?=
 =?utf-8?B?T2VtS0RrS1BDaGVvK3F0K1crYUVYVmdLQlZPYTNmeDhtMjIydmtQYnJHbGI3?=
 =?utf-8?B?UjJ5ZklVTkxmbkxhTmFOS3UyYWh2M2hpOHJISXhzSWJlWTlITmV5akc5UllD?=
 =?utf-8?B?K0VSNk5TZ3YyUytoRTA5L2d4TUhaaUpUNUJGSkE3cXA4ZG82Z0kxRmQzc3dx?=
 =?utf-8?B?M0ZpNERUK1RPYU5Idmgrc1h4SkpVMnN5VElWRm05QmhFVDBiYklSMnJ4RXR5?=
 =?utf-8?B?VUl1OG5VK08yS3NoNFZub3BpWjRMa2lEaFRySkpsNmgwaDhJblg1RE8wUmsy?=
 =?utf-8?B?L1dwYXF4N0UyQ0lUcFNZMWhzbi9Fdzlrb2ZjQjNveGh4dForb0Via1d4bHMy?=
 =?utf-8?B?MVhNWXhJYk94cU0rSGo1eHo3c1RHVGtOaWJtdmNnRXFMSGJoUzBsV2NiSEtM?=
 =?utf-8?B?RDF3RXhnZ1ZvOVRRNnZOQVVvT2JqVERhOUdnM3dEU2YzYmVONUhBcU5icDd3?=
 =?utf-8?B?ZkVwd21ubTVMQ0dnUkhkQjBMWmhuUm8xakpNR084R21SSTJrM2Z2NWpoYUI1?=
 =?utf-8?B?c1pyNGdZSjd4ZTdjeGV3TjNnTXg1ZHFQNm00cmRCZHVFMkRuMlFhUWY1QUJM?=
 =?utf-8?B?cXN4YWcyYkY2c3RidHlXL0hyTWdwQVUxVlhFYjhUNjFJVW9ranh1YXNYSENi?=
 =?utf-8?B?RW95dTF6WUp2eU1JZ2FZT2E3SmIycGQ2UDVEZmVKcUVVYUFNRC9QRHcxNXg5?=
 =?utf-8?B?NEdLSWhKSGsxekRwN0o0bFNWZTMyd1pWMzRSdnZBUWtWVWVNOC9VZ2EwWGtK?=
 =?utf-8?B?UFVTOW1UQXQwdHdoeGlKbFFyM3BIcjZPVTJjOUNQcndiMnJjMm9NZTVjK0Jh?=
 =?utf-8?B?WGcxM2FsYXMxNEJFQ3lDMEhjdTlCd1JtMWJLRTE0dzdIUHRrSTVCYy9IU3h2?=
 =?utf-8?B?TTQ1a243cHpaMWZNODEvdVdmbm5Md2JDVVBlLzJRYnBQRUM4QnllUTZpK0J6?=
 =?utf-8?B?eWZTRGE1N2RKbEtQcE5USVpMYStpdXJqQVEra1Fkd0lKZndhREhUeWJiRXlj?=
 =?utf-8?B?cC94enRKU201S2ZuS2ZsK3F3YmI0VDg2YWsxcFhyeElJTjN1VVZETWM1OEht?=
 =?utf-8?B?OU8vclh2REVocVRldXRpZzR3bEJaVVMvdVc5bW80SDhPT0VXNDMveUZaVmlU?=
 =?utf-8?B?bmFxaEtwWXMxN2w2OGdRcXlINnJIQXNpcDBsR1lUdWgzc0lOOU1memZkUVhV?=
 =?utf-8?B?a3lvNEVqWGt5c2I2RTlxWXg4cTdvRWpVcUwvQllnSkVONzAzWUVxK1NyMEJV?=
 =?utf-8?B?WGx5S0J4TzFRSWJyNTllaW1HYWxXMFhLbDFjL0xDcFJnYWIxVEtDTTBWTnQw?=
 =?utf-8?B?Rnpwa1psUTV5Yzd4amFoYUt3TkRWUFRVU0FXRW0yVUJjZnFLYnY3Rm51VStv?=
 =?utf-8?B?UUNUb0tEK3pKUXFLOEpmOWZqQ2lKN3RrZkxBQ2I4TWFnOFQ2SlZvd1hPdWVS?=
 =?utf-8?B?dkhrUmhEbkJCYVFzWkxkYWVsTStXQzZneDZtdkUxWDBjYnZ6NEtSbldZM1Zn?=
 =?utf-8?B?a0hOQld5bGJEbjVUSWt5dUd5SWtYVmVkL0Z3QTVjSlFBZml6SC9ySVZKNm4v?=
 =?utf-8?B?VldVby9UQ0xQMlQ5K0V6NzBFUThPT2lubjUxMHBzQlgyYlpidzBRL3hVS3Rv?=
 =?utf-8?B?V2xlUndLQWtsMWdsUVBDL0Nma1N3TmdxT0ZPMUJIOFVnMW96UzJEOTlkeXJn?=
 =?utf-8?B?ektLRHl1Vnl0MG45TE4xZng1YkJEZUdMQWNyZExiM1Z2VnR5MjRUYzJrbU9i?=
 =?utf-8?B?UXhkTnFEa1R3aWp2ZlYxZ004Q2FFcUdPTW5qSnVIQkl1alBaR0ZKakN2bmpQ?=
 =?utf-8?B?MnRrVDEvQlRmYWZzeDBhNFladW1LZzNOSFpMaUdNa0F2NGlhRzJrU3d4eEJP?=
 =?utf-8?B?YnNCbk80eUVaeG5SUm92RjV3eHhleHRET055OUpvbW56bTFzOEV0UStNMEJ3?=
 =?utf-8?B?Unc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c27cc1-52e3-4046-ca03-08dc275d1e28
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 21:46:47.2085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D7htq9/3wM/pxwwhWw5/VPHZBbTl/dJLTwN/SRxi7AecFHBM4BowjJY8WQxJea+d1cDnG+fLEv/zepzKfGlXhM65xqn2jzix5Be2jQQDRiE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7073
X-OriginatorOrg: intel.com

Hi Alex,

On 2/5/2024 2:35 PM, Alex Williamson wrote:
> On Thu,  1 Feb 2024 20:57:11 -0800
> Reinette Chatre <reinette.chatre@intel.com> wrote:

...

>> @@ -799,11 +765,11 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>>  		if (!ctx || !ctx->trigger)
>>  			continue;
>>  		if (flags & VFIO_IRQ_SET_DATA_NONE) {
>> -			eventfd_signal(ctx->trigger);
>> +			intr_ops[index].send_eventfd(vdev, ctx);
>>  		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
>>  			uint8_t *bools = data;
> 
> Nit, an opportunity to add the missing new line between variable
> declaration and code here.  Thanks,

Will do. Thank you.

Reinette

