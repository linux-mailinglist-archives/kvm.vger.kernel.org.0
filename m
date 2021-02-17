Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5913F31DE90
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 18:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhBQRp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 12:45:28 -0500
Received: from foss.arm.com ([217.140.110.172]:34966 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234667AbhBQRpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 12:45:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78C9C1FB;
        Wed, 17 Feb 2021 09:44:34 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A6233F73D;
        Wed, 17 Feb 2021 09:44:32 -0800 (PST)
Date:   Wed, 17 Feb 2021 17:43:24 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool 04/21] mmio: Extend handling to include ioport
 emulation
Message-ID: <20210217174245.30092828@slackpad.fritz.box>
In-Reply-To: <a97cc31b-73b0-7c48-79bb-fc14f7ec0aa1@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
        <20201210142908.169597-5-andre.przywara@arm.com>
        <a97cc31b-73b0-7c48-79bb-fc14f7ec0aa1@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Feb 2021 16:10:16 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> On 12/10/20 2:28 PM, Andre Przywara wrote:
> > In their core functionality MMIO and I/O port traps are not really
> > different, yet we still have two totally separate code paths for
> > handling them. Devices need to decide on one conduit or need to provide
> > different handler functions for each of them.
> >
> > Extend the existing MMIO emulation to also cover ioport handlers.
> > This just adds another RB tree root for holding the I/O port handlers,
> > but otherwise uses the same tree population and lookup code.  
> 
> Maybe I'm missing something, but why two trees? Is it valid to have an overlap
> between IO port and MMIO emulation? Or was it done to make the removal of ioport
> emulation easier?

So I thought about it as well, but figured it's easier this way:
- x86 allows overlap, PIO is a totally separate address space from
  memory/MMIO. Early x86 CPUs had pins to indicate a PIO bus cycle, but
  using the same address and data pins otherwise. In practise there
  might be no overlap when it comes to *MMIO* traps vs PIO on x86
  (there is DRAM only at the lowest 64K of the IBM PC memory map),
  but not sure we should rely on this.
- For non-x86 this would indeed be non-overlapping, but this would need
  to be translated at init time then? And then we can't move those
  anymore, I guess? So I found it cleaner to keep this separate, and do
  the translation at trap time.
- As a consequence we would need to have a bit indicating the address
  space. I haven't actually tried this, but my understanding is that
  this would spoil the whole rb_tree functions, since they rely on a
  linear addressing scheme, and adding another bit there would be at
  least cumbersome?

At the end I decided to go for separate trees, as also this was less
change.

I agree that it would be nice to have one tree, from a design point of
view, but I am afraid that would require more changes.
If need be, I think we can always unify them later on, on top of this
series?

> If it's not valid to have that overlap, then I think having one tree for both
> would better. Struct mmio_mapping would have to be augmented with a flags field
> that holds the same flags given to kvm__register_iotrap to differentiate between
> the two slightly different emulations. Saving the IOTRAP_COALESCE flag would also
> make it trivial to call KVM_UNREGISTER_COALESCED_MMIO in kvm__deregister_iotrap,
> which we currently don't do.
> 
> > "ioport" or "mmio" just become a flag in the registration function.
> > Provide wrappers to not break existing users, and allow an easy
> > transition for the existing ioport handlers.
> >
> > This also means that ioport handlers now can use the same emulation
> > callback prototype as MMIO handlers, which means we have to migrate them
> > over. To allow a smooth transition, we hook up the new I/O emulate
> > function to the end of the existing ioport emulation code.  
> 
> I'm sorry, but I don't understand that last sentence. Do you mean that the ioport
> emulation code has been modified to use kvm__emulate_pio() as a fallback for when
> the port is not found in the ioport_tree?

I meant that for the transition period we have all of traditional MMIO,
traditional PIO, *and* just transformed PIO.

That means there are still PIO devices registered through ioport.c's
ioport__register(), *and* PIO devices registered through mmio.c's
kvm__register_pio(). Which means they end up in two separate PIO trees.
And only the traditional kvm__emulate_io() from ioport.c is called upon
a trap, so it needs to check both trees, which it does by calling into
kvm__emulate_pio(), shall a search in the local tree fail.

