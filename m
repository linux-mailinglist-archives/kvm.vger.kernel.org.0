Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02DE7D40A3
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 22:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjJWUJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 16:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjJWUJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 16:09:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8100F9
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 13:08:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sj2ni2P0pKzI3kHMhhZP/2cKi1AYwuR40WGDzVyWn3g/wJOC0vLGntRmGpypZHRSlCxCE5vNeWWlFz3yMTBDM3Ead3O+lx7fHgdv11tF8wVNJFkUokV+GCCiBROq+mHJDtQ0geqji0VtCRj1Rry9sDB3ZIZwW8j0eL8r7yzobqpXr+4ZjXZx6kOfAdh8G/koFdxAycLY7IQoXvXiFms7acBNcLh2BrduxiiPtTrEmMejnNxGQGYI9agiZBgTCkI4bh/mW3NELOfA+Iex74R/6PdEeAh66NvUWSZ9vfXr0fdMqCdRxfFDl7kcxotsXngAJe26n2UR5XYH0Qd16400/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7QHWkuAd2QUiN1/4m8hM5Imb/eNwBjHfPmaxUhldKI=;
 b=RNLxe/WixWjPEbWNMOVeDc40BExL2mY3Ht+jwJ298PgiO7OSZwg68QghDOs9k9iVnDGaUeQeq3v/9EPZqQpvzwcn23sZYAz5NA21MmSEIiFesPOE2WV70XeFo4ocbQNQyTbXIiGNRMnxsHxqQal6mRRBSHvwt3fF6UARXebpSCubrXvUT37RODWASB3JuEpM/uVAsdvc439S1s7ie27p5AotgldYbu2A9JbSjz9ftSe9BrD9jGRsxU/JVS3BWkcxwW040pGx5j5/YmYv5qS9hPIcI+MXKAUM1z3aYMEk1mm/eMZipDvzwYa4iw+qjIfnNBh6Vwitgf6vrPCA5oYkwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7QHWkuAd2QUiN1/4m8hM5Imb/eNwBjHfPmaxUhldKI=;
 b=uh2IbJ79aPXgRp/93Tdq6KpSW2hxQapyDi5shEGYaygPAdXY5QpZKPK68o/Mlze/M/mGs4eq00mRJWe/OudxErzqeWqozRckqMJhvMTXrAdoiM/+ALjCAGMU4ewlOD4xt3Zfis/RuoisUXg0dJFPD9KaxSrSYmvg/9YpbkV3XFPIpIyKH1hy0Ze8PzlbrsgNaw7WIZZ+wq0+jpGmmI5sQgVjDBdUR/o0XCfRPfJa75Ephs6RK16UmcnDFfMEh6uEN9hoAeAH3M1WKnJJJlYkOWgWsy7WKedj41jLM5LI4UC86omoIUAfGl9SbtJvCYPiGp2pEWpxuUFT/F7jQ+xo7w==
