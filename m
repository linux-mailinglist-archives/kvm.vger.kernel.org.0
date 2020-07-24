Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A12B22BBD2
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 04:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgGXCDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 22:03:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:13785 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXCDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 22:03:33 -0400
IronPort-SDR: Ya6DjcfGUMu3mV/G7SYclGU48xzJG7+ZjFK8ZxMR3mHo3tZMe2ruVlwUqQLL97nsRfta2Iky2A
 1lZM1lmW/zrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="168779432"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="168779432"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 19:03:32 -0700
IronPort-SDR: Pr1rgrMC5mbPr6YgLvMqbidnCxxs8J7FMUSf+6AWg4LYJse1iVdQYLA38+llU4226NNXx46aCl
 SLOiRtFpQSNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="488578679"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jul 2020 19:03:31 -0700
Date:   Thu, 23 Jul 2020 19:03:16 -0700
From:   Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cathy Zhang <cathy.zhang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kyung Min Park <kyung.min.park@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>, fenghua.yu@intel.com
Subject: Re: [PATCH v2 1/4] x86/cpufeatures: Add enumeration for SERIALIZE
 instruction
Message-ID: <20200724020316.GA20814@ranerica-svr.sc.intel.com>
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
 <1594088183-7187-2-git-send-email-cathy.zhang@intel.com>
 <CALCETrWudiF8G8r57r5i4JefuP5biG1kHg==0O8YXb-bYS-0BA@mail.gmail.com>
 <20200708022102.GA25016@ranerica-svr.sc.intel.com>
 <87eep3ywz0.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eep3ywz0.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 23, 2020 at 01:02:43AM +0200, Thomas Gleixner wrote:
> Ricardo Neri <ricardo.neri-calderon@linux.intel.com> writes:
> > On Tue, Jul 07, 2020 at 09:36:15AM -0700, Andy Lutomirski wrote:
> >> On Mon, Jul 6, 2020 at 7:21 PM Cathy Zhang <cathy.zhang@intel.com> wrote:
> >> >
> >> > This instruction gives software a way to force the processor to complete
> >> > all modifications to flags, registers and memory from previous instructions
> >> > and drain all buffered writes to memory before the next instruction is
> >> > fetched and executed.
> >> >
> >> > The same effect can be obtained using the cpuid instruction. However,
> >> > cpuid causes modification on the eax, ebx, ecx, and ecx regiters; it
> >> > also causes a VM exit.
> >> >
> >> > A processor supports SERIALIZE instruction if CPUID.0x0x.0x0:EDX[14] is
> >> > present. The CPU feature flag is shown as "serialize" in /proc/cpuinfo.
> >> >
> >> > Detailed information on the instructions and CPUID feature flag SERIALIZE
> >> > can be found in the latest Intel Architecture Instruction Set Extensions
> >> > and Future Features Programming Reference and Intel 64 and IA-32
> >> > Architectures Software Developer's Manual.
> >> 
> >> Can you also wire this up so sync_core() uses it?
> >
> > I am cc'ing Fenghua, who has volunteered to work on this. Addind support
> > for SERIALIZE in sync_core() should not block merging these patches,
> > correct?
> 
> Come on. We are not serving KVM first before making this usable on bare
> metal.

Hi Thomas,

I ended up implementing support for SERIALIZE in sync_core() I will be
posting patches for this in the next few days.

Thanks and BR,
Ricardo
