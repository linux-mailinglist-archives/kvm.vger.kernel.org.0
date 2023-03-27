Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DE16CAC2C
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 19:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbjC0RsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 13:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbjC0RsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 13:48:11 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2044.outbound.protection.outlook.com [40.107.100.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7FF2710;
        Mon, 27 Mar 2023 10:48:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pd22+xbYpNK8+I1EBQWA/7hAFEJXsBwfU3ql7S2gJ+FhjWJzz/VrCBoMZO0XlVJImqAt1Cztru6jPYCXzsyRnvNlysmDhhCAsqCo24glUVYuCBuKYNStdzKna6scfJrYO//P49R8XudiLcyFwkaYfv7cZ8l2zl2iGW+IRKUHBMt/vdpxTIBFmcm64Sr6yhgN5wWIt9ZjiOep1MANkk+JOPCx6vnDW30yuyfX4u+xCM6XBffhYn0dd1F0aJFZr5hIKtobmPauxg9Ga/2wGUR0icfrqwcHTIUn0l05VpClsResZm7XM4iTULeNlnftPvtu9T6DV9SXM+wvKkd0E+bJNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BS0W4+p/GxnxDD0HoRO5curc19+HXURdpQjlIWFmLn8=;
 b=JBlMY/3L2UmemEksH4q0wtyAcsoN6E/kkwChOnpOKYr94uVWs5CDhGLI8n0WuzC5TvW7jrOP0V+Tmg7Q+X0XHxsEQlajjKbWW+jsfU7wq6Lcp7z+LP6ClxCzqQOZTTcjcEERQJeLhbqW7UiuAZcc1WF/CRPSIuj1IZG0bWQY4kvoILhhLgLCXy7CJIqdrh0NClKCRob80e9Hs/kL2qA/eTNCgvbtQKljIwXTen0Vg/DOv7NC7BQ3Xban2+2H+ra3RHRfz+ZYqrhXphlKU9nnPVM4NHaW7fEMFgptX89g9+Ps+syA9m12OAC6zjgmjstPKqsgOV+mzNM8QHFZr24+og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BS0W4+p/GxnxDD0HoRO5curc19+HXURdpQjlIWFmLn8=;
 b=Z2Ak+g1v+oDzQbxk3QzflvP/WDIk+LTKAwQSugNjFWHhnXWLwbi0hWHiPwHn1GmrEhifgRbUidp1hr2BF4vCPEvbB+KW15fdu8yJcP/vASPT0MMXdNGUJjgHaWhfApsyay1bMXkzUY2Z+/vwSRzxIXQM/dSqS2aYOjf0apNFk9JP1WW64ZUTXkq/2+6qM6ZHfYq5IMPf7bNff+gmHdcY6QTPjVFynjIe6gsJZfKy0zs+fBD9Prd36nN31Guaac5lsaF8ESEyxQkeIog1GfSBcJo0vZKuvpdVKNNQqraEtkabPTIPF5WcWueWGT4Tb8mXDTAjLWRml/mfgyaUZitIOw==
Received: from BN9PR03CA0657.namprd03.prod.outlook.com (2603:10b6:408:13b::32)
 by IA1PR12MB6354.namprd12.prod.outlook.com (2603:10b6:208:3e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.29; Mon, 27 Mar
 2023 17:48:05 +0000
Received: from BL02EPF000108EB.namprd05.prod.outlook.com
 (2603:10b6:408:13b:cafe::3a) by BN9PR03CA0657.outlook.office365.com
 (2603:10b6:408:13b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Mon, 27 Mar 2023 17:48:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF000108EB.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Mon, 27 Mar 2023 17:48:04 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 27 Mar 2023
 10:47:40 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 27 Mar
 2023 10:47:40 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Mon, 27 Mar 2023 10:47:38 -0700
Date:   Mon, 27 Mar 2023 10:47:37 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <joro@8bytes.org>, <robin.murphy@arm.com>,
        <cohuck@redhat.com>, <eric.auger@redhat.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>,
        <peterx@redhat.com>, <jasowang@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>, <lulu@redhat.com>,
        <suravee.suthikulpanit@amd.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-s390@vger.kernel.org>,
        <xudong.hao@intel.com>, <yan.y.zhao@intel.com>,
        <terrence.xu@intel.com>, <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 0/6] vfio: Make emulated devices prepared for vfio
 device cdev
Message-ID: <ZCHWuTJJ6kHHPPYq@Asurada-Nvidia>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230327093351.44505-1-yi.l.liu@intel.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EB:EE_|IA1PR12MB6354:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cb0273f-d790-455e-734d-08db2eeb6af4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NlT9wcQEOAiEutVyxLMf9I00tCaoYIZlwxJ7dlk9/tQUgPGOcXicAslOgAE862DC0VfU0sh9MU/n3nBrYZX4OPRZx2oRf4Ks6oso51H2SyWrCvyL0hNcovehnTUSQe946bCUoNmzoJX2asGg97+HB/X9okrR5R5y7vFRgEXYG7am2ey+UtQRDu9kR8/+WEQRqe2EapwVG/kvjV6P4VqgAo5AzTLjjLDPb2cHSU5vOu7KmcF9ySdDRDzzJz5cRB0Y3TjmirGdxedRcNBLh33UGUAFkeTChpLYnGwHPHy5s3Usk6olJTpmpdCM6kM48cSp1BIUVVJU8eJ4VmK8u0ivPMGfRXTG2N++Wq6TIbZ48SJRPo+x+llLZYR7ibsdBUDV9O7xCfmveXICDDOoleYHQPuEFOVl4kWtqOQk6/Fw8RA2SuZSRs8eWTeQq068nC2uIJ4CHJeeEUksb18aVOAmGKAMg3OWSaKuRG3jxEvaRTzR+50lmtSae6B9lPqCfjne/jX6nGV3zslXQAg/Dh+HdezVlMv0x6CbNV0Q0lqmbhRFvigkrt/MrgTFWY3F5QBUM/05CdjUiUOHhr9XUtO+bCHRMXW7sgnPSBylusF2dN2utqMIna3c4l6hFP7/Uv/4ektXWPbcw4Bv8teynq4lMRvpCaLwenXlp/uuTjsuZZ1/hbP/deeHaxpuzvYhgheMmMvxyE/RNx9nJa+VOKeJH3ij8DS8UCpn8cWO71PHCKcFCFdBXrBOmkCXsvNqz6SUvqh1jB4rb6B0aCVMKOW/CQWtOmVWkb2xMJS34i91mII=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(47076005)(83380400001)(426003)(336012)(8676002)(70586007)(2906002)(70206006)(4326008)(6916009)(54906003)(966005)(478600001)(9686003)(316002)(186003)(26005)(55016003)(82310400005)(40480700001)(7416002)(86362001)(33716001)(36860700001)(41300700001)(7636003)(356005)(8936002)(82740400003)(40460700003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 17:48:04.6373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb0273f-d790-455e-734d-08db2eeb6af4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6354
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:33:45AM -0700, Yi Liu wrote:
> External email: Use caution opening links or attachments
> 
> 
> The .bind_iommufd op of vfio emulated devices are either empty or does
> nothing. This is different with the vfio physical devices, to add vfio
> device cdev, need to make them act the same.
> 
> This series first makes the .bind_iommufd op of vfio emulated devices
> to create iommufd_access, this introduces a new iommufd API. Then let
> the driver that does not provide .bind_iommufd op to use the vfio emulated
> iommufd op set. This makes all vfio device drivers have consistent iommufd
> operations, which is good for adding new device uAPIs in the device cdev
> series.
> 
> Change log:
> 
> v3:
>  - Use iommufd_get_ioas() for ioas get, hence patch 01 is added to modify
>    the input parameter of iommufd_get_ioas(). (Jason)
>  - Add r-b from Jason and Kevin
>  - Add t-b from Terrence Xu

This runs well with iommufd selftest on x86 and QEMU sanity on
ARM64, applying nesting series on top of this and cdev series:
https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-03272023

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
