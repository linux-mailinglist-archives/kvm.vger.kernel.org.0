Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1421D5819C6
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 20:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239207AbiGZScz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 14:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239280AbiGZScx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 14:32:53 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3611FCD1;
        Tue, 26 Jul 2022 11:32:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etaGq+J0Wt7zpxgo0mJhOrbg6WZ0e6KCP+441YhU6Qx9jY4q8jIoP9HxUBKchs7yl1i48vAHezFJXOZ/6Lh/49LO+iune+zxyiYnpTX4K3Z3XP+immwHGa+HhPzaAu8S8likVdH1tl8xDoBSOK3O7NIGN2q6z2gJrMntVqAFoVpOBml460h4U99STQk4f8+RHy8Dq7bK17ee+cOK/QFSgmgfjIF3c49rKdiTiOqpVCI+sFCh37982oSir4jQckx6rFycneXLeMY3ixjOHGNEApckkCR1T4s0khK4ulRJzd5ufcQ8Kdpjflbz2PQG18taH2awR4TOVZ+RFKIeqeVljA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7KmWCJJiLmmCXvHEW/edwGywv0Y5xwCzERUc9HlzQo=;
 b=h1QPYA+Jym3gWMU3JcuVYHrxfJOG+8jWqZ5f4bDopZx82Xt6svvi6iHyAeA6tN6VVHJRqOiW00l6b2sojwPAUE4o1bqFKhHt7TrBDbi9iZlRxjDXTee7qxet30FDe0qM7Z4zM+qrFKI9zXnXO1KHVCKhSqq2BTCd2eN7kY8p9geMzu2mi0uPN3ldwJ5fdp4dyeoK8XFquT4ukKdBaJjczdvRJtBem2/yTdqOmwEpNJB21r5WLlT68B3irnxmxZ01IIAAYWGFw/Oc4dBnfOAz5DcAJ5l7eZm1sK/v/qPJdy8xT9xIzZzan3d6XP/uVslTuOqKJBzFbaCoeleDy9aFIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7KmWCJJiLmmCXvHEW/edwGywv0Y5xwCzERUc9HlzQo=;
 b=R23PdKIehSe/v8/Egr4s14t9166kDSkME/KRemw1pKDZBLTVbaidBpffCU8IvuIZkUu5ZmMhmWcNluuxQA6MbFUkZpCybUFlZkzeTsTtWb1OboXXxLfSkUjkIscTl+xoyCMAmIffGzUPPtu2AX5tRk3kvREU8bo/JJYEp7EsDaAEdQZHEOMK/PVOUiFRb1EJgJNxxTIv8tEdJdCho8fw8GEgTFrVqaLVFZrqnCvpnJ1OQsxaKN/AgENt49oE/+BZjEBGsSjansfG4VjK1lOs8SqzDxuaOg0O0xmYcoBUspFGVZulBOv1lV6Uz4v1ppV0Ane2nEGPtDRuWZtl05UfVg==
Received: from BN9PR03CA0783.namprd03.prod.outlook.com (2603:10b6:408:13f::8)
 by PH7PR12MB6717.namprd12.prod.outlook.com (2603:10b6:510:1b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 18:32:49 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::90) by BN9PR03CA0783.outlook.office365.com
 (2603:10b6:408:13f::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Tue, 26 Jul 2022 18:32:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Tue, 26 Jul 2022 18:32:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Jul
 2022 18:32:48 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 26 Jul
 2022 11:32:47 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 26 Jul 2022 11:32:45 -0700
Date:   Tue, 26 Jul 2022 11:32:43 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, Alex Williamson <alex.williamson@redhat.com>
CC:     <will@kernel.org>, <marcan@marcan.st>, <sven@svenpeter.dev>,
        <robin.murphy@arm.com>, <robdclark@gmail.com>,
        <baolu.lu@linux.intel.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <suravee.suthikulpanit@amd.com>,
        <alyssa@rosenzweig.io>, <dwmw2@infradead.org>,
        <mjrosato@linux.ibm.com>, <gerald.schaefer@linux.ibm.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <chenxiang66@hisilicon.com>, <john.garry@huawei.com>,
        <yangyingliang@huawei.com>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] cover-letter: Simplify vfio_iommu_type1
 attach/detach routine
