Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609BC543AA1
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 19:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiFHRih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 13:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbiFHRid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 13:38:33 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27901C111;
        Wed,  8 Jun 2022 10:38:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1BWX6K1R+uLPaOiwyQ9CAxmozpYz6cKBgk25ktapsJ3+BOzZQV1eHpJgXBPUIopwZ6yvJqbGC59twiaOhuel+6IZHLxecFxfamKSC0eG6SHCN2EBK1TY2TPdikY1yRZnOwxDb68TI47USZ1Q35yDt5Eqx3fF7K050TrE16f8EN2CcghyUPFdwfM6l7OYD2YtWtjvRvicLP20LwqmO7buLaoXc5V/zm8ME029Tk+nKkKx5KJwMpOzDt6DT88qtHRCoQQDTV0zi9ZCaDxFuDtx8CNRek7/4WntA7qo0l69JyTo6rQ89jH3iZW25cSQvnFhrNrDeOxX8+9qYmFN5RRhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G9m+KiG0SZtRd5/u4ThC8jMJtZr/Nc4RKd2A3eyR1tE=;
 b=cAp0T4zAhRB7IvLzE6o6Zr6y0MU8U5BvLEPDckUlqPRnyq6DDOPc+xRRIqsER0DwHc+p2WWXQJNjOcLfYa0gs4q5mdOk4oZ+E3lFcHO0sjOfJ1iR8uFWCfU5hZd69HbXWQ3Ncr24YYcrjnXIQqWLNM79dbixS4VnR03o5Ot0d4WeImC/y0qmPMz7w0NSlGUwCWc8gpIM2M8v4oL3D+wNE34XZLSB54nmEGcBQHrPrzJreO+b5BfZhyG4FnAxKIMAlVvX3ILQpbZEsGqO1Bqjo7UAPfHtC+k/swwcCMWq5Ms3SD+mF2XQY3r+hvMrOMJFB9C3CULk4qqt92Yt5/CFPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9m+KiG0SZtRd5/u4ThC8jMJtZr/Nc4RKd2A3eyR1tE=;
 b=QsvXkpEIO2Ehdu2QUvSm8aj+wyNi7aNFH8Iqjd/Twq0uxjJvXeyRa6Nrwx6/jbfF3JaWpEzdKgu76TpVp+x1gF/XLAMVDuAEee+gS9H0cTHPwhbFY7VfRxmmzutzxFrd4AUbK/xNuoS1cYZB/PjnRlOUSNHoxVndqfgxTT34LIr1hbD6SmukH7cWr2tpf5C2xhNZ04Iot/OLzxrTY/DoTOvZIif7Uz3O2MpKSIq5BKmqh+7k5o3mu2mtXzgZQaIOG7SiPbNzGP593HtpXp5m6epQsV8qkKV0HgbkxnCEBzHJIX4L55+hITRNBAaFzekVscy/RDGye+hKcPqfR0HD9Q==
