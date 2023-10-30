Return-Path: <kvm+bounces-87-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 377297DBD75
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:07:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF3452814B1
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17A218C25;
	Mon, 30 Oct 2023 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DLEMAFk1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6478718C17
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:07:17 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BB993
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:07:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmZg9PW4YcyfdzXNX68tJ1Gsu59HrLxHPQMxfLLXOPzIYFyFggvCnRyZE/I8BexVlPUFWYQlcWwy0HXAbySFv39Yl1uaUj7Gnrc6NEMANwo+Hvkr4O07WLwMnHZiqK7wk8V2bjuJlUY7nP1KLzshjyL1Lc/3QiWltUipBGyEeoUx3lEdRq2jf2zfXwIOIrkFBBap9iMrQeIaKrDMnPBnktCx/CbCNV7H4xx6HZoilSOlougbeDTjOMqPT5Z5aguokoG6ELPBxbmReLfMpeXCpgvUcZy2wyTKHv5t+NnJHaOshJrUJx8sfJxYWS7BOqUj1F1rxcL35Zc9pQODOfiopA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MoAGjrdPrNIY/qGNNIUck3Q3G9HOqeWHGIFSUIeM0JY=;
 b=dmi90o8PL+lptR2u3rlcd+TtcDsi/okaTiKg6+KSGp9bwr4Z2bRuP3Aox+m8SE6EyiIei8PobBF0zOsQ3r71V/w6hl7r2DGTTj9cnxHoilUYdtX1IQnkytv0+u0RbCj4LV4uLzIAlfVk7HZzbj/2MKcuSBDKYWMqbtHm7BO0MWGBeVr781xt5fSvsg6XV+LkVeseCihRWFjhQZu8MCPKRhgBTdPubdTs4ttVhw8iP4L7trvtGGLAlIvK8Ay+s83e9WAhQtlElc3hWkgo7MGw48E9U0+9gziTkzRt/+sktRNKJGCI9Y5RL+6Z/4gPPTKiyjfzNlTrpTeHlcP5mf5hpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MoAGjrdPrNIY/qGNNIUck3Q3G9HOqeWHGIFSUIeM0JY=;
 b=DLEMAFk1U6f1lCNh1SsWCPvubCrtabxheRmz4QdiA1of0YaIex5EgHp3x9c5Z5UW7h8LfuYHhrhrDBIXIZN2qFhi8kfIB1HNvEBqvXEPpT0l02EecbMtmHeD7KvyTcxw0rCrh0z2OHK+ZdjZuXk9+Jj1nZ8uc1SWC41NaqQQMgRFFqY1bVWSBk1vqE8AQLHvBHuN7iBigdFORXewzTPAIng5sUWlmBVik1KlHbmqvPUyZYWHaG6HP/1R6qcA9SljR3Xt9n0bruw7rq12djE8lkS1l3QtiH6xpfAjAMtYmEZBqf15TWuv0qINs4cZmGi1wZoE6q0flChto7EW5U5DBg==
