Return-Path: <kvm+bounces-71-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F23D7DBC94
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:28:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A506B20E27
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 15:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C2B18AEE;
	Mon, 30 Oct 2023 15:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l6dBPT1j"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB0115EAA
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 15:28:16 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3FDA9
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 08:28:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaD/QMsASgcGj/R3jIwGRGP0A8sirUzxFzKTTVK65XatXQUz5JHvKiu6BOpOU1wW0nVQTacD6isT7matJ9MeHTl6sbmywzkOewCFYGiT9WC7VaH4Ah8W41PpujNHbyOIQKGBIFhpPxnsHT/jfORW8gJU9AAh7sVbVMygdxDpKLtKHoxrdG2Eb6pOAuKIRqBYZE3cafpj1TmWKc8RsKvGFYbZmbfH2tzNUAwtfvSAoRIHknXNxACA7oEuGuXdaK2LbazQSnQQ2jEXNxCt0J0nyxUhFoYwjkMBoLptw8MIcqKe9+PFlCWyYjNxSu6dQwCuxPRZk2kSl1dJ3UM1/g9uaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9B6BGtAiDH9m1lPEhKPN9MCbFeL5yxwicpd2EhQcC+8=;
 b=fNnSSIowp1KfoegY6NHlKPqhSDrD1UlVAkEmEKouEBngEN+Yyk9csaCwXLMA8G4qUjai29Pl59zB2UQ9ryhmLBL8pLx5dLvCWMItESukcuO77krv0lnpcnp+JcJQFHqv+Vt/luSLwY7nfm6Hfr+VbOCUr6ebMCTE2NYqB9BiCGLfmPVNQPxLMXyrx10O2QW++OlsFEbgMlnfYwOl/1ZXrhkVsvJazyE4hNweuuDxVzpLtWP5TY/uoqqDzhUS207NjMioG5wmpPI5dJfbA5cmtuf3Wesz+4Hn8QTqNiKZfhE0JXy8WzRW0u8/8EDzx5saQ+t7aNG6tCCj6bpzGxZHFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9B6BGtAiDH9m1lPEhKPN9MCbFeL5yxwicpd2EhQcC+8=;
 b=l6dBPT1junPL3RLLJcjUQycVjwS4Fn55mJQzSKdbeK/TnwOQztSN/AXfySt3ACn4ozP2HXqinsfbkXXsNArDUun8oiJk/B/tDlM2JKF73CAwiHxychqmePD0ji1pUwMehh5ryPRDfCJXN7ZPvBCyFv7NgrLObUVgyTmZQluBFl9dAWk5mmQEBo0yuZsiOUUfrTI9z1CoEvXIzYn5nGjXAuOICp0x5SALJ/uWBkjmtv36Sy9LXY1827FI5PN9hKm/X0Hh/GJFC+du1QG4B7UpGTca+1eGGf+5qcYP/SXTLrH7CMBks50lGpf3/SUxYVCnVo2+BijKmgTDFBvDGN6sfg==
