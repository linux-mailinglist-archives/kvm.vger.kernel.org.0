Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444266BC5D0
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 06:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjCPFoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 01:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCPFoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 01:44:05 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61030A18A6;
        Wed, 15 Mar 2023 22:44:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTeqBmCJLV1/NBfLaD3HZMdJ/zEJrpu1ovxI6ceP8+wKnLC5D4dOcceEYHUiw9GkQjgiWXY+a76MaDQ0QiVibODo+u/RxC62ejxGBofwZguqeGXsUuB2XW2cSTms2mkjAa/vEOnzN2l7nhsU2OELR+mZtL2zUXKs6F0nF6zN4iZ7V9thgYjuR9vVODneC1PMNR5hoSt2RMGxE8z2YMSRle1bPoZIfskTsBiOIkSSfzleJ+ludZQludZ5qVybW8+iFtshEOj3CLOs9aQXMajBx4ZlEOLfVqY65OehYIVWQ/MCZg+hdkJNw1YyHdwvxQPFVpUF1Z1I7HRXshNX492mcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qv07CyGp1OXr202MI0xGtRF2hb36uVcKLP6EYdJF+hw=;
 b=S/HWEYKFrgqIUuMx9N0r+xze353aIx4OX4wTWGiaYAHjzQpnZ3Cn6yiZlrKQQOtuTgAK3rB5kJ01qNmHqNf0s84iTOWTMP6lsSrq3hjXSQCxEpFjJjOSA86GFNj1/H2+84mMi46fHNxAyWCb37BqSRVY6jTLEzKUv1czIIBVUwghaiFRJlA4dLEdtQ6IizfssZ0Q8qwFb+rKmhkGRr66QMPFfQSQH98/0N1nvgE71qq2bMJdtQQzj7LpkJwCw/ENIYAnyZpxusQP+ZYhrveM/+MDwXy9g5XcQCbZsbfFzVjEfFo/ALb7LMQlO0oKFt/5sboVotxbkX2VCo8TbQFSBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qv07CyGp1OXr202MI0xGtRF2hb36uVcKLP6EYdJF+hw=;
 b=qCD9Nakjv+0ifkg5nV4cDYWJHpQpKqsQUAuy31prxUT+GosXw2URC3qj0KYhAFIyFnH3qCwqkXVej+y5NtC1d9RLZkA+pWQNJXjNBS0znzwpYHTyQaKBbeaNTH14DEZ8/9TTv8RhywsJQUn2NPG9mvuvEBl4mSiVZelRyr9InJFK9sFhimFzSUMhjfJ8hWwKKdktLE6MFNBPiQKKcwy0n5gHazwxbXJ0aAOQBMZyhs7MeveA7aJneck8JcSvZOgGF9DvnSEZh5oiByG1vNccw+uvh0xu9pXGmBwM6IZHwxm8/HF80WkNb1tNVbDBOdNzdhNfCyfmd8m/rCbWLJUyRQ==
