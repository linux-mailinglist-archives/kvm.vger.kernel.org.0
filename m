Return-Path: <kvm+bounces-28471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E0F998EBB
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 19:48:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB3A2B280AC
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 17:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D114D1BDA90;
	Thu, 10 Oct 2024 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UMNB4+y7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B659C19ABCB
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 17:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728582485; cv=none; b=K4n0i+F8eEgPzm1eEstGYy2IZlLj6pnh+IOf+933iY3MwnjCq0iTEMc4jYro4jsxZ1K7QuOkHMAfFmfT4teLbrDRmsv9QgWmNT2z+lrIVO43OwWkD1ZDJhmywQFoY29rF3Hf3nlEFjofDJUcsp62JMsHyYhU1V6OoVU3MPCyOV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728582485; c=relaxed/simple;
	bh=E8mbeffuJCF5vv+fAvVmB2Ys8E6dCWOV1902JqtVczw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ihD+ycx9WfRuQM8M3y/S8jf98CcpxAiIGCwxfPDMyhcs/C+MuyUTOm1K7t1YJewB7wRzrxoNxxWpJkymu8ywhPtyuzYrCeKqgcd1/fxbdtO3BrmkI5wYZ4V1eiGVA6w1osKneJ9b7EFPq1P8hARXeWtVGdueAZnEhMD/ry0rK4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UMNB4+y7; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e290222fde4so1329404276.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 10:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728582482; x=1729187282; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X1Z42wRbrt15yDSnqRKqM6/kC3SQS2TPM9wcYC+W7Ws=;
        b=UMNB4+y7EjVUZLgIGOqdsiqTA9dBPw/WZWFoqidjXSdJYJxJhPXsf5EBFPP86/zzNZ
         HWV1A6uZqY6dGscLBtLo9XMdAr0PINu7yAAsaaNtosg6TAB12ugIvwM13K46OrHlTBlw
         I4XS5JfUMSWdg+eKd3Ym5TZYeKvmSVWCHer7Ke82ifnIBWHx1ie5BF5Qfk85y6nmALnz
         YJTsP1Q8L43CYCLG9VqNJTh5wavuvxh3tU1C/Xn8zFhkr+wVO544EUiInVdGcKBGZd51
         1toOYv89EFcO9Mhuxoyw6OWwtmAt31+W5GD3zd16GedQbzZ39jO4MiTgehyMnRpd0r2S
         rrGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728582482; x=1729187282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X1Z42wRbrt15yDSnqRKqM6/kC3SQS2TPM9wcYC+W7Ws=;
        b=Yjh+c1FPHkPCSh/Mxl6BNFXfHsbwwC1oyLUWq/CgJvg1fIJNo0PXOve5KCfEUxLSdA
         0B9HLFR0YBcTkGKAY3CRDY9HW0grUn9BvpBAsmBldC5WOYrfq6pmsA0nxG2/pZF4kd9T
         upH/laA2mniZ/I0vvZDXyR1l7Bjni5cITl3UCSmW26YgHR2Y2xI8xYSZT86fIHZ7wd9N
         QuN+H7bWZwQ5wXjxOK1MnoDK1JtAvghM9HHKAjKXe1dXOZEneJInwkzY5Gm9s7dxfglx
         z/DjgD+KcYSgvrl/KkseGul8Swbq0EOSFxAYJ0wDQzKaKpY8OkmYFkw7lNmjTQOtIZCj
         nJ3w==
X-Gm-Message-State: AOJu0YxJTkBAivjNh6MmUZmpukfHFO7e1qmBdGQWw3IiEWsW1ZK/P0Hc
	szWc3sW9gC/WQZb+/s8fXy9po2aPtM9nkejmItby218mJmXnA12c2wqRgqOwmhlrOBoGiTsStcg
	9fQ==
X-Google-Smtp-Source: AGHT+IF0dDDUVU5j61y3AwnqaoruwprA9uZzFBQnwA7DNa3maVwIMFNNKTf0+Fg7U7/6tuyOWQZWYl0/xnc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:a2c5:0:b0:e28:f1e8:6596 with SMTP id
 3f1490d57ef6-e28fe328e1emr94533276.1.1728582481751; Thu, 10 Oct 2024 10:48:01
 -0700 (PDT)
