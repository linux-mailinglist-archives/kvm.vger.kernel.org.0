Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B35335C606
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 14:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239874AbhDLMR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 08:17:28 -0400
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:52769
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238550AbhDLMR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 08:17:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPalngKhtQ7l+Zawiv/THvSYcuwZQko5yVDAdHlcoWRqCKXaA2wSu9o7RJ5NLMUbMta0EGGx94TLGsLxq5/sgzEZbrEOEE3JGqERPNpEHTKDUme5vcuQWxjdym4z9HveGMR6E988xZE6Agq9kRWFB33fqYVLWDREuEoeBNJC7BuSLQZbX+A+UWbKeBwFv618ali3RNgy3WHrNL5HdmjuGyRq4/TFXLx3bnxvJkPPmDKJE4XhwpcMwDMbeHWpgDI2lqI4FLnLtxID/6faRIFSwiVxVWbmjeGbpnev3M0bRbvxnOZD/yWixoGuXJ0t1nW0ffgpSSb3RDcqSzPF0CiZkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biS2m6I9ahC2Ekh8+K7ClUEPg7MZEhKZuwWIMECNf+4=;
 b=B+gao8EIg5u1IF5QTEAgiNa72Zt400Z/QCgsZEDrmukKqB+d1Vs7jU+m63bxaz5kipKYd262GTU7OgyILoTvA2vw7DIcrFYX7SxDoWIme0G6UzVoYeSGG2wSf0rVXcMW5+QaJk+o+m4T4niq4XIZ9T0amA/1ThomKu2QqqNjGFTBT0ti5i1xzuff85lSEaSS/9Z6Wc3mdzg5bDI105Y/8mh66UnDp87G0sOOjy2cpdXG6bhIr555zbsoxXbYKxzz8GpXe5KXHYsrWHoaLxslQ3UcDEkONgf1iTC653ZW/tOUt3vN4tmj3TC4RtMxzDoNrLsT57hKhFrxTNMUBpsNHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biS2m6I9ahC2Ekh8+K7ClUEPg7MZEhKZuwWIMECNf+4=;
 b=fWUA2nYrZnp3v7rfU7eFJL3FvxOsHqp/Z5UE2s23ECUBKRf3+iSSWbwEQi5WRLLOjcOf6tbQVJ6CxlAFiyTuxA42TklhHXGLkw69WTiDmr8736bns7FZmgmp5nvEuOt0U5idkvO2Yh2g4lVsKDMdj4bYfF6NuqPYS4fsZ9dpvZcYrxbW03SxLahwOYTlA2wzKun64QWm2meDXSprp52z/unSdzEOpZhKH9QRzFSRofKH5UFbk3EbpCbsYUJ3YiitTlCT+aFdbqGVi7bNRkgo3SXnDAu5uWJLbqWWRPv/OBBQSs3ytICcwgJbSwulJtHY3PKC5iV3zTU9MwSoX1RxlQ==
