Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897464D8C0B
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbiCNTIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbiCNTIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:08:21 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7156935DDD;
        Mon, 14 Mar 2022 12:07:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsvyFDeRr/ZTpmT9UoWOF+PhZYHpj9yzqkv1f1NzNuPgPJt1HBfpFN10TE4FmM/iYVjWYO2d+vGLS6EiYQkUadfiqJc76NExOxWpAniGPrk6UHU3gpzWIx98YlZ+6LAL4/iSQaPCLMB3zpQIawbEOoHG5U7ja460jC4Lx32eWxOKLxMpc+WuUs+Xt+qCHm7ikMiP7uTONBbJkoiCMnumqIN2VhuJBVM9BxhrdZR8nbuxG+LN0PEAEPCDfJxsZsrGLKgheudoh7sbbtDMdCFV2eFOWXYok+4DoBUC2g71VdQKJAZp1eMIs0Z5My00cKHIaplbK07ztppCoNi9NEENRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+ya3MaCf7MD8xRHgB/cYTCittpJlr4x1dtMKiCjNus=;
 b=iC/I+KdBKB4U97G8YXSnm0gJG9i4PK9yDqeRRzl3vIepkVP+mVHlvLXZ2mmrNHmmWXMmBJENs8rPyjv3chJIZ5V9yYGmg0mTIpIym3RQXNJ76HooiaFR4+T1qOLODiSO3QDYROwe5LisfeTlBqkaqB4SyRkd8GLuBqGxxz2YLXb+xbmr08J3R0gzQzLoMSHTU1fswgfvrLiuZKD1WoV3TQRKtF/6rhOMAeA4/KbS5zcucL/NFNlBUehmWm5V6klK9r0adlhNLExq91qXepp/2KKgTb4NRSWcNBERzFMUuIVyj+ulOKdYHp28Az8OdX4GwJ/q2KbnJEqqMRqgpiGLVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+ya3MaCf7MD8xRHgB/cYTCittpJlr4x1dtMKiCjNus=;
 b=ATGEFT4l/XzevmesraRPJ3zV4twcHDW+KJY53aRtJ+qSNWvhzkjdHRcFKHnsiVrQneMpN9eG24q4MtELehSuaZOTIVFx0T+0eb3CQ9Tdt1dVVHb/1XLN1dGthf4tAnyvf4hNxatwvP/LYstoIpowoXdfZXxo4EP3+IuC1ASxDntUO78zedY9PyH80EmcKQnjaphDsQf2pyL1uSLXJ2IWm+p/UlC13MXWvdYMLEg8oyLG3nUYFk2DaUQykx0KA42HHzY0V7z0UjqGaqyOifnGPxatSaDzVUgPhXSJOYVojakVpdiMUrTmxk0OXPqnpbgs1l6W3BOofT9GvdQFuDME+w==
