Return-Path: <kvm+bounces-54800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D53B28349
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 17:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C89805C7CE5
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 15:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30AA93090CB;
	Fri, 15 Aug 2025 15:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VbUwWtvm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09D8308F10
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 15:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755273101; cv=none; b=m90cCMGsVe+n07fga+P1+X7zdSx93czj5dMma1lXzVU38EgT+Av3e698QhAQ7N+hPQqdC3NWe72uIwC23+ZqaKN8E778fcKA5D1n/GAS4/G/kvttGZSfNFnvj2x9bumai+f3hu6oZV67ZV1XWtJ3z9NDnWojEReq+xQ8UYjgveI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755273101; c=relaxed/simple;
	bh=TC3F7GjzY+OYu16pCnRLEw1W9DDDYcqj1aSZMIOYjuI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G5LWYoRkl2AbLHxGTysFm937jSdPgK4czxNjsAu0Zv2VKXhKjohvP1fuHEO/fNzB3kHn2uYwbrxSCWmQbQGbjNvdVNgJNxGdZKwII3SiqvQSYtvCa7nVX5tzJi7G300c/lhm51lFjC7i7DScA7AABtBlKYVkOsn46JV8uLkAPTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VbUwWtvm; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47156acca5so1613476a12.0
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 08:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755273098; x=1755877898; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yLuuQdqXBRGyu60+ieS//bbxP+3AVwFN22YqAdloirM=;
        b=VbUwWtvmPg2mzJ1mDCrvoA9XcEX+R1vUa2Ytu1ZtQTkrmWQBNqlULza7r07TfXRunw
         rgTiJih/HIKEqr7vaGDRRkBS0UnEY54fKQBbf4WBjGJVIk38G8ugO1jrZ3Xd0gSIz6cT
         R8STM5KEF6lEudZxvKFLWEkK0CiqcYRWCl8OZlFVyonlBmDE43x4v3HHCoaFVQYkZue0
         3DDjzZSrVEJdosIX6rTshEjnnm7d/hKlnkWEy3LUwn8NqJ7LWYZ2DxJChCMoZwznWSqX
         TRyAEETcPbALtpKTWxzCy1T3weTv0fjnZI76Z8PrWUcFGL84VdFEXdrEadNIdzowWYYh
         l9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755273098; x=1755877898;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yLuuQdqXBRGyu60+ieS//bbxP+3AVwFN22YqAdloirM=;
        b=ttDNmSPQz/ewcATY5Zbl/1n6+GSAmW05E+fahe0jlWQ5F3aiADPybJPmpNBLiZtGfE
         EH+CQ3+E3Ld9CLgrqF36uYLJcNEwxde2C5rIJA60QXHpSS+mmvp8BBmw72U2KNZYk5s1
         w2cf3AwxlPxYTeBN/EoLzufvSd/OXiD+g9nErtUz9YC7Wyl74uTDni915AoiuYYHxjVr
         A4jMfOYyVejGDaQ0mpFXG8EYwiRfBdK5TY1pVNmDMag5/E+8Fp3587hF8h8LyGdhZf7g
         G5G8zgxZRjQHgprvYc0j6jm2gY4EfnjBruji3kK3YJvynAR6YqRpjt7D3X1x0PvsEE/x
         RTyg==
X-Forwarded-Encrypted: i=1; AJvYcCWGIGwNlV9tv7T6k3SQb6Y4erFW3yQdfkKWHT1Gye3X16TR5Vqn+24y4GmGXHwsp90tzaU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0o+u2dNUsHY92FHUKYwX3mRxUy1J0ZCFmTnUHyimGRld/IRQl
	3FMKz6rH6NE5aDfEvMNOp4EVFLiy3oNsY6ti89tVzIq80OCiThJVrrtMXPwumGNLxb0dKQ1gLJ6
	nHfZxJQ==
X-Google-Smtp-Source: AGHT+IEixUUF/+ontXG1UvvxuaP113HP3iSlTpnTS0Og0gwZnRo8djp+nSrKI0cvN3mMbDgB4JtBQNij17k=
X-Received: from pjee7.prod.google.com ([2002:a17:90b:5787:b0:321:c2d6:d1c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cec3:b0:244:5aa5:a8b
 with SMTP id d9443c01a7336-2445aa50e20mr99042625ad.27.1755273098085; Fri, 15
 Aug 2025 08:51:38 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:51:36 -0700
In-Reply-To: <20250815130436.GA3289052@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-10-seanjc@google.com>
 <20250815130436.GA3289052@noisy.programming.kicks-ass.net>
Message-ID: <aJ9XiAa58oMs55Ky@google.com>
Subject: Re: [PATCH v5 09/44] perf/x86: Switch LVTPC to/from mediated PMI
 vector on guest load/put context
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 15, 2025, Peter Zijlstra wrote:
> On Wed, Aug 06, 2025 at 12:56:31PM -0700, Sean Christopherson wrote:
> 
> > @@ -2727,6 +2739,21 @@ static struct pmu pmu = {
> >  	.filter			= x86_pmu_filter,
> >  };
> >  
> > +void arch_perf_load_guest_context(unsigned long data)
> > +{
> > +	u32 masked = data & APIC_LVT_MASKED;
> > +
> > +	apic_write(APIC_LVTPC,
> > +		   APIC_DM_FIXED | PERF_GUEST_MEDIATED_PMI_VECTOR | masked);
> > +	this_cpu_write(x86_guest_ctx_loaded, true);
> > +}
> 
> I'm further confused, why would this ever be masked?

The idea is to match the guest's LVTPC state so that KVM doesn't trigger IRQ
VM-Exits on counter overflow when the guest's LVTPC is masked.

