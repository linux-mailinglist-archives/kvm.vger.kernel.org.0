Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588EA6BA7CA
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 07:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjCOGZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 02:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjCOGZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 02:25:42 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5515C136;
        Tue, 14 Mar 2023 23:25:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJeN7yo/pnHPwHMtrqXlh2vo85fBkbEnfyVoo78gfV07la+l9GapwVYnEqpGV1dbyU7SC1LUbrlEqJ79Yfj++h5NS4KYNG3eirzamKxIa7ljNXkOuzCtDNdBRlVuFUUp1NUhK/n2CPl4g5ajs3s1iMkq8w0q4v73+2Q/ktAsvo7VxDIHqwj9xBNW8lcJGJvWEOEW36rLIS4qlP2jePqOuoc2dIgmz7bc5wKzTS3WPOZYVX14NN1E1UlZnHpJIjN3ykAJWuZ1BPCMS81JlKTKxuheO1Zn+cysy7sOKU7nct4On7A4GOoxmPqgzvIXx407wV/CxweSA8oIpbBdpnkmtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ua6y7QdR0eoUvnOVOUKD2q+meS7vGwPmfCBT1+hZm9k=;
 b=Q07nOUOAPGbh+vSDhVnBpjIFvjp0aoRFpEpAnM0cImwOweBUZkAP4djhT9/K7e6epFZsIhn5uRkNYwvsHtRspPI886C/gBgbjQAY3ol+GvYkjdBroiJqr1MHSiQZlIMv5wnk4lONDOQpWzA38jBMGLyFR6pqo6GVH1Z/bb/pkIwA0NaNf2jwTImnAzyyG9IhBHe1G+3Bnvx6o47MLxkcAbcu74ibuniL0KsDH/m4FajqGHuHm6Lk+2QcpByvOdpcSfCTwkMOIaKSRd0ZD+iWDe+4CXyJ2nORrh6pfwY39fyvchpLiKBEXQV7knkLtAF72h+9dh9+gQ6cbdP3JhTU1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ua6y7QdR0eoUvnOVOUKD2q+meS7vGwPmfCBT1+hZm9k=;
 b=BT+ZNYKWNM1SfEsP6Oing4L7nEWZH8vvYIkeV2uXE3ZGlemvglaa1lJXipGRHYAbT18x/JpKwJaptNjPVI/wlqlvbRMM/UMXjiHhW4Um4a5VPTcxqq8pPJWNpjEW9rHRES6R3w4Chhh2s6GinHJ/bq05d2znLhrqKPuA00mK0fybe1Zuv5w1ZVhjEzaKKWV2qk+5JbxY13OLhyLtXOGvY8dLTdmzdqAXybTyqLLPEPEbSv9JM6QB0+AWrR+LgULoPTE1WsOKz+KlZXYwd0aOUkg/pplN4f8vzlTvqsccsuNsagub+bBYk8LpPuZ4J56VeP0R8FSbgYBXj2jxUJ3nAg==
