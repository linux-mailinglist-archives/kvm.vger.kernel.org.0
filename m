Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71727AEAC1
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 12:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbjIZKvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 06:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234383AbjIZKvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 06:51:42 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98C4E9
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 03:51:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKodSdfqrB4iqCze2aeAvJBzPPICs9A6Pdkw3l9cnIEeuTFNg6CnqAcZJxW9p8UYq3WAdbUBfe3Pu9H4FKwwjLghPUjUasNtnkkgeBxyjWWvYoPYnflUMam61HBL9ihthfO741L5WYWzC49c3JILhfmpij4RnbSMeHoyxi6MfbBUXYfZGP9A/MG6TtL329BucmBLL+wULiUgrOLziJy01jHmZmHbU10U/dD3Yg2sdtks9RORpS/XW853iKGRNqWjcrkQYAZ7UPM9hmyvcF64abP3pyZxtE+JnOGQChegi2K0FCHH2AVSMb8ZOdRaLOU88FO0r5kGK99t4tsMUY3yrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNEnOb1BPuC0sPyfve7L9nten9oXY+XhGQmYI187fo0=;
 b=n0ougfBi2QlobJ6Dgz6LsrDEWZE+UA7ZiUSh093btanZgahvzXOL64CqDdpEweVzxelle6EKKa+1wOd/Bs2w3kmg7bxz0pwGIME6dkfMc5BKgCCE/I973jYTfHsFAn2WbxD2VK9UtgMDKhqkxGvrKA7MnZ4h9NnZgOTs8NXKBZOPG4T1xqW0AysMu+SBQlsWpDwOhU7VG6enKJ6WhQP+2ohkKPm/NTNtsbC/8r5FShwal1TZa/9FnF0xwrVIy5/R0P2hyLNo5Y12O1A5HOkAiY6F/L/3aBbTPWOM0dZxMriKDNpPUYSt2uriluOvL9dsan0nlMUpB7Q4BCq0zGpxgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNEnOb1BPuC0sPyfve7L9nten9oXY+XhGQmYI187fo0=;
 b=uoO1Gqx5NWGnPDVETfF9De/Djfxgfd3cxEb4gGfJq8QOxf9wqOcl3W2kNIbmdQ+df0RLtdaXgyNO+XNixnOQY2Rs/w2j6y2EpFZskpT+wPkeEKIebaDVBN0o8I8HZolVKK91vM3+etI3dHpckI509FiohNhWVGfec/di+Jbpparw7X82+n5/X5U846eNcZ4F9YHcfkEIJB0JBTvTzOjo4avVuhx2DfGj1TJQ60oZoTfgabyaAu7wBgOqt2SqtFj4uA9N26tdRR4A1wdVRCFSkKk+lo5qCf3+flt4vO1EihTzepgaoffklTUE/ecFMXxgpXH4qVp12ZtuMIGqtujTeA==
