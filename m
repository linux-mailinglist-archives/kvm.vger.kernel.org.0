Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93057D3EB1
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjJWSLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjJWSLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:11:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0EC9D
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:11:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdmO3AVk4xpo7HKQA1KSkadxWTRItRgBh9sYHtHLUwanmRm86Lai3SMhQwmLobU3iU75TK4rsJkHxcPNdHBYa2m5969ev50hegZE2df9e8dAuJbczPSPa4F68O5iSU6l/pjcySAGjmdNkj3/qZGVIOjcEzXo4AtVY3aLIgDto9l5tA2IOp6Rd5bYuAZV8sVT2iETQHIfMdalwRSa/FQ6GpxK+0GGBhmom1x8GGZtxiJ2+L+pnPmxgakPvThcrFODTAvEv0yGATlpBYTxFxKiw/MyBTOcMUYhWtnAn10asr5j3EMM/jgSGKOZbop0CfMW6x/BrcesholVXAxVy0zscw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+MNS6q3nliFrrsyi+yVjhBmf3sRH1/AggIKuqv8Ov0=;
 b=d5dMTnrEXEtQ0yxEf0Wgv6L29AOlcYHjJSGM4uwbrPUHS0jA/qdkYpHQEdmbmJ/sgP4eoslfOCzFmhvmjKQjOaC2/Sn/w6r+WvNpJQHA99TgDWazV5jPX16uTyI1GOkkEjA1rcvpguQ1OYHDYjRcF0nn2BkZrlAHvwTgcOULh+V/SJJn3dqpr8ptWOyEVCYXZPKsjvpeuF63eBM7JZaipSWfdMm22oWbb0HEAEBWjXQ6KC/YITmU0/zICJ/5j7qtY1+GkyUYn6fELR9C31Db/2OFJXzZClcu5Bt+PxbI3ytlQYvPade1S48kFsntLoQY2LC/ZPwiuSDvFQuqwDKO8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+MNS6q3nliFrrsyi+yVjhBmf3sRH1/AggIKuqv8Ov0=;
 b=XZgqe/DoxVcucxMZCqGOv/uC7Yq7UU+U73/inLJCPOM6xaUhtK9nHL6m5UmP8pIGwZ1+amYYXEth1hhLkIS7y34A7YLMHnqwWMdB+pr27e0TqdhM/WVye2YWbMsaRmc6uhJwQNKxOoedy250dU+iS6WY9AecXGa+jL0rMwzFg7nzYTn7yppX3lBsimMjZP2bfPlIwRdOjEOc+NYk7s78mlnwWombvNeXVpXike+NEAaSQAxfKkIynyZYQW5wo4fb+0nrwTDeq6tpKGQTNl+8O8cmdVZ4qI1oTLXa/edfcKF7kMXRrODQHb4ty+kdYnaFTjHhfW8h3JVZnSiDdvcWKQ==
