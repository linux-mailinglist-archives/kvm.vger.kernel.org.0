Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A0A77D0AF
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238666AbjHORL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238678AbjHORLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:11:17 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D832AE72
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 10:11:15 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-40c72caec5cso17211cf.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 10:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692119475; x=1692724275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VjU1cPGHPErz26GfxK/V2Y6QQnaVBfBoHVJffwhAgeg=;
        b=OkID7iHXzv+hD+tKR8T6YOXxoIXliF3W34NUBxDaFcmljCtGa4UoyiTKJr8D/Tqe60
         twt1hBEnODfYIcEtDbVnm54kA0lIiilXkx9/J9jQrHX5X/XhOJQ7UdJ3uclpwKIqOirD
         Nz+BaBpxqO9GVtg0Nf9FtqfKgA5MSX6L6ZpkqwrGirkV/80R7EjnEy3vAejyJrvzENi/
         tBF0sSeWY68NphfTowZ3duiS82ZwwGD9DYGMlv24ihtwu4rin3c/EbsSxVYNJXnuceR1
         sl4g7UKfuObykb/yzYDT2NhA5VP8HNK+onSuMDL7WMvns54M1ica33zsia1c0sn9ISDX
         ebGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692119475; x=1692724275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VjU1cPGHPErz26GfxK/V2Y6QQnaVBfBoHVJffwhAgeg=;
        b=Wp6bs9XhaKJQiaQ4aK7YBE6VhmIiL50UKSM+kRWr9nHlxc29uBRCIkt1q8pVJIez9M
         X0rR7ZowKylAgUiqO77VtJSOCvKhtgWcKogVFtn4OPXgY0bOGWTVC/vmbFQbIPCnvbie
         Oyso1+DPAciQ9r0wMJVUsv844nTu6jHkQmPTUE410iWYi/q80f1p+g9lOyfVHLEjbSNP
         kpukpzVPypA6QLAM3Zfow0sT/BkKbzbtG+JWMUxk7yLwIcD057JZ2QDUqFTLIcAJO0+n
         CqxsPohI7RTLaz3ppCQxpgZHD/OQ9d+soFoVh8vs7ag08v5ZStw0A5Y+ecdbATPGQUug
         hSGg==
X-Gm-Message-State: AOJu0YyB6x7pxfZV8hOES5okFTQ9OVlsNWZncgFlc5oo4CT8Wr67d7jK
        3H8x0o1sgoDAU8Fp1fFr6vSqpg17FrCMwTJeJtQ6eg==
X-Google-Smtp-Source: AGHT+IHxC6i5qwpObe1eDOWi/Od0g4GRgAk9jzOZ3XKeiC1SDm7VVZDyGLVzpXyK6cSH8wHoFhS6cxSCFQC9A0v0DV0=
X-Received: by 2002:a05:622a:198f:b0:40f:c60d:1c79 with SMTP id
 u15-20020a05622a198f00b0040fc60d1c79mr3382qtc.28.1692119474862; Tue, 15 Aug
 2023 10:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com> <ZNq15SZ+53umvOfx@google.com>
 <CAJHc60wMueazp3Wm=b6-tnFPAyX0zeYuVQe9uPEJrpAm0azw2A@mail.gmail.com> <ZNrMTmppUfQhdsyY@google.com>
In-Reply-To: <ZNrMTmppUfQhdsyY@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 15 Aug 2023 10:11:02 -0700
Message-ID: <CAJHc60yp7X9Za=CJnJWqAbPuKznp91fYtnBOuQQCGtiXyQBqWw@mail.gmail.com>
Subject: Re: [PATCH v9 00/14] KVM: arm64: Add support for FEAT_TLBIRANGE
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023 at 5:52=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Aug 14, 2023, Raghavendra Rao Ananta wrote:
> > On Mon, Aug 14, 2023 at 4:16=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Aug 11, 2023, Raghavendra Rao Ananta wrote:
> > > > The series is based off of upstream v6.5-rc1.
> > >
> > > Lies!  :-)
> > >
> > > This is based off one of the kvmarm.git topic branches (I didn't both=
er to figure
> > > out which one), not v6.5-rc1.
> > >
> > Sorry, what am I missing here? My git log is as follows:
>
> Hmm, not sure what's going on.  Maybe I misinterpreted why `git am` was f=
ailing?
> I assumed it was because there were objects in kvmarm that I didn't have =
locally,
> and fetching kvmarm allowed am to complete, though with 3-way merges, whi=
ch IIUC
> shouldn't have been necessary if I was using the exact same base.  Or may=
be I
> messed up and didn't actually reset to 6.5-rc1.
>
> > $ git log --oneline upstream_tlbi_range_v9
> > 5025857507abe (upstream_tlbi_range_v9) KVM: arm64: Use TLBI
> > range-based instructions for unmap
> > 5c0291b99a8fc KVM: arm64: Invalidate the table entries upon a range
> > 8c46b54d4aaec KVM: arm64: Flush only the memslot after write-protect
> > 231abaeb7ffc2 KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
> > 5ec291b863309 KVM: arm64: Define kvm_tlb_flush_vmid_range()
> > 5bcd7a085c34e KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
> > ea08f9dff7e5b arm64: tlb: Implement __flush_s2_tlb_range_op()
> > b3178687947c9 arm64: tlb: Refactor the core flush algorithm of __flush_=
tlb_range
> > a4850fa988eef KVM: Move kvm_arch_flush_remote_tlbs_memslot() to common =
code
> > 306dc4e6afd37 KVM: Allow range-based TLB invalidation from common code
> > d02785a0a1e01 KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
> > 136fa2d254537 KVM: arm64: Use kvm_arch_flush_remote_tlbs()
> > e35c68a75170d KVM: Declare kvm_arch_flush_remote_tlbs() globally
> > 5d592777b9bba KVM: Rename kvm_arch_flush_remote_tlb() to
> > kvm_arch_flush_remote_tlbs()
> > 06c2afb862f9d (tag: v6.5-rc1, tag: linux/v6.5-rc1) Linux 6.5-rc1
> > c192ac7357683 MAINTAINERS 2: Electric Boogaloo
> > f71f64210d698 Merge tag 'dma-mapping-6.5-2023-07-09' of
> > git://git.infradead.org/users/hch/dma-mapping
> > ...
> >
> > Isn't the commit, 06c2afb862f9d (06c2afb862f9d (tag: v6.5-rc1, tag:
> > linux/v6.5-rc1) Linux 6.5-rc1) the 'base' commit?
>
> Ya, should be.
>
> Either way, even if this is PEBKAC on my end, using --base would be nice,=
 e.g.
> then you can definitely say it's my fault ;-)
>
I'll consider this, and thanks for the confirmation.

- Raghavendra
> > > Please try to incorporate git format-patch's "--base" option into you=
r workflow,
> > > e.g. I do "git format-patch --base=3DHEAD~$nr" where $nr is the numbe=
r of patches
> > > I am posting.
> > >
> > > It's not foolproof, e.g. my approach doesn't help if I have a local p=
atch that
> > > I'm not posting, but 99% of the time it Just Works and eliminates any=
 ambuitity.
> > >
> > > You can also do "--base=3Dauto", but that only does the right thing i=
f your series
> > > has its upstream branch set to the base/tree that you want your patch=
es applied
> > > to (I use the upstream branch for a completely different purpose for =
my dev branches).
