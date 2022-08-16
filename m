Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5103595ED4
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 17:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbiHPPMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 11:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbiHPPMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 11:12:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6035E74BAC
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 08:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660662772; x=1692198772;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VinELAjBHg75gCog48KM/0A/jNqbrgLVcdXhOG8LsRI=;
  b=ZJ8Z2JvAe6MkW7nnTg5HKMIv4WkGlmE0iu8Cu+RlKWwYUDoauBEK/58x
   FY+2U8kxy/9bZOKlenKHbC4WYjmKpwylyudiKiHzON8LxDduGHt1mVKIo
   jFr8dnzLv3U6z9P2GzhvZwdj+r87r/vzt6ypVFOPJbdulHzytzR8TNqFi
   83kS8MLQ9pcH0Q650Yf3GdX4nIzhazcsTp0hi30YGFqlnk69OjidWPD/0
   xYRf+Ev0sIfyw2mNPJjV5HbN1FU8G0zCVhNeTJdQ9EkgVmciHhpPcVc0X
   BqlamBI6UgNXICQXXRpLPaiN6i+RU7o0CZf7WOsdhOViekrtajeIfCBKv
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="272638930"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="272638930"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 08:12:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="607070925"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 16 Aug 2022 08:12:51 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 16 Aug 2022 08:12:51 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 16 Aug 2022 08:12:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 16 Aug 2022 08:12:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 16 Aug 2022 08:12:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eq7xJQCNHVwWwecn/5zqkAUKD1T3ehBsIGYuVozkJcz+yXuripcZzsX4EzEYtz8eEbKPqvXq0aCVNdhZx3M5SFMrYj5iEWw8cTe6rbPRKLht7ZK1VsDNyN+jIZv7Hs2TUxP/2YrBGKUwYljzh/aPJWIPYxsozDh6zEMFXPv6fI/yb+wYmAZwlEd+wBE8dqfBbbgIxaBfWiClg7eWSw6SnsN2PsfS+ZTCBzu39lT3qk4hsHY7AlKtfFlI3kMnZCAwccxWBU6HWle/ckvaTxV2q7HkP9GuLaeVRX/wkstHG2D6onxZVDdTyt2swxP0gWJ09W2vSOZkOY9kHue8Hctrrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fRkxxKT5pTtog5AthcCmEWDVF3zLPrJgYFuliF5dXFc=;
 b=UtvAqF5tjzOHkWkp0+MOUUtwoX5K78yZTiUDNeafyhTWJWBOq5jj6+YMtS7draEJXP4j6cB0vzpbgNHrXaPHcRdnnh10Vrl/Cgzg8/+/KNSlfCbWO/4+73qCDlUfSbVUbU4LUDMwGCiqIeSan9p68VgzadAYOW5uUKLrFVfqS/72ebA4Wq5+DnSahtU5L2H0tJXRRwIHanL346V7Ej4FRT2f7wdopwToruZdL/CjB3hzpRocBFvSvsOxJwWkETmO1sD3KazGRUL7hVOvakD6+88orDWFsJtjd6GUtnZo8K8v+MKOLRluumj/OtnwNlph4F9vnjzZmdoJ+Qr3rs8Yew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by DM6PR11MB3194.namprd11.prod.outlook.com (2603:10b6:5:5c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 15:12:48 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d17a:b363:bea8:d12f]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d17a:b363:bea8:d12f%9]) with mapi id 15.20.5504.028; Tue, 16 Aug 2022
 15:12:47 +0000
Message-ID: <75f8fd2f-c298-b0d7-e2c2-7bee192afaca@intel.com>
Date:   Tue, 16 Aug 2022 23:12:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH] vfio: Remove vfio_group dev_counter
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
References: <0-v1-efa4029ed93d+22-vfio_dev_counter_jgg@nvidia.com>
 <1e4626c7-4eba-d1d6-a85d-6042acd64991@intel.com>
 <YvuNxRhOynTDJV4D@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <YvuNxRhOynTDJV4D@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0190.apcprd04.prod.outlook.com
 (2603:1096:4:14::28) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99caf0d9-4eae-4701-46ec-08da7f99c730
