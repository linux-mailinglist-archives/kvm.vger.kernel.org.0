Return-Path: <kvm+bounces-37224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D11B5A2700F
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 12:16:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57E93162CD0
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 11:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0C4220C03C;
	Tue,  4 Feb 2025 11:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uooEPmfC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD39820C000;
	Tue,  4 Feb 2025 11:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738667749; cv=none; b=SAUGWU1RKixXWqxaE+yMFbCGUzijbDXcYUjg6bKhRG4cm4gTF4qiXmRZyDNd59DxbuuhauHiYm964Al8z0sP6h/XH7SgZZZeZO+hOHsHXnF2S9ccmekf2mnZsU3fy5EHcqbJDD+XWH9jr1f6ZYO/ICPfGcGJqf0pLzLWcLP3ZQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738667749; c=relaxed/simple;
	bh=foF5/Wox8o8Vj4aKouN9RTcWHNUEL2b3SgpKataU7sI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/WBJDMeunylNXTGnVii+/uHo4Ejkeu9cRbBcxXM5P0tkbqZiaiVV3jZZ/XMtLir31GIzJcJE7PhvahAKSokJcJDcQVevPc2DesRww9lCMCYuRjSSVpfDZKh1bwauzQD2mSGhHx3K9KQUf7il2KL3ynYf+RmYHTFatjkB9S3zwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uooEPmfC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B788EC4CEE4;
	Tue,  4 Feb 2025 11:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738667748;
	bh=foF5/Wox8o8Vj4aKouN9RTcWHNUEL2b3SgpKataU7sI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uooEPmfCusttpDyHJEg608Hc5ugHIrXaIDxVUjoPRVpMfCZwHQZg339udcElSMLlX
	 Q8HF2g/2mu58RtwnjcNIE53uY3EoVZD9sd1nZqivO5Isy8eod9dt+g094xdFdkG32p
	 VdPuV8Gaa8LDFoKyU/ox88Fi7WfN1LUXRGsqax8ly9IbZERod6b1zRFdD2qTdHrbGq
	 wU54ldJbRNbH3n0ZsGuAiEypZmgYImqsT9HEYCe2qq5GzRB6URqb2QPkS4AV4JwfAS
	 M0pR0fJ2wCpijucganac21/HHPirlT9cya3URl1yXsbwlm3eZi9tXKm+zevPEMfUTr
	 JBBfOGAzrNBqw==
Date: Tue, 4 Feb 2025 16:36:14 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from
 apicv_inhibit_reasons
Message-ID: <uroh6wvlhfj4whlf2ull4iob6k7nr4igeplcfvax7nksav6mtf@ek5ja23dkjtn>
References: <cover.1738595289.git.naveen@kernel.org>
 <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com>
 <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
 <Z6FVaLOsPqmAPNWu@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6FVaLOsPqmAPNWu@google.com>

On Mon, Feb 03, 2025 at 03:46:48PM -0800, Sean Christopherson wrote:
> On Mon, Feb 03, 2025, Paolo Bonzini wrote:
> > On 2/3/25 19:45, Sean Christopherson wrote:
> > > Unless there's a very, very good reason to support a use case that generates
> > > ExtInts during boot, but _only_ during boot, and otherwise doesn't have any APICv
> > > ihibits, I'm leaning towards making SVM's IRQ window inhibit sticky, i.e. never
> > > clear it.
> > 
> > BIOS tends to use PIT, so that may be too much.  With respect to Naveen's report
> > of contention on apicv_update_lock, I would go with the sticky-bit idea but apply
> > it to APICV_INHIBIT_REASON_PIT_REINJ.
> 
> That won't work, at least not with yet more changes, because KVM creates the
> in-kernel PIT with reinjection enabled by default.  The stick-bit idea is that
> if a bit is set and can never be cleared, then there's no need to track new
> updates.  Since userspace needs to explicitly disable reinjection, the inhibit
> can't be sticky.
> 
> I assume We could fudge around that easily enough by deferring the inhibit until
> a vCPU is created (or run?), but piggybacking PIT_REINJ won't help the userspace
> I/O APIC case.

As a separate change, I have been testing a patch that moves the 
PIT_REINJ inhibit from PIT creation to the point at which the guest 
actually programs it so that default guest configurations can utilize 
AVIC:

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index cd57a517d04a..8f959de7ff32 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -235,6 +235,7 @@ static void destroy_pit_timer(struct kvm_pit *pit)
 {
        hrtimer_cancel(&pit->pit_state.timer);
        kthread_flush_work(&pit->expired);
+       kvm_clear_apicv_inhibit(pit->kvm, APICV_INHIBIT_REASON_PIT_REINJ);
 }
 
 static void pit_do_work(struct kthread_work *work)
@@ -296,22 +297,12 @@ void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject)
        if (atomic_read(&ps->reinject) == reinject)
                return;
 
-       /*
-        * AMD SVM AVIC accelerates EOI write and does not trap.
-        * This cause in-kernel PIT re-inject mode to fail
-        * since it checks ps->irq_ack before kvm_set_irq()
-        * and relies on the ack notifier to timely queue
-        * the pt->worker work iterm and reinject the missed tick.
-        * So, deactivate APICv when PIT is in reinject mode.
-        */
        if (reinject) {
-               kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PIT_REINJ);
                /* The initial state is preserved while ps->reinject == 0. */
                kvm_pit_reset_reinject(pit);
                kvm_register_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
                kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
        } else {
-               kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PIT_REINJ);
                kvm_unregister_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
                kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
        }
