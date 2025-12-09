Return-Path: <kvm+bounces-65592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 42DBACB0FC9
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 21:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A480301AF49
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 20:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019AC2FF177;
	Tue,  9 Dec 2025 20:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2pa3XLVr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC201E7C18
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 20:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765310508; cv=none; b=nF/jvyEsL5Gz57tGRIFNoR2K5W2Qky9Ql0crJner8FzvmaUxOPgFKjpnl80/vjvqiZ69ONntTRlxEQqiwuS8V+kcQY0kOjoUVuKOLduRoN+Ms6XNh3f3pewTYTmsXQt80bJCdPW9hyjzhtgxwKZdHvwQbxm9WL+e3K0MJqaxgHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765310508; c=relaxed/simple;
	bh=Qxi1j/RcHKxFAzWkNO39rmWa1j/5Kyprr7BXnY/6Tzg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fu1E8psuYrXai+gWNdxYeZbLJKVqP3wvL1HRPgO9B8juXlD2nLb47W9UPhN3T3V1u8pMrY6OLWqVZ/NF1LDZuCBl02NWBzblodV9eXXIgD9VzQCRshTRm/GQgld8shXDFsBaWNU1IQd3/STepkxdwZ1ysGyoT1gXVG+jp6wozNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2pa3XLVr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3418ad76023so11494833a91.0
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 12:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765310506; x=1765915306; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oAzgke8OztFL10s6gpyKViwU0Rh1AgMRSlbFbta1tHI=;
        b=2pa3XLVrSc4rvWJpk/uaf1/Ab8W5uMEPVfcUah8RECiVGEmZrgxUUpl9arwtAmv1oo
         Ocuw5BvGMCwFSEWMXbTtOGxCKlZlkczjJajPSpHFFQaUdfY9fNTx1CtP2w5+b482xLu2
         9FAy8W3Wp1EyTzdqhLaXqMR7YcxqOcqSEHhxsuQ8rzpWcvUftPL1yqK9vchU1SvzY3G9
         O1Mtp04Fkgxx4F9JfHITUnnIv3imyva5wZ7i882m88+8FlLcRQ7dcvN0rpXaMqoZUe+n
         /Gkgid8QdSZP0jnv5d7BXUBJHnYK9eyxXbBuW6QipjEvl6mxdzjbAAtKUcIsgjUGf89m
         et7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765310506; x=1765915306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oAzgke8OztFL10s6gpyKViwU0Rh1AgMRSlbFbta1tHI=;
        b=j2/whBsjgd1uL/4ZuVJGewxBm81+y58FsKsNYBbBVsiZjk+Qf0I1B9sQw2DZUA5e9D
         L0jAbxdhOYY0b42/T9t8qjARBlzdE7mXUFBY/Cuy3wwTQ0sQx26fOWK3NRSpcXGWGdeL
         ML8AgN77mfmHE/1ltVgfjiKOCeq++mxWC6G22nb7ocOzMLTqrQ2KHBZuuTrYNq3GBlWi
         kqrob5NceLaqCocG5dT4A6zxF50nP1Mt6Ru5T7DqqKc3MzSaWFcxumwEaB164Gi6C5rH
         eOFfK/1qW6psWZsTaBxoutDCXfLVDUNbBaPFJvqIw3ItMtct1M191gDINwyQySH9RlA3
         YFHw==
X-Forwarded-Encrypted: i=1; AJvYcCW+ucRmy7IXwdsNt0kVxLy4KAirasOlrXlYUJeN0m7HO4qsGobarHQVIM9iSqwi8gCkhYY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2/VY3oEx7DtQhwalWhU0fEEVZTFjyfLaL/G06Upib4jBESna5
	TC+yUdihLxWcIXIaKfI/+Jw2pO4fitQ1FelQYEwmJpKD1UButieKw43sawFWqyn/3t+Hz4+Y4ZL
	A5tNRaQ==
