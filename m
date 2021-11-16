Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D34453411
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 15:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbhKPO0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237271AbhKPO0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 09:26:45 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF754C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 06:23:46 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d24so38007645wra.0
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 06:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h7kOp545uVgx+GwL0MS2uV1T/3qLsZYrxv7B/NrXjJ0=;
        b=EMhiTIADHX9DiXxs1O8k/BKoqlBWAU/GRoWm0wPlPlMvCMCar7lRLY8j/HCLDSu+9q
         bQ+5g0kVF9+WDT61LBdd4DdKHxhMr4Zex6NYFbjZ1vJSvOLWdQRmGK5reVKGuA/pMc81
         4dfOnSmhgTTZKcHCAFoG44Owt3/v3ZpnFzKRwA1i6GLVx6kpEz7DJbNOQqJfufktOBKn
         eDPGSjAugQFu1al3bgZPR9W6GMeHRPMJfV7OC8y3ZPFn6fWg3Gn/QFpMxxi8Vrsy+ofi
         lIfV0QHe8wRNtrVGNUCym2Ohe7bbx0VSh5LON5Q11cDYoKv/gu8PC1mJ9OYFB22YMLDw
         JdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h7kOp545uVgx+GwL0MS2uV1T/3qLsZYrxv7B/NrXjJ0=;
        b=hEIyjkLjJVLvTncaF7s0n5DvL/3if8Akg5mctsOfoWgriAYnBkwKID7CX7O8XcCR5N
         UISSi7rteTRyPvs+FfdViJselSLGBoPQdz/jaUynq0ewo1B68kRLVaB1n9U5NRoM493a
         wUTaSnQ38HmGirpGmwd6vPJFlwppbFJi0R66Ely5RdMLz2Nfk3GOWY0P8+RbrYE8lV00
         GcEDg0rob1VyIgjjyOUxujjIhGLekgsWqryssF1CRhZauNEAgWq1SE7qMJxFdCmB3GJz
         b1T+Rr9GcmvNUeUtxDu6rEHNZUu4unPCULMrViz/oh05rDoUsitRLO3H7BqxjbwU3lPm
         kHMw==
X-Gm-Message-State: AOAM533ZuXS4ydFgPee/T6q0qm/CJzcLoDOc+QXgBS1FIG2tznABvZDp
        U90iNC3A9KHsmnWD94TbViuvYxN0N+c3pIDK/2C1eDnvfO+zvA==
X-Google-Smtp-Source: ABdhPJy1qTUFimPfD6YE2YJwCxkMQbs6CZrlUst3mZPNkbsBqE7ARnXVPNrMOA8ymxY0gvwCyDiplZvMikGY4x4mz6A=
X-Received: by 2002:a5d:628f:: with SMTP id k15mr9997324wru.363.1637072625270;
 Tue, 16 Nov 2021 06:23:45 -0800 (PST)
MIME-Version: 1.0
References: <20211104164107.1291793-1-seanjc@google.com> <20211104164107.1291793-2-seanjc@google.com>
In-Reply-To: <20211104164107.1291793-2-seanjc@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 16 Nov 2021 19:47:08 +0530
Message-ID: <CAAhSdy1sREo9KT_99kbz70RYLsXr1aCSapxxpraZ6ZOxh1P+kw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: RISC-V: Unmap stage2 mapping when
 deleting/moving a memslot
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atish.patra@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 4, 2021 at 10:11 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Unmap stage2 page tables when a memslot is being deleted or moved.  It's
> the architectures' responsibility to ensure existing mappings are removed
> when kvm_arch_flush_shadow_memslot() returns.
>
> Fixes: 99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

The Fixes tag should be
Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table programming")

Otherwise it looks good to me.

I have queued this patch for fixes.

Thanks,
Anup

> ---
>  arch/riscv/kvm/mmu.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index d81bae8eb55e..fc058ff5f4b6 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -453,6 +453,12 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>                                    struct kvm_memory_slot *slot)
>  {
> +       gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
> +       phys_addr_t size = slot->npages << PAGE_SHIFT;
> +
> +       spin_lock(&kvm->mmu_lock);
> +       stage2_unmap_range(kvm, gpa, size, false);
> +       spin_unlock(&kvm->mmu_lock);
>  }
>
>  void kvm_arch_commit_memory_region(struct kvm *kvm,
> --
> 2.34.0.rc0.344.g81b53c2807-goog
>
