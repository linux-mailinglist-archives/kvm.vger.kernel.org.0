Return-Path: <kvm+bounces-34223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C815D9F9686
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 17:27:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E68181893B54
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 16:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BECF21A92F;
	Fri, 20 Dec 2024 16:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RtoZGMjR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADFA218E9F
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 16:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734711766; cv=none; b=QPx7BNJtAqgOrZnrJ71mFR3KJhN0+BZu+VpOIP+XICbVwnJwXg3sn8P9cSLyiM0RMYX2ZLrKMUk9un/NfLEbNJagJLF+0y+nVQs6+ya7giU7Yovi2WFpw2Tu8nb4B6HtMQMCQNZ1mJS8+h3RbDL2ROo0W4GlG1mQpnJBAMypxyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734711766; c=relaxed/simple;
	bh=OAbms7px7/uvh4qcnGbWJEZ5P9BijvzHJ4QNctMzLEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vbco2a/f1/A38odVQFEa4TLsrYK8z1hNRwxtwxfkjYkoz4Z1/brHsb/yBRyBFdnsVl2Omc82WI6uzGv8ZkDO/VXdQJwJh5y/VniXDaSbYvgWSrDTKgVoJ6NbGD7GrzAwjPY/Xe9IZmw0ZRBPqoGA5XWgwwAPut/xlOAD2eIpyAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RtoZGMjR; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-725e87a142dso2918586b3a.2
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 08:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734711764; x=1735316564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B9G3vOfcvMrHWQEUvh3J/FxRFJb1hf1Q+LxRRkvzz8Q=;
        b=RtoZGMjRYIpMVYFYB5+nCwnGAyylykvNBxCaLdy5VUVpId65YFF0uj5DXm4el+yXRa
         7snp98GL0RbQh8V78n5PGXpjnTqaU98yV+QBNYCz+phlm1CXcwKNrXW+THNfOqKjd+2C
         AWMn2ZEqoqNaocjCTyyD1H+KRCnd4rSwRzOb4SjUgEpIFD9GyyDUktcKDQRp25UPoKJI
         7NxxrXmXXj17dcFP2pXHVdbzNY7gwDUt7AvFUKd/VDksyjdpvVL3072FRUykCKNc8jaM
         lxmo+Hx2+09I57AAodunqtJc7yvxs7GKtF7v+e5RULPX+FlhgGhnOrGU4OSvAyzv3txX
         HSrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734711764; x=1735316564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B9G3vOfcvMrHWQEUvh3J/FxRFJb1hf1Q+LxRRkvzz8Q=;
        b=Z1O1UOKxP5rBKkokeiCorLI94bVlZ6bhH08yyZMOg2cmm6cGLIbEk4P57CY4Q8fAsz
         uiGzFT7FKnY/z0BDHkpIZ/6H5GMx3PwC7BV8lCJLjHdL8QR+f93WYdpihEpcsNaaVnMd
         DpCQ7DZSD0eWnWg8nfYmWKTTrenqODNCrATxDwAbTKVhFZt03VgDd7lQOlOjkh0iqgZ0
         Q2LasUbOAbPE7bvTqYI8Hm2HEAQu+0gGzlvko7ce7EVSfCEcF6Tw8H+7Gtp9fRv87Lhu
         CjaDWL61CeB+hZ0lcOh4UogsmfvkZXLyjnT5FoDbnarhPhohGSmI2fjaOamRBz16xRjX
         5+UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbqLusNXUZfSzITAXym7a+iIUV4XhtLDnEhduTZC7rGHh09u3h8QAR8GxBbldP9TWMNXQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuSSZoEC8ylxjX6MXxdt9iKJ7IXzZfK8/vtBLjuqaVJFgm/TT9
	FWsL51sLJUzBOWmJnv/wdFwJt3NrlAx0PhtTeDCL0ZV3jXe9eJI6+SAekmWaQlvxeOGCMk0lvHb
	mSw==
