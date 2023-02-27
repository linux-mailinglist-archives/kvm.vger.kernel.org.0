Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185976A4A4A
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjB0Ss1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjB0Ss0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:48:26 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B311F18B38;
        Mon, 27 Feb 2023 10:48:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSmnq3OOqOBqf7k8yOhrcHqQ5VNQLcJg6qQJ5aZL/SogvpqM+7Zei4CUuVn0dpL0syywz92Qj37sCdBWS1aWx6WiRT29IkzMdWR6qvFT0gIVy5BeGjB6T32aHOVFNszSeaY5n8GwcNzEaUQVmr7uUXQ7kXDM5iaEzna6g160xJuaILkYMaGr5R6RZdRYIJXPSr0jtYBXKW2tEH2jTbNNkFbvcFFMcqNUuEPtmO/nQpJcD4B49y+HSGRx94cdZ+8beZwkZhCHicHqftRsErHmgRPZWDwwUptiRuv58UFkRZm1Ip2rydir95nT4uteY/VeUOqiIHRTyBtQqHIKNN3exg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VyltJaFmsA8HuOHjqSzbRnNFwBfzpiSVcPU+lGBD0MI=;
 b=LiLQfdcrIYsUFInOukFD6fBZiCwP6w5invCN9/HM7pP7oJnhnC7p8xV/CnmPt80i0TCxSQ/NQKYjs02vBRW7RkIuBv4ljLSR430esGw2oJLrWkSyXTUXx8l9rp5XXB49jsiLDOeq4JrhpYTn0Zrj435pwylYAJMEyJVjn10Z5PeIcUI3iq9piwzQKh0O/eDPii4b9ZPXj7ugtfrnYEypSnbZeav0vSAbGwCrLUaTke2vEiADxDNs3vH+x8pxzIlVRXyNIF8841dgl0INo5Rk4Gwam2xNYvS8x0kXF5I72RQI9FfSjQU7TvEFuMOD6QOt85LSGrS9fdhZ+DXgAZYeFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VyltJaFmsA8HuOHjqSzbRnNFwBfzpiSVcPU+lGBD0MI=;
 b=EMA93+KEMjZjo4Rnc8S2CXVvvSqLgi/no7dF8WxiELvOhncpp4Rxt3HRHzP0UV0IO+FZXWM2X9LcV1bNHjRxK/qWK1j7fF7qf7mIyLedKyv+nI0UmG5F/KBWCi9KazDayAOusRCSSkHZiIp53w1kbNcMysyRzkn64hZ5ApSn+23+SmJHFXZRBLZfRPBpx+KNThcF3+u1+dirkbZc72lWLIW/Zakc43d1r+drXez5fT9WK6b1gM6xclCqMKyFc5ys2q/HqAhvRmozMNu8PUpfzHEk9Uz3Gd+O6tVszlhuid2CNQf2PSZD4E9ismhrl9uLBjuDsnwrY7SEOuvCYTueXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB7950.namprd12.prod.outlook.com (2603:10b6:806:31c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Mon, 27 Feb
 2023 18:48:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:48:23 +0000
Date:   Mon, 27 Feb 2023 14:48:21 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 08/19] vfio/pci: Update comment around group_fd get in
 vfio_pci_ioctl_pci_hot_reset()