Received: from BL1P221CA0030.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::21)
 by DM4PR12MB7624.namprd12.prod.outlook.com (2603:10b6:8:107::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Mon, 30 Oct
 2023 15:28:13 +0000
Received: from BL02EPF0001A103.namprd05.prod.outlook.com
 (2603:10b6:208:2c5:cafe::6) by BL1P221CA0030.outlook.office365.com
 (2603:10b6:208:2c5::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28 via Frontend
 Transport; Mon, 30 Oct 2023 15:28:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A103.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Mon, 30 Oct 2023 15:28:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 30 Oct
 2023 08:27:57 -0700
Received: from [172.27.14.170] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 30 Oct
 2023 08:27:53 -0700
Message-ID: <bb8df2c8-74b5-4666-beda-550248a88890@nvidia.com>
Date: Mon, 30 Oct 2023 17:27:50 +0200
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
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231029160750-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A103:EE_|DM4PR12MB7624:EE_
X-MS-Office365-Filtering-Correlation-Id: bc060394-d049-4044-c32b-08dbd95cd49b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kiP/R8Ppc7PCLgjJ2vCxR2Jb7c2yPKBn9b4yiUsHxDxsqndjdFnvDyA1MCF8xEw1aov08d/jqZezugOyTpGhzNg3QKNkvsPN81nHlwWLnNND9KYSN3BXbMbU/Qk1nWAcwpcDD9ohVotL+TB825y0zO18CwQ7WEuVG2uegCJGUV/f1B//pFGmM2J+R7lj4hz8HJhH6x53w5x36314IyS2jh/jgdyE24n6YxOyvM04JzI9Bqav2HImm/lWKrCwY+q6v629CBnC+oA8vGT0ttJdbvsKlmjrCvA23m4euP9PMrbkmHcBGhzxvul35Ib1z/ychgUsETA5ZwoEfKux9tixPZstx5ea6SYIdaj+eJS+WYIUmz8PnSaKN0VGeBJGJLQTTYf1il+9FwE81kt9v4IQ8j4lPpBY3HTWueq2jxVjV7Rry0QYNReqOA9O8ZtZkZ8cFZgRvYOiqnpffgvVudPG2v4G5tDa9RAXm6BnHmhDvILKzuUqCD7hfivBwc+vbPQcGS0eOitELpcOx4OfqB+MbJp/S0j6EYJYVMFgJnq5IJxkFlTEv+jB35DsZA4Mnz5JdLW66yNNQ6BcnfRXjLzXE2oshkNW1kf0KlDF6RcQcbsVg4st+FiFudXrKFadwfc4FHbLlOJiEUoNpe6Zg/9O+CrFXFVKACJyx+weneYyvRujOdav9RV/G6FyPi6AajE0JEN6uS4Ri08GmsvAg78GIZ898bHKtvvPgumaPBCaItSxEKSPEx70NGfdRrMRX84E/s7frReVGUXiDcy9JAFTGw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(396003)(39860400002)(346002)(230922051799003)(82310400011)(186009)(1800799009)(64100799003)(451199024)(36840700001)(40470700004)(46966006)(31686004)(16576012)(40460700003)(2906002)(5660300002)(41300700001)(4326008)(8676002)(8936002)(36756003)(40480700001)(31696002)(86362001)(82740400003)(107886003)(316002)(54906003)(36860700001)(6916009)(47076005)(356005)(7636003)(70586007)(70206006)(83380400001)(16526019)(426003)(26005)(2616005)(336012)(53546011)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 15:28:12.8222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc060394-d049-4044-c32b-08dbd95cd49b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A103.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7624

On 29/10/2023 22:17, Michael S. Tsirkin wrote:
> On Sun, Oct 29, 2023 at 05:59:48PM +0200, Yishai Hadas wrote:
>> Initialize the supported admin commands upon activating the admin queue.
>>
>> The supported commands are saved as part of the admin queue context, it
>> will be used by the next patches from this series.
>>
>> Note:
>> As we don't want to let upper layers to execute admin commands before
>> that this initialization step was completed, we set ref count to 1 only
>> post of that flow and use a non ref counted version command for this
>> internal flow.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/virtio/virtio_pci_common.h |  1 +
>>   drivers/virtio/virtio_pci_modern.c | 77 +++++++++++++++++++++++++++++-
>>   2 files changed, 77 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
>> index a21b9ba01a60..9e07e556a51a 100644
>> --- a/drivers/virtio/virtio_pci_common.h
>> +++ b/drivers/virtio/virtio_pci_common.h
>> @@ -46,6 +46,7 @@ struct virtio_pci_admin_vq {
>>   	struct virtio_pci_vq_info info;
>>   	struct completion flush_done;
>>   	refcount_t refcount;
>> +	u64 supported_cmds;
>>   	/* Name of the admin queue: avq.$index. */
>>   	char name[10];
>>   	u16 vq_index;
>> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
>> index ccd7a4d9f57f..25e27aa79cab 100644
>> --- a/drivers/virtio/virtio_pci_modern.c
>> +++ b/drivers/virtio/virtio_pci_modern.c
>> @@ -19,6 +19,9 @@
>>   #define VIRTIO_RING_NO_LEGACY
>>   #include "virtio_pci_common.h"
>>   
>> +static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
>> +				    struct virtio_admin_cmd *cmd);
>> +
> I don't much like forward declarations. Just order functions sensibly
> and they will not be needed.

OK, will be part of V3.

>
>>   static u64 vp_get_features(struct virtio_device *vdev)
>>   {
>>   	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>> @@ -59,6 +62,42 @@ vp_modern_avq_set_abort(struct virtio_pci_admin_vq *admin_vq, bool abort)
>>   	WRITE_ONCE(admin_vq->abort, abort);
>>   }
>>   
>> +static void virtio_pci_admin_init_cmd_list(struct virtio_device *virtio_dev)
>> +{
>> +	struct virtio_pci_device *vp_dev = to_vp_device(virtio_dev);
>> +	struct virtio_admin_cmd cmd = {};
>> +	struct scatterlist result_sg;
>> +	struct scatterlist data_sg;
>> +	__le64 *data;
>> +	int ret;
>> +
>> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
>> +	if (!data)
>> +		return;
>> +
>> +	sg_init_one(&result_sg, data, sizeof(*data));
>> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
>> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
>> +	cmd.result_sg = &result_sg;
>> +
>> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>> +	if (ret)
>> +		goto end;
>> +
>> +	sg_init_one(&data_sg, data, sizeof(*data));
>> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
>> +	cmd.data_sg = &data_sg;
>> +	cmd.result_sg = NULL;
>> +
>> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
>> +	if (ret)
>> +		goto end;
>> +
>> +	vp_dev->admin_vq.supported_cmds = le64_to_cpu(*data);
>> +end:
>> +	kfree(data);
>> +}
>> +
>>   static void vp_modern_avq_activate(struct virtio_device *vdev)
>>   {
>>   	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>> @@ -67,6 +106,7 @@ static void vp_modern_avq_activate(struct virtio_device *vdev)
>>   	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
>>   		return;
>>   
>> +	virtio_pci_admin_init_cmd_list(vdev);
>>   	init_completion(&admin_vq->flush_done);
>>   	refcount_set(&admin_vq->refcount, 1);
>>   	vp_modern_avq_set_abort(admin_vq, false);
>> @@ -562,6 +602,35 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
>>   	return true;
>>   }
>>   
>> +static int __virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
>> +				    struct scatterlist **sgs,
>> +				    unsigned int out_num,
>> +				    unsigned int in_num,
>> +				    void *data,
>> +				    gfp_t gfp)
>> +{
>> +	struct virtqueue *vq;
>> +	int ret, len;
>> +
>> +	vq = admin_vq->info.vq;
>> +
>> +	ret = virtqueue_add_sgs(vq, sgs, out_num, in_num, data, gfp);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (unlikely(!virtqueue_kick(vq)))
>> +		return -EIO;
>> +
>> +	while (!virtqueue_get_buf(vq, &len) &&
>> +	       !virtqueue_is_broken(vq))
>> +		cpu_relax();
>> +
>> +	if (virtqueue_is_broken(vq))
>> +		return -EIO;
>> +
>> +	return 0;
>> +}
>> +
>
> This is tolerable I guess but it might pin the CPU for a long time.
> The difficulty is handling suprize removal well which we currently
> don't do with interrupts. I would say it's ok as is but add
> a TODO comments along the lines of /* TODO: use interrupts once these virtqueue_is_broken */

I assume that you asked for adding the below comment before the while loop:
/* TODO use interrupts to reduce cpu cycles in the future */

Right ?

Yishai

>
>>   static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
>>   				    struct scatterlist **sgs,
>>   				    unsigned int out_num,
>> @@ -653,7 +722,13 @@ static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
>>   		in_num++;
>>   	}
>>   
>> -	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
>> +	if (cmd->opcode == VIRTIO_ADMIN_CMD_LIST_QUERY ||
>> +	    cmd->opcode == VIRTIO_ADMIN_CMD_LIST_USE)
>> +		ret = __virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
>> +				       out_num, in_num,
>> +				       sgs, GFP_KERNEL);
>> +	else
>> +		ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
>>   				       out_num, in_num,
>>   				       sgs, GFP_KERNEL);
>>   	if (ret) {
>> -- 
>> 2.27.0



