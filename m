Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87DB787B92
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 00:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243917AbjHXWiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 18:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243941AbjHXWht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 18:37:49 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC056E77
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 15:37:47 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-40c72caec5cso120541cf.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 15:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692916667; x=1693521467; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ouja50lRt/Qn0hpYJQBRTrstUcNcH6yXAbWF/Sx0YoQ=;
        b=tZw52j1sKwnpwFHy0NN85MqIzsxZP6Y8r6be2BeG9U5vYw0SUf7Nri5ROux8Dc5xm3
         iaP5JdEMuvV0umkgVnVDi7QHr6M2kjdxYIkBKGNe4uPbZlWd3jxrNNab6Rx5XK5sFOLc
         +68uDJeZO7gI12OdAGCuXb0p2flsHlGeK6lasE7OLhG7wKFTKMFOTiiEQuDBlldR1jnu
         NAej9SE5C+jkYkiaNMngaBIRuV5euAMk4QUuGqV0XxR1L00fl2u/3vUV87Fz4jkFgzxt
         JSta+BhkjrQ3bbqOsdQYv+lfj7rwx2AwdJcKsWYHZcNcMYHKGu2T7jpNbMICow+OjRbN
         KFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692916667; x=1693521467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ouja50lRt/Qn0hpYJQBRTrstUcNcH6yXAbWF/Sx0YoQ=;
        b=ijg3TKoMQCpZCIsZla+ltRjOhH8Aw4ZWk9ZXwNXkty+/teaDL6G9jH7Tx7MdigSa9/
         uk6zoVgOjObTiRsIiY3xAL1vhlU/Qu+dQYDkuSoEJ/7vEDYNOp/+EAAQuVFo5E+vCdoj
         f13xHaYx+eAPhO41IyWdntGYg9I2pMxKYiQWHoFA2H4XF7ScbZkENA0CBXkTK4xWfwp/
         Nswzhgf3bKBcCTTENMialpmnwC8BS2TBFFdVcDAqLpR7vcBYTfqpD6+wNykcItx4/9p4
         8L5coA159Z8cvYF7dyUSm1L3vpzKEI2i1ohdMzJRnTrS3eGK+fJYecBm2xmBxNxd0mPX
         5dgw==
X-Gm-Message-State: AOJu0Yxwk3yeR5Mi5An/FjGNEF66Ii+6yytUqLBPSZDe2xUi1I7ar/Ij
        fjuEDwpm5uSaGUOcZfGjT10KqitCcP2GEMaE5P4cxA==
X-Google-Smtp-Source: AGHT+IG26i/8A4ihuw5NbTHDvZmpCMZLLOmERpUhBmwhch4uD0C92g4aCugoqIVCKfjauGPEYBkrCMbd+Gox/37XexA=
X-Received: by 2002:ac8:7e94:0:b0:410:8cbf:61de with SMTP id
 w20-20020ac87e94000000b004108cbf61demr46213qtj.13.1692916666850; Thu, 24 Aug
 2023 15:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230821225859.883120-1-srutherford@google.com> <23cfdd53-597e-45c3-9bd1-dbb1be506137@amd.com>
In-Reply-To: <23cfdd53-597e-45c3-9bd1-dbb1be506137@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 24 Aug 2023 15:37:08 -0700
Message-ID: <CABayD+cQ3+34uJ+gO5t5BTL-FYmFt_q-uq7VVLJePww+v8XErQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/sev: Make enc_dec_hypercall() accept a size
 instead of npages
To:     "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, thomas.lendacky@amd.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reuploading v3 with `Cc: stable@vger.kernel.org`.


