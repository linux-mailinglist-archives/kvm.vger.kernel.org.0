Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07229D6C40
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 01:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfJNXzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 19:55:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:8198 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbfJNXzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 19:55:22 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 16:55:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="208068129"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 14 Oct 2019 16:55:20 -0700
Date:   Mon, 14 Oct 2019 16:55:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/5] KVM: VMX: Use wrmsr for switching between guest
 and host IA32_XSS
Message-ID: <20191014235520.GP22962@linux.intel.com>
References: <20191011194032.240572-1-aaronlewis@google.com>
 <20191011194032.240572-3-aaronlewis@google.com>
 <20191012001838.GA11329@linux.intel.com>
 <CALMp9eQR3RbP8bkXSCp34izY4z76YFAxUGYbQmJ9JjizoAKy2A@mail.gmail.com>
 <20191014190529.GF22962@linux.intel.com>
 <CALMp9eQg+8eg_2dXaR51MMcjxLU=m48KW8hVoZWA_4mPAhU_uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQg+8eg_2dXaR51MMcjxLU=m48KW8hVoZWA_4mPAhU_uw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 02:01:41PM -0700, Jim Mattson wrote:
> On Mon, Oct 14, 2019 at 12:05 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Sat, Oct 12, 2019 at 10:36:15AM -0700, Jim Mattson wrote:
> > > On Fri, Oct 11, 2019 at 5:18 PM Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > >
> > > > On Fri, Oct 11, 2019 at 12:40:29PM -0700, Aaron Lewis wrote:
> > > > > @@ -5887,6 +5887,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
> > > > >  {
> > > > >       struct vcpu_svm *svm = to_svm(vcpu);
> > > > >
> > > > > +     vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> > > > > +                                 boot_cpu_has(X86_FEATURE_XSAVES);
> > > >
> > > > This looks very much like a functional change to SVM, which feels wrong
> > > > for a patch with a subject of "KVM: VMX: Use wrmsr for switching between
> > > > guest and host IA32_XSS" feels wrong.  Shouldn't this be unconditionally
> > > > set false in this patch, and then enabled in " kvm: svm: Add support for
> > > > XSAVES on AMD"?
> > >
> > > Nothing is being enabled here. Vcpu->arch.xsaves_enabled simply tells
> > > us whether or not the guest can execute the XSAVES instruction. Any
> > > guest with the ability to set CR4.OSXSAVE on an AMD host that supports
> > > XSAVES can use the instruction.
> >
> > Not enabling per se, but it's a functional change as it means MSR_IA32_XSS
> > will be written in kvm_load_{guest,host}_xsave_controls() if host_xss!=0.
> 
> Fortunately, host_xss is guaranteed to be zero for the nonce. :-)

And then someone backports something and things go sideways.
 
> Perhaps the commit message just needs to be updated? The only
> alternatives I see are:
> 1. Deliberately introducing buggy code to be removed later in the series, or
> 2. Introducing SVM-specific code first, to be removed later in the series.

I'd go with:

  2a. Make the change actually local to VMX as the subject implies, and
      introduce SVM-specific code in a separate patch, to be removed
      later.

Then the series looks like:

  KVM: VMX: Remove unneeded check for X86_FEATURE_XSAVE
  KVM: VMX: Use wrmsr for switching between guest and host IA32_XSS
  kvm: svm: Add support for XSAVES on AMD
  KVM: x86: Move IA32_XSS handling to common x86 code
  KVM: x86: Add IA32_XSS to the emulated_msrs list

It'd mean introducing vcpu->arch.xsaves_enabled in the VMX patch and
temporarily having it unused by SVM, but that's minor and can't backfire
if host_xss suddently is non-zero.

Side topic, I'm pretty sure vcpu->guest_xcr0_loaded is a waste of an 'int'
and a conditional branch.  VMX and SVM are the only users, and both
unconditionally pair kvm_load_guest_xcr0() with kvm_put_guest_xcr0().
Removing the useless flag as another prerequisite patch would make the
intermediate VMX and SVM patches slightly less awkward as they wouldn't
have to decide between adding a kludgy check on guest_xcr0_loaded and
ignoring it altogether.
