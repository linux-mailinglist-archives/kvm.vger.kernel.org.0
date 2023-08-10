Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E07977838E
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 00:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjHJWUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 18:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjHJWUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 18:20:16 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3ED8271E
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 15:20:15 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5865afcb825so18191317b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 15:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691706015; x=1692310815;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tmBFxKohqxWGeEzlaaidWaFnJW/Oy/RvfXuIqafrWOM=;
        b=6JTyZrfrPMxEB4xAyKq26rEGx6dnOtJemt5mF01prNKQ3cUVfJruc7Fe7RGiRWwnTQ
         JNdckI2vLoo+gqpkJ4Y/rCI2rOTa5hAiAak/2PN2K2x99UdsCwMzOR99izlBg4yxVppk
         dQK8g/hJNDIeks6PwAz/oyY3lHetOC4GBoRbRmdSsLay+vWH0iHE9YncdP80LYWTblDI
         iYMvC5FUjVcDsM/OLHEHwIfhMK0QewWcYKuW2IlqTPX5Otlz706FwBUZ5hXu21vGQIT4
         uYlRsQgCaSIAFf7MMqxoS33uW0RGdAOE21lmj0iEkCe384OiQkcbcQF5CJ0cTVjotCgp
         pMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691706015; x=1692310815;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tmBFxKohqxWGeEzlaaidWaFnJW/Oy/RvfXuIqafrWOM=;
        b=ECI0juky3HU0XGvqnbF3NFic3P6NV5X5JtS5EPe1XE00P8xn3j18mxqD6HMbDMKUP8
         aJPNjJ8NrV4qz5UKSBqhi/ClUUa0Y3R3N9iprD0ywUaynnHrbZDiAmQPLh8UNyuXSbvd
         GBPHSYYRXFIEbnCbSnjmNbtZpwU1Oym3iWwqzkEJfvpVRYKuyMRPTaPLeXJNlEvCWYor
         9/RGr7Jrnrqx8oC4jivDAsqF9pMJnFlM0GqGZslcWxnvyq9oe2nYwAyQL2Twrx6ze4ZC
         MGivA9tXfCWBA69xZjrpfBdv7tJ/6J9oGBp2CiRc3Abv+PwFSr5Pr/EaM10eNQ+641Jb
         BQvw==
X-Gm-Message-State: AOJu0YzBnU0KVgu8v56cynlAG+m5IHTr3qVXlaPQ2g5qsjmWjZ1EGKNd
        gf70Xf15db8b1oaMSEMTpatLXVFr3yA=
X-Google-Smtp-Source: AGHT+IFA+Eoa7k6dQo7jnaWMJsrKFJ33ryvAj3Q3LxXldo+rT6OtEr7lMPaA/JwDbq8aHQpRj3zalPzAYew=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:709:b0:57a:118a:f31 with SMTP id
 bs9-20020a05690c070900b0057a118a0f31mr4149ywb.7.1691706015047; Thu, 10 Aug
 2023 15:20:15 -0700 (PDT)
Date:   Thu, 10 Aug 2023 15:20:13 -0700
In-Reply-To: <CAJHc60x=bhXS3PahuRPwRVdqN4LeX-PBdjdEeCEomhf2YAJ1mw@mail.gmail.com>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com> <20230808231330.3855936-3-rananta@google.com>
 <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com> <CAJHc60yCJANBQOizaoSPhEJH9e8a9C6n68x4qdVkOhVZiiWqkw@mail.gmail.com>
 <30e45ef3-309a-63de-e085-be1645c1be79@redhat.com> <CAJHc60x=bhXS3PahuRPwRVdqN4LeX-PBdjdEeCEomhf2YAJ1mw@mail.gmail.com>
Message-ID: <ZNVfsxdYKu9Nt+j+@google.com>
Subject: Re: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs() globally
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
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
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023, Raghavendra Rao Ananta wrote:
> On Thu, Aug 10, 2023 at 5:26=E2=80=AFAM Shaoqin Huang <shahuang@redhat.co=
m> wrote:
> > On 8/10/23 00:38, Raghavendra Rao Ananta wrote:
> > >>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > >>> index e3f968b38ae97..ade5d4500c2ce 100644
> > >>> --- a/include/linux/kvm_host.h
> > >>> +++ b/include/linux/kvm_host.h
> > >>> @@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlbs(=
struct kvm *kvm)
> > >>>    {
> > >>>        return -ENOTSUPP;
> > >>>    }
> > >>> +#else
> > >>> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> > >>>    #endif
> > >>>
> > >>>    #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
> > >>
> > >> Is the declaration inconsistent to that in arch/x86/include/asm/kvm_=
host.h?
> > >> In order to keep them consistent, I guess we need move kvm_arch_flus=
h_remote_tlbs()
> > >> from x86's header file to arch/x86/kvm/mmu/mmu.c and 'inline' needs =
to be dropped.
> > >>
> > > Unsure of the original intentions, I didn't want to disturb any
> > > existing arrangements. If more people agree to this refactoring, I'm
> > > happy to move.
> >
> > This is amazing to me. This change can be compiled without any error
> > even if the declaration inconsistent between the kvm_host.h and x86's
> > header file.
> >
> > I'm curious which option make it possible?
> >
> After doing some experiments, I think it works because of the order in
> which the inline-definition and the declaration are laid out. If the
> 'inline' part of the function comes first and then the declaration, we
> don't see any error. However if the positions were reversed, we would
> see an error. (I'm not sure what the technical reason for this is).
>=20
> Just to be safe, I can move the definition to arch/x86/kvm/mmu/mmu.c
> as a non-inline function.

No need, asm/kvm_host.h _must_ be included before the declaration, otherwis=
e the
declaration wouldn't be made because __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS woul=
dn't
be defined.  I.e. we won't run into issues where the non-static declaration=
 comes
before the static inline definition.

C99 explicitly covers this case:

  6.2.2 Linkages of identifiers

  ...

  If the declaration of a file scope identifier for an object or a function=
 contains the storage-
  class specifier static, the identifier has internal linkage.

  For an identifier declared with the storage-class specifier extern in a s=
cope in which a
  prior declaration of that identifier is visible if the prior declaration =
specifies internal or
  external linkage, the linkage of the identifier at the later declaration =
is the same as the
  linkage specified at the prior declaration. If no prior declaration is vi=
sible, or if the prior
  declaration specifies no linkage, then the identifier has external linkag=
e.

In short, because the "static inline" declared internal linkage first, it w=
ins.
