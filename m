Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C6F6FD9C1
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbjEJIlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbjEJIli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:41:38 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77F9E64;
        Wed, 10 May 2023 01:41:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaPxfSHvDosPq/z303i+/PJsnD55+slkuyEo8iWmhWv3jWEqjAuH+/Ixv/79TB+DkMr+rZWHw1BL2aFWza+hB0sHzltDLQVvcdyuFuDSeAYTApi8NcPJNYR+lSISOTU14GPDNiJEhYBZVltTC/4eDKODv0CCSZ2cV1kkq/bsd72EoLW7vU2APtyyaQ73plhUpWqjbttAZws+q/utaz07GZUVLOyjX6KpH47PfNYOdtHWKz4+VH5MidhuH66yyYuKhpDVrJ3WyVf2BDDmpTYN389Acro/yvzoYhrKjhYCkhf4gFrZ4sedv5JYhSXgvCDh9VbmAAPGXoFoPAYja49AbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbUREkIMAMcNk+Mixvnc1NzHRNlbQPHjV6DyuyAEdt0=;
 b=XlwXHVKIWGR82JTlZ+FJ+skNmFOt/FIWxTssYLzabmmgVu8K/6J1+8+tkHjXwMiHQ6n6ZLiJbfltdwmVYoylj1UhdUbTTp0ED1MSIn/hJ+lOKV2fzqTlOzR7wBlIe2wGoy9tRe3z3a+Luk4bdpJlFL7bbD1gditLo2OV91mxOdo0itZi1aOUsAmeasxQSNwia5jpU5xYvsR7941CYDZoS7pCMZqbjluOEtDk4PimVy7+ue93+FDd+nq9qJBD9rcU9EbXioty1bdWbKlZoThFIn13Hgt24ujf2MectQoBk9SUtceALn+F8wQC8Er2eFGvYFgQ1VLpMbIEpn7mLl++aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbUREkIMAMcNk+Mixvnc1NzHRNlbQPHjV6DyuyAEdt0=;
 b=WTn9OEdobOgPX6Ph9TmA2YtPA2BtWv2f2/D/OOMIwsz4u5l/EhKDj/ElECS8nTj3LYDK0KHF0qCAaOn3XQub/eQ2xI6oyuL0+B2Bt3+Tp7dBQbLNnfwNUdytXdQTneOZy+pQsSY2nkS4DSktr2pQszPXFLtJo+Pa1J1a5RY7CkhTQbZI6ld0G00eK/TOSp9PJE0i0m/ZQ6gcffqsNxpGMgIxt52PMgaYgOczboS+eckalqh8gjwy5KbsiyC2n4BYRciP+upHVjlzUyUQnVX7wgR3dldh861CXBtgaS5y8tAypd1/ztF6Mbpco6MJYBqRfb969OqN1+YnYohxmYWUng==
