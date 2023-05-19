Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F3F709263
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 11:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjESJB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 05:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjESJBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 05:01:55 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68158E5E
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 02:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684486912; x=1716022912;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X46/072YW/VIJRmfuFyEHux+ZAEk+cJyJmqmMu3/ato=;
  b=A99q8egJxhR3k+R50yaPQihKIDMk/7lyc+BNvO0843741vzzN/gy57qr
   dgXbjZ39dV6e1bVMa0y75uwWkEaw4TVSvo9Uox1AOojGOitkT5Axwkuod
   81IgMCVIMMebd4Uj0M1+VogcXyBeZK2UVBkBK0SEkwGr64vd6nErZEVeX
   htrF57BOO9fd4ZBhtd4D2fl/Mmh/YI8ZdimGfyBfCy9U2Y66V1WS2SjDq
   r2DqZNkiAyNVxF95ZxE9h43NrGBGpv/DTg79O53NWeZUfnKPNuIBF6zIR
   XNBlbKjRaN5ZgE6VZCpvefU9IjQyjLO2njlr97jgWmT+XhDZF2umlpXl6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="355545615"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="355545615"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 02:01:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="846825567"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="846825567"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 19 May 2023 02:01:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 19 May 2023 02:01:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 19 May 2023 02:01:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 19 May 2023 02:01:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 19 May 2023 02:01:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKP8/JjBWh1g55oX79u7PcpVmxDtioQCGu5de/7E67RFBwI6VGCOyb1w3Si9FL3xIW9eHHTqJRjIccXTQ25FD05P72ALFMJPMO2LhxPscqAdfUiJxyxaGxCRzG3D/QB9ztv18WLtbNSIYSiGlHBY32PQ6oNLL/iPaYaQr7japaDi1fP8zrjPXIa0tFK5KNRbFx5imoJzYZHa2EEKs4tHmgsjjqUWLWBEEtTNmLb05RRvAsh1Ca2E2pGSzbXyZ6uFo3rX2oK5GvyzFt1VR4pN5n68yuMiKzOqUEWuRwsoROSLaCwen+8tK7q/O3FR8lcaHyzuelj4Ghz1+b/zw+rH6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2cW2uMeClQXzfJM6s8peaus4+wtxzcPeVM4BGYgZf4=;
 b=V4VT7nH8nTMXKe5OfvmbzZk5jAbk3vpotE2Chwm3qI4qEYJoXyYgQivD3JF93UD9D37q5uxyeRIAtoCyRFnFpD0c9SmQpZw9lVBsv60jJRJ5BMCH98Wska6p3wJZHA6tvXE8D+SLhR0t+wAZRIu9MTGVwBsehWNgydvJbryEfOAYlZrEEGUklm1usFWldS6DH/grK9sapuNv7jY5lJ2lHo5Pr9M7t2S3MuNB4lscVD8wbJ+eX0wjvDwyjFhOa0HETq4Wz4MXpcKDZ/TwVhjQcdhU7MenZI7Xndop0nxtATbW6+f/mQM2gpVn3AedsyuDj1PMJFmNNKzPyAemJ/XxSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5469.namprd11.prod.outlook.com (2603:10b6:5:399::13)
 by IA1PR11MB6396.namprd11.prod.outlook.com (2603:10b6:208:3ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Fri, 19 May
 2023 09:01:39 +0000
Received: from DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::e825:c2b5:8df5:e17b]) by DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::e825:c2b5:8df5:e17b%4]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 09:01:39 +0000
Message-ID: <aff4b4fc-ea22-2455-7560-01445ce31d8b@intel.com>
Date:   Fri, 19 May 2023 17:01:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFCv2 03/24] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-4-joao.m.martins@oracle.com>
From:   "Liu, Jingqi" <jingqi.liu@intel.com>
In-Reply-To: <20230518204650.14541-4-joao.m.martins@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To DM4PR11MB5469.namprd11.prod.outlook.com
 (2603:10b6:5:399::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5469:EE_|IA1PR11MB6396:EE_
X-MS-Office365-Filtering-Correlation-Id: 75dd2f3e-b57f-47df-3745-08db5847a7da
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C2etnf2cN3yIRNC46cNSTz6lbbwfDCb4gJKXq4zUc3ACF1DeeFOnt84pHtW+7Xc3GOH4gaS+ozzt0il68aN2Oozix2RAKpE53vSMUZMOhPyOFIuI3Hbo8Cv4B28fpE3NLr2mnPLM9LYpJOGjsJ/GgTz4/40dElfQUSz5xuwJMHRKTn0sII7mix4PjviQ+dvUGJoO5BQpG2GFePixyidqOXy0t4Qd9nz++GkOitEocQPqVIebM4cYzO/heIHUa67gFjiCh697T9QV5IyyxHKZUKST9pXL/TD3GJSl3xeMGp7eA8lQj10k8cryvXg/r1+/RXnqY8ZBwPYGCuKKDd1SlmC32Z6QFvuNRNE5DiM7WgASsS+FcrQJEtzSqbR6qbbH/M2Bue+z3z76mSx9ob6UKgSWNoMCXnmfN0/qetkH8667Dujap3f/CVzqpvPAU0sK9WTWV0/sMu9C0Cj/9d3n0Dl2H55C3uWhNs20OTbtCk+UoYi6uoHDBond8cLoZemLEFbsH02Xxy2CPlil2zFyBnkpFbKd5E34pqjbkykZlVLRp5nYWA7fn39HJ5Bm2WP5pQc6/J0gvDg/GgH2BpXc5umW9xFsSTL4DItyq23lEyqhcteJ2jrVwqMjcw77GSPrjIFWv32sMg7nz58yIV4pAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5469.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(376002)(39860400002)(396003)(451199021)(31686004)(66556008)(54906003)(4326008)(66476007)(478600001)(66946007)(316002)(36756003)(86362001)(31696002)(6506007)(83380400001)(53546011)(26005)(186003)(6512007)(2616005)(7416002)(6666004)(8676002)(2906002)(8936002)(5660300002)(6486002)(38100700002)(82960400001)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YU9WUlorT0JpeDMwblh3aE4vMjNoWGVuMXBSUE8wT1NqdzJ4LzczSGhUeWV2?=
 =?utf-8?B?UXJZYVdwcnlIcnpIa1pXZStNdWI4elR6MGcwY244UnM0NHBrTEorZWVRZW1S?=
 =?utf-8?B?ZHVJZG82U2RHNGhIZDRzaWNJV3h5bHVyVk1Tc1VIYUk3TSttc0E1cXhoVURV?=
 =?utf-8?B?TVRrSnhwM0lYUGZBQjNJUXdEVXFqNDI2YUplYkU4eDFsQnlZYndnT3BBZ29J?=
 =?utf-8?B?ZzR6VHRtbUJPWFlyM2d0YzZxNElnQ1F5SGc0RHhnQUNQTDA0MmFDeHUwSW9S?=
 =?utf-8?B?WVhJejFnaGZRNmtZVEVpVjRXbmJid0RTbmZiVEp1SStkMm1Gai9ZMEUzelJE?=
 =?utf-8?B?UDZFNlRYSFBkQlV3OGxrdEM3dFRKdWhvcGJGV0xhaERUbmxQN1U3VzlIUy9T?=
 =?utf-8?B?alVNK0lXektLcW5vSmxHWW9NcVd4d2NxaXU1UjE2eFpBdk5RU0M5YUx4NVZH?=
 =?utf-8?B?L0NLdDVVZmhmWkUvTGlLeFVUeFkwMTVqc2dVd2ZYU05PRkdNTWFsWkJPaitz?=
 =?utf-8?B?SjBvODBFbDhxeGpaelozNXVXOUs3VFJqZGlKSHFFOWNJTllFSXVtVTZyTkk0?=
 =?utf-8?B?ZmlibjNYaUZSNE52RFlWczlEc1k5dTV0WnE4UHgzR21jem9vbjljL2ZvOGhs?=
 =?utf-8?B?eE9yc09zaUYxN1RCT2xxbFVLa3I4cmVUR09hWlBVaHg0M1Rjd1VRWEVwUktj?=
 =?utf-8?B?OHJTTEpZb3NuTm5LbElWV0kwOVJrSlp6dW84WnUxZEFGdU95Z25QeXR5bS9i?=
 =?utf-8?B?cmxGQ0VYWEpGdVpiY2hmcnVpN0RONEFvdEw4RVpnSis5SXowMmM0UXlsRWlC?=
 =?utf-8?B?S1EwTGRNK0dlL1pZT3BBQnZ1andNdDdRT1EvSE1IamppSmVFbWRMZEN2T1BC?=
 =?utf-8?B?TXJWWXI1SVNlam1UZUs0aXBHOWlIenhxMzRvNkxtRmdsc3dteHJyTElWckhX?=
 =?utf-8?B?TkNJYUxuWktsbzAyZnZ2bFZaQzIzSThMMHJ0MkkwVDFGdnowRGhkY3piR1JP?=
 =?utf-8?B?Wkl0WDJYb0pTQTVrb3dxeEFrM082dHdVa1QxVGRRTzlDYVBQZklFK0pCSUpU?=
 =?utf-8?B?YTBVKys4UTQ3UWd0d01QMzIrQktXbDdtVUVKdkloT3FrWS9FbGcvRjJjRWM5?=
 =?utf-8?B?S1cyN25qVGllVEhVeUtEclUxYmxUWGI2eUFNSGdJdEdnSmJEa0RCSVlLRG51?=
 =?utf-8?B?TmdoMkxnNXdTU25HaGVGekFYb0VuSGloU2o2cGhSTURWUDhiS3REQm96ZW9T?=
 =?utf-8?B?Q0FjaDVUcmJ3b2NvMVoxaWZiSk84WktQV2MycXNTRjdnckpXVFlTZU43YjJC?=
 =?utf-8?B?eFNLNnEzemRjVFNQcUVWYmxXNUhEdVNEOHdhNHlxc2lrZTROdWVqWktYVHZK?=
 =?utf-8?B?RllLWjY3VXlTbVpaNFovTVRXTDdiWXJLTFpkSk0wM3pWTEhSY0F6SVpJT0R0?=
 =?utf-8?B?ZlZGc2ttUkNTUE5pQ2RNSCtnNlJ5VmR0b3U0UDFRSlVOTXA5MTBCSkJnZERW?=
 =?utf-8?B?R00zaWRETWpaZk80N2FQTFVaWThvL3grVUdMYzlLZWZlS0sweUp6UUN4cTNq?=
 =?utf-8?B?TDB1VnFtUVpNOUFldTNiNXpWcTJZQ1Bqc1FkS09lWW1MTlA2MEszMSthTUFl?=
 =?utf-8?B?K2RBb1NBNzBMSzRueGs1Sys1OW41SG5jdTBPSFNNSWo1S3FGbTJoWnJLc2xv?=
 =?utf-8?B?VDhRVHBRS1N1dWFxUDMwVmlreTZPQkZpSFJyWnM0ZEUrT2M4RHdKWlVRVkRP?=
 =?utf-8?B?RCtqVDdjdlVkVml4S3JxOG5nNk9oWTdlbU91bFAzbDRueTYxNE8xRFVCMWR3?=
 =?utf-8?B?NXRuNmVVbTJWYjBHbmM0alRpRy9xZzFsQzErMmxnNFRwcXY5SVBYTWs4Vm1j?=
 =?utf-8?B?MktnVUx5a3dMVWZaaXhNU292blZjeGo1OFZkQTVMY1Q0RFRmaXlCaDVraURO?=
 =?utf-8?B?aXQ4eVFNUGoveE9mRlp1YXdZd1BEZTZqWUxRT1VhY0cxYnZsUTEzd2xlMk9j?=
 =?utf-8?B?T3NpbmxKWDE2L0VvQWhObndNOURnY2NJSWJFSllmaHF6ditFUG5wbk9IaWNy?=
 =?utf-8?B?ZWs1blZuQXZNSGtyOTdVdUxGUDhuenN0SWUyVURtQTB5V1dRWFdWSmcrMXRy?=
 =?utf-8?Q?YFDpUOQmZPpDWBFE/6S/SAP0I?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 75dd2f3e-b57f-47df-3745-08db5847a7da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5469.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 09:01:38.8772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fjiG99vzmH4SpnQmF9YOyU88dFjcH0B7LAnXsQdkukaNrLNFWd3a/ShdhNo864d/ooN1Un7hYkd3oaq9UFOKsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6396
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/19/2023 4:46 AM, Joao Martins wrote:
> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
> the user bitmaps, so move to the common dependency into IOMMU core. IOMMUFD
s/move to/move
> can't exactly host it given that VFIO dirty tracking can be used without
> IOMMUFD.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/iommu/Makefile                | 1 +
>   drivers/{vfio => iommu}/iova_bitmap.c | 0
>   drivers/vfio/Makefile                 | 3 +--
>   3 files changed, 2 insertions(+), 2 deletions(-)
>   rename drivers/{vfio => iommu}/iova_bitmap.c (100%)
>
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 769e43d780ce..9d9dfbd2dfc2 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
>   obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
>   obj-$(CONFIG_IOMMU_IO_PGTABLE_DART) += io-pgtable-dart.o
>   obj-$(CONFIG_IOMMU_IOVA) += iova.o
> +obj-$(CONFIG_IOMMU_IOVA) += iova_bitmap.o
>   obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
>   obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o
>   obj-$(CONFIG_IPMMU_VMSA) += ipmmu-vmsa.o
> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/iommu/iova_bitmap.c
> similarity index 100%
> rename from drivers/vfio/iova_bitmap.c
> rename to drivers/iommu/iova_bitmap.c
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 57c3515af606..f9cc32a9810c 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -1,8 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0
>   obj-$(CONFIG_VFIO) += vfio.o
>   
> -vfio-y += vfio_main.o \
> -	  iova_bitmap.o
> +vfio-y += vfio_main.o
>   vfio-$(CONFIG_VFIO_DEVICE_CDEV) += device_cdev.o
>   vfio-$(CONFIG_VFIO_GROUP) += group.o
>   vfio-$(CONFIG_IOMMUFD) += iommufd.o
Thanks,
Jingqi
