Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EB36C17A5
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 16:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjCTPQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 11:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjCTPPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 11:15:41 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2412D147;
        Mon, 20 Mar 2023 08:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679325043; x=1710861043;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xKC+I6VBbKuubeX6jo3/rRivXWn0c11x+rsOhKMIyzA=;
  b=Hz0d7G9vGCvYUQjfPrHZqQjk8T144eZuSzBFqBNofkQStD2bCAsbUbq0
   FdFftKuvM0Vd0vCMpkfpExgfNvFK9ZbdLjC9JJOsrSwgX634Qmf+7+aRC
   QY9A8MZC68newHdf2Id5iK+nRQDRU2Jltx3sse8qe5TfrVoh/1+1+uZJM
   b6t8tsHYy8gPzMYTkqrxJkUDN6jnVOSTxu6+pblPtHPwy6ALx4bUDkp02
   B8VvqYN3d5TkKQZ3T2smV+hNW1pp3HQwFnnCry/ntveTFrzPb5QRhTaQj
   LdD4XTZ43KInayvtzkIjNSXjextfwebmjFCF6+QAaM+SBtHljph8ShGxb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="337404188"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="337404188"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:10:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="681108825"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="681108825"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 20 Mar 2023 08:10:36 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 08:10:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 08:10:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 08:10:35 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 08:10:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcZyfUM4Fbml8KTNvCPsjfLczcNY3wsYK8o1bz0il6cD90rwD9NAmcZmnX2EIoLGe0GgEVNdFuzVAeM8BVR3lx2bxiJhfBfqSR56f9hMG0fPxSg7t6Hy68yRgAjKW6w9bRLKn4PFCgZVheRoQtams6+yaQ3qBytCW9pk16OmL77rvn/f30jhoCsBOYPMZOcdn6J3QljRZL6ot2NHYmnw0uBEsZN7XnAkmOkWW7NZ0tMKtf3G74hxXyvJTTZZEcEkkmUKAjFwM6ngpJZ4n0LBZJrTg6xWSpSJlwkLVjb5IR9flsgExGKBeWIipUscidmhqeIOPoTD43GYhafQtzq/oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ET0CUw7gJNf/AB8Hlv1do1u34ibjsa2eXvyZtmEmXDk=;
 b=WjL+w675TlTwkZ/gOLEfjYZRkLeu5OPAdLNdcjy+nyn4xoJjC5AHMlWAu0OJ17ToJcfKgWlvHs20Gz127jiofR9sIlhfBPMxrHoC762vrPl/c5uKO2M6waap6lEQYxtA0bwy3Nn7CfYXmoOmXvA4mnLApote8dfUsZt10tJnRjh8j4B9r5pXUuuQaf6+wKjJRY2uB3rkjtwS33LUD/vmEZPwbCNY8PAA1Mt4avG5azcpBVyOrWr6D88XMhG9/4gIG1Kpo5mieBEPqi/zqv86p886IT0al3NsZGnVdIWCilnvbTS5L5tTPrskYFq1CMo5Ln8ut8aJlwI111CQkyRKqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 15:10:33 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 15:10:33 +0000
