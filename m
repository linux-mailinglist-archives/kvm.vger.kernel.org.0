Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DA42631F4
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgIIQbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 12:31:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:39049 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731097AbgIIQaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 12:30:35 -0400
IronPort-SDR: Fq5ViRsIB0MdMPGql18dWOKm6OpAHAx3BkD/l/wYsqxcQzcSu6iZDGPkmDokZ9r+r4cv8SlTuV
 JkgTi7jUWPjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="157642662"
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="157642662"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 09:30:35 -0700
IronPort-SDR: 2HK3ksUSQf8EagKxwJatBu384f8E1Vn9i8SUbNIoRyfpHpcQO2q7LAOJFnzZ/XrzAoLMauiWi8
 uhHixx5m9dmA==
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="505508252"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 09:30:35 -0700
Date:   Wed, 9 Sep 2020 09:30:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stsp <stsp2@yandex.ru>
Cc:     kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: Re: KVM_SET_SREGS & cr4.VMXE problems
Message-ID: <20200909163023.GA11727@sjchrist-ice>
References: <8f0d9048-c935-bccf-f7bd-58ba61759a54@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f0d9048-c935-bccf-f7bd-58ba61759a54@yandex.ru>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 09, 2020 at 01:04:45PM +0300, stsp wrote:
> Hi Guys!
> 
> I have a kvm-based hypervisor, and also I have problems with how KVM handles
> cr4.VMXE flag.
> 
> Problem 1 can be shown as follows.
> 
> The below snippet WORKS as expected:
> ---
>     sregs.cr4 |= X86_CR4_VMXE;

What is the starting value of sregs?  Not that it should matter, but it'd
be helpful to reproduce and understand the issue.

>     ret = ioctl(vcpufd, KVM_SET_SREGS, &sregs);
>     if (ret == -1) {
>       perror("KVM: KVM_SET_SREGS");
>       leavedos(99);
>     }
> ---
> 
> The below one doesn't:
> ---
>     ret = ioctl(vcpufd, KVM_SET_SREGS, &sregs);
>     if (ret == -1) {
>       perror("KVM: KVM_SET_SREGS");
>       leavedos(99);
>     }
>     sregs.cr4 |= X86_CR4_VMXE;
>     ret = ioctl(vcpufd, KVM_SET_SREGS, &sregs);
>     if (ret == -1) {
>       perror("KVM: KVM_SET_SREGS");
>       leavedos(99);
>     }
> ---
> 
> Basically that example demonstrates that I can set VMXE flag only by the very
> first call to KVM_SET_SREGS. Any subsequent calls do not allow me to modify
> VMXE flag, even though no error is returned, and other flags are modified, if
> needed, as expected, but not this one.  Is there any reason why VMXE flag is
> "locked" to its very first setting?

IIUC, in the above snippet, you observe that "ret == 0" but rereading sregs
shows the old CR4 value?

The direct cause of the weirdness is a KVM bug in KVM_SET_SREGS where it
doesn't check the return of vendor specific handling (VMX vs. SVM) of setting
CR4.  In this specific case, odds are good you're running afould of the check
that disallows VMXE=1 if nested virtualization is not supported for the VM.

As to why only the second variant fails, KVM_SET_REGS triggers a CPUID update
for the guest, which will reevaluate whether or not the guest supports nested
virtualization.  In theory, that could trigger the behavior you're seeing,
though I would expect guest CPUID to be accurate before the first
KVM_SET_SREGS.  So short answer, I have no idea :-)
 
> Problem 2:
> If I set both VME and VMXE flags (by the very first invocation of
> KVM_SET_SREGS, yes), then VME flag does not actually work. My hypervisor then
> runs in non-VME mode.  Is it KVM that clears the VME flag when VMXE is set,
> or is it really not a workable combination of flags?

What do you mean by "My hypervisor runs in non-VME mode"?  I assume you mean
the guest is in non-VME mode?  Or do you really mean CR4.VME in the host?

If you're referring to the guest, what CPU generation are you running?  From
the above descriptions, it sounds like you're on Nehalem (first gen Core) or
earlier (e.g. Core2).  I ask because the answer gets quite complicated if
you're running on hardware without support for unrestricted guest.

If you're talking about host CR4, when do you observe CR4.VME being cleared?
KVM is supposed to preserve the current CR4 value for the host.

> Problem 3.
> Some older Intel CPUs appear to require the VMXE flag even in non-root VMX.
> This is vaguely documented in an Intel specs:
> ---
> The first processors to support VMX operation require that the
> following bits be 1 in VMX operation: CR0.PE, CR0.NE, CR0.PG, and CR4.VMXE.
> ---
> 
> They are not explicit about a non-root mode, but my experiments show they
> meant exactly that. On such CPUs, KVM otherwise returns KVM_EXIT_FAIL_ENTRY,
> "invalid guest state".

Do you have emulate_invalid_guest_state disabled?

> Question: did they really mean non-root, and if so - shouldn't KVM itself
> work around such quirks?

Yes, it really does include non-root.  On CPUs without unrestricted guest,
the world switch to non-root is less complete, for lack of a better term.
Non-root without unrestricted guest requires the CPU to be in protected mode
with paging enabled as the CPU isn't capable of properly virtualizing things
if paging is disabled.  CR4.VMXE=1 is always required, even on modern CPUs.

However, those are the _hardware_ values of CR4, not the guest value of CR4,
i.e. the value visible to the guest is different than the actual value in
hardware.  And KVM_SET_SREGS operates on the _guest_ value, KVM always has
final say on the hardware value.

Note, the hardware value when running in the guest (non-root) will be very
different than the hardware value when running in the host (root), e.g. MCE
is the only CR4 bit that is explicitly propagated to the hardware value for
the guest, all other bits (including VME) are recomputed based on CPU
capabilities, KVM module params, and guest state.

> I wouldn't mind enabling VMXE myself, if not for the Problem 2 above, that
> just disables VME then.  Can KVM be somehow "fixed" to not require all these
> dancing, or is there a better ways of fixing that problem?

Can you rewind and describe your original problem?  It sounds like you're
trying to do something very specific on old hardware, encountered an error,
and then built up a pile of workarounds that led you into more issues that
aren't directly related to the original problem.
