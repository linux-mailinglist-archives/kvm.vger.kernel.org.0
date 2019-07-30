Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0865479EE9
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 04:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbfG3Ctm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 22:49:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:43707 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730760AbfG3Ctl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 22:49:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 19:49:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,325,1559545200"; 
   d="scan'208";a="346858151"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 29 Jul 2019 19:49:41 -0700
Date:   Mon, 29 Jul 2019 19:49:40 -0700
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
Message-ID: <20190730024940.GL21120@linux.intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
 <20190727055214.9282-9-sean.j.christopherson@intel.com>
 <CALCETrU_51Ae=F9HzUwsUuSkJ1or63p_eG+f3uKkBqFx=bheUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU_51Ae=F9HzUwsUuSkJ1or63p_eG+f3uKkBqFx=bheUA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 27, 2019 at 10:38:03AM -0700, Andy Lutomirski wrote:
> On Fri, Jul 26, 2019 at 10:52 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Similar to the existing AMD #NPF case where emulation of the current
> > instruction is not possible due to lack of information, virtualization
> > of Intel SGX will introduce a scenario where emulation is not possible
> > due to the VMExit occurring in an SGX enclave.  And again similar to
> > the AMD case, emulation can be initiated by kvm_mmu_page_fault(), i.e.
> > outside of the control of the vendor-specific code.
> >
> > While the cause and architecturally visible behavior of the two cases
> > is different,  e.g. Intel SGX will inject a #UD whereas AMD #NPF is a
> > clean resume or complete shutdown, the impact on the common emulation
> > code is identical: KVM must stop emulation immediately and resume the
> > guest.
> >
> > Replace the exisiting need_emulation_on_page_fault() with a more generic
> > is_emulatable() kvm_x86_ops callback, which is called unconditionally
> > by x86_emulate_instruction().
> >
> 
> Having recently noticed that emulate_ud() is broken when the guest's
> TF is set, I suppose I should ask: does your new code function
> sensibly when TF is set?

Barring a VMX fault injection interaction I'm not thinking of, yes.  The
SGX reaction to the #UD VM-Exit is to inject a #UD and resume the guest,
pending breakpoints shouldn't be affected in any way (unless some other
part of KVM mucks with them, e.g. when guest single-stepping is enabled).
