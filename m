Return-Path: <kvm+bounces-16595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B5928BBF3B
	for <lists+kvm@lfdr.de>; Sun,  5 May 2024 06:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DECBD1F21709
	for <lists+kvm@lfdr.de>; Sun,  5 May 2024 04:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928111C3E;
	Sun,  5 May 2024 04:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="exE/1vqq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498E415A8;
	Sun,  5 May 2024 04:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714885013; cv=none; b=AXhJADgKXIoN3rAHbBvPMFWf9hwQzJ6aptlncjddQ0QrzytCxGOzqqDc1qQIMDCV6KXEdMYwFXaQC0jhlbvoLtkN8FZ92q79GzvRW23pZDp3rQclV1cpKiRiZbI8WTMOoJvIdKDvbF8M/62vAhwH2EOno/pMc5XQeLh0rZTlPZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714885013; c=relaxed/simple;
	bh=5Y0YjiRqnO6A5dniWdhSBIB0N8ldWUfmJumCUrN+o6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WNylU5y+xB9Mg8xOYAaRfMociCnkVADl7KlBZYUGvzpvRpKgqzkh7Xzktr82TlTNmrW8N8msJGDhU4try0JpE2eUAgV7kn2cdg4ZVUEMWJQpcCVEUZGePnnVpXM+npmyLq6BtDiOUjtW65nB8+Kw2Wz+1cv4HrxPK6QE/q8wmDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=exE/1vqq; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-de8b66d1726so2414113276.0;
        Sat, 04 May 2024 21:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714885011; x=1715489811; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2NhuRV0uRDm62gy8P9p70beyb9gwrk6ySf9IjmIAWvg=;
        b=exE/1vqq7Xq5jcyrvqVr5kP8pj54y51guOMCMNEYGJ/mg9Hyk0BSjCQk8K+ixa4l/+
         aDoJKVt4K7sZeIUWCe3OLbTZtB+LYHwCnOT8VepuY2V24x60vZMpdhkLe2arw2lTGtm4
         ueaAw9olg/d5ryZlELo4tl49E8SpqSLJ7e0k7ihK3EikY7/sz6XLXTYqiDSsF+FxF+j5
         48E55lCAC45F3yIhpi7nNvWPGSkD57uSdRQpu8n+idjoxeyo+ST0HSOsuIbHyX64lz/K
         RYHvQ2Nvn8xz31rHuZwiPX+9sPp6OCUjG9AUcbEKoOEVUb4DGf31uShgqVCscmkU4dcf
         Ugcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714885011; x=1715489811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2NhuRV0uRDm62gy8P9p70beyb9gwrk6ySf9IjmIAWvg=;
        b=eU/b9aazQyr+l5PPc8WfzvBq1B2cT1agkHR7EQMe23V3XcBac/mXVTqMJL3HD38AXW
         eIxc+okNh8GTfXAkUWLYaA6G7nv18LiSrdI9Yr3N8oM2CslDlaKFYMbDOfZQQNtO3vqR
         5pYsumkblyWGZTN3YIapn1zWIFua20lffUeWxskBIyfTYy6LJm9uP7LvEL8GuC4P6pMf
         syGgmJirhYN/vnHKUS+Ol1aXa11WizuHsr10+CbRaaFVdfkk2wATQ/vyf9URWlvI+7s+
         AjCmhjnxqfZ/SOZ3xcm7MnzVPiFur4/YmxhfLWTfZjXhYAmtm+HvWglBXF6Lxu+FUuZq
         hIzA==
X-Forwarded-Encrypted: i=1; AJvYcCWIbFHYgN/JadQjxCC4M7ea6nLhh2Ja9k9VnPQ4oO1YNxpwHZOUcxizrfCXu751hUo8gtplZSEVYeSMP29DU+RblVuQKBR+GgCsKRZVNcKoIWnQb5VrRC1NFFvfQvLKws3w
X-Gm-Message-State: AOJu0YwmF3WBsy5cfskWPRXihMwP60qcd9q6oOKLYhRzolmReE/laed/
	xtsOtuENOhXEO4u00Dc+bSnlmlp8BURQr6Fs2y+blrxtTEaBE227Br2uFYWCwKLIcW6C6fgBG76
	aQ3EzX5ZqUtYhwbixY0ODd17ZsZ4=
X-Google-Smtp-Source: AGHT+IG1sPgiLlgNrZV318ofiSAvstdjPPafYHRRBbw4NEO6YjabhxDmUuAYWggKJX7zVxTl3Csf5lfWzmyvm/Jz3cE=
X-Received: by 2002:a05:6902:13cf:b0:de5:4f75:fcf1 with SMTP id
 y15-20020a05690213cf00b00de54f75fcf1mr7398329ybu.6.1714885011281; Sat, 04 May
 2024 21:56:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240426041559.3717884-1-foxywang@tencent.com>
 <20240426041559.3717884-2-foxywang@tencent.com> <ZjVgWvrXyyVYXoxj@google.com>
In-Reply-To: <ZjVgWvrXyyVYXoxj@google.com>
From: Yi Wang <up2wing@gmail.com>
Date: Sun, 5 May 2024 12:56:39 +0800
Message-ID: <CAN35MuTTy+ZxVHfFjPAGVDpqA_teGBg7vi9btCL8oQe+iUqnHg@mail.gmail.com>
Subject: Re: [v4 RESEND 1/3] KVM: setup empty irq routing when create vm
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, wanpengli@tencent.com, 
	foxywang@tencent.com, oliver.upton@linux.dev, maz@kernel.org, 
	anup@brainfault.org, atishp@atishpatra.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sean,

