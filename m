Return-Path: <kvm+bounces-41234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED92BA6550F
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:07:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40383165757
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 15:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C769A246327;
	Mon, 17 Mar 2025 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hlEmjMJu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6355F246348
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 15:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742223939; cv=none; b=rnwNjdxgTtvWvLECS4vYqxaiLnyTubLXbKlZKnACFc9x0rUaW18n3oHPd8wxDxjgEn5t1B1khtYyIwM9rWgIUDRA8nRpfJtjAbGbTMGLpuru6s6x45v1KKwNiY/KDcRpUKDeSbujL4ghmGF6+UennjG8QDdr2mSbdrSyDvYKxZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742223939; c=relaxed/simple;
	bh=pPwlz72pZYP2/MO2y+YPVVILWG4xhrWy2LDGwYGBQGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lvp/IJ76iSVAFEB94VIYxJvzTSYi6u2FTSQp+4PcXdN+eXT1mWlB9iftgf7Ght/8e5y7qvTTXl2gVnGX6ERpVZQq/AHc/7hsj/oNPv2dEgAx78UC0uOYt9sYQ1wrBXSJMNUPGlKq+gWw2basIfYoj5+TWhjWYWGa59DRjF2k21c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hlEmjMJu; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4769e30af66so43821cf.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 08:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742223936; x=1742828736; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6acMYyVpnTlWp6vf280bC/VNTF7hHxsvj81f2AtrN4=;
        b=hlEmjMJuvVbWBvEjwpPb6OsrBeuJPA6HzzvsMk/mUoTeNGJj8yEK0PFW4Co0APaEzk
         O46hdjMYHznfMY4Aipr1rhtpu7HMsseg22ryEafL/rr8+Cux1Vlfzd/Ht/cuksP/DLjL
         0JNe55J2yLlJ8U9QbRasexcsDyXL9KFM+vWx3aWuvzcQvI/yOIPu8moDvxUZH+9fokGW
         TsZpegHQc+L7vtrplhwfrHC6Y2mqmHEuXZpqAQex/t8nayidK70t7OKCVgbCFHOTnu29
         9nOgkvPwuf0FHaBIUFGBQr98OKHFnBS74XBUZB215ORjlUmO1piU9ZikW9sxIzezqavr
         i/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742223936; x=1742828736;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q6acMYyVpnTlWp6vf280bC/VNTF7hHxsvj81f2AtrN4=;
        b=IfcpAYavTs5govmikl7WpvqHuDFtJFV4uD3z8DGtIn3NTZ5tydUBxXKsxIzhK4OLLZ
         HOQdQrYlFoVPFIJRix5Dqzx1C+NmRMxi9tU8cXlwb+T6yNeT6Pl2nSJqdi8E+vaTOr+w
         xWmVdlsoDbtUVFnKI7k+VXuNRhLFVLGrArnxpMKq+xBgswa3OG+4N0/cKLogcfXaOZBn
         TnuW3ZTTBqpkhYDsd1yVOHYiJd+VcfyolQ9hfYAsJTU89PS4zj+hryvLZQP11uYezReE
         HDOS+bibHS1hwjobwdnsrdpYOYQ3nUOB82ZNvY0kWfDLjb/Hecr5Z9ypBW0Qx9Z9/FKO
         JhlA==
X-Forwarded-Encrypted: i=1; AJvYcCX/t0HdXKuEZeTdbnpgQwlPj6p19dHavjkxWNGBX5bDzZaDjEn2sww74boyhcbez3JeHxc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCcWssau5p7nfixLuUoC096cyCkUBck9VhHhmBnHkZT9ps07sI
	hDOgEZfuzm4RZpC/oDeOs92UAhA9OfavxurYx9aGJ7ZvqBFCCWr3zfrqZoSJFpdgOLNgxbtP7qc
	+oDugSLB4VciB/Tm4aJLjjOVrMhOUxvStdQq6
X-Gm-Gg: ASbGncsYEoAK63Ios29BT2A+bVte+oY5wLWWE101/SqXXyciYRZCDYyu1v8G92gHCnV
	iGO5qLsDp3CqWZv4+jCWS8+K67aKkZISoJYWv8djV9XYqtMCoi6pmEkbdJjsmmft66H1Cyz6E6A
	F/ZHigl4z0Al9iGDCG1QS4z3Gg
