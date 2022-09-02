Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5F45AB91E
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 22:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiIBUAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 16:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiIBT7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:48 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E43F2F3BB
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZ/Pa0O9VeRJRzzIq8YkxorYihjyKwV8I7NCF+6r51A593PROeHim+Fml+z97U9w1N9mRxZ2DczcwgnktcP9x6jyXn0p8e+rhPl2AOjx3xOeiuOMlTelgq7r3WSXGmNmqYDMB1iv6n4CVQCzYwLshl8TrDV61kEVW2MsR4dXB/50ld/mjNRFNWui8f+JYAY2qCoNP7WWh+GkcMPivlwqueb2MRTlsSVW1K72oLtPPIexgPpB+exykjBHSET53ZQl5tBg2ffjo3Y5Jvdz4MhGIX0teRIFhxj28gs+Yfd+adzjubaWaSh1iu8+D9pxvAyRjry5kfV7hkgAm6bKi7CLsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtTyTGSeYndyjA+OMqO6VIbA0V7BAnIbJ05OxXCeRmY=;
 b=UoJSB9/1yOKESh1nPOTbRQ4/j8bMrtYojXJYc717j65NF+oCUixNdGuot+F1qbV1tmV6+zZAE2nxp38OZsxz7MAgk2tNwcYYGRpzWhvqS4AI2s40VwREPj/Y7j+32DQH5vy61wHgpV4t8USbaGgvoc07WBg3VnYgorx5VqWelOVGMWBdMvSOeTycQWVpO6XeYWC0o4LrJXP+I4L7fT/2KHenvPhnGU4OykkFSv7WEZWKq0u+BBJVKysCKfU6rcpBQw5tX286XE2WmGAncYOnJRnYd5jzRGBsCfdl4P39xrpa0CeUJN0BAQFWOsubEpMwRI663fsBDNOyT6oJeml11Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtTyTGSeYndyjA+OMqO6VIbA0V7BAnIbJ05OxXCeRmY=;
 b=hrkJM8d/RmQKhi+1AVxqDrocCgdytWrsLuqmt1FiR2eAYxJocep+yFe8XfbxeD/pjGcIHjp7Lwy4QB0pJbxQBgvMtIx4+Cx4Oi1cAG0L1GJXr06DsdVVhUtrzHcF/R3H0udPxTXdlEeOrlldvBaqLXZG57K0mGzYNZTTJhHG8Oy77W8Pt8wEhLfsPB7vqUckQ3ub6tcKTceVmk0DIWcKPn6yuVLTOXxZb5JJo4jPYBKcFjxF9K1JMqaEtIAV62RV6OwKi8/POAiTv0CCuyTxGlUy81QVan20jnB6UuGnhQvgd555ZZW5VaPx2gimj9Ricqr5PjIV9HyAZfhwFpz0xQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 19:59:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 19:59:34 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH RFC v2 02/13] iommufd: Overview documentation
