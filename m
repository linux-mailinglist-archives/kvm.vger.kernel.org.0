Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654B81E8D10
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgE3CIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgE3CIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:08:10 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCF6C03E969
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:08:10 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k18so1431377ion.0
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hrHbbukp3NCxkwAoiGzfJrdGNthBCVnAVfeCvc+gAmM=;
        b=C3xgvfi7xPwRQ5BeiElEzm7fGN1AKf34LhxHjZspqegQ1XGYr5RmI8VAefPYaMc2Tb
         NkfQ5h1T3iWn69aHDH1X2EU5TwSzwzpf7WOOirhqSiH4kNKc9JJiz8j+/8dbsTGVk7Xe
         YeCCp2s3Fens0SM1scMTDoZuxfTU+X4dVKulVxZJpKozjuPGqktjUV9ZPofzYHNfPmd9
         W7BSc341KzvpOiQrk/qKSFm22P9hrpR+0DkknVF2a7ck1RpeZXkWthJdY634gGkfSj54
         XNI0M4EWy+83ChbIzUR3wcsYvCS92HoxYrfUTZ+zqkCIzOBn1muNLXrb2TI096x7ylfz
         7Hsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hrHbbukp3NCxkwAoiGzfJrdGNthBCVnAVfeCvc+gAmM=;
        b=EJyfXJjTaAjg+og+p4FmxSicIopbh5hqqxjlklhXXzz7cx9P4Sp1yG4BUbk/1stECm
         KtFe+ZyTLS89ubIduKuzlW/CD74jNwMZaIi27Ct7y4KVH3rlb6tCumo6DmVLQMpBXPM2
         u7w8BUZ+Coh1abj33DmmYcBP6ay6MgpXYBn9GFDiFszLI3rTUIpIOOFd6oMIkpYTjzfP
         Beb43Hoc+zc1NrzZaKuTbtFE8nBoRF7eBCHSylU5Nl3Xg4CzLbtcf85Kh77F35uCzXTu
         3ji+rbJb81pBZSy3lNgsk0InvG0L1PJ9LaM0HNNJwhFmxMPiwAL5/VdPFHBWCYh9MPMf
         h+Qw==
X-Gm-Message-State: AOAM531/jUD55uZA2PD+Rsoit421Je8N1D+uJl/Wi9HRIdD1PHVGvmWI
        U/+zsFXg6vHAt0ZihU2lf0CTI1z7jbCLzZagnZhZTw==
X-Google-Smtp-Source: ABdhPJxC3EuWjlSEbxf8tajdB8TU+ufny+A+RcsC/fGSYTVBdYM89XsQKdgpNp9t2YdLJbidzFdRFH2866sGseU10Io=
X-Received: by 2002:a6b:3805:: with SMTP id f5mr9464051ioa.156.1590804489138;
 Fri, 29 May 2020 19:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <17c14245a404ff679253313ffe899c5f4e966717.1588711355.git.ashish.kalra@amd.com>
In-Reply-To: <17c14245a404ff679253313ffe899c5f4e966717.1588711355.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 29 May 2020 19:07:33 -0700
Message-ID: <CABayD+f0XbhgKKe45Dwk5=-4d68iEn8HZsLCKrPaygxkkUWUCw@mail.gmail.com>
Subject: Re: [PATCH v8 12/18] KVM: SVM: Add support for static allocation of
 unified Page Encryption Bitmap.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 5, 2020 at 2:18 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Add support for static allocation of the unified Page encryption bitmap by
> extending kvm_arch_commit_memory_region() callack to add svm specific x86_ops
> which can read the userspace provided memory region/memslots and calculate
> the amount of guest RAM managed by the KVM and grow the bitmap based
> on that information, i.e. the highest guest PA that is mapped by a memslot.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm/sev.c          | 35 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          |  1 +
>  arch/x86/kvm/svm/svm.h          |  1 +
>  arch/x86/kvm/x86.c              |  5 +++++
>  5 files changed, 43 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fc74144d5ab0..b573ea85b57e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1254,6 +1254,7 @@ struct kvm_x86_ops {
>
>         bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>         int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> +       void (*commit_memory_region)(struct kvm *kvm, enum kvm_mr_change change);
>         int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
>                                   unsigned long sz, unsigned long mode);
>         int (*get_page_enc_bitmap)(struct kvm *kvm,
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 30efc1068707..c0d7043a0627 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1377,6 +1377,41 @@ static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
>         return 0;
>  }
>
> +void svm_commit_memory_region(struct kvm *kvm, enum kvm_mr_change change)
> +{
> +       struct kvm_memslots *slots;
> +       struct kvm_memory_slot *memslot;
> +       gfn_t start, end = 0;
> +
> +       spin_lock(&kvm->mmu_lock);
> +       if (change == KVM_MR_CREATE) {
> +               slots = kvm_memslots(kvm);
> +               kvm_for_each_memslot(memslot, slots) {
> +                       start = memslot->base_gfn;
> +                       end = memslot->base_gfn + memslot->npages;
> +                       /*
> +                        * KVM memslots is a sorted list, starting with
> +                        * the highest mapped guest PA, so pick the topmost
> +                        * valid guest PA.
> +                        */
> +                       if (memslot->npages)
> +                               break;
> +               }
> +       }
> +       spin_unlock(&kvm->mmu_lock);
> +
> +       if (end) {
> +               /*
> +                * NORE: This callback is invoked in vm ioctl
> +                * set_user_memory_region, hence we can use a
> +                * mutex here.
> +                */
> +               mutex_lock(&kvm->lock);
> +               sev_resize_page_enc_bitmap(kvm, end);
> +               mutex_unlock(&kvm->lock);
> +       }
> +}
> +
>  int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>                                   unsigned long npages, unsigned long enc)
>  {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 501e82f5593c..442adbbb0641 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4015,6 +4015,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>
>         .check_nested_events = svm_check_nested_events,
>
> +       .commit_memory_region = svm_commit_memory_region,
>         .page_enc_status_hc = svm_page_enc_status_hc,
>         .get_page_enc_bitmap = svm_get_page_enc_bitmap,
>         .set_page_enc_bitmap = svm_set_page_enc_bitmap,
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 2ebdcce50312..fd99e0a5417a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -406,6 +406,7 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>                                   unsigned long npages, unsigned long enc);
>  int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
>  int svm_set_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
> +void svm_commit_memory_region(struct kvm *kvm, enum kvm_mr_change change);
>
>  /* avic.c */
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c4166d7a0493..8938de868d42 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10133,6 +10133,11 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>                 kvm_mmu_change_mmu_pages(kvm,
>                                 kvm_mmu_calculate_default_mmu_pages(kvm));
>
> +       if (change == KVM_MR_CREATE || change == KVM_MR_DELETE) {
> +               if (kvm_x86_ops.commit_memory_region)
> +                       kvm_x86_ops.commit_memory_region(kvm, change);
Why not just call this every time (if it exists) and have the
kvm_x86_op determine if it should do anything?

It seems like it's a nop anyway unless you are doing a create.

> +       }
> +
>         /*
>          * Dirty logging tracks sptes in 4k granularity, meaning that large
>          * sptes have to be split.  If live migration is successful, the guest
> --
> 2.17.1
>
