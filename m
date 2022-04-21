Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A46B50A361
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 16:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387692AbiDUOzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 10:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244846AbiDUOzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 10:55:09 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8BB2664
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 07:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650552739; x=1682088739;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/8UthpexgDL3wBynFVnSVqbcnenxfbcIpa7mwSXEDVA=;
  b=IcXl8P1YTPhAgb2whd5Vj3BGjOVkWmNHu2KFf2LmBzr9njykUfZamHyi
   m+ewq67+iwcPXF2vLEMfVhXoX+4X1xrmo1ZG5ofEp3h3qZC5lTkh6nWQe
   CVLlfOc56Ty0X5FVz0rCwm+A8AHz8Yzft8g8BrJ24VkqRW62I3vQmNKJG
   koAoX1L/PlvfHSTpxQeW5kIklpdtvynRsmlWrS6D7rWq7o3wdKTgP3QdL
   gBKjVRddxGlBURcp6DgqorKsRsdmBiWObzJh9pXWV4srcZnZidGjnKidy
   nrt9fr0QzE2ZdZJ5gWsp3Nhh62tH8FMvNkCiANbf4at3SHFrJ+o495+26
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="350810601"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="350810601"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 07:52:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="530327941"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2022 07:52:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 07:52:18 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 07:52:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 21 Apr 2022 07:52:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Apr 2022 07:52:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkhCYZAiN7cE5WUpdVpY7C6rgAuDZmoMkusuf2smW2Xw4xuJVvl7Hvi43240MfZzm7CUDNNks4AOSxXRWtZztBvfu38Ha1YuP6gvjOO0VTm2Rfei4KC19wU8hNDqqJdJ2MdeXtbAvS3zKh711uVr0zTONk3jjqBzIwj0CUVx3ZEulbetsQas7wFKo2Yb41ZApl1mwtpG97nvjAP4mFzfElFa5KF7HPYOzUH84MVdvQnLoAnoBg+6IAlUsRGCBZAOr3uDCLgmC/IMjaMhFUljltd/qhV3ca3obrW1XhvW+qXDhsroeQrbUmP/Qm0l7nQRpuxkmAPFf34vCjzT2QoC6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1nShkos1iUe9861TnUWc5aVFEuoLf8+7QV1DitIbZXk=;
 b=cIiZPZXZLtuWd0eC2XhFnoeY9CqBFS/5lGgOcGJwPxUJbSt7Dq58v9j0Qcr0VJSJbPHfzw5MajrFE2ZhGj2XbuQQk8SoxnlviTCzC0wFxk8KU+4TfFhC2kh9kQPy8QsUAWWngdfjvV3//+rheNiJw9pGMGKrNCBeexfcnyyapK1blOVpL94bRLMRKcY+cERVveBw/ajWeiOnJCPAU/blsUiAGa8Z+6MP+i4f98IwWPs8SWkWes3Vek1MoIypYP60E4PYc8OheG3SlrUVP7f6COKBus7lCQIgNkOoQivbFGHC6iEtMdb/9qidfI9BoXfSSL68/OZwfIWo4oEahLtEdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by MN2PR11MB4759.namprd11.prod.outlook.com (2603:10b6:208:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 21 Apr
 2022 14:52:16 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024%7]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 14:52:16 +0000
Message-ID: <6724d260-75a2-f182-f429-e834f59bca02@intel.com>
Date:   Thu, 21 Apr 2022 22:51:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v2 0/8] Remove vfio_group from the struct file facing VFIO
 API
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Kevin Tian" <kevin.tian@intel.com>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR0302CA0018.apcprd03.prod.outlook.com
 (2603:1096:202::28) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b5734e6-1f83-4ed1-a589-08da23a68707
