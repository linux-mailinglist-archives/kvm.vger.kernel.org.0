Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89664EC67C
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 16:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbiC3O1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 10:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbiC3O1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 10:27:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 840B22FE5F
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 07:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648650353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zvLJ8hpn4uLcUl3yh6ObtYr+cK026HnJjPhO9peO7nY=;
        b=cJzamLumouYUBvlLsAolXa6qZr6Q695KQaX9HD0UMGwfusCBxmT13AcBkJu9PG3Whshld5
        fchw4zhEKZMgD+j9PQ9F4Jp61e6sroYVg4dm/Ghkk4yT+8GMJB3kFw6dau1o8z+q5oADyd
        qoAgsxkc3m6oNQNN8aAZw+mZrn5E0uw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-3Lsjl1tvMlS3fIhB7ajVQQ-1; Wed, 30 Mar 2022 10:25:52 -0400
X-MC-Unique: 3Lsjl1tvMlS3fIhB7ajVQQ-1
Received: by mail-qt1-f198.google.com with SMTP id h11-20020a05622a170b00b002e0769b9018so17529428qtk.14
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 07:25:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zvLJ8hpn4uLcUl3yh6ObtYr+cK026HnJjPhO9peO7nY=;
        b=VnQiJ725+0Y+OHPS10j88EU8/ewqaa6KhXjFYqhdKjittubqUsmBs/rcM3AFHyW6nj
         8owzoWxuFuKI6swzO6Vd7Z+Enfbl5CdbjyBYqVP0DbEPvd2dnj8zES/IqVfi/vUMBox8
         gXZ4dsDoLeA52lVewPw3hQHmjoJaJt8Ai3DzPQdOQrxBkuj7OcyL7Vrq6ejh0X3MMmt7
         3MaDIMOo1BrOigOZ01jkeCe4JtbKynZrZBg0Hctg0iuTnSFvhEzTyrUCg9nF4xs6nsr8
         q1l02ZpEaGdExoXX/s0Y7CRYEic1VCER48zfrvwyC1/ZAWTS8qpyI19Zbe2C67cvT94V
         0xYw==
X-Gm-Message-State: AOAM530HupwkyuqxX9/5hw7is37jlgktwzs7LYQUUlAqP8KzLnE602/E
        KIO3VGaLkp5DLahdhqj9fh6DZJY8PbZ1fH7vYdkkOKubxTWFZ/y4NeZhJ195eJ3YElFlcc6BCzs
        JfZiOo32QCKmp
X-Received: by 2002:a05:620a:d8b:b0:67b:1371:1796 with SMTP id q11-20020a05620a0d8b00b0067b13711796mr23958838qkl.415.1648650351526;
        Wed, 30 Mar 2022 07:25:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/r6U4mfqyrEs1oP/UnFbQv8EJ+XyurLMqYNaOVonYcHLEFbhhLYUdoEZC2YnVcD0Y5xCzUQ==
X-Received: by 2002:a05:620a:d8b:b0:67b:1371:1796 with SMTP id q11-20020a05620a0d8b00b0067b13711796mr23958817qkl.415.1648650351226;
        Wed, 30 Mar 2022 07:25:51 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id f34-20020a05622a1a2200b002e1a35ed1desm18226730qtb.94.2022.03.30.07.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 07:25:50 -0700 (PDT)
Date:   Wed, 30 Mar 2022 10:25:49 -0400
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
Subject: Re: [PATCH v2 03/26] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Message-ID: <YkRobUbpk1bM2zBQ@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-4-dmatlack@google.com>
 <YjBLFZWtdfwhNosG@xz-m1.local>
 <CALzav=dAW999FKid08Ry0YxPA+3Dt8HERrbn6YMkAnk0h+4h_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=dAW999FKid08Ry0YxPA+3Dt8HERrbn6YMkAnk0h+4h_A@mail.gmail.com>
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

On Tue, Mar 22, 2022 at 11:30:07AM -0700, David Matlack wrote:
> > > +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> > > +{
> > > +     struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> > > +     union kvm_mmu_page_role role;
> > > +
> > > +     role = parent_sp->role;
> > > +     role.level--;
> > > +     role.access = access;
> > > +     role.direct = direct;
> > > +
> > > +     /*
> > > +      * If the guest has 4-byte PTEs then that means it's using 32-bit,
> > > +      * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> > > +      * directories, each mapping 1/4 of the guest's linear address space
> > > +      * (1GiB). The shadow pages for those 4 page directories are
> > > +      * pre-allocated and assigned a separate quadrant in their role.
> > > +      *
> > > +      * Since we are allocating a child shadow page and there are only 2
> > > +      * levels, this must be a PG_LEVEL_4K shadow page. Here the quadrant
> > > +      * will either be 0 or 1 because it maps 1/2 of the address space mapped
> > > +      * by the guest's PG_LEVEL_4K page table (or 4MiB huge page) that it
> > > +      * is shadowing. In this case, the quadrant can be derived by the index
> > > +      * of the SPTE that points to the new child shadow page in the page
> > > +      * directory (parent_sp). Specifically, every 2 SPTEs in parent_sp
> > > +      * shadow one half of a guest's page table (or 4MiB huge page) so the
> > > +      * quadrant is just the parity of the index of the SPTE.
> > > +      */
> > > +     if (role.has_4_byte_gpte) {
> > > +             BUG_ON(role.level != PG_LEVEL_4K);
> > > +             role.quadrant = (sptep - parent_sp->spt) % 2;
> > > +     }
> >
> > This made me wonder whether role.quadrant can be dropped, because it seems
> > it can be calculated out of the box with has_4_byte_gpte, level and spte
> > offset.  I could have missed something, though..
> 
> I think you're right that we could compute it on-the-fly. But it'd be
> non-trivial to remove since it's currently used to ensure the sp->role
> and sp->gfn uniquely identifies each shadow page (e.g. when checking
> for collisions in the mmu_page_hash).

Makes sense.

-- 
Peter Xu