On Thu, Aug 24, 2023 at 2:04=E2=80=AFAM Gupta, Pankaj <pankaj.gupta@amd.com=
> wrote:
>
> On 8/22/2023 12:58 AM, Steve Rutherford wrote:
> > enc_dec_hypercall() accepted a page count instead of a size, which
> > forced its callers to round up. As a result, non-page aligned
> > vaddrs caused pages to be spuriously marked as decrypted via the
> > encryption status hypercall, which in turn caused consistent
> > corruption of pages during live migration. Live migration requires
> > accurate encryption status information to avoid migrating pages
> > from the wrong perspective.
> >
> > Fixes: 064ce6c550a0 ("mm: x86: Invoke hypercall when page encryption st=
atus is changed")
> > Signed-off-by: Steve Rutherford <srutherford@google.com>
> > ---
> >   arch/x86/include/asm/mem_encrypt.h |  6 +++---
> >   arch/x86/kernel/kvm.c              |  4 +---
> >   arch/x86/mm/mem_encrypt_amd.c      | 13 ++++++-------
> >   3 files changed, 10 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/=
mem_encrypt.h
> > index 7f97a8a97e24..473b16d73b47 100644
> > --- a/arch/x86/include/asm/mem_encrypt.h
> > +++ b/arch/x86/include/asm/mem_encrypt.h
> > @@ -50,8 +50,8 @@ void __init sme_enable(struct boot_params *bp);
> >
> >   int __init early_set_memory_decrypted(unsigned long vaddr, unsigned l=
ong size);
> >   int __init early_set_memory_encrypted(unsigned long vaddr, unsigned l=
ong size);
> > -void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int n=
pages,
> > -                                         bool enc);
> > +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr,
> > +                                         unsigned long size, bool enc)=
;
> >
> >   void __init mem_encrypt_free_decrypted_mem(void);
> >
> > @@ -85,7 +85,7 @@ early_set_memory_decrypted(unsigned long vaddr, unsig=
ned long size) { return 0;
> >   static inline int __init
> >   early_set_memory_encrypted(unsigned long vaddr, unsigned long size) {=
 return 0; }
> >   static inline void __init
> > -early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool =
enc) {}
> > +early_set_mem_enc_dec_hypercall(unsigned long vaddr, unsigned long siz=
e, bool enc) {}
> >
> >   static inline void mem_encrypt_free_decrypted_mem(void) { }
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 6a36db4f79fd..b8ab9ee5896c 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -966,10 +966,8 @@ static void __init kvm_init_platform(void)
> >                * Ensure that _bss_decrypted section is marked as decryp=
ted in the
> >                * shared pages list.
> >                */
> > -             nr_pages =3D DIV_ROUND_UP(__end_bss_decrypted - __start_b=
ss_decrypted,
> > -                                     PAGE_SIZE);
> >               early_set_mem_enc_dec_hypercall((unsigned long)__start_bs=
s_decrypted,
> > -                                             nr_pages, 0);
> > +                                             __end_bss_decrypted - __s=
tart_bss_decrypted, 0);
> >
> >               /*
> >                * If not booted using EFI, enable Live migration support=
.
> > diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_am=
d.c
> > index 54bbd5163e8d..6faea41e99b6 100644
> > --- a/arch/x86/mm/mem_encrypt_amd.c
> > +++ b/arch/x86/mm/mem_encrypt_amd.c
> > @@ -288,11 +288,10 @@ static bool amd_enc_cache_flush_required(void)
> >       return !cpu_feature_enabled(X86_FEATURE_SME_COHERENT);
> >   }
> >
> > -static void enc_dec_hypercall(unsigned long vaddr, int npages, bool en=
c)
> > +static void enc_dec_hypercall(unsigned long vaddr, unsigned long size,=
 bool enc)
> >   {
> >   #ifdef CONFIG_PARAVIRT
> > -     unsigned long sz =3D npages << PAGE_SHIFT;
> > -     unsigned long vaddr_end =3D vaddr + sz;
> > +     unsigned long vaddr_end =3D vaddr + size;
> >
> >       while (vaddr < vaddr_end) {
> >               int psize, pmask, level;
> > @@ -342,7 +341,7 @@ static bool amd_enc_status_change_finish(unsigned l=
ong vaddr, int npages, bool e
> >               snp_set_memory_private(vaddr, npages);
> >
> >       if (!cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
> > -             enc_dec_hypercall(vaddr, npages, enc);
> > +             enc_dec_hypercall(vaddr, npages << PAGE_SHIFT, enc);
> >
> >       return true;
> >   }
> > @@ -466,7 +465,7 @@ static int __init early_set_memory_enc_dec(unsigned=
 long vaddr,
> >
> >       ret =3D 0;
> >
> > -     early_set_mem_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_S=
HIFT, enc);
> > +     early_set_mem_enc_dec_hypercall(start, size, enc);
> >   out:
> >       __flush_tlb_all();
> >       return ret;
> > @@ -482,9 +481,9 @@ int __init early_set_memory_encrypted(unsigned long=
 vaddr, unsigned long size)
> >       return early_set_memory_enc_dec(vaddr, size, true);
> >   }
> >
> > -void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int n=
pages, bool enc)
> > +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, unsig=
ned long size, bool enc)
> >   {
> > -     enc_dec_hypercall(vaddr, npages, enc);
> > +     enc_dec_hypercall(vaddr, size, enc);
> >   }
> >
> >   void __init sme_early_init(void)
>
> Also had this thought to avoid passing the page boundaries calculation
> with npages in-place of existing size based, but no strong opinions.
>
> This seems even better. Thanks!
>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
