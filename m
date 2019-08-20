Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8690B9538B
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 03:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbfHTBlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 21:41:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:57687 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728965AbfHTBlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 21:41:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 18:41:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,407,1559545200"; 
   d="scan'208";a="262016113"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 19 Aug 2019 18:41:17 -0700
Date:   Mon, 19 Aug 2019 18:41:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 08/21] KVM: x86: Add kvm_x86_ops hook to short
 circuit emulation
Message-ID: <20190820014117.GJ1916@linux.intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
 <20190727055214.9282-9-sean.j.christopherson@intel.com>
 <CALCETrU_51Ae=F9HzUwsUuSkJ1or63p_eG+f3uKkBqFx=bheUA@mail.gmail.com>
 <20190730024940.GL21120@linux.intel.com>
 <25BBDA64-1253-4429-95AF-5D578684F6CC@amacapital.net>
 <20190819220150.GE1916@linux.intel.com>
 <CALCETrX6bmhFm62GyCF8Z2DGtb10Ua7xi6h3PoCUiP_es74M8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX6bmhFm62GyCF8Z2DGtb10Ua7xi6h3PoCUiP_es74M8A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 19, 2019 at 06:34:07PM -0700, Andy Lutomirski wrote:
> On Mon, Aug 19, 2019 at 3:01 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Thu, Aug 15, 2019 at 05:47:12PM -0700, Andy Lutomirski wrote:
> > >
> > >
> > > >> On Jul 29, 2019, at 7:49 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > > >>
> > > >> On Sat, Jul 27, 2019 at 10:38:03AM -0700, Andy Lutomirski wrote:
> > > >> On Fri, Jul 26, 2019 at 10:52 PM Sean Christopherson
> > > >> <sean.j.christopherson@intel.com> wrote:
> > > >>>
> > > >>> Similar to the existing AMD #NPF case where emulation of the current
> > > >>> instruction is not possible due to lack of information, virtualization
> > > >>> of Intel SGX will introduce a scenario where emulation is not possible
> > > >>> due to the VMExit occurring in an SGX enclave.  And again similar to
> > > >>> the AMD case, emulation can be initiated by kvm_mmu_page_fault(), i.e.
> > > >>> outside of the control of the vendor-specific code.
> > > >>>
> > > >>> While the cause and architecturally visible behavior of the two cases
> > > >>> is different,  e.g. Intel SGX will inject a #UD whereas AMD #NPF is a
> > > >>> clean resume or complete shutdown, the impact on the common emulation
> > > >>> code is identical: KVM must stop emulation immediately and resume the
> > > >>> guest.
> > > >>>
> > > >>> Replace the exisiting need_emulation_on_page_fault() with a more generic
> > > >>> is_emulatable() kvm_x86_ops callback, which is called unconditionally
> > > >>> by x86_emulate_instruction().
> > > >>
> > > >> Having recently noticed that emulate_ud() is broken when the guest's
> > > >> TF is set, I suppose I should ask: does your new code function
> > > >> sensibly when TF is set?
> > > >
> > > > Barring a VMX fault injection interaction I'm not thinking of, yes.  The
> > > > SGX reaction to the #UD VM-Exit is to inject a #UD and resume the guest,
> > > > pending breakpoints shouldn't be affected in any way (unless some other
> > > > part of KVM mucks with them, e.g. when guest single-stepping is enabled).
> > >
> > > What I mean is: does the code actually do what you think it does if TF is
> > > set?  Right now, as I understand it, the KVM emulation code has a bug in
> > > which some emulated faults also inject #DB despite the fact that the
> > > instruction faulted, and the #DB seems to take precedence over the original
> > > fault.  This confuses the guest.
> >
> > Yes.  The proposed change is to inject the #UD instead of calling into the
> > emulator, and by inspection I've verified that all code that injects a #DB
> > is either contained within the emulator or is mutually exclusive with an
> > intercepted #UD.  It's a qualified yes because I don't have an actual
> > testcase to verify my literacy.  I'll look into adding a test, either to
> > the selftest/x86/sgx or to kvm-unit-tests.
> 
> I wrote one, and it fails:
> 
> # ./tools/testing/selftests/x86/syscall_arg_fault_32
> [RUN]    SYSENTER with invalid state
> [OK]    Seems okay
> [RUN]    SYSCALL with invalid state
> [SKIP]    Illegal instruction
> [RUN]    SYSENTER with TF and invalid state
> [OK]    Seems okay
> [RUN]    SYSCALL with TF and invalid state
> [WARN]    Got stuck single-stepping -- you probably have a KVM bug
> 
> emulate_ud() is buggy.

Heh, yeah, I meant for the SGX case, e.g. SYSCALL from inside an enclave
with RFLAGS.TF=1.
