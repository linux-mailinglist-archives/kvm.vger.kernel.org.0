Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D094C8FF0
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 19:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbfJBR3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 13:29:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:46921 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728663AbfJBR3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 13:29:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 10:29:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,249,1566889200"; 
   d="scan'208";a="205388307"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 02 Oct 2019 10:29:44 -0700
Date:   Wed, 2 Oct 2019 10:29:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Jinpu Wang <jinpu.wang@cloud.ionos.com>, kvm@vger.kernel.org
Subject: Re: Broadwell server reboot with vmx: unexpected exit reason 0x3
Message-ID: <20191002172943.GG9615@linux.intel.com>
References: <CAMGffE=JTrCvj900OeMJQh06vogxKepRFn=7tdA965VJ9zSWow@mail.gmail.com>
 <DDC3DE27-46A3-4CB4-9AB8-C3C2F1D54777@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DDC3DE27-46A3-4CB4-9AB8-C3C2F1D54777@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 01:48:15PM +0300, Liran Alon wrote:
> 
> > On 30 Sep 2019, at 11:43, Jinpu Wang <jinpu.wang@cloud.ionos.com> wrote:
> > 
> > Dear KVM experts,
> > 
> > We have a Broadwell server reboot itself recently, before the reboot,
> > there were error messages from KVM in netconsole:
> > [5599380.317055] kvm [9046]: vcpu1, guest rIP: 0xffffffff816ad716 vmx:
> > unexpected exit reason 0x3
> > [5599380.317060] kvm [49626]: vcpu0, guest rIP: 0xffffffff81060fe6
> > vmx: unexpected exit reason 0x3
> > [5599380.317062] kvm [36632]: vcpu0, guest rIP: 0xffffffff8103970d
> > vmx: unexpected exit reason 0x3
> > [5599380.317064] kvm [9620]: vcpu1, guest rIP: 0xffffffffb6c1b08e vmx:
> > unexpected exit reason 0x3
> > [5599380.317067] kvm [49925]: vcpu5, guest rIP: 0xffffffff9b406ea2
> > vmx: unexpected exit reason 0x3
> > [5599380.317068] kvm [49925]: vcpu3, guest rIP: 0xffffffff9b406ea2
> > vmx: unexpected exit reason 0x3
> > [5599380.317070] kvm [33871]: vcpu2, guest rIP: 0xffffffff81060fe6
> > vmx: unexpected exit reason 0x3
> > [5599380.317072] kvm [49925]: vcpu4, guest rIP: 0xffffffff9b406ea2
> > vmx: unexpected exit reason 0x3
> > [5599380.317074] kvm [48505]: vcpu1, guest rIP: 0xffffffffaf36bf9b
> > vmx: unexpected exit reason 0x3
> > [5599380.317076] kvm [21880]: vcpu1, guest rIP: 0xffffffff8103970d
> > vmx: unexpected exit reason 0x3
> 
> The only way a CPU will raise this exit-reason (3 == EXIT_REASON_INIT_SIGNAL)
> is if CPU is in VMX non-root mode while it has a pending INIT signal in LAPIC.
> 
> In simple terms, it means that one CPU was running inside guest while
> another CPU have sent it a signal to reset itself.
> 
> I see in code that kvm_init() does register_reboot_notifier(&kvm_reboot_notifier).
> kvm_reboot() runs hardware_disable_nolock() on each CPU before reboot.
> Which should result on every CPU running VMX’s hardware_disable() which should
> exit VMX operation (VMXOFF) and disable VMX (Clear CR4.VMXE).
> 
> Therefore, I’m quite puzzled on how a server reboot triggers the scenario you
> present here.  Can you send your full kernel log?

My guess is that the system triggered an emergency reboot and was either
unable to force CPUs out of VMX non-root with NMIs, hit a triple fault
shutdown and auto-generated INITs before it could shootdown the other
CPUs, or didn't even attempt the NMI because VMX wasn't enabled on the
CPU that triggered reboot.

In arch/x86/kernel/reboot.c:

/* Use NMIs as IPIs to tell all CPUs to disable virtualization */
static void emergency_vmx_disable_all(void)
{
	/* Just make sure we won't change CPUs while doing this */
	local_irq_disable();

	/*
	 * We need to disable VMX on all CPUs before rebooting, otherwise
	 * we risk hanging up the machine, because the CPU ignore INIT
	 * signals when VMX is enabled.
	 *
	 * We can't take any locks and we may be on an inconsistent
	 * state, so we use NMIs as IPIs to tell the other CPUs to disable
	 * VMX and halt.
	 *
	 * For safety, we will avoid running the nmi_shootdown_cpus()
	 * stuff unnecessarily, but we don't have a way to check
	 * if other CPUs have VMX enabled. So we will call it only if the
	 * CPU we are running on has VMX enabled.
	 *
	 * We will miss cases where VMX is not enabled on all CPUs. This
	 * shouldn't do much harm because KVM always enable VMX on all
	 * CPUs anyway. But we can miss it on the small window where KVM
	 * is still enabling VMX.
	 */
	if (cpu_has_vmx() && cpu_vmx_enabled()) {
		/* Disable VMX on this CPU. */
		cpu_vmxoff();

		/* Halt and disable VMX on the other CPUs */
		nmi_shootdown_cpus(vmxoff_nmi);

	}
}

static void native_machine_emergency_restart(void)
{
	...

	if (reboot_emergency)
		emergency_vmx_disable_all();
}