X-MS-TrafficTypeDiagnostic: MN2PR11MB4759:EE_
X-Microsoft-Antispam-PRVS: <MN2PR11MB4759D915BEFAC91627A865DEC3F49@MN2PR11MB4759.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 89yQ3zpVPBCR6lgoOOSbvLkzGdmOR2Rn95wk4OrUq5wfl3xEVI8ozPJdObQJrRkILC9FuJT6jui+nmXh6dpjIeuXbU0u+2ztzHPSDW3wBVuQLuKzSZJ7mKdn4g3ozSkiF8TxYRkzcPqPC+QAZdcb1tTiC69drYf2fBDIbEYKENL1OVxKnzOCRr6+l0Wi8yGd8fuffNNcgsmrL+ijmr1hfysrjTAlhL7LQSoPL9XzXTOqUrnbpwIXtcNm9A82MzBhyJtXgnAYnDp/z2XRExAvxt8QzPSXiaCNSJSLBKfpEpyvXCc4bspuaZWPbZ6l+ngX/X6itfdaCBVWmMUXKT7rykTTS4JzBBpZ5OreLjTpEx018nbmfnPz4PkWCE3O7wOctqvYMkJwg4xzKKSYnOSuogbJiYCwQcpLzkrmxutQyOWuw+dTvmqfSajV8pbYuxzxoMC33J+3PSgfpP7137Zk5Dn5k3YwqTB0dnbwb+apSqJwIXFrppZd9bwoAn7eFL+MiqEEoMFuaeqviIe0invK38g63clwPcKbSPgAbFeWW+S9yFf0JSRFw+E0apbN1f9bebJqMt19qHV8LlFd2AdWq+HkmTC7nU8xLHxqq6DDBR3YDxjEB2yXmN087MJ4ameqVQRvMrlRraAQyOWOUd80O/9pOyAJLiz6i9IEWsNk6Qmj/5YLcvBgCSPdDbkmcHsQnqyBIW/N4fMhbOg2h6ZICJXWJlKnR/5tmpu07rwjvpvkFZ5p6D6oJEOwfTCP59FwwRV8iFJWrjHWEVVQld464i7puuzZrgF5hu1+n5Cygh7JyEyKtvUiwvFex9xUCECvSXxiedGX/VjeimI6cDNsNcYbc1AFAmjH7hswELWYl7g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(4326008)(2906002)(66476007)(66556008)(66946007)(2616005)(38100700002)(82960400001)(26005)(6512007)(6666004)(83380400001)(107886003)(53546011)(5660300002)(31686004)(36756003)(54906003)(110136005)(508600001)(8936002)(31696002)(86362001)(6486002)(186003)(6506007)(966005)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a083TUNvVzRKUTN3T0piYkxJdUxoK3krRWJwdzY4S2hFL2lNVTgwemRmdHg0?=
 =?utf-8?B?aFYxbjkveVJZOXQ0OCtpU0tuRmZya1JsRGh2ckZhRFNQM3lnWFcyY01WSTRi?=
 =?utf-8?B?aDFtQUVlT3lMMVdRS2cwRkVPQ2pwS1Z0QUxseElUKzJhVnNTWXZDUGp1VEhr?=
 =?utf-8?B?c0hDWTB2OHQ2TVc2UjBWbkZmZkxOWlZJWWNrOWZJRnlqck1PR1BMNGVCRkh2?=
 =?utf-8?B?ZFhpaFE0QlpsS2wxVWpzMlR0ajFwMzlnU1NmQTJTY1ZaeGZGTTR4elg2amdI?=
 =?utf-8?B?d2dqT2pBTklOMWUwU21iZzJZNy9GbWlXSXkxdjVHM3h0Nms0Z2p2aXBZL3dJ?=
 =?utf-8?B?cEc5cUVqSmNQdHlDU0JOLzRxaUNMdlcxWFkxTk1UQmUxd0VKSGNyazRuMGcr?=
 =?utf-8?B?MmYvNGRxVXdIQUZncWRVcDVOQmRpK3RLRnRJRkVqOWdoaTljT3ZPaFlkYk5Q?=
 =?utf-8?B?NkxGNXJIYUlZN3pXVHZRRUxVYUNPVXV2ZWpQYnNEVXlDTG1UbEdSNi9CT254?=
 =?utf-8?B?TGErOVNjemtwYUZUdTdHYmR3VXZpcWxqOEhxaVBYTWlMQkt6K2Q1NHQxL2Vr?=
 =?utf-8?B?L0RiV1RiZWxxZzZvUVh2RktoNkQxR0FOK0F3Qmo0bnZIaGl4UUw3cEFKQVhu?=
 =?utf-8?B?UzdwcDNubGtBZFhqd1RQK05TNE5seGtibHlaRW0wRkxRZFNkV05OYnpRZXcx?=
 =?utf-8?B?QTFJb0VFWStJemlNeSs1ZzBTUFMwZHd5ZGRycFdFaWV0Q0g0ZllOT2c2T3pV?=
 =?utf-8?B?ODMvNlhLRnNoaklINk5BZU44NzhxYXJyZzJmK1hMNTdncVR0TUdQeEhzb3Jo?=
 =?utf-8?B?Q3k3OEU3K01IeGd1QVpiN0lXNlBtbzY1N0RxRTc5ZDNsV3RMT3IzVEFTK2dH?=
 =?utf-8?B?RUZoTWMrU3ppcU5vdlZlN1YvSktwKzlpamtRY3Jhczl1U0xkK1VpQ2REb2dM?=
 =?utf-8?B?VHdtK1hBSFdRS2FZYzZDbnZCeUlwdkdVRWE2N05RakFSOXVGdXJDQ2Y1blEz?=
 =?utf-8?B?U0gzMUtXemZZT3EvWmUvckxud2N1R3hxT0c2aTlYUi9PN0VXTlJFTUx6Vno0?=
 =?utf-8?B?MUJlNUI1S3h0U2dYeVNCVExZdzlzeStGdWxUa2Z0emEzTHdFSWtYMGlxeHJD?=
 =?utf-8?B?UUVxVVBzS1hiM3dIemZ5ai9lMHd5ekpodkVnRW1rcGRjK0NDZ1dKMlo2eWhN?=
 =?utf-8?B?QUlCSHVjZnlDWEFiL1AxQmZEYStMMld3VzR1TmY3ay9ySkVBOHZFZTlDYjBq?=
 =?utf-8?B?RW5VajBpQlMxTXNJTFFrTnhZc2gvKzh4Tm94MDZYSjRMc0FKV3pRSEhSbGZk?=
 =?utf-8?B?YlZMdklhSU4yQW1FbjJlWWRENXR1NDdMUm45VlJ1UkRpdmdFSmNVWXJ1RHJO?=
 =?utf-8?B?T25TSHFZRmZIQVNKejVveWdUTTc5dEZTeGdOZ2w3RzNuRFptQnNsRkFJckJn?=
 =?utf-8?B?MGY2Vm1oWURaR0pGN3hUb2RJMUxNWDJQOENmQnR0Q1pZNHFVV2RVZUF2Sklv?=
 =?utf-8?B?UnZGd2grZ2IxL2N5YXRoR0h6a25qWmxTOWpUY096bkZNU1h2TXhtbnBybnVU?=
 =?utf-8?B?NC8xQm9MZDVHWjFZWDdIT25EWVJWUENhQjFsTjRGbGh2WnNBc2VMMG94QmRP?=
 =?utf-8?B?RVlZZ2xmTUZ2UWVJdXUyVnZoeHZmaFJPTlE4MEpMWCttbjBwR1BQVVdLdmNY?=
 =?utf-8?B?RHRnTGRYMUNwVUQ3Y1BoOVREUzRzNkdUSkh5Vk9yRGpDRnFnLyt3ejhublUw?=
 =?utf-8?B?TTcvbnpZUkwrekFucnRDNVVzMGNQRUtUUk93MEJGdXM1SGlrcHEzZUNoQlI0?=
 =?utf-8?B?VlZOTDZGN1lWbW44ay9La2JtWE54bzQyMTA0YnM5RjBoc1NTL0JtZlZ3U1di?=
 =?utf-8?B?YVF1b2ZVQ2dtdmJ5cU42S1ZYdTdENEI4bGsvUmxZczY4VEllbXJYTWRtb3Bh?=
 =?utf-8?B?a2pCd0RlMkdOK3cwR1QrNWRFSlJxOEs5T1FyMHBYSTlxc2cvRCtaN1lDYlB4?=
 =?utf-8?B?U3R2RTNwK2FkYkpaQ3lRUWdyWHBEc0YzcTVlam1IdzZsVExBb2RxR1E4ZVY2?=
 =?utf-8?B?bi9CL0ZjdjZGZGJXd09CR2NUR2RtRXc3ajZna2lKa243bW9kbktSVGo5bTRX?=
 =?utf-8?B?OEZmOTdYUzM0dWQ5VCt2YzF6dE85Rzk3SkdRVGl3TlJJOXE3S0loRXBKeDJW?=
 =?utf-8?B?TE9waS9MRk4zMmJnRUd1UGQ3VGMycFVPMU5ZakFzcEViWWFOQytpZWtENVJX?=
 =?utf-8?B?b0VacWliWDJzTVhtSGFicVFGSVVGS2VLUlRuMWVaT2c2eTZ2eEpOcFhCV050?=
 =?utf-8?B?eHdaQzUwRU82djJlS1VZZDg1MVA1MkNYemxYdnVEUjlpa2xVb3R4UDZUMnE2?=
 =?utf-8?Q?r1GHKRJy8gWmwNKg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b5734e6-1f83-4ed1-a589-08da23a68707
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 14:52:16.5671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JeLTm7j7epR+jgytbW2T92uj19sGK9HqQUjvKjvdtAFUHqx6siHG4Va6eF05de+ZWolEAkI6fXtuWyXpQVb0Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4759
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/4/21 03:23, Jason Gunthorpe wrote:
> This is the other half of removing the vfio_group from the externally
> facing VFIO API.
> 
> VFIO provides an API to manipulate its struct file *'s for use by KVM and
> VFIO PCI. Instead of converting the struct file into a ref counted struct
> vfio_group simply use the struct file as the handle throughout the API.
> 
> Along the way some of the APIs are simplified to be more direct about what
> they are trying to do with an eye to making future iommufd implementations
> for all of them.
> 
> This also simplifies the container_users ref counting by not holding a
> users refcount while KVM holds the group file.
> 
> Removing vfio_group from the external facing API is part of the iommufd
> work to modualize and compartmentalize the VFIO container and group object
> to be entirely internal to VFIO itself.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/vfio_kvm_no_group

