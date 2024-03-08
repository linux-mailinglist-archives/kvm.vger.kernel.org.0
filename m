Return-Path: <kvm+bounces-11382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E85876A09
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 18:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B756283C6D
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 17:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC29257882;
	Fri,  8 Mar 2024 17:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mFYgPgxN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B8D3BBF9
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 17:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709919371; cv=none; b=VyBiNZ3UYrHR3W0ycIm+8JsOnHTyehxycqzDrjpo3ejrLRNuqjZdIMV19KCBPliAEPU5Q+J7qjD0pAW2hJK8gh1tnMN1UIIaYDAc7ZMeCeCNvBAzNmSNXoFj1p/QhIqMWPppdnIRJ2Opnjt/OqVlq9BvKlXrzqu2ABYE5W62tZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709919371; c=relaxed/simple;
	bh=BLQqEflG3oKsA3aPOWUhkr0esXHDoToF4yiF8NeiiXk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZMAKW0pa4tR6L/NyGSU6yZbrNzGaxBBu01vWoQzRWzvAgwtaCn/7SODDNINGPPBHrSBYSFSseyV2zzCwVqfbXX+Z08NeHPSWZ4CFzQngAN3tCRAygLzUqhTm8O73LhcrRuog1EBbSCu9YVi9CuSA43noeLVRBoFr1VV6vQAuJ+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mFYgPgxN; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a45b6fcd5e8so303681466b.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 09:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709919368; x=1710524168; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BLQqEflG3oKsA3aPOWUhkr0esXHDoToF4yiF8NeiiXk=;
        b=mFYgPgxNpFecV5eyWYWvs2XLbjYZHNzpQi39mzzEBckiyFBRmQzRBchGpd61Xgcwzm
         hYNoqvawZ4bnvicJmeRoa2lREt4ts7p/BZqaTQmMLvo4ZDAZVrOklq/9ZOFPIpBVXGz1
         ZK1zpK96lZYwsltbksRktWSNsrHQ2NB0SrprK3bPvtOoh31ARVG7HQgBbvAW9cLHRyi4
         GuEMKyq/Jxdjg9aLfMwj/AUxv6uUobuqXZS0CQ2z5gpM1ui5vtGKgvw+BVtD5MeAnGFe
         vPwwUZ++VzmjqSqeVtQt6jewFJYdARnJ4WK0REAS7awP94gmu6wH5whzDWJePsHXpG8F
         mMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709919368; x=1710524168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BLQqEflG3oKsA3aPOWUhkr0esXHDoToF4yiF8NeiiXk=;
        b=q4OCfCmmy2Cu2Ip2mMjlAljwH+U0ZmZ5MhhpvnEeU5cTKyzsDbJziBxQ1rYVonUzfU
         HxLkHWVghlyt9FT1VxnfXim52pBBcyVwPhKsUKkzEk4KUO8MhMOIYXmi++KyHNrDbJwJ
         eUCbjdQ8iQhU9etENPMwfHSSvI22UxYJYd0FswEjQ3xTZjoBC7nXJ2yusy9Or4h3VcdE
         iTMlog4mLsavkjEVvMcvVzGo0fOcssZQcRufxfGQ6cPqlRjSfw1JgdNLgA4Yl2IVDAEW
         ZybLT6hOr01Nil2lXCjLGD8cV3yVyVq84VCwN8VqMUockCJSe0OZPELeg7NHNpOrbK4Z
         7vPw==
X-Forwarded-Encrypted: i=1; AJvYcCUCGdoHFn0LVunsQ2zAZueB2M52v8D6/VlWq2MZaBeSTyAmXB2LFx2lWNFLpwaCtdNpfIr0ajYY+2yiI/8y2NtW/0D5
X-Gm-Message-State: AOJu0Yx/6jk8fXHrGMrmviJjvICaKu9JWdoeJMtUZ3SZzahSO6te2/4r
	mK4zgwXgBjjdpmroyFGh4r4iIXi8D92qB8bofg/cFnitf8UJVVZkrvYn0zERSHQpXftYYi52YLc
	d9cfg07yLcN8j9G0bXy3En5SKhNtQEqecaMRf
