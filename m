Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11504E4932
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 23:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbiCVWcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 18:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiCVWcL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 18:32:11 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BEC4C439
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:30:42 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id q5so25872737ljb.11
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6C0VjdCibQefdFArpO2DUnsXQA3a5kOhFYGWARoK0ng=;
        b=MtxBqgU4fKDJGR32yDNgrmZJHVZ9bb2nYLZL1tpRrFZwetiJIn2bt+LK4GS5a9FE5z
         VSPQClN4wmv6t2ZS3+SThHgq+PTzoGZq9WwphTds4WaaDJdV9wLjRQpgZHXFo04LFK45
         DbaKwmn1MdC1W7oub9gJLVmt5D8P4MEz1fP9/LgQ/6jSqje2aE9tMYh2pUN8eBLuP7qB
         udL4gP5YkOBOuV/Q88HWPp0T5BcfMPOLoR6L4dUQPfvZn57wp9e+uFder/QNBPdTndt+
         VeiKQCAW7TVguWPR+wPjehqbqxcuqPr3qQWGhkmcTKwqPIpCQL2ZKGEShVUUNvzQVTAa
         ri3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6C0VjdCibQefdFArpO2DUnsXQA3a5kOhFYGWARoK0ng=;
        b=JGvzKQDdNB6YmuvNqvcqSlNaZwjjTx9cXyRYQ/TkVOFl8snIOp8Z+WLM/0iDGb35oy
         OwDWl4qAarjskURoFbHn1ROjz1gWTDYQDEgIrVVblttOj/ODH/ZlFby/0Kh5SqQ4Ruqa
         CF5QM2dhmrgk2EBiZAI0hQaEfFgpaCR+wXfHIEEOGboi/8RWek02ZsM14CkdukgGC0ii
         pow8OBoYg1PB9qrgwBXdI/3lx/bjtkIUEBaVOQ5WLFJ7xLYcthBVWVkSH3qXLbB/G/L6
         UDypA7zk8RQRmS8jRb0LXLVX/FkRoZGwzkX6kTDPlkZzaP7QXydHyK79pQuE2hv9eb6M
         pXTQ==
X-Gm-Message-State: AOAM5322EXAR4Wo7+adbAseOvYzcy5o7pFKeUI8M5xzRsZ/ZZa/UZav+
        9NgMNZJWO8rvoTxtsOG8cd9R2qT+MJyXEad32a+Gkw==
X-Google-Smtp-Source: ABdhPJzVn7Ue1RCjw9fF5Wh1a2QmXc4MY9QvN0TqD0+X9MMkibqMAaH0yMU5CoBRsExNt7Oq9j3MqODGm4HDDa8jxEw=
X-Received: by 2002:a2e:9119:0:b0:247:e306:1379 with SMTP id
 m25-20020a2e9119000000b00247e3061379mr20387823ljg.361.1647988240437; Tue, 22
 Mar 2022 15:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-9-dmatlack@google.com>
 <YjBkm8mYKNc5sdpU@xz-m1.local>
In-Reply-To: <YjBkm8mYKNc5sdpU@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Mar 2022 15:30:14 -0700
Message-ID: <CALzav=d82wAqcLQdGOfS7r95SSG3g=yKcY1hRc3fziZfNSHpzg@mail.gmail.com>
Subject: Re: [PATCH v2 08/26] KVM: x86/mmu: Link spt to sp during allocation
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

On Tue, Mar 15, 2022 at 3:04 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:10AM +0000, David Matlack wrote:
> > Link the shadow page table to the sp (via set_page_private()) during
> > allocation rather than initialization. This is a more logical place to
> > do it because allocation time is also where we do the reverse link
> > (setting sp->spt).
> >
> > This creates one extra call to set_page_private(), but having multiple
> > calls to set_page_private() is unavoidable anyway. We either do
> > set_page_private() during allocation, which requires 1 per allocation
> > function, or we do it during initialization, which requires 1 per
> > initialization function.
> >
> > No functional change intended.
> >
> > Suggested-by: Ben Gardon <bgardon@google.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Ah I should have read one more patch before commenting in previous one..
>
> Personally I (a little bit) like the other way around, since if with this
> in mind ideally we should also keep the use_mmu_page accounting in
> allocation helper:
>
>   kvm_mod_used_mmu_pages(vcpu->kvm, 1);

The TDP MMU doesn't call kvm_mod_used_mmu_pages() when it allocates
SPs. So that would prevent sharing kvm_mmu_alloc_shadow_page() with
the TDP MMU in patch 11.

Ben pointed out that we link the the page to sp->spt during
allocation, so it makes sense to do the reverse link at the same time.
Also, the set_page_private() call is common between the TDP MMU and
shadow MMU, so it makes sense to do it in the SP allocation code since
the allocation functions are shared between the two MMUs.





>
> But then we dup yet another line to all elsewheres as long as sp allocated.
>
> IOW, in my opinion the helpers should service 1st on code deduplications
> rather than else.  No strong opinion though..



>
> Thanks,
>
> --
> Peter Xu
>
