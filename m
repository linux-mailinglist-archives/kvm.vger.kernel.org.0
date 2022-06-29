Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A3255F97A
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 09:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiF2HqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 03:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbiF2HqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 03:46:17 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB99238BEB
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 00:46:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=laSKP46PWJZa3q4tlDf5ufbgeF4KTq+GzNrRG99wDbxnHYjtkLD+hxypq4buFpxRa9dxK+JZ3Ukwx3x6ipt/a8EmXoNyGLY27UKycUjU8/kLRgl718lGywSs9RUD7yHNVVZ08EGxhDh9xpF/AbF53Nxdc9+D3Xgyr2dX/flraAr1s0ApjFxtJ+Pjdj2ZZbhc1n6KgUKXKBYGC/KLq3JO45qzVPRP+UPddA8gliUuK9vER8/jnDafwH5A9c/r8MvFuVyLelAEtnVpEVZGHwaUgxJBWYc8XRVjzI0DcEQX4iEEQgsC6x5BgANtkeo7Re72NO8ZE2VOisgV12ivIik8aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZG4p4vmn21hV3lwwJeK+biDq0LO+DS9hTheQi3hb57o=;
 b=efqwuAiDUP/zBU1YGysbZGrmjMxfH7vevGY41HfBZItheagUqo+CIvz7KCvpb6P8MEGVGHCFRv6/1U5yMpnhJ9BpNjDDAx2JnTHLGKsAqhLwnut/0RDKfShGbZ+jG8nOTW4S9/B/VvjYponS/S6Wr1YqmeHH16Iv5jjwqx9tfRMi350X75Ym3B5t97dg4sObCFhFgt9t/NbrlPVuIpSXMwP1qlvlQJ7n0nUPmDXzBN7fK3jmWkLSkTBf8d6ej6GF+j5Gq10Zt4sA7/FjdCEHRGyjd9fesjytsFCpUmXA2UBvGGrDg0Eb0hR9nkpcUfvVBjqmoBcT/lsnO/1ma7Qsyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZG4p4vmn21hV3lwwJeK+biDq0LO+DS9hTheQi3hb57o=;
 b=eWma9qCcRkpH5+aqNxpqBe06o79iWjDqdTt+b8Fb+OIHf2JN0Vfum9u45gBsvLvHNj7PGmNTLY5tl1vVRXDYzi7ZKZRobfjzmSQJ1cCsH5UwrQ3AGt+rD/cO3i2XzagA2Axv0TpEbeAM83PO/b5AqjkfUaIPebVKJpNBTpGf5jQuNrZnhQHDKReg6t4c9FwBRkbmkrCjd7OoAHcAq041cf9FYNUy88719lTcgMI234kZ1cFfya53Ef6EWDqxTfzoDxocbl8rPjxAgqzSxW69gtG3FynwEC5Qf0zjfxotRfXGW+LiF99mWObRaUjPD2fOPWM2Ll1lzCdCaajR0PTgkA==
Received: from BN8PR12CA0009.namprd12.prod.outlook.com (2603:10b6:408:60::22)
 by BL1PR12MB5898.namprd12.prod.outlook.com (2603:10b6:208:396::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Wed, 29 Jun
 2022 07:46:14 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::b) by BN8PR12CA0009.outlook.office365.com
 (2603:10b6:408:60::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Wed, 29 Jun 2022 07:46:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Wed, 29 Jun 2022 07:46:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 29 Jun
 2022 07:46:10 +0000
Received: from [172.27.12.252] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 29 Jun
 2022 00:46:07 -0700
Message-ID: <5811b347-e65b-f8bf-5d7c-a0d04b96bb9d@nvidia.com>
Date:   Wed, 29 Jun 2022 10:46:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH V3 vfio 2/2] vfio: Split migration ops from main device
 ops
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <maorg@nvidia.com>,
        <cohuck@redhat.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>
References: <20220628155910.171454-1-yishaih@nvidia.com>
 <20220628155910.171454-3-yishaih@nvidia.com>
 <20220628141621.54ef59f8.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220628141621.54ef59f8.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67dca7ab-941d-4ae3-5a86-08da59a37142