Received: from BL1PR13CA0382.namprd13.prod.outlook.com (2603:10b6:208:2c0::27)
 by SN7PR12MB6911.namprd12.prod.outlook.com (2603:10b6:806:261::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.23; Mon, 30 Oct
 2023 16:07:13 +0000
Received: from BL6PEPF0001AB75.namprd02.prod.outlook.com
 (2603:10b6:208:2c0:cafe::e4) by BL1PR13CA0382.outlook.office365.com
 (2603:10b6:208:2c0::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.11 via Frontend
 Transport; Mon, 30 Oct 2023 16:07:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB75.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Mon, 30 Oct 2023 16:07:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 30 Oct
 2023 09:06:52 -0700
Received: from [172.27.14.170] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 30 Oct
 2023 09:06:48 -0700
Message-ID: <4e95d66c-c382-4612-8d4b-7ff2b0acd3fb@nvidia.com>
Date: Mon, 30 Oct 2023 18:06:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 vfio 5/9] virtio-pci: Initialize the supported admin
 commands
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <alex.williamson@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-6-yishaih@nvidia.com>
 <20231029160750-mutt-send-email-mst@kernel.org>
 <bb8df2c8-74b5-4666-beda-550248a88890@nvidia.com>
 <20231030115541-mutt-send-email-mst@kernel.org>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231030115541-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB75:EE_|SN7PR12MB6911:EE_
X-MS-Office365-Filtering-Correlation-Id: 6239e1ae-c3eb-4ccc-0757-08dbd96247a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2GIAiELWGN8EcGW+8tpHL4Z/QFPnlaSjcz57WXYdMgPw6G24RoLQBEs/x5DFgOrE1p21iguYaM3cRd6jAOy7tdGGa9XzAiDXVwnepG7bjKYMU1JMUoy+Z6LHc6QRyx8av/hFCPqhNvm2Fw+kwmp5mXV0wAGz6oMRGyapTG9VBxEli4kLoXv9kyzuKCTLX8PWet14Nw0VM7OAr0ENBVqzSe7JTlNfhsVBwT83N3I8chKc0X8yrYYpPI2EjSaGJ6Qkt/GrPekubqf3tsaT6+IIkbbFxoMBRpJ5gWe/4MX50T67Dpq6iKhYL7R6ngLIVrNyndnfOwNbz43zJfMYsYxUu4fIJlKjng/u/quBzNzmQxNUNEeBRbG/xYZWR5NjihXBAvGorXOy1NUergWdUiK7ENZZBDTzVqtKMGF1XnhVMF3bMQTttxjcZyjt7xP01tQ/JXl6DV7WMSrdjb99O2mvnR+5n3CEOJMsZiQ+vCBSzC01ixnOXctTAqbeHLbs8pWw5ACSZT17vgcIBh46sgO57IVHBhfwffwPAMH295Hfc2HHXZGrodQaMymD/HtKH6dKAeV3wEbcwU+WNuam2P0W9qyfzeOvYDS/6zVP7fm5NAmQB5P/xPJX9laP5Y/lgDV+Bffs8Lf6iV0kvPSUyyFCn44XSxbblQ656z64X7bADZTos2QwzQlG69f0U+pkCtTI+yKbSSYjbNMnl20yfzCABKdiSbMSkzXtmR58voTfL7D96kbwcrM35c/SA+mi3r4ZEWB1NFdG3/SnpVbOEwMocQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(39860400002)(346002)(136003)(230922051799003)(64100799003)(1800799009)(82310400011)(451199024)(186009)(36840700001)(40470700004)(46966006)(31696002)(8676002)(86362001)(8936002)(31686004)(4326008)(41300700001)(7636003)(5660300002)(2906002)(83380400001)(70206006)(54906003)(70586007)(6916009)(316002)(16576012)(336012)(426003)(356005)(16526019)(36860700001)(40480700001)(53546011)(6666004)(478600001)(40460700003)(47076005)(36756003)(2616005)(107886003)(82740400003)(26005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 16:07:13.2980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6239e1ae-c3eb-4ccc-0757-08dbd96247a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB75.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6911

On 30/10/2023 17:57, Michael S. Tsirkin wrote:
> On Mon, Oct 30, 2023 at 05:27:50PM +0200, Yishai Hadas wrote:
>> On 29/10/2023 22:17, Michael S. Tsirkin wrote:
>>> On Sun, Oct 29, 2023 at 05:59:48PM +0200, Yishai Hadas wrote:
>>>> Initialize the supported admin commands upon activating the admin queue.
>>>>
>>>> The supported commands are saved as part of the admin queue context, it
>>>> will be used by the next patches from this series.
>>>>
>>>> Note:
>>>> As we don't want to let upper layers to execute admin commands before
>>>> that this initialization step was completed, we set ref count to 1 only
>>>> post of that flow and use a non ref counted version command for this
>>>> internal flow.
>>>>
>>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>>> ---
>>>>    drivers/virtio/virtio_pci_common.h |  1 +
>>>>    drivers/virtio/virtio_pci_modern.c | 77 +++++++++++++++++++++++++++++-
>>>>    2 files changed, 77 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
>>>> index a21b9ba01a60..9e07e556a51a 100644
>>>> --- a/drivers/virtio/virtio_pci_common.h
>>>> +++ b/drivers/virtio/virtio_pci_common.h
>>>> @@ -46,6 +46,7 @@ struct virtio_pci_admin_vq {
>>>>    	struct virtio_pci_vq_info info;
>>>>    	struct completion flush_done;
>>>>    	refcount_t refcount;
>>>> +	u64 supported_cmds;
>>>>    	/* Name of the admin queue: avq.$index. */
>>>>    	char name[10];
>>>>    	u16 vq_index;
>>>> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
>>>> index ccd7a4d9f57f..25e27aa79cab 100644
>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>> @@ -19,6 +19,9 @@
>>>>    #define VIRTIO_RING_NO_LEGACY
>>>>    #include "virtio_pci_common.h"
>>>> +static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
>>>> +				    struct virtio_admin_cmd *cmd);
>>>> +
>>> I don't much like forward declarations. Just order functions sensibly
>>> and they will not be needed.
>> OK, will be part of V3.
>>
>>>>    static u64 vp_get_features(struct virtio_device *vdev)
>>>>    {
>>>>    	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>> @@ -59,6 +62,42 @@ vp_modern_avq_set_abort(struct virtio_pci_admin_vq *admin_vq, bool abort)
>>>>    	WRITE_ONCE(admin_vq->abort, abort);
>>>>    }
>>>> +static void virtio_pci_admin_init_cmd_list(struct virtio_device *virtio_dev)
>>>> +{
>>>> +	struct virtio_pci_device *vp_dev = to_vp_device(virtio_dev);
>>>> +	struct virtio_admin_cmd cmd = {};
>>>> +	struct scatterlist result_sg;
>>>> +	struct scatterlist data_sg;
>>>> +	__le64 *data;
>>>> +	int ret;
>>>> +
>>>> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
>>>> +	if (!data)
>>>> +		return;
>>>> +
>>>> +	sg_init_one(&result_sg, data, sizeof(*data));
>>>> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
>>>> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>>>> +	cmd.result_sg = &result_sg;
>>>> +
>>>> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>>> +	if (ret)
>>>> +		goto end;
>>>> +
>>>> +	sg_init_one(&data_sg, data, sizeof(*data));
>>>> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
>>>> +	cmd.data_sg = &data_sg;
>>>> +	cmd.result_sg = NULL;
>>>> +
>>>> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>>>> +	if (ret)
>>>> +		goto end;
>>>> +
>>>> +	vp_dev->admin_vq.supported_cmds = le64_to_cpu(*data);
>>>> +end:
>>>> +	kfree(data);
>>>> +}
>>>> +
>>>>    static void vp_modern_avq_activate(struct virtio_device *vdev)
>>>>    {
>>>>    	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>> @@ -67,6 +106,7 @@ static void vp_modern_avq_activate(struct virtio_device *vdev)
>>>>    	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
>>>>    		return;
>>>> +	virtio_pci_admin_init_cmd_list(vdev);
>>>>    	init_completion(&admin_vq->flush_done);
>>>>    	refcount_set(&admin_vq->refcount, 1);
>>>>    	vp_modern_avq_set_abort(admin_vq, false);
>>>> @@ -562,6 +602,35 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
>>>>    	return true;
>>>>    }
>>>> +static int __virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
>>>> +				    struct scatterlist **sgs,
>>>> +				    unsigned int out_num,
>>>> +				    unsigned int in_num,
>>>> +				    void *data,
>>>> +				    gfp_t gfp)
>>>> +{
>>>> +	struct virtqueue *vq;
>>>> +	int ret, len;
>>>> +
>>>> +	vq = admin_vq->info.vq;
>>>> +
>>>> +	ret = virtqueue_add_sgs(vq, sgs, out_num, in_num, data, gfp);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	if (unlikely(!virtqueue_kick(vq)))
>>>> +		return -EIO;
>>>> +
>>>> +	while (!virtqueue_get_buf(vq, &len) &&
>>>> +	       !virtqueue_is_broken(vq))
>>>> +		cpu_relax();
>>>> +
>>>> +	if (virtqueue_is_broken(vq))
>>>> +		return -EIO;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>> This is tolerable I guess but it might pin the CPU for a long time.
>>> The difficulty is handling suprize removal well which we currently
>>> don't do with interrupts. I would say it's ok as is but add
>>> a TODO comments along the lines of /* TODO: use interrupts once these virtqueue_is_broken */
>> I assume that you asked for adding the below comment before the while loop:
>> /* TODO use interrupts to reduce cpu cycles in the future */
>>
>> Right ?
>>
>> Yishai
> Well I wrote what I meant. in the future is redundant - everyone knows
> we can't change the past.

I agree, no need for 'in the future'.

However, in your suggestion you mentioned  "once these virtqueue_is_broken".

What does that mean in current polling mode ?

Yishai

>
>>>>    static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
>>>>    				    struct scatterlist **sgs,
>>>>    				    unsigned int out_num,
>>>> @@ -653,7 +722,13 @@ static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
>>>>    		in_num++;
>>>>    	}
>>>> -	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
>>>> +	if (cmd->opcode == VIRTIO_ADMIN_CMD_LIST_QUERY ||
>>>> +	    cmd->opcode == VIRTIO_ADMIN_CMD_LIST_USE)
>>>> +		ret = __virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
>>>> +				       out_num, in_num,
>>>> +				       sgs, GFP_KERNEL);
>>>> +	else
>>>> +		ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
>>>>    				       out_num, in_num,
>>>>    				       sgs, GFP_KERNEL);
>>>>    	if (ret) {
>>>> -- 
>>>> 2.27.0



