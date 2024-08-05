Return-Path: <kvm+bounces-23264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 260F394854B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:09:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 571E01C21EC2
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 22:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613AE16EB7C;
	Mon,  5 Aug 2024 22:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n2S1Pfro"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B922216C69C
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 22:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722895766; cv=none; b=fO4eh5qQ75/DjqoxFSCICnBq3TyI8JpP8CNX3LWea1s6K2W9ScVn/9UsACcIYQv8zyyqmwHUOfDkY94ReFMhkU4m1R5gA0fVK5er/frcmue5YkGVUr0l6ZZ7S+ncwGKj4U0dP4178TGkzyZBRMQA25wqeSiOOq9IiezwcBHP19I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722895766; c=relaxed/simple;
	bh=dmDvoV7DR66fW1rp/kKa2yAHHnKdcTd2T9VoWrRsnCs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=povm9c9ikSFINb+N4HVj39onMtyg4cXkleLUL6jo7rDP1TRqe+TPIGh3CTxA0U+iZz+8rIxG/UbtOZh1mpG60MneGlqcIsB6navUH0+gTY6jEn2mxu1L4Xn0EhUgBvf+Gjv+pKQwRTerBlMoPQ+/2vtGe7zBFg3vEOpDZ3dxCGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n2S1Pfro; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7106fcb5543so3132813b3a.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 15:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722895763; x=1723500563; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C2PiU8MTrEuvmn4oJRZEcNoPreaY/lLc5L+V0JuLroE=;
        b=n2S1Pfroj5GXc+AKmy97SqSqzhAatmtf6hSTbALfmWnl9FxJKmiV1UCBwSGSfwf8oN
         Zi9T6k66nDLL4H6wo9mFdf57vAhKbwYdnNHWTuMWYQz21ys2LETaeQ0wnqzAPVU7HXGk
         oGCOEcmJjmjnLRDJKSQF6RuoaOt5VvLien3b4rVqpBmK0hnKXY9XBzeN/7q8f6RYAf9L
         JKIzyUcKEZ5OJMcnhpRplUpEaJNMON8BUmhP126Sqr2k9Asmac+7h0ZA+vLQSDy8U9R2
         meRUTX0uq/MK/7IxffkTHph07HsMKzoEgpQ1FpV3OB8yL2kT5AzL67wlxHwLdPXoG8Qy
         cujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722895763; x=1723500563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C2PiU8MTrEuvmn4oJRZEcNoPreaY/lLc5L+V0JuLroE=;
        b=Y8AoEBUpvsJ73BVLrAHHm0MkdAdomvuwJpE8iIGUZ23PHaRNQk/tEQvhXAFCygFnmX
         eiNp1w7SvDP77WDP+Vgrvo6QXzHzrFtSyRUhduy9iTU3srCG800xMP0Mmoiu7/D0d+o7
         Akzx895+7y+Z/tmUMVZLJPNCKrsUc1eL+RnTSceW6ASG3nV/+0LM6yaHNCDNzMZuuGZY
         yif9gvYLmwy+CbydZFX5g39UF2NWhiUuqc1VPR0ik2npz0o+GBForXKLgt5upvQx/hiS
         FclYP9+HuUlHCyOnRRJlRcjf8id4iMn+CpKS+jYLo2jEu1oqk6LJfeyAPjH7dRzlcz9p
         NfCw==
X-Forwarded-Encrypted: i=1; AJvYcCUtgxiEQn6rSJOVNJbvh4AO+N6/O4zZ6gbTkDn8EzjxdlH+6BV883NuFvchf5XjbN/dvr+iTwGTXkFGTLmo3wtNUpdZ
X-Gm-Message-State: AOJu0Yw5IvyxtvzrKaSnZXgt6QfvcDS25J5H2eZwsAM3a0sKDyF/ZPYJ
	tWZ4/FBXzHzcFOFiYWcV8vJKQDrUxLQxq/9RdBZ8AQeyk6PdU6tpdkMF0nAjgW4VHzGEj+Hghsn
	dVg==
X-Google-Smtp-Source: AGHT+IFHGqnQ2aZELEsNF/YUFUu/OdaSqANvJ2o5+KNT08fnEczrxRkzi5g08NacDnyiiIzp3YSr6oxKzK4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f0e:b0:710:4d08:e41f with SMTP id
 d2e1a72fcca58-7106d08296emr87588b3a.4.1722895762937; Mon, 05 Aug 2024
 15:09:22 -0700 (PDT)
Date: Mon, 5 Aug 2024 15:09:21 -0700
In-Reply-To: <yq5a5xsftna9.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-3-seanjc@google.com>
 <yq5aikwku25o.fsf@kernel.org> <ZqvNekQAjs-SN-se@google.com> <yq5a5xsftna9.fsf@kernel.org>
Message-ID: <ZrFNkSU4-0Hli7JC@google.com>
Subject: Re: [PATCH v12 02/84] KVM: arm64: Disallow copying MTE to guest
 memory while KVM is dirty logging
From: Sean Christopherson <seanjc@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 05, 2024, Aneesh Kumar K.V wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, Aug 01, 2024, Aneesh Kumar K.V wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> 
> >> > Disallow copying MTE tags to guest memory while KVM is dirty logging, as
> >> > writing guest memory without marking the gfn as dirty in the memslot could
> >> > result in userspace failing to migrate the updated page.  Ideally (maybe?),
> >> > KVM would simply mark the gfn as dirty, but there is no vCPU to work with,
> >> > and presumably the only use case for copy MTE tags _to_ the guest is when
> >> > restoring state on the target.
> >> >
> >> > Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
> >> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> >> > ---
> >> >  arch/arm64/kvm/guest.c | 5 +++++
> >> >  1 file changed, 5 insertions(+)
> >> >
> >> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> >> > index e1f0ff08836a..962f985977c2 100644
> >> > --- a/arch/arm64/kvm/guest.c
> >> > +++ b/arch/arm64/kvm/guest.c
> >> > @@ -1045,6 +1045,11 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >> >  
> >> >  	mutex_lock(&kvm->slots_lock);
> >> >  
> >> > +	if (write && atomic_read(&kvm->nr_memslots_dirty_logging)) {
> >> > +		ret = -EBUSY;
> >> > +		goto out;
> >> > +	}
> >> > +
> >> >
> >> 
> >> is this equivalent to kvm_follow_pfn() with kfp->pin = 1 ?
> >
> > No, gfn_to_pfn_prot() == FOLL_GET, kfp->pin == FOLL_PIN.  But that's not really
> > relevant.
> 
> What I meant was, should we consider mte_copy_tags_from_user() as one
> that update the page contents (even though it is updating tags) and
> use kvm_follow_pfn() with kfp->pin = 1 instead?

Yes, that's my understanding as well.  However, this series is already ludicruosly
long, and I don't have the ability to test the affected code, so rather than blindly
churn more arch code, I opted to add a FIXME in patch 76 instead.

https://lore.kernel.org/all/20240726235234.228822-76-seanjc@google.com