Or did you mean something else?

> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  include/kvm/kvm.h | 42 +++++++++++++++++++++++++++++----
> >  ioport.c          |  4 ++--
> >  mmio.c            | 59 +++++++++++++++++++++++++++++++++++++++--------
> >  3 files changed, 89 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> > index ee99c28e..14f9d58b 100644
> > --- a/include/kvm/kvm.h
> > +++ b/include/kvm/kvm.h
> > @@ -27,10 +27,16 @@
> >  #define PAGE_SIZE (sysconf(_SC_PAGE_SIZE))
> >  #endif
> >  
> > +#define IOTRAP_BUS_MASK		0xf  
> 
> It's not immediately obvious what this mask does. It turns out it's used to mask
> the enum flags defined in the header devices.h, header which is not included in
> this file.
> 
> The flag names we pass to kvm__register_iotrap() are slightly inconsistent
> (DEVICE_BUS_PCI, DEVICE_BUS_MMIO and IOTRAP_COALESCE), where DEVICE_BUS_{PCI,
> MMIO} come from devices.h as an enum. I was wondering if I'm missing something and
> there is a particular reason why we don't define our own flags for that here
> (something like IOTRAP_PIO and IOTRAP_MMIO).

I am not sure why this would be needed?
We already define and use DEVICE_BUS_x elsewhere, so why not re-use it?

> If we do decide to keep the flags from devices.h, I think it would be worth it to
> have a compile time check (with BUILD_BUG_ON) that IOTRAP_BUS_MASK is >=
> DEVICES_BUS_MAX, which would also be a good indication of where those flags are
> coming from.

Well, if that makes you happy, I am not sure we gain another 13 bus
types anytime soon, though ;-)
 
> 
> > +#define IOTRAP_COALESCE		(1U << 4)
> > +
> >  #define DEFINE_KVM_EXT(ext)		\
> >  	.name = #ext,			\
> >  	.code = ext
> >  
> > +struct kvm_cpu;
> > +typedef void (*mmio_handler_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data,
> > +				u32 len, u8 is_write, void *ptr);
> >  typedef void (*fdt_irq_fn)(void *fdt, u8 irq, enum irq_type);
> >  
> >  enum {
> > @@ -113,6 +119,8 @@ void kvm__irq_line(struct kvm *kvm, int irq, int level);
> >  void kvm__irq_trigger(struct kvm *kvm, int irq);
> >  bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction, int size, u32 count);
> >  bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
> > +bool kvm__emulate_pio(struct kvm_cpu *vcpu, u16 port, void *data,
> > +		      int direction, int size, u32 count);
> >  int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr);
> >  int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
> >  		      enum kvm_mem_type type);
> > @@ -136,10 +144,36 @@ static inline int kvm__reserve_mem(struct kvm *kvm, u64 guest_phys, u64 size)
> >  				 KVM_MEM_TYPE_RESERVED);
> >  }
> >  
> > -int __must_check kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool coalesce,
> > -				    void (*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr),
> > -				    void *ptr);
> > -bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr);
> > +int __must_check kvm__register_iotrap(struct kvm *kvm, u64 phys_addr, u64 len,
> > +				      mmio_handler_fn mmio_fn, void *ptr,
> > +				      unsigned int flags);
> > +
> > +static inline
> > +int __must_check kvm__register_mmio(struct kvm *kvm, u64 phys_addr,
> > +				    u64 phys_addr_len, bool coalesce,
> > +				    mmio_handler_fn mmio_fn, void *ptr)
> > +{
> > +	return kvm__register_iotrap(kvm, phys_addr, phys_addr_len, mmio_fn, ptr,
> > +			DEVICE_BUS_MMIO | (coalesce ? IOTRAP_COALESCE : 0));
> > +}
> > +static inline
> > +int __must_check kvm__register_pio(struct kvm *kvm, u16 port, u16 len,
> > +				   mmio_handler_fn mmio_fn, void *ptr)
> > +{
> > +	return kvm__register_iotrap(kvm, port, len, mmio_fn, ptr,
> > +				    DEVICE_BUS_IOPORT);
> > +}
> > +
> > +bool kvm__deregister_iotrap(struct kvm *kvm, u64 phys_addr, unsigned int flags);
> > +static inline bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
> > +{
> > +	return kvm__deregister_iotrap(kvm, phys_addr, DEVICE_BUS_MMIO);
> > +}
> > +static inline bool kvm__deregister_pio(struct kvm *kvm, u16 port)
> > +{
> > +	return kvm__deregister_iotrap(kvm, port, DEVICE_BUS_IOPORT);
> > +}
> > +
> >  void kvm__reboot(struct kvm *kvm);
> >  void kvm__pause(struct kvm *kvm);
> >  void kvm__continue(struct kvm *kvm);
> > diff --git a/ioport.c b/ioport.c
> > index b98836d3..204d8103 100644
> > --- a/ioport.c
> > +++ b/ioport.c
> > @@ -147,7 +147,8 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
> >  
> >  	entry = ioport_get(&ioport_tree, port);
> >  	if (!entry)
> > -		goto out;
> > +		return kvm__emulate_pio(vcpu, port, data, direction,
> > +					size, count);  
> 
> I have to admit this gave me pause because this patch doesn't add any users for
> kvm__register_pio() (although with this change the behaviour of kvm__emulate_io()
> remains exactly the same). Do you think this change would fit better in patch #7,
> where the first user for kvm__register_pio() is added, or do you prefer it here?

