Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDF36BAB7A
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 10:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjCOJDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 05:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjCOJDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 05:03:44 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8847513D75;
        Wed, 15 Mar 2023 02:03:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmtBJMIv0I66PlaiDmI28KQUr1UCPwljar9gQ26yV2GcaR/PEN+56vCE1kHY6nz8ZkiAzs+znRjqHDYtYhyJpRQ4+zXWIuxPrQI1Q7lXbYWoHpNjWCfc4msZLmtgG8fIEZj7siDQXfc0k1LCE8JvDJfhOcGQT2u9gvlFh9roo/3gio23Vht/oXjjuEepfhAy/0WIufMcSwACPZas9tgG9x7O+KaYYD4/hrHRYFtwlYJxfwjbNsDbb1ZreXM/n54JDwNl66M058i5cGIxBIQycrMP1bTOvGn8NgeIG9hPikE1MAyvcd2Gc1DTD0qPnxyKNhKMb8Wdn3aEuHd3/EUGhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwGv1++BSbe+s+PQO8xqI5cJm7zP9u4IsZ/z0pnkHeA=;
 b=Jm1eHi6DPpAR/CujnZJRi1HmpBi/FgPTMzm+tKTXma2MuB5struAt2z51sJPtfiwt7XVjbrS0HqJGHCayCviKP/22b9Q0cd7xLsyPFzD7+Nu7Y1Avg3/kAlqjndU+r2n+QpUEGBYy6AIgIe7RhNJuAAB4Kei8MOUTFXMcEZYeD/r72ewPV/+Mn13Bb4bbvfaOL10/fbd1FYfu/+f0wLHXilS8Ci/hmp8Jc3opOj9hDr8eMliKwUfNSi3EJboiwuyDxHxQcAg9eW7Dh+u3COchwVfxYT/B3HrFGj93Z01oK1FBI+xGJy7/rW7ifyAHc2HzdLDLFA7/COG+QZbM5jBAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwGv1++BSbe+s+PQO8xqI5cJm7zP9u4IsZ/z0pnkHeA=;
 b=kWlyaeg8XGcp4UjkRUGhMxLcdbKbsgcShE3dJnFZDektjlwSv8fmT3TP4v0ai41wDQGRg41r0HK8w8yJcBxjb2RTUfgcs/MLA6HAq3XSTr7giK/1coN7OjBdOnopViMf5Ork5JVQYNW/mY7kqcYPzL+tnOMd14562JjoLftoIvKLpqIYuqKI7JXP4qohYzIM+SDDUTbPwzskZCtjYYqSMwdcGdpZUa9z17ERcq0GGfhbBS1af2oFazp4VH9sjk7p+O5+xQno8WvEbn5BZ7ciB1U7n45tGvIgEUZpKrFNipOAoHdRsRT9r1vy6D1PzhgOBk/gPtZPMZt8A4UneMqd4Q==
