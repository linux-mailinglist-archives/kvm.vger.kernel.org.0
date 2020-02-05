Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880311529F2
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 12:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgBELdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 06:33:47 -0500
Received: from foss.arm.com ([217.140.110.172]:46000 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728282AbgBELdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 06:33:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A19A11FB;
        Wed,  5 Feb 2020 03:25:05 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B83E93F52E;
        Wed,  5 Feb 2020 03:25:04 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 19/30] Use independent read/write locks for
 ioport and mmio
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-20-alexandru.elisei@arm.com>
 <20200203122338.6565e96a@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <fb3cd270-4bb5-b26e-2f3f-c01b8ae05931@arm.com>
Date:   Wed, 5 Feb 2020 11:25:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203122338.6565e96a@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/3/20 12:23 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:47:54 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> kvmtool uses brlock for protecting accesses to the ioport and mmio
>> red-black trees. brlock allows concurrent reads, but only one writer,
>> which is assumed not to be a VCPU thread. This is done by issuing a
>> compiler barrier on read and pausing the entire virtual machine on
>> writes. When KVM_BRLOCK_DEBUG is defined, brlock uses instead a pthread
>> read/write lock.
>>
>> When we will implement reassignable BARs, the mmio or ioport mapping
>> will be done as a result of a VCPU mmio access. When brlock is a
>> read/write lock, it means that we will try to acquire a write lock with
>> the read lock already held by the same VCPU and we will deadlock. When
>> it's not, a VCPU will have to call kvm__pause, which means the virtual
>> machine will stay paused forever.
>>
>> Let's avoid all this by using separate pthread_rwlock_t locks for the
>> mmio and the ioport red-black trees and carefully choosing our read
>> critical region such that modification as a result of a guest mmio
>> access doesn't deadlock.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  ioport.c | 20 +++++++++++---------
>>  mmio.c   | 26 +++++++++++++++++---------
>>  2 files changed, 28 insertions(+), 18 deletions(-)
>>
>> diff --git a/ioport.c b/ioport.c
>> index d224819c6e43..c044a80dd763 100644
>> --- a/ioport.c
>> +++ b/ioport.c
>> @@ -2,9 +2,9 @@
>>  
>>  #include "kvm/kvm.h"
>>  #include "kvm/util.h"
>> -#include "kvm/brlock.h"
>>  #include "kvm/rbtree-interval.h"
>>  #include "kvm/mutex.h"
>> +#include "kvm/rwsem.h"
>>  
>>  #include <linux/kvm.h>	/* for KVM_EXIT_* */
>>  #include <linux/types.h>
>> @@ -16,6 +16,8 @@
>>  
>>  #define ioport_node(n) rb_entry(n, struct ioport, node)
>>  
>> +static DECLARE_RWSEM(ioport_lock);
>> +
>>  static struct rb_root		ioport_tree = RB_ROOT;
>>  
>>  static struct ioport *ioport_search(struct rb_root *root, u64 addr)
>> @@ -68,7 +70,7 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
>>  	struct ioport *entry;
>>  	int r;
>>  
>> -	br_write_lock(kvm);
>> +	down_write(&ioport_lock);
>>  
>>  	entry = ioport_search(&ioport_tree, port);
>>  	if (entry) {
>> @@ -96,7 +98,7 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
>>  	r = device__register(&entry->dev_hdr);
>>  	if (r < 0)
>>  		goto out_erase;
>> -	br_write_unlock(kvm);
>> +	up_write(&ioport_lock);
>>  
>>  	return port;
>>  
>> @@ -104,7 +106,7 @@ out_erase:
>>  	rb_int_erase(&ioport_tree, &entry->node);
>>  out_free:
>>  	free(entry);
>> -	br_write_unlock(kvm);
>> +	up_write(&ioport_lock);
>>  	return r;
>>  }
>>  
>> @@ -113,7 +115,7 @@ int ioport__unregister(struct kvm *kvm, u16 port)
>>  	struct ioport *entry;
>>  	int r;
>>  
>> -	br_write_lock(kvm);
>> +	down_write(&ioport_lock);
>>  
>>  	r = -ENOENT;
>>  	entry = ioport_search(&ioport_tree, port);
>> @@ -128,7 +130,7 @@ int ioport__unregister(struct kvm *kvm, u16 port)
>>  	r = 0;
>>  
>>  done:
>> -	br_write_unlock(kvm);
>> +	up_write(&ioport_lock);
>>  
>>  	return r;
>>  }
>> @@ -171,8 +173,10 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
>>  	void *ptr = data;
>>  	struct kvm *kvm = vcpu->kvm;
>>  
>> -	br_read_lock(kvm);
>> +	down_read(&ioport_lock);
>>  	entry = ioport_search(&ioport_tree, port);
>> +	up_read(&ioport_lock);
>> +
>>  	if (!entry)
>>  		goto out;
> I don't think it's valid to drop the lock that early. A concurrent ioport_unregister would free the entry pointer, so we have a potential use-after-free here.
> I guess you are thinking about an x86 CF8/CFC config space access here, that in turn would take the write lock when updating an I/O BAR?
>
> So I think the same comment that you added below on kvm__emulate_mmio() applies here? More on this below then ....

