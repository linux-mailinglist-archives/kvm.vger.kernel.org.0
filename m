Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787F42A4BBF
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 17:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgKCQjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 11:39:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgKCQjq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 11:39:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604421585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yQBsE/t5jBF0RlQaFBc8rSEh1fxL3UOcs9joU9Ke/q4=;
        b=gJ4Atk3axzmgYsOrbrUzJSqLrfAbfTAIAVMCkkt75HNNkeaXfHxmTXRNRxoxXYZufRGHSL
        k/E/WD7waByW8N+YWwBNZZLekPLsphJMEgcB3mlyzT5p6SInDZFibzvq7yaEzrQnSXmv3W
        fO6ja6PIEqp7qXIT/SJLP4MKOPINPsc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129--M9OQLf5MwOWb3GZDXn1Qw-1; Tue, 03 Nov 2020 11:39:37 -0500
X-MC-Unique: -M9OQLf5MwOWb3GZDXn1Qw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74DA51009E23;
        Tue,  3 Nov 2020 16:39:36 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F08C10013D9;
        Tue,  3 Nov 2020 16:39:34 +0000 (UTC)
Date:   Tue, 3 Nov 2020 17:39:31 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: Add support for configuring
 the translation granule
Message-ID: <20201103163931.vs67zfhqnhn2y2wf@kamzik.brq.redhat.com>
References: <20201102113444.103536-1-nikos.nikoleris@arm.com>
 <20201102113444.103536-2-nikos.nikoleris@arm.com>
 <20201103130443.d7zt2zdzbg6hgq7c@kamzik.brq.redhat.com>
 <938dd93e-653b-492d-e8d9-d19fc54cb1f5@arm.com>
 <20201103161038.32orgisio5xy5cn2@kamzik.brq.redhat.com>
 <2f2a6f1a-2893-2a45-8145-8c013237025e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f2a6f1a-2893-2a45-8145-8c013237025e@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 04:25:15PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On 11/3/20 4:10 PM, Andrew Jones wrote:
> > On Tue, Nov 03, 2020 at 03:49:32PM +0000, Nikos Nikoleris wrote:
> >>>> diff --git a/lib/arm64/asm/page.h b/lib/arm64/asm/page.h
> >>>> index 46af552..2a06207 100644
> >>>> --- a/lib/arm64/asm/page.h
> >>>> +++ b/lib/arm64/asm/page.h
> >>>> @@ -10,38 +10,51 @@
> >>>>    * This work is licensed under the terms of the GNU GPL, version 2.
> >>>>    */
> >>>> +#include <config.h>
> >>>>   #include <linux/const.h>
> >>>> -#define PGTABLE_LEVELS		2
> >>>>   #define VA_BITS			42
> >>> Let's bump VA_BITS to 48 while we're at it.
> > I tried my suggestion to go to 48 VA bits, but it seems to break
> > things for 64K pages.
> 
> I believe that is because we end up with PGTABLE_LEVELS=3 and in
> mmu_set_ranges_sect() we try to install a block mapping at the PUD level, which is
> forbidden by the architecture.
> 
> I think the easiest fix for that is to always try to install block mapping at the
> pmd level. The diff below fixed all errors (with 16k and 64k pages):
> 
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 6d1c75b00eaa..d33948a8a06a 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -134,20 +134,22 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>                         phys_addr_t phys_start, phys_addr_t phys_end,
>                         pgprot_t prot)
>  {
> -       phys_addr_t paddr = phys_start & PUD_MASK;
> -       uintptr_t vaddr = virt_offset & PUD_MASK;
> +       phys_addr_t paddr = phys_start & PMD_MASK;
> +       uintptr_t vaddr = virt_offset & PMD_MASK;
>         uintptr_t virt_end = phys_end - paddr + vaddr;
>         pgd_t *pgd;
>         pud_t *pud;
> -       pud_t entry;
> +       pmd_t *pmd;
> +       pmd_t entry;
>  
> -       for (; vaddr < virt_end; vaddr += PUD_SIZE, paddr += PUD_SIZE) {
> -               pud_val(entry) = paddr;
> -               pud_val(entry) |= PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
> -               pud_val(entry) |= pgprot_val(prot);
> +       for (; vaddr < virt_end; vaddr += PMD_SIZE, paddr += PMD_SIZE) {
> +               pmd_val(entry) = paddr;
> +               pmd_val(entry) |= PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
> +               pmd_val(entry) |= pgprot_val(prot);
>                 pgd = pgd_offset(pgtable, vaddr);
>                 pud = pud_alloc(pgd, vaddr);
> -               WRITE_ONCE(*pud, entry);
> +               pmd = pmd_alloc(pud, vaddr);
> +               WRITE_ONCE(*pmd, entry);
>                 flush_tlb_page(vaddr);

Nice work! This resolves my issue as well. And, I can run with 16K pages
on my thunderx now too.


>         }
>  }
> diff --git a/lib/arm64/asm/page.h b/lib/arm64/asm/page.h
> index 2a06207444aa..f649f56bf16f 100644
> --- a/lib/arm64/asm/page.h
> +++ b/lib/arm64/asm/page.h
> @@ -13,7 +13,7 @@
>  #include <config.h>
>  #include <linux/const.h>
>  
> -#define VA_BITS                        42
> +#define VA_BITS                        46

Let's use 48.

>  
>  #define PAGE_SIZE              CONFIG_PAGE_SIZE
>  #if PAGE_SIZE == 65536
> 
> Thanks,
> 
> Alex
> 

Thanks,
drew

