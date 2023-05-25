Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54C9711AC8
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 01:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241563AbjEYXnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 19:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241274AbjEYXnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 19:43:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA9F187;
        Thu, 25 May 2023 16:43:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OazXdLj0ws0DNd/KsQNiuNuWIAih3+RK1Sd9bZ3YEE/yEWZfztlOr7xg1YhnvN2OOlo291MpvqQa7IWGP77aOZtYa8brTuv7vi2jj5mao8GrVTdi5A3spBspjb8TU/sg6wfzv8MPVc17cDjFiOHuxxLzk2ZgD/eZF+RKn0LeLYvM33GP3YfXVawq1dopSU71/N1zyLxoNdrp5onQDYxz8MzYDT2nJtkR6JsfFi4yqHJg9xIav/lIWUkcOkpXtaeBEmtPRg3wLcEBqPdF2NJUoJ4o8eLqgoqkGKMzySz/1OLHgCvViE3ZVymvwnBynHi3aWutN37rLCtqTg010y1rZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fWWiMAlzOl6qy78Kzst/nTUPjTFrI3dJTCOzIG6Dbvk=;
 b=J9LYI5tA6w0n9S0/SVTMljjErLx3t0wXvTFpF5nQa0dTgZVowNx6U/t6vYjaeP7tj1oXk8YoR8/oeDO+xZqINILooxnu/abV5tx1aAm2C/CQI/t9vlNvy+ABZy84TYE6wGqO5rNwQks2AEV4pIMfOTWhQaoKXUkB7ckiVDuty3Fy1+v7VBK3Cwz6UK1s18JM32XReHwLwyUW1cSEFcVGz+yLlribj88BL8VtDTa94qt2P7/NmteoPiugcu3opIxMPgP3xYDmw5Js6PyIvVq1sYrRniF75ZB+UU741HeasjkIEFyPdhqpYzAvmgmKmfNRHjapzeqYpMKEyvgcTk0Scg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linaro.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWWiMAlzOl6qy78Kzst/nTUPjTFrI3dJTCOzIG6Dbvk=;
 b=JK1k+Kl/4Mkk90kZeqSWpHx9BFLFPZL/gc8NErt094AuGwDyIKstmEmFhRTcDf/3A8L7y+/v+Rhx3q8e5sLqZBnp7IDkM+m5qhHu6uokzGvp8xteImZBfWT5zUEFHSACQ1Kw9iGtkJVql6d8b0FWeMkidaFHc6pEcpcgTWI1qbhwgU5sEwngOdr2XI5ycZhTOTarsLGWzLKk9CWAwGOWXnzASpgiyErSa2dJpGQfnIWXs5ofsMsah5HjitTlOWrGbn0ymEf6i+DBUas1JOoqmbwVfztY6DBCjbxyiT91hhJWLWtQXkkh1LroATCr7GapDFRFTcmM2+lO9i3ZGkmIyw==
Received: from DM6PR02CA0051.namprd02.prod.outlook.com (2603:10b6:5:177::28)
 by IA1PR12MB8334.namprd12.prod.outlook.com (2603:10b6:208:3ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 23:43:09 +0000
Received: from DS1PEPF0000E642.namprd02.prod.outlook.com
 (2603:10b6:5:177:cafe::d5) by DM6PR02CA0051.outlook.office365.com
 (2603:10b6:5:177::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16 via Frontend
 Transport; Thu, 25 May 2023 23:43:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E642.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.8 via Frontend Transport; Thu, 25 May 2023 23:43:07 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 25 May 2023
 16:42:59 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 25 May
 2023 16:42:59 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Thu, 25 May 2023 16:42:58 -0700
Date:   Thu, 25 May 2023 16:42:56 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
CC:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>,
        <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 00/17] Add Nested Translation Support for SMMUv3
Message-ID: <ZG/ygPy1XbSSNzR4@Asurada-Nvidia>
References: <cover.1683688960.git.nicolinc@nvidia.com>
 <CABQgh9FL4ssQjBJM52_kb0aBVVPb_9Wc0Q+NL1PaQO=2LYBHCA@mail.gmail.com>
 <ZGJWgFVJDWxVpiBE@Asurada-Nvidia>
 <CABQgh9FMGPnUpz6tc6c27i6nT0Lcs9YQMoO=V40Fi2inJiCh-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABQgh9FMGPnUpz6tc6c27i6nT0Lcs9YQMoO=V40Fi2inJiCh-A@mail.gmail.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E642:EE_|IA1PR12MB8334:EE_
X-MS-Office365-Filtering-Correlation-Id: ffd0b33e-ca99-4e73-2de7-08db5d79cabc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uBp5emZg+6lYlCE6yG7zUsukX8FE01QR3q08nw6AunJRnMaq8iowdY+ZDtAeUi76qR/fDe4N7dcxP3kfKQVvFHJf0vEJH/A19+n/au82OBGWHKdOyXKelCYDZtyrcgDIuJpBGJkA3AWZQlg5Mht7nZnZ42AcTjGK5pSlP3fAzCOSrBaAi5ktenTklyoMxS2bDD9iiiNbvuDZbIGBXKq8hPqgR9zHfj/V4EyvM3yghxUXDiLad5K6JSrhe/vCSbI29vHNTOe5qfz2Nz55Cba1YmMHZ7/ktZLyU3Qr7qxlNVT+ptSIlvczaCHl3/RrPp5nz/NWInNJTmrzgTsXT0XjCRxt4anLSNUJDAHDWpvLPiPU+OO1ODncjCrPAsJyZoczWeCX8gzIEK8asnpZO/fNbRkV22K15/wL7pVQ2iBx+MvIFEsdDqbDZLUU58EKueCcHZh6j0fW7fedJvzU9eXbbJmUgfmxBZb1Nhh4uo0m7EAIrezgb/SdbXm/aZuUMLaxvqsO8XffFtlrdIhW5UDdpyRrLrq0PyG7dwdrqADMsVEPkfo7egVfE8eMJ8fxkSymhYPPI/d7AjBmTzqTOxccIcLnfDmJoV1+WjNDQDqnZ1RFbx3KbG+gJQU2bK5JgHxt2/wwLs2F5ZE69SkfebUn7DMZHtUgSqEz5IeHx94oQtJwso+oH4W4sp0naS3y05d+a7pNxr5RovhIaKYFijCsON4VDecMKHoRmv8tF+bnjsBib3nX74ZfrBoi39bcBh9M
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199021)(46966006)(36840700001)(40470700004)(478600001)(54906003)(26005)(9686003)(186003)(70206006)(70586007)(6916009)(82740400003)(5660300002)(356005)(82310400005)(336012)(4326008)(41300700001)(36860700001)(426003)(55016003)(40480700001)(33716001)(86362001)(8676002)(2906002)(8936002)(7636003)(47076005)(7416002)(316002)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 23:43:07.5407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd0b33e-ca99-4e73-2de7-08db5d79cabc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E642.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8334
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16, 2023 at 11:12:44AM +0800, Zhangfei Gao wrote:

