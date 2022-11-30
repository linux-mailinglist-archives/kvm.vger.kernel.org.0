Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243EC63D379
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 11:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiK3Kdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 05:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiK3Kd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 05:33:28 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE3B42F6B
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 02:33:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rd3e+64qcsVZBmZiLRaWTEru2naVZCb48/f86zSQT6pad/VybYWPZHS8Zz6Er4iVR2ok+kXMT4a6eut6RGdHzqpZzHJCU/0YHtmXanwlkMyJcxEZCYOLdxxAkzHNCHeXCUUM3CsAeCe/do/KQgR/O2mek03Lzh+SKs8sV8hXSQO61Rd5QW7lJrxcg4UjPG+eCaG9y+TCZ/QCqswOPKHpWbcsvogZnBFReh1ivRIXLuqff5u+xlynh6wgKoXRbeGdp41HzuALe63yPLxrzA3oU55odcHZBr1X4rNRl5YtnolP9T+7IVLyLBzzpyI/2lw4ay2Z/Bqq47rLt2S6WUlJCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wwB7xFVXUu0lXcg0dR9Ft9Ii3YvdqIOmsQQsPQF7H1A=;
 b=mX7CIfTHz7cOjcOSNLO6wriVFsFmc/tRZhYcSSo3S8RbitiVObw3mtyS5tAnPjsf9wqrFqR3e7VCBJ2O4R9BTrV0CiQRzjlHHjM6gtFI74KrkfG0yKj30Pkc9z9SM4bSPPd8k6qx83SlnlEZTESrf2tK/cs1cdCEyGkwjdCU6Ut8aDGtCrtec/iOYnkNIDBbhPrkSzEFe453Hgn8mpFywXUKcjvpBP7yjD6v4S5D/3SDwyvIMgcYBwPmPls8N2KA+intsn4KCaiTShdFPHtrhLQ+gayRm7ERqZDqXDumhPYiOMS4lmIlx4jKUhWUacrtVlH1TNk0+E1JHJTsEm3gEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwB7xFVXUu0lXcg0dR9Ft9Ii3YvdqIOmsQQsPQF7H1A=;
 b=Fja/kT0+Y7rch0pAhqFxfNNqgxsCVqCxwBQ1bBGPKCjlKZhREsWfD4d/TPOX5FZ9Ou3IgOaLhRgcVR/XprVQ68eJs7oRSzGSBtWL644aaWkYxUbEwHLNYxx6bP7f1i2URPshf3rqWhNfptTOHSjO1R+j0sB5y+upZGREXNAMSbrKKT4WL0UgughctlsTbzRE5hAakZBScLk40uSdxyK4f2lFw1Dt8Es6E9tkyUO0BwAargJRuAsE0yu6aTaYykKXlapkSrabvw/PeuumpcwXrf+0KS60CJEUT6iWTnvkGo/qNnouLidcEqhS8M/dnGWhJhoerwsdq63nb5AE25uGSg==
