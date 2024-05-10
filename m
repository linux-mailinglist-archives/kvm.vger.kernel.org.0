Return-Path: <kvm+bounces-17181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF068C260C
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 15:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9FD61F21945
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C719212C498;
	Fri, 10 May 2024 13:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKay1Xwu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2AD12BF39
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 13:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715349055; cv=none; b=B3RSQ7dn2XEZlYiiCST5v2O/eVdALwYdW1guBsYYGa5hCp4XsuV9ItzHW5/4GC8+mw5NKcsvv2Vfe6jtrZcyG/1Ea2KotGbVFWdB2TWEj6EcKXwIXLKnjiYd1VG0t4GgF1bo3zRrlUqmbOG9dsrkbGEBx6KMFCcc8k+9d8Un0Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715349055; c=relaxed/simple;
	bh=I7z5nYT1NGtQi+9Q7VZZIxP3Ystgb6nUWLm9idhStWw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ukj2PmHnYjgUX4noGWjmKQh4P3f57aThlcBhV076oWKf+C/7raSJFAQEp9cAMdmL0H4BpsMOqc1tYhhQ/0Z97X/eK3AFmwcL2NzIDAE1L7SA0slEuPhv+lReQHxkK1ZmQJfAMT6gG6iwCZzxqxxB5k9sFpNc5til8wxl2Kw48Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XKay1Xwu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715349051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pzf9kZEryhnm+5290e4qBYeBBj+VU2djvO6AxGd9L7w=;
	b=XKay1XwuL4aRSP+yBi9N0GZ5w/lpCNHRxgLKjUndVAmBhDQaPy2H9VL7d6Va29UFFzzEqe
	fjrWkQw1ZucFeGPG1vJbUdcVty59KlRHxWzslhHx1MI9N7yBiMJWhjvc/tmv6cEZPs16FH
	iGfCkL7zE7jik9dnjq5P6kC9sFJD6rQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694--Rj0UKNSNCunHfr3Z2rBgQ-1; Fri, 10 May 2024 09:50:40 -0400
X-MC-Unique: -Rj0UKNSNCunHfr3Z2rBgQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-34dc7b83209so1064116f8f.2
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 06:50:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715349039; x=1715953839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pzf9kZEryhnm+5290e4qBYeBBj+VU2djvO6AxGd9L7w=;
        b=AKKyfVuS47vEMqCdUzKblqRNQLDx29KSnOJReMF1G23o4gqh176IrzfLfTBdo9i3HT
         llEC+2Ez4FFz/LqOLsP4l/AZgRVH2SGvtNWvWX3ND1UuvB2ZPmbjEY4wp1d6kIbIYUvU
         GqI9NwvEl5ZZCKwrLqyVy8f/NBGfRmflVuZg9ZgTwdMN059FgTYMAotXybIIKf85o77o
         uOdbI65U24UiehuscY5aXtK+DrpURMjfNs+DIUN3TmyfBElu2tHXF20qLcOSKY0wNf22
         aji4NGc2vu4PxZX46fMyO6YNxZSS4l7HIq8R9nyWA7xQSft6euyHn4heUFkdgTjDnxYL
         LUvw==
X-Forwarded-Encrypted: i=1; AJvYcCX47weBaYKGWaeWFWUcLgk1Lqc8ad0YHDamDFtkBoWhFZOEk6yww5UzmzQWcEg8f/nPITdmaS2uExQDaBPoD0hg0idJ
X-Gm-Message-State: AOJu0YyYd06WY+dd4lwkhZ4hIL9y3AzLLfICxtmM2E0a0BMgFwKgl0ti
	s/1WdpM3A8z12JMsM4uCYD/M7EYRuw6surxQRf96AonGth+oAdE4l1yrFwiq4pOXl4bjCpgUQQN
	5GRgMOaoSJOQkNMFHr1dvAODxk5CN/hvhCo5VevnTVuJRvWKAzVf4cFRZAUALsTy/ROyRDN5Fi8
	oUg6IWTJjZ4oexSHyDfTN1AZHy
X-Received: by 2002:a5d:5351:0:b0:343:e02f:1a46 with SMTP id ffacd0b85a97d-3504a62fb12mr2102111f8f.2.1715349038971;
        Fri, 10 May 2024 06:50:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHucRBfWSHvPvamu1WRWuBFTrQrQkQyBe+ROxdfO0QRjONS8tJPWThU8+2GOiv3nf4H2QrNLg23m2TZKw0gXJM=
X-Received: by 2002:a5d:5351:0:b0:343:e02f:1a46 with SMTP id
 ffacd0b85a97d-3504a62fb12mr2102054f8f.2.1715349038422; Fri, 10 May 2024
 06:50:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com> <Zj4lebCMsRvGn7ws@google.com>
In-Reply-To: <Zj4lebCMsRvGn7ws@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 10 May 2024 15:50:26 +0200
Message-ID: <CABgObfboqrSw8=+yZMDi_k9d6L3AoiU5o8d-sRb9Y5AXDTmp5w@mail.gmail.com>
Subject: Re: [PATCH v15 21/23] KVM: MMU: Disable fast path for private memslots
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 10, 2024 at 3:47=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> > +      * Since software-protected VMs don't have a notion of a shared v=
s.
> > +      * private that's separate from what KVM is tracking, the above
> > +      * KVM_EXIT_MEMORY_FAULT condition wouldn't occur, so avoid the
> > +      * special handling for that case for now.
>
> Very technically, it can occur if userspace _just_ modified the attribute=
s.  And
> as I've said multiple times, at least for now, I want to avoid special ca=
sing
> SW-protected VMs unless it is *absolutely* necessary, because their sole =
purpose
> is to allow testing flows that are impossible to excercise without SNP/TD=
X hardware.

Yep, it is not like they have to be optimized.

> > +      */
> > +     if (kvm_slot_can_be_private(fault->slot) &&
> > +         !(IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) &&
> > +           vcpu->kvm->arch.vm_type =3D=3D KVM_X86_SW_PROTECTED_VM))
>
> Heh, !(x && y) kills me, I misread this like 4 times.
>
> Anyways, I don't like the heuristic.  It doesn't tie the restriction back=
 to the
> cause in any reasonable way.  Can't this simply be?
>
>         if (fault->is_private !=3D kvm_mem_is_private(vcpu->kvm, fault->g=
fn)
>                 return false;

You beat me to it by seconds. And it can also be guarded by a check on
kvm->arch.has_private_mem to avoid the attributes lookup.

> Which is much, much more self-explanatory.

Both more self-explanatory and more correct.

Paolo


