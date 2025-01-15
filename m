Return-Path: <kvm+bounces-35492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C0BA11741
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 03:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41681188B4B1
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 02:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D1622DFBA;
	Wed, 15 Jan 2025 02:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ptmXa+CI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8D21798F
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 02:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736908110; cv=none; b=T0+flYsbQELtWVnb/Z632mP1iTAOipC0mMSg+hJDcR1dQYtDOXDw37e51zjDCdEgJXits7N4xbvmr5oxLN6KQgN5B2YgiYFdgQJ+rjORyGgbaoxSZKhI7PD4ZcL22DKs3J8AbZrkGk1Bu2ODMQF2jBmkV8G1sVyxNquMhwKbPJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736908110; c=relaxed/simple;
	bh=ZfJEdX888FyR/UEOoAtZOD+KvSvTeAbKj2ZQk4+CD7c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K5pJg8+S7psdkzKifXLxl9Do5043awEELuW32V+ir8/Dn+RsPZ4Tm1fCRJNrA7jjwIK1Bce01TZLHwsG1xSHs93vdyE4TVcfUDoqNW8LEwdGRIJCv93gEN2QSJ2FPR+LjYks2wpkCQDi3qleymO2j8pTELP5ssJnsLjeLo2XfYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ptmXa+CI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee46799961so16026011a91.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 18:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736908108; x=1737512908; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vZd9rD9LnIvJFdO20wn86prRApibTPy87K8yEgFw20k=;
        b=ptmXa+CI0+Qu5XBCW2x8kYcNb2Q8VC8cM5p4Yu89/e6cH0r8eH2DQwIpyJrNmvmd6u
         QO6qkd8DbFtztZcCztH4wG7BY6zqSvMv9o+Vq69d5XCp8xaMiYjOzAINVWySgHz8ndK4
         cIWY3FV3ZX6zco8YfY5oLHoxmmvEUdBousJMi5U4PHl6YQH/t+Nug4RZuu1Ew9uKlAuP
         Kcnv7aY9rceFI6ULwb96QKy+7t1fnYxPiJGzOgj2jJ0zaL/yjwJW3c+rVYvyjKti/eYH
         KjQvkN4cfihPQNGydkLkwt4oJ520aLW7Iv+ShtCuyPl1YZ2k3dVNqVmftvnV4+o743ne
         ZBcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736908108; x=1737512908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZd9rD9LnIvJFdO20wn86prRApibTPy87K8yEgFw20k=;
        b=kbmqVAyyaDfnjznBXLZCp4xR2o50/N658zcXETMpFoW2W0BsH7LxoUGc4Q5twxUB3p
         0IFY4DSk6cHcR0mfA769JoQiVQOj+pfdfrWnARFt/dly+CCdEcLR7AZobkq1RBQgxNk+
         k+D4kNQD09F8/eQoyYXXMvpGia6C4O9EPFE8Et/WKndylKAzYXMShMNe+ZsipzEn5+Ox
         JsSfDdbKCxjVvJE4L5BmZS94LKl9hZp1Dequmk+37Z35GI3gmi5SBUMHJX+g+oRTIH73
         +45cyj4y9D+lMMwZhhe3BO8luPDgrKAUhmYgIbKbvyK75JjZR1j3/auEj0PbnzsUUh3k
         i9VA==
X-Forwarded-Encrypted: i=1; AJvYcCV4ustmlcDJIwS5mdCzZG6JFEl37u/6OSfd44PPkOOrA0H+D14GP/DI6eeyGoHf654Q6r4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/g0mwIomsvOenkFg4mwhPqSFcT0olOuDF6jYWGlyJBxW43bac
	6hrBulZMAFlXjKhWbLvI7MZID9wK6ijpQ6VS24/zknmfVHn7xwG2b/5R7QZ0rOhWmXnGNnqSoOi
	OHw==
X-Google-Smtp-Source: AGHT+IEj70HHR7Ge90gWY/SZ+br4dWjDMhpzXSv4SNOqWyekGQGxPfOgOe9PodJe98cOOcUzIj8as/3yYwc=
X-Received: from pfnp6.prod.google.com ([2002:aa7:8606:0:b0:725:f14a:b57c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4485:b0:728:ea15:6d68
 with SMTP id d2e1a72fcca58-72d21fdfa27mr41148854b3a.18.1736908108307; Tue, 14
 Jan 2025 18:28:28 -0800 (PST)
Date: Tue, 14 Jan 2025 18:28:26 -0800
In-Reply-To: <51475a06-7775-4bbb-b53c-615796df8417@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Z0AbZWd/avwcMoyX@intel.com> <a42183ab-a25a-423e-9ef3-947abec20561@intel.com>
 <Z2GiQS_RmYeHU09L@google.com> <487a32e6-54cd-43b7-bfa6-945c725a313d@intel.com>
 <Z2WZ091z8GmGjSbC@google.com> <96f7204b-6eb4-4fac-b5bb-1cd5c1fc6def@intel.com>
 <Z4Aff2QTJeOyrEUY@google.com> <3a7d93aa-781b-445e-a67a-25b0ffea0dff@intel.com>
 <Z4FZKOzXIdhLOlU8@google.com> <51475a06-7775-4bbb-b53c-615796df8417@intel.com>
Message-ID: <Z4cdShy8Cuitd44I@google.com>
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

On Tue, Jan 14, 2025, Adrian Hunter wrote:
> On 10/01/25 19:30, Sean Christopherson wrote:
> >> Currently the KVM selftests expect to be able to set XCR0:
> >>
> >>     td_vcpu_add()
> >> 	vm_vcpu_add()
> >> 	    vm_arch_vcpu_add()
> >> 		vcpu_init_xcrs()
> >> 		    vcpu_xcrs_set()
> >> 			vcpu_ioctl(KVM_SET_XCRS)
> >> 			    __TEST_ASSERT_VM_VCPU_IOCTL(!ret)
> >>
> >> Seems like vm->arch.has_protected_state is needed for KVM selftests?
> > 
> > I doubt it's truly needed, my guess (without looking at the code) is that selftests
> > are fudging around the fact that KVM doesn't stuff arch.xcr0.
> 
> Here is when it was added:
> 
> commit 8b14c4d85d031f7700fa4e042aebf99d933971f0
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Thu Oct 3 16:43:31 2024 -0700
> 
>     KVM: selftests: Configure XCR0 to max supported value by default
>     
>     To play nice with compilers generating AVX instructions, set CR4.OSXSAVE
>     and configure XCR0 by default when creating selftests vCPUs.  Some distros
>     have switched gcc to '-march=x86-64-v3' by default, and while it's hard to
>     find a CPU which doesn't support AVX today, many KVM selftests fail with

Gah, sorry.  I misread the callstack the first time around and didn't realize it
was the common code that was writing XCR0.

> Is below OK to avoid it?

Skipping the ioctls to set XCRs and SREGS is definitely ok.  I'll hold off on
providing concrete feedback until I review the TDX selftests in its entirety,
as I'm skeptical of having td_vcpu_add() wrap vm_arch_vcpu_add() instead of the
other way around, but I don't want to cause a bunch of noise by reacting to a
sliver of the code.

