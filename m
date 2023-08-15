Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C30477D0B8
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238691AbjHORQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238682AbjHORP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:15:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B0419BF
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 10:15:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c647150c254so11005261276.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 10:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692119754; x=1692724554;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h4pRofXYscuxJwlZlec+kz5JByk1VStjcQk6pNX8VCg=;
        b=0ULGW8lrz4LAfQvUr6zW2RUHxg7wnB8mbW6D5bd2rDtC7t6jWPtR/lVCZvnMtK039v
         Gg8JyKieoo8YzZWKJSwsneurYfUwDhsBEjHR8BDDFIcMNXvxQFl1SY6+8po7yWKtX3gK
         0M47n08PCbwSAAAHpnB5NZUa5PJ3jqM0sFJYHYCV1+uFsvROyNCULug2lOezvw4KSxiC
         SwvzuqKN0keYa4/1ydFK2xGN83du5F8hP7y28i8MbkevBr7RMbIjQF8iEl3lxI4AS4rj
         O6jyhFmalRm5sDGo51MDmx9Yc7ibOQgbEesKJpyN5wkexREqBNWTi2YgoIds/heBTaQl
         JrNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692119754; x=1692724554;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h4pRofXYscuxJwlZlec+kz5JByk1VStjcQk6pNX8VCg=;
        b=IxVstITLUFnXpfJQMo9/tY9njvx/jxbs2KRUUlUCcFHZwhjOBfr8BXlL8564entUlC
         cu9DnwGR67gffGn76681EoFSar0tf9c1f6iRWDv7KYgxsnbmC3qJIhB1e6qY+2vqGQ2q
         /vBEazTLeHRUWStFnajCG7R1QpccltU2W9UJeqO2AflCvD12po+K8oqev5zcIb5QsOu8
         mxEClCbqAd6UThM9nwEAvpx+Zj2qiJOsgC4H5ZedasUgg15eep+r4ufArXkueAHA43v0
         4skjUyS2DmCqsr7KlNyDtP/k+9CfkPmGzgoS9Aljsk68tv7dIqK8oyjWLfQ+sNANvNhk
         sbLQ==
X-Gm-Message-State: AOJu0Ywrm66PcbH7ar3csi2omBzYOQqXi+Wsvk+1rqcfDNhf516JSWCs
        6neaBB4yN4PTu48S1dXbDOokKBHhdMQ=
X-Google-Smtp-Source: AGHT+IEdTpAtlbhdDz4CSAmHfwiSyntmeRr/8GY1hRZWQcWfFLbFbn/FO7WCsNQ5MIITNcxj8ryCZ17c50c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:890e:0:b0:d08:95:76d with SMTP id
 e14-20020a25890e000000b00d080095076dmr40567ybl.6.1692119754466; Tue, 15 Aug
 2023 10:15:54 -0700 (PDT)
Date:   Tue, 15 Aug 2023 17:15:53 +0000
In-Reply-To: <CAJHc60yp7X9Za=CJnJWqAbPuKznp91fYtnBOuQQCGtiXyQBqWw@mail.gmail.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com> <ZNq15SZ+53umvOfx@google.com>
 <CAJHc60wMueazp3Wm=b6-tnFPAyX0zeYuVQe9uPEJrpAm0azw2A@mail.gmail.com>
 <ZNrMTmppUfQhdsyY@google.com> <CAJHc60yp7X9Za=CJnJWqAbPuKznp91fYtnBOuQQCGtiXyQBqWw@mail.gmail.com>
Message-ID: <ZNuyyQsFCmDc7Gmb@google.com>
Subject: Re: [PATCH v9 00/14] KVM: arm64: Add support for FEAT_TLBIRANGE
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023, Raghavendra Rao Ananta wrote:
> On Mon, Aug 14, 2023 at 5:52=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Aug 14, 2023, Raghavendra Rao Ananta wrote:
> > > On Mon, Aug 14, 2023 at 4:16=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > >
> > > > On Fri, Aug 11, 2023, Raghavendra Rao Ananta wrote:
> > > > > The series is based off of upstream v6.5-rc1.
> > > >
> > > > Lies!  :-)
> > > >
> > > > This is based off one of the kvmarm.git topic branches (I didn't bo=
ther to figure
> > > > out which one), not v6.5-rc1.
> > > >
> > > Sorry, what am I missing here? My git log is as follows:
> >
> > Hmm, not sure what's going on.  Maybe I misinterpreted why `git am` was=
 failing?
> > I assumed it was because there were objects in kvmarm that I didn't hav=
e locally,
> > and fetching kvmarm allowed am to complete, though with 3-way merges, w=
hich IIUC
> > shouldn't have been necessary if I was using the exact same base.  Or m=
aybe I
> > messed up and didn't actually reset to 6.5-rc1.
> >
> > > $ git log --oneline upstream_tlbi_range_v9
> > > 5025857507abe (upstream_tlbi_range_v9) KVM: arm64: Use TLBI
> > > range-based instructions for unmap
> > > 5c0291b99a8fc KVM: arm64: Invalidate the table entries upon a range
> > > 8c46b54d4aaec KVM: arm64: Flush only the memslot after write-protect
> > > 231abaeb7ffc2 KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range(=
)
> > > 5ec291b863309 KVM: arm64: Define kvm_tlb_flush_vmid_range()
> > > 5bcd7a085c34e KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
> > > ea08f9dff7e5b arm64: tlb: Implement __flush_s2_tlb_range_op()
> > > b3178687947c9 arm64: tlb: Refactor the core flush algorithm of __flus=
h_tlb_range
> > > a4850fa988eef KVM: Move kvm_arch_flush_remote_tlbs_memslot() to commo=
n code
> > > 306dc4e6afd37 KVM: Allow range-based TLB invalidation from common cod=
e
> > > d02785a0a1e01 KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
> > > 136fa2d254537 KVM: arm64: Use kvm_arch_flush_remote_tlbs()
> > > e35c68a75170d KVM: Declare kvm_arch_flush_remote_tlbs() globally
> > > 5d592777b9bba KVM: Rename kvm_arch_flush_remote_tlb() to
> > > kvm_arch_flush_remote_tlbs()
> > > 06c2afb862f9d (tag: v6.5-rc1, tag: linux/v6.5-rc1) Linux 6.5-rc1
> > > c192ac7357683 MAINTAINERS 2: Electric Boogaloo
> > > f71f64210d698 Merge tag 'dma-mapping-6.5-2023-07-09' of
> > > git://git.infradead.org/users/hch/dma-mapping
> > > ...
> > >
> > > Isn't the commit, 06c2afb862f9d (06c2afb862f9d (tag: v6.5-rc1, tag:
> > > linux/v6.5-rc1) Linux 6.5-rc1) the 'base' commit?
> >
> > Ya, should be.
> >
> > Either way, even if this is PEBKAC on my end, using --base would be nic=
e, e.g.
> > then you can definitely say it's my fault ;-)
> >
> I'll consider this, and thanks for the confirmation.

Confirmed PEBKAC, I reset to v6.5-rc2, not rc1.  My apologies, and thanks f=
or being
gentle.
