Return-Path: <kvm+bounces-31190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C7F39C1175
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 23:04:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99C10B2209F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 22:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB2521832F;
	Thu,  7 Nov 2024 22:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QyCSQT/h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9C4215C6D
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 22:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017069; cv=none; b=mvfx0lCfJnuzoyV43XmFuQ3NE5LDh9k9TMyZAdSnZcGAKz/KLuSNWRr2IlM+vRsFojAS3Z9/RCvZ2eyOjr9gVhoni4Ci2jTZEI/6uIAbpGAaQeTFcQ+tNUmm0PFFtRXhJldC9EziycNvH5i2ctyLeOuAuq4lqamZJAFV0aJpGHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017069; c=relaxed/simple;
	bh=lpsB0Lhao14pSHuIsoNAfLMQVqkvehe9MRaIJTGgGQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p7a8pZY+pp+yLa4exznOx3JQXYRVTgM73gcMIZEmer3czeIu2h9vAK0cFYvBvUbICssH2A31hGiIvdNLGqjZprDFd8CPzPJF5dkXqBhuqOaQOKdG089wKbOsVeeoTdLOIPrVF8NxqUXo60asNY2vd533SHvOPYLBJ5dflI1Jzmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QyCSQT/h; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e290b8b69f8so2352905276.2
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 14:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731017066; x=1731621866; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xbGhGQD3dLGHOdZf79vl2DnONOHtbHblmt/KrMX34JM=;
        b=QyCSQT/hDiEnj+elNoSQ8RsnNXW/LbMbl4WOWB1gYBPSh8FDbk12Ea5Jc9At7jd+eM
         LbJkpJX5AJMdwqH4/g8nDx9hhfGzx7yHhi3T9IZNVkrpNXJKKhFZE6y7OZHF2/6nROZV
         D2Y7MfCoPfko6EUehfGjOVAtBZnGo8Q8spK5cassIymH5Y7Nn4hKUGjKTQjHF9wDUn1+
         oHOuCn/mytsE34uh5wNbV4fsKe5fKljoCJo0n+Xeo0wkkdJ35eeUmQakOsEhjzRjI3gM
         +CjMMa6EFDvNNWcjdYF2kQ1WgtgjXaZVtYrPrunaY4IvhEpFprdObgS6fqGn8NLI0qZ2
         myQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731017066; x=1731621866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xbGhGQD3dLGHOdZf79vl2DnONOHtbHblmt/KrMX34JM=;
        b=O33glBIi7kTMagXBR5EwFWx+uAy/3dfS4ovFCDwY1Fabwbmj+CIZ6xjcyZJB/zG5EB
         8GR0GvdBeD9BbqtY5aDpmdAETVOUMkz5vDdYsvxlaMl2Zfc57c5F5TCUXHFsYDk1MhkA
         xwMZPtEOgBUJvosv+bYyT3vt0laV9UVP93WondJPmL8F1Y8Lw/uBEQL00ZvvSzXDZaIx
         szPbbrpzJAYNyCxZbYDw8+vWQJvli4U2LkYCzEKuP9qfKBu8KnZh5WLyHCqlVxIqRIEB
         HWXiSNoqbKVsVQWmvbxW8rvZU7B5Y5rJp+/sE9Ej8rWfRWCzxJg7suGaVm7xNHA56EdB
         Em7w==
X-Forwarded-Encrypted: i=1; AJvYcCUWAJP3W+35Nz5arzIe/1Uvs+PevrWCBdsZ5mExyXvMWvtQbR/xx8fUS08pAP5IzdzgOeQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9KSqyOhuxdtLbxWBkUiLOlaBk51cr9u5o3VOLeYqrHm+LvhzN
	Mk3n54xqXNp4jqiQgIhkr5OYLqtgA+WKIxR9MWlt9TqRh9DqrhaO5Q4yaITozfMhgKzh61M/hYp
	U3Q==
X-Google-Smtp-Source: AGHT+IGAD4bX7VHgyHjrfJRov5ldRUBUOAvZsIHOxd9qJY11CpezC67q3aZc2w/ppTDS+z3xlmpJz1tjiN0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:a423:0:b0:e20:2502:be14 with SMTP id
 3f1490d57ef6-e337f8df4fbmr490276.7.1731017066602; Thu, 07 Nov 2024 14:04:26
 -0800 (PST)
Date: Thu, 7 Nov 2024 14:04:25 -0800
In-Reply-To: <2d69e11d8afc90e16a2bed5769f812663c123c14.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1730120881.git.kai.huang@intel.com> <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
 <ZyJOiPQnBz31qLZ7@google.com> <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
 <ZyPnC3K9hjjKAWCM@google.com> <37f497d9e6e624b56632021f122b81dd05f5d845.camel@intel.com>
 <ZyuDgLycfadLDg3A@google.com> <2d69e11d8afc90e16a2bed5769f812663c123c14.camel@intel.com>
