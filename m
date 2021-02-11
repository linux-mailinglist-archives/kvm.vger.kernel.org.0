Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656F9318FA2
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 17:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhBKQNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 11:13:23 -0500
Received: from foss.arm.com ([217.140.110.172]:54112 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhBKQLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 11:11:15 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DED01063;
        Thu, 11 Feb 2021 08:10:16 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 90D393F73D;
        Thu, 11 Feb 2021 08:10:15 -0800 (PST)
Subject: Re: [PATCH kvmtool 04/21] mmio: Extend handling to include ioport
 emulation
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-5-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a97cc31b-73b0-7c48-79bb-fc14f7ec0aa1@arm.com>
Date:   Thu, 11 Feb 2021 16:10:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-5-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 12/10/20 2:28 PM, Andre Przywara wrote:
> In their core functionality MMIO and I/O port traps are not really
> different, yet we still have two totally separate code paths for
> handling them. Devices need to decide on one conduit or need to provide
> different handler functions for each of them.
>
> Extend the existing MMIO emulation to also cover ioport handlers.
> This just adds another RB tree root for holding the I/O port handlers,
> but otherwise uses the same tree population and lookup code.

Maybe I'm missing something, but why two trees? Is it valid to have an overlap
between IO port and MMIO emulation? Or was it done to make the removal of ioport
emulation easier?

If it's not valid to have that overlap, then I think having one tree for both
would better. Struct mmio_mapping would have to be augmented with a flags field
that holds the same flags given to kvm__register_iotrap to differentiate between
the two slightly different emulations. Saving the IOTRAP_COALESCE flag would also
make it trivial to call KVM_UNREGISTER_COALESCED_MMIO in kvm__deregister_iotrap,
which we currently don't do.

> "ioport" or "mmio" just become a flag in the registration function.
> Provide wrappers to not break existing users, and allow an easy
> transition for the existing ioport handlers.
>
> This also means that ioport handlers now can use the same emulation
> callback prototype as MMIO handlers, which means we have to migrate them
> over. To allow a smooth transition, we hook up the new I/O emulate
> function to the end of the existing ioport emulation code.

I'm sorry, but I don't understand that last sentence. Do you mean that the ioport
emulation code has been modified to use kvm__emulate_pio() as a fallback for when
the port is not found in the ioport_tree?

>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/kvm.h | 42 +++++++++++++++++++++++++++++----
>  ioport.c          |  4 ++--
>  mmio.c            | 59 +++++++++++++++++++++++++++++++++++++++--------
>  3 files changed, 89 insertions(+), 16 deletions(-)
>
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index ee99c28e..14f9d58b 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -27,10 +27,16 @@
>  #define PAGE_SIZE (sysconf(_SC_PAGE_SIZE))
>  #endif
>  
> +#define IOTRAP_BUS_MASK		0xf

It's not immediately obvious what this mask does. It turns out it's used to mask
the enum flags defined in the header devices.h, header which is not included in
this file.

The flag names we pass to kvm__register_iotrap() are slightly inconsistent
(DEVICE_BUS_PCI, DEVICE_BUS_MMIO and IOTRAP_COALESCE), where DEVICE_BUS_{PCI,
MMIO} come from devices.h as an enum. I was wondering if I'm missing something and
there is a particular reason why we don't define our own flags for that here
(something like IOTRAP_PIO and IOTRAP_MMIO).

If we do decide to keep the flags from devices.h, I think it would be worth it to
have a compile time check (with BUILD_BUG_ON) that IOTRAP_BUS_MASK is >=
DEVICES_BUS_MAX, which would also be a good indication of where those flags are
coming from.

> +#define IOTRAP_COALESCE		(1U << 4)
> +
>  #define DEFINE_KVM_EXT(ext)		\
>  	.name = #ext,			\
>  	.code = ext
>  
> +struct kvm_cpu;
> +typedef void (*mmio_handler_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data,
> +				u32 len, u8 is_write, void *ptr);
>  typedef void (*fdt_irq_fn)(void *fdt, u8 irq, enum irq_type);
>  
>  enum {
> @@ -113,6 +119,8 @@ void kvm__irq_line(struct kvm *kvm, int irq, int level);
>  void kvm__irq_trigger(struct kvm *kvm, int irq);
>  bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction, int size, u32 count);
>  bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
> +bool kvm__emulate_pio(struct kvm_cpu *vcpu, u16 port, void *data,
> +		      int direction, int size, u32 count);
>  int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr);
>  int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
>  		      enum kvm_mem_type type);
> @@ -136,10 +144,36 @@ static inline int kvm__reserve_mem(struct kvm *kvm, u64 guest_phys, u64 size)
>  				 KVM_MEM_TYPE_RESERVED);
>  }
>  
> -int __must_check kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool coalesce,
> -				    void (*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr),
> -				    void *ptr);
> -bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr);
> +int __must_check kvm__register_iotrap(struct kvm *kvm, u64 phys_addr, u64 len,
> +				      mmio_handler_fn mmio_fn, void *ptr,
> +				      unsigned int flags);
> +
> +static inline
> +int __must_check kvm__register_mmio(struct kvm *kvm, u64 phys_addr,
> +				    u64 phys_addr_len, bool coalesce,
> +				    mmio_handler_fn mmio_fn, void *ptr)
> +{
> +	return kvm__register_iotrap(kvm, phys_addr, phys_addr_len, mmio_fn, ptr,
> +			DEVICE_BUS_MMIO | (coalesce ? IOTRAP_COALESCE : 0));
> +}
> +static inline
> +int __must_check kvm__register_pio(struct kvm *kvm, u16 port, u16 len,
> +				   mmio_handler_fn mmio_fn, void *ptr)
> +{
> +	return kvm__register_iotrap(kvm, port, len, mmio_fn, ptr,
> +				    DEVICE_BUS_IOPORT);
> +}
> +
> +bool kvm__deregister_iotrap(struct kvm *kvm, u64 phys_addr, unsigned int flags);
> +static inline bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
> +{
> +	return kvm__deregister_iotrap(kvm, phys_addr, DEVICE_BUS_MMIO);
> +}
> +static inline bool kvm__deregister_pio(struct kvm *kvm, u16 port)
> +{
> +	return kvm__deregister_iotrap(kvm, port, DEVICE_BUS_IOPORT);
> +}
> +
>  void kvm__reboot(struct kvm *kvm);
>  void kvm__pause(struct kvm *kvm);
>  void kvm__continue(struct kvm *kvm);
> diff --git a/ioport.c b/ioport.c
> index b98836d3..204d8103 100644
> --- a/ioport.c
> +++ b/ioport.c
> @@ -147,7 +147,8 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
>  
>  	entry = ioport_get(&ioport_tree, port);
>  	if (!entry)
> -		goto out;
> +		return kvm__emulate_pio(vcpu, port, data, direction,
> +					size, count);

