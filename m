Return-Path: <kvm+bounces-8627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF4C853502
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 16:45:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EB791C2614C
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 15:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01AD85EE9C;
	Tue, 13 Feb 2024 15:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WPloCjGS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A5B5EE76
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 15:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707839127; cv=none; b=Vo8xNn3Ngtdc9KSXZJhoTo5a2LHInJfhg9q4IHSLAW0OXc44nozVz/CnplpvrCuMsxFUBM8dNFs5OCHmn5Ax1anHszj+b8/eZ2uSZv6ULHch2N6jtgm1kRVagOcj3CCKbvIwKdeN7puSAmMt+PrE+vGa52ksTCiOW8XuZXiaHGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707839127; c=relaxed/simple;
	bh=+/Eg3fKlMGekNo4yQ3rdUF3VeqRNJ0tYyXOMZSXk47w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VaXiDSJtVWUVutnFuB8gRqRy0iM5oFdrn+Dv9WAv6yb+Va6Rx41MkD3HQTuGZoPowA3DqHiK1SGXMlMw102A3UAuwWCXpYrd+6ESg+qk1iRNzFDZA/SDn8kJtsGrPpWsBUeljGYdcV6Jc7a7EMggwIQ/VCDdsKTV+ZvFy7lX0yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WPloCjGS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707839124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mC+O0WAY8x9UWake37mLtLpIEPCaj8+5EiUT3ECyHuY=;
	b=WPloCjGSYyFzswAw8caEJr7MEhdlSBzORNSlaBHXHyKUCi4n/NSfjxk/+SJW/DMdNay6AR
	nLSgBcZqhPia+xsYjnIS6wVgNWZxh+jZqGzNg3SVHINOQTrP7a5ezmI7iHi/lIaV7OWWev
	rRBO+WAu8BQYbCVSiiTMpL6ElRlsHB0=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-X38d__ewOUm1ZHE2wbZnRg-1; Tue, 13 Feb 2024 10:45:23 -0500
X-MC-Unique: X38d__ewOUm1ZHE2wbZnRg-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-7d8f2415612so654797241.1
        for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 07:45:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707839122; x=1708443922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mC+O0WAY8x9UWake37mLtLpIEPCaj8+5EiUT3ECyHuY=;
        b=EI2uYm8IZrzC/LcQnVscytQ5ZblRphtIcw2Xa/oh+vc/MR/FC2b0Hy9Jdx7YbnfqnI
         EpJEvF5WHEVRazM4slgg2WzEIMSy3HtfCQHeigST7pBhw876OZQo36h7B/84O6V7Tk1V
         5awnrr4enq6FA9KXsS/8Umw80C9a7Icx2M3Jv4a2REJanf2YsOvhUbrrrmV8tmE2/w4Y
         fuXF3TBZAeIl5orIZX78NGlMcTl+4ZZL/1a6t4Xs1/gil4n5aLpe9vRYyze7zRMmrDJ6
         WJ+CjbtWkJUNyiQSykZuQHRv0YkZFCYqfTVlui2hopRZDvlO8fMBoZ1VWPseG26/Zg3A
         R26A==
X-Forwarded-Encrypted: i=1; AJvYcCU2LbuizQcbuadiVTyiLoKfVzNNA8CQAywfwtSKrFl5tdFH2Dsik/aERaAzJ47ADC8VTUd8mqG+McQcclZt3Tz4UIyt
X-Gm-Message-State: AOJu0YywCTr81GTv1aAhTD4Mtyw/GRBYkqstYZnTykDjBl66+qukMBJQ
	oOIMPSIACtrLwxWLgfco7hnoz2/PQ4KAxL4Gt1md29mvX1gmwH6ATafs2rBLW4xMOMDeUGs84+/
	HySoLS9qOildhk6347B8mC6W2kMLn7jhFAAWYN04rX94unYYiKhc3Ri04Nt+dkd5yq326B8ltRS
	P9h7e0hUZEfLvf4IAHOHLuChRT
X-Received: by 2002:a05:6102:2404:b0:46d:5e5a:5e80 with SMTP id j4-20020a056102240400b0046d5e5a5e80mr7770271vsi.31.1707839121829;
        Tue, 13 Feb 2024 07:45:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5uZRjDeJV9I7SDi5aFF14RvjRJfCYm3XpvfMki8n9aEbHyODKiVLPo9TTtcP8SbrbzA5HrAm6y05wjIoyygo=
X-Received: by 2002:a05:6102:2404:b0:46d:5e5a:5e80 with SMTP id
 j4-20020a056102240400b0046d5e5a5e80mr7770086vsi.31.1707839120113; Tue, 13 Feb
 2024 07:45:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240131230902.1867092-1-pbonzini@redhat.com> <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
 <CABgObfa_7ZAq1Kb9G=ehkzHfc5if3wnFi-kj3MZLE3oYLrArdQ@mail.gmail.com> <CABgObfbetwO=4whrCE+cFfCPJa0nsK=h6sQAaoamJH=UqaJqTg@mail.gmail.com>
In-Reply-To: <CABgObfbetwO=4whrCE+cFfCPJa0nsK=h6sQAaoamJH=UqaJqTg@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 13 Feb 2024 16:45:06 +0100
Message-ID: <CABgObfbUcG5NyKhLOnihWKNVM0OZ7zb9R=ADzq7mjbyOCg3tUw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or TME
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zixi Chen <zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, x86@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 4, 2024 at 6:21=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
> On Fri, Feb 2, 2024 at 12:08=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.co=
m> wrote:
> > On Thu, Feb 1, 2024 at 7:29=E2=80=AFPM Dave Hansen <dave.hansen@intel.c=
om> wrote:
> > > I really wanted get_cpu_address_sizes() to be the one and only spot
> > > where c->x86_phys_bits is established.  That way, we don't get a bunc=
h
> > > of code all of the place tweaking it and fighting for who "wins".
> > > We're not there yet, but the approach in this patch moves it back in =
the
> > > wrong direction because it permits the random tweaking of c->x86_phys=
_bits.
> >
> > There is unfortunately an important hurdle [...] in that
> > currently the BSP and AP flows are completely different. For the BSP
> > the flow is ->c_early_init(), then get_cpu_address_sizes(), then again
> > ->c_early_init() called by ->c_init(), then ->c_init(). For APs it is
> > get_cpu_address_sizes(), then ->c_early_init() called by ->c_init(),
> > then the rest of ->c_init(). And let's not even look at
> > ->c_identify(). [...] get_cpu_address_sizes()
> > is called too early to see enc_phys_bits on APs. But it was also
> > something that fbf6449f84bf didn't take into account, because it left
> > behind the tentative initialization of x86_*_bits in identify_cpu(),
> > while removing it from early_identify_cpu().  And

Ping, either for applying the original patches or for guidance on how
to proceed.

Paolo


