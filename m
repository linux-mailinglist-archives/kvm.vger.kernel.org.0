Return-Path: <kvm+bounces-53870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED25DB18E4F
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 13:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8DCB560F52
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 11:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA852264BD;
	Sat,  2 Aug 2025 11:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="dZElYOlW";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="p1hv894c"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A85E8836;
	Sat,  2 Aug 2025 11:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754135650; cv=none; b=UZ4E9rZl4ViL0+jJ/HrcS1d3sLeJYH2oYul+ShC3cEeQ7+dtmKy8hP8xHBlMM1iERlXzz5+e0l8dBzKzAB+aBrob8cmUn3Y4TUmbL6s2BELb0kQlst+0tb2aD7IKO1xXrx0jpw8j2ncE1PhrFI5oQVhSwy3rlENHAloMryRmSH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754135650; c=relaxed/simple;
	bh=7JSK08gr5EMMwFTP+Nc18gtIcN61iXQJ4wSPoNhyA7o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tsUHAlmJKI9EFY1BD23x71Dp1RvdE5gE2tw/CipP4ZOZFTbMGUnDJ1Jpjp+vBt8U4ki0TYzXXsHPx/5LM9iSLiwhlitEMs94DArLC/CkZLzKKf/ZP7wNmGbnG8boEWRgW8vwB20ZAnOBPqFi0iQiI49S5RiN5VNsbgso5ISxxL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=dZElYOlW; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=p1hv894c; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754135646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1HpnpcljZv3Vcr0JYTBR7pupUbl6kk1J0tdkltSaCQs=;
	b=dZElYOlWqZydsTiMiRF/GWFwajmqUZhV1PJrNaWfnpV18LmkLlIsi2pM9YcL1m3OAgVTGc
	/LGDe+3yrAJs3+n3/vnByVEiungrF0g/2EVAyqURZuKsw5H7oTnrhJ7z/1rAY1WR7O4GI2
	bERSGCW7J7xosEUz4ogT9V2OvbfvEC4lknXhjbfYoWzzLx4EDaKxgy6ONpJUEa0BWsVFps
	7IWWgP2zEn3Bl/lXomztPjGvaPRK48Vk9/niPomnOFu88dHg0I3khwx7Y0fLQspUtdPIaV
	qtE47TQErVakkAXWGY67ef7yj0F5ej+chVxfD4Ti3MqB1omLDI3A0I9l8wBTZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754135646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1HpnpcljZv3Vcr0JYTBR7pupUbl6kk1J0tdkltSaCQs=;
	b=p1hv894c7n9YDQ6eOZ7HFk5r3LdKrJNdBVb4JuevvoiZ9IdJUFrzFZxma9uNfs5bk1+Wws
	X5LlorFumjbOIiDQ==
To: Hogan Wang <hogan.wang@huawei.com>, x86@kernel.org,
 dave.hansen@linux.intel.com, kvm@vger.kernel.org,
 alex.williamson@redhat.com
Cc: weidong.huang@huawei.com, yechuan@huawei.com, hogan.wang@huawei.com,
 wangxinxin.wang@huawei.com, jianjay.zhou@huawei.com, wangjie88@huawei.com,
 maz@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/irq: Plug vector setup race
In-Reply-To: <20250801145633.2412-1-hogan.wang@huawei.com>
References: <87a54kil52.ffs@tglx> <20250801145633.2412-1-hogan.wang@huawei.com>
Date: Sat, 02 Aug 2025 13:54:05 +0200
Message-ID: <87v7n6gcrm.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Aug 01 2025 at 22:56, Hogan Wang wrote:
> I believe an effective solution to the issue of lost interrupts
> might be to modify the vifo module to avoid un-plug/plug irq,
> and instead use a more lightweight method to switch interrupt
> modes. Just like:
>
> vfio_irq_handler()
> 	if kvm_mode
> 		vfio_send_eventfd(kvm_irq_fd);
> 	else
> 		vfio_send_eventfd(qemu_irq_fd);
>
> However, this will bring about some troubles:
> 1) The kvm_mode variable should be protected, leading to performance loss. 
> 2) The VFIO interface requires the passing of two eventfds. 
> 3) Add another interface to implement mode switching. 
>
> Do you have a better solution to fix this interrupt loss issue?