Message-ID: <8129c297-5af0-f057-4dff-79840ef8e060@intel.com>
Date:   Mon, 20 Mar 2023 23:11:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com> <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia> <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia> <ZBhygasrWFAiaXIl@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <ZBhygasrWFAiaXIl@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0022.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::9)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CO1PR11MB4881:EE_
X-MS-Office365-Filtering-Correlation-Id: 34025bea-ae74-4e10-570c-08db29553fdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mw9arpJ49r0s2AZ+Wv46SbSgbO7pWpmM7UqwKcfxei8IiauhfI01a3vY5psFi71dURu33bZDk2D/bIb8YRogaWmsG5iBAjs20x9oFT2g3g9V+YuY9fXXbImb9zIJol3xAf/yjBlPkrjajjj/QzIQc3bUqkJFq0J9+3kG65VhcwXQsKzxlJuWVgT74a7CsCmm98QgrIqODmgmHFnrgjMoKoK8te4otUIobZdJ9eKa8ku0YlwTfHH6rK0U8duNIsayxeOpQK1oQa4EPwtmTVl/C5fw7RlkhCYlHPo6bFZRS+jrd28+eg20E1dFPyafPROyxKan5NXo+50RkaWHZ7m9RXt2EDj9Sz8MVGyAwEWbDpRHQuOMVHl4wriyGSGQf51aZhAy8HfOTkv66AnDWv52fqMWScb7KyF73dBwRW0gHYIwddHKvZfAWBV4myxGVPu9Hb0CQUN8DIGwM/jjK4qbmoyPx1W8ekQiccoQ61yh3crJOWFdh8M6Dj1ERergAaK0wgMDgLcEudyGO9Q5Qt9ybJHyd5IiktrjblEmuRs72CujhPe+Gt1cnlIbkg95ibqG1s/zF5RTYqriCrLRcjWM4nqdPJVGBP96z1UAyomg3+n2RFokTygmpsj35Ym93lRBrr9a9d1cDMXNDrHUITxrTh9Qnk6zfSn2jXBk3oeLDFOf7M04+9bAmdT70Y2/pomk6Y9HZt2t17RcFCnCW0y/7NTj2+rYroeRjH3jf7Lgoj6Bc25BUhBMwshwNx4goCtjAeHpuYfoJF9YWK12FfVjSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199018)(6666004)(38100700002)(5660300002)(31696002)(86362001)(186003)(83380400001)(8936002)(2616005)(41300700001)(2906002)(54906003)(82960400001)(316002)(110136005)(478600001)(53546011)(26005)(6506007)(6512007)(31686004)(36756003)(4326008)(66946007)(8676002)(6486002)(966005)(7416002)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTFBSGlnYWRXdCt5S1lOOWcyc3dyOG9XZ1FCUGlySG1ZbGd0VXA2eXg0Slc2?=
 =?utf-8?B?eXZLR29ndHJMQW5waFhSazM2ai85cnBjZnBYV3BxcjZzbGVFTjNzWHYyeG1O?=
 =?utf-8?B?VHQvZk92N3UrWUpMR0lNOGdtWmkyODZTVnV6eXFWMkVIaUhMb2RYQkM0SkZs?=
 =?utf-8?B?ZTlRazdEZU9OMVJpSmI2ZzBXOEwyWjJlN0RsRlFMKzdxSndGc3l5bmNLRFI5?=
 =?utf-8?B?T2tpUG1JVTBjbVNFVS9vK3RqRVNnWkgxOTZoLzlXVjI3cmJmWVBlT0Nzd2kx?=
 =?utf-8?B?MDdDQkM2SFFwV0ZJUkZkeUNlbG5MdU9uS00yZWJNaGpqa3VrNVdvUFFJSWdB?=
 =?utf-8?B?S0xISWZiSTJJSFZXRnhGV29ZcmR4Tk54V01ZSGwydVFYN1VndTZ2OG5hMjRF?=
 =?utf-8?B?U3R0bEJxZmJZQzNiMVNlZ3U5aDNPeGRuNkVUT2ZTbHBRQXVxY1gvcHN1VzZp?=
 =?utf-8?B?QnlKa0ZnbXNtaHRGL2N2eXdpc1g0bm9qRGg1dE00aWh6YTh1bkZpTW94ZFFu?=
 =?utf-8?B?cGtBT1hCbDJnOTVDNjBLMzlFYWJsbUNVS1Q0M2t0YUozN2Jlam94M3RFZlBj?=
 =?utf-8?B?bHVIamhHcUZMMFRvMFJocjYxSDIyclJKSFNLMDFrNXBtRDZUNUVsdzBaeHZz?=
 =?utf-8?B?WDJCUkE0aGkyQlBaZ0tKYk1Qd1BPU0MxM3lFaUg1N0JmODU3RHVKU2tCRDVl?=
 =?utf-8?B?dWxaVW5raDFsL3JiZVZKckp0TXJFZ3d2cjBvbnpmWlFnQmgrZVR6eDRVTFdU?=
 =?utf-8?B?Y1o2TGtCcEpKMmE4MXM5bmw4ZXloUDJ0VVBIaTJzVjk0dGU5andMSC9qOUY0?=
 =?utf-8?B?aURXbTBZcHFsRHkxTy95amZOZEFJVmxnQ2htckdkTXc0SC9Nc09Tc0wwZjVv?=
 =?utf-8?B?cS9jNHJWLzY2Qm1Fb1BVVzMxek1jZ3g3ZGJaWXFscWZSNGdHYm1vcjlrMzN1?=
 =?utf-8?B?bVNteCtHYkxnSCtNclhKR3VaRE1vVTUvcFprc2pNZnZ6ZTlXMTh0ejdDTFBo?=
 =?utf-8?B?M0VCZzYwakpVckN4b2Z5alRRSVRubkxWYjE3M3dKQWdkUXA3ZVdlT0c1U0to?=
 =?utf-8?B?M1RkR09VT2hPaEVPblkzOGFGOEhSV3FrNnM1TmRzVTBjY3JhcFp5US9NUUlU?=
 =?utf-8?B?RnhEUmtaQjdIc05PQ3U4REJkbXhlRmpWbUtWRUV5UkM0TUthUnEzK1BFT09i?=
 =?utf-8?B?ZkJtMU82YUNyL1FGK0FSZ2QwVzVGdDFHeGs5QWJ5S0N0akhsbEowcW1VNllz?=
 =?utf-8?B?TEs3Ui9wZS9kVlZ0MXZwKzd5akw0Uk9LSExHaEs5WkdtK0k3MWtDU0o5cVJi?=
 =?utf-8?B?Wjc2dUtrZm1ZTk43N2lzbkFzeWEraDllREF6Wm5WK21rVDNLL1M5a2p5Njd4?=
 =?utf-8?B?b3lVeUtYYlJpL0FLOTJVOHJXUUxTOUt3Z2hlS1dRM1JzaDlRSlI1S0RZVkVa?=
 =?utf-8?B?eUZ1Z1NCNXNuVmZaajJoQVM3ZUxsZXB6cm9SUHp1L0YweDJUMzJuR0N4WHd2?=
 =?utf-8?B?Y3p1emM3M0p0T0RyT1VIMHVTb09qUUlsdjlBWjJyczFaeXVmTDRkMmxBYzlQ?=
 =?utf-8?B?OVJPeXY0SDhMdUM5amJrQTNXVmkyc3UyQXUzdHlOUVhjOXVib1RqalJLV1Qz?=
 =?utf-8?B?WDBERFVnTVF0NHNSYmJhS2J5RFV0VEg3M0lLTklIUy80aVZWd1RGaThNbFZj?=
 =?utf-8?B?ZlAwOEd2RjE5NFJYY053RU1YWDM5b3dRTmlpVU5MS3ZuSHNVZ0tMY2dBbUYx?=
 =?utf-8?B?eU1DR05mVjkxNlh3WkFVNTdwWlA0RGNKOVZXTVEzZkxYdmZsUmVTOEQ0dTJS?=
 =?utf-8?B?UjAybElja0JVdU1JVjhiVnJIYkIrTlBDdUpEeVorUkR1VkdZbUlqU1kyR0tR?=
 =?utf-8?B?cXlhS0pOY3pERE1EYldsL2RqWVZ0K1oyT2ljbUt2aitCQkdWbmFvdlJXY21F?=
 =?utf-8?B?Wnc1ZVhoWUJsT2ZkM21JT3VQa3FzY3JoUGVVb3hFZUtCUlFXbEh2NVZSdysy?=
 =?utf-8?B?YloxK0RrQmxlVTlySERnT25zTWVqN05EMmM5VEZ4MXdtUVZxazA3TTBtRnNI?=
 =?utf-8?B?dXFodkZtNnRpWmZzMHRPb2h2UXlxZGJQSEVNWG1FYlpUQjQxUHJ1ZUtiOU1O?=
 =?utf-8?Q?yE63Y5JnBk0Spu5Q4CRP2cAvN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34025bea-ae74-4e10-570c-08db29553fdb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 15:10:32.7720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rmgsNmvjMJUYWM8ciXif0WAaGTHwoJwIquLv6BUUUO9QrVMrP1RFz48BGL9KezvFKSk+HP1zcgJ7DqkgrAjeVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023/3/20 22:49, Jason Gunthorpe wrote:
