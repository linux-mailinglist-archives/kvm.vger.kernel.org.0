Return-Path: <kvm+bounces-24085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D367951198
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 03:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C143AB246D9
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C5218026;
	Wed, 14 Aug 2024 01:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zj1zR6PI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADCF171A5
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 01:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723599103; cv=none; b=ijwV3y9MZ0OCbmyNOzn8OX6mWpeZTcX5PLZXGUO5WDihwTyffskctIoIZsPvOxIwmA0Sz+QlKVhn2B5z/Viq7DRtEe5UH2HQ2CB77aaJcFkZkmepPaAlM7uysqkjD57balYKlleAr9sDlA8nfbASOsdZG54ALWYVV72717nQOQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723599103; c=relaxed/simple;
	bh=8o4Icar/a4At+/b8xaGVPXtrtbM9FsaQ+MTRBWypSS4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DjVdm2STHnh2M7JqtvLWDMx4OsXwBKqRS2ZzN8pjz429cErgD5JUH78U3TSS489DltyJWathysadlKW89oFofyy1xfqSJwFI2jK+m1A0cFySFfIT6H0nOzWvhPG8bOj9sths8twLmJ/RoEWxTJSLoc2hYCKID4NxyHzU7vM8+xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zj1zR6PI; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66890dbb7b8so137872207b3.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 18:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723599101; x=1724203901; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+sFZ3SIAlPQj6ielgYFy5RPMkg4fE3WIWVRua/D7Dlk=;
        b=Zj1zR6PIdAsgEuN+D4yiK6ECAXgFYw/RYkbsMuEKjFE84IpaD1r1ErCPmPZiA+pA80
         lMDnPKyaa3wxXkq9i3+Gg+63FLp7EGxs6OwOgK7d+ZK0qkRZCUGfviZCYEurHp/8S+vJ
         W7gHF6zSO7z5GYeMeiYLzr79ZqBt7U9/PTfgMNCYLfAJ6sV4WXDKVFlmbRIj+zS94MOP
         rwkZC50UzvFI7KHGDFSuyjiF+o+0iEg4J9/UymEdQbKTqeY6NF8ETcKSncvgOFW9qyrX
         KYitvlPwsgd6lzHZuto4uuKU0DUA9IHbRV3RC/phqWyWYACVx8QgPhDYqfzGVMz53ask
         KRxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723599101; x=1724203901;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+sFZ3SIAlPQj6ielgYFy5RPMkg4fE3WIWVRua/D7Dlk=;
        b=G3RIPiqb78VPJFixYB0F9lc+reCtrK4OHoYOsV2pcfRAsXhQk0jUBUtrfqkCC1UuXS
         0pw6jMsI+bVesPlF9dZw2y0lSejBQeL1GxZ4SWsPETa67DNIFP9RbzxoC9TrenBdKB3w
         DUCj4aAvPWKEe6pT6I9XGdqV5+jvDF2wQifnZRV7AXLLLRn1Olcx0tkPK2dq2BO/hgKa
         jcmZnMKJk/tTNVTNRJq7tpy4ovqEhG3wO1KDGpoOlGLUY2aE6g+yvEnYdfWM8kCvIl+h
         QcP4Lyj4q8kBsULmROwJCD4Pc03IowsYu9V7kXtFeS3PDdowBOj0UlF++bfZ/xBWCMHW
         b0Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWxtD9m+UnQoo41t/Fk8a3+d2OW84EddrdoejvZZvEDpE7RkSY3Qbjac+MKokNQP3IBVwGNIh9N54BETUNByZCuXorj
X-Gm-Message-State: AOJu0YyMR/a57XJMuvj27xJRRg8PXL7LzLYdplyuJv4H4S70l+g5YNcX
	DIHgeNL1BLFTieUgPdJfTyONo7JvFK/2hsUmkWbCbzCDeCVAcN0E4uemKqcb9A0wC5svd1JJ6tf
	JJw==
X-Google-Smtp-Source: AGHT+IErM1oyl6dX79PLFBbS0Ue2cTuqm2deVMm1K7Fx1UQZ6ahMkuyTT3QbjPRcQErn+dpEqRps5VUDPf4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:770a:0:b0:64a:d9c2:42c1 with SMTP id
 00721157ae682-6ac9913772fmr296287b3.5.1723599100911; Tue, 13 Aug 2024
 18:31:40 -0700 (PDT)
