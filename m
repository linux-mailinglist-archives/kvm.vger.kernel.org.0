Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081FF6370DC
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 04:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiKXDO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 22:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKXDO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 22:14:58 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E22777202
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 19:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669259696; x=1700795696;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h/W74ZC4lMTd05q1LuqkDe1IgikhsB88nC6Aq2Esknc=;
  b=CTNbA7dH6DRsYAW8OWWsnqnnePcFOHjXuXtfmB4YCKW/ULfBp6FcRfUv
   BzW4K+5Db2dLZ8UBdpe8tdmbfTTqeJaBAf+JSbnZU64OPVKAvXKA/XIzP
   Nz50iMBBca36hfn7V6DT1oT9/eMd4ZFSvusaFkKZdq/SBJMvHnPynDAZD
   3xhUmyu3UEkpfgXATwQ+RzqtJTndpTo4ec3yb2HWWkiGoksogjzvhplxH
   mWPHVt83oV1hbLMNsghXTgyBfRPlRrTGdJfalJnRgHPjVKI+4hMaAwf+8
   GS+BRlhHgAGDZL+i6iphcFwxBvRe/jJegudV9y3uln+uuiq8kBS7YwItZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="314240139"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="314240139"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 19:14:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="644331292"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="644331292"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 23 Nov 2022 19:14:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 19:14:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 19:14:55 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 19:14:55 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 19:14:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hA/nUWbb5L5KinvMOhsIZgfg2cebKSU9VQzULvKzzl957GkzuGeDSRsrx6gQEkr8r7HMr1opbJP/QTJ5T+IiEs8YKFtalUIirnbPG5iUEZl/LYrI9O0yz0rcwjIJG2B8SNkfF2mwd1waI3QM435eAJRyT7vGFyLZ1Ey32rXH/ijVrpG0GWpSeTarEmZ3OAZoFUyGysdzeKvenbhrKfHzTKLrfcX3v5ZWcP/HuqzEn0vn9W1pA7Rymo2T4JHEw2JdNTw+zIzLNRhwxJpz38k/CTCC9yI6LDyJ8h+44rllt+Y8m9PVQCNIqbJAgBRHWNB1IP7r0QWwx4U1+Lv6VDHpyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sMjOtSvJ+sIGnBsMHibRnpU3yuFY4/BBiLIh8oorA+Y=;
 b=e0TOpSWspdLzaKX9W4+jlXdMLBhahtPvWXL8oIMhIHEiXuBLBe3WWipBO/KwGTGmfX5YDs7shihOwBvDEIbitlEzjETrUPb9QqZnRkhTnYWjImQeTKO8Z1mX9In9UKB9cvAQi0FM2lGrz+b0/N4bsgBVAwoRwyaztegNQcuQ50/73OBk2i+IfkVTeFWRsfEOSNuqPOPV5+hGguzIci1kA+y6bmt8TUVDh4RBBLc9ndXr/WSODpo1V5lE5RdNbGQqMR2ud/iBAEyakT8S3zQGLAOaOLPugT81RPJmUhYS7u/6BeAsj6A850PI31AcpPouJtTIH0crXes0deYNsprFtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 03:14:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%6]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 03:14:54 +0000
Message-ID: <5f188074-44d1-8984-572f-714cc1be09c4@intel.com>
Date:   Thu, 24 Nov 2022 11:15:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 00/10] Move group specific code into group.c
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <eric.auger@redhat.com>, <cohuck@redhat.com>,
        <nicolinc@nvidia.com>, <yi.y.sun@linux.intel.com>,
        <chao.p.peng@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <kvm@vger.kernel.org>