Message-ID: <Zy05af5Qxkc4uRtn@google.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tony Lindgren <tony.lindgren@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Dan J Williams <dan.j.williams@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Adrian Hunter <adrian.hunter@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 06, 2024, Kai Huang wrote:
> On Wed, 2024-11-06 at 07:01 -0800, Sean Christopherson wrote:
> > On Wed, Nov 06, 2024, Kai Huang wrote:
> > > For this we only disable TDX but continue to load module.  The reason is I think
> > > this is similar to enable a specific KVM feature but the hardware doesn't
> > > support it.  We can go further to check the return value of tdx_cpu_enable() to
> > > distinguish cases like "module not loaded" and "unexpected error", but I really
> > > don't want to go that far.
> > 
> > Hrm, tdx_cpu_enable() is a bit of a mess.  Ideally, there would be a separate
> > "probe" API so that KVM could detect if TDX is supported.  Though maybe it's the
> > TDX module itself is flawed, e.g. if TDH_SYS_INIT is literally the only way to
> > detect whether or not a module is loaded.
> 
> We can also use P-SEAMLDR SEAMCALL to query, but I see no difference between
> using TDH_SYS_INIT.  If you are asking whether there's CPUID or MSR to query
> then no.

Doesn't have to be a CPUID or MSR, anything idempotent would work.  Which begs
the question, is that P-SEAMLDR SEAMCALL query you have in mind idempotent? :-)

> > So, absent a way to clean up tdx_cpu_enable(), maybe disable the module param if
> > it returns -ENODEV, otherwise fail the module load?
> 
> We can, but we need to assume cpuhp_setup_state_cpuslocked() itself will not
> return -ENODEV (it is true now), otherwise we won't be able to distinguish
> whether the -ENODEV was from cpuhp_setup_state_cpuslocked() or tdx_cpu_enable().
> 
> Unless we choose to do tdx_cpu_enable() via on_each_cpu() separately.
> 
> Btw tdx_cpu_enable() itself will print "module not loaded" in case of -ENODEV,
> so the user will be aware anyway if we only disable TDX but not fail module
> loading.

That only helps if a human looks at dmesg before attempting to run a TDX VM on
the host, and parsing dmesg to treat that particular scenario as fatal isn't
something I want to recommend to end users.  E.g. if our platform configuration
screwed up and failed to load a TDX module, then I want that to be surfaced as
an alarm of sorts, not a silent "this platform doesn't support TDX" flag.

> My concern is still the whole "different handling of error cases" seems over-
> engineering.

IMO, that's a symptom of the TDX enabling code not cleanly separating "probe"
from "enable", and at a glance, that seems very solvable.  And I suspect that
cleaning things up will allow for additional hardening.  E.g. I assume the lack
of MOVDIR64B should be a WARN, but because KVM checks for MOVDIR64B before
checking for basic TDX support, it's an non-commitalpr_warn().

> > > 4) tdx_enable() fails.
> > > 
> > > Ditto to 3).
> > 
> > No, this should fail the module load.  E.g. most of the error conditions are
> > -ENOMEM, which has nothing to do with host support for TDX.
> > 
> > > 5) tdx_get_sysinfo() fails.
> > > 
> > > This is a kernel bug since tdx_get_sysinfo() should always return valid TDX
> > > sysinfo structure pointer after tdx_enable() is done successfully.  Currently we
> > > just WARN() if the returned pointer is NULL and disable TDX only.  I think it's
> > > also fine.
> > > 
> > > 6) TDX global metadata check fails, e.g., MAX_VCPUS etc.
> > > 
> > > Ditto to 3).  For this we disable TDX only.
> > 
> > Where is this code?
> 
> Please check:
> 
> https://github.com/intel/tdx/blob/tdx_kvm_dev-2024-10-25.1-host-metadata-v6-rebase/arch/x86/kvm/vmx/tdx.c
> 
> .. starting at line 3320.

Before I forget, that code has a bug.  This

	/* Check TDX module and KVM capabilities */
	if (!tdx_get_supported_attrs(&tdx_sysinfo->td_conf) ||
	    !tdx_get_supported_xfam(&tdx_sysinfo->td_conf))
		goto get_sysinfo_err;

will return '0' on error, instead of -EINVAL (or whatever it intends).

Back to the main discussion, these checks are obvious "probe" failures and so
should disable TDX without failing module load:

	if (!tdp_mmu_enabled || !enable_mmio_caching)
		return -EOPNOTSUPP;

	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
		pr_warn("MOVDIR64B is reqiured for TDX\n");
		return -EOPNOTSUPP;
	}

A kvm_find_user_return_msr() error is obviously a KVM bug, i.e. should definitely
WARN and fail module module.  Ditto for kvm_enable_virtualization().

The boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM) that's buried in tdx_enable()
really belongs in KVM.  Having it in both is totally fine, but KVM shouldn't do
a bunch of work and _then_ check if all that work was pointless.

I am ok treating everything at or after tdx_get_sysinfo() as fatal to module load,
especially since, IIUC, TD_SYS_INIT can't be undone, i.e. KVM has crossed a point
of no return.

In short, assuming KVM can query if a TDX module is a loaded, I don't think it's
all that much work to do:

  static bool kvm_is_tdx_supported(void)
  {
	if (boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
		return false;

	if (!<is TDX module loaded>)
		return false;

	if (!tdp_mmu_enabled || !enable_mmio_caching)
		return false;

	if (WARN_ON_ONCE(!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)))
		return false;

	return true;
  }

  int __init tdx_bringup(void)
  {
	enable_tdx = enable_tdx && kvm_is_tdx_supported();
	if (!enable_tdx)
		return 0;

	return __tdx_bringup();
  }