X-MS-TrafficTypeDiagnostic: BL1PR12MB5898:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q2S4mlXAuUp8D47qUtFQkWkE8V+Yt0rnua07lbE0Q8qVE7mj67uJ4iSkkFk5kWAaSE0K3GB8t9aPlrqixDe69UhLnCSxkgcAfFJeOeU4JXVNrfvkAi1j1hTR82sFqyXGGOQ6fc3y0XOnLCnhzLn9vVsKsbs6r5YoLRLjSbAWMLI3BWxlDOSFxXT2fXwak03iTXN6mWJ/rYeQYYaZkWy9CNeD6b1L6212jU2jSwrUvCAHt5B0nPAnCKIFeYQaEPLd9ZqI/G6D69u9quX9B9a2EEjf51M8rRhs/JesdXSqx8nHc533ZDgEjVdko74T9V1Ej2syMTuXzaNDiRW6X3DwVj/q3VhuWwk3I0BuBQKJ0zTyAnnELkkHAuZTZ2R/kDATrCV72g0O97Xx+5XOpx4subJY2OfYiwN7HunIVPmrjKZkh2qgyFm6eSmvTZDUU2xjbCj/R/2fPv78VqRNcuXRWXoD+9eHGyzfidwEXdV/bXQeNR1/HsrPKxgDRFtwJyYfApIqGihZ4UC6nMjuPxMHqOxL3Dbic9gPyUGqW2+6wgzddtuP81hyp25My4Fw6vK5/Vmv7jAeDhH/kYAYeCXlubUBKPSlEYVEQMiNMPE1lBls5o1rn/WTsnQDW78yOjUOZ5a3kxjU853MiO3yNFHVh1fN75X92UbP+zAZqfXAU99tBUQf4LZRciBMNjD5Koxvww6rYatHMSkATWWqKfBNhiMAT/sZB0W1YzwN+aTeIEEQ/GAqnSYFZEnJhXKwHjZADas9FzQOBQ9hMs6uYd4Ctz/+oC585k5M2AI0Ym1My2M9JGfr46z+SIqAQAO18rPS1ffVcucfk7jhtrABwR/qd+QyzWjYUARShsqSgpkwhsURD/YqA1WOERCdfHsNMb6B
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(136003)(39860400002)(46966006)(36840700001)(40470700004)(6916009)(16576012)(40460700003)(83380400001)(31686004)(26005)(36860700001)(316002)(8676002)(54906003)(4326008)(70586007)(70206006)(5660300002)(31696002)(336012)(2616005)(86362001)(2906002)(356005)(47076005)(53546011)(8936002)(81166007)(186003)(40480700001)(16526019)(478600001)(82310400005)(30864003)(426003)(36756003)(41300700001)(82740400003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 07:46:13.6218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67dca7ab-941d-4ae3-5a86-08da59a37142
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5898
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/06/2022 23:16, Alex Williamson wrote:
> On Tue, 28 Jun 2022 18:59:10 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> vfio core checks whether the driver sets some migration op (e.g.
>> set_state/get_state) and accordingly calls its op.
>>
>> However, currently mlx5 driver sets the above ops without regards to its
>> migration caps.
>>
>> This might lead to unexpected usage/Oops if user space may call to the
>> above ops even if the driver doesn't support migration. As for example,
>> the migration state_mutex is not initialized in that case.
>>
>> The cleanest way to manage that seems to split the migration ops from
>> the main device ops, this will let the driver setting them separately
>> from the main ops when it's applicable.
>>
>> As part of that, validate ops construction on registration and include a
>> check for VFIO_MIGRATION_STOP_COPY since the uAPI claims it must be set
>> in migration_flags.
>>
>> HISI driver was changed as well to match this scheme.
>>
>> This scheme may enable down the road to come with some extra group of
>> ops (e.g. DMA log) that can be set without regards to the other options
>> based on driver caps.
>>
>> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 11 +++++--
>>   drivers/vfio/pci/mlx5/cmd.c                   |  4 ++-
>>   drivers/vfio/pci/mlx5/cmd.h                   |  3 +-
>>   drivers/vfio/pci/mlx5/main.c                  |  9 ++++--
>>   drivers/vfio/pci/vfio_pci_core.c              |  7 +++++
>>   drivers/vfio/vfio.c                           | 11 ++++---
>>   include/linux/vfio.h                          | 30 ++++++++++++-------
>>   7 files changed, 51 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 4def43f5f7b6..ea762e28c1cc 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -1185,7 +1185,7 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>>   	if (ret)
>>   		return ret;
>>   
>> -	if (core_vdev->ops->migration_set_state) {
>> +	if (core_vdev->mig_ops) {
>>   		ret = hisi_acc_vf_qm_init(hisi_acc_vdev);
>>   		if (ret) {
>>   			vfio_pci_core_disable(vdev);
>> @@ -1208,6 +1208,11 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>>   	vfio_pci_core_close_device(core_vdev);
>>   }
>>   
>> +static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_state_ops = {
>> +	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
>> +	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
>> +};
>> +
>>   static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
>>   	.name = "hisi-acc-vfio-pci-migration",
>>   	.open_device = hisi_acc_vfio_pci_open_device,
>> @@ -1219,8 +1224,6 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
>>   	.mmap = hisi_acc_vfio_pci_mmap,
>>   	.request = vfio_pci_core_request,
>>   	.match = vfio_pci_core_match,
>> -	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
>> -	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
>>   };
>>   
>>   static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>> @@ -1272,6 +1275,8 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>>   		if (!ret) {
>>   			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
>>   						  &hisi_acc_vfio_pci_migrn_ops);
>> +			hisi_acc_vdev->core_device.vdev.mig_ops =
>> +					&hisi_acc_vfio_pci_migrn_state_ops;
>>   		} else {
>>   			pci_warn(pdev, "migration support failed, continue with generic interface\n");
>>   			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>> index cdd0c667dc77..dd5d7bfe0a49 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.c
>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>> @@ -108,7 +108,8 @@ void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
>>   	destroy_workqueue(mvdev->cb_wq);
>>   }
>>   
>> -void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
>> +void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
>> +			       const struct vfio_migration_ops *mig_ops)
>>   {
>>   	struct pci_dev *pdev = mvdev->core_device.pdev;
>>   	int ret;
>> @@ -149,6 +150,7 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
>>   	mvdev->core_device.vdev.migration_flags =
>>   		VFIO_MIGRATION_STOP_COPY |
>>   		VFIO_MIGRATION_P2P;
>> +	mvdev->core_device.vdev.mig_ops = mig_ops;
>>   
>>   end:
>>   	mlx5_vf_put_core_dev(mvdev->mdev);
>> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
>> index aa692d9ce656..8208f4701a90 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.h
>> +++ b/drivers/vfio/pci/mlx5/cmd.h
>> @@ -62,7 +62,8 @@ int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
>>   int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
>>   int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
>>   					  size_t *state_size);
>> -void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
>> +void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
>> +			       const struct vfio_migration_ops *mig_ops);
>>   void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
>>   void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
>>   int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> index d754990f0662..a9b63d15c5d3 100644
>> --- a/drivers/vfio/pci/mlx5/main.c
>> +++ b/drivers/vfio/pci/mlx5/main.c
>> @@ -574,6 +574,11 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
>>   	vfio_pci_core_close_device(core_vdev);
>>   }
>>   
>> +static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
>> +	.migration_set_state = mlx5vf_pci_set_device_state,
>> +	.migration_get_state = mlx5vf_pci_get_device_state,
>> +};
>> +
>>   static const struct vfio_device_ops mlx5vf_pci_ops = {
>>   	.name = "mlx5-vfio-pci",
>>   	.open_device = mlx5vf_pci_open_device,
>> @@ -585,8 +590,6 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
>>   	.mmap = vfio_pci_core_mmap,
>>   	.request = vfio_pci_core_request,
>>   	.match = vfio_pci_core_match,
>> -	.migration_set_state = mlx5vf_pci_set_device_state,
>> -	.migration_get_state = mlx5vf_pci_get_device_state,
>>   };
>>   
>>   static int mlx5vf_pci_probe(struct pci_dev *pdev,
>> @@ -599,7 +602,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>>   	if (!mvdev)
>>   		return -ENOMEM;
>>   	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
>> -	mlx5vf_cmd_set_migratable(mvdev);
>> +	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops);
>>   	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
>>   	ret = vfio_pci_core_register_device(&mvdev->core_device);
>>   	if (ret)
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index a0d69ddaf90d..cf875309dac0 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1855,6 +1855,13 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>>   	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>>   		return -EINVAL;
>>   
>> +	if (vdev->vdev.mig_ops) {
>> +		if ((!(vdev->vdev.mig_ops->migration_get_state &&
>> +		       vdev->vdev.mig_ops->migration_set_state)) ||
>> +		    (!(vdev->vdev.migration_flags & VFIO_MIGRATION_STOP_COPY)))
>> +			return -EINVAL;
> A bit excessive on the parenthesis, a logical NOT is just below parens
> and well above a logical OR on order of operations, so it should be
> fine as:
>
> 	if (!(vdev->vdev.mig_ops->migration_get_state &&
> 	      vdev->vdev.mig_ops->migration_set_state) ||
> 	    !(vdev->vdev.migration_flags & VFIO_MIGRATION_STOP_COPY))
> 		return -EINVAL;
>
> Looks ok to me otherwise, so if there are no other changes maybe I can
> roll that in on commit.  Thanks,
>
> Alex

Yes, makes sense,  please change locally.

Yishai

>> +	}
>> +
>>   	/*
>>   	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
>>   	 * by the host or other users.  We cannot capture the VFs if they
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index e22be13e6771..ccbd106b95d8 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -1534,8 +1534,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>>   	struct file *filp = NULL;
>>   	int ret;
>>   
>> -	if (!device->ops->migration_set_state ||
>> -	    !device->ops->migration_get_state)
>> +	if (!device->mig_ops)
>>   		return -ENOTTY;
>>   
>>   	ret = vfio_check_feature(flags, argsz,
>> @@ -1551,7 +1550,8 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>>   	if (flags & VFIO_DEVICE_FEATURE_GET) {
>>   		enum vfio_device_mig_state curr_state;
>>   
>> -		ret = device->ops->migration_get_state(device, &curr_state);
>> +		ret = device->mig_ops->migration_get_state(device,
>> +							   &curr_state);
>>   		if (ret)
>>   			return ret;
>>   		mig.device_state = curr_state;
>> @@ -1559,7 +1559,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>>   	}
>>   
>>   	/* Handle the VFIO_DEVICE_FEATURE_SET */
>> -	filp = device->ops->migration_set_state(device, mig.device_state);
>> +	filp = device->mig_ops->migration_set_state(device, mig.device_state);
>>   	if (IS_ERR(filp) || !filp)
>>   		goto out_copy;
>>   
>> @@ -1582,8 +1582,7 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>>   	};
>>   	int ret;
>>   
>> -	if (!device->ops->migration_set_state ||
>> -	    !device->ops->migration_get_state)
>> +	if (!device->mig_ops)
>>   		return -ENOTTY;
>>   
>>   	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index aa888cc51757..d6c592565be7 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -32,6 +32,11 @@ struct vfio_device_set {
>>   struct vfio_device {
>>   	struct device *dev;
>>   	const struct vfio_device_ops *ops;
>> +	/*
>> +	 * mig_ops is a static property of the vfio_device which must be set
>> +	 * prior to registering the vfio_device.
>> +	 */
>> +	const struct vfio_migration_ops *mig_ops;
>>   	struct vfio_group *group;
>>   	struct vfio_device_set *dev_set;
>>   	struct list_head dev_set_list;
>> @@ -61,16 +66,6 @@ struct vfio_device {
>>    *         match, -errno for abort (ex. match with insufficient or incorrect
>>    *         additional args)
>>    * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
>> - * @migration_set_state: Optional callback to change the migration state for
>> - *         devices that support migration. It's mandatory for
>> - *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
>> - *         The returned FD is used for data transfer according to the FSM
>> - *         definition. The driver is responsible to ensure that FD reaches end
>> - *         of stream or error whenever the migration FSM leaves a data transfer
>> - *         state or before close_device() returns.
>> - * @migration_get_state: Optional callback to get the migration state for
>> - *         devices that support migration. It's mandatory for
>> - *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
>>    */
>>   struct vfio_device_ops {
>>   	char	*name;
>> @@ -87,6 +82,21 @@ struct vfio_device_ops {
>>   	int	(*match)(struct vfio_device *vdev, char *buf);
>>   	int	(*device_feature)(struct vfio_device *device, u32 flags,
>>   				  void __user *arg, size_t argsz);
>> +};
>> +
>> +/**
>> + * @migration_set_state: Optional callback to change the migration state for
>> + *         devices that support migration. It's mandatory for
>> + *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
>> + *         The returned FD is used for data transfer according to the FSM
>> + *         definition. The driver is responsible to ensure that FD reaches end
>> + *         of stream or error whenever the migration FSM leaves a data transfer
>> + *         state or before close_device() returns.
>> + * @migration_get_state: Optional callback to get the migration state for
>> + *         devices that support migration. It's mandatory for
>> + *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
>> + */
>> +struct vfio_migration_ops {
>>   	struct file *(*migration_set_state)(
>>   		struct vfio_device *device,
>>   		enum vfio_device_mig_state new_state);


