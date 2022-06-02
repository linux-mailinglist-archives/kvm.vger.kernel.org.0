Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397E653BE53
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238331AbiFBTDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238319AbiFBTDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:03:47 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57F45F5B;
        Thu,  2 Jun 2022 12:03:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCZuR7hcX7Y7gKVFnSVVTExLeuNc0z5UK5iT/uAraysfPw3nlg4Katj+a0mHJKllav6lE7k31rHZ7h6aQN3caUe/gq0bLaAebm5jFD8UFEo7bTuCOvPKNlLN7V5vN/FeyNx4WvFfmAYCpI5n81jihMJOAoTTEtiVPSXOXZf0qh/03YfWEWJUjloHdrMpBBf+d84sxoRYpbGOwprYao+oOpOLIkeDnhhlanVqZRtQqnrdxN82dWeHmnFdWOExMKjpkia9CoKQpJu5kZGVAw8pEyVXtQO+KZ3ve3/LInDmRQhwFF91HKwdYw/7XKXQplef9oXKYG6yrusb6lAOqQ/kUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H49gJ+Tvqsbow5JnQM7xl+KNZNVqSZYuHGp3MtHP/b0=;
 b=c+lTWYBoG2Os2Lyu0NWbMFhyvy4joV4dMGbAs+JRoexLEJwuVm2qYgQeZ5dRCS1oLwDT72zL7A9Ko76PkRU9iwtAU4ac2xNHYGYljQp2wrT+ncR9e4v1x9L+oYQbt1aK4DV9RYO/hQTfIC0qlKyYHxllpIt+LCv+IoY/Bo7XIy6NezNHKkiud4x0255OMNFpn0XJXmM77DbY88jG3S41dxeYM5GWKAjwLUTRAsI3YUMhiUSJ4lt4NR9OODQaJc2jqudekAEZG+zmbNglQFPLtQFe7vdAgbLuzSDlcBcwqII4flH1lTMdzbLo/NBYklk/KSA3rpWmBDMUcwfcqnZddA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H49gJ+Tvqsbow5JnQM7xl+KNZNVqSZYuHGp3MtHP/b0=;
 b=fz4+XDKrLfPXJUsGNvO9i0eRj3sqf8N1yahl4u3rpMnFMQ2OcOjYycAt6EXgIS2hrnbCltE4cltJIdkX0NeQZIwHR/P0V9xKmRMyw9EClRbMljCc03dApZTl43xjJqNRyOH//7iVbsApQ2mJrkwc0eVxxQBXYSIgvN5+CK+6KmGYNAug1xICvsbPI+gUZjLKCxSQ2GHCz9RFoLn3Fgz8kRMFOgXIPurR+2IcAFgDoItS/Rio6+jAXTMN72iUhYwS3raAcz7K/fC8ixX2MeGb/km+tRszJBir8v46zK8/5SBtGVb4aIbX0LU8vQgBWq2ytrEqiu5X7o+ghY1Lzk2wOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB2662.namprd12.prod.outlook.com (2603:10b6:a03:61::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Thu, 2 Jun
 2022 19:03:44 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 19:03:44 +0000
