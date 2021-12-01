Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7FF46552C
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 19:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352276AbhLASVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 13:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352270AbhLASVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 13:21:11 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DACC061748
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 10:17:50 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id bu18so65240070lfb.0
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 10:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wLhC5Pay0B/Il8cbFcevOEOxfDkJT7JdpoaUwuUSTms=;
        b=UEXgWdrlFK8jl44/kkizK2Jvo8TNxtF243+EaMj/ZQ8LdxDOGtYnV0Kghy5CXkDbxF
         5gYu2BEZDWnjm/TH5nXJzpaGYhwkXZ1tAVclQ7Ge/85iwCdjZ/0ra0lByYxQ/29d/cZD
         Rd0SbO3wZ8VAIoFnVRIQkJTrqaa0nencytbA51SclZNJ5RWa86Oa9G9ZzKeMrRAD8WZ7
         gXcXQdkUvM8CQhTW/IHzJBJNwoAsEvaTIN/kPfyj4f3V43YfRa7duKsmtyDKwU8KUOql
         SsiW/xZq4ZGSZNwQ+fqsgWbc7stC8k2hzzd4kk6n+9MzAcGhfw05FMf/r9w6O6rwcOw3
         zCag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wLhC5Pay0B/Il8cbFcevOEOxfDkJT7JdpoaUwuUSTms=;
        b=cl0Tq70ZzM7Rv7mvQDftXxwWAdtvPecx/aYqvtXReoTM6mH16LA5dRxJTY+rLPUbOE
         EPGBEhUE5EtOY2fyvFyhTkOs8TEXXJ0AN5seJc1ZUdXnGHFz+1ejHwS7eCuEia49i0js
         gQz0Jn6AC+mMKoDUpv/3EAS+LitzR0BwG4Wyvr1dYFN5ceWMYWMW4pK8KKDTtaS4dWIW
         D1C1g+IZCyLg98vRFSvIo0jvRvSpzJJwUj/mRBIw96YCVnjvWg3CnTbUTdjXZR6cM5Hb
         dg9f8LxuUs9I/MqkOd7VJ02Ijnd5dwG69ANe5V2XCw/imG8aeXDdS+fwuvtdJBPsxiKB
         z7Eg==
X-Gm-Message-State: AOAM531tlXtZMkCI3vHTxLZd+oIguW43x3K9PnQ3I49xGmT/760no8sL
        nuwLqqwo8Zm/KgLklwGxRE47ukfFT49NkoYJxZMHkqKAC6U=
X-Google-Smtp-Source: ABdhPJyd7sBS2sjjuiLoaj67YdXJbdN8LjDdR9BtI4iXD3LqQGvLTx8PpTDGfeSYx4Jr2CynoB0V552qm3PuMZ4TlrA=
X-Received: by 2002:a05:6512:39c4:: with SMTP id k4mr7396595lfu.79.1638382668329;
 Wed, 01 Dec 2021 10:17:48 -0800 (PST)
