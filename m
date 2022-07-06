Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF75568973
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 15:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbiGFNaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 09:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbiGFNaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 09:30:03 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130DB2314F;
        Wed,  6 Jul 2022 06:29:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2xw1NsqCxE//Jz01TbTXpWWhRKIabs2+PtbjAooBKtJgby/qkTubF7TvpaD3GD6F0a6WTZIeJheQHnGpbFcu79tbmzdIKQeeWbQuc7XMmdh9kPm+Dms9nzZD1sOtCay88l/Eylzd/DTEl41XskxoxINyAfJgYeXBDpirg9ICPvaHiNdAS39yAGtyS2cq+cA48n4iB5hIvS99nQYrIbMQMqoN9WmGwASX/+Uk9toiwsMcZb1bCgM0vZMES4+8Kyv+YgBBer/YWjEiY4h1IkNcntElexia3l2d+w3D4U0Rs9vGY/BHdhNMtJztwLUAn5Q96H6/DZpT69SDn3Q6YRsWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68TiFIPfSNO/15syNSHK8PEO5oflnKQi8v4oWkOy51k=;
 b=BxrLN0S6aolX12dyUP1XxxeIRf1Po91x0wEFU0VL+q/hI/r3AaqsIIEc+KR1sNTPfx/de/6paWCSf/jP5CM7tA0LAZIyLrQ43JKyfqexKz1BI7/+jtBWRvazTCtRvuCwRWj0oOGxmSfy5OdD9dChLgMicPEKgHf+2JtAAgVomA8VI+QomAiouvlM/eg/SOAZh85GnI6/qX1Dzc5HWUk5KZ3/lTIZYuo3tjauB0Jiz0BCAjtWp2BWfBUl0TOxmwuM1T+efdxWhdMuRk4HLFUdMjZiE+hsP2ZB1vrc4iGf+A40pKqaoxSsGBx2m37LghFbWoJRMRNXglWP5aUunC4FUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68TiFIPfSNO/15syNSHK8PEO5oflnKQi8v4oWkOy51k=;
 b=pBpYivrMXucP8oFUUXx7efcG3SepwzkLWnZmKfwoV0PiLy4zylgjb/6ePJgMnm0Mn/Lk504cIVQpTO6q3N1TTQPyF1NjuZXAZ6VLfg5SFQ2axnapEF17pbMohLPy3k/VImLl7Bp/g9vdvf5FtVAgXCzzR3FxiP7e1hS+DoZfLqry/v3FB3Q8doiXE1lNKPdSbE5JmwlYyHS36qsuuaikclSzwDMOgwCj/Uyb9koJnaYAvTT2U79JEb5nUbS8aLOPmov5z+UXRxcoMPKKl1N6wguJS8HDSABu5rnTpPasNQo9bDyH/4dsdjAcqwHenyXWLFw66yoq2v6pQsK/ZVUlig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by BN6PR12MB1249.namprd12.prod.outlook.com (2603:10b6:404:1d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Wed, 6 Jul
 2022 13:29:55 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::e16c:261d:891d:676c]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::e16c:261d:891d:676c%3]) with mapi id 15.20.5395.022; Wed, 6 Jul 2022
 13:29:55 +0000
Message-ID: <6017460d-d7e8-9155-0e5a-fb13a51ee1c4@nvidia.com>
Date:   Wed, 6 Jul 2022 18:59:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 04/15] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Shounak Deshpande <shdeshpande@nvidia.com>,
        Neo Jia <cjia@nvidia.com>
References: <20220706074219.3614-1-hch@lst.de>
 <20220706074219.3614-5-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220706074219.3614-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0054.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::6) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf7b1062-23d7-4556-acee-08da5f539cee