@@ -358,6 +349,16 @@ static void create_pit_timer(struct kvm_pit *pit, u32 val, int is_period)
                }
        }
 
+       /*
+        * AMD SVM AVIC accelerates EOI write and does not trap. This causes
+        * in-kernel PIT re-inject mode to fail since it checks ps->irq_ack
+        * before kvm_set_irq() and relies on the ack notifier to timely queue
+        * the pt->worker work item and reinject the missed tick. So,
+        * deactivate APICv when PIT is in reinject mode, but only when the
+        * timer is actually armed.
+        */
+       kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PIT_REINJ);
+
        hrtimer_start(&ps->timer, ktime_add_ns(ktime_get(), interval),
                      HRTIMER_MODE_ABS);
 }


Is that reasonable?

If it is, or if we choose to delay PIT_REINJ inhibit to vcpu creation time, 
then making PT_REINJ or IRQWIN inhibits sticky will prevent AVIC from being 
enabled later on. I can see in my tests that BIOS (both seabios and edk2) 
programs the PIT though Linux guest itself doesn't (unless -no-hpet is used).  
The above change will allow AVIC to be used in Linux guests even when a PIT is 
present.

> 
> > I don't love adding another inhibit reason but, together, these two should
> > remove the contention on apicv_update_lock.  Another idea could be to move
> > IRQWIN to per-vCPU reason but Maxim tells me that it's not so easy.
> 
> Oh, yeah, that reminds me of the other reason I would vote for a sticky flag:
> if inhibition really is toggling rapidly, performance is going to be quite bad
> because inhibiting APICv requires (a) zapping APIC SPTEs and (b) serializing
> writers if multiple vCPUs trigger the 0=>1 transition.
> 
> And there's some amount of serialization even if there's only a single writer,
> as KVM kicks all vCPUs to toggle APICv (and again to flush TLBs, if necessary).
> 
> Hmm, something doesn't add up.  Naveen's changelog says:
> 
>   KVM additionally inhibits AVIC for requesting a IRQ window every time it has
>   to inject external interrupts resulting in a barrage of inhibits being set and
>   cleared. This shows significant performance degradation compared to AVIC being
>   disabled, due to high contention on apicv_update_lock.
> 
> But if this is a "real world" use case where the only source of ExtInt is the
> PIT, and kernels typically only wire up the PIT to the BSP, why is there
> contention on apicv_update_lock?  APICv isn't actually being toggled, so readers
> blocking writers to handle KVM_REQ_APICV_UPDATE shouldn't be a problem.
> 
> Naveen, do you know why there's a contention on apicv_update_lock?  Are multiple
> vCPUs actually trying to inject ExtInt?

Apologies for the confusion, I should probably have said "device 
interrupts" (sorry, I'm still trying to get my terminology right). I 
have described the test scenario in the cover letter, but to add more 
details: the test involves two guests on the same host (using network 
tap devices with vhost and mq) with one guest running netperf TCP_RR to 
the other guest. Trimmed qemu command:

qemu-system-x86_64 -machine q35,accel=kvm,kernel-irqchip=on \
  -smp 16,cores=8,threads=2 -cpu host,topoext=on,x2apic=on -m 32G \
  -drive file=~/ubuntu_vm1.img,if=virtio,format=qcow2 \
  -netdev tap,id=v0,br=virbr0,script=~/qemu-ifup,downscript=~/qemu-ifdown,vhost=on,queues=16 \
  -device virtio-net-pci,netdev=v0,mac=52:54:00:12:34:11,mq=on,vectors=34

So, not a real world workload per se, though there may be use cases for guests 
having to handle large number of packets.

You're right -- APICv isn't actually being toggled, but IRQWIN inhibit is 
constantly being set and cleared while trying to inject device interrupts into 
the guests. The places where we set/clear IRQWIN inhibit has comments 
indicating that it is only required for ExtINT, though that's not actually the 
case here.

What is actually happening is that since the PIT is in reinject mode, APICv is 
not active in the guest. When that happens, kvm_cpu_has_injectable_intr() 
returns true when any interrupt is pending:

    /*
     * check if there is injectable interrupt:
     * when virtual interrupt delivery enabled,
     * interrupt from apic will handled by hardware,
     * we don't need to check it here.
     */
    int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v)
    {
	    if (kvm_cpu_has_extint(v))
		    return 1;

	    if (!is_guest_mode(v) && kvm_vcpu_apicv_active(v))
		    return 0;

	    return kvm_apic_has_interrupt(v) != -1; /* LAPIC */
    }

The second if condition fails since APICv is not active. So, 
kvm_check_and_inject_events() calls enable_irq_window() to request for an IRQ 
window to inject those interrupts. That results in all vCPUs trying to acquire 
apicv_update_lock for updating the inhibit reason, though APICv state itself 
isn't changing and we are not requesting for KVM_REQ_APICV_UPDATE.


Thanks,
Naveen


