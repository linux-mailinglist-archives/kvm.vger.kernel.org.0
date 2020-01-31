Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE4C14F2FE
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 21:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgAaUBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 15:01:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:39358 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbgAaUBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 15:01:35 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 12:01:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,387,1574150400"; 
   d="scan'208";a="262661544"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jan 2020 12:01:34 -0800
Date:   Fri, 31 Jan 2020 12:01:34 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     David Laight <David.Laight@aculab.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86: Emulate split-lock access as a write
Message-ID: <20200131200134.GD18946@linux.intel.com>
References: <db3b854fd03745738f46cfce451d9c98@AcuMS.aculab.com>
 <777C5046-B9DE-4F8C-B04F-28A546AE4A3F@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <777C5046-B9DE-4F8C-B04F-28A546AE4A3F@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 30, 2020 at 07:16:24AM -0800, Andy Lutomirski wrote:
> 
> > On Jan 30, 2020, at 4:31 AM, David Laight <David.Laight@aculab.com> wrote:
> > 
> >> If split lock detect is enabled (warn/fatal), #AC handler calls die()
> >> when split lock happens in kernel.
> >> 
> >> A sane guest should never tigger emulation on a split-lock access, but
> >> it cannot prevent malicous guest from doing this. So just emulating the
> >> access as a write if it's a split-lock access to avoid malicous guest
> >> polluting the kernel log.
> > 
> > That doesn't seem right if, for example, the locked access is addx.
> > ISTM it would be better to force an immediate fatal error of some
> > kind than just corrupt the guest memory.
> 
> The existing page-spanning case is just as wrong.

Yes, it's a deliberate shortcut to handle a corner case that no real world
workload will ever trigger[*].  The split-lock #AC case is the same.
Actually, it's significantly less likely than the page-split case.

With a sane, non-malicious guest, the emulator code in question only gets
triggered if unrestricted guest is supported.  Without unrestricted guest,
there are certain modes, e.g. Big Real Mode, where VM-Enter will fail, in
which case KVM needs to emulate the entire guest code stream until the
guest transitions back to a valid mode (from VMX perspective).  When
unrestricted guest is enabled, the emulator is only invoked for MMIO,
I/O strings, and for some instructions that are emulated on #UD to allow
migrating VMs between hosts without heterogenous CPU capabilities.

Unrestricted guest is supported on all Intel CPUs since Westmere, and will
be supported on all CPUs that support split-lock #AC and VMX.  Except for
a few esoteric use cases where using shadow paging is more performant than
using EPT, there is zero benefit to disabling unrestricted guest, whereas
enabling unrestricted guest provides additional performance and security.

In other words, the odds of a sane, non-malicious guest executing a split-
lock instruction that needs to be emulated by KVM are basically zilch.

The reason the emulator needs to handle this case at all is because a
malicious guest could play TLB games to trick KVM into emulating a split-
lock instruction, e.g. get the guest's translation for RIP pointing at a
string I/O instruction to trigger VM-Exit, but have the host translation
point at a completely different instruction.  With split-lock #AC enable
in the host, that would cause a kernel split-lock #AC and panic the whole
system.

Exiting to host userspace with "emulation failed" is the other reasonable
alternative, but that's basically the same as killing the guest.  We're
arguing that, in the extremely unlikely event that there is a workload out
there that hits this, it's preferable to *maybe* corrupt guest memory and
log the anomaly in the kernel log, as opposed to outright killing the guest
with a generic "emulation failed".

Looking forward, the other reason for taking this shortcut is to easily
handle the case where KVM adds support for exposing split-lock #AC to the
guest.  With this approach, we don't have to teach the emulator how to
query for split-lock #AC enabling in the guest.  Again, in the interest of
not adding code to the emulator that is effectively useless.

[*] https://lkml.kernel.org/r/c8b2219b-53d5-38d2-3407-2476b45500eb@redhat.com
