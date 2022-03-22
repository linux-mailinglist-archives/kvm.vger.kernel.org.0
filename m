Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052B34E45E2
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 19:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbiCVSX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 14:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240253AbiCVSX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 14:23:26 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A71B8D697
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:21:58 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id l20so31144091lfg.12
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WAKfsHYufu3U00AAQ3K6rkkqvblKGp7U0moxttx1nDc=;
        b=g2Mo8JicfcFH/ca4r/k8qwzNmJcqohXhHSc8ZN1vggO+ws0hE9XyigO2hPYcPZWWtk
         wNEza19s0fPDjH5GX8/kKgwDj/AAV9pY4XeHmvC71+6Y6ICWamfbXU6C9YM9stEziAjS
         Pyzvv0cV9b5kaL2Vw0X3sHjwvfQugdxpBZP6WpNszpT8tGNVYT59NDnhX2XhWEiAEB2q
         R6auCiZeG6hXuo36MJY34i1dlEJGkAos2ZUzCMTTS5Ma09OmY4Ad9S5p/J99OkWTba+X
         viy50q5OpxBRGYxh9kdfQAiI1GToU553m9eY93dV6MAHbc4QHm6K6V/UCEWO+8O6FNPA
         Fxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WAKfsHYufu3U00AAQ3K6rkkqvblKGp7U0moxttx1nDc=;
        b=pMVhEGoJJZcyJ9fAuSsEMp6ylIImMF7w6jswRtcNuMevncaSTemJpaPEGluu8PO0Ul
         GAqmp4U7HVrMG7aL3h5sL/6fJXyi6FLax6UB9aIHEKOs1K5zsY9HefagXzWjfcb4qVg2
         yLEa/tsRqWCz9lRC3xVFQiWiU2MghjOD5THS+Vfx7zN3/xbk58BNGJpn85bfaSLdKKrV
         W7Kd1Ik1EFsIBFPEqDEhLOyX1jizS0TQGifuVrEgzh9+CmYvBzpmmyw00k0FMdMNv8UN
         xQRTWs+4CEaL+1V4i91HHIG1F8Ff/4eVTuLG/wQkiTQHpGANyMqszdx6AFmpj09UP1mL
         j+Og==
X-Gm-Message-State: AOAM530VHbY3CMV/sdVq1scCO2QS1MfoVS4XH3CUA4L0gXX3F6y3N/dC
        4BW6T3wKk3fQTqtcVLBGvfz4lv4FGU3oBgJ5X59CUA==
X-Google-Smtp-Source: ABdhPJyrSF1plRNyRh9A7BhcuZu0NWWd/cVBt3Nl5hNQUOvH0RUPVILChyti/fD/O7GaiC+DirE+BwoMtfWc3XC9kZI=
X-Received: by 2002:a05:6512:1114:b0:448:388c:b79f with SMTP id
 l20-20020a056512111400b00448388cb79fmr19109715lfg.250.1647973316603; Tue, 22
 Mar 2022 11:21:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-3-dmatlack@google.com>
 <YjBEWm3YsuSKj+ES@xz-m1.local>
In-Reply-To: <YjBEWm3YsuSKj+ES@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Mar 2022 11:21:30 -0700
Message-ID: <CALzav=cMFL=ZZyV5uckbhb3RqC0LhOnnooiJGKKN26F69TF63A@mail.gmail.com>
Subject: Re: [PATCH v2 02/26] KVM: x86/mmu: Use a bool for direct
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

On Tue, Mar 15, 2022 at 12:46 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:04AM +0000, David Matlack wrote:
> > The parameter "direct" can either be true or false, and all of the
> > callers pass in a bool variable or true/false literal, so just use the
> > type bool.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> If we care about this.. how about convert another one altogether?
>
> TRACE_EVENT(kvm_hv_stimer_expiration,
>         TP_PROTO(int vcpu_id, int timer_index, int direct, int msg_send_result),
>         TP_ARGS(vcpu_id, timer_index, direct, msg_send_result),

My preference would be to keep this commit specific to uses of
"direct" that are related to shadow pages.

The parameter `direct` in trace_kvm_hv_stimer_expiration() looks like
it could be converted as well, but is a different concept altogether
despite having the same variable name.

>
> Thanks,
>
> --
> Peter Xu
>