> On Wed, Mar 15, 2023 at 02:03:09AM -0700, Nicolin Chen wrote:
>> Hi,
>>
>> On Wed, Mar 15, 2023 at 06:50:53AM +0000, Tian, Kevin wrote:
>>
>>>> So, this preparatory series will add a pair of simple attach()
>>>> and detach() APIs. Then the cdev series will add the locking
>>>> and the ioas_unpin stuff as a rework of the detach() API.
>>
>>>> I think they can be something mingled... the sample code that
>>>> I sent previously could take care of those conditions. But, I
>>>> am also thinking a bit that maybe attach() does not need the
>>>> locking? I can do a separate replace() function in this case.
>>>>
>>>
>>> w/o locking then you need smp_store_release() and its pair.
>>>
>>> anyway it's not in perf critical path. Keeping lock for attach
>>> is simpler and safe.
>>
>> OK. Basically I followed what Jason suggested by having three
>> APIs and combined Kevin's inputs about the difference between
>> the attach/replace(). I also updated the replace changes, and
>> rebased all nesting (infrastructure, VT-d and SMMU):
>> https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-03142023
>>
>> The major three changes for those APIs:
>> [1] This adds iommufd_access_attach() in this series:
>>      "iommufd: Create access in vfio_iommufd_emulated_bind()"
>>      https://github.com/nicolinc/iommufd/commit/34fba7509429380f828fb23dcca5ceaeb40e22b5
>> [2] This adds iommufd_access_detach() in the cdev series:
>>      "iommufd/device: Add iommufd_access_detach() API"
>>      https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a097e2c9d9e26af4
>> [3] This adds iommufd_access_replace() in the replace series:
>>      "iommufd: Add iommufd_access_replace() API"
>>      https://github.com/nicolinc/iommufd/commit/36507fa9f0f42cf1a5bebe7c9bc2bf319b7654a8
>>
>> Please check if they look okay, so that Yi can integrate them
>> accordingly to the emulated/cdev series.
> 
> I don't understand why this is being put in front of the cdev series?

because we want to make emulated devices have iommufd_access in the
bind, then it can return iommufd_access->obj.id to userspace when
adding cdev.

-- 
Regards,
Yi Liu
