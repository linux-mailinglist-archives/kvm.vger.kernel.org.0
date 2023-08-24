Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F40787BA9
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 00:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243963AbjHXWtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 18:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243964AbjHXWse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 18:48:34 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7BA1BF7
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 15:48:31 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-40c72caec5cso122531cf.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 15:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692917310; x=1693522110; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vb9AfcF55mcoZGPO2dmvc9+6EX0/259C9jrBF6CbU4o=;
        b=JrE8u60dB1+q08qf9STEKBtPPddw8AVaiN5Biq1SOcxcDB6xhDH+oOnhHGGAZ/QRDN
         +NlQdqx10TEw72SSdBzj66XIrV1sLpJCGjS8eGB60Hy/ZKVVcmreSfedkCvbte+PRw3V
         SePlMjrc6+JY4QjjfG1iOk6CMMxn54xgflkZUbSC3Ys2v7reEJ+NnqaOR/M9cELzVZFp
         2DgDaqVBMyhmbUuDLrva8f+kkUSIA1H6tiuQi0qq46YyqG/i/J8mVR9fM9aSTRAyEV3J
         C7Ui23tvA/x5nXXKnrLSMPr2NVSKqNnJ/j9s0gVSItWG4L5R05jahzHxY/Erz7qWYDuY
         jJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917310; x=1693522110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vb9AfcF55mcoZGPO2dmvc9+6EX0/259C9jrBF6CbU4o=;
        b=f5wvlbyy50hLUvyWEtwzKUdK6FF9IO2G+lsbgMeQ3Va1303yW0RGyiMzDI0ZDwtRGT
         8rw3bwhRMsooe/8tAcRcXAqFZBL+62F0KWujPWCkv8qXbyByY983+wuc5LekTfGhV8UQ
         fBwHyqSWATzgb5b7xqn8HoQw6SgCZlxg91Y3t/AIN1FkYF9m/dUw6leT8/II3nLMu6h9
         CkM5TtDhrUVfMRomRANhxLcbKENZQM0/DAtCKHYEQg28oa6VfqU5nH6fFLgUNDBjPKoU
         Yn/KJihfSxH2uKt94YOeNN05Dk/PIBAV8Eq2O0WkBnIfP5GPTOD3zeGMitMqZO91gT0L
         mK5Q==
X-Gm-Message-State: AOJu0YyGtZXOSdxfcTzZ5jCWJ/NE444/GWKATp7O/A8/0+nFrVGRkRMW
        SOGnzn1T6cvlwieqCtcqc21cUYwcrGOx328qd9rt6A==
X-Google-Smtp-Source: AGHT+IGUi2btJyqhZwjI0swl1m7dj321OGKdIIYEKxQYvbRMpMhGCU304BgGWP9IHvXqT69giR0E0fo1t3jC1JH77mg=
X-Received: by 2002:a05:622a:24f:b0:403:b6ff:c0b with SMTP id
 c15-20020a05622a024f00b00403b6ff0c0bmr112968qtx.6.1692917310180; Thu, 24 Aug
 2023 15:48:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230824223731.2055016-1-srutherford@google.com>
In-Reply-To: <20230824223731.2055016-1-srutherford@google.com>
From:   Ben Hillier <bhillier@google.com>
Date:   Thu, 24 Aug 2023 15:48:18 -0700
Message-ID: <CAFn7gfRibD3YCBdXgtHuR0hMzJb+MYBNWHN5h+KJ1wJGzfL1sg@mail.gmail.com>
Subject: Re: [PATCH v3] x86/sev: Make enc_dec_hypercall() accept a size
 instead of npages
To:     Steve Rutherford <srutherford@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, thomas.lendacky@amd.com,
        pankaj.gupta@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 24, 2023 at 3:37=E2=80=AFPM Steve Rutherford <srutherford@googl=
