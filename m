Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DFC7D6E59
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbjJYOEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbjJYOEa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:04:30 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CABF1A5
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:04:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kg10TWDtvaci4ulrtVN6FcnVNL8LXk/2OnI73dejHgIkzC6GPOUpdTLU5SJGzCfqfblN813jnP7Fd46K69D1ien9qg4eEAdpvqnEIs4QzgIEXyJiHaQxqrpD72+1p4NYXq4hBKcMsaiQmofZB/TDEC6pxko/XWoSzyX3hOCbg9CikyMUR9J8asQaYJPM2OUK9a7SGgSydru/ja0w23NytYGZu/VOqpVqum8BxpqBv8hKVg8000INkzqQWuk0cgMyYsvF3f0xG0lUMcEPGupURKvbpyDheLcw2cZjmmVZAp8hsM1/dRxQp2Vq323FKJshwAKCtmhE6AvI8mv84QDLqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Ix25jMDyc1D0TDffnG5OBHetvlRdTznV/RxOtfCp00=;
 b=TMF3OKgm+OIPr7AtflVpkVOK7e6hagukypZ82rLp3Zu5lhVx8RnyGzJNna2j5n8PgEJDvDQS1ASc3uwJ/rxzB43xzEC0kccKxwCHJQ/jaKtF5cSDZjAR1qU25bjoqS+4CSB7lmhM6MtNBeMT38J70tA8KRvU+Ebkoj0fkz4p4S/cmGW+SbhbiQmmg7UgTl2g0vo/nC5ih4rmyZ3Am1LzVbmH3ZlIKv/ibN+xJIBEEVansJJ0nDJpQRVwEGbrhgWVfMWfjplklHWnfHOpr0PmfMjVyFJd1CCsi7htliVgr9wDG9AteCVf4dAyHqYDRM/zzrgdEcs6BqVtYR7mJZGA/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Ix25jMDyc1D0TDffnG5OBHetvlRdTznV/RxOtfCp00=;
 b=VXoqxRVnSI7bopr7o53Bm0Qh92hdsWRUTRIEpxbadIsJ5sIAZAisV/uXnOtFzYXSFnANgibIaneITqgrUfy8ayFD9U2pFUIx58OUbGU9LP8Nqar8z3qpDxk8LJabbABnpmm1tpDk8q34P6FNZdzet6ZN7X2yuN2p0MJNnobmLOknrMPkMqMDiy3iKMRgVvheLHO0srSevI5n8jaGlr5rT+aP7a3q7dEkpMfnRT5otaF660mEK9g7FSip4/otxIowtdmE1scHhW8/ZVWc0Fyg2QEU93PdMRKBlWKad8cefuLiZnIQIg3vQOVG/EcvT1qXAejPiWjZrAb6yb8OvaBtBw==
