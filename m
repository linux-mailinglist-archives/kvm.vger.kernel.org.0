Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E581D4EC684
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 16:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346834AbiC3OaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 10:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343900AbiC3OaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 10:30:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D8B0205BD0
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 07:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648650497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0MdzdhvbcfTH7B0x9nhddVD3XG1EagzEGRM2HvvMoaM=;
        b=URkSKNdrjdGvwpy+7NhX/C2hgs298shyXZ1qiTMwEoKzUTpc5vFGUSmW6+Pl5Bx+QTGSwc
        C0MCHhfzu79GFwJLKwsx2beB7hsnmLnnXn2q60CokUrXTKgkbQiLqP+2w2/LSTH75JuGEd
        tAJmfghaPXFaR+L8dSjVo4q/NIcxhm8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-EsA0cQqVPUyta1QYRAgifQ-1; Wed, 30 Mar 2022 10:28:13 -0400
X-MC-Unique: EsA0cQqVPUyta1QYRAgifQ-1
Received: by mail-qk1-f197.google.com with SMTP id c19-20020a05620a0cf300b005f17891c015so12622400qkj.18
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 07:28:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0MdzdhvbcfTH7B0x9nhddVD3XG1EagzEGRM2HvvMoaM=;
        b=YIuBtmyY/jpwy3RJs8fQPBjP+fw2kN2cQ8vDvkXffvI9f9Q+ZPquJiuWJ5wawFdT4a
         AYObGWvgGuQoA0XPTvZ9bRn+NN15Tz/d+RFFQRguyLcVqz3K52Mpb+QHSBopiO4JjaSI
         62tjFFgXjc4/kpskcdg7tYJdyLrmBOmbRTxcBu7WVTh2Hu8V7JWXUcd0pRsBip21PVp/
         cSIW31EczpRG0q51OeHsveDB6NwH1PjWLJyL+Uba64CmKE7I2NUm/ot08BMrA07WE/zZ
         FquFlA/XD4+75z2RrA3OHbhrF8w7e95aO1Qkn5IofT4EvdYs8SMIssx88PPl6vve4Q5+
         u1JA==
X-Gm-Message-State: AOAM5304xqn4/+ud4UUaYvV/LdAjUav3JdZNVCbQr/d3jEWO63z0WTf2
        /lx28AyMRgr97Y20Tpc6Enyux9H3ppVJnO+7CmQ40BjQ7sh6+HHuEB6IXCn2T2+t4NOVe8aE05d
        fBsxxupm4nSqT
X-Received: by 2002:ac8:580d:0:b0:2e1:c641:8c21 with SMTP id g13-20020ac8580d000000b002e1c6418c21mr32693445qtg.677.1648650492836;
        Wed, 30 Mar 2022 07:28:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxj9mfWzYsrvAU4I7K8iuYgWUFquDhfKr86ywKhvihB398kljxjsCy0kviStlHnrVX/SZQbLA==
X-Received: by 2002:ac8:580d:0:b0:2e1:c641:8c21 with SMTP id g13-20020ac8580d000000b002e1c6418c21mr32693412qtg.677.1648650492602;
        Wed, 30 Mar 2022 07:28:12 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id d12-20020a05620a158c00b00648ec3fcbdfsm10572195qkk.72.2022.03.30.07.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 07:28:12 -0700 (PDT)
Date:   Wed, 30 Mar 2022 10:28:10 -0400
From:   Peter Xu <peterx@redhat.com>
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
Subject: Re: [PATCH v2 05/26] KVM: x86/mmu: Rename shadow MMU functions that
 deal with shadow pages
Message-ID: <YkRo+rJwYJoOmXmW@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-6-dmatlack@google.com>
 <YjBTtz6wo/zQEHCv@xz-m1.local>
 <CALzav=c0ccztDULiVMwR4K20iYc0WH53ApeOCorhjKwaMNL5Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=c0ccztDULiVMwR4K20iYc0WH53ApeOCorhjKwaMNL5Sg@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 02:35:25PM -0700, David Matlack wrote:
> On Tue, Mar 15, 2022 at 1:52 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Fri, Mar 11, 2022 at 12:25:07AM +0000, David Matlack wrote:
> > > Rename 3 functions:
> > >
> > >   kvm_mmu_get_page()   -> kvm_mmu_get_shadow_page()
> > >   kvm_mmu_alloc_page() -> kvm_mmu_alloc_shadow_page()
> > >   kvm_mmu_free_page()  -> kvm_mmu_free_shadow_page()
> > >
> > > This change makes it clear that these functions deal with shadow pages
> > > rather than struct pages. Prefer "shadow_page" over the shorter "sp"
> > > since these are core routines.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> >
> > Acked-by: Peter Xu <peterx@redhat.com>
> 
> What's the reason to use Acked-by for this patch but Reviewed-by for others?

A weak version of r-b?  I normally don't do the rename when necessary (and
I'm pretty poor at naming..), in this case I don't have a strong opinion.
I should have left nothing then it's less confusing. :)

-- 
Peter Xu

