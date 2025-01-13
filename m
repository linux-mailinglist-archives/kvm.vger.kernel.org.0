Return-Path: <kvm+bounces-35313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD23A0C0B3
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 19:50:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0853C7A31C7
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 18:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E5C1CF7A1;
	Mon, 13 Jan 2025 18:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ofUH03Wg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F53F1C54BE
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 18:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736794091; cv=none; b=Y8gjDXuRrvC523fOsfApdQ79h/qeLA7JjZXHBp3KAH0ZiEWZrurAXpDJuvN6/88kXZQcOiVcBeH0bk3/I8qLVYVWxbC7MMJejyKHfUHQvecn32+4F9/ISv6e7v7vFSWocZHKc+Tz9kp5sq7v7P4tvPQXjebpSzBIh3EvqwS7r2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736794091; c=relaxed/simple;
	bh=TEHiOgjJVcMHzBYHyMXIJf3WWjW+4EqXOGyXjVacf8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j9Nn+V1NyUbssCxJtBvRdVQe5hl5rGy2c0n1Up4UcibfFgDbOaOczIFZ88OA1gXjFxIL4mlnP1P0NdljuBN3xWjTFzsiuIrboNH6KVpv/nSvUK5MpHNx3Ul/a7m1pBUfer/fmAUrMbBA0YVFCaOdSTNTLWJOe21rhF7UE6BnwlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ofUH03Wg; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-85b83479f45so984978241.0
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 10:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736794088; x=1737398888; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mO2m9NzhKb47cVTYFOAnGPUIXArhMJ3FJJluqAe9H+w=;
        b=ofUH03WgXpWEm6yibZMIX24XH8nTEMUQZDgUoY1oKS1tXBhO2IBTKoHtJ0Vl5aFvRX
         s6xSEQSzFPY9SKYo7E2G9mE+4J/cC6KMOSSLHarOySpJxW56hB6pAdJgN3dP4u6PQEss
         yQzGFdV0b8ZnoRU7Hp3qSf60DfFBptkkzOB2FVPYr0q6oZPPALOTgWXleVUWqagsjjn3
         mlf8QqVvoy9emv/L36bmc8c5OYS/z/fsMm7ST/PF7rfGkQg8c6TfY6xdwa604bcpiWSF
         NiQmR+NzrjhnMR3fvXBNi2mVOYcumuKjzb6d2935R9BnvsyF2o+3qCqtMKnV+Niy97bg
         uBJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736794088; x=1737398888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mO2m9NzhKb47cVTYFOAnGPUIXArhMJ3FJJluqAe9H+w=;
        b=i+kwpqpp5Kv3ev15EqfmTTcRSK0BHuGvRWCLY1vy0AV8k9ZlQx0hkEtvFuN2OvzmFF
         8CAvCB9OOLAR8fEqTdf4vA8zKbb35sA1eH1x5BkGHlWYlSwoZyRvnWc9/DX/y18HJVrD
         HY6vckDD8TLfE0Sy6HzboPpCelKWtCqSPoCH0rPDdCvzF6+YUm9WHO9kmlFgBLSTkZMj
         jUJS0Z/tIu9mUW46jAjqPoImxrPB3hM931UsNhVJ7nrzj1vsmlHRWmfPhvNO8uNtoBTB
         H8HM+cg2PN/DwxgJ91PyXY2KXyJamINjZo/vgNWTkO1gAPPr5Mg3uhOis6nKJwG4Dmq3
         j6oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPVPb9bjUC308HDJ7VL/CcG8FRDx9zsfwzWPBQFrVvu7TWdUbA1pLnRYJ1aKpUPDLb6aE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvIvoHDdCndEm6MyvUyfSF4rnNQJb2icWyeOCONRBRJoP7UZo3
	GqFV2Z/LWGKKgDHSLYLdl2l5sNEjjPTB4Uc91yYe2rjAEHJcgVeKevcKBrKFAgX8faT8skTB0Iq
	nLjuniLUk5kChfIgbJeiwNFDPMgSOZ3LEwmYd
X-Gm-Gg: ASbGncuDcpR9731IwYhmG+u2EvlkT/0xUdqJj2LspLcu1fHY8nDu14D/bKiyl/VVHnR
	ENd5qXoxHLEC98RL9EbsaTrvaXGwvKphukTI97sItArmDvXZ2EhpkkyAUUGQAhzjeFDcY
X-Google-Smtp-Source: AGHT+IG045LcVA4MqPGqJnFQyvWAkoJwzH7HcHof6BdlnbFOCvGlR2sLlMgjo3s+Wzdmq6HbzaftpOdaVN0Cb9CR3dQ=
X-Received: by 2002:a05:6102:370f:b0:4b2:5d10:29db with SMTP id
 ada2fe7eead31-4b3d0f91911mr18491643137.7.1736794088055; Mon, 13 Jan 2025
 10:48:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109225533.1841097-1-kevinloughlin@google.com>
 <20250109225533.1841097-3-kevinloughlin@google.com> <szkkdk35keb6ibdy2d2p2q6qiykeo2aoj2iqpzx3h6k2wzs2ob@iuidkwpeoxua>
In-Reply-To: <szkkdk35keb6ibdy2d2p2q6qiykeo2aoj2iqpzx3h6k2wzs2ob@iuidkwpeoxua>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Mon, 13 Jan 2025 10:47:57 -0800
X-Gm-Features: AbW1kvaBzO07btG5-vlfZH7tmHze-KR-sxmx_HPPES6yaPAyoet_uv7uG8Jl_zQ
Message-ID: <CAGdbjm+i52GNLRXVduzqe2h-bmNeJ_ES97p7LhJPJw+8FMuc-A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com, 
	ubizjak@gmail.com, dave.jiang@intel.com, jgross@suse.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 12:23=E2=80=AFAM Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> On Thu, Jan 09, 2025 at 10:55:33PM +0000, Kevin Loughlin wrote:
> > @@ -710,6 +711,14 @@ static void sev_clflush_pages(struct page *pages[]=
, unsigned long npages)
> >       }
> >  }
> >
> > +static void sev_wb_on_all_cpus(void)
> > +{
> > +     if (boot_cpu_has(X86_FEATURE_WBNOINVD))
> > +             wbnoinvd_on_all_cpus();
> > +     else
> > +             wbinvd_on_all_cpus();
>
> I think the X86_FEATURE_WBNOINVD check should be inside wbnoinvd().
> wbnoinvd() should fallback to WBINVD if the instruction is not supported
> rather than trigger #UD.

I debated this as well and am open to doing it that way. One argument
against silently falling back to WBINVD within wbnoinvd() (in general,
not referring to this specific case) is that frequent WBINVD can cause
soft lockups, whereas WBNOINVD is much less likely to do so. As such,
there are potentially use cases where falling back to WBINVD would be
undesirable (and would potentially be non-obvious behavior to the
programmer calling wbnoinvd()), hence why I left the decision outside
wbnoinvd().

That said, open to either way, especially since that "potential" use
case doesn't apply here; just lemme know if you still have a strong
preference for doing the check within wbnoinvd().

