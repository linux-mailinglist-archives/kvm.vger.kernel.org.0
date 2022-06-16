Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9F454ED47
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 00:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378926AbiFPW0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 18:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbiFPW0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 18:26:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEB860B84;
        Thu, 16 Jun 2022 15:26:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8aRmY1JdGSMx90BwU2AKlFM7+ASR5mj0ByVbRDkya7cAwbwKyR7PXZfeipgNJ1FQPe9cjfNYZR0uiTPT3XajRF6MuKNvgra7i/OJF8muNRH4rx4k6Vk/DmBvx3xunYFjj/ojJe4b2SE0/XjgmVNRE+yhkdG50NeHs78/WCkekkMvXU4/V0ph9w69VgbiLBANmOkfPiwIZr63c8JbkhXTAs2rqv9iAciqkNAPmjXGx8j8K9T19x4Cy5TTvzfgFfD2xjjC2963SUKP33qwReYfK/1o/3dP/OfQO+E96Ml8jKBHXGg3bp9K0rGg8zZ9t83Owfd3MsNBTem6MpN8ELF1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0WIyuudnNGesuuol1U7SbfYdjlcpyLSRI1CvrT+2O/w=;
 b=EPiYdHEaL36pB2+vQbr4bxe/7lhixB2eM6ImiIe37oknwQCuKp/BLo2A9LvXEoV7HjB8m7r5gWQWceAwk0nUmDto6MFDTWkHu/y/8AKMv0TwQHASNMhNEiemRHW8dRBUf7EYOQ7hpozJJo1n3cHyqK0eDKJyaSHpbgoMzuwu3O+MhumFEk9pY/g19roKDURvjaO4GpamZhGyo7Z1C87pKdjDPnhaaTGMycMISYM22CUIdBtRs+vy7HDMm1Wd2SwV+UJTOnIgWIaRR4WN/DtwNW+YHJ0lbNUMadiW4rBHN/adjfWWP0RNkFR/w69+kkHjjY1FaGUYWLcXLh0sEuJUXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WIyuudnNGesuuol1U7SbfYdjlcpyLSRI1CvrT+2O/w=;
 b=Z21zYdg09/+imRvPTtWqbGp4MLnGPdyf8Uvjm5rUNOyGknBf0iY5LWZ8c0ZKJSEC+aVESf8fizOCjylI9jTSrsurO9wgHmZX220Y+q8aHlp70mMXJGRvi6gr1GIgqllB4i0MUVZd+pTKCZKBrgtW30FU4GSwlIpIveaoxQT1A7HWArvSKcR96uSKVZH6MkxBN57eQ1rncIYMpdzNNy79LzZewWft6L4gLGSzGIiLEac8xdbpZBy0AtG7bswHHwfWE86JPwxIh2p73anRPdEB1wGYiWIqVPK6AdGyfYXE1vkc+5GGOWRMP1YVbTBZWMuZahhGEUxtOX3CDQY+bgwTxQ==
Received: from DM6PR07CA0067.namprd07.prod.outlook.com (2603:10b6:5:74::44) by
 BN8PR12MB3633.namprd12.prod.outlook.com (2603:10b6:408:49::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.13; Thu, 16 Jun 2022 22:26:14 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::10) by DM6PR07CA0067.outlook.office365.com
 (2603:10b6:5:74::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16 via Frontend
 Transport; Thu, 16 Jun 2022 22:26:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Thu, 16 Jun 2022 22:26:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 16 Jun 2022 22:26:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 16 Jun 2022 15:26:12 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 16 Jun 2022 15:26:11 -0700
Date:   Thu, 16 Jun 2022 15:26:09 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "saiprakash.ranjan@codeaurora.org" <saiprakash.ranjan@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "isaacm@codeaurora.org" <isaacm@codeaurora.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH v2 4/5] vfio/iommu_type1: Clean up update_dirty_scope in
 detach_group()
Message-ID: <YquuAR4h7dMCg4eq@Asurada-Nvidia>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-5-nicolinc@nvidia.com>
 <BL1PR11MB5271A40D57BEBBA0BAA4C0BB8CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BL1PR11MB5271A40D57BEBBA0BAA4C0BB8CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95aff080-e26e-4570-bf5e-08da4fe738f0
X-MS-TrafficTypeDiagnostic: BN8PR12MB3633:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB36337CA2177B4B98A2F486A2ABAC9@BN8PR12MB3633.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OmHpvl2CcvGdmIpLdmz9XMfkxgpNIMcHSFYWedc8MTTa6WnNShqzjoGP4HV457CgWvuGCxbToDLVoiLk0anLm+6lNSBC/AIy63GKexDlBt+IGRNjG5XpRTNTXMBUFUwg2ey33c9S01A0JinizzKap1AmcsyvsbNDEAGXti7GaEqEbPpLUxFqHBhZwJEz0je919Pqg5LN155IPjkOQNbXMAYMlsrblU0dApc5ULQSaUcdkKuZqv0X4fmWvPh6gNF0A52agRLvh6bfCKgMRtsXSAwZkeSHUVL5C0oq1oySOBw7TURG+8sxD/A5wVQOgaSSe57p54uULnsJTKL3OnTny88AeVE8tKd+qHMsvt2/kO9fuEVHlWlg2i1harTrhRqMVaIzsG1CAkyKE1o7HG7S7N/AWaRqzoHklh+nGQQujdiZrc9LG0bWKZFfwxeYpfVQrZDMK1BS+g5Aw9PCGstVQASM8oIbtaRqn02x9q3ILusIlMqC1uRaq7yg1dMuqVqblukwwgL6AnH+rZP3A6Py2NJCkZcLsYA89zqnV9Lp8z1DxT2E4LPS1fcmtwIASozerVw7s4kwlqbmAwVDfMl2NT3OcN88h63c3AAPd9UVJMMqss6U72oJ4eSaqcKGSUBZZfso5mlq3tc94ed/H58qN5p2mDYTZEiKQTdyAxk4glD9QSxeTVjokpiImQXqYBX2dhNXIDJDTpeHHYQa2FktN5AIeDx7qj3ORiBPfOk9cB4=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(36840700001)(40470700004)(26005)(8936002)(9686003)(498600001)(7406005)(7416002)(356005)(558084003)(70206006)(2906002)(5660300002)(81166007)(55016003)(36860700001)(83380400001)(47076005)(426003)(336012)(186003)(40460700003)(82310400005)(86362001)(33716001)(4326008)(8676002)(6916009)(54906003)(316002)(70586007)(14143004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:26:13.6281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95aff080-e26e-4570-bf5e-08da4fe738f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3633
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 06:45:09AM +0000, Tian, Kevin wrote:

> > +out_unlock:
> >       mutex_unlock(&iommu->lock);
> >  }
> >
> 
> I'd just replace the goto with a direct unlock and then return there.
> the readability is slightly better.

OK. Will do that.
