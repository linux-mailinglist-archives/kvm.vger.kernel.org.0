Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3B57D6C9D
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 15:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbjJYNBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 09:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbjJYNBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 09:01:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D11090
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 06:01:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JemmUnlyEb8gW+i5zIapWX93yb5L6qnODqcmqONo2qipGXkaE98q+P/eUYZ2CqhjtKnmGMwiFqazMiH/TivgLfnPKOQCLgnfyJ9CZKrNr6hgwLqbFKJ38+FEk+A8FhL5StdvpM5UWDewafL5B4jhKOGlThK5TJ7vSxc5V3RbOosIWZHzGv16dUoS7BiTQlgfVNkTAMhr5HWd11DVWd8m4nWJSMtsAMmDCLkCvpZDwNEyMJlm6qJIRwE1vfZAs0TqFPaU2TReB9FMgYG1o0E+cdfBNpGKaTvr5CIjb2WrI/Jd6+EhXc1x4rNE5Y1Hg7vuodu8Fs1hVTYpH7t+pZ1TDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m54izoeYG+9eaDzkP6J2TapozJ+pntMVgPvFiLpNhK4=;
 b=gTpV5+wbH5ojesc/vw62Qb0htPvclyvHdM/5cztwcnKY7OYnCj1PQwLPByQxultJ1uAX9fB59VfpsjKnckWW8EIOXZfLmF+TxP5nTgoJqfJEgOnqQpQ/D0w2+RAnD7y4OZ7ZCHlZEgxP/3rBb95ZUWBpBC3o4rHjRBpBSJRU+nbTV4+0GgqYnFUCvE6WJ9Du1YKnKAy3kTu9MwBDoy+eLWALbPYGjDoODzRtj6hmPE1nsyP3c0vNcREBpa5ERRCLjUom6EpVduBII/FfItYhawFP0Pk+gcmWXxRikmtG+Rr0bUW5sld+BLPB7C1J7aBQhLDlBCV6pRcp+E6HRaB47g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m54izoeYG+9eaDzkP6J2TapozJ+pntMVgPvFiLpNhK4=;
 b=Wqp0iYEjODJsnYnmAc54dEI2N5pvULg3dAoCkxWFqmS2ShtGwl6bvC8oWquED1Zor/82ndzRl4dN7eu1u71iihjxF2Ph3Hnry4WrmRKScEegMj8M7iMWvWDXyTdrACCgSRwYp4Cu4MpWvmWGE8w2cTjwtnu/AST/ToXcdfMSgqwUPN8FTyyoX489kFggeub7RgVe+ZDIDAiOOISMoJYjAU5xKbfCQc4RAmQSal5JjFU8y1Hdmh5oX1E0emgNtWhYt8+ww6FXBWIcC6GloXxqBrL/Cg5lytHVfcv7qKrQtKnpPo9RHSeMJvJ0vvCrJpgzmocIlvAPXlkdXXrh1PqwUg==
