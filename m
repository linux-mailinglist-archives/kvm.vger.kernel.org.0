Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EB96D4D54
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjDCQQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDCQQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:16:04 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2085.outbound.protection.outlook.com [40.107.96.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47601723
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:16:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RG5T3ZMMuCkz2Uwhn19fkRDMAcJr8D+nx5Va6S9L5+qkF08a5yjAJ89uvY4PQfq5yKi38WjaK+mASnOrqRJOvl2vLnvXmuD+HP75a7i6fZ86yG0XbefnvlwcQrIl3zPW+3+Y3Iu7Z8x5aJY8yLJ6deEpNGwOwstCapy77gSFTW/e/UPTDGdAV8KOQOEUIspGnXz+SmyRBY5E67JAB4zMir9xofBPWdJVDxUXoGyJne4CJme4SXKO3XulQ5U2gKNMSvkLSjNNBTbMnDRgKSD1dmFBQZypa+a/2SKL92jZRNITWnXz22yKRFY57TPf16OaZX+rpEFDw/J4yI5fp2Dvxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvm0pIQzpertY8xAZsopyZRfs0eEAm4CVSW/g9zfrh4=;
 b=iqHicnQm03p/gGZikhaWFneyhh82/ejA6KMW80w9uITy4F95Oh7l/SoKMlTnRdLVXBceILcEpCwg+cXe0BaDUpbi9SD5Crn4Fger8QVhHq+sGGNKcoipBKL4VdU45BDgG+XLVUqEuEnUppkEFJuG7iLoqjVlxj8MlvdSO2QO2uTkJplGQ+xnG/tChQBs8A3I91EiJJ9LbG9tUMC3z9oY1hfPzRLCEU8QhxgMxwDTbvnz7n9o6Qz/J/10wB8+4qH5Kfx6dds9PpfW6640dwLlAVh5qidEPjGjcvvzP+cRuWO9yia+CI96gDXZ+DSRZt85/lDcylgrl9dL1ipQvvuERg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvm0pIQzpertY8xAZsopyZRfs0eEAm4CVSW/g9zfrh4=;
 b=FGYYk740ispq0nAB/ka3epf8Csc4G14CBhP407nHwwA2AyhGoWd74W0py2piWAGz3kcJfi/rC8YxneNHapAUAJDItBDexxG8o2LpM05al38Di1wr/vfwEOC2GF76XYSoHWUGHpa66u3aSiSBA6x6xtTuLq11w7G55xRzwFBZQjfR3gIVv4kptAnVLy/Za8emSizBTJdzW5SH4UvmEv4ybjea2iPytE1yp+bfbNSE7XdO95bZ4DarsAzKMwj9C8aCqoJuVDuWBBtodR8JMEg4EfsN1T9Ix1sxVJlGHoXwuY44CFvYHeARzkW5aodTYdGjhftwvw4I/myIQuwVabsIeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7775.namprd12.prod.outlook.com (2603:10b6:208:431::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 16:16:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 3 Apr 2023
 16:16:01 +0000
Date:   Mon, 3 Apr 2023 13:15:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     Yi Liu <yi.l.liu@intel.com>
Subject: [GIT PULL vfio] Please pull vfio/iommufd changes
Message-ID: <ZCr7v8pFz+3rMyAX@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mfOlftgNv8IJ9EAe"
Content-Disposition: inline
X-ClientProxiedBy: MN2PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:208:239::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7775:EE_
X-MS-Office365-Filtering-Correlation-Id: a39548ac-d279-4945-3b19-08db345eb731
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qMHAzWhp8mJFaw0YUG2Ky3coJURvmpxNlgnFMEDH14/vE8X/JJ6Vf7tJmx8abrl3ypQSaQW3FEthXP47olEMvF9fi0PDorROyW6IGh83OAIcg4DdYykKAEtZM+TwI2kT+850rLPaUGuv/MXXyspumrHUTUl6vb3GHrYoXGdEFf+sK0iT12ZAUMidUbbuS6AmO+DSY914M57R+rsA8FiiyqvVPhlOQfyIdrKUDfxfeS/3xUezTdJ9xP9x6BIXloUWf7cbVX2wSdNMZC3dFmFrsaySP2joodtXpgE8olEghiUoGOQcX+u7O96ni/3VrAohkKiMx83Mkll2JIbDkQVV81H2O//tuoPZggSoQeGTgRmbh/mbgAZpmbJOIZ7a1tkr6tkSGbidn/FzLecDheNUx/UadmJtOaOxKaUBI8+penkll8VpgbPsoy+WCh9ajdVxoS3RCuTZnwwiXszRTpk2OYjCool6RG1UNcjP46I+xxAG5Q1j298R8YT40q/1ggk6PhSrR8U1wftplQ+QujMMgrB1PVbBPjOIT67iIKttwZFaR2P/f2rX/2DD8nkGZHAsEcJcov9vA4nIzTQDqoqNIXzmp4u+p84DvHhOUlQ3l2+o60DKwiTMl77M9T+nr3hWZ1cqP4l7UYl7Iyitsd2s0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199021)(186003)(21480400003)(44144004)(6512007)(6506007)(26005)(478600001)(38100700002)(36756003)(66556008)(86362001)(66946007)(66476007)(83380400001)(8676002)(4326008)(316002)(2906002)(41300700001)(5660300002)(6486002)(8936002)(2616005)(67856001)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KL7d4qjMW1sHWvwR5eL+85ehyAVEEzcwZrpILs72a4DNbNMbTI80qe/N7G/X?=
 =?us-ascii?Q?hQhKY1BdU7UnXsLZ6crEiylf+zt6Sa1G/6hBB6JMw8W/gNYHPxnzkRbJOi0i?=
 =?us-ascii?Q?z0PoYcz1jqlzCeixIj64rzxTK+uf2cutPEFG0FsgD0G8dIc9bf7HflVbFmn9?=
 =?us-ascii?Q?I2R61eEjcGIlPRjmFI5tdGRSjlnT8ZSYSg8zRNvmmbmy3dRv+O6ssasfjMFo?=
 =?us-ascii?Q?fok/Jcwsxa4Wmoa4XU7yNdKk2Zu9L1y6hwzW415T7kF4yIbGXJSw5rS5jPO0?=
 =?us-ascii?Q?tUo0YgVV9/NJ2YJtMbk18npL9YFKuAaWg0eVLPWsncAnoDuSwV3oBUvwU9kV?=
 =?us-ascii?Q?PHKLuaXKio5IX8Dn2yB6HnVx3Nldu7oAwSqvmo5syhT6SeDEjzaaiTFNBQcU?=
 =?us-ascii?Q?3ZelUzJte4O63n7jJ/ykHar2XyGaz+8Yc05jXCJi2yYGbV2+bO3pZmrW3a1B?=
 =?us-ascii?Q?GeWVXNJ8T3tLBOjZgLcWUx4K7Ay2J9RmWRuBfqOJqB5rj3gbxID1kDQ6rod2?=
 =?us-ascii?Q?FphG2TzlXX41LZ5saJqx4uM4cUsIlCLTRWlcRrBHEJUwhWHhtt8YaE4kFVH5?=
 =?us-ascii?Q?pM2qhu3hG6dfb2el5Ah9Ys+qHArItajLKFQjycxshCFaOJgmWr1PpeNaNuOj?=
 =?us-ascii?Q?GeWd8Tn6GgyOu6MQmjcbPAfwyLjq2sCL6YSoalwpu9tms3NFsOTsfOKoFljL?=
 =?us-ascii?Q?oS5gaQeUWCahvhY5yMiLcbSH5tAHjDGj5GrB36SPoPwn5utewNlHYG31v/L1?=
 =?us-ascii?Q?xvj2wsP+mi+2Zavp/T/xUeWu7T5CR7Tm67O7BewSgKlXCEHkb1pMtx3JYYt2?=
 =?us-ascii?Q?l7y9/toZ9WTjX/2OtZ5XUKkuxiqMjYB9oJL1Vhye0xKm6moj9NbS6PE/zQS3?=
 =?us-ascii?Q?ZUoBG+HO1I9VejzY6Qi+ZChQGfXSn0X3kcboH7LBzYMLxOvYhj69D4nm2Rxj?=
 =?us-ascii?Q?/rPQRGPblNQLDnjQrufZlD4Oc9F3YXIVUKfiM/H/mAIB1PUOM2Olfm4Mx+z7?=
 =?us-ascii?Q?w7pXIKAkwKc0O7gyq4NWwHUaO7pgKMku7yVAVShrTTPT0WqyvIvhlBGbHptU?=
 =?us-ascii?Q?O+hEQcI42BKVV1xkEQk+p7GMAc1mrzGKXPfYtQODoMfmQ4YHME1MRFBah678?=
 =?us-ascii?Q?b6qG2lWddoe+jjm9kBBweMcuQ6FXLYk+J858z7khg3nAd6iX5knghebr+mY0?=
 =?us-ascii?Q?kIjny4IB7mmAZCQ4WN6W2czC9qjdoXxVuCMfPS1rL9Yp35Mkqt5L/0n8fh/L?=
 =?us-ascii?Q?dU2EGfmjT2S/F0n9xhDJ8x1To7Ud0uVCtRlH307XFb8pFjNS/y27Gn8agVCN?=
 =?us-ascii?Q?qUX4R42ixtw4Ps8faEjbfcx+NKqcNkjyomyXd9SS8GzF+UsgMJTagrXTrqzc?=
 =?us-ascii?Q?Kq4FskH/dzUj5GMDNACv8CZ2GCR6Uq/27Aa+eQjrUqfnVExGQ9KOCrTHvqh/?=
 =?us-ascii?Q?wFfdpMoQsNjwA/89GlgVKDR5DQgXK8++aVnmppjV2RsiMC/3bY+6Et+1rkiA?=
 =?us-ascii?Q?qlj2x6ncicpPvccnRvyDFR6BMKfX8RJlvx0XuseZWGXz8MgF2QoecjVXKuye?=
 =?us-ascii?Q?RWesyEKXrSziGdB+/1z04D73eWTfuHAvMygnHpIa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a39548ac-d279-4945-3b19-08db345eb731
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 16:16:00.9659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HfR91IvOki4Mylz1Da7YmxO2NxdA1kzKzIoH+D6EAGQbyyqEZ76b9ZRP0EnKGXAt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7775
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--mfOlftgNv8IJ9EAe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alex,

Here is the shared branch for the mdev changes

Yi, you should base your series on this commit 7d12578c5d508050554bcd9ca3d2331914d86d71.

Thanks,
Jason

The following changes since commit fe15c26ee26efa11741a7b632e9f23b01aca4cc6:

  Linux 6.3-rc1 (2023-03-05 14:52:03 -0800)

are available in the Git repository at:
  //git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git vfio_mdev_ops

for you to fetch changes up to 7d12578c5d508050554bcd9ca3d2331914d86d71:

  vfio: Check the presence for iommufd callbacks in __vfio_register_dev() (2023-03-31 13:43:32 -0300)

----------------------------------------------------------------
Nicolin Chen (1):
      iommufd: Create access in vfio_iommufd_emulated_bind()

Yi Liu (5):
      iommu/iommufd: Pass iommufd_ctx pointer in iommufd_get_ioas()
      vfio-iommufd: No need to record iommufd_ctx in vfio_device
      vfio-iommufd: Make vfio_iommufd_emulated_bind() return iommufd_access ID
      vfio/mdev: Uses the vfio emulated iommufd ops set in the mdev sample drivers
      vfio: Check the presence for iommufd callbacks in __vfio_register_dev()

 drivers/iommu/iommufd/device.c          | 56 +++++++++++++++++++++++++++++++++-----------------------
 drivers/iommu/iommufd/ioas.c            | 14 +++++++-------
 drivers/iommu/iommufd/iommufd_private.h |  4 ++--
 drivers/iommu/iommufd/selftest.c        | 14 +++++++++-----
 drivers/iommu/iommufd/vfio_compat.c     |  2 +-
 drivers/vfio/iommufd.c                  | 37 ++++++++++++++++++-------------------
 drivers/vfio/vfio_main.c                |  5 +++--
 include/linux/iommufd.h                 |  5 +++--
 include/linux/vfio.h                    |  1 -
 samples/vfio-mdev/mbochs.c              |  3 +++
 samples/vfio-mdev/mdpy.c                |  3 +++
 samples/vfio-mdev/mtty.c                |  3 +++
 12 files changed, 85 insertions(+), 62 deletions(-)

--mfOlftgNv8IJ9EAe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZCr7vAAKCRCFwuHvBreF
YUG2AP9u+3bdlDGQb6jBZkXkf6YHbCQ9lWcsGVQ+55HqyUIvIAD8DyM/E0To7nGG
/1yVWWz1Uq4WEZ79P0tc7xbFhErtogA=
=nQzI
-----END PGP SIGNATURE-----

--mfOlftgNv8IJ9EAe--
