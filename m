Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C713F50A360
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 16:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389363AbiDUOyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 10:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381289AbiDUOyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 10:54:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FB0F2E
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 07:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650552714; x=1682088714;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j3MWNO2TFeCW5r56WCDqUVvdoSZXoB/uNu0I2iklqVo=;
  b=d+yAZy2C07/2JZFFFDtB5y/mlT90g2J6THe/ZZPCkc5idYN/vaxxsOoO
   ZwejV2FoEZuWeu8FucWD49HmuytcDyQ3Ky6S5iIGr5ldpZVDB9oj6D0LV
   uGlHrmj1QZpMobhNXmUVsBcGcGUUTsRIQdwIGM3nQ34nFvtshIZyLP30u
   IDpZR6jFwFIfeyyllBg6VqecOhmTGaj3c4ZS1W57ckbp59xhLG/ddTSEY
   FnptlXTa2bYn8wxqLHpo0Y6P03KIpoavqXEr8G3cNlv9S0+bfQiuOd53u
   NN8rG5rDJpz9I7B3OEgGx951/Pmun8U4DUQ/GHjkfdhOpZT3pE7X2Crdj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="263218404"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="263218404"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 07:51:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="530327165"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2022 07:51:00 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 07:50:59 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 07:50:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 21 Apr 2022 07:50:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Apr 2022 07:50:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlxrPJjJarajcGJPMRVp6G8xf2W/MjpnOjyxERXcfQnn0PhfcrvSPOxAMLOCnfwLjZlvYyypFLrdAElIP5ohwK5Rza82ETI6XoRR3SU1QQTZDj+8LiKsC5Yd/nlopbmDhkTgb2ed870gu4ji5etf4hYIJ4olvH0m7A6vvBDZFfdEi5cuV0F0wrAmhBdKsE+rHLGTOuYMTgWD1XfsP2FpLJQqfV2j35pkjWXy0tn/91UHthwhXwHAygnWw8IRBdq2bVljB9taFXouFUNj1rsEkyAF2SeXTfRkDSC5nzYxFc1Xj8PYbuysyeT8oim4w1rsr4ZkZGw5tC9jIDxQ173pEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SC26mfsvGE2W+DoX0guL2CA37pBWWlVbnE3aoAUASGk=;
 b=ne1S/ADsvqDLIM20BHTvKHW9DGeSma0Z7bE389MOz2AsHuUjmsjfuw045+NXk8LZH3o9Dj2gaPOeVhGkMkmrvBK0OpWqKtN2f7g05RK6GiAYb0MBHEMRqYw4c1r9ttMOGZrknSAJvJKpAs1R5Aw+2SPLRD7ZSM7xXTuCFSRXn+5tc6gh3l0nvs6YpQI4lZB2fLpbV86d5UzugWljIJsjUhL86Zd6QpFUTj6AuJur8oxU7AI9qGPA14Oc3uWr/3kqZ2pFrjGwa7rsJ63Y+EPMlB8MZwDOjP5X/Y0uSLeFVNfbbJP5jPhqmE6vhCuKr/0rAvrCxTxSfktDkzphxIuYRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by DM6PR11MB3995.namprd11.prod.outlook.com (2603:10b6:5:6::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Thu, 21 Apr 2022 14:50:57 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024%7]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 14:50:57 +0000
Message-ID: <40f40b36-46cd-f156-f33f-01dc0f1418c7@intel.com>
Date:   Thu, 21 Apr 2022 22:50:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v2 4/8] vfio: Remove vfio_external_group_match_file()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Kevin Tian" <kevin.tian@intel.com>
References: <4-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <4-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR0302CA0014.apcprd03.prod.outlook.com
 (2603:1096:202::24) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbb32d25-e5c1-4cf7-6fe0-08da23a65787