X-Google-Smtp-Source: AGHT+IHJ5+IunYdkLmIlmxzrML57BpWM+OKCGDR1imNOGZGgDjiyH1eeQy1f5I13znoJ9RsrIHFYxpfirkY=
X-Received: from pjup12.prod.google.com ([2002:a17:90a:d30c:b0:349:a1a3:75f8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5905:b0:341:761c:3330
 with SMTP id 98e67ed59e1d1-349a25bd8e0mr10531817a91.23.1765310505789; Tue, 09
 Dec 2025 12:01:45 -0800 (PST)
Date: Tue, 9 Dec 2025 12:01:44 -0800
In-Reply-To: <69352b2239a33_1b2e100d2@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com> <20251206011054.494190-3-seanjc@google.com>
 <69352b2239a33_1b2e100d2@dwillia2-mobl4.notmuch>
Message-ID: <aTiAKG4TlKcZnJnn@google.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
From: Sean Christopherson <seanjc@google.com>
To: dan.j.williams@intel.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Dec 06, 2025, dan.j.williams@intel.com wrote:
> Sean Christopherson wrote:
> > @@ -694,9 +696,6 @@ static void drop_user_return_notifiers(void)
> >  		kvm_on_user_return(&msrs->urn);
> >  }
> >  
> > -__visible bool kvm_rebooting;
> > -EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
> 
> ...a short stay for this symbol in kvm/x86.c? It raises my curiosity why
> patch1 is separate.

Because it affects non-x86 architectures.  It should be a complete nop, but I
wanted to isolate what I could.

> Patch1 looked like the start of a series of incremental conversions, patch2
> is a combo move. I am ok either way, just questioning consistency. I.e. if
> combo move then patch1 folds in here, if incremental, perhaps split out other
> combo conversions like emergency_disable_virtualization_cpu()? The aspect of
> "this got moved twice in the same patchset" is what poked me.

Yeah, I got lazy to a large extent.  I'm not super optimistic that we won't end
up with one big "move all this stuff" patch, but I agree it doesn't need to be
_this_ big.

> [..]
> > diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
> > new file mode 100644
> > index 000000000000..986e780cf438
> > --- /dev/null
> > +++ b/arch/x86/virt/hw.c
> > @@ -0,0 +1,340 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#include <linux/cpu.h>
> > +#include <linux/cpumask.h>
> > +#include <linux/errno.h>
> > +#include <linux/kvm_types.h>
> > +#include <linux/list.h>
> > +#include <linux/percpu.h>
> > +
> > +#include <asm/perf_event.h>
> > +#include <asm/processor.h>
> > +#include <asm/virt.h>
> > +#include <asm/vmx.h>
> > +
> > +static int x86_virt_feature __ro_after_init;
> > +
> > +__visible bool virt_rebooting;
> > +EXPORT_SYMBOL_GPL(virt_rebooting);
> > +
> > +static DEFINE_PER_CPU(int, virtualization_nr_users);
> > +
> > +static cpu_emergency_virt_cb __rcu *kvm_emergency_callback;
> 
> Hmm, why kvm_ and not virt_?

I was trying to capture that this callback can _only_ be used by KVM, because
KVM is the only in-tree hypervisor.  That's also why the exports are only for
KVM (and will use EXPORT_SYMBOL_FOR_KVM() when I post the next version).

> [..]
> > +#if IS_ENABLED(CONFIG_KVM_INTEL)
> > +static DEFINE_PER_CPU(struct vmcs *, root_vmcs);
> 
> Perhaps introduce a CONFIG_INTEL_VMX for this? For example, KVM need not
> be enabled if all one wants to do is use TDX to setup PCIe Link
> Encryption. ...or were you expecting?
> 
> #if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(...<other VMX users>...)

I don't think we need anything at this time.  INTEL_TDX_HOST depends on KVM_INTEL,
and so without a user that needs VMXON without KVM_INTEL, I think we're good as-is.

 config INTEL_TDX_HOST
	bool "Intel Trust Domain Extensions (TDX) host support"
	depends on CPU_SUP_INTEL
	depends on X86_64
	depends on KVM_INTEL

