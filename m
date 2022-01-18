Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1516492696
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 14:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242359AbiARNMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 08:12:37 -0500
Received: from foss.arm.com ([217.140.110.172]:56324 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242186AbiARNMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 08:12:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 924751FB;
        Tue, 18 Jan 2022 05:12:31 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.37.52])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 258C03F73D;
        Tue, 18 Jan 2022 05:12:26 -0800 (PST)
Date:   Tue, 18 Jan 2022 13:12:23 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        aleksandar.qemu.devel@gmail.com, alexandru.elisei@arm.com,
        anup.patel@wdc.com, aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
        chenhuacai@kernel.org, dave.hansen@linux.intel.com,
        david@redhat.com, frankja@linux.ibm.com, frederic@kernel.org,
        gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        james.morse@arm.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, maz@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, nsaenzju@redhat.com, palmer@dabbelt.com,
        paulmck@kernel.org, paulus@samba.org, paul.walmsley@sifive.com,
        seanjc@google.com, suzuki.poulose@arm.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: Re: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
Message-ID: <20220118131223.GC17938@C02TD0UTHF1T.local>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <127a6117-85fb-7477-983c-daf09e91349d@linux.ibm.com>
 <YeFqUlhqY+7uzUT1@FVFF77S0Q05N>
 <ae1a42ab-f719-4a4e-8d2a-e2b4fa6e9580@linux.ibm.com>
 <YeF7Wvz05JhyCx0l@FVFF77S0Q05N>
 <b66c4856-7826-9cff-83f3-007d7ed5635c@linux.ibm.com>
 <YeGUnwhbSvwJz5pD@FVFF77S0Q05N>
 <8aa0cada-7f00-47b3-41e4-8a9e7beaae47@redhat.com>
 <20220118120154.GA17938@C02TD0UTHF1T.local>
 <6b6b8a2b-202c-8966-b3f7-5ce35cf40a7e@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b6b8a2b-202c-8966-b3f7-5ce35cf40a7e@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022 at 01:42:26PM +0100, Christian Borntraeger wrote:
> 
> 
> Am 18.01.22 um 13:02 schrieb Mark Rutland:
> > On Mon, Jan 17, 2022 at 06:45:36PM +0100, Paolo Bonzini wrote:
> > > On 1/14/22 16:19, Mark Rutland wrote:
> > > > I also think there is another issue here. When an IRQ is taken from SIE, will
> > > > user_mode(regs) always be false, or could it be true if the guest userspace is
> > > > running? If it can be true I think tha context tracking checks can complain,
> > > > and it*might*  be possible to trigger a panic().
> > > 
> > > I think that it would be false, because the guest PSW is in the SIE block
> > > and switched on SIE entry and exit, but I might be incorrect.
> > 
> > Ah; that's the crux of my confusion: I had thought the guest PSW would
> > be placed in the regular lowcore *_old_psw slots. From looking at the
> > entry asm it looks like the host PSW (around the invocation of SIE) is
> > stored there, since that's what the OUTSIDE + SIEEXIT handling is
> > checking for.
> > 
> > Assuming that's correct, I agree this problem doesn't exist, and there's
> > only the common RCU/tracing/lockdep management to fix.
> 
> Will you provide an s390 patch in your next iteration or shall we then do
> one as soon as there is a v2? We also need to look into vsie.c where we
> also call sie64a

I'm having a go at that now; my plan is to try to have an s390 patch as
part of v2 in the next day or so.

Now that I have a rough idea of how SIE and exception handling works on
s390, I think the structural changes to kvm-s390.c:__vcpu_run() and
vsie.c:do_vsie_run() are fairly simple.

The only open bit is exactly how/where to identify when the interrupt
entry code needs to wake RCU. I can add a per-cpu variable or thread
flag to indicate that we're inside that EQS, or or I could move the irq
enable/disable into the sie64a asm and identify that as with the OUTSIDE
macro in the entry asm.

Thanks,
Mark.
