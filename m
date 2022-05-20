Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42B052ED3F
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 15:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349828AbiETNgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 09:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345592AbiETNgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 09:36:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9EF60AB2;
        Fri, 20 May 2022 06:36:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auxgcc6p3vkC2xX1uCcqWLMFry2cMuDUv3RRdPZc0KDu35nUR/5sHXISS27r7XbLPUgcRrPk9BZjlIct8SKT/AD/fht6KG2q8JNyl55hZeQTKu3kEVH2CGe3B2Lz2LbYDA/j31R0ejCG7DA6HOmn42ivmSc/CQQG5rHXbTjYS9KEg2GRmIQ0fr/oRj5t2unAdBw20nP5NfC+O7ROMaq5S9SztOZyik0V2mBflCm5wbsIxEWRV/+mDoeTxDjHJSg8DheK9u0xqiLs0z17QhRnY1549bLgIo++YZZiPVrAJlYiFuQr5diaFSqujuuQdD4sK1MDiAezdAqHW85eHawyzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQaGjBCOBqj/mNi+pnxJOtqMaKn7dG4nob8Hp9oi0XI=;
 b=lsjlg7LR2gCK7NSfam/lT2Ac6iFE4AyP1q9ntbFBjXme4ziLNGIFQx35CYpiYteOVtM/ap7F/O2DPhpZ6E5ukHnwl/7QjkxaheHGkBge/ygHlbZmjF6XMq6NbcsBr5sK/mvb7MJO+Kr5Rb8gCuP+pfBveQekuySqM9cXgxa/QOMYUnEN7RtN4w9vn96qVN8NLs8Ct20Ol285/0yNOwv+gt05x++NVl6SouMAgj2BVUvsyQf+cSQQeaao27/N4E2p/HpjvlhbWANPBABw6E15xCp0mdbLbu3lHH774Irss/M9YZWFx1PcSB6W5zfpSJ3HLk94V3ng49mDvyZ2TzitXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQaGjBCOBqj/mNi+pnxJOtqMaKn7dG4nob8Hp9oi0XI=;
 b=n0fAiBVcykvGzF0CX1J5yh4kkakTtLp08Sthnj8lsgJ2ZChW1Uy36rhUdxALEI3cUQWBoFYhWOq0wPjsHzFDii4SAmVqI0wl1WWcShXs2Uq6hviP+zGHduCiFzzu5Ux78P2B1I8oNNxL5ADAP6TB3Isy2qv0TpzyArY1ohHAJRgfeMH4JMcM3Gz7NKzBaU/6CfVFP82LuE9RQfhMrkiqSfIPBOAamUMXRhi0YtC71wloYj847a1oSFokvzKlx56oxkYsF381rk6b8YlDpS3/OHUIzzCIKE5jFdlv+i77XIdL/uQubgEWlk5MhAJUmp/1OeNPHiuO4zjSITpPU65h/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB4977.namprd12.prod.outlook.com (2603:10b6:408:a4::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 13:36:32 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%7]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 13:36:32 +0000
Date:   Fri, 20 May 2022 10:36:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        borntraeger@linux.ibm.com, jjherne@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <20220520133630.GG1343366@nvidia.com>
References: <20220519183311.582380-1-mjrosato@linux.ibm.com>
 <20220519183311.582380-2-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519183311.582380-2-mjrosato@linux.ibm.com>
