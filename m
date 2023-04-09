Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C233B6DBFB9
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 13:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjDIL5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 07:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIL5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 07:57:30 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2110E3594;
        Sun,  9 Apr 2023 04:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681041449; x=1712577449;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R5E1aSQ1dY7qIJDa7lizZ/5+iXUl4Sj3qgEOjJkvYm4=;
  b=MdCxOMkgFmvtbDeceP1xzqvlY9VyD59ARHo69sRyQrI65pJBhDS+pnhf
   zIe+fTtMrnxEc+NvXlTMqOel7TV1XFbbcHgRZkp6yPT/L17vnXil1JDK1
   Z10oNj5K46yg8K0uEov76Z9R9YhEfQ+pxKeottL8d2mY/DqDU3J/0vjBK
   C5dlaz6+sXib/Zcx64/I35OJaqoNdbWdJuwvsRHaXLQl4yXc/SCiBOnFp
   MrGOPHi07XEJVFxPufOCkqpICD9CDwDpdCBztyjNuNP3qxBJBTzJoE5K5
   SF7knefSZjx7rqhrDQIV0thmWDLxhmdAgJI/hF7c3RSzcmmJJ7EJqwrtW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10674"; a="406041604"
X-IronPort-AV: E=Sophos;i="5.98,331,1673942400"; 
   d="scan'208";a="406041604"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2023 04:57:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10674"; a="638189570"
