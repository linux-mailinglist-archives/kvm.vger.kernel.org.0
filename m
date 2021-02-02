Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE82930CF2F
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 23:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbhBBWjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 17:39:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235074AbhBBWjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 17:39:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7420964F66;
        Tue,  2 Feb 2021 22:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612305521;
        bh=1jsYJbo/PT7+F1+0wgdMyVcUx0ewpifsiiTK8woGiTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Epo07cIZXOAHyQRbqCsszR4ntcL6hu0UFWaoocorXZjXTItWnnL8iUj8Y+zo1NnDe
         4wt+JVQcqs+GuKWWOrn3qHhMFme5kkAZ1fbnCEaL98IgADJTXE5TfRwkuEs6wGmJ0l
         AFypmR0mZPXEuUgl9DMnUXZ6Xr4XCbEJjfJAVqu7QZ9UjYS46a3gi25f8ruaLaE9yN
         tCYvvoOxtvF0rvRh9IHonKGaHTWojPS04bA7EhwbqdauoUrSU0Y0K4VpcS9OXXg74t
         IHgQtfwSwExfexdEfwHB5LkHYUaQCcdjMpfPeoaC1/j0Jc/7v/HGlZYJrm4rrIDfO4
         6VONmmoS/64zA==
Date:   Wed, 3 Feb 2021 00:38:33 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [RFC PATCH v3 16/27] KVM: VMX: Convert vcpu_vmx.exit_reason to a
 union
Message-ID: <YBnUaSoihDQygzKz@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <d32ab375be78315e3bc2540f2a741859637abcb0.1611634586.git.kai.huang@intel.com>
 <YBV0nnqUHnING5qA@kernel.org>
 <YBg2j45w2IIUlZ0V@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBg2j45w2IIUlZ0V@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021 at 09:12:47AM -0800, Sean Christopherson wrote:
> On Sat, Jan 30, 2021, Jarkko Sakkinen wrote:
> > On Tue, Jan 26, 2021 at 10:31:37PM +1300, Kai Huang wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
> > > full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
> > > bits 15:0, and single-bit modifiers in bits 31:16.
> > > 
> > > Historically, KVM has only had to worry about handling the "failed
> > > VM-Entry" modifier, which could only be set in very specific flows and
> > > required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
> > > bit was a somewhat viable approach.  But even with only a single bit to
> > > worry about, KVM has had several bugs related to comparing a basic exit
> > > reason against the full exit reason store in vcpu_vmx.
> > > 
> > > Upcoming Intel features, e.g. SGX, will add new modifier bits that can
> > > be set on more or less any VM-Exit, as opposed to the significantly more
> > > restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
> > > flows isn't scalable.  Tracking exit reason in a union forces code to
> > > explicitly choose between consuming the full exit reason and the basic
> > > exit, and is a convenient way to document and access the modifiers.
> > 
> > I *believe* that the change is correct but I dropped in the last paragraph
> > - most likely only because of lack of expertise in this area.
> > 
> > I ask the most basic question: why SGX will add new modifier bits?
> 
> Register state is loaded with synthetic state and/or trampoline state on VM-Exit
> from enclaves.  For all intents and purposes, emulation and other VMM/hypervisor
> behavior that accesses vCPU state is impossible.  E.g. on a #UD VM-Exit, RIP
> will point at the AEP; emulating would emulate some random instruction in the
> untrusted runtime, not the instruction that faulted.
> 
> Hardware sets the "exit from enclave" modifier flag so that the VMM can try and
> do something moderately sane, e.g. inject a #UD into the guest instead of
> attempting to emulate random instructions.

OK, thanks for the explanation! I think this would be a great addition to
the commit message (as a reminder).

/Jarkko
