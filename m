Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5676943874D
	for <lists+kvm@lfdr.de>; Sun, 24 Oct 2021 10:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhJXIO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Oct 2021 04:14:56 -0400
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:39609
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229527AbhJXIOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Oct 2021 04:14:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8DDuIK1MraAse835ItGqr50FRrBkwYt9qs4kCE9dUhhVIgZvZABaRVJS9eXcD0Yo2h2XMeHqFs8apLUNNndB81f8I3BWfS0Wk3dEC5eJUvG4iukuDOa9sI1Hj+hEfaA/oEJo4cleG59NWCGPsEuauoCQ3uZGZQCpJvKaw/jxmBgOyEMQNt6UxerXHLVxsjFVWF/fdC+37e9/N4ZJD38N4iLC3mG+ANFIEjnsHUbXGjZfQN1cDCPZ05x59qevHXUh9uAKwZaQtxcWYSQDW6RtFY9IaDXT+p+i7easSPHzTM7uWaX/5I7pcs53EqaaURwNAO5MFOOe2ueMYDow2+8AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uqt4nRThpsSXcj1pMLd3LXMv6JlccUAW8kEKf0FydYA=;
 b=d6bGImUZu5eg+WMl37Ect78mldK2zfauOSv+RJnHLniQ9YaaX7P50Fz4vNX+NmJr8gvR1K93wUiLCvGjOmkUo+VuyO1deSolQQUhr1QobuGmxqnJHXn8fp+QqMVTzQGAktdMatbqktABPk7bwZlN+9cqGtULej8Nx417OfKDR4WMuKXamRavCLvBP3P9Gh3Z0rUTWaUl3FYHiTvM02y29x4+pSmigtfV2tFUHKoRVRGwPxFg+1dqLlS69WPuh9XKxIAPUOQEdtxXaq+QacTc7FkLOAXoTYi77zkYWulyl6q/TNnGxHXMnF4InKQr3wW8/TuGfn1DEbg2g7sn6PGYSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqt4nRThpsSXcj1pMLd3LXMv6JlccUAW8kEKf0FydYA=;
 b=RlXwebrwMzlrTr7m0dnemPGOeV/4zT+3j/hRTRBLiFsNwRL4gWAzBWgjIrMvleHtKub55dzXO/9B4AI1ogHIPWkToRCSJERldfcn9Sgbua0xKL14Xf4uc2DrO1zw0QKGVj1J8pYp2XvpaOKQCaVeZz9ljp0yEWIrcbKhstH8vzAl91KcEeXxirMGeURVrTe2tdWOUeTQKbMhBQku/yFSyCWu99RASr5qz6NE04JU9CjgPgej/mURk4H/zaQ4RAaBxYl8M2KNBVEes2ZDwsaKVT90XJ7anIuM4RHqFs7gu7ZbMpMjRU59zD1NMjNQtb4zLQUvhvSrwoApoNv4iuAIyQ==
