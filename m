Return-Path: <kvm+bounces-16921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 277428BEC4D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 21:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A74C31F25ACC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 19:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8BD16F0DE;
	Tue,  7 May 2024 19:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lb84cuJQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E75916EBFA
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 19:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715108868; cv=none; b=ZvMUTR227TZXcJAfYbN5XHFQRbOyFiDP1/UzmLe/ITYRTCfPL5v/jFLx2YTt/J1OYXqdBC03+FmKckZlYsWnp7hETaWZLAbRASdksRu4sJIR7KUaSdErA79hLvi9ot35sfowQfv6Nk2xud7uSVhScC5cAlBlJJDfXXyGkdkHdO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715108868; c=relaxed/simple;
	bh=9K/bO5jtlWAadEx++bJ4tBnwyCoDvk5e6sU6qqppTJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J7FyLcuI610QWDjpubJNTEkE+venc4wBtUSmHTyX2z8Z0HOvcXB+GhpRsgmMlgN+hl50p+IRkv7AhRTi1q3BxTdoCZmUnSTbC/uwYUSzmPW3op8iLddmMRvbKq36S/z3/BL9DXouKZ/hdUSk8Omt+3mohqCoHnTyS3GRUMhJ/Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lb84cuJQ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-61c943c18a8so3590935a12.0
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 12:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715108866; x=1715713666; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jkQu4Jm3xj+OSWk/nhy3+Jt5eXwFDQEAw7ll75hZ8tw=;
        b=Lb84cuJQCVpWPod3fTIPvQb3Nm1Rf2NGWNrgl9RX53l4L8anb8uMsdJD+nz4GGYcIY
         4sWzPkbwSMk+thBfJNoxWBEUVIUbp/bHAYnzqyyHnsxuuOE4b24KobqlLhGE4AvHI1JV
         FHEcjL7wkeIe+SvlK1Hbomduy+gplLYdBEhbD//ozHLVvSHr8dgawJd5Kij/UtnLepQr
         Ze3TY8K9OiuAE3B/iQyPJ0HhxpocuMGP6mfjOma2kM0vr2IoEc4RmAP60XuCf+ipKGoF
         3t11FG5teEJj6bSmq7kIOGOV4QEA1ZOAp0rR2q7ugbwCmpPuLc5JJJsyeuOMZBtHGQvg
         camw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715108866; x=1715713666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jkQu4Jm3xj+OSWk/nhy3+Jt5eXwFDQEAw7ll75hZ8tw=;
        b=euqsKr7bxf35Ft6lmALJc+J2kppFhtHs7T5M3T1QcBS6Y6EIrtv3Kw1ct4C/biQZvy
         m8xmU22LEV6FyAkjjYloYc/BrboOLvqx71jbxsqvkekcx0loO4+Ttu9cyHAeMkdJ5VuT
         ohF0xK7nbuEoIi3Oqimw2UDhx9pbS3dRnN5BpFmjRGW6+NuQ2s+nz5O0NnTs9E5Lrr/O
         DF71SNZdHRBBlNqzXZAWy5eSqPFePr6rBbFtWukH/n8yy11FA3Gofiw+XsJBkARrDry5
         752gJLFsyNsFqr2RSbDLtmdr+g7y5+eYcIeT+ZUEAQXia0Hhzf3jcE3fP9+5y9R1JNlQ
         AkFA==
X-Forwarded-Encrypted: i=1; AJvYcCWULvDqDWgyRHZcwXmXuoAoPm1y57igpVDDseXg5wqcP/9j6brTV9GDJA674HG9Y1Qzfb1MOJDG2bWUSkfFAAwP5QQ6
X-Gm-Message-State: AOJu0YylD6T4Rd7j0hXYQ6Rn91JXeodDYIzOUJ3a2p2Iz5E+604jhrm5
	7nz0BdPcbov2Y08aB5NuN4b55a8mRuak/bWp+MiXFNF0t/PyXFZIFwBWb+WLH5b7R+deTb+TeZL
	/2A==
X-Google-Smtp-Source: AGHT+IEgjxdsHk9aJmOIaJyY9cp6EJfT5579+ZXn0lQR+zEfJ/cnb/Xx+FkIFQJQtpXQchgkEeeXdrdRsVg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:fe18:0:b0:5d6:cfc:2f39 with SMTP id
 41be03b00d2f7-62f23220b0fmr23804a12.11.1715108865796; Tue, 07 May 2024
 12:07:45 -0700 (PDT)
Date: Tue, 7 May 2024 12:07:44 -0700
In-Reply-To: <9252b68e-2b6a-6173-2e13-20154903097d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416050338.517-1-ravi.bangoria@amd.com> <ZjQnFO9Pf4OLZdLU@google.com>
 <9252b68e-2b6a-6173-2e13-20154903097d@amd.com>
