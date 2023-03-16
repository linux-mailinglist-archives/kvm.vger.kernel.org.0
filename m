Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45CE6BC2D9
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 01:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbjCPAfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 20:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbjCPAez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 20:34:55 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F566A9095;
        Wed, 15 Mar 2023 17:33:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eo679m0dWIaJ4qFJmYk2pAZW3BLZPwFYvVt5b7+0i+6sQfr5f1tgdaW+gDSQKDGOp2fTSLkph/tk3e/pCinKjZtAw0mHePG7VHVFncIcBI6puOtla6AK7xZQUQWukAmN1GpU3dhcHpGLcTlIPdDW2CkJ6mLZn98euWwT805xj6dVhhr0+ZBMJ1fZEXwUAfWmyGqrzLEy7GwAKpvornfjiVuLxoEUdQ6kzsNt3ceEc7Jl4kN7Na7tnTr5XPiLkbbzy8zsDBwuFz/J9OHIW8qT0GFVpFH5DQ23pFmCMApx02k90A8cZ+vuNT6aT823Sq9CLvggNW47F1ca3LoI2Mi2zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33B6XREyMQcmfv+Q4YX892Beq/6N4/SKTLkDK3aodEk=;
 b=WH7gU2fWQ01GOYQKWCroejZ/vKjvT3++Rp1BBDXCFkQu4HqEz0betShsjy+f3Ix8bg1t1DY18Cak5Ga2inC+yLRoQP/pCn2bsKOj5/1gwFVSHgeCzTh8gK3cnVwScvmMeLlkRozPtuFZrZyLWD808Y7ub0Q5uWSIHxxIOtAmEAh1BFrlNxO7gePQBfqa7ONjSO7j9lYQwthlRZ6omlVtbYZDMlJuvNdNvLib/f0+/CQY6aYFc3nZSLywUV/2lpORzXdmH1KiPSp0Nvl9vzosRUKhLP1cYKT50xE3ydXaJKIcHlQRCtIul1ERPfs/boRxg5QJibXv3yWZ6iRu/mLh+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33B6XREyMQcmfv+Q4YX892Beq/6N4/SKTLkDK3aodEk=;
 b=V5XU6OV1afY2BfVkljejKd95OjzjCAjvYGIwodGmxPX3zO6OzlRTNIdOklzybaazosXnvY4F3Dv5wfkx/6zTIcRA+TVM5e3pVabqDEpvCKoA0s+HpBi8Vm2BGq+y740uNOAKm9rBQDh4A173Fv31hX6vYGXQvRfP6z21HevvmETBProX1XLSplqbtauLkbYHEHsPK09BZebvnEIHpRMbC1HVuATq7ZvKrJfyVHmo5qj/Nw/izHF8GnKrJXBSj/Ys5KrA3lyr1fQnnRxhyxK1iRJDo/3aZSfUgr2mKA3pIiI51DMclhxoXxJX8HK62xFZtOsqLUtCjb+xNAckF/6dzw==
