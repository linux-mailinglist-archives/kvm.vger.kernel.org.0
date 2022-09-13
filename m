Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC7B5B69A5
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 10:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiIMIgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 04:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbiIMIgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 04:36:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9D841984;
        Tue, 13 Sep 2022 01:36:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6fcNLQCTXAfO2c/6ba0PdDWAZAGqBPyGNFDudQ9V2sEjU3ip9iasv1fQ2BBG7uXS0LufHHLH7z+z5IuvpWeOZLbPw3RheqqJ6my3HHxcYfwHznPgu/C8hPqJByh/jFV8YPPx3xFhhEJTN08eGObkSo1Uo9eePVejlZ3mHHU9Vb2Vs8CKFnWAwRi+YRoNJuKqWBNWGG+ezn+nVsvzx+wTDp/FeAP/RbYB9JU7Ay9VJhVEr1N8+guOe96axkpXDa4MklcL9enX0pmwYqPrJ3/RKk2IJFybcgD+rz5IRk4peXkMkRgfoG5N9UiiFyKFnmGD4B4OXf8WcX0PtwndszDvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFx5cipRighv2yQgnm23/UfY2GbsW+9HHM+VYfD3Trg=;
 b=mUt1LO27si3h5rNU0K+EJNL5SENjSAIpnHlIJ54QF+Kj8shR6Rxr4aQnu3EFnJIB/EgrGrtbIRAJPO9XK4BefoeuPn6g78EFnKZsHOj0GQnqaC7DQmnf1EoF+dSXn846SuqBPhKbakaf5JI1Ph2kMYPyDu04SfKUVIh86Evw4o5SPhrqilwBR+YsVmPJhmZfjWw+WqDcVZoSilQ0Uo5MQ+8yX3zf6W08QaA9vHTqEGW0VolQlC5Uqkqqgb9ERBsm81A1u650dMTlY/krG6bbBMppexnECZrDdKe4GZL6M7brn8slYE5piiRFgrZ3BN02HA9hQKB32KPzv7szTw53GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=marcan.st smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFx5cipRighv2yQgnm23/UfY2GbsW+9HHM+VYfD3Trg=;
 b=PdmLWu8JpW19M1i0/Z4gBrDjmtUIPQ9GZYBOUPFKon/PbXjExRpSQcWyGLJd84nd4FJu9CYv1UY035MkiCiQ/fnFs20YLioI3D3ExOGF5i9hp/Xkp38IQgXVmwemUFIioK+P2vyKg+Ppy9KoRsPROcYZJaEbeG0v+x93EVY9qvAT7qKmiCkDQc7CUKJXSWW+pYDoX/V/N4Ik3y6sdrS8H0wbAr5c1eVXGt88n4rIzHWfz3nUSYgozDkqro6plXJRSEOQvgP/s9K1a4MwR+4TlVBBTfJ2dpLhXApAmdaT3nBZeL5cbpHEm8NFdGyzEmm37QfcALZd+Kzwux4TXFzGDw==