Message-ID: <YuAzS1LatwGEvk7S@Asurada-Nvidia>
References: <20220701214455.14992-1-nicolinc@nvidia.com>
 <20220706114217.105f4f61.alex.williamson@redhat.com>
 <YsXMMCX5LY/3IOtf@Asurada-Nvidia>
 <20220706120325.4741ff34.alex.williamson@redhat.com>
 <Ys9b7GSImp/sHair@Asurada-Nvidia>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Ys9b7GSImp/sHair@Asurada-Nvidia>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ef99da6-838d-494f-5c78-08da6f353e2b
X-MS-TrafficTypeDiagnostic: PH7PR12MB6717:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JKTq9ja6++9To/TifTnBWKAR8eQJHhLvv7kCXdeCIX9uRppKFnhrrlM9RVqnUrWiAggW822U6t5OKC6diMxvG5upIKa16PSg1NcS/N2ipsXeFxr0pZmh5PNP/5LV6mEo0Em9vx9VD0uG09voESZNunmG595b/fM+IY7vG5i8NngW5BRQJr5LHzdv9OrAxV9nm5bH/R//APCKTs1zakP2lYFjIh8CToTVHB0mge4t2IqNhMTMItqgNtPIvZzS44bzLWY3rnyNW9l9Rzj70VepiSQZJP93U/h64M4rl47SozVH2IEbi/jaeGnTiJYE1B1Ex/DRs3LAnDP8CbMIM0DN8TFk9ir3C22hz1ACftiurKKcPJFer4YIL1MILUQEqRqbQ6HxuXZyH7AT8OztE+w1mPf0zsIPtDiQj6m8uhIZCFGMVeMoy+fPON67IJpoxx4jx3wfoooR4f6vgNTZrkKEj3XGi2/0qestSqxHrIYrizGpoDarxu3bQ5ddiJlVF+dq7PF+Txo/Oy8GGpRw9gyjixOX6jacIViPD5MvsZQDqjahQ4nFAY2IPFVrIZHSRXFySgbMYAGqWGk/0HdVHOJ+XgnzP79mqmUn5bny8wpCvHIQxAdEwivN7RioxS1WTsuj/lF01PJc93akbW5ehO25wysr6YBL+wQFuM39UX0iqYA8WiHjY+MEAmh9Y9Ma/atuGrMGauP146wO6JawMj08vc/CmOXjhmeKSKMBbe7GpxnAPuoOUbtfrfW2+DwHZg/8jmHRwriIuAQVp/EG9DKxqCBVt0Vh8+ZwgB1SikdqdIDY+NTVuJNdRA0wR1FqSWcriE9T9e71XZJ4HVQGEfaN+KTeRYYuzIZpsdNRa5B4pPg6MklFQNjFxa855sjMLwbgT4O18Q2MsrV8hkJ8Cc+noKu42/fmUxnkR7own9gzRLM=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(39860400002)(136003)(46966006)(36840700001)(40470700004)(8676002)(186003)(966005)(81166007)(41300700001)(426003)(336012)(47076005)(9686003)(83380400001)(478600001)(40460700003)(110136005)(54906003)(26005)(86362001)(5660300002)(36860700001)(40480700001)(316002)(7416002)(8936002)(55016003)(7406005)(70586007)(356005)(70206006)(82740400003)(33716001)(2906002)(82310400005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 18:32:49.0825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef99da6-838d-494f-5c78-08da6f353e2b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6717
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 13, 2022 at 04:57:36PM -0700, Nicolin Chen wrote:

> > > > > This is on github:
> > > > > https://github.com/nicolinc/iommufd/commits/vfio_iommu_attach
> > > >
> > > > How do you foresee this going in, I'm imagining Joerg would merge the
> > > > first patch via the IOMMU tree and provide a topic branch that I'd
> > > > merge into the vfio tree along with the remaining patches.  Sound
> > > > right?  Thanks,
> > >
> > > We don't have any build dependency between the IOMMU change and
> > > VFIO changes, yet, without the IOMMU one, any iommu_attach_group()
> > > failure now would be a hard failure without a chance falling back
> > > to a new_domain, which is slightly different from the current flow.
> > >
> > > For a potential existing use case that relies on reusing existing
> > > domain, I think it'd be safer to have Joerg acking the first change
> > > so you merge them all? Thank!
> > 
> > Works for me, I'll look for buy-in + ack from Joerg.  Thanks,
> > 
> > Alex
> 
> Joerg, would it be possible for you to ack at the IOMMU patch?

Joerg, sorry for pinning again. Would it be possible for you
to give an ack at the IOMMU patch so that this series might
catch the last train of this cycle? Thanks!