passthrough a device from singleton-group passed. will do it test against
non-singleton group as well.

> v2:
> - s/filp/file/ s/filep/file/
> - Drop patch to allow ppc to be compile tested
> - Keep symbol_get's Christoph has an alternative approach
> v1: https://lore.kernel.org/r/0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com
> 
> Jason Gunthorpe (8):
>    kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into functions
>    kvm/vfio: Store the struct file in the kvm_vfio_group
>    vfio: Change vfio_external_user_iommu_id() to vfio_file_iommu_group()
>    vfio: Remove vfio_external_group_match_file()
>    vfio: Change vfio_external_check_extension() to
>      vfio_file_enforced_coherent()
>    vfio: Change vfio_group_set_kvm() to vfio_file_set_kvm()
>    kvm/vfio: Remove vfio_group from kvm
>    vfio/pci: Use the struct file as the handle not the vfio_group
> 
>   drivers/vfio/pci/vfio_pci_core.c |  42 ++--
>   drivers/vfio/vfio.c              | 146 ++++++------
>   include/linux/vfio.h             |  14 +-
>   virt/kvm/vfio.c                  | 377 ++++++++++++++-----------------
>   4 files changed, 270 insertions(+), 309 deletions(-)
> 
> 
> base-commit: ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e

-- 
Regards,
Yi Liu