References: <20221123150113.670399-1-yi.l.liu@intel.com>
 <Y35pdp/PqA2TMx9w@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y35pdp/PqA2TMx9w@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0012.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::24)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: 27670545-be32-401f-cf33-08dacdca0e8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2WiWtEiQbtNrPCLP36qEQ3ibnMGH/wm80dZM/ADMZQeUYWnX7RgHzWO8Bs0kkG4KZhxt6KYn9p/cryD2hp89qvxJX37zwMM9KafMmI5xqR/tfn1IkJI1AMPThUhNlASa8P0XqN/z8tp8D/mv6gtiomI/BzeCKzftcYxcBb/GiYeNRjOIqz1S4yEdymEyo6zmABLt/jo50hmsN4JzQg1ov9/oRWlfCmYer3w8gntnXRZtKJNt8NazLONn+t/YK6IUtMtD7l0ESGDC03QHCR5JCWplvzoelu0qTX8M9aW9ICXTVIiQ1GSiFVXZ6rybznVQxmyDOOm5USP2cs9cKXkIoDlKHI0jPuDZKx9R8QIxh5L92bNhGecC+6YLwXxCBdRgWLu7DcxtVlQ2lHutHrBS2qryLiOjPNJyOKRHo2a2ST0PhCpiFHuxpTtvUUeqvqCClFdo9OcBWHUL7oIxojJXsA6WTmnkD3n/ZK30wDI1xt1aUROV9RdE9ITEWyPMTgMv2hz47LrcUErr7E492DYLZn4I2LhXQ1ybOOnR8fCyzL7fiHUceWOGavgb7vpJHh65pReUj2vdZzBbIKw3pmZgq6HdKfB67nhfTgft243mcz+A8sUandsbZgHLAoK1g4Zg9ojQS66SqABZpS8QCBEIE03XHD++IiumUKNB9s2EXpKVYGcF2gxyvILnlUTgozBl+6LrSMBBdsdyo1sBkvBuaEakHwosU60/NqilyL/h/xGib4PU6cudqk/jyDVWqIvXrPmOVzQZA6Par9MvPRN85683sfitYbS6orRD2oPNFcq1oO3b0iVbC7iq2YcXbbut
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199015)(36756003)(38100700002)(82960400001)(86362001)(31696002)(2616005)(6916009)(316002)(186003)(41300700001)(26005)(6506007)(66946007)(66556008)(478600001)(4326008)(31686004)(6486002)(966005)(53546011)(6666004)(2906002)(8676002)(83380400001)(6512007)(66476007)(30864003)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGNVQ1RsMitpZFZZZ2o3bW5jYThaOW53TnNBT1RVZ3lNVkRJMzNNVzlxdmtV?=
 =?utf-8?B?Unhia3BWTUI2NWZsZCtvWXlNSE9NL2E0aXc2dklNdStZemtveDlLVTlZZDVD?=
 =?utf-8?B?ZmpSYndlOTVKaGZiU0VYdmpWQWpURktDWmpIVldlOHpoN0ZEYXZ0YUplTjl4?=
 =?utf-8?B?ZjZmekdCMks1SnNKSXZqQ2Zia1NjdXlIcTBDYTdPaWRFcUFXT29QbDd3ZG1B?=
 =?utf-8?B?WXk2WEs0R241cnQxVXM0UkF5TGtxRzIwNVFzOGhBekdSa1FJdWxjTGM0VHF2?=
 =?utf-8?B?dWJQakZETTRhb0RXbDNTS3d6eFp4MENiOFcrUy9HRU5uZWU3ZGJSeUJJWVk1?=
 =?utf-8?B?cXRRU2E5SVRNdlFIc1Z6TGFXZXRxa05ralFpTmpubHYwWTN1YlFQSVJxbi9Z?=
 =?utf-8?B?cWZKVzFBRGk4b2xPYXNWQ3FibHVGQmtpdHdHZzdYUUhNZ3EwUE9hSGlCNW1B?=
 =?utf-8?B?NUFWM2ZkQUhiM1p1cjFTS05yS2FsaEtxbnRQUHVWN0t3K1dnbkh1TytoZ1lQ?=
 =?utf-8?B?eEsySmo0cVVkQjlybFQ1YWYxZzNzQkphK2JrMVBERktsUXNyTGdhWWlUdGJi?=
 =?utf-8?B?OVNkRy9mb1ZxeGR5cFZpbVBrazBXdTA5cG9LMGZ5KzY1MWdKcmhUVHdCeHNG?=
 =?utf-8?B?UEx1S2VqaUQ5ZFNIaCtkRENnZkYyeU50Wm9RSnI2dlRxT1VUeVR4eFBDS3hz?=
 =?utf-8?B?ZWY2MjJQaFc5VzArMEdPYTMzVWJpa1poTkhqNWZpekZEcmcvMXZHRXhhWHMx?=
 =?utf-8?B?MklmTitwcUVzYTRKVGZNQUtSQVBCYmcyK1BVcG5SY3htOVFKN0J6aXlsSXJB?=
 =?utf-8?B?MW5yYkxaZHRFYkphdk5qcWdnUzE5akZ5YUFkcTQxNlJuYWdBQzJac1duY0RV?=
 =?utf-8?B?a0s1eUFHeHhnYVJCbmFVYk1JU0VlVmtyeTZsamViQVZZMzRLVEg5WW5uN3dj?=
 =?utf-8?B?SUNKS1dIa2krNU9Lcm9tUDdiNjJXcVZKQk5TS3Q2ZjZZc2tieklJOXFoYm81?=
 =?utf-8?B?YnJmd0RMUmhpRWhOWlhZZmxVWVIxcW84VHpjU2NNemJRb0VyaVlRODIyUjZD?=
 =?utf-8?B?d2FoTnZVaFhnVzZ6a0tXSW1NbnV0bGFVTS95NWVwK3RRN1ZMYVZORnlGZy8v?=
 =?utf-8?B?Ym1XQ3BTZ3VQUVdhcjhTNllWRWJUYjRiUDU1alZkbWN4Z1lqZTdvQVBIcUFl?=
 =?utf-8?B?ZTBReE9PamJoSk9mSmd4M1dlSXArVHJWRHNBaWJ5ZldYbEw0WUw5R2s0SVZn?=
 =?utf-8?B?eVBGK3FwTnliNFQzMk5tK29SMlFVamxjTWphVk43NTBsUXVKdjNPMkJvZVBl?=
 =?utf-8?B?V0s4UUZGV095aXdhRDM0bkd6MmJ2eVJYRllreEgwK3NSTlVRN1owVyt6UDZR?=
 =?utf-8?B?N1ExSEtUZUtBVHk4K3dNblJQSnlQK1RWcjBZT3VvZnF2RjBJUG1kNWt5QVdh?=
 =?utf-8?B?dkNmaGEvZU5DbUFXdkcxSTdYMFkvY2syWU52RnVGcUVaWmoyN0hCS3oxcWZV?=
 =?utf-8?B?cVJCdjFmdjMzT0c1ZzE4ZkRSM0pidVdZYzhJaG5ybzdzRUdGam94dEZMbHRv?=
 =?utf-8?B?K2dLNnF2R3RXczltaWVOQjdmVzU0ak8wWUZpN0ErUjFjcE5YWHlUeGhqck13?=
 =?utf-8?B?b0tZMDgwYlFxamRVd2hiczA4eGNzQ3NXaDdWSzBhRTRBQ3ZuL0NaOE5hTXNm?=
 =?utf-8?B?Y1ZTb05DaUZSNkF5Qys1Z2NZQW9WQWU1aUxETG0yQ1pqU2kxOG10ODUzWGs0?=
 =?utf-8?B?WXFrM3Q0YjhFN2pJV08rMUd6NTBCRUpneGw1YkYzdnhlTEY1Q3N1cHBReEZF?=
 =?utf-8?B?ZHNaM3F3NWl5dUdQN0tlaGg3Yk5EYjdsR3NlMkNEODNDUFA1eFdiMFQ3cnhY?=
 =?utf-8?B?dW4xTTFrOElEdTNBUXFMdmM0djYxdjRYRmlWd2R5bzBoWGZQV3pYNjB2bG5G?=
 =?utf-8?B?dlhpOWxwVXlwMjZCWndyVkRzZGdXdHNDc0Q0YTUyMmFVUlVLTjFXMWdnbmFk?=
 =?utf-8?B?UzJ1UHNMSXlzczFUK3prNjMxa0R6ajZ0R3NvbC9ha0pHODNYTEgyT01HNWVO?=
 =?utf-8?B?dW10c1E0OU12QzRGUnBYVTErczBuWXZwdXVyb3J3eGhRaXQ2TWdFSUNmSjF6?=
 =?utf-8?Q?7FBxIgPES1AjrfW1wZTRoYNCN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27670545-be32-401f-cf33-08dacdca0e8c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 03:14:53.9418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UzlhTZMDABt78BrdaubSpdSVH+5C7mQ3/hFIgUfoLze+x0/gXzot72F49mvRePqE+zkOqora+zDO9/NVzdloQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/24 02:41, Jason Gunthorpe wrote:
