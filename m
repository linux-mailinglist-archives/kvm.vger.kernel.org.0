Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0CE7D66FB
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 11:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbjJYJgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 05:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjJYJgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 05:36:39 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E61A6
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 02:36:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLmYwD7vaDlaHrNjVhr8ra71378HL6maVQ8mu1TvAwLw54ApOYlfv4xfQ2XXPvemAfCPxyGStca/nz6UTVme00jRxCi9FElE+4fjJwpkO/Dzo0G8WnimkkTTP89jfrxgZDHAXUvP6MpfWXBHWn4zv2iLt6C736TgKyCzHy9PQ2oGwDfHyKvVN0yoarMLvk21hkF7oI+Nxf8dclPac0AN1FAXWzeA/D/6vvsVScj7BJ3retwN+tGMFmD+ROtcjUArQ0miR7Q9j3/QcOQCQ4S5tJ75UJ37+xlwDnZmTMi+WoYMRz52OP14yW7HveJ/YYPmwupTaghtfE4eRy7XOTPIQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVrvLZH4VOwfxz+0WpAnsClCD9Z1kv7EEMcwCalXR1Q=;
 b=bKsjU1E5yFBu3jXvkDXcpP28bL6CuwRTJwau98a7XUjnAYm/wxF90325dFaioSPqclMZcNBsJ8XsFZscZ4iX5vWgc3DljsA0RUauMujJduQ9Rxpft91SlYv2wakqagN03RfGJjDgYLZ594BDg8fSPqplwl4FHFZkNG7PTXyGQUOa0q3koEL7Cgjmmg7eI2b/pqvpH50G00frhVxae+k2Wb2xHPJ52i2gB+VaOS934YwOp56bvijgU13hfqp9dk9SRn4qsPuY0PJDxA+/2oCdfftgUWxGIQuhNeoA3mzbKFODrk625dAD6ES/y3NC07fu8zyxYD4AQHICC48rXSay9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVrvLZH4VOwfxz+0WpAnsClCD9Z1kv7EEMcwCalXR1Q=;
 b=bcckztAtnRrFJ56fSb11i25UJYiULr2qTw8QawTBOJW+hvmMxPo6fX+TGNCh63ZJej9IfqVCq450BHNJH4MWFuqHA5UKqk2YfJAM4kEuMPNOAJNxAe2QSb7nWzizlYhUtcAjQBYV4K9+S+jZQjCxsdU5KTPGS3Qs9sJXKWoYWloG2wDTFTMWYhIhak+iLdEpt2mQbIwKF2+UNJrQ9HdU8Ud2gj+urkxr9E3gzXeJ1KJDKJvlShGPzqbREEwOvej61k5XEBxYvN4o5D8acfE2t92oSDinLkrZGuCYntPzdy7z0pbwt3go38MS2YwyjxrLq4Y4eWj1p7BE7jzKubt14w==
