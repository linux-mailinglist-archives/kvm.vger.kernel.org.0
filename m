Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9323A31EE46
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhBRS2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:28:35 -0500
Received: from foss.arm.com ([217.140.110.172]:53308 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233820AbhBRQnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 11:43:12 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A57F9106F;
        Thu, 18 Feb 2021 08:42:16 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F3893F73D;
        Thu, 18 Feb 2021 08:42:14 -0800 (PST)
Date:   Thu, 18 Feb 2021 16:41:17 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool 21/21] hw/rtc: ARM/arm64: Use MMIO at higher
 addresses
Message-ID: <20210218164117.15fbd67a@slackpad.fritz.box>
In-Reply-To: <102807a0-812f-d4bf-b8b4-560f999c6e6c@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
        <20201210142908.169597-22-andre.przywara@arm.com>
        <102807a0-812f-d4bf-b8b4-560f999c6e6c@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Feb 2021 13:33:15 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Hi Andre,
> 
> On 12/10/20 2:29 PM, Andre Przywara wrote:
> > Using the RTC device at its legacy I/O address as set by IBM in 1981
> > was a kludge we used for simplicity on ARM platforms as well.
> > However this imposes problems due to their missing alignment and overlap
> > with the PCI I/O address space.
> >
> > Now that we can switch a device easily between using ioports and
> > MMIO, let's move the RTC out of the first 4K of memory on ARM platforms.
> >
> > That should be transparent for well behaved guests, since the change is
> > naturally reflected in the device tree.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  hw/rtc.c | 24 ++++++++++++++++--------
> >  1 file changed, 16 insertions(+), 8 deletions(-)
> >
> > diff --git a/hw/rtc.c b/hw/rtc.c
> > index ee4c9102..bdb88f0f 100644
> > --- a/hw/rtc.c
> > +++ b/hw/rtc.c
> > @@ -5,6 +5,15 @@
> >  
> >  #include <time.h>
> >  
> > +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> > +#define RTC_BUS_TYPE		DEVICE_BUS_MMIO
> > +#define RTC_BASE_ADDRESS	0x1010000  
> 
> This looks correct, the base address is the serial base address + 64k, so they
> don't overlap, and it doesn't overlap with the flash memory either. Same comment
> as for the serial, I think the reason for choosing this address should be
> mentioned, and the region should be put in the arch memory layout file. Other than
> that, the patch looks good.

Yep, will do!

Thanks,
Andre

> 
> > +#else
> > +/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> > +#define RTC_BUS_TYPE		DEVICE_BUS_IOPORT
> > +#define RTC_BASE_ADDRESS	0x70
> > +#endif
> > +
> >  /*
> >   * MC146818 RTC registers
> >   */
> > @@ -49,7 +58,7 @@ static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
> >  	time_t ti;
> >  
> >  	if (is_write) {
> > -		if (addr == 0x70) {	/* index register */
> > +		if (addr == RTC_BASE_ADDRESS) {	/* index register */
> >  			u8 value = ioport__read8(data);
> >  
> >  			vcpu->kvm->nmi_disabled	= value & (1UL << 7);
> > @@ -70,7 +79,7 @@ static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
> >  		return;
> >  	}
> >  
> > -	if (addr == 0x70)
> > +	if (addr == RTC_BASE_ADDRESS)	/* index register is write-only */
> >  		return;
> >  
> >  	time(&ti);
> > @@ -127,7 +136,7 @@ static void generate_rtc_fdt_node(void *fdt,
> >  							    u8 irq,
> >  							    enum irq_type))
> >  {
> > -	u64 reg_prop[2] = { cpu_to_fdt64(0x70), cpu_to_fdt64(2) };
> > +	u64 reg_prop[2] = { cpu_to_fdt64(RTC_BASE_ADDRESS), cpu_to_fdt64(2) };
> >  
> >  	_FDT(fdt_begin_node(fdt, "rtc"));
> >  	_FDT(fdt_property_string(fdt, "compatible", "motorola,mc146818"));
> > @@ -139,7 +148,7 @@ static void generate_rtc_fdt_node(void *fdt,
> >  #endif
> >  
> >  struct device_header rtc_dev_hdr = {
> > -	.bus_type = DEVICE_BUS_IOPORT,
> > +	.bus_type = RTC_BUS_TYPE,
> >  	.data = generate_rtc_fdt_node,
> >  };
> >  
> > @@ -151,8 +160,8 @@ int rtc__init(struct kvm *kvm)
> >  	if (r < 0)
> >  		return r;
> >  
> > -	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> > -	r = kvm__register_pio(kvm, 0x0070, 2, cmos_ram_io, NULL);
> > +	r = kvm__register_iotrap(kvm, RTC_BASE_ADDRESS, 2, cmos_ram_io, NULL,
> > +				 RTC_BUS_TYPE);
> >  	if (r < 0)
> >  		goto out_device;
> >  
> > @@ -170,8 +179,7 @@ dev_init(rtc__init);
> >  
> >  int rtc__exit(struct kvm *kvm)
> >  {
> > -	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> > -	kvm__deregister_pio(kvm, 0x0070);
> > +	kvm__deregister_iotrap(kvm, RTC_BASE_ADDRESS, RTC_BUS_TYPE);
> >  
> >  	return 0;
> >  }  

