Return-Path: <kvm+bounces-36581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E222AA1BE5B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 23:20:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B93D3188FDB7
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 22:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF79D1E7C0F;
	Fri, 24 Jan 2025 22:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N/0HMVmD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7F4224CC
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 22:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737757211; cv=none; b=OSA8vxoPVLE5SfFWx2w9QBqe3dQoqBSGYNYzDxsFwm9/NM6KOd8aJ4r4NnOjcOlLEbI/Gcyq3ZPzIroEnl4aAmJdLrH3FxQte9f+LedEiUjC0dp1b6tMFEQqZOgN/B7b5pfOV3wmUCYVbN1LC8lLIO7EtTm+k6i9cnHsjmIWq00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737757211; c=relaxed/simple;
	bh=bH6GGNVJ/vtn1muKoVKBj2Ejb4oLIi+hq2dWqh8lhkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fgy0J+WVcux4s15y/VhZQHto4eADzlJ9Dl4rSbH+1Rioj6kkz13nsoLf7y5bD0qXriI4DglFE91hVNFSffG0+kAf9oVcYtJbk0cFNdFeJmvTfNGWg+gZd2hr+h+e7S9k51UsWr5feaFDDSd90NvXVLRJ1l7WTLxlfsS3Hq/JWgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N/0HMVmD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737757208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kupsqb54AUnPoCY/Rj0IhcvkjRH5z47p1YqK/cn5ubw=;
	b=N/0HMVmD1uweB6h70agsB2/h/ZlMgyrlRz6M5ct+zXCBt6A4Pz3hG+NlD2tZzI7Pxg9xCm
	qxLQJvYS1sNXNqcWS3TNF6WBb3fmA97SmxAs9MrpzvQnBuisrRxZnsTUuDXXL5tbGTArTm
	W8Clo3FSXXXgr0xW98lpyQIrNQ2vsq4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-KxikeNY6N2e0uGzArm8Xhw-1; Fri, 24 Jan 2025 17:20:06 -0500
X-MC-Unique: KxikeNY6N2e0uGzArm8Xhw-1
X-Mimecast-MFC-AGG-ID: KxikeNY6N2e0uGzArm8Xhw
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-436723bf7ffso18717245e9.3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 14:20:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737757205; x=1738362005;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kupsqb54AUnPoCY/Rj0IhcvkjRH5z47p1YqK/cn5ubw=;
        b=oiRPTqUWceKm852/l59OWyCSegMTCRJ05XYieRCyxunYNAi/DXtotNGoz84wFhqo4q
         7jmExVeOR1jYQrXeUwlXR2vh0EkeeTWXGXKdqtMEYON0/NnJQRDuTH0d+3rFftwibJNu
         bYzm6tvohQpEoi5dOLBuYEeYH4UxnPYhL2PhHUuH19yOaNu96JpEKgMJzk3HOTqM2jgA
         NqxPll1onLCXPrZ7aJf7KsQqEt5lVOULMARFYM4O10lDZelseOs7h4Gjjhu6uVSJDl9e
         uARnVRbIH1U+iUtx+6Gq6si7ijVHXhWRyY/vqBq/pzX1oYCUBJQvzrqS3Ati4fSCuMcO
         4utA==
X-Forwarded-Encrypted: i=1; AJvYcCWqbgvqKTpgin5Gh4r3vURqn9W7U9z6ijgY/YNWIEbEjCQISRwCppXOyY63eIdHASzMoio=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3e9MdPxWowqOTDjL6zxJzG1FqNSrNRrMAfoj0i5w9oU7IpVyF
	OCaVNmRVraeGe5/mgr7WMg0D6MuP8QaXgGcDcIWx8lpuPWVfa4mgsTsl4PAupSO4CwiuPTFqhQs
	qdWUS+kSEGMgtif9VFyusm5Z6kPBvBJi77LjdDiAJeIFQtWncZakBTFrqhnocbipBeZlK78f8eR
	fVJYj33IsWdnT80/BIb/1cThBP
X-Gm-Gg: ASbGnct4YqbLzF2bFFlKUtBS6QKwE34a23L6fAd/ksC0DejI7dUy9uKWU+oYT9TgNPP
	RvltKO5nhuoymM8pYTlHinAFw+POCdlnJH3Jdbb3exY27BFVRR1liMt5xx1putQ==
X-Received: by 2002:a05:6000:1886:b0:38c:2745:2df3 with SMTP id ffacd0b85a97d-38c27452ffemr6834108f8f.37.1737757205129;
        Fri, 24 Jan 2025 14:20:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHt5+GwGvXExOnVjwxYRsaCasnT8Rg07wdS6GSNH7QSevVJB7iNnEqUMh9GvbCGDaQKUgk41K31AKLfI2n5TmE=
X-Received: by 2002:a05:6000:1886:b0:38c:2745:2df3 with SMTP id
 ffacd0b85a97d-38c27452ffemr6834097f8f.37.1737757204760; Fri, 24 Jan 2025
 14:20:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124191109.205955-1-pbonzini@redhat.com> <20250124191109.205955-2-pbonzini@redhat.com>
 <Z5Pz7Ga5UGt88zDc@google.com>
