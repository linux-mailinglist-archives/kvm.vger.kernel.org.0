Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F894553F27
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 01:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354268AbiFUXra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 19:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiFUXr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 19:47:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFBA31500;
        Tue, 21 Jun 2022 16:47:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCi8pM01KDslTxSC1v0wpTaefyN5VX3ILYNNAlmIfSFbtAeX+iua2UixPzeaAtOtYzKAeEJwZpCRx0Fm1Giz5rSDggLQCfY/Ez2r23VeQtTLUEmxIvqFg7rFcHkhKoXDPcX4uwI7ShLxeMSUrz+j8HHDih06F1ToIgP8kze58wFBL3DihmKhEjK56u0gKQ8QzGS3LUe5sXqRxIpe7SjrPLAJBoNH7BaNRP1u+O6w1MAl7ZKQ4KmyRH6FwY2g4VQK4ZGj0V+/eYhBJjqToRycLrirJFYSU8QYx7rGSz1BwZohexSzC7BdBA4WAFRuY1ImV0eUvbJ3265xvvtWpcTrOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aqJHOQmxrxlatNO2xMwYxJVq0MrIa0oXWWVFnxwgEkU=;
 b=kyyEjv8pKRQyS4xhF2jWhFMnPkSN6fQfYmU8rHgRfrAUuAknwC+J9Ct0vlC8Gawbgqr34rAiwTL8n8wCUOdZotajLpMV/HukCNA3aq+UPDoXtVDWxTdvtuZjfNlOlUbj6huTi/9+E3RoJ9Mh076agEQSy8OTdVJA80Imt6SFSLCD9fNoDqBX1gG8vDGcuvTH3iemqXoRaqc53m0j7vDkGbpDCe2GamO+1Cpsip7rBzdJyE1XWRAf4tKYOBfa+qoLIKpHFfMnsnCGAY9xG2bicJarlCSrG4lsclS3nST3Ram8oczITdlKcQzuY8/LhLZKLH9UepGxfRa1QQPssg05PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqJHOQmxrxlatNO2xMwYxJVq0MrIa0oXWWVFnxwgEkU=;
 b=IN9npoapkbB8oXv441aT7uIWUmJRTWO3QfDBLJ3NXVgbNQRgzEawfifkbG/+QCyCIMfbLPRYA/bB2baK8ZQ0SpQDhdc/2QUTxsTMsbVvoJNKEhiw5yW+VkWniwDd9xwWPgxyL5gDmjW1qA5AWop/EiikrCtwVaJmFyhP897Ae5FYRwk0vLTe9sCoCetmO9RRMfSur6oO1htHE8sTl4igEuJ0svwp5K02vk7hjj1tQLaC7RrSbxkjJZC0/mfhpRy20zcjiIdkPQ6RqYzcp7b5ceBhd0ncWuUr7j1KSOLkqhiTVjriw9pZmqMhiZL0YCaMbn/ooiYR0ZjXlM7NHJMBEg==
Received: from DS7PR03CA0295.namprd03.prod.outlook.com (2603:10b6:5:3ad::30)
 by BYAPR12MB3479.namprd12.prod.outlook.com (2603:10b6:a03:dc::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.21; Tue, 21 Jun
 2022 23:47:25 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::13) by DS7PR03CA0295.outlook.office365.com
 (2603:10b6:5:3ad::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20 via Frontend
 Transport; Tue, 21 Jun 2022 23:47:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Tue, 21 Jun 2022 23:47:24 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 21 Jun
 2022 23:47:24 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 21 Jun
 2022 16:47:23 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 21 Jun 2022 16:47:18 -0700
Date:   Tue, 21 Jun 2022 16:47:16 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <matthias.bgg@gmail.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <suravee.suthikulpanit@amd.com>,
        <alyssa@rosenzweig.io>, <dwmw2@infradead.org>,
        <yong.wu@mediatek.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <christophe.jaillet@wanadoo.fr>, <john.garry@huawei.com>,
        <chenxiang66@hisilicon.com>, <saiprakash.ranjan@codeaurora.org>,
        <isaacm@codeaurora.org>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] vfio/iommu_type1: Prefer to reuse domains vs
 match enforced cache coherency
Message-ID: <YrJYhIiivpiJ1t4f@Asurada-Nvidia>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-3-nicolinc@nvidia.com>
 <20220621164602.4079bf43.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220621164602.4079bf43.alex.williamson@redhat.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83bbd326-a75f-47d9-b6a0-08da53e06440
