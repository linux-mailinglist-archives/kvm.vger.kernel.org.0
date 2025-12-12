Return-Path: <kvm+bounces-65905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22528CBA0C1
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 00:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6EF8C300F1A9
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 23:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B812DF13A;
	Fri, 12 Dec 2025 23:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4OkbuOV/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5487D1E4BE
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 23:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765582255; cv=none; b=F/GG5u2dOZydx4hZQyFlLw8Aqpdr/lkao9jsZ/GZswpXYlZm+G8zg0bkD+8egaV9b6cT2xm1vPbc+Trqo1QhYr6HWgXAMQ/E1bJA1eQMq/W/BqTPmNIqBL68nEZM5s4h0XK4s6AA/8OnYhipnH38kfhsuzgwoL8WyYGM0P18q24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765582255; c=relaxed/simple;
	bh=vRlNzepxx+5wdjlhRvJZqkLWzWtdMkj9WKyQgqEmQ04=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vFqmMLvdo9PbPKlUpaI+gwo7pBJkIUwhvREJ1LemhaTUYe0RvzXcmT1NqCwXcCdlX9ga3lY/tpoaLJuzY70HpGFfYPaboHHw4sCMFCKHZEsmcdZSGF0OfkizhcQZfNrgBh+XfUyD5SXc4sNEs/zLlEMOOXuiPL0OOWGIkAXKvFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4OkbuOV/; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2958c80fcabso34519185ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765582253; x=1766187053; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YPUFnzvE1LGEB4EPZqcNEIbrRSKbBQjakqo88MsCIoE=;
        b=4OkbuOV/pdi6IVoxafvCzMA1vnSGiSDxTWbSHyn56MdNx4ckCCKmv7PAGrD03Jykpw
         b21dhloYAbIW7C4yBeNv6THcA/OpdCU89PUN8w7pLKIPAwL1qROxhd9uRBYP+Wj2jA+m
         4CPEUDWLDJTuioikmdopSzl7047qVkajGhx0AUe6MYT0RRCqWvoDS5IyfHovoX352tWO
         1Z9SVtR4KbKLQ5P5r9YeLb8YRrySyYznsezykbUOF1fOpV8dB/trjKJcbTYkqFGdbltj
         54iGfl5rbjuqqHN8NGWc6GpC58psBkB8/ystzpj5Gd56VdZuoqj/Qcp4SboYkOh2vf3u
         5FaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765582253; x=1766187053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YPUFnzvE1LGEB4EPZqcNEIbrRSKbBQjakqo88MsCIoE=;
        b=JDqW77nxwl/lW3OmBvxGBhz1r0sO6sT2VY6kjoqop9ePkvobp7HFTY8zdk8a27kytl
         Yc925vU+iaWdLbiqE6ZKx4mcd/imd0ZbZjQhDM27UwDBxFIQ8VBnF03kAYLZm3SmRHp1
         tPOjPXFvKjoPz2IGEttu71Op5hRaL7g58WW/2xoDVvH8PsZCcI8g3v0Bg0GF0faORo+a
         wJF6OCCii1akXU2MkNiSq5hO5odCW2xfaRcuxaOj0nyiJ0wvXjLKxKlAL0PwJONJz/rL
         YXgo14jTgZWOPOqxb1raXWk+2qJJzB/xOd3mEZdApMQxv9ETcCjV1Bhq98dhE7VJfil3
         oeFw==
X-Forwarded-Encrypted: i=1; AJvYcCWP4OTiA9sZ9WgYVml8ecA1ZbjcA7yFMMS12ochUaHkeEj/5EqcfpWevuppJdY3K2QeBMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzT3HLcdOK4YlfKvLnNChd7KQWoRNCxNRP0yazTjrrfOumCv1W+
	M4BBF4nlEjBmBcSBae6b+7fqsMGihAlCngwuChXLKuX1ugNUOxtj+8YEsrGWJIkbE/mYPqLXczK
	6FljIow==