X-Google-Smtp-Source: AGHT+IFkTYIcCL1l9o5RjDKPoaVQan11oBznC39bFG2ZH8ecuKgl3pM8An2YgW6zEDhm2+81Oc0jo7ML8Jo=
X-Received: from pfoi26.prod.google.com ([2002:aa7:87da:0:b0:72a:c59c:ef6e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:f96:b0:724:ed8f:4d35
 with SMTP id d2e1a72fcca58-72abdedda5fmr5482723b3a.26.1734711764569; Fri, 20
 Dec 2024 08:22:44 -0800 (PST)
Date: Fri, 20 Dec 2024 08:22:43 -0800
In-Reply-To: <487a32e6-54cd-43b7-bfa6-945c725a313d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com> <Z2GiQS_RmYeHU09L@google.com>
 <487a32e6-54cd-43b7-bfa6-945c725a313d@intel.com>
Message-ID: <Z2WZ091z8GmGjSbC@google.com>
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org, yan.y.zhao@intel.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 20, 2024, Adrian Hunter wrote:
> On 17/12/24 18:09, Sean Christopherson wrote:
> > On Mon, Nov 25, 2024, Adrian Hunter wrote:
> > I would rather just use kvm_load_host_xsave_state(), by forcing vcpu->arch.{xcr0,xss}
> > to XFAM, with a comment explaining that the TDX module sets XCR0 and XSS prior to
> > returning from VP.ENTER.  I don't see any justificaton for maintaining a special
> > flow for TDX, it's just more work.  E.g. TDX is missing the optimization to elide
> > WRPKRU if the current value is the same as the host value.
> 
> Not entirely missing since write_pkru() does do that by itself:
> 
> static inline void write_pkru(u32 pkru)
> {
> 	if (!cpu_feature_enabled(X86_FEATURE_OSPKE))
> 		return;
> 	/*
> 	 * WRPKRU is relatively expensive compared to RDPKRU.
> 	 * Avoid WRPKRU when it would not change the value.
> 	 */
> 	if (pkru != rdpkru())
> 		wrpkru(pkru);

Argh.  Well that's a bug.  KVM did the right thing, and then the core kernel
swizzled things around and got in the way.  I'll post this once it's fully tested:

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 20 Dec 2024 07:38:39 -0800
Subject: [PATCH] KVM: x86: Avoid double RDPKRU when loading host/guest PKRU

Use the raw wrpkru() helper when loading the guest/host's PKRU on switch
to/from guest context, as the write_pkru() wrapper incurs an unnecessary
rdpkru().  In both paths, KVM is guaranteed to have performed RDPKRU since
the last possible write, i.e. KVM has a fresh cache of the current value
in hardware.

This effectively restores KVM behavior to that of KVM rior to commit
c806e88734b9 ("x86/pkeys: Provide *pkru() helpers"), which renamed the raw
helper from __write_pkru() => wrpkru(), and turned __write_pkru() into a
wrapper.  Commit 577ff465f5a6 ("x86/fpu: Only write PKRU if it is different
from current") then added the extra RDPKRU to avoid an unnecessary WRPKRU,
but completely missed that KVM already optimized away pointless writes.

Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 577ff465f5a6 ("x86/fpu: Only write PKRU if it is different from current")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4320647bd78a..9d5cece9260b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1186,7 +1186,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 	    vcpu->arch.pkru != vcpu->arch.host_pkru &&
 	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
 	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE)))
-		write_pkru(vcpu->arch.pkru);
+		wrpkru(vcpu->arch.pkru);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
@@ -1200,7 +1200,7 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
 		vcpu->arch.pkru = rdpkru();
 		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
-			write_pkru(vcpu->arch.host_pkru);
+			wrpkru(vcpu->arch.host_pkru);
 	}
 
 	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {

base-commit: 13e98294d7cec978e31138d16824f50556a62d17
-- 

> }
> 
> For TDX, we don't really need rdpkru() since the TDX Module
> clears it, so it could be:
> 
> 	if (pkru)
> 		wrpkru(pkru);

Ah, right, there's no need to do RDPKRU because KVM knows it's zero.  On top of
my previous suggestion:

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e23cd8231144..9e490fccf073 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -664,11 +664,12 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
        /*
         * On return from VP.ENTER, the TDX Module sets XCR0 and XSS to the
-        * maximal values supported by the guest, so from KVM's perspective,
-        * those are the guest's values at all times.
+        * maximal values supported by the guest, and zeroes PKRU, so from
+        * KVM's perspective, those are the guest's values at all times.
         */
        vcpu->arch.ia32_xss = (kvm_tdx->xfam & XFEATURE_SUPERVISOR_MASK);
        vcpu->arch.xcr0 = (kvm_tdx->xfam & XFEATURE_USE_MASK);
+       vcpu->arch.pkru = 0;
 
        return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d380837433c6..d2ea7db896ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1208,7 +1208,8 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
        if (cpu_feature_enabled(X86_FEATURE_PKU) &&
            ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
             kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
-               vcpu->arch.pkru = rdpkru();
+               if (!vcpu->arch.guest_state_protected)
+                       vcpu->arch.pkru = rdpkru();
                if (vcpu->arch.pkru != vcpu->arch.host_pkru)
                        write_pkru(vcpu->arch.host_pkru);
        }

> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 7eff717c9d0d..b49dcf32206b 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -636,6 +636,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> >  	vcpu->arch.cr0_guest_owned_bits = -1ul;
> >  	vcpu->arch.cr4_guest_owned_bits = -1ul;
> >  
> > +	vcpu->arch.cr4 = <maximal value>;
> 
> Sorry for slow reply.  Seems fine except maybe CR4 usage.
> 
> TDX Module validates CR4 based on XFAM and scrubs host state
> based on XFAM.  It seems like we would need to use XFAM to
> manufacture a CR4 that we then effectively use as a proxy
> instead of just checking XFAM.

Yep.

> Since only some vcpu->arch.cr4 bits will be meaningful, it also
> still leaves the possibility for confusion.

IMO, it's less confusing having '0' for CR0 and CR4, while having accurate values
for other state.  And I'm far more worried about KVM wondering into a bad path
because CR0 and/or CR4 are completely wrong.  E.g. kvm_mmu.cpu_role would be
completely wrong at steady state, the CR4-based runtime CPUID updates would do
the wrong thing, and any helper that wraps kvm_is_cr{0,4}_bit_set() would likely
do the worst possible thing.

> Are you sure you want this?

Yeah, pretty sure.  It would be nice if the TDX Module exposed guest CR0/CR4 to
KVM, a la the traps SEV-ES+ uses, but I think the next best thing is to assume
the guest is using all features.

> > +	vcpu->arch.cr0 = <maximal value, give or take>;
> 
> AFAICT we don't need to care about CR0

Probably not, but having e.g. CR4.PAE/LA57=1 with CR0.PG/PE=0 will be quite
weird.