> > > However when debugging hotplug PCI device, it still does not work,
> > > Segmentation fault same as 6.2.
> > >
> > > guest kernel
> > > CONFIG_HOTPLUG_PCI_PCIE=y
> > >
> > > boot guest (this info does not appear in 6.2)
> > > qemu-system-aarch64: -device
> > > vfio-pci,host=0000:76:00.1,bus=pci.1,addr=0x0,id=acc1,iommufd=iommufd0:
> > > Failed to set data -1
> > > qemu-system-aarch64: -device
> > > vfio-pci,host=0000:76:00.1,bus=pci.1,addr=0x0,id=acc1,iommufd=iommufd0:
> > > failed to set device data
> >
> > Hmm.. I wonder what fails the set_dev_data ioctl...
> Simply debug, it is because dev_data.sid=0, causing
> arm_smmu_set_dev_user_data fail

I found that too. The input pci bus number is 1, yet the in
the context of set_dev_data, the pci bus number is 0, which
resulted in a 0-valued sid. I will take another look to get
why.

> > > $ sudo nc -U /tmp/qmpm_1.socket
> > > (qemu) info pci
> > > (qemu) device_del acc1
> > >
> > > guest:
> > > qemu-system-aarch64: IOMMU_IOAS_UNMAP failed: No such file or directory
> > > qemu-system-aarch64: vfio_container_dma_unmap(0xaaaae1fc0380,
> > > 0x8000000000, 0x10000) = -2 (No such file or directory)
> >
> From ex-email reply
> (Eric) In qemu arm virt machine 0x8000000000 matches the PCI MMIO region.
> (Yi) Currently, iommufd kernel part doesn't support mapping device BAR MMIO.
> This is a known gap.

OK.

> > > qemu-system-aarch64: Failed to unset data -1
> > > Segmentation fault (core dumped).  // also happened in 6.2
> >
> > Hmm, would it be possible for you to run the test again by
> > adding the following tracers to your QEMU command?
> >     --trace "iommufd*" \
> >     --trace "smmu*" \
> >     --trace "vfio_*" \
> >     --trace "pci_*"
> >
> 
> Have sent you the log directly, since it is too big.

I have found two missing pieces in the device detach routine.
Applying the following should fix the crash at hotplug path.

----------------------------------------------------------------------------
diff --git a/hw/vfio/container-base.c b/hw/vfio/container-base.c
index 89a256efa999..2344307523cb 100644
--- a/hw/vfio/container-base.c
+++ b/hw/vfio/container-base.c
@@ -151,8 +151,10 @@ void vfio_container_destroy(VFIOContainer *container)
     }

     QLIST_FOREACH_SAFE(giommu, &container->giommu_list, giommu_next, tmp) {
-        memory_region_unregister_iommu_notifier(
-                MEMORY_REGION(giommu->iommu_mr), &giommu->n);
+        if (giommu->n.notifier_flags) {
+            memory_region_unregister_iommu_notifier(
+                    MEMORY_REGION(giommu->iommu_mr), &giommu->n);
+        }
         QLIST_REMOVE(giommu, giommu_next);
         g_free(giommu);
     }
diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
index 844c60892db2..35d31480390d 100644
--- a/hw/vfio/iommufd.c
+++ b/hw/vfio/iommufd.c
@@ -652,6 +652,9 @@ found:
      */
     if (QLIST_EMPTY(&container->hwpt_list)) {
         vfio_as_del_container(space, bcontainer);
+        if (bcontainer->nested) {
+            memory_listener_unregister(& bcontainer->prereg_listener);
+        }
     }
     __vfio_device_detach_container(vbasedev, container, &err);
     if (err) {
----------------------------------------------------------------------------

Would you please try your case with it?

Thanks
Nic