X-Google-Smtp-Source: AGHT+IGceX9beSvLegicFsUM7bVnbHkalYe9JD/77bNVUNdVA+Xl4w4FIFSUu9uJ12/JV7uxpjfKrXnAPKcZF463m/U=
X-Received: by 2002:a17:907:d38b:b0:a45:e3ab:152f with SMTP id
 vh11-20020a170907d38b00b00a45e3ab152fmr3755078ejc.21.1709919368333; Fri, 08
 Mar 2024 09:36:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com> <CA+i-1C34VT5oFQL7en1n+MdRrO7AXaAMdNVvjFPxOaTDGXu9Dw@mail.gmail.com>
In-Reply-To: <CA+i-1C34VT5oFQL7en1n+MdRrO7AXaAMdNVvjFPxOaTDGXu9Dw@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 8 Mar 2024 09:35:39 -0800
Message-ID: <CALzav=fO2hpaErSRHGCJCKTrJKD7b9F5oEg7Ljhb0u1gB=VKwg@mail.gmail.com>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
To: Brendan Jackman <jackmanb@google.com>
Cc: "Gowans, James" <jgowans@amazon.com>, "seanjc@google.com" <seanjc@google.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Roy, Patrick" <roypat@amazon.co.uk>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "Manwaring, Derek" <derekmn@amazon.com>, 
	"rppt@kernel.org" <rppt@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Woodhouse, David" <dwmw@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"lstoakes@gmail.com" <lstoakes@gmail.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>, "Graf (AWS), Alexander" <graf@amazon.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 8, 2024 at 8:25=E2=80=AFAM Brendan Jackman <jackmanb@google.com=
> wrote:
>
> Hi James
>
> On Fri, 8 Mar 2024 at 16:50, Gowans, James <jgowans@amazon.com> wrote:
> > Our goal is to more completely address the class of issues whose leak
> > origin is categorized as "Mapped memory" [1].
>
> Did you forget a link below? I'm interested in hearing about that
> categorisation.
>
> > ... what=E2=80=99s the best way to solve getting guest RAM out of
> > the direct map?
>
> It's perhaps a bigger hammer than you are looking for, but the
> solution we're working on at Google is "Address Space Isolation" (ASI)
> - the latest posting about that is [2].
>
> The sense in which it's a bigger hammer is that it doesn't only
> support removing guest memory from the direct map, but rather
> arbitrary data from arbitrary kernel mappings.

I'm not sure if ASI provides a solution to the problem James is trying
to solve. ASI creates a separate "restricted" address spaces where, yes,
guest memory can be not mapped. But any access to guest memory is
 still allowed. An access will trigger a page fault, the kernel will
switch to the "full" kernel address space (flushing hardware buffers
along the way to prevent speculation), and then proceed. i.e. ASI
doesn't not prevent accessing guest memory through the
direct map, it just prevents speculation of guest memory through the
direct map.

I think what James is looking for (and what we are also interested
in), is _eliminating_ the ability to access guest memory from the
direct map entirely. And in general, eliminate the ability to access
guest memory in as many ways as possible.

For that goal, I have been thinking about guest_memfd as a
solution. Yes guest_memfd today is backed by pages of memory that are
mapped in the direct map. But what we can do is add the ability to
back guest_memfd by pages of memory that aren't in the direct map. I
haven't thought it fully through yet but something like... Hide the
majority of RAM from Linux (I believe there are kernel parameters to
do this) and hand it off to guest_memfd to allocate from as a source
of guest memory. Then the only way to access guest memory is to mmap()
a guest_memfd (e.g. for PV userspace devices).