X-MS-TrafficTypeDiagnostic: DM6PR11MB3995:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB39952D7FBC570D981331EBD0C3F49@DM6PR11MB3995.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cw4iCS+L535x0k4CFnbx45C1/bkmej3wILyBoox1XoMl0qb/XEFQAc5Mahd2TfWcVoyA+vTxMdLBfVnqf0GVRheLKRRE78JppOzW+UWq4In3oSGrWrExEcE6ONdSnbmpwrF0OaomtfiwAN5EzBI8T5s7wMkine+5kx/AHLPbrjb80VlQqGuFtjaeGe8RvGCYCaKk8GDwUwu2/3BQEUo3qTmVOCq+yTTMWkOdIobEo1ujtDLCzegxco7trgMXAzYj0nUOzOa5U24vXBH6ntWs2/cPB4Yvwf6luWv+m7uQn9AQOR03x8eB4gZwuoKMD576jCsJ18ZRlNUrOsozs81NmrELFvy0wmif6qXtjOotMic05dYDk8V9JtMGM+mkkc7GdpBxdnBOxYie+l3e0YKePibGmt5vpGvJnc4hGdf0I4PJM7ERS4rpqajJbB8s1OyDjACpLOE3GzIWoHpL5MG7KeifGk3zeYBGKXey5We5A3luG0w8oXTXoJD+hFIvUSwCXXBXE4SaCgweNGlXhZdVEb2Is3G7682Oqi5elKhERBru5J3q/VXPViZuJ/q9IJCukEskxaYcyMUopEPcD7zxo0Ki8Ue0SaAEaoOTVAzwmSjfrK7el605fIQp8xkdIC/t8IuZXvl9up19JC4FGYDZFMN5+EaSsLP89Tk8mVjMrfo9GPGzKbMjn4t5ME4XEzr4PyZ17mttX1QuyxJNGZzch3oWFyxw+/09eqed5XsXeSU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(5660300002)(2906002)(110136005)(26005)(107886003)(8676002)(4326008)(2616005)(54906003)(82960400001)(66476007)(66556008)(83380400001)(66946007)(508600001)(38100700002)(86362001)(31696002)(4744005)(31686004)(186003)(316002)(6486002)(6506007)(36756003)(6666004)(53546011)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEYwK2lmeHFmUkd4UExTRHJXTzNIbzh5ZFJKWld1SXRvT3pEbDZobFRxNjg5?=
 =?utf-8?B?eFUreGJVLzM0UXBvWGtmcWFaVk0xa0Z4LzVxdGIrbHEva1UwOVdKVVdoekZs?=
 =?utf-8?B?L2ozY2lJMy80dldHaGhJZFk5YVh4bkxNZ2pZSlhRZGJ4S0IwNHNuNHJMaTZq?=
 =?utf-8?B?MmJ6cTAzdFhyLzUvOUlzbVNvYnVzaGRic05nNVppQkNDZjlaSG9uelg0RVEw?=
 =?utf-8?B?WjFHTWIyc2RwV2RxaFpRWlpIWll6SVQrakxnaFBMM3BvSit1SGxDMXNRYWdS?=
 =?utf-8?B?SXdtWCtJT1FVZzNSMUdWZ3pjdktZZGVCNjVxNVdDd204SkdVU1pyY3lhSG1W?=
 =?utf-8?B?UzQ2TW1DLzB6QVdNVEFFTGVqUmFMRlNXQlFCL1BFMGRjU01wMC9UeGpBOEtz?=
 =?utf-8?B?YTVtNEkvQ3Z6ZnlXZlM5M0lnUTRyWEZXSkErNGtKaTNqdElzaHlZVTFNT2FF?=
 =?utf-8?B?SVFwcWJUQ0dUU0x2U3phZDJpcmZRd05sSmk1SHQ0YnpSTThkdTdQc3g1RzlR?=
 =?utf-8?B?dEs3UzFON0lSWTk2dWM0OEc0RUFNSGlET25zUm1YYjdmYitRb0ZzM2F4MjB6?=
 =?utf-8?B?dm1Za2FJSUNJdnVCSGVhT2JJNVFzWXdwaW1MWks1OXhpSHJOWGhNSE5rWHNN?=
 =?utf-8?B?K2JKTzBNWExwdHpVM3hEb0JVWkdSL2xEZUJsRFMxQlM2NjAvQWt1OEJtK2Jz?=
 =?utf-8?B?Wjh5MGRRVkQ1N2VnRnNzVERxM2Q5cHUzNGpoK0lzdHJibXR0MnJxTmFrN0h6?=
 =?utf-8?B?SWQvVXIxbVdESW5Gam03aFFkcEppMEd0MVBjQi9yNVpsSENwSm15ODVQSVJW?=
 =?utf-8?B?dyt2Y2RPVFJtQTlaSDNxYkwwT1NXR09BaVc1dE53UEM5NDY1MlQzTERxNWdI?=
 =?utf-8?B?eXkwSU4zTXpUKzJnMnZuRTUrSXZFUlVKR1VGSlhqa2xPbW1JakJEeGRoendL?=
 =?utf-8?B?aWpxRlVzMlFsLzUyNTViNi9RWlMxcDViTnZLcDFIU3Ewdjc5Q3A0VFJVTWZj?=
 =?utf-8?B?UlcxV28ralpVTm9Zc0JPb3NuNWNhVWNtTzdNU0pTamRXTHNQY0pqNkVFbXBW?=
 =?utf-8?B?KzlJeUpWVzhrU1haMkxLeDgxUC81RXhtdnR6MEhDTTJFb2Z4blRyUHllNUM4?=
 =?utf-8?B?T0hpRzY5enZxTXNqWjMxOE11Qi93ZGY3NEZoV3VHdWNzUSt3eDBrdlpuNEM2?=
 =?utf-8?B?aWZTUVdxV0c5cmFMVDZwM1dKRmd3RERPTnBIUUpXU2c5VUlGTWFDQWwxNy85?=
 =?utf-8?B?TjBVSm5OMnlYaWZTSE91NEZFT29rV1NUMVhLOUZBZ0FaVE9Gd3B1TlFUZ0NU?=
 =?utf-8?B?N2U4Y1VVNzZ1bTBFM2p6QjNSeERrd0RpL20ySnA5ZzgzYzJVMzNWbjMyUExh?=
 =?utf-8?B?L2dRUmNtMlQvSHFuUnFiZk80QmwyelIyOUUzcENCTlF3S0w2aXNseWVLcm5w?=
 =?utf-8?B?dkoxS084N09WSXFzTndvc1JObUFYVkIza3J6Vk52Q0dIMVpMZzVhVmV5ODJN?=
 =?utf-8?B?VmtXMkdqdjgwRmsxTmgyMXRhUDJRUzM4QjM0U2hDL2RkYkY0dU1RbU03ZXV3?=
 =?utf-8?B?QStIT2NRci9OR2lXdWRucnI2NVBDWTNucmRjTXNvM3VaU28zaE1oc2NiSmQy?=
 =?utf-8?B?YzRyRCtWTmRBN0pxbk5MYTFsK3lRT0xKMW8rLzlSVVVHSW9uMnc0aUFaUUMr?=
 =?utf-8?B?VVc3SEpmMGFPL3JaWnNSbVZ6Mk9LbU5kQVVzSWxQaGZla0xEYzVIdy9DQWhn?=
 =?utf-8?B?b01oSnZpZS9oa0owQVkxbEhsRlRPZ2szUEtseHQ5NlpFM0dzaTRkMXBBM0FB?=
 =?utf-8?B?VU40dEJCTjBvR2I2ajYxcWdoQ1V5cnhjcTJlU09kWjV2TVk5cXMxaFBVZXpD?=
 =?utf-8?B?OEhZdG42TVhsdFJvZEZZck1HV0pmUXFpMVJIdzJNY2J1dFlobVlGYmZSY3dR?=
 =?utf-8?B?QmJ1MDJxc29MYk5ubkR6WGtjNjJMOGZwZ0tianMxUHJlQ3pwT3cvdURLbmR6?=
 =?utf-8?B?WEJQSTU5TG4zb1lTb1pRLzNOMUQ1U2dKbjdUNlh5emlwQjQwc0wxUGY3aHk2?=
 =?utf-8?B?NzdnbmJsalJrbWEwcFdGUVQ1OWt4WDNOWGxkT0JKeWs1NGhNWlVWVi9wVU5o?=
 =?utf-8?B?Mnhwa29kcWFvc2hYL2pSb2NSZno3UENlMS92NElsdEJSc1p3Z0NucG9nTStU?=
 =?utf-8?B?VHI1bWcvbGxqRE5rTkJOVXZWMVF6MnFzR0YrRlJGQkdLaDNxeHFwKyt0RGNR?=
 =?utf-8?B?dkJYZUs5L2QrOWJOcXpwS2xJMnB4LytwbDFCTU9aWERLSkN0NG9ZcnVHVTFC?=
 =?utf-8?B?UTRMUlpvT0NzMGtEdEFvcDRPa1JyK1pKQkh2dUQ2QW1yWXMxMDhtZ1dsVjdX?=
 =?utf-8?Q?AafuHsctq4suElUo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fbb32d25-e5c1-4cf7-6fe0-08da23a65787
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 14:50:56.9820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o/7ZYzcPiojeesoPOvGfP2DuRDgmYahaGGOmEAY3w28oMzGPJdKLkqSka/DV7SgJ+wBb0B0cKr4MvLOkezfLkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3995
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/21 03:23, Jason Gunthorpe wrote:
> vfio_group_fops_open() ensures there is only ever one struct file open for
> any struct vfio_group at any time:
> 
> 	/* Do we need multiple instances of the group open?  Seems not. */
> 	opened = atomic_cmpxchg(&group->opened, 0, 1);
> 	if (opened) {
> 		vfio_group_put(group);
> 		return -EBUSY;
> 
> Therefor the struct file * can be used directly to search the list of VFIO
> groups that KVM keeps instead of using the
> vfio_external_group_match_file() callback to try to figure out if the
> passed in FD matches the list or not.
> 
> Delete vfio_external_group_match_file().
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/vfio.c  |  9 ---------
>   include/linux/vfio.h |  2 --
>   virt/kvm/vfio.c      | 19 +------------------
>   3 files changed, 1 insertion(+), 29 deletions(-)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

-- 
Regards,
Yi Liu
