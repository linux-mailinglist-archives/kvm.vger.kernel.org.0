Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88131558ADB
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 23:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiFWViF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 17:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiFWVh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 17:37:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A731036;
        Thu, 23 Jun 2022 14:37:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJvCq3HSnZ01SA+Xt1hLGTCgY1PIGFZ5twxw6zqs1Hpuc2k69UkxabF2YKuKEgMFV8iAQ0XeBH9ZuMt0fc1G4hCc/pXa+8gni0YkEagvB5HlZcmHldPwtyJ8W2ioUtwQIimHTIYEfMSk7MlvIXCNUUpTo+aa7GjpOClWGPTdw8n0qcL+i5DA1XTwjhPNaECdjU/nIDr6a+OGwmJ7FbsJ+tyjAnTZOuqj9oka1a7B3SlIMPUVAZd3jYConUBI6/nkaCPiFiSXBfl8tIKCUy8Xd7B/r0XfI3j1RYAfZxMEr9/efYlUcB/k4ivsnEzlxXxxApC3y8nHWd7i7aXsa8Wh+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wHRZnfYJP2uQ5SD8sfT6YfF2Ht2bFznXmjUK8+kJ51I=;
 b=jUTuC15I2sGg0wQW2YSBItaUoHpQqyJIYOAsezRrVmWjOBKHUWUwis2N8GG1TG5/5yMY6o8PMDAY8KUGWuiUIMOv+EvKACICqGIgT7oOqJyKv8p/Mr7BQzskbgodsNFXIM7APl1rs3NP/gq3orWdepaZeCuTLNixMlZoC79q6fb/BoC96bQIXZ4sAnqjCIIREV8ZGVQXqVnWSpuWVBtlX8pUYD8NXskLy8L5aqXcSK0LaAIcIKVXaqs/JNfKJgwuCHrqCKJoAycAmhYWArhC27p7pbIgwQTNT0+xqTZ1dJWQ4RZd3oanymalSzkURAhHlO9h8XfqSThxxFrNOcab8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHRZnfYJP2uQ5SD8sfT6YfF2Ht2bFznXmjUK8+kJ51I=;
 b=QpqcvC3zPjVSONhyKNHKMSGGaBNRfNn/9Pb+ooSQhD90KKI+ef6sTQ9m8js0w6RNwpcOg9IZviGcrVK2HyfXrUsRxMtceSVQ3t8RNqu87nPMftxwFKbiAmjpFYV0WZbNdnxhIs5u5gaLDNcSm0OUAW0TGiinGN2Px3PPYIv47Jpa3cuAzH/lTIgGQa+PEtcVXph5vt23bdFQlW886LXYaZruXMrpMf4a1YVZKn4VNix/pHO2GA9I+fsRqkTXQaWs7zvwz36UKoGvFlKYXxhcrtgSnaV2d96do6WZh00cefD+34Nj6gDdaVV8ITQRN3iCs614W9ODDNJkSVQLxTZ8bg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN7PR12MB2802.namprd12.prod.outlook.com (2603:10b6:408:25::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Thu, 23 Jun
 2022 21:37:53 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 21:37:53 +0000
Date:   Thu, 23 Jun 2022 18:37:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 12/13] vfio/mdev: consolidate all the description sysfs
 into the core code