Message-ID: <Zjp8AIorXJ-TEZP0@google.com>
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, michael.roth@amd.com, nikunj.dadhania@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, May 06, 2024, Ravi Bangoria wrote:
> On 03-May-24 5:21 AM, Sean Christopherson wrote:
> > On Tue, Apr 16, 2024, Ravi Bangoria wrote:
> >> Currently, LBR Virtualization is dynamically enabled and disabled for
> >> a vcpu by intercepting writes to MSR_IA32_DEBUGCTLMSR. This helps by
> >> avoiding unnecessary save/restore of LBR MSRs when nobody is using it
> >> in the guest. However, SEV-ES guest mandates LBR Virtualization to be
> >> _always_ ON[1] and thus this dynamic toggling doesn't work for SEV-ES
> >> guest, in fact it results into fatal error:
> >>
> >> SEV-ES guest on Zen3, kvm-amd.ko loaded with lbrv=1
> >>
> >>   [guest ~]# wrmsr 0x1d9 0x4
> >>   KVM: entry failed, hardware error 0xffffffff
> >>   EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000
> >>   ...
> >>
> >> Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.
> > 
> > Uh, what?  I mean, sure, it works, maybe, I dunno.  But there's a _massive_
> > disconnect between the first paragraph and this statement.
> > 
> > Oh, good gravy, it "works" because SEV already forces LBR virtualization.
> > 
> > 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
> > 
> > (a) the changelog needs to call that out.
> 
> Sorry, I should have called that out explicitly.
> 
> >  (b) KVM needs to disallow SEV-ES if
> > LBR virtualization is disabled by the admin, i.e. if lbrv=false.
> 
> That's what I initially thought. But since KVM currently allows booting SEV-ES
> guests even when lbrv=0 (by silently ignoring lbrv value), erroring out would
> be a behavior change.

IMO, that's totally fine.  There are no hard guarantees regarding module params,

> > Alternatively, I would be a-ok simply deleting lbrv, e.g. to avoid yet more
> > printks about why SEV-ES couldn't be enabled.
> > 
> > Hmm, I'd probably be more than ok.  Because AMD (thankfully, blessedly) uses CPUID
> > bits for SVM features, the admin can disable LBRV via clear_cpuid (or whatever it's
> > called now).  And there are hardly any checks on the feature, so it's not like
> > having a boolean saves anything.  AMD is clearly committed to making sure LBRV
> > works, so the odds of KVM really getting much value out of a module param is low.
> 
> Currently, lbrv is not enabled by default with model specific -cpu profiles in
> qemu. So I guess this is not backward compatible?

I am talking about LBRV being disabled in the _host_ kernel, not guest CPUID.
QEMU enabling LBRV only affects nested SVM, which is out of scope for SEV-ES.

> > And then when you delete lbrv, please add a WARN_ON_ONCE() sanity check in
> > sev_hardware_setup() (if SEV-ES is supported), because like the DECODEASSISTS
> > and FLUSHBYASID requirements, it's not super obvious that LBRV is a hard
> > requirement for SEV-ES (that's an understatment; I'm curious how some decided
> > that LBR virtualization is where the line go drawn for "yeah, _this_ is mandatory").
> 
> I'm not sure. Some ES internal dependency.
> 
> In any case, the patch simply fixes 'missed clearing MSR Interception' for
> SEV-ES guests. So, would it be okay to apply this patch as is and do lbrv
> cleanup as a followup series?

No.

(a) the lbrv module param mess needs to be sorted out.
(b) this is not a complete fix.
(c) I'm not convinced it's the right way to fix this, at all.
(d) there's a big gaping hole in KVM's handling of MSRs that are passed through
    to SEV-ES guests.
(e) it's not clear to me that KVM needs to dynamically toggle LBRV for _any_ guest.
(f) I don't like that sev_es_init_vmcb() mucks with the LBRV intercepts without
    using svm_enable_lbrv().

Unless I'm missing something, KVM allows userspace to get/set MSRs for SEV-ES
guests, even after the VMSA is encrypted.  E.g. a naive userspace could attempt
to migrate MSR_IA32_DEBUGCTLMSR and end up unintentionally disabling LBRV on the
target.  The proper fix for VMSA being encrypted is to likely to disallow
KVM_{G,S}ET_MSR on MSRs that are contexted switched via the VMSA.

But that doesn't address the issue where KVM will disable LBRV if userspace
sets MSR_IA32_DEBUGCTLMSR before the VMSA is encrypted.  The easiest fix for
that is to have svm_disable_lbrv() do nothing for SEV-ES guests, but I'm not
convinced that's the best fix.

AFAICT, host perf doesn't use the relevant MSRs, and even if host perf did use
the MSRs, IIUC there is no "stack", and #VMEXIT retains the guest values for
non-SEV-ES guests.  I.e. functionally, running with and without LBRV would be
largely equivalent as far as perf is concerned.  The guest could scribble an MSR
with garbage, but overall, host perf wouldn't be meaningfully affected by LBRV.

So unless I'm missing something, the only reason to ever disable LBRV would be
for performance reasons.  Indeed the original commits more or less says as much:

  commit 24e09cbf480a72f9c952af4ca77b159503dca44b
  Author:     Joerg Roedel <joerg.roedel@amd.com>
  AuthorDate: Wed Feb 13 18:58:47 2008 +0100

    KVM: SVM: enable LBR virtualization
    
    This patch implements the Last Branch Record Virtualization (LBRV) feature of
    the AMD Barcelona and Phenom processors into the kvm-amd module. It will only
    be enabled if the guest enables last branch recording in the DEBUG_CTL MSR. So
    there is no increased world switch overhead when the guest doesn't use these
    MSRs.

but what it _doesn't_ say is what the world switch overhead is when LBRV is
enabled.  If the overhead is small, e.g. 20 cycles?, then I see no reason to
keep the dynamically toggling.

And if we ditch the dynamic toggling, then this patch is unnecessary to fix the
LBRV issue.  It _is_ necessary to actually let the guest use the LBRs, but that's
a wildly different changelog and justification.

And if we _don't_ ditch the dynamic toggling, then sev_es_init_vmcb() should be
using svm_enable_lbrv(), not open coding the exact same thing.