> On Wed, Nov 23, 2022 at 07:01:03AM -0800, Yi Liu wrote:
>> With the introduction of iommufd[1], VFIO is towarding to provide device
>> centric uAPI after adapting to iommufd. With this trend, existing VFIO
>> group infrastructure is optional once VFIO converted to device centric.
>>
>> This series moves the group specific code out of vfio_main.c, prepares
>> for compiling group infrastructure out after adding vfio device cdev[2]
>>
>> Complete code in below branch:
>>
>> https://github.com/yiliu1765/iommufd/commits/vfio_group_split_rfcv1
>>
>> This is based on Jason's "Connect VFIO to IOMMUFD"[3] and my "Make mdev driver
>> dma_unmap callback tolerant to unmaps come before device open"[4]
>>
>> [1] https://lore.kernel.org/all/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com/
>> [2] https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev
>> [3] https://lore.kernel.org/kvm/063990c3-c244-1f7f-4e01-348023832066@intel.com/T/#t
>> [4] https://lore.kernel.org/kvm/20221123134832.429589-1-yi.l.liu@intel.com/T/#t
> 
> I looked at this for a while, I think you should squish the below into
> the series too.
> 
> A good goal is to make it so we can compile out vfio_device::group
> entirely when group.c is disabled. This makes the compile time
> checking stronger (adjust the cdev patch to do this). It means
> removing all device->group references from vfio_main.c, which the
> below does:

