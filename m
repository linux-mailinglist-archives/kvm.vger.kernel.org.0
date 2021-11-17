Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1A2454C68
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 18:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239601AbhKQRuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 12:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbhKQRuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 12:50:01 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BEAC061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 09:47:02 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y8so2838852plg.1
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 09:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HSLtB6Q7QNH9F1W7qlW0Hp58Qwigu0M5uYUCRsiHwC8=;
        b=i91S0zxnZ2YjxCPE0ezujuZtsD9n0tH0L43A/22KOp7ipN94InVR2Wn0r3oyPNEke2
         9U36PmooJOjzVOMUgdHQUrGD+/HUbs9bDIUbqrIcPIucW/CT/hXC4E17CNHwGF9gsA6Q
         n39tnJHoumxIa4IUC5lQqVHghzCUZb8Gj1I7JRn0oqu+yFbTDItRaizjIVARrMXsV9zx
         29QUfojA+FKZBQoT/AQVPGKHXn5tHivqH8FxcTMyPpg5YR9McwJz/iPoRol57/V5xgAd
         2TE7zpV127mIdx4KGSDkFbt6yuGtMMp9ytLEjLtJJR3x2TRLd7mBU5e10xqBtV7TOTFx
         pr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HSLtB6Q7QNH9F1W7qlW0Hp58Qwigu0M5uYUCRsiHwC8=;
        b=LazzroL+duHf8drZDy94nQNeVy29Bc74lcRa3Xi2PILGf8b3iLJrCgaACZo5EmSwwK
         do/5+kJw6gfKfdd8boAS/LUJqdqtsvA8PjZ7f5dpzkN+zhK/dVwy1wB64Xm0f4+sbKOB
         2zJwervhwCsjRbrjtWVPUDiiScWujhTi+MgLtBnAXboUua57QfTzBqX6QMbJsG9ossT/
         E8qYPI2Solh+/4+DzEeKzu7kei2N2N+qs9NCfI1q5rpE9ZQyW8cT8+IE/Ye99zRQUO/5
         GGTYQ5Xq1CcXMCSgetO8RUWyOsCXT+TTaAQK5nzSwwP+zOHZ/x7otn3WbyY909P/WiZd
         +Slg==
X-Gm-Message-State: AOAM531Y4sVF2jPWWLxVk3SRt6Ve1l2QuJfwDy5XJbv4VcDNWRIPMjk8
        /wrO9cBaKpp0DdMSfGxuc4jnvQVanRw1e3G6P8kGnQ==
X-Google-Smtp-Source: ABdhPJzuoVg8TZNtBfzM3itZiL5K5WGkgTiWXW2BerW+z4FhVVCEGPuw+dKwS7itfZfVHqVMZTme1WDz3avKyVVCez4=
X-Received: by 2002:a17:90a:b88d:: with SMTP id o13mr1693460pjr.39.1637171221769;
 Wed, 17 Nov 2021 09:47:01 -0800 (PST)
MIME-Version: 1.0
References: <20211117163809.1441845-1-pbonzini@redhat.com> <20211117163809.1441845-5-pbonzini@redhat.com>
In-Reply-To: <20211117163809.1441845-5-pbonzini@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 17 Nov 2021 10:46:48 -0700
Message-ID: <CAMkAt6odbAGZ-LgK7yefnNRgoAAs3ekvR2_sZpjTiv_6mfwRKg@mail.gmail.com>
Subject: Re: [PATCH 4/4] KVM: SEV: Do COPY_ENC_CONTEXT_FROM with both VMs locked
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021 at 9:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Now that we have a facility to lock two VMs with deadlock
> protection, use it for the creation of mirror VMs as well.  One of
> COPY_ENC_CONTEXT_FROM(dst, src) and COPY_ENC_CONTEXT_FROM(src, dst)
> would always fail, so the combination is nonsensical and it is okay to
> return -EBUSY if it is attempted.
>
> This sidesteps the question of what happens if a VM is
> MOVE_ENC_CONTEXT_FROM'd at the same time as it is
> COPY_ENC_CONTEXT_FROM'd: the locking prevents that from
> happening.
>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Peter Gonda <pgonda@google.com>

> ---
>  arch/x86/kvm/svm/sev.c | 68 ++++++++++++++++--------------------------
>  1 file changed, 26 insertions(+), 42 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f9256ba269e6..47d54df7675c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1548,6 +1548,9 @@ static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
>         struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
>         struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
>
> +       if (dst_kvm == src_kvm)
> +               return -EINVAL;
> +

