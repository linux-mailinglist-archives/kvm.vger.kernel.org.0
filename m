Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F0A63C93A
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbiK2U36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiK2U3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:29:54 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2AA63CC5
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:29:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vy9zdDS3sUXvWEBcJwG4XlYSHi0z1yEERqGxUPZ9YvO2vRIzb0kuj1+QF/mm5JpYnT++ibeaR4+CGKLrO7LNmR7eSnLYTHN+UJP8/6ayxAUHl3Gn5o7ze3IYNBjZAeWfMwEzMZY34uQY2LhyAxliWYFYwrdQiEoaYYseuxERH1XZVMUEpXNi05B9GWlAzGYFL7/KGmHgduxBT8c5TJrUVxFgLBYgSAEyOfzhr3hFBnnM53F0EnmHhrZ1uVEQJJcLy1Kk8U0//axRv/e+R3iJCczqFIBaYXvBAbybdImkJEE0XQbBY/eVd7uA1L1TyUN7gJCIDN1uoxpiV3CgSb3teQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnAxDMsiD7KqBLK8nkyDXsBC0DMKIBdFp7Z04tOfK7o=;
 b=gAw2t843Vj9CIG39xp0cPCi549f8z++HZ5w+Zj5j2c76//FFVHB7gntkj+PnBQxZHCkx7UnAYtm147996Wo6GyWbpuOWZogLlvRpsovLThtJwj1V25RZptRsbHDCioyHa+HUdSj4POvY3ysdCvMM/gVW7Ny7rZ43JsvrYJogrkN6KU2/VA/av9A9QSWo47gSJs9jO8rRb/uV7IcfT/o9isf7AxInAgFav5RkKqeQ1H5HyNDZBNzFtYS5FnHO7yLcILxNOPofmXHD3fxP42+Do5MaIRYTlBWdMgGPey7x2oBcPQEvtzL1SQCgUxuA4I+Uz4nLooGVQXai12a0W8/Ubg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnAxDMsiD7KqBLK8nkyDXsBC0DMKIBdFp7Z04tOfK7o=;
 b=as6WV6oA0QRUCTQIPAnI0aNctyn8rsVDzyHBkdF0uszSli3B4b1ge2L71h7CRcwJQARM5Wxy0PkPj61SUKYTlGzZeW8KzOgu2QNcB9jj7eOJ3cOFal1YjZyhFJwDX/Y23MeDty1EZKOJkqCzhMiCD2PL969TVQ3VxYea3Kshj+buZYaRhxxLutWWfv7HQVKxKCSEdibchHRxLKzM+7EiTX3i2u9FAqhfr1gWy3uQtqdgV/6OADrYe17RziDznicf2N2bqlyBX1ZrmaRk+kKCpddSm3b2YskalqsmdpCGgn8mVvJ7h7ZUVnpKJ7CPWmGeK1Unno18/N+VkNlHzH85AA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:47 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 05/19] iommufd: Document overview of iommufd
