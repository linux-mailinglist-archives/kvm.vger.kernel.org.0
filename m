Return-Path: <kvm+bounces-28415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD01699837F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 12:25:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FCE01F226F8
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE071BE857;
	Thu, 10 Oct 2024 10:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pRXMscBv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF5B1BDAB8
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 10:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728555876; cv=none; b=aJpJeVE+uGnfDZQ4vmWp0ofrHdRSPBY70/q4TyVmtKg3agKG6QUNb0LPJ3K5i1eiqqDUFPlKuZS5RUNSPeNGMjIkOnCVFWq2lwxE5nezgtqE1fzl8hz7ZUsSOiz3Hex7uw6gM6qjzgr+UcUJJFT/oRKex7GeFuUwPOvZf/9k2a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728555876; c=relaxed/simple;
	bh=fFCNlWru5+pdNkh5QLeCqMQctRHkljYByudCKs4aFmk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KmubbaFUc3zvZ11IM4oXYIuMpV5NJaG0SrkkvKKm17k5aNnL9jiPis2QDs0ldwTjI5eYUuhYhsrMTM4woJ8kMetS/lrY8sF88djyphE2pOi45ODR3zEk+geMA5HTlX+NNs0Zwb+FiAg5fk+cUaSPpvWtZOa4l52eA/OnqiW9++U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pRXMscBv; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-431141cb4efso214155e9.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 03:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728555873; x=1729160673; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OzRLepl01rBIXpKHqICQ+VG1MuVzX81celcTfUwqlgU=;
        b=pRXMscBvWOklh5qqGefn55MF5TZ+PgIdn9PG4HliizTi3aFK3J1MiZ2EFshqp6knBX
         ljuGWaa++VNlUXKx9xFLsIE+1nYVtnUQmA+6hRheVxVE/gjXYZKPQiDHl32VpgXIW1wG
         6dIXRKQk0cKtKnRaBbJV8Alxe1x0w9JFoDJ7bTqtxKzK1mgcrF7LNEFXsh6uz8UhZxYQ
         IhN4Y0r4cdwImmw3ukP4Ta7KnD30/MEFnfpu9q2m0yNBRqpHpSS00SDczGkeIeM0O1To
         1If17pamiRJKEROLwWJF6TClGh7DHdaRJFZfL+29qC9zQbQZn6a8D96ugyknZIKEMJcc
         I3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728555873; x=1729160673;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OzRLepl01rBIXpKHqICQ+VG1MuVzX81celcTfUwqlgU=;
        b=bljaQVs8SYHJI0WimMpJmmbX64w+r2ZEpw1gCD0DpKhyFVXoIYJcNjA4YyrrggT8wk
         1x4k6LyjlbcVcRuY0AO4o98jJZa39VbbCizQk+rkRZlHTn9WD9NR/xoLLtrrMAfN6Dzs
         OAmAO5003e54sdaw5KZpZvsb0mesO+6czRdyUg7MeGjjk1j+I7fPCHrFW2jgks/f/G4c
         3hLXV6I3TemU1Uj/wh9T++AEqCVmaFKtNN2KjVacq3KV1mMP6lCgXrCmtLBHdMy5USDt
         ihLxZds0e+3CxXqM3XHymC/lETZypx5rIzpo5hCm1OlUiUU2sYV1assjNoOj67Qfhxi5
         nZtQ==
X-Gm-Message-State: AOJu0Yx0AQoM8Lc/ctS60HV9wajTyshLlfXwfDugGBJkalrRYwrYGT8T
	mWyvZ+U27oa423A6Hpj33hmJpbJ5D5ho/bmmVib0YM0Htrw8dqOPSKE4VYaOznlW0HGNalZIO2G
	hBetC2wo14NPy0jvCVOGG5B4yVcXXG41dKeLu
X-Google-Smtp-Source: AGHT+IGFf0e8gomwA6a0slETrpo9MsW4kTd5EZtJLAbPns5yYHIued/ItYJ6plaUZhkrBipZGu+G9pNHAZZCl+u+1Kk=
X-Received: by 2002:a05:600c:1e21:b0:42b:a8fc:3937 with SMTP id
 5b1f17b1804b1-431161b4011mr3744105e9.4.1728555872435; Thu, 10 Oct 2024
 03:24:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241010085930.1546800-1-tabba@google.com> <20241010085930.1546800-5-tabba@google.com>
 <i44qkun5ddu3vwli7dxh27je72ywlrb7m5ercjhvprhleapv6x@52dwi3kwp2zx>
In-Reply-To: <i44qkun5ddu3vwli7dxh27je72ywlrb7m5ercjhvprhleapv6x@52dwi3kwp2zx>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 10 Oct 2024 11:23:55 +0100
Message-ID: <CA+EHjTwOsbNRN=6ZQ4rAJLhpVNifrtmLLs84q4_kOixghaSHBg@mail.gmail.com>
Subject: Re: [PATCH v3 04/11] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages when shared
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Kirill,

On Thu, 10 Oct 2024 at 11:14, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> On Thu, Oct 10, 2024 at 09:59:23AM +0100, Fuad Tabba wrote:
> > +out:
> > +     if (ret != VM_FAULT_LOCKED) {
> > +             folio_put(folio);
> > +             folio_unlock(folio);
>
> Hm. Here and in few other places you return reference before unlocking.
>
> I think it is safe because nobody can (or can they?) remove the page from
> pagecache while the page is locked so we have at least one refcount on the
> folie, but it *looks* like a use-after-free bug.
>
> Please follow the usual pattern: _unlock() then _put().

That is deliberate, since these patches rely on the refcount to check
whether the host has any mappings, and the folio lock in order not to
race. It's not that it's not safe to decrement the refcount after
unlocking, but by doing that i cannot rely on the folio lock to ensure
that there aren't any races between the code added to check whether a
folio is mappable, and the code that checks whether the refcount is
safe. It's a tiny window, but it's there.

What do you think?

Thanks,
/fuad

> --
>   Kiryl Shutsemau / Kirill A. Shutemov