Received: from DS7PR03CA0042.namprd03.prod.outlook.com (2603:10b6:5:3b5::17)
 by CH3PR12MB8852.namprd12.prod.outlook.com (2603:10b6:610:17d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Wed, 25 Oct
 2023 13:01:08 +0000
Received: from CY4PEPF0000EDD3.namprd03.prod.outlook.com
 (2603:10b6:5:3b5:cafe::6e) by DS7PR03CA0042.outlook.office365.com
 (2603:10b6:5:3b5::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33 via Frontend
 Transport; Wed, 25 Oct 2023 13:01:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD3.mail.protection.outlook.com (10.167.241.207) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Wed, 25 Oct 2023 13:01:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 25 Oct
 2023 06:00:49 -0700
Received: from [172.27.14.159] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 25 Oct
 2023 06:00:45 -0700
Message-ID: <03c4e0da-7a5c-44bc-98f8-fca8228a9674@nvidia.com>
Date:   Wed, 25 Oct 2023 16:00:43 +0300
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
 <5a83e6c1-1d32-4edb-a01c-3660ab74d875@nvidia.com>
 <20231025060501-mutt-send-email-mst@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231025060501-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD3:EE_|CH3PR12MB8852:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f86e532-6873-4596-640d-08dbd55a747e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 94oybD03A5n4jcM+mktZ/afYViKBGvaNri7qlFNaTEzISeB5Rfmo4KXw+us8a4SM8hWqEKCfgFu7Aku9YhUFLnXhk9eH2pYklbU5VnZjb9TabxwEOCShULzod+zZFV10bTqOekjtooy41HDsVaiUBLpjgG/3DEJVR9V95i/cQrhS6MyDMc7+LivpG0s5gV2t93BMhJL9UawRmyZQGM3s2ClizjiRX+uJZB/Da3P+Z7DPMFqYO3hyEcWVx1pb3sg1sycaOXFsp5dAJwksICjdPFKum2LXIgZ+EysjhOO9WjJXcpJAHIicdOKrqdMhEohzDUTrLvE9n9q6dgRBt93DSg0ntDDXWLD1r920SkpKWjjdSONSgkC9wsQfiBajxd4LcA/OJBaLNYjbYMb+IfXWIqrpbpZ/z/CpyOSBnRZG83JWmT3lS6RR+jb20GMeeHrmG2Nm4ljS1Ho5gD8GnbQs13Xp1Q5m49agnFchHrNp5/gtWVJK8IlakYxUGMqZ8svPFUV04SIu2L+/nbok1KLviVQSbrnyLSsxeVYF+wxmf13wXPnuHBFmKAxxqvVsl//KUoQ7aoAuyGUZaBONW6px+LbFTESU8CY08k0G/A/+moOq/k1DbGoX7e33ByfuspQRoSnzFNpsDyjDHcP5Lym5ki0fG9PAi9QCuZSyrtE2nff2c3UCsf4ePxS1yXg5bLX5KJFGRzOqaVdLLw3C6daBhr39d0UgCGOdJw8gYTj8YGqn1xsdQ6Zfgj+ncKSqvUzyl2sdkGGe2SWFKWLCsirJbQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(396003)(39860400002)(230922051799003)(186009)(82310400011)(1800799009)(451199024)(64100799003)(40470700004)(46966006)(36840700001)(356005)(26005)(31686004)(40460700003)(2906002)(30864003)(54906003)(36860700001)(5660300002)(86362001)(41300700001)(8676002)(8936002)(36756003)(478600001)(4326008)(6916009)(16576012)(107886003)(16526019)(7636003)(70586007)(31696002)(82740400003)(70206006)(53546011)(316002)(83380400001)(2616005)(336012)(426003)(40480700001)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 13:01:08.0176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f86e532-6873-4596-640d-08dbd55a747e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EDD3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8852
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 13:17, Michael S. Tsirkin wrote:
> On Wed, Oct 25, 2023 at 12:18:32PM +0300, Yishai Hadas wrote:
>> On 25/10/2023 0:01, Michael S. Tsirkin wrote:
>>
>>      On Tue, Oct 17, 2023 at 04:42:14PM +0300, Yishai Hadas wrote:
>>
>>          Introduce APIs to execute legacy IO admin commands.
>>
>>          It includes: list_query/use, io_legacy_read/write,
>>          io_legacy_notify_info.
>>
>>          Those APIs will be used by the next patches from this series.
>>
>>          Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>          ---
>>           drivers/virtio/virtio_pci_common.c |  11 ++
>>           drivers/virtio/virtio_pci_common.h |   2 +
>>           drivers/virtio/virtio_pci_modern.c | 206 +++++++++++++++++++++++++++++
>>           include/linux/virtio_pci_admin.h   |  18 +++
>>           4 files changed, 237 insertions(+)
>>           create mode 100644 include/linux/virtio_pci_admin.h
>>
>>          diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
>>          index 6b4766d5abe6..212d68401d2c 100644
>>          --- a/drivers/virtio/virtio_pci_common.c
>>          +++ b/drivers/virtio/virtio_pci_common.c
>>          @@ -645,6 +645,17 @@ static struct pci_driver virtio_pci_driver = {
>>                  .sriov_configure = virtio_pci_sriov_configure,
>>           };
>>
>>          +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev)
>>          +{
>>          +       struct virtio_pci_device *pf_vp_dev;
>>          +
>>          +       pf_vp_dev = pci_iov_get_pf_drvdata(pdev, &virtio_pci_driver);
>>          +       if (IS_ERR(pf_vp_dev))
>>          +               return NULL;
>>          +
>>          +       return &pf_vp_dev->vdev;
>>          +}
>>          +
>>           module_pci_driver(virtio_pci_driver);
>>
>>           MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
>>          diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
>>          index a21b9ba01a60..2785e61ed668 100644
>>          --- a/drivers/virtio/virtio_pci_common.h
>>          +++ b/drivers/virtio/virtio_pci_common.h
>>          @@ -155,4 +155,6 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
>>           int virtio_pci_modern_probe(struct virtio_pci_device *);
>>           void virtio_pci_modern_remove(struct virtio_pci_device *);
>>
>>          +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
>>          +
>>           #endif
>>          diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
>>          index cc159a8e6c70..00b65e20b2f5 100644
>>          --- a/drivers/virtio/virtio_pci_modern.c
>>          +++ b/drivers/virtio/virtio_pci_modern.c
>>          @@ -719,6 +719,212 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
>>                  vp_dev->del_vq(&vp_dev->admin_vq.info);
>>           }
>>
>>          +/*
>>          + * virtio_pci_admin_list_query - Provides to driver list of commands
>>          + * supported for the PCI VF.
>>          + * @dev: VF pci_dev
>>          + * @buf: buffer to hold the returned list
>>          + * @buf_size: size of the given buffer
>>          + *
>>          + * Returns 0 on success, or negative on failure.
>>          + */
>>          +int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
>>          +{
>>          +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>          +       struct virtio_admin_cmd cmd = {};
>>          +       struct scatterlist result_sg;
>>          +
>>          +       if (!virtio_dev)
>>          +               return -ENODEV;
>>          +
>>          +       sg_init_one(&result_sg, buf, buf_size);
>>          +       cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
>>          +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>>          +       cmd.result_sg = &result_sg;
>>          +
>>          +       return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>          +}
>>          +EXPORT_SYMBOL_GPL(virtio_pci_admin_list_query);
>>          +
>>          +/*
>>          + * virtio_pci_admin_list_use - Provides to device list of commands
>>          + * used for the PCI VF.
>>          + * @dev: VF pci_dev
>>          + * @buf: buffer which holds the list
>>          + * @buf_size: size of the given buffer
>>          + *
>>          + * Returns 0 on success, or negative on failure.
>>          + */
>>          +int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
>>          +{
>>          +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>          +       struct virtio_admin_cmd cmd = {};
>>          +       struct scatterlist data_sg;
>>          +
>>          +       if (!virtio_dev)
>>          +               return -ENODEV;
>>          +
>>          +       sg_init_one(&data_sg, buf, buf_size);
>>          +       cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
>>          +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>>          +       cmd.data_sg = &data_sg;
>>          +
>>          +       return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>          +}
>>          +EXPORT_SYMBOL_GPL(virtio_pci_admin_list_use);
>>
>>      list commands are actually for a group, not for the VF.
>>
>> The VF was given to let the function gets the PF from it.
>>
>> For now, the only existing 'group_type' in the spec is SRIOV, this is why we
>> hard-coded it internally to match the VF PCI.
>>
>> Alternatively,
>> We can change the API to get the PF and 'group_type' from the caller to better
>> match future usage.
>> However, this will require to export the virtio_pci_vf_get_pf_dev() API outside
>> virtio-pci.
>>
>> Do you prefer to change to the latter option ?
> No, there are several points I wanted to make but this
> was not one of them.
>
> First, for query, I was trying to suggest changing the comment.
> Something like:
>           + * virtio_pci_admin_list_query - Provides to driver list of commands
>           + * supported for the group including the given member device.
>           + * @dev: member pci device.

