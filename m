Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D61B6EE5E0
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 18:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbjDYQhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 12:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbjDYQhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 12:37:37 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5DA146C0
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 09:37:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJ0X8sLRXzNmGmQ2MC71PVTb9ZLaTSk0gUDZdIRYkmFkwqke9DhzmlaZFuQSzR4qTS/ywimGwhkjzaB022eLR9fLat71sG2vqVJlv2GVkJNcZBntGwXlCBlef5HoFDSM50GLp1RHFxqxsICmpvZz38R8OONURD8EXxhuYHC7ejdLt4eyHPSJkT/ajLeMSJxqDtRy/g1B5IOg+ZQDOwZ6IzInixtVaxtXvThlmV00CQvR4uvf8hfs8Uc6X1TZSJTcWxCfT+wpBJ42PwHczWMmBaf3TmfQX26zrlj1JN+ThmGEaDdbEB2wXJTK4HYo+v/KV2wReoRenHa8suSigS+dtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0Lk6VCPXtYwhiQuRMR/51LKp/7ZfgkTmB23Y1Ekdos=;
 b=dNzSLMrFxzaWzohZ7WJ5cx++92NETLycBYx/oFuEfeDx7qLBMiaywMwMUHppRJM8ytLAIQTHd9kKbS/6ikrXboRji5B35Vp038miYfwsbWX/xfOmcA0JitTGSV+/qWpsMoqzNJnYpuz7M5P+C07yGtmEyuGJfnTOA/jUAz9WS5jjMa9Hjob69VLfkM1IXtjVgrUwoOqx0c8Wte5bWov9qRRJ+GitfrO6ttxcSG3ywNW4igKY4cWEVa/aeLlOxLVYbTT5bWbAPum0C+Cc5QYOMBAvLJin37ulN3sxfmVLHO6R+n1rXp8J/sUr/YQm10zzcYmSOGaukbfqCR9jlUY6JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0Lk6VCPXtYwhiQuRMR/51LKp/7ZfgkTmB23Y1Ekdos=;
 b=JB5pdUmfSBWoVJC5UXZp0JAuHdgB2EONo9bNhKoXJ9HC4M0gB7ei9mjBLh9HDXitBN4CbyyJDGO5kq9mNFycJ3RLbmYst/BvCERRVGCUgE0wxaRvMm4ohpHy2vAMdSFyOOsRr/WBJ8nAlDudVP/Z351yY5dzcN3nmbcg8dBVjjZS9wg78ZkDK4l4+r7b0U6Wkp8tJvZAkZCXcz7D4mm5cffGEhzUw+ShtlgEroqzXExzT4DmF27t7q72zQntGUBXoJNzxB9EB2mCIx4r/3uyigVzhia64VNQ/FQ+rkYBJPmVJ7SoIvHXcPt1lACvsoVICLlFan5fNmPj+inCDx5c7g==
Received: from CY5PR18CA0051.namprd18.prod.outlook.com (2603:10b6:930:13::25)
 by DM4PR12MB7622.namprd12.prod.outlook.com (2603:10b6:8:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.20; Tue, 25 Apr
 2023 16:37:32 +0000
Received: from CY4PEPF0000B8EF.namprd05.prod.outlook.com
 (2603:10b6:930:13:cafe::79) by CY5PR18CA0051.outlook.office365.com
 (2603:10b6:930:13::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34 via Frontend
 Transport; Tue, 25 Apr 2023 16:37:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000B8EF.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.5 via Frontend Transport; Tue, 25 Apr 2023 16:37:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 25 Apr 2023
 09:37:16 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 25 Apr
 2023 09:37:15 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Tue, 25 Apr 2023 09:37:15 -0700
Date:   Tue, 25 Apr 2023 09:37:13 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <ZEgBua57zrciDfg9@Asurada-Nvidia>
References: <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com>
 <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
 <ZEKFdJ6yXoyFiHY+@nvidia.com>
 <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
 <ZELOqZliiwbG6l5K@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZELOqZliiwbG6l5K@nvidia.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EF:EE_|DM4PR12MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: 462a19a0-f013-46a4-70e2-08db45ab5ceb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TN8KcUmkBO9EGFsQql8vIbVS89VX8yOgY9jnGDNGU4cn7X8ZhKoFhBGZBO97iAHoq4qCwRJbiWNbSj/gbFSoKuGEFmNaKYpbWeVYuTrpW0jv53Fm7HuDJIOJfO35fNLx39MSYZuQuKqB6ZhqXOG9SA/MwQjgIma+PxBO+A2/+DS/FAnelFdAhZsD24s8+Vpqs8NEylASMNL+qHAv1LW3g5/jUupXjnqo7CwTHpiEfAXZxlFTtmcP+SWnlQJDno0EKfhrrk71RK5o5fvCoYCY4LkbLVwuGD0217DHltcV7CWypxd8bsnlNZ7179Qvc7CPInUXJULJrc9nezQRk/alGG2/HJMpZ6v1iH02idHv4YBomwBWC7mJSHfq6anQMnC6etsLi1SKLXw2e32AwNHfxspjwUn/KN583MnizfEOjk+aCJdOMIIND4Iwuwqs9ZT/mbXvyXElg3WroAH7sG1XUStjgeBrXdySn7Ov+F0ZJR2mOrvTNxYquGuzo5s36VTVC4cJa+zeU3FCpPjXn/Wvk1cEGxnCiLBrzptfd67sIXTrn6/0ve/djB0TIpzUyfqPiQVvHo+6y6FCZNyu5fdfPuPgvlHWddMZc3BuTDtq9YL+jdZLGlBYJlIkONC/K5nIxAbWvywkBV5R21SXYfnAzPpg1VWKJDRbbkQ6gTTS1w5srsIoPa9nqpZAff7H+GOaOI73B73QjsM7pCV253rReQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199021)(46966006)(40470700004)(36840700001)(478600001)(36860700001)(40480700001)(55016003)(26005)(9686003)(54906003)(6636002)(70586007)(70206006)(186003)(47076005)(426003)(336012)(41300700001)(7636003)(356005)(5660300002)(40460700003)(316002)(82740400003)(4326008)(86362001)(2906002)(4744005)(6862004)(8676002)(8936002)(33716001)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 16:37:30.2621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 462a19a0-f013-46a4-70e2-08db45ab5ceb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7622
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 02:58:01PM -0300, Jason Gunthorpe wrote:
 
> When the VM writes it totally-a-lie MSI address to the PCI MSI-X
> registers the hypervisor traps it and subsitutes, what it valiantly
> hopes, is the right address for the ITS in the VM's S1 IOMMU table
> based on the ACPI where it nicely asked the guest to keep this
> specific IOVA mapped.
> 
> I'm not sure how the data bit works on ARM..

Not sure if I follow everything here correctly, yet the data
seems to be the hwirq idx in its_alloc_device_irq()? So, not
only the MSI in the guest is fake, the data also?

Thanks
Nicolin
