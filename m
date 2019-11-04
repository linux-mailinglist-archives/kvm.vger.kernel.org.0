Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1971DEDFEF
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 13:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfKDMZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 07:25:18 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39495 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfKDMZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 07:25:18 -0500
Received: by mail-oi1-f196.google.com with SMTP id v138so13886033oif.6;
        Mon, 04 Nov 2019 04:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7DO/9fdGQ8A/RF+WbZ97l1qptLYcB41OzLDfDxLbCT8=;
        b=jDM/tCrsVGxfVtrRxk2+J7kFUVDaQPOIwjigB+bvbRWEe0uuAwFanzS1k0d4M/Uh6V
         V1ueAGxXvzxfaPN2K0URqwdO/THOadzT/j+pQG5ZM1KlG10VKpBL3LV3smTB8/hbzPLm
         5ej3opFeVUTpFmt+52r33WKnjRgD9YE/nRned8LQZbtdvfhd04LKO/tcurgBcblpyLbw
         YG2IEYf6AhHvhL3XkytDxY+zm2/NWrO4XhJI+TewzsXGkYXmpF3wNc5mR0hVY2ShkbXn
         HfTsugNZeUZY0TtLFuDowQ7CiUVcg+IdxB6hEm5PWAh6HIK5QmtLj6WofEACUXfJd5SD
         Ju4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7DO/9fdGQ8A/RF+WbZ97l1qptLYcB41OzLDfDxLbCT8=;
        b=eSWNlMjCUzYNKf3Vw9Lm5DCezBHAwEdgo0CDhVxLS325w9ds5B4mhj1TDuPO6r+ZjH
         A+X/dgBYnAPLemfSkz4sEI83qJUa/DP0ujCJ71BsaH0fnUAg9r142FpUEnfnZ/OvIBkl
         KVNK/m6HL/r5eksIi98nI3i3p35M61/6OtZ3t3px7Z7xazg4CwHDlfVx84rRitkVPg77
         yKlbXMMHJiSB5KzY5T2lY3qF82z6Ik669x9mrCKdK6Aop5m/Ai7gJaiFlvnT/fZrAvTH
         9VZ/roY6xuBrBSRy7hoGjK3488JyIwnrkXW/HcR2UWwQlQ2VxzOsGGpf9KB6XLi35Nk8
         l0Xg==
X-Gm-Message-State: APjAAAUkcCMwLMsqRtPYzh4BaAs1JUwhOGcn9TEICfxBt+76iLWpyr4T
        hc88drw5fLJpCoeBAb///TbYdl+lOTG7TbARxm0=
X-Google-Smtp-Source: APXvYqzpQIQnhMez88/FFxSM86oUaVh2fh5p8FRYjEuMscE9oXFEeRRCjDNFNer1jIHpr2lL3P+o1HglPHiRs+/baSA=
X-Received: by 2002:aca:39d6:: with SMTP id g205mr9940797oia.33.1572870318047;
 Mon, 04 Nov 2019 04:25:18 -0800 (PST)
MIME-Version: 1.0
References: <1572848879-21011-1-git-send-email-wanpengli@tencent.com>
 <1572848879-21011-2-git-send-email-wanpengli@tencent.com> <c32d632b-8fb0-f7c6-4937-07c30769b924@redhat.com>
 <CANRm+CzkbrbE2C2yFKL1=mQCBCZMfVH8Tue3eXXqTL5Z1VUB5w@mail.gmail.com> <ee896a34-0914-8d3c-bcdd-5aede1743190@redhat.com>
In-Reply-To: <ee896a34-0914-8d3c-bcdd-5aede1743190@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 4 Nov 2019 20:25:11 +0800
Message-ID: <CANRm+CyLiP_EncGnpMug9hbJYO+hC0DT2a-p5mOKUKHnUadO9w@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: Fix rcu splat if vm creation fails
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 Nov 2019 at 20:21, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/11/19 13:16, Wanpeng Li wrote:
> >> I don't understand this one, hasn't
> >>
> >>         WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
> >>
> >> decreased the conut already?  With your patch the refcount would then
> >> underflow.
> >
> > r = kvm_arch_init_vm(kvm, type);
> > if (r)
> >     goto out_err_no_arch_destroy_vm;
> >
> > out_err_no_disable:
> >     kvm_arch_destroy_vm(kvm);
> >     WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
> > out_err_no_arch_destroy_vm:
> >
> > So, if kvm_arch_init_vm() fails, we will not execute
> > WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>
> Uuh of course.  But I'd rather do the opposite: move the refcount_set
> earlier so that refcount_dec_and_test can be moved after
> no_arch_destroy_vm.  Moving the refcount_set is not strictly necessary,
> but avoids the introduction of yet another label.
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e22ff63e5b1a..e7a07132cd7f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -650,6 +650,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>         if (init_srcu_struct(&kvm->irq_srcu))
>                 goto out_err_no_irq_srcu;
>
> +       refcount_set(&kvm->users_count, 1);
>         for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>                 struct kvm_memslots *slots = kvm_alloc_memslots();
>
> @@ -667,7 +668,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
>                         goto out_err_no_arch_destroy_vm;
>         }
>
> -       refcount_set(&kvm->users_count, 1);
>         r = kvm_arch_init_vm(kvm, type);
>         if (r)
>                 goto out_err_no_arch_destroy_vm;
> @@ -696,8 +696,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
>         hardware_disable_all();
>  out_err_no_disable:
>         kvm_arch_destroy_vm(kvm);
> -       WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>  out_err_no_arch_destroy_vm:
> +       WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>         for (i = 0; i < KVM_NR_BUSES; i++)
>                 kfree(kvm_get_bus(kvm, i));
>         for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)

Good point, I will handle these two patches later.

    Wanpeng