Received: from BN1PR13CA0020.namprd13.prod.outlook.com (2603:10b6:408:e2::25)
 by BN9PR12MB5164.namprd12.prod.outlook.com (2603:10b6:408:11d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Tue, 13 Sep
 2022 08:36:07 +0000
Received: from BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::46) by BN1PR13CA0020.outlook.office365.com
 (2603:10b6:408:e2::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.12 via Frontend
 Transport; Tue, 13 Sep 2022 08:36:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT087.mail.protection.outlook.com (10.13.177.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Tue, 13 Sep 2022 08:36:06 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 13 Sep
 2022 08:36:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 13 Sep
 2022 01:36:04 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Tue, 13 Sep 2022 01:36:02 -0700
Date:   Tue, 13 Sep 2022 01:36:01 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jon@solid-run.com" <jon@solid-run.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <YyBA8ZQ2jBK6euYM@Asurada-Nvidia>
References: <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
 <9f91f187-2767-13f9-68a2-a5458b888f00@arm.com>
 <YxjOPo5FFqu2vE/g@nvidia.com>
 <0b466705-3a17-1bbc-7ef2-5adadc22d1ae@arm.com>
 <Yxk6sR4JiAAn3Jf5@nvidia.com>
 <BN9PR11MB52763FAD3E7545CC26C0DE908C409@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YxnbRq5vaP/OL0ra@nvidia.com>
 <Yx0fVJpaojM5RNR4@Asurada-Nvidia>
 <BN9PR11MB52761E126D797ED865DC3E8B8C479@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52761E126D797ED865DC3E8B8C479@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT087:EE_|BN9PR12MB5164:EE_
X-MS-Office365-Filtering-Correlation-Id: e18d6e0f-4de6-4dc5-092f-08da9563009b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LIh40H8pbOhVq1+wmMdNfEkrGiJ8gFVTZcbj3d4K6iDZ3fcOp4jOYjaP2WQiGE0MCW/VHkvNao3wg5Dv35BtK0RKWotMIY6XILyTFQ15W6edyXQJkTrTJmzX8zjvWqzhgAzzH3zd5vzg2eQWNzWvYFw1TMpzjofC9bA+UzvM/CN2pK+eZjZOmB8SHoTRuw8Hyw3PnQckizaVfUVzx55HsHPuwHw3lbbIKZWdzh8lgEO46AnLoWWAgTcNP/AzLDackJY8Eh6oIMDc1c01bJCoDom6DqBkNy3FDxN/4av2aml9RMSK09N6dLnZvzeTeYbc2C+ViJus3YAR66qQyfQN1R8YNs6jHmy0sDLEpPibPnuBIWqHpYr9X5UyexVcDDWL5S8JNLF891OUIrOCBwak77p08dTWwokeASq1j6sfSXqkfn/ALqDcJ4WRLC1pFfbV4CLzCsiw1F6e1UCujofSawntD7c4l1Xw7XFlGtvNhxr/4ixOL++WnNKV1k3UHnLuBUVMaioNYB3ybBadFub+iLiwhTJyVCJMo6giy5ZUtUY+ZjFemaouPt51RG7midb7597OApMtmckk8TFquKsnEdZvihh6gxCNKCsCn2N0/3R2//LGnF8lSCVOupu1hUOQk92goZqr7JjkHsncssHC3WHVddjOQ9HxEN1PYHPO9+5ahU+SGQCqWKNNKGh2L+ko4mUIcxMtAHCK2UgPcgCdjhfA8QPUucTQr3PvvphmjWpkTyAs93R12sa2ZzhQPxaeM3dONovnT83bau+OqDNxkyZbXEOh0CS/B4I4UfuP8RaQvx4u+Zb9H6vTNjSvcZ09eD1Ju5Qa/Mdc/6qXMfrAcXQFAq64ATRXxP2pIEUa4GBBQ1KyQsX/fjEhPJivXLiV
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199015)(36840700001)(40470700004)(46966006)(966005)(316002)(33716001)(86362001)(83380400001)(41300700001)(47076005)(82740400003)(82310400005)(336012)(426003)(7406005)(478600001)(5660300002)(81166007)(2906002)(186003)(356005)(8936002)(6916009)(70206006)(7416002)(70586007)(8676002)(4744005)(36860700001)(40460700003)(4326008)(55016003)(9686003)(26005)(40480700001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 08:36:06.8932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e18d6e0f-4de6-4dc5-092f-08da9563009b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5164
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On Tue, Sep 13, 2022 at 02:24:27AM +0000, Tian, Kevin wrote:
> > I wonder if it would be safe to just treat a pm_runtime_get_sync()
> > failure as -ENODEV, since a PM resume() mostly occurs to the IOMMU
> > that an IOMMU client/master device is behind, while an iommu_domain
> > rarely intervenes.
> 
> Yes, this is a condition preventing the device from being attached by
> a domain hence converting -EINVAL to -ENODEV probably makes sense.
> But as replied in another we might want to keep other errno's as is.

Thanks for the reply and helps. I've sent a new IOMMU series:
https://lore.kernel.org/linux-iommu/20220913082448.31120-1-nicolinc@nvidia.com/

Sorry I forgot to put you in CC, for I plainly copied the send
list from the get_maintainer.pl script :(

Hope you can still find these emails.
