Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6057C20DD61
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 23:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgF2Sua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 14:50:30 -0400
Received: from mga06.intel.com ([134.134.136.31]:65036 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728989AbgF2Su3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 14:50:29 -0400
IronPort-SDR: 3HsAtCcAK206/0dLM5Y5p9QJWiqL9Mqqy0uFotOEhnjUVyWY1GwetYl/z8ZXmdZhUgkRBjhvdA
 QwlWfvvtM6KA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="207497668"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="207497668"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 08:35:25 -0700
IronPort-SDR: pUypuiC+OyJPqwDrCxOgRJO5xsFjlcTMhcZ2ZIIjmeac+XqYlbQiMUEWHK8+4HTA8kW4ZtW2eT
 Jtxl6HzIG9EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="264863710"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jun 2020 08:35:25 -0700
Date:   Mon, 29 Jun 2020 08:35:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        syzbot <syzbot+e0240f9c36530bda7130@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>, joro@8bytes.org,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, vkuznets@redhat.com,
        wanpengli@tencent.com, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: KASAN: out-of-bounds Read in kvm_arch_hardware_setup
Message-ID: <20200629153524.GB12312@linux.intel.com>
References: <000000000000a0784a05a916495e@google.com>
 <04786ba2-4934-c544-63d1-4d5d36dc5822@redhat.com>
 <CAAeHK+yPbp_e9_DfRP4ikvfyMcfaveTwoVUyA+2=K3g+MvW-fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+yPbp_e9_DfRP4ikvfyMcfaveTwoVUyA+2=K3g+MvW-fA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 29, 2020 at 05:29:56PM +0200, Andrey Konovalov wrote:
> On Mon, Jun 29, 2020 at 5:25 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > The reproducer has nothing to do with KVM:
> >
> >         # https://syzkaller.appspot.com/bug?id=c356395d480ca736b00443ad89cd76fd7d209013
> >         # See https://goo.gl/kgGztJ for information about syzkaller reproducers.
> >         #{"repeat":true,"procs":1,"sandbox":"","fault_call":-1,"close_fds":false,"segv":true}
> >         r0 = openat$fb0(0xffffffffffffff9c, &(0x7f0000000180)='/dev/fb0\x00', 0x0, 0x0)
> >         ioctl$FBIOPUT_VSCREENINFO(r0, 0x4601, &(0x7f0000000000)={0x0, 0x80, 0xc80, 0x0, 0x2, 0x1, 0x4, 0x0, {0x0, 0x0, 0x1}, {0x0, 0x0, 0xfffffffc}, {}, {}, 0x0, 0x40})
> >
> > but the stack trace does.  On the other hand, the address seems okay:
> >
> >         kvm_cpu_caps+0x24/0x50
> >
> > and there are tons of other kvm_cpu_cap_get calls that aren't causing
> > KASAN to complain.  The variable is initialized from
> >
> >         kvm_arch_hardware_setup
> >           hardware_setup (in arch/x86/kvm/vmx/vmx.c)
> >             vmx_set_cpu_caps
> >               kvm_set_cpu_caps
> >
> > with a simple memcpy that writes the entire array.  Does anyone understand
> > what is going on here?
> 
> Most likely a bug in /dev/fb handlers caused a memory corruption in
> kvm related memory.

That's my assumption as well.  There's another syzbot failure[*] that points
at KVM but whose reproducer is a single FBIOPUT_VSCREENINFO.  In that case,
the pointer from "&cpu_data(smp_processor_id())" is NULL, i.e. highly unlikely
to be a KVM bug.

[*] https://lkml.kernel.org/r/000000000000077a6505a8bf57b2@google.com

> > Paolo
> >
> > On 27/06/20 22:01, syzbot wrote:
> > > BUG: KASAN: out-of-bounds in kvm_cpu_cap_get arch/x86/kvm/cpuid.h:292 [inline]
> > > BUG: KASAN: out-of-bounds in kvm_cpu_cap_has arch/x86/kvm/cpuid.h:297 [inline]
> > > BUG: KASAN: out-of-bounds in kvm_init_msr_list arch/x86/kvm/x86.c:5362 [inline]
> > > BUG: KASAN: out-of-bounds in kvm_arch_hardware_setup+0xb05/0xf40 arch/x86/kvm/x86.c:9802
> > > Read of size 4 at addr ffffffff896c3134 by task syz-executor614/6786
> > >
> > > CPU: 1 PID: 6786 Comm: syz-executor614 Not tainted 5.7.0-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > Call Trace:
> > >  <IRQ>
> > >  __dump_stack lib/dump_stack.c:77 [inline]
> > >  dump_stack+0x1e9/0x30e lib/dump_stack.c:118
> > >  print_address_description+0x66/0x5a0 mm/kasan/report.c:383
> > >  __kasan_report mm/kasan/report.c:513 [inline]
> > >  kasan_report+0x132/0x1d0 mm/kasan/report.c:530
> > >  kvm_cpu_cap_get arch/x86/kvm/cpuid.h:292 [inline]
> > >  kvm_cpu_cap_has arch/x86/kvm/cpuid.h:297 [inline]
> > >  kvm_init_msr_list arch/x86/kvm/x86.c:5362 [inline]
> > >  kvm_arch_hardware_setup+0xb05/0xf40 arch/x86/kvm/x86.c:9802
> > >  </IRQ>
> > >
> > > The buggy address belongs to the variable:
> > >  kvm_cpu_caps+0x24/0x50
> > >
> > > Memory state around the buggy address:
> > >  ffffffff896c3000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >  ffffffff896c3080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >> ffffffff896c3100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >                                         ^
> > >  ffffffff896c3180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >  ffffffff896c3200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > ==================================================================
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/04786ba2-4934-c544-63d1-4d5d36dc5822%40redhat.com.