Received: from CY8P220CA0033.NAMP220.PROD.OUTLOOK.COM (2603:10b6:930:47::23)
 by DM4PR12MB6109.namprd12.prod.outlook.com (2603:10b6:8:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 18:10:37 +0000
Received: from CY4PEPF0000FCC5.namprd03.prod.outlook.com
 (2603:10b6:930:47:cafe::a4) by CY8P220CA0033.outlook.office365.com
 (2603:10b6:930:47::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34 via Frontend
 Transport; Mon, 23 Oct 2023 18:10:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC5.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Mon, 23 Oct 2023 18:10:36 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 23 Oct
 2023 11:10:22 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 23 Oct 2023 11:10:20 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 23 Oct 2023 11:10:19 -0700
Date:   Mon, 23 Oct 2023 11:10:18 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <iommu@lists.linux.dev>,
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
Subject: Re: [PATCH v5 00/18] IOMMUFD Dirty Tracking
Message-ID: <ZTa2uRBLt4EcZKVP@Asurada-Nvidia>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231021162321.GK3952@nvidia.com>
 <ZTXOJGKefAwH70M4@Asurada-Nvidia>
 <4e7c8e8d-f22d-40e8-ad41-1e334bb78496@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4e7c8e8d-f22d-40e8-ad41-1e334bb78496@oracle.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC5:EE_|DM4PR12MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 3261d1ce-3bcc-4a05-47db-08dbd3f35b90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZX1d/qI8nquc5Z7yB/8D3VYZ9aS9ygMzgXsrnyifnk5WoNbfDhTxgND1EUZuJLWpIiCqD+GD9Yopx1UzvvOGzuqGDuHlU1eKL1bSRLi0tKnOxgxNKCgz+P+41ge5KkQlDazE6aZ0ad713y2913mme3owo+iwN287BeOuFLt493rZ/uNwJiBv49MCOAHtq8MPnvzacjpIMRgk7AeQ3kKhvmmaSgOD/j0pKf00Jw854ibM5uyA+E1fF6W3mfjyJsWsVCTf4KgrCguv3x9Mhp8miYH6ltgr8/v8sKF+F0/gWPvB529Kx9npCk5Ah4IHTQsrNi3BLYpp/9CJvUtvOEbk+T5Tw2tcHBkrxWwOEMtwIstFWcwaMI8qxAQzxlnkw5iS6EfInNwDdTvqrMQDGzOtQQIinbe4Efiqwn5oiUH4D97/oeaitZ8Q75emPk5a4k1gZJtV3bIYC5CAAxg99NxSyR6IJcCh493sDmkm5KU9VQxOaCu9zBuV5FrsL3ah1DNrW9rEnSQ6aEBm9Ws4Ynh2QJBGpuQs8hdUosHKPQJgxsqrql5SAe6jsRDtQgVdOehsfr9Z6Fp1oHZisPCwHAlhRt/9GIESXNeqHogWXk1r7B69ex+/aCSgzAC4SqiYQVLsngcpSijLpWp36OA6R8JCIFnzVwVPYncOmlCn0Q0jEokTM4VqTMkoxApw7cxpf15AjfZHEbZgfOX9u+F1ASqETkc2k4fZL8Djc/RTNM/c1r4=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(230922051799003)(82310400011)(186009)(451199024)(1800799009)(36840700001)(46966006)(40470700004)(26005)(33716001)(2906002)(55016003)(86362001)(40460700003)(7416002)(5660300002)(36860700001)(8936002)(8676002)(4326008)(70206006)(508600001)(7636003)(356005)(54906003)(6916009)(316002)(70586007)(83380400001)(9686003)(336012)(426003)(47076005)(14143004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 18:10:36.8659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3261d1ce-3bcc-4a05-47db-08dbd3f35b90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6109
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 10:15:24AM +0100, Joao Martins wrote:

> It comes from the GET_DIRTY_BITMAP selftest ("iommufd/selftest: Test
> IOMMU_HWPT_GET_DIRTY_BITMAP") because I use test_bit/set_bit/BITS_PER_BYTE in
> bitmap validation to make sure all the bits are set/unset as expected. I think
> some time ago I had an issue on my environment that the selftests didn't build
> in-tree with the kernel unless it has the kernel headers installed in the
> system/path (between before/after commit 0d7a91678aaa ("selftests: iommu: Use
> installed kernel headers search path")) so I was mistakenly using:
> 
> CFLAGS="-I../../../../tools/include/ -I../../../../include/uapi/
> -I../../../../include/"
> 
> Just for the iommufd selftests, to replace what was prior to the commit plus
> `tools/include`:
> 
> diff --git a/tools/testing/selftests/iommu/Makefile
> b/tools/testing/selftests/iommu/Makefile
> index 7cb74d26f141..32c5fdfd0eef 100644
> --- a/tools/testing/selftests/iommu/Makefile
> +++ b/tools/testing/selftests/iommu/Makefile
> @@ -1,7 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  CFLAGS += -Wall -O2 -Wno-unused-function
> -CFLAGS += -I../../../../include/uapi/
> -CFLAGS += -I../../../../include/
> +CFLAGS += $(KHDR_INCLUDES)

You'd need to run "make headers" before building the test.

> ... Which is what is masking your reported build problem for me.
> [The tests will build and run fine though once having the above]
> 
> The usage of non UAPI kernel headers in selftests isn't unprecedented as I
> understand (if you grep for 'linux/bitmap.h') you will see a whole bunch. But
> maybe it isn't supposed to be used. Nonetheless the brokeness assumption was on
> my environment, and I have fixed up the environment now. Except for the above
> that you are reporting

Selftest is a user space program, so only uapi headers are
allowed unless you could find similar helpers in a library.

> Perhaps the simpler change is to just import those two functions into the
> iommufd_util.h, since the selftest doesn't require any other non-UAPI headers. I
> have also had a couple more warnings/issues (in other patches), so I will need a
> v6 address to address everything.

Yea, thanks
Nic
