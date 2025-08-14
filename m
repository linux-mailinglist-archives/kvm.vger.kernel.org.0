Return-Path: <kvm+bounces-54629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C482FB25884
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 02:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EAD63B0008
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 00:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB00F158874;
	Thu, 14 Aug 2025 00:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QgczY9Cu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7712D2FF64E;
	Thu, 14 Aug 2025 00:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755132126; cv=none; b=LShfrVY4OkfW2l8RrCpRgfiHkiE1oXsfvcOVmWcLA1SgyWVwGbJaCzj4Q6CkCAx0fCwj4GrpC5fWMwUrqby/BYy5NfLPZLxeHR1jewRy7oOiA+qVWrD2D8N4hPdlUhgux7r58/LMjz6vIgWRA15XUScJD8GZEXTAl8sFlWVdeZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755132126; c=relaxed/simple;
	bh=2AyuyY8jOJfSWOHFbWeZJd5RK6edkeRSZfWoN8M4qaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zl8K2fBMiLK1efXequKca5O43euovrrZwP2LFoArD09CxFqI6i/Iz+i6F7KX/USjtFY+P7mSz0VYofT17kXsClO0sYwKDC/vikNKxbQtqWTNfx6/V7XNJ7TPZztRoccoJV8wvqrrdbHrIkLjafM5ded7bHLwpMh4vUUiJrqGTBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QgczY9Cu; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-32326bd4f4dso410551a91.1;
        Wed, 13 Aug 2025 17:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755132125; x=1755736925; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jQSzYpp/Kw6XvG2Zk3vgLEx7CcGvhlvhRCj75K67uYw=;
        b=QgczY9Cu45JfbdXsshS7s1Q4ZZqiKmzU5XhKW+C2inXs6beChYxsW00qVhimRzFzkh
         QxDZkffTsDlWC0OlPV4JqRUTCb5ovVkM+bNgR41UKGmSkdEltKW3eHe3a5oVLVl+V6lj
         OTkNtREtEnL5hfKuxpZkx2NuQy/iYuv4tkUnTSve0a4Hh/FD4doxk87udOe3V8u/UDtm
         yfjiJ5VsZVgMZttojQxicT3JdbofzXUk1NKAknZnbAcNXpZceSvfuriBZgGzcsYJeb5E
         kaBv+vRNtG7VXHTmI9fgsA89ZthtD7LGmhrhI9vKuO5fioBDUpt8BBbmKL/2M/+idVgI
         0dVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755132125; x=1755736925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jQSzYpp/Kw6XvG2Zk3vgLEx7CcGvhlvhRCj75K67uYw=;
        b=MLbNMbJRyfThtmquHwtMATCBj/2skOY6o0Wuyz3TuvddM1Rm1sqenplnYcsaz6vQrD
         ExvQD65k6Sg/9wjMGdCj7fn/U00FvM2ZEMm9CzYvE5ws/VC7dLE/wKC+vcqQ2yE2Y8mJ
         SOvc+shd3YAR4qPtje62sF9F+psPEN1sVDebL7yHPXV0CHT/XiDGXMcm177dnlD24U/e
         fAtOg1sg7vcGzyB7E6PF8ZtFwxt6S85sGmdxQRvdVKq81S3ZD7k4u/5sL9U6EPn0woyh
         9nPL4ncuDL3HiitLIV5U1cLhwF8xUhQVQ2a40jNMFqTtHHpnyJySDX2dKKCfZT4e/cPY
         KC2g==
X-Forwarded-Encrypted: i=1; AJvYcCVIPJPI3fZFLCBWKmXbw13pIk0NRUvr1YZu9nFTZeuesXVwqYvb6sx01hk2y5dxxLse+6/B254W4C5FRyEd@vger.kernel.org, AJvYcCXe32m+/LePxlboEQQmL+SF2haTTehZN8yld87qNaeM4vyH/2cJw2y4HUJN+DYvpyqZZ3s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1D5JgGH1qnR+RNa+iWF0PmVPOgb7H1oaSimx6k+zufBklT649
	WkXVwRgEbhlwjntJ2Nb9YH8COzVBOeuFIMs8/PN6VeHhtMgL9Rhvw8EW
