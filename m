Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A8F76DB91
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjHBXaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjHBXax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:30:53 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0442698
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:30:51 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-348c7075afcso30315ab.1
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 16:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691019051; x=1691623851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9p/r3/7OOEeGD98k45cJqzqj6mNEuBO34pHN8nni+M=;
        b=fFKN5nHbyv551/4W30i+xv9zwo+3QEZKGkdrHoMkNbWnp7D69/RlaUhp/eF6/2v5F3
         PY4ootJGDhDcUwe+92UvbjD4/1toXHiTlmtImD9LT/8YQiZYo1yq/3Gd4/VDg79/Fjr+
         6pmjunqIV0Ca8hZsxV+aVu04NE60qfC1zia2pWkVAMNlEmBowfsdO+ZCG2YoM1jl/JLo
         g0hFzMkrepyVv2HBAO+grYkMtS7Ff2jFJXIxiFQF080W3PmgZFJzBwbn5Io3N8oYuy6R
         Dxbqqy14GybNEz0zpdK7tsmDcO74eEg1QwBJKVXI6nZoxgpf0g/I8paf+i1lAj70Gw7g
         RYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691019051; x=1691623851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y9p/r3/7OOEeGD98k45cJqzqj6mNEuBO34pHN8nni+M=;
        b=bQK/XlR7dCxW8vgFE3IcmY/FmYp5ho9iSM9VC5s3jiSUaBnV8Dsff0zfO2wqY7ocFy
         pTnWs8ArJ2Kme72DrJyiBy68EAak5DBqKo1csrEcS0BArKY7Dz2WGUDJr0Pya5mJeQdV
         AC5HJPCwOwoE8J60v1O5beK3//0LMTU4RC863qLtMzVdbMG6gtYEWBhbk2qlPofpHMW/
         3Bp2I9Xv0Ej8rpGFqTuAT7dfb6rz7jh5GjBV9T0lccsCje8YnqCd8q4P4fhDS88QbaTY
         x01EHDfTjw9X2Cw6qrNzcLvbP60tpigyBXiNX5AKgkyukhta1y2XitglLWO/IM6Ksdnw
         13YQ==
X-Gm-Message-State: ABy/qLY6yq4gApnvuJrVZg3byB4I7xPagnxg3ayBYJej1Xz0TghABcea
        pbyRyE7F9vFMDHjcCTyQwwBk4yJgxc+ia2T3gZ6Ijw==
X-Google-Smtp-Source: APBJJlELAYNKKPfecK64fKx5Ci1HyUNKE08JkQGkdOgzq5gUkMmu0eZ6vl6aaIwqTlVQfSan7JpwYd6tPF2vIZQ+LNM=
X-Received: by 2002:a92:c54a:0:b0:340:502b:1487 with SMTP id
 a10-20020a92c54a000000b00340502b1487mr1178689ilj.12.1691019050973; Wed, 02
 Aug 2023 16:30:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-2-rananta@google.com>
 <87v8e5r6s6.wl-maz@kernel.org> <CAJHc60wtc2Usei3hKj1ykVRvBZFFCBOHMi9HCxnNvGK2dPFApA@mail.gmail.com>
 <ZMgqueePlmKvgUId@google.com> <CAJHc60xM+KsUKxtoqORnpzrRke4T-sob2uLJRMvBKwruipxnpw@mail.gmail.com>
 <878ratqw2l.wl-maz@kernel.org> <ZMqABp6OdrgOtsum@google.com>
In-Reply-To: <ZMqABp6OdrgOtsum@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 2 Aug 2023 16:30:39 -0700
Message-ID: <CAJHc60zvKSoPU6uTzZQCY2ZAeVj18qmu3=U-rUt5er0zGLQ33Q@mail.gmail.com>
Subject: Re: [PATCH v7 01/12] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
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
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Okay, so just the #define in the respective arch header with a global
declaration. I'll consider this in v8.

Thanks,
Raghavendra

On Wed, Aug 2, 2023 at 9:10=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Aug 02, 2023, Marc Zyngier wrote:
> > On Tue, 01 Aug 2023 01:42:54 +0100,
> > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > Thanks for the suggestions; I can go with a common declaration. Along
> > > with that, do we want to keep defining
> > > __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS in the arch code that supports it o=
r
> > > convert it into a CONFIG_?
> >
> > This isn't something that a user can select, more something that is an
> > architectural decision. Maybe in a later patch if there is a consensus
> > around that, but probably not as part of this series.
>
> +1.  I agree it's annoying that KVM uses a mix of Kconfigs and manual #de=
fines
> for the various "KVM_HAVE" knobs, but we have so many of both that one-of=
f
> conversions without a real need don't make much sense.