I think it logically belongs here, as we introduce the
kvm__emulate_pio() function here as well. Otherwise this function would
have no caller. As it is now, it's just a "coincidence" that no one
actually called kvm__register_pio() so far. This also makes the other
patches movable and replaceable: this patch prepares the stage, the
follow-up patches just fill it.

> >  
> >  	ops	= entry->ops;
> >  
> > @@ -162,7 +163,6 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16
> > port, void *data, int direction, 
> >  	ioport_put(&ioport_tree, entry);
> >  
> > -out:
> >  	if (ret)
> >  		return true;
> >  
> > diff --git a/mmio.c b/mmio.c
> > index cd141cd3..4cce1901 100644
> > --- a/mmio.c
> > +++ b/mmio.c
> > @@ -19,13 +19,14 @@ static DEFINE_MUTEX(mmio_lock);
> >  
> >  struct mmio_mapping {
> >  	struct rb_int_node	node;
> > -	void			(*mmio_fn)(struct kvm_cpu
> > *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr);
> > +	mmio_handler_fn		mmio_fn;
> >  	void			*ptr;
> >  	u32			refcount;
> >  	bool			remove;
> >  };
> >  
> >  static struct rb_root mmio_tree = RB_ROOT;
> > +static struct rb_root pio_tree = RB_ROOT;
> >  
> >  static struct mmio_mapping *mmio_search(struct rb_root *root, u64
> > addr, u64 len) {
> > @@ -103,9 +104,9 @@ static void mmio_put(struct kvm *kvm, struct
> > rb_root *root, struct mmio_mapping mutex_unlock(&mmio_lock);
> >  }
> >  
> > -int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64
> > phys_addr_len, bool coalesce,
> > -		       void (*mmio_fn)(struct kvm_cpu *vcpu, u64
> > addr, u8 *data, u32 len, u8 is_write, void *ptr),
> > -			void *ptr)
> > +int kvm__register_iotrap(struct kvm *kvm, u64 phys_addr, u64
> > phys_addr_len,
> > +			 mmio_handler_fn mmio_fn, void *ptr,
> > +			 unsigned int flags)
> >  {
> >  	struct mmio_mapping *mmio;
> >  	struct kvm_coalesced_mmio_zone zone;
> > @@ -127,7 +128,7 @@ int kvm__register_mmio(struct kvm *kvm, u64
> > phys_addr, u64 phys_addr_len, bool c .remove		= false,
> >  	};
> >  
> > -	if (coalesce) {
> > +	if (flags & IOTRAP_COALESCE) {  
> 
> There is no such flag being used in ioport.c, is it valid to have the
> flags DEVICE_BUS_IOPORT and IOTRAP_COALESCE set at the same time?

Well, yes and no: Yes, as this maps to MMIO on non-x86, so
theoretically could use the flag. No, as no one registering a trap
handler through kvm__register_pio() would ever have the chance to set
this flag.
I can check for the registration being for the MMIO bus before entering
the "if" branch, if that is what you mean?

> 
> >  		zone = (struct kvm_coalesced_mmio_zone) {
> >  			.addr	= phys_addr,
> >  			.size	= phys_addr_len,
> > @@ -139,18 +140,27 @@ int kvm__register_mmio(struct kvm *kvm, u64
> > phys_addr, u64 phys_addr_len, bool c }
> >  	}
> >  	mutex_lock(&mmio_lock);
> > -	ret = mmio_insert(&mmio_tree, mmio);
> > +	if ((flags & IOTRAP_BUS_MASK) == DEVICE_BUS_IOPORT)
> > +		ret = mmio_insert(&pio_tree, mmio);
> > +	else
> > +		ret = mmio_insert(&mmio_tree, mmio);
> >  	mutex_unlock(&mmio_lock);
> >  
> >  	return ret;
> >  }
> >  
> > -bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
> > +bool kvm__deregister_iotrap(struct kvm *kvm, u64 phys_addr,
> > unsigned int flags) {
> >  	struct mmio_mapping *mmio;
> > +	struct rb_root *tree;
> > +
> > +	if ((flags & IOTRAP_BUS_MASK) == DEVICE_BUS_IOPORT)
> > +		tree = &pio_tree;
> > +	else
> > +		tree = &mmio_tree;
> >  
> >  	mutex_lock(&mmio_lock);
> > -	mmio = mmio_search_single(&mmio_tree, phys_addr);
> > +	mmio = mmio_search_single(tree, phys_addr);
> >  	if (mmio == NULL) {
> >  		mutex_unlock(&mmio_lock);
> >  		return false;
> > @@ -167,7 +177,7 @@ bool kvm__deregister_mmio(struct kvm *kvm, u64
> > phys_addr)
> >  	 * called mmio_put(). This will trigger use-after-free
> > errors on VCPU0. */
> >  	if (mmio->refcount == 0)
> > -		mmio_deregister(kvm, &mmio_tree, mmio);
> > +		mmio_deregister(kvm, tree, mmio);
> >  	else
> >  		mmio->remove = true;
> >  	mutex_unlock(&mmio_lock);
> > @@ -175,7 +185,8 @@ bool kvm__deregister_mmio(struct kvm *kvm, u64
> > phys_addr) return true;
> >  }
> >  
> > -bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8
> > *data, u32 len, u8 is_write) +bool kvm__emulate_mmio(struct kvm_cpu
> > *vcpu, u64 phys_addr, u8 *data,
> > +		       u32 len, u8 is_write)  
> 
> I don't think style changes should be part of this patch, the patch
> is large enough as it is.

I see, I just figured it's not worth a separate patch either.

Cheers,
Andre

> >  {
> >  	struct mmio_mapping *mmio;
> >  
> > @@ -194,3 +205,31 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu,
> > u64 phys_addr, u8 *data, u32 len, u out:
> >  	return true;
> >  }
> > +
> > +bool kvm__emulate_pio(struct kvm_cpu *vcpu, u16 port, void *data,
> > +		     int direction, int size, u32 count)
> > +{
> > +	struct mmio_mapping *mmio;
> > +	bool is_write = direction == KVM_EXIT_IO_OUT;
> > +
> > +	mmio = mmio_get(&pio_tree, port, size);
> > +	if (!mmio) {
> > +		if (vcpu->kvm->cfg.ioport_debug) {
> > +			fprintf(stderr, "IO error: %s port=%x,
> > size=%d, count=%u\n",
> > +				to_direction(direction), port,
> > size, count); +
> > +			return false;
> > +		}
> > +		return true;
> > +	}
> > +
> > +	while (count--) {
> > +		mmio->mmio_fn(vcpu, port, data, size, is_write,
> > mmio->ptr); +
> > +		data += size;
> > +	}
> > +
> > +	mmio_put(vcpu->kvm, &pio_tree, mmio);
> > +
> > +	return true;
> > +}  

