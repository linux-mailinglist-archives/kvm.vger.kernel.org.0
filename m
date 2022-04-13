Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58E94FF372
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 11:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbiDMJ2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 05:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiDMJ2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 05:28:05 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA7525C5E;
        Wed, 13 Apr 2022 02:25:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yaohongbo@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V9z3Zrl_1649841940;
Received: from 30.225.28.93(mailfrom:yaohongbo@linux.alibaba.com fp:SMTPD_---0V9z3Zrl_1649841940)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Apr 2022 17:25:41 +0800
Message-ID: <ebd1b238-6e48-6561-93ab-f562096b1c05@linux.alibaba.com>
Date:   Wed, 13 Apr 2022 17:25:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v2] uio/uio_pci_generic: Introduce refcnt on open/release
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     alikernel-developer@linux.alibaba.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1649833302-27299-1-git-send-email-yaohongbo@linux.alibaba.com>
 <YlZ8vZ9RX5i7mWNk@kroah.com> <20220413044246-mutt-send-email-mst@kernel.org>
From:   Yao Hongbo <yaohongbo@linux.alibaba.com>
In-Reply-To: <20220413044246-mutt-send-email-mst@kernel.org>
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


在 2022/4/13 下午4:51, Michael S. Tsirkin 写道:
> On Wed, Apr 13, 2022 at 09:33:17AM +0200, Greg KH wrote:
>> On Wed, Apr 13, 2022 at 03:01:42PM +0800, Yao Hongbo wrote:
>>> If two userspace programs both open the PCI UIO fd, when one
>>> of the program exits uncleanly, the other will cause IO hang
>>> due to bus-mastering disabled.
>>>
>>> It's a common usage for spdk/dpdk to use UIO. So, introduce refcnt
>>> to avoid such problems.
>> Why do you have multiple userspace programs opening the same device?
>> Shouldn't they coordinate?
> Or to restate, I think the question is, why not open the device
> once and pass the FD around?

Hmm, it will have the same result, no matter  whether opening the same 
device or pass the FD around.

Our expectation is that even if the primary process exits abnormally,  
the second process can still send

or receive data.

The impact of disabling pci bus-master is relatively large, and we 
should make some restrictions on

this behavior.

>
>>> Fixes: 865a11f987ab("uio/uio_pci_generic: Disable bus-mastering on release")
>
> space missing before ( here .
>
>>> Reported-by: Xiu Yang <yangxiu.yx@alibaba-inc.com>
>>> Signed-off-by: Yao Hongbo <yaohongbo@linux.alibaba.com>
>>> ---
>>> Changes for v2:
>>> 	Use refcount_t instead of atomic_t to catch overflow/underflows.
>>> ---
>>>   drivers/uio/uio_pci_generic.c | 16 +++++++++++++++-
>>>   1 file changed, 15 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
>>> index e03f9b5..1a5e1fd 100644
>>> --- a/drivers/uio/uio_pci_generic.c
>>> +++ b/drivers/uio/uio_pci_generic.c
>>> @@ -31,6 +31,7 @@
>>>   struct uio_pci_generic_dev {
>>>   	struct uio_info info;
>>>   	struct pci_dev *pdev;
>>> +	refcount_t refcnt;
>>>   };
>>>   
>>>   static inline struct uio_pci_generic_dev *
>>> @@ -39,6 +40,14 @@ struct uio_pci_generic_dev {
>>>   	return container_of(info, struct uio_pci_generic_dev, info);
>>>   }
>>>   
>>> +static int open(struct uio_info *info, struct inode *inode)
>>> +{
>>> +	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
>>> +
>>> +	refcount_inc(&gdev->refcnt);
>>> +	return 0;
>>> +}
>>> +
>>>   static int release(struct uio_info *info, struct inode *inode)
>>>   {
>>>   	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
>>> @@ -51,7 +60,9 @@ static int release(struct uio_info *info, struct inode *inode)
>>>   	 * Note that there's a non-zero chance doing this will wedge the device
>>>   	 * at least until reset.
>>>   	 */
>>> -	pci_clear_master(gdev->pdev);
>>> +	if (refcount_dec_and_test(&gdev->refcnt))
>>> +		pci_clear_master(gdev->pdev);
>> The goal here is to flush things when userspace closes the device, as
>> the comment says.  So don't you want that to happen for when userspace
>> closes the file handle no matter who opened it?
>>
>> As this is a functional change, how is userspace going to "know" this
>> functionality is now changed or not?
>>
>> And if userspace really wants to open this multiple times, then properly
>> switch the code to only create the device-specific structures when open
>> is called.  Otherwise you are sharing structures here that are not
>> intended to be shared, shouldn't you have your own private one?
>>
>> this feels odd.
>>
>> thanks,
>>
>> greg k-h
> Sigh. Maybe it was a mistake to do 865a11f987ab to begin with.
> Anyone doing DMA with UIO is already on very thin ice.
> But oh well.
>
