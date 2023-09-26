Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58717AEB20
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 13:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjIZLOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 07:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjIZLOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 07:14:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAF1E5
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 04:14:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcXAGDN6NnwUtLhuDJFzJl3gZu3w4Y+03xOrL4/s8z12tAGNPBMaVF1p6GhrL7ye7jo4M5q6SujGBY+YodeNGGkxUCB5AsSz2bF6Y+UtcnWH9DZJcpieCYcKgl+/h9pHH8Id9iZnqSZiVpPvaQ84WN/LUxiLtAMw6BRAlYwXG+cH3eOdcI75GB1mlPZC+t+Ra1ubv3E3dwJzhpFyFZh8zaDppiMZ7hIr0n7/2bsYz4CrjmNUGY0MUkK7X1HDBBm3L3qsFVOp4CzSJyED7Yvdz7skrQ3X2iqiQZoE5aw6kQGq7ecw8qZuMWbzjsOZWJuW+cUOixvU2EbepssIPQy2lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RL9GakccGJxJF6Kd236M0en00zFcN1koXsW5TfbJsWM=;
 b=NTEoCDBIgz2uqHZKRlwQXVaoB03bnylBH2gO5dzGXkJppqQH47BoB2Vs6xXnd1AJ+1YbLsfVTkNUExeb7AZIKnVEuzxQ5gZgLgq7QuxGwdVglMPeOB2GuXK4RviJ2V13wlV0A1HM5ixSQSllVU9YgNGsCVE9XnkpYyR288MGDCiX0gdXLgwqYbr7+K4PVc5ZM2w7fdPsQAwSqjGBRkOHk9Kb1nDM8JpPcq6lFzax9ciYcoDOXVFpPhgv4H6/ysBvtSDVbP0s+RrPhyE8sa/4coGCsBL8UmBAqcJwGkck/NM+6u4mCCGVG5PmBo95QU/8yz7nWU1k9U1aieJIJvK8rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RL9GakccGJxJF6Kd236M0en00zFcN1koXsW5TfbJsWM=;
 b=AWWeL1W2lYQ1x3gFRjOe1NIH7l3mEPJBejYF7zjXj8FXb+jduFtZ/XvBTTmplmK5TH4zqQu57XOTWg13G9S9FsxKqTKGhfRZ9ljFto6uHJeFyt75xFTpIPCCAA1kulzdUunuyT7FwaX83X+xCsQJ6lohx4xekjArxvVUYyDowwGRuSB5Z8Ex0BLdCQ+LKGwdSd7b2n6kYgGwIMfKnStxDcBI6hDV5aqFEL+ZeO/ity3Cog3aApez6l806rvs1ctIe5DhMrMf40XfqfT8qWhiur8+1A8pFwS/X2fk04J4KxbtJkgySvAJpelTc4E+UuPKl3g31UYxkWRUuLgjxQgvTQ==
Received: from BL0PR03CA0006.namprd03.prod.outlook.com (2603:10b6:208:2d::19)
 by MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.19; Tue, 26 Sep
 2023 11:14:24 +0000
