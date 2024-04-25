Return-Path: <kvm+bounces-15934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6918B2453
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD5DFB267AD
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB35414A4EC;
	Thu, 25 Apr 2024 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="diHBnk+S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FFC12AAC6
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714056452; cv=none; b=A+UqrJbfM/jJKCJxh53gMU+f9CjJzzIt6vmS1ejC7ZjUy4RoL/ru57b6/nm8kL6zS65ZJIYTJRVm8ezLI3XwF3eyimCizCVxOmINy7fuVmGhNEbLlo+GwPAoe+TIGk1jFe9ywUdOEvCErV5wbgeVjnGXLcAqeh/FOVfgyS6yl78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714056452; c=relaxed/simple;
	bh=/3Ptl6/dILtlcFf0CHKjc1lWsobe4sOIdkfxCyy5D/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s5KkbJbzv9A6tQ2lje9JWIfqmouOY2ImrDEmctI5LUNZ7Hna3jchHGt2ojgbu04chpdt1/iIMF074htida9R55dULcOaJ4IkipCYMkUbMlhiiGotqRNjVxK8kImKiWzFKJI5jYcOQV3Ov/yCbtW8waBpa+j8x7IUm3Dg1F/3zEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=diHBnk+S; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de46620afd7so1879288276.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 07:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714056450; x=1714661250; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KnP/oZP4ccxa1mrTRhNYPfpsHrss5qynOl3RJuOsATE=;
        b=diHBnk+SfSxEhJeirTnI5ZIM8LL3QoFZQC1CmdW8Vd0zImECVKudhuSPA4Gi+n4+KJ
         nmm5z/0mDYjmepV9QZPMMd1TqjYTFqgrFkyGi8itP9kJN8G5tAGWcSL8s0t7fgTEWQrl
         KX8OC0/w3YXH/Ou+sRMWJbB+X6MEDgPQS3gDf1kqPyDJWJEzZ4nzz5TPiYLpAXBsnEgw
         q+Asv+dhDkYt/Y3i/IDPMK2nVjpuRvbanzVsx4L898F03nZlGeyGPZJuZXD2ZVytmiuP
         iLPpwKMNrPt9zB52DfW0S5Ol0uqj4Qmmp7VzNn0McqYjmg5zpNoXoU9+93pheeLeEbtA
         S8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714056450; x=1714661250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KnP/oZP4ccxa1mrTRhNYPfpsHrss5qynOl3RJuOsATE=;
        b=jxz1dv9MdamTWD+QI6BV8qXvxAhMJ/Pn3FfVYydhBUorzv2Fod1fwi4rsXKeH762xF
         iRYPTUrIKU156kqzo/L0H+02A/i2ZabvwuT4u2sZ/owm9SbO7wqmvGpABVt+a6cWRzGP
         65wzs3ukj5zTRNd+XSuNLEfrzoW2mdvZruH6sfbzez2FF3YQ5hS71+A0B33RsEaQ0QDj
         EjLQ44iArZhX313jtFbu7RXr3wbAh02MTkX04Ef2fyl9OtCG+XEm0bD72bde84S667+3
         +6aRy6Efb8zSJzJVE/qjAjkcP+NBulTm7bClN9mZ+ANBerwTfWJn3OkJmYaHGAeOzbW0
         BPrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWchXYOro9Y4SOIPbt8qBCD6kyNLLicm12TWkf1Y4U5H0pPyRK01++qai1TMVgBZdHY3AnV40dVIh6GaiOQsrKggoMr
X-Gm-Message-State: AOJu0Yw/BeFOQyUXN11i+cLQBrs/HaROYcPk9lG3Jo9H3c/Ks9lzWIt3
	RCbPVsii+0VziQN5099CL3UgHGWB4wsA73jroHZLyFMBJx9SDwSEwm7MdlLJcXVo/aCbR1SP1Q/
	kIQ==
X-Google-Smtp-Source: AGHT+IHcpvR4nfgTITxm6amC5T1Ujhg5dy2vcrW46iCRFNddlNNj+5lEziGBZsh0whUnNAfnw5b2pULpc2g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1249:b0:dc6:dfd9:d423 with SMTP id
 t9-20020a056902124900b00dc6dfd9d423mr590089ybu.3.1714056450615; Thu, 25 Apr
 2024 07:47:30 -0700 (PDT)
Date: Thu, 25 Apr 2024 07:47:29 -0700
In-Reply-To: <DS0PR11MB6373C82CB77354EFD779E0C3DC172@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423221521.2923759-1-seanjc@google.com> <20240423221521.2923759-2-seanjc@google.com>
 <DS0PR11MB6373B95FF222DD6939CFEFC6DC172@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZipjhYUIAQMMkXci@google.com> <DS0PR11MB6373C82CB77354EFD779E0C3DC172@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZiptAV51VcTEhqgY@google.com>
Subject: Re: [PATCH 1/4] KVM: x86: Add a struct to consolidate host values,
 e.g. EFER, XCR0, etc...
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 25, 2024, Wei W Wang wrote:
> On Thursday, April 25, 2024 10:10 PM, Sean Christopherson wrote:
> > We should shorten the name to arch_caps, but I don't think that's a net
> > positive, e.g. unless we do a bulk rename, it'd diverge from several other
> > functions/variables, and IMO it would be less obvious that the field holds
> > MSR_IA32_ARCH_CAPABILITIES.
> 
> Yeah, the above isn't nice and no need to do bulk rename.
> We could just shorten it here, e.g.:

Works for me.

> > > > @@ -325,11 +332,8 @@ int x86_emulate_instruction(struct kvm_vcpu
> > > > *vcpu, gpa_t cr2_or_gpa,
> > > >  			    int emulation_type, void *insn, int insn_len);
> > fastpath_t
> > > > handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
> > > >
> > > > -extern u64 host_xcr0;
> > > > -extern u64 host_xss;
> > > > -extern u64 host_arch_capabilities;
> > > > -
> > > >  extern struct kvm_caps kvm_caps;
> > > > +extern struct kvm_host_values kvm_host;
> > >
> > > Have you considered merging the kvm_host_values and kvm_caps into one
> > > unified structure?
> > 
> > No really.  I don't see any benefit, only the downside of having to come up
> > with a name that is intuitive when reading code related to both.
> 
> I thought the two structures perform quite similar jobs and most of the fields in
> kvm_cap, e.g. has_tsc_control, supported_perf_cap, could also be interpreted
> as host values?

No, kvm_caps is filtered and/or generated information, e.g. supported_perf_cap
and supported_xss incorporate host/hardware support, but they also incorporate
KVM's own capabilities.

kvm_host holds pure, unadultered host values.

XSS is a perfect example.  If we shoved the host value in kvm_caps, then we'd
have kvm_caps.supported_xss and kvm_caps.xss, which would be incredibly confusing.
So then we'd need to rename it to kvm_caps.host_xss, which is also confusing,
just less so, and also results in a longer name with no added value.

