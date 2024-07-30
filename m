Return-Path: <kvm+bounces-22702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 505FF942134
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 22:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C6621C23E84
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 20:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E83718C909;
	Tue, 30 Jul 2024 20:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YGQ6Sro+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CCE18CC0A
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 20:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722369653; cv=none; b=J5n4wJF++jwrM0hSz1bEjk6sla5h0Bj49r55TF/eXzZeuWU1HRIDWGqU5cZ+OX5RxvHKNDSxL3E2n9BjkewF5Ezx4hoCWDx/hAyQ0Ed1dsauuAUm/AYSwM2qnqI0+Til9kC8UCFsQ25YGPVJqf6NEGrVMesKgagbHrB/1x/Ol4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722369653; c=relaxed/simple;
	bh=Sm9YliIBseVNdVtXfF6wU54oboHpFF3iBhE8X9in9r4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qdNyCsWP5ly2tJkQ7tA96p1IeXRH7ZR3ld1VXsDF8erMphf+l6clzVh9fieHi2pb27CyOhktAI6MDjh1a1Zil5D7U18xNoNnvR7iLiPWoOJLN8eOytFo+OsmzGm/n2pczwmUGUBmqi2oeJNBMrg3AR+xqdK9xxZ7n933ZX9M7yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YGQ6Sro+; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a134fd9261so5432454a12.3
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 13:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722369651; x=1722974451; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T1b0dd+u4QtRKmjCQ1fWaclUboiBOp5PBFZF+RqiWy8=;
        b=YGQ6Sro+JlS75Jcs5Glq0mA6Fjof9EetpnArPZqMi3brBlwbX3/13pn/E7ftqvq1dE
         Z1Ow3kKecRFDO2zWvVDkeVPRjXo54Di2flPIM+Pp/u6iuNjpj2eaGRmYx5KJAt0CGoQN
         kj3ncsccSYT/L064wske3OgY3RE+/wfKzGb4DRHxzF5xadVELUA2oJRxKWA6e8bdv8wW
         JNlTI9fRGHS+OnxREc35TSZl7/5HgJM4Xm4IWTS45v2ucZFOg1LnyTOeXe8pk1RqMtjF
         d1yOWOUICOKbMeJx9b6xvj9w2SHek6TM6QIGlZFrQnQ6ymvR9+JRt4yhc1w2Yg+UafXL
         R1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722369651; x=1722974451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T1b0dd+u4QtRKmjCQ1fWaclUboiBOp5PBFZF+RqiWy8=;
        b=SXv4/pLTJ4EvMTl5zqnjP48yY3C/36BQ+Vjqhmc61VGoD1VXYNNPPihBwHBhPbciIv
         HOr7ITj7BGhKLl4j6tN/aj9xIzo5CU1UDPreSiA3AhXUMJpMm8a1I4lYoK+KsTAjdFek
         CMHZyn0tazdrGOzDHy0uCYqXBJ8GlmlAFeZaFluZiyk6Udm6WBD5wqTsJPKgwO+AM7U2
         Za862J9TNmGUWxnxsLS/bVK4UGs5+4n56snSbNQCwFP5TYWQr/tIJfbYl/Nlwa4SiqNj
         nrMgZ9MzBIxPtOletDPk3VC2A+Flz3cMH/UBRKX/27tgR8AV75CAyY5Ayr/l/9F7iVpB
         2N9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUXqQik1UvYxBYirQfj8Kux6Zj2z/2Tr65jyBhLC2iLXIRffqBAMQSOprDRq2BnYPqtP77Miy0zh4V7ALKkC+qp426g
X-Gm-Message-State: AOJu0Yy8MPg4wTwC4PgK1reEbZhKNxF6PrI6Z0YEDWlsfet8nkGgSGeW
	EwCYPeGguvF7vZd929VYN6b/OYAgy7KGwR/mShkWUR1IaU4pgp1y4whCVAIkrcyq/20k4KG4Gmf
	61A==
X-Google-Smtp-Source: AGHT+IFIpN0t9CwDntyaqKmkPJ5cyx3sfG1IwNUw2ka0n2i9gazwPDbMR7YOpYtas1d8Mj8EPxP4qtxT2wA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:5a3:b0:6bc:b210:c1dd with SMTP id
 41be03b00d2f7-7ac8fd2ec71mr34114a12.8.1722369651264; Tue, 30 Jul 2024
 13:00:51 -0700 (PDT)
Date: Tue, 30 Jul 2024 13:00:49 -0700
In-Reply-To: <2da6b57e-d5c2-4016-b89b-d51700eeb845@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-46-seanjc@google.com>
 <2da6b57e-d5c2-4016-b89b-d51700eeb845@redhat.com>
Message-ID: <ZqlGcaESdxw5vzl8@google.com>
Subject: Re: [PATCH v12 45/84] KVM: guest_memfd: Provide "struct page" as
 output from kvm_gmem_get_pfn()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, Paolo Bonzini wrote:
> On 7/27/24 01:51, Sean Christopherson wrote:
> > Provide the "struct page" associated with a guest_memfd pfn as an output
> > from __kvm_gmem_get_pfn() so that KVM guest page fault handlers can
>        ^^^^^^^^^^^^^^^^^^^^
> 
> Just "kvm_gmem_get_pfn()".
> 
> > directly put the page instead of having to rely on
> > kvm_pfn_to_refcounted_page().
> 
> This will conflict with my series, where I'm introducing
> folio_file_pfn() and using it here:
> > -	page = folio_file_page(folio, index);
> > +	*page = folio_file_page(folio, index);
> > -	*pfn = page_to_pfn(page);
> > +	*pfn = page_to_pfn(*page);
> >   	if (max_order)
> >   		*max_order = 0;
> 
> That said, I think it's better to turn kvm_gmem_get_pfn() into
> kvm_gmem_get_page() here, and pull the page_to_pfn() or page_to_phys()
> to the caller as applicable.  This highlights that the caller always
> gets a refcounted page with guest_memfd.

I have mixed feelings on this.

On one hand, it's silly/confusing to return a pfn+page pair and thus imply that
guest_memfd can return a pfn without a page.

On the other hand, if guest_memfd does ever serve pfns without a struct page,
it could be quite painful to unwind all of the arch arch code we'll accrue that
assumes guest_memfd only ever returns a refcounted page (as evidenced by this
series).

The probability of guest_memfd not having struct page for mapped pfns is likely
very low, but at the same time, providing a pfn+page pair doesn't cost us much.
And if it turns out that not having struct page is nonsensical, deferring the
kvm_gmem_get_pfn() => kvm_gmem_get_page() conversion could be annoying, but highly
unlikely to be painful since it should be 100% mechanical.  Whereas reverting back
to kvm_gmem_get_pfn() if we make the wrong decision now could mean doing surgery
on a pile of arch code.