Received: from CH2PR14CA0023.namprd14.prod.outlook.com (2603:10b6:610:60::33)
 by BY5PR12MB4920.namprd12.prod.outlook.com (2603:10b6:a03:1d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 09:36:33 +0000
Received: from DS2PEPF00003441.namprd04.prod.outlook.com
 (2603:10b6:610:60:cafe::bc) by CH2PR14CA0023.outlook.office365.com
 (2603:10b6:610:60::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.34 via Frontend
 Transport; Wed, 25 Oct 2023 09:36:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF00003441.mail.protection.outlook.com (10.167.17.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Wed, 25 Oct 2023 09:36:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 25 Oct
 2023 02:36:20 -0700
Received: from [172.27.14.159] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 25 Oct
 2023 02:36:16 -0700
Message-ID: <155561a3-cb30-48a9-8723-33b667e23aa5@nvidia.com>
Date:   Wed, 25 Oct 2023 12:36:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 vfio 6/9] virtio-pci: Introduce APIs to execute legacy
 IO admin commands
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <alex.williamson@redhat.com>, <jasowang@redhat.com>,
        <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
        <feliu@nvidia.com>, <jiri@nvidia.com>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-7-yishaih@nvidia.com>
 <20231024165210-mutt-send-email-mst@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231024165210-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003441:EE_|BY5PR12MB4920:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c5d27e1-0594-43c3-b1b4-08dbd53ddfd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lmgHVYsC/ix+eUT8bVLJQYkMSoLkzW/wDQVKmk6wdDaEMnVPgIFszPhedLvN+4nbYY0e5Ld4/yl0tuMpmZvAWsusSZ55nv4aTOcb3OZGIdeJ7WHDlmOBb58mmEhDQ2ATqZF9ekQ7tx07LJ34p9+bLWsDDBTiJtmTOEtX+qpYXGUp905olSA5B5vUUquwVX69sbFmjxrfOOeWDPrHWeQUTy1TMbuspCaEM8mLQnDnpkYESuH6Y1MK5ok/NqDE2+aDMxA+WT1SDZZtb2D8OiiUuw0ZG5Dk5LurEhvrLSC+354cTD23em0kc6H04I4aY8cxMXAyepm2vqXhPhuqURNIF4wyQkLhBFg+QFK/jegOnG01AsbHxT9mi/PPDTP0lDi0PFLhRi6AJRR1aZIfbYpxftGTf2U90SVsNL0NTvUCYxKl6y7MsKs9NuNt8TCjA9uxYXF+oD8RGx69iYZ8AO7sik6T3FK5cT/R0zbt9RVH8X4iWG2zHdBVZUrJu27SfFFxc+M5V9g8XlkxLckZsSOixdW3p7nj7f+gfLkgSscei0io5Ap/L3fAFc70maj8p4nOu4FtecHNxXYZ00EuD2YpdNgsynY4dxIs6ytZImdWWU0W4DHScPJ47KLMXbGborFwFICIneGW5CtFTm+sNM8h+a6s+6WaQ54UjIEaD8SNDC00Bhg5A2BxKwcG7Wa/1vD4nwtFDmrpJfvhNuaZCsHuWxyQk69UJ3bZsfuILq+z/I4ZsmBanMRv+OqCjKA1qFWYwybdRJCh629jR4jQhnFEg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(230922051799003)(186009)(451199024)(1800799009)(82310400011)(64100799003)(36840700001)(46966006)(40470700004)(31686004)(83380400001)(40480700001)(40460700003)(30864003)(36860700001)(8676002)(36756003)(4326008)(2906002)(8936002)(53546011)(107886003)(82740400003)(26005)(47076005)(2616005)(16526019)(7636003)(356005)(426003)(336012)(5660300002)(54906003)(6916009)(31696002)(316002)(70586007)(86362001)(41300700001)(16576012)(70206006)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 09:36:32.5889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5d27e1-0594-43c3-b1b4-08dbd53ddfd7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003441.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4920
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re sending as previous reply was by mistake not in a text format.

On 25/10/2023 0:01, Michael S. Tsirkin wrote:
> On Tue, Oct 17, 2023 at 04:42:14PM +0300, Yishai Hadas wrote:
>> Introduce APIs to execute legacy IO admin commands.
>>
>> It includes: list_query/use, io_legacy_read/write,
>> io_legacy_notify_info.
>>
>> Those APIs will be used by the next patches from this series.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/virtio/virtio_pci_common.c |  11 ++
>>   drivers/virtio/virtio_pci_common.h |   2 +
>>   drivers/virtio/virtio_pci_modern.c | 206 +++++++++++++++++++++++++++++
>>   include/linux/virtio_pci_admin.h   |  18 +++
>>   4 files changed, 237 insertions(+)
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
>> index a21b9ba01a60..2785e61ed668 100644
>> --- a/drivers/virtio/virtio_pci_common.h
>> +++ b/drivers/virtio/virtio_pci_common.h
>> @@ -155,4 +155,6 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
>>   int virtio_pci_modern_probe(struct virtio_pci_device *);
>>   void virtio_pci_modern_remove(struct virtio_pci_device *);
>>   
>> +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
>> +
>>   #endif
>> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
>> index cc159a8e6c70..00b65e20b2f5 100644
>> --- a/drivers/virtio/virtio_pci_modern.c
>> +++ b/drivers/virtio/virtio_pci_modern.c
>> @@ -719,6 +719,212 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
>>   	vp_dev->del_vq(&vp_dev->admin_vq.info);
>>   }
>>   
>> +/*
>> + * virtio_pci_admin_list_query - Provides to driver list of commands
>> + * supported for the PCI VF.
>> + * @dev: VF pci_dev
>> + * @buf: buffer to hold the returned list
>> + * @buf_size: size of the given buffer
>> + *
>> + * Returns 0 on success, or negative on failure.
>> + */
>> +int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
>> +{
>> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>> +	struct virtio_admin_cmd cmd = {};
>> +	struct scatterlist result_sg;
>> +
>> +	if (!virtio_dev)
>> +		return -ENODEV;
>> +
>> +	sg_init_one(&result_sg, buf, buf_size);
>> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
>> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>> +	cmd.result_sg = &result_sg;
>> +
>> +	return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_pci_admin_list_query);
>> +
>> +/*
>> + * virtio_pci_admin_list_use - Provides to device list of commands
>> + * used for the PCI VF.
>> + * @dev: VF pci_dev
>> + * @buf: buffer which holds the list
>> + * @buf_size: size of the given buffer
>> + *
>> + * Returns 0 on success, or negative on failure.
>> + */
>> +int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
>> +{
>> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>> +	struct virtio_admin_cmd cmd = {};
>> +	struct scatterlist data_sg;
>> +
>> +	if (!virtio_dev)
>> +		return -ENODEV;
>> +
>> +	sg_init_one(&data_sg, buf, buf_size);
>> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
>> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>> +	cmd.data_sg = &data_sg;
>> +
>> +	return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_pci_admin_list_use);
> list commands are actually for a group, not for the VF.
The VF was given to let the function gets the PF from it.
For now, the only existing 'group_type' in the spec is SRIOV, this is 
why we hard-coded it internally to match the VF PCI.

Alternatively,
We can change the API to get the PF and 'group_type' from the caller to 
better match future usage.
However, this will require to export the virtio_pci_vf_get_pf_dev() API 
outside virtio-pci.

Do you prefer to change to the latter option ?
>> +
>> +/*
>> + * virtio_pci_admin_legacy_io_write - Write legacy registers of a member device
>> + * @dev: VF pci_dev
>> + * @opcode: op code of the io write command
> opcode is actually either VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE
> or VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE correct?
>
> So please just add 2 APIs for this so users don't need to care.
> Could be wrappers around these two things.
>
>
OK.
We'll export the below 2 APIs [1] which internally will call 
virtio_pci_admin_legacy_io_write() with the proper op code hard-coded.
[1]virtio_pci_admin_legacy_device_io_write()
      virtio_pci_admin_legacy_common_io_write()

Yishai

>
>> + * @offset: starting byte offset within the registers to write to
>> + * @size: size of the data to write
>> + * @buf: buffer which holds the data
>> + *
>> + * Returns 0 on success, or negative on failure.
>> + */
>> +int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
>> +				     u8 offset, u8 size, u8 *buf)
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
>> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_write);
>> +
>> +/*
>> + * virtio_pci_admin_legacy_io_read - Read legacy registers of a member device
>> + * @dev: VF pci_dev
>> + * @opcode: op code of the io read command
>> + * @offset: starting byte offset within the registers to read from
>> + * @size: size of the data to be read
>> + * @buf: buffer to hold the returned data
>> + *
>> + * Returns 0 on success, or negative on failure.
>> + */
>> +int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
>> +				    u8 offset, u8 size, u8 *buf)
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
>> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_read);
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
>> index 000000000000..cb916a4bc1b1
>> --- /dev/null
>> +++ b/include/linux/virtio_pci_admin.h
>> @@ -0,0 +1,18 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _LINUX_VIRTIO_PCI_ADMIN_H
>> +#define _LINUX_VIRTIO_PCI_ADMIN_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/pci.h>
>> +
>> +int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size);
>> +int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
>> +int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
>> +				     u8 offset, u8 size, u8 *buf);
>> +int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
>> +				    u8 offset, u8 size, u8 *buf);
>> +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
>> +					   u8 req_bar_flags, u8 *bar,
>> +					   u64 *bar_offset);
>> +
>> +#endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
>> -- 
>> 2.27.0


