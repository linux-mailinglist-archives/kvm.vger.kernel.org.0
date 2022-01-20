Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63FA494602
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 04:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbiATDSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 22:18:17 -0500
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:59392 "EHLO
        ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbiATDSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 22:18:16 -0500
X-Greylist: delayed 1042 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2022 22:18:16 EST
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: https://help.uis.cam.ac.uk/email-scanner-virus
Received: from hades.srcf.societies.cam.ac.uk ([131.111.179.67]:49372)
        by ppsw-33.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.137]:25)
        with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        id 1nANgO-0005zr-iJ (Exim 4.95)
        (return-path <amc96@srcf.net>);
        Thu, 20 Jan 2022 03:00:16 +0000
Received: from [192.168.1.10] (host-92-12-61-86.as13285.net [92.12.61.86])
        (Authenticated sender: amc96)
        by hades.srcf.societies.cam.ac.uk (Postfix) with ESMTPSA id 5EA821FBFF;
        Thu, 20 Jan 2022 03:00:16 +0000 (GMT)
Message-ID: <f3239ec0-9fb8-722a-00c5-11b18f19f047@srcf.net>
Date:   Thu, 20 Jan 2022 03:00:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-GB
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andrew Cooper <amc96@srcf.net>
References: <20220120000624.655815-1-seanjc@google.com>
From:   Andrew Cooper <amc96@srcf.net>
Subject: Re: [PATCH] KVM: VMX: Set vmcs.PENDING_DBG.BS on #DB in STI/MOVSS
 blocking shadow
In-Reply-To: <20220120000624.655815-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 00:06, Sean Christopherson wrote:
> Set vmcs.GUEST_PENDING_DBG_EXCEPTIONS.BS, a.k.a. the pending single-step
> breakpoint flag, when re-injecting a #DB with RFLAGS.TF=1, and STI or
> MOVSS blocking is active.  Setting the flag is necessary to make VM-Entry
> consistency checks happy, as VMX has an invariant that if RFLAGS.TF is
> set and STI/MOVSS blocking is true, then the previous instruction must
> have been STI or MOV/POP, and therefore a single-step #DB must be pending
> since the RFLAGS.TF cannot have been set by the previous instruction,
> i.e. the one instruction delay after setting RFLAGS.TF must have already
> expired.
>
> Normally, the CPU sets vmcs.GUEST_PENDING_DBG_EXCEPTIONS.BS appropriately
> when recording guest state as part of a VM-Exit, but #DB VM-Exits
> intentionally do not treat the #DB as "guest state" as interception of
> the #DB effectively makes the #DB host-owned, thus KVM needs to manually
> set PENDING_DBG.BS when forwarding/re-injecting the #DB to the guest.

The problem is that none of this is documented.

Amongst other things, the vmentry consistency check misses the case when
#DB really is pending in ENTRY_INTR_INFO.


It is very clear that to use VT-x/SVM correctly, required reading
includes the core microcode and RTL, which of course all of us have
access to...