Received: from BL6PEPF0001AB4D.namprd04.prod.outlook.com
 (2603:10b6:208:2d:cafe::39) by BL0PR03CA0006.outlook.office365.com
 (2603:10b6:208:2d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.35 via Frontend
 Transport; Tue, 26 Sep 2023 11:14:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB4D.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Tue, 26 Sep 2023 11:14:24 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 26 Sep
 2023 04:14:07 -0700
Received: from [172.27.13.90] (10.126.231.35) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 26 Sep
 2023 04:14:03 -0700
Message-ID: <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
Date:   Tue, 26 Sep 2023 14:14:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over virtio
 device
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <alex.williamson@redhat.com>, <jasowang@redhat.com>,
        <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
        <feliu@nvidia.com>, <jiri@nvidia.com>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <maorg@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20230922055336-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail202.nvidia.com (10.129.68.7)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4D:EE_|MN0PR12MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: ab7b7945-f824-4cc6-ea95-08dbbe81bdca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6t8YCNpbU23fvoh23q/8mBZN1II5KPIJmWPbTHI1Z8922TEZeOr+SThDN0Tw5PyucSkb10NwcI7T8fv9Wj4LxzU68TpozrNmwSQpDNarMcELtNOkmBkhCR9dyeUY4S7zso9knJof4TB1T8IlE912Jky4MBeB/5Eh7BuZu9W/PRlSGrEQ49qGCLRV8rxNTd4OmY2XL2O4Glw90VOG8mGtfasIpSaFR8MhnKCB8Xxggvaldsj+W7tXA2CCFVwKI33OQvaO+hJdxR7oIs6zhW2stueanC8ukkUjxY929VjWcbd1iIQf/aOOZMTPPFYBW/WKq1HG9DIXbz94TThfnxng0BhCjw8RVe6Y8/9sjbDIJYub5digZt0gKh4R9VP2gKmU6jxlugktbyfbVr4RVXSqZQk282cUDbw61vZm0E0HcjTIUnv+jEol2+hXXeVFMyIszLIKi1R3oHEisaP2vOXFKnsSySeUEzsSiG40smxUw3W+IG+ZzV0Tp7xiRWgiEUUyxrDhC+p0dvT8Z8ibK1mhVQIw9LbQefhGynHeuNCVkJI08yPZhe1yUgjpcSsZ/Ehd7VPaxYbt216rXRAbQP4J/buOQyhRpXrFrv2dz8VrrOOSVv+lPj1T8NJZkgan5baXa40k9Z9+JBgNYxu5+xu0aB+GWX0qsdbOa7pGKbRsFiKKO6QDr7F1E7V8eZ8Nm5KPZHEL83m6N0T6ILNgZkRakS5hvQbh295TnK2erM/VN6eWVZ5VwdVIrXF5KBKYVY6Thmwu8o5t02myDgnbj91dzIOhsh6IaerKXCWcdTHsdb8O9QEkmxWE/d3/raqqpCRR
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(376002)(39860400002)(136003)(230922051799003)(82310400011)(1800799009)(451199024)(186009)(36840700001)(40470700004)(46966006)(53546011)(478600001)(83380400001)(8676002)(70586007)(70206006)(54906003)(31686004)(966005)(8936002)(16576012)(6916009)(316002)(356005)(16526019)(36756003)(5660300002)(107886003)(40460700003)(26005)(2616005)(4326008)(36860700001)(31696002)(82740400003)(426003)(40480700001)(86362001)(47076005)(336012)(41300700001)(2906002)(7636003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 11:14:24.5432
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7b7945-f824-4cc6-ea95-08dbbe81bdca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL6PEPF0001AB4D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5979
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/2023 12:54, Michael S. Tsirkin wrote:
> On Thu, Sep 21, 2023 at 03:40:39PM +0300, Yishai Hadas wrote:
>> Expose admin commands over the virtio device, to be used by the
>> vfio-virtio driver in the next patches.
>>
>> It includes: list query/use, legacy write/read, read notify_info.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>
> This stuff is pure virtio spec. I think it should live under
> drivers/virtio, too.

The motivation to put it in the vfio layer was from the below main reasons:

1) Having it inside virtio may require to export a symbol/function per 
command.

    This will end up today by 5 and in the future (e.g. live migration) 
with much more exported symbols.

    With current code we export only 2 generic symbols 
virtio_pci_vf_get_pf_dev(), virtio_admin_cmd_exec() which may fit for 
any further extension.

2) For now there is no logic in this vfio layer, however, in the future 
we may have some DMA/other logic that should better fit to the 
caller/client layer (i.e. vfio).

By the way, this follows what was done already between vfio/mlx5 to 
mlx5_core modules where mlx5_core exposes generic APIs to execute a 
command and to get the a PF from a given mlx5 VF.

This way, we can enable further commands to be added/extended 
easily/cleanly.

See for example here [1, 2].

[1] 
https://elixir.bootlin.com/linux/v6.6-rc3/source/drivers/vfio/pci/mlx5/cmd.c#L210

[2] 
https://elixir.bootlin.com/linux/v6.6-rc3/source/drivers/vfio/pci/mlx5/cmd.c#L683

Yishai