X-ClientProxiedBy: MN2PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:208:fc::38) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6450de01-6887-4214-6ec7-08da3a65c061
X-MS-TrafficTypeDiagnostic: BN8PR12MB4977:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB49770F73C6AFE9E505D85AC2C2D39@BN8PR12MB4977.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NBxhmSUb6tKzCN1lMF0qpbDpQ/+vBfV6ftQSEh5ozEOQ2tahkt4KTUxRT1P5Jto6HZch7pyXSyvqSs/bvppTu+3/C6PURB4Z9i4FzEHaoh9RWJKIojMgpeutaqg6J4XO2WWGGa7ywlDchGDqRoKokN/Zu2xY6Mbmu9Oo7m6yXfn1BEP+2eArl+ivK+SfCrFkQCitxH3bRPiofkPmHOj7KcH4BNoIHR/h+uAZ36+6ZfsWMTgYfK6EfONduypJYAb/OYfpkq+dPJSjVgDO9xWXYDE+WzK88Do0mJ5RA+M/dpmceIcXgza5havFqUVXUNvxa3xYkJGr05pWYsfLacMaip4D+fjQg8PliY44HNyH7Q0U7v8Igip9sNzjkBQ8HmC65rloJJFjU4hl7Oye4FdzXAKCxSwfBqutv7aN6mERK0cpNs4Tkkf9wPylPjRLmH4l4ACEZZA6to7zhm7SLp5tWPGXRGriWazPPsctfcSxnkjYCuen+hkpNuWaJd9ZCSGU72NDNfeN5mqq3fn7JibjbTM2QCCRPaa7bn0rgFO5hV6FRKE6FRJTsbI2Ymt1VFgaB0UE14SDsoCbFImr42ZNMecxAzn0tk59u21GIKOwQG18n0pw0UNl20zPPHoRhBDIyGkeZRke89CdeSf+A6CKkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(54906003)(6916009)(316002)(86362001)(36756003)(83380400001)(6506007)(186003)(6512007)(26005)(8936002)(66556008)(508600001)(8676002)(4326008)(7416002)(1076003)(2616005)(6486002)(66476007)(2906002)(5660300002)(66946007)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SdJhQN3qKKVUyKaPOZLCHGaPuFJALx0NnKFS3NG4WcAvmJtn8qV3pgPilAwq?=
 =?us-ascii?Q?xTee3n5lMKCOkD76Kxt2VxdzCD/Je/FO8v/szZ5Q2OI+hYctk5KhCnam6qj1?=
 =?us-ascii?Q?YB8TIZI/KKXXU92WCnTgWbNq9Y5SfgT5Pe82e3JM9PFoihDdcTjjkL4FRrhq?=
 =?us-ascii?Q?DQmMfj4DsUMXjjw9Q/11Pi03m/7JZ8bD8sxv+7UyfzTWvr8pCYTIZhbbAnUg?=
 =?us-ascii?Q?r+WmgjyKTA8LzZH68J/tRpxoGnzNkZmHB75YJUk/6v5Hrd9dM7VK4M0nZUeo?=
 =?us-ascii?Q?vr//aeFW1mAQ3d0Nqj0ItrZZ5WzQsJ4q+MbGWJCEJi14huZoz1MiHWeGF90M?=
 =?us-ascii?Q?avUuCVLBtYDBrk4hyhhw66TlRlPVs54BsFxopeOVd+ODh4FjLHyuilYwJiIW?=
 =?us-ascii?Q?xiGQh8E2VH2iFC2xONp22l0sYNy7rnmw8ajrPsSh8Ju8SCqfWXg3Sp/MbEcP?=
 =?us-ascii?Q?YfSKnBACCnNr/Qg+cPFJtOTOQ1sTgYY6pFgRwxyjHdasr07EMn3AKzGr7XMv?=
 =?us-ascii?Q?rq0KuRY1LGgXVNAvQsvEewiIfc909cnT2+eg2Meq1GEetdfFxKbgonTR9ofW?=
 =?us-ascii?Q?Z6vdPWMcZoEP4UBVvCiHBS6WOcUntGE59aFgb2jp+BXpJUEd2binPrKJ1UI2?=
 =?us-ascii?Q?ysF7zWRL8Z0GhViVJL6BW2mhCrzX0IOzBZoTbzsgvVQbtRI//M7Go7swbBhY?=
 =?us-ascii?Q?tHM02YMnlJ5UoS75sblfvMQ460ap8H7rhjvIbo2s3FBYEBT5i6XLL1Gge4h/?=
 =?us-ascii?Q?wrPwUr/rpsTTOOJPA4yhlkFWOKHVXJkg6KSEQP3gSl7BWwmN+IPT21zRwcjf?=
 =?us-ascii?Q?w+zsDLOqS/vklx82C4AXvXHGFB1YEBvsNobUu+1xy9uCVIwCu6T+Ah1avyAb?=
 =?us-ascii?Q?S+V9FOoA7Ns8i6iRzZog+qyOY3kQxF/UHtF5KLBt0CaxX1ndp7+U8XyO3Gur?=
 =?us-ascii?Q?aMfnfcMm6QIZ8BqWqrMY2hyxU1rDuSn5iCZcfyCJwQgrSQbY2yZYdpUg4xYH?=
 =?us-ascii?Q?A6JY0Mrs1wxZVg2cywSfeTW9pyUHmJCVw7paE+kqaodmUfdg1D2tajE/G8N+?=
 =?us-ascii?Q?Qq1qqqB/9aoHfuzIXz//ry+acR50HlxMIMzfS2BMIivEkCEFFKVE+VA91VgG?=
 =?us-ascii?Q?VfpH60XTmQhcILZ3/KJuCyAAj8o+BJ2gBEdPPsmKgSMmbi22P4tBy3X5/Dwy?=
 =?us-ascii?Q?iJoOJQDbs6xn/gnlGKickUnHgdK/a9k5VxQE06MN4xB5HKPW9CqcwTn/wp8x?=
 =?us-ascii?Q?9DpLsGJ97zKcLIPw2G6JDvZInGpLBYdB1N3KbwON4t3/RTM3txtbO6oeKPk+?=
 =?us-ascii?Q?miCO5CYE5gcQSyYbx8zyqQMZ7PSzmZuQMthE1jMi52HLcnVI99Clhl9IIeUV?=
 =?us-ascii?Q?EEBvkSP8X6g+pme7FLDCiHkOPi1Reqo2DX+1RDY0vvw5RJPWE5FGgeIRnfzl?=
 =?us-ascii?Q?Qyz1V+Gb6ve7w5eezLCavKa9cmOYaYDp8X0G8qgfynYDR+8SBC37ki2lJQgO?=
 =?us-ascii?Q?XY6tuESA7JKZAdCGufX9B41VPLcABw2C6PppSfSY+HI/vE5zJOYM4ou8KBYG?=
 =?us-ascii?Q?+wQateJw+0ccCi0A3cpf2y5LhvfHaEqqAVnM4dje5M0AW+FHlu+HyaKgiYjw?=
 =?us-ascii?Q?ZaLAsjd+r6Y5I6SyWsgMvYuBqFm7Vxkd1WyOtR24TEuWA0NMgLzHI2gXCwsy?=
 =?us-ascii?Q?lk3fhwNVPMIWRrKa/LyQoN3S02uDAGmyo4+EB8sqBu6C7PK1lrp61gmE+7pJ?=
 =?us-ascii?Q?7aVniwLTgg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6450de01-6887-4214-6ec7-08da3a65c061
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 13:36:32.1783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6qdNHD2vr6Nb93Dd4fGdOJmd6gCsTlqRBB6iVfcCy1LJBod4lVhAInHlnbajGGao
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4977
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 02:33:11PM -0400, Matthew Rosato wrote:
> Rather than relying on a notifier for associating the KVM with
> the group, let's assume that the association has already been
> made prior to device_open.  The first time a device is opened
> associate the group KVM with the device.
> 
> This fixes a user-triggerable oops in GVT.
> 
> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/gpu/drm/i915/gvt/gtt.c        |  4 +-
>  drivers/gpu/drm/i915/gvt/gvt.h        |  3 -
>  drivers/gpu/drm/i915/gvt/kvmgt.c      | 82 ++++++--------------------
>  drivers/s390/crypto/vfio_ap_ops.c     | 35 ++---------
>  drivers/s390/crypto/vfio_ap_private.h |  3 -
>  drivers/vfio/vfio.c                   | 83 ++++++++++-----------------
>  include/linux/vfio.h                  |  6 +-
>  7 files changed, 57 insertions(+), 159 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
