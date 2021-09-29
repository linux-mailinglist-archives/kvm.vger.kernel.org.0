Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243C541C7E0
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 17:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345042AbhI2PJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 11:09:59 -0400
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:46048
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345036AbhI2PJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 11:09:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dmx3vugXVeEVuukdvqNUnNaz9ibxtX7ZH3NSkemzts8UQ8JtvYHtdeXBnr2kYlDhmwKon8P5EzomJt/hfagRel4rZz0v4oXIibyLKpZiZp6KaTD2orstrjuZvsv2d3V0/CSwMruIaA43CUxO+Ya7tI7VSmMBcltyKg+oaF6oH6/A0AEsYuMoeB/s9dLwkCVqZDFHz4SUoqxGWnpZfREkeq1Sm5DXE+P3VZFC7HSWHG/UTS7ioF8x8SBYxvlGZQTXptgPa+OfDelRGJJhnbA0nw0EWISoH7efn4WwHTz4ZdLEOcgaJLbsNjYxfVFIJME3RRWkNg3+kvkaVRjIVFR7fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VwkjbWzQFJCA93W0V4TazP2g8h5qtXlJf9q55XsC2OM=;
 b=aVZ47nQlQxJQ4oMPC7qacRQQsw7TUilRjiiIF7vkSvPBTfRttZj4z7kdwXKjkQ9f9wbEzgDL3xW8EnAAHdSYNqVGvp7LKUwsKK3ArggIYYnCHd7NOXylNf+HSoMDC/IGABpVueA034HgSnla3zx5HOylgiABfi9tLa+k0lRIwJ1+ItjGAZnPjaTymRxXJfzXnoSArQq2WkvqJzJc/DpLZ4Vcxao4joZqAmPTWK0Tj5Rj3ZDRK6ikfQsWmIBVLzULiJ3E5oyaw0wybkIBClxA0mAIHCU9CWlBxXqOaqZ6o+EpT76auVD7JHRJy7aB72kuCUoIYR9M0EaH4foYkNecNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwkjbWzQFJCA93W0V4TazP2g8h5qtXlJf9q55XsC2OM=;
 b=l2QfCugG0LqP8Ff2RsdMNhTDwLfOZ+eiQrceSJnn1sJWM7ej6/j0RyTFJRSZbP3YxeEgMyzQyG9apXIc9Iu89NL2VyFrTAs/pHhZO+k/LmmLYbq+v8TK363k1K2UurUT+meiiPxGYGcvVES5Pr7DLut2c/fDkT+/UOPed5T+ZsZ7/Jx5lYGEPldNJhbaelSYznlr72hEGZTXOaKuLNW2svY5hL7k9sLvnYguDsDqjBjFo5025uyPuJhXMFZbYbOn7t/k6ZKwgsj0OIyfmCVCEHAOcyBczmYfgc56C1DD4QTxExtAsIV+vKGWKdFFP5uF78xBVuue8as3J7ew0LTJXw==