Received: from DS7PR03CA0007.namprd03.prod.outlook.com (2603:10b6:5:3b8::12)
 by SA1PR12MB8858.namprd12.prod.outlook.com (2603:10b6:806:385::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Tue, 26 Sep
 2023 10:51:32 +0000
Received: from CY4PEPF0000EE30.namprd05.prod.outlook.com
 (2603:10b6:5:3b8:cafe::60) by DS7PR03CA0007.outlook.office365.com
 (2603:10b6:5:3b8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.35 via Frontend
 Transport; Tue, 26 Sep 2023 10:51:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EE30.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Tue, 26 Sep 2023 10:51:32 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 26 Sep
 2023 03:51:21 -0700
Received: from [172.27.13.90] (10.126.230.35) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 26 Sep
 2023 03:51:15 -0700
Message-ID: <cf657792-c21a-4ef7-737d-402239ce557d@nvidia.com>
Date:   Tue, 26 Sep 2023 13:51:13 +0300
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
 <20230921162621-mutt-send-email-mst@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20230921162621-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail202.nvidia.com (10.129.68.7)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE30:EE_|SA1PR12MB8858:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc168d3-3e46-4140-6b5b-08dbbe7e8be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nvycYj5z0jQYdFnALUQoJ5DP1bdkLpV7mdcvA0YQreu61sjxkmrxcbJQg0FK1KRNuWDXdbIQTkysoI6tNqDcF4sID0XP1gjvqVMs/fV+r97ohr+guBntJrd6WCzdKkytJWIKp1spo5vYfI0vqey7TOqHf/v8gpgFIUFdYSXZbfZCEJUjeanZOcjXv6RCcvJvXMONnEi5VgxF3ko9Th0hemzNJVBpzmsNKOto23GOgSXYeFcZW/38p6PqxG38pluWcC6QEyb0ozkWkQNVf3b2DXfuTMx8812dxyJhpAgJJ7iKCQjeqE4hbnCMrCRQIorqyB2p7rSM94i6qoWNnyQZhFM+NTtPSaMvFjD7NXRDX2PMqaAk3Of37Kyfht7M/chTnC11eGdQrOBr/xu8GxQZCsjIhuXGAM2ZjLDQexeP/5OJGqcVxAaMc72+5k21LtFp8X/Ii2C+XwYCUThWItJJugNyZMhD3FqT0HHXljtz66lHqj6L8tWOEAGPgl3yhff+w7qo/4IaurfLg4AVFApiPexUKMfHsk04jjPnhxFAVWSR2y4qYzUgMQRTnHS91Foh05DcFI5B9tv1pDmXG2uUr2IUgAlcWQzmpnFqQzRNMyosTpn6wu/bvRw6OZ/5TIMz/VJoWZrPhwqMqFt/rFUGzqwc+Lxy0CZDciEMZthD7YflUWMwHQFLxuf6a4FZi0Tjjd2dgUlYx+byKKlUCMHBmzDn91QZmDMxdKYfj4RZSpPbDJN1gyADPzo/nrto0tbefPhz5ErV3y/anJfboKPsPA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(376002)(346002)(230922051799003)(1800799009)(186009)(451199024)(82310400011)(40470700004)(46966006)(36840700001)(31686004)(4326008)(8676002)(8936002)(53546011)(40480700001)(70586007)(316002)(41300700001)(6916009)(54906003)(70206006)(5660300002)(16576012)(40460700003)(36860700001)(47076005)(86362001)(107886003)(7636003)(82740400003)(356005)(31696002)(36756003)(26005)(16526019)(2616005)(478600001)(2906002)(83380400001)(336012)(426003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 10:51:32.3991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc168d3-3e46-4140-6b5b-08dbbe7e8be2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE30.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8858
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/2023 23:34, Michael S. Tsirkin wrote:
> On Thu, Sep 21, 2023 at 03:40:39PM +0300, Yishai Hadas wrote:
>> Expose admin commands over the virtio device, to be used by the
>> vfio-virtio driver in the next patches.
>>
>> It includes: list query/use, legacy write/read, read notify_info.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
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
> in/out seem all wrong here. In virtio terminology, in means from
> device to driver, out means from driver to device.
I referred here to in/out from vfio POV who prepares the command.

However, I can replace it to follow the virtio terminology as you 
suggested if this more makes sense.

Please see also my coming answer on your suggestion to put all of this 
in the virtio layer.

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
>
> what is _lr short for?

This was an acronym to legacy_read.

The actual command is according to the given opcode which can be one 
among LEGACY_COMMON_CFG_READ, LEGACY_DEV_CFG_READ.

I can rename it to '_legacy_read' (i.e. virtiovf_issue_legacy_read_cmd) 
to be clearer.

>
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
> weird. why + 1?

This follows the virtio spec in that area.

"When sending commands with the SR-IOV group type, the driver specify a 
value for group_member_id
between 1 and NumVFs inclusive."

The 'virtvdev->vf_id' was set upon vfio/virtio driver initialization by 
pci_iov_vf_id() which its first index is 0.

>> +	cmd.data_sg = &in_sg;
>> +	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
>> +
>> +	kfree(in);
>> +	return ret;
>> +}
> How do you know it's safe to send this command, in particular at
> this time? This seems to be doing zero checks, and zero synchronization
> with the PF driver.
>
The virtiovf_cmd_lr_read()/other gets a virtio VF and it gets its PF by 
calling virtio_pci_vf_get_pf_dev().

The VF can't gone by 'disable sriov' as it's owned/used by vfio.

The PF can't gone by rmmod/modprobe -r of virtio, as of the 'module in 
use'/dependencies between VFIO to VIRTIO.

The below check [1] was done only from a clean code perspective, which 
might theoretically fail in case the given VF doesn't use a virtio driver.

[1] if (!virtio_dev)
         return -ENOTCONN;

So, it looks safe as is.

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
> and what is lq short for?

To be more explicit, I may replace to virtiovf_cmd_legacy_notify_info() 
to follow the spec opcode.

Yishai

>
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