X-MS-TrafficTypeDiagnostic: DM6PR11MB3194:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cInkjiuYUBAg6nM0EkvBsCG+l2Wy2K7AseDSV2B+WUMtPGNPs+ULKOomo0DF9ErDalu2eUrJC4EphMbxvXSF6HzBeRi/lVipIuYFD23Q9D3v1ZlaxgtMf4vsYUPpruAQtTZb6ZYEJpUQd5/V1bkXmhKnGb0HrWp9I9F142uWLRDZV0yRLWaNJwgTg9MCHdXa0ryNeqdj8gWtJMDBS4PfLVESqx2W0mIHSLCkJ1Epxnzm8H3gmjcP1Q0oY6pK1Lo388vke0ymvuuLuGjnZCWv8qBY5Re+M1h+gJFiJOs2hTaQJcRzWGlNMvsxBSMIrI7v5hYL5hP0Xi3cc/4AKy2yOVvEfAYAQGyCB5eBDXZHjWab0k1dtn7BFCfksTKJOD5X1jlYy7C+H+dagh6Hm3n0kwXzjPRdwcGo40GJELnUNc8hrx80uu5w1tsiFpADeoqIMFx97+3kkbFSJ54P4snoI9NfMIIBBK6h5gfTwHQdppoTWAih7uQLCAEv0Q6hvtHGuS1kD5A2sdIoFbPiAJu9EzOrbmLpgahR0GutaucebxZ42Te2uWYOrBv+O1jwTktvsMQuApUFxqJ5xtIPNONZWlhpVW0hLkqs99EgXP7BPQaQEai45fOFjXa8OLVIJCqWAYeLwn2WjrFg0OYrA/zvjd78+V49jp/2bxEpxmKtVMw0d341ih/qoyyfIf8CySnKkdkcDBU8B2TM6+zpwjsnHDusQBVa++Ugbppriu770cnEEu1yyjMyvZaOI/+49fZm+BujlUsrIsqqVLw/D4jTCIAUjRBii3Q2cHA+i8PQQtazuhAwSc++bCizhaLXLBvDi9jldvCz9o+UqJiveZNmjan1H/R5WXLX/tud6ZAa9sTy3vLcqYhRH0IZUCw/LX5Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(396003)(346002)(376002)(366004)(38100700002)(6486002)(31696002)(4326008)(2906002)(86362001)(66946007)(8936002)(5660300002)(66476007)(66556008)(82960400001)(53546011)(6916009)(54906003)(26005)(8676002)(316002)(6506007)(36756003)(186003)(41300700001)(6666004)(31686004)(2616005)(83380400001)(478600001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dE1DWCsvZVEvTVRCODI4MU1YVU1pVXd4OWY2TTZScjVtSUppcGp6VUYzSWt2?=
 =?utf-8?B?NE5Wd2VtK2IrWFVhLzc2TXA2Vjc5WURsR0t5NnNFWml3dUZpTFM1Wmo0UkJX?=
 =?utf-8?B?QWIzbDMwS1lmTFNNKzltQkliWlptVWc3MnMzVjlseWpOUE5WMjZ0VVlabUh6?=
 =?utf-8?B?TkpsOVRwclJJcEpXcWQ1SE1SWkE2UDI5cGtUWWtCMDlKd21VZHpJTVhucE00?=
 =?utf-8?B?K0JvV1I1eVdOK3JCZEp1NHVCbFhKSHhSZkw4dXFGeit6R1B3Y2ludHJXMjFn?=
 =?utf-8?B?YW9NblZZc0YyYjVMbmtRWWtGNEhhMm1kUzJHWUp0QU1nOG1leWNlOStMTkU1?=
 =?utf-8?B?ZStWcnJOTE94RXRKdnh0YTFsMVg1eHFBZUdIY1ZXRzd3THY1dG00YlhKeGdR?=
 =?utf-8?B?R2FkRTJ4L0FxR3FoWGdEMWZRdEQvZUZibXFIUFJOckNZUEtHMk00SkdmYVcr?=
 =?utf-8?B?WVArcytocDJoTHk2T0VOeGdvMzh4ODZnckw1clppSFlUUkZBbFZZVUo3VnB4?=
 =?utf-8?B?RzFtV3k1ZTZ1NjhCZkczTTRjYTF2eWxmS1hKV1RXN2VhSisyOWZMNlpoM3A5?=
 =?utf-8?B?SVc2bmwrQkZaUlp1ZG1lK0g1Z3dCVSsrR3ExS0k4V3FISS8zeEVxWWhBbjNJ?=
 =?utf-8?B?REQ2eDV4dzNaTEFBNzc3MVRtREZBbXcwSVdCRWNVREJaOXc1TTlpeXBSS0FZ?=
 =?utf-8?B?bThuWmN6MDJ3ZnkrMXNUQnFwUER1dDBLcUdxZ3pSc1pxbTJKanZ5UERVeEI4?=
 =?utf-8?B?YjRwSFo4ZDdMeHp0WnJWWEZZSnR0ZTNsem9aT0t6Umo1cENXeVJWbW9IL20w?=
 =?utf-8?B?cE1kNnNLODd5c3AvMThrcS8xbDZrVlFrSWhOQ3pGQ3J5bzN4SW5uaXJWc08z?=
 =?utf-8?B?djJNRkRORGdBZmRVUG9GTTQyOFVPR2ZjS244MzZld0ZhZ1RPSk4vd1BuWnRE?=
 =?utf-8?B?aFVMWENqKzQ4aElQZTJlcVRFTkROUkw1OUtDWEo4Q3JlWTNiYzhnTXJVYnBG?=
 =?utf-8?B?V3FpS3dMWkVLYWtRMUxXRkxNWkw2cDMxSGZMV2tGREVHZDBIb2x4TW9KS3Vt?=
 =?utf-8?B?dVBRcXRGc2VPcytJNVdVa1g4U0xmWGEwNExPUGZrQkVWeGFUTExrcEN1WkE4?=
 =?utf-8?B?ZVByN003aVd2M0R4Zm1CQ1dDZGpXQlQreURzS2hvdWNDblRnWkduSktlSjJo?=
 =?utf-8?B?dDd5T3ZYRG5RTHE3MjdyQXVKRDJzdERKZWN0Z2pWVnVCclUxS2pGb05uQ1Yz?=
 =?utf-8?B?QzJYUW5GaFZhOCszUVhwUVNPajdLY0xqM2duOTBtMUtZcCtHTjJNdnRUN0cz?=
 =?utf-8?B?N3kyUHhjS3ZOUitaYTVaYTJGNXcyandzMXpNd3pYdU41Ym8xZkJJd05wbFlk?=
 =?utf-8?B?U1ZlU1VveWk5dSt4czgvYnFNMzJ4anJxNTI5OU9DcTRmMTFnaGtLekc3QlBs?=
 =?utf-8?B?M1JHMWp1ZFYxSkl4U3k5Y0lUQ1Q3V3dXSFNCMFNTaWVRNzdCUytaaVlrU05j?=
 =?utf-8?B?cVVkaXVESThPdU8wanh6c3EwdGI0QXlWTFFVSUZJQjdoN3ZvbFpYOXYybFgz?=
 =?utf-8?B?RU5hRGVSS0t2L0x6OGQ2UDlkQzU4TXdXNEF4dXd6eS9KT2pVUmtDeFVydTA5?=
 =?utf-8?B?R3kralNUa1dsWTVmWnJpK01mY2ZYOEgvWWZwTDRxcUVISFhOejJoVkNJdHI3?=
 =?utf-8?B?WjQvbG9LUlZ5ZVRxZ0V2cEJ6Z0hTdVdvcnQvbFM4ZFVybWNNWDJPZlAzcEJz?=
 =?utf-8?B?RURiT1RTQlZwOU1aTGNjd3JTYURNVlhzUGxIalZVOVU2SUFNc1dOak1pMkhD?=
 =?utf-8?B?Rkk0dFNVMVhRK1djam1GcStaaWxSSmY2VExVUnBqZk5zVmdtMytCM0JUSlRI?=
 =?utf-8?B?cndTczZiR0IvWEk2TkwrNGdPU08wWDZJU2J1YWlxTDF4NkxDWEo1QlJNS3BF?=
 =?utf-8?B?enAvQ3NTOWlXT3RDb2g0dVVCeUdyMXhQNXc5cjFoR2VLUStyYkpXTnBRZnpE?=
 =?utf-8?B?dnQ1SDc2bHBKZjRoS3A1K3JKMnNCemZZSklBQ0V2eXBiWXJqd2RFR2R0QnUy?=
 =?utf-8?B?VXB3TjFtdkhlZnNPVlpndHovS3hzVkdzVk0zSWdMSkxkOUtEWC9nNzR6clI2?=
 =?utf-8?Q?Svect/g+L4xjY/Ds8BLDpQnCI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99caf0d9-4eae-4701-46ec-08da7f99c730
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 15:12:47.8024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gbrxW7u9YV08aadqrL/4aJsJCasDnmzLzB78Rh1oKR5AhMoeyqz20md7AzL9xBVDyf4vtwanzVON2n2tEMwiiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/8/16 20:29, Jason Gunthorpe wrote:
> On Tue, Aug 16, 2022 at 09:21:05AM +0800, Yi Liu wrote:
>> Hi Jason,
>>
>> On 2022/8/16 00:50, Jason Gunthorpe wrote:
>>> This counts the number of devices attached to a vfio_group, ie the number
>>> of items in the group->device_list.
>>
>> yes. This dev_counter is added to ensure only singleton vfio group supports
>> pin page. Although I don't think it is a good approach as it only counts the
>> registered devices.
> 
> Ah, I missed explaining this, lets try again:
> 
> vfio: Remove vfio_group dev_counter
> 
> This counts the number of devices attached to a vfio_group, ie the number
> of items in the group->device_list.
> 
> It has two purposes
>   - To ensure the vfio_device is opened

hmmm, surely vfio_pin_pages() needs to ensure vfio_device is opened.
But it's not the purpose of adding dev_counter. So I guess this line
can be removed. :)

>   - To assert the group is singleton because the dirty tracking code in the
>     type1 iommu has limitations
> 
> However, vfio_pin_pages() already calls vfio_assert_device_open() so the
> first is taken care of, and all callers of vfio_pin_pages() use now use
> vfio_register_emulated_iommu_dev() which guarentees single groups by
> constrution.
> 
> So delete dev_counter and leave a note that vfio_pin_pages() can only be
> used with vfio_register_emulated_iommu_dev().

oh, yes. The fake group is allocated in vfio_register_emulated_iommu_dev().
So the group is surely singleton. Maybe for simple just say
vfio_register_emulated_iommu_dev() guarantees the group is singleton, and
vfio_pin_pages() can only be used with vfio_register_emulated_iommu_dev().
So no need to use dev_counter in vfio_pin_pages(). Such commit message may
be more accurate and no unnecessary distraction. :-) btw. The change looks
good to me.

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

-- 
Regards,
Yi Liu
