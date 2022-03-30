Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B627F4EC905
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 18:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348514AbiC3QDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 12:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348497AbiC3QDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 12:03:10 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25B1593B6;
        Wed, 30 Mar 2022 09:01:24 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2e5e9025c20so224445667b3.7;
        Wed, 30 Mar 2022 09:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kjZketVP9CFkspy1PCl99/PtzZngJWwIzjlL5Zl64m0=;
        b=n1FphQ40TOVvrDwgCRv9ZKYtjg1Pg2dsYmXFyUPdaRqirnSzRi2WzoqjjNPwajEZlv
         ecDpkUjaXQuRrfNMThba/BUeePs1cwMbdNILgCbAdunjosL5oxqIbWc16WuZUZhrjGnT
         zRJ+5+5yl1k03MewnrDpaGatwBhdFD6AISoRmmey8/tS6cTIi/7N349FreaYkDzP1hR9
         D3j8wpneeHZ9cOYVBEf20MqD3Dng+CLh6jZ5buQn/uls4p6EbWGfknkc6k/Ue5tG7dqK
         j03AYd0TbpNaUNHKCScJcA/pNQKqwILlkZ56DphYyG87xw5Jl8nf6TBejVaaEEqbmRER
         x4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kjZketVP9CFkspy1PCl99/PtzZngJWwIzjlL5Zl64m0=;
        b=c9lzT5KB8ji7GHNsmuMiGlzh5snmeBhzVWyAAU/d5K/ahTWqUEPSXb6DE5YUdBPoix
         qN9gC94BFjZTdSVMO3z9KgVxanJFjiQLBDCr/63GiGXRdZsAjIxPb6WFfKB7HZMOHSh7
         kDbQVPxl5brs1ApnePrFyHwBmFogcdLyDdwvfjQNLzSPxe6k2QEEYyezjozTkWhpmz99
         r03dYeaTfrS0nm3s6KJO2lKjXsxjRSNER8zJugj5Ap8LfgfNaZ3ySbmixa6zylBM8dvL
         VdUKdS4npy9VUShYkv+6X2VwJGzX+2rFFG3SozWVxSRkVtGLwyxvcNSSzukzY/YjzH7t
         SbaA==
X-Gm-Message-State: AOAM5301wmH6W6UXPt3Hkb8avnAqwsz3jX9VssWQ1QGcsXtXgSc4afvu
        JeKtg8Aa2n3rr8MsGy1zdC/OcJ8+2lfOnUt1DI0i3SRQpNM=
X-Google-Smtp-Source: ABdhPJwXtdByR/9hUinxGFuk8X+7vugCI3mUN2zADV8B2V9ek2t+ILN5fwvIBlxq3GlpTIjvTeXltjGHjTGpmvFteaM=
X-Received: by 2002:a81:7983:0:b0:2e5:9d0a:1c52 with SMTP id
 u125-20020a817983000000b002e59d0a1c52mr269047ywc.411.1648656083991; Wed, 30
 Mar 2022 09:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220330132152.4568-1-jiangshanlai@gmail.com> <20220330132152.4568-3-jiangshanlai@gmail.com>
In-Reply-To: <20220330132152.4568-3-jiangshanlai@gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 31 Mar 2022 00:01:12 +0800
Message-ID: <CAJhGHyBajHJ8hDy--7mofH=25Ji6L2+jUvfZ1oTQ2gcqqupyFA@mail.gmail.com>
Subject: Re: [RFC PATCH V3 2/4] KVM: X86: Introduce role.glevel for level
 expanded pagetable
To:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022 at 9:21 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:

> @@ -1713,7 +1721,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>
>         sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
>         sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> -       if (!role.direct)
> +       if (role.glevel == role.level)
>                 sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
>         set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>
> @@ -2054,6 +2062,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>                 quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
>                 role.quadrant = quadrant;
>         }
> +       if (level < role.glevel)
> +               role.glevel = level;

missing:

if (direct)
   role.glevel = 0;

>
>         sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>         for_each_valid_sp(vcpu->kvm, sp, sp_list) {
