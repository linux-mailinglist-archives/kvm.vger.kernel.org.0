Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED163568F82
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 18:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbiGFQpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 12:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234185AbiGFQpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 12:45:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC102A265;
        Wed,  6 Jul 2022 09:45:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fi+9wVYoB6urt3hkCVwRJ+xPU5cNTjNO7mk4ralb2ST4+JstZgnDyVs1LVozkLPHn9NlRigV+kFbdXgsMJ80tM87YvXllLIpZgcLHCbQfbDWjv4i05rrdjfm1HgZZnEu6xtHbZl+PeiOqJBTA98tvuQEA+piASHzyaV1aLhZK9OQ61XMkZbbMLw8Z7GSkrhsIRkvO+m7Oy7ZwfWoCZd2WfUC+0bp7P2k9lUuN+wh11E7PPAEUL2eTjYPQoG/qg7T3/anUtfi7WzJvrnI35PDXb8zU1oe6PEhgMP360++W7ow+V4mx8kUi/kelKfEQ/eg+rozS/dOR2/FG5NtaGf92Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXFT0HlfSYTofhObyQ7pHTBV+0C3pyGfxRMsHfPjfQ0=;
 b=eas0Z+RHXFMVSX2FBohG5KJXbYhBHYsZmELABOIyd4COfbh7jhaR5Dh36Jv5NwTpCsP5jZu/xqYGXGA1NbLzBzCe0vvkC4sW7nQ+A2xQF0pupQmlkmBNYBdxfqHESxchcYflzSr43e3MIdKS0zW7pTHA/24uNW8gfPFjDoTb0/vvNjoZBCUKQ8CJMGNT8SZNrvC7p1BPXmumLbCHdUSBYWc4M7aV58tVH7QJLBCIEeUilD6O9hjJzoMBdjmOu8PfpiHWCIWtHDqEFTlxJjkvdgET3GMquiY916zuuMdSMzC3uzvVQvusiZMpWIAPi8b3Kx1F4P3kWgXoSWwUF93JvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXFT0HlfSYTofhObyQ7pHTBV+0C3pyGfxRMsHfPjfQ0=;
 b=kxqCJvJIzvPYwXW5dWIlegToiAi0tsAXATzzBfQmeGFfpmYL6ijDytzWucRSOiJIQxro2D39MLF1NyTcidVVDMITC1PXcg1YBxn8lUQa3Xvq8aaSI3MBGjCqS/zucUAz2ZCC8v4mzGgfdh5X8z37D7yVF72iCs6aaY5fX8fI6/ZSaGEMU5mztQ7/RV4E3iDO/WJc/6+yGLzJVRotbeFJDr2lHi/NCAxtS2U1sdzMyz+3E/pXtfeX/DfQO7+mm/dklcddna6+E3Oz1TbVdTejPY8lqF6qLvDuYzDFXlZ198SPtzJb4v63GqjCrPbFaVmWk+3xqVUeR2QEMNw4O6oM5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY5PR12MB6550.namprd12.prod.outlook.com (2603:10b6:930:42::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 6 Jul
 2022 16:45:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 16:45:11 +0000
Date:   Wed, 6 Jul 2022 13:45:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     kwankhede@nvidia.com, corbet@lwn.net, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, hch@infradead.org, jchrist@linux.ibm.com,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFT][PATCH v2 1/9] vfio: Make vfio_unpin_pages() return void
Message-ID: <20220706164509.GH693670@nvidia.com>
References: <20220706062759.24946-1-nicolinc@nvidia.com>
 <20220706062759.24946-2-nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706062759.24946-2-nicolinc@nvidia.com>
