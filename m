Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB14677A21
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 12:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjAWL3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 06:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjAWL3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 06:29:00 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B9A11174
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 03:28:59 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id vw16so29553837ejc.12
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 03:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P7BRPVAgytXaXdSv+u5YyZxWP4l0mg5orHBmrI9mWeg=;
        b=0wDnlGH3rvVCwUJWtYmtEn2Eg9MLFBRrOs5reZ04bpBHLIZzqBIxzlx7xKTL7xoIsZ
         T1hpFIO2WqgcgaUDCMxWnmtf35fafrq/4wkMx7WN55ze/ZXc/qY0y5XyDM3CHBNwkIrT
         KQ3L8ZqRP6jM/5BPJ1pxq1nmfOmpfNcaypx/JQODpAk0iHV6YcK6X9eY8iOpsynOaHX6
         X50PeTCEl5D4SxM/iNXh1DopkOkG1OawQ306U3iPgKEjO8A7FmsounBgaMkQCXCVIeN8
         6W4Fet7EqWYQbqkk0QuY+6r1Qp3gfcdnOkZ/VFjG+MhNTR9FbdFBFWGY6aaQwXeUnjjw
         78MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P7BRPVAgytXaXdSv+u5YyZxWP4l0mg5orHBmrI9mWeg=;
        b=mokd+pTf2AqSUeDg22OresRC/CsnvBhOrVo02jicITq1DRlNKb/BvlirJemVOQZor4
         ODuMh7BgLRr6hq6QYUI8gEHqE26lSatpyWQgtfFPzuPWFvBBY7yoXL358LjoDx/xGV4P
         gRewjWyd2sCyoDBNiYBLEbCdDTaqrgJhygPqd7hlxGderpKxAmlS6rE+V4yjpqaqgHq/
         8k33umxNNqeS9jUBlPlS38AqUrkJCJru3A01MgNEs3+dsGmVijcqJTOqIXkCu++5Aleh
         0Ni97+eD1sH74rTc/xe4KznmsSwxFnQOSKt91PSZ78laCAZZF0WhQXnq3TVUSBs0frRr
         iLFg==
X-Gm-Message-State: AFqh2kr1kc4HybND7AWQaM59wh4rktlegSR70QPrMACy2FVErfDPDzWu
        Tx07fugjEPdCve7AWesbgoFoHstkS/iiHHJfZqUmHg==
X-Google-Smtp-Source: AMrXdXtqcNCysMqdMD4mx3Jj+yyU8K/MY3RB0Fli4xwB+fqEtTmBASo6IjedZ6OY+kR4N+23YmywkUCjtwVoDJ4UXik=
X-Received: by 2002:a17:906:d190:b0:84d:4b8d:5652 with SMTP id
 c16-20020a170906d19000b0084d4b8d5652mr2635037ejz.16.1674473337819; Mon, 23
 Jan 2023 03:28:57 -0800 (PST)
MIME-Version: 1.0
References: <20230123092928.808014-1-alexghiti@rivosinc.com> <bdabafb1-53f3-403c-ab9c-1c2d00421690@ghiti.fr>
In-Reply-To: <bdabafb1-53f3-403c-ab9c-1c2d00421690@ghiti.fr>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 23 Jan 2023 16:58:46 +0530
Message-ID: <CAAhSdy1grLz2EXEJUicGFZO7md7F=Hbnhv7ZqBFFx-vtnkpmmA@mail.gmail.com>
Subject: Re: [PATCH] KVM: RISC-V: Fix wrong usage of PGDIR_SIZE to check page sizes
To:     Alexandre Ghiti <alex@ghiti.fr>
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023 at 3:01 PM Alexandre Ghiti <alex@ghiti.fr> wrote:
>
> @Anup: Sorry, forgot to add -fixes to the patch title, as I think this
> should go into your fixes branch for 6.2.

Can you provide the Fixes: line here ? I will include it at time of
adding this patch to my fixes branch.

Regards,
Anup

>
> On 1/23/23 10:29, Alexandre Ghiti wrote:
> > At the moment, riscv only supports PMD and PUD hugepages. For sv39,
> > PGDIR_SIZE == PUD_SIZE but not for sv48 and sv57. So fix this by changing
> > PGDIR_SIZE into PUD_SIZE.
> >
> > Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> > ---
> >   arch/riscv/kvm/mmu.c | 8 ++++----
> >   1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > index 34b57e0be2ef..dbc4ca060174 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -585,7 +585,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >       if (!kvm->arch.pgd)
> >               return false;
> >
> > -     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
> > +     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
> >
> >       if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
> >                                  &ptep, &ptep_level))
> > @@ -603,7 +603,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >       if (!kvm->arch.pgd)
> >               return false;
> >
> > -     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
> > +     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
> >
> >       if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
> >                                  &ptep, &ptep_level))
> > @@ -645,12 +645,12 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
> >       if (logging || (vma->vm_flags & VM_PFNMAP))
> >               vma_pagesize = PAGE_SIZE;
> >
> > -     if (vma_pagesize == PMD_SIZE || vma_pagesize == PGDIR_SIZE)
> > +     if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
> >               gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
> >
> >       mmap_read_unlock(current->mm);
> >
> > -     if (vma_pagesize != PGDIR_SIZE &&
> > +     if (vma_pagesize != PUD_SIZE &&
> >           vma_pagesize != PMD_SIZE &&
> >           vma_pagesize != PAGE_SIZE) {
> >               kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
