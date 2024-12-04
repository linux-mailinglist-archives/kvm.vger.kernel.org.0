Return-Path: <kvm+bounces-33031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E43CC9E3AD0
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 14:05:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3C52280F7A
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD831B9831;
	Wed,  4 Dec 2024 13:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="wL73UjeX";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="qPufNg0a"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB623746E;
	Wed,  4 Dec 2024 13:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733317533; cv=none; b=CybCbXFp43ptfG/5Zsb3ulyqlRd9zxIb3y/javqtB5u9VwsMDCWE0bHUBMADRBq9eUZ3SNjwdO+NBIO1BktYZ9YPYFwN+EmG1VXIiFMpnyuPSKRPJk64u2HMaCcKVpU34NJZf2IPFLlUJPsGDNDWE5c0jpLWN3Yvxp/Idons5UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733317533; c=relaxed/simple;
	bh=XVtkq5iJ4Mj7hRv7CqYFdnVlFpaRegC0V8RTwadfHQk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JX81zvCkiLjglNgOOAL3myYxjYxbujl6bgVlU6ykQU4b4Rlw6J+aSXV54MCb8c0+ru18wWqKuVmXyHP23H3IulaeOBKDDI5P9pRm+2B6jraxANbAJGF6CvxewrTpIpf1ty2+7JC+gLVl/dVVuULkuFCMDz8NMqCdspzlD6PxFng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=wL73UjeX; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=qPufNg0a; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1733317524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ROH6zlh02KHc87r45BDTv/cN5afbSIuh9toQ2ctg4yk=;
	b=wL73UjeXWyYQQmB1Pp1remQXdjAmCrtcWFIChE7E9HHlqL9M/l/akN/1PUyWWcio+M4hsd
	d7PhJzhCnsWkx4s2pdhDctBT82t3yAu7JL5tjJcYh5qKSbFl1hdbxAKNn5Bt1Rnq8D3xyh
	1W12Torjr4e84kQ605+X6R3Xvphy304E3U+iWFWCCSOPeoenFGFisFQOMcWHZkqvkIm/Yo
	rqrivG3Lb9g3nGu76ZInJIUVeq0VCHCnHokMrMp17Gv781GoLj6bgF39qb7BhDi4tsMRg6
	qBrRpQNn0HXqJMPWSPvD3rrF6D76de00gbF5IouDkUgEw4GC/F5dlO0bLlErmA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1733317524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ROH6zlh02KHc87r45BDTv/cN5afbSIuh9toQ2ctg4yk=;
	b=qPufNg0aO0AVR52BVTeAWUHTNUKlqiQiXfPzDa82iuoktna7Zd4GaEhPSAChG0cycCtYIt
	oiuHXrVUC/U2oQBQ==
To: Anup Patel <anup@brainfault.org>
Cc: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 tjeznach@rivosinc.com, zong.li@sifive.com, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, atishp@atishpatra.org,
 alex.williamson@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 01/15] irqchip/riscv-imsic: Use hierarchy to reach
 irq_set_affinity
In-Reply-To: <CAAhSdy27gaVJaXBrx8GB+Xr4ZTvp8hd0Jg8JokzehgC-=5pOmA@mail.gmail.com>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-18-ajones@ventanamicro.com> <87mshcub2u.ffs@tglx>
 <CAAhSdy08gi998HsTkGpaV+bTWczVSL6D8c7EmuTQqovo63oXDw@mail.gmail.com>
 <874j3ktrjv.ffs@tglx> <87ser4s796.ffs@tglx>
 <CAAhSdy27gaVJaXBrx8GB+Xr4ZTvp8hd0Jg8JokzehgC-=5pOmA@mail.gmail.com>
Date: Wed, 04 Dec 2024 14:05:23 +0100
Message-ID: <87mshbsing.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 04 2024 at 09:13, Anup Patel wrote:
> On Wed, Dec 4, 2024 at 4:29=E2=80=AFAM Thomas Gleixner <tglx@linutronix.d=
e> wrote:
>> As I was looking at something else MSI related I had a look at
>> imsic_irq_set_affinity() again.
>>
>> It's actually required to have the message write in that function and
>> not afterwards as you invoke imsic_vector_move() from that function.
>>
>> That's obviously not true for the remap case as that will not change the
>> message address/data pair because the remap table entry is immutable -
>> at least I assume so for my mental sanity sake :)
>>
>> But that brings me to a related question. How is this supposed to work
>> with non-atomic message updates? PCI/MSI does not necessarily provide
>> masking, and the write of the address/data pair is done in bits and
>> pieces. So you can end up with an intermediate state seen by the device
>> which ends up somewhere in interrupt nirvana space.
>>
>> See the dance in msi_set_affinity() and commit 6f1a4891a592
>> ("x86/apic/msi: Plug non-maskable MSI affinity race") for further
>> explanation.
>>
>> The way how the IMSIC driver works seems to be pretty much the same as
>> the x86 APIC mess:
>>
>>         @address is the physical address of the per CPU MSI target
>>         address and @data is the vector ID on that CPU.
>>
>> So the non-atomic update in case of non-maskable MSI suffers from the
>> same problem. It works most of the time, but if it doesn't you might
>> stare at the occasionally lost interrupt and the stale device in
>> disbelief for quite a while :)
>
> Yes, we have the same challenges as x86 APIC when changing
> MSI affinity.
>>
>> I might be missing something which magically prevent that though :)
>>
> Your understanding is correct. In fact, the IMSIC msi_set_affinity()
> handling is inspired from x86 APIC approach due to similarity in
> the overall MSI controller.
>
> The high-level idea of imsic_irq_set_affinity() is as follows:
>
> 1) Allocate new_vector (new CPU IMSIC address + new ID on that CPU)
>
> 2) Update the MSI address and data programmed in the device
> based on new_vector (see imsic_msi_update_msg())
>
> 3) At this point the device points to the new_vector but old_vector
> (old CPU IMSIC address + old ID on that CPU) is still enabled and
> we might have received MSI on old_vector while we were busy
> setting up a new_vector for the device. To address this, we call
> imsic_vector_move().
>
> 4) The imsic_vector_move() marks the old_vector as being
> moved and schedules a lazy timer on the old CPU.
>
> 5) The lazy timer expires on the old CPU and results in
> __imsic_local_sync() being called on the old CPU.
>
> 6) If there was a pending MSI on the old vector then the
> __imsic_local_sync() function injects an MSI to the
> new_vector using an MMIO write.
>
> It is very unlikely that an MSI from device will be dropped
> (unless I am missing something) but the unsolved issue
> is that handling of in-flight MSI received on the old_vector
> during the MSI re-programming is delayed which may have
> side effects on the device driver side.