Received: from SJ0PR05CA0094.namprd05.prod.outlook.com (2603:10b6:a03:334::9)
 by CH2PR12MB4245.namprd12.prod.outlook.com (2603:10b6:610:af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 08:41:34 +0000
Received: from DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:334:cafe::aa) by SJ0PR05CA0094.outlook.office365.com
 (2603:10b6:a03:334::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18 via Frontend
 Transport; Wed, 10 May 2023 08:41:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT098.mail.protection.outlook.com (10.13.173.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20 via Frontend Transport; Wed, 10 May 2023 08:41:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 10 May 2023
 01:41:17 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 10 May
 2023 01:41:16 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 10 May 2023 01:41:15 -0700
Date:   Wed, 10 May 2023 01:41:14 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "will@kernel.org" <will@kernel.org>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 00/17] Add Nested Translation Support for SMMUv3
Message-ID: <ZFtYqtdsFSSx1Prr@Asurada-Nvidia>
References: <cover.1683688960.git.nicolinc@nvidia.com>
 <BN9PR11MB5276A6619129034311C917FA8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276A6619129034311C917FA8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT098:EE_|CH2PR12MB4245:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c639ece-c270-4ad5-26de-08db51325c3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h5SLBaxWkJl2TrXxOD6w7Tg/YkGGk7Ilk4LuHlxX1Kq/VYGSoA1VVw55mEGfJr9ClJVeoUDywgOrKF/CYaQ6g3tD45TJMDZpqkGOHykFAiH99V7eCFHVVo6MxmT7hKYdkQE9AH8vEuJWOeL8cDELBR3wu8OtVaoMVWA+TEuldJG950WvR/XxtjluYPai5vp13bi9jZbXUId/kTfU4cThIKGNlTKw3Tei1Uzs96L4dm4pxuJB1+NeH/8T9GdAl+lQT4+DH54jJrIwACGVjkhAoG2fVnR3CoUMK4POYkN9slB/NTkxpXFLjF5PZ5V2ZxHp+G4xAvoce1MTwm96AhYoQaj8QRz8yM4h+GQZPGiVl+wX0v1RH+fylZurhmBhQRivYNyDgq42hDGlGhPa+VtD/LToG7b5WOLDVW2Uhhk2zRX65KZsmpdnrIvnVEwuHoKEs1lAq5fvt9UTIoYIB1UmPSTpcf9/G2oEC8NU1VoPqJC1iHzd6j/H2dbG/1BNiMIC/uzdd9DXAusvJVMCG40ZD9lZrNOVKAY64caUtq6i6V/jY3Jkx0vfMuQfeO6E2bux/2C9BcVY2eT7vfiw8tj1v8+KQq/rK6bnPf+rWoUTtw0Fr/CbCohmBhV36eRvr5N1tye5gUn5ObqMMNNwBIUoPVYX1eroQ8QY3uDTymcBNBIRnPU7Prg6trsIPf9sEuJrPFJvpRGNp2z0rOy7t8ddlDtQNtJaTbFkpo7+uCN6Ev+TVNNlAm9YgpTFc8iNoGBY
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(7416002)(5660300002)(54906003)(110136005)(478600001)(41300700001)(8936002)(8676002)(316002)(966005)(4326008)(70206006)(70586007)(26005)(9686003)(2906002)(47076005)(336012)(426003)(40460700003)(186003)(36860700001)(7636003)(82740400003)(356005)(40480700001)(55016003)(33716001)(86362001)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:41:33.9442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c639ece-c270-4ad5-26de-08db51325c3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4245
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 10, 2023 at 08:11:28AM +0000, Tian, Kevin wrote:
 
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Wednesday, May 10, 2023 11:33 AM
> >
> > One unique requirement for SMMUv3 nested translation support is the MSI
> > doorbell address translation, which is a 2-stage translation too. And,
> > to working with the ITS driver, an msi_cookie needs to be setup on the
> > kernel-managed domain, the stage-2 domain of the nesting setup. And the
> > same msi_cookie will be fetched, via
> > iommu_dma_get_msi_mapping_domain(),
> > in the iommu core to allocate and creates IOVA mappings for MSI doorbell
> > page(s). However, with the nesting design, the device is attached to a
> > user-managed domain, the stage-1 domain. So both the setup and fetching
> > of the msi_cookie would not work at the level of stage-2 domain. Thus,
> > on both sides, the msi_cookie setup and fetching require a redirection
> > of the domain pointer. It's easy to do so in iommufd core, but needs a
> > new op in the iommu core and driver.
> >
> 
> Looks the new preferred way is to map the physical ITS page to an IPA
> provided by Qemu then let the guest allocate the cookie in S1 which
> is then passed back by Qemu to the host kernel? [1]
> 
> [1] https://lore.kernel.org/linux-iommu/5ff0d72b-a7b8-c8a9-60e5-396e7a1ef363@arm.com/

Hmm..is that something firm to implement at this stage?

Thank you
Nicolin
