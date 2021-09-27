Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E421419C8E
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 19:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbhI0RaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 13:30:04 -0400
Received: from mail-dm3nam07on2075.outbound.protection.outlook.com ([40.107.95.75]:49409
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237795AbhI0R1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 13:27:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2aXOLLNAcU3KjYMs8c9AIP+KNXvUlbeYcN20/8wMB48ypJE7srW70Vde6Q+ZpxLxMAVCJfvr6aIiItFjun5woB+M+GtCaZMYmxUsIy3Fg+Ze2NVFBcnY/iHEgus64jQSup4mXg/c36bSIeMopv1ppwi3DGE4fNuiRAY5C0WqduaFLvtlsdi69lggp3l+oTBxwZCISlsWl4b/xYx/Burxnqm09ausGB+cDU9uZqAHtMy/o46LHVMBOiAwfoZl1osbm4uKqJnhdmomowKnDgX2ZogKAxIhEp/uxKOyKDZ8n3NsJzHB4V+WdaKqdNsi9RHuxG1Dn+wM/WFtnLoGsXQUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=E7CExuPcP6rxaeV2PFaCrKV32ZwGeNYCugkTCaN4qAI=;
 b=f3Bb9wPgzO0E7rPtHGpR9yldvjm6ilzs8jlcpWFgshPQqpaDdlQUcWXMvjsUKo7y0MLrtyfyAFYRbNy2EosfqQcZYePOYfW1dv4751jxh2/NgaRlFqZZ8J2zzH1ge7UrBFxWvBe2RWxFDXeCScLGPjk2qSlbXmUNfzzF/oqEaiVUM6XeOQ31w6bzRtxiWMOTgizQKfl2eCuN33U3XuTP7eh/3T71/QEFIhNWjzCTJcs0i29x/OEZ4u4GXaw2k5SnNt0lGgoBbXPx6hA8qqQoERj579cyHBUYPoHEhsYfQih9qwJwNip5mQSOXRb0ir/utBE4QDbvvYc9FISDd5cWFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7CExuPcP6rxaeV2PFaCrKV32ZwGeNYCugkTCaN4qAI=;
 b=XqQpjh6dzfZpWUmqvJv9oBPzNKhFEXyL0Be4Hc8WGWPX5Gs1lbj32VFieNhbF5hznn+OEivUsoQw5sFA4ve96w35+LPUnj4qwMbBnpMb66IpvtO/b4IAe9WWED6/PTMedGIAPBlrYdslzjJm4Y5+Rzis8gPqqIEJSovYDLOcWB/KvnQALygONnk6gyk3n1oNa61G3EnCVrr+thAUwbQdYLpSkQ9jW26ymWyJZFPSrFfl5dgq/+TIs8G6U/PQFZRRis/zPW5inQuydHhNP81rq7XGvDf0mDJ86RohmO4s3CkyGr1bKrojBK3VDO6Ro6sbOQAnF1Yt4EUmjyBxQZMHoA==
Received: from DM3PR12CA0062.namprd12.prod.outlook.com (2603:10b6:0:56::30) by
 BN9PR12MB5147.namprd12.prod.outlook.com (2603:10b6:408:118::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 17:25:16 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:56:cafe::de) by DM3PR12CA0062.outlook.office365.com
 (2603:10b6:0:56::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Mon, 27 Sep 2021 17:25:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 17:25:16 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep
 2021 17:25:15 +0000
Received: from [172.27.0.62] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep
 2021 17:25:12 +0000
Subject: Re: [PATCH 2/2] virtio-blk: set NUMA affinity for a tagset
To:     Leon Romanovsky <leon@kernel.org>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>, <oren@nvidia.com>,
        <nitzanc@nvidia.com>, <israelr@nvidia.com>, <hch@infradead.org>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
 <20210926145518.64164-2-mgurtovoy@nvidia.com> <YVGsMsIjD2+aS3eC@unreal>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <0c155679-e1db-3d1e-2b4e-a0f12ce5950c@nvidia.com>
Date:   Mon, 27 Sep 2021 20:25:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVGsMsIjD2+aS3eC@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e10660b-4f83-4d59-c8ec-08d981dbc5a5
X-MS-TrafficTypeDiagnostic: BN9PR12MB5147:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5147BB86AE38DB73F98492D3DEA79@BN9PR12MB5147.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vhap4u6sq5IUNFKiX2tK7tHi1XPDCgdOkZLNWiw4hvJHUEO4GveyN3q8CMYCyJudFopP6mu3J+z2/WvKcEDwjVuo0/+GxHsxvalyDUjqh4+L5vqvrSbrWrbvEijj+delsTaxm1unmsxx9LjyYFzbRlR0Oc/RzKGByAV9BelqeAxXc2BdQSHGQIGdmGj8RjmNxvRtXVp0hfOkoHKlznI232XXJJJ6eglatzHHFvQ2e9cotda7y6ejsSQd+Hjl77lSTQw4JTqPGOqSuTGeOt+SiYHDYRcCWGwgffBLOx48UAVHcnQO/GpJZrbnX9p/KIdfH3FQwsvFf27V4tfR/QC8IKaVdnOBeHuqHMF8wLRY1kigr4bSO/yQJC9WEjOpnLsDupR/ikwBMNccfzA0w2RcQhfhJ1SsgpGX/GexgqIhNKJD0Wc1aUqjwugZW3pvbwxDV2d9pVqjuCjYWHqtSKpSKQ2242R2QD/7sx2xfMwq66DYnwDpz069gPLY2SJYqQTUKTLnJhh/l09CUkkttgbD6KM9g0pam2chXepSUg12DTpMXP7yJQLOha0XeQPZ6Hql5MVqux1lFvBnJCyL600wmrufchld28DSNprXmFQj0lmBC9HnVJx7axy0r0yHylY3LofFgt9sCsE6sodXKDWVQx8cOs6APFJGDmX5CzVIrPmQY6w3aIz7FtRXR6EXj42TEs4XH5yEmfxC+k/015d2/3NtaQOfXHVq3gcGz9dl8iM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2616005)(16526019)(83380400001)(8676002)(5660300002)(36756003)(47076005)(70586007)(70206006)(6916009)(356005)(8936002)(426003)(36906005)(54906003)(26005)(31696002)(4326008)(16576012)(186003)(6666004)(336012)(316002)(7636003)(508600001)(36860700001)(2906002)(53546011)(86362001)(82310400003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 17:25:16.2363
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e10660b-4f83-4d59-c8ec-08d981dbc5a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5147
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/27/2021 2:34 PM, Leon Romanovsky wrote:
> On Sun, Sep 26, 2021 at 05:55:18PM +0300, Max Gurtovoy wrote:
>> To optimize performance, set the affinity of the block device tagset
>> according to the virtio device affinity.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>   drivers/block/virtio_blk.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index 9b3bd083b411..1c68c3e0ebf9 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -774,7 +774,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>>   	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
>>   	vblk->tag_set.ops = &virtio_mq_ops;
>>   	vblk->tag_set.queue_depth = queue_depth;
>> -	vblk->tag_set.numa_node = NUMA_NO_NODE;
>> +	vblk->tag_set.numa_node = virtio_dev_to_node(vdev);
> I afraid that by doing it, you will increase chances to see OOM, because
> in NUMA_NO_NODE, MM will try allocate memory in whole system, while in
> the latter mode only on specific NUMA which can be depleted.

This is a common methodology we use in the block layer and in NVMe 
subsystem and we don't afraid of the OOM issue you raised.

This is not new and I guess that the kernel MM will (or should) be 
handling the fallback you raised.

Anyway, if we're doing this in NVMe I don't see a reason to afraid doing 
it in virtio-blk.

Also, I've send a patch that decrease the size of the memory consumption 
for virtio-blk few weeks ago so I guess we'll be just fine.

>
> Thanks
>
>>   	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>>   	vblk->tag_set.cmd_size =
>>   		sizeof(struct virtblk_req) +
>> -- 
>> 2.18.1
>>
