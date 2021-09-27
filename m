Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE84419D17
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 19:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhI0Rlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 13:41:51 -0400
Received: from mail-bn7nam10on2074.outbound.protection.outlook.com ([40.107.92.74]:6606
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237710AbhI0RlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 13:41:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKD4d1DTFbGi6bOxHUkBNPPkOqMWvvtY+7Orn+5MWxQ/1XQ3Jv6eidt4LcydRFX98aGLzZXkKs+TYHRkZexdsCPydkcAEyl6F6ns8Om1bjgAcaW1jj7rU6pCp4CG/kJOivN5gqNjE/PsDzITp14nvcH2++hq77EKkaNuyOihlqCQ2ZKP8NRj0HNC7lvw0NQqfRikCwTNXDy+PGiAPcVmOfab43zV5X7AVKAM/rNKsvD0UFxls+iGbIVsIuxkbOnz+aBKPlYKkrgRlkpS5X04489LwwzqOXsuuGHTWRw3/vlkdvYIcGeFCgDAyWdr2kK39ZRPdYWf5y7erWax5dMqUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YdtXbf58qnDgrPVCnkwjcJgBHLvdzmtk6Twqhb72qZc=;
 b=KaBaN0e9rHFxzK8rDVxl0pXpt4rGlkVFgdlAQ49/BJmtp/zd02oglrzDeanKfxufaZZhaEJTBOsnz8nzjnSKyxrPQgoYAFkjb04aNU3LxN5QF3rTx97r8thwQHVKbmWNVzMTm9uWgqoHwuHf0H8oPUiLuX6NepauJHEuxecHCOiwqpwoO1RIdrDcyzVFfVh3zsdIy9Rgm3E76chJucLp8Le5JL0F6YsDHN+2zFuIlBxjtu0Gb6/JH8wkuq/xLjaq6slbVky8hrKIwMpgeLoGhkJvGBw8mj7ZvXggy5qiOs6GtLlgACMki4Et6wa4+rCbtlOPhB/aTE4GktemQOQdFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdtXbf58qnDgrPVCnkwjcJgBHLvdzmtk6Twqhb72qZc=;
 b=lbikr1k9ojcwkm9BrF6V+TkrwuEAzA2Dm+ZADu6ZQvbxDA0GYNkOgKV3RT8si2Bpl1xksAQ6vepT77YHlO0Aj91W8mG7S3EYfvgVH3drCQKiXH0ez+syxTADVGZuKRfMKBjMYafMTNnEou2KqUWMfm8srx5/0uEfPiKE4yNAoe1yYVr1D3GXKN/9EG7qv7A4XopDCI8yBVhJIXrP8b1MgFselhwmkxTiKpcd1t/D3Dut/GXhtvk9PjMUxi20YrYAob2rVKpyNGUl7gemFW+DbBISeGtuKVY9bIOq3+98XRPUprjGJXhTIFIlCeAdmCSxEB4UEHp09v3iix7dJa+CNw==
Received: from DM6PR06CA0073.namprd06.prod.outlook.com (2603:10b6:5:336::6) by
 MWHPR12MB1549.namprd12.prod.outlook.com (2603:10b6:301:10::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.14; Mon, 27 Sep 2021 17:39:38 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::4) by DM6PR06CA0073.outlook.office365.com
 (2603:10b6:5:336::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend
 Transport; Mon, 27 Sep 2021 17:39:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 17:39:37 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep
 2021 10:39:37 -0700
Received: from [172.27.0.62] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep
 2021 17:39:33 +0000
Subject: Re: [PATCH 2/2] virtio-blk: set NUMA affinity for a tagset
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <oren@nvidia.com>, <nitzanc@nvidia.com>,
        <israelr@nvidia.com>, <hch@infradead.org>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
 <20210926145518.64164-2-mgurtovoy@nvidia.com>
 <YVF8RBZSaJs9BScd@stefanha-x1.localdomain>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <21295187-41c4-5fb6-21c3-28004eb7c5d8@nvidia.com>
Date:   Mon, 27 Sep 2021 20:39:30 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVF8RBZSaJs9BScd@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dda8de83-1633-46f6-7916-08d981ddc726
X-MS-TrafficTypeDiagnostic: MWHPR12MB1549:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1549CAA659524786085E2CB2DEA79@MWHPR12MB1549.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iwhc96DqBzBxQOcG8+gNevWLaNyDe40Betsvtky1kEgnultwzG3QmEb6oOza6iKkn/b2DNnm0NBwoYu1zSJff82Mi7cxFQSL+jIcKxWya6J5fZjA78DQThYHRDA1AaEZ33kBP5ox1I2CeR7Gk8W3kxWysbfL4i/eoFhVbcfgLmJlyRAPElbJWPiY9unCZahadRKxJIXGqHZuTQyut3y6dwYAvXMW98P2+10lYjzdSvGeYSgs/jDflpCruf5FnaSFHPUnUfwDLHgC9zn2h83emz2oX4MrKRvmCwabDBqNQPbu2vBSEcGcKjOMpBIgYfqrsWjMJM0047sH3WLLT91HlhQylHHm1Obd5YXEoObH/yLOVRK1VChxTuVBwGQvNOzTWzNQqUlqSpFadPwOrjEusTgzvDAL8dJksO3sDKD/FEkNyuxZn1a6P7Jc66XZh4e+VI8YDxTZh8TUZmk7C6TUL4W+SvH3p/L6y68H6RXNoC6hJubZakyzH6Ge7Bmw5evukDe5H7ZelJLGWkzXVi5NTfzELuvda27/1Kn+NlmF5rgnawYEWINr87EnPJ5ZJTkKHDMtG8zWNXe9OlvBAUjGKnqPyjwf82D1UhJXoSBgHAjOjDU8qdfmjurD8sc6fNIOrht5SxPUPY7KiIuK+xPi1TZrssMGzlhUb74xXF5CRDbD7LSeU9Y+h4tCaBqCY9ZcluQV1TCyTDmj2OXSRDcdrmPAStK29dtmcw8zQCHkvv6kBrzA4vV9fpV/XfvJCeIa5YMz9+xjiTTwC9iG3zZmkhmBhKshbo4hQSkQOCVkjebsqrF99K4aQBEEJnzCp4zR
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(16526019)(186003)(70206006)(8936002)(83380400001)(2616005)(6916009)(26005)(47076005)(336012)(86362001)(2906002)(508600001)(426003)(8676002)(82310400003)(31686004)(36756003)(7636003)(53546011)(316002)(356005)(966005)(16576012)(70586007)(5660300002)(31696002)(36860700001)(54906003)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 17:39:37.7489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dda8de83-1633-46f6-7916-08d981ddc726
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1549
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/27/2021 11:09 AM, Stefan Hajnoczi wrote:
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
>>   	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>>   	vblk->tag_set.cmd_size =
>>   		sizeof(struct virtblk_req) +
> I implemented NUMA affinity in the past and could not demonstrate a
> performance improvement:
> https://lists.linuxfoundation.org/pipermail/virtualization/2020-June/048248.html
>
> The pathological case is when a guest with vNUMA has the virtio-blk-pci
> device on the "wrong" host NUMA node. Then memory accesses should cross
> NUMA nodes. Still, it didn't seem to matter.

I think the reason you didn't see any improvement is since you didn't 
use the right device for the node query. See my patch 1/2.

I can try integrating these patches in my series and fix it.

BTW, we might not see a big improvement because of other bottlenecks but 
this is known perf optimization we use often in block storage drivers.


>
> Please share your benchmark results. If you haven't collected data yet
> you could even combine our patches to see if it helps. Thanks!
>
> Stefan
