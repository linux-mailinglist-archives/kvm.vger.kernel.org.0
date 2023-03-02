Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE4D6A8D58
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 00:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCBXvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 18:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCBXvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 18:51:15 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7662131E1A;
        Thu,  2 Mar 2023 15:51:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dy4Mv9mYOu0CZeNqSBXnwqpNAEA4qPGD8Y8ryERgOFBJzSHs0x9pfK83vInKqEAjEz7UVa4/7jMInVeLtUpvU1pCry7tc71kRZhdjsUkz9lxUNchfBACj8F73OY+M4tvo+OUeDKYgy9OjobJtvYL0aFW9DnRYSHdmQsjpDEq/RxqXaZjB50ep9+UHCAllI3o+Qjk2MpfSzbhLfm4fXxAM0h0uUuz5RYByJGIQLHE5jBFWCUe3wanX37Q2TMx5S7WLPoLAXG6TyLOZMUusgAHiRdMFpIYtd7nWFZqIfLkFmR0bexHhZ5N2Wb4V3wugLnVD7NrlbMgQGNzrkh+BhgMEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7Bj7avGcjL9j8XTnhE5AE6PSjl/ZjWPj3qg8707/6o=;
 b=Bxaa6LWtjyxeo1AMvSYwAASTQyBV48up/4ImKXEZUk3GTvuifO5+NY9T9iC9YmDZDq+wpPSQpdh6F+JHNlfnDgdwFDkIy9Nx33UmjfjmLcdPObpFnb6R4M+hLksY7y8La4LVHAZ8+yYVjT35cI5Ttl+e0OT2p/6siO0eRR+sPRP2TW4ib0eECJso4fRMuWxMqkHj9EKbDTPiVWh2su9fGEBcdHxw7XSKWc5Cy+fYONXh6220mttnuW3I39P9vYn0iPpEpes2dh2rhQ0yBLVNU4mzccutqawnyhpqMYHQnWDERwP+FcrBiKCV6ny8EP6+aMIQW2NQXtT6405FluI43g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7Bj7avGcjL9j8XTnhE5AE6PSjl/ZjWPj3qg8707/6o=;
 b=Nl0f3vHIkb+Pd964Xfnyl/+TVdYIIRRk388Jn8CNlYTNGSVjknzqYKD9jXTFkx7mkxJRzrkQuzaOiTpgDCcnzs5hFZkYO6R9WPnLtbsfYy//JZs/wgdHsV81r1lHyZLgzAtItamg2TQGpGu2HPRgB7WHfWIJv24dOquKCof1anrxepaifUn7LuGBm7yLfUBvP3ovUILf8vJ64UHuCwgQo8/aDsRDjI2lnUMUzf7L7Y1VP3g334PZE+en+nH2rAX82R8V1X8F8ljsYBo5ZUzwZpVK+ZApBOS5CHHVb6RkAIxZJ5OLkictFNc2DpPB5zays0DoY9C9dDuKHF0Yc6rjAg==
Received: from BN0PR04CA0120.namprd04.prod.outlook.com (2603:10b6:408:ec::35)
 by BY5PR12MB4034.namprd12.prod.outlook.com (2603:10b6:a03:205::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 23:51:11 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::73) by BN0PR04CA0120.outlook.office365.com
 (2603:10b6:408:ec::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19 via Frontend
 Transport; Thu, 2 Mar 2023 23:51:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.19 via Frontend Transport; Thu, 2 Mar 2023 23:51:11 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 2 Mar 2023
 15:51:09 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Thu, 2 Mar 2023 15:51:09 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Thu, 2 Mar 2023 15:51:08 -0800
Date:   Thu, 2 Mar 2023 15:51:06 -0800
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
CC:     "Xu, Terrence" <terrence.xu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Message-ID: <ZAE2J0I1LiBjWUnm@Asurada-Nvidia>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <Y/0Cr/tcNCzzIAhi@nvidia.com>
 <DS0PR11MB7529A422D4361B39CCA3D248C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <SA1PR11MB5873479F73CFBAA170717624F0AC9@SA1PR11MB5873.namprd11.prod.outlook.com>
 <Y/64ejbhMiV77uUA@Asurada-Nvidia>
 <b7c1f9d5b4b647f0b0686c3b99f3d006@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b7c1f9d5b4b647f0b0686c3b99f3d006@huawei.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT018:EE_|BY5PR12MB4034:EE_
X-MS-Office365-Filtering-Correlation-Id: db36bbe9-afad-478c-88eb-08db1b79003e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6RP6V7Vttuqx+W4qm/3kkA3aIuGFUaPn/crIIV2lu8RKEmg/7hs0C8krSfVFnNRUaJkbN+gVsNJqzK7rjy3h2zAvn99ukJI73JK95aedHJEKTrHuYQJajMqBW9FLCUIySBs9rsRvClUOTW5pPPDqDfO//LpTbbkcD1W+UePCsyqAlHvILVztrfoKvFa2yoCx8Yto1pQ/SeSOQIZ0Gjg/KcEE3qhFf7/tyBGLRwN+kEyvIunBiyJrpgo8N1ciYnFe9Ft9GKUHluVDNM4KRMbShcihJO2/okUBAq+ZhD2cQjWo6KFqnURzYDgqd1lbePwMrBDabYbBKeJyK0ZfwdqJU3JefmfpSqg2nGpUb6WruFuqrGLlQmIx5Jxh121YCGVyLQAZV0pYDv2Ck3HdCaEH4T/lzJKvx2Fq1TrCE2xtgLFzz4Dxkw0i1hyoxPDUUR5QMOq0UsZA8xI82hAPSqlNzm3i0vJR8xno/m8u5TMWQ0xpsGAQ4VfVki9smVjD14uJ8Ywk8H69oevwVq36GsTt88/y5Bn5a0VoibMh1Yg3SkEYBc1/ZMXxjkGXNsVuBZzfeMd70U5KPWGD/m4kEkg1oz0Sx1JEOdt3YeC0/o+DsnsEuK3a42pkgu17M53oy8too7lw2MBamU67xieZRRCoQMcamJ6AT6QY32I0ey6+/gVpU/os1D+f4o75O2yt10EyAUNBtSwbB8mThiKcp7Z3bGTXi7k1YvFLMgD6Ia26lRQNQGuoAhD7XJMX8oNtl5z1
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199018)(36840700001)(46966006)(186003)(966005)(336012)(9686003)(26005)(316002)(54906003)(41300700001)(6916009)(4326008)(2906002)(8676002)(4744005)(70586007)(478600001)(8936002)(7416002)(5660300002)(7636003)(82740400003)(33716001)(86362001)(40480700001)(55016003)(82310400005)(356005)(36860700001)(34020700004)(83380400001)(70206006)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 23:51:11.0116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db36bbe9-afad-478c-88eb-08db1b79003e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4034
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 02, 2023 at 09:43:00AM +0000, Shameerali Kolothum Thodi wrote:
 
> Hi Nicolin,
> 
> Thanks for the latest ARM64 branch. Do you have a working Qemu branch corresponding to the
> above one?
> 
> I tried the https://github.com/nicolinc/qemu/tree/wip/iommufd_rfcv3%2Bnesting%2Bsmmuv3
> but for some reason not able to launch the Guest.
> 
> Please let me know.

I do use that branch. It might not be that robust though as it
went through a big rebase. Can you try with the followings?

--trace "iommufd*" --trace "smmu*" --trace "vfio_*" --trace "pci_*" --trace "msi_*" --trace "nvme_*"

Thanks
Nicolin
