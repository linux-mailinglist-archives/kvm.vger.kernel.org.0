Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8545638576
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 09:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiKYIpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 03:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiKYIpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 03:45:52 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCC221242
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 00:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669365951; x=1700901951;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ur+fihbkI1Kg80oKLmC3P3CL+mfTtv1nyLIagDImOmE=;
  b=PgDCNhWq37sSgIwTRhqhti7kjE6Sl1ZYQaA1rHbvY76cR0SgcxzGVwHZ
   6vR2Zc0/ZxgVF8cnO85cqG5y9ADbdr6zh0i75Un3QyuVIOMgkCy3qWHMt
   vgLA8bssecvIgsCT1C/KZbNkc1iPS+VUD0ml3TwBqyceqxoH6jodYC3TA
   xwryeFE1HpJFzCst9WdhPGyfH6GpEqvcvPuz/aNZgjYInF6OkhzIk/+wO
   +mwSLewzlDXz6rCkXBxv256rz/FKpQSI5M1nWoVANDaeXDR4ebwtBdgvD
   yXwuec7sSuBjchMXT8nepYfBqWT4YeOLzWXudOlbBpSwDrVTMtnv9TygB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="378698283"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="378698283"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 00:45:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="711211006"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="711211006"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 25 Nov 2022 00:44:33 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 00:44:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 00:44:32 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 25 Nov 2022 00:44:32 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 00:44:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnHhvDwY+tubMri78RwXwdeqS5Bj+K3djKhVYPrrmMHqqcirM5iW5cnxedab6U8hKfGpxXqeMSiz1czfMp8DzoefUKrx5GwYLaHkrROcXgVFBNpKZUi9AZot2lTfwq8ooXagfvqEyEl4OqfrHDdx6Rnd2OkOh+eU+mIwkQxKCKfnarMJfoWZADMXMN+BtRD90F799wv3Mxxh792psaSTparialc2+Wqj/sSDyjrcuwt7WQb3Y2x0qdJ+qwikiURRRnN+SqNZUIQgKdvp7l3gEfdAuhvRGVYGmDPIEQyDA0cnMnd27vyOZ9d317APGwY0hQGmBD8sAZoTw+7MhHbOZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75kwFCIUTVZxDchvxZAY63Of+oDXkk8YJwTDlJEmNRI=;
 b=A8mEmeT+T3YEjMJD05mHjymhwILYatJ3ltBR8ClGNoWKQw2XfhqidZhqdLCq+KsOKWOGjTqHmuP9NIP43Pk/w3+z5zKXosK/aF4gWDp3P2haW9kO5SUSkwsvhK3qjOIIE9tsKv+qauhIwDo0dn4Yt/lMX4z7rd1jQtkmgLuMCowaC2A6KTaMmD45csZmrhDWopOXAu5vSrQSJ5F/SCGPO+DQ9uM/AzqNbAMBlA/FBui7saZuWT8rDof4Y4+gMaIkbfqjjwtIzw7M0rWIO0oyJyvkP6v0vg9GDAnODey6z4s5SQRRmUIHn8pWI/71DHOTDUFpYEEldqG2RTG+lAd6Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB7318.namprd11.prod.outlook.com (2603:10b6:208:426::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 08:44:31 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 08:44:30 +0000
Message-ID: <e4f8c00f-809c-01d8-c104-06bf84041116@intel.com>
Date:   Fri, 25 Nov 2022 16:45:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 11/11] vfio: Move vfio group specific code into group.c
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <eric.auger@redhat.com>, <cohuck@redhat.com>,
        <nicolinc@nvidia.com>, <yi.y.sun@linux.intel.com>,
        <chao.p.peng@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <kvm@vger.kernel.org>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-12-yi.l.liu@intel.com> <Y3+BXHd7dEL7FYqz@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y3+BXHd7dEL7FYqz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0023.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB7318:EE_
