Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B98360CF6E
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 16:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbiJYOoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 10:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbiJYOoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 10:44:02 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC31D180277
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 07:44:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGzffGGUfslX8c/6JvRlnKc9O5kFz3Pa6MPYiu0pK4GWMilnsNsPG5PG5Og/DNvdE22VHkrfKTLVDiMSEaDm4wcMVgp9rypWxMW1mzfRKdRf8exGsayD8ZAqif89Z5dJYXJ5liDGLR2T4WqpkmxMP5maaPajSKHsNyiHPY95RDPPw7upEb3fqojwa9c6gUR6aJl3m6JBKYCFmmb8yRzs9O1EUFJdVD5Km6RHezGtQ9jShiEYS6YCvqQO349zK4CgmTyr/yHvqj3G8whuYTqOWyEAaxD3LkOUULNHPfKDtao4tUX2lKqUnHawQh/cwIq5bGbmX1NMv+HvTUzF1Cn4/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yedv/ahxFjdRHcSCyK3EGo1j3cAnh8nsjbuj16G5AoY=;
 b=Gis/fqkvvaW6OwcYNx+V6Yy04MkT2qs0KhuHyyNSnMS05uw2jcOAotLDch3YO5LxgN3V9eENFgltNQxKk5z5SYTzT5cNxofv1K8mFigdpnQvLSxaR9p75qPiujdJAIrEualA7KB6VxLgg6Z5bySuNeGICbQC5NeKEz3Mxh45soZhQrzXfEvdUcdtwxdsXzyV0uYA7AmZnzHwv0F+JFrXovgDA3Jwk5CMSkLgdFxR2dL68FDvnWaIZFNF6I4qcJes4Q1K0uhbsSDL60/s10AKyUrV426V3CVZfro7PQNY2YdO+TvYGRnQpy0qluzMD65xTKY6eUKxvHj3rhBUTTSWaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yedv/ahxFjdRHcSCyK3EGo1j3cAnh8nsjbuj16G5AoY=;
 b=DdPFeMLTTHHrcZnEZTtxPqex4/F//1wc0PZAyINyoaqnynO/3ysjQpOfppzv1HHv/gD+S/CDKtzOqez46E9NNvvXV2vrH49Y9sSsPG5TvCAyXGk2stGp4F7aIBBZmnHhHm5fV8dTUVpKio9byMZdwRtHzDzKeFyLxKUgc/+6jhWj68i6+1UoMG8/EQ2/A0+S2eZs0SireKDZQXZ2MebXT8BfraYhUgyL6UmnpFNKQ2UxUH2bzLOWA4ZK4bRagRBzQd3/hGzge3IW8i0OVN0bJkFmfJtdQ9BgplXM+VmyLzViQ1wrfNpCF+4okJLw4ZPoicjpiwJ5asOSOEYJFUYivg==
Received: from BN0PR03CA0050.namprd03.prod.outlook.com (2603:10b6:408:e7::25)
 by SA3PR12MB7951.namprd12.prod.outlook.com (2603:10b6:806:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 14:43:59 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::6e) by BN0PR03CA0050.outlook.office365.com
 (2603:10b6:408:e7::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.27 via Frontend
 Transport; Tue, 25 Oct 2022 14:43:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Tue, 25 Oct 2022 14:43:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 25 Oct
 2022 07:43:49 -0700
Received: from [10.80.22.245] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 25 Oct
 2022 07:43:46 -0700
Message-ID: <a4add7ee-cd07-b931-c1d7-803201b7e037@nvidia.com>
Date:   Tue, 25 Oct 2022 17:43:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] vfio: Add an option to get migration data size
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <quintela@redhat.com>, <kvm@vger.kernel.org>,
        <liulongfang@huawei.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kuba@kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
References: <20221020132109.112708-1-yishaih@nvidia.com>
 <20221025070400.5ea5f7e0.alex.williamson@redhat.com>