Following your suggestion below, to issue inside virtio the query/use 
and keep its data internally (i.e. on the 'admin_queue' context).

We may suggest the below API for the upper-layers (e.g. vfio) to be 
exported.

bool virtio_pci_admin_supported_cmds(struct pci_dev *pdev, u64 cmds)

It will find the PF from the VF and internally will check on the 
'admin_queue' context whether the given 'cmds' input is supported.

Its output will be true/false.

Makes sense ?

> 	
>
>
> Second, I don't think using buf/size  like this is necessary.
> For now we have a small number of commands just work with u64.
OK, just keep in mind that upon issuing the command towards the 
controller this still needs to be an allocated u64 data on the heap to 
work properly.
>
>
> Third, while list could be an OK API, the use API does not
> really work. If you call use with one set of parameters for
> one VF and another for another then they conflict do they not?
>
> So you need virtio core to do the list/use dance for you,
> save the list of commands on the PF (which again is just u64 for now)
> and vfio or vdpa or whatnot will just query that.
> I hope I'm being clear.

In that case the virtio_pci_admin_list_query() and 
virtio_pci_admin_list_use() won't be exported any more and will be 
static in virtio-pci.

They will be called internally as part of activating the admin_queue and 
will simply get struct virtio_device* (the PF) instead of struct pci_dev 
*pdev.