Received: from DM5PR15CA0031.namprd15.prod.outlook.com (2603:10b6:4:4b::17) by
 MWHPR12MB1408.namprd12.prod.outlook.com (2603:10b6:300:12::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.22; Mon, 12 Apr 2021 12:17:07 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::6b) by DM5PR15CA0031.outlook.office365.com
 (2603:10b6:4:4b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Mon, 12 Apr 2021 12:17:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 12:17:07 +0000
Received: from [172.27.0.90] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Apr
 2021 12:17:05 +0000
Subject: Re: [PATCH v2 1/3] virtio: update reset callback to return status
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <oren@nvidia.com>,
        <nitzanc@nvidia.com>, <cohuck@redhat.com>
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
 <16fa0e31-a305-3b41-b0d3-ad76aa00177b@redhat.com>
 <1f134102-4ccb-57e3-858d-3922d851ce8a@nvidia.com>
 <a46cef9b-b8da-b748-c332-a3a05bd9135f@redhat.com>
 <103ae6fe-1ffc-90a3-09cd-bcbbcbb8eee7@nvidia.com>
 <7d4599c5-348e-5ca1-8eb6-577d65dc4688@redhat.com>
 <96742dde-edba-0329-c9c2-b3ac3b28cf1d@nvidia.com>
 <20210412050311-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <e1e4a42c-2e87-adc1-9089-1c722f02b810@nvidia.com>
Date:   Mon, 12 Apr 2021 15:17:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210412050311-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71a48422-d58d-49da-43c7-08d8fdace40c
X-MS-TrafficTypeDiagnostic: MWHPR12MB1408:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1408D44FC4082C766F56C27CDE709@MWHPR12MB1408.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GxVdl0sn09W+BibY5cQOGUniliQz1dXCuRZEmgDVlG87Vei9h8LyRo0XBnNgRD5Xj0KEP+9528wF/xLgQ3VBDBcKTj2IZxDFukBFxbyu+TjCjK8yMttoggkivvVOs7M9kTKGvsNbFqjBk0qSJg9ftqNTHKljH3/MEQyhtM8JDclvRWZGvAto6BNeC9pEs8nBGZkCt87j8yp73qR+IZk1bclYPtK0uY6Oi/H5+ozqk8WNXykKJXG4qDc4dCv0fiQXUn94vBv+14gtdVXoHwKJk8ZCWmklxKUqmxaHDCuOBLdB/FUw6fI61Xj40xsjEV9iE1D0wQ0onkUnAZfYym/ZMIf3TQoPjHJmZ5CPZJdGCMA7bjQrAT+GmQW/jkPpmKyekliLqUiEKftpTZELTpAhmB9mutFvbbeRPJRK3ksZxIHzJLZxWUF1KvhSQq9Nz2kgO0W6qBW6KUdggor5SddlLTqJCURX4aUsAYaNABn6eIHi2EJXoJ10l9T1sJxUEY4+RX0ux5LOsVtBcMG4o+by9HaEtWVm7MNgSr0uxmx0/5W+fqaSbME3S1CbmPUsOTMprz0MaeoDLPtLYTId5THjQpp99UlhJiFs6DN6d2i2vTy8aobR/FiWSHcVIiDCyh4E9DeZChpMVo86lDZ1nAfCaDPH0Gqz46kvbmNk051FVIXHJdi8sb1S3f5XX6BqFJ+m
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(36840700001)(54906003)(5660300002)(4326008)(2906002)(53546011)(15650500001)(26005)(356005)(336012)(70586007)(8676002)(7636003)(6916009)(70206006)(16576012)(82740400003)(82310400003)(6666004)(2616005)(36906005)(30864003)(36860700001)(31686004)(31696002)(186003)(16526019)(8936002)(47076005)(36756003)(86362001)(316002)(83380400001)(426003)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 12:17:07.3587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a48422-d58d-49da-43c7-08d8fdace40c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1408
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/12/2021 12:07 PM, Michael S. Tsirkin wrote:
> On Sun, Apr 11, 2021 at 12:50:22PM +0300, Max Gurtovoy wrote:
>> On 4/9/2021 8:22 AM, Jason Wang wrote:
>>> 在 2021/4/8 下午10:24, Max Gurtovoy 写道:
>>>> On 4/8/2021 4:14 PM, Jason Wang wrote:
>>>>> 在 2021/4/8 下午5:56, Max Gurtovoy 写道:
>>>>>> On 4/8/2021 11:58 AM, Jason Wang wrote:
>>>>>>> 在 2021/4/8 下午4:11, Max Gurtovoy 写道:
>>>>>>>> The reset device operation, usually is an operation
>>>>>>>> that might fail from
>>>>>>>> various reasons. For example, the controller might
>>>>>>>> be in a bad state and
>>>>>>>> can't answer to any request. Usually, the paravirt SW based virtio
>>>>>>>> devices always succeed in reset operation but this
>>>>>>>> is not the case for
>>>>>>>> HW based virtio devices.
>>>>>>>
>>>>>>> I would like to know under what condition that the reset
>>>>>>> operation may fail (except for the case of a bugg
>>>>>>> guest).
>>>>>> The controller might not be ready or stuck. This is a real
>>>>>> use case for many PCI devices.
>>>>>>
>>>>>> For real devices the FW might be in a bad state and it can
>>>>>> happen also for paravirt device if you have a bug in the
>>>>>> controller code or if you entered some error flow (Out of
>>>>>> memory).
>>>>>>
>>>>>> You don't want to be stuck because of one bad device.
>>>>>
>>>>> So the buggy driver can damage the host through various ways,
>>>>> I'm not sure doing such workaround is worthwhile.
>>>> do you mean device ?
>>>
>>> Yes.
>>>
>>>
>>>> sometimes you need to replace device FW and it will work.
>>>>
>>>> I don't think it's a workaround. Other protocols, such as NVMe,
>>>> solved this in the specification.
>>>>
>>>> PCI config space and PCI controller are sometimes 2 different
>>>> components and sometimes the controller is not active, although the
>>>> device is plugged and seen by the PCI subsystem.
>>>
>>> So I think we need patch to spec to see if it works first.
>> We can't leave the driver to loop forever without allowing next "good"
>> virtio devices to probe.
>>
>> We can in parallel look for spec fixes but for now we must fix the driver.
> I'd like to narrow the case though. the proper thing
> would probably be for device to clear the status.
> Provided it entered some state where it can not do it -
> is there anything special about
> the device state that *can* be detected?
> If yes what is it?

We don't have anything in the spec to detect it.

Different devices can have different behavior.

The only thing we can count on is that the device didn't present a 0 in 
device_status once that was requested.


>
>> The fix can be using the mechanism introduced in this series or adding an
>> async probing mechanism.
> What would that be?

just schedule some work using queue_work/schedule_work.

And wait for it in the virtio_pci_remove

>> In both solutions, we can't allow looping forever.
> Multiple minute downtime isn't much better either. I'd like a
> much shorter timer or even no timer at all, instead
> verifying that device is alive every X iterations.

I added an option to configure the module parameter.

I think 2-3 minutes to wait is not so bad and one can configure it for 
any value that fits.


>
>>>
>>>>
>>>>> Note that this driver has been used for real hardware PCI
>>>>> devices for many years. We don't receive any report of this
>>>>> before.
>>>>>
>>>>>
>>>>>>
>>>>>>>
>>>>>>>> This commit is also a preparation for adding a timeout mechanism for
>>>>>>>> resetting virtio devices.
>>>>>>>>
>>>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>>>> ---
>>>>>>>>
>>>>>>>> changes from v1:
>>>>>>>>    - update virtio_ccw.c (Cornelia)
>>>>>>>>    - update virtio_uml.c
>>>>>>>>    - update mlxbf-tmfifo.c
>>>>>>>
>>>>>>> Note that virtio driver may call reset, so you probably
>>>>>>> need to convert them.
>>>>>> I'm sure I understand.
>>>>>>
>>>>>> Convert to what ?
>>>>>
>>>>> Convert to deal with the possible rest failure. E.g in
>>>>> virtblk_freeze() we had:
>>>>>
>>>>> static int virtblk_freeze(struct virtio_device *vdev)
>>>>> {
>>>>>          struct virtio_blk *vblk = vdev->priv;
>>>>>
>>>>>          /* Ensure we don't receive any more interrupts */
>>>>>          vdev->config->reset(vdev);
>>>>> ...
>>>>>
>>>>> We need fail the freeze here.
>>>>
>>>> Agree.
>>>>
>>>>
>>>>> Another example is the driver remove which is not expected to be
>>>>> fail. A lot of virtio drivers tries to call reset there. I'm not
>>>>> sure how hard to deal with the failure in the path of remove
>>>>> (e.g __device_release_driver tends to ignore the return value of
>>>>> bus->remove().)
>>>> I think it can stay as-is and ignore the ->reset return value and
>>>> continue free the other resources to avoid leakage.
>>>
>>> The problem is that it's unclear that what kind of behaviour would the
>>> device do, e.g can it still send interrupts?
>>>
>>> That's why we need to formalize the bahviour first if necessary.
>>>
>>> Thanks
>>>
>>>
>>>>
>>>>> Thanks
>>>>>
>>>>>
>>>>>> Thanks.
>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>>
>>>>>>>> ---
>>>>>>>>    arch/um/drivers/virtio_uml.c             |  4 +++-
>>>>>>>>    drivers/platform/mellanox/mlxbf-tmfifo.c |  4 +++-
>>>>>>>>    drivers/remoteproc/remoteproc_virtio.c   |  4 +++-
>>>>>>>>    drivers/s390/virtio/virtio_ccw.c         |  9 ++++++---
>>>>>>>>    drivers/virtio/virtio.c                  | 22
>>>>>>>> +++++++++++++++-------
>>>>>>>>    drivers/virtio/virtio_mmio.c             |  3 ++-
>>>>>>>>    drivers/virtio/virtio_pci_legacy.c       |  4 +++-
>>>>>>>>    drivers/virtio/virtio_pci_modern.c       |  3 ++-
>>>>>>>>    drivers/virtio/virtio_vdpa.c             |  4 +++-
>>>>>>>>    include/linux/virtio_config.h            |  5 +++--
>>>>>>>>    10 files changed, 43 insertions(+), 19 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/um/drivers/virtio_uml.c
>>>>>>>> b/arch/um/drivers/virtio_uml.c
>>>>>>>> index 91ddf74ca888..b6e66265ed32 100644
>>>>>>>> --- a/arch/um/drivers/virtio_uml.c
>>>>>>>> +++ b/arch/um/drivers/virtio_uml.c
>>>>>>>> @@ -827,11 +827,13 @@ static void
>>>>>>>> vu_set_status(struct virtio_device *vdev, u8 status)
>>>>>>>>        vu_dev->status = status;
>>>>>>>>    }
>>>>>>>>    -static void vu_reset(struct virtio_device *vdev)
>>>>>>>> +static int vu_reset(struct virtio_device *vdev)
>>>>>>>>    {
>>>>>>>>        struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
>>>>>>>>          vu_dev->status = 0;
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>>    }
>>>>>>>>      static void vu_del_vq(struct virtqueue *vq)
>>>>>>>> diff --git
>>>>>>>> a/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>> b/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>> index bbc4e71a16ff..c192b8ac5d9e 100644
>>>>>>>> --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>> +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
>>>>>>>> @@ -980,11 +980,13 @@ static void
>>>>>>>> mlxbf_tmfifo_virtio_set_status(struct virtio_device
>>>>>>>> *vdev,
>>>>>>>>    }
>>>>>>>>      /* Reset the device. Not much here for now. */
>>>>>>>> -static void mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
>>>>>>>> +static int mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
>>>>>>>>    {
>>>>>>>>        struct mlxbf_tmfifo_vdev *tm_vdev =
>>>>>>>> mlxbf_vdev_to_tmfifo(vdev);
>>>>>>>>          tm_vdev->status = 0;
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>>    }
>>>>>>>>      /* Read the value of a configuration field. */
>>>>>>>> diff --git a/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>> b/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>> index 0cc617f76068..ca9573c62c3d 100644
>>>>>>>> --- a/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>> +++ b/drivers/remoteproc/remoteproc_virtio.c
>>>>>>>> @@ -191,7 +191,7 @@ static void
>>>>>>>> rproc_virtio_set_status(struct virtio_device *vdev,
>>>>>>>> u8 status)
>>>>>>>>        dev_dbg(&vdev->dev, "status: %d\n", status);
>>>>>>>>    }
>>>>>>>>    -static void rproc_virtio_reset(struct virtio_device *vdev)
>>>>>>>> +static int rproc_virtio_reset(struct virtio_device *vdev)
>>>>>>>>    {
>>>>>>>>        struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
>>>>>>>>        struct fw_rsc_vdev *rsc;
>>>>>>>> @@ -200,6 +200,8 @@ static void
>>>>>>>> rproc_virtio_reset(struct virtio_device *vdev)
>>>>>>>>          rsc->status = 0;
>>>>>>>>        dev_dbg(&vdev->dev, "reset !\n");
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>>    }
>>>>>>>>      /* provide the vdev features as retrieved from the firmware */
>>>>>>>> diff --git a/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> b/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> index 54e686dca6de..52b32555e746 100644
>>>>>>>> --- a/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> +++ b/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> @@ -732,14 +732,15 @@ static int
>>>>>>>> virtio_ccw_find_vqs(struct virtio_device *vdev,
>>>>>>>> unsigned nvqs,
>>>>>>>>        return ret;
>>>>>>>>    }
>>>>>>>>    -static void virtio_ccw_reset(struct virtio_device *vdev)
>>>>>>>> +static int virtio_ccw_reset(struct virtio_device *vdev)
>>>>>>>>    {
>>>>>>>>        struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>>>>>>>>        struct ccw1 *ccw;
>>>>>>>> +    int ret;
>>>>>>>>          ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
>>>>>>>>        if (!ccw)
>>>>>>>> -        return;
>>>>>>>> +        return -ENOMEM;
>>>>>>>>          /* Zero status bits. */
>>>>>>>>        vcdev->dma_area->status = 0;
>>>>>>>> @@ -749,8 +750,10 @@ static void
>>>>>>>> virtio_ccw_reset(struct virtio_device *vdev)
>>>>>>>>        ccw->flags = 0;
>>>>>>>>        ccw->count = 0;
>>>>>>>>        ccw->cda = 0;
>>>>>>>> -    ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
>>>>>>>> +    ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
>>>>>>>>        ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
>>>>>>>> +
>>>>>>>> +    return ret;
>>>>>>>>    }
>>>>>>>>      static u64 virtio_ccw_get_features(struct virtio_device *vdev)
>>>>>>>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>>>>>>>> index 4b15c00c0a0a..ddbfd5b5f3bd 100644
>>>>>>>> --- a/drivers/virtio/virtio.c
>>>>>>>> +++ b/drivers/virtio/virtio.c
>>>>>>>> @@ -338,7 +338,7 @@ int
>>>>>>>> register_virtio_device(struct virtio_device *dev)
>>>>>>>>        /* Assign a unique device index and hence name. */
>>>>>>>>        err = ida_simple_get(&virtio_index_ida, 0, 0, GFP_KERNEL);
>>>>>>>>        if (err < 0)
>>>>>>>> -        goto out;
>>>>>>>> +        goto out_err;
>>>>>>>>          dev->index = err;
>>>>>>>>        dev_set_name(&dev->dev, "virtio%u", dev->index);
>>>>>>>> @@ -349,7 +349,9 @@ int
>>>>>>>> register_virtio_device(struct virtio_device *dev)
>>>>>>>>          /* We always start by resetting the device,
>>>>>>>> in case a previous
>>>>>>>>         * driver messed it up.  This also tests that
>>>>>>>> code path a little. */
>>>>>>>> -    dev->config->reset(dev);
>>>>>>>> +    err = dev->config->reset(dev);
>>>>>>>> +    if (err)
>>>>>>>> +        goto out_ida;
>>>>>>>>          /* Acknowledge that we've seen the device. */
>>>>>>>>        virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>>>>>>>> @@ -362,10 +364,14 @@ int
>>>>>>>> register_virtio_device(struct virtio_device *dev)
>>>>>>>>         */
>>>>>>>>        err = device_add(&dev->dev);
>>>>>>>>        if (err)
>>>>>>>> -        ida_simple_remove(&virtio_index_ida, dev->index);
>>>>>>>> -out:
>>>>>>>> -    if (err)
>>>>>>>> -        virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>>>>>>>> +        goto out_ida;
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>> +
>>>>>>>> +out_ida:
>>>>>>>> +    ida_simple_remove(&virtio_index_ida, dev->index);
>>>>>>>> +out_err:
>>>>>>>> +    virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>>>>>>>>        return err;
>>>>>>>>    }
>>>>>>>>    EXPORT_SYMBOL_GPL(register_virtio_device);
>>>>>>>> @@ -408,7 +414,9 @@ int virtio_device_restore(struct
>>>>>>>> virtio_device *dev)
>>>>>>>>          /* We always start by resetting the device,
>>>>>>>> in case a previous
>>>>>>>>         * driver messed it up. */
>>>>>>>> -    dev->config->reset(dev);
>>>>>>>> +    ret = dev->config->reset(dev);
>>>>>>>> +    if (ret)
>>>>>>>> +        goto err;
>>>>>>>>          /* Acknowledge that we've seen the device. */
>>>>>>>>        virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>>>>>>>> diff --git a/drivers/virtio/virtio_mmio.c
>>>>>>>> b/drivers/virtio/virtio_mmio.c
>>>>>>>> index 56128b9c46eb..12b8f048c48d 100644
>>>>>>>> --- a/drivers/virtio/virtio_mmio.c
>>>>>>>> +++ b/drivers/virtio/virtio_mmio.c
>>>>>>>> @@ -256,12 +256,13 @@ static void
>>>>>>>> vm_set_status(struct virtio_device *vdev, u8 status)
>>>>>>>>        writel(status, vm_dev->base + VIRTIO_MMIO_STATUS);
>>>>>>>>    }
>>>>>>>>    -static void vm_reset(struct virtio_device *vdev)
>>>>>>>> +static int vm_reset(struct virtio_device *vdev)
>>>>>>>>    {
>>>>>>>>        struct virtio_mmio_device *vm_dev =
>>>>>>>> to_virtio_mmio_device(vdev);
>>>>>>>>          /* 0 status means a reset. */
>>>>>>>>        writel(0, vm_dev->base + VIRTIO_MMIO_STATUS);
>>>>>>>> +    return 0;
>>>>>>>>    }
>>>>>>>>      diff --git a/drivers/virtio/virtio_pci_legacy.c
>>>>>>>> b/drivers/virtio/virtio_pci_legacy.c
>>>>>>>> index d62e9835aeec..0b5d95e3efa1 100644
>>>>>>>> --- a/drivers/virtio/virtio_pci_legacy.c
>>>>>>>> +++ b/drivers/virtio/virtio_pci_legacy.c
>>>>>>>> @@ -89,7 +89,7 @@ static void vp_set_status(struct
>>>>>>>> virtio_device *vdev, u8 status)
>>>>>>>>        iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
>>>>>>>>    }
>>>>>>>>    -static void vp_reset(struct virtio_device *vdev)
>>>>>>>> +static int vp_reset(struct virtio_device *vdev)
>>>>>>>>    {
>>>>>>>>        struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>>>>>>        /* 0 status means a reset. */
>>>>>>>> @@ -99,6 +99,8 @@ static void vp_reset(struct virtio_device *vdev)
>>>>>>>>        ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
>>>>>>>>        /* Flush pending VQ/configuration callbacks. */
>>>>>>>>        vp_synchronize_vectors(vdev);
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>>    }
>>>>>>>>      static u16 vp_config_vector(struct
>>>>>>>> virtio_pci_device *vp_dev, u16 vector)
>>>>>>>> diff --git a/drivers/virtio/virtio_pci_modern.c
>>>>>>>> b/drivers/virtio/virtio_pci_modern.c
>>>>>>>> index fbd4ebc00eb6..cc3412a96a17 100644
>>>>>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>>>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>>>>>> @@ -158,7 +158,7 @@ static void vp_set_status(struct
>>>>>>>> virtio_device *vdev, u8 status)
>>>>>>>>        vp_modern_set_status(&vp_dev->mdev, status);
>>>>>>>>    }
>>>>>>>>    -static void vp_reset(struct virtio_device *vdev)
>>>>>>>> +static int vp_reset(struct virtio_device *vdev)
>>>>>>>>    {
>>>>>>>>        struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>>>>>>        struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>>>>>>> @@ -174,6 +174,7 @@ static void vp_reset(struct virtio_device *vdev)
>>>>>>>>            msleep(1);
>>>>>>>>        /* Flush pending VQ/configuration callbacks. */
>>>>>>>>        vp_synchronize_vectors(vdev);
>>>>>>>> +    return 0;
>>>>>>>>    }
>>>>>>>>      static u16 vp_config_vector(struct
>>>>>>>> virtio_pci_device *vp_dev, u16 vector)
>>>>>>>> diff --git a/drivers/virtio/virtio_vdpa.c
>>>>>>>> b/drivers/virtio/virtio_vdpa.c
>>>>>>>> index e28acf482e0c..5fd4e627a9b0 100644
>>>>>>>> --- a/drivers/virtio/virtio_vdpa.c
>>>>>>>> +++ b/drivers/virtio/virtio_vdpa.c
>>>>>>>> @@ -97,11 +97,13 @@ static void
>>>>>>>> virtio_vdpa_set_status(struct virtio_device *vdev,
>>>>>>>> u8 status)
>>>>>>>>        return ops->set_status(vdpa, status);
>>>>>>>>    }
>>>>>>>>    -static void virtio_vdpa_reset(struct virtio_device *vdev)
>>>>>>>> +static int virtio_vdpa_reset(struct virtio_device *vdev)
>>>>>>>>    {
>>>>>>>>        struct vdpa_device *vdpa = vd_get_vdpa(vdev);
>>>>>>>>          vdpa_reset(vdpa);
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>>    }
>>>>>>>>      static bool virtio_vdpa_notify(struct virtqueue *vq)
>>>>>>>> diff --git a/include/linux/virtio_config.h
>>>>>>>> b/include/linux/virtio_config.h
>>>>>>>> index 8519b3ae5d52..d2b0f1699a75 100644
>>>>>>>> --- a/include/linux/virtio_config.h
>>>>>>>> +++ b/include/linux/virtio_config.h
>>>>>>>> @@ -44,9 +44,10 @@ struct virtio_shm_region {
>>>>>>>>     *    status: the new status byte
>>>>>>>>     * @reset: reset the device
>>>>>>>>     *    vdev: the virtio device
>>>>>>>> - *    After this, status and feature negotiation must be done again
>>>>>>>> + *    Upon success, status and feature negotiation
>>>>>>>> must be done again
>>>>>>>>     *    Device must not be reset from its vq/config callbacks, or in
>>>>>>>>     *    parallel with being added/removed.
>>>>>>>> + *    Returns 0 on success or error status.
>>>>>>>>     * @find_vqs: find virtqueues and instantiate them.
>>>>>>>>     *    vdev: the virtio_device
>>>>>>>>     *    nvqs: the number of virtqueues to find
>>>>>>>> @@ -82,7 +83,7 @@ struct virtio_config_ops {
>>>>>>>>        u32 (*generation)(struct virtio_device *vdev);
>>>>>>>>        u8 (*get_status)(struct virtio_device *vdev);
>>>>>>>>        void (*set_status)(struct virtio_device *vdev, u8 status);
>>>>>>>> -    void (*reset)(struct virtio_device *vdev);
>>>>>>>> +    int (*reset)(struct virtio_device *vdev);
>>>>>>>>        int (*find_vqs)(struct virtio_device *, unsigned nvqs,
>>>>>>>>                struct virtqueue *vqs[], vq_callback_t *callbacks[],
>>>>>>>>                const char * const names[], const bool *ctx,
