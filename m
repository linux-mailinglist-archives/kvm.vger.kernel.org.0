Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B487BA99F
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 20:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjJES7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 14:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjJES67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 14:58:59 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32250C0
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 11:58:58 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-3af6cd01323so832685b6e.3
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 11:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696532337; x=1697137137; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yDQQmCSsjmsi9m5zFrDWZjrxSkRh4MDqIUqD4S4tkjk=;
        b=Fis28j8539ULLCZ7MQ23cjbmnfumeGuPp6cQ0ruQo6tl7fwCjdRUwdZcvDYsxRY3F+
         5JGHuNeuWl/F1RZz8ox7F1VrovEftLASjhrcIWzJsM+Dc7ICJ2G9IlJA8rBQp5oml+je
         UblU8ETPCuCMXPY5c/rpC+nxiz45LRecTos2TUv21b85Hj6fBh6QNbRwUokM5m++7cPY
         SyWTh5kj8S9e9BOLpudT5KUVzZjduccbEq/0/0qXaQaNS/cJLfHwazYSsaB/gd4ejlkD
         4C7w682nqmoPC7qCfFssL2dfOtnvekwpustRwskp4Kwjj2l83SLnIFm7V39aYiCEqYVk
         z3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696532337; x=1697137137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yDQQmCSsjmsi9m5zFrDWZjrxSkRh4MDqIUqD4S4tkjk=;
        b=stNuWbnVZCG+iehTTlsb+VH/J8lxDF0kgVuHHQkK/IOaRv37Xov/vPRoFSOvCxv5OB
         6skDqLEk4Af6rlqbLYPUJHeJj5vVQBXUcMdYBANepwLSfDVZXhNyWjf3TaTQ6+1qK7u8
         3Zp8re0fDEKGDHYuqF28S+Hz+E+A6vyd+bRnjqu2d2w3joLeLOJ6lgrCd1HhEmyFEhlv
         NPypMop2IFJ7jv+0ZRzoRlGrXnf40Mrpw56W9nYztpM31ibhTtLJjaHxzZfo06ugqueO
         Oic7nJlYLGeGXBfEzTOUd4mrB3zGJQeUSRaa6gaBWBmYPvrD2NbkSatY+DVV+t5zklon
         Dkkw==
X-Gm-Message-State: AOJu0YxJBps0KscfDWonor0FX1IRG08VzTBtSqhnzNIMyMDDbzI6vu5/
        gm8UHKu+YYjJZ+2j2UxjiNVox1/aKreLt19aAB6bQg==
X-Google-Smtp-Source: AGHT+IEjwNOFakx4ccTdhsQ8QAUUS0UJOAJL+jgIf9Wgup01bCxwbJD37o3+W/nPZD5mUlQnp9NN4JrzgAjg2NZqln8=
X-Received: by 2002:a05:6808:1143:b0:3a8:1727:5af4 with SMTP id
 u3-20020a056808114300b003a817275af4mr6814984oiu.24.1696532337483; Thu, 05 Oct
 2023 11:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com>
In-Reply-To: <ZR4U_czGstnDrVxo@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 5 Oct 2023 11:58:21 -0700
Message-ID: <CAF7b7mqUkP1jDf_TF_DpGcAKqn+nYx4ZPasW00qT4nOr-76e_Q@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Eh, the shortlog basically says "do work" with a lot of fancy words.  It =
really
> just boils down to:
>
>   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_MISS=
ING
>
> On Fri, Sep 08, 2023, Anish Moorthy wrote:
> > Change the "atomic" parameter of __gfn_to_pfn_memslot() to an enum whic=
h
>
> I've pushed back on more booleans multiple times, but IMO this is even wo=
rse.
> E.g. what does an "upgrade" to atomic even mean?

Oh, that bad huh? Based on what you mentioned earlier about some
callers of __gfn_to_pfn_memslot() needing to opt out of the memslot
flag, it seemed like there were basically three ways (wrt to @atomic)
that function needed to be called

1. With atomic =3D true
2. With atomic =3D false, and some way to make sure that's respected
whatever the memslot flag says
3. With atomic =3D false, but respecting the memslot flag (ie, changing
to atomic =3D true when it's set).

An "upgrade" in this context was meant to describe case 3 (when the
memslot flag is set). Anyways despite terminology issues, the idea of
an enum encapsulating those three cases seems like, essentially, the
right thing to do. Though of course, let me know if you disagree :)

> Since we have line of sight to getting out of boolean hell via David's se=
ries,
> just bite the bullet for now.  Deciphering the callers will suck, but not=
 really
> anymore than it already sucks.

Sorry, what exactly are you suggesting via "bite the bullet" here?
