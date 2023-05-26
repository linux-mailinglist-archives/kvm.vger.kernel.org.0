Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF4B711F19
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 07:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbjEZFKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 01:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZFKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 01:10:46 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67ED313A;
        Thu, 25 May 2023 22:10:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5vgBq0l8E6nU51aMPF4EYLMkgqZL85oOQPl1niZ5NwM57hm4qO1zTOx81oK08td8oRJ5hYmni9ZCgiZFGy+WfT5iYbVsrm0xqTeTbyImPZCh0fxtrtzJhaR4QPZ7H1Wkp6JTyCwbJ9Jnzt+6lG0HwX0SclPqyZKR1tEn8ZM3wVTv0rdaNaer6+WbdZDd/L/ANXjQ/V2q8R+o3P3dDYvXfUICsHqyQ6hpgZQW398a4WJlwg/5bQMjdTh001IGAz1yRVCXkpwVYvETlkefFGugxouLlo6cH1BS1izFMf5i76yH+f+N4RLl2W28PpNNLoXzplXvMF3JwgkoL7CsD9OPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3+1stszlMU8sFSBePYXgrcjn668Cc+QxBX3ohI/GeA=;
 b=MwQLYgSkJPTq7KWQBW5VchKQcm0lEzu1+A9FOpqc1kFha/k/yD0AE6lRdlWkgu/9NPrdmIq8ZQ+j/ftKD1OZC7mcfZ6wlQywa8ys53T2zlAwg3r2i/mA0EVfS8TVWl0uO+0d+fNRTad739wW50vwoYWZaG23veqATVJO4EKX2pG+asL12K/x6wXJgV3gS+dj2rdRUuHVgfTKlUl4PU70VVGI4gjiujNTbCj7YdTOVIuGoEbhokJ771zlT60ZTGo/EzsvaSC/ICurjOYZgGO1kR8wWnkpRkBkviKTDxHaZEr4qEovpPWx4D1E/tfVtdeDTMFtgXWsMgferQlyqxKDyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linaro.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3+1stszlMU8sFSBePYXgrcjn668Cc+QxBX3ohI/GeA=;
 b=VUWCZ7a8+NWQU2dr3R8q86AKtVvXA/HWAv1SK5ukGRwb81G3f6HZAmnmA6iY+OnMxESALcfJsdqiFdXMW+RoguiDnERzgKgCtF852ZD7pG9RTGG8vNdUjw5ujZAM6l2J8QsO9lizsUe9+QA8iAYE1EGjYFa/CmYnUtMX7BYRH5GEwz6eTalce+CipRS/B0EduavAYCEbHNCy3TKYqTenJ/c9zbL6x5B+hxI+gwNWa3GsyAeImERFHVdWo50LKFhbBJQU4F/D4iaRhQgn5iHQ18cfQGa7sLb+Y5IOVbr4VBAegfAbnlefg0tkSMITXor3wH2I7UO5sPChF1IMX2EA5g==
Received: from BYAPR06CA0059.namprd06.prod.outlook.com (2603:10b6:a03:14b::36)
 by SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 05:10:35 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:a03:14b:cafe::fe) by BYAPR06CA0059.outlook.office365.com
 (2603:10b6:a03:14b::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16 via Frontend
 Transport; Fri, 26 May 2023 05:10:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.7 via Frontend Transport; Fri, 26 May 2023 05:10:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 25 May 2023
 22:10:18 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Thu, 25 May 2023 22:10:17 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Thu, 25 May 2023 22:10:16 -0700
Date:   Thu, 25 May 2023 22:10:15 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     zhangfei gao <zhangfei.gao@linaro.org>
CC:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>,
        <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 00/17] Add Nested Translation Support for SMMUv3
Message-ID: <ZHA/N8m+kpaOLxaT@Asurada-Nvidia>
References: <cover.1683688960.git.nicolinc@nvidia.com>
 <CABQgh9FL4ssQjBJM52_kb0aBVVPb_9Wc0Q+NL1PaQO=2LYBHCA@mail.gmail.com>
 <ZGJWgFVJDWxVpiBE@Asurada-Nvidia>
 <CABQgh9FMGPnUpz6tc6c27i6nT0Lcs9YQMoO=V40Fi2inJiCh-A@mail.gmail.com>
 <ZG/ygPy1XbSSNzR4@Asurada-Nvidia>
 <7650f32d-6d4d-012e-b14b-538529de0577@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7650f32d-6d4d-012e-b14b-538529de0577@linaro.org>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|SJ1PR12MB6075:EE_
