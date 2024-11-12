Return-Path: <kvm+bounces-31646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1125E9C5FDF
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 19:05:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FF3B283875
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DEFF215028;
	Tue, 12 Nov 2024 18:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q1KN+lI9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284EF215007
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731434748; cv=none; b=V6GYiqt9gkarMSCDQDgTe1HMqcqyzJaVa8L5vY8YXD84tpKfM8m7kuTPOLaIU08+QDcmjXFbfAMvKUZl2O2/ejvV3kXPFumQ18YGh/xsNEHZ0ofq5lm1GZuKt9G3lacoJa6dNge1cLzSt9ofw9QTFL+/e/1NlLW81n9GqWF7LuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731434748; c=relaxed/simple;
	bh=1TNtYrw0cI+4IbhwahK3f27e0NBbir3ttqfscikF/Tc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X8quWoEWk/4WXr+XNG/hWhT8Z9z7TnjFfHyAGxm41Y2H0Iu6mkmRQCozolEa2hh3DjjNxy+qGJ0t6Gviprg3bl0JEiIZv8qckON9kFGPGlP/AboeKv4/xtP+7oSD3W81Gm9Ov6Cf9mE6xNgmNCe+zke0kHMkeV57LOy3r4kMfNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q1KN+lI9; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2118b20e83aso57509015ad.0
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 10:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731434746; x=1732039546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6syIpXROohiAYDOvSaTBOoRkASAnslDzHcGzJCB1UlA=;
        b=Q1KN+lI96oQNSWTGl2pHpOuMsfPJ32PkiO0JY4MyeFfcIG+oXG7rDMS50YCHmMNV2p
         tPqGAvLndJ6FceUyoY3IhR1HGK+ywIm9jeO2VSMJ5AtFbkrIp/7s7nKXiF7+aXXdauFi
         VhZfuE2Id5FblglCgX38OEEDpOPbPmdz2PY9IbW0fnl9cYAFFPDfwZU23v2gVp9tigEW
         UbJlOrco+AeUsTLeDxw8nBv86epgViDFUkaHUF4d8dFPn8IXyfRv28X/N/kEXadTVOds
         k10uDJ+JpHo8n/l7HVPvpXhNjplY5Ma3u441WlWzRerm2aS2NwkiH/9cMY5Ka7n2ZXHg
         8dXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731434746; x=1732039546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6syIpXROohiAYDOvSaTBOoRkASAnslDzHcGzJCB1UlA=;
        b=PgArassUGuvoufD2xbUu3EnLAGReDti80Bp1AwktlDirzARP5YNFi9QwHKpJ54DnnH
         IhdWgsvphyKmEhxJdJoIc1/4S9hj6m6QEdiVjlWHP5Y8dHB/ZSMOAGbGp+81fYSCIkgv
         kq+FHezgoGylM1N3pSNIMVSFUIJJGQzSvny/Nc/+UAzpdw22c03SFbAsDS2HlqKUfhcE
         h7WK5eSgPuRniARLmekY+4cYQVeJll679Yd3ctYpSguMYFQQIiTrya5btokygbSBvE60
         ptsl1hePkbOfgSmNNPuf+0oBfQJQlv+meG1dzUXbRgG0Zj5hJPvGqX8omsVBcTy7I9wT
         He5A==
X-Forwarded-Encrypted: i=1; AJvYcCX1TuxVPCwpWM/hyAvn0HVRT4NdiiSodhzgxOftXJBzvFD9zIMJXHVVktH1z5EGENFONMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYF7DkOjdZ+NMI7fU1CWUg8GTJE48Esdbmb+13rTvJZ4xx2c+a
	RAO3hqTwGEaWypDsrUuq2IdR6CAqDCSbB1hQV7+SZ/zQLvndSA82Axfn06UCqqr+HCwovnZKfcK
	eDA==
X-Google-Smtp-Source: AGHT+IH4kIZHreHu/wwqMQNUg569gEssFax5NR336gUa63Ml5d5Oc6cqepxT2wPIVMkXWwz+u3m8I7kF464=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:7596:b0:20b:96e2:59a2 with SMTP id
 d9443c01a7336-211833138acmr1094805ad.0.1731434746498; Tue, 12 Nov 2024
 10:05:46 -0800 (PST)
Date: Tue, 12 Nov 2024 10:05:44 -0800
In-Reply-To: <20241112065415.3974321-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241112065415.3974321-1-arnd@kernel.org>
Message-ID: <ZzOY-AlBgouiIbDB@google.com>
Subject: Re: [PATCH] x86: kvm: add back X86_LOCAL_APIC dependency
From: Sean Christopherson <seanjc@google.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	kernel test robot <lkp@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Michael Roth <michael.roth@amd.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 12, 2024, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Enabling KVM now causes a build failure on x86-32 if X86_LOCAL_APIC
> is disabled:
> 
> arch/x86/kvm/svm/svm.c: In function 'svm_emergency_disable_virtualization_cpu':
> arch/x86/kvm/svm/svm.c:597:9: error: 'kvm_rebooting' undeclared (first use in this function); did you mean 'kvm_irq_routing'?
>   597 |         kvm_rebooting = true;
>       |         ^~~~~~~~~~~~~
>       |         kvm_irq_routing
> arch/x86/kvm/svm/svm.c:597:9: note: each undeclared identifier is reported only once for each function it appears in
> make[6]: *** [scripts/Makefile.build:221: arch/x86/kvm/svm/svm.o] Error 1
> In file included from include/linux/rculist.h:11,
>                  from include/linux/hashtable.h:14,
>                  from arch/x86/kvm/svm/avic.c:18:
> arch/x86/kvm/svm/avic.c: In function 'avic_pi_update_irte':
> arch/x86/kvm/svm/avic.c:909:38: error: 'struct kvm' has no member named 'irq_routing'
>   909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
>       |                                      ^~
> include/linux/rcupdate.h:538:17: note: in definition of macro '__rcu_dereference_check'
>   538 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
> 
> Move the dependency to the same place as before.
> 
> Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202410060426.e9Xsnkvi-lkp@intel.com/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Question: is there actually any point in keeping KVM support for 32-bit host
> processors?

Nope.  We need _a_ 32-bit KVM build to run as a nested (L1) hypervisor for testing
purposes, but AFAIK there's zero need to keep 32-bit KVM up-to-date.

> From what I can tell, the only 32-bit CPUs that support this are
> the rare Atom E6xx and Z5xx models and the even older Yonah/Sossaman "Core
> Duo", everything else is presumably better off just running a 64-bit kernel
> even for 32-bit guests?

Yep.  I am 99.9% certain there are no users of 32-bit KVM.  There have been
multiple instances in the past few years where 32-bit KVM was quite broken, for
several kernel releases, and no one complained.

Paolo, should we go ahead and start the process of removing 32-bit support in x86?
I forget who it was, but someone from the QEMU world mentioned that dropping 32-bit
support in KVM would allow dropping a rather large pile of code in QEMU too.

