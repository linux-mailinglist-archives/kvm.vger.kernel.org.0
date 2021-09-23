Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867FB41602B
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 15:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239161AbhIWNmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 09:42:36 -0400
Received: from mail-mw2nam10on2074.outbound.protection.outlook.com ([40.107.94.74]:32929
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231974AbhIWNmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 09:42:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqzG45HaAf7xs1BP4+uDfZy91F13I+7Kt1F10V+yr+YMKVCm+iKPzUg1E3FsvOaJwLiRw3k8F2wvtPaiOHVVVhEK3T4qg8by/6xzUGt3o5wEohcydYml/hzQvwp8w0G9MLJDCnfnhI2VP+rT09FYqkl/EscLiCiGcJpyVYcsaNBTPKAhyOsQSCLEhHJhjIF7PnYJYPj8tl+/NGMrnqOg8EnIZPxhVbTC+/JwvWdPUJDmqpv6THsWHNxCq1oboh86UTY0M7jW5MqZoETya+EGtj6wgE48M/TzR2aIpO5HCPAjnhi8a4RfHNDMm1gH+PNbCOEap1zhUydu9iUr7Kt2Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fDK68mcob+Bu+ZJ7Ssh8u/I7SweBb6UypZf94T0Iko8=;
 b=dcZJwXL6rEFnRuS5vutBdQeMAV5MOiqIRxN89eztEb2kAzbqdYonYgjYih2A/6KDbA3jwyvsVzjKrcWKafMAJIYsZFoEHCucnNgpALFqGbQ7wfz3D2wexqVhbV4wVi5+lvjj0ySwLo6wBswzDnrz7X0tD/1W1EAkbOq12q1ORnEBhQ1yyqahQSzSoSS2CgnqYG0jYel2nFOFmY8VvdZnOeYOHRG9gcTG1x9WtbF3AcXOb0hmyKQIA1y7QkOCBeEyofwYlV30kzbao7/aZc42OT0ndMCCudBCgWlCtgkThQ3k4JcMxUrZEHakWx5Z4EImVbge+xsfdCD/pclqffjilg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=kernel.dk smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDK68mcob+Bu+ZJ7Ssh8u/I7SweBb6UypZf94T0Iko8=;
 b=p1/W1FCS9tSZWJ1HKcq6r0N4+y2TUGjsl4P8C2ZiUzjlEiVBzhnwAWgXOlgRkHE1E3MR7xdVf8Xgn2Vbqt9bWniUb8z/nZx8cdUrznDiwv7l57WfLz/pkDtxDq++JI8DF5/y5b4/jhzo99Z3M6Bj9GSZRpTG18xVOOjtccq65MSrV6jjjERmuD3WuKqArxoVLZCMd/0j75OlwTQ3b10c2y68LUgOyvbXpABINAkmCiN00T+dHwUgQml7ojpE0dY1OP5S4u4OukP6EoGHZ/jwcc6GXK1cwrFz2TJn4KGAo91RtrKKgEbBtSABiFHxHsgswyT/V5X2pgGDi7b5DYVtLw==
Received: from DM5PR06CA0051.namprd06.prod.outlook.com (2603:10b6:3:37::13) by
 DM5PR1201MB0236.namprd12.prod.outlook.com (2603:10b6:4:57::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.14; Thu, 23 Sep 2021 13:41:02 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::3) by DM5PR06CA0051.outlook.office365.com
 (2603:10b6:3:37::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend
 Transport; Thu, 23 Sep 2021 13:41:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 13:41:02 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Sep
 2021 06:41:01 -0700
Received: from [172.27.15.96] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Sep
 2021 13:40:58 +0000
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, "mst@redhat.com" <mst@redhat.com>
CC:     <hch@infradead.org>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
 <YTYvOetMHvocg9UZ@stefanha-x1.localdomain>
 <692f8e81-8585-1d39-e7a4-576ae01438a1@nvidia.com>
 <YUCUF7co94CRGkGU@stefanha-x1.localdomain>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <56cf84e2-fec0-08e8-0a47-24bb1df71883@nvidia.com>
Date:   Thu, 23 Sep 2021 16:40:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YUCUF7co94CRGkGU@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 862d6dd5-706b-4f45-3cba-08d97e97c8db
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0236:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02365339B750C22879266603DEA39@DM5PR1201MB0236.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pl4vLU1J6yHftu+FFlnyV22bDCJ/xzbA0+7jZA8RIdHfyZD9psApSeoI5IWdzU/IU+dImqvHpFOaf/NHDTW1uU7KvYRiLpN/xEtznbrR9scWZp4oPezotGj9cJV3Y1xG91S50P8VywlK0iOS96dDyvoDJnZXpeJo34tGihJcUfEMrQq5+FCYKAROj2URnG38eDz5zdO9RDvRTEmczKNIgE20w4o8kHocUJRtyjFj6O67MRmn+G2RUmKILydb0H2jrIxVmBouxEa5+KCARKAh8+7McfkLzth+K4I8DuTatn81CtqEiuV8rUccgepQbfjuCp6CkF74DgAAhlnc8/UGjxOm/KTCHBenOAYyCV/Bpd4zOsj8wON+nxkEVSCHuceLA5/8f9EeHXwCDsgu5XJHnxMxF8P/GBT3u1h26IU2o5t14zO7l13DNjykYT3K9XN0o0kghF6SA9l0qVVwx8It3QXfhv/HOqcaqRoK61F//bl+WSnxdi1GPIuOzLjzEeNRGNxmzmzr0EB70laPLPhByA2j3D/W1DFFCTIGWw6UTIwdqKapqlaG6T6eHWiHzu0Vrd74K51t2wOSda5AvvLB41HZJ5ll2aF82oHztGEjUkj8UpwIPKFArzgxazFkOrwFuymSy4GMhsolq5byHBetjgNK3yLzXvqKxDBU/pYGDKYLxFgHN7htKo2NNE3uRILsTqOfUkRRJCVxMb4XxkE19VcgrEMnwh10DaJxxrWg2+JkCiUe1ZMQiPQ4WZk/081DTGdEzo2g2F+Cc2E/HcUf3WQcS5jtV8gbKVoKduuRi+Ii+lK34VN0mic0fiCMxzfD
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(8676002)(70586007)(70206006)(966005)(82310400003)(8936002)(16526019)(356005)(83380400001)(336012)(4326008)(2616005)(2906002)(426003)(36860700001)(31686004)(186003)(53546011)(7636003)(47076005)(54906003)(110136005)(5660300002)(316002)(36756003)(16576012)(31696002)(508600001)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 13:41:02.3509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 862d6dd5-706b-4f45-3cba-08d97e97c8db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0236
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi MST/Jens,

Do we need more review here or are we ok with the code and the test matrix ?

If we're ok, we need to decide if this goes through virtio PR or block PR.

Cheers,

-Max.

On 9/14/2021 3:22 PM, Stefan Hajnoczi wrote:
> On Mon, Sep 13, 2021 at 05:50:21PM +0300, Max Gurtovoy wrote:
>> On 9/6/2021 6:09 PM, Stefan Hajnoczi wrote:
>>> On Wed, Sep 01, 2021 at 04:14:34PM +0300, Max Gurtovoy wrote:
>>>> No need to pre-allocate a big buffer for the IO SGL anymore. If a device
>>>> has lots of deep queues, preallocation for the sg list can consume
>>>> substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
>>>> can be 64 or 128 and each queue's depth might be 128. This means the
>>>> resulting preallocation for the data SGLs is big.
>>>>
>>>> Switch to runtime allocation for SGL for lists longer than 2 entries.
>>>> This is the approach used by NVMe drivers so it should be reasonable for
>>>> virtio block as well. Runtime SGL allocation has always been the case
>>>> for the legacy I/O path so this is nothing new.
>>>>
>>>> The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
>>>> support SG_CHAIN, use only runtime allocation for the SGL.
>>>>
>>>> Re-organize the setup of the IO request to fit the new sg chain
>>>> mechanism.
>>>>
>>>> No performance degradation was seen (fio libaio engine with 16 jobs and
>>>> 128 iodepth):
>>>>
>>>> IO size      IOPs Rand Read (before/after)         IOPs Rand Write (before/after)
>>>> --------     ---------------------------------    ----------------------------------
>>>> 512B          318K/316K                                    329K/325K
>>>>
>>>> 4KB           323K/321K                                    353K/349K
>>>>
>>>> 16KB          199K/208K                                    250K/275K
>>>>
>>>> 128KB         36K/36.1K                                    39.2K/41.7K
>>> I ran fio randread benchmarks with 4k, 16k, 64k, and 128k at iodepth 1,
>>> 8, and 64 on two vCPUs. The results look fine, there is no significant
>>> regression.
>>>
>>> iodepth=1 and iodepth=64 are very consistent. For some reason the
>>> iodepth=8 has significant variance but I don't think it's the fault of
>>> this patch.
>>>
>>> Fio results and the Jupyter notebook export are available here (check
>>> out benchmark.html to see the graphs):
>>>
>>> https://gitlab.com/stefanha/virt-playbooks/-/tree/virtio-blk-sgl-allocation-benchmark/notebook
>>>
>>> Guest:
>>> - Fedora 34
>>> - Linux v5.14
>>> - 2 vCPUs (pinned), 4 GB RAM (single host NUMA node)
>>> - 1 IOThread (pinned)
>>> - virtio-blk aio=native,cache=none,format=raw
>>> - QEMU 6.1.0
>>>
>>> Host:
>>> - RHEL 8.3
>>> - Linux 4.18.0-240.22.1.el8_3.x86_64
>>> - Intel(R) Xeon(R) Silver 4214 CPU @ 2.20GHz
>>> - Intel Optane DC P4800X
>>>
>>> Stefan
>> Thanks, Stefan.
>>
>> Would you like me to add some of the results in my commit msg ? or Tested-By
>> sign ?
> Thanks, there's no need to change the commit description.
>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Tested-by: Stefan Hajnoczi <stefanha@redhat.com>
