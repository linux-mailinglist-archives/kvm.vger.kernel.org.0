Return-Path: <kvm+bounces-15925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2CDC8B2392
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EB1C28B8D6
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBAA6149E0C;
	Thu, 25 Apr 2024 14:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uzpqxT4t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98493149E0E
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 14:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054217; cv=none; b=A/MhebWxZy6GXfLpWnh9uoBbrZ7bEj1IYWXPKTZ2C5uROEv6zHiTHWMNet33C6TzyNI2e9SWlmVQZwNctb0KWkFdZQgoAlPmVsJqLNO6SKaPZloUcZmuR/660C1aVgBeJKS3PadxQNdHl7J0SN5zgWeu583FctsCRmdhhlwwF0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054217; c=relaxed/simple;
	bh=BItV8R6H9q+R+pZ30mC6aRJAXYs4oMTWPeQORV5rSpA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CeZQpDQOo0GR17nFAjr09pGwdzpGFkbvygAI+6NrkMCYkjYxjMuGbc/t9lSmGUlYdlssCtpNNanYsQwWljDKc8ugniWGTuv67idG3HCuMNpDymsl0A1u6vOgCKfgw+wI1KW94Oi//cUvJ1xM2k8HWwQZ3WMJ7keQY52ts89Lsuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uzpqxT4t; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6183c4a6d18so18689987b3.3
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 07:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714054214; x=1714659014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ny6k5In1yh/dXdoAix2kKCvHY5SPtsFGuRUZpDcPe/0=;
        b=uzpqxT4tJtpGc8OCKCA894g0fUkvcbHhG50Kz2J34kc4Pq8Rycd9yo1u3hc8r+p8iY
         dhMrAoc1UcoXSZgnOGFvPBrqBwl/z2t/+4A5H2p27WioEcHIV9W9RG6ALzxwqBazrc2q
         Ed0oQNQH80LFsDBriaWbYzXlwiKIoDWm5+JwuqZFMRZ4Jb+X6iJwGs2V1Lxf7B5Y63N4
         0TMZS2LG+GXpcA5BGNqF7pErHgwuv2GYNky/FSTc70cKNHJUNhmUTnsHq9fMLre2gs+5
         LLcCSysOsHuRi1pucIPMc7GBj6EM3zH84kXruHb4rRr9hPu2X6JDzYFChQ3UYBWGwVNy
         PQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054214; x=1714659014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ny6k5In1yh/dXdoAix2kKCvHY5SPtsFGuRUZpDcPe/0=;
        b=mF9mUrGe6/Yw3RQVUip53kFtBbP/ssO6aOGVYVyFjji9q2Ck6DhMl5Vnv5JmED3TVP
         4S0kOmdZHbcwnT+I8N3XwAnhCyDL+gbCVkSzXx27GelszlSz/1P41m16zssobagXqZxx
         qO9xVFgMq3QiY2vA8OXhdvmtM6ks3JIOI6UWn8RRSv+NgZWa9PwrbyxWQKbVs0L9RKb9
         A4ZWjVWSBa3gEN2CweAu80HZ0JKFnk/UNkA/FVzr+TXhVTc7DdajaPHFYumUucSq+MP1
         r0Y4qktIiH8h8dVcw0Wmkjl/ToYi23Z5uXhQlPCD8FbgHrDZqj0GnMV1ZhtqF0wuCruy
         4Y0w==
X-Forwarded-Encrypted: i=1; AJvYcCWl6tOwwAJMVrHaulmGxFouTrXngZkNtSRU69ryu07hBAKzyWcLREmTJ8u7zSFMny/sRm0aXkr7x+wkw4mqmy0B88oE
X-Gm-Message-State: AOJu0Yx2XfgMcEk4LCvCQvDyp+6zkY0LXQh+z8hjWZ0QtizE+/aiEwSu
	k3d0b+5OmndG3B2T0Jecnk4QyqwdMTjp7JywwGpOKEEHLHn/pTKdqwZZGRdNQWYa2CSnL0Jaszy
	IiA==
X-Google-Smtp-Source: AGHT+IFL9wPrQFDopC/chIeNLVS3VPuSmUroG6L2BUybtR2TPtd/K09nmBBgvgCzzy630jRdsmnmqufyNAM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:bb4f:0:b0:614:428:e4f9 with SMTP id
 a15-20020a81bb4f000000b006140428e4f9mr1132555ywl.6.1714054214658; Thu, 25 Apr
 2024 07:10:14 -0700 (PDT)
Date: Thu, 25 Apr 2024 07:10:13 -0700
In-Reply-To: <DS0PR11MB6373B95FF222DD6939CFEFC6DC172@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423221521.2923759-1-seanjc@google.com> <20240423221521.2923759-2-seanjc@google.com>
 <DS0PR11MB6373B95FF222DD6939CFEFC6DC172@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZipjhYUIAQMMkXci@google.com>
Subject: Re: [PATCH 1/4] KVM: x86: Add a struct to consolidate host values,
 e.g. EFER, XCR0, etc...
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 25, 2024, Wei W Wang wrote:
> On Wednesday, April 24, 2024 6:15 AM, Sean Christopherson wrote:
> > @@ -403,7 +403,7 @@ static void vmx_update_fb_clear_dis(struct kvm_vcpu
> > *vcpu, struct vcpu_vmx *vmx)
> >  	 * and VM-Exit.
> >  	 */
> >  	vmx->disable_fb_clear
> > = !cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF) &&
> > -				(host_arch_capabilities &
> > ARCH_CAP_FB_CLEAR_CTRL) &&
> > +				(kvm_host.arch_capabilities &
> > ARCH_CAP_FB_CLEAR_CTRL) &&
> 
> The line of code appears to be lengthy. It would be preferable to limit it to under
> 80 columns per line.

I agree that staying under 80 is generally preferred, but I find this

	vmx->disable_fb_clear = (kvm_host.arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
				!boot_cpu_has_bug(X86_BUG_MDS) &&
				!boot_cpu_has_bug(X86_BUG_TAA);

much more readable than this

	vmx->disable_fb_clear = (kvm_host.arch_capabilities &
			 	 ARCH_CAP_FB_CLEAR_CTRL) &&
				!boot_cpu_has_bug(X86_BUG_MDS) &&
				!boot_cpu_has_bug(X86_BUG_TAA);

We should shorten the name to arch_caps, but I don't think that's a net positive,
e.g. unless we do a bulk rename, it'd diverge from several other functions/variables,
and IMO it would be less obvious that the field holds MSR_IA32_ARCH_CAPABILITIES.

> >  				!boot_cpu_has_bug(X86_BUG_MDS) &&
> >  				!boot_cpu_has_bug(X86_BUG_TAA);
> > 

> > @@ -325,11 +332,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
> > gpa_t cr2_or_gpa,
> >  			    int emulation_type, void *insn, int insn_len);
> > fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
> > 
> > -extern u64 host_xcr0;
> > -extern u64 host_xss;
> > -extern u64 host_arch_capabilities;
> > -
> >  extern struct kvm_caps kvm_caps;
> > +extern struct kvm_host_values kvm_host;
> 
> Have you considered merging the kvm_host_values and kvm_caps into one unified
> structure?

No really.  I don't see any benefit, only the downside of having to come up with
a name that is intuitive when reading code related to both.

> (If the concern is about naming, we could brainstorm a more encompassing term
> for them)