Content-Language: en-US
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20221025070400.5ea5f7e0.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT005:EE_|SA3PR12MB7951:EE_
X-MS-Office365-Filtering-Correlation-Id: 737489cb-34c0-4c93-c048-08dab69759ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OjV/e2W8N8swftcf8rvsiVfedKdWDOH03IlT+F8M9Jcma6o/X2i+AStoucSoXvZlfk2l0Vet9LSZwBdB+vjWpzSJLe39EKRwJ+ogJgv2yocn1DMhmB6o1yBpEmBv0vjQRmXVLcmOHGjg+8JYWhnFGLBJJiCW2/TWJV2POapl7N0mzLjhm0k4spECQzGzVPl427N/LQ9OjqK5ULLSwX//rwfcGuQk/o3jFv620ifDclMqlGDEJmvPa1K3Gv3FigNoSCqdaVKX6C65s/JWXAnASlX3ldh39A/cgRYsCYdpVdhmvdbV1IdA1f8o2AdcuBoqH/QXuCtk6AgGnjE21UynvR7rdql3MRv6HF8M+LlOMckotjUTO/2fgTlBaSQzTmDyY5U8z/+RHIdzuDKl13OMYMjMS7QnHBf52X7AzxGrYVN28und8NsX45TTzs2Do/kHEOHqmwkDhliM9MX+H8e/AeWCQO/5qvJUEhUd3G3B9QLEICtQYVhSs3Kes7W6KCKlHyhOtQ/uIoR2qTFxSo14i0iPPhW18+hyZgNngCAGHWgBYpNorP525j2ldwU7ybIj6GmkNTbgzMch3hjqPosR21ogLaB+5QYi0fXeCCmFAYn0gkNYNq6l7kSN5f5RbvuMIoVQKDi3d29bD4fDCYs/0WAPWNgol/K6f+1MuHJEUBG9U0Dr3HmS6wUYE2IrIjmw03tW0V/GEEn5jOAudpmEWn92uNYptddpBxwhn24zjOwxWCZG3e1fsEJ7O3HCJOXbVhfVATvJJIwUWK/SBm6YnJmroUXv3Fj1+TOEMw4cngEYyVZKceJLqYKMTXmhb4vu
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199015)(40470700004)(36840700001)(46966006)(478600001)(53546011)(41300700001)(7636003)(356005)(186003)(82740400003)(36860700001)(31696002)(86362001)(40480700001)(5660300002)(54906003)(2616005)(26005)(6916009)(47076005)(16576012)(2906002)(8936002)(36756003)(316002)(16526019)(426003)(83380400001)(82310400005)(70586007)(31686004)(70206006)(8676002)(4326008)(40460700003)(336012)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:43:58.9032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 737489cb-34c0-4c93-c048-08dab69759ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7951
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2022 16:04, Alex Williamson wrote:
> On Thu, 20 Oct 2022 16:21:09 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> Add an option to get migration data size by introducing a new migration
>> feature named VFIO_DEVICE_FEATURE_MIG_DATA_SIZE.
>>
>> Upon VFIO_DEVICE_FEATURE_GET the estimated data length that will be
>> required to complete STOP_COPY is returned.
>>
>> This option may better enable user space to consider before moving to
>> STOP_COPY whether it can meet the downtime SLA based on the returned
>> data.
>>
>> The patch also includes the implementation for mlx5 and hisi for this
>> new option to make it feature complete for the existing drivers in this
>> area.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  9 ++++++
>>   drivers/vfio/pci/mlx5/main.c                  | 18 +++++++++++
>>   drivers/vfio/vfio_main.c                      | 32 +++++++++++++++++++
>>   include/linux/vfio.h                          |  5 +++
>>   include/uapi/linux/vfio.h                     | 13 ++++++++
>>   5 files changed, 77 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 39eeca18a0f7..0c0c0c7f0521 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -957,6 +957,14 @@ hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
>>   	return res;
>>   }
>>   
>> +static int
>> +hisi_acc_vfio_pci_get_data_size(struct vfio_device *vdev,
>> +				unsigned long *stop_copy_length)
>> +{
>> +	*stop_copy_length = sizeof(struct acc_vf_data);
>> +	return 0;
>> +}
>> +
>>   static int
>>   hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>>   				   enum vfio_device_mig_state *curr_state)
>> @@ -1213,6 +1221,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>>   static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_state_ops = {
>>   	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
>>   	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
>> +	.migration_get_data_size = hisi_acc_vfio_pci_get_data_size,
>>   };
>>   
>>   static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> index fd6ccb8454a2..4c7a39ffd247 100644
>> --- a/drivers/vfio/pci/mlx5/main.c
>> +++ b/drivers/vfio/pci/mlx5/main.c
>> @@ -512,6 +512,23 @@ mlx5vf_pci_set_device_state(struct vfio_device *vdev,
>>   	return res;
>>   }
>>   
>> +static int mlx5vf_pci_get_data_size(struct vfio_device *vdev,
>> +				    unsigned long *stop_copy_length)
>> +{
>> +	struct mlx5vf_pci_core_device *mvdev = container_of(
>> +		vdev, struct mlx5vf_pci_core_device, core_device.vdev);
>> +	size_t state_size;
>> +	int ret;
>> +
>> +	mutex_lock(&mvdev->state_mutex);
>> +	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
>> +						    &state_size);
>> +	if (!ret)
>> +		*stop_copy_length = state_size;
>> +	mlx5vf_state_mutex_unlock(mvdev);
>> +	return ret;
>> +}
>> +
>>   static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
>>   				       enum vfio_device_mig_state *curr_state)
>>   {
>> @@ -577,6 +594,7 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
>>   static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
>>   	.migration_set_state = mlx5vf_pci_set_device_state,
>>   	.migration_get_state = mlx5vf_pci_get_device_state,
>> +	.migration_get_data_size = mlx5vf_pci_get_data_size,
>>   };
>>   
>>   static const struct vfio_log_ops mlx5vf_pci_log_ops = {
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index 2d168793d4e1..b118e7b1bc59 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -1256,6 +1256,34 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>>   	return 0;
>>   }
>>   
>> +static int
>> +vfio_ioctl_device_feature_migration_data_size(struct vfio_device *device,
>> +					      u32 flags, void __user *arg,
>> +					      size_t argsz)
>> +{
>> +	struct vfio_device_feature_mig_data_size data_size = {};
>> +	unsigned long stop_copy_length;
>> +	int ret;
>> +
>> +	if (!device->mig_ops)
>> +		return -ENOTTY;
>> +
>> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
>> +				 sizeof(data_size));
>> +	if (ret != 1)
>> +		return ret;
>> +
>> +	ret = device->mig_ops->migration_get_data_size(device, &stop_copy_length);
>> +	if (ret)
>> +		return ret;
>> +
>> +	data_size.stop_copy_length = stop_copy_length;
>> +	if (copy_to_user(arg, &data_size, sizeof(data_size)))
>> +		return -EFAULT;
>> +
>> +	return 0;
>> +}
>> +
>>   static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>>   					       u32 flags, void __user *arg,
>>   					       size_t argsz)
>> @@ -1483,6 +1511,10 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>>   		return vfio_ioctl_device_feature_logging_report(
>>   			device, feature.flags, arg->data,
>>   			feature.argsz - minsz);
>> +	case VFIO_DEVICE_FEATURE_MIG_DATA_SIZE:
>> +		return vfio_ioctl_device_feature_migration_data_size(
>> +			device, feature.flags, arg->data,
>> +			feature.argsz - minsz);
>>   	default:
>>   		if (unlikely(!device->ops->device_feature))
>>   			return -EINVAL;
>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index e7cebeb875dd..5509451ae709 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -107,6 +107,9 @@ struct vfio_device_ops {
>>    * @migration_get_state: Optional callback to get the migration state for
>>    *         devices that support migration. It's mandatory for
>>    *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
>> + * @migration_get_data_size: Optional callback to get the estimated data
>> + *          length that will be required to complete stop copy. It's mandatory for
>> + *          VFIO_DEVICE_FEATURE_MIGRATION migration support.
>>    */
> This is listed as an optional callback, but we call it
> deterministically and there's no added check like there is for
> set/get_state in vfio_pci_core_register_device().  Thanks,

Right,

We may add as part of V1 the below chunk.

diff --git a/drivers/vfio/pci/vfio_pci_core.c 
b/drivers/vfio/pci/vfio_pci_core.c
index badc9d828cac..4d97ca66ba6c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2128,7 +2128,8 @@ int vfio_pci_core_register_device(struct 
vfio_pci_core_device *vdev)

         if (vdev->vdev.mig_ops) {
                 if (!(vdev->vdev.mig_ops->migration_get_state &&
- vdev->vdev.mig_ops->migration_set_state) ||
+ vdev->vdev.mig_ops->migration_set_state &&
+ vdev->vdev.mig_ops->migration_get_data_size) ||
                     !(vdev->vdev.migration_flags & 
VFIO_MIGRATION_STOP_COPY))
                         return -EINVAL;
         }

Yishai

> Alex
>
>
>>   struct vfio_migration_ops {
>>   	struct file *(*migration_set_state)(
>> @@ -114,6 +117,8 @@ struct vfio_migration_ops {
>>   		enum vfio_device_mig_state new_state);
>>   	int (*migration_get_state)(struct vfio_device *device,
>>   				   enum vfio_device_mig_state *curr_state);
>> +	int (*migration_get_data_size)(struct vfio_device *device,
>> +				       unsigned long *stop_copy_length);
>>   };
>>   
>>   /**
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index d7d8e0922376..3e45dbaf190e 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1128,6 +1128,19 @@ struct vfio_device_feature_dma_logging_report {
>>   
>>   #define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 8
>>   
>> +/*
>> + * Upon VFIO_DEVICE_FEATURE_GET read back the estimated data length that will
>> + * be required to complete stop copy.
>> + *
>> + * Note: Can be called on each device state.
>> + */
>> +
>> +struct vfio_device_feature_mig_data_size {
>> +	__aligned_u64 stop_copy_length;
>> +};
>> +
>> +#define VFIO_DEVICE_FEATURE_MIG_DATA_SIZE 9
>> +
>>   /* -------- API for Type1 VFIO IOMMU -------- */
>>   
>>   /**


