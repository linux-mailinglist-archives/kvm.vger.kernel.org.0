Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0EB5BF24B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiIUAmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIUAmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:42:40 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E4743630
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:42:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bausAykDV/ib5wkwsxpD+Wkqw9PUUoa+xUii+rDEtICUG8FMUwrK+n4n9ba8y7tRzuNdxhx2aF9+ml3s7BR/YZmBNIojHS1MN7Qli6Kqs5kHfW+A4ZngVW07zncyuBd6dXo6iUYNl/qo/8ghoIF1cQJEMItgnizdDSi2PUnb75OgIOVmT6jfea8r5gyd37sp593ssEzmXUdS8qhWylXMc9IZ5G+VU7MY71uKYbnZp+eL/ZaFqfGs62mdH8DGduIoJKnc5HJRi79R6RwcHU1Kb9s42s6BB3IVQUQIONBGNRuyCoMicWT+2oLLWvrH99u23vhSqc3qrPTQzLdCO3nikQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZzcaZAC5R20MfK5sCFZSkBJnVnRfgWiqa4Yf/OdIBL4=;
 b=IMIoFmgC4qkrZpT7w4TBBs2vdvSFjhP8aRyjHXkv1eevvZihZxiHck7XXxo+qDh6e7FaMwBVPEUMsV08jHWHvGjpXr7eS40fPhSo4rwOXj6pYUYOBIGbN5jnyPP4aKFfK8RLn8lt0nXReIzqLwDBzOR/VKBQrLSQDeBi1bkGVYzhQW3bAqrem0GVESNIBTCjzBqyLUGRpD8PrAeyLPq1bG0WFblWbXCaaHqfYHgcU4LhSq9IXr1QCESZ5zPmhykKiELgHvpssTtYLF+a3SWEt3Ki8mEcipU9jI950HnqOQovadViHbyx1G38hF8r0eyAXiJgjMPIUKqLvgNpDv8ylw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzcaZAC5R20MfK5sCFZSkBJnVnRfgWiqa4Yf/OdIBL4=;
 b=h9aW1vFr84J6XZAPEklKc4vxhYKLDwAyzSq9nFs3OsFCzjjkPOvMH5V+9OIne4zmXa8bio/dxwYQCExOVms0VsostlzrEM2t1lEyJdOh9Ojaf+Lm2B12OqbylnHl84tugzGMglXpziQhhLcCczBzjPJhFA16xgg4b4WQji88bC+K/kuVeXJrcJERPktNYu1GT4n3J/oegxobGi+8sNH8iFvntaa/ScS93OshtNnuFXQBli7+eFvAWPbQ5jxDMv8XLub3dWqn4MU+MJXSE/grviqo0Ps2tQ7nQ73ciVgXN9rbDrdzlcfo+SQ5PDCXmLY04WorG3gl5dmSz2kh4qOv6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by MW3PR12MB4426.namprd12.prod.outlook.com (2603:10b6:303:58::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 00:42:37 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 00:42:37 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 0/8] vfio: Split the container code into a clean layer and dedicated file
Date:   Tue, 20 Sep 2022 21:42:28 -0300
Message-Id: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0042.namprd16.prod.outlook.com
 (2603:10b6:208:234::11) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4181:EE_|MW3PR12MB4426:EE_
