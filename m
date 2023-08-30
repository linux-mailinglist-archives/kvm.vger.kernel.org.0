Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F2478E364
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 01:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344545AbjH3Xk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 19:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344536AbjH3Xk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 19:40:56 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C89198;
        Wed, 30 Aug 2023 16:40:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdzIQFETseI2QV70dnPpww70cv45SCeOmDG5XNUKSYLzqoijYcBV6ht2H63rM814eiC7Af4RWtUG4T84gSJiN8Rz42T2wBf6sVZgBjoAP5XkMCws++hA6Fo7oiK2HrD8FJFggmaMO+Ic193djMkKG4BEBwngP0h1gblkprOZoCEISg0XFmkSqCgFLK3pPyTfgKAksp8E3ea0vvHOr1UTB78OlCuUXmJOMCD8aqP7NojcXmIrK5UWLyWo4lPPD9oSmwn71qeHwhOXL1zg+Qsv//tljqzn8JqHdizOBaEL3qWa0kSjFr4CUULyRQ3pjY6T4LZ9ap/11WSrokXvhmKdIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVRDDH7iEt1xW+XdNlxY+/EfTnM4A3jm0dul3GMkNpQ=;
 b=Hnwz2Lcog/COjw45HGKNXm5dYm79fborIl77pfuR0QruAkqM05fH8i4Yu+3gMRDOnmugxqKfQkEcBBWOxLZsod+6+TiEQgY4sa6EadSfBuYwV3yWdoig90rIxR1MTUGpWvU19+IuXKJbZOez9xe7Lk6d2NWnCFr9fO+CaKMsxldmh6eDSlMw8i8E6r6H+3ePCdt6RJrb4t4r8AixRPgGZ8iXc/1MhYcSj9dM3SiyEQGzzIJu0PSwj3mdke4I76RgkUa89EjJOkS3DLJ5xwvNY6u/0FbRaX9/trYfnVH1rGYxu4FunbFeDGGsVwIcfxalEww1Jp4GVSH7CzVNqTFPSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVRDDH7iEt1xW+XdNlxY+/EfTnM4A3jm0dul3GMkNpQ=;
 b=Aq8tOGi0HtohINh5ZUAghOrxoon1UIlYCN6/5+cMdg4CBOBaM4r55q4C00khOiXyqwmwiXsl2BMlqx7nbLnjVZZ6j5NzOhR3B8OQHvCgP8ApRxgtpoDRZZdw2mkekmfk2NeXWZkOejLk1up/fXlY0a7LdIqa/rhRoWON5xR4UI6LRm5L6mKTZhAbz3eZ3XmxA6AH91LhFdc4PMIFnAXENS8lwE12fchgFHn0chsj4J+Wu5VCGyy8q7wowtniUITDYz5d4Iif9AQTZkVyxSWHUwpwEikv+gQF/4o3/UYDGlk2ABI3gtMJLLKdoyKnXsxJ4rze3rYVcwpkSKVmE9xrMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7098.namprd12.prod.outlook.com (2603:10b6:930:62::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.29; Wed, 30 Aug
 2023 23:40:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6745.020; Wed, 30 Aug 2023
 23:40:44 +0000
Date:   Wed, 30 Aug 2023 20:40:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <ZO/Te6LU1ENf58ZW@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YfoF2lUpkICbgCZl"
Content-Disposition: inline
X-ClientProxiedBy: CH0PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:610:76::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: c3ab1b59-65dd-4461-3a38-08dba9b2875f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/Zyud3AyqyyrZqkYHMREW2qDzR8Lz+ZHBaO5tujAF+cXlu359scS/j8vUprqPQP2ipHedFWUIVkoqH+o/CIgBDBFPpII63RFyLqlQAFywHAfmqIMTq5JLVVQk/HYeSZm442CvY4ZKjOq0oFIr8VG+hQlunl1lML3kln4fyCQz3NU4ArfVOrslDwIMZIjhVzcQnM5X8ipDoyvfDHzpfFXLYTmGuSo7Ywrk02FcXmIl4p6hDJl9xVwzEXSNIh7cw2ybRbS0SFNubUFKifnU0RcXMiW8+ubywhrArHDZ2o/taqh2sno5gcxUqptC9Wua6utuU7Z1WzgQoM4ZY09XAYEczVqmx2/OpU2FeA7D/aV6/cGYymtuuCvbxqKCwmmGCCDofK1/GIus1yLKjle2DsGpWSJQlEneF5RXy/y05sak2CRGFY/hUdH1HLIyPcIVxkTw6E221bZy4sRt5pu2Kh27qEQxAMbmv0dAUSUd5el6Y02pH30RZWvElnrAOxIHHNMioKRSasiQ6L+8W6us5LiZX2O3ZYc5j2P3yyugciFKqH6RSxruozvCZpkc9FBT0hqHp8YbM353lrVAk+9Roudwxysy57+bIEufUWGniy6NIf8ttDZcz9pYwv/XxPCDAswm9KP249IR2G7cWprxm9KorCV0xGwMq63OOZTKPqshA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(366004)(39860400002)(376002)(1800799009)(451199024)(186009)(6512007)(6486002)(6506007)(86362001)(36756003)(38100700002)(2616005)(478600001)(30864003)(44144004)(21480400003)(83380400001)(26005)(966005)(8936002)(4326008)(5660300002)(66946007)(66476007)(2906002)(66556008)(41300700001)(316002)(8676002)(6916009)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OBO0Dj6bDdA8zUtfXbXHV+WDaMj5phR61jvsATU1S1EgrJ0klp/3yQ/RH8GY?=
 =?us-ascii?Q?+3KUMhoCozM8Y55aNyTPsz00mFjJLnI2nh/yWtMOo2BRA1qbj6AH8kHEHiHG?=
 =?us-ascii?Q?c4Z5viRzWBQ3pC7I5s7Vw3coOWwARveWAMUAV4Ma2uPc/A2M8UwMMJJCEWnq?=
 =?us-ascii?Q?ZLyc6HdGx4nWN3j8ckCswNLmctRQlTdjGDqOuYDJn5uiTYyle514rOMIzTWk?=
 =?us-ascii?Q?P5rCYe95kauO20/NXdw+fgIuhUwCzRo55Lno5XDGkdGAye9LvbnK/VdruW1i?=
 =?us-ascii?Q?0K4NpPcqrgX7y7a25P3ZfCpPJ5yhDiln+4s008/Hmsmnpg77VLqXll3j+NO5?=
 =?us-ascii?Q?1bDotiu8STmVzb+AGvcMrbDuaKf4Fvauowqlmo17uyHaRSq8guyTsCrjz57+?=
 =?us-ascii?Q?kyjE/8Y6XSbJXQ2THuzc5YVaR56g2yJ3LHe8bkcKtu6PlSFxOv848zo4nU6W?=
 =?us-ascii?Q?FeTYXPixU9V2uUwJiAvcXRVkyWzSmPg6RsxJZzREd77TlWeKZCxyP/kRqpEH?=
 =?us-ascii?Q?7l62vPGPLa6k6tfF3qAI6xI1/LVfXRPdYKAGGicNbGNT8hon8HMg4WhkZ320?=
 =?us-ascii?Q?taY3IkZlhv7PR9uxJKhBkkDqgch28f1PnhbI8TPuS1gHnZGmwGvIHLA1UhN1?=
 =?us-ascii?Q?U0K14mVZmRGuITWwYT0OYd6IYfbP9cM0TUEXwD8+eftrEVdgKQa7yCAGi2/2?=
 =?us-ascii?Q?alC2MkvVvXDg4Od6t6LfDdjniO1McL5oaqVeUcmuixSwhQz3XMIu6DrNNoon?=
 =?us-ascii?Q?8TxXV6EQ2+1LVPfRTQDsNmQoqp42vsx9v+di4jgs5TAPqjP5Z698pzemdGh6?=
 =?us-ascii?Q?LnVN3AJP34aXB9TJWl6KjfZISM5SdAR5FF4nYlOArAYnsnWIVqYN5h5oWqjQ?=
 =?us-ascii?Q?Os0C0GpnCVK8N1bGlOMRirY5AaDhpBmwrAjdeE8QoHG5vWo0Az6JliB+xE5G?=
 =?us-ascii?Q?GdIogO7jgpqvGrAuGtjhBvYHZVMNKLp9gFfHrLEA4N1zjFZu5YB3afdjpP4x?=
 =?us-ascii?Q?FusHI/6i1mfSGYx/NRW+VNSfNVNObX7o8nz3ZpdEV17GgZ07CFeUH8mipSHa?=
 =?us-ascii?Q?a1JlYogKguP1I6p5V2eMGT/Kg7ZC85/sQH0dqLngIdKlg5dQJBQJHgqc19iL?=
 =?us-ascii?Q?pQVxevTvCaG5LYQ+0bAy9fcLSI2SVT/H+FAPfGyCjDCuM7RkJVweM4Pb5bUV?=
 =?us-ascii?Q?+N1Uudu7UOUB66tg8ZzCcIrulRojfDyVxAuEbQnism4vvjCIusQDV+EjhNaK?=
 =?us-ascii?Q?oNreIJiiKRVRRhstxN5XUdJtT0pS/fWFjrqo2cVw6gvZg7t8dMl4XE3z7Yvi?=
 =?us-ascii?Q?2NQwNECf4wwwkrV1ppzeNmDYjLMmyfsjy8iBvbpZgyDOTO5caybfEWWMpSYQ?=
 =?us-ascii?Q?G//DU2hgBeXPf+WODYGimZ8CWsnAtWcs+xs4DtJzkIFhniVwZPqIP9s5AYip?=
 =?us-ascii?Q?ypaQIeAIVyHmFZ01McbNJTUHcKaB2dBr6jT/2KDDM9DZTrdwtm0O+72VUACP?=
 =?us-ascii?Q?OhMJWAqqdLWQDjverVTZmqbaCWpjOkoIX/6+z5h12bIGhifHwgZQkMVTa8F3?=
 =?us-ascii?Q?XMhDTxnnhh51ahVCY3U6FucLbZ7/lb+DJ92Y2REh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ab1b59-65dd-4461-3a38-08dba9b2875f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2023 23:40:44.6246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4/58EMPF8pOXKSAHD+7MnhMP8+r70rFX82xCbWgq5HjvILMMpD+Tc1Q990sQWEsq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7098
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--YfoF2lUpkICbgCZl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

This PR includes several of the items that have been in progress for quite
some time now, details in the tag.

For those following, these series are still progressing:

- User page table invalidation:
 https://lore.kernel.org/all/20230724110406.107212-1-yi.l.liu@intel.com/

- Intel VT-d nested translation:
 https://lore.kernel.org/all/20230724111335.107427-1-yi.l.liu@intel.com/

- ARM SMMv3 nested translation:
 https://lore.kernel.org/all/cover.1683688960.git.nicolinc@nvidia.com/

- Draft AMD IOMMU nested translation:
 https://lore.kernel.org/all/20230621235508.113949-1-suravee.suthikulpanit@amd.com/

There is also alot of ongoing work to generically enable PASID support in all
the IOMMU drivers:
 SMMUv3:
   https://lore.kernel.org/linux-iommu/20230621063825.268890-1-mshavit@google.com/
 AMD:
   https://lore.kernel.org/all/20230821104227.706997-1-vasant.hegde@amd.com/
   https://lore.kernel.org/all/20230821104956.707235-1-vasant.hegde@amd.com/
   https://lore.kernel.org/all/20230816174031.634453-1-vasant.hegde@amd.com/

Which will see exposure through the iommufd uAPI soon.

Along with qemu patches implementing iommufd:
 https://lore.kernel.org/all/20230830103754.36461-1-zhenzhong.duan@intel.com/

Draft patches for the qemu side support for nested translation support in
the vIOMMU drivers are linked from the above.

Thanks,
Jason

The following changes since commit 2ccdd1b13c591d306f0401d98dedc4bdcd02b421:

  Linux 6.5-rc6 (2023-08-13 11:29:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to eb501c2d96cfce6b42528e8321ea085ec605e790:

  iommufd/selftest: Don't leak the platform device memory when unloading the module (2023-08-18 12:56:24 -0300)

----------------------------------------------------------------
iommufd for 6.6

This includes a shared branch with VFIO:

 - Enhance VFIO_DEVICE_GET_PCI_HOT_RESET_INFO so it can work with iommufd
   FDs, not just group FDs. This removes the last place in the uAPI that
   required the group fd.

 - Give VFIO a new device node /dev/vfio/devices/vfioX (the so called cdev
   node) which is very similar to the FD from VFIO_GROUP_GET_DEVICE_FD.
   The cdev is associated with the struct device that the VFIO driver is
   bound to and shows up in sysfs in the normal way.

 - Add a cdev IOCTL VFIO_DEVICE_BIND_IOMMUFD which allows a newly opened
   /dev/vfio/devices/vfioX to be associated with an IOMMUFD, this replaces
   the VFIO_GROUP_SET_CONTAINER flow.

 - Add cdev IOCTLs VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT to allow the IOMMU
   translation the vfio_device is associated with to be changed. This is a
   significant new feature for VFIO as previously each vfio_device was
   fixed to a single translation.

   The translation is under the control of iommufd, so it can be any of
   the different translation modes that iommufd is learning to create.

At this point VFIO has compilation options to remove the legacy interfaces
and in modern mode it behaves like a normal driver subsystem. The
/dev/vfio/iommu and /dev/vfio/groupX nodes are not present and each
vfio_device only has a /dev/vfio/devices/vfioX cdev node that represents
the device.

On top of this is built some of the new iommufd functionality:

 - IOMMU_HWPT_ALLOC allows userspace to directly create the low level
   IO Page table objects and affiliate them with IOAS objects that hold
   the translation mapping. This is the basic functionality for the
   normal IOMMU_DOMAIN_PAGING domains.

 - VFIO_DEVICE_ATTACH_IOMMUFD_PT can be used to replace the current
   translation. This is wired up to through all the layers down to the
   driver so the driver has the ability to implement a hitless
   replacement. This is necessary to fully support guest behaviors when
   emulating HW (eg guest atomic change of translation)

 - IOMMU_GET_HW_INFO returns information about the IOMMU driver HW that
   owns a VFIO device. This includes support for the Intel iommu, and
   patches have been posted for all the other server IOMMU.

Along the way are a number of internal items:

 - New iommufd kapis iommufd_ctx_has_group(), iommufd_device_to_ictx(),
   iommufd_device_to_id(), iommufd_access_detach(), iommufd_ctx_from_fd(),
   iommufd_device_replace()

 - iommufd now internally tracks iommu_groups as it needs some per-group
   data

 - Reorganize how the internal hwpt allocation flows to have more robust
   locking

 - Improve the access interfaces to support detach and replace of an IOAS
   from an access

 - New selftests and a rework of how the selftests creates a mock iommu
   driver to be more like a real iommu driver

----------------------------------------------------------------
Jason Gunthorpe (21):
      Merge branch 'v6.6/vfio/cdev' of https://github.com/awilliam/linux-vfio into iommufd for-next
      iommufd: Move isolated msi enforcement to iommufd_device_bind()
      iommufd: Add iommufd_group
      iommufd: Replace the hwpt->devices list with iommufd_group
      iommu: Export iommu_get_resv_regions()
      iommufd: Keep track of each device's reserved regions instead of groups
      iommufd: Use the iommufd_group to avoid duplicate MSI setup
      iommufd: Make sw_msi_start a group global
      iommufd: Move putting a hwpt to a helper function
      iommufd: Add enforced_cache_coherency to iommufd_hw_pagetable_alloc()
      iommufd: Allow a hwpt to be aborted after allocation
      iommufd: Fix locking around hwpt allocation
      iommufd: Reorganize iommufd_device_attach into iommufd_device_change_pt
      iommufd: Add iommufd_device_replace()
      iommufd: Make destroy_rwsem use a lock class per object type
      iommufd: Add IOMMU_HWPT_ALLOC
      iommufd/selftest: Return the real idev id from selftest mock_domain
      iommufd/selftest: Add a selftest for IOMMU_HWPT_ALLOC
      iommufd/selftest: Make the mock iommu driver into a real driver
      Merge tag 'v6.5-rc6' into iommufd for-next
      iommufd: Remove iommufd_ref_to_users()

Lu Baolu (1):
      iommu: Add new iommu op to get iommu hardware information

Nicolin Chen (11):
      iommufd/device: Add iommufd_access_detach() API
      iommu: Introduce a new iommu_group_replace_domain() API
      iommufd/selftest: Test iommufd_device_replace()
      vfio: Do not allow !ops->dma_unmap in vfio_pin/unpin_pages()
      iommufd: Allow passing in iopt_access_list_id to iopt_remove_access()
      iommufd: Add iommufd_access_change_ioas(_id) helpers
      iommufd: Use iommufd_access_change_ioas in iommufd_access_destroy_object
      iommufd: Add iommufd_access_replace() API
      iommufd/selftest: Add IOMMU_TEST_OP_ACCESS_REPLACE_IOAS coverage
      vfio: Support IO page table replacement
      iommufd/selftest: Add coverage for IOMMU_GET_HW_INFO ioctl

Yang Yingliang (1):
      iommufd/selftest: Don't leak the platform device memory when unloading the module

Yi Liu (38):
      vfio/pci: Update comment around group_fd get in vfio_pci_ioctl_pci_hot_reset()
      vfio/pci: Move the existing hot reset logic to be a helper
      iommufd: Reserve all negative IDs in the iommufd xarray
      iommufd: Add iommufd_ctx_has_group()
      iommufd: Add helper to retrieve iommufd_ctx and devid
      vfio: Mark cdev usage in vfio_device
      vfio: Add helper to search vfio_device in a dev_set
      vfio/pci: Extend VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
      vfio/pci: Copy hot-reset device info to userspace in the devices loop
      vfio/pci: Allow passing zero-length fd array in VFIO_DEVICE_PCI_HOT_RESET
      vfio: Allocate per device file structure
      vfio: Refine vfio file kAPIs for KVM
      vfio: Accept vfio device file in the KVM facing kAPI
      kvm/vfio: Prepare for accepting vfio device fd
      kvm/vfio: Accept vfio device file from userspace
      vfio: Pass struct vfio_device_file * to vfio_device_open/close()
      vfio: Block device access via device fd until device is opened
      vfio: Add cdev_device_open_cnt to vfio_group
      vfio: Make vfio_df_open() single open for device cdev path
      vfio-iommufd: Move noiommu compat validation out of vfio_iommufd_bind()
      vfio-iommufd: Split bind/attach into two steps
      vfio: Record devid in vfio_device_file
      vfio-iommufd: Add detach_ioas support for physical VFIO devices
      vfio-iommufd: Add detach_ioas support for emulated VFIO devices
      vfio: Move vfio_device_group_unregister() to be the first operation in unregister
      vfio: Move device_del() before waiting for the last vfio_device registration refcount
      vfio: Add cdev for vfio_device
      vfio: Test kvm pointer in _vfio_device_get_kvm_safe()
      iommufd: Add iommufd_ctx_from_fd()
      vfio: Avoid repeated user pointer cast in vfio_device_fops_unl_ioctl()
      vfio: Add VFIO_DEVICE_BIND_IOMMUFD
      vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
      vfio: Move the IOMMU_CAP_CACHE_COHERENCY check in __vfio_register_dev()
      vfio: Compile vfio_group infrastructure optionally
      docs: vfio: Add vfio device cdev description
      iommu: Move dev_iommu_ops() to private header
      iommufd: Add IOMMU_GET_HW_INFO
      iommu/vt-d: Implement hw_info for iommu capability query

 Documentation/driver-api/vfio.rst                | 147 ++++-
 Documentation/virt/kvm/devices/vfio.rst          |  47 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c                 |   1 +
 drivers/iommu/intel/iommu.c                      |  19 +
 drivers/iommu/iommu-priv.h                       |  30 +
 drivers/iommu/iommu.c                            |  81 ++-
 drivers/iommu/iommufd/Kconfig                    |   4 +-
 drivers/iommu/iommufd/device.c                   | 801 ++++++++++++++++++-----
 drivers/iommu/iommufd/hw_pagetable.c             | 112 +++-
 drivers/iommu/iommufd/io_pagetable.c             |  36 +-
 drivers/iommu/iommufd/iommufd_private.h          |  86 +--
 drivers/iommu/iommufd/iommufd_test.h             |  19 +
 drivers/iommu/iommufd/main.c                     |  61 +-
 drivers/iommu/iommufd/selftest.c                 | 213 ++++--
 drivers/s390/cio/vfio_ccw_ops.c                  |   1 +
 drivers/s390/crypto/vfio_ap_ops.c                |   1 +
 drivers/vfio/Kconfig                             |  27 +
 drivers/vfio/Makefile                            |   3 +-
 drivers/vfio/device_cdev.c                       | 228 +++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                |   1 +
 drivers/vfio/group.c                             | 173 +++--
 drivers/vfio/iommufd.c                           | 145 +++-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c   |   2 +
 drivers/vfio/pci/mlx5/main.c                     |   1 +
 drivers/vfio/pci/vfio_pci.c                      |   1 +
 drivers/vfio/pci/vfio_pci_core.c                 | 250 ++++---
 drivers/vfio/platform/vfio_amba.c                |   1 +
 drivers/vfio/platform/vfio_platform.c            |   1 +
 drivers/vfio/vfio.h                              | 218 +++++-
 drivers/vfio/vfio_main.c                         | 258 +++++++-
 include/linux/iommu.h                            |  16 +-
 include/linux/iommufd.h                          |   9 +
 include/linux/vfio.h                             |  66 +-
 include/uapi/linux/iommufd.h                     |  97 +++
 include/uapi/linux/kvm.h                         |  13 +-
 include/uapi/linux/vfio.h                        | 148 ++++-
 samples/vfio-mdev/mbochs.c                       |   1 +
 samples/vfio-mdev/mdpy.c                         |   1 +
 samples/vfio-mdev/mtty.c                         |   1 +
 tools/testing/selftests/iommu/iommufd.c          | 130 +++-
 tools/testing/selftests/iommu/iommufd_fail_nth.c |  71 +-
 tools/testing/selftests/iommu/iommufd_utils.h    | 144 +++-
 virt/kvm/vfio.c                                  | 137 ++--
 43 files changed, 3130 insertions(+), 672 deletions(-)
 create mode 100644 drivers/iommu/iommu-priv.h
 create mode 100644 drivers/vfio/device_cdev.c

--YfoF2lUpkICbgCZl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZO/TeQAKCRCFwuHvBreF
YS8RAP42jC28E/IRORQ36hWYLG8T5IwuhdFMHUrG1+P8TzRW4wEAniIX1ZW6mLZd
cLUyzBVONFp9bB/USW0XHf9BQLApDAM=
=keMH
-----END PGP SIGNATURE-----

--YfoF2lUpkICbgCZl--