Received: from DM6PR11CA0031.namprd11.prod.outlook.com (2603:10b6:5:190::44)
 by LV2PR12MB5919.namprd12.prod.outlook.com (2603:10b6:408:173::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 05:44:01 +0000
Received: from DS1PEPF0000B076.namprd05.prod.outlook.com
 (2603:10b6:5:190:cafe::24) by DM6PR11CA0031.outlook.office365.com
 (2603:10b6:5:190::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Thu, 16 Mar 2023 05:44:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF0000B076.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 16 Mar 2023 05:44:00 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 15 Mar 2023
 22:43:52 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 15 Mar 2023 22:43:51 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Wed, 15 Mar 2023 22:43:50 -0700
Date:   Wed, 15 Mar 2023 22:43:49 -0700
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
Message-ID: <ZBKsldu+EKT5jd98@Asurada-Nvidia>
References: <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia>
 <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
 <BL1PR11MB52710B5DCB08214EF4542D098CBC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <ZBKp9BXwX3+txIEC@Asurada-Nvidia>
 <BN9PR11MB5276EDB7E88E9AE5F059C8948CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276EDB7E88E9AE5F059C8948CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B076:EE_|LV2PR12MB5919:EE_
X-MS-Office365-Filtering-Correlation-Id: 44e4beb2-1ba2-4d63-4b3c-08db25e17178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x1MOAPXvvIGM77L6RPZZOi+9SJeDxrNwUya6u4q+OT4zX4ZS+5VjZu3la5ZmRXO4y4hbdC4VVqL8VrtIdtOY9IWeNsnKzESXQc+DbYogcoTjHiqc2YoeXZEYdHjJhktQDPTXHWCr3bpXJcZmPJ3pZ8aiyIoJO+11aDK2kmmUHgA4JA8HMURJ9fKb64MgzMt8l+8Nmos0PPm43RTEL8BEIW7mevK9n7d02Y6ASr1rdqeSjYgFGuLCSpltdzbfZl93rZR+gGYqdc4t8/7PUU7JCeTepGETsHVesLoXdfJ5s+m7JTMJ88NtxDE4KOTXnP1RFz60ys7gpnKN0L2Qczq8vwF5uYD7WAI7WaVG+Dkbbk+jLLA3GVg+6guxqagnFyn/SpbCNmY9kvZfaGRl7n6NYQSvA5kGL1VpUyyBQ4KwherOhhwOLPVeo6/Gkr55lYPn1p0zWh8Bio7+VCy7fP5EQauSEX+q+6g7RPZjJ/MpVxtKPFgXl4yYgv9z4aeQLExsd+PlgJ2Ft5XxDRZg3sldC3XG/61miPHviQsr11qLZ1SKLLgMPn3a55MHGpVq5jY3BZ9mHFJHDbuZsyIfKTQESkL4rDMTn6GvtM8Sx3I/majVee0eg+RDIVBVy+tuVx2pnsQkBKkjfogTNwsGYdY7QKz3PrHCmohZ+punjHFKfePCM4y8eL7bY1WOG4k7B0f+c8QfBZz9vbMEh0cyDbv0upgOi2Bv4YLIj+6/yMZo8wYYWF/Um6TjQcFmT9aGXDU2HjXUGJzg1JJrSwzcnxpjUXDfGoAbny60UuTkv6rSphnySjGqG8HUwyoM+phapbeI
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(478600001)(40460700003)(70206006)(41300700001)(70586007)(8676002)(9686003)(6916009)(7416002)(83380400001)(5660300002)(186003)(966005)(8936002)(426003)(54906003)(336012)(55016003)(47076005)(4326008)(356005)(82310400005)(40480700001)(26005)(7636003)(82740400003)(36860700001)(2906002)(86362001)(33716001)(316002)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 05:44:00.3228
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e4beb2-1ba2-4d63-4b3c-08db25e17178
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B076.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5919
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 05:38:41AM +0000, Tian, Kevin wrote:
> External email: Use caution opening links or attachments
> 
> 
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Thursday, March 16, 2023 1:33 PM
> >
> > Hi Kevin,
> >
> > I've fixed the other two commits. Here is the one that I am
> > not sure about:
> >
> > On Thu, Mar 16, 2023 at 02:53:50AM +0000, Tian, Kevin wrote:
> >
> > > > [2] This adds iommufd_access_detach() in the cdev series:
> > > >     "iommufd/device: Add iommufd_access_detach() API"
> > > >
> > > >
> > https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a
> > > > 097e2c9d9e26af4
> > >
> > > also add a check if old_ioas exists it must equal to the new_ioas in attach.
> >
> > This is the commit adding detach(). And there's a check in it:
> >       if (WARN_ON(!access->ioas))
> >
> > Do you mean having an "if (access->ioas) return -EBUSY;" line
> > in the commit adding attach()?
> 
> if (access->ioas && access->ioas != new_ioas)
>         return -EBUSY;
> 
> yes this is for attach.

OK. For attach(), the access->ioas shouldn't be !NULL, I think.
At the point of adding attach(), the uAPI doesn't support the
replacement use case yet. And later we have a separate API for
that.

So I think it'd be just:
	if (access->ioas)
		return -EBUSY;

The reason why I didn't add it is actually because the caller
vfio_iommufd_emulated_attach_ioas() has a check of "attached"
already. Yet, it doesn't hurt to have one more in the API.

Thanks
Nic
