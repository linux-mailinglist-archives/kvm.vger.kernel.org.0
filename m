Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC79D300A14
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 18:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbhAVRnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 12:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729907AbhAVRaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 12:30:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30A5C23A9A;
        Fri, 22 Jan 2021 17:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611336564;
        bh=4gZnnmmnh8aGQ+syP8eUllgr8Tuh6Y9dYtD8qbPup7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ge3zo/B+y18FqMAqwkdn4+HPVxV4+lTPa55Q3tBXDkWpgojIG53bf6lt6nOmwaC7p
         LkM/kg0tMmXxjDRrpvq3jwnS7Ca0RK+5FbHZgj2jXFFQdqNfpDBG5OtF+oi5EExVPn
         O4s3aTRvJAu+w6s0OlixdNDljSnMQxMVdxpSs2wa9mDl5HvYs+vee7LCG8T0zm8cXX
         I7QDOodOsmuSqbqVbjxfQg+aateHZ3b7WkF3DKV6gzpEiVfAzdO9qR7coAIu1QTO6D
         dPbBYELNTzB/nlftURCU9A/xo8OuFB4l5WTvP3v6uOMaMyuUxbdI+jjStiFWWZnZFF
         yjchrTweuhupg==
Date:   Fri, 22 Jan 2021 19:29:22 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [RFC PATCH v2 15/26] KVM: VMX: Convert vcpu_vmx.exit_reason to a
 union
Message-ID: <YAsLcpOUVd6N7ypv@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <72e2f0e0fb28af55cb11f259eb5bc9e034fb705c.1610935432.git.kai.huang@intel.com>
 <YAg7vzevfw5iL9kN@kernel.org>
 <YAhcvqXNxq0ALCyO@google.com>
 <YAjPC5VTiyO3XFsJ@kernel.org>
 <YAms5375BLAp/x1W@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAms5375BLAp/x1W@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 08:33:43AM -0800, Sean Christopherson wrote:
> On Thu, Jan 21, 2021, Jarkko Sakkinen wrote:
> > On Wed, Jan 20, 2021 at 08:39:26AM -0800, Sean Christopherson wrote:
> > > On Wed, Jan 20, 2021, Jarkko Sakkinen wrote:
> > > > On Mon, Jan 18, 2021 at 04:28:26PM +1300, Kai Huang wrote:
> > > > > ---
> > > > >  arch/x86/kvm/vmx/nested.c | 42 +++++++++++++++---------
> > > > >  arch/x86/kvm/vmx/vmx.c    | 68 ++++++++++++++++++++-------------------
> > > > >  arch/x86/kvm/vmx/vmx.h    | 25 +++++++++++++-
> > > > >  3 files changed, 86 insertions(+), 49 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > > index 0fbb46990dfc..f112c2482887 100644
> > > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > > @@ -3311,7 +3311,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> > > > >  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> > > > >  	enum vm_entry_failure_code entry_failure_code;
> > > > >  	bool evaluate_pending_interrupts;
> > > > > -	u32 exit_reason, failed_index;
> > > > > +	u32 failed_index;
> > > > > +	union vmx_exit_reason exit_reason = {
> > > > > +		.basic = -1,
> > > > > +		.failed_vmentry = 1,
> > > > > +	};
> > > > 
> > > > Instead, put this declaration to the correct place, following the
> > > > reverse christmas tree ordering:
> > > > 
> > > >         union vmx_exit_reason exit_reason = {};
> > > > 
> > > > And after declarations:
> > > > 
> > > >         exit_reason.basic = -1;
> > > >         exit_reason.failed_vmentry = 1;
> > > > 
> > > > More pleasing for the eye.
> > > 
> > > I disagree (obviously, since I wrote the patch).  Initializing the fields to
> > > their respective values is a critical, but subtle, aspect of this code.  Making
> > > the code stand out via explicit initialization is a good thing, and we really
> > > don't want any possibility of code touching exit_reason before it is initialized.
> > 
> > The struct does get initialized to zero, and fields get initialized
> > to their respective values. What is the critical aspect that is gone?
> > I'm not following.
> 
> Setting exit_reason.failed_vmentry from time zero.  This code should never
> synthesize a nested VM-Exit with failed_vmentry=0.  There have been bugs around
> the exit_reason in this code in the past, I strongly prefer to not have any
> window where exit_reason has the "wrong" value.

OK, I see.  Thanks for the explanation.

/Jarkko