X-IronPort-AV: E=Sophos;i="5.98,331,1673942400"; 
   d="scan'208";a="638189570"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 09 Apr 2023 04:57:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 9 Apr 2023 04:57:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 9 Apr 2023 04:57:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 9 Apr 2023 04:57:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 9 Apr 2023 04:57:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQJih8+MXbg/tv1PiVOowJrNyLQALQA4JtSs69LIfypzO7DgE/09sw0HtOghDvaLTBRdDGDd2RCsGBU/XTsr8CgPZ8lQ6zTq1513DzycpRI6ZiMqwzEmNy3NaBg5vOs7dnsG+cQPOfwHDPE67ObmFroKwPWFTEIB4VhHT8Tg78+sWlztmTK8qyQTz+9jRwQLIcVvcSrV0QYsQQsybHHzydExY1feb2wGGnoefdZ9wNy687hQjC47BD/xWFW6K+PfVFefW1gVTctM06/HO9Q3sZvMLoJPon473Y4V8uCItfnxYAlxdIfl5eL/XvtbDA2Hfimw9oQMn8BH6gX/8RN4mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WU3p9hbROSigYckpdR67KtgiJqv5jjsKXRKwjnCn840=;
 b=mXnGGqoKmH2KydwWgETVHZou5X1a0TgKvVLHofv22OlJicQkE49GxcIw1kgeNsAxeE7TBmMLCHyo5jPJOwvTJK1YJZ4T0SFxZJbK+/azBLZplR54NZv6hvO2oVGp59sUn+yWhmmzSa52nVdoGy9XehufYW8nAw7dTLGLSZ7+A5lVRuZ3CTlYSgeVo07tprS15rFHJ9NszGxT11BQmjn2xO18I4ykaYREDNCajL70h74EyfbZmamOaZV2wJvH+TUhACMb/33Mq/PeEwNqLlmWAeGX4HIIVgBaJc0xt0zT41qPwHg3GSBLUw3nYO/JGErjIyf3rYujYnNYIqkReJ0+3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5208.namprd11.prod.outlook.com (2603:10b6:510:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Sun, 9 Apr
 2023 11:57:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6277.036; Sun, 9 Apr 2023
 11:57:24 +0000
Message-ID: <81a3e148-89de-e399-fefa-0785dac75f85@intel.com>
Date:   Sun, 9 Apr 2023 19:58:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-13-yi.l.liu@intel.com>
 <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230403090151.4cb2158c.alex.williamson@redhat.com>
 <DS0PR11MB75291E6ED702ADD03AAE023BC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407060335.7babfeb8.alex.williamson@redhat.com>
 <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407075155.3ad4c804.alex.williamson@redhat.com>
 <DS0PR11MB7529C1CA38D7D1035869F358C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407091401.1c847419.alex.williamson@redhat.com>
 <DS0PR11MB7529A9D103F88381F84CF390C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407150721.395eabc4.alex.williamson@redhat.com>
 <SN7PR11MB75407463181A0D7A4F21D546C3979@SN7PR11MB7540.namprd11.prod.outlook.com>
 <20230408082018.04dcd1e3.alex.williamson@redhat.com>
Content-Language: en-US
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20230408082018.04dcd1e3.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::10)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB5208:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b01774-9177-4ff3-6d25-08db38f194d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62zPseepC9HnMypO6t+zMsLzMWwI2AVOMyhRA8qScv9dfXfDsPdysduCFm9nBdE7ZHUGefDawXMGUKPmACYgls+CW+KBwkRddO1No3EbGatxm3HIwu5gM0SznIVNbUKfvarvSrpK+rF/pTAGC4t0rOjxjgOpNePMhQ/KzqFO2b9ghXRNFMiFt1xcEpqoIim13cnr23WDHVqT/t5Il0IQXj5ee5LeHA3yGfQDEfGSHEhjg8lb2LhDe4bMG+vr0VbL2lno/l99ugLQfaKSScLCAVfDw3Es/mvsLmpfM29l6wYJKXRhujbJOB+F0QQBnb0Of2fzRBDeWGqHsd7DPmssz9RbZZKo/1bFNp78PbQQhgzaiCQn90OYiCCNf4ORHpMLw6eDKgEFQwKX+6/MO5xBmptFD6IO2Oxs0cCFJUlIHF7nu2JZV9/emlRZ6m6PwuRMW2KPPSsI7XWgq9rJYGPNMPQvmPuujNTqoRJ4FsgZQf5yUG4l0J9SEs8HjC3aYdoIJv+s8A6hR6nA7UrdnlZJuydsnY+xH9rHSuHKVpvtzzINvNnGyyzYnztnciECqTdPw0k1TrK+LZ9mtFwnGybKK+3lZqjFic3NnMkMujke8b8lw6+G7njf4jazL4TKeJhe2Bbb2vughaQnPT9jX5WUxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199021)(478600001)(54906003)(316002)(53546011)(6512007)(26005)(6506007)(186003)(6666004)(966005)(6486002)(2906002)(4326008)(66946007)(5660300002)(8676002)(6916009)(41300700001)(8936002)(7416002)(66476007)(66556008)(82960400001)(38100700002)(86362001)(31696002)(36756003)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnFrL09WWTNDR1RxM2VjOHpBVlJKNTBzRWtVUTFQSXBDVE5Ya3EzelhqMUpU?=
 =?utf-8?B?SFR5TVNyVjRPaXhuWFdYUytGNjNDeDl2SE9XQmpCbW9WNGNOL1JhWkZveEZD?=
 =?utf-8?B?NmpiQnhIVmh5VWJMbVFjNTZycks3V01lTGFJUnJHZWRUK09ZWUMxNHExbk4r?=
 =?utf-8?B?dkQ3SWtZQUtDeGNua0NOS0pUcmZVODFHMDV5cWVUbklTVVNaMnhrZFhhcHFk?=
 =?utf-8?B?b1hHTVZIdU00cXpBVC9aU0RYSnhzMC9FMURJZlhuNVR2U0hIdG5xNGxZanI3?=
 =?utf-8?B?TXdGbm5DaWMweU5PNDVaZXBXcmw4Y2VYREwrR2ViRGVFM0I5YWxSRFJVL0R3?=
 =?utf-8?B?QlpoVzlyaWgzS0RVWUFFVGFHdGo5djVSbGZUdjdjSjR4N3hDTFhZdnI0U1pB?=
 =?utf-8?B?YW1EbGVnbkcwQnJ6T1pTMHZObW9UK1planNSeG8vQ2xkbXFvRzlJeFFQd3kv?=
 =?utf-8?B?MHhHTks3U0NIYk9DSlZreEZ0K0hOOE5salRQSUw1RmJndU8vTXNSTUtvSUNM?=
 =?utf-8?B?dzNsZ3V3cDNBVDJxbTJqRGZIaUNMcmJtNklvbm1ybWJWRDNzcmRCVnh0NkFM?=
 =?utf-8?B?ZXR3aDZzRmpHMVZDdUhSZ0tFcEFDK0s1MzFFcTVVY0ZtYXZUWWhzcmIvTDNR?=
 =?utf-8?B?b1h2dXIwcnpsTjdJVGcxYTZ6TENRendLS2NVekg5bktNb1R5YnVyc0F2UW1W?=
 =?utf-8?B?Y28rZXNscVFDczRiakUva1JCcE5mVmtPbnVqNy9JS0d5alBqbE44b1VZUDU1?=
 =?utf-8?B?ekNpZy9sNzZBaFd4bmtQR20yRjZhandxMFRkQmFtcTNHbllPTWlCamYrMWxa?=
 =?utf-8?B?OTBYaGdicTZlMmVPTmhMd3ZtQjVMbjNDOEZYT0JEc1l2aktaODNjMldYYzNz?=
 =?utf-8?B?cWZ2eWZmbms4aGtNUDZKQnhtNWRTb3VxSytSVTBrdnJZUmpvZ1JwWXUvUUVz?=
 =?utf-8?B?RUVsbEQ1Rk1Va0xLTENoRGNhQjRlalRSK3YvaEQ2dHowNHJpeUZpZFhpRHBX?=
 =?utf-8?B?dkVMaHRtd2QyRjBLZDh4cHRJS3FwUFVrcytoOTVrL3BmQXFwbU1FM2o3YXJt?=
 =?utf-8?B?M3Z4Z0RqK2JRRG94eE8wRWw2c3hHZHlVRjU1MkNkblRUb2NDRnNxMDMxOFNW?=
 =?utf-8?B?Tlh5cENzR3VLVG5pR205YUVKanB1TnhBSDhJcVg2YWs0dVRoSzUzYWprU3Yr?=
 =?utf-8?B?QXUvS08xWncyZ2FBbHZvaUxxUmw0KzRoYmhOczlJUHZxelJ1cU1WbEx2ZVJP?=
 =?utf-8?B?WjBXV3g2Z3RKZ3NwVmJsTjBZUEp2OEo0b3NPQlNNQ2YwTlJraUp5Q0laTG5J?=
 =?utf-8?B?aHEwTWtMVGxxNU5tRkdnZjdPTVZpU2hBZDhGcE4xZ2RXVVFWMitXNU1mRFRV?=
 =?utf-8?B?OXh1bExVaGhzdStRM2ZsMVAxYTBWeTRhdDFuZmpiWThNQUZFeW1pQTkvOE5x?=
 =?utf-8?B?elJiejI0cldkOGhwKy9Wb2VyaEF5QnVwQVYzNkpYSGEvUG92cjVCVlhBb0NB?=
 =?utf-8?B?VkNhaENnNExsRTVCTG5tK1podUZvZXZMVk9JMlRpbGhGeHdIeE04RUdUZXVH?=
 =?utf-8?B?K2dCenJ2NUMvUDNDQmhQTFpnSlcvVHpDOWVKK2w4TXJoTXVmOEVSUm5qSWtT?=
 =?utf-8?B?bHlFR1kyRWx4NCt1V3ZZazJ0SEpmb2FHbW5FYVg0akhQczQ0UGl0TjJMdGlO?=
 =?utf-8?B?UFNZaE1RVm5aZW1RVVNlOWVrcXlHK2o1azQvSHUzb2JyNlN5b3ZLbkQ2UkNk?=
 =?utf-8?B?TDE4bEdJTzk5ZjFqd3BEN0ZHaEJoVjlLMzNyZXVMbHVvOWNzZldaM25zQVRn?=
 =?utf-8?B?RmtsWG9FaXdJS3g3aVpHNDVtU00vcWpoUC9Memo0bTY1MmpPTE5lMGtzTExJ?=
 =?utf-8?B?c3ovbnBsQUVraEFkZ05hUi9td2FHQXdJcVh3MkZWQ2pBNzBBc283YlQwc3JF?=
 =?utf-8?B?UDdGeHRwNWlFQlZyMnExc3o2VlRCZzhRMEpwbUdhaHBaNUVOeDhGUmREL2VM?=
 =?utf-8?B?MnhpN0pHZUI3SG9UOUh0dzZnNk5NeVNHSExLT3o1bmFRQ2dyMXp0SGFnelpC?=
 =?utf-8?B?TEQxVmMvdXRUdFhNbVJMd045OTdvSUZYYUNZYzRDclhGNEdXSlpVbHBSSHpu?=
 =?utf-8?Q?iJSbpgaxO4ZimqR4y7EQ4aory?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b01774-9177-4ff3-6d25-08db38f194d7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2023 11:57:24.2825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qr9nJDFQrpTSV1p3sRS3gqHIYOCFSh/XNqpVqlWymLgnc1CjXWEh4otBeQPhQAugB1Jh2hdp6m2szGo/7ij/2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5208
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/4/8 22:20, Alex Williamson wrote:
> On Sat, 8 Apr 2023 05:07:16 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
>>> From: Alex Williamson <alex.williamson@redhat.com>
>>> Sent: Saturday, April 8, 2023 5:07 AM
>>>
>>> On Fri, 7 Apr 2023 15:47:10 +0000
>>> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>>>    
>>>>> From: Alex Williamson <alex.williamson@redhat.com>
>>>>> Sent: Friday, April 7, 2023 11:14 PM
>>>>>
>>>>> On Fri, 7 Apr 2023 14:04:02 +0000
>>>>> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>>>>>   
>>>>>>> From: Alex Williamson <alex.williamson@redhat.com>
>>>>>>> Sent: Friday, April 7, 2023 9:52 PM
>>>>>>>
>>>>>>> On Fri, 7 Apr 2023 13:24:25 +0000
>>>>>>> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>>>>>>>   
>>>>>>>>> From: Alex Williamson <alex.williamson@redhat.com>
>>>>>>>>> Sent: Friday, April 7, 2023 8:04 PM
>>>>>>>>>   
>>>>>>>>>>>>> @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct pci_dev
>>>>> *pdev,
>>>>>>> void
>>>>>>>>>>> *data)
>>>>>>>>>>>>>   	if (!iommu_group)
>>>>>>>>>>>>>   		return -EPERM; /* Cannot reset non-isolated devices
>>> */
>>>>>>>>
>>>>>>>> [1]
>>>>>>>>   
>>>>>>>>>>>>
>>>>>>>>>>>> Hi Alex,
>>>>>>>>>>>>
>>>>>>>>>>>> Is disabling iommu a sane way to test vfio noiommu mode?
>>>>>>>>>>>
>>>>>>>>>>> Yes
>>>>>>>>>>>   
>>>>>>>>>>>> I added intel_iommu=off to disable intel iommu and bind a device to
>>> vfio-
>>>>> pci.
>>>>>>>>>>>> I can see the /dev/vfio/noiommu-0 and /dev/vfio/devices/noiommu-
>>> vfio0.
>>>>>>> Bind
>>>>>>>>>>>> iommufd==-1 can succeed, but failed to get hot reset info due to the
>>>>> above
>>>>>>>>>>>> group check. Reason is that this happens to have some affected
>>> devices,
>>>>> and
>>>>>>>>>>>> these devices have no valid iommu_group (because they are not
>>> bound to
>>>>>>> vfio-
>>>>>>>>> pci
>>>>>>>>>>>> hence nobody allocates noiommu group for them). So when hot reset
>>> info
>>>>>>> loops
>>>>>>>>>>>> such devices, it failed with -EPERM. Is this expected?
>>>>>>>>>>>
>>>>>>>>>>> Hmm, I didn't recall that we put in such a limitation, but given the
>>>>>>>>>>> minimally intrusive approach to no-iommu and the fact that we never
>>>>>>>>>>> defined an invalid group ID to return to the user, it makes sense that
>>>>>>>>>>> we just blocked the ioctl for no-iommu use.  I guess we can do the same
>>>>>>>>>>> for no-iommu cdev.
>>>>>>>>>>
>>>>>>>>>> I just realize a further issue related to this limitation. Remember that we
>>>>>>>>>> may finally compile out the vfio group infrastructure in the future. Say I
>>>>>>>>>> want to test noiommu, I may boot such a kernel with iommu disabled. I
>>> think
>>>>>>>>>> the _INFO ioctl would fail as there is no iommu_group. Does it mean we
>>> will
>>>>>>>>>> not support hot reset for noiommu in future if vfio group infrastructure is
>>>>>>>>>> compiled out?
>>>>>>>>>
>>>>>>>>> We're talking about IOMMU groups, IOMMU groups are always present
>>>>>>>>> regardless of whether we expose a vfio group interface to userspace.
>>>>>>>>> Remember, we create IOMMU groups even in the no-iommu case.  Even
>>> with
>>>>>>>>> pure cdev, there are underlying IOMMU groups that maintain the DMA
>>>>>>>>> ownership.
>>>>>>>>
>>>>>>>> hmmm. As [1], when iommu is disabled, there will be no iommu_group for a
>>>>>>>> given device unless it is registered to VFIO, which a fake group is created.
>>>>>>>> That's why I hit the limitation [1]. When vfio_group is compiled out, then
>>>>>>>> even fake group goes away.
>>>>>>>
>>>>>>> In the vfio group case, [1] can be hit with no-iommu only when there
>>>>>>> are affected devices which are not bound to vfio.
>>>>>>
>>>>>> yes. because vfio would allocate fake group when device is registered to
>>>>>> it.
>>>>>>   
>>>>>>> Why are we not
>>>>>>> allocating an IOMMU group to no-iommu devices when vfio group is
>>>>>>> disabled?  Thanks,
>>>>>>
>>>>>> hmmm. when the vfio group code is configured out. The
>>>>>> vfio_device_set_group() just returns 0 after below patch is
>>>>>> applied and CONFIG_VFIO_GROUP=n. So when there is no
>>>>>> vfio group, the fake group also goes away.
>>>>>>
>>>>>> https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel.com/
>>>>>
>>>>> Is this a fundamental issue or just a problem with the current
>>>>> implementation proposal?  It seems like the latter.  FWIW, I also don't
>>>>> see a taint happening in the cdev path for no-iommu use.  Thanks,
>>>>
>>>> yes. the latter case. The reason I raised it here is to confirm the
>>>> policy on the new group/bdf capability in the DEVICE_GET_INFO. If
>>>> there is no iommu group, perhaps I only need to exclude the new
>>>> group/bdf capability from the cap chain of DEVICE_GET_INFO. is it?
>>>
>>> I think we need to revisit the question of why allocating an IOMMU
>>> group for a no-iommu device is exclusive to the vfio group support.
>>
>> For no-iommu device, the iommu group is a fake group allocated by vfio.
>> is it? And the fake group allocation is part of the vfio group code.
>> It is the vfio_device_set_group() in group.c. If vfio group code is not
>> compiled in, vfio does not allocate fake groups. Detail for this compiling
>> can be found in link [1].
>>
>>> We've already been down the path of trying to report a field that only
>>> exists for devices with certain properties with dev-id.  It doesn't
>>> work well.  I think we've said all along that while the cdev interface
>>> is device based, there are still going to be underlying IOMMU groups
>>> for the user to be aware of, they're just not as much a fundamental
>>> part of the interface.  There should not be a case where a device
>>> doesn't have a group to report.  Thanks,
>>
>> As the patch in link [1] makes vfio group optional, so if compile a kernel
>> with CONFIG_VFIO_GROUP=n, and boot it with iommu disabled, then there is no
>> group to report. Perhaps this is not a typical usage but still a sane usage
>> for noiommu mode as I confirmed with you in this thread. So when it comes,
>> needs to consider what to report for the group field.
>>
>> Perhaps I messed up the discussion by referring to a patch that is part of
>> another series. But I think it should be considered when talking about the
>> group to be reported.
> 
> The question is whether the split that group.c code handles both the
> vfio group AND creation of the IOMMU group in such cases is the correct
> split.  I'm not arguing that the way the code is currently laid out has
> the fake IOMMU group for no-iommu devices created in vfio group
> specific code, but we have a common interface that makes use of IOMMU
> group information for which we don't have an equivalent alternative
> data field to report.

yes. It is needed to ensure _HOT_RESET_INFO workable for noiommu devices.

> We've shown that dev-id doesn't work here because dev-ids only exist
> for devices within the user's IOMMU context.  Also reporting an invalid
> ID of any sort fails to indicate the potential implied ownership.
> Therefore I recognize that if this interface is to report an IOMMU
> group, then the creation of fake IOMMU groups existing only in vfio
> group code would need to be refactored.  Thanks,

yeah, needs to move the iommu group creation back to vfio_main.c. This
would be a prerequisite for [1]

[1] https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel.com/

I'll also try out your suggestion to add a capability like below and link
it in the vfio_device_info cap chain.

#define VFIO_DEVICE_INFO_CAP_PCI_BDF          5

struct vfio_device_info_cap_pci_bdf {
         struct vfio_info_cap_header header;
         __u32   group_id;
         __u16   segment;
         __u8    bus;
         __u8    devfn; /* Use PCI_SLOT/PCI_FUNC */
};

-- 
Regards,
Yi Liu
