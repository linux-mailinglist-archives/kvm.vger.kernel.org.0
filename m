Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919891C7822
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 19:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgEFRj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 13:39:59 -0400
Received: from foss.arm.com ([217.140.110.172]:42190 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728047AbgEFRj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 13:39:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15A0A1FB;
        Wed,  6 May 2020 10:39:58 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3364E3F71F;
        Wed,  6 May 2020 10:39:57 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 19/32] ioport: mmio: Use a mutex and reference
 counting for locking
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-20-alexandru.elisei@arm.com>
 <fcc54fdb-3d7d-3a4c-5c99-120bc156d48f@arm.com>
 <e28d41e5-a13b-a3bc-2963-3518dc610dbe@arm.com>
Message-ID: <7fc883dc-8144-d51f-9289-04d45829695b@arm.com>
Date:   Wed, 6 May 2020 18:40:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e28d41e5-a13b-a3bc-2963-3518dc610dbe@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/1/20 4:30 PM, Alexandru Elisei wrote:
> Hi,
>
> On 3/31/20 12:51 PM, André Przywara wrote:
>> On 26/03/2020 15:24, Alexandru Elisei wrote:
>>
>> Hi,
>>
>>> kvmtool uses brlock for protecting accesses to the ioport and mmio
>>> red-black trees. brlock allows concurrent reads, but only one writer, which
>>> is assumed not to be a VCPU thread (for more information see commit
>>> 0b907ed2eaec ("kvm tools: Add a brlock)). This is done by issuing a
>>> compiler barrier on read and pausing the entire virtual machine on writes.
>>> When KVM_BRLOCK_DEBUG is defined, brlock uses instead a pthread read/write
>>> lock.
>>>
>>> When we will implement reassignable BARs, the mmio or ioport mapping will
>>> be done as a result of a VCPU mmio access. When brlock is a pthread
>>> read/write lock, it means that we will try to acquire a write lock with the
>>> read lock already held by the same VCPU and we will deadlock. When it's
>>> not, a VCPU will have to call kvm__pause, which means the virtual machine
>>> will stay paused forever.
>>>
>>> Let's avoid all this by using a mutex and reference counting the red-black
>>> tree entries. This way we can guarantee that we won't unregister a node
>>> that another thread is currently using for emulation.
>>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>  include/kvm/ioport.h          |  2 +
>>>  include/kvm/rbtree-interval.h |  4 +-
>>>  ioport.c                      | 64 +++++++++++++++++-------
>>>  mmio.c                        | 91 +++++++++++++++++++++++++----------
>>>  4 files changed, 118 insertions(+), 43 deletions(-)
>>>
>>> diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
>>> index 62a719327e3f..039633f76bdd 100644
>>> --- a/include/kvm/ioport.h
>>> +++ b/include/kvm/ioport.h
>>> @@ -22,6 +22,8 @@ struct ioport {
>>>  	struct ioport_operations	*ops;
>>>  	void				*priv;
>>>  	struct device_header		dev_hdr;
>>> +	u32				refcount;
>>> +	bool				remove;
>> The use of this extra "remove" variable seems somehow odd. I think
>> normally you would initialise the refcount to 1, and let the unregister
>> operation do a put as well, with the removal code triggered if the count
>> reaches zero. At least this is what kref does, can we do the same here?
>> Or is there anything that would prevent it? I think it's a good idea to
>> stick to existing design patterns for things like refcounts.
>>
>> Cheers,
>> Andre.
>>
> You're totally right, it didn't cross my mind to initialize refcount to 1, it's a
> great idea, I'll do it like that.

I take that back, I've tested your proposal and it's not working. Let's consider
the scenario with 3 threads where the a mmio node is created with a refcount of 1,
as you suggested (please excuse any bad formatting):

     1             |        2           |        3

1. mmio_get()      |                    |

2. refcount++(== 2)|                    |

                   | 1. deactivate BAR  |

                   | 2. BAR active      |

                   |                    | 1. deactivate BAR

                   |                    | 2. BAR active

                   |                    | 3. refcount--(==1)

                   | 3. refcount--(==0) |

                   | 4. remove mmio node|

3. mmio->mmio_fn() |                    |

When Thread 1 calls mmio->mmio_fn(), the mmio node has been free'd. My original
version works because the only place where I decrement refcount is after the call
to mmio_fn. I really don't want to use locking when calling pci_deactivate_bar. Do
you have any ideas?

Thanks,
Alex