sure, I'll refine the series with below hints. btw. If no device->group
reference in vfio_main.c, then we may also make struct vfio_device::group
defined optionally in header file. This may be done in later cdev series.

> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index d8ef098c1f74a6..3a69839c65ff75 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -476,8 +476,8 @@ void vfio_device_remove_group(struct vfio_device *device)
>   	put_device(&group->dev);
>   }
>   
> -struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
> -					    enum vfio_group_type type)
> +static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
> +						   enum vfio_group_type type)
>   {
>   	struct iommu_group *iommu_group;
>   	struct vfio_group *group;
> @@ -526,7 +526,7 @@ static bool vfio_group_has_device(struct vfio_group *group, struct device *dev)
>   	return false;
>   }
>   
> -struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> +static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>   {
>   	struct iommu_group *iommu_group;
>   	struct vfio_group *group;
> @@ -577,6 +577,22 @@ struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>   	return group;
>   }
>   
> +int vfio_device_set_group(struct vfio_device *device, enum vfio_group_type type)
> +{
> +	struct vfio_group *group;
> +
> +	if (type == VFIO_IOMMU)
> +		group = vfio_group_find_or_alloc(device->dev);
> +	else
> +		group = vfio_noiommu_group_alloc(device->dev, type);
> +	if (IS_ERR(group))
> +		return PTR_ERR(group);
> +
> +	/* Our reference on group is moved to the device */
> +	device->group = group;
> +	return 0;
> +}
> +
>   void vfio_device_group_register(struct vfio_device *device)
>   {
>   	mutex_lock(&device->group->device_lock);
> @@ -632,8 +648,10 @@ void vfio_device_group_unuse_iommu(struct vfio_device *device)
>   	mutex_unlock(&device->group->group_lock);
>   }
>   
> -struct kvm *vfio_group_get_kvm(struct vfio_group *group)
> +struct kvm *vfio_device_get_group_kvm(struct vfio_device *device)
>   {
> +	struct vfio_group *group = device->group;
> +
>   	mutex_lock(&group->group_lock);
>   	if (!group->kvm) {
>   		mutex_unlock(&group->group_lock);
> @@ -643,24 +661,8 @@ struct kvm *vfio_group_get_kvm(struct vfio_group *group)
>   	return group->kvm;
>   }
>   
> -void vfio_group_put_kvm(struct vfio_group *group)
> -{
> -	mutex_unlock(&group->group_lock);
> -}
> -
> -void vfio_device_group_finalize_open(struct vfio_device *device)
> +void vfio_device_put_group_kvm(struct vfio_device *device)
>   {
> -	mutex_lock(&device->group->group_lock);
> -	if (device->group->container)
> -		vfio_device_container_register(device);
> -	mutex_unlock(&device->group->group_lock);
> -}
> -
> -void vfio_device_group_abort_open(struct vfio_device *device)
> -{
> -	mutex_lock(&device->group->group_lock);
> -	if (device->group->container)
> -		vfio_device_container_unregister(device);
>   	mutex_unlock(&device->group->group_lock);
>   }
>   
> @@ -779,9 +781,9 @@ bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
>   }
>   EXPORT_SYMBOL_GPL(vfio_file_has_dev);
>   
> -bool vfio_group_has_container(struct vfio_group *group)
> +bool vfio_device_has_container(struct vfio_device *device)
>   {
> -	return group->container;
> +	return device->group->container;
>   }
>   
>   static char *vfio_devnode(struct device *dev, umode_t *mode)
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 670c9c5a55f1fc..e69bfcefee400e 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -70,19 +70,16 @@ struct vfio_group {
>   	struct iommufd_ctx		*iommufd;
>   };
>   
> +int vfio_device_set_group(struct vfio_device *device,
> +			  enum vfio_group_type type);
>   void vfio_device_remove_group(struct vfio_device *device);
> -struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
> -					    enum vfio_group_type type);
> -struct vfio_group *vfio_group_find_or_alloc(struct device *dev);
>   void vfio_device_group_register(struct vfio_device *device);
>   void vfio_device_group_unregister(struct vfio_device *device);
>   int vfio_device_group_use_iommu(struct vfio_device *device);
>   void vfio_device_group_unuse_iommu(struct vfio_device *device);
> -struct kvm *vfio_group_get_kvm(struct vfio_group *group);
> -void vfio_group_put_kvm(struct vfio_group *group);
> -void vfio_device_group_finalize_open(struct vfio_device *device);
> -void vfio_device_group_abort_open(struct vfio_device *device);
> -bool vfio_group_has_container(struct vfio_group *group);
> +struct kvm *vfio_device_get_group_kvm(struct vfio_device *device);
> +void vfio_device_put_group_kvm(struct vfio_device *device);
> +bool vfio_device_has_container(struct vfio_device *device);
>   int __init vfio_group_init(void);
>   void vfio_group_cleanup(void);
>   
> @@ -142,12 +139,12 @@ int vfio_container_attach_group(struct vfio_container *container,
>   void vfio_group_detach_container(struct vfio_group *group);
>   void vfio_device_container_register(struct vfio_device *device);
>   void vfio_device_container_unregister(struct vfio_device *device);
> -int vfio_group_container_pin_pages(struct vfio_group *group,
> +int vfio_device_container_pin_pages(struct vfio_device *device,
>   				   dma_addr_t iova, int npage,
>   				   int prot, struct page **pages);
> -void vfio_group_container_unpin_pages(struct vfio_group *group,
> +void vfio_device_container_unpin_pages(struct vfio_device *device,
>   				      dma_addr_t iova, int npage);
> -int vfio_group_container_dma_rw(struct vfio_group *group,
> +int vfio_device_container_dma_rw(struct vfio_device *device,
>   				dma_addr_t iova, void *data,
>   				size_t len, bool write);
>   
> @@ -187,21 +184,21 @@ static inline void vfio_device_container_unregister(struct vfio_device *device)
>   {
>   }
>   
> -static inline int vfio_group_container_pin_pages(struct vfio_group *group,
> -						 dma_addr_t iova, int npage,
> -						 int prot, struct page **pages)
> +static inline int vfio_device_container_pin_pages(struct vfio_device *device,
> +						  dma_addr_t iova, int npage,
> +						  int prot, struct page **pages)
>   {
>   	return -EOPNOTSUPP;
>   }
>   
> -static inline void vfio_group_container_unpin_pages(struct vfio_group *group,
> -						    dma_addr_t iova, int npage)
> +static inline void vfio_device_container_unpin_pages(struct vfio_device *device,
> +						     dma_addr_t iova, int npage)
>   {
>   }
>   
> -static inline int vfio_group_container_dma_rw(struct vfio_group *group,
> -					      dma_addr_t iova, void *data,
> -					      size_t len, bool write)
> +static inline int vfio_device_container_dma_rw(struct vfio_device *device,
> +					       dma_addr_t iova, void *data,
> +					       size_t len, bool write)
>   {
>   	return -EOPNOTSUPP;
>   }
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index a7b966b4f3fc86..3108e92a5cb20b 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -260,17 +260,10 @@ void vfio_free_device(struct vfio_device *device)
>   EXPORT_SYMBOL_GPL(vfio_free_device);
>   
>   static int __vfio_register_dev(struct vfio_device *device,
> -		struct vfio_group *group)
> +			       enum vfio_group_type type)
>   {
>   	int ret;
>   
> -	/*
> -	 * In all cases group is the output of one of the group allocation
> -	 * functions and we have group->drivers incremented for us.
> -	 */
> -	if (IS_ERR(group))
> -		return PTR_ERR(group);
> -
>   	if (WARN_ON(device->ops->bind_iommufd &&
>   		    (!device->ops->unbind_iommufd ||
>   		     !device->ops->attach_ioas)))
> @@ -283,16 +276,19 @@ static int __vfio_register_dev(struct vfio_device *device,
>   	if (!device->dev_set)
>   		vfio_assign_device_set(device, device);
>   
> -	/* Our reference on group is moved to the device */
> -	device->group = group;
> -
>   	ret = dev_set_name(&device->device, "vfio%d", device->index);
>   	if (ret)
> -		goto err_out;
> +		return ret;
>   
> -	ret = device_add(&device->device);
> +	ret = vfio_device_set_group(device, type);
>   	if (ret)
> -		goto err_out;
> +		return ret;
> +
> +	ret = device_add(&device->device);
> +	if (ret) {
> +		vfio_device_remove_group(device);
> +		return ret;
> +	}
>   
>   	/* Refcounting can't start until the driver calls register */
>   	refcount_set(&device->refcount, 1);
> @@ -300,15 +296,12 @@ static int __vfio_register_dev(struct vfio_device *device,
>   	vfio_device_group_register(device);
>   
>   	return 0;
> -err_out:
> -	vfio_device_remove_group(device);
> -	return ret;
>   }
>   
>   int vfio_register_group_dev(struct vfio_device *device)
>   {
> -	return __vfio_register_dev(device,
> -		vfio_group_find_or_alloc(device->dev));
> +	return __vfio_register_dev(device, VFIO_IOMMU);
> +
>   }
>   EXPORT_SYMBOL_GPL(vfio_register_group_dev);
>   
> @@ -318,8 +311,7 @@ EXPORT_SYMBOL_GPL(vfio_register_group_dev);
>    */
>   int vfio_register_emulated_iommu_dev(struct vfio_device *device)
>   {
> -	return __vfio_register_dev(device,
> -		vfio_noiommu_group_alloc(device->dev, VFIO_EMULATED_IOMMU));
> +	return __vfio_register_dev(device, VFIO_EMULATED_IOMMU);
>   }
>   EXPORT_SYMBOL_GPL(vfio_register_emulated_iommu_dev);
>   
> @@ -386,7 +378,7 @@ static int vfio_device_first_open(struct vfio_device *device)
>   	if (ret)
>   		goto err_module_put;
>   
> -	kvm = vfio_group_get_kvm(device->group);
> +	kvm = vfio_device_get_group_kvm(device);
>   	if (!kvm) {
>   		ret = -EINVAL;
>   		goto err_unuse_iommu;
> @@ -398,12 +390,12 @@ static int vfio_device_first_open(struct vfio_device *device)
>   		if (ret)
>   			goto err_container;
>   	}
> -	vfio_group_put_kvm(device->group);
> +	vfio_device_put_group_kvm(device);
>   	return 0;
>   
>   err_container:
>   	device->kvm = NULL;
> -	vfio_group_put_kvm(device->group);
> +	vfio_device_put_group_kvm(device);
>   err_unuse_iommu:
>   	vfio_device_group_unuse_iommu(device);
>   err_module_put:
> @@ -1199,8 +1191,8 @@ int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
>   	/* group->container cannot change while a vfio device is open */
>   	if (!pages || !npage || WARN_ON(!vfio_assert_device_open(device)))
>   		return -EINVAL;
> -	if (vfio_group_has_container(device->group))
> -		return vfio_group_container_pin_pages(device->group, iova,
> +	if (vfio_device_has_container(device))
> +		return vfio_device_container_pin_pages(device, iova,
>   						      npage, prot, pages);
>   	if (device->iommufd_access) {
>   		int ret;
> @@ -1237,8 +1229,8 @@ void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
>   	if (WARN_ON(!vfio_assert_device_open(device)))
>   		return;
>   
> -	if (vfio_group_has_container(device->group)) {
> -		vfio_group_container_unpin_pages(device->group, iova,
> +	if (vfio_device_has_container(device)) {
> +		vfio_device_container_unpin_pages(device, iova,
>   						 npage);
>   		return;
>   	}
> @@ -1276,9 +1268,9 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
>   	if (!data || len <= 0 || !vfio_assert_device_open(device))
>   		return -EINVAL;
>   
> -	if (vfio_group_has_container(device->group))
> -		return vfio_group_container_dma_rw(device->group, iova,
> -						   data, len, write);
> +	if (vfio_device_has_container(device))
> +		return vfio_device_container_dma_rw(device, iova, data, len,
> +						    write);
>   
>   	if (device->iommufd_access) {
>   		unsigned int flags = 0;

-- 
Regards,
Yi Liu
