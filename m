Return-Path: <kvm+bounces-57781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03D95B5A1B1
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 21:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBE2617997B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51C3D2E54B9;
	Tue, 16 Sep 2025 19:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HsgD5jbk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D7F19F40A
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 19:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758052443; cv=none; b=KWZ/IRu3SsvPcVHYxWx5JEt25jTI06Qb3MLDZGUGrIvD97dtB6Z2/Gm3JKWvSwudpASTA1LFChTAy2VX+Y1P5eTiJshXJ/VugnZQkSp6APLTryyt+ZXSWQmJKACEay1/y1m4RH7fr8JZkj/Mc0qrG0eWy4WpWq8dJVlr1pvefIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758052443; c=relaxed/simple;
	bh=K42TrTHCprp/z96FHfYhNr0g4AcPAvf8SJ9hfIxuUlY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N34nZMAzIPZBjj2VGb2qBZ7o5YgbUhz+ze+qhMmvB4MEve8vMjY9mTQ4E8FUBTTpN2EYDqsjmT3WIcJ+yK30bDWUuwY+jUIL7fiDPS5ADRYH3YIWAxGMwNs2nbgfPhqTWYNC73HzldWxV7QCwVLOBREM4fi5lwUEkmmCrdxE+FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HsgD5jbk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec2211659so611896a91.0
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 12:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758052440; x=1758657240; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ypCkSV2j4XpnxIOH+Xa4yIgQz4o/rWKDyEIeCFtvkq4=;
        b=HsgD5jbknGT83Tm4s3Z05jNWWI229EOEl1zn9+LSzWXCXomR9N/rjMEkn8CI+JuJm/
         Ku8wWLHb73zHZ8T9SVGkkezaWcdzKpQpa0sdIbjAf9AB+UrjMCSJWmrvhBXA6k0y4b7/
         sfQaVxWiEBbtSzVwH5txF+rLq1OMMhE7unEhFgSFr1W7d7NyOFh8I/bSKKtfzzhOxnKE
         uOmhFUEkz5PBP+XJ+Z2cCouNeeKCSpTNgEP8Sb5zOgVcujSBwizx7ccDT0K9E5V9oeOb
         9mxdW1oNBz+tFa4A/ShLRgLsHuQFpl4lfHVkfSrrI8sYqHNjm6veVYziY2x+goqipnz1
         eICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758052440; x=1758657240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ypCkSV2j4XpnxIOH+Xa4yIgQz4o/rWKDyEIeCFtvkq4=;
        b=WpVEuh6I8GeqKnDiUfzW2nvbA/IMHDH59TaVJ2+TH9EWv9wIqTnKco+0BdmV7kyPca
         edJ9s4fHWSm4Gom3ZIVlwxdXf3+DMD28G1gYMnUs7rwHWhy6GVGsQ1R22axhN3o+vvwD
         jZzXD/5Db9ryhwAQnrPud02kQHrjavnW5Oq2jLlQYZxcBbqegEQAxjrUyWmJX6eSHKiZ
         zS1ATNvNZw72Hl1XvfXcGcaJZ/VNvwTQAREjHhveQB4Tp0JTbV5ah7lris0ndW/ZoFLk
         Hg0xdo/mIA6l4hM0LbuY30o0zLL3X6+nin05gD6rBHPkz5JoLL1jVIkSh46qNWNI4OtP
         LcDA==
X-Forwarded-Encrypted: i=1; AJvYcCV2L9HSh6Giq7XfhD/pN1jlv4EB0sg7PlI9yJVDOTgaEZYDnDrYZf2cJQE4A77kQd/zVII=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTLFUhc+jQHCeC7cvNHAtj0yzN1VaKToo00qH3Li3z6X6+eTLN
	1QLcAESQqnskVQTaWw6Haj1PqJmavIEF4k2dPk3Itx7/8qpYGxAOkG65AspNWVRU67sUewfsQdF
	3rWxigA==
X-Google-Smtp-Source: AGHT+IF7V5/RFWKziMu7+PnjJdaAV3vmh8rDnydpSEaIMymcODcxVrmX+z/O7AjuUkm0xOVeP/MX9RaLbHg=
X-Received: from pjbqi2.prod.google.com ([2002:a17:90b:2742:b0:32d:def7:e60f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1810:b0:32b:d8af:b636
 with SMTP id 98e67ed59e1d1-32de4f87766mr22838318a91.19.1758052440244; Tue, 16
 Sep 2025 12:54:00 -0700 (PDT)
Date: Tue, 16 Sep 2025 12:53:58 -0700
In-Reply-To: <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-30-seanjc@google.com>
 <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com>
Message-ID: <aMnAVtWhxQipw9Er@google.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 16, 2025, John Allen wrote:
> On Fri, Sep 12, 2025 at 04:23:07PM -0700, Sean Christopherson wrote:
> > Synchronize XSS from the GHCB to KVM's internal tracking if the guest
> > marks XSS as valid on a #VMGEXIT.  Like XCR0, KVM needs an up-to-date copy
> > of XSS in order to compute the required XSTATE size when emulating
> > CPUID.0xD.0x1 for the guest.
> > 
> > Treat the incoming XSS change as an emulated write, i.e. validatate the
> > guest-provided value, to avoid letting the guest load garbage into KVM's
> > tracking.  Simply ignore bad values, as either the guest managed to get an
> > unsupported value into hardware, or the guest is misbehaving and providing
> > pure garbage.  In either case, KVM can't fix the broken guest.
> > 
> > Note, emulating the change as an MSR write also takes care of side effects,
> > e.g. marking dynamic CPUID bits as dirty.
> > 
> > Suggested-by: John Allen <john.allen@amd.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/sev.c | 3 +++
> >  arch/x86/kvm/svm/svm.h | 1 +
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 0cd77a87dd84..0cd32df7b9b6 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3306,6 +3306,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> >  	if (kvm_ghcb_xcr0_is_valid(svm))
> >  		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));
> >  
> > +	if (kvm_ghcb_xss_is_valid(svm))
> > +		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(ghcb));
> > +
> 
> It looks like this is the change that caused the selftest regression
> with sev-es. It's not yet clear to me what the problem is though.

Do you see any WARNs in the guest kernel log?

The most obvious potential bug is that KVM is missing a CPUID update, e.g. due
to dropping an XSS write, consuming stale data, not setting cpuid_dynamic_bits_dirty,
etc.  But AFAICT, CPUID.0xD.1.EBX (only thing that consumes the current XSS) is
only used by init_xstate_size(), and I would expect the guest kernel's sanity
checks in paranoid_xstate_size_valid() to yell if KVM botches CPUID emulation.

Another possibility is that unconditionally setting cpuid_dynamic_bits_dirty
was masking a pre-existing (or just different) bug, and that "fixing" that flaw
by eliding cpuid_dynamic_bits_dirty when "vcpu->arch.ia32_xss == data" exposed
the bug.

