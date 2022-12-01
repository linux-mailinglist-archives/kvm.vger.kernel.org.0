Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7377563EA8F
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 08:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiLAHvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 02:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiLAHvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 02:51:09 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A0F46675;
        Wed, 30 Nov 2022 23:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669881067; x=1701417067;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=so0mF1IbyLN/xDZ4sh9I6GYEIUYdt/eX7BsDWnKhCiY=;
  b=NSduJKJI9uh+UL0QtiZSXyJnFaNJtE1jb3DB+wZUEzYtV4cVdt0zhR+h
   Asnw/CXvegBtUAZnr4JA2KyP1BQtE9emASFaTNriBQLPLGVueDXQHOySN
   M52aX9lmLDhOZgDFWmIUuzqHPigK666EWCSnbc53OnRTIj/hsDL29L9cq
   t4YU7C+PQnlP+y0501zXzGI5PTQtZ0xQ/oQJOy6oiG5k0gE9WhUwxQWSm
   hW68Y4d2rnKTl26lcwv4lQTS1PWrR54glLm5Ejp+OFpzTxoQFX7rIpFlo
   gBJpZdgj9cRM8EflTDock3q3efrJbC4dNGprVEswoXI0uhGODymNpZi/s
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="314316433"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="314316433"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 23:50:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="733310364"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="733310364"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Nov 2022 23:50:46 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 23:50:45 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 23:50:45 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 23:50:45 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 23:50:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKhcKoTMvWwixvy7iWIkVv8UKywybhDOMfQGT6YC5G1H2/XRSmFx52Coxyx0q4FueWmKaMXs/GtF5jk/u8w2zC7QcCzzvsY4kOjTTTEgcnXIw/X12SKTwJNKc5rAV7KeuQCYtA7/h+BmyZhgcz8V5LXBmrMOfHd6YtSvorlrRGFcZgDcMXx6A9PIKAm1LmMrzS3p/DT7bX8Gf1JpjSfZMDFdrqDvByNECVwyJpepyvLvCrhKMglrQGXrDp2JfjXA31yhUAjRU75POOM2Qqs1qOlOew7caYZObK0nKp6tYPJH6OiBwjQhmV8SyKiwk5k+ciiUAzjzmWXhtOqFS7bTtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FeaLIlNJDOaNAauOuzK7ucXUV7T6XteQ5MlEOyQLjWA=;
 b=ap8Ge/3THtGjKw4Aacn7dUlKlend7YdTfu3jYpnQ5XpxgZm41dhS+sPq0k8yNqaR2IneCM35z38xK3tIdWP+1ifBdlz74KbbKvXV1+U4x2l10sLoDjtfY3Oy50b352IzaItKcAzm/GPlINLwAAp96uTCmFikZvfwyg3K56z+SSYNMrnECoNbEcpdW7OGh36vHhxq4CxyLthHDx4itvhqtnCHHVQ9Gy9ErnpM8s+P68yFJu5imyvqaY8lUN5X5FrmyjXKFAJM/AGAwSpG0kZBlqk7eFFc6XJCvi/M84cMmIFPsGpdFC0mCdMCgwVgUkkxsW7Xaer432bAGxUHbPeS4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN2PR11MB4616.namprd11.prod.outlook.com (2603:10b6:208:26f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 07:50:43 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 07:50:43 +0000
Message-ID: <39583ff0-e6ca-e236-9905-c863f897c0b0@intel.com>
Date:   Thu, 1 Dec 2022 15:51:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [[RESEND] iommufd PATCH v2 1/2] i915/gvt: Move gvt mapping cache
 initialization to intel_vgpu_init_dev()
Content-Language: en-US
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     <jgg@nvidia.com>, <alex.williamson@redhat.com>,
        <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        <mjrosato@linux.ibm.com>, <chao.p.peng@linux.intel.com>,
        <yi.y.sun@linux.intel.com>, <intel-gvt-dev@lists.freedesktop.org>,
        <linux-s390@vger.kernel.org>, Zhi Wang <zhi.a.wang@intel.com>
References: <20221129105831.466954-1-yi.l.liu@intel.com>
 <20221129105831.466954-2-yi.l.liu@intel.com>
 <20221201032531.GY30028@zhen-hp.sh.intel.com>
 <47b0f601-5022-c083-44e8-4048031dddd4@intel.com>
 <20221201072119.GZ30028@zhen-hp.sh.intel.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221201072119.GZ30028@zhen-hp.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0093.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::33) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MN2PR11MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: 802e4676-186e-4200-ef68-08dad370bf3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hInEe014f8/J2He8zzLBL3FO4VTlGam4G4Ei1GUAi2e5zu+EE9GPHj6NxvXPN5ymh5/uQYBjPaVPQNabzmb2yIB/QGIjQLIa2vEmNJaZTLRMJDFl7kW+RLz6ltQikvlRH0PUwNtIN6Zx+uqH7Q5tWXibSp2bYHQMgZOBIfn4KzYE9TOVH16gBUOQigcsDRKU3EpqayUf+qdoD0hQTVwMPm/EQ03zjlhldZxG5uICE+awc5XHGs/EzGAWktYweF2IjMzpR7JkWROmdUCrNHk48M1wSVMya0qEEb6x7/uqVMTUscwTTVXWekx12KSort7RkMFO/iwj/QXWOITnqxRSDkILDJGeJ0r4UfaCxwSpT4+lTyauw0wqJPiMi9yJw/F8GHVPGT995thzwDGJoOG8SUZxV3tHzRP2VhXyipN/rKe+aw2vKq3ajta3GCmJ35Kwq84rRXw0apj0cUHvCa6UXQXWFUtjGyToOWpRr+ZVWRPoNXpQLohY68m7/to6VrN8lgok+HPGuqD2kasXOj4oZsq9lXZ7LJiSFx+EvjudtsVzxo3q6AHZw651HMjOnRwKDWftOMDm9y32i8jazrCoqlT5H6wkag55eq75C6E92EaZzaM2PRnLC4I/hcAkwHrWWFUYsgqWcboWRwvedCR3+l14HLYXqTjsOcLp1mEEnV5FqjM7jeYZhh4ZS3Z4Z5fznEQg3O0vSP9QYlrrSYzn9C7Cq43Mqw83NKIb4gMNow4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(376002)(396003)(366004)(451199015)(2616005)(6666004)(86362001)(41300700001)(6916009)(31696002)(6506007)(38100700002)(26005)(316002)(82960400001)(6512007)(4326008)(8676002)(66476007)(66946007)(53546011)(36756003)(66556008)(31686004)(2906002)(186003)(83380400001)(5660300002)(6486002)(8936002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDUwVFQ3aGYrRmNXdnF1U3RHdGJpVVQvWENsK1hrY1gxbkNzRUJ6UTQxVHk5?=
 =?utf-8?B?RDFScmhGTnFXMGRYV0dEamFDRXdPOExqVVFKRHFNQStZSXV5MFZCK2pzZkZT?=
 =?utf-8?B?ajd4OW1hVlV4YjEydThuSzlPRjQ1TFFYcXhCMjROamxMUHBQZGxwZUE0Z1pU?=
 =?utf-8?B?d25adURRbnFJRlZab1FVa3l3NUhHWmg1bFFCOVJZNnRDZG5IZmZPOFdlVkNZ?=
 =?utf-8?B?RnhTYldsaFJ5cmlMSngyMmlQc2tsK1NudjhJNGdDbzR5RmVjOUlsZEdPdlNs?=
 =?utf-8?B?WjU0QldhSzFQVE5LaFhIV2IvZWZSNmR2YmM1VXM3U2tpMlVFUjhDR0Fma1Zq?=
 =?utf-8?B?bUEyWERKZmZJQlkvYXFpNE1vcWVZUmFlbitDN0VCQzdOOVd6dit3TXMxRTNt?=
 =?utf-8?B?bGU2WlRJbzVUUHBuRHRvUnJ1QmFCWElyYUwvSmlTRDFlei8wUVV4eDU3Q3dF?=
 =?utf-8?B?UUNsUTJYVHNFeHM5NWx3ZTgvbXVSRm5QVXpzWHRueFpoZU44Vk1VY295RjRW?=
 =?utf-8?B?UEJucFl1SHhyM09SaWd6UW4wY2s2LzBSQTRKQko4RStmaXUzQ0QvZFp5bmp3?=
 =?utf-8?B?QXQvRFlsRWQ0NlZ1Q1hnS0hiUTc2SFgwNWdqVnVueHdlZlBrREExczNOQmJC?=
 =?utf-8?B?UnFna1FQaHFFclZGMmR6eWtuM3FMOFNKV3B3dWlSeU1qcHdzSytXbVBXYU1w?=
 =?utf-8?B?R0VndkE1UmRTM0cxaVRVUktTVDFyYzlhMFdSYkQ2b20rWEdzMTI3alFPN3h3?=
 =?utf-8?B?bzd0alhCL0hMMVdiRTJvUkc2cThVd2VDRUFBNmN3YkN0WWtpTVk0WCtDWk9a?=
 =?utf-8?B?bkY0S1JnTnlib1VobWFta1UxOEIyMytmcUpUei9vMHRtL3FOTHRUWmJjQ3Br?=
 =?utf-8?B?L0pkakVKYWpYMFBwdDkza2M5d2JNZWdxRVdpemw0MUFkUlkvTmk2eXV5czVW?=
 =?utf-8?B?Wmo0UXAvZnBYUWNzSzlPanF6WjlGbEx3ckpkZmY4QUs5c2FlcXZiNzN4L2Zv?=
 =?utf-8?B?cFBEdlBZS3RWRWl2QWh6TGRxTXpuZ2VJV2dTUWljd1pockxyZ2tDYkxhZW5Y?=
 =?utf-8?B?cWJ0d2JiMHZGSzllK2w4M0E4RUp0OXJPOG5xYmdhVW1XMTVrcmRWWE9jSzM3?=
 =?utf-8?B?VC9lVGM0WkgxYXJ0ekt5dUNQYjYvMGdGQU8zS2wxYjIzN2dhNzQ1SnQ4RFNZ?=
 =?utf-8?B?UUo3UTFEN3BGanV1ei9TN3A3czZFQXlwSmVrMkcwZVk0MXIxYmFLR05oV3M1?=
 =?utf-8?B?V1NmdDBIanFhUEpwOW40UmViODNmU2hkcnhRTjdJZlcyNzhuejlTUlRzUUxI?=
 =?utf-8?B?Y2NJNDJjVzhsSUx3Sm8wRWlyTnFxYkZCNGNDOWtCTVpZdFpJWElNUS85NWNK?=
 =?utf-8?B?S2J1U29BWUhURlFTRHRvM0V2dUdaQmVxVW5xYlFITWJlVkdPYVE0c0lzem5y?=
 =?utf-8?B?SHZjQVFhV3FlOVZFZnlkMCtGZ3JBUE5ocForMEFOdUVLOC9zK25UM1dDLzlR?=
 =?utf-8?B?M1hPbnZqVUp6YTB1Vm52U0lnb0doR2libGFnU2w0Ri9ZMW10SE94ZVVhK0Jr?=
 =?utf-8?B?d202MW9GRnRYdjF5WVl6R3l4MlIrZ1BEV3VhenFMeXdsNFFhY3R1dWFuNklq?=
 =?utf-8?B?UWVNeTYrd2pDeW1uenluSkNHazNYOWxaaE42S1NtWFZyR3VqY1JySEI5S1RD?=
 =?utf-8?B?dFQvTm9YbC9iU2IxdHFrL1BmYzU4Y2VROGRraEFld29ZWlQ3YnBzTEVvcURi?=
 =?utf-8?B?TTZWVjJBdVNodDBpSDNQd0RtZXoyOERreVhPOTllR3A4UmsvdVpoZnh1N1ky?=
 =?utf-8?B?Nm52RFVObnNqa0pZaW9uTEdzQ3c1M01MT1RZSC9BNlUxbW1ZYXg1VFNscGlj?=
 =?utf-8?B?V1JEaDdrdnAvYWVvV242Zmc2cnRyTHBYbi9lNUk1UU9PeStYZVExcllMMlNS?=
 =?utf-8?B?Qk5jVzNRUmV3WVQxaG9DbndLbktNK0UxSkZNSUtPOGNYQnRNcloxYldDUER4?=
 =?utf-8?B?VEZXQmJNQUNIVjJ5K29lZjZLQ0lxSWFqY081eEJldk1yOGhrQ3ZpY3RjZ1lP?=
 =?utf-8?B?S2JFalY1N0pxNWFTaWlQVUY4RGNFbE1oREpKZGplVzV4WnJhbEo0SmVxQUta?=
 =?utf-8?Q?YzznzO2U47tBFtNE0fd6bG6QR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 802e4676-186e-4200-ef68-08dad370bf3f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 07:50:42.7907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qh8TjPhGDegfAK5sY4WFvc6sGy2vXY0QApkPmV+kiVmAg0QPITdvWwXnMZFAIvutF2jUcJZiSGlXEhb+GQmjTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4616
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/1 15:21, Zhenyu Wang wrote:
> On 2022.12.01 12:18:29 +0800, Yi Liu wrote:
>> On 2022/12/1 11:25, Zhenyu Wang wrote:
>>> On 2022.11.29 02:58:30 -0800, Yi Liu wrote:
>>>> vfio container registers .dma_unmap() callback after the device is opened.
>>>> So it's fine for mdev drivers to initialize internal mapping cache in
>>>> .open_device(). See vfio_device_container_register().
>>>>
>>>> Now with iommufd an access ops with an unmap callback is registered
>>>> when the device is bound to iommufd which is before .open_device()
>>>> is called. This implies gvt's .dma_unmap() could be called before its
>>>> internal mapping cache is initialized.
>>>>
>>>> The fix is moving gvt mapping cache initialization to vGPU init. While
>>>> at it also move ptable initialization together.
>>>>
>>>> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
>>>> Cc: Zhi Wang <zhi.a.wang@intel.com>
>>>> Cc: Kevin Tian <kevin.tian@intel.com>
>>>> Cc: intel-gvt-dev@lists.freedesktop.org
>>>> Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
>>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>>> ---
>>>>    drivers/gpu/drm/i915/gvt/kvmgt.c | 13 +++++++++----
>>>>    1 file changed, 9 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
>>>> index 7a45e5360caf..f563e5dbe66f 100644
>>>> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
>>>> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
>>>> @@ -671,9 +671,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
>>>>    	vgpu->attached = true;
>>>> -	kvmgt_protect_table_init(vgpu);
>>>> -	gvt_cache_init(vgpu);
>>>> -
>>>>    	vgpu->track_node.track_write = kvmgt_page_track_write;
>>>>    	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
>>>>    	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
>>>> @@ -1451,9 +1448,17 @@ static int intel_vgpu_init_dev(struct vfio_device *vfio_dev)
>>>>    	struct intel_vgpu *vgpu = vfio_dev_to_vgpu(vfio_dev);
>>>>    	struct intel_vgpu_type *type =
>>>>    		container_of(mdev->type, struct intel_vgpu_type, type);
>>>> +	int ret;
>>>>    	vgpu->gvt = kdev_to_i915(mdev->type->parent->dev)->gvt;
>>>> -	return intel_gvt_create_vgpu(vgpu, type->conf);
>>>> +	ret = intel_gvt_create_vgpu(vgpu, type->conf);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	kvmgt_protect_table_init(vgpu);
>>>> +	gvt_cache_init(vgpu);
>>>> +
>>>> +	return 0;
>>>
>>> I'm fine with this change, but could we add some sanity check at close
>>> time to ensure we clean up any internal cache? Btw, do we need to reset
>>> rbtree root pointer?
>>
>> I noticed there is gvt_cache_destroy() in intel_vgpu_close_device(). This
>> cleans up the internal cache. So even the rbtree root is valid, it is an
>> empty per close_device(). isn't it?
>>
> 
> I'd like to see an explicit sanity check on vgpu->nr_cache_entries and
> reset rb root at close time, which matches current code behavior, but
> not need to do re-init.

do you mean check vgpu->nr_cache_entries before calling 
gvt_cache_destroy()? I think it should be possible non-zero, so even 
non-zero is detected, nothing should be done. But if non-zero nr_cache_entries
is detected after gvt_cache_destroy(), this should be a problem as
gvt_cache_destroy() should make nr_cache_entries be zero. Is there any
chance that it is still non-zero after gvt_cache_destroy()?

static void gvt_cache_destroy(struct intel_vgpu *vgpu)
{
         struct gvt_dma *dma;
         struct rb_node *node = NULL;

         for (;;) {
                 mutex_lock(&vgpu->cache_lock);
                 node = rb_first(&vgpu->gfn_cache);
                 if (!node) {
                         mutex_unlock(&vgpu->cache_lock);
                         break;
                 }
                 dma = rb_entry(node, struct gvt_dma, gfn_node);
                 gvt_dma_unmap_page(vgpu, dma->gfn, dma->dma_addr, dma->size);
                 __gvt_cache_remove_entry(vgpu, dma); //decrements 
nr_cache_entries
                 mutex_unlock(&vgpu->cache_lock);
         }
}

-- 
Regards,
Yi Liu