Received: from DS7P222CA0022.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::25) by
 DM6PR12MB3817.namprd12.prod.outlook.com (2603:10b6:5:1c9::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Wed, 8 Jun 2022 17:38:29 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::2f) by DS7P222CA0022.outlook.office365.com
 (2603:10b6:8:2e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13 via Frontend
 Transport; Wed, 8 Jun 2022 17:38:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 8 Jun 2022 17:38:29 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 8 Jun
 2022 17:38:28 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 8 Jun 2022
 10:38:28 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 8 Jun 2022 10:38:25 -0700
Date:   Wed, 8 Jun 2022 10:38:24 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "agross@kernel.org" <agross@kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "wens@csie.org" <wens@csie.org>,
        "jernej.skrabec@gmail.com" <jernej.skrabec@gmail.com>,
        "samuel@sholland.org" <samuel@sholland.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Message-ID: <YqDekEqGV0SXWgmL@Asurada-Nvidia>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
 <20220606061927.26049-2-nicolinc@nvidia.com>
 <BN9PR11MB52763602BBEEEF580C3B360E8CA49@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52763602BBEEEF580C3B360E8CA49@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3a5ea2a-f976-46d7-b11e-08da4975b335
X-MS-TrafficTypeDiagnostic: DM6PR12MB3817:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3817CD67B892FAAFFB7B32A4ABA49@DM6PR12MB3817.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UTuUaEidQiWyq/qNlzH8v5WGUimEdNqfSxfGKylYYXiqjlw4B1Gjyy1s4p3W4k3yDa8t7UoT53/PaYdak4dbB2Lt+aa+PD4NtHNuEjdjXI/fS6NCZ75VYHg3UcaiNynCwiOvFtNK8lTZxcP3ov8NojJjozjShXHOInS5sEXloaohwRfDVRBr9IWDce3Yx1Mdbh6cuRRF0FUgijBp5eTZgCRljLobuT9Kh93Sb/rXKFNfQXmusshV0LGeShINpGmQBBD1f+jdCNXflp1fFbDY934siMXKL7aizsP4C/SGApoTZT6ej7lwciIcbPsFvXykmFCl6M4M0RgoE8B+fyEyjWfmeUb6T72cooBQOMg+0RtQkU4v21Jhm8Fhle+C+za7FloTTqLCUI0rE0bBtfso2jWI3sjyslJtS4IGmnWgn2wlgIq571iMTeG6axWO+rZVWvhjU1bS9zCiI0/m8Z1ANJP170fIGjFxACzUwt/Mb1tmfTehVX8S61T8kQXf70W+svGYx4LadvLlhkPt3pz/ah+zikqnML6s4QkrBeMzbrlZwrvf2q7O1ZkHiDzRD95QC6yDHMzch5f5SMRB+Goyowa3ZG2NmM8800IA7XLcpn66mchSWDcoSqYPa0YiA3v2SUJmPuhVtzjdMtiB0b24y5chII5/gmqnvibh6gGxRiuMl5ghH+WzK0ccgB6D6Y5bSmDqJqs/P5Mzl1ERR2Quew==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(82310400005)(83380400001)(426003)(186003)(336012)(7406005)(70206006)(36860700001)(5660300002)(8936002)(508600001)(40460700003)(47076005)(86362001)(2906002)(33716001)(26005)(356005)(9686003)(7416002)(316002)(81166007)(54906003)(4326008)(8676002)(6916009)(70586007)(55016003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 17:38:29.1738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a5ea2a-f976-46d7-b11e-08da4975b335
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3817
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On Wed, Jun 08, 2022 at 07:49:10AM +0000, Tian, Kevin wrote:
> External email: Use caution opening links or attachments
> 
> 
> > From: Nicolin Chen
> > Sent: Monday, June 6, 2022 2:19 PM
> >
> > Cases like VFIO wish to attach a device to an existing domain that was
> > not allocated specifically from the device. This raises a condition
> > where the IOMMU driver can fail the domain attach because the domain and
> > device are incompatible with each other.
> >
> > This is a soft failure that can be resolved by using a different domain.
> >
> > Provide a dedicated errno from the IOMMU driver during attach that the
> > reason attached failed is because of domain incompatability. EMEDIUMTYPE
> > is chosen because it is never used within the iommu subsystem today and
> > evokes a sense that the 'medium' aka the domain is incompatible.
> >
> > VFIO can use this to know attach is a soft failure and it should continue
> > searching. Otherwise the attach will be a hard failure and VFIO will
> > return the code to userspace.
> >
> > Update all drivers to return EMEDIUMTYPE in their failure paths that are
> > related to domain incompatability.
> 
> Seems not all drivers are converted, e.g.:

Thank you for going through all of them!

> mtk_iommu_v1_attach_device():
>         /* Only allow the domain created internally. */
>         mtk_mapping = data->mapping;
>         if (mtk_mapping->domain != domain)
>                 return 0;
> ** the current code sounds incorrect which should return an error

I agree.
 
> s390_iommu_attach_device():
>         /* Allow only devices with identical DMA range limits */
>         } else if (domain->geometry.aperture_start != zdev->start_dma ||
>                 domain->geometry.aperture_end != zdev->end_dma) {
>                 rc = -EINVAL;
>
> sprd_iommu_attach_device():
>         if (dom->sdev) {
>                 pr_err("There's already a device attached to this domain.\n");
>                 return -EINVAL;
>         }
> 
> 
> gart_iommu_attach_dev():
>         if (gart->active_domain && gart->active_domain != domain) {
>                 ret = -EBUSY;

Will add these.

> arm_smmu_attach_dev():
>         if (!fwspec || fwspec->ops != &arm_smmu_ops) {
>                 dev_err(dev, "cannot attach to SMMU, is it on the same bus?\n");
>                 return -ENXIO;
>         }
> **probably this check can be covered by next patch which moves bus ops
> check into iommu core?

I was thinking that it could be covered. Yet, we are about to drop
that ops check, as Robin pointed out that we don't need that ops
sanity for we don't have mixed-driver systems yet. So perhaps this
would be a different ops check and should return -EMEDIUMTYPE too,
I think.

Thanks
Nic