Yes, it applies. More on this below.

>
>>  
>> @@ -188,8 +192,6 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
>>  	}
>>  
>>  out:
>> -	br_read_unlock(kvm);
>> -
>>  	if (ret)
>>  		return true;
>>  
>> diff --git a/mmio.c b/mmio.c
>> index 61e1d47a587d..4e0ff830c738 100644
>> --- a/mmio.c
>> +++ b/mmio.c
>> @@ -1,7 +1,7 @@
>>  #include "kvm/kvm.h"
>>  #include "kvm/kvm-cpu.h"
>>  #include "kvm/rbtree-interval.h"
>> -#include "kvm/brlock.h"
>> +#include "kvm/rwsem.h"
>>  
>>  #include <stdio.h>
>>  #include <stdlib.h>
>> @@ -15,6 +15,8 @@
>>  
>>  #define mmio_node(n) rb_entry(n, struct mmio_mapping, node)
>>  
>> +static DECLARE_RWSEM(mmio_lock);
>> +
>>  struct mmio_mapping {
>>  	struct rb_int_node	node;
>>  	void			(*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr);
>> @@ -61,7 +63,7 @@ static const char *to_direction(u8 is_write)
>>  
>>  int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool coalesce,
>>  		       void (*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr),
>> -			void *ptr)
>> +		       void *ptr)
>>  {
>>  	struct mmio_mapping *mmio;
>>  	struct kvm_coalesced_mmio_zone zone;
>> @@ -88,9 +90,9 @@ int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool c
>>  			return -errno;
>>  		}
>>  	}
>> -	br_write_lock(kvm);
>> +	down_write(&mmio_lock);
>>  	ret = mmio_insert(&mmio_tree, mmio);
>> -	br_write_unlock(kvm);
>> +	up_write(&mmio_lock);
>>  
>>  	return ret;
>>  }
>> @@ -100,10 +102,10 @@ bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
>>  	struct mmio_mapping *mmio;
>>  	struct kvm_coalesced_mmio_zone zone;
>>  
>> -	br_write_lock(kvm);
>> +	down_write(&mmio_lock);
>>  	mmio = mmio_search_single(&mmio_tree, phys_addr);
>>  	if (mmio == NULL) {
>> -		br_write_unlock(kvm);
>> +		up_write(&mmio_lock);
>>  		return false;
>>  	}
>>  
>> @@ -114,7 +116,7 @@ bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
>>  	ioctl(kvm->vm_fd, KVM_UNREGISTER_COALESCED_MMIO, &zone);
>>  
>>  	rb_int_erase(&mmio_tree, &mmio->node);
>> -	br_write_unlock(kvm);
>> +	up_write(&mmio_lock);
>>  
>>  	free(mmio);
>>  	return true;
>> @@ -124,8 +126,15 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u
>>  {
>>  	struct mmio_mapping *mmio;
>>  
>> -	br_read_lock(vcpu->kvm);
>> +	/*
>> +	 * The callback might call kvm__register_mmio which takes a write lock,
>> +	 * so avoid deadlocks by protecting only the node search with a reader
>> +	 * lock. Note that there is still a small time window for a node to be
>> +	 * deleted by another vcpu before mmio_fn gets called.
>> +	 */
> Do I get this right that this means the locking is not "fully" correct?
> I don't think we should tolerate this. The underlying problem seems to be that the lock protects two separate things: namely the RB tree to find the handler, but also the handlers and their data structures itself. So far this was feasible, but this doesn't work any longer.
>
> I think refcounting would be the answer here: Once mmio_search() returns an entry, a ref counter increases, preventing this entry from being removed by kvm__deregister_mmio(). If the emulation has finished, we decrement the counter, and trigger the free operation if it has reached zero.
>
> Does that make sense?

The only situation you end up with use-after-free if there's a race inside the
guest between one thread which reprograms the BAR address/disables access to
memory BARs, and another thread thread which tries to access the memory region
described by the BAR. My reasoning for putting the comment there instead of fixing
the race was that the guest is broken in this case and it won't function correctly
regardless of what kvmtool does. And having this use-after-free error in kvmtool
might actually benefit debugging the guest.

Adding a refcounter to prevent that from happening should be fairly straightforward.

Thanks,
Alex
>
> Cheers,
> Andre.
>
>> +	down_read(&mmio_lock);
>>  	mmio = mmio_search(&mmio_tree, phys_addr, len);
>> +	up_read(&mmio_lock);
>>  
>>  	if (mmio)
>>  		mmio->mmio_fn(vcpu, phys_addr, data, len, is_write, mmio->ptr);
>> @@ -135,7 +144,6 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u
>>  				to_direction(is_write),
>>  				(unsigned long long)phys_addr, len);
>>  	}
>> -	br_read_unlock(vcpu->kvm);
>>  
>>  	return true;
>>  }
