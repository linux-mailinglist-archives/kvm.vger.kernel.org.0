Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8931B771B
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 15:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgDXNhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 09:37:52 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:35716 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726301AbgDXNhu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 09:37:50 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 734C42E147E;
        Fri, 24 Apr 2020 16:37:45 +0300 (MSK)
Received: from myt4-18a966dbd9be.qloud-c.yandex.net (myt4-18a966dbd9be.qloud-c.yandex.net [2a02:6b8:c00:12ad:0:640:18a9:66db])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id JZcvDwKanJ-bineFWlf;
        Fri, 24 Apr 2020 16:37:45 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1587735465; bh=p1tmmGFmqS8FsDtSNmv79qCz8OSl/ASvcOCn5/WI97k=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=O9XwE86nGpR7CI3COomMlYzjzjWocAsx5/4xvwFqx9znu/xd1GIIbY6p87jTFgGP1
         IVGMS4V8OaqIFGG4ajoYxWTDqkJ5aVFODuzAcls6iXXOvQaq4s5gmCtiEvYbaUHaBN
         dTP5qN3+mubvXYHL+iwa+pnGLGZPgSjE0r+uT1K0=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:1404::1:d])
        by myt4-18a966dbd9be.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id v2wwRZyTHF-biXmYwTc;
        Fri, 24 Apr 2020 16:37:44 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Fri, 24 Apr 2020 16:37:42 +0300
From:   Roman Kagan <rvkagan@yandex-team.ru>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200424133742.GA2439920@rvkaganb>
Mail-Followup-To: Roman Kagan <rvkagan@yandex-team.ru>,
        Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
References: <20200416083847.1776387-1-arilou@gmail.com>
 <20200416120040.GA3745197@rvkaganb>
 <20200416125430.GL7606@jondnuc>
 <20200417104251.GA3009@rvkaganb>
 <20200418064127.GB1917435@jondnuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200418064127.GB1917435@jondnuc>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 18, 2020 at 09:41:27AM +0300, Jon Doron wrote:
> On 17/04/2020, Roman Kagan wrote:
> > On Thu, Apr 16, 2020 at 03:54:30PM +0300, Jon Doron wrote:
> > > On 16/04/2020, Roman Kagan wrote:
> > > > On Thu, Apr 16, 2020 at 11:38:46AM +0300, Jon Doron wrote:
> > > > > According to the TLFS:
> > > > > "A write to the end of message (EOM) register by the guest causes the
> > > > > hypervisor to scan the internal message buffer queue(s) associated with
> > > > > the virtual processor.
> > > > >
> > > > > If a message buffer queue contains a queued message buffer, the hypervisor
> > > > > attempts to deliver the message.
> > > > >
> > > > > Message delivery succeeds if the SIM page is enabled and the message slot
> > > > > corresponding to the SINTx is empty (that is, the message type in the
> > > > > header is set to HvMessageTypeNone).
> > > > > If a message is successfully delivered, its corresponding internal message
> > > > > buffer is dequeued and marked free.
> > > > > If the corresponding SINTx is not masked, an edge-triggered interrupt is
> > > > > delivered (that is, the corresponding bit in the IRR is set).
> > > > >
> > > > > This register can be used by guests to poll for messages. It can also be
> > > > > used as a way to drain the message queue for a SINTx that has
> > > > > been disabled (that is, masked)."
> > > >
> > > > Doesn't this work already?
> > > >
> > > 
> > > Well if you dont have SCONTROL and a GSI associated with the SINT then it
> > > does not...
> > 
> > Yes you do need both of these.
> > 
> > > > > So basically this means that we need to exit on EOM so the hypervisor
> > > > > will have a chance to send all the pending messages regardless of the
> > > > > SCONTROL mechnaisim.
> > > >
> > > > I might be misinterpreting the spec, but my understanding is that
> > > > SCONTROL {en,dis}ables the message queueing completely.  What the quoted
> > > > part means is that a write to EOM should trigger the message source to
> > > > push a new message into the slot, regardless of whether the SINT was
> > > > masked or not.
> > > >
> > > > And this (I think, haven't tested) should already work.  The userspace
> > > > just keeps using the SINT route as it normally does, posting
> > > > notifications to the corresponding irqfd when posting a message, and
> > > > waiting on the resamplerfd for the message slot to become free.  If the
> > > > SINT is masked KVM will skip injecting the interrupt, that's it.
> > > >
> > > > Roman.
> > > 
> > > That's what I was thinking originally as well, but then i noticed KDNET as a
> > > VMBus client (and it basically runs before anything else) is working in this
> > > polling mode, where SCONTROL is disabled and it just loops, and if it saw
> > > there is a PENDING message flag it will issue an EOM to indicate it has free
> > > the slot.
> > 
> > Who sets up the message page then?  Doesn't it enabe SCONTROL as well?
> > 
> 
> KdNet is the one setting the SIMP and it's not setting the SCONTROL, ill
> paste output of KVM traces for the relevant MSRs
> 
> > Note that, even if you don't see it being enabled by Windows, it can be
> > enabled by the firmware and/or by the bootloader.
> > 
> > Can you perhaps try with the SeaBIOS from
> > https://src.openvz.org/projects/UP/repos/seabios branch hv-scsi?  It
> > enables SCONTROL and leaves it that way.
> > 
> > I'd also suggest tracing kvm_msr events (both reads and writes) for
> > SCONTROL and SIMP msrs, to better understand the picture.
> > 
> > So far the change you propose appears too heavy to work around the
> > problem of disabled SCONTROL.  You seem to be better off just making
> > sure it's enabled (either by the firmware or slighly violating the spec
> > and initializing to enabled from the start), and sticking to the
> > existing infrastructure for posting messages.
> > 
> 
> I guess there is something I'm missing here but let's say the BIOS would
> have set the SCONTROL but the OS is not setting it, who is in charge of
> handling the interrupts?