Thanks so much for your patient reply.

On Sat, May 4, 2024 at 6:08=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Apr 26, 2024, Yi Wang wrote:
> > From: Yi Wang <foxywang@tencent.com>
> >
> > Add a new function to setup empty irq routing in kvm path, which
> > can be invoded in non-architecture-specific functions. The difference
> > compared to the kvm_setup_empty_irq_routing() is this function just
> > alloc the empty irq routing and does not need synchronize srcu, as
> > we will call it in kvm_create_vm().
> >
> > Using the new adding function, we can setup empty irq routing when
> > kvm_create_vm(), so that x86 and s390 no longer need to set
> > empty/dummy irq routing when creating an IRQCHIP 'cause it avoid
> > an synchronize_srcu.
> >
> > Signed-off-by: Yi Wang <foxywang@tencent.com>
> > ---
> >  include/linux/kvm_host.h |  1 +
> >  virt/kvm/irqchip.c       | 19 +++++++++++++++++++
> >  virt/kvm/kvm_main.c      |  4 ++++
> >  3 files changed, 24 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 48f31dcd318a..9256539139ef 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2100,6 +2100,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
> >                       const struct kvm_irq_routing_entry *entries,
> >                       unsigned nr,
> >                       unsigned flags);
> > +int kvm_setup_empty_irq_routing_lockless(struct kvm *kvm);
>
> This is in an #ifdef, the #else needs a stub (for MIPS).

Okay, I'll update the patch.

>
> >  int kvm_set_routing_entry(struct kvm *kvm,
> >                         struct kvm_kernel_irq_routing_entry *e,
> >                         const struct kvm_irq_routing_entry *ue);
> > diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> > index 1e567d1f6d3d..266bab99a8a8 100644
> > --- a/virt/kvm/irqchip.c
> > +++ b/virt/kvm/irqchip.c
> > @@ -237,3 +237,22 @@ int kvm_set_irq_routing(struct kvm *kvm,
> >
> >       return r;
> >  }
> > +
> > +int kvm_setup_empty_irq_routing_lockless(struct kvm *kvm)
>
> I vote for kvm_init_irq_routing() to make it more obvious that the API is=
 purely
> for initializing the routing, i.e. only to be used at VM creation.  Then =
the
> "lockless" tag is largely redundant.  And then maybe add a comment about =
how this
> creates an empty routing table?  Because every time I look at this code, =
it takes
> me a few seconds to remember how this is actually an empty table.

That sounds reasonable to me.

>
> > +{
> > +     struct kvm_irq_routing_table *new;
> > +     int chip_size;
> > +
> > +     new =3D kzalloc(struct_size(new, map, 1), GFP_KERNEL_ACCOUNT);
> > +     if (!new)
> > +             return -ENOMEM;
> > +
> > +     new->nr_rt_entries =3D 1;
> > +
> > +     chip_size =3D sizeof(int) * KVM_NR_IRQCHIPS * KVM_IRQCHIP_NUM_PIN=
S;
> > +     memset(new->chip, -1, chip_size);
> > +
> > +     RCU_INIT_POINTER(kvm->irq_routing, new);
> > +
> > +     return 0;
> > +}
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index ff0a20565f90..b5f4fa9d050d 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1285,6 +1285,10 @@ static struct kvm *kvm_create_vm(unsigned long t=
ype, const char *fdname)
> >       if (r)
> >               goto out_err;
> >
> > +     r =3D kvm_setup_empty_irq_routing_lockless(kvm);
> > +     if (r)
> > +             goto out_err;
>
> This is too late.  It might not matter in practice, but the call before t=
his is
> to kvm_arch_post_init_vm(), which quite strongly suggests that *all* comm=
on setup
> is done before that arch hook is invoked.
>
> Calling this right before kvm_arch_init_vm() seems like the best/easiest =
fit, e.g.

Got it. I will update the patch ASAP, before that I will do some tests.

Thanks again, Sean.

>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2e388972d856..ab607441686f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1197,9 +1197,13 @@ static struct kvm *kvm_create_vm(unsigned long typ=
e, const char *fdname)
>                 rcu_assign_pointer(kvm->buses[i],
>                         kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACC=
OUNT));
>                 if (!kvm->buses[i])
> -                       goto out_err_no_arch_destroy_vm;
> +                       goto out_err_no_irq_routing;
>         }
>
> +       r =3D kvm_init_irq_routing(kvm);
> +       if (r)
> +               goto out_err_no_irq_routing;
> +
>         r =3D kvm_arch_init_vm(kvm, type);
>         if (r)
>                 goto out_err_no_arch_destroy_vm;
> @@ -1254,6 +1258,8 @@ static struct kvm *kvm_create_vm(unsigned long type=
, const char *fdname)
>         WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>         for (i =3D 0; i < KVM_NR_BUSES; i++)
>                 kfree(kvm_get_bus(kvm, i));
> +       kvm_free_irq_routing(kvm);
> +out_err_no_irq_routing:
>         cleanup_srcu_struct(&kvm->irq_srcu);
>  out_err_no_irq_srcu:
>         cleanup_srcu_struct(&kvm->srcu);
>


--=20
---
Best wishes
Yi Wang

