Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FE76C20B8
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 20:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjCTTDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 15:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjCTTCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 15:02:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE52F10AA7;
        Mon, 20 Mar 2023 11:55:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dT5lGvscH7xgZoNNfx0G5u0aLaAUF2skVx+RNpYFPtdDDYbJpK0jqytmdmXjHyV3EpXW3+T89zO11hxxm/BzSN+jyHOkekJLLroBg+viwDh1FLu6ymMkC1hQytUwC2X8QbQxSF1hx9e6JPUnWR1MNJAqT/1ugp2VNPXCjei/L7ZO3lukJPc52RGlXTabZ7tAaaBEG5sM2dbzRvjYeYjpHsqWw82l1TD742gzGRfS6ehmt84pzZhJ85A5FQzPYRjbLppG+aZVQvqrXAeljHvfSTeSJvscwOMlKMGoyP1H7t+CarUYb99UWCFntrUht3yx/tnBFr4Q1ibiEQeJv91b3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfAf4qP5Co4sp8aj5O9p6/ASdyDmKkF1l/rF0fr0ZwU=;
 b=B1DRLgW7gdKq3PWUSr//dvi7AKuPqwtEyPpYu1Par9nqaSaAbRc8Nis0Q/U4+rZgcvIJUMvgvyEpnVywpR2vfiQLB2Zg7zSUPemudAkb+dLKLHLuMi15Ni6kddDj6pjh8aMjr51AIi4sdGdrIRsl1HVACYgFYvz1yvlT/pYUChDBgol1+T8V+XdQiaCA44mUdGr9Lbph77Zg464+lyfiZO+PonJ3Qz7keag6ml/cTrUIkhlVbydRZWskOXOGGZWycYR27pgGT9ZyYs53+4nUbbqQrd8QL9Cz6a0Tck2CHic4h+9i1A0FOfD4KIncuvIJdUU+CFwe49KbxpG1kthoIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfAf4qP5Co4sp8aj5O9p6/ASdyDmKkF1l/rF0fr0ZwU=;
 b=A2XEcsJsSjyABN5+gdZkPKNSSPNkxp6Xso5C6+4OLrYryCfX4mSFPKwmtgwpcWeE6d7TevPs9MN+lSh71V1Uhe79Ht1A3T7mvHFMPSmjU/jqn50KHzec5QNdhsu6CQ3sdkYLV/WgECbqPWg/JglreFfDjFYlA2Mg6IGTTYG+IFQArE+tp49z+3Kvd77K0xVwAss3tOt6fAU8EcMn3oQSa+2xgmEADSXOJhiSJQU6JQdqSRak1meTTCTXyZ8ip//swfpsL0LCfJ82ojurKDItLk209CEUcKgtCLIx71MoVtHctm+oAUJVVN93JSSBb8jgFVA3uYaKRsSbJw8n7x7PPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB6001.namprd12.prod.outlook.com (2603:10b6:208:37d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 18:54:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 18:54:21 +0000
Date:   Mon, 20 Mar 2023 15:54:19 -0300
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
Subject: Re: [PATCH 2/7] vfio/pci: Only check ownership of opened devices in
 hot reset