I have to admit this gave me pause because this patch doesn't add any users for
kvm__register_pio() (although with this change the behaviour of kvm__emulate_io()
remains exactly the same). Do you think this change would fit better in patch #7,
where the first user for kvm__register_pio() is added, or do you prefer it here?

>  
>  	ops	= entry->ops;
>  
> @@ -162,7 +163,6 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
>  
>  	ioport_put(&ioport_tree, entry);
>  
> -out:
>  	if (ret)
>  		return true;
>  
> diff --git a/mmio.c b/mmio.c
> index cd141cd3..4cce1901 100644
> --- a/mmio.c
> +++ b/mmio.c
> @@ -19,13 +19,14 @@ static DEFINE_MUTEX(mmio_lock);
>  
>  struct mmio_mapping {
>  	struct rb_int_node	node;
> -	void			(*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr);
> +	mmio_handler_fn		mmio_fn;
>  	void			*ptr;
>  	u32			refcount;
>  	bool			remove;
>  };
>  
>  static struct rb_root mmio_tree = RB_ROOT;
> +static struct rb_root pio_tree = RB_ROOT;
>  
>  static struct mmio_mapping *mmio_search(struct rb_root *root, u64 addr, u64 len)
>  {
> @@ -103,9 +104,9 @@ static void mmio_put(struct kvm *kvm, struct rb_root *root, struct mmio_mapping
>  	mutex_unlock(&mmio_lock);
>  }
>  
> -int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool coalesce,
> -		       void (*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr),
> -			void *ptr)
> +int kvm__register_iotrap(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len,
> +			 mmio_handler_fn mmio_fn, void *ptr,
> +			 unsigned int flags)
>  {
>  	struct mmio_mapping *mmio;
>  	struct kvm_coalesced_mmio_zone zone;
> @@ -127,7 +128,7 @@ int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool c
>  		.remove		= false,
>  	};
>  
> -	if (coalesce) {
> +	if (flags & IOTRAP_COALESCE) {

There is no such flag being used in ioport.c, is it valid to have the flags
DEVICE_BUS_IOPORT and IOTRAP_COALESCE set at the same time?

>  		zone = (struct kvm_coalesced_mmio_zone) {
>  			.addr	= phys_addr,
>  			.size	= phys_addr_len,
> @@ -139,18 +140,27 @@ int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool c
>  		}
>  	}
>  	mutex_lock(&mmio_lock);
> -	ret = mmio_insert(&mmio_tree, mmio);
> +	if ((flags & IOTRAP_BUS_MASK) == DEVICE_BUS_IOPORT)
> +		ret = mmio_insert(&pio_tree, mmio);
> +	else
> +		ret = mmio_insert(&mmio_tree, mmio);
>  	mutex_unlock(&mmio_lock);
>  
>  	return ret;
>  }
>  
> -bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
> +bool kvm__deregister_iotrap(struct kvm *kvm, u64 phys_addr, unsigned int flags)
>  {
>  	struct mmio_mapping *mmio;
> +	struct rb_root *tree;
> +
> +	if ((flags & IOTRAP_BUS_MASK) == DEVICE_BUS_IOPORT)
> +		tree = &pio_tree;
> +	else
> +		tree = &mmio_tree;
>  
>  	mutex_lock(&mmio_lock);
> -	mmio = mmio_search_single(&mmio_tree, phys_addr);
> +	mmio = mmio_search_single(tree, phys_addr);
>  	if (mmio == NULL) {
>  		mutex_unlock(&mmio_lock);
>  		return false;
> @@ -167,7 +177,7 @@ bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
>  	 * called mmio_put(). This will trigger use-after-free errors on VCPU0.
>  	 */
>  	if (mmio->refcount == 0)
> -		mmio_deregister(kvm, &mmio_tree, mmio);
> +		mmio_deregister(kvm, tree, mmio);
>  	else
>  		mmio->remove = true;
>  	mutex_unlock(&mmio_lock);
> @@ -175,7 +185,8 @@ bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
>  	return true;
>  }
>  
> -bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write)
> +bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data,
> +		       u32 len, u8 is_write)

I don't think style changes should be part of this patch, the patch is large
enough as it is.

Thanks,

Alex

>  {
>  	struct mmio_mapping *mmio;
>  
> @@ -194,3 +205,31 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u
>  out:
>  	return true;
>  }
> +
> +bool kvm__emulate_pio(struct kvm_cpu *vcpu, u16 port, void *data,
> +		     int direction, int size, u32 count)
> +{
> +	struct mmio_mapping *mmio;
> +	bool is_write = direction == KVM_EXIT_IO_OUT;
> +
> +	mmio = mmio_get(&pio_tree, port, size);
> +	if (!mmio) {
> +		if (vcpu->kvm->cfg.ioport_debug) {
> +			fprintf(stderr, "IO error: %s port=%x, size=%d, count=%u\n",
> +				to_direction(direction), port, size, count);
> +
> +			return false;
> +		}
> +		return true;
> +	}
> +
> +	while (count--) {
> +		mmio->mmio_fn(vcpu, port, data, size, is_write, mmio->ptr);
> +
> +		data += size;
> +	}
> +
> +	mmio_put(vcpu->kvm, &pio_tree, mmio);
> +
> +	return true;
> +}
