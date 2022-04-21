Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327A450A37D
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 16:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbiDUPAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 11:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbiDUPAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 11:00:19 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7B3434AC
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 07:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650553049; x=1682089049;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sa+BGltHPFx7rO45mHjyizApfXAEbE6xcgDF+dOTnC4=;
  b=Ftw/n8pOu9hFXIoqkzi11NjY+weMH3Yofi49bo3t+/PzCCqNQ+rx7cbL
   MnaY2j6nf+6f6yvmPofyBmcFxk36vi0qWz9uq3xWt630ITwV26K2m5ACI
   Ik1ivApVNF+GkIiG1gtltySQVcXO+tVpHLKDm9EqCokVem96goqUex5hh
   zuy/1ZMrW2LJFUnTM7t4W1sV9hzVVjgYypImv/3upM04E+X4TB/iX4Wvx
   6zWox0XCDAnY/BGv/EUCM7XHEEJncLrcJHQLfZqCA6TnkxvoXJJJLNRgl
   mXdgXznTR2ZJDbaZ8rhKEOIWnNvQxmG/Z9xVILo2IuzbIQr9PUD2eF5nO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="350811544"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="350811544"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 07:57:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="530329868"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2022 07:57:29 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 07:57:28 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 07:57:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 21 Apr 2022 07:57:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Apr 2022 07:57:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVpvvAS0J1OhZPt0IPcVy4WumoWa6/kpJs8vuaQrYRgIHdFW1q+OaiXGT0q3PLWsEN8Qv41I/M+FvKXAWlrCrR3P5WC6NpdcgfMK8X3HyrRbNLJvCfQWWYgKamy8VkSpyY/MkoKKgWKXxSwUBdv5jMNgjOJtLmzuHlYLRhNuAh7YFsxGHnfLrSucHBC8sHfQ/+tFz0UmMFF+tx1selpcQDIYr6SZZ2faZ3DLb4SjCgn+1G66/4RIklaRHd4B4XHXdCkledlP/uB0eP+nfvegygoLqbMmO0AB5vuBoVC5xAWVj/7QCy/E2WMASvYiDZEmk8XoRM1A2QcegcDnrtZ8+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0RpMsLdcAuMCALuIw4uR2MAOdotifXT5TpyK2p3Ew3Y=;
 b=IUPQOVEBieeXQijgqOHjM/7/NYxdGu0vpcLqpyYvyF2wL339TqYwoHGpyEQXhiC4BH6X26hcnTrPs+tSXa2fxtE5Obua55mFoWPLLXEyF9NVFyzV1BQX9Xr/rIkgwqK4QF+OmP8JonvSRUjRgYWcWpTpqrYB8JeZ2uGM22/7zs52fAa+0NIHxD7PYkFBwEawY6utXXjFZZcz6tSEfPND9u3D4ewojsaQg4FoDsUeuuFkC/1rnf+Du2oC9qoWF2oFrD0CZgNammm/YaGg2+6uI4N3xIzN79M6rV0Y48cPpZzpoj9RsvDWzQE+YrXPY10mNurB9pxZ4X01sjJG58VzSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by BN7PR11MB2724.namprd11.prod.outlook.com (2603:10b6:406:b3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 14:57:26 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024%7]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 14:57:26 +0000
Message-ID: <d9729afd-61fd-1911-ba15-ae3ed5e73f30@intel.com>
Date:   Thu, 21 Apr 2022 22:57:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v2 3/8] vfio: Change vfio_external_user_iommu_id() to
 vfio_file_iommu_group()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Kevin Tian" <kevin.tian@intel.com>
References: <3-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <3-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0183.apcprd02.prod.outlook.com
 (2603:1096:201:21::19) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10aab239-8576-4b1c-88e2-08da23a73f77