X-MS-Office365-Filtering-Correlation-Id: 108ff167-e3c0-47b9-ed32-08da9b6a2e5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UsTRPl3JhFeToLHPUGyOvPuVkEE59QqsGJ0BKWqXlae/DJ30A85Ww0xXb6Qgp8MNY90K0yKLeAcPzeex9izlnmbrPqyFqsoknjJI3C/mCbEtrKykoezo3IldFceKiW5H8MmEr3rxTPOCqRJrVYPbbpZ/jfXJAPLFn+WXJV9/rIX0uk8z0cN4ezlcvFj9DhBZ+yUyBGljs/fZXI62LBRfSwVkwfSZMLfa4kPAoL5GIArsGmrOo4OhkWgKVK/+NnSowpEEOhr4V9kHw/z4iyywqi+mhfyNBMDN4Lcxik1OQO0D8XPUZctumONRCK//uc5LdJxKySQHbg1d7Y9WFBHoWV7CMnszAGx1rExjIZ2xGqGwHzPdjVcLlNlgFlOuUu7mqsYhl/+I7ubH+EDkF2DdpHQ69rUGyIls/vW8/I9lHFE9vpV9u/zCgUMuKW6sF+22yoFeQxjuj9AMp3qh4ekbwfv+OsEFbRXhv1fqT4cG5oFH2uZTfF2pFAii1eKl/iJqll89dH0XbglbLMlkLyCahS/fZN3QmENc66EHlzB1pu306M1uo/NsGwN3toSwQxKd1H0Lo6+XCC0elPPb/3l5hFPImugxmfFTF36Hg2IJWessrX3N7CA9TaRxKcRPKxXp/Lo9/IRv/SVbj1XopyqGsJDInZT2HyqWpnaTkrNhmGYLvIefwRZnb/MMMwVE8/te1Rs0NZsNZ7iL+OACC03h8l01Ti6A6kfTDW/mkwuuRvBVg6/fyqY/YnRm0dMVI8HCUV8n0sxv3OqDqmHOrO/v92C6mT8QHWUXajvsP6HqtkyDC2jZPLMQqycCurQ4lcSo008M9x+swCjxmCGRnmI3sBFkyKjsHzH0fQHMzlzbJ9mr3F7MOZtxskzjO0NZVCa2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199015)(38100700002)(8676002)(6512007)(41300700001)(316002)(83380400001)(110136005)(36756003)(86362001)(478600001)(2906002)(2616005)(26005)(6486002)(966005)(6506007)(5660300002)(66556008)(8936002)(66476007)(186003)(4326008)(66946007)(6666004)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lTqQfBz2iXB2ZhMOdqbgPkvauQ7BmHaXcKJvRBkaGexAkTvzaUqGRm9r9P6S?=
 =?us-ascii?Q?AOFVEu48Crcn3AsNIPvssGPaMvI7y0cDKylzr2tWDhJ8/gIV4TwKpK7WM0sE?=
 =?us-ascii?Q?HCuSkxQ+XtNY4RL1Mo85i2mLh5xaYkrGap5wAzpZGL0UtWyBDunmTgj547wX?=
 =?us-ascii?Q?C31Ood7FXLVqdJsN5JU5O6UH2HbmgQehkqK1wItljzuYxPjTYdHHYd0rvpVH?=
 =?us-ascii?Q?NKifMsWqhWTYec7DcABHj0427vp16E9ORyVXQi5sL3uNPuOL197RO6N2nDYN?=
 =?us-ascii?Q?H60E7N8Du1cVkLJwhC8ohs2lu7KrICQjopvHcAxkPpvMqgMKqDvvRFtDfxhi?=
 =?us-ascii?Q?g/v4fFGi7t3FokBLngDkwfcB6Ks6k8LTodC6Gj9p78gskxc+GBZ0Y4/gFY06?=
 =?us-ascii?Q?/u0JHwX91Y0WMI33U3jx7yw0tEtcup+JNReuI8T9zdQvSycIqcgU6Of9P17n?=
 =?us-ascii?Q?bbeUqLA36SHPhNXsBNbyYY513k2JAda3v+7ir7rEHlxXXAMdc7non+IlzY28?=
 =?us-ascii?Q?DpxaqyUPjtJk/tB5D529nSGBUgbcdMbuJRQLAHQEda7+3gYadIF0l8MLaCw/?=
 =?us-ascii?Q?j8t0lPPrrb2QdCZlJzCdmuupNczPmOl8ylatgxH0emZIny/81KB8MnPLYLSQ?=
 =?us-ascii?Q?Byd9L8B1Om3WhHDrYU8UYM+4QXpC0HKg7IGizeWBvuJMwfb/tth7muKJN/KC?=
 =?us-ascii?Q?GulQlUyUsamxjFiFFhJbKZaVFtBXU89OFj2+QLN+7RR69xuCZibOQdcXCJNg?=
 =?us-ascii?Q?WYHy1DVj1qAMJjymU7TlXwtwy8Wh6sFfFHlhJ0xFIfPskK975LTT7wbuL2Xy?=
 =?us-ascii?Q?Wzelgu74+cB8LsDkU4+m1yiGw3cmTQ050c5YteMXFWhPsqGUR00ngOO3XLaL?=
 =?us-ascii?Q?wnv3FZwuiBDO4+L+Z6y6Fp3o3BR9iIUYdQ9clXjO4tRosSZ8YaIkYt3Peyoa?=
 =?us-ascii?Q?L6kH43kD3LTZWzhGAsG3m4BxGcQ5RX8w+GeD3B7Voe5eBEPzkpDhxpRZZnZg?=
 =?us-ascii?Q?d4OOpT6BnfM8IGROno/84v7CV8b5gMICx6rKmy4P6ApDktuHR3r0/t2ILDb5?=
 =?us-ascii?Q?wsf1n0Xjg8Xln1m+NngaWuGN3Ev7nDzn1gzX4n14El8bhl9V5X0eSJjE3JGr?=
 =?us-ascii?Q?icld0GOOVvYasXu4XakwJYFx4xWD5NqVUfjh1SKkVbzQCCu8oaFZJ44DR0xT?=
 =?us-ascii?Q?wH1HH45ehTpjJ1XcTWmhncHgCwV0SCmXmmqUax98XtgaKTUfP3Qb19JJsDou?=
 =?us-ascii?Q?EHmyi+cZ0UUhvmrya56tk7gdWQyFJBzbUcbtqi+rIkLxdGVVIqFkgHoINZgM?=
 =?us-ascii?Q?j95l3GYI8A47+ZrT9KlAmAxcsn5ZDXfFrbpHFhfyjSU+E72Fs27guzjnmq4C?=
 =?us-ascii?Q?RyCwcpRohNUog9KxGgvU8NR2HS5Yo4hj9RvKCy4BnEOKNHGhamwD7eMpitkN?=
 =?us-ascii?Q?ptTevlQif1EuoyUhpd6POIekYKDf5Kb/N2QPOTHUtIlFpG11PT5gV96MFuMa?=
 =?us-ascii?Q?H5C6y0tgjn3G22W2uzCV5EbdB3CfgJZI6GUDwxFKA76PMuT5RTLtwLurGRUI?=
 =?us-ascii?Q?TfhkgwhU6hQHMw6Nl2KTH7NlTw0429D3+01bQNce?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108ff167-e3c0-47b9-ed32-08da9b6a2e5c
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 00:42:37.3964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbDZ8x8Q/e8iUDm1snJEh4nECxbqamfZPs10fz3sgeAjzMiOICgxn4cLonVkr0KT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4426
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This creates an isolated layer around the container FD code and everything
under it, including the VFIO iommu drivers. All this code is placed into
container.c, along with the "struct vfio_container" to compartmentalize
it.