Received: from MW4P223CA0018.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::23)
 by BN8PR12MB3523.namprd12.prod.outlook.com (2603:10b6:408:69::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 15:08:08 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::d9) by MW4P223CA0018.outlook.office365.com
 (2603:10b6:303:80::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend
 Transport; Wed, 29 Sep 2021 15:08:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 15:08:07 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 08:08:06 -0700
Received: from [172.27.14.186] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 15:08:01 +0000
Subject: Re: [PATCH 2/2] virtio-blk: set NUMA affinity for a tagset
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <oren@nvidia.com>, <nitzanc@nvidia.com>,
        <israelr@nvidia.com>, <hch@infradead.org>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
 <20210926145518.64164-2-mgurtovoy@nvidia.com>
 <YVF8RBZSaJs9BScd@stefanha-x1.localdomain>
 <21295187-41c4-5fb6-21c3-28004eb7c5d8@nvidia.com>
 <YVK6hdcrXwQHrXQ9@stefanha-x1.localdomain>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <f15e1115-25c1-5b9a-223c-db122251d4c1@nvidia.com>
Date:   Wed, 29 Sep 2021 18:07:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVK6hdcrXwQHrXQ9@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40f28239-345a-4083-2b45-08d9835af1cc
X-MS-TrafficTypeDiagnostic: BN8PR12MB3523:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3523D73F5F7E961411A577EEDEA99@BN8PR12MB3523.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUiCuYTzwuO/wG6BH7eJ1aWClWhHEQjfeG/0pHqvC2qZvZvdVVoV/9TypNmPm9016lyWylZmRPZNTzUnPWZ2D2HXxm/XE5SGujHE789q2LUf8LG4JVpQIB3IenFw5vndyIZBoicQgRukPUK2OyECkerjtpBM2g7aF2ceQVr6NlGvI6Gywc3JfSExYJPD53ap+eK7//fyqCDTK5OkHYZxnKdlM2b6Z8+XM5RUdfGO25lMPbzTLfsEsoXW+mWvHvAWMUvUyXSb0k5r9crQu4nFrqXR4K48/+qc6siInATj8d3Sd3nSFt91mj96KSvGZ9dLCaZNpCoeDZ/XYapXd2tzNx/dNPce1Aa9ohzE4LjZfhFTf2djY8aPaqR7dxaa1lE8SkO1Mv4f0ybpXJjIc6o5IvM+GvLFbNSRCkw9x+pAg6OqjbR9P50hrcU2VKgs2CZWhBn/AnK7aR4tDbdr3Fqdm3BfIK3GfW+hVNZlq12SfOGxIxEagOKuH2+s9Vb/UgzSCuzsnno9MoWSrXv/ioteCLYmE36IA0fBOTmemf20rW3j6q225q/KkeyrxgyExdxSt12grU7KRMcZr33U3PdE8Mfg0Pg/75Wwt5xP9XHCGae0/DF8ZYreIc9hPh7Gn4LNBbmLUfj1Iw3XUxr25VFIf73oKpQ6TLLNqayf6omnFNqr+G0N813j+huMwJfhm0Q/prS4OdObg+uJJd5XugE8Ig7U+e+jD6tDU4Ojnn14NO6mVhNWSMXmdbfSaJ8IkAM1Xr0pO1Ahd2VERMOwqQRtd/OXDKsIuEmETjf235kDeKYGYEZWhZJEZNnSOI8PF9ko
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(426003)(2616005)(336012)(6666004)(2906002)(8676002)(5660300002)(54906003)(83380400001)(47076005)(356005)(6916009)(36756003)(316002)(16576012)(4326008)(86362001)(186003)(16526019)(26005)(7636003)(36860700001)(82310400003)(31696002)(70586007)(70206006)(966005)(53546011)(8936002)(508600001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 15:08:07.5537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40f28239-345a-4083-2b45-08d9835af1cc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3523
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/28/2021 9:47 AM, Stefan Hajnoczi wrote:
> On Mon, Sep 27, 2021 at 08:39:30PM +0300, Max Gurtovoy wrote:
>> On 9/27/2021 11:09 AM, Stefan Hajnoczi wrote:
>>> On Sun, Sep 26, 2021 at 05:55:18PM +0300, Max Gurtovoy wrote:
>>>> To optimize performance, set the affinity of the block device tagset
>>>> according to the virtio device affinity.
>>>>
>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>> ---
>>>>    drivers/block/virtio_blk.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>> index 9b3bd083b411..1c68c3e0ebf9 100644
>>>> --- a/drivers/block/virtio_blk.c
>>>> +++ b/drivers/block/virtio_blk.c
>>>> @@ -774,7 +774,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>>>>    	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
>>>>    	vblk->tag_set.ops = &virtio_mq_ops;
>>>>    	vblk->tag_set.queue_depth = queue_depth;
>>>> -	vblk->tag_set.numa_node = NUMA_NO_NODE;
>>>> +	vblk->tag_set.numa_node = virtio_dev_to_node(vdev);
>>>>    	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>>>>    	vblk->tag_set.cmd_size =
>>>>    		sizeof(struct virtblk_req) +
>>> I implemented NUMA affinity in the past and could not demonstrate a
>>> performance improvement:
>>> https://lists.linuxfoundation.org/pipermail/virtualization/2020-June/048248.html
>>>
>>> The pathological case is when a guest with vNUMA has the virtio-blk-pci
>>> device on the "wrong" host NUMA node. Then memory accesses should cross
>>> NUMA nodes. Still, it didn't seem to matter.
>> I think the reason you didn't see any improvement is since you didn't use
>> the right device for the node query. See my patch 1/2.
> That doesn't seem to be the case. Please see
> drivers/base/core.c:device_add():
>
>    /* use parent numa_node */
>    if (parent && (dev_to_node(dev) == NUMA_NO_NODE))
>            set_dev_node(dev, dev_to_node(parent));
>
> IMO it's cleaner to use dev_to_node(&vdev->dev) than to directly access
> the parent.
>
> Have I missed something?

but dev_to_node(dev) is 0 IMO.

who set it to NUMA_NO_NODE ?

>
>> I can try integrating these patches in my series and fix it.
>>
>> BTW, we might not see a big improvement because of other bottlenecks but
>> this is known perf optimization we use often in block storage drivers.
> Let's see benchmark results. Otherwise this is just dead code that adds
> complexity.
>
> Stefan
