Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F725298F9
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 07:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbiEQFMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 01:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiEQFMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 01:12:05 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E558275CB
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 22:12:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdvT/znhmzAjocolayI3N/6xjNCA2JIFHVGBVjBM2dAH9IR5+UYAoVXTh3vBuQlmAnvv4U8+espNc/ScjHdGDTS1AtdEyWmDeREcCyaNOq3XeXVMx03aZ6OFvF6+XkG+ONEZtofxKy09sRLewfmGFtFuIV6w5o8XTY/NICALMi1qk1UWx0AzGzfuwFcup7wWKtmTKYJyJs/McSlm+fGHC3dY4OvMiarsTrqPevJGf4FqATBLoDYo/54Vhv2nADSjPhiCYuZ/dT69HU6sXyPRZOUx9JkSLl18xa0vgPmA1lqBrNBWn3ovaWGwRsHWfLpQJkIWu/5wr2Z8fxLRbHD8tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WYL3PErDIajImpc+oCGWD8NquvftJlHomISOslvMcOY=;
 b=l/ri3sieCXOpiiGxnTkWKH71AxCPDUu3bDaniG773nQMkCx4CTSzfEHroOHU4Z2c/Lp5FXNry1yTY9s35Ll9l6/K+Mtrs1A4x5z9dO4g3st/3aJrHtQZcwDzpwfomKYddf42H8rwhtzTupdgtMEaiKvABq5pVjz4Ni1mB0CFoDxqV/aiOwO2TOIzZ4syq7U4sR+9iuKRAE/CIYiQrqK3E4GWxXWdA9Q+Dv7pv7CJwUo9TRGx+vuzRRY0ga8JmxWuitwn44NSGZGJPKBA+TfPTVLyEX5cUMlBisLlCfRd7rXgc8bD40mj4vxBWWofKaIt6EvHzsx4u7Wrc7ANRbdraA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYL3PErDIajImpc+oCGWD8NquvftJlHomISOslvMcOY=;
 b=X7MNvg0OlXwdAmHvCb7ZkiC7O0pjxy9aIx5c3KY3swtyK0zWZdKiek57i6eI3XC2fRDsGUaHDdA0hFWxASKJ55TRqvmXc3UdeigV0gVEHI8L4FwOvpXtw3+bDCjjkHDTl+JDIlGa8Wrw5YwbZHDAD5+4XnrPICfFoggVUR/rJguVJz2gQgOIUUbhQAJMf0BCN9EXsVvMVy6bJhyVCzISL/bYY9+QFTmrsoHJeiNpJ9EQZh3VPIBZqhYi/ZiWV4zsSgZp0K1jOGD0VzB+QgMperaasfZ/nvOFN962IUGcjpgSvA8BhrGvDpObfkN1GhTY3/247mRJKSmofqrel0znYg==
Received: from BN8PR04CA0046.namprd04.prod.outlook.com (2603:10b6:408:d4::20)
 by BYAPR12MB3111.namprd12.prod.outlook.com (2603:10b6:a03:dd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.16; Tue, 17 May
 2022 05:12:02 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::f4) by BN8PR04CA0046.outlook.office365.com
 (2603:10b6:408:d4::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Tue, 17 May 2022 05:12:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 05:12:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 17 May
 2022 05:12:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 16 May
 2022 22:11:59 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 16 May 2022 22:11:59 -0700
Date:   Mon, 16 May 2022 22:11:57 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v2 0/6] Fully lock the container members of struct
 vfio_group
Message-ID: <YoMunTOPFRrGASWq@Asurada-Nvidia>
References: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef033fb6-2daa-4e0a-96ea-08da37c3c6a0
X-MS-TrafficTypeDiagnostic: BYAPR12MB3111:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3111CCDF6B179BC3950080E6ABCE9@BYAPR12MB3111.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xDLdR4MdIccvPi4oCsZ5r5wPGxSiE+aVsZApMyg2T3EvEEXCqg8HLGGP7aOansc4HAfr+SP1InmirfEcG2OQEtbOzvURtz8C3yDLR/MQFp+fHeTnBqP3HVNf0MO8TGOYm6bfD8jrXt9ERDBa+fuqqaiksXlIn80S5IUEKwvMm6PB9ZZKiNWX+M2tvL656QBMk0DnNZ9X21rRcyYDjWdpYmEDEPSzh68HWCiBYrQ3oQqnj/siSwzq5WaycuSWsl1YAq01w+pkzBwyly6Qgbr9CQsnBeU5MTnDrau5+u5/EcydsABkgcNzbuOsBcoW0RnRc8psGmdhA+5AXx6zxQs9gjCARuNyGiE9TJ0c8QPSDoAMDjD6ntJE3Hi+Sa+VzMO9MsW8VH2uPu9ovM1q4YW+oBX5PdmpRR5rZCuqNNYh0TpKtqFTUgv98MTiZYtjAGToHzDyRKHA6MD797LpK1bd4JOF/xvwZ+kaVNuf8OFVQv6nuavYDAwKrxH59OqFatlFoEN55i2l8aoymHvJRLL6tJQZiRqZpQZgelxm5dSBigjc3cDMS+O/5+giYRRKxQnnf+gcciVyU5Y6eDGx04zXieuibaF+qYrkyZgHihG9NFNhT5Hkk6aNttQnGseTYahQ2uwg7YoEQY5qY8QX6lmwc9AgUufSqqZvg2pxvrbAtf4XtbqUEqVB//3Zz6EDuuT4kmFozuwH2mmBTU06KNkt0dn00UfiDx5B6l3nD0ytcNUtdn/sPPZLaXnMBGf6+4nLDn2nDWxXWku21it8iSUFX4mJ4i7qWu8BHJW7EN/P8HZ+MKdPjeZvznTBcFpAcLIfWpji8aZ9+uGv8AKNtEp4zQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(4744005)(356005)(2906002)(966005)(55016003)(47076005)(86362001)(508600001)(426003)(107886003)(336012)(186003)(81166007)(70586007)(6636002)(316002)(83380400001)(6862004)(8676002)(70206006)(82310400005)(40460700003)(54906003)(9686003)(5660300002)(8936002)(33716001)(26005)(4326008)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 05:12:01.5191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef033fb6-2daa-4e0a-96ea-08da37c3c6a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3111
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 08:41:16PM -0300, Jason Gunthorpe wrote:
> The atomic based scheme for tracking the group->container and group->kvm
> has two race conditions, simplify it by adding a rwsem to protect those
> values and related and remove the atomics.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/vfio_group_locking
> 
> v2:
>  - Updated comments and commit messages
>  - Rebased on vfio next
>  - Left the dev_warn in place, will adjust it later
>  - s/singleton_file/opened_file/
> v1: https://lore.kernel.org/r/0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com
> 
> Cc: Nicolin Chen <nicolinc@nvidia.com>

Sanity tested on x86_64 and ARM64.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
