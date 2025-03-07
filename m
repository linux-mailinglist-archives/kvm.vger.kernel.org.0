Return-Path: <kvm+bounces-40468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF73A575B9
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 00:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F3B2189A36A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 23:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7CB258CEB;
	Fri,  7 Mar 2025 23:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EuGdljpt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68C519006F
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 23:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741388688; cv=none; b=JiqLeKfS6QVS5lN5nWPzNV8/GqDjy3k9nsvISwuk7rJCwyXb5guumzDxG0OoSoU+9/a4KIhaVDnoDWqOICCnps3vZRK4XgELu2DeC1kME7V7GBz423N/unfw2+HhfkNG0XjXcEgoHj3lLgULgxOpAwn6F+5XjUk6blom6NDyryA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741388688; c=relaxed/simple;
	bh=037h1qvGSyHX25RVz/MQsjTkT/9oI6JagFBorEczsZI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SqHhKpf+U1k+8a1b34tyBUrngpT42ptXbslVnftyhrB/MxxaQl4bW7rYacdZ4a6+nXpau8ZCeKMW+wNLTyNZVrweE5bBRl/752v0EI0VhicEavEq0Z9dA2AcaDJ0wb13HVOgzbqbgXW2Soy8TcBexrkdWEy57UfOCOnBL5M2gio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EuGdljpt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-223f63b450eso40822295ad.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 15:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741388686; x=1741993486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cT76M5nOMYPj1kKKAkhRDAQZijMJO1Yeab7naAnYE5o=;
        b=EuGdljptDQqHRrrLWOhro6Yznt65Y2Cwcxfq9w/l+xM0dZcMlbubhYtHdi1Ytg1bhx
         DhSheno6DQ8T3TCPxMGNECHrmBakgCZI9X1AtMwWhz+6+x6chrDvHd6bi3XtlwDwWkOp
         GxotDFu3RxUOWOvBlEgPPq57DBRDUylXUsoatoRb+G6vguyVh6QQbvu/WisKIFk3dOUy
         luJPIENRT3yqSEMmCKALD9KOpOqtTCdGRaKUSylRwdOyh/nyNjBG993PpDbmII9eQzCh
         f+arbe75tUdqWmvh2j+pc5gSrKoNytlAxEmc1mJu4JVWWrcBbgHNnJfSX7HyOPFJAED2
         vqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741388686; x=1741993486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cT76M5nOMYPj1kKKAkhRDAQZijMJO1Yeab7naAnYE5o=;
        b=vqFMtasBLlrUGxoYNKWjCZwU8IhEqf1BmLmLLHDFpAJxl7eFQHHkWk7ZWglWZFk/ZN
         vpl5ge3wHPrdgi1xkyg3fwDM1FyfGBSteDtcQyEYzZpQIBhhFQQdgPtpox4nL303FH2E
         hGsWTQRygmU2O+bsmX4d/tFK4otWs8Xei7z6l7VOuIRDCYD7OWZvoP45QylBwC0H7+Bq
         qedKtkOE5XNfNTZc1eutueRCVp+K0JV4yWr/9gD7RBJG3kbhjCeFpZdqUMILmqxoTKyT
         zDin6YZ+gjqU2eUBItdFWan8ohuRdUqeBwovS1Y523DKj7jUuilwSq8DLRa6PSqBGJp3
         iRKw==
X-Forwarded-Encrypted: i=1; AJvYcCXxolIcGq/AXPS1eqq3OcnRXhMnTkN/yo5TKKI4S6hqCXAARLUt+3ezhUHtYQokpX1vEWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3Tj7TWZwCNTQP12pPnpIXI99Wj7nC3wVs3VVVQMGBVZHld6QJ
	A7bBzfSAxDekfij35UQhr0zN7HHfG7pZfGTyb8D66sCRuzSMKp8SFb43XRHkz3thum4yos/dBTs
	uAQ==