SCONTROL doesn't enable the interrupts, it enables SynIC as a whole.
The interrupts are enabled via individual SINTx msrs.  This SeaBIOS
branch does exactly this: it enables the SynIC via SCONTROL, and then
specific SynIC functionality via SIMP/SIEFP, but doesn't activate SINTx
and works in polling mode.

I agree that this global SCONTROL switch seems redundant but it appears
to match the spec.

> > > (There are a bunch of patches i sent on the QEMU mailing list as well  where
> > > i CCed you, I will probably revise it a bit but was hoping to get  KVM
> > > sorted out first).
> > 
> > I'll look through the archive, should be there, thanks.
> > 
> > Roman.
> 
> I tried testing with both the SeaBIOS branch you have suggested and the
> EDK2, unfortunately I could not get the EDK2 build to identify my VM drive
> to boot from (not sure why)
> 
> Here is an output of KVM trace for the relevant MSRs (SCONTROL and SIMP)
> 
> QEMU Default BIOS
> -----------------
>  qemu-system-x86-613   [000] ....  1121.080722: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
>  qemu-system-x86-613   [000] ....  1121.080722: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
>  qemu-system-x86-613   [000] .N..  1121.095592: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
>  qemu-system-x86-613   [000] .N..  1121.095592: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
> Choose Windows DebugEntry
>  qemu-system-x86-613   [001] ....  1165.185227: kvm_msr: msr_read 40000083 = 0x0
>  qemu-system-x86-613   [001] ....  1165.185255: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1001 host 0
>  qemu-system-x86-613   [001] ....  1165.185255: kvm_msr: msr_write 40000083 = 0xfa1001
>  qemu-system-x86-613   [001] ....  1165.193206: kvm_msr: msr_read 40000083 = 0xfa1001
>  qemu-system-x86-613   [001] ....  1165.193236: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1000 host 0
>  qemu-system-x86-613   [001] ....  1165.193237: kvm_msr: msr_write 40000083 = 0xfa1000
> 
> 
> SeaBIOS hv-scsci
> ----------------
>  qemu-system-x86-656   [001] ....  1313.072714: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
>  qemu-system-x86-656   [001] ....  1313.072714: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1
>  qemu-system-x86-656   [001] ....  1313.087752: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x0 host 1
>  qemu-system-x86-656   [001] ....  1313.087752: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 1

Initialization (host == 1)

>  qemu-system-x86-656   [001] ....  1313.156675: kvm_msr: msr_read 40000083 = 0x0
>  qemu-system-x86-656   [001] ....  1313.156680: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x7fffe001 host 0
> Choose Windows DebugEntry