Received: from CYZPR11CA0024.namprd11.prod.outlook.com (2603:10b6:930:8d::9)
 by IA1PR12MB6652.namprd12.prod.outlook.com (2603:10b6:208:38a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Wed, 25 Oct
 2023 14:04:18 +0000
Received: from CY4PEPF0000EDD5.namprd03.prod.outlook.com
 (2603:10b6:930:8d:cafe::a1) by CYZPR11CA0024.outlook.office365.com
 (2603:10b6:930:8d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19 via Frontend
 Transport; Wed, 25 Oct 2023 14:04:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EDD5.mail.protection.outlook.com (10.167.241.209) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Wed, 25 Oct 2023 14:04:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 25 Oct
 2023 07:04:03 -0700
Received: from [172.27.14.159] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 25 Oct
 2023 07:03:57 -0700
Message-ID: <c6c849b6-e1ff-4319-a199-5abcac032a25@nvidia.com>
Date:   Wed, 25 Oct 2023 17:03:55 +0300
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
 <03c4e0da-7a5c-44bc-98f8-fca8228a9674@nvidia.com>
 <20231025094118-mutt-send-email-mst@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231025094118-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD5:EE_|IA1PR12MB6652:EE_
X-MS-Office365-Filtering-Correlation-Id: 072ff1ff-2a5e-4b2f-5497-08dbd56347e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qjwCQYAQYLBPJBRT4Y5vdra/b6LScKDR8wofybIjNyjXBa7YxqOd5VoM3phc/fBuR7YCZxPzrxVSimGA+JgkEDp2zJBTzycvptObdGPhnwSU4XEHVl7njkf5tabt+RH820vOD1OVqq+2Em/vb0ZfLqpcLTXGE6oAuf5uOexCugIVy6Ia3HaMIz5t56InUJR3Dxkky+yDElVrlyRUzoo5n5J3LdNp/hdWqDgrhuZDH98DC7WhpA+xYcCYIt1K5rEDNgNRR4ZajEDCNZ7TLiQy095pNDWlBNcVIav5FLKJAlFhxCftfngxwOcEW8+O0dp3wsCizki2HfDoY/7DlotiZQvWtb8eSpYE0wMeVNEkBRvjwdhby/KufG4KoHn15kt9+Qz7sjsY2ZTTnwlqK1zskAS6AbE+4AfuvQKcF4pZprUyKfRzrQjVf30s+wJuhH/ERTUAcfVmjrR42ATmCWzunVsFtpM1GXM0Kq1hdah/7jP7dBwjH+6zH2qEXl6yp2UQQY/00zksan2AWW5lXfZdL6SfM7SrjXCaA2gGcR975ec6/dDSwQWRx0Tr6ZJbKIWDDmtp0rTbiqNh2DB79x2Orib+lPLyTmlVP0U+m/eYS83Pc4XofkNadPflbc5CZ5b40Mw+qhfv/9pBWE8y3dtYnWkjN7fDmiKhppRsfXpsvnNcpVxtT4zBXBdTIIn51Cfz+CYdKmtLdoI7O0lxw/T+DZiVAVnyptuoajLdiu1btnIcXRvx6JaYhz1c7nbAgZwOBbYrDFQQdg8j8Dny2Z55xQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(396003)(136003)(346002)(230922051799003)(1800799009)(64100799003)(82310400011)(186009)(451199024)(46966006)(36840700001)(40470700004)(31686004)(30864003)(107886003)(53546011)(26005)(40460700003)(356005)(36756003)(40480700001)(86362001)(31696002)(426003)(36860700001)(7636003)(336012)(16526019)(2906002)(2616005)(478600001)(82740400003)(47076005)(8936002)(4326008)(83380400001)(16576012)(316002)(70586007)(54906003)(5660300002)(41300700001)(6916009)(8676002)(70206006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 14:04:18.6210
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 072ff1ff-2a5e-4b2f-5497-08dbd56347e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EDD5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6652
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 16:44, Michael S. Tsirkin wrote:
> On Wed, Oct 25, 2023 at 04:00:43PM +0300, Yishai Hadas wrote:
>> On 25/10/2023 13:17, Michael S. Tsirkin wrote:
>>> On Wed, Oct 25, 2023 at 12:18:32PM +0300, Yishai Hadas wrote:
>>>> On 25/10/2023 0:01, Michael S. Tsirkin wrote:
>>>>
>>>>       On Tue, Oct 17, 2023 at 04:42:14PM +0300, Yishai Hadas wrote:
>>>>
>>>>           Introduce APIs to execute legacy IO admin commands.
>>>>
>>>>           It includes: list_query/use, io_legacy_read/write,
>>>>           io_legacy_notify_info.
>>>>
>>>>           Those APIs will be used by the next patches from this series.
>>>>
>>>>           Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>>>           ---
>>>>            drivers/virtio/virtio_pci_common.c |  11 ++
>>>>            drivers/virtio/virtio_pci_common.h |   2 +
>>>>            drivers/virtio/virtio_pci_modern.c | 206 +++++++++++++++++++++++++++++
>>>>            include/linux/virtio_pci_admin.h   |  18 +++
>>>>            4 files changed, 237 insertions(+)
>>>>            create mode 100644 include/linux/virtio_pci_admin.h
>>>>
>>>>           diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
>>>>           index 6b4766d5abe6..212d68401d2c 100644
>>>>           --- a/drivers/virtio/virtio_pci_common.c
>>>>           +++ b/drivers/virtio/virtio_pci_common.c
>>>>           @@ -645,6 +645,17 @@ static struct pci_driver virtio_pci_driver = {
>>>>                   .sriov_configure = virtio_pci_sriov_configure,
>>>>            };
>>>>
>>>>           +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev)
>>>>           +{
>>>>           +       struct virtio_pci_device *pf_vp_dev;
>>>>           +
>>>>           +       pf_vp_dev = pci_iov_get_pf_drvdata(pdev, &virtio_pci_driver);
>>>>           +       if (IS_ERR(pf_vp_dev))
>>>>           +               return NULL;
>>>>           +
>>>>           +       return &pf_vp_dev->vdev;
>>>>           +}
>>>>           +
>>>>            module_pci_driver(virtio_pci_driver);
>>>>
>>>>            MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
>>>>           diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
>>>>           index a21b9ba01a60..2785e61ed668 100644
>>>>           --- a/drivers/virtio/virtio_pci_common.h
>>>>           +++ b/drivers/virtio/virtio_pci_common.h
>>>>           @@ -155,4 +155,6 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
>>>>            int virtio_pci_modern_probe(struct virtio_pci_device *);
>>>>            void virtio_pci_modern_remove(struct virtio_pci_device *);
>>>>
>>>>           +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
>>>>           +
>>>>            #endif
>>>>           diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
>>>>           index cc159a8e6c70..00b65e20b2f5 100644
>>>>           --- a/drivers/virtio/virtio_pci_modern.c
>>>>           +++ b/drivers/virtio/virtio_pci_modern.c
>>>>           @@ -719,6 +719,212 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
>>>>                   vp_dev->del_vq(&vp_dev->admin_vq.info);
>>>>            }
>>>>
>>>>           +/*
>>>>           + * virtio_pci_admin_list_query - Provides to driver list of commands
>>>>           + * supported for the PCI VF.
>>>>           + * @dev: VF pci_dev
>>>>           + * @buf: buffer to hold the returned list
>>>>           + * @buf_size: size of the given buffer
>>>>           + *
>>>>           + * Returns 0 on success, or negative on failure.
>>>>           + */
>>>>           +int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
>>>>           +{
>>>>           +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>>>           +       struct virtio_admin_cmd cmd = {};
>>>>           +       struct scatterlist result_sg;
>>>>           +
>>>>           +       if (!virtio_dev)
>>>>           +               return -ENODEV;
>>>>           +
>>>>           +       sg_init_one(&result_sg, buf, buf_size);
>>>>           +       cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
>>>>           +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>>>>           +       cmd.result_sg = &result_sg;
>>>>           +
>>>>           +       return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>>>           +}
>>>>           +EXPORT_SYMBOL_GPL(virtio_pci_admin_list_query);
>>>>           +
>>>>           +/*
>>>>           + * virtio_pci_admin_list_use - Provides to device list of commands
>>>>           + * used for the PCI VF.
>>>>           + * @dev: VF pci_dev
>>>>           + * @buf: buffer which holds the list
>>>>           + * @buf_size: size of the given buffer
>>>>           + *
>>>>           + * Returns 0 on success, or negative on failure.
>>>>           + */
>>>>           +int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
>>>>           +{
>>>>           +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>>>           +       struct virtio_admin_cmd cmd = {};
>>>>           +       struct scatterlist data_sg;
>>>>           +
>>>>           +       if (!virtio_dev)
>>>>           +               return -ENODEV;
>>>>           +
>>>>           +       sg_init_one(&data_sg, buf, buf_size);
>>>>           +       cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
>>>>           +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>>>>           +       cmd.data_sg = &data_sg;
>>>>           +
>>>>           +       return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>>>           +}
>>>>           +EXPORT_SYMBOL_GPL(virtio_pci_admin_list_use);
>>>>
>>>>       list commands are actually for a group, not for the VF.
>>>>
>>>> The VF was given to let the function gets the PF from it.
>>>>
>>>> For now, the only existing 'group_type' in the spec is SRIOV, this is why we
>>>> hard-coded it internally to match the VF PCI.
>>>>
>>>> Alternatively,
>>>> We can change the API to get the PF and 'group_type' from the caller to better
>>>> match future usage.
>>>> However, this will require to export the virtio_pci_vf_get_pf_dev() API outside
>>>> virtio-pci.
>>>>
>>>> Do you prefer to change to the latter option ?
>>> No, there are several points I wanted to make but this
>>> was not one of them.
>>>
>>> First, for query, I was trying to suggest changing the comment.
>>> Something like:
>>>            + * virtio_pci_admin_list_query - Provides to driver list of commands
>>>            + * supported for the group including the given member device.
>>>            + * @dev: member pci device.
>> Following your suggestion below, to issue inside virtio the query/use and
>> keep its data internally (i.e. on the 'admin_queue' context).
>>
>> We may suggest the below API for the upper-layers (e.g. vfio) to be
>> exported.
>>
>> bool virtio_pci_admin_supported_cmds(struct pci_dev *pdev, u64 cmds)
>>
>> It will find the PF from the VF and internally will check on the
>> 'admin_queue' context whether the given 'cmds' input is supported.
>>
>> Its output will be true/false.
>>
>> Makes sense ?
>>
>>> 	
>>>
>>>
>>> Second, I don't think using buf/size  like this is necessary.
>>> For now we have a small number of commands just work with u64.
>> OK, just keep in mind that upon issuing the command towards the controller
>> this still needs to be an allocated u64 data on the heap to work properly.
>>>
>>> Third, while list could be an OK API, the use API does not
>>> really work. If you call use with one set of parameters for
>>> one VF and another for another then they conflict do they not?
>>>
>>> So you need virtio core to do the list/use dance for you,
>>> save the list of commands on the PF (which again is just u64 for now)
>>> and vfio or vdpa or whatnot will just query that.
>>> I hope I'm being clear.
>> In that case the virtio_pci_admin_list_query() and
>> virtio_pci_admin_list_use() won't be exported any more and will be static in
>> virtio-pci.
>>
>> They will be called internally as part of activating the admin_queue and
>> will simply get struct virtio_device* (the PF) instead of struct pci_dev
>> *pdev.
>
> Yes - I think some kind of API will be needed to setup/cleanup.
> Then 1st call to setup would do the list/use dance? some ref counting?

OK, we may work to come in V2 with that option in place.

Please note that the initialization 'list/use' commands would be done as 
part of the admin queue activation but we can't enable the admin queue 
for the upper layers before that it was done.

So, we may consider skipping the ref count set/get as part of the 
initialization flow with some flag/detection of the list/use commands as 
the ref count setting enables the admin queue for upper-layers which we 
would like to prevent by that time.

>
> And maybe the API should just be
> bool virtio_pci_admin_has_legacy_io()

This can work as well.

In that case, the API will just get the VF PCI to get from it the PF + 
'admin_queue' context and will check internally that all current 5 
legacy commands are supported.

Yishai

>
>
>
>>>
>>>>
>>>>           +
>>>>           +/*
>>>>           + * virtio_pci_admin_legacy_io_write - Write legacy registers of a member device
>>>>           + * @dev: VF pci_dev
>>>>           + * @opcode: op code of the io write command
>>>>
>>>>       opcode is actually either VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE
>>>>       or VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE correct?
>>>>
>>>>       So please just add 2 APIs for this so users don't need to care.
>>>>       Could be wrappers around these two things.
>>>>
>>>>
>>>> OK.
>>>>
>>>> We'll export the below 2 APIs [1] which internally will call
>>>> virtio_pci_admin_legacy_io_write() with the proper op code hard-coded.
>>>>
>>>> [1]virtio_pci_admin_legacy_device_io_write()
>>>>        virtio_pci_admin_legacy_common_io_write()
>>>>
>>>> Yishai
>>>>
>>> Makes sense.
>> OK, we may do the same split for the 'legacy_io_read' commands to be
>> symmetric with the 'legacy_io_write', right ?
>>
>> Yishai
> makes sense.
>
>>>>           + * @offset: starting byte offset within the registers to write to
>>>>           + * @size: size of the data to write
>>>>           + * @buf: buffer which holds the data
>>>>           + *
>>>>           + * Returns 0 on success, or negative on failure.
>>>>           + */
>>>>           +int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
>>>>           +                                    u8 offset, u8 size, u8 *buf)
>>>>           +{
>>>>           +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>>>           +       struct virtio_admin_cmd_legacy_wr_data *data;
>>>>           +       struct virtio_admin_cmd cmd = {};
>>>>           +       struct scatterlist data_sg;
>>>>           +       int vf_id;
>>>>           +       int ret;
>>>>           +
>>>>           +       if (!virtio_dev)
>>>>           +               return -ENODEV;
>>>>           +
>>>>           +       vf_id = pci_iov_vf_id(pdev);
>>>>           +       if (vf_id < 0)
>>>>           +               return vf_id;
>>>>           +
>>>>           +       data = kzalloc(sizeof(*data) + size, GFP_KERNEL);
>>>>           +       if (!data)
>>>>           +               return -ENOMEM;
>>>>           +
>>>>           +       data->offset = offset;
>>>>           +       memcpy(data->registers, buf, size);
>>>>           +       sg_init_one(&data_sg, data, sizeof(*data) + size);
>>>>           +       cmd.opcode = cpu_to_le16(opcode);
>>>>           +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>>>>           +       cmd.group_member_id = cpu_to_le64(vf_id + 1);
>>>>           +       cmd.data_sg = &data_sg;
>>>>           +       ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>>>           +
>>>>           +       kfree(data);
>>>>           +       return ret;
>>>>           +}
>>>>           +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_write);
>>>>           +
>>>>           +/*
>>>>           + * virtio_pci_admin_legacy_io_read - Read legacy registers of a member device
>>>>           + * @dev: VF pci_dev
>>>>           + * @opcode: op code of the io read command
>>>>           + * @offset: starting byte offset within the registers to read from
>>>>           + * @size: size of the data to be read
>>>>           + * @buf: buffer to hold the returned data
>>>>           + *
>>>>           + * Returns 0 on success, or negative on failure.
>>>>           + */
>>>>           +int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
>>>>           +                                   u8 offset, u8 size, u8 *buf)
>>>>           +{
>>>>           +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>>>           +       struct virtio_admin_cmd_legacy_rd_data *data;
>>>>           +       struct scatterlist data_sg, result_sg;
>>>>           +       struct virtio_admin_cmd cmd = {};
>>>>           +       int vf_id;
>>>>           +       int ret;
>>>>           +
>>>>           +       if (!virtio_dev)
>>>>           +               return -ENODEV;
>>>>           +
>>>>           +       vf_id = pci_iov_vf_id(pdev);
>>>>           +       if (vf_id < 0)
>>>>           +               return vf_id;
>>>>           +
>>>>           +       data = kzalloc(sizeof(*data), GFP_KERNEL);
>>>>           +       if (!data)
>>>>           +               return -ENOMEM;
>>>>           +
>>>>           +       data->offset = offset;
>>>>           +       sg_init_one(&data_sg, data, sizeof(*data));
>>>>           +       sg_init_one(&result_sg, buf, size);
>>>>           +       cmd.opcode = cpu_to_le16(opcode);
>>>>           +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>>>>           +       cmd.group_member_id = cpu_to_le64(vf_id + 1);
>>>>           +       cmd.data_sg = &data_sg;
>>>>           +       cmd.result_sg = &result_sg;
>>>>           +       ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>>>           +
>>>>           +       kfree(data);
>>>>           +       return ret;
>>>>           +}
>>>>           +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_read);
>>>>           +
>>>>           +/*
>>>>           + * virtio_pci_admin_legacy_io_notify_info - Read the queue notification
>>>>           + * information for legacy interface
>>>>           + * @dev: VF pci_dev
>>>>           + * @req_bar_flags: requested bar flags
>>>>           + * @bar: on output the BAR number of the member device
>>>>           + * @bar_offset: on output the offset within bar
>>>>           + *
>>>>           + * Returns 0 on success, or negative on failure.
>>>>           + */
>>>>           +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
>>>>           +                                          u8 req_bar_flags, u8 *bar,
>>>>           +                                          u64 *bar_offset)
>>>>           +{
>>>>           +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>>>           +       struct virtio_admin_cmd_notify_info_result *result;
>>>>           +       struct virtio_admin_cmd cmd = {};
>>>>           +       struct scatterlist result_sg;
>>>>           +       int vf_id;
>>>>           +       int ret;
>>>>           +
>>>>           +       if (!virtio_dev)
>>>>           +               return -ENODEV;
>>>>           +
>>>>           +       vf_id = pci_iov_vf_id(pdev);
>>>>           +       if (vf_id < 0)
>>>>           +               return vf_id;
>>>>           +
>>>>           +       result = kzalloc(sizeof(*result), GFP_KERNEL);
>>>>           +       if (!result)
>>>>           +               return -ENOMEM;
>>>>           +
>>>>           +       sg_init_one(&result_sg, result, sizeof(*result));
>>>>           +       cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO);
>>>>           +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>>>>           +       cmd.group_member_id = cpu_to_le64(vf_id + 1);
>>>>           +       cmd.result_sg = &result_sg;
>>>>           +       ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>>>           +       if (!ret) {
>>>>           +               struct virtio_admin_cmd_notify_info_data *entry;
>>>>           +               int i;
>>>>           +
>>>>           +               ret = -ENOENT;
>>>>           +               for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
>>>>           +                       entry = &result->entries[i];
>>>>           +                       if (entry->flags == VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END)
>>>>           +                               break;
>>>>           +                       if (entry->flags != req_bar_flags)
>>>>           +                               continue;
>>>>           +                       *bar = entry->bar;
>>>>           +                       *bar_offset = le64_to_cpu(entry->offset);
>>>>           +                       ret = 0;
>>>>           +                       break;
>>>>           +               }
>>>>           +       }
>>>>           +
>>>>           +       kfree(result);
>>>>           +       return ret;
>>>>           +}
>>>>           +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_notify_info);
>>>>           +
>>>>            static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>>>>                   .get            = NULL,
>>>>                   .set            = NULL,
>>>>           diff --git a/include/linux/virtio_pci_admin.h b/include/linux/virtio_pci_admin.h
>>>>           new file mode 100644
>>>>           index 000000000000..cb916a4bc1b1
>>>>           --- /dev/null
>>>>           +++ b/include/linux/virtio_pci_admin.h
>>>>           @@ -0,0 +1,18 @@
>>>>           +/* SPDX-License-Identifier: GPL-2.0 */
>>>>           +#ifndef _LINUX_VIRTIO_PCI_ADMIN_H
>>>>           +#define _LINUX_VIRTIO_PCI_ADMIN_H
>>>>           +
>>>>           +#include <linux/types.h>
>>>>           +#include <linux/pci.h>
>>>>           +
>>>>           +int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size);
>>>>           +int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
>>>>           +int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
>>>>           +                                    u8 offset, u8 size, u8 *buf);
>>>>           +int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
>>>>           +                                   u8 offset, u8 size, u8 *buf);
>>>>           +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
>>>>           +                                          u8 req_bar_flags, u8 *bar,
>>>>           +                                          u64 *bar_offset);
>>>>           +
>>>>           +#endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
>>>>           --
>>>>           2.27.0
>>>>
>>>>

