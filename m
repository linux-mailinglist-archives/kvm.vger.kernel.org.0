Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B802B2BFB
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 08:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgKNHe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Nov 2020 02:34:28 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:36186 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgKNHe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Nov 2020 02:34:28 -0500
Received: by mail-il1-f194.google.com with SMTP id p10so10588660ile.3;
        Fri, 13 Nov 2020 23:34:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rGTFAKzr23qDU0X05TSfUL7Ef9EPpKQTkZuX7avWNY0=;
        b=qjaL2len/pBlvlBKxaECcsCOpcFy/p2M53HKRjLMlERdAFDk7PzNmL3tAXhyygg059
         fPIP7zbwLP89/+tpF3lOLxXPim7oi/jczS8/RG3mcqFqswEaIKIbG7oynyuYRfRjCpy2
         XxpMJUqzephdf9CdI+z5Y8UZMbG+OJxp3g4QukYcLuY0uiTqiw0MYEhZNMIPMRtLo9ax
         cVbrA5dXinw8mgly71juJku1h8axcfxkNv7kDn6ZftRwGrnAbMlgR9BGlpUugVKUJ5xv
         UAeBWrI6kpUOlYKD0DlvDnGKj2feKWxq+smzjHTvpGBLvNDgKfBOJkWE/lMQClx09JDU
         EK5A==
X-Gm-Message-State: AOAM532f8tH9diTn5prLHznRMouhO4ChXP40cm120hJGRBo/lTs1mkM3
        BVu1wRU4zftAFFytLjsuKZ1ETSyJ5GarIwfTMfA=
X-Google-Smtp-Source: ABdhPJzVBbLJ/Nn/dVtepqiEEKhi3aevey/mPf8XVsqyzlMYBTaTPwIErnDrGxPrHYmDLN8HdOLJzkTDFBAEI7XbIyY=
X-Received: by 2002:a92:85c5:: with SMTP id f188mr2697987ilh.173.1605339266125;
 Fri, 13 Nov 2020 23:34:26 -0800 (PST)
MIME-Version: 1.0
References: <20201113110952.68086-1-tsbogend@alpha.franken.de> <20201113110952.68086-2-tsbogend@alpha.franken.de>
In-Reply-To: <20201113110952.68086-2-tsbogend@alpha.franken.de>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Sat, 14 Nov 2020 15:34:14 +0800
Message-ID: <CAAhV-H7Sc6tmsfRcxOkx3rPk85Ey6XtxqhDB0RWokk+XSGVJ9A@mail.gmail.com>
Subject: Re: [PATCH 2/4] MIPS: kvm: Use vm_get_page_prot to get protection bits
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Thomas,

On Fri, Nov 13, 2020 at 7:13 PM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
>
> MIPS protection bits are setup during runtime so using defines like
> PAGE_SHARED ignores this runtime changes. Using vm_get_page_prot
> to get correct page protection fixes this.
Is there some visible bugs if without this fix?

Huacai
>
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>  arch/mips/kvm/mmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 28c366d307e7..3dabeda82458 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -1074,6 +1074,7 @@ int kvm_mips_handle_commpage_tlb_fault(unsigned long badvaddr,
>  {
>         kvm_pfn_t pfn;
>         pte_t *ptep;
> +       pgprot_t prot;
>
>         ptep = kvm_trap_emul_pte_for_gva(vcpu, badvaddr);
>         if (!ptep) {
> @@ -1083,7 +1084,8 @@ int kvm_mips_handle_commpage_tlb_fault(unsigned long badvaddr,
>
>         pfn = PFN_DOWN(virt_to_phys(vcpu->arch.kseg0_commpage));
>         /* Also set valid and dirty, so refill handler doesn't have to */
> -       *ptep = pte_mkyoung(pte_mkdirty(pfn_pte(pfn, PAGE_SHARED)));
> +       prot = vm_get_page_prot(VM_READ|VM_WRITE|VM_SHARED);
> +       *ptep = pte_mkyoung(pte_mkdirty(pfn_pte(pfn, prot)));
>
>         /* Invalidate this entry in the TLB, guest kernel ASID only */
>         kvm_mips_host_tlb_inv(vcpu, badvaddr, false, true);
> --
> 2.16.4
>
