Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B5D7BAF85
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 02:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjJFARz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 20:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjJFARy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 20:17:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8856ED9
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 17:17:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d865a8a7819so2210138276.2
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 17:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696551470; x=1697156270; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=McJdi/j/1GKFjqEOteMsFmQa6CgQZT5EeqPYROfMhbk=;
        b=nlOcUyLWr0WX19+BVuLK7WhOuyJglGiV8ORtEDqSMpoKWrM8GqpCiRqXXrUdgvXe8y
         GwoJo8H7N40nYn6GryUAHcqK+uqICw56JLg1Amj6pyfyzePEymbs6cpjkmamd7JaF/fQ
         0uCAMJUUo3fJeN6RQ5BVdPoHxGj5W7bVj06jXZ+R2e6ZHy+OgGyG4M2/IFLq1FA9iDKT
         pY3gdTw5m4bB6OlmG4b7q9Zya1zj00MFuoLPdmvEhkXf29J/NDjDTSqGL2mdlKfZcEQs
         8bwak7HZRG8R+ckQWXJS8RUKRorC6pxFMBcby00sfKhwnZPWDSifw8croWDY3pbsYQQ7
         WRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696551470; x=1697156270;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=McJdi/j/1GKFjqEOteMsFmQa6CgQZT5EeqPYROfMhbk=;
        b=CifQgWbwHwQMZWzu2uMxjPAnV5eer55yeigPU/Hjdd7ibGJhPTvgeMhub+2E+hMmoi
         vT3p0Ok9TxWmxVoBTPqI6g5csD3pOaZmY6hZCkIyfM9P54oSoROeaqjYLPC62QDb0eZh
         b+2E94zw8DCcTiW2FX36uTrvea+hR/zBVrhwnZw4wlJVsSGkUo2eCA5cj4pj6hLE4wxD
         Narr4ug998zjnJTe4bzwb1BDSasYfYfZy9oMSSKA2vfTdFP8ASwAlBF87rYpeUQoleJn
         s/+kdIExoSoVrKosQwND0aRpfE10akwVkVoRWjhuy2YmMcaS89/zRLRvrl1wV81L8FnA
         cppA==
X-Gm-Message-State: AOJu0Yz9va+ye664rmtGJuFqHbX22qzwIV7SI5/fC/DhJ4sdATi6WbLx
        b2ai3WS957UcBNqsoFVaPW3j3CVko60=
X-Google-Smtp-Source: AGHT+IHitULJr7kPwzCJOPk3YaN6WA3g1yti650435QLOqCIesvbT6fAE5o/0S84/9L7cBx2w8foopHaCq0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4197:0:b0:d78:f45:d7bd with SMTP id
 o145-20020a254197000000b00d780f45d7bdmr104941yba.4.1696551470557; Thu, 05 Oct
 2023 17:17:50 -0700 (PDT)
Date:   Fri, 6 Oct 2023 00:17:48 +0000
In-Reply-To: <CAF7b7mqUkP1jDf_TF_DpGcAKqn+nYx4ZPasW00qT4nOr-76e_Q@mail.gmail.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mqUkP1jDf_TF_DpGcAKqn+nYx4ZPasW00qT4nOr-76e_Q@mail.gmail.com>
Message-ID: <ZR9SLOQcFEqPg01A@google.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 05, 2023, Anish Moorthy wrote:
> On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > Eh, the shortlog basically says "do work" with a lot of fancy words.  I=
t really
> > just boils down to:
> >
> >   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_MI=
SSING
> >
> > On Fri, Sep 08, 2023, Anish Moorthy wrote:
> > > Change the "atomic" parameter of __gfn_to_pfn_memslot() to an enum wh=
ich
> >
> > I've pushed back on more booleans multiple times, but IMO this is even =
worse.
> > E.g. what does an "upgrade" to atomic even mean?
>=20
> Oh, that bad huh? Based on what you mentioned earlier about some
> callers of __gfn_to_pfn_memslot() needing to opt out of the memslot
> flag, it seemed like there were basically three ways (wrt to @atomic)
> that function needed to be called
>=20
> 1. With atomic =3D true
> 2. With atomic =3D false, and some way to make sure that's respected
> whatever the memslot flag says
> 3. With atomic =3D false, but respecting the memslot flag (ie, changing
> to atomic =3D true when it's set).
>=20
> An "upgrade" in this context was meant to describe case 3 (when the
> memslot flag is set). Anyways despite terminology issues, the idea of
> an enum encapsulating those three cases seems like, essentially, the
> right thing to do. Though of course, let me know if you disagree :)

The problem is that the three possibilities aren't directly related.  The e=
xisting
use of atomic truly means "this call can't sleep/block".  The userfault-on-=
missing
case has nothing to do with sleeping being illegal, the behavior of @atomic=
 just
happens to align exactly with what is needed *today*.

E.g. if there was a flavor of gup() that could fault in memory without slee=
ping,
that could be used for the @atomic case but not the userfault-on-missing ca=
se.
I doubt such a variation will ever exist, but "that probably won't happen" =
isn't
a good reason to conflate the two things.

> > Since we have line of sight to getting out of boolean hell via David's =
series,
> > just bite the bullet for now.  Deciphering the callers will suck, but n=
ot really
> > anymore than it already sucks.
>=20
> Sorry, what exactly are you suggesting via "bite the bullet" here?

Add another boolean, the "bool can_do_userfault" from the diff that got sni=
pped.