Message-ID: <20220623213752.GG38911@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-13-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614045428.278494-13-hch@lst.de>
X-ClientProxiedBy: BL1PR13CA0239.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8bbf5eb-1a11-4861-a7ff-08da5560a0fa
X-MS-TrafficTypeDiagnostic: BN7PR12MB2802:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jgJ9EqN6DPVUcxj+z2eKSMO7fYNlSSy9MHJ3R+Z6wCWrVqrdOnPtvGv/9MTiMJsV7bP3diydNlsR2B9aeSkAbepgM3W1uJ1Aeg5gXqQP6IGHrLddTeua73LGudISJH6+MQeROl3UX8IbJZjMUVGcrRXRsOs8QVvWOXJsGeudOGg7QZnIEMjin5pC0da9SGG/gxPGx6drYlZ0QDuA9McNKOaCAXsqkX70LOeyNxOitcZEvf2Rx1Ug3OCzwKfyTWAmVtg3YhxMLaoLCHrKw7wuYCWXxqb31UayE7n729+/TdqVg3RhfUoSH+OBpoTZdaJ/SkBJA+HBDZuPEl5hMg6u8DNeLGmCNal7fY/4rb0oqtq8qrBn/YqADNcv745Y15YQnNvKixTs4KfW8b+4VGW5xnrhfZbf2FkRyF1+oBbligWRqmZTl5kMYexWIkohLCvFB5Wi6ef+VK5moJbpD2IQ98ynhzTmqNLokSspOvdQsXmaae1c7BCFj/B1eHNS8dbTeA4XGcYS/7yT6ADbz2w5YH0d1Qqxp0YYXd/kb5XvfLMRuPZo9PNVRb2YjWoUDlLO+LmigGh7RcGsCPnPVZD4uSixnmAel1ErlxS+0AyQNduOW0EQglG6Rrx2DYc4anHKFY2SE9vHV5CIZUp+k2MqGUmAp0x4MbBALdZloAhK0eDuOOdhZ0GWkj7wZVDxvm/dL2aK83MpbnemXy8v0ZgZsZqFb90uC8NFo10rTjCZHQhqyV69a2WA0aZj01fNAIsk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(478600001)(26005)(1076003)(6512007)(5660300002)(2616005)(6486002)(41300700001)(86362001)(186003)(8936002)(4744005)(2906002)(83380400001)(7416002)(33656002)(38100700002)(8676002)(66556008)(316002)(4326008)(66476007)(66946007)(6916009)(6506007)(36756003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HI1VoRiyfqZcv+3IZ85TUosB4BYc5OVZawfc5JgVSNQnwSoSL/vzinnlJbE1?=
 =?us-ascii?Q?YxVG96Xm2K3lkuRVHKYyIUVaoDEgswza5F5xZ+fZu8tu1H6YV03IlS+09ERJ?=
 =?us-ascii?Q?PPXyw/h51/FLFatMUlXdzByMDdSMkz/pCGT/vphQSRllL3axB71KSOO+FBuT?=
 =?us-ascii?Q?7CGaaC8KFYERMACQxuO8h8QakPfT5VWNZzgksC56DlD1tPxZrVPq07IlO8Vv?=
 =?us-ascii?Q?QyPaAKAup7jY447QCHH7bLMHXFb1i83Z937CewbPFI+JypKGdIMbJai4e+Vm?=
 =?us-ascii?Q?VFtDG/wXXUUvwD4RAnjsV10oyIFyyhiSk0UMHvbQUi6y112oi+Grid/r6M/b?=
 =?us-ascii?Q?tg7Iq4bO/CpOgm+so72z7QZVRkju58Q5OcMItbIIFOW27kb6XxYsD2hldXjV?=
 =?us-ascii?Q?w8fWX3RAyO3q7ELizDf00irNjdiaXLU4m0lrORFYMyvSRfYAET0HNtAIyqyx?=
 =?us-ascii?Q?jOb2htDr2v/EBS6amw++UEmSDn2QHcxZB4UtkUBcgSo5MzaC8ZzapwhEwuq7?=
 =?us-ascii?Q?8ctvPHRsqP06hofjO2iu5rtdAfvzpF3Gbst36nUymBRZb4DhJYoy3LCa/XHq?=
 =?us-ascii?Q?PHsy+r4Qvwo9mfD5Sisuu2xnz6+LYxrn0v/jsCziaid/GHkSGZmhZJpcfV42?=
 =?us-ascii?Q?t32o5Hl5yFWBlKVt4eJI2Nclcr64IyvPdtl/wl9rlcOLqnH/AaAENzxURaDb?=
 =?us-ascii?Q?MCpWRix/yEoIxOc+zV2jT4fjoYtzBhkk6+e55fXTzF80d8PLl3HEYlS2Xb4H?=
 =?us-ascii?Q?7dJP9PPJiqls+QhgETrE4Z55aQxiPk+Z17RtZL4H4NNpX2khOTFYH1dEfuSi?=
 =?us-ascii?Q?Q/Qcy4AK3wS/5e60XZfmnDmvVQnsNmm91Iyw5a5IAOyjrfGV/Dx0KHBognIB?=
 =?us-ascii?Q?CC4eAIXWIcA4iSI2oiBr4dJrH1A4XxBIONFZXmBneaq+UxIXBubO5kH8HFo0?=
 =?us-ascii?Q?LO8JFwb6b9YzAO4UOpS1zIVp+3auLPosBynP1eVXri/FnHSNMUDnisUuQx/B?=
 =?us-ascii?Q?Sq08ubuH43t4txjizQGYu/4phFkkdZkOlBBCmNivqt+fLFDlcWJr7ie6avEd?=
 =?us-ascii?Q?LyijJh7Ukz4eVWrFTxt36j4pNmPvs1/j0y09sggob0850iZTo2SNn3wFtwnz?=
 =?us-ascii?Q?mj8Hcu4gV9zdv2njtkMwuhFJ0f398b0zDpQJJ9YHZDVj5wEsyhvV7TNpTDZA?=
 =?us-ascii?Q?uxPsILns5LAMOuWp3OBGIX9HgHts5L26LqQjcnd/pLrZdNETOv8t7tJByIqD?=
 =?us-ascii?Q?12jS3Xh+gaL5oOgW9mu4s2aoYlzqKojNNfojwTDlLHLx9dafzPP+XgtKYFox?=
 =?us-ascii?Q?HQLsxGPN9thUS3BIGoNuFHdoaKei35bGMxuzbF/9zOJO3M7P9U3mj0bo0jGn?=
 =?us-ascii?Q?iARU3R42OBY4blaPOGdQz+N3K2kIjZMPHmlS3bHrZyenMewx7t1tCmB+2v+D?=
 =?us-ascii?Q?k3x9TxOWMZsAkVaZ2jdk8empmMDUYPUbpUhgHvaabIqtpRO6KIRuzkROWFh3?=
 =?us-ascii?Q?+5WVzQ9qRbmKGKANe8125oJDSs+kjsA5YijetBBdDSirhKaznL3D+Cv4/17g?=
 =?us-ascii?Q?zJduicpuMcT16o1cAU6tXLGlW/kGP0j0FdhVEG/e?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8bbf5eb-1a11-4861-a7ff-08da5560a0fa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 21:37:53.4536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QUCAjAQrVZ0w7PNdKvbnOsjPqQ30zhmSyxvdZyG6044X8VaxV3eMr+A0DTUiXpRE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2802
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 06:54:27AM +0200, Christoph Hellwig wrote:
> Every driver just emits a string, simply add a method to the mdev_driver
> to return it and provide a standard sysfs show function.
> 
> Remove the now unused types_attrs field in struct mdev_driver and the
> support code for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       |  4 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              | 18 +++------
>  drivers/vfio/mdev/mdev_driver.c               |  2 +-
>  drivers/vfio/mdev/mdev_sysfs.c                | 40 +++++++++++++++----
>  include/linux/mdev.h                          | 19 +--------
>  samples/vfio-mdev/mbochs.c                    | 11 +----
>  samples/vfio-mdev/mdpy.c                      | 11 +----
>  7 files changed, 46 insertions(+), 59 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