X-MS-Office365-Filtering-Correlation-Id: acadeb48-08ca-414b-3fad-08db5da789c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +AD4VjiUHSDsv/8F1l3YgsYRunArLAmWDg4iLHZUpKmEDrd7bk90pfw0cEKfAP67i8lcVgk7e0u/sMdx/9OadFLMgFA81+rM7AZ2QR1SJfPOecx4oRnBBFAe6Yov1+4DZuB1s+PVvhBPFqNjEZcqXEl9K8Yhs484YM4snHaVj+l9mpQ6VPlkdnVYQcSVRmLifyirmL1qVhmUpeRGkXs9BryLfpt4G9btTgZf2CedtZanpfli9YZPyyojFquR6iTzgGfSXx3ohZ6AXm19MBEZJlMWwsq88Tit5YevvG/fHQXtmImfgV0qs5Wqkh0DOnIzn2IjJXjd1+Cb/OmrSb7bWclVNfCX0ICwvZTxpktkL09Wjl0y9sxZ8X6AfgjgYD3WpbOxrSzhkAVc5wKbD+m1a5jDRfk0W8dQh4qiISnUW5OoE52vdwsFZKEBwbdPF6IPaQA4YO38H24y2iCPsIbRLHCJEXQCJzprvd08gO6aZPUAiikJuJJnp8bc3OJMQX7BrcYJ4s123BA+JAs+UB/fpLa+dFgBXURmSWuVxZMKuv7rwRozUUyakWC6WieaGC3OyLb90WlKDtLvy04B4UlYBbdTZkbmvrl7x3rhq0GlubngFFoxX4HKBMDUG8yUIK+mqMk93T5ZMXKp2tXe/4lTkb5FLfd9CzunZ/qWLI3ZRyxI765Qan9nPEJNiKhOLry1oASFSYG/b0ouFn4OuBCp3GUvOeUEVg3Kgdy2gyXqrqsa4sz+OKyZSnMk34Tyodm8
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(6916009)(70206006)(70586007)(478600001)(316002)(4326008)(54906003)(86362001)(47076005)(26005)(186003)(336012)(36860700001)(9686003)(426003)(41300700001)(8936002)(8676002)(7416002)(2906002)(55016003)(40480700001)(33716001)(82310400005)(82740400003)(7636003)(5660300002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 05:10:35.4003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acadeb48-08ca-414b-3fad-08db5da789c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6075
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

On Fri, May 26, 2023 at 09:58:52AM +0800, zhangfei gao wrote:

> > I have found two missing pieces in the device detach routine.
> > Applying the following should fix the crash at hotplug path.
> > 
> > ----------------------------------------------------------------------------
> > diff --git a/hw/vfio/container-base.c b/hw/vfio/container-base.c
> > index 89a256efa999..2344307523cb 100644
> > --- a/hw/vfio/container-base.c
> > +++ b/hw/vfio/container-base.c
> > @@ -151,8 +151,10 @@ void vfio_container_destroy(VFIOContainer *container)
> >       }
> > 
> >       QLIST_FOREACH_SAFE(giommu, &container->giommu_list, giommu_next, tmp) {
> > -        memory_region_unregister_iommu_notifier(
> > -                MEMORY_REGION(giommu->iommu_mr), &giommu->n);
> > +        if (giommu->n.notifier_flags) {
> > +            memory_region_unregister_iommu_notifier(
> > +                    MEMORY_REGION(giommu->iommu_mr), &giommu->n);
> > +        }
> >           QLIST_REMOVE(giommu, giommu_next);
> >           g_free(giommu);
> >       }
> > diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
> > index 844c60892db2..35d31480390d 100644
> > --- a/hw/vfio/iommufd.c
> > +++ b/hw/vfio/iommufd.c
> > @@ -652,6 +652,9 @@ found:
> >        */
> >       if (QLIST_EMPTY(&container->hwpt_list)) {
> >           vfio_as_del_container(space, bcontainer);
> > +        if (bcontainer->nested) {
> > +            memory_listener_unregister(& bcontainer->prereg_listener);
> > +        }
> >       }
> >       __vfio_device_detach_container(vbasedev, container, &err);
> >       if (err) {
> > ----------------------------------------------------------------------------
> > 
> > Would you please try your case with it?
> 
> 
> Yes, this solve the hotplug segmentation fault

Nice. Thanks!

> Still report
> 
> qemu-system-aarch64: IOMMU_IOAS_UNMAP failed: No such file or directory
> qemu-system-aarch64: vfio_container_dma_unmap(0xaaaae622e300,
> 0x8000000000, 0x10000) = -2 (No such file or directory)
> qemu-system-aarch64: Failed to unset data -1 (only the first time of
> device_del)
> 
> Test with device_del and device_add

I found the "pci.1" has secondary bus number 0 when VM inits:

(qemu) info pci
  [...]
  Bus  0, device   2, function 0:
    PCI bridge: PCI device 1b36:000c
      IRQ 0, pin A
      BUS 0.
      secondary bus 0.
      subordinate bus 0.
      IO range [0xf000, 0x0fff]
      memory range [0xfff00000, 0x000fffff]
      prefetchable memory range [0xfff00000, 0x000fffff]
      BAR0: 32 bit memory at 0xffffffffffffffff [0x00000ffe].
      id "pci.1"

Then it changes later during the guest OS boots:

(qemu) info pci
  [...]
  Bus  0, device   2, function 0:
    PCI bridge: PCI device 1b36:000c
      IRQ 255, pin A
      BUS 0.
      secondary bus 1.
      subordinate bus 1.
      IO range [0x0000, 0x0fff]
      memory range [0x10000000, 0x101fffff]
      prefetchable memory range [0x8000000000, 0x80000fffff]
      BAR0: 32 bit memory at 0x10240000 [0x10240fff].
      id "pci.1"

This must be related the PCI bus init thing, since it doesn't
fully assign correct the bus numbers and ranges being listed
above, in the first dump.

I will try figuring out what's going on, because this doesn't
make too much sense for our ->set_iommu_device callback if a
PCIBus isn't fully ready.

Alternatively, I could move the set_dev_data ioctl out of the
->set_iommu_device callback to a later stage.

Overall, this should be fixed in the next version.

Thank you
Nicolin