Worth adding a migrate/mirror from self fails tests in
test_sev_(migrate|mirror)_parameters()? I guess it's already covered
by "the source cannot be SEV enabled" test cases.

>         /*
>          * Bail if these VMs are already involved in a migration to avoid
>          * deadlock between two VMs trying to migrate to/from each other.
> @@ -1951,76 +1954,57 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>  {
>         struct file *source_kvm_file;
>         struct kvm *source_kvm;
> -       struct kvm_sev_info source_sev, *mirror_sev;
> +       struct kvm_sev_info *source_sev, *mirror_sev;
>         int ret;
>
>         source_kvm_file = fget(source_fd);
>         if (!file_is_kvm(source_kvm_file)) {
>                 ret = -EBADF;
> -               goto e_source_put;
> +               goto e_source_fput;
>         }
>
>         source_kvm = source_kvm_file->private_data;
> -       mutex_lock(&source_kvm->lock);
> -
> -       if (!sev_guest(source_kvm)) {
> -               ret = -EINVAL;
> -               goto e_source_unlock;
> -       }
> +       ret = sev_lock_two_vms(kvm, source_kvm);
> +       if (ret)
> +               goto e_source_fput;
>
> -       /* Mirrors of mirrors should work, but let's not get silly */
> -       if (is_mirroring_enc_context(source_kvm) || source_kvm == kvm) {
> +       /*
> +        * Mirrors of mirrors should work, but let's not get silly.  Also
> +        * disallow out-of-band SEV/SEV-ES init if the target is already an
> +        * SEV guest, or if vCPUs have been created.  KVM relies on vCPUs being
> +        * created after SEV/SEV-ES initialization, e.g. to init intercepts.
> +        */
> +       if (sev_guest(kvm) || !sev_guest(source_kvm) ||
> +           is_mirroring_enc_context(source_kvm) || kvm->created_vcpus) {
>                 ret = -EINVAL;
> -               goto e_source_unlock;
> +               goto e_unlock;
>         }
>
> -       memcpy(&source_sev, &to_kvm_svm(source_kvm)->sev_info,
> -              sizeof(source_sev));
> -
>         /*
>          * The mirror kvm holds an enc_context_owner ref so its asid can't
>          * disappear until we're done with it
>          */
> +       source_sev = &to_kvm_svm(source_kvm)->sev_info;
>         kvm_get_kvm(source_kvm);
>
> -       fput(source_kvm_file);
> -       mutex_unlock(&source_kvm->lock);
> -       mutex_lock(&kvm->lock);
> -
> -       /*
> -        * Disallow out-of-band SEV/SEV-ES init if the target is already an
> -        * SEV guest, or if vCPUs have been created.  KVM relies on vCPUs being
> -        * created after SEV/SEV-ES initialization, e.g. to init intercepts.
> -        */
> -       if (sev_guest(kvm) || kvm->created_vcpus) {
> -               ret = -EINVAL;
> -               goto e_mirror_unlock;
> -       }
> -
>         /* Set enc_context_owner and copy its encryption context over */
>         mirror_sev = &to_kvm_svm(kvm)->sev_info;
>         mirror_sev->enc_context_owner = source_kvm;
>         mirror_sev->active = true;
> -       mirror_sev->asid = source_sev.asid;
> -       mirror_sev->fd = source_sev.fd;
> -       mirror_sev->es_active = source_sev.es_active;
> -       mirror_sev->handle = source_sev.handle;
> +       mirror_sev->asid = source_sev->asid;
> +       mirror_sev->fd = source_sev->fd;
> +       mirror_sev->es_active = source_sev->es_active;
> +       mirror_sev->handle = source_sev->handle;
> +       ret = 0;
>         /*
>          * Do not copy ap_jump_table. Since the mirror does not share the same
>          * KVM contexts as the original, and they may have different
>          * memory-views.
>          */
>
> -       mutex_unlock(&kvm->lock);
> -       return 0;
> -
> -e_mirror_unlock:
> -       mutex_unlock(&kvm->lock);
> -       kvm_put_kvm(source_kvm);
> -       return ret;
> -e_source_unlock:
> -       mutex_unlock(&source_kvm->lock);
> -e_source_put:
> +e_unlock:
> +       sev_unlock_two_vms(kvm, source_kvm);
> +e_source_fput:
>         if (source_kvm_file)
>                 fput(source_kvm_file);
>         return ret;
> --
> 2.27.0
>
