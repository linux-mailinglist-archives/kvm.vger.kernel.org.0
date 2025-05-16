Return-Path: <kvm+bounces-46800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F8EEAB9CEB
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D8F6A205D7
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 13:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EDE224337C;
	Fri, 16 May 2025 13:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3gflXpBR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380AB241CBA
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 13:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747400839; cv=none; b=gH7CDQ+tNyhqBaPWSQIf4yZ00pErizyEXU3qrxZF1mqGG2uR64bZAZZ0nDYDFcaqK0KPLo7tPZ6o1vMYc7ccN5+uiRlP3gLaTCP1A1LHSF1qDf4wPoIBqWWc+d24dQOwNnNSaxR1s1/zsGILZu6GEbO2Hzj5KfRh49ye4tCoMWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747400839; c=relaxed/simple;
	bh=PrrUQ+uxcDi3ejokw76IebhFgwbzAkd2ege5T4RwaQA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ja1n5P20I9+0kFWW5hOFFzxT1LbR+TchBpnA8ly1+lMIDbS6z6eJGpRB1G8zh2D/2jyrzKoAPOmIrHmykEb80IJS6OyPaXrfK49gh/5cwg9S/sfQB0OTfQsCy1qQ4rfC89WIznFVl9KrB3MXUZft3y5d9aA7IJAqZl7qo8f6kpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3gflXpBR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30c4bdd0618so2319167a91.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 06:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747400837; x=1748005637; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tyoRdtKKaC94EYmOIfUvbZygUJ2Y/x95QZCsEe1TaYk=;
        b=3gflXpBRAYlPbCicbU2bc1zwZaG7l4ZV+1HUpPv37dmQ3dFthfr+9lxblzrgqj4vwx
         HXbiNdetWYefArj7O0R2A+dopNHZ48eHLLAvaDuDwG6uQ0x8YUGK/0onEGS1WpQmQkMd
         ZPF6Bkt2oeLf4q41Vh0odTzlNnYzy87y9JDjGMiNOmUZOoZCD5Z/LbpSPkr6FSQ6/wxv
         vA/ferllY+imHNVyVHgEFmXVuxmdNxYB/vhcsB/aaJOgVmMYqbQ4K2GSGCITcfgKDoAL
         7OQG5R9qdJ6goVXoVi3UrZ4s4U2NnwR8IgINYPeotmoIuLp4s4jKsd48wRRk3Ybxi21z
         Rrbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747400837; x=1748005637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tyoRdtKKaC94EYmOIfUvbZygUJ2Y/x95QZCsEe1TaYk=;
        b=g8++yw9tWQdSgF7aAtLl00G0hiIc5YFTgctHQoLti+CimffKypH2MQ8Mp9HFXWUuUl
         L9h93572e+ShflwpEBSPykhS51qyWumhqpgeZTblATeVEWPLpjgT1CtnzvDjmbFhEG1f
         YDjpsvwrGVzA8hivmZo5PzwsDsKz0ip3mqzljaJPYlRolM82fXuKnlfriVoGNlkpxkLZ
         A7AtZF6p48m5ONRxNBmUS0ojGxiY5dNKVHnPLn3HxkLTBqlJMD/iTM7nmULdGkBMlKjz
         Yk+JuG4vMwNCPxXyWbAUHMMlYLJxrZqRkW3AXp+Y6WsJFkgzzs73o94/9GOoWP92c9Ij
         tdDw==
X-Forwarded-Encrypted: i=1; AJvYcCWNAepJR+58xGgdSHEZL5wJ993trUzVU1+c9cAPhkKnerqJB71EAcCIglkmrOrPFuSOrBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+vy8+SpK6Q/lYzQ6eyt/bhojX5uMc3sOV9HspYZ2z+g/322wj
	fgaPGiTL3t5mmFY1aXTdJofx+hGQwgWHmGox+fGIiy1hLCM17HvLQ0AowWM84zWeXyVpJOpmboI
	Y5jAhvw==
X-Google-Smtp-Source: AGHT+IG7myX6oiMz2Z4cjLxZfhIbXYUSxKscGQl9RlY+MIP6DC2PxaUFBqS+Tplw6v4f+Ga8vY6ITsGFKfQ=
X-Received: from pjboi16.prod.google.com ([2002:a17:90b:3a10:b0:2fc:2ee0:d38a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d47:b0:305:2d68:8d55
 with SMTP id 98e67ed59e1d1-30e7d52a4f5mr4119316a91.8.1747400837464; Fri, 16
 May 2025 06:07:17 -0700 (PDT)
Date: Fri, 16 May 2025 06:07:15 -0700
In-Reply-To: <aCbf6JikteXzb0gB@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250515005353.952707-1-mlevitsk@redhat.com> <20250515005353.952707-3-mlevitsk@redhat.com>
 <aCbf6JikteXzb0gB@intel.com>
Message-ID: <aCc4gyb_hrQZs9Ya@google.com>
Subject: Re: [PATCH v4 2/4] KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a
 new KVM_RUN flag
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 16, 2025, Chao Gao wrote:
> >diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >index c8b8a9947057..026b28051fff 100644
> >--- a/arch/x86/kvm/svm/svm.c
> >+++ b/arch/x86/kvm/svm/svm.c
> >@@ -4308,10 +4308,13 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
> > 	svm_hv_update_vp_id(svm->vmcb, vcpu);
> > 
> > 	/*
> >-	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
> >-	 * of a #DB.
> >+	 * Run with all-zero DR6 unless the guest can write DR6 freely, so that
> >+	 * KVM can get the exact cause of a #DB.  Note, loading guest DR6 from
> >+	 * KVM's snapshot is only necessary when DR accesses won't exit.
> > 	 */
> >-	if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
> >+	if (unlikely(run_flags & KVM_RUN_LOAD_GUEST_DR6))
> >+		svm_set_dr6(vcpu, vcpu->arch.dr6);
> >+	else if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
> > 		svm_set_dr6(vcpu, DR6_ACTIVE_LOW);
> 
> ...
> 
> > void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
> > {
> > 	vmcs_writel(GUEST_DR7, val);
> >@@ -7371,6 +7365,9 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
> > 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
> > 	vcpu->arch.regs_dirty = 0;
> > 
> >+	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
> >+		set_debugreg(vcpu->arch.dr6, 6);
> >+
> > 	/*
> > 	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
> > 	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 25de78cdab42..684b8047e0f2 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -11019,7 +11019,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> > 		set_debugreg(vcpu->arch.eff_db[3], 3);
> > 		/* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
> > 		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
> >-			kvm_x86_call(set_dr6)(vcpu, vcpu->arch.dr6);
> >+			run_flags |= KVM_RUN_LOAD_GUEST_DR6;
> 
> The new KVM_RUN flag isn't necessary. Vendor code can directly check
> switch_db_regs to decide whether to load the guest dr6 into hardware.

So thought Paolo, too.

> In svm_vcpu_run(), referencing both run_flags and switch_db_regs is confusing.
> The following logic is much clearer:
> 
> 	if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
>  		svm_set_dr6(vcpu, DR6_ACTIVE_LOW);
> 	else
> 		svm_set_dr6(vcpu, vcpu->arch.dr6);

And wrong :-)  vcpu->arch.dr6 is stale on fastpasth reentry, see commit c2fee09fc167
("KVM: x86: Load DR6 with guest value only before entering .vcpu_run() loop").