Date: Tue, 13 Aug 2024 18:31:39 -0700
In-Reply-To: <Zrv/60HrjlPCaXsi@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com> <ZrucyCn8rfTrKeNE@ls.amr.corp.intel.com>
 <b58771a0-352e-4478-b57d-11fa2569f084@intel.com> <Zrv/60HrjlPCaXsi@ls.amr.corp.intel.com>
Message-ID: <ZrwI-927_7cBxYT1@google.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace generically
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	michael.roth@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 13, 2024, Isaku Yamahata wrote:
> On Wed, Aug 14, 2024 at 11:11:29AM +1200,
> Kai Huang <kai.huang@intel.com> wrote:
> 
> > 
> > 
> > On 14/08/2024 5:50 am, Isaku Yamahata wrote:
> > > On Tue, Aug 13, 2024 at 01:12:55PM +0800,
> > > Binbin Wu <binbin.wu@linux.intel.com> wrote:
> > > 
> > > > Check whether a KVM hypercall needs to exit to userspace or not based on
> > > > hypercall_exit_enabled field of struct kvm_arch.
> > > > 
> > > > Userspace can request a hypercall to exit to userspace for handling by
> > > > enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
> > > > hypercall_exit_enabled.  Make the check code generic based on it.
> > > > 
> > > > Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> > > > ---
> > > >   arch/x86/kvm/x86.c | 4 ++--
> > > >   arch/x86/kvm/x86.h | 7 +++++++
> > > >   2 files changed, 9 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index af6c8cf6a37a..6e16c9751af7 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > > >   	cpl = kvm_x86_call(get_cpl)(vcpu);
> > > >   	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> > > > -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> > > > -		/* MAP_GPA tosses the request to the user space. */
> > > > +	if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
> > > > +		/* The hypercall is requested to exit to userspace. */
> > > >   		return 0;
> > > >   	if (!op_64_bit)
> > > > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > > > index 50596f6f8320..0cbec76b42e6 100644
> > > > --- a/arch/x86/kvm/x86.h
> > > > +++ b/arch/x86/kvm/x86.h
> > > > @@ -547,4 +547,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
> > > >   			 unsigned int port, void *data,  unsigned int count,
> > > >   			 int in);
> > > > +static inline bool is_kvm_hc_exit_enabled(struct kvm *kvm, unsigned long hc_nr)

I would rather have "hypercall" in the name, "hc" never jumps out to me as being
"hypercall". Maybe is_hypercall_exit_enabled(), user_exit_on_hypercall(), or just
exit_on_hypercall()?

I'd probably vote for user_exit_on_hypercall(), as that clarifies it's all about
exiting to userspace, not from the guest.

> > > > +{
> > > > +	if(WARN_ON_ONCE(hc_nr >= sizeof(kvm->arch.hypercall_exit_enabled) * 8))
> > > > +		return false;
> > > 
> > > Is this to detect potential bug? Maybe
> > > BUILD_BUG_ON(__builtin_constant_p(hc_nr) &&
> > >               !(BIT(hc_nr) & KVM_EXIT_HYPERCALL_VALID_MASK));
> > > Overkill?
> > 
> > I don't think this is the correct way to use __builtin_constant_p(), i.e. it
> > doesn't make sense to use __builtin_constant_p() in BUILD_BUG_ON().

KVM does use __builtin_constant_p() to effectively disable some assertions when
it's allowed (by KVM's arbitrary rules) to pass in a non-constant value.  E.g.
see all the vmcs_checkNN() helpers.  If we didn't waive the assertion for values
that aren't constant at compile-time, all of the segmentation code would need to
be unwound into switch statements.

But for things like guest_cpuid_has(), the rule is that the input must be a
compile-time constant.

> > IIUC you need some build time guarantee here, but __builtin_constant_p() can
> > return false, in which case the above BUILD_BUG_ON() does nothing, which
> > defeats the purpose.
> 
> It depends on what we'd like to detect.  BUILT_BUG_ON(__builtin_constant_p())
> can detect the usage in the patch 2/2,
> is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE).  The potential
> future use of is_kvm_hc_exit_enabled(, KVM_HC_MAP_future_hypercall).
> 
> Although this version doesn't help for the one in kvm_emulate_hypercall(),
> !ret check is done first to avoid WARN_ON_ONCE() to hit here.
> 
> Maybe we can just drop this WARN_ON_ONCE().

Yeah, I think it makes sense to drop the WARN, otherwise I suspect we'll end up
dancing around the helper just to avoid the warning.

I'm 50/50 on the BUILD_BUG_ON().  One one hand, it's kinda overkill.  On the other
hand, it's zero generated code.

