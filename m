Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3855B400FE8
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 15:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbhIENSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 09:18:02 -0400
Received: from mail-dm6nam12on2069.outbound.protection.outlook.com ([40.107.243.69]:39264
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229759AbhIENSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 09:18:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQMH/uFB9nDjXp/SEyYnDgIxzFhbBB12thuWj+UevpKPLi4/q9DEXu9MY9Q5KeYrxSFvJpcqWzuoQCXUS3BEZonck8vsG8s9+pIIK00R62jl4y8zqcYqUbkhV/ZR/BbpBWjouBvruE6XPJpSgUxcud1ZaWidTQ5vshcGxnEbk7NBi0IW7kfZGODTtycsfFrQBK51U69oAN2z5CW2zzL/tMGMT3KzZSvACOj99y9f3T1WSyrlbWP3kbLREjnib9WGNu2OWBWM1Iq+bISxRhwVHWSYVKNj8q1LYrIX+92LvNQuoxlFxQlEuTRo4gwBTEhE4rLv29s9z2uqrSfLYCXV+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydjlHOGGKcCjN/B5Is6BoR2yX7OttLQsRhBr4t91eR8=;
 b=g9i8nX1qGWxfXE5qwqjCfLpUYnHH0bZnsSe7NDevC+0c+FMIxD6y/KBmSBXNBrMff6zYEDoCFg9CwUzGuHQFAco3O55X5lEj6iEqVW9vsGxSzyE79GCbS4Els2GPaIPoVtkqzj3OjDnh08TFzEVRS0Q7n7FARDV3z5/ZkbTi6EB+SbkgFWjg/v7iwqtD7RU/tLT4NJB8to4SKag1nv9Z1IODKE20DAV06I0davaCl5CoIt2JTDawZ0TOfSvO2Uw48xvFrpPLAsgxY3hX+YoMhGebKYyldfbT7ObPU0Z5O1CscHPHzbfhhm3pQt/F9lzEqyVa0sqiKnH/rK+dvDytbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydjlHOGGKcCjN/B5Is6BoR2yX7OttLQsRhBr4t91eR8=;
 b=QW2CEivH3/D/y51UB8jT/JXyDBdonBV6olwIJ8oB8vl5+aJZKmRNWKQ8A8DbsuvCwmcHgfuRWm93eJEte8a70bHuM+6jaUTGIRUETz4sKFzDseG2ybpVaoRvRdIYwo2CoZehttG4P3Nob0XOwcjg3YFjjuwVSpGxFLsLL+T7FWjVMc7EybHkoSqJo8uUgT11zwfkscervHegZgtq1OOLyCCNfIo79irnTHWaz5FNBfdYsG+uT5ZWsn/7AHVd9vJWSjlkC2LmlKqMDl1Ci88npWqAOFFgQIOi1MMPEuVlyY4gVGDQxxYVHFMps7azFHIQawVDfqLTo/RgwOOxW+CAdg==
Received: from MWHPR13CA0014.namprd13.prod.outlook.com (2603:10b6:300:16::24)
 by BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Sun, 5 Sep
 2021 13:16:55 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::f1) by MWHPR13CA0014.outlook.office365.com
 (2603:10b6:300:16::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.4 via Frontend
 Transport; Sun, 5 Sep 2021 13:16:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Sun, 5 Sep 2021 13:16:55 +0000
Received: from [172.27.15.146] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Sep
 2021 13:16:51 +0000
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
To:     Leon Romanovsky <leon@kernel.org>
CC:     Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, <hch@infradead.org>,
        <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>, <israelr@nvidia.com>,
        <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <YTR12AHOGs1nhfz1@unreal> <b2e60035-2e63-3162-6222-d8c862526a28@gmail.com>
 <e4455133-ac9f-44d0-a07d-be55b336ebcc@nvidia.com> <YTSZpm1GZGT4BUDR@unreal>
 <5aada544-356f-5363-c6e4-6885e9812f82@nvidia.com> <YTTBrD/0bHcyfNGm@unreal>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <47718828-5a01-1673-92c3-20a02add84de@nvidia.com>
Date:   Sun, 5 Sep 2021 16:16:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTTBrD/0bHcyfNGm@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d761388-3200-4283-da02-08d9706f6eed
X-MS-TrafficTypeDiagnostic: BYAPR12MB2823:
X-Microsoft-Antispam-PRVS: <BYAPR12MB28233F9BF81B2DE27E1BE376DED19@BYAPR12MB2823.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OiSk3sM+RqlsM998RQaBgrWqN0mhC3GoBHhb1Gk/8ffohhhTECjpecsSRp7GHObJ96HP2Oz0z+M1uPYIMauDb4DlOeO2fyA4giywbpdLLDoDt0U0FfPy6PYMM5dSLF6Nh8iojpcR6IpaYSkRUwGLdttIgEfIU792zwL5BrFQN0Od+A1a+r5MPSRNUkAlQzlB1GGiU+elUTXn1Y77T8LC1tjiz0cEU+IByzYo2qFbKghHtBuAutYLSFEonbgBbLrw9LFSVUWAwtFlb+qTFf2hpF+LudVoeR0YfQR/Yhhl4RQhm3etZvxnW7sIp4m8mZHFPmuyzmBjATE7CK/nrVvxSbgUshRSoVXue/8AARpmrpFVwOZASDC7eNCfk2T6WBugL4mO5FWR9pL32QZOKcpGNr3DWQv1d8EbQpA6is0m9mbrnoBOaPKzJCX1mA7RpAZRT6MZ0ztNDxLruFJKL+T0TPO/VzodMKYHvAt7j9celnJ3UckJHzxQVBYx+nggirJ63cwW0ya1q+qBEMzkLbBMlqbi4pn78Unv4u2PM8cilQpNrssSlZJulHvIlBGtTUh8nSjUmcA+dWX7T0QFiZ63tTlBXlUFQMIztuv5jrrmkCgQOt0pnOZMKNHzI10cYOmr/2H6KrIp1YozNCbxdogtgY+0kfIXT5D0bS4OGUpgyuvYkC0mvr6vwVhyQCkFdvSRgeL9Bg+T0VZBGfKCsm3ahY2Ezbwub0lnLgr4NqpNqU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(36840700001)(46966006)(47076005)(82310400003)(31686004)(70586007)(5660300002)(70206006)(36756003)(83380400001)(426003)(4326008)(336012)(82740400003)(36860700001)(356005)(8676002)(6916009)(53546011)(8936002)(186003)(478600001)(54906003)(7636003)(26005)(16526019)(31696002)(16576012)(2906002)(316002)(86362001)(36906005)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2021 13:16:55.3408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d761388-3200-4283-da02-08d9706f6eed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2823
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/5/2021 4:10 PM, Leon Romanovsky wrote:
> On Sun, Sep 05, 2021 at 02:16:58PM +0300, Max Gurtovoy wrote:
>> On 9/5/2021 1:19 PM, Leon Romanovsky wrote:
>>> On Sun, Sep 05, 2021 at 12:19:09PM +0300, Max Gurtovoy wrote:
>>>> On 9/5/2021 11:49 AM, Chaitanya Kulkarni wrote:
>>>>> On 9/5/2021 12:46 AM, Leon Romanovsky wrote:
>>>>>>> +static unsigned int num_request_queues;
>>>>>>> +module_param_cb(num_request_queues, &queue_count_ops,
>>>>>>> &num_request_queues,
>>>>>>> +        0644);
>>>>>>> +MODULE_PARM_DESC(num_request_queues,
>>>>>>> +         "Number of request queues to use for blk device.
>>>>>>> Should > 0");
>>>>>>> +
>>>>>> Won't it limit all virtio block devices to the same limit?
>>>>>>
>>>>>> It is very common to see multiple virtio-blk devices on the same system
>>>>>> and they probably need different limits.
>>>>>>
>>>>>> Thanks
>>>>> Without looking into the code, that can be done adding a configfs
>>>>>
>>>>> interface and overriding a global value (module param) when it is set
>>>>> from
>>>>>
>>>>> configfs.
>>>>>
>>>>>
>>>> You have many ways to overcome this issue.
>>>>
>>>> For example:
>>>>
>>>> # ls -l /sys/block/vda/mq/
>>>> drwxr-xr-x 18 root root 0 Sep  5 12:14 0
>>>> drwxr-xr-x 18 root root 0 Sep  5 12:14 1
>>>> drwxr-xr-x 18 root root 0 Sep  5 12:14 2
>>>> drwxr-xr-x 18 root root 0 Sep  5 12:14 3
>>>>
>>>> # echo virtio0 > /sys/bus/virtio/drivers/virtio_blk/unbind
>>>>
>>>> # echo 8 > /sys/module/virtio_blk/parameters/num_request_queues
>>> This is global to all virtio-blk devices.
>> You define a global module param but you bind/unbind a specific device.
>>
>> Do you have a better way to control it ?
> One of the possible solutions will be to extend virtio bus to allow
> setting of such pre-probe parameters. However I don't know if it is
> really worth doing it,

So lets keep it as it is now.

Thanks.

>> if the device is already probed, it's too late to change the queue_num.
>>
>>
>>>> # echo virtio0 > /sys/bus/virtio/drivers/virtio_blk/bind
>>>>
>>>> # ls -l /sys/block/vda/mq/
>>>> drwxr-xr-x 10 root root 0 Sep  5 12:17 0
>>>> drwxr-xr-x 10 root root 0 Sep  5 12:17 1
>>>> drwxr-xr-x 10 root root 0 Sep  5 12:17 2
>>>> drwxr-xr-x 10 root root 0 Sep  5 12:17 3
>>>> drwxr-xr-x 10 root root 0 Sep  5 12:17 4
>>>> drwxr-xr-x 10 root root 0 Sep  5 12:17 5
>>>> drwxr-xr-x 10 root root 0 Sep  5 12:17 6
>>>> drwxr-xr-x 10 root root 0 Sep  5 12:17 7
>>>>
>>>> -Max.
>>>>
>>>>
