Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BD1641723
	for <lists+kvm@lfdr.de>; Sat,  3 Dec 2022 14:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLCNws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Dec 2022 08:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiLCNwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Dec 2022 08:52:44 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4AA5F72
        for <kvm@vger.kernel.org>; Sat,  3 Dec 2022 05:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670075563; x=1701611563;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YwW0cCYBimllXhdsZqLId0R005ZCCYC80KIXLCEXu9A=;
  b=OKkEiCX1b6scWIJ+dcPzk+8WfswNOyIVKWjkL471HmpkpTb9/esdFYI2
   49xrlVbIjsIHt87EMV7NdW6rvcq4KOi9W3TasorhiRH6UQ0f2oeypPrO8
   GGotLl92ErjKcQVOT+4Nekus0lU0Y1G5rATYZNTvMAC5qWPfv8gyg9gwx
   jKpYaXZMWBBYDlrlquvqQYZ3UOiCAqD2P53Tjna1iY9vjaaUbd0kiTD+r
   KIQ0rj2p81xsq4cdKRuRWKvEW2abIFtLMC6YPu0b5nLFfA7W/h+W1VPzm
   GujZ1GyeZAbTFEGcnkitb320nQnuuUdUcSkaAlDdSGRWWky/VHUyo7uOJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="314829855"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="314829855"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2022 05:52:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="639026591"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="639026591"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 03 Dec 2022 05:52:42 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 3 Dec 2022 05:52:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 3 Dec 2022 05:52:41 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 3 Dec 2022 05:52:41 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 3 Dec 2022 05:52:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKkDNrDPTbuP/8dpBe4u7/4KYnswHWGAZTx+xgE5xoQQiUM/wjEqw3WCEqsowg60dp5jEW0+Ga9UzojHUVJrC6Jm76KtYCnUdaoJwUX3Y2T4uDD3wRTo7+gpYbBAp8aayJ7BaBhVWPZaIor/Vh3t6Msmz/KazN4wtSyhnPvjIOI90ZgBfYHW4EDxgwTvi5eqMWTOdAMBpMAjtiA0foLxSVEDWMB/RTHmpRMXYLKXh+bEdnCTn6nMfxFZWFsP/dUi7mgSJQEWKrjWf3TH/SEnj8VLCtGaSaDL4X3sCpsU3uemTwrE24OcxF0//sjmyC9V+EmewMLMeLX3QXPaI/Jclw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51hQHS0uW8LFJ5+OpjEWPZFkkX1xsLck/MG1AhZtU4Q=;
 b=DjcZlnZw0kX8eeqaSuyTdZDHsTbmNZGNgR0/a4b/2owld4TgbZzyvkiiSvfnP34ugXTICSdOBQr8E1LNLMRK6ucCn3sFgbeB89VfLfqgDpSnAAhbxVUu1Au7U94fIFQ49H2JO9DmXR6F50BhF4h0iEtnZDd13u7RSqgBC8sh3YPsjNsjdUH613db5oUAYxi45W5fHa22d/Y2q9/fgq3JOaYUKRQlRcEgXoMlnT6G2ScVr8TyUFscbcTB7Tl/XkatWVAMgJ0EzflaQqo4IdV8XOLNtDtkHfNf7ZyAbn4JZZieky9iltZFyJvyZaTB+YcrBA2zTXH9xFK9xmpn+Wp19A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB5400.namprd11.prod.outlook.com (2603:10b6:208:311::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sat, 3 Dec
 2022 13:52:38 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%5]) with mapi id 15.20.5880.010; Sat, 3 Dec 2022
 13:52:38 +0000
Message-ID: <fecfc22d-cb9e-cac9-95ff-21df13f257c2@intel.com>
Date:   Sat, 3 Dec 2022 21:53:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 00/10] Move group specific code into group.c
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <yi.y.sun@linux.intel.com>
CC:     <kevin.tian@intel.com>, <cohuck@redhat.com>,
        <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <Y4kRC0SRD9kpKFWS@nvidia.com>
 <86c4f504-a0b2-969c-c2c6-5fd43deb6627@intel.com>
 <Y4oPTjCTlQ/ozjoZ@nvidia.com>
 <20221202161225.3144305f.alex.williamson@redhat.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221202161225.3144305f.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BL1PR11MB5400:EE_