X-MS-Office365-Filtering-Correlation-Id: 98e334bc-ba40-4b00-dfa4-08dacec14445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZaszDfQ5muvMB5xE9MjOrj9dFfX20HPjF8NxJT9kTyLdWsrOnSncOAY1DTWgv1rdtTX6FV4UnUAtqfJTwiuLcyelMFycJ/NkYM4idTynQRPfNFwLe4T7fWLpyykzx7TO/wGyMyLGSvYwXX7U0m+HxKJD9q75Muky7hvINHPFrGhJYDPqG11IqTcZ0iESoNiMMJ8b0K+M7wQmAMc7/fKb8zYENPJISTWYXfJ7QxBFm7Hs9WbA/PpARtAi7LCA3cOBrv4zLLMId3jP0avdHektLawXqg2RLEG8Ds7vA94xIunQnVCSWEy5yW+74hZppvDTuM11jCWeK1i0IAmIYOKGafCa/rqq9KaArsxtct2lgWbM9tV6xLsd47OuQ/Sz5iI9BgXHljMBJvItJlAInIXmZgADAKtQWDO+2+DDYGA4Jn0mNCs6BZWY0pHM9q0RG+Fo4u14wSzZMVF0UV1XsuUCkvvva6VQcypie8uuK+VlG3R+yw2C5Y8DpMq0aF3gqfw6Nv+qltg+/2bvGBjCS+yV8fjlMiZz75YJDqDSAuw5b5NfMaQLfSwmzbvYZmnp1CXthCcXXtkmrSn0hOuteP3sVKP0vZPumNe04BtNP3awmVLqmWTZ5P9T3RcGjD0SAov5YNiZS5boMXAW1LUNL0O7HBys1TnNPLj5mU9jhhNfSbfsym5hILbUQjqKiX/rYkX4bxp9BgBadUqKhIlw3EC/4SKOJIAKAhUGt++z7I5o8g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199015)(6512007)(26005)(83380400001)(186003)(82960400001)(38100700002)(2906002)(2616005)(4744005)(5660300002)(8936002)(41300700001)(6486002)(478600001)(316002)(6506007)(6916009)(8676002)(66946007)(6666004)(66556008)(66476007)(4326008)(53546011)(86362001)(31696002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1M3aVRxYWZPMUtNVkc0VkRsaXZ3UkZ0aUwwcUJmRTFvRzZOZVIrcHNoWGwv?=
 =?utf-8?B?Q2VMVXM0VThqb0xZRDBxdXVJVGIyZ3V3U1RsZ3pOelZhYlluMDJqUVk1bFV3?=
 =?utf-8?B?MkM5aDk5YTVSa244UGhXWkZCcys5NDYraXd5bG1DZk1xcDlyN3ZITi9YWFdU?=
 =?utf-8?B?eWdMVzVFV0FRMXE3V2hyOFVOc2I2QWR3RTYzZU9XdGwrUlZ2dXlJTUtTUHJ0?=
 =?utf-8?B?aWp1ZW96TWVLOHFFU0h1eEVoMVVNSUtHM1hUSTgzSExNTlFsTVlFRmthL2RC?=
 =?utf-8?B?K2FTWlJxZU5rMUlDWFJWM1IxNEplMGc5WjRSMW5qamlXT3Nwc1NaRkZxa1lU?=
 =?utf-8?B?dGErOW1heGpGaHRvbWdFN09EWlJkZWovazJJVDlyemN1c3NMekdhS1B5K3Jn?=
 =?utf-8?B?ay94YXE4K0NpYTJwM0tKQkQ0Y0lPdG5FVVNrQXJUQ0ZNUUdsUHRpVURMOG5q?=
 =?utf-8?B?TmdCdzZoTWhhOXFFTWdyeWJiNWREWjBSejhadE4rYlp2UDlSbmVTem5oOVo1?=
 =?utf-8?B?eGZRT2dNWnhsRnFmemVPRXBHS21SOHUxRWpScThtWEFXbnVZaTVRYzYyM0Na?=
 =?utf-8?B?WE1nMjF2ZStOb3AyQXJBOGhDZW1wZFh3dFk4aEx0dXdBRURFRmo4U2F6cysy?=
 =?utf-8?B?K0w2amZUNG5TY3huZkpHSTNHeWRKV2tMSFB0eXV6TGxwR2F1MXl6S3BWUFN2?=
 =?utf-8?B?Zkl6cU9BTkZDbm9VMkozWi9MOFpYZFM3YkZKbEV6NWNBaW8rdmMzYUZIY0to?=
 =?utf-8?B?SDBxbTU3NFMxMXphWlpNVTc2VVRxUExOTDMvZko4eHk4ZE9GYm1xSlVmM0xt?=
 =?utf-8?B?TVZ6UjhKZzlWSjRNbmZhQjEwdThlME1XbUdJK0piUHhnWHNkK0ZZUk9sM1oz?=
 =?utf-8?B?anpzNVdUSng0dG5BaWRhRm9PYVpoSktUeG5WQnFNa2U0S01NV0Qzb0ZNZ244?=
 =?utf-8?B?WnJwa3Rxa2N3dk1pWEljT1c2Y2MvZnhqSlZqejRRR2grZzVQRWZCN24xNFhi?=
 =?utf-8?B?VkpmRkpTaVFEdi81QXB0NFdycjU2c2hObExGMVRvZTRyUnMrQXN5bFNsdEpU?=
 =?utf-8?B?bGo4TVp5OGcvamNaTjM0aWdMTGdQZVRtKzJ2ekJUTDFDR0gvSEg4cUlTdHds?=
 =?utf-8?B?M0ZmOHdYaStNa2NrWGFDVFVoQmd3ZTVWVDM5YVVYcy9QY2hKVGxqQTVidTdv?=
 =?utf-8?B?WFNSbjg1QzN6Z1J1VVRUd212WUptNElZK2VNb3FRRWpHTzU4M0JGSHR3OFFU?=
 =?utf-8?B?K3pxTW81Mk5hRW5mRkFVWkx2blVQd2JjMTVRUGpKYzlJQ0xNek0rUjVkc0Fi?=
 =?utf-8?B?OCt4eGJacElYcEU5U1ZQbWQ4eUJqRnUzK21yc3NJY1BjNHVqN2o2NThrRFdZ?=
 =?utf-8?B?b3hsdmZZZ2R2TWx3Ri91dzdwTmUwRitLYXNxODM5YytDdVAxemRsb2JSYndY?=
 =?utf-8?B?TVJaQ0NjM2l1a1l3Q2ZPNTVhZFFnWURTVTY4WWxGTHpDZTBaWGJacUJZczB3?=
 =?utf-8?B?MTU3R05aK3JudGJGS1U5a1prUWJSN0dEZEUwMW1WVmlPbEoxNTkxUFFyRTZI?=
 =?utf-8?B?WHlrRHdjZWZaRlZuTkNiUm1NdVp0TCtsdFFERmdXZzkvRFRabktpNVRDTE10?=
 =?utf-8?B?bXVTZzhCWEE1TXBYanBLZ3JlV204RnNMWTMzYjFDY1p1ZVNJb2Z1ekp0NDQ0?=
 =?utf-8?B?UXBIbzRKR0YzaFN2cWZjNkxSNlVidW5IVGw4eW9FY3VsNWlONHJKRlkzWERL?=
 =?utf-8?B?aUFJLzdsdzV4dG9uRkJyL2dZU01rVmsxYXMrTnRJdjdSU1NNWFBCZ2Fqcnd6?=
 =?utf-8?B?QW5lcW9McHB2K1g0VjNQWHNPcmxNRlI4NU80YWFYN21XSDlKamVQazhpWFZa?=
 =?utf-8?B?YkRET1ZVTG9DWmdLdlBwRXMyUFh6RGxFWTlOdVZRNWpkUEYxYXpiZEF3MVF0?=
 =?utf-8?B?ZnNwaXhCRE13U1VlQUZGK2tuYmxDVllkTDAxNnk2NGtQMHpxUFRYNWJQMkxE?=
 =?utf-8?B?V0xTa3pXU256WllZMVpidVo4bGYvQXFsdnVQeHV4Zk5nRi9uemxCNi90SFlm?=
 =?utf-8?B?VDNMaDZBdnJiZm9SODJVZWN0ZzRseUROZU9xNWVVZ1ZodGJKbDZkNG5Ybm53?=
 =?utf-8?Q?Ps9eoinYlsY/uB6UO5RsYQvCg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e334bc-ba40-4b00-dfa4-08dacec14445
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 08:44:30.8609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4QRcur1ImXkRD5e80dyYjn5dXGeY+ZIuwF1VowC8pyftlDYOFjUfNW334x8hZtgG5SVITRQq7a+IZHvdeNAeGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7318
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

On 2022/11/24 22:36, Jason Gunthorpe wrote:
> On Thu, Nov 24, 2022 at 04:27:02AM -0800, Yi Liu wrote:
>> This prepares for compiling out vfio group after vfio device cdev is
>> added. No vfio_group decode code should be in vfio_main.c.
>>
>> No functional change is intended.
>>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/vfio/Makefile    |   1 +
>>   drivers/vfio/group.c     | 842 +++++++++++++++++++++++++++++++++++++++
>>   drivers/vfio/vfio.h      |  17 +
>>   drivers/vfio/vfio_main.c | 830 +-------------------------------------
>>   4 files changed, 863 insertions(+), 827 deletions(-)
>>   create mode 100644 drivers/vfio/group.c
> 
> vfio_device_open_file() should be moved into group.c as well and
> export vfio_device_open/close() instead

also need export vfio_device_ops as well:-)

-- 
Regards,
Yi Liu
