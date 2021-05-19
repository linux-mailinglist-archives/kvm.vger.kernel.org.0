Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E785938867A
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbhESFXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229598AbhESFXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:23:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46AE660698;
        Wed, 19 May 2021 05:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621401718;
        bh=owqbI49L+gR1rjUolKaNBsPEOJROmpMWgv4EYAKkMZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jBPu23TnD2QUYGCLa0OfojPq1t38Fk93/wvPfTJPxsvGy2WaiTFGD5/r96kc40q9e
         u5rkzYkDSlnw4oH1IBUNkQxaW27drHeR4Tb26wsCI3VfCe+MNZ007Z+Ce278oa1hcc
         51DUApCj/VFk65duD8vCSy9u2Q9vESEkfrQC2Fho=
Date:   Wed, 19 May 2021 07:21:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anup Patel <anup@brainfault.org>
Cc:     Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH v18 00/18] KVM RISC-V Support
Message-ID: <YKSgcn5gxE/4u2bT@kroah.com>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
 <YKSa48cejI1Lax+/@kroah.com>
 <CAAhSdy18qySXbUdrEsUe-KtbtuEoYrys0TcmsV2UkEA2=7UQzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhSdy18qySXbUdrEsUe-KtbtuEoYrys0TcmsV2UkEA2=7UQzw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 10:40:13AM +0530, Anup Patel wrote:
> On Wed, May 19, 2021 at 10:28 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, May 19, 2021 at 09:05:35AM +0530, Anup Patel wrote:
> > > From: Anup Patel <anup@brainfault.org>
> > >
> > > This series adds initial KVM RISC-V support. Currently, we are able to boot
> > > Linux on RV64/RV32 Guest with multiple VCPUs.
> > >
> > > Key aspects of KVM RISC-V added by this series are:
> > > 1. No RISC-V specific KVM IOCTL
> > > 2. Minimal possible KVM world-switch which touches only GPRs and few CSRs
> > > 3. Both RV64 and RV32 host supported
> > > 4. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
> > > 5. KVM ONE_REG interface for VCPU register access from user-space
> > > 6. PLIC emulation is done in user-space
> > > 7. Timer and IPI emuation is done in-kernel
> > > 8. Both Sv39x4 and Sv48x4 supported for RV64 host
> > > 9. MMU notifiers supported
> > > 10. Generic dirtylog supported
> > > 11. FP lazy save/restore supported
> > > 12. SBI v0.1 emulation for KVM Guest available
> > > 13. Forward unhandled SBI calls to KVM userspace
> > > 14. Hugepage support for Guest/VM
> > > 15. IOEVENTFD support for Vhost
> > >
> > > Here's a brief TODO list which we will work upon after this series:
> > > 1. SBI v0.2 emulation in-kernel
> > > 2. SBI v0.2 hart state management emulation in-kernel
> > > 3. In-kernel PLIC emulation
> > > 4. ..... and more .....
> > >
> > > This series can be found in riscv_kvm_v18 branch at:
> > > https//github.com/avpatel/linux.git
> > >
> > > Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v7 branch
> > > at: https//github.com/avpatel/kvmtool.git
> > >
> > > The QEMU RISC-V hypervisor emulation is done by Alistair and is available
> > > in master branch at: https://git.qemu.org/git/qemu.git
> > >
> > > To play around with KVM RISC-V, refer KVM RISC-V wiki at:
> > > https://github.com/kvm-riscv/howto/wiki
> > > https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
> > > https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike
> > >
> > > Changes since v17:
> > >  - Rebased on Linux-5.13-rc2
> > >  - Moved to new KVM MMU notifier APIs
> > >  - Removed redundant kvm_arch_vcpu_uninit()
> > >  - Moved KVM RISC-V sources to drivers/staging for compliance with
> > >    Linux RISC-V patch acceptance policy
> >
> > What is this new "patch acceptance policy" and what does it have to do
> > with drivers/staging?
> 
> The Linux RISC-V patch acceptance policy is here:
> Documentation/riscv/patch-acceptance.rst
> 
> As-per this policy, the Linux RISC-V maintainers will only accept
> patches for frozen/ratified RISC-V extensions. Basically, it links the
> Linux RISC-V development process with the RISC-V foundation
> process which is painfully slow.
> 
> The KVM RISC-V patches have been sitting on the lists for almost
> 2 years now. The requirements for freezing RISC-V H-extension
> (hypervisor extension) keeps changing and we are not clear when
> it will be frozen. In fact, quite a few people have already implemented
> RISC-V H-extension in hardware as well and KVM RISC-V works
> on real HW as well.
> 
> Rationale of moving KVM RISC-V to drivers/staging is to continue
> KVM RISC-V development without breaking the Linux RISC-V patch
> acceptance policy until RISC-V H-extension is frozen. Once, RISC-V
> H-extension is frozen we will move KVM RISC-V back to arch/riscv
> (like other architectures).

Wait, no, this has nothing to do with what drivers/staging/ is for and
how it is used.  Again, not ok.

> > What does drivers/staging/ have to do with this at all?  Did anyone ask
> > the staging maintainer about this?
> 
> Yes, Paolo (KVM maintainer) suggested having KVM RISC-V under
> drivers/staging until RISC-V H-extension is frozen and continue the
> KVM RISC-V development from there.

staging is not for stuff like this at all.  It is for code that is
self-contained (not this) and needs work to get merged into the main
part of the kernel (listed in a TODO file, and is not this).

It is not a dumping ground for stuff that arch maintainers can not seem
to agree on, and it is not a place where you can just randomly play
around with user/kernel apis with no consequences.

So no, sorry, not going to take this code at all.

gre gk-h
