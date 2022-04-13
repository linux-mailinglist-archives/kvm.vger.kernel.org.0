Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AFD4FF576
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 13:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbiDMLM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 07:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbiDMLMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 07:12:24 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFD122299;
        Wed, 13 Apr 2022 04:10:02 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yaohongbo@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V9zdJNn_1649848198;
Received: from 30.225.28.93(mailfrom:yaohongbo@linux.alibaba.com fp:SMTPD_---0V9zdJNn_1649848198)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Apr 2022 19:09:59 +0800
Message-ID: <5a80c065-e811-018e-6c35-01c12b194c94@linux.alibaba.com>
Date:   Wed, 13 Apr 2022 19:09:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v2] uio/uio_pci_generic: Introduce refcnt on open/release
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        alikernel-developer@linux.alibaba.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1649833302-27299-1-git-send-email-yaohongbo@linux.alibaba.com>
 <YlZ8vZ9RX5i7mWNk@kroah.com> <20220413044246-mutt-send-email-mst@kernel.org>
 <ebd1b238-6e48-6561-93ab-f562096b1c05@linux.alibaba.com>
 <YlabT7+Hqc3h62AT@kroah.com>
From:   Yao Hongbo <yaohongbo@linux.alibaba.com>
In-Reply-To: <YlabT7+Hqc3h62AT@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/4/13 下午5:43, Greg KH 写道:
> On Wed, Apr 13, 2022 at 05:25:40PM +0800, Yao Hongbo wrote:
>> 在 2022/4/13 下午4:51, Michael S. Tsirkin 写道:
>>> On Wed, Apr 13, 2022 at 09:33:17AM +0200, Greg KH wrote:
>>>> On Wed, Apr 13, 2022 at 03:01:42PM +0800, Yao Hongbo wrote:
>>>>> If two userspace programs both open the PCI UIO fd, when one
>>>>> of the program exits uncleanly, the other will cause IO hang
>>>>> due to bus-mastering disabled.
>>>>>
>>>>> It's a common usage for spdk/dpdk to use UIO. So, introduce refcnt
>>>>> to avoid such problems.
>>>> Why do you have multiple userspace programs opening the same device?
>>>> Shouldn't they coordinate?
>>> Or to restate, I think the question is, why not open the device
>>> once and pass the FD around?
>> Hmm, it will have the same result, no matter  whether opening the same
>> device or pass the FD around.
> How?  You only open once, and close once.  Where is the multiple closes?
>
>> Our expectation is that even if the primary process exits abnormally,  the
>> second process can still send
>>
>> or receive data.
> Then use the same file descriptor.


Yes, we can use the same file descriptor.

but since the pcie bus-master  has been disabled by the primary process,

the seconday process cannot continue to operate.

>
>> The impact of disabling pci bus-master is relatively large, and we should
>> make some restrictions on
>> this behavior.
> Why?  UIO is "you better really really know what you are doing to use
> this interface", right?  Just duplicate the fd and pass it around if you
> must have multiple accesses to the same device.
>
> And again, this will be a functional change.  How can you handle your
> userspace on older kernels if you make this change?

Without this change, our userspace cannot work properly on older kernels.


Our userspace only use the "multi process mode" feature of the spdk.

The SPDK links:
https://spdk.io/doc/app_overview.html

"Multi process mode
When --shm-id is specified, the application is started in multi-process 
mode.

Applications using the same shm-id share their memory and NVMe devices.

The first app to start with a given id becomes a primary process, with 
the rest,

called secondary processes, only attaching to it. When the primary 
process exits,

the secondary ones continue to operate, but no new processes can be 
attached

at this point. All processes within the same shm-id group must use the 
same --single-file-segments setting."

> thanks,
>
> greg k-h