e.com> wrote:
>
> enc_dec_hypercall() accepted a page count instead of a size, which
> forced its callers to round up. As a result, non-page aligned
> vaddrs caused pages to be spuriously marked as decrypted via the
> encryption status hypercall, which in turn caused consistent
> corruption of pages during live migration. Live migration requires
> accurate encryption status information to avoid migrating pages
> from the wrong perspective.
>
> Cc: stable@vger.kernel.org
> Fixes: 064ce6c550a0 ("mm: x86: Invoke hypercall when page encryption stat=
us is changed")
> Signed-off-by: Steve Rutherford <srutherford@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Ran test comparing the c-bit status in the guest page tables to the
host perspective. Before the patch, there was a c-bit status mismatch.
Adding the patch fixed these mismatched c-bits.
Tested-by: Ben Hillier <bhillier@google.com>
> ---
>  arch/x86/include/asm/mem_encrypt.h |  6 +++---
>  arch/x86/kernel/kvm.c              |  4 +---
>  arch/x86/mm/mem_encrypt_amd.c      | 13 ++++++-------
>  3 files changed, 10 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/me=
m_encrypt.h
> index 7f97a8a97e24..473b16d73b47 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -50,8 +50,8 @@ void __init sme_enable(struct boot_params *bp);
>
>  int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long=
 size);
>  int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long=
 size);
> -void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npa=
ges,
> -                                           bool enc);
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr,
> +                                           unsigned long size, bool enc)=
;
>
>  void __init mem_encrypt_free_decrypted_mem(void);
>
> @@ -85,7 +85,7 @@ early_set_memory_decrypted(unsigned long vaddr, unsigne=
d long size) { return 0;
>  static inline int __init
>  early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { re=
turn 0; }
>  static inline void __init
> -early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool en=
c) {}
> +early_set_mem_enc_dec_hypercall(unsigned long vaddr, unsigned long size,=
 bool enc) {}
>
>  static inline void mem_encrypt_free_decrypted_mem(void) { }
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6a36db4f79fd..b8ab9ee5896c 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -966,10 +966,8 @@ static void __init kvm_init_platform(void)
>                  * Ensure that _bss_decrypted section is marked as decryp=
ted in the
>                  * shared pages list.
>                  */
> -               nr_pages =3D DIV_ROUND_UP(__end_bss_decrypted - __start_b=
ss_decrypted,
> -                                       PAGE_SIZE);
>                 early_set_mem_enc_dec_hypercall((unsigned long)__start_bs=
s_decrypted,
> -                                               nr_pages, 0);
> +                                               __end_bss_decrypted - __s=
tart_bss_decrypted, 0);
>
>                 /*
>                  * If not booted using EFI, enable Live migration support=
.
> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.=
c
> index 54bbd5163e8d..6faea41e99b6 100644
> --- a/arch/x86/mm/mem_encrypt_amd.c
> +++ b/arch/x86/mm/mem_encrypt_amd.c
> @@ -288,11 +288,10 @@ static bool amd_enc_cache_flush_required(void)
>         return !cpu_feature_enabled(X86_FEATURE_SME_COHERENT);
>  }
>
> -static void enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
> +static void enc_dec_hypercall(unsigned long vaddr, unsigned long size, b=
ool enc)
>  {
>  #ifdef CONFIG_PARAVIRT
> -       unsigned long sz =3D npages << PAGE_SHIFT;
> -       unsigned long vaddr_end =3D vaddr + sz;
> +       unsigned long vaddr_end =3D vaddr + size;
>
>         while (vaddr < vaddr_end) {
>                 int psize, pmask, level;
> @@ -342,7 +341,7 @@ static bool amd_enc_status_change_finish(unsigned lon=
g vaddr, int npages, bool e
>                 snp_set_memory_private(vaddr, npages);
>
>         if (!cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
> -               enc_dec_hypercall(vaddr, npages, enc);
> +               enc_dec_hypercall(vaddr, npages << PAGE_SHIFT, enc);
>
>         return true;
>  }
> @@ -466,7 +465,7 @@ static int __init early_set_memory_enc_dec(unsigned l=
ong vaddr,
>
>         ret =3D 0;
>
> -       early_set_mem_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_S=
HIFT, enc);
> +       early_set_mem_enc_dec_hypercall(start, size, enc);
>  out:
>         __flush_tlb_all();
>         return ret;
> @@ -482,9 +481,9 @@ int __init early_set_memory_encrypted(unsigned long v=
addr, unsigned long size)
>         return early_set_memory_enc_dec(vaddr, size, true);
>  }
>
> -void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npa=
ges, bool enc)
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, unsigne=
d long size, bool enc)
>  {
> -       enc_dec_hypercall(vaddr, npages, enc);
> +       enc_dec_hypercall(vaddr, size, enc);
>  }
>
>  void __init sme_early_init(void)
> --
> 2.42.0.rc1.204.g551eb34607-goog
>
