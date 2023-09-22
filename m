Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A164A7AB1EF
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 14:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbjIVMPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 08:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbjIVMPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 08:15:37 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806CE100
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 05:15:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhXXIRguUZSgjCmkrxG8/ZfmG5MaY6LebVNcipt7lonQYtzrwPc2xXKFf74Qw7/WfFxm6ZdtufYldI8qPY7LNpCvw82mCYSlYrkNYm4yeJH23IY/ivOMEgZdvK/bCUd+SAhedXExuN9Fit5DNVGpDSTUtV0i24eN8iosI0Jdg/MNzjnwvkk+SYk/VJhxHysSf+0tDTlQeIkdtE6PmUGT5xIzHGBv8u/aoTh0kZMF+2IIxA0ukGcRWYyLCp7d0nte89cipJCDiGEVc0/q+kql5yWHGaYwDWg3FLYy8pB1AeUL83O/pYTMUt8hiRlw8xAHswZocLRVwUcVzW5qkn9B1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VAVfw0lieb0ohWfXiQx0q/zV+ru1SItLNijqAVZaDEI=;
 b=j3K+xtZHg4YaN6KH+9FSderF6n2K9Al49Z36iq4hoeaanZYkCLYSPsV+p68BKLwOwX1gb+ST2FLIBpuYuoku3RZT1lB8NIX2oiWV8lRdpcxBctRpUkhnzyqVGjSCIqxFl1EyElt2LPbSd/zAuvyCAn6MTNqmjQO1S4TiNygZxhKMB0FoULcLogPgvEsInDXEV64AnQp1n+92iNAvlsD114dy7+3QIv+irIhDMW9b9Rel+3kGeohLPOr8QDEZZXzYPJVcK7wFCWsTTZHd3YEfWEvsHhEROvjvQuVy2yhD3P34junLy4buiSCPtzDEmBjn9SkPSsX4HFKJqp99TqUB6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAVfw0lieb0ohWfXiQx0q/zV+ru1SItLNijqAVZaDEI=;
 b=KCH+MkfY7mX/R+A5YVKQT2xNbHmGRPcjivmlvFUV6EAyWkcWEcj8TltLBrOVt1ksvy7qHHoa+DpCRV93BVad+BvA6w+9+/4mMjAD/2VZpEZEOMjAuyvNAl6eM/5qlWDCNxm4JEUkysqHz/1Uk9/r4xBaH99njaHM4Mez7OZDERcGZUWfsNTO0DqEpSmoiNZFw7H8MYwISIzGmqeTkKm99EK2uOpb2XbQjvga71wZHLg+kA3v5j9J04B/moUB6vJFjjO4td0xMXgnR+Of4Y+6rWoRmPjv81lQSf6urmQhCwrmrpliOId8OGv9/FHJykp1qxrx+VrTc6fPKW6Nqd3qSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6823.namprd12.prod.outlook.com (2603:10b6:806:25e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.31; Fri, 22 Sep
 2023 12:15:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Fri, 22 Sep 2023
 12:15:27 +0000
Date:   Fri, 22 Sep 2023 09:15:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922121526.GL13733@nvidia.com>
References: <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
 <20230921163421-mutt-send-email-mst@kernel.org>
 <20230921225526.GE13733@nvidia.com>
 <20230922064957-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922064957-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BL1PR13CA0233.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: fa8ada2d-ef6d-4025-c80b-08dbbb659b28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p17HhtYiNU9pKUIuzBsSky5DqR6dpsq618O+GDpm4TpC1pLnEem1bkTFSLSWH86qybzGZvXkOGMyoztZyimQD2GIwTUWSeFcHJWLsbn4Uj6MzYq7bwi53HooSHlhE5B+SNiQWGY92lg7eBCsJgQLiFyqpbc/Ewuhz73O48L1COCEThImg1QlR2qM4lqP2yWExwHJB84XrpjDDJ8gY2/CGWGI/TA53NnhdUOiz970e/kfKs9jI3xZdcgoHczgLJiwdNKOBAHH+PCv3LCSRmewI/BXCNn9zGERWdZ3CVJzC6JzTqVsfy178itTnm9796evS6TW79n9oBpzQgWIH4Y1iAVwVUSIfvoaNiQ/MORJ47UE3Cz6BOlSl21N7veCtw3fI4jbib1jRKbQnO+2dDktUy2pWPhsHgHOhD3qpOeEUaU6Y/5EWSIklNx32vS22eYBLMxKlShkzt111RFPxs6ZHYtJNs3/oQD6WYN1zSVedZNBuCx1rncbyG0yRKJtWGw+x16dLs8YcgpEfaHGtfOG126kgd2+tWMCc16V8gA2tawI3aNvD04Omcz6vQwVCx0j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(186009)(1800799009)(451199024)(6512007)(316002)(26005)(66946007)(38100700002)(6916009)(66556008)(1076003)(41300700001)(107886003)(36756003)(478600001)(2616005)(6506007)(6486002)(66476007)(33656002)(4744005)(2906002)(4326008)(8676002)(8936002)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dEc8CMAXuu0HaZxSQpQu+FoJtKqjzVK0tsmmmIY6s5gX142VSBJZ31TfZOuK?=
 =?us-ascii?Q?Es2j3FtWaFxZ3HMCWIFSKVMG2oAaG7QQFu8fELX5CiiDfhD13ykHhdoKcl8m?=
 =?us-ascii?Q?joxDbULb8fJoM5GUKIVaDpxrMAe7eqIFkKpTh8wxnpQQcIPsxR0Etf+nqNiG?=
 =?us-ascii?Q?7koqaClLmdX2Fjol3V7K9kVNv7Lo9z2RueYJqSlfJA+CUYfQsWewwc7jGYTV?=
 =?us-ascii?Q?CUk/g//YA5eFyOLP0FRoUn69vmzYfK2M86c4k1ODysdj367ZvRLMlD1qTEWv?=
 =?us-ascii?Q?XFcbCEO34q+rZnhuuShtmLHy92HyhiEV3pnY/JEMiZ05d2/dGGxhkpP6CABl?=
 =?us-ascii?Q?kUljOMXIE7TS/EZ+F1lTZOfIzC9lLEKlyqOOmnjXZsuorA4uniG5XvyWQB8q?=
 =?us-ascii?Q?3GOkKBBHHCopDGWZUltGxIP+ArTCTYngeSQD7owkGcex7J0Rj/A9PHZE7D6s?=
 =?us-ascii?Q?+bxmgJblbw+whxcHtmZ2amNJ598RnsfWjXZz95+djPCY8cKshH9NbFnMY9da?=
 =?us-ascii?Q?1V1+w9M1v3N8HA44yK+qdHKSI8gsqjQ7gBbEW0JM4EjyimY2PuiFmKikOemG?=
 =?us-ascii?Q?sAYDQOH7rSz15789oL4oVb93Xl8Rpc59o56g9YtpV1ZTB0VDD+5R3SolYGbs?=
 =?us-ascii?Q?Uk3QkExsg8HYWNyVjGfHAUdhe2qSrX/Av3mSXqVBVoDNAI8krOgePoatTnsN?=
 =?us-ascii?Q?HNvPGpQGad+qpIe+sPAkm2TqmB/iGiv0gWkRxhV3I539esZl1jWd3K7Mw3X4?=
 =?us-ascii?Q?Tec0teiewpklH+LmaU4RaMLJpHy6bdJq1Ko3lhTzzzaA/eU6bIxOosSKYURJ?=
 =?us-ascii?Q?pbGleew2B7dO1Ohy/gqLiMnE2E5OOwHq6uWEKRowQJo9mns8rbFqOT8A6Ptj?=
 =?us-ascii?Q?faXQQVxigHObyjMmpGHts8We/joe24qpPFsuSWRgL3YmyslsmTpQ+OlZKBxc?=
 =?us-ascii?Q?Q9fpemGsy7FEg58SWbNWqOol6EINdG3+9omgd9W3vU4y9hjQ5gcTGTUJzie5?=
 =?us-ascii?Q?IunoUPdNd7k95jxdi4A2mzaG2/NniPafR5SfprjItTvQYEMPMtADSFqV112K?=
 =?us-ascii?Q?eQ9IejO8w+LWbto7JftcCGgILxV1iAqwO4z3fbIcbDTPpXm9wnHMpmlqmbRe?=
 =?us-ascii?Q?wXvoZq8G96VKCnvM7H+V9Yf2hrKsYxOVkNb8CQuat1ZA+GWqfkWvSPEIhh3I?=
 =?us-ascii?Q?5Vd7gSB9Irn0XDICzcx2yb8toBoQ0P/ZHn2leV6UgbIWyy+l+x6puSsi262G?=
 =?us-ascii?Q?Xi78slAS/31CQSl1BIRHdBhJRHUaN4138nJ4rwTpujGmgtA8HwAdY0HROPMy?=
 =?us-ascii?Q?RYiHTHJO9SkssQFTVw/J86SqFQj/B/X0z1STroPCkdThOsKpzRa9zewlU1jT?=
 =?us-ascii?Q?rd8fJlrg5TVNOhxGjNnQiv0IaEOHnJNCgGxS1jcjp/cYxEGj6l7UukuwWHjn?=
 =?us-ascii?Q?FVRyxSTSRLucrcLozZFdTQ1BvkkmfYl9hvkuVeF0bhHsmo5CzaWeoGx4Qnlr?=
 =?us-ascii?Q?FOiL+MD1rCQ6XMJ2MYHgIkgJmgWbKFINBRiFs5I7DEnrG6zrAV62tL+XlRYs?=
 =?us-ascii?Q?RS3YdGxuuF8hsTTlC5/AqHPH+Enxc1M1kLPDWMpa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8ada2d-ef6d-4025-c80b-08dbbb659b28
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 12:15:27.3589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tlimWW6ehvhZGZYMBx+aQWh5kuaI34hoee73yevhZsz4baEK9YcNv/YgW+6I19K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6823
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 07:23:28AM -0400, Michael S. Tsirkin wrote:
> On Thu, Sep 21, 2023 at 07:55:26PM -0300, Jason Gunthorpe wrote:

> Looking at it from user's POV, it is just super confusing that
> card ABC would need to be used with VDPA to drive legacy while
> card DEF needs to be used with VFIO. And both VFIO and VDPA
> will happily bind, too. Oh man ...

It is standard VFIO stuff. If you don't attach vfio then you get a
normal kernel vfio-net driver. If you turn that into VDPA then you get
that.

If you attach VFIO to the PCI function then you get VFIO.

There is nothing special here, we have good infrastructure to support
doing this already.

User gets to pick. I don't understand why you think the kernel side
should deny this choice.

Jason
