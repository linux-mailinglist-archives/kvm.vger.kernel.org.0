Return-Path: <kvm+bounces-60956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2B8C03E99
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 01:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6717C1A67F4A
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 00:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B7C2E4278;
	Thu, 23 Oct 2025 23:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cBDI8FR2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7730D2DA750
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 23:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761263958; cv=none; b=ZpE3iF/Bz3bnXf4weUCIj69V15PfqOkjUZ3stuai+QNNd7pbOkwaiPpYazFbO/5ryWvSS9Jo9SQPXvU2P3m0bOnu77UTj4g1J+YGZXR8gPojNI31eTMm63/JqiCh9m5ygvH6/FPXQIQaLaEkfwSXXjdhtGPW2SjzCGNaRr5kGCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761263958; c=relaxed/simple;
	bh=KRqFx1cZkwsyBUxEVPNGesO9wktbAXLUFJV2t0yuRh8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=COc6wyLbDDUZnWged5dtOaNYZfCgrDzLy70LmyElFBFnZ+NVnxMYKNV3u2aBoNutJRkezKxjMFOiDj5nalZcUspI9EKlLuLuwbibnjeGqXUC6hfVqspAd9nYQpcEHZ4hNF7nt/m5kXUMq3Fv1WmoC6V8SHTWd8DF/P2fBtzFXuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cBDI8FR2; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4e6ec0d1683so82401cf.0
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 16:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761263953; x=1761868753; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OWaPYvH94F3bazBBQR1mRrH2sncW+IAfzERpSr3zH6w=;
        b=cBDI8FR2q8G+wj/K7qG8Xv1LOz52xdMF0mAjnX/UuhvnPwmNybAhHmkFcdjC0zTzdP
         nOmxIwLxVyHLEv9ExgF6SgSPKfqHEIDkz+VsvHiWGB71OwQSL09CWKa2pN1lnMroIA1P
         pks6bcR7Qp62Wqj2oL/y5U/ZX96fhXEU+E6wAJ9qnRWRHdZBqOuF6/8ARR4z3L7NIDH4
         gazN6fvDW2A4wdKACHdVdEwITcCZenBPCIxIkabUmDEttmsyeQ8m3b972PSzKg8PuFQw
         LD1O2J41f6W/ZIIIhysyF7VzPZCQHJUURKl3mpZa6umfRvD4FSqw7n41mssstow+83ho
         IzVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761263953; x=1761868753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OWaPYvH94F3bazBBQR1mRrH2sncW+IAfzERpSr3zH6w=;
        b=UHzo/8yyYSCoaJmsdGlpMsM1Wk6G4OZ9/quKJGwfotO4fcy/kKNYl81+C9DXD7Sair
         v3HvAVEIr5LsmmsKo/g7Nqms83OxNPQjjPrQ0r51JszZbMDfPjsy17MW5cc6X9ccSWXK
         Ei+LJGXXzNR/W+wZ1MV9f9h5jpTwwWxXNelVUXJpW9V4YeHLbwwTgHYzwCyKUdANLpJL
         jGse+BiRK+f/aiBgn0nS4DFhgb2mAj435pZ7jV8yXw1eTuj/A0Yw/x03/lnVa6l/JEAJ
         z2lW18RyIwmjZFc57j5tz95cKkabfQtGbeNbq/7/kq/lVZeMF+MKezBG6MtjxaUmgQ+T
         84eg==
X-Forwarded-Encrypted: i=1; AJvYcCX3apd8MGIt5S6jtu/wmTFaUOxRK+aIN4JfmGq3fB7XL94eoeE8qf6vpX9rFOXdDoaGu6o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcV7GPh3mGjop9kOnN9ZddkHyryL+L7q0dqCtyHoY6LlS3bUxU
	d3GDjr1NgRR88UXpubirp8vhKn+G/Ww/7QPO/fhPlZfNOZet9l+8h0lmkgMXHlEBQQIYgebPozK
	h35DoiPuqywVSe7NZrMcA/NbWMOAhLxdM+dZkCA+2
X-Gm-Gg: ASbGnctYnOJP/ibzdYyFCNqzjmez6di6rKReTmu1PeZaCYYpW++1/2m5VDAT/NHns2w
	ZJzVqqVhzMJ/EIlxeq8C9o+1LTCTQQiCkiqd5IQKhDDasNvBdxnKZyvRePsvVlE5bCG5T4NNfdM
	NDkKBvyhAgDdYBMUhqkN4mS6+ekk5jPTPziAZhH5FuHBt6m087tUjZ6CwVywWqY4YpV7SoCOqX/
	IQA+iBHQ4c73xnnMIROyVMAwm76RinlvBWybkpL1oxqG92IHEk+b/Rm3CV74JryrIXVIqkENuDD
	xtzicqqi4ADI3UlqZ+B8kMGw/8WN
X-Google-Smtp-Source: AGHT+IFiCpGL8XfWTU0ddwConeQqYO4+/7UNnfpipr71hb3sds9xvvlkZExSlvxpN5YXK1dP6WJgpa5Frp79V38UrVw=
X-Received: by 2002:a05:622a:1495:b0:4eb:75cb:a267 with SMTP id
 d75a77b69052e-4eb9251b2b5mr2286001cf.12.1761263953189; Thu, 23 Oct 2025
 16:59:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com> <20250925172851.606193-14-sagis@google.com>
 <68efcb7ee33e5_cab031002e@iweiny-mobl.notmuch>
In-Reply-To: <68efcb7ee33e5_cab031002e@iweiny-mobl.notmuch>
From: Sagi Shahar <sagis@google.com>
Date: Thu, 23 Oct 2025 18:59:01 -0500
X-Gm-Features: AS18NWB13mopkwuSS4JxlZadYovueuOn6EGZfluKJpeBEQ17CYTqorbiZz-kY7o
Message-ID: <CAAhR5DGcz-2=a6Q2zZS_eP2ZjNNPs65jNG+K50tdVAQfC6AbbA@mail.gmail.com>
Subject: Re: [PATCH v11 13/21] KVM: selftests: Add helpers to init TDX memory
 and finalize VM
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2025 at 11:25=E2=80=AFAM Ira Weiny <ira.weiny@intel.com> wr=
ote:
>
> Sagi Shahar wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> >
>
> [snip]
>
> > diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools=
/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > index 2551b3eac8f8..53cfadeff8de 100644
> > --- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > +++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > @@ -270,3 +270,61 @@ void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t at=
tributes)
> >
> >       free(init_vm);
> >  }
> > +
>
> [snip]
>
> > +
> > +void vm_tdx_finalize(struct kvm_vm *vm)
>
> Why is this not a new kvm_arch_vm_finalize_vcpu() call?

What do you mean?
>
> Ira
>
> > +{
> > +     load_td_private_memory(vm);
> > +     vm_tdx_vm_ioctl(vm, KVM_TDX_FINALIZE_VM, 0, NULL);
> > +}
> > --
> > 2.51.0.536.g15c5d4f767-goog
> >

