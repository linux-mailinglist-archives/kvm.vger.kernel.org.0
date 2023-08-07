Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6A57718EE
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 06:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjHGEHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 00:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjHGEG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 00:06:56 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07F21735
        for <kvm@vger.kernel.org>; Sun,  6 Aug 2023 21:06:51 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99bfcf4c814so603128066b.0
        for <kvm@vger.kernel.org>; Sun, 06 Aug 2023 21:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1691381210; x=1691986010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SQR6KJ/FhtvInUvsXBBH3959t1otsdS1MIxYT4RZrmE=;
        b=zVgu5hm9jsUtIHg2wK8KanlvekGNwZL84xIX6PmVsRIW7AMzAekULWyX5RLH2+3I8a
         9NBBposKMt4HqGXcpayM1SeXVNxifTvCsaOX2PXnRtfxSCS83v/J1s5Gu7TxPTzV+9p1
         yJvU8XrAsXdWlhtJcxwAChcp3oeuJmiTtiy+eziTjd7H5bbEJNAQqmZlblbhkcZN785Q
         +l18v1S3feFlxtzGIq70Fan2V3RAt5cIBaXolAHAxjaPeLh/pAV8Zh6/dCPGIUiJU0xQ
         EyyibS/pax4U9DK8XBMx1XqQ6uKHSUI0DrtiXsPx42IdPFcTakN4pCe5Spbac5xsI9wf
         Y8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691381210; x=1691986010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQR6KJ/FhtvInUvsXBBH3959t1otsdS1MIxYT4RZrmE=;
        b=APUmIKb2IkOnTDcru3E++Z9oLeHW9sJb1lQG/oURNVykH8w3YYWyqq5HrmK6QWwKM+
         q4plO8+B9ZwWFu1ZqnVmqkMAO6vHsDQUtDpR6cLrXNZM1YFDENIZrCcofQPjcDjWCtVH
         S5mg6SgeG+WVPuR1iPRYk4W957S5W4Oc+LnMVih4a447i0U3G7YBmx2a+c4+hQdAQBQB
         yqER0c17vbBBmhfjI9iQeqLjnRy/q7h+Khe4+sR1u7NRWszB536EAO42GrHPwQf8A93a
         qK4djAfl/NvGQxXnIZQhtQbi0HhFwOQDgu2SWdH0LwQitvh/rTxdYYBJnULrx5AIAR6A
         GS/w==
X-Gm-Message-State: AOJu0Yzf98SoSNs5SqgzSsFTHXUIe/7eV0N0CIb7wcDAnKoscPNvRVxs
        lx4WlcMSd29E2L6KFyjNG+QxPxBN5Egiy+BOokMfag==
X-Google-Smtp-Source: AGHT+IGeoOwkB9nQ7k0b/dRr/76SHuvh53LuNDU3Lsybg1LD47bB07JdBMPGIOFZdm/g+2inVrwy8kPSFUbfzIUZMy4=
X-Received: by 2002:a17:906:c5:b0:994:555a:e49f with SMTP id
 5-20020a17090600c500b00994555ae49fmr9032741eji.31.1691381209962; Sun, 06 Aug
 2023 21:06:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-6-rananta@google.com>
In-Reply-To: <20230722022251.3446223-6-rananta@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 7 Aug 2023 09:36:38 +0530
Message-ID: <CAAhSdy1niGVbogG-dZhRC43DLasAXW+Ay3bvdKH_t73s0v5HJg@mail.gmail.com>
Subject: Re: [PATCH v7 05/12] KVM: Move kvm_arch_flush_remote_tlbs_memslot()
 to common code
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 22, 2023 at 7:53=E2=80=AFAM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> From: David Matlack <dmatlack@google.com>
>
> Move kvm_arch_flush_remote_tlbs_memslot() to common code and drop
> "arch_" from the name. kvm_arch_flush_remote_tlbs_memslot() is just a
> range-based TLB invalidation where the range is defined by the memslot.
> Now that kvm_flush_remote_tlbs_range() can be called from common code we
> can just use that and drop a bunch of duplicate code from the arch
> directories.
>
> Note this adds a lockdep assertion for slots_lock being held when
> calling kvm_flush_remote_tlbs_memslot(), which was previously only
> asserted on x86. MIPS has calls to kvm_flush_remote_tlbs_memslot(),
> but they all hold the slots_lock, so the lockdep assertion continues to
> hold true.
>
> Also drop the CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT ifdef gating
> kvm_flush_remote_tlbs_memslot(), since it is no longer necessary.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  arch/arm64/kvm/arm.c     |  6 ------
>  arch/mips/kvm/mips.c     | 10 ++--------
>  arch/riscv/kvm/mmu.c     |  6 ------
>  arch/x86/kvm/mmu/mmu.c   | 16 +---------------
>  arch/x86/kvm/x86.c       |  2 +-
>  include/linux/kvm_host.h |  7 +++----
>  virt/kvm/kvm_main.c      | 18 ++++++++++++++++--
>  7 files changed, 23 insertions(+), 42 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c2c14059f6a8..ed7bef4d970b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1525,12 +1525,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, stru=
ct kvm_memory_slot *memslot)
>
>  }
>
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *mem=
slot)
> -{
> -       kvm_flush_remote_tlbs(kvm);
> -}
> -
>  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>                                         struct kvm_arm_device_addr *dev_a=
ddr)
>  {
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 4b7bc39a4173..231ac052b506 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -199,7 +199,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>         /* Flush slot from GPA */
>         kvm_mips_flush_gpa_pt(kvm, slot->base_gfn,
>                               slot->base_gfn + slot->npages - 1);
> -       kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +       kvm_flush_remote_tlbs_memslot(kvm, slot);
>         spin_unlock(&kvm->mmu_lock);
>  }
>
> @@ -235,7 +235,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>                 needs_flush =3D kvm_mips_mkclean_gpa_pt(kvm, new->base_gf=
n,
>                                         new->base_gfn + new->npages - 1);
>                 if (needs_flush)
> -                       kvm_arch_flush_remote_tlbs_memslot(kvm, new);
> +                       kvm_flush_remote_tlbs_memslot(kvm, new);
>                 spin_unlock(&kvm->mmu_lock);
>         }
>  }
> @@ -987,12 +987,6 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>         return 1;
>  }
>
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *mem=
slot)
> -{
> -       kvm_flush_remote_tlbs(kvm);
> -}
> -
>  int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned lo=
ng arg)
>  {
>         int r;
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index f2eb47925806..97e129620686 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -406,12 +406,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct=
 kvm_memory_slot *memslot)