I guess this is a bit misplaced timewise, BIOS is still working here

>  qemu-system-x86-656   [001] ....  1313.156680: kvm_msr: msr_write 40000083 = 0x7fffe001

BIOS sets up message page

>  qemu-system-x86-656   [001] ....  1313.162111: kvm_msr: msr_read 40000080 = 0x0
>  qemu-system-x86-656   [001] ....  1313.162118: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000080 data 0x1 host 0
>  qemu-system-x86-656   [001] ....  1313.162119: kvm_msr: msr_write 40000080 = 0x1

BIOS activates SCONTROL

>  qemu-system-x86-656   [001] ....  1313.246758: kvm_msr: msr_read 40000083 = 0x7fffe001
>  qemu-system-x86-656   [001] ....  1313.246764: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0x0 host 0
>  qemu-system-x86-656   [001] ....  1313.246764: kvm_msr: msr_write 40000083 = 0x0

BIOS clears message page (it's not needed once the VMBus device was
brought up)

I guess the choice of Windows DebugEntry appeared somewhere here.

>  qemu-system-x86-656   [001] ....  1348.904727: kvm_msr: msr_read 40000083 = 0x0
>  qemu-system-x86-656   [001] ....  1348.904771: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1001 host 0
>  qemu-system-x86-656   [001] ....  1348.904772: kvm_msr: msr_write 40000083 = 0xfa1001

Bootloader (debug stub?) sets up the message page

>  qemu-system-x86-656   [001] ....  1348.919170: kvm_msr: msr_read 40000083 = 0xfa1001
>  qemu-system-x86-656   [001] ....  1348.919183: kvm_hv_synic_set_msr: vcpu_id 0 msr 0x40000083 data 0xfa1000 host 0
>  qemu-system-x86-656   [001] ....  1348.919183: kvm_msr: msr_write 40000083 = 0xfa1000

Message page is being disabled again.

I guess you only filtered SCONTROL and SIMP, skipping e.g. SVERSION,
GUEST_OS_ID, HYPERCALL, etc., which are also part of the exchange here.

>  I could not get the EDK2 setup to work though
>  (https://src.openvz.org/projects/UP/repos/edk2 branch hv-scsi)
> 
> It does not detect my VM hard drive not sure why (this is how i  configured
> it:
>  -drive file=./win10.qcow2,format=qcow2,if=none,id=drive_disk0 \
>  -device virtio-blk-pci,drive=drive_disk0 \
> 
> (Is there something special i need to configure it order for it to  work?, I
> tried building EDK2 with and without SMM_REQUIRE and  SECURE_BOOT_ENABLE)

No special configuration I can think of.

> But in general it sounds like there is something I dont fully understand
> when SCONTROL is enabled, then a GSI is associated with this SintRoute.
> 
> Then when the guest triggers an EOI via the APIC we will trigger the GSI
> notification, which will give us another go on trying to copy the message
> into it's slot.

Right.

> So is it the OS that is in charge of setting the EOI?

Yes.

> If so then it needs to
> be aware of SCONTROL being enabled and just having it left set by the BIOS
> might not be enough?

Yes it needs to be aware of SCONTROL being enabled.  However, this
awareness may be based on a pure assumption that the previous entity
(BIOS or bootloader) did it already.

> Also in the TLFS (looking at v6) they mention that message queueing has "3
> exit conditions", which will cause the hypervisor to try and attempt to
> deliver the additional messages.
> 
> The 3 exit conditions they refer to are:
> * Another message buffer is queued.
> * The guest indicates the “end of interrupt” by writing to the APIC’s   EOI
> register.
> * The guest indicates the “end of message” by writing to the SynIC’s EOM
> register.
> 
> Also notice this additional exit is only if there is a pending message and
> not for every EOM.

This meaning of "exit" doesn't trivially correspond to what we have in
KVM.  A write to an msr does cause a vmexit.  Then KVM notifies resample
eventfds for all SINTs that have them set up, no matter if there's a
pending message in the slot.  It may be slightly more optimal to only
notify those having indicated a pending message, but I don't see the
current behavior break anything or violate the spec, so, as EOMs are not
used on fast paths, I woudn't bother optimizing.

Roman.
