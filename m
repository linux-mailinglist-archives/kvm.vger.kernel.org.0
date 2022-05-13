Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182FF525E0A
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 11:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347289AbiEMIyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 04:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344569AbiEMIyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 04:54:36 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183882B09D4;
        Fri, 13 May 2022 01:54:34 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id i38so14123025ybj.13;
        Fri, 13 May 2022 01:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nOLcuBx81l3T4akJ0OxMVdpq9MkOLHyLkjcSUt3VELs=;
        b=D6xPM6wQ7LbuBMKZwulpmITdzxO1wq9SYBVgycLpxFBm9iCGPStRJ2Mesmnb0HgOYz
         re/WmnImOZFr2VPThcsAWFxr+2VdMbRe/8C6yjnMxya+olpVal+bE11Vkar3WBWGy0LE
         WNcXJeSxDuG7TRxar6Stg8+6JIYwSVBjuW8coCqn3Ym+xBj5DvKmmgYPyqT/JnEw48yj
         BOba6JKhxaHRhRH393iYsmVCYQ85nTrIi7ieZhXB9ByRLjRAQF1MKJv76yTmjNswNd2g
         TPLyGmkTDEdS0EwReMPNS1/0xBkCDOszsbGg+W69oyT1eAFdBoxzMKf9VNPHZiTCTH+S
         G0tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nOLcuBx81l3T4akJ0OxMVdpq9MkOLHyLkjcSUt3VELs=;
        b=V+b8qB1BvsUjzhxdCzmCkYL+T+HOqEzcDgBPvhZlSDU6hn6SqWEC5dfyOIobLTgFU6
         mlp3/lNHvosZ/J4CPDKDPUlisF38jyXWGs9b6H7Ku3QABs6/WCHr9dJnuV2Vlmr9PDsp
         gH2KkwStpxXK+qyK2i5EWtkI0pXzo8PAD/J0M9X6TEaz6aOg3Ab/Wq834PoOEwZoG40m
         gATvP6C64fbOW/kGtftAY55OHWksedbfUn90lV2VpG/r0RTWN2B/c++n/J80b4ubvp7f
         fh5uoqFsgPTn7gt9IIbGS7c/uMyQF2Q5Rd/PzqWsTbtSBOhsWhaRrOCY3x6LrAfL73Ph
         YxTQ==
X-Gm-Message-State: AOAM5338T0tKbUVZxQxCr8GypehpH4+AV3jNUxdIIvk3n97ko1dswCYM
        pgmZ9dF3Fg1TYkXAPxl6UzjHjPoGmcwbNXTzdfEGS4RU
X-Google-Smtp-Source: ABdhPJwaF5EEXwzWMwLAtDMXczmbVR+72S2p37qXGXhv/X3Jn4qjdIvifguvu6iahBjjE0DvVwkTvUNtrmruBfsa9kQ=
X-Received: by 2002:a5b:81:0:b0:64a:f6d1:dc7f with SMTP id b1-20020a5b0081000000b0064af6d1dc7fmr3791799ybp.352.1652432073258;
 Fri, 13 May 2022 01:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220415103414.86555-1-jiangshanlai@gmail.com>
In-Reply-To: <20220415103414.86555-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 13 May 2022 16:54:21 +0800
Message-ID: <CAJhGHyA2uyu4Tg_1LCaoHzNFeQ3mW3KtaKg-KFkHBeLet99zjw@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86/svm/nested: Cache PDPTEs for nested NPT in PAE
 paging mode
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>
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

On Fri, Apr 15, 2022 at 6:33 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
>
> When NPT enabled L1 is PAE paging, vcpu->arch.mmu->get_pdptrs() which
> is nested_svm_get_tdp_pdptr() reads the guest NPT's PDPTE from memroy
> unconditionally for each call.
>
> The guest PAE root page is not write-protected.
>
> The mmu->get_pdptrs() in FNAME(walk_addr_generic) might get different
> values every time or it is different from the return value of
> mmu->get_pdptrs() in mmu_alloc_shadow_roots().
>
> And it will cause FNAME(fetch) installs the spte in a wrong sp
> or links a sp to a wrong parent since FNAME(gpte_changed) can't
> check these kind of changes.
>
> Cache the PDPTEs and the problem is resolved.  The guest is responsible
> to info the host if its PAE root page is updated which will cause
> nested vmexit and the host updates the cache when next nested run.
>
> The commit e4e517b4be01 ("KVM: MMU: Do not unconditionally read PDPTE
> from guest memory") fixs the same problem for non-nested case.
>
> Fixes: e4e517b4be01 ("KVM: MMU: Do not unconditionally read PDPTE from guest memory")
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Ping