>
>> ---
>>   drivers/vfio/pci/virtio/cmd.c | 146 ++++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/virtio/cmd.h |  27 +++++++
>>   2 files changed, 173 insertions(+)
>>   create mode 100644 drivers/vfio/pci/virtio/cmd.c
>>   create mode 100644 drivers/vfio/pci/virtio/cmd.h
>>
>> diff --git a/drivers/vfio/pci/virtio/cmd.c b/drivers/vfio/pci/virtio/cmd.c
>> new file mode 100644
>> index 000000000000..f068239cdbb0
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/cmd.c
>> @@ -0,0 +1,146 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>> +/*
>> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>> + */
>> +
>> +#include "cmd.h"
>> +
>> +int virtiovf_cmd_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
>> +{
>> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>> +	struct scatterlist out_sg;
>> +	struct virtio_admin_cmd cmd = {};
>> +
>> +	if (!virtio_dev)
>> +		return -ENOTCONN;
>> +
>> +	sg_init_one(&out_sg, buf, buf_size);
>> +	cmd.opcode = VIRTIO_ADMIN_CMD_LIST_QUERY;
>> +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
>> +	cmd.result_sg = &out_sg;
>> +
>> +	return virtio_admin_cmd_exec(virtio_dev, &cmd);
>> +}
>> +
>> +int virtiovf_cmd_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
>> +{
>> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>> +	struct scatterlist in_sg;
>> +	struct virtio_admin_cmd cmd = {};
>> +
>> +	if (!virtio_dev)
>> +		return -ENOTCONN;
>> +
>> +	sg_init_one(&in_sg, buf, buf_size);
>> +	cmd.opcode = VIRTIO_ADMIN_CMD_LIST_USE;
>> +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
>> +	cmd.data_sg = &in_sg;
>> +
>> +	return virtio_admin_cmd_exec(virtio_dev, &cmd);
>> +}
>> +
>> +int virtiovf_cmd_lr_write(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
>> +			  u8 offset, u8 size, u8 *buf)
>> +{
>> +	struct virtio_device *virtio_dev =
>> +		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
>> +	struct virtio_admin_cmd_data_lr_write *in;
>> +	struct scatterlist in_sg;
>> +	struct virtio_admin_cmd cmd = {};
>> +	int ret;
>> +
>> +	if (!virtio_dev)
>> +		return -ENOTCONN;
>> +
>> +	in = kzalloc(sizeof(*in) + size, GFP_KERNEL);
>> +	if (!in)
>> +		return -ENOMEM;
>> +
>> +	in->offset = offset;
>> +	memcpy(in->registers, buf, size);
>> +	sg_init_one(&in_sg, in, sizeof(*in) + size);
>> +	cmd.opcode = opcode;
>> +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
>> +	cmd.group_member_id = virtvdev->vf_id + 1;
>> +	cmd.data_sg = &in_sg;
>> +	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
>> +
>> +	kfree(in);
>> +	return ret;
>> +}
>> +
>> +int virtiovf_cmd_lr_read(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
>> +			 u8 offset, u8 size, u8 *buf)
>> +{
>> +	struct virtio_device *virtio_dev =
>> +		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
>> +	struct virtio_admin_cmd_data_lr_read *in;
>> +	struct scatterlist in_sg, out_sg;
>> +	struct virtio_admin_cmd cmd = {};
>> +	int ret;
>> +
>> +	if (!virtio_dev)
>> +		return -ENOTCONN;
>> +
>> +	in = kzalloc(sizeof(*in), GFP_KERNEL);
>> +	if (!in)
>> +		return -ENOMEM;
>> +
>> +	in->offset = offset;
>> +	sg_init_one(&in_sg, in, sizeof(*in));
>> +	sg_init_one(&out_sg, buf, size);
>> +	cmd.opcode = opcode;
>> +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
>> +	cmd.data_sg = &in_sg;
>> +	cmd.result_sg = &out_sg;
>> +	cmd.group_member_id = virtvdev->vf_id + 1;
>> +	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
>> +
>> +	kfree(in);
>> +	return ret;
>> +}
>> +
>> +int virtiovf_cmd_lq_read_notify(struct virtiovf_pci_core_device *virtvdev,
>> +				u8 req_bar_flags, u8 *bar, u64 *bar_offset)
>> +{
>> +	struct virtio_device *virtio_dev =
>> +		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
>> +	struct virtio_admin_cmd_notify_info_result *out;
>> +	struct scatterlist out_sg;
>> +	struct virtio_admin_cmd cmd = {};
>> +	int ret;
>> +
>> +	if (!virtio_dev)
>> +		return -ENOTCONN;
>> +
>> +	out = kzalloc(sizeof(*out), GFP_KERNEL);
>> +	if (!out)
>> +		return -ENOMEM;
>> +
>> +	sg_init_one(&out_sg, out, sizeof(*out));
>> +	cmd.opcode = VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO;
>> +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
>> +	cmd.result_sg = &out_sg;
>> +	cmd.group_member_id = virtvdev->vf_id + 1;
>> +	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
>> +	if (!ret) {
>> +		struct virtio_admin_cmd_notify_info_data *entry;
>> +		int i;
>> +
>> +		ret = -ENOENT;
>> +		for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
>> +			entry = &out->entries[i];
>> +			if (entry->flags == VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END)
>> +				break;
>> +			if (entry->flags != req_bar_flags)
>> +				continue;
>> +			*bar = entry->bar;
>> +			*bar_offset = le64_to_cpu(entry->offset);
>> +			ret = 0;
>> +			break;
>> +		}
>> +	}
>> +
>> +	kfree(out);
>> +	return ret;
>> +}
>> diff --git a/drivers/vfio/pci/virtio/cmd.h b/drivers/vfio/pci/virtio/cmd.h
>> new file mode 100644
>> index 000000000000..c2a3645f4b90
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/cmd.h
>> @@ -0,0 +1,27 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>> +/*
>> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
>> + */
>> +
>> +#ifndef VIRTIO_VFIO_CMD_H
>> +#define VIRTIO_VFIO_CMD_H
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/virtio.h>
>> +#include <linux/vfio_pci_core.h>
>> +#include <linux/virtio_pci.h>
>> +
>> +struct virtiovf_pci_core_device {
>> +	struct vfio_pci_core_device core_device;
>> +	int vf_id;
>> +};
>> +
>> +int virtiovf_cmd_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
>> +int virtiovf_cmd_list_use(struct pci_dev *pdev, u8 *buf, int buf_size);
>> +int virtiovf_cmd_lr_write(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
>> +			  u8 offset, u8 size, u8 *buf);
>> +int virtiovf_cmd_lr_read(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
>> +			 u8 offset, u8 size, u8 *buf);
>> +int virtiovf_cmd_lq_read_notify(struct virtiovf_pci_core_device *virtvdev,
>> +				u8 req_bar_flags, u8 *bar, u64 *bar_offset);
>> +#endif /* VIRTIO_VFIO_CMD_H */
>> -- 
>> 2.27.0