Message-ID: <Y/z69VIQW1rWPweB@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-9-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-9-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:208:120::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e590d6e-8c5d-4a21-5ce5-08db18f333ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZTThui5HGZytbVoS+ehZx1XHfyj2tzfxKGGmbi7Y2UtSXKoutlnoS+6lK+g16aW1zF5zIr3p8txURJnWmC7u4l8sNEN6CGBMP7oBuWjIXv+WoK3WoNEPaG5LWZjs+wBPe+KjNF+cELCN90W/RCF9qw+W0U3TNMe+hEo7uGb4ca16oOfYJpa2pLykBxhMHaJt1IlwPsrlgkoK8wfvf7xQrMCQGujYZBDY8zlQE/BE1aEe4tNM1OxU2ccZ5fIxxJoOjOIhNUsJOc3XCDAf4Stnmed/PjNAo7ZhHLQisvoYYl4rkTEXtP4hy3F04iXjLKy+8GSFxU1DMQjXlQckty6zdHkM3/eCf/xZpiSe18ejTOSTWLPdN/FeTgWbX1I8ZxFST3LT3u0T36p7eaimRA6R3z6Rqm1me8HSlqph/b50WEBX0ydMsHwCtrV7jScKy+7fqv/pbZvhlyVtTA9cQ72uPWVNjrLJ9RmvBtOHb4A5rLM0kJIw0XD5wASLwrfU3dhqLgGj93ZV/sLi9liXPeF5BHPsSv2PTRH6SRgenDucYQWxPQbmArfm3c1Dl7uHu07enfRis5z929Z7wIRI0pPHNb+T2WxP18DkbtmWLsb7y5U2y2bu5ITelGRU/kA7hRzPoIjv4sELChd/ycqh98yoEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199018)(6486002)(316002)(7416002)(8936002)(5660300002)(66556008)(6506007)(478600001)(6916009)(4744005)(26005)(186003)(2616005)(6512007)(2906002)(38100700002)(41300700001)(8676002)(86362001)(83380400001)(36756003)(4326008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3zFHhQUjHedjAOxrFizTkHJfPJG1buXuSkDNB22MvUpW/2ECF0t7S9Aj0dlO?=
 =?us-ascii?Q?Hj+942EjkqCDOD6LyaRb40f0/PUer1csG0xwUXa9DbaBCm6dDDyUbMFOMEIf?=
 =?us-ascii?Q?2ctCWvBNowFVbb5jUlOIhySUM6oPQwBCloI7Gke8sKm/kXhTwNPslFg+iiWI?=
 =?us-ascii?Q?2tGzuE0y3Pi1bN0J6yfVTCSubPIKXj3w6gRabwQQLN8OfMdOqMLpjCvA2W+7?=
 =?us-ascii?Q?ShltIPpnwGYySIDdWU1mCtVlFhZR/MjxwSwYE5vuqGkDa+GjBV7C+M2h8lTM?=
 =?us-ascii?Q?HXLd8I8o8Ojh9X77i/nVbMDr0HFYx/2635DdhIGOCq6mKysmAejWwwZoX+pm?=
 =?us-ascii?Q?4/RqxcMoKJSYCrooxsclj0qNuhhbmus7PkFmkdnEPN75rfWSdMdqQLvxp+uP?=
 =?us-ascii?Q?G5LaZQasukmGsWxYqahMQ71XhUmGdPmSWmGnxP8L1rGp8VMbt0lsjN+9NHNF?=
 =?us-ascii?Q?ZcCLBMyJb/JtYA5ELpYgVz2qM6QsZ+NlEZvsNSkVZmB5gxZwT+I30jkq0ayl?=
 =?us-ascii?Q?uSQs59z56IxWB98AOknXNF9iVUgu44qdUQGHvbYIjJacBMR8c5Ze4VloIQ1b?=
 =?us-ascii?Q?wKr6eOejxwE9CcD5xDF9yIcCQJfNm3zVaL3oUCjnuYCrMWt8MN0j740LmA3o?=
 =?us-ascii?Q?Q5myCWohokPuRaZtUbB1LAY80LZ0jEX0t23SQezLLEsL+cr+nmoKVEMWaY7V?=
 =?us-ascii?Q?/VkcbIn1ZjIPGFAODoSovVYVmATLXmBB+KcvJ90YTyoARjzqseiE+n6AO6zp?=
 =?us-ascii?Q?qPlyes+oCDNy3Di12eGHEHEAHdFoOuY4ncTz9r+K+XwDH9q7AWFqlpK7+U4y?=
 =?us-ascii?Q?wdH5S5OvTiaJDjNvuGpKBWIaq0taeUk3i/zTs7YkED651F6npM0wnKqmummm?=
 =?us-ascii?Q?jTj+eJ99kHnhhQqpIbWYvKSzotPd7rKMOIYIbAEpM5TZuJAvF4UmLhWhA6Yp?=
 =?us-ascii?Q?SzkP7gp7MT0YN2J6hnk0H+GlxUUNWcvDUMkdypJRGoiwxGbdqTLImeH1MqYc?=
 =?us-ascii?Q?lym41jVFFR/XHxMicMAi7enfhMoMkOu/SZtNcLNOHupiWDZPaBRFdQjRR1BB?=
 =?us-ascii?Q?kBSD9ji4EkdThLbM3+GkLdMpVQvzQ7TINJLuMpbcFHYpl/hWuYySNsgeiHl8?=
 =?us-ascii?Q?y3u7+0H1gYw0c8bvONbRWJajmavAef+bWjScAUG06S7giVA+2dgVtIkIUuY7?=
 =?us-ascii?Q?PRmN/xbMMj/5o1PNDqISLwMezaggzveP6n8XaBKjYhlQldm06T7MVzAxivaR?=
 =?us-ascii?Q?kcpF3LHTt6nglqIlyqrCXRsW97rpLKdFKHKmkwaljbguLsJEnoMr6hyGi5M2?=
 =?us-ascii?Q?fJPDdUl0/8c6dgfzJZ3Ssc0SOkTAqFtzIXL86JPZ7WNjTyESOLQ5fKTsBMdk?=
 =?us-ascii?Q?E/xA+rnXo79r3EglikDs469px5SyvjPmY/FJDmx+0VN1ZSKi455RCTZiNow+?=
 =?us-ascii?Q?Up2H5SCc0ybSeigTdnMCnuOOlN9TXI+Vi6Id4quNZt7RdkyXjj1ftHCRTMzk?=
 =?us-ascii?Q?yIGVuI/ivCw2UgFCnM6uadHHLcO+nrpa4to/wKZ8mcDvWJfcKQiWK+HjDbVK?=
 =?us-ascii?Q?UMMB7tQgme5/dD2Sf5MQoEXNGxZzv5Qg7X71qVxz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e590d6e-8c5d-4a21-5ce5-08db18f333ba
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:48:22.9059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jc9Uaak7cLZ+/3hSlayEqCsq2aeyql4Ys9I/QzPBGRk0zSALzynQvAIqo/bn3Keu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7950
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:24AM -0800, Yi Liu wrote:
> this suits more on what the code does.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
