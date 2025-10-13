Return-Path: <kvm+bounces-59924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A943BBD5449
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 18:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0AAF18A5BE3
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 16:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD3C29B766;
	Mon, 13 Oct 2025 16:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zkkPO8Ew"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFE629ACF7
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 16:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374348; cv=none; b=omvVhECnJ69n/vSZQXqNn1tTvpeD+ZJaaw0RgC994iiL7qVsaBnouiezOxN2DFlgXAfEoIPU3Ohux8fxhBpRnJYAJSjZfvEwximE353e16Lb4Ael0JZf2Ps/I2YvayfOuDqJn6JviIm6EJFyEWfP1sIvW/jBM2wbY/wpNvk1XMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374348; c=relaxed/simple;
	bh=e3tLcIQLqH6H/IT1sJqhXxFczgdqOWot4PqZ6gWHfkI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=apQwOr6k+BCDQhvm6JLTyVZcguB3s4cm4S0u6+TtzVfByW9AR0MN4TKPBscfm3ZiZ9iZ5JJDEWLts7RQhQF1zpoY+qL4wkisXjnhADFg/CqrscIyQhugBtbEYZhBDE2C3B0Ob4QILtTnfmF5uOtpkkkd9fCVgD+bXNhlZ/wWgwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zkkPO8Ew; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e25f5ed85so38602195e9.3
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 09:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760374344; x=1760979144; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WCgnvEw9iBAU3lsygBQE1W+28HxHDdIOUKUuUDxXYXY=;
        b=zkkPO8EwCRpAKctqb3/I0wFd0sl/v71r4+QVi9IWzAZMi1gqudBKmwLjvD8NN8S80A
         DbWicQ+i39evOGbJeTko7MaAYaWO+UqW7sLKoWM5WHxi9zx4INo4GPDp1pOHIOFq63HR
         VTXkTNOeAJ4abz1HCOzj1W3+1MeWCuPt3J5zWPDXtUCWZif5omCpdpYZaUmU4YMQ7/VQ
         OGrO/1j++UA/8mFjDpgH9OJIPuve1V24lVyDDj4iF4zCmvIuQrovlTmkDQbGmcQAZuPr
         M4W5pzbbZzicRY1el2cstxvjHCFXmd4ms5wfqZ8UABlEXkPFbHk+j3c7O18dfclZdKHo
         u5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760374344; x=1760979144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WCgnvEw9iBAU3lsygBQE1W+28HxHDdIOUKUuUDxXYXY=;
        b=BjK8YDEMPWuCz4v4RCgtRu9H9ay6g79twgxga7pXjMtcg414BGe1NdyApSm+jSOmTq
         ZRYtDhxIAwmDjWjqNqAHLsFrw7NP3Pt0QjW4wLgGafuHOizzGp1Q2qFDtH8DJ/EveGSX
         Vfg3TPPFVqt62xmzWlhblf4jm6x6mqCp39NkHFfI56aEv0QAMq4o3I5cfgNhB3ZkWpck
         IeF00695hMXPlreeFGGDBtXAkttTWvFkIcs0b7L6ZiasHgZ0ag2GhvGRldzlFBBu5agg
         YrSzFs75QfkJF9RrLS9SGSZg09Tz7FoGn1EGjzQn8O9VyToL7Ju2adv006EoRBmnsfpr
         sUcA==
X-Forwarded-Encrypted: i=1; AJvYcCXfQirGLGpQFyRtJ0ITzjVrrdLAMm+ATeRxP31S+PyCeRS+DZsmRp9B8IgcoCppAV98y9I=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqoi+mPb/W9Nj9xilYVcG4jD0SyWuUsu+Xja8x9nOVhXIj9Eo/
	ZawKeGlpTRTljhfTD1HV5pTK3PGte9tJZo3BZR0HHB5uVXX+ZhHqfPrGZzQYVu985wxeJldyqwU
	8K30O+ceLidezJw==