X-MS-Office365-Filtering-Correlation-Id: e9449e53-0d2d-4c17-6ef4-08dad535a365
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZUHXUd8OpaXT1sMGmR9GKZtP1y6XMxt2ezbJeBJE3ZuDtOkbEjSyg8RGSCdtAcdwjHbMldw8Cq5u+PgzuvfwfI9wlvcbT9BRC+aO2jJ6jTxHv354CViQ66HCrnvtEBwyJQ3j5Sk0Pw39GGiTgEjwYxoN3fxNrrxotsjLMx+2icqGHc54FqT/A70+y5L3ybADBZZBeX/vKchCBeur3Vik++q6X/QGli1eewrvxQqxzF/CR7vX5az1onmVTncJYg7yE+KwH2Sy7GlfqCRykJJ5hk2+3kXX6vWyJH6/r/h6hGfQt3NUflc2uLk8bYgEzqie4b9S0PRsdu2NFlFSFdCxlzexIQjenHQ7fC79/AgFa9SKCmjF31qiHXzsTeOqATbNIGbUdJ9E0a+6GXwK9k+Mqkl0iJSyAQYR/wePotPijXp7wf048hBv3tWjsq17e1kbVjar8vcpqbVgFlKRsBmGPWMw6eYlNH3YCFammsdMWUa8SRBbeO/4w3GXxPQc6L6YkjkUdWTC86XAFnvcxMaikoAxw+x61w+UIhOffPGe6CRmnkTj6mkclS9/aoRSgW4OszSe+Wmi76AJagqq7vK9rHSI3p9O+HiF9+Dw7zlNbjRp55DzPwOK+ZSLmzWkHZlbYINlJddawRdG5ZclyXtikxxf1aIkE8XUU8ETAdWJ1bQD41m907yTGUFsRIe/+1EPk/rXmNbKGXOS8T3WgPzihF18EsdCjdUanfETTaPNJIlUeDO4cAIBSUyfPKADgagadZqgjI5upAf+9KBmz/BSmvWITQvJUEN/WinsiA1iYXQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199015)(86362001)(2906002)(31696002)(83380400001)(316002)(110136005)(6666004)(53546011)(6506007)(6512007)(186003)(26005)(966005)(6486002)(2616005)(478600001)(41300700001)(82960400001)(5660300002)(8936002)(38100700002)(4326008)(66946007)(66556008)(66476007)(8676002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NE1TbTVxVHd3b2IyMnJjQVk4OUxhZjVJeWdkNGlWcGhaaVZmQzIyblByUFhm?=
 =?utf-8?B?K0FiSlhYTVEzSU1ZRTB3UjFwVHBlQmo2RXRjalVyQjNVaHU1aHdHYnIvTzZH?=
 =?utf-8?B?Ky81T0RtS0twS3FMOUJXUG02cmhFZ0hyalpPYkswN09FV0ZMOUdzNU53amoz?=
 =?utf-8?B?VDZnOThnY2JlS0MrTkRWZVhzaGI5QnhVZGo4M0xUcG9La2FkWlJXM3VZTjI0?=
 =?utf-8?B?ZUtQVm81VnhwWHk5NEhKcjEzbVB2Ukd2TUd1dDA5VmRHeUFSell0MzZhSmw4?=
 =?utf-8?B?dnEybFcrWmkxc1Bpb2lMbGFnQTd5YU9NZ3dzNUYyQkZuT2FydFBlYUVEMk03?=
 =?utf-8?B?TGpnbjhUVmxjOTZQTDJaMi9XWTBQQVR4Z2tGS2VsQlVPTXoxNmRqaHVaa2d5?=
 =?utf-8?B?citESWs4YVBzV3J2dGIza1hobFJJQmxkV3FNdEYwejI2aU1HMExvcEN0bFQr?=
 =?utf-8?B?TG1Yb3JFaGt5ZGJvNllwL3I0anlxaEE4SEJOcVlYV3dhVTZUa3dLZ0ovU3NI?=
 =?utf-8?B?bGIwWm1PcWJHSkpaRTJKYi84bWtWalR5OFV3V3lVbHY2NFJlY25ZWlp2S3Ux?=
 =?utf-8?B?Q1o1cksycFd2QW0vc2M1b2JYVFV2SkFwcHBoS0c4ZTZ1U1BNcERkTU51Y0hu?=
 =?utf-8?B?SVFkS2lZdW9jbS92b3RoSUdzNjAvUXJIc2d5TzV4Ukh1M0NsM1RJTk1Dekds?=
 =?utf-8?B?QVM1MnorbUN6SGJKSy81V3ZIRTFqWE5wOHVDWks4NTl6WEp0K0xwOHE5QXl5?=
 =?utf-8?B?R1VpQXQ4YS9MQ2V5K0ljUERnU3B1alpqSjlSb01BazkxZzA0bldGeXlkdWpX?=
 =?utf-8?B?SUdrSXArZEx6aEpkelBPRkhmcjZlbjdIZjhnQXFUMDBmY2NsN3kwTnFOU1da?=
 =?utf-8?B?Y3V4empDTHpUMlFCT01RKzlxQ0xzZUpUOWNPNGpVY0JqWCs2RVF0Y25EbWlK?=
 =?utf-8?B?QUpReWx6ekNxVEZHUlNvYTl0T0FmQUd4VnNQaVRXbTdBWml2aFJoNmhySkhp?=
 =?utf-8?B?YVBPVkZrUytzZHphQzNGakhsV3FISGpVTnNwMGZ5dzhCWmg2WGx5OEJ2eFNB?=
 =?utf-8?B?YTQ3S1ZBTElZMDNMc1VvSklTalRhUXlETE40SDJJZzV0U0tSTi9aa2VBdlRM?=
 =?utf-8?B?NDhpRWI5cFU5dEljNE1JNnM0bU8za2pMU2NuZXAzbjZpN3EwMVZsUnhHTWY3?=
 =?utf-8?B?aU9Fa0RrdGlxUTg3aVUvN3F3dE01RW8zaVJ0RTB2SlhDN281NmcrWFFodFlx?=
 =?utf-8?B?ME5abkg5MXZmbDVCaHBQdjRwNlJqNjRmdDNwUzM1U1lxYVZHSkVIUU1qY0FK?=
 =?utf-8?B?NWM2WFliSDVtN2F6Rm92dVlkTFdYZ0VtZTNjUnQ4S090eEs3VkMyMDNSMG4z?=
 =?utf-8?B?emI0L1pLRWVEQjVNanFlc3JtTHRWVHhEaEI4UlczcWdhTEVvWUlrQUtOeTI0?=
 =?utf-8?B?VUxWRERyVEtDT0luTVMzMmNMT1JXSjViTTcreXZOL2srUUlJUVlEVHd3NTFB?=
 =?utf-8?B?YVhBN0daTTYvOWdIdWlZbFZEVU1yOXdqTUVTVXlxb2VGSWtwYTFRQVVsWEN6?=
 =?utf-8?B?WGRqM1NpZDg1S0pDcU1FUGVJTk0wOTgxYU1qZnRWendXb2toNHQvSWY3bmVm?=
 =?utf-8?B?TzFxSFNBVk4yNGZUL3pUNnpVVVo2b1lOTEVXL28vNGp5MFlIYzB6VnFGOWZY?=
 =?utf-8?B?d29OY0tZRCtiWStWcnhnZG5XaVNGUGI3MWNYZUNIdDZ0andBSk9lOGlQbXZk?=
 =?utf-8?B?cW9GRkVhenJuMHU4ZmpSNmlmczZmVG5LNFBpQ1lWc1ZkQ2g5bGE5NFJVL21I?=
 =?utf-8?B?aHU5K0tZSUlkZ3lpZTdZU1NyL2JORm0rTjhmR3dqU1ZTWjg0RHBnQ0RoYlRV?=
 =?utf-8?B?Nno1MUkzalFsTUtsbjhURlcyRmlzNzc4cXhUUzZGK0drdHUrSHF4aU1oVGQr?=
 =?utf-8?B?eW5xZU94N085RWNkY2M5MmpBYml5aW5ISmx6NFkzcEc0TmVQaUdDNmJLTFRa?=
 =?utf-8?B?UGg2cEVCbFZkKytSbnFXTmpqbkVUTjdrLzM1NURHWHZyM1R6OG15ZGxacjln?=
 =?utf-8?B?cmZvdmFXTUxlUC8vMnNFQ2ZIWjExdnV5aFZmSUorQ1MwdHRvd0loNVRORkRl?=
 =?utf-8?Q?FsCqmfTRgvSpWaOh2KHfuHqA/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9449e53-0d2d-4c17-6ef4-08dad535a365
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 13:52:38.0956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPTHqeWhQxlpdLQn7o3Fg5oOEXpZuOlH0rWw4bjVZUPfRfvI/Ttklt7dMClza8XORfmVbYjJMR6zISoSxQWrTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5400
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

On 2022/12/3 07:12, Alex Williamson wrote:
> On Fri, 2 Dec 2022 10:44:30 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> On Fri, Dec 02, 2022 at 09:57:45PM +0800, Yi Liu wrote:
>>> On 2022/12/2 04:39, Jason Gunthorpe wrote:
>>>> On Thu, Dec 01, 2022 at 06:55:25AM -0800, Yi Liu wrote:
>>>>> With the introduction of iommufd[1], VFIO is towarding to provide device
>>>>> centric uAPI after adapting to iommufd. With this trend, existing VFIO
>>>>> group infrastructure is optional once VFIO converted to device centric.
>>>>>
>>>>> This series moves the group specific code out of vfio_main.c, prepares
>>>>> for compiling group infrastructure out after adding vfio device cdev[2]
>>>>>
>>>>> Complete code in below branch:
>>>>>
>>>>> https://github.com/yiliu1765/iommufd/commits/vfio_group_split_v1
>>>>>
>>>>> This is based on Jason's "Connect VFIO to IOMMUFD"[3] and my "Make mdev driver
>>>>> dma_unmap callback tolerant to unmaps come before device open"[4]
>>>>>
>>>>> [1] https://lore.kernel.org/all/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com/
>>>>> [2] https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev
>>>>> [3] https://lore.kernel.org/kvm/0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com/
>>>>> [4] https://lore.kernel.org/kvm/20221129105831.466954-1-yi.l.liu@intel.com/
>>>>
>>>> This looks good to me, and it applies OK to my branch here:
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/
>>>>
>>>> Alex, if you ack this in the next few days I can include it in the
>>>> iommufd PR, otherwise it can go into the vfio tree in January
>>>>
>>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>    
>>>
>>> thanks. btw. I've updated my github to incorporate Kevin's nit and also
>>> r-b from you and Kevin.
>>
>> Please rebase it on the above branch also

To Jason: done. Please fetch from below branch.

https://github.com/yiliu1765/iommufd/commits/for-jason/vfio_group_split

> It looks fine to me aside from the previous review comments and my own
> spelling nit.  I also don't see that this adds any additional conflicts
> vs the existing iommufd integration for any outstanding vfio patches on
> the list, therefore, where there's not already a sign-off from me:
> 
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

To Alex: thanks. above branch is based on Jason's for-next. So may have
one minor conflict with below commit in your next branch.

vfio: Remove vfio_free_device

-- 
Regards,
Yi Liu