Interrupt delivery can be delayed for tons of other reasons.

But yes, you are missing something which is worse than a jiffie delay:

CPU                                     Device
  msi_update_msg()
     compose()
     write()
       write(msg->address_lo); [1]
       write(msg->address_hi); [2]
                                        Raises interrupt [3]
       write(msg->data);       [4]

[2] can be ignored as it should not change (otherwise 32bit only devices
would not work).

Lets assume that the original message was:

     addr_lo =3D 0x1000, data =3D 0x10    (CPU1, vector 0x10)
=20=20=20=20=20=20=20
The new message is

     addr_lo =3D 0x2000, data =3D 0x20    (CPU2, vector 0x20)

After [2] the device sees:

     addr_lo =3D 0x2000, data =3D 0x10    (CPU2, vector 0x10)

The interrupt raised in [3] will end up on CPU2 at vector 0x10 which
might be not in use or used by some other device. In any case the
interrupt is not reaching the real device handler and you can't see that
interrupt as pending in CPU1.

That's why x86 in case of non-remapped interrupts has this for the two
situations:

  1) old->data =3D=3D new->data

     write_msg(new);=20

     The next interrupt either arrives on the old CPU or on the new CPU
     depending on timing. There is no intermediate state because the
     vector (data) is the same on both CPUs.

  2) old->data !=3D new->data

     tmp_msg.addr =3D old_msg.addr
     tmp_msg.data =3D new_msg.data

     write_msg(tmp_msg);

     So after that write the device might raise the interrupt on CPU1
     and vector 0x20.

     The next step is

     write_msg(new);=20

     which changes the destination CPU to CPU2.

     So depending what the device has observed the interrupt might end
     up on

     CPU1 vector 0x10   (old)
     CPU1 vector 0x20   (tmp)
     CPU2 vector 0x20   (new)

     CPU1 vector 0x20 (tmp) is then checked in the pending register and
     the interrupt is retriggered if pending.

That requires to move the interrupt from actual interrupt context on the
old target CPU. It allows to evaluate the old target CPUs pending
register with local interrupts disabled, which obviously does not work
remote.

I don't see a way how that can work remote with the IMSIC either even if
you can easily access the pending state of the remote CPU:

CPU0                            CPU1                   Device
set_affinity()
  write_msg(tmp)
    write(addr); // CPU1
    write(data); // vector 0x20
                                                        raise IRQ
                                handle vector 0x20
                                (spurious or other device)

    check_pending(CPU1, 0x20) =3D=3D false -> Interrupt is lost

Remapped interrupts do not have that issue because the table update is
atomic vs. a concurrently raised interrupt, so that it either ends up on
the old or on the new destination. The device message does not change as
it always targets the table entry, which is immutable after setup.

That's why x86 has this special msi affinity setter for the non remapped
case. For the remapped case it's just using the hierarchy default which
ends up at the remap domain.

So the hierarchies look like this:

   1) non-remap

      PCI/MSI device domain
         irq_chip.irq_set_affinity =3D msi_set_affinity;
      VECTOR domain

   2) remap

      PCI/MSI device domain
         irq_chip.irq_set_affinity =3D msi_domain_set_affinity;
      REMAP domain
         irq_chip.irq_set_affinity =3D remap_set_affinity;
      VECTOR domain

The special case of msi_set_affinity() is not involved in the remap case
and solely utilized for the non-remap horrors. The remap case does not
require the interrupt to be moved in interrupt context either because
there is no intermediate step and pending register check on the old CPU
involved.

The vector cleanup of the old CPU always happens when the interrupt
arrives on the new target for the first time independent of remapping
mode. That's required for both cases to take care of the case where the
interrupt is raised on the old vector (cpu1, 0x10) before the write
happens and is pending in CPU1. So after desc::lock is released and
interrupts are reenabled the interrupt is handled on CPU1. The next one
is guaranteed to arrive on CPU2 and that triggers the clean up of the
CPU1 vector, which releases it for reuse in the matrix allocator.

I think you should model it in a similar way instead of trying to
artificially reuse imsic_irq_set_affinity() for the remap case,
especially when you decide to close the non-maskable MSI hole described
above, which I recommend to do :)

You still can utilize msi-lib and just have your private implementation
of init_dev_msi_info() as a wrapper around the library similar to
mbi_init_dev_msi_info() and its_init_dev_msi_info(). That wrapper would
just handle the non-remap case to set info::chip:irq_set_affinity to the
magic non-remap function.

Hope that helps.

> I believe in the future RISC-V AIA v2.0 (whenever that
> happens) will address the gaps in AIA v1.0 (like this one).

If that is strictly translation table based, yes.

Thanks,

        tglx