>  {
>  }
>
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *mem=
slot)
> -{
> -       kvm_flush_remote_tlbs(kvm);
> -}
> -
>  void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free=
)
>  {
>  }
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index eb88d25f9896..efbe394da1a6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6669,7 +6669,7 @@ static void kvm_rmap_zap_collapsible_sptes(struct k=
vm *kvm,
>          */
>         if (walk_slot_rmaps(kvm, slot, kvm_mmu_zap_collapsible_spte,
>                             PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true=
))
> -               kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +               kvm_flush_remote_tlbs_memslot(kvm, slot);
>  }
>
>  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> @@ -6688,20 +6688,6 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm=
,
>         }
>  }
>
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *mem=
slot)
> -{
> -       /*
> -        * All current use cases for flushing the TLBs for a specific mem=
slot
> -        * related to dirty logging, and many do the TLB flush out of mmu=
_lock.
> -        * The interaction between the various operations on memslot must=
 be
> -        * serialized by slots_locks to ensure the TLB flush from one ope=
ration
> -        * is observed by any other operation on the same memslot.
> -        */
> -       lockdep_assert_held(&kvm->slots_lock);
> -       kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npag=
es);
> -}
> -
>  void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
>                                    const struct kvm_memory_slot *memslot)
>  {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a6b9bea62fb8..faeb2e307b36 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12751,7 +12751,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *=
kvm,
>                  * See is_writable_pte() for more details (the case invol=
ving
>                  * access-tracked SPTEs is particularly relevant).
>                  */
> -               kvm_arch_flush_remote_tlbs_memslot(kvm, new);
> +               kvm_flush_remote_tlbs_memslot(kvm, new);
>         }
>  }
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a731967b24ff..45899ce9ed31 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1360,6 +1360,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool y=
ield_to_kernel_mode);
>
>  void kvm_flush_remote_tlbs(struct kvm *kvm);
>  void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages);
> +void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
> +                                  const struct kvm_memory_slot *memslot)=
;
>
>  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)=
;
> @@ -1388,10 +1390,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struc=
t kvm *kvm,
>                                         unsigned long mask);
>  void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *me=
mslot);
>
> -#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *mem=
slot);
> -#else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
> +#ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *lo=
g);
>  int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
>                       int *is_dirty, struct kvm_memory_slot **memslot);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 804470fccac7..58213cc4b9b9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -379,6 +379,20 @@ void kvm_flush_remote_tlbs_range(struct kvm *kvm, gf=
n_t gfn, u64 pages)
>         kvm_flush_remote_tlbs(kvm);
>  }
>
> +void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
> +                                  const struct kvm_memory_slot *memslot)
> +{
> +       /*
> +        * All current use cases for flushing the TLBs for a specific mem=
slot
> +        * related to dirty logging, and many do the TLB flush out of mmu=
_lock.
> +        * The interaction between the various operations on memslot must=
 be
> +        * serialized by slots_locks to ensure the TLB flush from one ope=
ration
> +        * is observed by any other operation on the same memslot.
> +        */
> +       lockdep_assert_held(&kvm->slots_lock);
> +       kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npag=
es);
> +}
> +
>  static void kvm_flush_shadow_all(struct kvm *kvm)
>  {
>         kvm_arch_flush_shadow_all(kvm);
> @@ -2191,7 +2205,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kv=
m, struct kvm_dirty_log *log)
>         }
>
>         if (flush)
> -               kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> +               kvm_flush_remote_tlbs_memslot(kvm, memslot);
>
>         if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
>                 return -EFAULT;
> @@ -2308,7 +2322,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *=
kvm,
>         KVM_MMU_UNLOCK(kvm);
>
>         if (flush)
> -               kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> +               kvm_flush_remote_tlbs_memslot(kvm, memslot);
>
>         return 0;
>  }
> --
> 2.41.0.487.g6d72f3e995-goog
>
