Return-Path: <kvm+bounces-45558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 736C2AABB46
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:37:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEDE13BFB5D
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A794A33E4;
	Tue,  6 May 2025 05:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EIYpJuK9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F3623A9BD
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 05:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746508647; cv=none; b=CWX7zge4rqQlawK1CaIPUEAG/GbBv24PVqTs0+c3gH+gl4F2NQSdOFvYq4n8xuKgnww/138V5DPOeFjJWgZ5MNq60VoGgZ3OsyrpzcEkhD4UK2/yBS8x9+w5HInrh0UT1lvZSfyc/+D81TEoijUq60T5qe+c64uhwZkw/sDx4Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746508647; c=relaxed/simple;
	bh=FQeYSRTyGaLyx8mJE3z/WnWqQ1oIIA9h3QkTkL5Bqlo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dCqSJ28iTviwGy7dtGvc1lgpYjMAa3zND/2e7i/PjPVG9qE51ix+R3GVUQ7iSzBMDoI9SNEQXesVpzS6pCS7PDC6UzVz5n9SjAOn+88hTGg969U07m/2f856+0571N8IXDP9RG2Fa7Gvfrw9xFdFX1FPveuAagGfcZUYiHSbV0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EIYpJuK9; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22e39fbad5fso65735ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 22:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746508645; x=1747113445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/oyNXL8JmitesFhXvr9WQW93SUMwRydjKM6cb06+Bg=;
        b=EIYpJuK9loB5PVZigkGXD1YlTlI0XqkhgaGdNRhdkfTly7uzLDu1OWQYbGaOfpz5qA
         IJ7N4whfflwJSMGqES5690LzebWk9pkuqn1yA1NWfIiC+QERirLhLRJj3Bu5u1eHiVJF
         oSshSwAMs7XvPdfvqYIfm/Mv63fVb4b9vqHhWEveJQm/835iSNsggU3N52TvBR0ChXW6
         sn70S2/CC3Q8Gfi7/fFHH06UwY9Oj+kB6tOU7E1lOi8hlIMhAe6vANGCgkydqWPAsQB8
         h/dbl2tRXFtrgDNEgV6X3XqRJ679U4IHCbOuECXA2C+/KCnIYb4vAzfrbElypzJhHFZq
         AQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746508645; x=1747113445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2/oyNXL8JmitesFhXvr9WQW93SUMwRydjKM6cb06+Bg=;
        b=PSfiN0ED3q9yH1KBujE4N7k3hpcH0NE1A/5GGJeLXt7flbO/wVMO+BWJSwry+Z5UlW
         /fE0SLwqJoOQYReQojX4uNyjbtbRuZEwFFVBEwLPC7COmzDwdnbLFmM8gs7BreRi0s0a
         S2S+SEKTbvq7S19O2ururo3Ce25HlCDD+5aMmfQZ5hkSJyQClYnNLI6876BDKoSbzSyQ
         yLmkhMsY+lG+YGEcb2Pr79+YRqi6meGAgpCUeDC0e2AFfSAdsFYeaY0k3WeyrthSs4Kp
         ixl5fqz/YJ4eZHWjYIuM5xISY/HIiWyCNnmfmhppgkMB4dnkVc7Axs3K9GdBHUeHU+32
         c2jw==
X-Forwarded-Encrypted: i=1; AJvYcCX/XcVWFXxfGgrObVEvtvgW6IfPIykF5ZoyN26+W/60FcIP/8wyBLYoLKs9xLDwX8xzgao=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxae1A93sLd2DLeWkLhFkXMyRGwEJGLbDRvW0cFAFFomaEyjKIe
	1WDun3X5g0VPQxzLN8AqsfVMkKgxf/27zoXGTXOHnMlHlmKSyjM3K6gXeqe/iMFii57N3vAlZkV
	/hRITRG6f1xnxeHzmjpyGKBga4/z+QHs04d5V
X-Gm-Gg: ASbGncvMBhXmcEjHEUhgQlfPYpH/duRH9UDhbvkMv9nq6w+wy9dy+y5W8AtNu5beOWP
	mKduYuVaM//CUHZ+hg2dycCkJKdn+eRbQggZpsp0412hi842AHlHIL5tILIuE8gEKo6BHOtxQK5
	Wd9156f0GVV9X5aezryV7bGixjbbOD/fWb+NeF0xfbeG3q5RbB1NIKAK8=
X-Google-Smtp-Source: AGHT+IGihzOzWy8x+6Ja+LalRDd0k3+jQXGYbU3MHt0hkecArEO8Kjrf7J4KdbKoNVLOX2f2VTCUMWQSCZqQ6vCwIH4=
X-Received: by 2002:a17:902:ce10:b0:216:2839:145 with SMTP id
 d9443c01a7336-22e3b071eb8mr1281395ad.1.1746508645256; Mon, 05 May 2025
 22:17:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
 <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com> <aBTxJvew1GvSczKY@google.com>
 <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com> <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
 <aBlCSGB86cp3B3zn@google.com>
In-Reply-To: <aBlCSGB86cp3B3zn@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 5 May 2025 22:17:12 -0700
X-Gm-Features: ATxdqUEzeS31T2q-e4VkgtgiiNIU1vS-masT4eZQygwiHzAZfHdNnbMPeJW7-MU
Message-ID: <CAGtprH8DW-hqxbFdyo+Mg7MddsOAnN+rpLZUOHT-msD+OwCv=Q@mail.gmail.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
To: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 3:57=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> > ...
> > And not worry about lpage_infor for the time being, until we actually d=
o
> > support larger pages.
>
> I don't want to completely punt on this, because if it gets messy, then I=
 want
> to know now and have a solution in hand, not find out N months from now.
>
> That said, I don't expect it to be difficult.  What we could punt on is
> performance of the lookups, which is the real reason KVM maintains the ra=
ther
> expensive disallow_lpage array.
>
> And that said, memslots can only bind to one guest_memfd instance, so I d=
on't
> immediately see any reason why the guest_memfd ioctl() couldn't process t=
he
> slots that are bound to it.  I.e. why not update KVM_LPAGE_MIXED_FLAG fro=
m the
> guest_memfd ioctl() instead of from KVM_SET_MEMORY_ATTRIBUTES?

I am missing the point here to update KVM_LPAGE_MIXED_FLAG for the
scenarios where in-place memory conversion will be supported with
guest_memfd. As guest_memfd support for hugepages comes with the
design that hugepages can't have mixed attributes. i.e. max_order
returned by get_pfn will always have the same attributes for the folio
range.

Is your suggestion around using guest_memfd ioctl() to also toggle
memory attributes for the scenarios where guest_memfd instance doesn't
have in-place memory conversion feature enabled?