Date:   Tue, 29 Nov 2022 16:29:28 -0400
Message-Id: <5-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0109.namprd05.prod.outlook.com
 (2603:10b6:a03:334::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: 99f2f76f-b30b-4130-66c3-08dad24873de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZCZpmAl/ubm6vz51+eu+dlW5fw+BBj3upLM2jGTIeRxHYWJg2/bDpKDINkS6lGXjbx0dxkyh3jpskCzXThanKUcSQ4JlTs9F8LlKNR2ECdi+QCQuMtsO8+fu7u4cRlruo6y5/B6w1QOKujDHTt3QT4BV1jAv3qvP1nTeLsa130ZfTwY54zeaZi27EKBOQg0Dr/1dOexj4M/LKGcljRUOcbBx7Hsz/tHgZjSHttHRtxoB9pH9cLJLclYtByDEf2BnqXQtuodJk18J3BAqJoReSSVBFkh1dP7WCcJQnr3zjauyq2/GLN8QNNX/tQRC0MbqJmlP3VJPZvMrA12craBd2tIBMOBwxTc/gyXBVTwyu17dh/6fq13KpG+EHKnscTaoC5RKlbuMKfFmzM2LFvT5Kv3CXvrRqqnpeerLpq49sJ+SddxoWyLT/H6/pOI83hdCi084KlQCtslR91aOdKqqjx6NZaML8i0JR4mx3YJh4OxcEhV3ZAPPWi42uOoaxeJhDqIQZvPSad9RcSaRQ5bk4Asmj2Q+IHF7vn5R8YPOpQnzpYdSQJqQmOU78qpk0WC6eG7tioYHNFsuq21d1j5xltduoriqYWtCTPoANgiIiViTiyk1z9wR9ZpZSTrlpjKy+Fdhg7PwWX80E2vzA7GP9/lmStg/PFrS2MctWras/tqEqxOrOnIJk4raYE0sSWBLw7MYVCI7mzqrBA/4FR5zXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Vs5XWfmtIfZF/6IMo99uKgS3RbunrrGNUNvdZhpcbuwi5wmJ1IwG7eTGX1a?=
 =?us-ascii?Q?P0v2ut9ISZTGO6S42cqkhIIqLIBIJulprsriB4zbOo2A6DzNJWmegh8qINXh?=
 =?us-ascii?Q?JSFuggSxGsmDEA5IwLYMYSw32KfN5Wi+Hwi/kLGwu5yvsKvxKKL82wkqJXXI?=
 =?us-ascii?Q?UxszxOv8K0YXTivFW+cRr/eYafML5Y3dCoGvU3MM+jnAAmdHratkg67nlbew?=
 =?us-ascii?Q?BKgmWy2Q1Z4IGNwEe+POdz1Hpo2GWO87mu5omHvIcxPoV0AvWNFDmBBgSCql?=
 =?us-ascii?Q?yoWv3nKTO/4VPf8h/u/Wph2+nG0rQsr8jRjq4V06Dm30OjfM/AYT9Zk02uVG?=
 =?us-ascii?Q?KTfQArzgnI8UelyT1mQVPFCrH5nFspHFYuqf1N3JO9sa9n9Nl2pn+/grKcLi?=
 =?us-ascii?Q?ycvs9j3qI2XdurldCr+UaLg7LWxpXUgO2yyi7jKx9t+o2WKCFwSQrcBIFJEY?=
 =?us-ascii?Q?Z+DWL4UnFMDEd5rBqLkU03aPZrujpx8bJ3W2bGATHRfjne6BvNHNC398m1YU?=
 =?us-ascii?Q?PJJXuyaxZJ1MZC+UclMKFxOSlfHoHA+F8CTWhQeGwgU7UyJcjDHrIgI8Haub?=
 =?us-ascii?Q?Db635BOZbPoxkzH0l5mZsOVDjPxyHQEZQIDrkqW2ZRoUYi+7thWlaJnRS1w3?=
 =?us-ascii?Q?+sJkLPWSrgQjBLLyeRr9NgAAQtgkChmweKLq6M66UIa6vKPEWq0TCBcgPmVq?=
 =?us-ascii?Q?sdOyfPI9QrTGaG3q9RVuHpsJPM18JoWPuzKMsTdBlZZNnj3bBasXenv76Y/f?=
 =?us-ascii?Q?GaqFOSDlLF/kDpnkkzt/j+6t99GCup9/3WrnRO4wOTzpnLEER0EAzUlYIAiw?=
 =?us-ascii?Q?r4Cbdn2oCj8CHNa+CVX/vxmYGlMm3PKAeCdYHuuqAYmAsh63YHBJ4NJus9cm?=
 =?us-ascii?Q?IrWc5/dGAGejxNakZg9rgxEqUIg/hrS3XIo1aKa0++OTgu0bbOEyaxGYl4ZM?=
 =?us-ascii?Q?lEeT/h57tB6t1HBqjeo5PZUpCD1YW2ADBBqAwlGyUoYiJ4GfjeW2p8raPDmt?=
 =?us-ascii?Q?3oPwReTq7UKhzEwJdy/+1jSL+r2vxTKfiKFTC+fcAsSH5rndd3a1U5NH1QCL?=
 =?us-ascii?Q?CG2Z9zAbDKn2Nv8nFoq/7asCUCpmTpQF/zL8+h74Gd0oEju9uCEfDXzLZOBC?=
 =?us-ascii?Q?Tr8+Hio5vqnKCokfKJBUOvkjdMGKW9lkBOT/PlgEcRd5aiLO8MYcgzKBNKJa?=
 =?us-ascii?Q?emwM/O1ImLJhVubFWt96Thv9KnQHN0DIgI+V44Nle+BFFkXeilG+smkNK4O2?=
 =?us-ascii?Q?kmCCoqlmoyiTWa+XJ0VvnRc3ns1BEJ+piIx2GEx6a9sZSim4OTYK3aS5MYc0?=
 =?us-ascii?Q?+SjrgHVNcPWHxjenYMZ11e5zTBM/It81OQ8AxI2wc/j5z76CIEupsZ5IMjJu?=
 =?us-ascii?Q?sYZ/8VIZMyiN8pywzsfyev+X/Z1mjeRnHv8nwwEH7kVR9KNqp03pxoh+Zjrc?=
 =?us-ascii?Q?VtNFgTdeuG9yXXVygukqMUehPRpO7nJ3LKMIUsoEh8uF+1iBlHndcOvx2WV+?=
 =?us-ascii?Q?yauxtGr5yVn2k0I5kHqK3+2ABRhBhhPe/+F2VkYiPgrO9I5rhtxEONUs9uzY?=
 =?us-ascii?Q?a56gQ/nbEaCYhwK0NqguAmegPmNWYc4XdXj/s5a3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f2f76f-b30b-4130-66c3-08dad24873de
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:45.3517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RcjSHghKicdsTK5s4zKhVmZ4TfmPUXQ/mTdTBLTTVyhb8/x9F2UefceV3k7qYAE3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kevin Tian <kevin.tian@intel.com>

Add iommufd into the documentation tree, and supply initial documentation.
Much of this is linked from code comments by kdoc.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/userspace-api/index.rst   |   1 +
 Documentation/userspace-api/iommufd.rst | 223 ++++++++++++++++++++++++
 2 files changed, 224 insertions(+)
 create mode 100644 Documentation/userspace-api/iommufd.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index c78da9ce0ec44e..f16337bdb8520f 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -25,6 +25,7 @@ place where this information is gathered.
    ebpf/index
    ioctl/index
    iommu
+   iommufd
    media/index
    netlink/index
    sysfs-platform_profile
diff --git a/Documentation/userspace-api/iommufd.rst b/Documentation/userspace-api/iommufd.rst
new file mode 100644
index 00000000000000..8b1392fd2e3487
--- /dev/null
+++ b/Documentation/userspace-api/iommufd.rst
@@ -0,0 +1,223 @@
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
+IO page tables from userspace using file descriptors. It intends to be general
+and consumable by any driver that wants to expose DMA to userspace. These
+drivers are eventually expected to deprecate any internal IOMMU logic
+they may already/historically implement (e.g. vfio_iommu_type1.c).
+
+At minimum iommufd provides universal support of managing I/O address spaces and
+I/O page tables for all IOMMUs, with room in the design to add non-generic
+features to cater to specific hardware functionality.
+
+In this context the capital letter (IOMMUFD) refers to the subsystem while the
+small letter (iommufd) refers to the file descriptors created via /dev/iommu for
+use by userspace.
+
+Key Concepts
+============
+
+User Visible Objects
+--------------------
+
+Following IOMMUFD objects are exposed to userspace:
+
+- IOMMUFD_OBJ_IOAS, representing an I/O address space (IOAS), allowing map/unmap
+  of user space memory into ranges of I/O Virtual Address (IOVA).
+
+  The IOAS is a functional replacement for the VFIO container, and like the VFIO
+  container it copies an IOVA map to a list of iommu_domains held within it.
+
+- IOMMUFD_OBJ_DEVICE, representing a device that is bound to iommufd by an
+  external driver.
+
+- IOMMUFD_OBJ_HW_PAGETABLE, representing an actual hardware I/O page table
+  (i.e. a single struct iommu_domain) managed by the iommu driver.
+
+  The IOAS has a list of HW_PAGETABLES that share the same IOVA mapping and
+  it will synchronize its mapping with each member HW_PAGETABLE.
+
+All user-visible objects are destroyed via the IOMMU_DESTROY uAPI.
+
+The diagram below shows relationship between user-visible objects and kernel
+datastructures (external to iommufd), with numbers referred to operations
+creating the objects and links::
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
+1. IOMMUFD_OBJ_IOAS is created via the IOMMU_IOAS_ALLOC uAPI. An iommufd can
+   hold multiple IOAS objects. IOAS is the most generic object and does not
+   expose interfaces that are specific to single IOMMU drivers. All operations
+   on the IOAS must operate equally on each of the iommu_domains inside of it.
+
+2. IOMMUFD_OBJ_DEVICE is created when an external driver calls the IOMMUFD kAPI
+   to bind a device to an iommufd. The driver is expected to implement a set of
+   ioctls to allow userspace to initiate the binding operation. Successful
+   completion of this operation establishes the desired DMA ownership over the
+   device. The driver must also set the driver_managed_dma flag and must not
+   touch the device until this operation succeeds.
+
+3. IOMMUFD_OBJ_HW_PAGETABLE is created when an external driver calls the IOMMUFD
+   kAPI to attach a bound device to an IOAS. Similarly the external driver uAPI
+   allows userspace to initiate the attaching operation. If a compatible
+   pagetable already exists then it is reused for the attachment. Otherwise a
+   new pagetable object and iommu_domain is created. Successful completion of
+   this operation sets up the linkages among IOAS, device and iommu_domain. Once
+   this completes the device could do DMA.
+
+   Every iommu_domain inside the IOAS is also represented to userspace as a
+   HW_PAGETABLE object.
+
+   .. note::
+
+      Future IOMMUFD updates will provide an API to create and manipulate the
+      HW_PAGETABLE directly.
+
+A device can only bind to an iommufd due to DMA ownership claim and attach to at
+most one IOAS object (no support of PASID yet).
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
+- Automatic domain - refers to an iommu domain created automatically when
+  attaching a device to an IOAS object. This is compatible to the semantics of
+  VFIO type1.
+
+- Manual domain - refers to an iommu domain designated by the user as the
+  target pagetable to be attached to by a device. Though currently there are
+  no uAPIs to directly create such domain, the datastructure and algorithms
+  are ready for handling that use case.
+
+- In-kernel user - refers to something like a VFIO mdev that is using the
+  IOMMUFD access interface to access the IOAS. This starts by creating an
+  iommufd_access object that is similar to the domain binding a physical device
+  would do. The access object will then allow converting IOVA ranges into struct
+  page * lists, or doing direct read/write to an IOVA.
+
+iommufd_ioas serves as the metadata datastructure to manage how IOVA ranges are
+mapped to memory pages, composed of:
+
+- struct io_pagetable holding the IOVA map
+- struct iopt_areas representing populated portions of IOVA
+- struct iopt_pages representing the storage of PFNs
+- struct iommu_domain representing the IO page table in the IOMMU
+- struct iopt_pages_access representing in-kernel users of PFNs
+- struct xarray pinned_pfns holding a list of pages pinned by in-kernel users
+
+Each iopt_pages represents a logical linear array of full PFNs. The PFNs are
+ultimately derived from userspave VAs via an mm_struct. Once they have been
+pinned the PFNs are stored in IOPTEs of an iommu_domain or inside the pinned_pages
+xarray if they have been pinned through an iommufd_access.
+
+PFN have to be copied between all combinations of storage locations, depending
+on what domains are present and what kinds of in-kernel "software access" users
+exists. The mechanism ensures that a page is pinned only once.
+
+An io_pagetable is composed of iopt_areas pointing at iopt_pages, along with a
+list of iommu_domains that mirror the IOVA to PFN map.
+
+Multiple io_pagetable-s, through their iopt_area-s, can share a single
+iopt_pages which avoids multi-pinning and double accounting of page
+consumption.
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
+scene. This allows the external drivers calling such kAPI to implement a simple
+device-centric uAPI for connecting its device to an iommufd, instead of
+explicitly imposing the group semantics in its uAPI as VFIO does.
+
+.. kernel-doc:: drivers/iommu/iommufd/device.c
+   :export:
+
+.. kernel-doc:: drivers/iommu/iommufd/main.c
+   :export:
+
+VFIO and IOMMUFD
+----------------
+
+Connecting a VFIO device to iommufd can be done in two ways.
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
2.38.1

