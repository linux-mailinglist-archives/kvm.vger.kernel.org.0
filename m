Return-Path: <kvm+bounces-62663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D72E9C49DD1
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 01:26:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96AE83A7D5F
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D8241D6DB5;
	Tue, 11 Nov 2025 00:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eHvm1Lzy"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51BB1C3BFC
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 00:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762820813; cv=none; b=eeMsSudFtFtAopubfYTuOqex9ikdJSDWZbmwK/xDYRkBsdcKmlwfHfr5RGqGUhR+j3UTaz4ejQXTWtjp4jdbvpU8anoN93vNszBuqrv0CLh0dDuiJaURBA9Z/OR8lnlnJZxCj+c3qPrdbhPkvtSQA2csw8/OyfOsKPkZJS79Rz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762820813; c=relaxed/simple;
	bh=NgfNWY3Wt3nuaS355AaMY+stuYNDIeq0GOQ3IoiEeuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElUKoSBn7g5GfZVcbw1F9BUJOfjKIWkuhA+JSzk4GasltKhRVIsPbvzvvx1OEYhKUG/BZYl4HvtsFJoEbEKieWo9bSUA/spI3vUYh9RMLHu+fE+ppLZBgVbAfMIcB9Pc7NMBkOXQzTWt0x4JfpnJZa2mNKreRkbw29aMGTELzFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eHvm1Lzy; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 11 Nov 2025 00:26:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762820808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tlmDsda+dxGOrCn1EldCEA+y3uPWJnnm3FqHlVKFFcA=;
	b=eHvm1LzyuVQp0E5hsdfidIAeXCuNsVLZ6K0BtpkwGMbJBe2V4CDBidlA1bInYYKzvx731j
	zJRFMH8OYb8nZZkpKB70fzbQnr6zfD/XJzsmXapkxtt8gKUvWLhC4vInH1Lk2gohjN0DlJ
	HSKtN0rnh+MZ4DXOFs5u/35A55/upzc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: SVM: Don't set GIF when clearing EFER.SVME
Message-ID: <472x65cnmgux7nrbclwfsaf6gaym6jb7vvh2vgxfxfevdb47x2@nz2rv3wzhduv>
References: <20251009223153.3344555-1-jmattson@google.com>
 <20251009223153.3344555-3-jmattson@google.com>
 <aO1-IV-R6XX7RIlv@google.com>
 <CALMp9eRQZuDy8-H3b8tbdZVQSznUK9=yhuBV9vBFAQz3UP+iRg@mail.gmail.com>
 <aO6-CbTRPp1ZNIWq@google.com>
 <CALMp9eRJaO9z=u5y0e+D44_U_FH1ye2s+cHNHmtERxEe+k2Dsw@mail.gmail.com>
 <aO7JjaymjPMBcjrz@google.com>
 <CALMp9eQ3Ff4pYJgwcyzq-Ttw=Se6f+Q3VK06ROg5FCJe+=kAhg@mail.gmail.com>
 <aPK7qvIeSdzxdzMZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aPK7qvIeSdzxdzMZ@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 17, 2025 at 02:56:58PM -0700, Sean Christopherson wrote:
> On Tue, Oct 14, 2025, Jim Mattson wrote:
> > On Tue, Oct 14, 2025 at 3:07 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Oct 14, 2025, Jim Mattson wrote:
> > > > On Tue, Oct 14, 2025 at 2:18 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Tue, Oct 14, 2025, Jim Mattson wrote:
> > > > > > On Mon, Oct 13, 2025 at 3:33 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > > > >
> > > > > > > On Thu, Oct 09, 2025, Jim Mattson wrote:
> > > > > > > > Clearing EFER.SVME is not architected to set GIF.
> > > > > > >
> > > > > > > But it's also not architected to leave GIF set when the guest is running, which
> > > > > > > was the basic gist of the Fixes commit.  I suspect that forcing GIF=1 was
> > > > > > > intentional, e.g. so that the guest doesn't end up with GIF=0 after stuffing the
> > > > > > > vCPU into SMM mode, which might actually be invalid.
> > > > > > >
> > > > > > > I think what we actually want is to to set GIF when force-leaving nested.  The
> > > > > > > only path where it's not obvious that's "safe" is toggling SMM in
> > > > > > > kvm_vcpu_ioctl_x86_set_vcpu_events().  In every other path, setting GIF is either
> > > > > > > correct/desirable, or irrelevant because the caller immediately and unconditionally
> > > > > > > sets/clears GIF.
> > > > > > >
> > > > > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > > > > index a6443feab252..3392c7e22cae 100644
> > > > > > > --- a/arch/x86/kvm/svm/nested.c
> > > > > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > > > > @@ -1367,6 +1367,8 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
> > > > > > >                 nested_svm_uninit_mmu_context(vcpu);
> > > > > > >                 vmcb_mark_all_dirty(svm->vmcb);
> > > > > > >
> > > > > > > +               svm_set_gif(svm, true);
> > > > > > > +
> > > > > > >                 if (kvm_apicv_activated(vcpu->kvm))
> > > > > > >                         kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> > > > > > >         }
> > > > > > >
> > > > > >
> > > > > > This seems dangerously close to KVM making up "hardware" behavior, but
> > > > > > I'm okay with that if you are.
> > > > >
> > > > > Regardless of what KVM does, we're defining hardware behavior, i.e. keeping GIF
> > > > > unchanged defines behavior just as much as setting GIF.  The only way to truly
> > > > > avoid defining behavior would be to terminate the VM and completely prevent
> > > > > userspace from accessing its state.
> > > >
> > > > This can't be the only instance of "undefined behavior" that KVM deals
> > > > with.
> > >
> > > Oh, for sure.  But unsurprisingly, people only care about cases that actually
> > > matter in practice.  E.g. the other one that comes to mind is SHUTDOWN on AMD:
> > >
> > >         /*
> > >          * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU to put
> > >          * the VMCB in a known good state.  Unfortuately, KVM doesn't have
> > >          * KVM_MP_STATE_SHUTDOWN and can't add it without potentially breaking
> > >          * userspace.  At a platform view, INIT is acceptable behavior as
> > >          * there exist bare metal platforms that automatically INIT the CPU
> > >          * in response to shutdown.
> > >          *
> > 
> > The behavior of SHUTDOWN while GIF==0 is clearly architected:
> > 
> > "If the processor enters the shutdown state (due to a triple fault for
> > instance) while GIF is clear, it can only be restarted by means of a
> > RESET."
> > 
> > Doesn't setting GIF in svm_leave_nested() violate this specification?
> 
> Probably?  But SHUTDOWN also makes the VMCB undefined, so KVM is caught between
> a rock and a hard place.  And when using vGIF, I don't see how KVM can do the
> right thing, because the state of GIF at the time of SHUTDOWN is unknown.
> 
> And FWIW, if userspace does RESET the guest (which KVM can't detect with 100%
> accuracy), GIF=1 on RESET, so it's kinda sorta right :-)

This thread kinda ended on a cliffhanger.

Sean, is the plan to apply Jim's patch + your diff to svm_set_gif() in
svm_leave_nested()? Or are you waiting for Jim to send a v2?