X-Google-Smtp-Source: AGHT+IH+SnQ4554b74aP98WRux3+caKdpTmocH4nK8o2u2lfK/Pn6Hyq/zWKssKls3zXLlkEqDdUuIxYh1b4SlHlcSs=
X-Received: by 2002:a05:622a:6182:b0:476:fc5c:fd27 with SMTP id
 d75a77b69052e-476fc5cfeeamr25651cf.22.1742223935968; Mon, 17 Mar 2025
 08:05:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <diqzy0x9rqf4.fsf@ackerleytng-ctop.c.googlers.com>
 <fe2955d4-c0a2-411a-9e50-a25cc15c75dd@suse.cz> <Z9gz_IwHScMkFQz4@google.com>
In-Reply-To: <Z9gz_IwHScMkFQz4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Mar 2025 15:04:59 +0000
X-Gm-Features: AQ5f1JrRC1We58imXbf1zfAv2Rf3a2pvMKnkCv_X6pPugKz4Jk08Z4RTqdk2G-k
Message-ID: <CA+EHjTzWBnFrG1iuoHnVeszomApri1B25YcNJ2Dk6zU3Py6zFg@mail.gmail.com>
Subject: Re: [PATCH v6 03/10] KVM: guest_memfd: Handle kvm_gmem_handle_folio_put()
 for KVM as a module
To: Sean Christopherson <seanjc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi Sean and Vlastimil,

On Mon, 17 Mar 2025 at 14:39, Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Mar 17, 2025, Vlastimil Babka wrote:
> > On 3/13/25 14:49, Ackerley Tng wrote:
> > >> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > >> +static void gmem_folio_put(struct folio *folio)
> > >> +{
> > >> +#if IS_MODULE(CONFIG_KVM)
> > >> +  void (*fn)(struct folio *folio);
> > >> +
> > >> +  fn = symbol_get(kvm_gmem_handle_folio_put);
> > >> +  if (WARN_ON_ONCE(!fn))
> > >> +          return;
> > >> +
> > >> +  fn(folio);
> > >> +  symbol_put(kvm_gmem_handle_folio_put);
> > >> +#else
> > >> +  kvm_gmem_handle_folio_put(folio);
> > >> +#endif
> > >> +}
> > >> +#endif
> >
> > Yeah, this is not great. The vfio code isn't setting a good example to follow :(
>
> +1000
>
> I haven't been following guest_memfd development, so I've no idea what the context
> of this patch is, but...
>
> NAK to any approach that requires symbol_get().  Not only is it beyond gross,
> it's also broken on x86 as it fails to pin the vendor module, i.e. kvm-amd.ko or
> kvm-intel.ko.
>
> > > Sorry about the premature sending earlier!
> > >
> > > I was thinking about having a static function pointer in mm/swap.c that
> > > will be filled in when KVM is loaded and cleared when KVM is unloaded.
> > >
> > > One benefit I see is that it'll avoid the lookup that symbol_get() does
> > > on every folio_put(), but some other pinning on KVM would have to be
> > > done to prevent KVM from being unloaded in the middle of
> > > kvm_gmem_handle_folio_put() call.
> >
> > Isn't there some "natural" dependency between things such that at the point
> > the KVM module is able to unload itself, no guest_memfd areas should be
> > existing anymore at that point, and thus also not any pages that would use
> > this callback should exist?
>
> Yes.  File-backed VMAs hold a reference to the file (e.g. see get_file() usage
> in vma.c), and keeping the guest_memfd file alive in turn prevents kvm.ko from
> being unloaded.
>
> The "magic" is this bit of code in kvm_gmem_init():
>
>         kvm_gmem_fops.owner = module;
>
> The fops->owner pointer is then processed by the try_get_module() call in
> __anon_inode_getfile() to obtain a reference to the module which owns the fops.
> The module reference won't be put until the file is fully closed/released; see
> __fput() => fops_put().
>
> On x86, that pins not only kvm.ko, but also the vendor module, because the
> @module passed to kvm_gmem_init() points at the vendor module, not at kvm.ko.
>
> If that's not working, y'all broke something :-)

Thank you for your feedback and for clarifying things. You're right,
with a reference to the module held, no one should be able to unload
it as long as there are in-flight references, no stragglers.

Nothing is broken. Will fix this on the respin.

Cheers,
/fuad

