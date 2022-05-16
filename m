Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B051527DEC
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 08:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240583AbiEPGzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 02:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240581AbiEPGzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 02:55:09 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42E9366B5;
        Sun, 15 May 2022 23:55:07 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id e78so4304874ybc.12;
        Sun, 15 May 2022 23:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1dK2edFTU6ZA396mt6VL7asKfbqNWslhLCJG//w22WE=;
        b=WVYfP4NvxnHADNi+hRg6j3xIW9SSgkwiYdcc4w4LkOcObEbK4djJuGbyRgSNXfqRUc
         /OpAOGbxuX0XJVU+FZAjYzt6GgK2Z+C0SZukTADGxR5J3mtX3I5HAItHwW8nzVi6yVay
         HO+mhZ0KkyMX4E6/xxDVv1j6XmvTBkZT8N2qrsYsG7VZd30ddAmcKTEEj1X/ekScfmpI
         E1Ep5yaon/rUT9cGuvuGaHRt+iBlFR1trUiR46MoJ4KR+qtTNUlRRJ4IwqRPhW114le9
         DMvywKUWPGHv1WSyDW+cMm+0w2JQO+XgUC1uuhm5N/9Lmnaumrt3JJMYnTvjeMSP7ciz
         o5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1dK2edFTU6ZA396mt6VL7asKfbqNWslhLCJG//w22WE=;
        b=7MicOJmpdDTHqAB27PY9Asr0QRToOD2yUMx55i1sDFXFfGk3a6BpFpkKfeYYD2zTqb
         /e9MtMaW6OLH7x+r5hAsUd7jLUFCQWvtICHNF44zcstLyXbGWa1kmiY1jKiGue0Jey76
         krGc1m6/gbmiM5qIKyYLBLwj5GP0fUzX7UkiO51xM2S7/Vo8kTt8v5oGU0Hvd0WJUyK8
         XvJBC0xDzhY6f+br1gBwZDnJxxJftUk7PLz69x2vJq178kBxuf3LFH9IOVw2HeHnVh7R
         Gu3alvA3/hZSepV4iQEnndjF5P/wVubCTfy+ve/C34gigDvoSQsdMV9L3yURbhmODpSd
         cMjQ==
X-Gm-Message-State: AOAM530Gzqv5QzyogCffv5nqEY2SfhAhcKO/s5ETmuCFRw40g750S49e
        aopTWZg+mkbfDkHrfINOLbGkVct1rxTa1uMMqM4=
X-Google-Smtp-Source: ABdhPJzocFzE5rLFilLG6+T+z0h5XBshtuxJ3zJwJJbakycdvZGhiUOe/2JYCMFm7TDfi4FBy+rA24Yx8TOKnCEWpQ0=
X-Received: by 2002:a25:cf42:0:b0:64d:8800:ade3 with SMTP id
 f63-20020a25cf42000000b0064d8800ade3mr5478053ybg.376.1652684107021; Sun, 15
 May 2022 23:55:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com> <20220513202819.829591-4-dmatlack@google.com>
In-Reply-To: <20220513202819.829591-4-dmatlack@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Mon, 16 May 2022 14:54:55 +0800
Message-ID: <CAJhGHyAU_5Esn6i-eeBNKOh4XenOc9_1aiF8N0+CeMF5yyhxew@mail.gmail.com>
Subject: Re: [PATCH v5 03/21] KVM: x86/mmu: Derive shadow MMU page role from parent
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
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

On Sat, May 14, 2022 at 4:28 AM David Matlack <dmatlack@google.com> wrote:

> -static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
> +static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
>                             u8 level, bool direct)
>  {
> +       union kvm_mmu_page_role role;
>         struct kvm_mmu_page *sp;
>
> -       sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
> +       role = vcpu->arch.mmu->root_role;
> +       role.level = level;
> +       role.direct = direct;
> +       role.access = ACC_ALL;
> +
> +       if (role.has_4_byte_gpte)
> +               role.quadrant = quadrant;
> +
> +       if (level <= vcpu->arch.mmu->cpu_role.base.level)
> +               role.passthrough = 0;
> +



+       role.level = level;
+
+       if (role.has_4_byte_gpte)
+               role.quadrant = quadrant;

Only these lines are needed because of mmu->pae_root, others are
the same as vcpu->arch.mmu->root_role.

The argument @direct is vcpu->arch.mmu->root_role.direct.
vcpu->arch.mmu->root_role.access is always set to be ACC_ALL.

vcpu->arch.mmu->root_role.passthrough is 0 when mmu->pae_root is used.
Or if vcpu->arch.mmu->root_role.passthrough is 1, @level must be 5
and vcpu->arch.mmu->cpu_role.base.level must be 4, the code here
is useless.
