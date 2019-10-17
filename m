Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5500FDB60D
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 20:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389123AbfJQSZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 14:25:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:11414 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730483AbfJQSZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 14:25:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 11:25:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="208735773"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 17 Oct 2019 11:24:59 -0700
Date:   Thu, 17 Oct 2019 11:24:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH 2/4] kvm-unit-test: nVMX: __enter_guest() needs to also
 check for VMX_FAIL_STATE
Message-ID: <20191017182459.GF20903@linux.intel.com>
References: <20191015001633.8603-1-krish.sadhukhan@oracle.com>
 <20191015001633.8603-3-krish.sadhukhan@oracle.com>
 <CALMp9eSg-cY0ZDauS11HitF13b7G_=urszQ6d7m+kAm-4htArg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSg-cY0ZDauS11HitF13b7G_=urszQ6d7m+kAm-4htArg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 16, 2019 at 10:55:55AM -0700, Jim Mattson wrote:
> On Mon, Oct 14, 2019 at 5:52 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
> >
> >   ..as both VMX_ENTRY_FAILURE and VMX_FAIL_STATE together comprise the
> >     exit eeason when VM-entry fails due invalid guest state.
> 
> Nit: s/reason/reason/
> 
> > Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> > ---
> >  x86/vmx.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/x86/vmx.c b/x86/vmx.c
> > index 647ab49..4ce0fb5 100644
> > --- a/x86/vmx.c
> > +++ b/x86/vmx.c
> > @@ -1848,7 +1848,8 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
> >         vmx_enter_guest(failure);
> >         if ((abort_flag & ABORT_ON_EARLY_VMENTRY_FAIL && failure->early) ||
> >             (abort_flag & ABORT_ON_INVALID_GUEST_STATE &&
> > -           vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
> > +           (vmcs_read(EXI_REASON) & (VMX_ENTRY_FAILURE | VMX_FAIL_STATE))
> > +           == (VMX_ENTRY_FAILURE | VMX_FAIL_STATE))) {
> This shouldn't be a bitwise comparison. It should just be a value comparison:
> 
> vmcs_read(EXI_REASON) == VMX_ENTRY_FAILURE | VMX_FAIL_STATE

Hmm, but then we miss failed VM-Enter if something goes truly haywire,
e.g. KVM signals a failed VM-Enter due to #MC.

I'd do something like this:

	u32 exit_reason;

	...

	vmx_enter_guest(failure);

	if (failure->early) {
		if (abort_flag & ABORT_ON_EARLY_VMENTRY_FAIL)
			goto do_abort;
		return;
	}
	exit_reason = vmcs_read(EXI_REASON);
	if (exit_reason & VMX_ENTRY_FAILURE) {
		if ((abort_flag & ABORT_ON_INVALID_GUEST_STATE) ||
		    exit_reason != (VMX_ENTRY_FAILURE | VMX_FAIL_STATE))
			goto do_abort;
		return;
	}

	launched = 1;
	check_for_guest_termination();
	return;

do_abort:
	print_vmentry_failure_info(failure);
	abort();


