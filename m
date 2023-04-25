Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D146EE427
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 16:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbjDYOq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 10:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbjDYOq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 10:46:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31ABA3A87;
        Tue, 25 Apr 2023 07:46:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FndvxulKoGqrhdNMlvSFjp5PQOfdyNgXbVwm8jxhyQGq1TmUMYgK5qmEzLAw/gZ6u0RihnkZezuzDUiARcHUbSs1aGI/D2Fz7/rbVjeyqiBBGDYNZct7ZBC6ihxKmKu0oalYBvRGQm5BcLLeY4Bd09a2a6LoGDqNoMDUfEye/MBa+nABY4DHASVTJg/EpLKi1IiP72skYPUiOENZYDUylupaT0fHQ3zWtDl4Tjd4zU5hLY4T2CPWCN593WnznyfQA/TxTTQjjaJWOLqnvlNlED4/hVCfxVf/rd9L1NT2iFKXWoGIzIoavLvoVUU5lNF0NGbWXzmR3IysH8bAEiFcVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UX5z0Fad3Met5akmfjPp3Zvut3tZRC9Pj/xj0VBJCI4=;
 b=g8KKi80FTM7LrWrCrDI1yikgzi+D0TwS7jkL20hfnCzP69DDKUp080nN3juhTNZYZk6SZG5H7Is6eJb0v6WOJXuxLxc+uKXEr8kGWVsiB8zdJFuyR0YcmXyxeUopkn8RNoI1Dpn5AfD/OA85KIwk67R+jiJBtF3Q3k/meWZBFyT5RBu0P/8CNfAW1Gvowg1vSTJxO6Yi9xafMEEsOC5G+23HeqyLH8LFtrlu2e8LMoQeR8SYOBV0OmAfkw6K+IlRKAasdSInPJf8Ab5W0Qf3+aVMeI0w44PcZsYirb5uZtfBRaJl2gCpeMF9DLXpvxuonjWd+i3AFiSmsNtNVYBUXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UX5z0Fad3Met5akmfjPp3Zvut3tZRC9Pj/xj0VBJCI4=;
 b=QE4lgZDOMOYSJhyAm9eZMzO87PwDeQXXk5Kg2flvnLpkD11xsMP0vkz80UgvkXHGnSdzy54+OYvFO1gO87ZGjluPkZtAjGU5oG7TFF/6CxYIsIZ+J+BCEqU5KxSrufKcZ/6Qwf8v/8QxS14TeZALTyivmMk4ay/pOWtUkvXSf5fzrpXj2KL27zJY4sxp6scuJCIUQIaV1pcRwDSIiPYdlz0rsm468rx49FscS1TgSZ4tX/rXAydeHspgHWAW8Y4Im3m6ta8f/32OESDS8MbtmzhFEvbcIImkvkW9mbtweD46hdKFt1S4BsE4tvgnDfUU6OAB9gnsYHeOXQ+HWezxAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7237.namprd12.prod.outlook.com (2603:10b6:303:22a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 14:46:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 14:46:20 +0000
Date:   Tue, 25 Apr 2023 11:46:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <ZEfnucryav8vI+og@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Tc5hITz70x7gRxTt"
Content-Disposition: inline
X-ClientProxiedBy: BY3PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:a03:255::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7237:EE_
X-MS-Office365-Filtering-Correlation-Id: b7a49b40-0123-47ed-e2c5-08db459bd579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BGqKk71htrR20QPz9yW7uuNMH4rDEIwfN6pLhuuoS9qSelAttQLNgJzD70RITDOoYwckAfPyuC89jMCiA7TR14QMdbpwOjTmAyZQrC9q4OSasrHZLoxiHUOSyAibYmlvKqve4NUuWxKO4ExXlaW2SmgE3AUwYdMjwce1kJiTH4gdnnfGwq98w/lsYOv6BzIjokdy2MRfvQ0+3tYevcxlVmXicvuv7dNek4WlEs31aHsJmltj0pDwfy8mOr3uWFwheilmk6kNfnNR83b8U3Tf8BJa0MlsfZGj+15Zrl+4FQOdOzvZvNtcfom6RNDlD4NFt7Wtes8iS8CtUQKJBcc30bnpSC0Q85DDFA36lYab2l3l8iPIvSjG0KnoaTP2V924kN5MDTUK9O2EQiBNUsnaPa6R8AWAJg/pJtui9P83fJA2U5bMrP5amV/yeoEQRmtLyNUnLdJuRlEB467NX/BpvFwC+lJzfxFbAigdA3Cvv+Q7yp8KetVU+imjx/mgQN2dDBS9CruJRGoAB7OOA4N00pWkf1GUVX4R2MIFMUM05bYFcYEUzD5wm3Ak5SAw5qkMR03EqdFr8OgcEExYimhZxwGST5Nx2jjNxPu4HD96GCm4Z4kS3AoxsF5giEzE5JlHEsNqGtk2xCCczgZmMTy+gjFsKVA61NbcojYVnnK55PtR8dUfGX3P2/5SnHXCrdc0Pf/zWySPCoCe49j9MFZEoE0KGv82frUrBOW2IeIcGf3Zgyut8qjex6xZmFxIOdhy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199021)(2906002)(66476007)(66556008)(66946007)(6916009)(4326008)(316002)(5660300002)(8936002)(8676002)(41300700001)(36756003)(86362001)(186003)(26005)(6512007)(21480400003)(38100700002)(478600001)(44144004)(6666004)(966005)(6486002)(83380400001)(2616005)(6506007)(2700100001)(67856001)(266184004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NFdoq0/OSWNmZYyrvo7y4ZkaKnh9OyDcv/3s3kapR3NTN8+pqPIzaHTSdGzt?=
 =?us-ascii?Q?ll1VHfS4jlEwZeWd/+fnreA6Rl2U9E1qTbfO+UNjQpTjT+I9FXCUp7QP+qSr?=
 =?us-ascii?Q?fZ3/kx8I/5doBGuncwPcHk2wJug62riZ+Z9/ISFg+J/ttXdIYlOXGrcECdAa?=
 =?us-ascii?Q?9+EgRHDKNQAWkA6Qbdto5k7TY8EklDHDxvsJ/KLmAoDtfmXMvI/sUfuT2uyi?=
 =?us-ascii?Q?6VOGRmNlab/GisWMtWZ4JCx1AVNG2Hca1GRabGSEtdIlN7K/vwUbE6zlN+7P?=
 =?us-ascii?Q?E3rfCZbDvzRNg135UuvDqtDOIobBGD4Tr+mWg5vEkHlxXKh+RgstObNLZgIy?=
 =?us-ascii?Q?+6aPcdges4GNOUk5ispxkXTqDH68H1YAmy5CyR91Z7DqaVgfAY/YOwD/TuKm?=
 =?us-ascii?Q?lgko2OK/pKp1dPbVh1xxc4G43EHaakrIsssVh1JAJ7bj6kHsiCKudfp2iUkX?=
 =?us-ascii?Q?fORW5svfGpRYVWnwTySAYr5FClq4/tl/Vue9w6CVNXttKA0sW9lkuMz5VY/b?=
 =?us-ascii?Q?c96NPf1WjTgp9mxBkhzWvQacThfRLaLOSmQ7BbI0PdZGIxmQV2RwtpBHYVdS?=
 =?us-ascii?Q?blTuu1AK8dB0EEy82fgHpAH55i0hmzUvKRifJBg9HBMEP3yFZFhYJTMtiG8R?=
 =?us-ascii?Q?Okt6qDIlNFxLMawc7fyp89To9zashcK1Hxx42mJt8bl2ORlAcRLe8Moy4IL6?=
 =?us-ascii?Q?AH3I4bXQ08DIpoJZ8AGKP1wyjq0VT3FrSQ7VCcM8g1kMffja/f8cShT49ndz?=
 =?us-ascii?Q?1YgnOU2XrG/1lUbrpxcjDKxLgNXkoooI/AxLIBd62fQkDe1NMWtK0PHie/hR?=
 =?us-ascii?Q?SwRTPuqtyIuKoCyBUD6R4NMUC1fNfMF5nLZZz/kj1FLOe+8AAhIgxePj6LCe?=
 =?us-ascii?Q?T58RSc2yxfawOfnF8dpaUtWywE8XO3wpKaCPIcSapj13t8Ixgz8cyCF3raU0?=
 =?us-ascii?Q?cQeqVo/nP+cnvuBE8cK9Nzt6vbKblzoiIezM1zW+trFpOeFX2+vgC0pm1xR5?=
 =?us-ascii?Q?YGBNVXoFifsAqJwK/vsQP9ZspXf3dRI1ouWV7VnhMwvuxOguDS1pBhueOVED?=
 =?us-ascii?Q?9Z5qELIarCXgX5sPoNwGn2y2Xc4Bvb5M72HuRna+G/ifKJfyxssNxgTg4CRL?=
 =?us-ascii?Q?ICcv5jqNbGISsmXHSAlXgsMJkAhX3KGr+kgSuh4CwTgCJDci3S/eSwAUYSgp?=
 =?us-ascii?Q?ifjCiTqGHM4Y/njMi2THz/rOYhLoJJ69SJ20IwH5pfoBF6nDErLya8sEVCDO?=
 =?us-ascii?Q?eY6Xv5hAotqNd3MFFIim51JubnXi5kaEDIA6IIi2pe/MWLs6kAmbY2iD8vKO?=
 =?us-ascii?Q?ctbi3j6le7aGytUtB7u8AbUqtXht9ySXBn/5aClkip/GF1/xPQW7cktZGA6e?=
 =?us-ascii?Q?x81jc3Kxc4EvhNsasyDUnXA4VopG80yk4jv2Z3drfeXDS61r1/6gY+GsoPYT?=
 =?us-ascii?Q?3URIA7SQPnNgKEqaciwMO0BBhlIOnM4JPlfDjWrv8xh3+HjTTri2SL7mmYoM?=
 =?us-ascii?Q?Qcp+1t+dPuPab/UpxCcovw6jlh0dYUFcN+NC0Pi8JS1vzO5G07uzmtkzDxZQ?=
 =?us-ascii?Q?v6uS1gYU0vrICV9n8aQTiy2v0gABlqEwBdg3dcw2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7a49b40-0123-47ed-e2c5-08db459bd579
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 14:46:20.8807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSny2pUXZ5+KZH+iQ8UxBqGrzB7ZB2z7HWXjUMDCbcCfTc36yCFGHsOBGwybljqk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7237
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Tc5hITz70x7gRxTt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

We did not manage to get the VFIO parts ready for this cycle, but it
looks really close now. Here is the stuff still in progress:

- VFIO PCI hot reset support for iommufd:
  https://lore.kernel.org/kvm/20230401144429.88673-1-yi.l.liu@intel.com/

- VFIO device cdev support to allow exposing all the iommufd features:
  https://lore.kernel.org/kvm/20230401151833.124749-1-yi.l.liu@intel.com/

- iommufd page table replace operation:
  https://lore.kernel.org/kvm/0-v6-fdb604df649a+369-iommufd_alloc_jgg@nvidia.com/

- IOMMU driver information query:
  https://lore.kernel.org/kvm/20230309075358.571567-1-yi.l.liu@intel.com/

- Intel VT-d nested translation:
  https://lore.kernel.org/kvm/20230309082207.612346-1-yi.l.liu@intel.com/

- ARM SMMUv3 nested translation:
  https://lore.kernel.org/linux-iommu/cover.1678348754.git.nicolinc@nvidia.com/

Along with qemu patches implementing iommufd:
https://lore.kernel.org/qemu-devel/20230131205305.2726330-1-eric.auger@redhat.com/

And draft patches for the qemu side support for nested translation.

This PR is some small fixes and two preperatory reworks for the above
series.

Thanks,
Jason

The following changes since commit 13a0d1ae7ee6b438f5537711a8c60cba00554943:

  iommufd: Do not corrupt the pfn list when doing batch carry (2023-04-04 09:10:55 -0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 62e37c86bf0718e1ec0156c7a88a43ced6cdf201:

  iommufd/selftest: Cover domain unmap with huge pages and access (2023-04-04 13:11:24 -0300)

----------------------------------------------------------------
iommufd for 6.4

Two series:

 - Reorganize how the hardware page table objects are managed,
   particularly their destruction flow. Increase the selftest
   test coverage in this area by creating a more complete mock
   iommu driver.

   This is preparation to add a replace operation for HWPT binding,
   which is done but waiting for the VFIO parts to complete so there
   is a user.

 - Split the iommufd support for "access" to make it two step - allocate
   an access then link it to an IOAS. Update VFIO and have VFIO always
   create an access even for the VFIO mdevs that never do DMA.

   This is also preperation for the replace VFIO series that will allow
   replace to work on access types as well.

Three minor fixes:

 - Sykzaller found the selftest code didn't check for overflow when
   processing user VAs

 - smatch noted a .data item should have been static

 - Add a selftest that reproduces a syzkaller bug for batch carry already
   fixed in rc

----------------------------------------------------------------
Jason Gunthorpe (16):
      iommufd: Assert devices_lock for iommufd_hw_pagetable_has_group()
      iommufd: Add iommufd_lock_obj() around the auto-domains hwpts
      iommufd: Consistently manage hwpt_item
      iommufd: Move ioas related HWPT destruction into iommufd_hw_pagetable_destroy()
      iommufd: Move iommufd_device to iommufd_private.h
      iommufd: Make iommufd_hw_pagetable_alloc() do iopt_table_add_domain()
      iommufd/selftest: Rename the sefltest 'device_id' to 'stdev_id'
      iommufd/selftest: Rename domain_id to stdev_id for FIXTURE iommufd_ioas
      iommufd/selftest: Rename domain_id to hwpt_id for FIXTURE iommufd_mock_domain
      iommufd/selftest: Rename the remaining mock device_id's to stdev_id
      iommufd/selftest: Make selftest create a more complete mock device
      iommufd/selftest: Add a selftest for iommufd_device_attach() with a hwpt argument
      iommufd/selftest: Catch overflow of uptr and length
      Merge branch 'vfio_mdev_ops' into iommufd.git for-next
      Merge branch 'iommufd/for-rc' into for-next
      iommufd/selftest: Cover domain unmap with huge pages and access

Nicolin Chen (1):
      iommufd: Create access in vfio_iommufd_emulated_bind()

Tom Rix (1):
      iommufd/selftest: Set varaiable mock_iommu_device storage-class-specifier to static

Yi Liu (5):
      iommu/iommufd: Pass iommufd_ctx pointer in iommufd_get_ioas()
      vfio-iommufd: No need to record iommufd_ctx in vfio_device
      vfio-iommufd: Make vfio_iommufd_emulated_bind() return iommufd_access ID
      vfio/mdev: Uses the vfio emulated iommufd ops set in the mdev sample drivers
      vfio: Check the presence for iommufd callbacks in __vfio_register_dev()

 drivers/iommu/iommufd/device.c                   | 205 +++++++++------------
 drivers/iommu/iommufd/hw_pagetable.c             |  70 ++++++--
 drivers/iommu/iommufd/ioas.c                     |  14 +-
 drivers/iommu/iommufd/iommufd_private.h          |  39 +++-
 drivers/iommu/iommufd/iommufd_test.h             |   2 +-
 drivers/iommu/iommufd/selftest.c                 | 219 +++++++++++++++++++----
 drivers/iommu/iommufd/vfio_compat.c              |   2 +-
 drivers/vfio/iommufd.c                           |  37 ++--
 drivers/vfio/vfio_main.c                         |   5 +-
 include/linux/iommufd.h                          |   5 +-
 include/linux/vfio.h                             |   1 -
 samples/vfio-mdev/mbochs.c                       |   3 +
 samples/vfio-mdev/mdpy.c                         |   3 +
 samples/vfio-mdev/mtty.c                         |   3 +
 tools/testing/selftests/iommu/iommufd.c          | 104 +++++++----
 tools/testing/selftests/iommu/iommufd_fail_nth.c |  38 ++--
 tools/testing/selftests/iommu/iommufd_utils.h    |  16 +-
 17 files changed, 494 insertions(+), 272 deletions(-)

--Tc5hITz70x7gRxTt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZEfntwAKCRCFwuHvBreF
YW52AQC/FEaSk5DclfIGxjJcuS54dzWDxGIq/F9DVDMEUYM08QD+PxmJV6c/pTsP
4de/B6ZDr2MLB7zP9HNibmilZDdk3QA=
=b7Uz
-----END PGP SIGNATURE-----

--Tc5hITz70x7gRxTt--