Received: from DS7PR03CA0192.namprd03.prod.outlook.com (2603:10b6:5:3b6::17)
 by IA1PR12MB6185.namprd12.prod.outlook.com (2603:10b6:208:3e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 10:33:25 +0000
Received: from DS1PEPF0000B073.namprd05.prod.outlook.com
 (2603:10b6:5:3b6:cafe::7) by DS7PR03CA0192.outlook.office365.com
 (2603:10b6:5:3b6::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Wed, 30 Nov 2022 10:33:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B073.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Wed, 30 Nov 2022 10:33:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 02:33:10 -0800
Received: from [172.27.11.80] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 02:33:06 -0800
Message-ID: <a3db348a-246f-dbff-7667-e5837ef8be47@nvidia.com>
Date:   Wed, 30 Nov 2022 12:33:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH V1 vfio 00/14] Add migration PRE_COPY support for mlx5
 driver
Content-Language: en-US
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>,
        <cohuck@redhat.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20221124173932.194654-1-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B073:EE_|IA1PR12MB6185:EE_
X-MS-Office365-Filtering-Correlation-Id: f3eedcae-1e08-4e65-e4cd-08dad2be4fc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z1P+KQffjZvm90lX+2MUUkATNLRTONv9N8FTZCatT41Za65TC15UPLKKuUEmir0+VnDRALKdRZi/MuiI0t0gpwDdlvYvET/oTGFJ/vyWkN/doaCk2Nabl0rFEoAMD+Sb0qwqvz5RSDJgNJYVOtMcWF5lLHVys50oNyExJrMrEFLJNYf4/4N8wlRg77eWzu+ot8O0WVf/c9T+fd9DhqKTYe9K3gZ1XrBshic8QQ2C0CwIS1DwiKegyvd7HdjbOwME8H3ROwS2tBIPEaOXjfJx/Cxg48fHFtiwkQb0nZgNUjE+WurjRTBF13VqrYN+62y8Sg4GS/foIb+rz5uOFuZQNUbrwws1sddQ3ag2XQttYAaCxOE+MB0yGfJnNv+jJLYvP9cJA1d0Y6UgXCRsNS6S/sOu3GJSLpZLCKWL5Oy6pp71HfKLy3aFCxRQt5m9kHr8HwNH5aRYgGlV5wDE+IDMaFVec6NxWFQGLo+z1YlIBxEHae3mIldhhh/Pw2NgRw6/daxgJ3gzVPSlwoHqV5dukXIn+9MY8hiblx9svf0v6kQQcsVnIhhMyMbxnv5WBwWqqoeilCBavXCU/WIn3sgIpRlNubJhXQYTET76Jx/1j5UFUw2RJqvuXI5g5EMCm9voiLbp0qwzV4oiIn0sh9kmYH4bb5xY8zD9EcdbTQBYgvA78Fg+0U57EA1t2WC9cCwRo73JLnk/8piJbDld+UJydY0XiP5ENTdcY/tpxRqeb6In0vpYFpeC6Xn0T/lY1ESSV5sMNq+JxDB6Pfle9Uu+qGSi9bud0FDjhFXdvc2S4YWlVCHGPwUpS143eQvrj+hz8k2+h7jmWem0BvJYDm/PZ2LwcH0Hl1/dHmLiDwyzlpw=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199015)(46966006)(36840700001)(40470700004)(53546011)(82740400003)(26005)(5660300002)(478600001)(31686004)(16576012)(6636002)(54906003)(36860700001)(16526019)(336012)(186003)(47076005)(426003)(2616005)(36756003)(316002)(7636003)(356005)(966005)(83380400001)(70206006)(8676002)(70586007)(86362001)(82310400005)(41300700001)(4326008)(40460700003)(40480700001)(110136005)(2906002)(8936002)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 10:33:24.8903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3eedcae-1e08-4e65-e4cd-08dad2be4fc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B073.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6185
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/11/2022 19:39, Yishai Hadas wrote:
> This series adds migration PRE_COPY uAPIs and their implementation as
> part of mlx5 driver.
>
> The uAPIs follow some discussion that was done in the mailing list [1]
> in this area.
>
> By the time the patches were sent, there was no driver implementation
> for the uAPIs, now we have it for mlx5 driver.
>
> The optional PRE_COPY state opens the saving data transfer FD before
> reaching STOP_COPY and allows the device to dirty track the internal
> state changes with the general idea to reduce the volume of data
> transferred in the STOP_COPY stage.
>
> While in PRE_COPY the device remains RUNNING, but the saving FD is open.
>
> A new ioctl VFIO_MIG_GET_PRECOPY_INFO is provided to allow userspace to
> query the progress of the precopy operation in the driver with the idea
> it will judge to move to STOP_COPY at least once the initial data set is
> transferred, and possibly after the dirty size has shrunk appropriately.
>
> User space can detect whether PRE_COPY is supported for a given device
> by checking the VFIO_MIGRATION_PRE_COPY flag once using the
> VFIO_DEVICE_FEATURE_MIGRATION ioctl.
>
> Extra details exist as part of the specific uAPI patch from the series.
>
> Finally, we come with mlx5 implementation based on its device
> specification for PRE_COPY.
>
> To support PRE_COPY, mlx5 driver is transferring multiple states
> (images) of the device. e.g.: the source VF can save and transfer
> multiple states, and the target VF will load them by that order.
>
> The device is saving three kinds of states:
> 1) Initial state - when the device moves to PRE_COPY state.
> 2) Middle state - during PRE_COPY phase via VFIO_MIG_GET_PRECOPY_INFO,
>                    can be multiple such states.
> 3) Final state - when the device moves to STOP_COPY state.
>
> After moving to PRE_COPY state, the user is holding the saving FD and
> should use it for transferring the data from the source to the target
> while the VM is still running. From user point of view, it's a stream of
> data, however, from mlx5 driver point of view it includes multiple
> images/states. For that, it sets some headers with metadata on the
> source to be parsed on the target.
>
> At some point, user may switch the device state from PRE_COPY to
> STOP_COPY, this will invoke saving of the final state.
>
> As discussed earlier in the mailing list, the data that is returned as
> part of PRE_COPY is not required to have any bearing relative to the
> data size available during the STOP_COPY phase.
>
> For this, we have the VFIO_DEVICE_FEATURE_MIG_DATA_SIZE option.
>
> In mlx5 driver we could gain with this series about 20-30 percent
> improvement in the downtime compared to the previous code when PRE_COPY
> wasn't supported.
>
> The series includes some pre-patches to be ready for managing multiple
> images then it comes with the PRE_COPY implementation itself.
>
> The matching qemu changes can be previewed here [2].
>
> They come on top of the v2 migration protocol patches that were sent
> already to the mailing list.
>
> Note:
> As this series includes a net/mlx5 patch, we may need to send it as a
> pull request format to VFIO to avoid conflicts before acceptance.
>
> [1] https://lore.kernel.org/kvm/20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com/
> [2] https://github.com/avihai1122/qemu/commits/mig_v2_precopy
>
> Changes from V0: https://www.spinics.net/lists/kvm/msg294247.html
>
> Drop the first 2 patches that Alex merged already.
> Refactor mlx5 implementation based on Jason's comments on V0, it includes
> the below:
> * Refactor the PD usage to be aligned with the migration file life cycle.
> * Refactor the MKEY usage to be aligned with the migration file life cycle.
> * Refactor the migration file state.
> * Use queue based data chunks to simplify the driver code.
> * Use the FSM model on the target to simplify the driver code.
> * Extend the driver pre_copy header for future use.
>
> Yishai
>
>
> Jason Gunthorpe (1):
>    vfio: Extend the device migration protocol with PRE_COPY
>
> Shay Drory (3):
>    net/mlx5: Introduce ifc bits for pre_copy
>    vfio/mlx5: Fallback to STOP_COPY upon specific PRE_COPY error
>    vfio/mlx5: Enable MIGRATION_PRE_COPY flag
>
> Yishai Hadas (10):
>    vfio/mlx5: Enforce a single SAVE command at a time
>    vfio/mlx5: Refactor PD usage
>    vfio/mlx5: Refactor MKEY usage
>    vfio/mlx5: Refactor migration file state
>    vfio/mlx5: Refactor to use queue based data chunks
>    vfio/mlx5: Introduce device transitions of PRE_COPY
>    vfio/mlx5: Introduce SW headers for migration states
>    vfio/mlx5: Introduce vfio precopy ioctl implementation
>    vfio/mlx5: Consider temporary end of stream as part of PRE_COPY
>    vfio/mlx5: Introduce multiple loads
>
>   drivers/vfio/pci/mlx5/cmd.c   | 408 ++++++++++++++----
>   drivers/vfio/pci/mlx5/cmd.h   |  93 ++++-
>   drivers/vfio/pci/mlx5/main.c  | 750 ++++++++++++++++++++++++++++------
>   drivers/vfio/vfio_main.c      |  74 +++-
>   include/linux/mlx5/mlx5_ifc.h |  14 +-
>   include/uapi/linux/vfio.h     | 122 +++++-
>   6 files changed, 1241 insertions(+), 220 deletions(-)
>
Hi Alex,

Any comments on V1 ? I would like to send V2 very soon with a small fix 
that was found in patch #9 (see my note in the list).

As no comments were published on the UAPI patch so far and the other 
code is mlx5 driver specific, I believe that V2 can be a merge candidate.

Let's try to complete review soon so that we can send a PR for the first 
net/mlx5 patch, the others should go later on via the vfio tree.

By that, we can have in kernel 6.2 feature complete for migration V2 in 
the UAPI area that were in V1 and we can focus on completing the QEMU side.

Thanks,
Yishai