Date:   Thu, 2 Jun 2022 16:03:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 07/18] vfio/ccw: Flatten MDEV device (un)register
Message-ID: <20220602190342.GD3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-8-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-8-farman@linux.ibm.com>
X-ClientProxiedBy: BL0PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:207:3c::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3b35a7e-5684-4992-43c9-08da44ca9d6b
X-MS-TrafficTypeDiagnostic: BYAPR12MB2662:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB26626796781D5D2E541B3CF4C2DE9@BYAPR12MB2662.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: itHl+uRfjOM/bWksSj2ndOM4Yi3P5jnfSchQcvXeYn0GMeJ8bBqLTxOOQW+KwSL8zQqLbJx/4WDLMDKOcPsgaElWDOu2R7HGPChfDLWFtuuXgT9KFFB/eejUDEiR1xe3lrMLEuUgSkdRzjMEI0ioFH+kfbqGD/aqzdXhgDql57vUAviiUo1tyOLDbHK7tM7PCuBKw6WykjYhiev6Qh/DQrTBYgOyBX/hWpgaZQAn1m6dNpXuYq+hbsOz3iwDK4AIDKID3zNr904kr5oObVjJnuSKoK8ElCxJOPKg1LP+S9irfjam6ViPI12V8F0VjJ0HD0XyDRcQOGNkvgD4oYe9u+COiBdb8f3B2SZN/PPuEz+ltdQy5ddb8AmwWZWnjEO3dzUWdkqwwOqAT+aC+io5fHLp5272IbbRysvW2c0d7oqVMIGwXKPvNoC+noEKkcEIiMpXko0TK6Ntc4G+gceru3+AT1D7oNX3Fqsh5NHgmQwhJ3Aeor2MRXbeBoyOJHyLO6erMzbFf+OcIYN3Q/daNkJnOvWlFwyIdx6nMDfpn4PXYdjPyehe7zuk0IlovKbodZf9O6kP4uYPaja9AOhRC+SOFSl6L9r5w6Bvazu4DWYxw7qfzZrEsCKmZQsp14IuaP5lDr56JnLNSstlt89ueQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(54906003)(6916009)(26005)(86362001)(4326008)(66556008)(33656002)(4744005)(316002)(2906002)(5660300002)(83380400001)(66476007)(66946007)(38100700002)(1076003)(8936002)(186003)(508600001)(36756003)(6486002)(6506007)(6512007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DyGoYLpbdh60xKynJRUnY1FbCZF3hILov0Z4kWgZRAODWEV2mv0Lx6r7HXdD?=
 =?us-ascii?Q?7yg5cecrx7q8rx73S6IJDXsmS2kjH6y5EOOBBf4wYV5n/Fi+Yyz7XShKtEwE?=
 =?us-ascii?Q?WbVB+nDsFxyfCDxtYmOkhFGHI+3is8u/ryVgx19/enGZgjuPYgMLxuBCW8la?=
 =?us-ascii?Q?xOsQGyG8E6U8/LWBg/Ljwvt6Xw5H4YbYcMUYjQsMBPqjh5NzK7+mwe27q7aS?=
 =?us-ascii?Q?2SsO+ADaFOj48Z3AqSgc3BN6eW5iS4qEBrmiyMsKgmc+mALo7c2lpzIw7Z1s?=
 =?us-ascii?Q?QMruyUoa67vj9vHe3MDEFsoACMuqBwrdKwIKQBkeGtqnc5VxKjkG+b+hd0OD?=
 =?us-ascii?Q?nUkkLuaE6C+o1gOGL++ov5hCb7glRVNMM/hn77xrXEJWR1oX0ctbLK8kB7rk?=
 =?us-ascii?Q?/FCxZXFrjqfhzLifc9uTDQOlo0XYvy4EyiM6oDLLVempDmxb+XO1ueHNIUeP?=
 =?us-ascii?Q?RZ+crgM+JsCt+jBcnV1up2NsWypez/S/IA6HVHWWns02PfUv+rUQmTMzQBoY?=
 =?us-ascii?Q?S3srh7eKlTEx2+06zmNKVi+igbk4Hbrxt6ZlCcsadzrlN38zy2Iz6PKhVO6/?=
 =?us-ascii?Q?QRT8Vg3cRO9PVWZLxmuMOmWmEFd9FNa1ZP0m1NsjIYHgV6S/eqfAtCJeO/51?=
 =?us-ascii?Q?l5RWvBatRE0UZklEW4anKnYaB7CEEsDpgrI4ckH2iF9/AYRgJ1oDgDFEkZ/l?=
 =?us-ascii?Q?Z3pELj6sv0TlzQMt10eBqu2ah82M20T4p491Ph1hCi5+O/v0nqT7jnOcYp2c?=
 =?us-ascii?Q?HfXEbiYv7iFp2c7DCAN7qy4bnmP15T654zsaZW+sGu9qEVb09Q24mdmyWbR4?=
 =?us-ascii?Q?V9fIEJzcjbT+5ehldxa/SW6WiMz2AVwbzTdLNl9fgs8cO52toj45E3G4qR2r?=
 =?us-ascii?Q?qVz0SoNCZlgSNcCcxMEpQP06Quo+VPKTdNfxG+L/NJohuBtvJahIVih9canj?=
 =?us-ascii?Q?XSOXf3BeV3MnrXShgA9PjBji28awvaXuVEhLFhOlKd1F9Eaz6dYvhFm2zT1G?=
 =?us-ascii?Q?aNqJqAU9obvyyzfGA4QeD5H46x/LrVWOCBhMSL+DyGUDd6qVMCcEmuslYGng?=
 =?us-ascii?Q?1OdAxpI0FY4MHPeZeEihFQHWsnGAtUgyeRw0V3+17xYvNQll74Mz5QEIH5rj?=
 =?us-ascii?Q?KFRxtOypyl4vfJ5viJdMm+SlSuz66YvkIo9IzjbL5AdAZhibww0srQ7fGuGQ?=
 =?us-ascii?Q?BEJNsy5DlfZpdlr2ysWf61riF8mY5Z5BydOydtb7XK3quLocdbzTUuMDd/wz?=
 =?us-ascii?Q?NByb6cjC+s0QgmScVQ0kTXkdJkGqNJf9MY5mbVq9QIhEm7lxcR2iEDR3NJjB?=
 =?us-ascii?Q?wPH1XbnmZg90vslm+0kR0AjQf/bCwOxL6HQb4k7N6eBiiQAcO9Rj1fkWhkfg?=
 =?us-ascii?Q?StBxq/hkFwl0suhay8LRdv+VVWGnboS5/lkFfFbeBPSMhokHN1QU2Esukzr6?=
 =?us-ascii?Q?+i5Hxk1HAP2PWuvB1Wo6qWmLfknOzoDZw41Q+bgQV1ZGDFYlyQ2OykReBHWw?=
 =?us-ascii?Q?VUpNoQdpbNeLP4JkE0LPFQ63ViSfDZ+JGIpZ7ZsrKJJDA3vrdBn9ETLVwLiQ?=
 =?us-ascii?Q?hDOetGetK0I4n9QfEmahaxQGjRCqh7lTlDxmpW4hZF06XV7roP3zTJp8Qtih?=
 =?us-ascii?Q?RRXCF2gkBoIozv4h9CvmJsA5qXC6/z5H6364f5raHzIVsV6c8x2puhFEyLCf?=
 =?us-ascii?Q?JXAfkPBBQ1rvMumf/3PuQiYRFjo/jADQZ+PWrHiz8ORqfnC+qtd+Aao6snw5?=
 =?us-ascii?Q?hux5fOGghQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b35a7e-5684-4992-43c9-08da44ca9d6b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:03:44.2418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KmoD/J+54N+lgvrgLqMuPXX4we8hgyq76Eb6rjTT9i4EtGw9FrvYzltFZ/TTZ1YI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2662
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:37PM +0200, Eric Farman wrote:
> The vfio_ccw_mdev_(un)reg routines are merely vfio-ccw routines that
> pass control to mdev_(un)register_device. Since there's only one
> caller of each, let's just call the mdev routines directly.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c     |  4 ++--
>  drivers/s390/cio/vfio_ccw_ops.c     | 12 +-----------
>  drivers/s390/cio/vfio_ccw_private.h |  4 +---
>  3 files changed, 4 insertions(+), 16 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
