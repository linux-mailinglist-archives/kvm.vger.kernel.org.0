Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B083788C4
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 13:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbhEJLXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 07:23:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237868AbhEJLQW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 07:16:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620645317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hFmh+Js5dcrDC2qggJjjCnOndzOyA1bZlKu+7H/G1EM=;
        b=itg5gqvPt6mIOCW5fb0vUT7JxjowEP5mudZKwXrDZGbk+gGu7TDR/699BveS3tjwfQE8iv
        8VVM5BjfgPYhEYEs6noFPO/B5lgBYofpHx4A+YNdHZE1ImTSvK3Sb6P38Hgd1GdB7xpAC6
        Qv1e0IYi/DRbVFHSKymiLPCkXHq9K8I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-c-mOJp0PMYKTwi2QxvFm6A-1; Mon, 10 May 2021 07:15:15 -0400
X-MC-Unique: c-mOJp0PMYKTwi2QxvFm6A-1
Received: by mail-wm1-f72.google.com with SMTP id d199-20020a1c1dd00000b02901492c14476eso3389311wmd.2
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 04:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hFmh+Js5dcrDC2qggJjjCnOndzOyA1bZlKu+7H/G1EM=;
        b=JlzqqsVdmENUFuUK/rbZoICHxVB7Roue72b8OGxPNteKuRNBIxSquC35I8XT+4Hmbg
         tqfwey6pC6nbT4zwqXR5JHtSAsVZdkWHKV0sug/b6+08MHJT3++V5QUw7Bt7rBqqroIe
         Qd2igRjodZxP/Pd9cF2Yl+o4sfhJh7pGd2QUI0DVi2UqrsKzusPxa+2BSYaPnZ1QzK0K
         anAOuWe2TZKtOIo3ItXs37oXz/EqoItBVLifFnW96WDF1izu7BR/1yQ1obU5vY//Cizp
         K/h6OH4TmCPQcqvFK0S7Wie7b5zDXuVBOFd4VNp3R1e19dBKBDIVL9obXfn8l0uu81qG
         IvIw==
X-Gm-Message-State: AOAM533lNAGRVYekAv0NcZgTxkvELo6VCoJ5sbquK9bVNDf7v6eFZHu1
        pUME9wJJLi64nhBE1yf83r6wXp4nfyLUrmbmT4p5ndyowYaoH+3qxC/cv1U78Ty4uek7DZ1qQkQ
        4oIIlKrsnHPyAsNd6f4G0ZSpEFnay8awdmXR395cUhSN9auUiWypHyvG3M9Z+Tfae
X-Received: by 2002:a1c:ed0a:: with SMTP id l10mr25281643wmh.151.1620645314857;
        Mon, 10 May 2021 04:15:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNQKSSI/r8Wlen3ES/RDC+rWje7UeoceaXXPHNhueDpOpsfTfeb15I8P0mSb8TkSG/33UfHg==
X-Received: by 2002:a1c:ed0a:: with SMTP id l10mr25281613wmh.151.1620645314644;
        Mon, 10 May 2021 04:15:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f7sm25241980wrg.34.2021.05.10.04.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 04:15:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: hyper-v: Task srcu lock when accessing
 kvm_memslots()
In-Reply-To: <CANRm+Cw-MdiZKt7rPKGM=7ZudW3c_H5--CGg82t7eChSBkn-FQ@mail.gmail.com>
References: <1620634919-4563-1-git-send-email-wanpengli@tencent.com>
 <87mtt3vus5.fsf@vitty.brq.redhat.com>
 <CANRm+Cw-MdiZKt7rPKGM=7ZudW3c_H5--CGg82t7eChSBkn-FQ@mail.gmail.com>
Date:   Mon, 10 May 2021 13:15:13 +0200
Message-ID: <87k0o6x2ke.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> On Mon, 10 May 2021 at 16:48, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Wanpeng Li <kernellwp@gmail.com> writes:
>>
>> > From: Wanpeng Li <wanpengli@tencent.com>
>> >
>> >  WARNING: suspicious RCU usage
>> >  5.13.0-rc1 #4 Not tainted
>> >  -----------------------------
>> >  ./include/linux/kvm_host.h:710 suspicious rcu_dereference_check() usage!
>> >
>> > other info that might help us debug this:
>> >
>> > rcu_scheduler_active = 2, debug_locks = 1
>> >  1 lock held by hyperv_clock/8318:
>> >   #0: ffffb6b8cb05a7d8 (&hv->hv_lock){+.+.}-{3:3}, at: kvm_hv_invalidate_tsc_page+0x3e/0xa0 [kvm]
>> >
>> > stack backtrace:
>> > CPU: 3 PID: 8318 Comm: hyperv_clock Not tainted 5.13.0-rc1 #4
>> > Call Trace:
>> >  dump_stack+0x87/0xb7
>> >  lockdep_rcu_suspicious+0xce/0xf0
>> >  kvm_write_guest_page+0x1c1/0x1d0 [kvm]
>> >  kvm_write_guest+0x50/0x90 [kvm]
>> >  kvm_hv_invalidate_tsc_page+0x79/0xa0 [kvm]
>> >  kvm_gen_update_masterclock+0x1d/0x110 [kvm]
>> >  kvm_arch_vm_ioctl+0x2a7/0xc50 [kvm]
>> >  kvm_vm_ioctl+0x123/0x11d0 [kvm]
>> >  __x64_sys_ioctl+0x3ed/0x9d0
>> >  do_syscall_64+0x3d/0x80
>> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> >
>> > kvm_memslots() will be called by kvm_write_guest(), so we should take the srcu lock.
>> >
>> > Fixes: e880c6ea5 (KVM: x86: hyper-v: Prevent using not-yet-updated TSC page by secondary CPUs)
>> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>> > ---
>> >  arch/x86/kvm/hyperv.c | 8 ++++++++
>> >  1 file changed, 8 insertions(+)
>> >
>> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> > index f98370a3..f00830e 100644
>> > --- a/arch/x86/kvm/hyperv.c
>> > +++ b/arch/x86/kvm/hyperv.c
>> > @@ -1172,6 +1172,7 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
>> >  {
>> >       struct kvm_hv *hv = to_kvm_hv(kvm);
>> >       u64 gfn;
>> > +     int idx;
>> >
>> >       if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
>> >           hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET ||
>> > @@ -1190,9 +1191,16 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
>> >       gfn = hv->hv_tsc_page >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
>> >
>> >       hv->tsc_ref.tsc_sequence = 0;
>> > +
>> > +     /*
>> > +      * Take the srcu lock as memslots will be accessed to check the gfn
>> > +      * cache generation against the memslots generation.
>> > +      */
>> > +     idx = srcu_read_lock(&kvm->srcu);
>> >       if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
>> >                           &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
>> >               hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
>> > +     srcu_read_unlock(&kvm->srcu, idx);
>> >
>> >  out_unlock:
>> >       mutex_unlock(&hv->hv_lock);
>>
>> Thanks!
>>
>> Do we need to do the same in kvm_hv_setup_tsc_page()?
>
> kvm_hv_setup_tsc_page() is called in vcpu_enter_guest() path which has
> already held kvm->srcu lock.
>

I, true, thanks for checking!

For the patch:
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