Received: from DM6PR07CA0127.namprd07.prod.outlook.com (2603:10b6:5:330::28)
 by PH0PR12MB5466.namprd12.prod.outlook.com (2603:10b6:510:d7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 06:25:30 +0000
Received: from CY4PEPF0000B8EC.namprd05.prod.outlook.com
 (2603:10b6:5:330:cafe::79) by DM6PR07CA0127.outlook.office365.com
 (2603:10b6:5:330::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Wed, 15 Mar 2023 06:25:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000B8EC.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.7 via Frontend Transport; Wed, 15 Mar 2023 06:25:29 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 14 Mar 2023
 23:25:11 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 14 Mar
 2023 23:25:11 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Tue, 14 Mar 2023 23:25:09 -0700
Date:   Tue, 14 Mar 2023 23:25:08 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v6 19/24] vfio-iommufd: Add detach_ioas support for
 emulated VFIO devices
Message-ID: <ZBFkxL8lKP7FcCml@Asurada-Nvidia>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-20-yi.l.liu@intel.com>
 <ZAvAefwLEj8i13+s@Asurada-Nvidia>
 <DS0PR11MB7529D9C29E76E74EF7B8E038C3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529D9C29E76E74EF7B8E038C3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EC:EE_|PH0PR12MB5466:EE_
X-MS-Office365-Filtering-Correlation-Id: 53c865e0-0ac1-4d02-57c9-08db251e129e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QRzWyq0x0GHFhZFPFquLBW59+T5R9/BPvOzZ7HEscw2Y9mNLNWbYvXCVJSBCPB63EcRYFEwqSQkIByJm1IPKXsJf5bxX4L4WDNcJUWl4PMWAZJGITOPAPKDP3BzCWFNeXaQuCLLLxb1ailhoiHA1I4ANSwm5j0rPJ0zl8bNHRiNGryAqvYVFIG+quOyiV+AwkUsut31u89ofq8+63BS/L3RGgOO2pcokzBvjrYdV5d/vwkBYfoXpBhMDIZRMSsONesAm6Ts/JkhAfe5q5ij2EFo4l1FanwdNY1ykB5RzS1SQXq/MbNYIgHiYy9XafkzO71eUzJ7plCbqFKJP/rS81SnSSFlATZPTcjY3x2d8lHxqG8W5cVJw2AQT9F+5QcD6KaQ9L0cPaJRKhVcD4CJXFWK6Kir0LoeOK7Gt3PzJZzY8WqFegNLDeNrwXw3BT3nqhPGPdXL5t+bTa96VRty6Eb9+Ejuor600Sh2YxVvaBgdSvmWFkrRuUt7Q0rTSnBjCoVUt9emSkiYAUvMjd7FfUCFnKX6USO1swpwMwBRoyKqchV/LVEnYpLV2qDvRSFOED3JL7retigcLCLqWcYfWed3ZBv1Cf8ozW0oi+tK6LYbdrf43zQ/T3+KRS+qsvEaqDub07TA52RQpAHTJI6eS/w0I1kF2En4fNTEMlhQ/89LtiKUVaIavP3+Zi4A595VJgkahakCsis6apWCXbEbEV3KVwQIK2UuE3G2mngR2jdxiq7ecJKvmRI9xVNnmd2/4dbHE3auL0CGtTJd6kNYADHedOBvkLjFaeFImuTZDDes=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199018)(40470700004)(36840700001)(46966006)(356005)(86362001)(33716001)(336012)(426003)(47076005)(7416002)(316002)(5660300002)(40480700001)(55016003)(4744005)(36860700001)(54906003)(45080400002)(8936002)(83380400001)(41300700001)(478600001)(40460700003)(966005)(186003)(7636003)(82310400005)(70586007)(70206006)(6916009)(4326008)(8676002)(2906002)(9686003)(82740400003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 06:25:29.3419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c865e0-0ac1-4d02-57c9-08db251e129e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5466
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 06:15:02AM +0000, Liu, Yi L wrote:

> > > +void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev)
> > > +{
> > > +       lockdep_assert_held(&vdev->dev_set->lock);
> > > +
> > > +       if (WARN_ON(!vdev->iommufd_access))
> > > +               return;
> > > +
> > [...]
> > > +       iommufd_access_destroy(vdev->iommufd_access);
> > > +       vdev->iommufd_access = NULL;
> >
> > After moving access allocation/destroy to bind/unbind, here it
> > should be:
> >       iommufd_access_set_ioas(vdev->iommufd_access, 0);
> 
> You are right.

Yet...iommufd_access_set_ioas is getting reworked with my patch:
In another thread, Jason suggested to have iommufd_acces_detach
API, and I am trying to finalize it with Jason/Kevin.
https://lore.kernel.org/kvm/BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com/

Nic