Date:   Fri,  2 Sep 2022 16:59:18 -0300
Message-Id: <2-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:208:32a::8) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6492c2a6-7286-45ec-9bf6-08da8d1da65e
X-MS-TrafficTypeDiagnostic: DM4PR12MB6566:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JW/iv9otOe4wjgBWsFFQOih+U20TgwQR2OWrhMpeMKAzZSmxS/Fy5b67Ytfui6sfV4UzOAPJ/chX+7iaDRDBWq7VQHBOwWXI1qFRNox7q5wUpiifUZVIcwkFHffWfGKCeuuvQ+uI1Gj5oFluhpg9t5mD9bZIrH8UCVnrKCdemz/mtR0X4rQ2jOl4wCGOU/JJdJlzeH3PKEZ8QSHy+hcLnfDg/6uH234ZEDZqFcQ1N+E0H/PsVuqqLb4Tl/JHT5jU34p5q6A9vjkxoBOCTXluLTOnOxzG+x9MXx474bBnveUaZa9z88qqIJKX7OmBtD8hVwF/EPYuPV/ZDFVg1FXATvYxJ6+epZ5gOtq2UOWFMudXwoG7Gn0x3aPuy3Z22RnBER/Z0YtcLolPLRbbGgiq5Js3O4+rIFtGJhAMcLiLogOrP+sVPKuExz3hjytl92o0Eyd+tcXDGcHDD++NP76xSSZQID9MR4YqT9gbhB453BrcpI/wK6wBnuNckjkOgLIm3FP0tuNhBG904t8e+pfBtmkViBVNzinAFzqFrIiLOaK/OUKRwKhEYuPlYCKrrwsoUpAXwTDI+GJBBO8O+dm69VKZG+Q08YPdFIXBJJVUMdWEaboXisdAyDt9PVQjtDCFTnMoTRaU9VYK4MWVWAhabG+Uw+0RU/B34ISEFLfWcB0VJriPf3w6bZUdani5IlCNJxE2vu2ZrsNy5eAz3W5X1OXFvsxHyDW/k9azso5nhTOGs5/K8dIloo5NtDXvzEVjnGklUVGeIxWEEkRPrD8Qng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(5660300002)(109986005)(6506007)(36756003)(83380400001)(41300700001)(8936002)(6666004)(6486002)(478600001)(2906002)(38100700002)(66476007)(8676002)(66946007)(66556008)(4326008)(86362001)(54906003)(7416002)(26005)(6512007)(186003)(2616005)(316002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1e7j23+5k9QRvRiUG4SCRtlPAXY2UErRdtD0YMd0ns0B27RXcuPmuIVS89OZ?=
 =?us-ascii?Q?JUBPTQZpQ0aD+dUz3zk/cN4m+r7Ak8aQvDjKEqX1IJmDd+IsSXzu8W/3mBFy?=
 =?us-ascii?Q?NotFU80TYg8AGE/XWSUDq1SbzJZcFFmt9dsJ3iICT4UHn+vJccRzU7qh/3hA?=
 =?us-ascii?Q?XWmpAzL1tFViezAhral/ajwoDs5Z6E5mcRofZGyf8nTex6joKQhGFqaD9pWT?=
 =?us-ascii?Q?Ld9gZPcHPTFhzqBH/YZ9XYguRNZ3vAXswODW6j4eOy1zmzwCvT51KuvRLssi?=
 =?us-ascii?Q?mVPnk3YHpfcVqOH2zb6lEVucBG1B22V6jxAwJpRVU6qhvkhkaRojKTFDOAKD?=
 =?us-ascii?Q?iP5L+JOTJdYL6lX90t5NdQw0fYVjGqQWjh1PXsSyng5p3F8oNM6KOkZy+PEf?=
 =?us-ascii?Q?4oHApGz5toPLjwCiQ2e3+61bLxkmkg2q1IiI5d8THXw+OuzkIfHy9t4/fc2C?=
 =?us-ascii?Q?pbXPcevWri5pr22ZUgzqHGp5wDKu8iId1j5DNt+Hd9YmGgxlJiVQlPwKg9Rk?=
 =?us-ascii?Q?qPSjTrYJ095JOBqe2YbDv9BZDwd/6QVKQnNIaiEjNQfFGeW7DLFs5jDPDwB5?=
 =?us-ascii?Q?QlaP3sQZqm+ukPaFjFI15n7KT3YHMkb86OAwcvcnP8kBh1G63jR9nFhlDhV5?=
 =?us-ascii?Q?qTuMOTpkbz9i3tGX8+XfSvIo0Gc3RN9M6F/EUz8EfX/OqwrRg2is5ocuqv/p?=
 =?us-ascii?Q?uhs65PeNzzOEjbKtSZwDCANtODRcDcJwIbEb7xWblqaItixV12cyNYafX6eg?=
 =?us-ascii?Q?Tj5VaX7KFPH1TgflZPxuwX1l6g+JAOptoYFwbqOeJoFKF0iJyC+kcsJxySco?=
 =?us-ascii?Q?dHA6iQsyrKcQvz7fp1qffJj3T12m2O1XO3uNy2wk0Fy9UP3Tal9stOQoAtkQ?=
 =?us-ascii?Q?g7RggIlxwh656UgnKA87roEcgsEsPUcYIvAp3WKlQDCmPu9b+57UYWBlvA8H?=
 =?us-ascii?Q?MVAgGVCkb1jaozz+ENlnxpKlwanDs3lDEtYk5YYG4rHiHzKzdz2uFGnzOUcr?=
 =?us-ascii?Q?2+K60i0zkkoHtXC8oWi2PTqjZgGuRQzMb9nBQEBLIkl0JNobqCzL06btH3NG?=
 =?us-ascii?Q?6gbZ6aqWdbZ9PDLAkpU37zZlXipWvdnvhyan7uoiyP8Zy6ZZdad7qxjsakrS?=
 =?us-ascii?Q?IoV6befszAMHKrYHbPEUSXtIGXlZdx9GMJfZpGouKdxdl7SLI8WRnBO2gbOE?=
 =?us-ascii?Q?YoGa+e5ZN+S+itYMcrLi6/6J/i+5g0gTHlLT4hFSPbB3tIGmD+Fr62AEZJ1q?=
 =?us-ascii?Q?U66R7BKd/CRhNtYn/Mgs50MJ3jX3yJbGZCQsR9MTCELIAd2hB4L6z8bRvqpQ?=
 =?us-ascii?Q?0dyyZKYim/WXrIS2O5TYOze0/fF8rrbcrOEIsCwD1SUNoVCzVyFvsOkT6Vvf?=
 =?us-ascii?Q?0sO+yUPssfW9jjPOmy52mk8LecRj2sxl6EpMeTqhM1yocp8uCjh6B+eRpB+6?=
 =?us-ascii?Q?7qXaqRyFZqg/6mJ9swzCE+tQNRB8/cnKegKP6kjxFMvL50+oiahzzms+JCkg?=
 =?us-ascii?Q?88Ll6VBgZ8PF5wfoNb8Q9db1XLI0cAr4E6wKUctcHCW8nzLhIV4DAbfo6IKt?=
 =?us-ascii?Q?6l5jv4qO8gEd2txdejSrIq9w7CsNYCIydBgQfx2J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6492c2a6-7286-45ec-9bf6-08da8d1da65e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:31.3163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16r5NAFUL/+Jb4x4MywMyP18kWwtSpy/B2uiBOgFRDNmQMF/wWrEIRtKR4pjDtbk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6566
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kevin Tian <kevin.tian@intel.com>

Add iommufd to the documentation tree.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/userspace-api/index.rst   |   1 +
 Documentation/userspace-api/iommufd.rst | 224 ++++++++++++++++++++++++
 2 files changed, 225 insertions(+)
 create mode 100644 Documentation/userspace-api/iommufd.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a61eac0c73f825..3815f013e4aebd 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -25,6 +25,7 @@ place where this information is gathered.
    ebpf/index
    ioctl/index
    iommu
+   iommufd
    media/index
    sysfs-platform_profile
    vduse
diff --git a/Documentation/userspace-api/iommufd.rst b/Documentation/userspace-api/iommufd.rst
new file mode 100644
index 00000000000000..38035b3822fd23
--- /dev/null
+++ b/Documentation/userspace-api/iommufd.rst
@@ -0,0 +1,224 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+=======
+IOMMUFD
+=======
+
+:Author: Jason Gunthorpe
+:Author: Kevin Tian
+
+Overview
+========
+
+IOMMUFD is the user API to control the IOMMU subsystem as it relates to managing
+IO page tables that point at user space memory. It intends to be general and
+consumable by any driver that wants to DMA to userspace. Those drivers are
+expected to deprecate any proprietary IOMMU logic, if existing (e.g.
+vfio_iommu_type1.c).
+
+At minimum iommufd provides a universal support of managing I/O address spaces
+and I/O page tables for all IOMMUs, with room in the design to add non-generic
+features to cater to specific hardware functionality.
+
+In this context the capital letter (IOMMUFD) refers to the subsystem while the
+small letter (iommufd) refers to the file descriptors created via /dev/iommu to
+run the user API over.
+
+Key Concepts
+============
+
+User Visible Objects
+--------------------
+
+Following IOMMUFD objects are exposed to userspace:
+
+- IOMMUFD_OBJ_IOAS, representing an I/O address space (IOAS) allowing map/unmap
+  of user space memory into ranges of I/O Virtual Address (IOVA).
+
+  The IOAS is a functional replacement for the VFIO container, and like the VFIO
+  container copies its IOVA map to a list of iommu_domains held within it.
+
+- IOMMUFD_OBJ_DEVICE, representing a device that is bound to iommufd by an
+  external driver.
+
+- IOMMUFD_OBJ_HW_PAGETABLE, wrapping an actual hardware I/O page table (i.e. a
+  single struct iommu_domain) managed by the iommu driver.
+
+  The IOAS has a list of HW_PAGETABLES that share the same IOVA mapping and the
+  IOAS will synchronize its mapping with each member HW_PAGETABLE.
+
+All user-visible objects are destroyed via the IOMMU_DESTROY uAPI.
+
+Linkage between user-visible objects and external kernel datastructures are
+reflected by dotted line arrows below, with numbers referring to certain
+operations creating the objects and links::
+
+  _________________________________________________________
+ |                         iommufd                         |
+ |       [1]                                               |
+ |  _________________                                      |
+ | |                 |                                     |
+ | |                 |                                     |
+ | |                 |                                     |
+ | |                 |                                     |
+ | |                 |                                     |
+ | |                 |                                     |
+ | |                 |        [3]                 [2]      |
+ | |                 |    ____________         __________  |
+ | |      IOAS       |<--|            |<------|          | |
+ | |                 |   |HW_PAGETABLE|       |  DEVICE  | |
+ | |                 |   |____________|       |__________| |
+ | |                 |         |                   |       |
+ | |                 |         |                   |       |
+ | |                 |         |                   |       |
+ | |                 |         |                   |       |
+ | |                 |         |                   |       |
+ | |_________________|         |                   |       |
+ |         |                   |                   |       |
+ |_________|___________________|___________________|_______|
+           |                   |                   |
+           |              _____v______      _______v_____
+           | PFN storage |            |    |             |
+           |------------>|iommu_domain|    |struct device|
+                         |____________|    |_____________|
+
+1. IOMMUFD_OBJ_IOAS is created via the IOMMU_IOAS_ALLOC uAPI. One iommufd can
+   hold multiple IOAS objects. IOAS is the most generic object and does not
+   expose interfaces that are specific to single IOMMU drivers. All operations
+   on the IOAS must operate equally on each of the iommu_domains that are inside
+   it.
+
+2. IOMMUFD_OBJ_DEVICE is created when an external driver calls the IOMMUFD kAPI
+   to bind a device to an iommufd. The external driver is expected to implement
+   proper uAPI for userspace to initiate the binding operation. Successful
+   completion of this operation establishes the desired DMA ownership over the
+   device. The external driver must set driver_managed_dma flag and must not
+   touch the device until this operation succeeds.
+
+3. IOMMUFD_OBJ_HW_PAGETABLE is created when an external driver calls the IOMMUFD
+   kAPI to attach a bound device to an IOAS. Similarly the external driver uAPI
+   allows userspace to initiate the attaching operation. If a compatible
+   pagetable already exists then it is reused for the attachment. Otherwise a
+   new pagetable object (and a new iommu_domain) is created. Successful
+   completion of this operation sets up the linkages among an IOAS, a device and
+   an iommu_domain. Once this completes the device could do DMA.
+
+   Every iommu_domain inside the IOAS is also represented to userspace as a
+   HW_PAGETABLE object.
+
+   NOTE: Future additions to IOMMUFD will provide an API to create and
+   manipulate the HW_PAGETABLE directly.
+
+One device can only bind to one iommufd (due to DMA ownership claim) and attach
+to at most one IOAS object (no support of PASID yet).
+
+Currently only PCI device is allowed.
+
+Kernel Datastructure
+--------------------
+
+User visible objects are backed by following datastructures:
+
+- iommufd_ioas for IOMMUFD_OBJ_IOAS.
+- iommufd_device for IOMMUFD_OBJ_DEVICE.
+- iommufd_hw_pagetable for IOMMUFD_OBJ_HW_PAGETABLE.
+
+Several terminologies when looking at these datastructures:
+
+- Automatic domain, referring to an iommu domain created automatically when
+  attaching a device to an IOAS object. This is compatible to the semantics of
+  VFIO type1.
+
+- Manual domain, referring to an iommu domain designated by the user as the
+  target pagetable to be attached to by a device. Though currently no user API
+  for userspace to directly create such domain, the datastructure and algorithms
+  are ready for that usage.
+
+- In-kernel user, referring to something like a VFIO mdev that is accessing the
+  IOAS and using a 'struct page \*' for CPU based access. Such users require an
+  isolation granularity smaller than what an iommu domain can afford. They must
+  manually enforce the IOAS constraints on DMA buffers before those buffers can
+  be accessed by mdev. Though no kernel API for an external driver to bind a
+  mdev, the datastructure and algorithms are ready for such usage.
+
+iommufd_ioas serves as the metadata datastructure to manage how IOVA ranges are
+mapped to memory pages, composed of:
+
+- struct io_pagetable holding the IOVA map
+- struct iopt_areas representing populated portions of IOVA
+- struct iopt_pages representing the storage of PFNs
+- struct iommu_domain representing the IO page table in the IOMMU
+- struct iopt_pages_user representing in-kernel users of PFNs
+- struct xarray pinned_pfns holding a list of pages pinned by
+   in-kernel Users
+
+The iopt_pages is the center of the storage and motion of PFNs. Each iopt_pages
+represents a logical linear array of full PFNs. PFNs are stored in a tiered
+scheme:
+
+ 1) iopt_pages::pinned_pfns xarray
+ 2) An iommu_domain
+ 3) The origin of the PFNs, i.e. the userspace pointer
+
+PFN have to be copied between all combinations of tiers, depending on the
+configuration (i.e. attached domains and in-kernel users).
+
+An io_pagetable is composed of iopt_areas pointing at iopt_pages, along with a
+list of iommu_domains that mirror the IOVA to PFN map.
+
+Multiple io_pagetable's, through their iopt_area's, can share a single
+iopt_pages which avoids multi-pinning and double accounting of page consumption.
+
+iommufd_ioas is sharable between subsystems, e.g. VFIO and VDPA, as long as
+devices managed by different subsystems are bound to a same iommufd.
+
+IOMMUFD User API
+================
+
+.. kernel-doc:: include/uapi/linux/iommufd.h
+
+IOMMUFD Kernel API
+==================
+
+The IOMMUFD kAPI is device-centric with group-related tricks managed behind the
+scene. This allows the external driver calling such kAPI to implement a simple
+device-centric uAPI for connecting its device to an iommufd, instead of
+explicitly imposing the group semantics in its uAPI (as VFIO does).
+
+.. kernel-doc:: drivers/iommu/iommufd/device.c
+   :export:
+
+VFIO and IOMMUFD
+----------------
+
+Connecting VFIO device to iommufd can be done in two approaches.
+
+First is a VFIO compatible way by directly implementing the /dev/vfio/vfio
+container IOCTLs by mapping them into io_pagetable operations. Doing so allows
+the use of iommufd in legacy VFIO applications by symlinking /dev/vfio/vfio to
+/dev/iommufd or extending VFIO to SET_CONTAINER using an iommufd instead of a
+container fd.
+
+The second approach directly extends VFIO to support a new set of device-centric
+user API based on aforementioned IOMMUFD kernel API. It requires userspace
+change but better matches the IOMMUFD API semantics and easier to support new
+iommufd features when comparing it to the first approach.
+
+Currently both approaches are still work-in-progress.
+
+There are still a few gaps to be resolved to catch up with VFIO type1, as
+documented in iommufd_vfio_check_extension().
+
+Future TODOs
+============
+
+Currently IOMMUFD supports only kernel-managed I/O page table, similar to VFIO
+type1. New features on the radar include:
+
+ - Binding iommu_domain's to PASID/SSID
+ - Userspace page tables, for ARM, x86 and S390
+ - Kernel bypass'd invalidation of user page tables
+ - Re-use of the KVM page table in the IOMMU
+ - Dirty page tracking in the IOMMU
+ - Runtime Increase/Decrease of IOPTE size
+ - PRI support with faults resolved in userspace
-- 
2.37.3