X-MS-TrafficTypeDiagnostic: BYAPR12MB3479:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3479D56EB2C3CE3D32569B32ABB39@BYAPR12MB3479.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8NwIxgGiwtZsX9DG5RYiN32gAOfze5/tHQkp+2/EouFLvJOnuWFOd471Cz5Jl5gYgAUOXfqy5Wr+5NtKJVEZ3Qg+R0CJeF6/IcgIDERf3FtOBJWDpvn9hiQcVDgi2B7o3V8XlxyOC10oADVBAkVSS74F4DgmBYUJMd9ZIY43esDyXNhzvjM6V09g5UD+6hca2/FXncFjBzrplsG7I44g51AEMOepe6dTXA//7yT7sIF6SMzkoQcDqaav8L/RndMvpXmKm4GU+AIFjhCTry0vSif6jeOoeZeB2wIuSfqAEv3VW1BQzOxN7i08+GZKCc1WjnVnnACf45HViXnBFNxg4syidc2AaVEvBtgnkoGl9+BHSx1ckgrGQOCBF6+zXvFAW/5m7JE2gkBKPK/QBoeQ14bBIMMzaz7eSqW1CHUKFJoqFzljM6XYJuZtP6Fj5xxFfTlF94tQ0UcUuUpbhVL5cL34n/9lsR0bs5CyhLZnyo2DbKH3dpwdlgYIKbiYEkhUwExPOrhJMU1cy8uY6FvdXHBuH23fGLzk3Me+8aqbERqrg2yzKpjWfJzpVMFutxwNK8hMTf765uI03HoY3cbDw4s4uJtkQdvIfyLewn84BzCBpbqEw9kJ4o+qQPTS+7PK6MsD+/HGyGP8+EwwwKlH6FzkcX7edz/VyZrbCBOs/KNc+0CV/KhlbnMdjF8UpYRqkxkSlBn3f1+ls7XECv+7fI7ahSW39MDxPyuAmH2YyCZndmi6C684ASePTby+pJkT
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(376002)(36840700001)(40470700004)(46966006)(70586007)(54906003)(2906002)(7406005)(40460700003)(7416002)(6916009)(8676002)(186003)(81166007)(70206006)(36860700001)(33716001)(4326008)(47076005)(55016003)(8936002)(426003)(82740400003)(9686003)(40480700001)(356005)(26005)(336012)(478600001)(82310400005)(41300700001)(86362001)(316002)(83380400001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 23:47:24.4682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83bbd326-a75f-47d9-b6a0-08da53e06440
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3479
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022 at 04:46:02PM -0600, Alex Williamson wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Wed, 15 Jun 2022 17:03:01 -0700
> Nicolin Chen <nicolinc@nvidia.com> wrote:
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> >
> > The KVM mechanism for controlling wbinvd is based on OR of the coherency
> > property of all devices attached to a guest, no matter those devices are
> > attached to a single domain or multiple domains.
> >
> > So, there is no value in trying to push a device that could do enforced
> > cache coherency to a dedicated domain vs re-using an existing domain
> > which is non-coherent since KVM won't be able to take advantage of it.
> > This just wastes domain memory.
> >
> > Simplify this code and eliminate the test. This removes the only logic
> > that needed to have a dummy domain attached prior to searching for a
> > matching domain and simplifies the next patches.
> >
> > It's unclear whether we want to further optimize the Intel driver to
> > update the domain coherency after a device is detached from it, at
> > least not before KVM can be verified to handle such dynamics in related
> > emulation paths (wbinvd, vcpu load, write_cr0, ept, etc.). In reality
> > we don't see an usage requiring such optimization as the only device
> > which imposes such non-coherency is Intel GPU which even doesn't
> > support hotplug/hot remove.
> 
> The 2nd paragraph above is quite misleading in this respect.  I think
> it would be more accurate to explain that the benefit to using separate
> domains was that devices attached to domains supporting enforced cache
> coherency always mapped with the attributes necessary to provide that
> feature, therefore if a non-enforced domain was dropped, the associated
> group removal would re-trigger an evaluation by KVM.  We can then go on
> to discuss that in practice the only known cases of such mixed domains
> included an Intel IGD device behind an IOMMU lacking snoop control,
> where such devices do not support hotplug, therefore this scenario lacks
> testing and is not considered sufficiently relevant to support.  Thanks,

Thanks for the input. I integrated that into the commit log:

    vfio/iommu_type1: Prefer to reuse domains vs match enforced cache coherency

    The KVM mechanism for controlling wbinvd is based on OR of the coherency
    property of all devices attached to a guest, no matter whether those
    devices are attached to a single domain or multiple domains.

    On the other hand, the benefit to using separate domains was that those
    devices attached to domains supporting enforced cache coherency always
    mapped with the attributes necessary to provide that feature, therefore
    if a non-enforced domain was dropped, the associated group removal would
    re-trigger an evaluation by KVM.

    In practice however, the only known cases of such mixed domains included
    an Intel IGD device behind an IOMMU lacking snoop control, where such
    devices do not support hotplug, therefore this scenario lacks testing and
    is not considered sufficiently relevant to support.

    After all, KVM won't take advantage of trying to push a device that could
    do enforced cache coherency to a dedicated domain vs re-using an existing
    domain, which is non-coherent.

    Simplify this code and eliminate the test. This removes the only logic
    that needed to have a dummy domain attached prior to searching for a
    matching domain and simplifies the next patches.

    It's unclear whether we want to further optimize the Intel driver to
    update the domain coherency after a device is detached from it, at
    least not before KVM can be verified to handle such dynamics in related
    emulation paths (wbinvd, vcpu load, write_cr0, ept, etc.). In reality
    we don't see an usage requiring such optimization as the only device
    which imposes such non-coherency is Intel GPU which even doesn't
    support hotplug/hot remove.