Message-ID: <ZBir26zqGG2rCcsK@nvidia.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316124156.12064-3-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0314.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: 696cbcfa-5b17-4a65-c8e5-08db297483e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XiwFOZwE9yHc6IKbrZ5049zpd9ns3RI40KbF/ZBvDTEyTyPDNcDDi6D9TJcSqXslrnBLC5oyWFXRyzIy952zEJ2sjBoPGows4iWxAEPHyQ69BTzco8ZEW8dk38Gh23KKR+PhOePj7vX+DgYP0X5h3mRZ4mvJX87Rqd7JeNbnhQdBTvaSr/r8+OJgZbcC11P40LNW6MFDbQzgF34NQr0MHzSKzBtPZVenOqiEBsnIiSBAeTeWJzvwr1LMPnin6a9YfAydp/6Jo2ZDMv4/Ah3dbFHknNePuaCzfEZCm+H8Gou2CENjwEZYKG82aC6fMWgw18N0ZrsGApS8yahsjCWffFAmTaJZmwzG26mzRF4fUvxPYz+oeF/eb/JJolzuE1wW366WKjaE5DuDibNremojLvAQRG1LsqXGNAZGcpy1yqJ2Vl5+DIoDY7ol3FSYaYXJdMVEd+Jjh1TwgMIUIDY1KEJrDOq1fG5nuvyvIOiUbdtL7v0rxxDuqNl6Tbkhcj/l7wqNkpFGf18pyXzbSolVWUkMWgY21xc/ySPDHKPuqej0KG8uH9FHHu3Y5jkwHUtVKc6QzdQeYavD53UzJVxQDESkZfSt7+7a6rGKblwktdBdKc6AKnA/IfvCajLDN7DSUxpRHh1DIqf5UlKGdHEmpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199018)(6512007)(66556008)(7416002)(66946007)(66476007)(478600001)(6916009)(8936002)(4744005)(5660300002)(41300700001)(8676002)(4326008)(86362001)(36756003)(316002)(6506007)(186003)(6486002)(26005)(2616005)(2906002)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q+I1Aw9RFKo94ULy1nSvYrc7apaApmV3yo1sd1kQWPplYD1PB4OiO1XHLg/I?=
 =?us-ascii?Q?RTyu5pLhd2fWTKBxvbxtaVMv8rX1MKemPLAm8gKsEYI71738qH+5IX9lFU7x?=
 =?us-ascii?Q?2+vU/0Bi7F+/TRQghPc5S+tuiql0pHp0AKVMXRn6hwDJQ1/pbH6gXyvgDvwb?=
 =?us-ascii?Q?QpOOZSQI81Hh2ZYul0cyjjs/6iP1sxDBh6huySRKEGnvXxgC1vtPUnKv8etH?=
 =?us-ascii?Q?tPoS4tJqvBaBModhLYtTswHfB0XMfmCIto3Azy1LmV+Vbhmn8ou92miediHk?=
 =?us-ascii?Q?2M+/uQVeJoJnucHE10rU1m1gErZMBpze02A32dmA24mpXdkxw2EVUfq14kFd?=
 =?us-ascii?Q?lfxbhHsOOdS5H0C724vrZU/GPrNH/kQm5Fc/RVpQ3WXnCvQ2vyM5ccX60d9z?=
 =?us-ascii?Q?bWfn4C2f/ossb+7UZsqIqIxEIVVObyY3hD3VAmDS/WpoZZIt4U2G1dXt+paq?=
 =?us-ascii?Q?7bpGs6pszo4wUmpLoo6FMt8gnh2rLOZq3EF/33Ib66uqFKcybQOzBkuKmIHF?=
 =?us-ascii?Q?/khTUbUHDGLxOvDYgdizqptlSkZNY7GCag5CriI8pY13opw4jqe982tdzpJ/?=
 =?us-ascii?Q?OBrFUmBOnXUT3QWvADJdAoudc01XtOQm9ZdTL2gHWd3ubq048jsX4Feb49m4?=
 =?us-ascii?Q?xJWygv90a7eSOS92NgsqviZMFUKBYT6ySUbgrEHfd5UhMp9iOLb1Lixfe7oD?=
 =?us-ascii?Q?3xpRKqo1oQe7qgGQ9ffeqWFESz/BDLpOgpDLwyYaqWNOlhwUnfE6comL9Bwz?=
 =?us-ascii?Q?8S3C9FxlIG4968RkTD+4rNknZ3c+R/D1P8dxODlUCxXkHKqlaqukcwlTt2ad?=
 =?us-ascii?Q?RJnqKohDJtm8nEVRHfH6pfSu9jvz0QxCZPPoo36rFQMVgi/ZK706xKPIME1H?=
 =?us-ascii?Q?NBR3KXzVdDFHMMWJvSLq8viCytv6MlEAcOJsJDUd1xrgIpcksTTppypQjr6I?=
 =?us-ascii?Q?5wrnm5TOvpIjunEDMWtwtDCpFc3TaM87t7qFUKkQAiS+B8/KjIxYaHtDoi/d?=
 =?us-ascii?Q?m6OWchtlZ0HyKMVX4FQhFe0kbc3gEsiaTFdyDGdGknYogrU4Deb1x+8INO04?=
 =?us-ascii?Q?9bOCkzteF0n44tifpngakjps/CaMMVdEaBzx8BugOX7GM5FXmgC0fJ8HFyAD?=
 =?us-ascii?Q?S404trhS2HrKku4usIi2ruF3+XXG8hgmG4R06A0862hGNLtuXyoml0t8yyKD?=
 =?us-ascii?Q?lnKzROjKePWFk2vdvszRxd4zQYqe790JUI/vMwa0GrAXvkQtpCMEEVvVd5Mv?=
 =?us-ascii?Q?vXRPnQsg7zT54jTtO+47VQO/T7zt+J6m4RixpXiyXNlIgHDhi7kodouI1zkQ?=
 =?us-ascii?Q?wF6h309/Qhs9flj+/eqn6MBjyB8cXt095QKYTqxvTLAy6K+iiIC8TIk9FU2P?=
 =?us-ascii?Q?CnC63vWJmW9GADmoO0aTK2N5GZ337ApxI1XvdAdhIHyfK4n0Q249hmu3QZiB?=
 =?us-ascii?Q?bZbONvblqqc0r4CwlwOdiJ+SrZy4dnOOBt0+rwrtfi+TwK1bE9kbeZPS0Tki?=
 =?us-ascii?Q?P0EjvTcPqVKc2wOXHCUCIVZ9rj0iYG/5o9twKQ+ZgFnUFhoKG6qqe/lGUrEd?=
 =?us-ascii?Q?ogb2OFlNZrLeXXvHjw2Lj1S0F9cgLXE3+IJ/r3Ge?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 696cbcfa-5b17-4a65-c8e5-08db297483e5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 18:54:21.0752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Rn0Fk6fhyrPbz/nEOvb2xsMegVN9JxJ5jJ5rW5MXqn7/SC0WBlpbpetW3XSV8J2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6001
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 05:41:51AM -0700, Yi Liu wrote:
> If the affected device is not opened by any user, it's safe to reset it
> given it's not in use.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 14 +++++++++++---
>  include/uapi/linux/vfio.h        |  8 ++++++++
>  2 files changed, 19 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