>
>
>>
>>
>>          +
>>          +/*
>>          + * virtio_pci_admin_legacy_io_write - Write legacy registers of a member device
>>          + * @dev: VF pci_dev
>>          + * @opcode: op code of the io write command
>>
>>      opcode is actually either VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE
>>      or VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE correct?
>>
>>      So please just add 2 APIs for this so users don't need to care.
>>      Could be wrappers around these two things.
>>
>>
>> OK.
>>
>> We'll export the below 2 APIs [1] which internally will call
>> virtio_pci_admin_legacy_io_write() with the proper op code hard-coded.
>>
>> [1]virtio_pci_admin_legacy_device_io_write()
>>       virtio_pci_admin_legacy_common_io_write()
>>
>> Yishai
>>
> Makes sense.
>   

OK, we may do the same split for the 'legacy_io_read' commands to be 
symmetric with the 'legacy_io_write', right ?

Yishai

>>
>>          + * @offset: starting byte offset within the registers to write to
>>          + * @size: size of the data to write
>>          + * @buf: buffer which holds the data
>>          + *
>>          + * Returns 0 on success, or negative on failure.
>>          + */
>>          +int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
>>          +                                    u8 offset, u8 size, u8 *buf)
>>          +{
>>          +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>          +       struct virtio_admin_cmd_legacy_wr_data *data;
>>          +       struct virtio_admin_cmd cmd = {};
>>          +       struct scatterlist data_sg;
>>          +       int vf_id;
>>          +       int ret;
>>          +
>>          +       if (!virtio_dev)
>>          +               return -ENODEV;
>>          +
>>          +       vf_id = pci_iov_vf_id(pdev);
>>          +       if (vf_id < 0)
>>          +               return vf_id;
>>          +
>>          +       data = kzalloc(sizeof(*data) + size, GFP_KERNEL);
>>          +       if (!data)
>>          +               return -ENOMEM;
>>          +
>>          +       data->offset = offset;
>>          +       memcpy(data->registers, buf, size);
>>          +       sg_init_one(&data_sg, data, sizeof(*data) + size);
>>          +       cmd.opcode = cpu_to_le16(opcode);
>>          +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>>          +       cmd.group_member_id = cpu_to_le64(vf_id + 1);
>>          +       cmd.data_sg = &data_sg;
>>          +       ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>          +
>>          +       kfree(data);
>>          +       return ret;
>>          +}
>>          +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_write);
>>          +
>>          +/*
>>          + * virtio_pci_admin_legacy_io_read - Read legacy registers of a member device
>>          + * @dev: VF pci_dev
>>          + * @opcode: op code of the io read command
>>          + * @offset: starting byte offset within the registers to read from
>>          + * @size: size of the data to be read
>>          + * @buf: buffer to hold the returned data
>>          + *
>>          + * Returns 0 on success, or negative on failure.
>>          + */
>>          +int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
>>          +                                   u8 offset, u8 size, u8 *buf)
>>          +{
>>          +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>          +       struct virtio_admin_cmd_legacy_rd_data *data;
>>          +       struct scatterlist data_sg, result_sg;
>>          +       struct virtio_admin_cmd cmd = {};
>>          +       int vf_id;
>>          +       int ret;
>>          +
>>          +       if (!virtio_dev)
>>          +               return -ENODEV;
>>          +
>>          +       vf_id = pci_iov_vf_id(pdev);
>>          +       if (vf_id < 0)
>>          +               return vf_id;
>>          +
>>          +       data = kzalloc(sizeof(*data), GFP_KERNEL);
>>          +       if (!data)
>>          +               return -ENOMEM;
>>          +
>>          +       data->offset = offset;
>>          +       sg_init_one(&data_sg, data, sizeof(*data));
>>          +       sg_init_one(&result_sg, buf, size);
>>          +       cmd.opcode = cpu_to_le16(opcode);
>>          +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>>          +       cmd.group_member_id = cpu_to_le64(vf_id + 1);
>>          +       cmd.data_sg = &data_sg;
>>          +       cmd.result_sg = &result_sg;
>>          +       ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>          +
>>          +       kfree(data);
>>          +       return ret;
>>          +}
>>          +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_read);
>>          +
>>          +/*
>>          + * virtio_pci_admin_legacy_io_notify_info - Read the queue notification
>>          + * information for legacy interface
>>          + * @dev: VF pci_dev
>>          + * @req_bar_flags: requested bar flags
>>          + * @bar: on output the BAR number of the member device
>>          + * @bar_offset: on output the offset within bar
>>          + *
>>          + * Returns 0 on success, or negative on failure.
>>          + */
>>          +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
>>          +                                          u8 req_bar_flags, u8 *bar,
>>          +                                          u64 *bar_offset)
>>          +{
>>          +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>          +       struct virtio_admin_cmd_notify_info_result *result;
>>          +       struct virtio_admin_cmd cmd = {};
>>          +       struct scatterlist result_sg;
>>          +       int vf_id;
>>          +       int ret;
>>          +
>>          +       if (!virtio_dev)
>>          +               return -ENODEV;
>>          +
>>          +       vf_id = pci_iov_vf_id(pdev);
>>          +       if (vf_id < 0)
>>          +               return vf_id;
>>          +
>>          +       result = kzalloc(sizeof(*result), GFP_KERNEL);
>>          +       if (!result)
>>          +               return -ENOMEM;
>>          +
>>          +       sg_init_one(&result_sg, result, sizeof(*result));
>>          +       cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO);
>>          +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>>          +       cmd.group_member_id = cpu_to_le64(vf_id + 1);
>>          +       cmd.result_sg = &result_sg;
>>          +       ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>          +       if (!ret) {
>>          +               struct virtio_admin_cmd_notify_info_data *entry;
>>          +               int i;
>>          +
>>          +               ret = -ENOENT;
>>          +               for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
>>          +                       entry = &result->entries[i];
>>          +                       if (entry->flags == VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END)
>>          +                               break;
>>          +                       if (entry->flags != req_bar_flags)
>>          +                               continue;
>>          +                       *bar = entry->bar;
>>          +                       *bar_offset = le64_to_cpu(entry->offset);
>>          +                       ret = 0;
>>          +                       break;
>>          +               }
>>          +       }
>>          +
>>          +       kfree(result);
>>          +       return ret;
>>          +}
>>          +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_notify_info);
>>          +
>>           static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>>                  .get            = NULL,
>>                  .set            = NULL,
>>          diff --git a/include/linux/virtio_pci_admin.h b/include/linux/virtio_pci_admin.h
>>          new file mode 100644
>>          index 000000000000..cb916a4bc1b1
>>          --- /dev/null
>>          +++ b/include/linux/virtio_pci_admin.h
>>          @@ -0,0 +1,18 @@
>>          +/* SPDX-License-Identifier: GPL-2.0 */
>>          +#ifndef _LINUX_VIRTIO_PCI_ADMIN_H
>>          +#define _LINUX_VIRTIO_PCI_ADMIN_H
>>          +
>>          +#include <linux/types.h>
>>          +#include <linux/pci.h>
>>          +
>>          +int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size);
>>          +int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
>>          +int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
>>          +                                    u8 offset, u8 size, u8 *buf);
>>          +int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
>>          +                                   u8 offset, u8 size, u8 *buf);
>>          +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
>>          +                                          u8 req_bar_flags, u8 *bar,
>>          +                                          u64 *bar_offset);
>>          +
>>          +#endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
>>          --
>>          2.27.0
>>
>>