Received: from MW4PR03CA0293.namprd03.prod.outlook.com (2603:10b6:303:b5::28)
 by CH2PR12MB4280.namprd12.prod.outlook.com (2603:10b6:610:ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Mon, 14 Mar
 2022 19:07:08 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::f2) by MW4PR03CA0293.outlook.office365.com
 (2603:10b6:303:b5::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28 via Frontend
 Transport; Mon, 14 Mar 2022 19:07:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Mon, 14 Mar 2022 19:07:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 14 Mar
 2022 19:07:07 +0000
Received: from [172.27.14.25] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 14 Mar
 2022 12:07:04 -0700
Message-ID: <a635abc8-be36-a9ee-dd8b-2950cc368562@nvidia.com>
Date:   Mon, 14 Mar 2022 21:07:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] vfio-pci: Provide reviewers and acceptance criteria for
 vendor drivers
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <jgg@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <linux-doc@vger.kernel.org>, <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <164727326053.17467.1731353533389014796.stgit@omen>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <164727326053.17467.1731353533389014796.stgit@omen>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3398d45e-189d-4659-b9cd-08da05edd5e6
X-MS-TrafficTypeDiagnostic: CH2PR12MB4280:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB42800AACF02E2BB9E221BA4AC30F9@CH2PR12MB4280.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I94h3HG9WGlr5/gEkhv2dX50HFsJKEy2Bmm/6Vfds5pRjXdPfLTwvHhFraiztGL3+ZlYUyEFQoNsgvknUEdHlG00yS8y+iFoEnkoqJDDPOAB5LvozYXeoymQAiW/Ko5B6wWaIVZ/48+N8FBbxIc+UPX+9zK9KpnB/6yc82XxHiMb6QHkVHdJJTjqV3UVOlNTHTvMdnTL/Y3hq952H7vhl6zmZD+fo6XTL5A3MrD+itzyYBWeynYWmB9l9uZ9X+qGw1dObtW+JxjJEjRpKNR47OtpzCA6NuQZv3HpdBd5yw8pT4QkPwrRcdxzDVb1x7XbcG7ri8qlJe52PnjJLOkf3GJLCWwXgiUH11cI9DGPYzlPfsBA54TN8cjuVwJoEXFTrBafjLa28MgwwDI8+GOOKyXlXgEc/Iyhna4Fibj3hwkV1oIgqd+BMwpWiZWiGLIZ/lIN7iToe4KbSdrOIpNjUa6LtwjGFE4EGNRee5L/I8vUtW/ieGDbm8s2uNmw7B+YFJhQ5dKuphg/7wEsMdful6ezyhTLi3f/i+wPE7OL01IjTc1WcgRktCfLnzP3/FTfr3TlquohnhhTS1naGLccP3rqL4U7mL5qm7egTgioEkIhR2zNm4+oyhO3nKLTu+l/x7F9Dm2/jaOHpcJI2N2JbxO8GTCcDEfTT/wIyvRcRhu+vI3QdvMLszrfpb7ZRsSWCTrlKR0MxOzvXrEDCc+ZbuavqUMobm0Iadxe+u7VFxH7Hy5L28Qbn79GEmdhywG8sHXpMaZvDmdlJsDmMDeNISXt6FALYc18kHDPdWRlXn7Q2xPKvVd4yM9yhTNiHMNmhwAiRRqn/hMGeHkHr2W4qw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(316002)(36860700001)(81166007)(26005)(356005)(70206006)(70586007)(2616005)(16576012)(426003)(8676002)(186003)(45080400002)(8936002)(54906003)(336012)(508600001)(31686004)(82310400004)(53546011)(36756003)(16526019)(2906002)(86362001)(6916009)(31696002)(5660300002)(6666004)(83380400001)(47076005)(40460700003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 19:07:07.9308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3398d45e-189d-4659-b9cd-08da05edd5e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4280
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/2022 6:09 PM, Alex Williamson wrote:
> Vendor or device specific extensions for devices exposed to userspace
> through the vfio-pci-core library open both new functionality and new
> risks.  Here we attempt to provided formalized requirements and
> expectations to ensure that future drivers both collaborate in their
> interaction with existing host drivers, as well as receive additional
> reviews from community members with experience in this area.
>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>
> Per the proposal here[1], I've collected those that volunteered and
> those that I interpreted as showing interest (alpha by last name).  For
> those on the reviewers list below, please R-b/A-b to keep your name as a
> reviewer.  More volunteers are still welcome, please let me know
> explicitly; R-b/A-b will not be used to automatically add reviewers but
> are of course welcome.  Thanks,

You can add me as well to the reviewers list.

Thanks,

Yishai

> Alex
>
> [1]https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20220310134954.0df4bb12.alex.williamson%40redhat.com%2F&amp;data=04%7C01%7Cyishaih%40nvidia.com%7C914efb56c83d4b8d1b4808da05d4fd37%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637828709598448083%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=OCpxnavNm2klUpkGRDX1CFb6ucO32jO4e%2BUADebVFbo%3D&amp;reserved=0
>
>   .../vfio/vfio-pci-vendor-driver-acceptance.rst     |   35 ++++++++++++++++++++
>   MAINTAINERS                                        |    9 +++++
>   2 files changed, 44 insertions(+)
>   create mode 100644 Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
>
> diff --git a/Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst b/Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
> new file mode 100644
> index 000000000000..3a108d748681
> --- /dev/null
> +++ b/Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
> @@ -0,0 +1,35 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Acceptance criteria for vfio-pci device specific driver variants
> +================================================================
> +
> +Overview
> +--------
> +The vfio-pci driver exists as a device agnostic driver using the
> +system IOMMU and relying on the robustness of platform fault
> +handling to provide isolated device access to userspace.  While the
> +vfio-pci driver does include some device specific support, further
> +extensions for yet more advanced device specific features are not
> +sustainable.  The vfio-pci driver has therefore split out
> +vfio-pci-core as a library that may be reused to implement features
> +requiring device specific knowledge, ex. saving and loading device
> +state for the purposes of supporting migration.
> +
> +In support of such features, it's expected that some device specific
> +variants may interact with parent devices (ex. SR-IOV PF in support of
> +a user assigned VF) or other extensions that may not be otherwise
> +accessible via the vfio-pci base driver.  Authors of such drivers
> +should be diligent not to create exploitable interfaces via such
> +interactions or allow unchecked userspace data to have an effect
> +beyond the scope of the assigned device.
> +
> +New driver submissions are therefore requested to have approval via
> +Sign-off/Acked-by/etc for any interactions with parent drivers.
> +Additionally, drivers should make an attempt to provide sufficient
> +documentation for reviewers to understand the device specific
> +extensions, for example in the case of migration data, how is the
> +device state composed and consumed, which portions are not otherwise
> +available to the user via vfio-pci, what safeguards exist to validate
> +the data, etc.  To that extent, authors should additionally expect to
> +require reviews from at least one of the listed reviewers, in addition
> +to the overall vfio maintainer.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4322b5321891..7847b1492586 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20314,6 +20314,15 @@ F:	drivers/vfio/mdev/
>   F:	include/linux/mdev.h
>   F:	samples/vfio-mdev/
>   
> +VFIO PCI VENDOR DRIVERS
> +R:	Jason Gunthorpe <jgg@nvidia.com>
> +R:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> +R:	Kevin Tian <kevin.tian@intel.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +P:	Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
> +F:	drivers/vfio/pci/*/
> +
>   VFIO PLATFORM DRIVER
>   M:	Eric Auger <eric.auger@redhat.com>
>   L:	kvm@vger.kernel.org
>
>