In-Reply-To: <Z5Pz7Ga5UGt88zDc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 24 Jan 2025 23:19:52 +0100
X-Gm-Features: AWEUYZkrifWDsbsW2Puf18SDVsk1swGn_J_wr3ZKsthSti8LwfafcVWVg_bC7rg
Message-ID: <CABgObfa4TKcj-d3Spw+TAE7ZfO8wFGJebkW3jMyFY2TrKxMuSw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: fix usage of kvm_lock in set_nx_huge_pages()
To: Sean Christopherson <seanjc@google.com>
Cc: "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Il ven 24 gen 2025, 21:11 Sean Christopherson <seanjc@google.com> ha scritto:
> Heh, except it's all kinds of broken.

Yes, I didn't even try.

> IMO, biting the bullet and converting to
> an SRCU-protected list is going to be far less work in the long run.

I did try a long SRCU critical section and it was unreviewable. It
ends up a lot less manageable than just making the lock a leaf,
especially as the lock hierarchy spans multiple subsystems (static
key, KVM, cpufreq---thanks CPU hotplug lock...). I also didn't like
adding a synchronization primitive that's... kinda single-use, but
that would not be a blocker of course.

So the second attempt was regular RCU, which looked a lot like this
patch. I started writing all the dances to find a struct kvm that
passes kvm_get_kvm_safe() before you do rcu_read_unlock() and drop the
previous one (because you cannot do kvm_put_kvm() within the RCU read
side) and set aside the idea, incorrectly thinking that they were not
needed with kvm_lock. Plus I didn't like having to keep alive a bunch
of data for a whole grace period if call_rcu() is used.

So for the third attempt I could have chosen between dropping the SRCU
or just using kvm_lock. I didn't even think of SRCU to be honest,
because everything so far looked so bad, but it does seem a little
better than RCU. At least, if kvm_destroy_vm() uses call_srcu(), you
can call kvm_put_kvm() within srcu_read_lock()...srcu_read_unlock().
It would look something like

  list_for_each_entry_srcu(kvm, &vm_list, vm_list, 1) {
    if (!kvm_get_kvm_safe(kvm))
      continue;

    /* kvm is protected by the reference count now. */
    srcu_read_unlock(&kvm_srcu);
    ...
    srcu_read_lock(&kvm_srcu);
    /* kvm stays alive, and next can be read, until the next
srcu_read_unlock() */
    kvm_put_kvm(kvm);
  }
  srcu_read_unlock(&kvm_srcu);

but again I am not sure how speedy call_srcu() is in reclaiming the
data, even in the common case where set_nx_huge_pages() or any other
RCU reader (none of them is frequent) isn't running. If you don't use
call_srcu() it becomes just as bad as RCU or kvm_lock.

So... let's talk about kvm_lock.

> > @@ -7143,16 +7141,19 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
> > +                     kvm_get_kvm(kvm);
>
> This needs to be:
>
>                 if (!kvm_get_kvm_safe(kvm))
>                         continue;

If we go for kvm_lock, kvm_get_kvm() *can* be made safe within the
critical section; if kvm_put_kvm() uses refcount_dec_and_mutex_lock(),
then the 1->0 transition happens under kvm_lock and cannot race with
kvm_get_kvm() (the mutex can be dropped as soon as
refcount_dec_and_mutex_lock() returns, it's really just the decrement
that needs to be within the critical section).

> >       if (new_val != old_val) {
> >               struct kvm *kvm;
> >
> > -             mutex_lock(&kvm_lock);
> > -
> >               list_for_each_entry(kvm, &vm_list, vm_list) {
>
> This is unsafe, as vm_list can be modified while kvm_lock is dropped.  And
> using list_for_each_entry_safe() doesn't help, because the _next_ entry have been
> freed.

list_for_each_entry_safe() is broken, but list_for_each_entry() can be
used. The problem is the call to kvm_put_kvm(), which is where the kvm
struct is freed thus breaking the foreach loop. So next must be read
and ref'd _before_ kvm_put_kvm(), then you can do

  kvm_get_kvm(kvm);
  mutex_unlock(&kvm_lock);
  if (prev)
    kvm_put_kvm(prev);
  ...
  mutex_lock(&kvm_lock);
  prev = kvm;

I don't know... there are few-enough readers that SRCU seems a bit
misplaced and it has the issue of keeping the VM data alive; while
kvm_lock has uglier code with the kvm_put_kvm() looking really
misplaced. If there were many instances one could write a nice
iterator, but for just one use?

Hmm... I wonder if something like

  if (poll_state_synchronize_srcu(&kvm_srcu,
          get_state_synchronize_srcu(&kvm_srcu))) {
    kvm_destroy_vm_cb(&kvm->rcu_head);
  } else {
    call_srcu(&kvm_srcu, &kvm->rcu_head, kvm_destroy_vm_cb);
  }

catches the case where there's no concurrent reader. If so, SRCU would
be a winner undoubtedly, but being the only user of a tricky RCU API
doesn't give me warm and fuzzy feelings. I'm still team kvm_lock for
now.

Anyhow I can prepare a tested version next Monday, with either
kvm_lock or with SRCU if the above trick works. Unless I showed that
it's trickier than it seems and successfully nerd-sniped you.
Seriously - just tell me what you prefer.

Paolo


