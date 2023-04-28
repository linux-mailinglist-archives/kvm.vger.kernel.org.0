Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD2B6F1C61
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 18:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345870AbjD1QN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 12:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344161AbjD1QNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 12:13:54 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5434C0E;
        Fri, 28 Apr 2023 09:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682698433; x=1714234433;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HfhW/XBbTAPu9A2YCCrfe6ag35b76SyBXCYe3d8/7b4=;
  b=NiTksFs0EHMXFYrJz8OWtKW0Bk3eQ0Zg9kGnp+HZH1VFYu3Vjj91oPhS
   7/vMttK1Nle0YFeGJDpXtzfN9rOovBJgOvU5eYlo6rPOsApmfVS+uW0OV
   x6S3fDpjshoEVC6vLQujYX6xFp7rsnbf5N9jDWWYEiMF7rAF7H0JwSakf
   +RSIWcbIy/hRiQuR6F8EtQCI3yw6D2m0Silk8z2io2M3rEq6UsH8ij/4k
   Gph4U3uP6F2d78xvvvySjY0hvYHRxavdtVkDOuwsVHbjdRrDKpoIrIX5P
   iYFJ9d567rXC6SVsuBpewRZ1LnWAY9ZoNdDeyJykqjF3ZS4hMYHRDgtiO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="336860077"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="336860077"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 09:12:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="784255041"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="784255041"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Apr 2023 09:12:14 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 09:12:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 09:12:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 09:12:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 09:12:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwWKE7urz5yuIcM5LCGrxoRCipXB7uQ2KCfSq/Z5DMzZDtXM2ijEpKzENZnWlcL2VBGUsFpwqHWZdi8KYEV2PCzp7gAwa+48JFdVC8yukCE6vk9poXoEF45HuEwmvyQTcOTQF4D99LIoCfAdpGSWSUNqXwy5fxd0qldcv0VFyrQg0S1LqZdlvlXML9UsWvtIyoI8+jvOzuBi/fElaQIKIEQ2bvstVV7Aa3kRaNujxVdNP/u71cZF6YCC4EuP87j8+JJCTIRl6IZlkySpExjPEGXxQD4MSRFu1a1KkUTGAn4vjTYxvgjjJ0J57bEpgjKkH6SYAps/mRBZTBsNCtE7pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rh0KRcO0TDpnGxR1G6nhYmgU+hB0FNHTjmjn2OjAuEg=;
 b=e2K9u/EEdK220xq6gxGfAvQplUs5lFB1JW324nayajpX3Qc+oVNx+mXBnsTSa7sMr6YMBau1086SRrLzz8xy1B66HptH8BK6bcb3TDA1svAsEqP9R78HUuQfl0jLCYoFxlEtI8qmChGNtjxpBAVn1Usq9tqnh/g30mSJ3OIRcQXDIc95n0zmWnLaXsB524EA+UYVc8+1oaE2i6d8x4AE+5VYgaexevD34bHEbX1WbLCqRDOe+ak8QRF6dYgV/3knUozbebNsuY72mwhtaxGFIE7/MoFTR/ZjsEKMWViEo+EhRD4evUcWYzYz89M4k+5Ne9hoRmR8RkJw2UCx7Wvvpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5927.namprd11.prod.outlook.com (2603:10b6:510:14e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.24; Fri, 28 Apr
 2023 16:12:12 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6340.021; Fri, 28 Apr 2023
 16:12:11 +0000
Message-ID: <c203f11f-4d9f-cf43-03ab-e41a858bdd92@intel.com>
Date:   Sat, 29 Apr 2023 00:13:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20230427123203.22307c4f.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0056.apcprd02.prod.outlook.com
 (2603:1096:4:54::20) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB5927:EE_
X-MS-Office365-Filtering-Correlation-Id: 438e7043-fd23-4f1c-212f-08db4803525f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S0lh8EwpAyaqmW4k1D9MEONZ+yBqKr+RrFJyGcLxnuWeF4yQSPAQIEtq4LQFjU0PnwOKNqo6PLQVYjAEtfl3Iv9OARHP4sAqf9Z0vtzODxldn3KUqfbOcou813LCOtcJiCqe/fRFo5HnXpfrGNO3CMNYylvGHOBvB7OTtKFPmz0Z+5gWIj+eDPKkCvOAkBfMlRRFu4hl5ADl7Co4iLT7tnJw2cFapghLISB0S7hG+U2+0GKvzxdUDoEjA/3l9oNykqDoihPsUWeTuJ8vB+uUAt5nSYuau7yDFaEY6aoI/1YX6Or6cQn5Pv//xZKOx/pEOr3kR0Mv/XkI/pj0aQn5hlNG9eUxNvP7zmZGYQ6Zr73EnnCIfnyk9BssLGsQnkKU81CipWAmKGHcM0z4JPgxFM+e0ZHj1Yfh9ioRYp7m10XQxyWeEsKWR1L5UCisvrkbi3VB260lWiaJsl8r20yKvC8n4q3Si3JZjRWyMWva3yWTslOJS7aS/UaLWKkEDpCxIvH05BVGaA5IclwZdZki8UhH4rmsuf2quXuZ7FCH5aFjoWNAcTgkcpWTCfSprJAhfyd22kts7xdvisOdL8N4kc2LSmhUzDCAQP506P9J/ird8UuXePYWXK+DR0KMpRiEbgY+5tBfi04Wb4GW2ssxAkLJ/obykGSKllcqQtAxfao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199021)(38100700002)(2906002)(41300700001)(7416002)(5660300002)(8676002)(8936002)(36756003)(86362001)(31696002)(53546011)(54906003)(26005)(6512007)(6506007)(186003)(966005)(6486002)(6666004)(478600001)(66946007)(66556008)(66476007)(316002)(83380400001)(82960400001)(6916009)(4326008)(31686004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUNnSTlVRUZQcitNZjFmU0VWM1B6a0NsdVdoeHpXQVUwVUl6VmtCRlZTVHhS?=
 =?utf-8?B?STAveVNlNFRHd3RNUmJCN0FTMEluc3FrL3RITlpYOVZmVGc3bnEwVE9WQVlZ?=
 =?utf-8?B?VWJzaUtrN3FtNUFjWHh6ZzMzbUM1ZzdZdzkrVmhwK1gvaHRBMUhUQjRPY2Nx?=
 =?utf-8?B?aUxGUWNLRmhFcWpZZ2hVaHdpcHlxbk9adUpqWkt5UGpDaHdYN0U0QmNHaU5T?=
 =?utf-8?B?eHJmWkthbzdxVzl3UGpmZExMV1MyK1hqQWFlaTh6NldnTk1lT0cwWnUwWlJP?=
 =?utf-8?B?bWEyNzBDdHVQeHd1dUNTNFBSRjVIMi9iS29sa1JXV2d6aUNvejB0TEVOVjJV?=
 =?utf-8?B?RXJmeFB2d1NWYmY0YWZCKzRsL1l1WnVWckJ1aFRneE5RUit4dUVvUnBxZ3M0?=
 =?utf-8?B?Qm5WZThQZWlVb3NvbGtoTitTUG5DcTh3SFBadEN3dmVOUEVhSndERFNoTHIr?=
 =?utf-8?B?TmduUEZSbzRCWnRySnhQS2d0cjdJMW15MmNaU3F2amNJTWFBbktJR250MCsx?=
 =?utf-8?B?U1pEYzZ4eWZhS1QxR1p1REFoZHRwMGVCdnRqKzJwM2NWdU9UWUZ3Tkc2U0ZG?=
 =?utf-8?B?WHBRclgxbE10bTh6Y1VRSU04L1NmMTJVVEppbnB6VmxTcHROblZxd0ZSTDNr?=
 =?utf-8?B?SmhIeHJTaUR1b2hMWTN6c3dzQ09XRk1IS1pZVHVvRTk2STF2STE4Y3VBN2Y1?=
 =?utf-8?B?dnNiNXd6WU93NVpSQ1h1UThSOVBqWXQvbEhxVjJJa3RmSkdhUHlIZDRjVEhq?=
 =?utf-8?B?ZTRWMUFaZ2RrMWhaQko0d1dEdUJ2UVVjb3B4bWMvc2pKazkrNE5zQ3UzM2Vj?=
 =?utf-8?B?V1VRZ3A3RlU5cTlrT3dpWm5YcnY5MGdleVpReW9MUGlmdkxoSUhvSnN6amZF?=
 =?utf-8?B?K2s1L053Y1BGMkgyQmZ3MnZKYXQvT1MvdmYvTHV0cCtzckdyUlIzUURlL1JB?=
 =?utf-8?B?MUduUWRYZThKcnFDT1pPdklkU3VJUDJJZ0JIemFJbjM3YVAxQ2xBN3F0dSs3?=
 =?utf-8?B?ZmpUYnZmZWhkd05ndTdpeGhVS0NlOWNnTEZzQ1diZEQ4N3FkUmI1T25ITVlz?=
 =?utf-8?B?dnlHMisvSkV3S0Rnb1VpcmtaRUJKYUZ3bXlSMzRTaHRaTmt5YXAyZk95VUpT?=
 =?utf-8?B?U3B4cHVSd0pvUk9JUitjUTBoWGl2aFNrS3hmd3pCc2NCb2o4RGRoMzR2akI3?=
 =?utf-8?B?MjQwVVZYOGJqS3U2bVdVTEFsY1c3bTZXQzZkazlqT1JTR1BWcDRzaWYrZXFi?=
 =?utf-8?B?N1BtU1VDb2VWWGs0bm93WU5uaW1pTlBuWE1ZRHBPNytrR0tTUUVJallUVnBL?=
 =?utf-8?B?YXN1ZEY1bE9GSkdIeDgwbWJmekh5aHI0NmR3SjBsWHhObFYzNEM4blIwRG9i?=
 =?utf-8?B?Ukd2emc5VWtGbGRpR3JaVkRTYW9Ta1o0YTRZdHBHRFZtdHA3QldqSkNHTzZH?=
 =?utf-8?B?MGViNzRHOStMV094L1VNS2RHRUhQNWpaY29uY24zTkdXTnRDR3pNWmRiYThY?=
 =?utf-8?B?bmFBZTNraGhwRzVGTlV2ZHA4SEJmcWNqbnNQaEppR0E3TnB2UktvelBGR3JI?=
 =?utf-8?B?bEs4dk1FY2Z2b01CNzNNM2llaVd5MUZ4YVpBaVc5eXlkNkZuenNhQjlXVFFi?=
 =?utf-8?B?dm5ya0RCRDZkSHpxdkw3ZWhsSHJkZytDRDFvU2lxQXhsc29rNG9Vcm9Lank0?=
 =?utf-8?B?YkJzNUtuNXdhNlNPTmtoYnRoYzd3a0tnbU1mY0NYNEJjdkdnMlBpcEkvbFVY?=
 =?utf-8?B?MVRwMlF0bGp5VkJSR3VrOWhCSmQwNnU2eENNbmVTeE9yWWVzZ2tZaGFhaURn?=
 =?utf-8?B?UkVIVTl0ZmM3LzdwWW50dlFlQi9pU1pLUVFLTm51R2ltMmpxellpWFNPSkdV?=
 =?utf-8?B?UHkra2pZZFUyV0RQeE1sZ3VhQ3EzdlAvbnI2TW5kWHNiOENnSjIvTkJUZitI?=
 =?utf-8?B?aUtGeU5qR0NoYW9GVkpMcm5iRERHL0NrSm9uejRONzdhS2NSMVhOaGF1S3R4?=
 =?utf-8?B?c3orUGVsRzBxTlI5ekIyYXJQS3pLTFEvVzVYek9CTWVsNGo3Y3JPTmw1bFF1?=
 =?utf-8?B?NHdWVnRsR20yaDZLSUxZc2c0TU1CYlNxVUhTeThCa0F5OSs2NmNNYTBEdThM?=
 =?utf-8?Q?PowhJL9Tm8ihqzqiipmUnaQMB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 438e7043-fd23-4f1c-212f-08db4803525f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 16:12:11.2818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zu3PTTRWl7Z9tuYvYJ15dPaMW19MQJeGviwAnhL420sjyoKe2mq50l7ijjtOz4JO1o1LwpbctFO+HllSdIqNbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5927
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/4/28 02:32, Alex Williamson wrote:
> On Thu, 27 Apr 2023 06:59:17 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
[...]
>>
>> I'm not quite sure about it so far. For mdev devices, the device driver
>> may use vfio_pin_pages/vfio_dma_rw () to pin page. Hence such drivers
>> need to listen to dma_unmap() event. But for noiommu users, does the
>> device driver also participate in the page pin? At least for vfio-pci driver,
>> it does not, or maybe it will in the future when enabling noiommu
>> userspace to pin pages. It looks to me such userspace should order
>> the DMA before calling ioctl to unpin page instead of letting device
>> driver listen to unmap.
> 
> Whoa, noiommu is inherently unsafe an only meant to expose the vfio
> device interface for userspace drivers that are going to do unsafe
> things regardless.  Enabling noiommu to work with mdev, pin pages, or
> anything else should not be on our agenda.  Userspaces relying on niommu
> get the minimum viable interface and must impose a minuscule
> incremental maintenance burden.  The only reason we're spending so much
> effort on it here is to make iommufd noiommu support equivalent to
> group/container noiommu support.  We should stop at that.  Thanks,

btw. I asked a question in [1] to check if we should allow attach/detach
on noiommu devices. Jason has replied it. If in future noiommu userspace
can pin page, then such userspace will need to attach/detach ioas. So I
made cdev series[2] to allow attach ioas on noiommu devices. Supporting
it from cdev day-1 may avoid probing if attach/detach is supported or
not for specific devices when adding pin page for noiommu userspace.

But now, I think such a support will not in plan, is it? If so, will it
be better to disallow attach/detach on noiommu devices in patch [2]?

[1] https://lore.kernel.org/kvm/ZEa+khH0tUFStRMW@nvidia.com/
[2] https://lore.kernel.org/kvm/20230426150321.454465-21-yi.l.liu@intel.com/

-- 
Regards,
Yi Liu
