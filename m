Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC926BC5AE
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 06:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjCPFdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 01:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjCPFdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 01:33:41 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E531F4AD;
        Wed, 15 Mar 2023 22:33:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0EIMqOuWGk5bmkRjmVIAezT+DKoMMiKw+uKgay+ajEUXkRAEhzEHC6ZRyebiKtH3bjeXpkqWjORuoqajjOLC0fZ0qbBg6YJD9cfDBuLylS4Sior38ntZt3qQDmWd4y09yZkzGFm5i7gpExlfYXb8t+Z5LZnW4zdaqz5iy2x867jW3K56XVvAyZpvrQuG9Vdq4Cf5tE0Ovk/GqUP3A/Dpgx/TGa6uumw8MgEoFYV1OtE5mgUYqV2/RK2UCikUCiVuDIfeDHovycWNlg8zJ1tXi5hJ0PzWjqAL2jtMCaxXGRFzD98Ijd2W79b4RtnVDlUyjmVDsMkw1LaZpqAUYga5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RAxlST7r0rF5FqhbHUBk5fJX8gHmMT5XIGZDa/Wj+d0=;
 b=jJ2sxXunnHIvzyTK3BCd0MYIHlNWtRvImFSHrgM3+Smk7xS3G45skonIZSpcQdaWXyYRoWp16d2rHWna6QB402r/GLm3yaK+NnEsja9TCz8N2Qphs1+P5aNl475LrAkXT2ydsuPdJbdHnH1WECCeAMC2w1X9TSnVD510zWoUAE9VyxL2lkYRxwSrJm56fdsPSZjQuwnL1TdOi5XayeFp28xItBnuW4Lq9Bn//F8HQfY1hkWReVVJ/fZE3V4j6JS3Fj66Lx1tKjY708KB1zMeZEhJqFd6/uJpLmGLufz/wQdzjhyYMeC5MIlQzTdSPsWu9HytbilzaPvkQgnmCTaAJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAxlST7r0rF5FqhbHUBk5fJX8gHmMT5XIGZDa/Wj+d0=;
 b=jv1P/oYquqOfrvL8upynfWIMmgiFE2xRcSpdiuglMppwHYHjUn/ayW2WdPvC2e6YDP3uKH8vlsT2MHPlXLw4YtxZO80L+IX3nIBRNWkxfQZF0vAR6W2Y1vdfA3vx22up9uV5bs2ls3y7pwLvpbWvERP72Y7TMxroDlENruULXtFH+5C5BPgBl9Sc6b2g6ewx+ejrYqo5WHpvA0rvCXjwNM54+2gD+r/X8grg1WODU5OQrPQp0M5wdmf/zggbrYdagMTi8i7Ei0ZD1yDuHOZbVV1k+imBiq/FHJu5LOTNaGGoP6gRb4r3l2tC9ZkLSm4L44V2SPlDDHRnN1x75RLpjQ==
Received: from BN9PR03CA0948.namprd03.prod.outlook.com (2603:10b6:408:108::23)
 by DM4PR12MB6112.namprd12.prod.outlook.com (2603:10b6:8:aa::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Thu, 16 Mar 2023 05:33:38 +0000
Received: from BL02EPF000100D1.namprd05.prod.outlook.com
 (2603:10b6:408:108:cafe::10) by BN9PR03CA0948.outlook.office365.com
 (2603:10b6:408:108::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31 via Frontend
 Transport; Thu, 16 Mar 2023 05:33:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000100D1.mail.protection.outlook.com (10.167.241.205) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 16 Mar 2023 05:33:37 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 15 Mar 2023
 22:33:22 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 15 Mar
 2023 22:33:22 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Wed, 15 Mar 2023 22:33:21 -0700
Date:   Wed, 15 Mar 2023 22:33:19 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <ZBKp9BXwX3+txIEC@Asurada-Nvidia>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia>
 <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
 <BL1PR11MB52710B5DCB08214EF4542D098CBC9@BL1PR11MB5271.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BL1PR11MB52710B5DCB08214EF4542D098CBC9@BL1PR11MB5271.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D1:EE_|DM4PR12MB6112:EE_
X-MS-Office365-Filtering-Correlation-Id: 57aed4da-f4b0-4a7f-0d31-08db25dffe63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BK86Y6HAf/SnWQiYwgxkCCcFToAII04DBE8PeynvLci+8sylhNrzXQRtoOoJx9CDezHbT3AQIlpl03U6FQBb4GneAk9JOFU+vg6oiSxP9xiMLHMXSezt0Uc2p0SpuU/lGzm2CopkkIbOFyBMy4ZySkoX+USteg3FxsV8lpGDtRz0e2ELUr/okUFtemOXzEs6B3W6PqkyDFnVuP08FWCzMI49g+OXj0CDqFySujfxcKFiN8uZOuK5AwoaaCJsasLT2d9QV3+O/0dAuZMT0lTPRtH9woLlEiakFaeUe/OZ/OoEcGvbWgvo2lVN5ybTsJBp11Ydiyw31e2ZVtLJ550Z9Kc+q5bRUv74K+mIOJofePGI62M+ODmXKx6YKyvVUZdITJ6cAGHLJeoUbukPetj4MUYQ8nqsU5iwJL/GAwKO/+Vl1hr3CZqjBR7oa+aaGmmBCa7TJ1mmpWIA6Q5Y9eY5/sxpBJtgtPq8HGAFqe4TrlP5BkVmwk1fehN4LMHT5p5zZJXa/iOrVEEsszZK4qtYNaw+m6GIKEVJ1YFejTE0u3URaZU2mHx2DtQ5pmAgWLP+6uth3mwFRFsU973yPqu9pgQW/TmHYTO9ASCucjFYg4OcMHST+GfLdN3MDAHHo48kWg9y9gu51un/PpSJv/GluCLgFywcnZYy8XC3frY6ZHdcg4vb48VM2Qvo3CtCEp/bIErYZMvGLM8vjtK/9PyGSexS3kYnyyED74Et0ku7Qpd6u39o6FH/2ajLmAVOIth6SKiw0LYn406nZ0/U1EUkgmhXKA8184KZADmlspaoM/f9dRlzGA2Q0F/L6Xk6WuLI
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(82310400005)(356005)(36860700001)(7636003)(55016003)(40480700001)(70586007)(4326008)(40460700003)(86362001)(41300700001)(8676002)(82740400003)(70206006)(54906003)(33716001)(478600001)(8936002)(6916009)(4744005)(316002)(2906002)(83380400001)(426003)(336012)(47076005)(5660300002)(966005)(186003)(9686003)(7416002)(26005)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 05:33:37.6864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57aed4da-f4b0-4a7f-0d31-08db25dffe63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6112
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

I've fixed the other two commits. Here is the one that I am
not sure about:

On Thu, Mar 16, 2023 at 02:53:50AM +0000, Tian, Kevin wrote:

> > [2] This adds iommufd_access_detach() in the cdev series:
> >     "iommufd/device: Add iommufd_access_detach() API"
> >
> > https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a
> > 097e2c9d9e26af4
> 
> also add a check if old_ioas exists it must equal to the new_ioas in attach.

This is the commit adding detach(). And there's a check in it:
	if (WARN_ON(!access->ioas))

Do you mean having an "if (access->ioas) return -EBUSY;" line
in the commit adding attach()?

And, how should we check in the detach() if it equals to the
new_ioas in attach? Isn't the WARN_ON(!access->ioas) enough?

Thanks
Nic
