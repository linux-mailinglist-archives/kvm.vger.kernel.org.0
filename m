Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96AB529CF1
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 10:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243014AbiEQIwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 04:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240133AbiEQIwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 04:52:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0099436152
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 01:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652777558; x=1684313558;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f4cop49w/428WDB79NrvD49ul5k5hmhA4HE272/sp5c=;
  b=ETFSNy+OE3ruZ6qDj6jYLSNbAX9iGjRVJc7L6s86zZGBv2TYlStTVkdk
   RTmxl7+wNDiD8ca29c0NPxsMS/wH3w8967za4AVay88T/epURRArNd5/C
   UOA1Dg/OiYXSwgdt37HN1iUPy6XmW8xZTjXMYlaE7b11CKjOZNn2Afc3C
   E6JzJ11obsuo3oi+dOVgAbBdCd4I6+7UczacH/HiP07x2S4RZEhiolheo
   EsEeZh4RyySwhq7BduE8hRrLfEvo3qWg2hvvbPLmk9zZzeJlcLfoJmdBq
   S4nRT5TdzyC1PMrQJtsMtt2BLKydTFDIzcVsYwW2vcmTGrpyKn1oYju6a
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="296391333"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="296391333"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 01:52:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="605266105"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 17 May 2022 01:52:37 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 17 May 2022 01:52:36 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 17 May 2022 01:52:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 17 May 2022 01:52:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 17 May 2022 01:52:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RpzLV690Rc6xTYE32eCbfTfqhg+gkf/3LpuDKmRgL337HBhYz7NtPcvRcyFnWW0wM4HZgE7dqMdZ5EX9EGStwO7+kYxFrkNgqTw2KVTMPHyAveUHg4q8b0WTmOu4vbvk8DjSrdnyGvAmAcEXA7WQxZqcqhmq4DDHXgJHdJ4s/UUV1RgVs3KUrTE0J498JZBC1Sl1mUQ50f1tuTHSeq0esaj/ASZ+V3TzIeIRSDO3PFz8JSdLn4XUccN0NJ7PFaTSl1iH2tCyHuDT739aIUiWUpmIuGIff2Lo42cGoapp+g5oqLIDA1Ku7qvblGckkck3zHFEcrlEDGVNVvinAG+s3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HzT1XZpe00QtpoxxpMbmUsJTxobg6EXD3mPzwiy+3MU=;
 b=e+POGOBJwYA90/kknrLuojTfRtkYwAw4qp4CcbMwaTbg+CZn64Bp1YFIJIMbWJut+/7LoNJLrvX8ZogCieUFFgl98e/pUXW4DkfjZO/iSfnrONsDh4M19Hw1tHNRoPHe55oRRZH/2kOqlWJYD+QUAPeFY7P2HYRWd28D5Da6zzgSiQtSwUOi2FODlpB2+PaCO1yNIqTZeuuCx7XUqP2QVBjV6w8Ar3lNbwYnvCMB7b+q50udruRcgeJc0RK425B8vCJzlIieYUOM/kacPqlABduKp4JMkr6b1YR6ipK9/rXgnuAQe9Td8gw3z3HsMEwFh2+iqsbPXenaxhJfZY7g/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 08:52:35 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f%5]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 08:52:34 +0000
Message-ID: <2e7d40ae-9449-36a2-2e3b-a5eb62e11aa6@intel.com>
Date:   Tue, 17 May 2022 16:52:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Content-Language: en-US
To:     "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
CC:     <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "chao.p.peng@intel.com" <chao.p.peng@intel.com>,
        "yi.y.sun@intel.com" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <4f920d463ebf414caa96419b625632d5@huawei.com>
 <be8aa86a-25d1-d034-5e3b-6406aa7ff897@redhat.com>
 <4ac4956cfe344326a805966535c1dc43@huawei.com>
 <20220426103507.5693a0ca.alex.williamson@redhat.com>
 <66f4af24-b76e-9f9a-a86d-565c0453053d@linaro.org>
 <0d9bd05e-d82b-e390-5763-52995bfb0b16@intel.com>
 <720d56c8-da84-5e4d-f1f8-0e1878473b93@redhat.com>
 <29475423-33ad-bdd2-2d6a-dcd484d257a7@linaro.org>
 <20220510124554.GY49344@nvidia.com>
 <637b3992-45d9-f472-b160-208849d3d27a@intel.com>
 <tencent_5823CCB7CFD4C49A90D3CC1A183AB406EB09@qq.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <tencent_5823CCB7CFD4C49A90D3CC1A183AB406EB09@qq.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR0401CA0007.apcprd04.prod.outlook.com
 (2603:1096:202:2::17) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ad0e311-5bc9-47db-c85a-08da37e295be
