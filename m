Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D658B375D4E
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 01:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhEFXHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 19:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhEFXHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 19:07:31 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DB7C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 16:06:31 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id q7-20020a9d57870000b02902a5c2bd8c17so6392131oth.5
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 16:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=puSn4XmETa9i4jT6sRSbeiOvgKRNZLbIOzKaQoODelw=;
        b=BW0gfeKF/RfgaCMS6XoDjwHd3mgxHEIuNDN1gCaM9vQFpnsm6WiHAdzvwiYu/mVYtb
         BhYCgKo2kmSlSs4v3qM3421of0BJzSHCM1ju+ovOMsg1KIWSRtzFbivGfNih7ZPp5hov
         7ldK3dtbJvtGdJEhjQy6urB0y3NikewcYpdZFm5URlfyb8dOXiL4quqryrpJMdUidboC
         7Bte+BwLICwW4AoSFH6DnHSXEDmqLb+9hzzuXgezU3Tvcy4wOiBbTi0TEyhx+UeVsCV6
         VDMc8Kjp3YaOrtOyXYen9cQx2+CvNoriagUC6uxRN6DXMGs1+zWUCB3ch7TtjPhwE6lx
         omXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=puSn4XmETa9i4jT6sRSbeiOvgKRNZLbIOzKaQoODelw=;
        b=OK5X0mW7rgtAXnBdiobVwaTBzOVD/tgAeG32oECDRv/ZxDzLfFzOVD5a37qsBHwe41
         n7b2hiZeoutvj4yvdjOdpyHpc/6dtLW3IB7bRLs2MQ92qAqrF7rZfLmqFDe37E9C0lk1
         SSEipR9FRY8zJ1m4z3TePhhOpkVK3I1RKE+EqEfyOQJPU9D6btHAC9F65GgRzLwckrZk
         +8CVqULwFv25OXgjKiFI0FRtTCo5dog1NaNB7MwrrTn3mZvDzNzRdW1UmBsD1HimwYkI
         oNnYDnuzjdLBml4YqwtWOzzX5pFImxCH539/bYJsbxL57/Q8C+2yCDC99mKcSzp+jgxP
         pScA==
X-Gm-Message-State: AOAM533BWTTXLDX/cXhlxUQVkkyfUC8V7+NOOEJusn8vXK81qthKWCF0
        uatYGtT48So+5qjYc4BaOKqUSsIZp2lt0elVZgN+ZA==
X-Google-Smtp-Source: ABdhPJzDykGlQ6ezNL2J4VfpoNJwXtHZP1bF6dS04iOa4mv17SRjG9AWPexaf7XqqSIVA4YFCxqgtQpLPdmlkR/I7/U=
X-Received: by 2002:a9d:1b4d:: with SMTP id l71mr5728018otl.241.1620342390829;
 Thu, 06 May 2021 16:06:30 -0700 (PDT)
MIME-Version: 1.0
References: <1548966284-28642-1-git-send-email-karahmed@amazon.de> <1548966284-28642-9-git-send-email-karahmed@amazon.de>
In-Reply-To: <1548966284-28642-9-git-send-email-karahmed@amazon.de>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 6 May 2021 16:06:19 -0700
Message-ID: <CALMp9eR-Kt5wcveYmmmOe7HfWBB4r5nF+SjMfybPRR-b9TXiTg@mail.gmail.com>
Subject: Re: [PATCH v6 08/14] KVM/nVMX: Use kvm_vcpu_map when mapping the
 posted interrupt descriptor table
