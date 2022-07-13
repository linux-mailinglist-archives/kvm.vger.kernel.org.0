Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86BF572ACC
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 03:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbiGMB05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 21:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbiGMB0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 21:26:55 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9611CBA161
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 18:26:53 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-31c8a1e9e33so98676707b3.5
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 18:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Dy+Rmcjm8hkXGU4nfEHBrtA1yQ8VRvv++C+zBI3stA=;
        b=AGQh/f2q3qa6iXyE58orKUemPvszcwkcBLBJaMXz97hOSpcp+xbP7A3WISXnxCsi8J
         qmti94NwVRMdkhLPb7Z519Z0uOxjAs5mZNcLNPJvbRUUe/1d1SNmD9qM8pguS+3NHhry
         JpctM7lg5p9sbx/qoRaUQlI3PyLT5G7Eckt1U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Dy+Rmcjm8hkXGU4nfEHBrtA1yQ8VRvv++C+zBI3stA=;
        b=fcttRqQbHQ9b/kVL8QcR7P5cecpaTJfawUJ7PYo4wXoW9Sc4RZwkezAZ3STLbB8ok5
         Ce989/8MsSH5/27c23RAY/FZVpPzi9nj35S5r49m+6+v3zQWnW9VpvV52dR8wnHekdme
         aC1TyJyNJKIKytU+jUoyziDr3iVphenZ3hR/trmO6jYl7xLvfufG9GjBrDynHHaEp8vI
         HeTKH+7VIpW8SXBC8JCWW6SX9ncdvtbD/I9HHAr55UdiYv+u3zev14jPD+/h2FLJXhnz
         HdfYuTn2JP+X9th2mmDxAVdyzPBfXnRb/IIJb2ZDiLAq6B/fMuTP3l+lxzGyBPe28l7i
         c/VQ==
X-Gm-Message-State: AJIora91Ugk7Y4ffhFKzG5IilNM+pIqqIaUAaywvznxSXmV1bRqXbSR8
        Y7p/BmJCRwdRp/H/jDhJ0686Hr0KuYz1msxKVmZr
X-Google-Smtp-Source: AGRyM1v39Ct4gOMX9HbMyTm32hNI7oUAX2ibL1Ztp+G3+AyDL2If/7+ku58GCT5aQ/SwsU7B4sIB2VVl18XrQB/dNRc=
X-Received: by 2002:a81:653:0:b0:31d:2a21:734 with SMTP id 80-20020a810653000000b0031d2a210734mr1435894ywg.14.1657675612674;
 Tue, 12 Jul 2022 18:26:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220707145248.458771-1-apatel@ventanamicro.com> <20220707145248.458771-4-apatel@ventanamicro.com>
In-Reply-To: <20220707145248.458771-4-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 12 Jul 2022 18:26:41 -0700
Message-ID: <CAOnJCU++MsxgPyGqumWMLrB7ihDk3UmzwwD_voW0Rfnf-BVPWQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] RISC-V: KVM: Add G-stage ioremap() and iounmap() functions
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 7, 2022 at 7:53 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The in-kernel AIA IMSIC support requires on-demand mapping / unmapping
> of Guest IMSIC address to Host IMSIC guest files. To help achieve this,
> we add kvm_riscv_stage2_ioremap() and kvm_riscv_stage2_iounmap()
> functions. These new functions for updating G-stage page table mappings
> will be called in atomic context so we have special "in_atomic" parameter
> for this purpose.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |  5 +++++
>  arch/riscv/kvm/mmu.c              | 18 ++++++++++++++----
>  2 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 59a0cf2ca7b9..60c517e4d576 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -284,6 +284,11 @@ void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
>  void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
>                                unsigned long hbase, unsigned long hmask);
>
> +int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
> +                            phys_addr_t hpa, unsigned long size,
> +                            bool writable, bool in_atomic);
> +void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa,
> +                             unsigned long size);
>  int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                          struct kvm_memory_slot *memslot,
>                          gpa_t gpa, unsigned long hva, bool is_write);
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index b75d4e200064..f7862ca4c4c6 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -343,8 +343,9 @@ static void gstage_wp_memory_region(struct kvm *kvm, int slot)
>         kvm_flush_remote_tlbs(kvm);
>  }
>
> -static int gstage_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
> -                         unsigned long size, bool writable)
> +int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
> +                            phys_addr_t hpa, unsigned long size,
> +                            bool writable, bool in_atomic)
>  {
>         pte_t pte;
>         int ret = 0;
> @@ -353,6 +354,7 @@ static int gstage_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>         struct kvm_mmu_memory_cache pcache;
>
>         memset(&pcache, 0, sizeof(pcache));
> +       pcache.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0;
>         pcache.gfp_zero = __GFP_ZERO;
>
>         end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
> @@ -382,6 +384,13 @@ static int gstage_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>         return ret;
>  }
>
> +void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa, unsigned long size)
> +{
> +       spin_lock(&kvm->mmu_lock);
> +       gstage_unmap_range(kvm, gpa, size, false);
> +       spin_unlock(&kvm->mmu_lock);
> +}
> +
>  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>                                              struct kvm_memory_slot *slot,
>                                              gfn_t gfn_offset,
> @@ -517,8 +526,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>                                 goto out;
>                         }
>
> -                       ret = gstage_ioremap(kvm, gpa, pa,
> -                                            vm_end - vm_start, writable);
> +                       ret = kvm_riscv_gstage_ioremap(kvm, gpa, pa,
> +                                                      vm_end - vm_start,
> +                                                      writable, false);
>                         if (ret)
>                                 break;
>                 }
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