X-MS-TrafficTypeDiagnostic: DM6PR11MB4545:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4545113F315DDCEB22ACE017C3CE9@DM6PR11MB4545.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TBw4EMvaVnR8WaVUbFvorq5A7Disd10zwQ8ZD9HqIPM+mYToddsBtvg8rIXrD/HTmGu/1ZA7KXqa+JavSTSHZ0Q9brHhywMm/VxzFh9dGMvcv8S6cuTtjQkUWCtpM7e5YQ+yqnS/Ysojj4KrbS++a9g4SUq7pCl/5omwqp7e5WYK6zLqgC56hRdIclWJMbb7LZ+n0iaqk2mpl5XyORx0kDC7FhLL23chEBa5vzBVbaUVNs3q2wxDShKgQsvJTl2WKzJNE8Z+t7JBbVzzZuwx16+G/QdNTZGMOiTYNs7+CPx1dUEkaxu9gQiMuijJxpfo4EdMy4GSQuDTJl3k10rOAHqjYwlwi4iN3WKZgXA5rUeTAJMH4hiXGT09fslA0fs+jm5Il849xa3bCwW1F0PtmYAfkFDfXrVsqb8AEOOgmbxhnGSYxQnu0XzFMk1JNC3zcAcmB99pyQbs08NwEr0WNvkPmnebae7Mo+c9QiuudM6/kBGnaxOk0CrJG6YpDV5Z930r22yXcQyr0tYDaLNlQ0ZOkbm0/h+jUcvX6BH1FtARLeuc9cL25Ji4p3oN4699+vXxYYAHqQPUCuIjlnJAigpW0ZVpAuHklpS2upfjICsqT4PEFkISIkp4OZpMAsfYX3VP/bOCS34s0K3XUeVxJOZIYpSd0WILceGVLgz4RuuwHq+e/6PImxsAvF6qJiur4vdhk7IXxgP+IPyS8HDE0oCM1ui744Lys5MkbNvW2N9268xk0cqT7EXC5/gs/sX7kdlirDISu6ikrsY6OKdb4W+IfmeCDLTIQapcDjVI7ODlHP8DZ9KfZz47v9qDtMZHifLVwzZ07KEftfl7AgzVgepeB1bYmEFqDKEI2CcGMAQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(31686004)(6506007)(186003)(53546011)(82960400001)(508600001)(54906003)(110136005)(966005)(6486002)(26005)(6512007)(2906002)(38100700002)(31696002)(316002)(66946007)(66476007)(8676002)(4326008)(66556008)(6666004)(2616005)(8936002)(5660300002)(7416002)(83380400001)(86362001)(48020200002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UExydmVkbFp1aVFsa2VRWm9Xa1VoMTZqQm1PaGFycjExSGh5clQyZ2ZHZEhZ?=
 =?utf-8?B?VEJHcHFQUkpqdnBQSktUQUN4bEVqMU9MTmUrbGVqV25VeCtwczBvTEUyU0tX?=
 =?utf-8?B?V0p2emxmb1RmZWJCZVdJT2JzQkN1YkRXZnpSTG5xd1FxZVFqd3ZMNW9RaWJZ?=
 =?utf-8?B?RGtvc2VDVkt3VEhiSTJkN1M0TVRtQndIZE0zb3gvVVhsbEV3ZjA5K0dqa0VF?=
 =?utf-8?B?VzdwcTJDRnFTVURkNHczcnk3aE5uZGVBOFdJRHZka21qR2EwNXJJK2pCeWpn?=
 =?utf-8?B?VlZERmgvUDRKdlZicStBWWNWZVpXd2dkeUdUR2szbUxIM29YTFdqRllkYjk2?=
 =?utf-8?B?b1dWMFMxU1h5N0xHQ3dPVHBZVktLUFhtdnIxLzhPSHFhcFFvNFREbmthOGsr?=
 =?utf-8?B?ZWpOTEE5TDdFbnN2NVlqMkJOSGNDZVgyTU9XZS9ScjBhbVN1aVlKYU9EV3Bu?=
 =?utf-8?B?eG93Y3RDanNtd0NSYTMyWk11NVJzcmJFRXAyUlR3TmVHWEJtY3hZTFNCMUhT?=
 =?utf-8?B?RDhNR3BPVzhMMnJQL0Rrb3F3YVlKK1dWVnZMU2xNV0JndDFtM0FvY0RlR2lv?=
 =?utf-8?B?eU5BRS9qQXZ0TjNQblZ3bmdKMXZOd0pNVXQvcUVOakJXZGFTdDM2ZlkyUmhU?=
 =?utf-8?B?RDUvSWpUQUNDeXVZM3lrdWQya3dSa0FwUWl6RU1WRkNFcENQV2cxWHFGS2lw?=
 =?utf-8?B?ZWh4RWlJMCtxWlk0N2dsdnYrUGg4TmlhZ0NzR3dvcHRTM05ydHpFT1RDUkRo?=
 =?utf-8?B?SWorU0liK2Y5Wi95dEVHSEdHVzVaV3pNMUw5UkVYOXNJWktzRGlWcGtkR0J6?=
 =?utf-8?B?SER1TnpCRzhjVStnQVhkZFVXWHlCR242UnNqckU1SThUMFR5ai94UGFBMFYw?=
 =?utf-8?B?S2xiWVB6VnVlQVdxUWo3bURqL21Mb2pSRjcrYitHWlZBa0h0RHJsanN6c1FL?=
 =?utf-8?B?elRzYklqcUFjTGtqNWlmaTIwbXhQSHNYNkRjckZKeUIxSktNVGNSKzU2VlNK?=
 =?utf-8?B?Vm1CNjhnanBIWmJRN1FLNHM2QjZleitwOWZIV21XUEUvVG5tUWhQaUNvU0xK?=
 =?utf-8?B?S0R4aDlXUmUrYURHZ0h1V3VDUU9LWDVlWmtPL0JnZEZ0SFlhdk4yQ1ByalA0?=
 =?utf-8?B?ZHZ0UTVYcjBmK3lrRzFudlFKTURBQlpsNGE0aW4xN08yQ1Bka3NPakNpaUFX?=
 =?utf-8?B?TEhjamFOM0hZM3ZPT1pRRFpZMmg1VTJ5ODdGakR3cTNKYzhxaU1hV2Y5MnB0?=
 =?utf-8?B?aENocmdIU2NNUmdwZkc2aVlNYWtTeFJuYzVqNFBwcWFrRGlpeWRwRWpwQ0Rz?=
 =?utf-8?B?V3JuWk5hSzhuVTZpNi81dHQ2U3VORWt4MHBkQUswV0FwMzJsclJ5Z2RJQS90?=
 =?utf-8?B?TWdZZnRVaHhiV3IveENwaWc4M1hFTFlVSUJJSG1lcU13Y1Q5Y0Q0M29jb3pH?=
 =?utf-8?B?UnVnek9JVU5ndUN1VDJ2ZmxncU1lN1U3N0tvUlNWelFUTDBIdll4YXE0SDli?=
 =?utf-8?B?amVic2ZMbk9vUlNqM1ByWVg2NVpINWhiT2lUYkMzV1drcHNFVmVxSXc1L2lI?=
 =?utf-8?B?d08rbk1TL3VMRmh2MGR2Z2EvSUhiYzE5VkFHWkJ3MmpHOFVEWHBSMC8zQ0JB?=
 =?utf-8?B?ZGxISWYyTFRSeHhZTk9Ya0dXalUyNnNwRVlvdWNHUXQ4NklZQlh6ZjAxSGZ2?=
 =?utf-8?B?VkRybDY3TjdLVnlWTU41VlZrS2JyTUljcVY4cDJCN0RPb05DZzVkYVF0TTRr?=
 =?utf-8?B?YnJES3d2TTVWdCtaK1RiS0hDc1ArSktqUWluVllCQjZ0TTcyZ0tmaGtNc2NF?=
 =?utf-8?B?SG10N3ZNdjRjNjBoaDBTcDdIbCtONXJKMklTZlFZWUM4dFFYbDB3dHlxMFYw?=
 =?utf-8?B?NFhBdkVXdHRyUFhjMnJIejFVTFJWY0JxWUtuRURNcW9yUkhjeG5vbVgvbEhw?=
 =?utf-8?B?RlVlN25XcmplSlRkb2N5MTJES0UwWjdQS0htOVdmVHBOcHkzdVQwSWZ3OTdW?=
 =?utf-8?B?NGQrYjA2b29PTUdyYUNQVTZYSmNHQUNkQy9oRFNSVnU1eGtwZnpQRWtmYkZD?=
 =?utf-8?B?Z3Z1TFBzQTZkckZZYyt1NHNOc2NXamN1RTRNV0s5ODZ2clducUdWTjNGRFR2?=
 =?utf-8?B?MDhWSHlJK1cxQjBpVldTcEZOOWd3VC9nQlZLdmFFYUlaWG9kMVBua2RBNEsr?=
 =?utf-8?B?VHA0TStOelFHVUZKZjBDdWMyNVNYS3BvVWRjKzBtdjhYYStSS1NueHFzelNi?=
 =?utf-8?B?TXlDSEw0YW9zUUpWL0xwdUU5T0ZYVEg4Z1poMWVUeUxjaUZKc2NVWlU2U0Fn?=
 =?utf-8?B?R3MxSlNzVkw3bDdDMnNkTGc4ZXRtNWxUT3MwM2w4M1VFdDhKaThtRDFyWlVa?=
 =?utf-8?Q?vk0zXWcX8+45DHqs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ad0e311-5bc9-47db-c85a-08da37e295be
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 08:52:34.5790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U4QX4rn/tIJmCKHatEVYsba+dqZWwiDES5e26yVJG/5hK+bsNkZTqrpR09DvBmOW9/ZPlPUYoRbwwQsHZYMOPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4545
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhangfei,

On 2022/5/11 22:17, zhangfei.gao@foxmail.com wrote:
> 
> 
> On 2022/5/10 下午10:08, Yi Liu wrote:
>> On 2022/5/10 20:45, Jason Gunthorpe wrote:
>>> On Tue, May 10, 2022 at 08:35:00PM +0800, Zhangfei Gao wrote:
>>>> Thanks Yi and Eric,
>>>> Then will wait for the updated iommufd kernel for the PCI MMIO region.
>>>>
>>>> Another question,
>>>> How to get the iommu_domain in the ioctl.
>>>
>>> The ID of the iommu_domain (called the hwpt) it should be returned by
>>> the vfio attach ioctl.
>>
>> yes, hwpt_id is returned by the vfio attach ioctl and recorded in
>> qemu. You can query page table related capabilities with this id.
>>
>> https://lore.kernel.org/kvm/20220414104710.28534-16-yi.l.liu@intel.com/
>>
> Thanks Yi,
> 
> Do we use iommufd_hw_pagetable_from_id in kernel?
> 
> The qemu send hwpt_id via ioctl.
> Currently VFIOIOMMUFDContainer has hwpt_list,
> Which member is good to save hwpt_id, IOMMUTLBEntry?

currently, we don't make use of hwpt yet in the version we have
in the qemu branch. I have a change to make use of it. Also, it
would be used in future for nested translation setup and also
dirty page bit support query for a given domain.

> 
> In kernel ioctl: iommufd_vfio_ioctl
> @dev: Device to get an iommu_domain for
> iommufd_hw_pagetable_from_id(struct iommufd_ctx *ictx, u32 pt_id, struct 
> device *dev)
> But iommufd_vfio_ioctl seems no para dev?

there is. you can look at the vfio_group_set_iommufd(), it loops the
device_list provided by vfio. And the device info is passed to iommufd.

> Thanks
> 
> 
> 
> 

-- 
Regards,
Yi Liu