Received: from CY5PR15CA0147.namprd15.prod.outlook.com (2603:10b6:930:67::16)
 by IA1PR12MB6235.namprd12.prod.outlook.com (2603:10b6:208:3e5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Mon, 23 Oct
 2023 20:08:56 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:930:67:cafe::86) by CY5PR15CA0147.outlook.office365.com
 (2603:10b6:930:67::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33 via Frontend
 Transport; Mon, 23 Oct 2023 20:08:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Mon, 23 Oct 2023 20:08:55 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 23 Oct
 2023 13:08:46 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 23 Oct 2023 13:08:41 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 23 Oct 2023 13:08:40 -0700
Date:   Mon, 23 Oct 2023 13:08:39 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
CC:     <iommu@lists.linux.dev>, Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Zhenzhong Duan" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 16/18] iommufd/selftest: Test
 IOMMU_HWPT_GET_DIRTY_BITMAP
Message-ID: <ZTbSx9mDWf7QwgjF@Asurada-Nvidia>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-17-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231020222804.21850-17-joao.m.martins@oracle.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|IA1PR12MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: f4651c46-c318-4ad6-5781-08dbd403e298
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lcBqwQ5kdTW/MPuMuS2ZLIcECuIGtcgpV3Tf7k67ViAcrpS8a/k7u6KqFz5BEqyM24fwlsmMuPs/smcvTHdf0z7bKioB8WysaRvco+z/4I+7wjXD9lXPNq18exwA0WKsUl3SgUq8axku2sulDeEnK1kCupoZ/ZJFD+rPbPDCDFE8V32U/8e8WJskg8FO4VL1rd15pZVoLsrAXki/eBqHENGG4Kx55UOJA02VJxNB6BO64SK+ob6PojY+P/HFtaZXhgO4CPB/6PNDzMrgaQLWd/CftWZGvjFQGi3VjLfw6iyRyH2FmnmGM7j9Wj8T9Wl+zSIeMS4ea0aX4ocJmX7D4ONHAy9zmUVHtRhdzUtkvX1VXY+rfedvVq0dFVLn0xxfijM6k3DHE2bmbNjJcR8FMBsoH122z+cLwnBXK1dRZWeTW6X1atbqkhh4O2CxxNWMoNR/lAY6UvQlhp7wAOCJnRalGOlYQ6P9vmA0Del0plSEv1RrEQuKmoqabC7VvA8OTUz9j216uyoqrhPeRJtEqQXF/WrIpcLw3t5IiwxbNszDty2f9k47ZuJLD9vBuhUjrZTBqP7hwXkT/9ocQrDJJUB/3TJTOlAZgl3GE84N0zxL2nz0av1062nSUTrURkWFjLLuu7ZnGXzeden/+tbK7yBAgIjTqzZ7OudSv2f4oyCs5Ciqeejp20ThpyL9dcsklfcmp+cdBRSBNIcyvd5hxi0GvO9Ypx6Gu+mlCEmcAGu3F40i/fywnIaN2d1850NSjVbRkQ8dWwpFvuAksykFlA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(376002)(39860400002)(396003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(82310400011)(40470700004)(46966006)(36840700001)(33716001)(7416002)(41300700001)(2906002)(40460700003)(55016003)(47076005)(9686003)(4326008)(7636003)(26005)(82740400003)(336012)(86362001)(36860700001)(40480700001)(356005)(426003)(8936002)(478600001)(5660300002)(8676002)(316002)(70586007)(70206006)(54906003)(6916009)(14143004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 20:08:55.3744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4651c46-c318-4ad6-5781-08dbd403e298
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6235
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 11:28:02PM +0100, Joao Martins wrote:
 
> +static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
> +                             unsigned int mockpt_id, unsigned long iova,
> +                             size_t length, unsigned long page_size,
> +                             void __user *uptr, u32 flags)
> +{
> +       unsigned long i, max = length / page_size;
> +       struct iommu_test_cmd *cmd = ucmd->cmd;
> +       struct iommufd_hw_pagetable *hwpt;
> +       struct mock_iommu_domain *mock;
> +       int rc, count = 0;
> +
> +       if (iova % page_size || length % page_size ||
> +           (uintptr_t)uptr % page_size)
> +               return -EINVAL;
> +
> +       hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
> +       if (IS_ERR(hwpt))
> +               return PTR_ERR(hwpt);
> +
> +       if (!(mock->flags & MOCK_DIRTY_TRACK)) {
> +               rc = -EINVAL;
> +               goto out_put;
> +       }
> +
> +       for (i = 0; i < max; i++) {
> +               unsigned long cur = iova + i * page_size;
> +               void *ent, *old;
> +
> +               if (!test_bit(i, (unsigned long *) uptr))
> +                       continue;

Is it okay to test_bit on a user pointer/page? Should we call
get_user_pages or so?

Thanks
Nicolin