X-MS-TrafficTypeDiagnostic: BN7PR11MB2724:EE_
X-Microsoft-Antispam-PRVS: <BN7PR11MB2724F5AB29D457F77098055FC3F49@BN7PR11MB2724.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXWBM8n/OZclrt3YTxVa0zGu7orGO6VRcW2h4091s0VPNAS+NppEoOLjFjcV39qMACRhbJiDXM3Wa6bvML/ckRySVrZDmwGpbyUTd0YJ3Kp5FiiUqx0E34sTr3c2XvNQFBHUjhe6SqUi3kpsnLfhidnay7Lsoxyuc8NaGUJe4r4/mYsIAEGyUzlIMso7EWyiCuNNZ+q2alMik/nWHOUSG3Q51PKPHeatDS2A4TYOFclMwl9v7veI2G781B6kimoeAMx8d9oAY7i+XV0l66P5JeGjnVYkoz2dOgrJ14nXf4SThJBglrjo8dx1qhPGYhCfzuAWm6Bi0tMaIRsu9C74LxiFS31LyrBFIWU2Gg57H29kKlBwqKKFYQAOLFtLYyAhR63967tbMfhLsPp9ib+bVw4IYt5pVSyIfd9OxqjVh8KdU4RCHgd+GEzKrcoDYm/UOjmsYueOSDk2Pu2aY1r4Uh31Ci+wj/c6NPMT2DYipCTYLbVUfnFEJR3jJZvMp1ILD1hBnrpzpvNeZVhLI/oManxoxaYg0BQwXPTNVbjZWS5dAypCW9+lz0jMUnP5NbP9JOiwY0IqgqeNE8ULq5kUJtYUkJE6vSzXh4EaYolQwR6AJV3m4hpLcCAlVmjkke69l2SEsVVvX1EnURs5VqH1t6SwjukzM7KjobPBCfCzUjNjVulyMevryaGmBU7i+7arneqwQwroCKiIRV6xJO8GKt+DdNrP2L6WxpwywDS9H5ybjOgPv/8awJaoxYmgCT8z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6512007)(53546011)(26005)(31686004)(6506007)(82960400001)(36756003)(8936002)(6486002)(2906002)(4326008)(110136005)(8676002)(86362001)(38100700002)(186003)(6666004)(66946007)(66476007)(83380400001)(66556008)(2616005)(5660300002)(316002)(31696002)(54906003)(107886003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUZwYVljczhqMmNLbExKUEtoMkFWVXVnYnI0TGZSeUZTd3IwVkI5WDZZVFkz?=
 =?utf-8?B?aEMwRW8wNnNMNWJjOFg2YjZtalpldTh1NGZ3MFNnQlBGZ2s0aStQL3hGa0Jz?=
 =?utf-8?B?M1pVZWFoN0kxUzBVMjRxMjRLWm0va3gxNDB2Wkk0YU9NS1lhSG5zRXRUWkty?=
 =?utf-8?B?T0FvT3puVzJvdzBDanhuSE1ZZkVDdTdhcFI0ZTZPb1ZKZjJnbk83N0lSY242?=
 =?utf-8?B?emQ3RkVXaXQ1RXFXNCtlRGpQOU1UZE5iMEs4YnA5YlpkMXROaitJdVJ4Q3Ur?=
 =?utf-8?B?Zmx6NHJWZTRlUjdoaXR6a3QxNFUwMTlyS2FBWFg3eVNYaVUyT2drbDc0M2t0?=
 =?utf-8?B?dmZ4dUlHS0Jvc3FDSENVeXVCNXFLTWxTS0lIR3dFTmZRWFZHR0lBaWMxaHZT?=
 =?utf-8?B?TVp4WHpNZHZ0NmRCVHVoaXJ2TkdlZDM3WkRxK0JucHJWQnRtUktReCtSNzN5?=
 =?utf-8?B?bVBnbURBYzRXdnh1dmIxRFFYRnpNN0orNWV0OTB3MUxxb0h5Y1BIZWdvSTFM?=
 =?utf-8?B?aU5mTWFsOWdqQkJzamtuS3dqb0JOc0ticWpaWlV6cEZVbGtsNzVyZk91bFlO?=
 =?utf-8?B?SlB5SGtrWFI3MHF3WjRvMnVVWkN5ZXBaMVZsazZxRVduV3QyckJVb2ZGUEFr?=
 =?utf-8?B?QWVhcy90eURXMU1oNmNYMGJZL2IzSnBIclZCandhVnA0bkt5YlFPbnY0dHlY?=
 =?utf-8?B?UWoxSTJQZlVRUFkxbTVuNEtBVzg4VVFYWmdzUGl4WDBicFlqaXY2eEFVRkV6?=
 =?utf-8?B?TTNFN1hObEhXS1FKWlJLbDdCdjlkbExWSHdiVzg1V0V2VDlZTDZiTExtSlAy?=
 =?utf-8?B?WG5SMDhIWmpyS3Z1dDJuTVlaOERCSXBTazVOTXZoMFE0UXVlaGZPQ1FNM1NY?=
 =?utf-8?B?MWc0KzAvNDRjTkQwajhNU2I2cEVuMGxodkM5cTJpbGVBaldsZzRjQnZYS3pX?=
 =?utf-8?B?azJSY00zc1ZjS1h2Y1g5Ylg3NmIyZHhXcFFHR2d2dzZXTENzcnVNRmhlSGRT?=
 =?utf-8?B?NGkrQVJTbDd6eE51blUzbk4zQ0pXTnNzY0VaQnNjaWE2K0ZWRlNlSGViYnhD?=
 =?utf-8?B?OHU5bm1tblNIcEg4cGdLdUNRSkRhMStNOUJLR0d4a3haeHFOTUVuTDBwNURI?=
 =?utf-8?B?OGUyUEhaaVhOa3J2U1JGdTZkZ0wzalN4cTM1T3loczliUytXdDFVOFQvSGtw?=
 =?utf-8?B?dGh5Qm9wU3BPNzBuOVJnbWJDYlFCOFN2V0QxVlZPemcvbTlEdkNJbmRyRm1G?=
 =?utf-8?B?YWxFaWJYNEx1VW9RbDk5QzFtN2tCd2wwK2VxNmcxc1FNUVI3Z0swYU9PZmh3?=
 =?utf-8?B?WmJpQTlDeTVYMnZwNlV5dUVlTVJGVnVMMGxxL1ByTTNOOTJEUE54bExBbWNH?=
 =?utf-8?B?b0JBeGlXaSt5eWtYSDFzSFpvNWRVVDNOUTdObEhSZmhmWlYzc1AzLzRWaDJJ?=
 =?utf-8?B?YndFK295bWxZYUJYbUZqZFdIcGYxa3AvZXBPdmV4ejlDRU1oVGFDTnJhN0lj?=
 =?utf-8?B?eWFNb3ZGbEZ0ZXNpWDBPUUM0UmFMWGVHck1wYmVhczVqWHNoa0tQQmpLS1ZQ?=
 =?utf-8?B?akc2ZmNoRitFdEl1akVjeEorVjV4SjV6RW1iREllME5kQ3JrcFNvYlM4a2JK?=
 =?utf-8?B?ZHZva3ZFT1RlRlh1Q09uazVNb25FbVV4dzBBL05RNk53dVhmaldNWldEb0JB?=
 =?utf-8?B?NkpLUFh1QWd6cHhlcytYY1lZY1FHYkFkT0Q5UU11QmRFU2YwS0pweGJGRDlC?=
 =?utf-8?B?VTNqZTQ4aG9jVWo3L0ZYS2thTTlNZG9DUUt4WkhQeXdVOTk4L1ZxK3hSTTVn?=
 =?utf-8?B?RXRJbjdxOEpVNlBGRXA0ZFZWcXZzNUgzYlpRWDRWODB4MzExSDRXRmQ1RXNa?=
 =?utf-8?B?bTBVQ2R3NzFzVnFKWmsyelhMaTBRSzY3dXhRN0RLYnFMRkc0elo1VVg5YjZ3?=
 =?utf-8?B?MWd5akxic1FrWGZzS2tHREJ6TG4wMVZFN1dnSllucERBR0JWS2VDamVGZlNZ?=
 =?utf-8?B?MTdaTlBQaUNnQ2VKeXZ5aVhwMGlEb2FSdDE0YlBGNWR0Mi82SlJBMTdiOWR6?=
 =?utf-8?B?TkNzdnRtVjhRRzV3TVowSEtJUFFxUVNockV3LzhoNVNYWWdkNUZmdGM0ODRm?=
 =?utf-8?B?RzJQY1BmeWdQTThnbUNTZkpaRzJ5dk9YZU9vU2MwUWl5ZTVMR1d6aTAyenRx?=
 =?utf-8?B?cGNlN1BjZXhKc2FTSVRuc3FFbGVSb2ZwdTVFM3ZwSDQ1dkU3RWoxVnBLQUo0?=
 =?utf-8?B?ZjFZdC95NjRGeVAxL2krOTlMR2Zlb1VZbndDdk5ubzkwZzJiMGxzUjl2anRs?=
 =?utf-8?B?WVcxVGpUNTc2SnlCcVVMVFFNaW16MkpiMWUzV2pHTkN2enk0OW90WlBpVUFm?=
 =?utf-8?Q?v4msFtny4JNKDotM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 10aab239-8576-4b1c-88e2-08da23a73f77
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 14:57:26.0936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2jFVEAKNmu2kEbFUslcUjsLxzTrM82yk9SytwiYTP1iFFTdQpuj/xeQN1YE18dQUYPO8RIpGaqLKBmu7hP9vAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2724
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
> The only user wants to get a pointer to the struct iommu_group associated
> with the VFIO group file being used. 

Not native speaker, but above line is a little bit difficlut to interpret.

"What user wants is to get a pointer to the struct iommu_group associated
with the VFIO group file being used."

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> Instead of returning the group ID
> then searching sysfs for that string just directly return the iommu_group
> pointer already held by the vfio_group struct.
> 
> It already has a safe lifetime due to the struct file kref, the vfio_group
> and thus the iommu_group cannot be destroyed while the group file is open.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/vfio.c  | 21 ++++++++++++++-------
>   include/linux/vfio.h |  2 +-
>   virt/kvm/vfio.c      | 37 ++++++++++++-------------------------
>   3 files changed, 27 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index a4555014bd1e72..3444d36714e933 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1919,10 +1919,7 @@ static const struct file_operations vfio_device_fops = {
>    * increments the container user counter to prevent
>    * the VFIO group from disposal before KVM exits.
>    *
> - * 3. The external user calls vfio_external_user_iommu_id()
> - * to know an IOMMU ID.
> - *
> - * 4. When the external KVM finishes, it calls
> + * 3. When the external KVM finishes, it calls
>    * vfio_group_put_external_user() to release the VFIO group.
>    * This call decrements the container user counter.
>    */
> @@ -2001,11 +1998,21 @@ bool vfio_external_group_match_file(struct vfio_group *test_group,
>   }
>   EXPORT_SYMBOL_GPL(vfio_external_group_match_file);
>   
> -int vfio_external_user_iommu_id(struct vfio_group *group)
> +/**
> + * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
> + * @file: VFIO group file
> + *
> + * The returned iommu_group is valid as long as a ref is held on the file.
> + */
> +struct iommu_group *vfio_file_iommu_group(struct file *file)
>   {
> -	return iommu_group_id(group->iommu_group);
> +	struct vfio_group *group = file->private_data;
> +
> +	if (file->f_op != &vfio_group_fops)
> +		return NULL;
> +	return group->iommu_group;
>   }
> -EXPORT_SYMBOL_GPL(vfio_external_user_iommu_id);
> +EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
>   
>   long vfio_external_check_extension(struct vfio_group *group, unsigned long arg)
>   {
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 66dda06ec42d1b..8b53fd9920d24a 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -144,7 +144,7 @@ extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
>   								*dev);
>   extern bool vfio_external_group_match_file(struct vfio_group *group,
>   					   struct file *filep);
> -extern int vfio_external_user_iommu_id(struct vfio_group *group);
> +extern struct iommu_group *vfio_file_iommu_group(struct file *file);
>   extern long vfio_external_check_extension(struct vfio_group *group,
>   					  unsigned long arg);
>   
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 07ee54a62b560d..1655d3aebd16b4 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -108,43 +108,31 @@ static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
>   }
>   
>   #ifdef CONFIG_SPAPR_TCE_IOMMU
> -static int kvm_vfio_external_user_iommu_id(struct vfio_group *vfio_group)
> +static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
>   {
> -	int (*fn)(struct vfio_group *);
> -	int ret = -EINVAL;
> +	struct iommu_group *(*fn)(struct file *file);
> +	struct iommu_group *ret;
>   
> -	fn = symbol_get(vfio_external_user_iommu_id);
> +	fn = symbol_get(vfio_file_iommu_group);
>   	if (!fn)
> -		return ret;
> +		return NULL;
>   
> -	ret = fn(vfio_group);
> +	ret = fn(file);
>   
> -	symbol_put(vfio_external_user_iommu_id);
> +	symbol_put(vfio_file_iommu_group);
>   
>   	return ret;
>   }
>   
> -static struct iommu_group *kvm_vfio_group_get_iommu_group(
> -		struct vfio_group *group)
> -{
> -	int group_id = kvm_vfio_external_user_iommu_id(group);
> -
> -	if (group_id < 0)
> -		return NULL;
> -
> -	return iommu_group_get_by_id(group_id);
> -}
> -
>   static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
> -		struct vfio_group *vfio_group)
> +					     struct kvm_vfio_group *kvg)
>   {
> -	struct iommu_group *grp = kvm_vfio_group_get_iommu_group(vfio_group);
> +	struct iommu_group *grp = kvm_vfio_file_iommu_group(kvg->file);
>   
>   	if (WARN_ON_ONCE(!grp))
>   		return;
>   
>   	kvm_spapr_tce_release_iommu_group(kvm, grp);
> -	iommu_group_put(grp);
>   }
>   #endif
>   
> @@ -258,7 +246,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
>   		list_del(&kvg->node);
>   		kvm_arch_end_assignment(dev->kvm);
>   #ifdef CONFIG_SPAPR_TCE_IOMMU
> -		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
> +		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
>   #endif
>   		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
>   		kvm_vfio_group_put_external_user(kvg->vfio_group);
> @@ -304,7 +292,7 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
>   		if (kvg->file != f.file)
>   			continue;
>   
> -		grp = kvm_vfio_group_get_iommu_group(kvg->vfio_group);
> +		grp = kvm_vfio_file_iommu_group(kvg->file);
>   		if (WARN_ON_ONCE(!grp)) {
>   			ret = -EIO;
>   			goto err_fdput;
> @@ -312,7 +300,6 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
>   
>   		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
>   						       grp);
> -		iommu_group_put(grp);
>   		break;
>   	}
>   
> @@ -386,7 +373,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
>   
>   	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
>   #ifdef CONFIG_SPAPR_TCE_IOMMU
> -		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
> +		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
>   #endif
>   		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
>   		kvm_vfio_group_put_external_user(kvg->vfio_group);

-- 
Regards,
Yi Liu