Received: from BN6PR13CA0015.namprd13.prod.outlook.com (2603:10b6:404:10a::25)
 by DM6PR12MB4434.namprd12.prod.outlook.com (2603:10b6:5:2ad::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Sun, 24 Oct
 2021 08:12:34 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::b3) by BN6PR13CA0015.outlook.office365.com
 (2603:10b6:404:10a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend
 Transport; Sun, 24 Oct 2021 08:12:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:12:33 +0000
Received: from [172.27.13.118] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 08:12:29 +0000
Message-ID: <93c7838d-d942-010e-e1b2-bc052365f5b1@nvidia.com>
Date:   Sun, 24 Oct 2021 11:12:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Content-Language: en-US
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <hch@infradead.org>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>, <israelr@nvidia.com>,
        <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <20211022052950-mutt-send-email-mst@kernel.org>
 <19cbe00a-409c-fd4b-4466-6b9fe650229f@nvidia.com>
In-Reply-To: <19cbe00a-409c-fd4b-4466-6b9fe650229f@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebba4ada-4f5a-4364-c76f-08d996c60857
X-MS-TrafficTypeDiagnostic: DM6PR12MB4434:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4434D441FFEA329E4E9F153CDE829@DM6PR12MB4434.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oqVtpWA37mI1eT6YhnH1BDS8fl3qG/tSAE21uzCEnK5kt2trm+cvDVj8jxsuCkO1q5oplzh1fC5dmdH2c61Zf5FkBL2tha7iOo9OpI5+AWFDGmpapjpAuePV+pNtVCYxV4W/mOYFk/h/Pe6KHGw1jUth9LG+BWzmraBqN/m8It3MaCChvrbcej98un9H08M3gZIPsRm4ylJSBG0H73en4uHSmS1iDSwbOILmECTrBNxtBBn9OFte3BDrMJGFhByk809SoaV2JI4uiuH5vhxX7Oxqf6ctmpfo8iQ8xKTXVjQkTBayt0ZarQb8LFogwXAiz8bKL9/ZqPXyd7RNf+tu3oxtd5ba+4EdO/TZSCUTET7cuLQFBrNb4qJ9Lioz4yuiR4cjz8X8zwxPb7vCP3t+fxTDjrkABlIdT4oj2tMU0hocDOkW8cHfOV4fnCjq5B160emDRE9vvdXd+CTPKlwga0QqrlMMN0MC+Ng5b5xLz1QhK8hXobUsOw5sjHm86oiPG4MF0+3aVTPMwkZ2a8VGYraV8W/AE7v8HFAI+KkXaySkZ9pY8VON4/OK32ay9YEZI5H4/d8nZJe/+KZ3aIlkKtnog6MyvJAHsgaIBKOlv+p9uR9JtSYi1FhM4GlHAvnxZtXZcmvGGdlruIdMvgvmi+3lz/GhJZ+UM33xLs+TRa+gjz1S0uv9RyfyUHVD3e318nQRNZyhHM4bBowMw/drHKmnss4erOvvoQm3kFBLua4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(508600001)(82310400003)(6916009)(26005)(47076005)(16576012)(356005)(31686004)(186003)(7636003)(36756003)(31696002)(83380400001)(86362001)(8936002)(426003)(5660300002)(54906003)(8676002)(6666004)(70206006)(53546011)(2906002)(16526019)(336012)(316002)(70586007)(2616005)(36860700001)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:12:33.4658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebba4ada-4f5a-4364-c76f-08d996c60857
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4434
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/24/2021 10:19 AM, Max Gurtovoy wrote:
>
> On 10/22/2021 12:30 PM, Michael S. Tsirkin wrote:
>> On Thu, Sep 02, 2021 at 11:46:22PM +0300, Max Gurtovoy wrote:
>>> Sometimes a user would like to control the amount of request queues to
>>> be created for a block device. For example, for limiting the memory
>>> footprint of virtio-blk devices.
>>>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>> ---
>>>
>>> changes from v2:
>>>   - renamed num_io_queues to num_request_queues (from Stefan)
>>>   - added Reviewed-by signatures (from Stefan and Christoph)
>>>
>>> changes from v1:
>>>   - use param_set_uint_minmax (from Christoph)
>>>   - added "Should > 0" to module description
>>>
>>> Note: This commit apply on top of Jens's branch for-5.15/drivers
>>>
>>> ---
>>>   drivers/block/virtio_blk.c | 21 ++++++++++++++++++++-
>>>   1 file changed, 20 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>> index 4b49df2dfd23..aaa2833a4734 100644
>>> --- a/drivers/block/virtio_blk.c
>>> +++ b/drivers/block/virtio_blk.c
>>> @@ -24,6 +24,23 @@
>>>   /* The maximum number of sg elements that fit into a virtqueue */
>>>   #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>>   +static int virtblk_queue_count_set(const char *val,
>>> +        const struct kernel_param *kp)
>>> +{
>>> +    return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
>>> +}
>>> +

BTW, I've noticed in your new message you allow setting 0 so you might 
want to change the code to

param_set_uint_minmax(val, kp, 0, nr_cpu_ids);

to a case a user will load the module with num_request_queues=0.

>>> +static const struct kernel_param_ops queue_count_ops = {
>>> +    .set = virtblk_queue_count_set,
>>> +    .get = param_get_uint,
>>> +};
>>> +
>>> +static unsigned int num_request_queues;
>>> +module_param_cb(num_request_queues, &queue_count_ops, 
>>> &num_request_queues,
>>> +        0644);
>>> +MODULE_PARM_DESC(num_request_queues,
>>> +         "Number of request queues to use for blk device. Should > 
>>> 0");
>>> +
>>>   static int major;
>>>   static DEFINE_IDA(vd_index_ida);
>> I wasn't happy with the message here so I tweaked it.
>>
>> Please look at it in linux-next and confirm. Thanks!
>
> Looks good.
>
>
>>
>>
>>> @@ -501,7 +518,9 @@ static int init_vq(struct virtio_blk *vblk)
>>>       if (err)
>>>           num_vqs = 1;
>>>   -    num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>>> +    num_vqs = min_t(unsigned int,
>>> +            min_not_zero(num_request_queues, nr_cpu_ids),
>>> +            num_vqs);
>>>         vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs), 
>>> GFP_KERNEL);
>>>       if (!vblk->vqs)
>>> -- 
>>> 2.18.1