Received: from DS7PR05CA0102.namprd05.prod.outlook.com (2603:10b6:8:56::22) by
 IA1PR12MB6113.namprd12.prod.outlook.com (2603:10b6:208:3eb::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Thu, 16 Mar 2023 00:32:53 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::73) by DS7PR05CA0102.outlook.office365.com
 (2603:10b6:8:56::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Thu, 16 Mar 2023 00:32:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.11 via Frontend Transport; Thu, 16 Mar 2023 00:32:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 15 Mar 2023
 17:32:44 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 15 Mar
 2023 17:32:44 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Wed, 15 Mar 2023 17:32:42 -0700
Date:   Wed, 15 Mar 2023 17:32:41 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
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
Message-ID: <ZBJjqfdUehQyJhJM@Asurada-Nvidia>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia>
 <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
 <DS0PR11MB752992285621A36585AEAB2BC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR11MB752992285621A36585AEAB2BC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT006:EE_|IA1PR12MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: a748221f-a16f-4a4d-cd10-08db25b5fad1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKFRgn2QdMVW5TKLaItOFN0YYmmgs9MdTA6W4nVh3H8ukBVjDGOEZ1T2yehmfawqiaSenuEvsfRcufwOUAGR4G0ragsW7mWBTNxEXwDof5dSqCuihvBJz0WnpohRNgiPbKnw0E4h5l20tBC2m5QQnC+LCKJLjOhvi3RdgxoH+KhARkLL4Shh7gDAl/5sYXLJYPogl5V9O8N+qOYH61deivpdBy8te7bcpdHj4TjGTyRavh0N7Awy9B4j8+/QEQO6DsOG7Cj8wA9//eom/epajX5f+uvZgppaKCEmqlkUrlLbgjlcEszZ9tr1qza6Q26yrf49WuLf8lsgtGkssMdX1glxtDpWF2Qo80JpElZxN7baR7Bqy2R6Wid5mrdTetpXSh/GRbqEwEgKeaPNH7mmfmY0JZ3zETMrkFMj/zoiXskHMUTY8Ez5kRPTebnGrdmT73tEDZ3ulNqp4kWSUYIeW+VyXkovXQdaRi32j4AMXX+b2ars1gZ1Eng8HX4WrzV5EiYak1Oi0zuImUnj2/P3GXFfU5+pBqByqVmHnoQhkndGHpGA9SgqSupJgRpqJFgFLluQCws97jBJH5RQ4TRn1m88AUJKPxd9hasoJkdIeYHL2M/lEoRn+ZhDGomclJc9PtVXgT1+vRl2bA7AKBLuEeHG+3orsAhLqxPb7jB8Us4kixDVpGspsliSiHvI6S7i80x0//TR+/HZqp5NuO47jHCSJKaX/ikniMm4/Xj+M1Dsr3V4sjfrmJkWydfcx+FA7LsxjRNG4cuqzIB+X8LjlLtP9nD8eOOZ7MrXcc2c3ha46oQjsiKLWSbqNWMdkj9IB8bK38Q/ip3fztIuBxKEQQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199018)(36840700001)(40470700004)(46966006)(356005)(36860700001)(7636003)(82740400003)(7416002)(8936002)(41300700001)(2906002)(5660300002)(40480700001)(55016003)(33716001)(82310400005)(9686003)(86362001)(186003)(26005)(478600001)(54906003)(83380400001)(336012)(426003)(47076005)(316002)(70206006)(966005)(6916009)(40460700003)(4326008)(70586007)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 00:32:52.9012
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a748221f-a16f-4a4d-cd10-08db25b5fad1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 12:18:01PM +0000, Liu, Yi L wrote:
> > OK. Basically I followed what Jason suggested by having three
> > APIs and combined Kevin's inputs about the difference between
> > the attach/replace(). I also updated the replace changes, and
> > rebased all nesting (infrastructure, VT-d and SMMU):
> > https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-03142023
> >
> > The major three changes for those APIs:
> > [1] This adds iommufd_access_attach() in this series:
> >     "iommufd: Create access in vfio_iommufd_emulated_bind()"
> >
> > https://github.com/nicolinc/iommufd/commit/34fba7509429380f828fb23dc
> > ca5ceaeb40e22b5
> > [2] This adds iommufd_access_detach() in the cdev series:
> >     "iommufd/device: Add iommufd_access_detach() API"
> >
> > https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a
> > 097e2c9d9e26af4
> > [3] This adds iommufd_access_replace() in the replace series:
> >     "iommufd: Add iommufd_access_replace() API"
> >
> > https://github.com/nicolinc/iommufd/commit/36507fa9f0f42cf1a5bebe7c9
> > bc2bf319b7654a8
> >
> > Please check if they look okay, so that Yi can integrate them
> > accordingly to the emulated/cdev series.
> 
> Thanks. I'll start to integrate after ack from Kevin or Jason. btw.
> Below is my latest code (rebased on top of rc-2). 😊
> 
> https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev_v7_candidate

Jason is travelling per his email in the iommufd group. Perhaps
Kevin can help us here. After that, we can integrate a version
and (if necessary) rework a bit after Jason comes back. Overall
I think they are pretty close to what Jason suggested.

Thanks
Nic