> Note, although this bug can be triggered by guest userspace, doing so
> requires IOPL=3, and guest userspace running with IOPL=3 has full access
> to all I/O ports (from the guest's perspective) and can crash/reboot the
> guest any number of ways.  IOPL=3 is required because STI blocking kicks
> in if and only if RFLAGS.IF is toggled 0=>1, and if CPL>IOPL, STI either
> takes a #GP or modifies RFLAGS.VIF, not RFLAGS.IF.
>
> MOVSS blocking can be initiated by userspace, but can be coincident with
> a #DB if and only if DR7.GD=1 (General Detect enabled) and a MOV DR is
> executed in the MOVSS shadow.  MOV DR #GPs at CPL>0, thus MOVSS blocking
> is problematic only for CPL0 (and only if the guest is crazy enough to
> access a DR in a MOVSS shadow).  All other sources of #DBs are either
> suppressed by MOVSS blocking (single-step, code fetch, data, and I/O),

It is more complicated than this and undocumented.  Single step is
discard in a shadow, while data breakpoints are deferred.

I've just run an experiment with code breakpoints, as they're faults
like General Detect:

bool do_unhandled_exception(struct cpu_regs *regs)
{
    static int limit;

    if ( limit++ > 10 )
        return false;

    if ( regs->entry_vector == X86_EXC_DB )
    {
        unsigned int pending_dbg = read_dr6() ^ X86_DR6_DEFAULT;
        unsigned int dr7 = read_dr7(), spurious = 0;

        for ( int i = 0; i < 4; ++i )
            if ( pending_dbg & (1 << i) && ((dr7 >> (2 * i)) & 3) == 0 )
                spurious |= (1 << i);

        printk("#DB at %04x:%p, pending %08x, spurious %x\n",
               regs->cs, _p(regs->ip), pending_dbg ^ spurious, spurious);
        write_dr6(X86_DR6_DEFAULT);

        return true;
    }

    return false;
}

void test_main(void)
{
    extern char l0[] asm ("0f"), l1[] asm ("1f");
    extern char l2[] asm ("2f"), l3[] asm ("3f");
    unsigned int tmp;

    write_cr4(read_cr4() | X86_CR4_DE);

    write_dr0(_u(l0));
    write_dr1(_u(l1));
    write_dr2(_u(l2));
    write_dr3(_u(l3));

    write_dr7(/* DR7_SYM(0, G, X) | */
              /* DR7_SYM(1, G, X) | */
              DR7_SYM(2, G, X) |
              /* DR7_SYM(3, G, X) | */
              X86_DR7_GE);

    asm volatile("mov %%ss, %[tmp];"
                 "pushf;"
                 "pushf;"
                 "orl $"STR(X86_EFLAGS_TF)", (%%"_ASM_SP");"
                 "popf;"
                 "nop;"
                 "0: nop;"
                 "1: mov %[tmp], %%ss;"
                 "2: nop;"
                 "3: popf;"
                 : [tmp] "=r" (tmp));

    /* If the VM is still alive, it didn't suffer a vmentry failure. */
    xtf_success("Success: Not vulnerable to XSA-308\n");
}

$ objdump -d tests/xsa-308/test-hvm64-xsa-308 | grep -A25 '<test_main>:'
001048a0 <test_main>:
  1048a0:    0f 20 e0                 mov    %cr4,%rax
  1048a3:    48 83 c8 08              or     $0x8,%rax
  1048a7:    0f 22 e0                 mov    %rax,%cr4
  1048aa:    b8 df 48 10 00           mov    $0x1048df,%eax
  1048af:    0f 23 c0                 mov    %rax,%db0
  1048b2:    b8 e0 48 10 00           mov    $0x1048e0,%eax
  1048b7:    0f 23 c8                 mov    %rax,%db1
  1048ba:    b8 e2 48 10 00           mov    $0x1048e2,%eax
  1048bf:    0f 23 d0                 mov    %rax,%db2
  1048c2:    b8 e3 48 10 00           mov    $0x1048e3,%eax
  1048c7:    0f 23 d8                 mov    %rax,%db3
  1048ca:    b8 20 02 00 00           mov    $0x220,%eax
  1048cf:    0f 23 f8                 mov    %rax,%db7
  1048d2:    8c d0                    mov    %ss,%eax
  1048d4:    9c                       pushf 
  1048d5:    9c                       pushf 
  1048d6:    81 0c 24 00 01 00 00     orl    $0x100,(%rsp)
  1048dd:    9d                       popf  
  1048de:    90                       nop
  1048df:    90                       nop
  1048e0:    8e d0                    mov    %eax,%ss
  1048e2:    90                       nop
  1048e3:    9d                       popf  
  1048e4:    bf 00 3e 11 00           mov    $0x113e00,%edi
  1048e9:    31 c0                    xor    %eax,%eax

gives

--- Xen Test Framework ---
Environment: HVM 64bit (Long mode 4 levels)
XSA-308 PoC
#DB at 0008:00000000001048df, pending 00004000, spurious 1
#DB at 0008:00000000001048e0, pending 00004000, spurious 2
#DB at 0008:00000000001048e3, pending 00004000, spurious 8
#DB at 0008:00000000001048e4, pending 00004000, spurious 0
Success: Not vulnerable to XSA-308

which suggests that the active code breakpoint in the MovSS shadow is
discarded too, because of no #DB on the 0x1048e2 boundary.

This test is obscured by another bug/misfeature/something where the
B{0..3} get lost on vmexit if BT is also set.

> are mutually exclusive with MOVSS blocking (T-bit task switch),

Howso?  MovSS prevents external interrupts from triggering task
switches, but instruction sources still trigger in a shadow.

>  or are
> already handled by KVM (ICEBP, a.k.a. INT1).

Other sources of #DB include RTM debugging, with errata causing a
fault-style #DB pointing at the XBEGIN instruction, rather than
vectoring to the abort handler, and splitlock which is new since I last
thought about this problem.

> This bug was originally found by running tests[1] created for XSA-308[2].
> Note that Xen's userspace test emits ICEBP in the MOVSS shadow, which is
> presumably why the Xen bug was deemed to be an exploitable DOS from guest
> userspace.

As I recall, the original report to the security team was something
along the lines of "Steam has just updated game, and now when I start
it, the VM explodes".

>   KVM already handles ICEBP by skipping the ICEBP instruction
> and thus clears MOVSS blocking as a side effect of its "emulation".
>
> [1] http://xenbits.xenproject.org/docs/xtf/xsa-308_2main_8c_source.html

This URL is at the whim of doxygen and not necessarily stable.

https://xenbits.xen.org/gitweb/?p=xtf.git;a=blob;f=tests/xsa-308/main.c
ought to have better longevity, as well as including test description.

~Andrew