X-MS-TrafficTypeDiagnostic: BN6PR12MB1249:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NhpDrlrTUzAZMT+bQEkg10Bb/d0OTMgkX9ORX93SqeiR4wvEi4NrFeAuMxBrdCf1Yhtyxj2MQV1O8ExbNdZxCACaUAXV2iVRf0cv4rkCIaI74KuNwGVcNqnCGAp6/fCxDO//xt8tjSzV3JqzSlg4Qw1qt5EdQFCCI+geF3dtE2ccgQcG7sZYOQkD2i5GUdPqtzzSrQYCNihnzRUxRJvs5wGzHBS59t8v72VCJwyT/61YtZ3lIsk/FCVxgn6kC/O8Ie4sjL4wECp4RJebpk2ko3r8K8+c7bINBpXINUgP9R6bFutwodjCes06k8j684lR3KyHsPKMxi/a6G+lDfDN8RzWhRBayYpVWijOvS/TxsQxm0RIm+rBzP+4GeBFJQPnZjZrwEAJS8W02D1ESbQOTrzbRhq6fp2Zfr7clU8Fkrxxk0vIzBnQ3H9rICKw2KQD64z/FVTwlBZyRo9NEE9dm0sMCnF6tmFaQc0q9OI0EHgRSGDPBF1cVTQba6XdwMZwvGYWcazI1VuzeiL9zChFZgVsEd8ZA7SSUpC61hevdfeZpc4cXz6jS1K+Z/BlhHQ4xRL7BlDzy9QK/gMKTghos+DacGvIiJxiggvRPbPGgeofnP6oKH6UuogGWfhnfb63qd0GGh3p57jldnEmyuKmHmoRjDSUh1oWAUIKZDJk4t01sLr1IHimUrRWnPseKglZ22nyfYyb2R+Rj8ZzGbtPOMLWMuM4zjKoZA4KWrMrKfJJcwI1EyrRV2rhgjdlJZneCkk5C6nVBtxBmCtr8VIkDRqWsPwbUHNknwUxnHcv9UcmwXRyMur+Ars0ei4qqbkFZUhKi5x1WDR+MxyVy00eH9NTXFhUay/MUEuvvbCXSmc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(107886003)(186003)(2616005)(38100700002)(36756003)(316002)(54906003)(31686004)(8676002)(4326008)(83380400001)(110136005)(66946007)(66556008)(66476007)(6486002)(53546011)(55236004)(5660300002)(8936002)(31696002)(86362001)(6506007)(30864003)(7416002)(478600001)(26005)(6512007)(41300700001)(2906002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YSt6eXNwN0VFL0EyYmMwREFtcjQxQmNSN0ppaVFuc1ZMcjdWZzVQa245dXBC?=
 =?utf-8?B?MWxGbVV3ZERRMVkvV1ZIbWFrYWJXSitQQkxtWTRlUDVjMmlxUUtxdUx2OVBV?=
 =?utf-8?B?SERWYUJZS3B0TUFLZUVZWGVDQ3VhaEJCZnBENlA5YmZRUXhYazZjNDhicjF4?=
 =?utf-8?B?MXpYY01yelJoYy9ySFZTakFvWG1WdGFhNW9LZ3ovOTJlU3FYaXJ0V3o2TGJQ?=
 =?utf-8?B?WFNhajBvUFRKNVpzSGNCSG1vNkVnVFZxbmpiNFZaK2luMzdmZUx0blhHTmdx?=
 =?utf-8?B?Sms1dlRUdS84UFYrMzlRSFQzYlFJQitCQXVpMnJ4enUxOGlndnI3M3k3a1pU?=
 =?utf-8?B?cEl1eVF0R250a3pPT1o4SGNzbDZEa1VqU2U0WllUY1RXQzR5bXFYNzU5bS80?=
 =?utf-8?B?dDlncm5FeXlKMXlsdzNVcDAwWW1LMElsNW1MU3ZIdSt2ODhYejJDdUZXaGd3?=
 =?utf-8?B?WDFGcjdXNHVEM293TGRaamZNTDJuZk1OQTBJY3VjdnllQjJnRWlEZllXd09U?=
 =?utf-8?B?UUdyUHJWZ3VsaFA2Umwyd2hlL1RjVE1nVHdaMlVFekNyZTBIdTk4TTQ3OEgw?=
 =?utf-8?B?R1ZDNll4VjNYV0x3clJYSnlyUytzcWRUekQ4NlZINk0xNkFYSDVYdDYvcE9K?=
 =?utf-8?B?ZG0yVEdEbUl2bmpYemFXUERwZUJXbDNFblhndnRIYzhjdFdkY3lOOStQN0tv?=
 =?utf-8?B?aTB4Q1dMdnpmUzlKb2p3MlBqNnZ3M1VacHhZVW9KYjdVNHd1TW5McEpscFpJ?=
 =?utf-8?B?TjlBenNFMHlDcFJ4aFdBRkRFZ3dsQUxIZzBjSVZlQzFwczlPNGdpZDk0MkZN?=
 =?utf-8?B?WHN0Wm1NLzdmekhsWnFPM0c1dkMxNmpKN0UxWlM4Z0FmVU0vQ00rbk5QbXN6?=
 =?utf-8?B?bWE2ZmtvVnh3U0RIeGpVS0dWMmMzZFJVTVdIbUF0OGZhTmZUYnRLUkNmUmpu?=
 =?utf-8?B?WmZMV0M5WmNRVEpNbTY3ZlJ4VHoxNW96YVdEcmtTMkhURzU5TjFGTG1zUFdV?=
 =?utf-8?B?OWFPN2xYTU1EaE1EM240Vm5jVjlLeDBnTGQvS0ZsTEdTWisrZE8zZ0J5aGdz?=
 =?utf-8?B?SHhOUC9ycS9scnJrYUZPcDNFTmxwSHArNG1XYVdyVjVJSmdBNzJiMVhYcTN3?=
 =?utf-8?B?MHRwMjIrbndCYXc1SXN5V1BNUFI1TUtrL0FYUlBWcnAyK2NDdzRIWDIxK1Ba?=
 =?utf-8?B?b29Ea1BQMytPL1E1cUpJSDhaUC9ZYVhFYXV5MVd5UkFnT3R0b3lPS1NHN3JT?=
 =?utf-8?B?TUpGYmlJVHFRVWhpbFJ4OW4zWWlUa3VRNFlIT1NZZDFwOXRGcmQ3S3dwenVK?=
 =?utf-8?B?My8rTDZYSGw3K0hRN2tYOGwxVzVzQ0g1NzY1RjgwdmtVMWZObUV6Qy9aNllq?=
 =?utf-8?B?V1BLbXhrbWZhY3U5YW8wTllrNEU1a2F1WGZmOHlVRmFnelk4TFltR0tmS1g5?=
 =?utf-8?B?bTlxQlZWVGRWdnQzUWVmY2pVbDBwcDRtUWpiOU5CSENCbmMzVExxanpTZmZl?=
 =?utf-8?B?RWZnNTNVYzNrcm5ZMS9BQkQ3Z3NiZWpadmVwdW4wVnQ4bFBsdXFacnQvTkJz?=
 =?utf-8?B?blN0MjZtZ3c2SThjeFhybHY2a2R2dTJMVm00YVdFZWVoTmYydDd3RnNJNmF1?=
 =?utf-8?B?ZHY2YmN6MGF5OG9HV1pNeGN4eWZyOUFjMUVXWVMxTldRdXZ5WFlYdkwrc1dw?=
 =?utf-8?B?K0NTOTB4NWs3WVdSaTZvT3I3YUZaZEhRTE1zM3lWbVRGQUtXVzQ5WmM3bVZJ?=
 =?utf-8?B?dDJMUXN4R1ZYdnUxNGFjSDRzclpiOHVDV2pSVzEzR1RRSkpqYVBPKzVoSkF4?=
 =?utf-8?B?bzloeUorcjJzb0NISGt0Z3cyaUJrb1NlUVZOYnpWYWJWSE1tYnFFN21ETkZv?=
 =?utf-8?B?N2VFSWlPZ3dIOFpCaW5GcUhXdEpJRlpKY1NqVnFMeHErVXZsb3VVQmF0VlFM?=
 =?utf-8?B?V3pvRVR4emRFZys5dGN0SlRCdFhyUmtaS3pGVVp1MEdFb1l0Y2pSZUttdkkx?=
 =?utf-8?B?dExqWi9CY2RDM2VMVEFJY1R0VkhkeStBUnpoZ3NUSE1zSzdMWEhBektMM29P?=
 =?utf-8?B?T0JkV216UUxKa1B6aXhzVTBLeUVrU0VXQk5nSVJJb0xjRWdjUjIyQlJqeHFL?=
 =?utf-8?Q?z13lJoGrJP2xkpVPFDiCyQorR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7b1062-23d7-4556-acee-08da5f539cee
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 13:29:54.9607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UpLFaIvsLl4V0JuYcDHlAmgNQyLoMivJs4eVuaynk3T2Xp3RAtt1rfGm+Lpe1vOObfkim7utb0z7lTnX0tlpsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1249
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>