MIME-Version: 1.0
References: <20211123005036.2954379-1-pbonzini@redhat.com> <20211123005036.2954379-11-pbonzini@redhat.com>
In-Reply-To: <20211123005036.2954379-11-pbonzini@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 1 Dec 2021 11:17:36 -0700
Message-ID: <CAMkAt6q9OsrZuEG-fXRh2D26F34RAZcX8KQS22CTLC7S+YF3MA@mail.gmail.com>
Subject: Re: [PATCH 10/12] KVM: SEV: Prohibit migration of a VM that has mirrors
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 5:50 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> VMs that mirror an encryption context rely on the owner to keep the
> ASID allocated.  Performing a KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
> would cause a dangling ASID:
>
> 1. copy context from A to B (gets ref to A)
> 2. move context from A to L (moves ASID from A to L)
> 3. close L (releases ASID from L, B still references it)
>
> The right way to do the handoff instead is to create a fresh mirror VM
> on the destination first:
>
> 1. copy context from A to B (gets ref to A)
> [later] 2. close B (releases ref to A)
> 3. move context from A to L (moves ASID from A to L)
> 4. copy context from L to M
>
> So, catch the situation by adding a count of how many VMs are
> mirroring this one's encryption context.
>
> Fixes: 0b020f5af092 ("KVM: SEV: Add support for SEV-ES intra host migration")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c                        | 22 ++++++++++-
>  arch/x86/kvm/svm/svm.h                        |  1 +
>  .../selftests/kvm/x86_64/sev_migrate_tests.c  | 37 +++++++++++++++++++
>  3 files changed, 59 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 025d9731b66c..89a716290fac 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1696,6 +1696,16 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
>         }
>
>         src_sev = &to_kvm_svm(source_kvm)->sev_info;
> +
> +       /*
> +        * VMs mirroring src's encryption context rely on it to keep the
> +        * ASID allocated, but below we are clearing src_sev->asid.
> +        */
> +       if (src_sev->num_mirrored_vms) {
> +               ret = -EBUSY;
> +               goto out_unlock;
> +       }
> +
>         dst_sev->misc_cg = get_current_misc_cg();
>         cg_cleanup_sev = dst_sev;
>         if (dst_sev->misc_cg != src_sev->misc_cg) {
> @@ -1987,6 +1997,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>          */
>         source_sev = &to_kvm_svm(source_kvm)->sev_info;
>         kvm_get_kvm(source_kvm);
> +       source_sev->num_mirrored_vms++;
>
>         /* Set enc_context_owner and copy its encryption context over */
>         mirror_sev = &to_kvm_svm(kvm)->sev_info;
> @@ -2019,12 +2030,21 @@ void sev_vm_destroy(struct kvm *kvm)
>         struct list_head *head = &sev->regions_list;
>         struct list_head *pos, *q;
>
> +       WARN_ON(sev->num_mirrored_vms);
> +

If we don't change to atomic doesn't this need to happen when we have
the kvm->lock?

>         if (!sev_guest(kvm))
>                 return;
>
>         /* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
>         if (is_mirroring_enc_context(kvm)) {
> -               kvm_put_kvm(sev->enc_context_owner);
> +               struct kvm *owner_kvm = sev->enc_context_owner;
> +               struct kvm_sev_info *owner_sev = &to_kvm_svm(owner_kvm)->sev_info;
> +
> +               mutex_lock(&owner_kvm->lock);
> +               if (!WARN_ON(!owner_sev->num_mirrored_vms))
> +                       owner_sev->num_mirrored_vms--;
> +               mutex_unlock(&owner_kvm->lock);
> +               kvm_put_kvm(owner_kvm);
>                 return;
>         }
>
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5faad3dc10e2..1c7306c370fa 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -79,6 +79,7 @@ struct kvm_sev_info {
>         struct list_head regions_list;  /* List of registered regions */
>         u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
>         struct kvm *enc_context_owner; /* Owner of copied encryption context */
> +       unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
>         struct misc_cg *misc_cg; /* For misc cgroup accounting */
>         atomic_t migration_in_progress;
>  };
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> index d265cea5de85..29b18d565cf4 100644
> --- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> +++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> @@ -294,6 +294,41 @@ static void test_sev_mirror_parameters(void)
>         kvm_vm_free(vm_no_vcpu);
>  }
>
> +static void test_sev_move_copy(void)
> +{
> +       struct kvm_vm *dst_vm, *sev_vm, *mirror_vm, *dst_mirror_vm;
> +       int ret;
> +
> +       sev_vm = sev_vm_create(/* es= */ false);
> +       dst_vm = aux_vm_create(true);
> +       mirror_vm = aux_vm_create(false);
> +       dst_mirror_vm = aux_vm_create(false);
> +
> +       sev_mirror_create(mirror_vm->fd, sev_vm->fd);
> +       ret = __sev_migrate_from(dst_vm->fd, sev_vm->fd);
> +       TEST_ASSERT(ret == -1 && errno == EBUSY,
> +                   "Cannot migrate VM that has mirrors. ret %d, errno: %d\n", ret,
> +                   errno);
> +
> +       /* The mirror itself can be migrated.  */
> +       sev_migrate_from(dst_mirror_vm->fd, mirror_vm->fd);
> +       ret = __sev_migrate_from(dst_vm->fd, sev_vm->fd);
> +       TEST_ASSERT(ret == -1 && errno == EBUSY,
> +                   "Cannot migrate VM that has mirrors. ret %d, errno: %d\n", ret,
> +                   errno);
> +
> +       /*
> +        * mirror_vm is not a mirror anymore, dst_mirror_vm is.  Thus,
> +        * the owner can be copied as soon as dst_mirror_vm is gone.
> +        */
> +       kvm_vm_free(dst_mirror_vm);
> +       sev_migrate_from(dst_vm->fd, sev_vm->fd);
> +
> +       kvm_vm_free(mirror_vm);
> +       kvm_vm_free(dst_vm);
> +       kvm_vm_free(sev_vm);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>         if (kvm_check_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
> @@ -301,6 +336,8 @@ int main(int argc, char *argv[])
>                 test_sev_migrate_from(/* es= */ true);
>                 test_sev_migrate_locking();
>                 test_sev_migrate_parameters();
> +               if (kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM))
> +                       test_sev_move_copy();
>         }
>         if (kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
>                 test_sev_mirror(/* es= */ false);
> --
> 2.27.0
>
>
