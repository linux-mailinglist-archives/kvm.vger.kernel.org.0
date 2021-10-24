Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC8D438864
	for <lists+kvm@lfdr.de>; Sun, 24 Oct 2021 12:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhJXLAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Oct 2021 07:00:01 -0400
Received: from mail-dm6nam12on2084.outbound.protection.outlook.com ([40.107.243.84]:21569
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229867AbhJXLAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Oct 2021 07:00:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dB5QFWn/vWpS8HCPbws3OQI+Ux4pRWSB8Zz2Aluuym6Ye3h2a1aMmmxwWeQkcO027N6ZYiPVLIGCNQIfMMf6+UayUqd4O9CwHOSSGdrgTDWRKzBbzIFKjCXlj5v7YN82/zHuG/plO1cvMPcyGSbwu6zH2024Hvigq79Ktbp7PVwREYvXI53iiwEsUJWmFYyVnF+55CnzeyxWKE9za9C+ADK90rnTBJQcp3Bl4Elg/aUh8mwe2XIIlE3cFNa4xm3a6uvSA/4dHXObv8Sf113wLqoh3KGZrD537dg+W0JrYWu/uOEBQztac4pmk99KSr+bQJ11gXJB06qjsAsRRa3Zkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptBo9DErJgLUbokd6N+n3HmtcQEU0Wn1TKj+dn8dNGM=;
 b=LGG9TYx3rvE53JAAj0YjDWH1BWiBcwEXjmqrsEwtzKOHfd7sOo+rrB2k9g9Kxkg8Z+/7EtY47Skno8eHQJh+wT7pcOCCmOtQuDAkQez1u0cbT/rXlNSXM2N8AyC7zK8VUpIvWTvUJaJQi61dSmKGvIb59UWBlukBQfjZTKpgMw3YuluB2G7S2FjQk2NaZnhzbcAGLbls3Ak5PF7N6OtC+aOKM+u3sBnOnD9b9kTrlvqrY81fxOFGFtZ8igDLqOY7h3b/Psv+shbF1QHoGS0QojyI6XOXJsmXa79b5a6XY3+RnJToUsz3r5Io4nZMFGU7KJ3INySw1URatYrUjEOWJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptBo9DErJgLUbokd6N+n3HmtcQEU0Wn1TKj+dn8dNGM=;
 b=CYlVClniBK9tMGBRT4SocapSuk4nlueDXMVPdiNNPxCpsBlRZ5ZqjQHaBNK5jBv1XoDmqilDWbX3LRAiXeYPRdNSSYdgbpB2EpRywL9OHbKAX/55JLFmE4yhOUtILmwK9v74IzN0DDaFTBRvF9/TU6wFsUhg/bVMW9BzStdlzGFaIogo1NlHoR0bno889pGd24WiXOQ0RaPzpjgFHcVq7iexNmFXhMFagn4UAi2rSXMltIQRAXel/Yd9TdL1odxXiJZ9/ILDR4YfdzJOSDWdOCHDIbAED0WPzE3UmzLkW8RCF7eWK8BOAyu2HKV1kDDCP10jAZixK5t0vh/gKFidyw==
Received: from BN0PR04CA0155.namprd04.prod.outlook.com (2603:10b6:408:eb::10)
 by DM5PR1201MB0265.namprd12.prod.outlook.com (2603:10b6:4:58::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Sun, 24 Oct
 2021 10:57:37 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::c4) by BN0PR04CA0155.outlook.office365.com
 (2603:10b6:408:eb::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20 via Frontend
 Transport; Sun, 24 Oct 2021 10:57:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 10:57:34 +0000
Received: from [172.27.13.118] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 10:57:29 +0000
Message-ID: <c428be6a-5d48-8af0-7744-c992bf2e243a@nvidia.com>
Date:   Sun, 24 Oct 2021 13:57:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <hch@infradead.org>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>, <israelr@nvidia.com>,
        <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <20211022052950-mutt-send-email-mst@kernel.org>
 <19cbe00a-409c-fd4b-4466-6b9fe650229f@nvidia.com>
 <93c7838d-d942-010e-e1b2-bc052365f5b1@nvidia.com>
 <20211024044727-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20211024044727-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 897bde66-ceab-42f7-5d15-08d996dd1608
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0265:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0265F0AC92029E9A5E75C731DE829@DM5PR1201MB0265.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ifvC1g/Jpxv7xSHkJTtmE7yzZFdj38UaccLJ1NLDh7fnoHEXZJDGjCni+C3RWb6I+eQi6gKw3i6Hog2GjfUJykYecXozrRymdHhzq8mNg+5VFjXp+eTnK8YmqWJ5f6JcaToHkdCobA/ksY2A8BEaEO86cs15+teUj6fXZzbBdgk0Fe9ewpZOaiCi03YYC5d9WUG1sJ3d3aBa1qhAo+/sjCEURQnk/kwYYV+uxK3je3JABwFdP/lB+8hXqfFPa6itsVtDHGWADC+5Wz5Wen6eOIzaCrwjTb3a4LOir/gU9uLQFsN348nHv7aJDQSWuGWibyYI79JG0FMkV2/wSRB/MC/Lojd2wjnJVDD0uxYQb34ko0j+hOl4r3VSyaXnsSDRRdeQR8v7ZzZ3r58+lFp4Vc6gjE1QKJV7KGSPEKssCeREaulk/ls5HOEE6/yCpPc9EKYxnyT983iS0m7GmvKHNtuP38tf4Rwfw7rl44Lmem0ZODBgaEpMRVOEV+sFLi7uVT/C1zepDNuo9JcbhHQxpbczhyZacRfDzVYXTGDBKsj8L+BIXr0BOjj0uQ5d9g5k41amWZ0YpBI+CrpvkPHVX81Vo1bmvvQwfRbOrvLXfMxNc8STgrZuHFVqjVFGlfpHPyqdaOI7n08ATnr5pEd9hmM4+hleBaeCHoaNlgB5qOqhLhkC883uv2ExP8CKNZNf2GNxvo0iroDOA8Xo8VuPD0roI5kqVZXECVVHXRWiO40=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(6916009)(70206006)(83380400001)(47076005)(2906002)(31686004)(6666004)(316002)(70586007)(7636003)(356005)(508600001)(36756003)(16576012)(186003)(36860700001)(8676002)(86362001)(8936002)(26005)(336012)(2616005)(53546011)(5660300002)(16526019)(82310400003)(426003)(31696002)(4326008)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 10:57:34.9362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 897bde66-ceab-42f7-5d15-08d996dd1608
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0265
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/24/2021 11:48 AM, Michael S. Tsirkin wrote:
> On Sun, Oct 24, 2021 at 11:12:26AM +0300, Max Gurtovoy wrote:
>> On 10/24/2021 10:19 AM, Max Gurtovoy wrote:
>>> On 10/22/2021 12:30 PM, Michael S. Tsirkin wrote:
>>>> On Thu, Sep 02, 2021 at 11:46:22PM +0300, Max Gurtovoy wrote:
>>>>> Sometimes a user would like to control the amount of request queues to
>>>>> be created for a block device. For example, for limiting the memory
>>>>> footprint of virtio-blk devices.
>>>>>
>>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>> ---
>>>>>
>>>>> changes from v2:
>>>>>    - renamed num_io_queues to num_request_queues (from Stefan)
>>>>>    - added Reviewed-by signatures (from Stefan and Christoph)
>>>>>
>>>>> changes from v1:
>>>>>    - use param_set_uint_minmax (from Christoph)
>>>>>    - added "Should > 0" to module description
>>>>>
>>>>> Note: This commit apply on top of Jens's branch for-5.15/drivers
>>>>>
>>>>> ---
>>>>>    drivers/block/virtio_blk.c | 21 ++++++++++++++++++++-
>>>>>    1 file changed, 20 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>>> index 4b49df2dfd23..aaa2833a4734 100644
>>>>> --- a/drivers/block/virtio_blk.c
>>>>> +++ b/drivers/block/virtio_blk.c
>>>>> @@ -24,6 +24,23 @@
>>>>>    /* The maximum number of sg elements that fit into a virtqueue */
>>>>>    #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>>>>    +static int virtblk_queue_count_set(const char *val,
>>>>> +        const struct kernel_param *kp)
>>>>> +{
>>>>> +    return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
>>>>> +}
>>>>> +
>> BTW, I've noticed in your new message you allow setting 0 so you might want
>> to change the code to
>>
>> param_set_uint_minmax(val, kp, 0, nr_cpu_ids);
>>
>> to a case a user will load the module with num_request_queues=0.
> Oh. So as written the default forces 1 queue?
> Send a patch please!

No. The default (if nobody touch this param) is 0 and everything works 
as today. but the user can't do "modprobe virtio_blk num_request_queues=0".

My comment was right (should be set > 0).

You changed and wrote "0 for no limit." but the user can't set to 0. So 
if you want the user to change to 0, please change the above code as I 
mentioned.


>
>>>>> +static const struct kernel_param_ops queue_count_ops = {
>>>>> +    .set = virtblk_queue_count_set,
>>>>> +    .get = param_get_uint,
>>>>> +};
>>>>> +
>>>>> +static unsigned int num_request_queues;
>>>>> +module_param_cb(num_request_queues, &queue_count_ops,
>>>>> &num_request_queues,
>>>>> +        0644);
>>>>> +MODULE_PARM_DESC(num_request_queues,
>>>>> +         "Number of request queues to use for blk device.
>>>>> Should > 0");
>>>>> +
>>>>>    static int major;
>>>>>    static DEFINE_IDA(vd_index_ida);
>>>> I wasn't happy with the message here so I tweaked it.
>>>>
>>>> Please look at it in linux-next and confirm. Thanks!
>>> Looks good.
>>>
>>>
>>>>
>>>>> @@ -501,7 +518,9 @@ static int init_vq(struct virtio_blk *vblk)
>>>>>        if (err)
>>>>>            num_vqs = 1;
>>>>>    -    num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>>>>> +    num_vqs = min_t(unsigned int,
>>>>> +            min_not_zero(num_request_queues, nr_cpu_ids),
>>>>> +            num_vqs);
>>>>>          vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs),
>>>>> GFP_KERNEL);
>>>>>        if (!vblk->vqs)
>>>>> -- 
>>>>> 2.18.1
