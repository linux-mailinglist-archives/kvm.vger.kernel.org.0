Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F5E6F1218
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 09:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345415AbjD1HDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 03:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjD1HDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 03:03:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517F6E42;
        Fri, 28 Apr 2023 00:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682665379; x=1714201379;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hlp0okybqha5NT+4JaSsQvz43gkMVq6nMwMqX30nQyA=;
  b=jnTf0rZR155k63kQZL+qQDwxIdBgRctwqV0MBF5e/S76kggujsPWBzM+
   hXgPnoxMtN6Qfav6tH9QT75KI1/lY0E2km9bkcXJFjSfff4ulW9vE0Jj2
   5njTr+/gphbVMlEYl858cRnYhDV5TT3ziVMX5q79pOdwsg0fKjUgiSokP
   uz5ikmVAx039NH7JRHAL0g1NdBuVM687w1IlFU7Ly1rAj9BwgMdhgOPw0
   ukDuS1qTu5o9mm3BHJu4Q6TJliImY0vrSmHNs74mqgwDJiFTLzXu9n/R+
   2Eq34zIT5wWdCgJz+qt4l1sSGqR6ZmHd3yHfuiuuh5UPwNDTaRdQp7eJl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="410755993"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="410755993"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 00:02:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="764171584"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="764171584"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 28 Apr 2023 00:02:58 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 00:02:57 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 00:02:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 00:02:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 00:02:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vxc6LY2NR0adRdGVMuO5Q2juWoSz9eknhK5lOZWR0j+p9zDugMOVzRRdtzf1Ue2OIFm9fLq/BIrrpw5AYEBPxDUFoWgk8hqwhF2RXJYsmZRP9lMr/Lo0WF4kmapspSGqqnuB2njkyX8QF+2L46rtCwHZLcIJiVuk6mUpr4vePwsHaIfycJv0ItI7ygi4JGMSpcIUZG3h8m7y8YmnrFmKMpgmyvLNKk/wQX25DhXOg5t/Bi01MXQLgssgij9dMvZmhqeLyM9Cue7aLLBMDhg6tbGXk5mIyLnVK36Rc87MPPF01LV8Wigkh/xYkuCDfD24QQ5X79zOhZqBemNkZyrAug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPgnXXKHQlzb1Qg6h2DcgCg6qG+yfKg75nR80cHjP/E=;
 b=VY1pYKiITxsHLc5T2l+me5KVL1pJh4rbynv3Kv0BqBNm7pSz+2gTN+P+dai5LrRikLK7dpsaX0o8nWsy1CZKrG4roUquVNNB2v2ZgH13Rz60CIayHejLKyRAPZ3R7BP26FCynPAgG4aZrKNPCpOLyEj3qTFzCj/uwTz3FxPMpapeA9RoibsjtImB/emCCfeA7FXTRkqE71tNYeHo1Q5Ibzqoqxf2O9vsz+ykpnWIbPOjlfFJ+vDCSqke+jms60ArpuLfFBZ0ojKhRXzRtFynu0KeepSXQKvo2DYcBsxLtdlMGBRGd6qmADmtHAleZL2mdVtd4BS8A2BEWdziR7tqaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7785.namprd11.prod.outlook.com (2603:10b6:8:f1::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.21; Fri, 28 Apr 2023 07:02:55 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6340.021; Fri, 28 Apr 2023
 07:02:55 +0000
Message-ID: <f1772499-b9da-b2ee-d778-76165a9b2861@intel.com>
Date:   Fri, 28 Apr 2023 15:04:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
 <a6b77884-1678-b17c-f6a4-28d56e6c366b@intel.com>
 <BN9PR11MB5276A619F48F99D70073682B8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276A619F48F99D70073682B8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0104.apcprd02.prod.outlook.com
 (2603:1096:4:92::20) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7785:EE_
X-MS-Office365-Filtering-Correlation-Id: a2fb5144-728c-4f5e-a54f-08db47b696d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AcPQUcLasXRaDjWE93YD7IlAEJ5qLRxTbqt+KaejSmzla7deV0HazPEZ3EOPbOXa7vIh6dMrmLE+J6BmwPMszR+DvoMWqvVUImtYVhKx2uRrqIaj3h7y4H3serJ4DeHk+H1S9uDuOakvwBGal1U4O+kbhNav/yOyn4ufyIlq99hz/UIznKQB8kRzZ+/WdGuBGu9278CJG630vGrV9+4GMeEoQfAckYUs0fFL+ITmA/jA5LUKpKeIK46g+wlY6YRVS0whXO6Ym+Wdhhk8b5JV7bot9ByBTIPn802iIlJZlarXLKihUe1Zuwj8297w72iBED2u8/llJkYb/6zCKM2nknNqikZgoCSEQDHNX1zyIkyFJ65org2bS6N6BQlagxgnBrptKejswPt/QqIw03ip8D2ENwgd//LplW2/YS8kfAdwZjFJhvaRBYYzyYExi/4+VltXoUGmxos3jc2vn/4aFFicVXOLlN6vKAtd9V21trnKtD+EyTlmBMb+qWUG9cq5mbUk7BzR86JofJnk7Zzx11MjpJP2uDEwzxl+Z1rPucCPVBtqSepZlOOw3XAOaj7mz74GsD1dgkeC6xK4sCSNxTIEPAy8+mIWeCYBSBSvxWc3nUYinXr/Rp4tpUqHD5lIztMUMxtvtpFcuuwPbkzdpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199021)(31686004)(66899021)(36756003)(5660300002)(38100700002)(7416002)(2906002)(8936002)(8676002)(31696002)(316002)(86362001)(66946007)(66556008)(66476007)(41300700001)(82960400001)(4326008)(186003)(6512007)(6506007)(54906003)(26005)(53546011)(478600001)(110136005)(2616005)(6486002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azB1aCtBUU5pRmtrTWhHZTYwdFdER3hHUXBsSFFPUUVnVHNxWWtCUjNCb1do?=
 =?utf-8?B?S3dQT0ZLOFlLVk1qTkVQSXNOVkpVZU5ERWtFV2xsWWNDMGtza2w1UFN6S3M0?=
 =?utf-8?B?R3Fxei9CdFpxeG5tbGd1QWJJMHRYQU1OcjY5YWpOSU05dndySVR0c1hyb1JY?=
 =?utf-8?B?ZnV4eGNDd2J1VDVNaVNMeHB6RG16NE4zQUN4V1luYkk3anRlSnViNUlPdWxN?=
 =?utf-8?B?LzdNYWVJM055dC8wV0l2aWlvcnc2d05WUjhLZk42amxHZVdOSXB4U1ZLMmQy?=
 =?utf-8?B?SU5vc0dMNDZQeTlmTW5lOVpGajE1Yk1EdDJZL1hZSkduYzlXMjYzTFVHWGhv?=
 =?utf-8?B?TjBSaGh4TXMyR2p0TnB3RnV4VE5LVXdJMWtkYjVSQ1N1QzVrV2t1Rmp6UFBO?=
 =?utf-8?B?Z0xHVHRiS0hERTAvR2laaW5JemFlODFzak5rSGdVamtzZ3J2YUxZQ3IzQUNL?=
 =?utf-8?B?Ym1BYjJxM05pMC9RcnNTaGdhWTNHUnZmZjlyeGZwcllLbWdMWTJWSTZWUHRl?=
 =?utf-8?B?cmc3QXZvMVBSaCtaZHZyQ2pKU01ZTlNZRGdKNnNXWElBL3NTZVRta3VhdTMy?=
 =?utf-8?B?ajl3UTE1QmJpMEpLVGZkN3FZMXlKSDVtWFpkcndzbVhCT09xM2ZjVFptL0xQ?=
 =?utf-8?B?YWI2ZUFoQmh3dTliVjNXdEw1MzRvangva0R1b0xIWVhrb0RrZGlyOUhjWmpm?=
 =?utf-8?B?cXZRc2ZyNzBWRm9XbkpmYmRtcFoxL3VqeTQ3b3R0enp3VUkvaVJCT0dESTJS?=
 =?utf-8?B?N1AvV2Y3TysrM2dnb3BldVdiaEtvS0lyemY2L2JWdGFwTGJNL29LNTRIWktp?=
 =?utf-8?B?dlZWeWNOZGd1dktESXQwVGpXMWpxbVBYeUJ3cFh1MlBxMTRvSmVnTUR1QUNZ?=
 =?utf-8?B?bVFwcThrUFNnYlFWRm9uRVF0WXV2b0JCc3FIczQvMFRYNHBBblZaSjJGUkUx?=
 =?utf-8?B?MThubUFtYlhlbVI0WHhiZGlRbHJJM2ZPeVJvUzlRakhHTWt4dmdKSnlpb1NW?=
 =?utf-8?B?aVpsRHcxUE00eVZpeGVnZjdzZmJrTWJ0SmlGQ3V2YVRCanpMNUpnWG1OcllI?=
 =?utf-8?B?YnArdk9JWXRFMy96UnE1VXhYNWhCTzlNN0p5a0Uwc2RJeSs1V2ZuOXpDd28y?=
 =?utf-8?B?ZlBoeHFBcDlpZ2RIYkNrbkU3UCttZmF0REJRRTFsMVBpalRPN0NoVWlsQm5u?=
 =?utf-8?B?azRsUTNXMGo0WUlmMDJyT1l3SmNYSkJtK2lKQXVJUEJhUzBCdmZGeHBTbFNQ?=
 =?utf-8?B?amY0L0llRUw4WmdxUi9Jd0FzVFFiK1FTbExsNjh2b05taHhqbWJBUzhCcEVy?=
 =?utf-8?B?SzZJL2ZuTS9aRVN3aTRyNnRjQ1l1YU5jOXowZDgydHdIeHd5Q29GVHg0RG1j?=
 =?utf-8?B?cC9ZSENvN1ZMeDlhQndpNDJYS3hsR0FZcDNPUnhHYjI3QmdHWEJObEtFZzUv?=
 =?utf-8?B?eFFvQWJ6bUhkUEJiU2pJUlVEby9MYXBVSlBWSk5ycXlmbGthcnpmZGJGRjBT?=
 =?utf-8?B?Q3ZIWjZ6ektObmkvU05yMjFacFhLUFRuMUJBVjhVdlZodExBVDRqS3pURFB1?=
 =?utf-8?B?aG42dk9wMUw1TkpnT0dKRCtzSUdzUW9iOVArendsN0tXdWhZOFdUWm1pN0xP?=
 =?utf-8?B?dmJnNHVWMS9XZFFBSnFrYy9WSGpwZCtSOWlzbVc5cDlTTjQrOENBZDJzd1VV?=
 =?utf-8?B?bzZRZVFTa0d6SHNjUlZ5WTZwODJHbW1jd0NzakJjNU52ZXI3TGhWUkZCU2R2?=
 =?utf-8?B?MGtwSG5BZ2toVVNObzRVYTVpU0VJR2RzVVY4alFCbUlLdkhRMG9aajJjL3Jh?=
 =?utf-8?B?b1hYQW91NUgwTGlYZWN6VzI0VVBQTHZ2a3p6TXV2ZjBuMHgxM0lLaGhTMU5h?=
 =?utf-8?B?WkRwdmRWSGRUTmh0UzZKakhHWW1RdUQ4ZFRQMEI5emR3SnRYQVNXa0VnWWJC?=
 =?utf-8?B?YUhnaDVqZUhsTW1ZWThNVkh6cE9pS05SSGlReEJWeDI0a0tSQUpDanM4a3JU?=
 =?utf-8?B?cytBVzNvdTltaHREWFBPdENkc0FNRU1FVEJxcmFwVDBzMmxmeXVqWkl5dk9C?=
 =?utf-8?B?UE5pUjE0dmxha21LTGRKSUgzcG1Da0w1SGJjeDlsYmlmQXQ3N3VaUFBsczZE?=
 =?utf-8?Q?1AMa/kSjMtjjewKLN87O4+sj9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2fb5144-728c-4f5e-a54f-08db47b696d4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 07:02:54.9158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6EtGwT9aBXAk/WEXjZbMHHZfCIhbcfOXgndwKdF4qQxGIYNqt/D2Yl/9yBmnG6LavsSZOahjqaTqBbgmEU/lFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7785
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/4/28 15:00, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Friday, April 28, 2023 2:21 PM
>>
>> On 2023/4/28 02:32, Alex Williamson wrote:
>>> On Thu, 27 Apr 2023 06:59:17 +0000
>>> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>>>
>>>>> From: Tian, Kevin <kevin.tian@intel.com>
>>>>> Sent: Thursday, April 27, 2023 2:39 PM
>>>>>
>>>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>>>> Sent: Wednesday, April 26, 2023 10:54 PM
>>>>>> @@ -121,7 +128,8 @@ static void vfio_emulated_unmap(void *data,
>>>>>> unsigned long iova,
>>>>>>    {
>>>>>>    	struct vfio_device *vdev = data;
>>>>>>
>>>>>> -	if (vdev->ops->dma_unmap)
>>>>>> +	/* noiommu devices cannot do map/unmap */
>>>>>> +	if (vdev->noiommu && vdev->ops->dma_unmap)
>>>>>>    		vdev->ops->dma_unmap(vdev, iova, length);
>>>>>
>>>>> Is it necessary? All mdev devices implementing @dma_unmap won't
>>>>> set noiommu flag.
>>>>
>>>> Hmmm. Yes, and all the devices set noiommu is not implementing
>> @dma_unmap
>>>> as far as I see. Maybe this noiommu check can be removed.
>>>
>>> Not to mention that the polarity of the noiommu test is backwards here!
>>> This also seems to be the only performance path where noiommu is tested
>>> and therefore I believe the only actual justification of the previous
>>> patch.
>>
>> but this patch needs to use vfio_iommufd_emulated_bind() and
>> vfio_iommufd_emulated_unbind() for the noiommu devices when binding
>> to iommufd. So needs to check noiommu in the vfio_iommufd_bind()
>> and vfio_iommu_unbind() as well.
>>
> 
> You can continue to use vfio_device_is_noiommu() in this patch. It's not
> big deal to drop it from this series and then add back in cdev series.

yes.:-) patch 01 of this series was added more per the cdev series reviews.

-- 
Regards,
Yi Liu