X-ClientProxiedBy: MN2PR20CA0041.namprd20.prod.outlook.com
 (2603:10b6:208:235::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 438bc0ad-aa18-4fd6-0d3d-08da5f6ee460
X-MS-TrafficTypeDiagnostic: CY5PR12MB6550:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8/x3cQjNnai9OhW6qPW6EzK5OT5XYzLwv5sccTzpEs66H//srZ7Y5EOnjZgZ78XPtk/LVw5lvgwhsdU+LhfI78gQjP+gVlPqdyHlivrysu06L2IKCdPq8C0ve5Iy0oLzPmr9IdXMf5mxHg/H6XKlduzj8UZThkHYn69JA0nWK6LK6o6Wx0q5QN1CMMhYZXyGTKCeS3Gaqy/UcF7JlCTtbG/A5X9mzLZCTja1LPzR3YTUOSCzvaHZNfx9zBzQGB5wtND/oCakxdueEsjO5MNMxU6OSa//vsRJfMOcVrFsaONzCktDGFq9WCDXMWBcrjK8o7yrzaYxkEw6SiMBlcJDeO1pXouixWC/cmt5e5NlSueU5TRUlCNlhZQX5J/NvImM3Ft5HTnZYJGjoYs7k2FiY9oO7BC1uOPLwWvdI9sTzg6gTcFBvTYx3LnZK4OsGVnXHh+EE3GTTWdUVBV9UaNAr7DKe6NuAJNExFdbCwsQMb7+FaTTTeT24yJ8DLUKhbvjymQkvdMMO/XbSj6vv/lTzrrSrDwzG9QyqaKsa30bUxLLjLLPo3ycfvk2w+zCfXImGsRAqlLlgTHzICtHLcX+XZRLJzf3B0ex5VfZ3BSdE47+6xmfw0t8CLQ/j1KC+Jcrbm++9SsCsso5/uZKB0uMLxol3dEgCm+Faz+9UbKZ63t4GMCzpo3T4kxJiw8rKEwxaHqwI5vic10+Ryvyy7Lz7UYZAnUHBu4ITGgDzrbQCmWXeUiK21H8vBevV2K7VWm6CZ2WKvpOeOr6VVATNETCgmrdOXbWDDW4LgHE4LCOyzQI0PXr6r11YVr/Cgsbjf8K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(83380400001)(6486002)(478600001)(7406005)(186003)(36756003)(33656002)(2906002)(4744005)(4326008)(5660300002)(38100700002)(66946007)(316002)(86362001)(2616005)(66556008)(66476007)(1076003)(8936002)(8676002)(6636002)(37006003)(6862004)(6512007)(26005)(6506007)(41300700001)(7416002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IE42i86wRKtCboBgtfOzGazp1nQJHBk+2lBdOMDX8fEHgP4mBXIar8kdpbHR?=
 =?us-ascii?Q?2G53Lssmr7GSNO6qIWuATlRdkkUOyO2KmlppjqyOkKSZH/jsJMxH9HEdAdng?=
 =?us-ascii?Q?x4JoKeHu+95RC/xzDHkKbengUBaMiag/r5SB1k3BKuQfxeVA0XfESh30gU39?=
 =?us-ascii?Q?cNmbV6vEIIFb/7Wq10IzhtrQnkZJU9xtiCzx8Xg0DLXZYr3V3qMyLRil67bU?=
 =?us-ascii?Q?oNQu/JpAsxgmf739wCQSPJOk7k4ymDrk9TSs9aHCsdzfVaUbpucAn3J77BTU?=
 =?us-ascii?Q?pLVYGdicfZ5nW1yCAqxQRNEDx6ZUzHqgE4UFP6LsaPNKBKipnl6a1504sXpe?=
 =?us-ascii?Q?cofMpx1gdKpqLiYowoCqr2z4juqqJK6T9Cw6BJT8QluZs57bozxxl2gQ3vTL?=
 =?us-ascii?Q?z9VNb0dCa0ZpONM6eaAvM9/saH5AA9UCKZPVhI5i7E7OULZ4YMJiD3HQL+HR?=
 =?us-ascii?Q?uzNNGu17ugbvi/UamrE7hjsFvUEElXB5dOOUyqQLOXLmWILMuxrGeEnSGG1q?=
 =?us-ascii?Q?4ZXcirH0FZyzTv2a9tkDeJF8j4S0Gl4Eat04/7ZAh8qoVeWrSyARsYVb6CLr?=
 =?us-ascii?Q?zgSsGSJjcD32Nfk/2nCC2v5bcRnSYPiZLhMyLYcihRvpcbXe01rHaFwL+Kbx?=
 =?us-ascii?Q?Vrt/9LydDWCLHLjdry4z4i1xMlBpsaWYuylouk7GD4CqAZMUkiGwES8UySKm?=
 =?us-ascii?Q?sQOo102w0+HVmBuFrhvkDdYRzRj78EgHybfpNaFSMJaGUk6nYdTVGDfnsJqx?=
 =?us-ascii?Q?nAv60kbkG2OEQ/mqoxr6GPiFjkcbJCPPAqseCY1C6uSiPqm8WJvzkdX1L7cv?=
 =?us-ascii?Q?FoRs+mWDzfJN2Y76Xh5bHWa6i+OJnleoAAULly/N4J5IQGpUEOOaccANfg3V?=
 =?us-ascii?Q?uuG6hn7ucG5vOCCnvYlwjrOAlJjZDXoldA+98PWZFgM4apR/PMrlQEyo+Ps3?=
 =?us-ascii?Q?48aBzHRtso/SXGwJ3Gv79gm4kaj57akqCQooBk5b8gDsYDMBAhT516IaV7jT?=
 =?us-ascii?Q?k3AYQkQ1sTK+kOJU9RwCKlOI03+QCrVC7HTJkGHCcekEZW7vUuguCSeXBv1p?=
 =?us-ascii?Q?YaJX/sDtPyOty2/V1ti9UnWjx2tNa3BUJs2YOyPtshWBwvYvQti0o+NbtJKp?=
 =?us-ascii?Q?Kmt8Erm2NspuiivWxPvOqir5bv1yiICno+mT4N68tEPVvRtOWHxyG4JMRAPv?=
 =?us-ascii?Q?B5uIq2B89mAwiNv/hcGTTNnF89582uWnLix6AhP0MK8g0u2kmcX2XHbiygIX?=
 =?us-ascii?Q?iUSfRe3iPCIJYS6RdlTHzQPWNqa+CyJsdyFb6vRIbNVRIBXne5prWDd2YxaO?=
 =?us-ascii?Q?ePXZ+cItnwy27XeUdTFMbdqKAXEQFYTGD0P0BM4Rgz1XI22r6k0AeNEfSeCU?=
 =?us-ascii?Q?8aUXVZDCRVYZRz7mwC9R4jUQKpJ4/hS5amiswwtxjFSDjX1q239nzP1UlyNn?=
 =?us-ascii?Q?AQdFPbkSyTMDa9Q47OI7eqX/8r72vcU57ca7ZU9StVKdSKglTWqObRDo2vc8?=
 =?us-ascii?Q?1QUtDb1RdS0nF/DVIpkNjCErcL/Siyco7rqaV3UNPXXWxiEzQ8Rhjf8wyCX2?=
 =?us-ascii?Q?x0I1lxWgAEapbSouiKNCmlqactq9jcSet2fs7GA0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 438bc0ad-aa18-4fd6-0d3d-08da5f6ee460
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 16:45:11.0918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDXF7gX5UTpoDQpo/7yfNVC7JkGANmgHWTTNRjSdtoZdxOueCYVE1tbRL7YQDvx7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6550
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 05, 2022 at 11:27:51PM -0700, Nicolin Chen wrote:
> There's only one caller that checks its return value with a WARN_ON_ONCE,
> while all other callers do not check return value at all. So simplify the
> API to return void by embedding similar WARN_ON_ONCEs.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       |  2 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  5 +---
>  drivers/vfio/vfio.c                           | 24 ++++++++-----------
>  drivers/vfio/vfio.h                           |  2 +-
>  drivers/vfio/vfio_iommu_type1.c               | 16 ++++++-------
>  include/linux/vfio.h                          |  4 ++--
>  6 files changed, 23 insertions(+), 30 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
