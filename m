Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81E565F829
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 01:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbjAFAco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 19:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjAFAcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 19:32:42 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737EE4F12B;
        Thu,  5 Jan 2023 16:32:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYVtJGvOIdrLWm9P4n1StamGMhAV9TgBJcdMzCzgIZJ4D+RhSAI8ptPspJu9PLSTzYzahiFge862xdXgzq8cp9WyI3lq63AugXC7R1194n6sNE5iRdmSNfQkh971me7A3FUiW30ufLSzMxKksrEhDba2Lr1Cml4y+vgwap4+DGrLWj3CK4ODvtpCCGM1jH6UfL8cY1bbKTtBy8CpSl+wmvLeCbp3aJcIOv1oYaLt+w7128swVp6rRwt4WbCpIBecfikXtA9FbnsOH/kN36lcMUv6mfkY84chFb02RoW2C0WXAeLTjmq7F1ogUGDel/3+RqMcc7bffDnGkTRyR1ND1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JE1C8m+1puPeAC/QGsBmdt422vxta/kS6P0eIzS34Ik=;
 b=grA9m76PgBxElSrzcp5Fw+/fHP4VlXowKxKWxGJRlAVXb141W8iNNYMeoqwm9LhxT4RJTq1hf++ODz3gKKxtsJoeUAjNk9xBLiUiUUJD4J5ewQGdCe3CZk/QkRTpmWM0w3x/Zbj0fK7/o2aJA5l3L4tNbd/G5ZOmGftogIxgQ7Eexmud6NQNhCQ+9kOWmNMR3E/luNWV6J1kH/6pR6hjcNiMxL+03zxas2/AwLTaFZ4J2NFBQCeJN5CUbNuq4pIu0U9iU5WZogReSEgpYTc9oL/r6nTIo3pCoA458XPVc4ykX1MbCA85F5zV8jGndKhXUuZ530+11lEcU6JMGUb8Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JE1C8m+1puPeAC/QGsBmdt422vxta/kS6P0eIzS34Ik=;
 b=AUhRN2JYc0NZL6P6vFncgzRLl0nQnc+sJzeuRBd7+uyeVjn6GSwxQ0WgAOBuRnSY+F0tEqVuCQzy3QhI6qNQlGItY0BHxOcRntIjRF/+oAKUuhg8kci9mNgwcb0PpiDk/KQCsX+B7MHrV9WqFfreHIrLI45QI5WdAe/PKsl7QB5KtRAPn8N5uI8NFhKt0szCme5Hv1gWBEmLpehYtagz2E4Leo7akzrIHmUNeZT1igOX/y47TRBxe/+PWcfAXJur3UowM/E/G/723bPMXNUmq4BCq1uYbzOZkwZW9JhZK608Bg8TyzwNWVzimRh7MzJQlqG5ewotRe1XE7il4FY9Yg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 00:32:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 00:32:39 +0000
Date:   Thu, 5 Jan 2023 20:32:38 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        borntraeger@linux.ibm.com, jjherne@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <Y7dsJpudKGtM0kbl@nvidia.com>
References: <20220519183311.582380-1-mjrosato@linux.ibm.com>
 <20220519183311.582380-2-mjrosato@linux.ibm.com>
 <20230105150930.6ee65182.alex.williamson@redhat.com>
 <Y7dehnZSC6ukNxKU@nvidia.com>
 <5e17a35d-2a94-f482-c466-521afcab80b8@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e17a35d-2a94-f482-c466-521afcab80b8@linux.ibm.com>
