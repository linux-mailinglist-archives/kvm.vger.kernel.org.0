Return-Path: <kvm+bounces-160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C9C07DC829
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:31:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 349281C20C2D
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 08:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6504125D9;
	Tue, 31 Oct 2023 08:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IlC9O0gk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C4213AC6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:31:08 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2083.outbound.protection.outlook.com [40.107.100.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC714C9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 01:31:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPMyD7ZWDoaS691cEVwJjfH6cNQMA2/wl74xOytBEFq7l07q+SkbfFd/HYqf47fRpNl/jPno320MzDg4MQSPjkhSgdd9FzHtz4bZaDeRZ++hyC1/69Jwr6YNXWRMHW6kt3O/HqqCaoSu4JYk0EiXtXyfWei+Vn67qmiriUuXZh1ScOnW8o/ftwMvntd/z/kqEVPpW4+47XfCabyconHfM+Pc0Neq/Wx7o7+lV8KmTSQdwy5l/QhXFCK6XKHlWobwo00z0RmMYOn1hNu528m4kxQyPWimBhc5qkl6UjUDEIVohBub23QISB22L9xtd2E4xS8NvKBXy3uArBqodytIXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ivxJ/NJYSNMwj7CC9eyRR2Y+SJI1RxAgQUYUH5Mvj4=;
 b=iQ9UX/6ENMp/4gwRI0Uk8fWvoNniRUViwITK3j1tIJz1rdA60zo1V1rxmgfM1FtrCSeacJtRgKQKQDhA7ZfXwZ0vDPOpxsFnkCI/QPF10LDVwjmVWoajPK+DfWyLEXGHlEiUKXyjsbP+xB52S1Kl20qdBfxypLiAYOqdfep03JPVfM5K5YVrDgfLx8NLvz00JHMw3vVHmgc98rLs/Re6EiUJ9PstBEn/Bba2LqWh44HHMv2UbpQIWV8x5k5jA+9l/yM202KVZUCrOILExtED7PcZky5X87jptkCaR1DfoC5L20ZBJGZJC3vDwS5niFEDiMUNfRhoT/lOWBwGhrrVug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ivxJ/NJYSNMwj7CC9eyRR2Y+SJI1RxAgQUYUH5Mvj4=;
 b=IlC9O0gk1VVxLSyVm2zsUfPcOzdG4xnVovBbT23OAyGX05guMrLY0cklMQKB2H8TjXekUXFuQ1H8G4tNAu9nVU6BlWebMKEmi2ZD1wt4RaMXy8zafBwWU3O4O2r5qQMbfcP2n16bPl0GOQGPRkXVLx3xH8JniEPPghAL6zO7dDuX/OhSIaZ6db7IPVZUPMk5vKCpFCDlCwbtkIFoO0NVvCMj7a8gK+X74wwo6IJoD7JMV+ObRX538QinAAABN9f9mWUo2NraMMe2d/7EiUHiXSDlVwKP/EKSY2T6QoMHT8ujQLAT+j4QFt/5z2ImH+1JgX23IKMkbL9TJFaE+zUqyQ==
Received: from BN0PR04CA0014.namprd04.prod.outlook.com (2603:10b6:408:ee::19)
 by BL1PR12MB5158.namprd12.prod.outlook.com (2603:10b6:208:31c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Tue, 31 Oct
 2023 08:31:03 +0000
Received: from SA2PEPF00001504.namprd04.prod.outlook.com
 (2603:10b6:408:ee:cafe::ae) by BN0PR04CA0014.outlook.office365.com
 (2603:10b6:408:ee::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29 via Frontend
 Transport; Tue, 31 Oct 2023 08:31:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001504.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6954.19 via Frontend Transport; Tue, 31 Oct 2023 08:31:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 31 Oct
 2023 01:30:46 -0700
Received: from [172.27.14.202] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 31 Oct
 2023 01:30:42 -0700
Message-ID: <3a7c776d-1e5a-4c8d-b91e-9da5fe91db32@nvidia.com>
Date: Tue, 31 Oct 2023 10:30:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 vfio 6/9] virtio-pci: Introduce APIs to execute legacy
 IO admin commands
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <alex.williamson@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-7-yishaih@nvidia.com>
 <20231031040403-mutt-send-email-mst@kernel.org>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231031040403-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001504:EE_|BL1PR12MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: a2abb818-3cbb-4c81-5865-08dbd9ebb830
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uJuZj1uNFd2GlBvhzEymrXiKmPPfnjLruZcHS7u5APTbXkLlmphZcRdZU1ex3vyCGQ42S62JB49jmyIluf4s45f2RqmA0VtCrYChtC2lqUajLJDDi9svgeDC9/5Fb9JZquZafQJDTcTcJsY5UU8b405sr80+YC/UU0EyA3ObtSTfy6heRhs1jS8YGp3+wN83lg5Xv9wygp+1W9VM6jPN93Egzstb9yaAYrditVmm8IICrSnbacwQ4waeVY6KlppQfqAKqLuXY4mNPPfmkjf7TDcHiYg4wCGO7o5zkUgzOTYToLLvEhMHHb27kmDgM6nYM27cRHkHaEJDOz9b72mI8Jp+tj5KoI2ZVjaM+JkqGHJoV1Dq2Jsv1pu/2dU/S03ZFqg70O2LzoqpYlKj6SD6gBnOvNUGgSJ488wTE83DfETGBsKJsgpYZNbZZ0Z4pL4EwW3XhqXO+nk4QFky6GGgX7TK8i2TmVOpSIRY+lkXPIYZxxtRoDwkDEnN0weDMiE+krTGDpklxbLBW3prow+oL2gP84c1R7zKssJIgYxdrQWnwMYlQbz8guqgu1TqkRag0GunYjVceG2FaSXGuKCJK9RgOJsvm7SXLdNhDWYdrNby9mV4Ej4dJFFfAfGXsP1J5CX8K05iGKUYBAlQK0JC5S2ZvEhxiYiWWPxHDJaz8awUR17bbyXMWJHKH5gmiMVA4v4g0QIFIwVn3g/3yptGnN7Mhsi4f51H7MgHt2Gd9JxoQKM7xPSpchdYdad5dyI3zmGCcpt7MVqAn8LXKdHURA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(376002)(346002)(39860400002)(230922051799003)(186009)(82310400011)(1800799009)(451199024)(64100799003)(40470700004)(36840700001)(46966006)(478600001)(40460700003)(40480700001)(107886003)(2616005)(16526019)(26005)(426003)(336012)(31696002)(86362001)(82740400003)(47076005)(7636003)(36756003)(83380400001)(36860700001)(356005)(53546011)(70206006)(70586007)(41300700001)(54906003)(16576012)(316002)(6916009)(5660300002)(8936002)(4326008)(8676002)(31686004)(30864003)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 08:31:03.2212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2abb818-3cbb-4c81-5865-08dbd9ebb830
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001504.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5158

On 31/10/2023 10:09, Michael S. Tsirkin wrote:
> On Sun, Oct 29, 2023 at 05:59:49PM +0200, Yishai Hadas wrote:
>> Introduce APIs to execute legacy IO admin commands.
>>
>> It includes: io_legacy_read/write for both common and the device
>> registers, io_legacy_notify_info.
>>
>> In addition, exposing an API to check whether the legacy IO commands are
>> supported. (i.e. virtio_pci_admin_has_legacy_io()).
>>
>> Those APIs will be used by the next patches from this series.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/virtio/virtio_pci_common.c |  11 ++
>>   drivers/virtio/virtio_pci_common.h |   2 +
>>   drivers/virtio/virtio_pci_modern.c | 241 +++++++++++++++++++++++++++++
>>   include/linux/virtio_pci_admin.h   |  21 +++
>>   4 files changed, 275 insertions(+)
>>   create mode 100644 include/linux/virtio_pci_admin.h
>>
>> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
>> index 6b4766d5abe6..212d68401d2c 100644
>> --- a/drivers/virtio/virtio_pci_common.c
>> +++ b/drivers/virtio/virtio_pci_common.c
>> @@ -645,6 +645,17 @@ static struct pci_driver virtio_pci_driver = {
>>   	.sriov_configure = virtio_pci_sriov_configure,
>>   };
>>   
>> +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev)
>> +{
>> +	struct virtio_pci_device *pf_vp_dev;
>> +
>> +	pf_vp_dev = pci_iov_get_pf_drvdata(pdev, &virtio_pci_driver);
>> +	if (IS_ERR(pf_vp_dev))
>> +		return NULL;
>> +
>> +	return &pf_vp_dev->vdev;
>> +}
>> +
>>   module_pci_driver(virtio_pci_driver);
>>   
>>   MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
>> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
>> index 9e07e556a51a..07d4f863ac44 100644
>> --- a/drivers/virtio/virtio_pci_common.h
>> +++ b/drivers/virtio/virtio_pci_common.h
>> @@ -156,4 +156,6 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
>>   int virtio_pci_modern_probe(struct virtio_pci_device *);
>>   void virtio_pci_modern_remove(struct virtio_pci_device *);
>>   
>> +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
>> +
>>   #endif
>> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
>> index 25e27aa79cab..def0f2de6091 100644
>> --- a/drivers/virtio/virtio_pci_modern.c
>> +++ b/drivers/virtio/virtio_pci_modern.c
>> @@ -15,6 +15,7 @@
>>    */
>>   
>>   #include <linux/delay.h>
>> +#include <linux/virtio_pci_admin.h>
>>   #define VIRTIO_PCI_NO_LEGACY
>>   #define VIRTIO_RING_NO_LEGACY
>>   #include "virtio_pci_common.h"
>> @@ -794,6 +795,246 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
>>   	vp_dev->del_vq(&vp_dev->admin_vq.info);
>>   }
>>   
>> +#define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
>> +	(BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
>> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
>> +
>> +/*
>> + * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
>> + * commands are supported
>> + * @dev: VF pci_dev
>> + *
>> + * Returns true on success.
>> + */
>> +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
>> +{
>> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>> +	struct virtio_pci_device *vp_dev;
>> +
>> +	if (!virtio_dev)
>> +		return false;
>> +
>> +	if (!virtio_has_feature(virtio_dev, VIRTIO_F_ADMIN_VQ))
>> +		return false;
>> +
>> +	vp_dev = to_vp_device(virtio_dev);
>> +
>> +	if ((vp_dev->admin_vq.supported_cmds & VIRTIO_LEGACY_ADMIN_CMD_BITMAP) ==
>> +		VIRTIO_LEGACY_ADMIN_CMD_BITMAP)
>> +		return true;
>> +	return false;
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);
>> +
>> +static int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
>> +					    u8 offset, u8 size, u8 *buf)
>> +{
>> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>> +	struct virtio_admin_cmd_legacy_wr_data *data;
>> +	struct virtio_admin_cmd cmd = {};
>> +	struct scatterlist data_sg;
>> +	int vf_id;
>> +	int ret;
>> +
>> +	if (!virtio_dev)
>> +		return -ENODEV;
>> +
>> +	vf_id = pci_iov_vf_id(pdev);
>> +	if (vf_id < 0)
>> +		return vf_id;
>> +
>> +	data = kzalloc(sizeof(*data) + size, GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	data->offset = offset;
>> +	memcpy(data->registers, buf, size);
>> +	sg_init_one(&data_sg, data, sizeof(*data) + size);
>> +	cmd.opcode = cpu_to_le16(opcode);
>> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>> +	cmd.group_member_id = cpu_to_le64(vf_id + 1);
>> +	cmd.data_sg = &data_sg;
>> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>> +
>> +	kfree(data);
>> +	return ret;
>> +}
>
>> +
>> +/*
>> + * virtio_pci_admin_legacy_io_write_common - Write common legacy registers
>> + * of a member device
>> + * @dev: VF pci_dev
>> + * @offset: starting byte offset within the registers to write to
>> + * @size: size of the data to write
>> + * @buf: buffer which holds the data
>> + *
>> + * Returns 0 on success, or negative on failure.
>> + */
>> +int virtio_pci_admin_legacy_common_io_write(struct pci_dev *pdev, u8 offset,
>> +					    u8 size, u8 *buf)
>> +{
>> +	return virtio_pci_admin_legacy_io_write(pdev,
>> +					VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE,
>> +					offset, size, buf);
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_common_io_write);
> So consider this for example. You start with a PCI device of a VF.
> Any number of these will access a PF in parallel. No locking
> is taking place so admin vq can get corrupted.

Right

As you commented correctly on previous patch, virtqueue_add_sgs() needs 
to be protected by some lock.
This is true also for virtqueue_get_buf().

So as part of V3 we may add a lock as part of virtqueue_exec_admin_cmd() 
to serialize a given command on the PF.

> And further, is caller expected not to invoke several of these
> in parallel on the same device? If yes this needs to be
> documented. I don't see where does vfio enforce this if yes.
Please have a look at virtiovf_issue_legacy_rw_cmd() from patch #9.

It has a lock on its VF device to serialize access to the bar, it 
includes calling this API.

Yishai

>
>   
>> +
>> +/*
>> + * virtio_pci_admin_legacy_io_write_device - Write device legacy registers
>> + * of a member device
>> + * @dev: VF pci_dev
>> + * @offset: starting byte offset within the registers to write to
>> + * @size: size of the data to write
>> + * @buf: buffer which holds the data
>> + *
>> + * Returns 0 on success, or negative on failure.
>> + */
>> +int virtio_pci_admin_legacy_device_io_write(struct pci_dev *pdev, u8 offset,
>> +					    u8 size, u8 *buf)
>> +{
>> +	return virtio_pci_admin_legacy_io_write(pdev,
>> +					VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE,
>> +					offset, size, buf);
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_device_io_write);
>> +
>> +static int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
>> +					   u8 offset, u8 size, u8 *buf)
>> +{
>> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>> +	struct virtio_admin_cmd_legacy_rd_data *data;
>> +	struct scatterlist data_sg, result_sg;
>> +	struct virtio_admin_cmd cmd = {};
>> +	int vf_id;
>> +	int ret;
>> +
>> +	if (!virtio_dev)
>> +		return -ENODEV;
>> +
>> +	vf_id = pci_iov_vf_id(pdev);
>> +	if (vf_id < 0)
>> +		return vf_id;
>> +
>> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	data->offset = offset;
>> +	sg_init_one(&data_sg, data, sizeof(*data));
>> +	sg_init_one(&result_sg, buf, size);
>> +	cmd.opcode = cpu_to_le16(opcode);
>> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>> +	cmd.group_member_id = cpu_to_le64(vf_id + 1);
>> +	cmd.data_sg = &data_sg;
>> +	cmd.result_sg = &result_sg;
>> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>> +
>> +	kfree(data);
>> +	return ret;
>> +}
>> +
>> +/*
>> + * virtio_pci_admin_legacy_device_io_read - Read legacy device registers of
>> + * a member device
>> + * @dev: VF pci_dev
>> + * @offset: starting byte offset within the registers to read from
>> + * @size: size of the data to be read
>> + * @buf: buffer to hold the returned data
>> + *
>> + * Returns 0 on success, or negative on failure.
>> + */
>> +int virtio_pci_admin_legacy_device_io_read(struct pci_dev *pdev, u8 offset,
>> +					   u8 size, u8 *buf)
>> +{
>> +	return virtio_pci_admin_legacy_io_read(pdev,
>> +					VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ,
>> +					offset, size, buf);
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_device_io_read);
>> +
>> +/*
>> + * virtio_pci_admin_legacy_common_io_read - Read legacy common registers of
>> + * a member device
>> + * @dev: VF pci_dev
>> + * @offset: starting byte offset within the registers to read from
>> + * @size: size of the data to be read
>> + * @buf: buffer to hold the returned data
>> + *
>> + * Returns 0 on success, or negative on failure.
>> + */
>> +int virtio_pci_admin_legacy_common_io_read(struct pci_dev *pdev, u8 offset,
>> +					    u8 size, u8 *buf)
>> +{
>> +	return virtio_pci_admin_legacy_io_read(pdev,
>> +					VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ,
>> +					offset, size, buf);
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_common_io_read);
>> +
>> +/*
>> + * virtio_pci_admin_legacy_io_notify_info - Read the queue notification
>> + * information for legacy interface
>> + * @dev: VF pci_dev
>> + * @req_bar_flags: requested bar flags
>> + * @bar: on output the BAR number of the member device
>> + * @bar_offset: on output the offset within bar
>> + *
>> + * Returns 0 on success, or negative on failure.
>> + */
>> +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
>> +					   u8 req_bar_flags, u8 *bar,
>> +					   u64 *bar_offset)
>> +{
>> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>> +	struct virtio_admin_cmd_notify_info_result *result;
>> +	struct virtio_admin_cmd cmd = {};
>> +	struct scatterlist result_sg;
>> +	int vf_id;
>> +	int ret;
>> +
>> +	if (!virtio_dev)
>> +		return -ENODEV;
>> +
>> +	vf_id = pci_iov_vf_id(pdev);
>> +	if (vf_id < 0)
>> +		return vf_id;
>> +
>> +	result = kzalloc(sizeof(*result), GFP_KERNEL);
>> +	if (!result)
>> +		return -ENOMEM;
>> +
>> +	sg_init_one(&result_sg, result, sizeof(*result));
>> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO);
>> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>> +	cmd.group_member_id = cpu_to_le64(vf_id + 1);
>> +	cmd.result_sg = &result_sg;
>> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>> +	if (!ret) {
>> +		struct virtio_admin_cmd_notify_info_data *entry;
>> +		int i;
>> +
>> +		ret = -ENOENT;
>> +		for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
>> +			entry = &result->entries[i];
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
>> +	kfree(result);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_notify_info);
>> +
>>   static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>>   	.get		= NULL,
>>   	.set		= NULL,
>> diff --git a/include/linux/virtio_pci_admin.h b/include/linux/virtio_pci_admin.h
>> new file mode 100644
>> index 000000000000..446ced8cb050
>> --- /dev/null
>> +++ b/include/linux/virtio_pci_admin.h
>> @@ -0,0 +1,21 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _LINUX_VIRTIO_PCI_ADMIN_H
>> +#define _LINUX_VIRTIO_PCI_ADMIN_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/pci.h>
>> +
>> +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev);
>> +int virtio_pci_admin_legacy_common_io_write(struct pci_dev *pdev, u8 offset,
>> +					    u8 size, u8 *buf);
>> +int virtio_pci_admin_legacy_common_io_read(struct pci_dev *pdev, u8 offset,
>> +					   u8 size, u8 *buf);
>> +int virtio_pci_admin_legacy_device_io_write(struct pci_dev *pdev, u8 offset,
>> +					    u8 size, u8 *buf);
>> +int virtio_pci_admin_legacy_device_io_read(struct pci_dev *pdev, u8 offset,
>> +					   u8 size, u8 *buf);
>> +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
>> +					   u8 req_bar_flags, u8 *bar,
>> +					   u64 *bar_offset);
>> +
>> +#endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
>> -- 
>> 2.27.0



