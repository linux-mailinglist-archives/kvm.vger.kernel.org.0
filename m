Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFBC438988
	for <lists+kvm@lfdr.de>; Sun, 24 Oct 2021 16:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhJXOdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Oct 2021 10:33:39 -0400
Received: from mail-dm6nam11on2055.outbound.protection.outlook.com ([40.107.223.55]:25921
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230358AbhJXOdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Oct 2021 10:33:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKypTiZ6KXdtXL1yOijaXuhrgkscCrzNdQ/rGCv9IEUoRcpPtWPsLYFnf8zguVkiWKplGhTMPu3VuqjSM2fhIcXc9PoPjx/coN3LLbSNEPUctGOxxX1lVXnOWgFtvCm/D9QbZBIlCQjjS/fsFGDkbeJaEd+XiR+9ojQ379iXXUqQQp6vwUB9ChTTiBh+GvVM995/2DlHwN93bPhZfZilT+zj8CyrMDhfcL8At89hpGk3rdu/Ypmm7rBMBWHDRGIenixG8OF/MCVhiox9LGzqAuxgSSCZj/Fpo35UFFg5/8iimP+tTPr7mQYND6F/hyPEVMVLGSzzaA6qIj8cKcsEMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1HrohWAionriYoqexcIsDS3hd4UcwYYUS/cKybvPrQ0=;
 b=McyUUakh80WfBzfo2bh1y5VN7z+3euXXJeXJZFUBRMsvLHM3vdE2ByB31IKZDpTklyRN+RO5vY6cj2+kbmzxg7y0Cg0zRdMrzsIWq/HK5eqIYPEcpUt7FGt5L3jT+BRotnUr+na/O3hwUZrrc2u7qRhc1y0mCyHyCCcp2fp2+GmxpieiyokMLrDwVBDBFy/gADd67DNbkLBKXDkH2VczWQUB7o90CVhQC8syDk9ee36D3wTK1az4drm9dEc2emp2xWoCNXNxchcZ7YbfTpaPWnnqxeAlgv+YTVjTXv3PNZase2yMqorSJhcd30zVSjK7a/9kXbOFi/pkgSVBimMaVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1HrohWAionriYoqexcIsDS3hd4UcwYYUS/cKybvPrQ0=;
 b=gWu2It2x+L8GmJWooQnIlDopxUqWptyoAL6v6R0wRgFvBvTf513YW7Sw+G6zI+F9LHUF48cluKYay4RFhmdmB0hqoQJV0+/jXNtH9lR+06/F8A3PlLghrCHZv7JshOvzd55mQZzpQo0H7JkwBfa4oc++/NkXMXMI6EHu3Px9JYbK0wHCML299iLZWVJeHXIy0L8FmRB0qIYvQKMmdjlyWqjujspST7g7oMPDqX6XmWocBMmdBWYhXuGcFq2NmJtWHk6vleRZkhC3Uixg/N/k5b14aYCaxIh4B7Kb85rmG+vU1UhI+1PMOvDVJYKhxBFX6jYgcDJLwm8tet4fDScv8g==
Received: from DM6PR08CA0054.namprd08.prod.outlook.com (2603:10b6:5:1e0::28)
 by BY5PR12MB5016.namprd12.prod.outlook.com (2603:10b6:a03:1c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Sun, 24 Oct
 2021 14:31:15 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::7f) by DM6PR08CA0054.outlook.office365.com
 (2603:10b6:5:1e0::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20 via Frontend
 Transport; Sun, 24 Oct 2021 14:31:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 14:31:14 +0000
Received: from [172.27.13.118] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 14:31:10 +0000
Message-ID: <fe38a4b6-186c-c2fe-e6f9-df33a27640e1@nvidia.com>
Date:   Sun, 24 Oct 2021 17:31:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, <hch@infradead.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
 <YTYvOetMHvocg9UZ@stefanha-x1.localdomain>
 <692f8e81-8585-1d39-e7a4-576ae01438a1@nvidia.com>
 <YUCUF7co94CRGkGU@stefanha-x1.localdomain>
 <56cf84e2-fec0-08e8-0a47-24bb1df71883@nvidia.com>
 <20211022051343-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20211022051343-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc4ce97f-935f-4bd6-5a60-08d996faef39
X-MS-TrafficTypeDiagnostic: BY5PR12MB5016:
X-Microsoft-Antispam-PRVS: <BY5PR12MB501674E8FC57D894DA7E081EDE829@BY5PR12MB5016.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N5IHKiTMXsZl9342Owzg0ZLNMiNXCIh0FrWEZKUad+sglMwHdHE/Qv8F0f1aLM4BsNmlLeJX0fmQVS6YyvaySMdnq/XFtQgoxBDMOrMKCxNghhyQugVL6UwWCMZsJt0v87xrJOyruA8kCl1qcE1fNNhykazob+uOzTr62IihFyVVm2VdGvWge7gmg7ftTPZbz3pOu1Kqo+5ojS+WLg7WF/CZSlE1Ku/YBdyZdvhZF4cKDcXfxYAcHvkUH9ZK/1Ehr7UqaNLQsZWIxzBkDEHkGp8cCBCDDV2cdbjBdcJc+3/Gn8yS485LweTejAip7asgH8MFA9RfBTdEgg29paAEeL1i7NG5HeR5+/Hq9781K1T+UZJDxU/tXTlbbFC+M9g4UKXDHjLOK6grS6HY7yEZjqBVc9BvsNCath7smegHbfRhYtU9v1uq8Scv27ySp42FGZFSIjIM+nRgwaz3LbDJMqQVe+8TeTarxojhXihO0X1zr6AiB1trQRWKrtGyr/DgrMjwryDRmU79JsiJ6RaNsukxJ70PEbQEtobgJH5IngJFlk9K1XGYE2FBjdjkokiAYBE2hrhKQOBl3qO/4bDzT2Xb70taebXClCi/K5lSi24A63dYVytQXEcrI7w/SA/5ehwrz34QixssQviLPGh2fECrohB+Ppi/J7oN0n0Yl18w/BdS7PGdIwd8oTHFYU8tpKZRB49H4W7CR89DGkAC18b7xkEVB6yjE5FRwrA0W3pdDqrO/dFsnuqHBLoTQT9l5e4ykk/a2ptpRahEUSYcdg5nUWWh/oQaTm5RJeM8Ciuryul1C+NYFW9JaylRWQSS
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36906005)(53546011)(86362001)(6916009)(36860700001)(356005)(82310400003)(26005)(966005)(508600001)(36756003)(16576012)(5660300002)(47076005)(186003)(316002)(83380400001)(54906003)(70586007)(70206006)(31686004)(4326008)(6666004)(7636003)(8676002)(31696002)(426003)(2906002)(2616005)(336012)(16526019)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 14:31:14.7970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc4ce97f-935f-4bd6-5a60-08d996faef39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5016
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/22/2021 12:15 PM, Michael S. Tsirkin wrote:
> My tree is ok.
> Looks like your patch was developed on top of some other tree,
> not plan upstream linux, so git am fails. I applied it using
> patch and some manual tweaking, and it seems to work for
> me but please do test it in linux-next and confirm -
> will push to a linux-next branch in my tree soon.

I've tested. looks fine.


>
> On Thu, Sep 23, 2021 at 04:40:56PM +0300, Max Gurtovoy wrote:
>> Hi MST/Jens,
>>
>> Do we need more review here or are we ok with the code and the test matrix ?
>>
>> If we're ok, we need to decide if this goes through virtio PR or block PR.
>>
>> Cheers,
>>
>> -Max.
>>
>> On 9/14/2021 3:22 PM, Stefan Hajnoczi wrote:
>>> On Mon, Sep 13, 2021 at 05:50:21PM +0300, Max Gurtovoy wrote:
>>>> On 9/6/2021 6:09 PM, Stefan Hajnoczi wrote:
>>>>> On Wed, Sep 01, 2021 at 04:14:34PM +0300, Max Gurtovoy wrote:
>>>>>> No need to pre-allocate a big buffer for the IO SGL anymore. If a device
>>>>>> has lots of deep queues, preallocation for the sg list can consume
>>>>>> substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
>>>>>> can be 64 or 128 and each queue's depth might be 128. This means the
>>>>>> resulting preallocation for the data SGLs is big.
>>>>>>
>>>>>> Switch to runtime allocation for SGL for lists longer than 2 entries.
>>>>>> This is the approach used by NVMe drivers so it should be reasonable for
>>>>>> virtio block as well. Runtime SGL allocation has always been the case
>>>>>> for the legacy I/O path so this is nothing new.
>>>>>>
>>>>>> The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
>>>>>> support SG_CHAIN, use only runtime allocation for the SGL.
>>>>>>
>>>>>> Re-organize the setup of the IO request to fit the new sg chain
>>>>>> mechanism.
>>>>>>
>>>>>> No performance degradation was seen (fio libaio engine with 16 jobs and
>>>>>> 128 iodepth):
>>>>>>
>>>>>> IO size      IOPs Rand Read (before/after)         IOPs Rand Write (before/after)
>>>>>> --------     ---------------------------------    ----------------------------------
>>>>>> 512B          318K/316K                                    329K/325K
>>>>>>
>>>>>> 4KB           323K/321K                                    353K/349K
>>>>>>
>>>>>> 16KB          199K/208K                                    250K/275K
>>>>>>
>>>>>> 128KB         36K/36.1K                                    39.2K/41.7K
>>>>> I ran fio randread benchmarks with 4k, 16k, 64k, and 128k at iodepth 1,
>>>>> 8, and 64 on two vCPUs. The results look fine, there is no significant
>>>>> regression.
>>>>>
>>>>> iodepth=1 and iodepth=64 are very consistent. For some reason the
>>>>> iodepth=8 has significant variance but I don't think it's the fault of
>>>>> this patch.
>>>>>
>>>>> Fio results and the Jupyter notebook export are available here (check
>>>>> out benchmark.html to see the graphs):
>>>>>
>>>>> https://gitlab.com/stefanha/virt-playbooks/-/tree/virtio-blk-sgl-allocation-benchmark/notebook
>>>>>
>>>>> Guest:
>>>>> - Fedora 34
>>>>> - Linux v5.14
>>>>> - 2 vCPUs (pinned), 4 GB RAM (single host NUMA node)
>>>>> - 1 IOThread (pinned)
>>>>> - virtio-blk aio=native,cache=none,format=raw
>>>>> - QEMU 6.1.0
>>>>>
>>>>> Host:
>>>>> - RHEL 8.3
>>>>> - Linux 4.18.0-240.22.1.el8_3.x86_64
>>>>> - Intel(R) Xeon(R) Silver 4214 CPU @ 2.20GHz
>>>>> - Intel Optane DC P4800X
>>>>>
>>>>> Stefan
>>>> Thanks, Stefan.
>>>>
>>>> Would you like me to add some of the results in my commit msg ? or Tested-By
>>>> sign ?
>>> Thanks, there's no need to change the commit description.
>>>
>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>> Tested-by: Stefan Hajnoczi <stefanha@redhat.com>