X-Gm-Gg: ASbGncuCyLGUjhLbIYcx8RL0kL9xy4Co9pn1QyTR2PQAU4hTSy8EVYtM3Vq0yeAI9bC
	80blvmk+kYKjl+DLtdWQa1abes1FtVNoAG6HH9j8PQaVwYnY7JsgN6IzzIHrjnNgFhH20iTON3o
	oELtbyqN0TU1IbD9yby/plL/snAGMb2zRJzDr7U1AYPf5hL1d683iTJseY0TZ2dWh6z8LXpdZZq
	GlSKtu/TKgiwaLAArAgtba+SGKhwpEJ11XjHUYktIqRSlixh0QPFfbai1EhrUKOuU3rq44sNzWG
	4LVtxLf913A5ERyV4Er2H8Mch9x58M8KL2jpmmq4h3Ub16EUWYskH46ghnbPqhXBZF+snx1m+4/
	xEiclgm+kKc9JwPMnV5+Uug==
X-Google-Smtp-Source: AGHT+IFyi0oBaVhKQSKgeG+HpvEZqmGtj0trvg3Wauhiu6iaXOBidJ7kcCKO0zzGk7Sbzm4PK7Qcyg==
X-Received: by 2002:a17:90b:4c48:b0:31f:252:e765 with SMTP id 98e67ed59e1d1-32329a934f1mr899151a91.6.1755132124581;
        Wed, 13 Aug 2025 17:42:04 -0700 (PDT)
Received: from localhost ([216.228.127.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32330f83626sm35226a91.2.2025.08.13.17.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 17:42:03 -0700 (PDT)
Date: Wed, 13 Aug 2025 20:42:01 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Zheyun Shen <szy0127@sjtu.edu.cn>
Subject: Re: [PATCH 2/2] KVM: SVM: drop useless cpumask_test_cpu() in
 pre_sev_run()
Message-ID: <aJ0w2dKYwNQNllQb@yury>
References: <20250811203041.61622-1-yury.norov@gmail.com>
 <20250811203041.61622-3-yury.norov@gmail.com>
 <aJpWet3USvXLWYEZ@google.com>
 <aJpgZeC8SEHfQ0EY@yury>
 <aJppAp5tK7kPv8uj@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJppAp5tK7kPv8uj@google.com>

On Mon, Aug 11, 2025 at 03:04:50PM -0700, Sean Christopherson wrote:
> On Mon, Aug 11, 2025, Yury Norov wrote:
> > On Mon, Aug 11, 2025 at 01:45:46PM -0700, Sean Christopherson wrote:
> > > On Mon, Aug 11, 2025, Yury Norov wrote:
> > > > Testing cpumask for a CPU to be cleared just before setting the exact
> > > > same CPU is useless because the end result is always the same: CPU is
> > > > set.
> > > 
> > > No, it is not useless.  Blindly writing to the variable will unnecessarily bounce
> > > the cacheline, and this is a hot path.
> > 
> > How hot is that path?
> 
> Very, it gets hit on every VM-Exit => VM-Entry.  For context, putting a single
> printk anywhere in KVM's exit=>entry path can completely prevent forward progress
> in the guest (for some workloads/patterns).
> 
> > How bad the cache contention is?
> 
> I would expect it to be "fatally" bad for some workloads and setups.  Not literally
> fatal, but bad enough that it would require an urgent fix.
> 
> > Is there any evidence that conditional cpumask_set_cpu() worth the effort?
> 
> I don't have evidence for this specific code flow, but there is plenty of evidence
> that shows that generating atomic accesses, especially across sockets, can have a
> significant negative impact on performance.
> 
> I didn't ask for performance numbers for optimizing setting the mask because (a)
> I know the VM-Entry path can be extremely hot, (b) I know that dueling atomics
> can be hugely problematic, and (c) I don't see the separate test + set logic as
> being at all notable in terms of effort.
> 
> > The original patch doesn't discuss that at all, and without any comment the
> > code looks just buggy.
> 
> FWIW, there was discussion in a previous version of the series, but no hard
> numbers on the perf impact.
> 
> https://lore.kernel.org/all/Z75se_OZQvaeQE-4@google.com

OK, I see. So, as I said I don't insist on moving this patch. Let's
drop it if you think that cache contention is critical.

I probably need to think in the opposite direction - if some code
pieces trash caches by concurrent accessing the whole cache line just
to set a single bit, and people try to minimize that by using
conditional set/clear_bit(), we need to make it as effective as we
can, and a part of the API.

Thanks for the discussion, Sean!