To:     KarimAllah Ahmed <karahmed@amazon.de>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 31, 2019 at 12:28 PM KarimAllah Ahmed <karahmed@amazon.de> wrote:
>
> Use kvm_vcpu_map when mapping the posted interrupt descriptor table since
> using kvm_vcpu_gpa_to_page() and kmap() will only work for guest memory
> that has a "struct page".
>
> One additional semantic change is that the virtual host mapping lifecycle
> has changed a bit. It now has the same lifetime of the pinning of the
> interrupt descriptor table page on the host side.
>
> Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> v4 -> v5:
> - unmap with dirty flag
>
> v1 -> v2:
> - Do not change the lifecycle of the mapping (pbonzini)
> ---
>  arch/x86/kvm/vmx/nested.c | 43 ++++++++++++-------------------------------
>  arch/x86/kvm/vmx/vmx.h    |  2 +-
>  2 files changed, 13 insertions(+), 32 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 31b352c..53b1063 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -230,12 +230,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
>                 vmx->nested.apic_access_page = NULL;
>         }
>         kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
> -       if (vmx->nested.pi_desc_page) {
> -               kunmap(vmx->nested.pi_desc_page);
> -               kvm_release_page_dirty(vmx->nested.pi_desc_page);
> -               vmx->nested.pi_desc_page = NULL;
> -               vmx->nested.pi_desc = NULL;
> -       }
> +       kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
> +       vmx->nested.pi_desc = NULL;
>
>         kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
>
> @@ -2868,26 +2864,15 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>         }
>
>         if (nested_cpu_has_posted_intr(vmcs12)) {
> -               if (vmx->nested.pi_desc_page) { /* shouldn't happen */
> -                       kunmap(vmx->nested.pi_desc_page);
> -                       kvm_release_page_dirty(vmx->nested.pi_desc_page);
> -                       vmx->nested.pi_desc_page = NULL;
> -                       vmx->nested.pi_desc = NULL;
> -                       vmcs_write64(POSTED_INTR_DESC_ADDR, -1ull);
> +               map = &vmx->nested.pi_desc_map;
> +
> +               if (!kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->posted_intr_desc_addr), map)) {
> +                       vmx->nested.pi_desc =
> +                               (struct pi_desc *)(((void *)map->hva) +
> +                               offset_in_page(vmcs12->posted_intr_desc_addr));
> +                       vmcs_write64(POSTED_INTR_DESC_ADDR,
> +                                    pfn_to_hpa(map->pfn) + offset_in_page(vmcs12->posted_intr_desc_addr));
>                 }

Previously, if there was no backing page for the
vmcs12->posted_intr_desc_addr, we wrote an illegal value (-1ull) into
the vmcs02 POSTED_INTR_DESC_ADDR field to force VM-entry failure. Now,
AFAICT, we leave that field unmodified. For a newly constructed
vmcs02, doesn't that mean we're going to treat physical address 0 as
the address of the vmcs02 posted interrupt descriptor?

> -               page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->posted_intr_desc_addr);
> -               if (is_error_page(page))
> -                       return;
> -               vmx->nested.pi_desc_page = page;
> -               vmx->nested.pi_desc = kmap(vmx->nested.pi_desc_page);
> -               vmx->nested.pi_desc =
> -                       (struct pi_desc *)((void *)vmx->nested.pi_desc +
> -                       (unsigned long)(vmcs12->posted_intr_desc_addr &
> -                       (PAGE_SIZE - 1)));
> -               vmcs_write64(POSTED_INTR_DESC_ADDR,
> -                       page_to_phys(vmx->nested.pi_desc_page) +
> -                       (unsigned long)(vmcs12->posted_intr_desc_addr &
> -                       (PAGE_SIZE - 1)));
>         }
>         if (nested_vmx_prepare_msr_bitmap(vcpu, vmcs12))
>                 vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
> @@ -3911,12 +3896,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>                 vmx->nested.apic_access_page = NULL;
>         }
>         kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
> -       if (vmx->nested.pi_desc_page) {
> -               kunmap(vmx->nested.pi_desc_page);
> -               kvm_release_page_dirty(vmx->nested.pi_desc_page);
> -               vmx->nested.pi_desc_page = NULL;
> -               vmx->nested.pi_desc = NULL;
> -       }
> +       kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
> +       vmx->nested.pi_desc = NULL;
>
>         /*
>          * We are now running in L2, mmu_notifier will force to reload the
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index f618f52..bd04725 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -143,7 +143,7 @@ struct nested_vmx {
>          */
>         struct page *apic_access_page;
>         struct kvm_host_map virtual_apic_map;
> -       struct page *pi_desc_page;
> +       struct kvm_host_map pi_desc_map;
>
>         struct kvm_host_map msr_bitmap_map;
>
> --
> 2.7.4
>
