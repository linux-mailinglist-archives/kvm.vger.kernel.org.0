Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D444F4E4934
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 23:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiCVWfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 18:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiCVWfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 18:35:16 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC23DF66
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:33:47 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id q14so12625897ljc.12
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S07AH0WG+avsPfFFCXY8ruiMhMyQ+txMHAKVZKwWZ2A=;
        b=Ng0nwZCHfZEOXPG+X8Pkkd1bBwYRJci6byKPVfO8KwVkFPEmh4d6JEu5kno4ppdDfb
         1RQSt98sr3n340+L4uIAp5gai8+EKW8VSgLRq3Dh0UnGflkTkuZ2sZc47297Pho+UquI
         kXDnPv+NeMCyPS0UhLu8H5+rWGv5jergWXzAgvq9C4KnJIY5Nc0yRUGQHGoJuSbQnUUe
         v/xhLLAGJhkGOVEar3pyS9crtf+PN7vJkCqTXvtyLTXVaVAe9Mmj+aVrqLsszya2DOva
         9mbVAhG8k75adaPiEGB198YWR+wIZIt/EDNNOdGBCY6odjFtePaKWLY/j2kg5fDdiOPR
         99Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S07AH0WG+avsPfFFCXY8ruiMhMyQ+txMHAKVZKwWZ2A=;
        b=Ln+kz4MxN6rMPdkMhSOmF/vhvYFhk0wvdhyNLpBcXSGRMEGTnFY5/O6SNCMDzEln+o
         xtW+4WG2RFSa6Y2zyOCpAAmY424Q02NfsFjmlRTkgchLoqECb3lyd3X/Zi5FfQltKYqe
         wQHSUWnC6hZ3Vl5XP4WWFngoo3S2g5ZyNe8glVu7TkYT4hrIG1K0v1tZwSaOL+Hq9U0I
         /Ay/ICSNAzNz8lHp3UHLoFq0537Mzc3MyhDLMnT8uXzLXSG6phbboDvjj8aUkIhjFfwB
         +s2+40eInE3ZXIuEc87Fy82DCiXD1Y0ZFZzcT9V/u8J0yM8G7SjHo5QdlCjMpAg++n61
         4+iA==
X-Gm-Message-State: AOAM532qF87+RF6ar/A6fZqXhtSiP+nDeKr9uLG3uLmEkKqF+vSQo2Yv
        PoTfFEh+43Dv2rqspw9+dqlcWfhIRVU46Pu1ESuwCA==
X-Google-Smtp-Source: ABdhPJworeA778z1gBXZTTzxjh4xsrDQFhXkFHaqJJL/0AKV8N60E1I4tQX6QbLoILy+wNmtvlVaubKG+aPV7dB41VU=
X-Received: by 2002:a2e:9119:0:b0:247:e306:1379 with SMTP id
 m25-20020a2e9119000000b00247e3061379mr20396060ljg.361.1647988425050; Tue, 22
 Mar 2022 15:33:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-11-dmatlack@google.com>
 <YjBo9iuSBm1hbqXz@xz-m1.local>
In-Reply-To: <YjBo9iuSBm1hbqXz@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Mar 2022 15:33:18 -0700
Message-ID: <CALzav=fPeXcKbrdguPKBt13awjPt3+3AB_2hBWo_M9U9sKinWw@mail.gmail.com>
Subject: Re: [PATCH v2 10/26] KVM: x86/mmu: Use common code to free
 kvm_mmu_page structs
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 3:23 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:12AM +0000, David Matlack wrote:
> >  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
> >  {
> > -     free_page((unsigned long)sp->spt);
> > -     kmem_cache_free(mmu_page_header_cache, sp);
> > +     kvm_mmu_free_shadow_page(sp);
> >  }
>
> Perhaps tdp_mmu_free_sp() can be dropped altogether with this?

It certainly can but I prefer to keep it for 2 reasons:
 - Smaller diff.
 - It mirrors tdp_mmu_alloc_sp(), which I prefer to keep as well but
I'll explain that in the next patch.

>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> --
> Peter Xu
>
