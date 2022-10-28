Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4525A611E5B
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 01:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiJ1XzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 19:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiJ1XzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 19:55:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FD95809D;
        Fri, 28 Oct 2022 16:55:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOdTAKbvGO/F9clZvpEjrJ12aSk0iWTwbnQYKDHo5gUsasNm7oqKz3fMc/zYFDtFMW2ZDuVboZ9gwOwfI6anggFq0gJfo91/SfhpjzLenaNIal+t9xMXyxaS5Cjy+N/4NdaesKx5GmTFwO1tAnOa7bPc4+9ZiGFnWc8bR8rm+z/s9Pzmr0sPVSQnW9l0NKGr0oWWC1V8jWIbwFDytaGBGbl2pHf4V8/ziQ6kYJZ9/WYoI9wFfIfUQJbxcPoG39GGa3yM3/4Phv4si7TNNlt4nEutTj2cAM3dbwqO05WloGGT3sBtYLDjkS00W8kjYpJeSojI4E/kk9WtR8Fa6CYZEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfUGmyKIfDbukXyo4BkEuQTuL+05ZIcIDdfWSjAbi3k=;
 b=ifNTKqOTpZ1Wq7z97lMuKaYy7NvsfUCrinFSGxFtq75Sve6JkhaEpYb/oN1TLP+azOimqX/7ILHi8egml2cGywXAFKrPRuxm/tuzp2lvWE+6NY4ozJp4DPjC0kLZHuWsPctoEU2HBu36n8h3KktBITtk0d8cs3UrVzGX7hdgn9F9CfKdkOTDnJj66Z079CReBYXGPBzkW5T1xttIRhdkjhBPtnKynO/NefT5FQ9I5Sg0U3MvEJv8dolDNsiCMbuqJnPsIb4J9qgsDTD9R04oZal5sCbkctPlK/D97ORN/mttZG0gk8oUs7OQAaYq8DhtO74TsMYbhD9A2FtChNgLdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfUGmyKIfDbukXyo4BkEuQTuL+05ZIcIDdfWSjAbi3k=;
 b=FK8pF5Nd37gJKmu68Ila1T8XD7QCBrEVfQcMEu37oJGHVCaJuiq23okLaxYdEOtBdD7bIXZDVZEwzk9BBlb5IQ4MSs7TyG9jIKI1m3U3AS6DlKuypYIndLvOGPoMoZSSz+esD134T2WVbXs25td8ddYNOjbE2tGMd6+vfFL52NF0EWNW8AcuOel6bOux8qADeFHXElrvg7YKgBP3prtCyOBSC6cfoG3H9e0ZBuXnTaSU65EEvi6htIriEy7aBRYvbxlOeRuZZjNkWbLXvoec58TL0JbuhA2+5q5yCr4ndG35JCdLcspgiQWEK5/PAglaWp5ABxvh31TKfP0TqAg/Jg==
Received: from MW4P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::12)
 by CH2PR12MB4261.namprd12.prod.outlook.com (2603:10b6:610:a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 23:55:02 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::e2) by MW4P220CA0007.outlook.office365.com
 (2603:10b6:303:115::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14 via Frontend
 Transport; Fri, 28 Oct 2022 23:55:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Fri, 28 Oct 2022 23:55:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 28 Oct
 2022 16:55:00 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 28 Oct 2022 16:55:00 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Fri, 28 Oct 2022 16:54:58 -0700
Date:   Fri, 28 Oct 2022 16:54:56 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@gmail.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        <dri-devel@lists.freedesktop.org>,
        Eric Auger <eric.auger@redhat.com>,
        "Eric Farman" <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        <intel-gfx@lists.freedesktop.org>,
        <intel-gvt-dev@lists.freedesktop.org>, <iommu@lists.linux.dev>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Jason Herne" <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        Longfang Liu <liulongfang@huawei.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        "Halil Pasic" <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Rodrigo Vivi" <rodrigo.vivi@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 00/10] Connect VFIO to IOMMUFD
Message-ID: <Y1xr0IYUf8lx+hHl@Asurada-Nvidia>
References: <0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
 <Y1xrbbTEsaEEcU7O@Asurada-Nvidia>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y1xrbbTEsaEEcU7O@Asurada-Nvidia>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT049:EE_|CH2PR12MB4261:EE_