On 7/6/2022 1:12 PM, Christoph Hellwig wrote:
> Simplify mdev_{un}register_device by requiring the caller to pass in
> a structure allocate as part of the parent device structure.  This
> removes the need for a list of parents and the separate mdev_parent
> refcount as we can simplify rely on the reference to the parent device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   .../driver-api/vfio-mediated-device.rst       |  12 +-
>   Documentation/s390/vfio-ap.rst                |   2 +-
>   Documentation/s390/vfio-ccw.rst               |   2 +-
>   drivers/gpu/drm/i915/gvt/gvt.h                |   2 +
>   drivers/gpu/drm/i915/gvt/kvmgt.c              |   5 +-
>   drivers/s390/cio/cio.h                        |   2 +
>   drivers/s390/cio/vfio_ccw_ops.c               |   6 +-
>   drivers/s390/crypto/vfio_ap_ops.c             |   5 +-
>   drivers/s390/crypto/vfio_ap_private.h         |   1 +
>   drivers/vfio/mdev/mdev_core.c                 | 120 ++++--------------
>   drivers/vfio/mdev/mdev_private.h              |  23 ----
>   drivers/vfio/mdev/mdev_sysfs.c                |   4 +-
>   include/linux/mdev.h                          |  15 ++-
>   samples/vfio-mdev/mbochs.c                    |   5 +-
>   samples/vfio-mdev/mdpy.c                      |   5 +-
>   samples/vfio-mdev/mtty.c                      |   6 +-
>   16 files changed, 69 insertions(+), 146 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index 1c57815619fdf..62a82afce161b 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -60,19 +60,19 @@ devices as examples, as these devices are the first devices to use this module::
>        |  MDEV CORE    |
>        |   MODULE      |
>        |   mdev.ko     |
> -     | +-----------+ |  mdev_register_device() +--------------+
> +     | +-----------+ |  mdev_register_parent() +--------------+
>        | |           | +<------------------------+              |
>        | |           | |                         |  nvidia.ko   |<-> physical
>        | |           | +------------------------>+              |    device
>        | |           | |        callbacks        +--------------+
>        | | Physical  | |
> -     | |  device   | |  mdev_register_device() +--------------+
> +     | |  device   | |  mdev_register_parent() +--------------+
>        | | interface | |<------------------------+              |
>        | |           | |                         |  i915.ko     |<-> physical
>        | |           | +------------------------>+              |    device
>        | |           | |        callbacks        +--------------+
>        | |           | |
> -     | |           | |  mdev_register_device() +--------------+
> +     | |           | |  mdev_register_parent() +--------------+
>        | |           | +<------------------------+              |
>        | |           | |                         | ccw_device.ko|<-> physical
>        | |           | +------------------------>+              |    device
> @@ -127,8 +127,8 @@ vfio_device_ops.
>   When a driver wants to add the GUID creation sysfs to an existing device it has
>   probe'd to then it should call::
>   
> -    int mdev_register_device(struct device *dev,
> -                             struct mdev_driver *mdev_driver);
> +    int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> +			struct mdev_driver *mdev_driver);
>   
>   This will provide the 'mdev_supported_types/XX/create' files which can then be
>   used to trigger the creation of a mdev_device. The created mdev_device will be
> @@ -136,7 +136,7 @@ attached to the specified driver.
>   
>   When the driver needs to remove itself it calls::
>   
> -    void mdev_unregister_device(struct device *dev);
> +    void mdev_unregister_parent(struct mdev_parent *parent);
>   
>   Which will unbind and destroy all the created mdevs and remove the sysfs files.
>   
> diff --git a/Documentation/s390/vfio-ap.rst b/Documentation/s390/vfio-ap.rst
> index f57ae621f33e8..37e16158c7fbf 100644
> --- a/Documentation/s390/vfio-ap.rst
> +++ b/Documentation/s390/vfio-ap.rst
> @@ -299,7 +299,7 @@ of the VFIO AP mediated matrix device driver::
>      |  MDEV CORE  |
>      |   MODULE    |
>      |   mdev.ko   |
> -   | +---------+ | mdev_register_device() +--------------+
> +   | +---------+ | mdev_register_parent() +--------------+
>      | |Physical | +<-----------------------+              |
>      | | device  | |                        |  vfio_ap.ko  |<-> matrix
>      | |interface| +----------------------->+              |    device
> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
> index 8aad08a8b8a50..ea928a3806f43 100644
> --- a/Documentation/s390/vfio-ccw.rst
> +++ b/Documentation/s390/vfio-ccw.rst
> @@ -156,7 +156,7 @@ Below is a high Level block diagram::
>    |  MDEV CORE  |
>    |   MODULE    |
>    |   mdev.ko   |
> - | +---------+ | mdev_register_device() +--------------+
> + | +---------+ | mdev_register_parent() +--------------+
>    | |Physical | +<-----------------------+              |
>    | | device  | |                        |  vfio_ccw.ko |<-> subchannel
>    | |interface| +----------------------->+              |     device
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
> index 392c2ad49d376..bbf0116671ecb 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -36,6 +36,7 @@
>   #include <uapi/linux/pci_regs.h>
>   #include <linux/kvm_host.h>
>   #include <linux/vfio.h>
> +#include <linux/mdev.h>
>   
>   #include "i915_drv.h"
>   #include "intel_gvt.h"
> @@ -338,6 +339,7 @@ struct intel_gvt {
>   	struct intel_gvt_workload_scheduler scheduler;
>   	struct notifier_block shadow_ctx_notifier_block[I915_NUM_ENGINES];
>   	DECLARE_HASHTABLE(cmd_table, GVT_CMD_HASH_BITS);
> +	struct mdev_parent parent;
>   	struct intel_vgpu_type *types;
>   	unsigned int num_types;
>   	struct intel_vgpu *idle_vgpu;
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 85e1393d8e55c..e9dba4c0fe6b5 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1958,7 +1958,7 @@ static void intel_gvt_clean_device(struct drm_i915_private *i915)
>   	if (drm_WARN_ON(&i915->drm, !gvt))
>   		return;
>   
> -	mdev_unregister_device(i915->drm.dev);
> +	mdev_unregister_parent(&gvt->parent);
>   	intel_gvt_cleanup_vgpu_type_groups(gvt);
>   	intel_gvt_destroy_idle_vgpu(gvt->idle_vgpu);
>   	intel_gvt_clean_vgpu_types(gvt);
> @@ -2063,7 +2063,8 @@ static int intel_gvt_init_device(struct drm_i915_private *i915)
>   	if (ret)
>   		goto out_destroy_idle_vgpu;
>   
> -	ret = mdev_register_device(i915->drm.dev, &intel_vgpu_mdev_driver);
> +	ret = mdev_register_parent(&gvt->parent, i915->drm.dev,
> +				   &intel_vgpu_mdev_driver);
>   	if (ret)
>   		goto out_cleanup_vgpu_type_groups;
>   
> diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
> index fa8df50bb49e3..22be5ac7d23c1 100644
> --- a/drivers/s390/cio/cio.h
> +++ b/drivers/s390/cio/cio.h
> @@ -5,6 +5,7 @@
>   #include <linux/mutex.h>
>   #include <linux/device.h>
>   #include <linux/mod_devicetable.h>
> +#include <linux/mdev.h>
>   #include <asm/chpid.h>
>   #include <asm/cio.h>
>   #include <asm/fcx.h>
> @@ -108,6 +109,7 @@ struct subchannel {
>   	 * frees it.  Use driver_set_override() to set or clear it.
>   	 */
>   	const char *driver_override;
> +	struct mdev_parent parent;
>   } __attribute__ ((aligned(8)));
>   
>   DECLARE_PER_CPU_ALIGNED(struct irb, cio_irb);
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index b49e2e9db2dc6..9192a21085ce4 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -11,7 +11,6 @@
>    */
>   
>   #include <linux/vfio.h>
> -#include <linux/mdev.h>
>   #include <linux/nospec.h>
>   #include <linux/slab.h>
>   
> @@ -660,10 +659,11 @@ struct mdev_driver vfio_ccw_mdev_driver = {
>   
>   int vfio_ccw_mdev_reg(struct subchannel *sch)
>   {
> -	return mdev_register_device(&sch->dev, &vfio_ccw_mdev_driver);
> +	return mdev_register_parent(&sch->parent, &sch->dev,
> +				    &vfio_ccw_mdev_driver);
>   }
>   
>   void vfio_ccw_mdev_unreg(struct subchannel *sch)
>   {
> -	mdev_unregister_device(&sch->dev);
> +	mdev_unregister_parent(&sch->parent);
>   }
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index a7d2a95796d36..834945150dc9f 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1485,7 +1485,8 @@ int vfio_ap_mdev_register(void)
>   	if (ret)
>   		return ret;
>   
> -	ret = mdev_register_device(&matrix_dev->device, &vfio_ap_matrix_driver);
> +	ret = mdev_register_parent(&matrix_dev->parent, &matrix_dev->device,
> +				   &vfio_ap_matrix_driver);
>   	if (ret)
>   		goto err_driver;
>   	return 0;
> @@ -1497,6 +1498,6 @@ int vfio_ap_mdev_register(void)
>   
>   void vfio_ap_mdev_unregister(void)
>   {
> -	mdev_unregister_device(&matrix_dev->device);
> +	mdev_unregister_parent(&matrix_dev->parent);
>   	mdev_unregister_driver(&vfio_ap_matrix_driver);
>   }
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 6616aa83347ad..0191f6bc973a4 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -45,6 +45,7 @@ struct ap_matrix_dev {
>   	struct list_head mdev_list;
>   	struct mutex lock;
>   	struct ap_driver  *vfio_ap_drv;
> +	struct mdev_parent parent;
>   };
>   
>   extern struct ap_matrix_dev *matrix_dev;
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 2c32923fbad27..fa05ac3396950 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -18,8 +18,6 @@
>   #define DRIVER_AUTHOR		"NVIDIA Corporation"
>   #define DRIVER_DESC		"Mediated device Core Driver"
>   
> -static LIST_HEAD(parent_list);
> -static DEFINE_MUTEX(parent_list_lock);
>   static struct class_compat *mdev_bus_compat_class;
>   
>   static LIST_HEAD(mdev_list);
> @@ -61,28 +59,6 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype)
>   }
>   EXPORT_SYMBOL(mtype_get_parent_dev);
>   
> -/* Should be called holding parent_list_lock */
> -static struct mdev_parent *__find_parent_device(struct device *dev)
> -{
> -	struct mdev_parent *parent;
> -
> -	list_for_each_entry(parent, &parent_list, next) {
> -		if (parent->dev == dev)
> -			return parent;
> -	}
> -	return NULL;
> -}
> -
> -void mdev_release_parent(struct kref *kref)
> -{
> -	struct mdev_parent *parent = container_of(kref, struct mdev_parent,
> -						  ref);
> -	struct device *dev = parent->dev;
> -
> -	kfree(parent);
> -	put_device(dev);
> -}
> -
>   /* Caller must hold parent unreg_sem read or write lock */
>   static void mdev_device_remove_common(struct mdev_device *mdev)
>   {
> @@ -105,125 +81,73 @@ static int mdev_device_remove_cb(struct device *dev, void *data)
>   }
>   
>   /*
> - * mdev_register_device : Register a device
> + * mdev_register_parent: Register a device as parent for mdevs
> + * @parent: parent structure registered
>    * @dev: device structure representing parent device.
>    * @mdev_driver: Device driver to bind to the newly created mdev
>    *
> - * Add device to list of registered parent devices.
> + * Registers the @parent stucture as a parent for mdev types and thus mdev
> + * devices.  The caller needs to hold a reference on @dev that must not be
> + * released until after the call to mdev_unregister_parent().
> + *
>    * Returns a negative value on error, otherwise 0.
>    */
> -int mdev_register_device(struct device *dev, struct mdev_driver *mdev_driver)
> +int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> +		struct mdev_driver *mdev_driver)
>   {
> -	int ret;
> -	struct mdev_parent *parent;
>   	char *env_string = "MDEV_STATE=registered";
>   	char *envp[] = { env_string, NULL };
> +	int ret;
>   
>   	/* check for mandatory ops */
>   	if (!mdev_driver->supported_type_groups)
>   		return -EINVAL;
>   
> -	dev = get_device(dev);
> -	if (!dev)
> -		return -EINVAL;
> -
> -	mutex_lock(&parent_list_lock);
> -
> -	/* Check for duplicate */
> -	parent = __find_parent_device(dev);
> -	if (parent) {
> -		parent = NULL;
> -		ret = -EEXIST;
> -		goto add_dev_err;
> -	}
> -
> -	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
> -	if (!parent) {
> -		ret = -ENOMEM;
> -		goto add_dev_err;
> -	}
> -
> -	kref_init(&parent->ref);
> +	memset(parent, 0, sizeof(*parent));
>   	init_rwsem(&parent->unreg_sem);
> -
>   	parent->dev = dev;
>   	parent->mdev_driver = mdev_driver;
>   
>   	if (!mdev_bus_compat_class) {
>   		mdev_bus_compat_class = class_compat_register("mdev_bus");
> -		if (!mdev_bus_compat_class) {
> -			ret = -ENOMEM;
> -			goto add_dev_err;
> -		}
> +		if (!mdev_bus_compat_class)
> +			return -ENOMEM;
>   	}
>   
>   	ret = parent_create_sysfs_files(parent);
>   	if (ret)
> -		goto add_dev_err;
> +		return ret;
>   
>   	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
>   	if (ret)
>   		dev_warn(dev, "Failed to create compatibility class link\n");
>   
> -	list_add(&parent->next, &parent_list);
> -	mutex_unlock(&parent_list_lock);
> -
>   	dev_info(dev, "MDEV: Registered\n");
>   	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> -
>   	return 0;
> -
> -add_dev_err:
> -	mutex_unlock(&parent_list_lock);
> -	if (parent)
> -		mdev_put_parent(parent);
> -	else
> -		put_device(dev);
> -	return ret;
>   }
> -EXPORT_SYMBOL(mdev_register_device);
> +EXPORT_SYMBOL(mdev_register_parent);
>   
>   /*
> - * mdev_unregister_device : Unregister a parent device
> - * @dev: device structure representing parent device.
> - *
> - * Remove device from list of registered parent devices. Give a chance to free
> - * existing mediated devices for given device.
> + * mdev_unregister_parent : Unregister a parent device
> + * @parent: parent structure to unregister
>    */
> -
> -void mdev_unregister_device(struct device *dev)
> +void mdev_unregister_parent(struct mdev_parent *parent)
>   {
> -	struct mdev_parent *parent;
>   	char *env_string = "MDEV_STATE=unregistered";
>   	char *envp[] = { env_string, NULL };
>   
> -	mutex_lock(&parent_list_lock);
> -	parent = __find_parent_device(dev);
> -
> -	if (!parent) {
> -		mutex_unlock(&parent_list_lock);
> -		return;
> -	}
> -	dev_info(dev, "MDEV: Unregistering\n");
> -
> -	list_del(&parent->next);
> -	mutex_unlock(&parent_list_lock);
> +	dev_info(parent->dev, "MDEV: Unregistering\n");
>   
>   	down_write(&parent->unreg_sem);
> -
> -	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> -
> -	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> -
> +	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
> +	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
>   	parent_remove_sysfs_files(parent);
>   	up_write(&parent->unreg_sem);
>   
> -	mdev_put_parent(parent);
> -
> -	/* We still have the caller's reference to use for the uevent */
> -	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> +	kobject_uevent_env(&parent->dev->kobj, KOBJ_CHANGE, envp);
>   }
> -EXPORT_SYMBOL(mdev_unregister_device);
> +EXPORT_SYMBOL(mdev_unregister_parent);
>   
>   static void mdev_device_release(struct device *dev)
>   {
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 7c9fc79f3d838..297f911fdc890 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -13,17 +13,6 @@
>   int  mdev_bus_register(void);
>   void mdev_bus_unregister(void);
>   
> -struct mdev_parent {
> -	struct device *dev;
> -	struct mdev_driver *mdev_driver;
> -	struct kref ref;
> -	struct list_head next;
> -	struct kset *mdev_types_kset;
> -	struct list_head type_list;
> -	/* Synchronize device creation/removal with parent unregistration */
> -	struct rw_semaphore unreg_sem;
> -};
> -
>   struct mdev_type {
>   	struct kobject kobj;
>   	struct kobject *devices_kobj;
> @@ -48,16 +37,4 @@ void mdev_remove_sysfs_files(struct mdev_device *mdev);
>   int mdev_device_create(struct mdev_type *kobj, const guid_t *uuid);
>   int  mdev_device_remove(struct mdev_device *dev);
>   
> -void mdev_release_parent(struct kref *kref);
> -
> -static inline void mdev_get_parent(struct mdev_parent *parent)
> -{
> -	kref_get(&parent->ref);
> -}
> -
> -static inline void mdev_put_parent(struct mdev_parent *parent)
> -{
> -	kref_put(&parent->ref, mdev_release_parent);
> -}
> -
>   #endif /* MDEV_PRIVATE_H */
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 4bfbf49aaa66a..b71ffc5594870 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -81,7 +81,7 @@ static void mdev_type_release(struct kobject *kobj)
>   
>   	pr_debug("Releasing group %s\n", kobj->name);
>   	/* Pairs with the get in add_mdev_supported_type() */
> -	mdev_put_parent(type->parent);
> +	put_device(type->parent->dev);
>   	kfree(type);
>   }
>   
> @@ -110,7 +110,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>   	type->kobj.kset = parent->mdev_types_kset;
>   	type->parent = parent;
>   	/* Pairs with the put in mdev_type_release() */
> -	mdev_get_parent(parent);
> +	get_device(parent->dev);
>   	type->type_group_id = type_group_id;
>   
>   	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 555c1d015b5f0..327ce3e5c6b5f 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -23,6 +23,16 @@ struct mdev_device {
>   	bool active;
>   };
>   
> +/* embedded into the struct device that the mdev devices hang off */
> +struct mdev_parent {
> +	struct device *dev;
> +	struct mdev_driver *mdev_driver;
> +	struct kset *mdev_types_kset;
> +	struct list_head type_list;
> +	/* Synchronize device creation/removal with parent unregistration */
> +	struct rw_semaphore unreg_sem;
> +};
> +
>   static inline struct mdev_device *to_mdev_device(struct device *dev)
>   {
>   	return container_of(dev, struct mdev_device, dev);
> @@ -75,8 +85,9 @@ static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
>   
>   extern struct bus_type mdev_bus_type;
>   
> -int mdev_register_device(struct device *dev, struct mdev_driver *mdev_driver);
> -void mdev_unregister_device(struct device *dev);
> +int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> +		struct mdev_driver *mdev_driver);
> +void mdev_unregister_parent(struct mdev_parent *parent);
>   
>   int mdev_register_driver(struct mdev_driver *drv);
>   void mdev_unregister_driver(struct mdev_driver *drv);
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index d0d1bb7747240..30b3643b3b389 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -128,6 +128,7 @@ static dev_t		mbochs_devt;
>   static struct class	*mbochs_class;
>   static struct cdev	mbochs_cdev;
>   static struct device	mbochs_dev;
> +static struct mdev_parent mbochs_parent;
>   static atomic_t mbochs_avail_mbytes;
>   static const struct vfio_device_ops mbochs_dev_ops;
>   
> @@ -1456,7 +1457,7 @@ static int __init mbochs_dev_init(void)
>   	if (ret)
>   		goto err_class;
>   
> -	ret = mdev_register_device(&mbochs_dev, &mbochs_driver);
> +	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver);
>   	if (ret)
>   		goto err_device;
>   
> @@ -1477,7 +1478,7 @@ static int __init mbochs_dev_init(void)
>   static void __exit mbochs_dev_exit(void)
>   {
>   	mbochs_dev.bus = NULL;
> -	mdev_unregister_device(&mbochs_dev);
> +	mdev_unregister_parent(&mbochs_parent);
>   
>   	device_unregister(&mbochs_dev);
>   	mdev_unregister_driver(&mbochs_driver);
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 0c4ca1f4be7ed..132bb055628a6 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -83,6 +83,7 @@ static dev_t		mdpy_devt;
>   static struct class	*mdpy_class;
>   static struct cdev	mdpy_cdev;
>   static struct device	mdpy_dev;
> +static struct mdev_parent mdpy_parent;
>   static u32		mdpy_count;
>   static const struct vfio_device_ops mdpy_dev_ops;
>   
> @@ -765,7 +766,7 @@ static int __init mdpy_dev_init(void)
>   	if (ret)
>   		goto err_class;
>   
> -	ret = mdev_register_device(&mdpy_dev, &mdpy_driver);
> +	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver);
>   	if (ret)
>   		goto err_device;
>   
> @@ -786,7 +787,7 @@ static int __init mdpy_dev_init(void)
>   static void __exit mdpy_dev_exit(void)
>   {
>   	mdpy_dev.bus = NULL;
> -	mdev_unregister_device(&mdpy_dev);
> +	mdev_unregister_parent(&mdpy_parent);
>   
>   	device_unregister(&mdpy_dev);
>   	mdev_unregister_driver(&mdpy_driver);
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 4f5a6f2d3629d..8ba5f6084a093 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -72,6 +72,7 @@ static struct mtty_dev {
>   	struct cdev	vd_cdev;
>   	struct idr	vd_idr;
>   	struct device	dev;
> +	struct mdev_parent parent;
>   } mtty_dev;
>   
>   struct mdev_region_info {
> @@ -1350,7 +1351,8 @@ static int __init mtty_dev_init(void)
>   	if (ret)
>   		goto err_class;
>   
> -	ret = mdev_register_device(&mtty_dev.dev, &mtty_driver);
> +	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
> +				   &mtty_driver);
>   	if (ret)
>   		goto err_device;
>   	return 0;
> @@ -1370,7 +1372,7 @@ static int __init mtty_dev_init(void)
>   static void __exit mtty_dev_exit(void)
>   {
>   	mtty_dev.dev.bus = NULL;
> -	mdev_unregister_device(&mtty_dev.dev);
> +	mdev_unregister_parent(&mtty_dev.parent);
>   
>   	device_unregister(&mtty_dev.dev);
>   	idr_destroy(&mtty_dev.vd_idr);
