Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4237D6EFB77
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 22:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbjDZUCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 16:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236381AbjDZUCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 16:02:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD2C30C7
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 13:02:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b8f52873c69so8564929276.2
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 13:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682539349; x=1685131349;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P9JWy87Tj+Ohbv9i4lrujuAMWsRFGxg3vAQivaDkQmE=;
        b=QcL90t0FH/+UHVyLHypDmT6LT+DSxb+99v1OhFvx06BdhKvR9/rHlHQMFnQGkTzER0
         bURztq7xhX8LGkHbkKXgCXg3e+Ntdclj4/kvjI5gxWldOO6EPMk/GT7k3qG6IHigfpWB
         VBERf5b78lifMhevYbb5W3X6wxs6eQ0vaq7R1C9oLKAte72M7qloYvzOTcT8fKSXvWKS
         IgRjlAh252KmgFkq+6RcRNaM7ObVFH92218WmoSTe5V3/7eH3PujmhjtEpI61pMUkF3B
         QYqk8Mb7mrc4g7Cms07TOJZDC2LpMd05gAf9EVB65mc2dcqFx06IEGZ3S8Xp07Lcb6q5
         7Row==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682539349; x=1685131349;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P9JWy87Tj+Ohbv9i4lrujuAMWsRFGxg3vAQivaDkQmE=;
        b=OUO1d2HxcaUrwHl6rLQZjGWNV1FVjry4zbjDuFk0LnS0uFl54ZzWQiOzt4tuIeqTgw
         ucD1PNdLcAhBBIsm2EWzbRaHQmL7IXGf+Ur0xS+UAd0auKV5yd6esFSHKJUEW0dy+K0f
         kbVXgfcq8l5LwlSn30JNSsUc/rlUhRMWplzBnKOTcL5+RkTx7WbCapcEurDpWTiyyWIQ
         gGh8n88RAMpIDDMW1OwmpiHdP3PBw7J8xbbZMZP9m9NFWx/jSmTkVDzsDD8xqAr05h9h
         AOfRwz41ztNFmf2+GRi1jzGsLBMvRazfLLH9mK0MC9Q6y4TYwvFD4j0ZGQpbw2xga2Kd
         uQ4w==
X-Gm-Message-State: AAQBX9dYMp2KLb2RRX09nRlSRh8wosh4IwTlA3V5NiwGZWnuFNOKjrcj
        tf5nncLrZgKS9ke32IG0RMw1V+94bqQ=
X-Google-Smtp-Source: AKy350bx++EFtAqjCjD6UvovgRUbIW8fs/MSKqn7eQt7MM8RSe8m5OxkBfY4loyTJ8tl0LX0eFHSYwiK+nE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d0d7:0:b0:b95:6caa:a2cb with SMTP id
 h206-20020a25d0d7000000b00b956caaa2cbmr12432515ybg.10.1682539349657; Wed, 26
 Apr 2023 13:02:29 -0700 (PDT)
Date:   Wed, 26 Apr 2023 20:02:28 +0000
In-Reply-To: <CABgObfaXqx1nM5tc5jSBfHCv_Ju4=CPtn6atyuGJdeawE2EcFg@mail.gmail.com>
Mime-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com> <20230424173529.2648601-6-seanjc@google.com>
 <CABgObfaXqx1nM5tc5jSBfHCv_Ju4=CPtn6atyuGJdeawE2EcFg@mail.gmail.com>
Message-ID: <ZEmDVOifOywZGllP@google.com>
Subject: Re: [GIT PULL] KVM: x86: SVM changes for 6.4
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 26, 2023, Paolo Bonzini wrote:
> On Mon, Apr 24, 2023 at 7:35=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > KVM SVM changes for 6.4.  The highlight, by a country mile, is support =
for
> > virtual NMIs.
> >
> > The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73=
b6e7:
> >
> >   KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 1=
0:18:07 -0400)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.4
> >
> > for you to fetch changes up to c0d0ce9b5a851895f34fd401c9dddc70616711a4=
:
> >
> >   KVM: SVM: Remove a duplicate definition of VMCB_AVIC_APIC_BAR_MASK (2=
023-04-04 11:08:12 -0700)
>=20
> Pulled (but not pushed yet), thanks.
>=20
> This is probably the sub-PR for which I'm more interested in giving
> the code a closer look, but this is more about understanding the
> changes than it is about expecting something bad in it.

100% agree.  If you were to scrutinize only one thing for 6.4, the vNMI cha=
nges
are definitely my choice for extra eyeballs.