X-MS-Office365-Filtering-Correlation-Id: 00187bf3-0bec-4e37-a4f1-08dab93fd417
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qTGX5vS1HfJZP1F7FRu1w7+lAdHksmc0lLPpIZY/Oa78Z8PZZGHzkCiQxmxk5U3SvftpyPnWtiz62UHVZzUtOk4/aq3pBTNRadQ0bzz1XByKWLtZHlXBBf5ecNn8qTKzIOtTQ2l2dAnTyZFNiC3/iNlDKIJp4MsCFCtBF9BP3P4b7C4ujF+43HW0vnuS2tLJWn6GZHuMfj60Nha/trLi/JcfIG1qDo+0cV+KXK7zpWRuU3liUR0o4eb6XQ2gha0XhA5k9qOIv3U5c0ARy33jLRANL4mB5P4jgSxcvQydssSoCAO18D50aLY9FAFObvk3CaoFIJdOcqw5bMTwN3q3HI2xRXiX64bALqouF1QS3hb/MvUttV4h1oTcJKiRNLOd9TylAPDXJjaCCo1pjaFruGBubBr1EC2ciXKO3m1LwcVsw5DmESul+LWzvForOTVr5q1ks7MIKkDcngkCNCMmekp2DjVQD4udS2Wz+YLL/eua+pENTVEkum7h5cKryTlm3FWXHIlOhHxPuIVoG2cLMrg3iVYtqKn23M19+cnj+YipYOzIrONMlSWoGXyuXu8SpHf3m4I1q2nDsQjlM6rcdOnUTJCQMniQUtk7mRte8HcXkOM8s5cvj8hhGJ61j4KT/MnumtRkUQYNgBtnjw3EgKArIhl84capPdQZ7xulqs/FInmMJYyGa2OAtzca8c8eSNRKf78zVZx407DPsDuZMRpw4bY13lYQUzLFntqq27VeA873WoB4X5Wxs61GRODVwGoPwwy0gGC1tSLclcN9FWPMOfMn5/Q37f4tMytAGjL5rn9MsfuB7OjaqZID7mw+QAqAHggyCgkamvQiHHqSceghsdbnRqHodIfUUDjZYj9l5jtgyhiPAi0SiA5esAGg
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199015)(46966006)(40470700004)(36840700001)(426003)(7406005)(47076005)(83380400001)(40460700003)(86362001)(82740400003)(36860700001)(5660300002)(356005)(7636003)(2906002)(7416002)(70206006)(8676002)(4326008)(41300700001)(8936002)(33716001)(82310400005)(54906003)(6862004)(70586007)(26005)(336012)(186003)(9686003)(6636002)(316002)(966005)(478600001)(40480700001)(55016003)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 23:55:01.7806
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00187bf3-0bec-4e37-a4f1-08dab93fd417
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4261
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 28, 2022 at 04:53:21PM -0700, Nicolin Chen wrote:
> On Tue, Oct 25, 2022 at 03:17:06PM -0300, Jason Gunthorpe wrote:
> > This series provides an alternative container layer for VFIO implemented
> > using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
> > not be compiled in.
> > 
> > At this point iommufd can be injected by passing in a iommfd FD to
> > VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
> > to obtain the compat IOAS and then connect up all the VFIO drivers as
> > appropriate.
> > 
> > This is temporary stopping point, a following series will provide a way to
> > directly open a VFIO device FD and directly connect it to IOMMUFD using
> > native ioctls that can expose the IOMMUFD features like hwpt, future
> > vPASID and dynamic attachment.
> > 
> > This series, in compat mode, has passed all the qemu tests we have
> > available, including the test suites for the Intel GVT mdev. Aside from
> > the temporary limitation with P2P memory this is belived to be fully
> > compatible with VFIO.
> > 
> > This is on github: https://github.com/jgunthorpe/linux/commits/vfio_iommufd
> 
> Tested-by: Nicolin Chen <nicoleotsuka@nvidia.com>

Sorry, wrong email -- should be:
Tested-by: Nicolin Chen <nicolinc@nvidia.com>

> Tested this branch on ARM64+SMMUv3 with the iommufd selftest and
> QEMU passthrough sanity using noiommu and virtio-iommu setups by
> combining with both CONFIG_VFIO_CONTAINER=y and =n.