Interesting. I looked at vfio_irq_handler(), which is in the platform/
part of VFIO. The corresponding vfio_set_trigger(), which switches eventfds
does the right thing:

     disable_irq();
     update(trigger);
     enable_irq();

disable_irq() ensures that there is no interrupt handler in progress, so
it becomes safe to switch the trigger in the data structure which is has
been handed to request_irq() as @dev_id argument. For edge type
interupts this ensures that a interrupt which arrives while disabled is
retriggered on enable, so that no interrupt can get lost.

The PCI variant is using the trigger itself as the @dev_id argument and
therefore has to do the free_irq()/request_irq() dance. It shouldn't be
hard to convert the PCI implementation over to the disable/enable scheme.

> There is a question that has been troubling me: Why are interrupts
> still reported after they have been masked and the interrupt remapping
> table entries have been disabled? Is this interrupt cached somewhere?

Let me bring back the picture I used before:

	 CPU0				CPU1
	 vmenter(vCPU0)
	 ....                           local_irq_disable()
	  msi_set_affinity()
 #1	    mask(MSI-X)
	      vmexit()                  
 #2      ...                             interrupt is raised in APIC
                                         but not handled

 #3      really_mask(MSI-X)
         free_irq()
 	   mask();        

 #4	   __synchronize_irq()

	   msi_domain_deactivate()
	     write_msg(0);
	   x86_vector_deactivate()
 #5          per_cpu(vector_irq, cpu)[vector] = VECTOR_SHUTDOWN;

 #6                                     local_irq_enable()
                                         interrupt is handled and
					 observes VECTOR_SHUTDOWN
					 writes VECTOR_UNUSED
	request_irq()
	  x86_vector_activate()
	     per_cpu(vector_irq, cpu)[vector] = desc;

	   msi_domain_deactivate()
	     write_msg(msg);
	   unmask();

#1 is the mask operation in the VM, which is trapped, i.e. the interrupt
   is not yet masked at the MSIX level.

#2 The device raises the interupt _before_ the host can mask the
   interrupt at the PCI-MSIX level (#3).

   The interrupt is sent to the APIC of the target CPU 1, which sets the
   corresponding IRR bit in the APIC if the CPU cannot handle it at that
   point, because it has interrupts disabled.

#4 cannot observe the pending IRR bit on CPU1's APIC and therefore
   concludes that there is no interrupt in flight.

If the host side VMM manages to shut down the interrupt completely (#5)
_before_ CPU1 reenables interrupts (#6), then CPU1 will observe
VECTOR_SHUTDOWN and treats it as a spurious interrupt.

The same problem exists on bare metal, when a driver leaves the device
interrupts enabled and then does a free/request dance:

	 CPU0				CPU1
	 ....                           local_irq_disable()
 #1	 free_irq()
 #2      ...                             interrupt is raised in APIC
                                         but not handled

 #3       really_mask(MSI-X)

 #4	   __synchronize_irq()

	   msi_domain_deactivate()
	     write_msg(0);
	   x86_vector_deactivate()
 #5          per_cpu(vector_irq, cpu)[vector] = VECTOR_SHUTDOWN;

 #6                                     local_irq_enable()
                                         interrupt is handled and
					 observes VECTOR_SHUTDOWN
					 writes VECTOR_UNUSED
	request_irq()
	  x86_vector_activate()
	     per_cpu(vector_irq, cpu)[vector] = desc;

	   msi_domain_deactivate()
	     write_msg(msg);
	   unmask();

See?

Thanks,

        tglx