X-Google-Smtp-Source: AGHT+IFuUBdOJkQeVkRTNpKcA2QYqIWBVJCJUEfYckN5CTEqD3lX+DF6loFWSuPGufrlH9/FO+WMiotZpoZzwA==
X-Received: from wmgp15.prod.google.com ([2002:a05:600c:204f:b0:46f:c7ab:c8ce])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:628b:b0:46e:4814:4b6f with SMTP id 5b1f17b1804b1-46fa9a942b1mr161318715e9.2.1760374344710;
 Mon, 13 Oct 2025 09:52:24 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:52:24 +0000
In-Reply-To: <aO0pf8h8k0NddyvX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com> <aO0pf8h8k0NddyvX@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDHCMHEN3389.3KHOEVYLJY26S@google.com>
Subject: Re: [PATCH] KVM: x86: Unify L1TF flushing under per-CPU variable
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, 
	<kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon Oct 13, 2025 at 4:31 PM UTC, Sean Christopherson wrote:
> On Mon, Oct 13, 2025, Brendan Jackman wrote:
>> Currently the tracking of the need to flush L1D for L1TF is tracked by
>> two bits: one per-CPU and one per-vCPU.
>> 
>> The per-vCPU bit is always set when the vCPU shows up on a core, so
>> there is no interesting state that's truly per-vCPU. Indeed, this is a
>> requirement, since L1D is a part of the physical CPU.
>> 
>> So simplify this by combining the two bits.
>> 
>> Since this requires a DECLARE_PER_CPU() which belongs in kvm_host.h,
>
> No, it doesn't belong in kvm_host.h.
>
> One of my biggest gripes with Google's prodkernel is that we only build with one
> .config, and that breeds bad habits and some truly awful misconceptions about
> kernel programming because engineers tend to treat that one .config as gospel.
>
> Information *never* flows from a module to code that can _only_ be built-in, i.e.
> to the so called "core kernel".  KVM x86 can be, and _usually_ is, built as a module,
> kvm.ko.  Thus, KVM should *never* declare/provide symbols that are used by the
> core kernel, because it simply can't work (without some abusrdly stupid logic)
> when kvm.ko is built as a module:
>
>   ld: vmlinux.o: in function `common_interrupt':
>   arch/x86/include/asm/kvm_host.h:2486:(.noinstr.text+0x2b56): undefined reference to `l1tf_flush_l1d'
>   ld: vmlinux.o: in function `sysvec_x86_platform_ipi':
>   arch/x86/include/asm/kvm_host.h:2486:(.noinstr.text+0x2bf1): undefined reference to `l1tf_flush_l1d'
>   ld: vmlinux.o: in function `sysvec_kvm_posted_intr_ipi':
>   arch/x86/include/asm/kvm_host.h:2486:(.noinstr.text+0x2c81): undefined reference to `l1tf_flush_l1d'
>   ld: vmlinux.o: in function `sysvec_kvm_posted_intr_wakeup_ipi':
>   arch/x86/include/asm/kvm_host.h:2486:(.noinstr.text+0x2cd1): undefined reference to `l1tf_flush_l1d'
>   ld: vmlinux.o: in function `sysvec_kvm_posted_intr_nested_ipi':
>   arch/x86/include/asm/kvm_host.h:2486:(.noinstr.text+0x2d61): undefined reference to `l1tf_flush_l1d'
>   ld: vmlinux.o:arch/x86/include/asm/kvm_host.h:2486: more undefined references to `l1tf_flush_l1d' follow
>
> Because prodkernel's .config forces CONFIG_KVM=y (for equally awful reasons),
> Google engineers completely forget/miss that having information flow from kvm.ko
> to vmlinux is broken (though I am convinced that a large percentage of engineers
> that work (almost) exclusively on prodkernel simply have no clue about how kernel
> modules work in the first place).
>
> I am 100% in favor of dropping kvm_vcpu_arch.l1tf_flush_l1d, but the per-CPU flag
> needs to stay in IRQ stats.  The alternative would be to have KVM (un)register a
> pointer at module (un)load, but I don't see any point in doing so.  And _if_ we
> wanted to go that route, it should be done in a separate patch.

Ack, thanks for the correction. I indeed thought wrongly of kvm_host.h
as the "builtin KVM stuff" place.

I also see from the commit message of
45b575c00d8e72d69d75dd8c112f044b7b01b069 that PeterZ suggested irq_stat
should be cache-hot.

Will wait a day or two in case anyone spots other issues.