X-Google-Smtp-Source: AGHT+IGYc4JneoK0W3Ry4kHv+mU/5C5A2YvBBXCemPA8KOIIIESsSEA5ZqJLu3i859Z2kGVle0Eh7AiB9cA=
X-Received: from plhk10.prod.google.com ([2002:a17:902:d58a:b0:29d:9b42:7557])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef12:b0:29e:9c82:a925
 with SMTP id d9443c01a7336-29f23b1ecc1mr40903325ad.6.1765582253522; Fri, 12
 Dec 2025 15:30:53 -0800 (PST)
Date: Fri, 12 Dec 2025 15:30:51 -0800
In-Reply-To: <zozt7pbeqn4ekiyrkwjbesqv6sxf6seyskfbnhzz5do2an4zbl@q6pdskoiawvc>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-11-yosry.ahmed@linux.dev> <aThIQzni6fC1qdgj@google.com>
 <2rmpnqjnyhew3tektl3ndmukbfgs4zrytsaxdgec2i3tggneuk@gphhqbrqevan> <zozt7pbeqn4ekiyrkwjbesqv6sxf6seyskfbnhzz5do2an4zbl@q6pdskoiawvc>
Message-ID: <aTylq0oDnhGY61PM@google.com>
Subject: Re: [PATCH v2 10/13] KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 11, 2025, Yosry Ahmed wrote:
> On Wed, Dec 10, 2025 at 11:05:44PM +0000, Yosry Ahmed wrote:
> > On Tue, Dec 09, 2025 at 08:03:15AM -0800, Sean Christopherson wrote:
> > > On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > Unfortunately this doesn't work, it breaks the newly introduced
> > nested_invalid_cr3_test. The problem is that we bail before we fully
> > initialize VMCB02, then nested_svm_vmrun() calls nested_svm_vmexit(),
> > which restores state from VMCB02 to VMCB12.
> > 
> > The test first tries to run L2 with a messed up CR3, which fails but
> > corrupts VMCB12 due to the above, then the second nested entry is
> > screwed.
> > 
> > There are two fixes, the easy one is just move the consistency checks
> > after nested_vmcb02_prepare_control() and nested_vmcb02_prepare_save()
> > (like the existing failure mode of nested_svm_load_cr3()). This works,
> > but the code doesn't make a lot of sense because we use VMCB12 to create
> > VMCB02 and THEN check that VMCB12 is valid.
> > 
> > The alternative is unfortunately a lot more involved. We only do a
> > partial restore or a "fast #VMEXIT" for failed VMRUNs. We'd need to:
> > 
> > 1) Move nested_svm_load_cr3() above nested_vmcb02_prepare_control(),
> >    which needs moving nested_svm_init_mmu_context() out of
> >    nested_vmcb02_prepare_control() to remain before
> >    nested_svm_load_cr3().
> > 
> >    This makes sure a failed nested VMRUN always needs a "fast #VMEXIT"
> > 
> > 2) Figure out which parts of nested_svm_vmexit() are needed in the
> >    failed VMRUN case. We need to at least switch the VMCB, propagate the
> >    error code, and do some cleanups. We can split this out into the
> >    "fast #VMEXIT" path, and use it for failed VMRUNs.
> > 
> > Let me know which way you prefer.
> 
> I think I prefer (2), the code looks cleaner and I like having a
> separate code path for VMRUN failures. Unless there are objections, I
> will do that in the next version.

With the caveat that I haven't seen the code, that has my vote too.  nVMX has a
similar flow, and logically this is equivalent, at least to me.  We can probably
even use similar terminology, e.g. vmrun_fail_vmexit instead of vmentry_fail_vmext.

vmentry_fail_vmexit:
	vmx_switch_vmcs(vcpu, &vmx->vmcs01);

	if (!from_vmentry)
		return NVMX_VMENTRY_VMEXIT;

	load_vmcs12_host_state(vcpu, vmcs12);
	vmcs12->vm_exit_reason = exit_reason.full;
	if (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx))
		vmx->nested.need_vmcs12_to_shadow_sync = true;
	return NVMX_VMENTRY_VMEXIT;