X-Google-Smtp-Source: AGHT+IHct+pLavXuZw6EDxxZ7ZokK0tGuArbgipPORHJKdMgfjFghFar2LGWx+A6U/e+4H/R7dy+puDVzRA=
X-Received: from pjbmf14.prod.google.com ([2002:a17:90b:184e:b0:2ef:7af4:5e8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf41:b0:223:5e76:637a
 with SMTP id d9443c01a7336-2242889c67bmr85553605ad.23.1741388686143; Fri, 07
 Mar 2025 15:04:46 -0800 (PST)
Date: Fri, 7 Mar 2025 15:04:44 -0800
In-Reply-To: <CABgObfahNJWCMPMV101ta-d0Cxu=RjjfMkKbOWTdRmk_VtACuw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-3-adrian.hunter@intel.com> <01e85b96-db63-4de2-9f49-322919e054ec@intel.com>
 <0745c6ee-9d8b-4936-ab1f-cfecceb86735@redhat.com> <Z8oImITJahUiZbwj@google.com>
 <CABgObfahNJWCMPMV101ta-d0Cxu=RjjfMkKbOWTdRmk_VtACuw@mail.gmail.com>
Message-ID: <Z8t16I-UXNQhcd3N@google.com>
Subject: Re: [PATCH V2 02/12] KVM: x86: Allow the use of kvm_load_host_xsave_state()
 with guest_state_protected
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	kvm <kvm@vger.kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, reinette.chatre@intel.com, 
	Tony Lindgren <tony.lindgren@linux.intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Nikolay Borisov <nik.borisov@suse.com>, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 06, 2025, Paolo Bonzini wrote:
> Il gio 6 mar 2025, 21:44 Sean Christopherson <seanjc@google.com> ha scritto:
> > > Allowing the use of kvm_load_host_xsave_state() is really ugly, especially
> > > since the corresponding code is so simple:
> > >
> > >         if (cpu_feature_enabled(X86_FEATURE_PKU) && vcpu->arch.pkru != 0)
> > >                         wrpkru(vcpu->arch.host_pkru);
> >
> > It's clearly not "so simple", because this code is buggy.
> >
> > The justification for using kvm_load_host_xsave_state() is that either KVM gets
> > the TDX state model correct and the existing flows Just Work, or we handle all
> > that state as one-offs and at best replicate concepts and flows, and at worst
> > have bugs that are unique to TDX, e.g. because we get the "simple" code wrong,
> > we miss flows that subtly consume state, etc.
> 
> A typo doesn't change the fact that kvm_load_host_xsave_state is
> optimized with knowledge of the guest CR0 and CR4; faking the values
> so that the same field means both "exit value" and "guest value",

I can't argue against that, but I still absolutely detest carrying dedicated code
for SEV and TDX state management.  It's bad enough that figuring out WTF actually
happens basically requires encyclopedic knowledge of massive specs.

I tried to figure out a way to share code, but everything I can come up with that
doesn't fake vCPU state makes the non-TDX code a mess.  :-(

> just so that the common code does the right thing for pkru/xcr0/xss,

FWIW, it's not just to that KVM does the right thing for those values, it's a
defense in depth mechanism so that *when*, not if, KVM screws up, the odds of the
bug being fatal to KVM and/or the guest are reduced.

> is > unmaintainable and conceptually just wrong. 

I don't necessarily disagree, but what we have today isn't maintainable either.
Without actual sanity check and safeguards in the low level helpers, we absolutely
are playing a game of whack-a-mole.

E.g. see commit 9b42d1e8e4fe ("KVM: x86: Play nice with protected guests in
complete_hypercall_exit()").

At a glance, kvm_hv_hypercall() is still broken, because is_protmode() will return
false incorrectly.

> And while the change for XSS (and possibly other MSRs) is actually correct,
> it should be justified for both SEV-ES/SNP and TDX rather than sneaked into
> the TDX patches.
> 
> While there could be other flows that consume guest state, they're
> just as bound to do the wrong thing if vcpu->arch is only guaranteed
> to be somehow plausible (think anything that for whatever reason uses
> cpu_role).

But the MMU code is *already* broken.  kvm_init_mmu() => vcpu_to_role_regs().  It
"works" because the fubar role is never truly consumed.  I'm sure there are more
examples.

> There's no way the existing flows for !guest_state_protected should run _at
> all_ when the register state is not there. If they do, it's a bug and fixing
> them is the right thing to do (it may feel like whack-a-mole but isn't)

Eh, it's still whack-a-mole, there just happen to be a finite number of moles :-)