X-ClientProxiedBy: MN2PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:208:c0::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB7277:EE_
X-MS-Office365-Filtering-Correlation-Id: d9165fed-e082-4219-ea22-08daef7d83e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sYzBr2Y4ZRVb0VIVqfuqNnCslw6bLBr8dcnp57YV2dPdNOGYCn8mfwxM0FWyXprY8e24/RYEfNk2DC0tTWphBWCJQVXqP5A6TbJJJE6gbGnfg5ICRPFdXH5v9yrrGmUJ/bvFi09in8ceHaRX8TqIuRLUwEkR4nA+WwhqLYJYfsFgWEODvZsSBJGcrxkVDWe6Y/TifS3E3bfEYq1+gdAee5UFfvGmOxPQ5vjEnicNby23olASbGYoAwSOSqTS0nSHILWYPivBQAxV70oXfBlKxhua3XJsHEJZcqiek/0uFLWz3F/zVbOSYoB9YhIijBxQ8UMM0YhAjoCotlemVTwD9B3jFjv6xSX1ynb2BMluamDLWH5+pPFGIdJA6nm/3L8wLHKfXUwSeyh6TQngvbGpRPiFvsrrQPOJRQzERS+h6jVMVgyqDuRdbPrP00/vhuSwEozBm89xHHxAgwAtFQZwO6nwkwdX787QzOIOJ+zcQjdn0gijrX+grl7BHBCAPIxPeEN2uUX0GIG4y3s9BKt/z3/2inVxlWrF0qMZRhVNWf8AHqw2PfTquPyCrL6vrXSiWDmNe1SiATudL/aqCtcdUFjQfQtsEujLib1y+VrP+MdmqYBhbWvvXr3hGUNrVVeXj28WlFRzoeupubXnSQDPKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199015)(6916009)(478600001)(36756003)(86362001)(316002)(54906003)(38100700002)(2906002)(6486002)(2616005)(4744005)(6506007)(8936002)(5660300002)(8676002)(4326008)(26005)(66476007)(66946007)(41300700001)(66556008)(6512007)(186003)(7416002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?26hpK6Uh+D/mXJmVkJV4f09PZV/1O/6LgZH+R0ZQ6k4aFudHCcgbJLTPTyTV?=
 =?us-ascii?Q?g5GheyL9qQmtuPSfyyFFOGX+UN+zey4An96daluA2utccOrjRmLqchLCIoWy?=
 =?us-ascii?Q?+NtH1DjUPuWIRwQ2Y5cB+vh6o2LTZbIr1gN38oK2MqwU+clgV63z9SWCAnk6?=
 =?us-ascii?Q?9qhejP3gOjYresdVs97MNFmU/E7iWORo7r1p5bAMRC72k/GFlttSMe9F4BYz?=
 =?us-ascii?Q?QKEAL7pwqwsqycedNpGvuEIhi6SMIEd4CLkv9TKZ3begwaUyOd40vaT2bPQ0?=
 =?us-ascii?Q?VIEaBoljACCJq4w9kwbC+5xMGGmGIwL+9KSxLXmS8tGe93BZYdM9rq8Ues6y?=
 =?us-ascii?Q?3kYVo6LRCoevLyJaoawgEaxbXHaANd7RDq3ONQIyhYzNOk8Voot+Y1nTjXaZ?=
 =?us-ascii?Q?WGIazRUqOPUlcnSrKtUzCPqNu+foq6jMTU0HcjLC+5SR991wDjPIQwqtYe2W?=
 =?us-ascii?Q?BybxCrWT/6c1i0eGToEaFBMjs5rSPZUnCRn+wCkPWamtD/T3zkGf7OLvwZHr?=
 =?us-ascii?Q?C9Gs5JfjZsrLhTwXDTxd3IMKykzeQSUGfvV2qh92RxgJ9jN81ES7bn0RHZmO?=
 =?us-ascii?Q?9UxXYc+xcErw7tmCstrGEdmE1vEfhpz+RB8a7sRLKOfT6yfUPku232NHMmkq?=
 =?us-ascii?Q?PtEIX4G3GdH8ru6JuY04suVmFyvdDpIeI9pXcMqqqsToAHzVVlSwCBtJDvAh?=
 =?us-ascii?Q?hWqRA+wKwywa/VfQF4VcMnVXhw2g1HXsjwlwy4SsH5zP1xQwbJZC6r7yNoj5?=
 =?us-ascii?Q?9VDfLRHrFYxNzVHc3gnxsrI8cViOXt28hw9WY2AGLbM2/hvuTpUZ7unVR5Jx?=
 =?us-ascii?Q?V+a5+f35oqvVLaQp0r3kbCxGRKrtKoO+Jh4ifLWII3JuEJ6MUifAWs2Y/coE?=
 =?us-ascii?Q?ZUXD1uRjPX5xaRRnPnDJXOPvZRtuiRUBDa5F1CFIUzLdCgHW96fXxYahP1SL?=
 =?us-ascii?Q?MHb+KbbtDr0jXjD1mUaEoUVX8gYu3aKaxlcr8/uCUjo9/SLc+Q7vOlZglHcN?=
 =?us-ascii?Q?zdHIEfCj3boZeKEgAcoLA2/Y9d7gxmMU4+1xIuEHUFLxACWAGdiUf8fUjihb?=
 =?us-ascii?Q?i1x/9YJT5Dwa20DOMQxiq+9nQgyBdjpxSQ0VqLL8eIMt90aQgSXgGiwBtFXM?=
 =?us-ascii?Q?VcMl5TMuRwt7isoZDc8UyttrpfIgEycEAuuFWoils4ANVauk/Qes8kYM2+fr?=
 =?us-ascii?Q?pDlWWjc1/wbraM4K5ZHu3vAzqlClvTCIwRiIHQfXg3t4ksd2sXNBQ/NNmUVj?=
 =?us-ascii?Q?BNp7tSJ0wjJsP52/HaoGt3RLWSBOOE4lgwEvjYiHohjvClZfiZNnlR3HmOyT?=
 =?us-ascii?Q?HYSR7xZCbWjoZaLkIFo9/h7nyFNxqx2TLTEKMSPP8Sh6X8v1ZKCjVpxWVOUt?=
 =?us-ascii?Q?KZy/9nb7Mk+14sP1EOtQgsZ34V+MU51ZsX36jIYuv/oE5xjnG7vPyfDuU4te?=
 =?us-ascii?Q?W9RK5dNmqAJn7/wNPH3btlr6st3GpS0zbmKwv0B1tQqupENHslr5Z7nVc/kj?=
 =?us-ascii?Q?OC6HfLB8wOTcY4N+plpq1dwL8E5W8pI5L9zLgWtj7YX8TF+9buLCPyEv2fEq?=
 =?us-ascii?Q?gHDguKel7FK+che8ZMr064f6IODRK8qdNf5DnfhL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9165fed-e082-4219-ea22-08daef7d83e5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 00:32:39.0273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VYped0kScWHy1469deIwyZasLCNYpZLBGlsbpi/obahtM0Dy/t4Zkp6Ptyy9s8EV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7277
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023 at 07:16:37PM -0500, Matthew Rosato wrote:

> Yeah, this is also what I was thinking, replace the direct
> kvm_put_kvm calls with, say, schedule_delayed_work in each driver,
> where the delayed task just does the kvm_put_kvm (along with a brief
> comment explaining why we handle the put asynchronously).

Don't put that in every driver, do something like mmput_async() where
the core code has all of this.

> Other than that..  The goal of this patch originally was to get the
> kvm reference at first open_device and release it with the very last
> close_device, so the only other option I could think of would be to
> take the responsibility back from the vfio drivers and do the
> kvm_get_kvm and kvm_put_kvm directly in vfio_main after dropping the
> (but that would result in some ugly symbol linkage and would acquire
> kvm references that a driver maybe does not care about so I don't
> really like that idea)

And we still have the deadlock problem anyhow..

Jason
 