Future patches will provide an iommufd based layer that gives the same API
as the container layer and choose which layer to go to based on how
userspace operates.

The patches continue to split up existing functions and finally the last
patch just moves every function that is a "container" function to the new
file and creates the global symbols to link them together.

Cross-file container functions are prefixed with vfio_container_* for
clarity.

The last patch can be defered and queued during the merge window to manage
conflicts. The earlier patches should be fine immediately conflicts wise.

This is the last big series I have to enable basic iommufd functionality.
As part of the iommufd series the entire container.c becomes conditionally
compiled:

https://github.com/jgunthorpe/linux/commits/vfio_iommufd

v2:
 - Rename s/vfio_container_detatch_group/vfio_group_detach_container/
          s/vfio_container_register_device/vfio_device_container_register/
          s/vfio_container_unregister_device/vfio_device_container_unregister/
 - Change argument order of vfio_container_attach_group()
 - Rebased onto merged patches
v1: https://lore.kernel.org/r/0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com

Jason Gunthorpe (8):
  vfio: Add header guards and includes to drivers/vfio/vfio.h
  vfio: Rename __vfio_group_unset_container()
  vfio: Split the container logic into vfio_container_attach_group()
  vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
  vfio: Split out container code from the init/cleanup functions
  vfio: Rename vfio_ioctl_check_extension()
  vfio: Split the register_device ops call into functions
  vfio: Move container code into drivers/vfio/container.c

 drivers/vfio/Makefile    |   1 +
 drivers/vfio/container.c | 680 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h      |  56 ++++
 drivers/vfio/vfio_main.c | 708 ++-------------------------------------
 4 files changed, 765 insertions(+), 680 deletions(-)
 create mode 100644 drivers/vfio/container.c


base-commit: 245898eb9275ce31942cff95d0bdc7412ad3d589
-- 
2.37.3