Date: Thu, 10 Oct 2024 10:48:00 -0700
In-Reply-To: <1baf4159-ce53-4a75-99bf-adf4b89dd07b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009150455.1057573-1-seanjc@google.com> <20241009150455.1057573-5-seanjc@google.com>
 <1baf4159-ce53-4a75-99bf-adf4b89dd07b@redhat.com>
Message-ID: <ZwgTUNCOIh2xwU6e@google.com>
Subject: Re: [PATCH 4/6] Revert "KVM: Fix vcpu_array[0] races"
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>, Alexander Potapenko <glider@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 10, 2024, Paolo Bonzini wrote:
> On 10/9/24 17:04, Sean Christopherson wrote:
> > Now that KVM loads from vcpu_array if and only if the target index is
> > valid with respect to online_vcpus, i.e. now that it is safe to erase a
> > not-fully-onlined vCPU entry, revert to storing into vcpu_array before
> > success is guaranteed.
> > 
> > If xa_store() fails, which _should_ be impossible, then putting the vCPU's
> > reference to 'struct kvm' results in a refcounting bug as the vCPU fd has
> > been installed and owns the vCPU's reference.
> > 
> > This was found by inspection, but forcing the xa_store() to fail
> > confirms the problem:
> > 
> >   | Unable to handle kernel paging request at virtual address ffff800080ecd960
> >   | Call trace:
> >   |  _raw_spin_lock_irq+0x2c/0x70
> >   |  kvm_irqfd_release+0x24/0xa0
> >   |  kvm_vm_release+0x1c/0x38
> >   |  __fput+0x88/0x2ec
> >   |  ____fput+0x10/0x1c
> >   |  task_work_run+0xb0/0xd4
> >   |  do_exit+0x210/0x854
> >   |  do_group_exit+0x70/0x98
> >   |  get_signal+0x6b0/0x73c
> >   |  do_signal+0xa4/0x11e8
> >   |  do_notify_resume+0x60/0x12c
> >   |  el0_svc+0x64/0x68
> >   |  el0t_64_sync_handler+0x84/0xfc
> >   |  el0t_64_sync+0x190/0x194
> >   | Code: b9000909 d503201f 2a1f03e1 52800028 (88e17c08)
> > 
> > Practically speaking, this is a non-issue as xa_store() can't fail, absent
> > a nasty kernel bug.  But the code is visually jarring and technically
> > broken.
> > 
> > This reverts commit afb2acb2e3a32e4d56f7fbd819769b98ed1b7520.
> > 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Michal Luczaj <mhal@rbox.co>
> > Cc: Alexander Potapenko <glider@google.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Reported-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   virt/kvm/kvm_main.c | 14 +++++---------
> >   1 file changed, 5 insertions(+), 9 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index fca9f74e9544..f081839521ef 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4283,7 +4283,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> >   	}
> >   	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
> > -	r = xa_reserve(&kvm->vcpu_array, vcpu->vcpu_idx, GFP_KERNEL_ACCOUNT);
> > +	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
> > +	BUG_ON(r == -EBUSY);
> >   	if (r)
> >   		goto unlock_vcpu_destroy;
> > @@ -4298,12 +4299,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> >   	kvm_get_kvm(kvm);
> >   	r = create_vcpu_fd(vcpu);
> >   	if (r < 0)
> > -		goto kvm_put_xa_release;
> > -
> > -	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> > -		r = -EINVAL;
> > -		goto kvm_put_xa_release;
> > -	}
> > +		goto kvm_put_xa_erase;
> 
> I also find it a bit jarring though that we have to undo the insertion. This
> is a chicken-and-egg situation where you are pick one operation B that will
> have to undo operation A if it fails.  But what xa_store is doing, is
> breaking this deadlock.
> 
> The code is a bit longer, sure, but I don't see the point in complicating
> the vcpu_array invariants and letting an entry disappear.

But we only need one rule: vcpu_array[x] is valid if and only if 'x' is less than
online_vcpus.  And that rule is necessary regardless of whether or not vcpu_array[x]
is filled before success is guaranteed.

I'm not concerned about the code length, it's that we need to do _something_ if
xa_store() fails.  Yeah, it should never happen, but knowingly doing nothing feels
all kinds of wrong.  I don't like BUG(), because it's obviously very doable to
gracefully handle failure.  And a WARN() is rather pointless, because continuing
on with an invalid entry is all but guaranteed to crash, i.e. is little more than a
deferred BUG() in this case.