Received: from DM6PR07CA0094.namprd07.prod.outlook.com (2603:10b6:5:337::27)
 by DS7PR12MB8081.namprd12.prod.outlook.com (2603:10b6:8:e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 15 Mar
 2023 09:03:22 +0000
Received: from DS1PEPF0000E633.namprd02.prod.outlook.com
 (2603:10b6:5:337:cafe::a7) by DM6PR07CA0094.outlook.office365.com
 (2603:10b6:5:337::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Wed, 15 Mar 2023 09:03:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E633.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Wed, 15 Mar 2023 09:03:22 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 15 Mar 2023
 02:03:12 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 15 Mar
 2023 02:03:12 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 15 Mar 2023 02:03:10 -0700
Date:   Wed, 15 Mar 2023 02:03:09 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia>
 <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E633:EE_|DS7PR12MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d332fb1-0425-4e7e-02c3-08db253420f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wagvEuLEsEaO/hgXShyWJd16Z8VWoZ3KqpScdSlUp3qLufvG8NcwO1hcz1TLmj9o0oKTe05vNZOT5DdtASqwEPHLzM0wcOr9QbWMNI8MUnHWl0jYeZ2a1y8IDu87fb0M1/EBV4Ma0NeXmhqnuOw2FZonNRdWnXw5qhPhx9abfQC0xUoiE1upgQv7mWWB1KTL0Zq1+pQ8s8J20WGzr3GGWB9Nfoz5V6PXpqlfYAAgW93tzY93v5wT+BDFKMxy6gUgTcUuMXN1IcTr7bALASd1YCsZMyWDipT3vehvo97auHthKQAdkJfoEu1j1MkEvV6QbjebqIj4xTu9BHEGRwjAhY53ciHg6y8VwwZO1w2djLUunnVuBrvr4geu2fkwOEo8NBqSUqDU14OSnAY0bNpvsZ8CPiBxeIqKm6iW64BUdOFtMVQgDvoM/E+tCZfSnu1doLpk6DxWEzi0d3khBZHgqOu0DxJPCPN2XWCqUpkllPL8tigSPyHbEDcGwkb8SYgyYIx3w+9T2mSlCJ9FjaL5O5EFbZdAKG/oo4ihqL5uQW9qNajde/LoEGxPFC7X11Q0GQOosHxgM566Duz6QjwBpxL2mm3qhweEh0a74uP2px9KOnAbA20QyHbXOUmDsrJdDTwIzE4f6wKH0ZVBdarCOQuvfCpPX/EXZsaEOPx2qVNo1uUu4mgDZLiyIhUZqZzc0ANzUf79o8jBjN7vEF1L0kriKYa3NBy9pQIj2Wuosmc2vMz5SWcLUQJYXUHW3wJdzf28WrraBk740s48QZ9dfSlGwV1AfeSa6o/F6NI6TUjA816BSM6DE2gBKGBwKY28Q4D+pyaDKimiaUksSjT3Kg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199018)(36840700001)(40470700004)(46966006)(5660300002)(336012)(110136005)(41300700001)(86362001)(40460700003)(316002)(8936002)(7416002)(36860700001)(966005)(47076005)(7636003)(426003)(54906003)(82740400003)(478600001)(83380400001)(186003)(2906002)(26005)(33716001)(4326008)(70586007)(70206006)(40480700001)(55016003)(9686003)(8676002)(356005)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:03:22.3302
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d332fb1-0425-4e7e-02c3-08db253420f8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E633.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Mar 15, 2023 at 06:50:53AM +0000, Tian, Kevin wrote:

> > So, this preparatory series will add a pair of simple attach()
> > and detach() APIs. Then the cdev series will add the locking
> > and the ioas_unpin stuff as a rework of the detach() API.

> > I think they can be something mingled... the sample code that
> > I sent previously could take care of those conditions. But, I
> > am also thinking a bit that maybe attach() does not need the
> > locking? I can do a separate replace() function in this case.
> >
> 
> w/o locking then you need smp_store_release() and its pair.
> 
> anyway it's not in perf critical path. Keeping lock for attach
> is simpler and safe.

OK. Basically I followed what Jason suggested by having three
APIs and combined Kevin's inputs about the difference between
the attach/replace(). I also updated the replace changes, and
rebased all nesting (infrastructure, VT-d and SMMU):
https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-03142023

The major three changes for those APIs:
[1] This adds iommufd_access_attach() in this series:
    "iommufd: Create access in vfio_iommufd_emulated_bind()"
    https://github.com/nicolinc/iommufd/commit/34fba7509429380f828fb23dcca5ceaeb40e22b5
[2] This adds iommufd_access_detach() in the cdev series:
    "iommufd/device: Add iommufd_access_detach() API"
    https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a097e2c9d9e26af4
[3] This adds iommufd_access_replace() in the replace series:
    "iommufd: Add iommufd_access_replace() API"
    https://github.com/nicolinc/iommufd/commit/36507fa9f0f42cf1a5bebe7c9bc2bf319b7654a8

Please check if they look okay, so that Yi can integrate them
accordingly to the emulated/cdev series.

[*] This is the patch that I posted in the other mail addressing
    Kevin's comments on iommufd_ctx_get():
    "iommufd/device: Do iommufd_ctx_get() at the top of iommufd_access_create()"
    https://github.com/nicolinc/iommufd/commit/077b09bb83329dc046753f4ef672f5bf6386755c
    (I just saw Yi's reply concerning its necessity. Feel free
     to drop in that case.)

Thanks
Nicolin

P.S. Attaching the list of changes with their locations:
3791dedf98e8 cover-letter: Add IO page table replacement support
c8ebf51c3c9b vfio: Support IO page table replacement
c5710f23e8f6 iommufd/selftest: Add IOMMU_TEST_OP_ACCESS_REPLACE_IOAS coverage
[3] 36507fa9f0f4 iommufd: Add iommufd_access_replace() API
0263855d1e8b vfio: Do not allow !ops->dma_unmap in vfio_pin/unpin_pages()
e39ed55e77a0 cover-letter: Add vfio_device cdev for iommufd support
26fd7fccaef3 docs: vfio: Add vfio device cdev description
f10f3e3162bb vfio: Compile group optionally
9588ae4c4049 vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
3e57108eac64 vfio: Add VFIO_DEVICE_BIND_IOMMUFD
b925716dd226 vfio: Add cdev for vfio_device
db309463ab92 vfio-iommufd: Add detach_ioas support for emulated VFIO devices
[2] 4110522146ca iommufd/device: Add iommufd_access_detach() API
abca7e1e063a vfio-iommufd: Add detach_ioas support for physical VFIO devices
9d368f7247c7 vfio: Record devid in vfio_device_file
683af0a471e1 vfio-iommufd: Split the compat_ioas attach out from vfio_iommufd_bind()
32a2e7de1d53 vfio-iommufd: Split the no-iommu support out from vfio_iommufd_bind()
8a1c042379f5 vfio: Make vfio_device_first_open() to accept NULL iommufd for noiommu
fc6e0ed2aa44 vfio: Make vfio_device_open() single open for device cdev path
3f6821d507a4 vfio: Add cdev_device_open_cnt to vfio_group
896cde40a016 vfio: Block device access via device fd until device is opened
f422c4216a19 vfio: Pass struct vfio_device_file * to vfio_device_open/close()
b187f9980fed kvm/vfio: Accept vfio device file from userspace
721e2e60ff54 kvm/vfio: Rename kvm_vfio_group to prepare for accepting vfio device fd
8993c4c75c20 vfio: Accept vfio device file in the KVM facing kAPI
a92c45ae0ce6 vfio: Remove vfio_file_is_group()
fb586f783934 vfio: Refine vfio file kAPIs for KVM
50694af6f3c0 vfio: Allocate per device file structure
df21c0737eef cover-letter: Make vfio-pci hot reset prepared for vfio device cdev
5c25c874d7e0 vfio/pci: Accept device fd in VFIO_DEVICE_PCI_HOT_RESET ioctl
7c30ce8b54db vfio: Accpet device file from vfio PCI hot reset path
e3209342db44 vfio: Refine vfio file kAPIs for vfio PCI hot reset
8354fd79944e vfio/pci: Rename the helpers and data in hot reset path to accept device fd
54387efb858c vfio/pci: Allow passing zero-length fd array in VFIO_DEVICE_PCI_HOT_RESET
cd93ffb62c51 vfio/pci: Only need to check opened devices in the dev_set for hot reset
2a6fd7231cbf vfio/pci: Update comment around group_fd get in vfio_pci_ioctl_pci_hot_reset()
480abea5961e cover-letter: vfio: Make emulated devices prepared for vfio device cdev
46b6d1ae1754 vfio: Check the presence for iommufd callbacks in __vfio_register_dev()
6064b9f81817 Samples/mdev: Uses the vfio emulated iommufd ops set in the mdev sample drivers
c20852af7291 vfio-iommufd: Make vfio_iommufd_emulated_bind() return iommufd_access ID
3405865b0b3f vfio-iommufd: No need to record iommufd_ctx in vfio_device
[*] 077b09bb8332 iommufd/device: Do iommufd_ctx_get() at the top of iommufd_access_create()
[1] 34fba7509429 iommufd: Create access in vfio_iommufd_emulated_bind()
a5d8ac47554f docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD before VFIO_GROUP_GET_DEVICE_FD
