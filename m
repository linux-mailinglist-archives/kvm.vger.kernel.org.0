Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FB774DB21
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 18:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjGJQeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 12:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjGJQeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 12:34:20 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CCDAB
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 09:34:18 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6687281b767so5535982b3a.1
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 09:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689006858; x=1691598858;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=21f2RU0O+Dm1adZnCtcR9jtXzIDli0Vque4erFfsGVc=;
        b=bfFsKDy6zOnQ4xlUnZwRZL742l9SPt3VWo2nUvvGj0tX7lD7Ay/RoH13YlkO4gWV1B
         Cec876vsj9JQBATq2B5estI9SkEAokiAhVJMeTKkTrG8dOh+fXxOBngq4zyC1nb41oLn
         xf3R6agFeSqdYsfJKz/mErKMYAHcWhhwfLrKHP0kFSdGPvCOTsb6wTqUFrVHfSb9mnvL
         qN2mi4STex4P6GTf8/RdVgIad/Db34CTjPQ/cbDXcC2x/B22ubqytMZNkt1iqwI3YlR/
         zubJKh3w1qK7uH2qaUP3TAlSfvgJ8G28+BxbXPGwYYLhiGMTpOJUaZ3z3b8xlMjPhFV0
         6ORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689006858; x=1691598858;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=21f2RU0O+Dm1adZnCtcR9jtXzIDli0Vque4erFfsGVc=;
        b=Mr9C9G3gayrV9Gf3jttkzE0sZ5UpMgUs3XwsGEIN2w1NJv1sXFiUd2QvCvGaSPxDFY
         B1J9006fy4nQUeKYAc46UwDveicn4WioEbNZdCihb4hpAX7Jv0fQrPE2ilGa/3CkAVNa
         j8PhFKZG9DQn9o5eBvYCrV4chuYu7aTvsCgSdlMNA7ekQPfLuehniGaKj3gdQsHybBO2
         l1GbMnwzYndiwNkJkb5SrejE821QxcJmj9XCcDWvwdwkpHqdWUYNR97/FGhNNbeDc1WL
         xrKNy5sqa9k+Z+aV6cT5i1Z7E8ztpDfw9mymmoC/N8N+umtR3OfzUc93RijyI8cZ2MmK
         rWlg==
X-Gm-Message-State: ABy/qLbQcLh81JpHt6LAJq/hCvjIKd+YfszH7Qc767PaRmBpmdNm9aNN
        89rqwRUv/pWliCwN0EPieGC5DR8139s=
X-Google-Smtp-Source: APBJJlEjyBicQw+/XqYFxNk01qqs57dOrv8MIQDFBq9CGNnEfdLDPZkMfTvXCuaPOdUsWYiLLCcY2+unbNE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e9e:b0:682:a8df:e64b with SMTP id
 fd30-20020a056a002e9e00b00682a8dfe64bmr17883460pfb.6.1689006858218; Mon, 10
 Jul 2023 09:34:18 -0700 (PDT)
Date:   Mon, 10 Jul 2023 09:34:16 -0700
In-Reply-To: <CABgObfZCbt8YNuJSa358Er5DO4Eeb4UNbcdyNsWymSSqAnVSpA@mail.gmail.com>
Mime-Version: 1.0
References: <20230627003306.2841058-1-seanjc@google.com> <20230627003306.2841058-2-seanjc@google.com>
 <CABgObfZCbt8YNuJSa358Er5DO4Eeb4UNbcdyNsWymSSqAnVSpA@mail.gmail.com>
Message-ID: <ZKwzCA6guSJZGtJJ@google.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.5
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 01, 2023, Paolo Bonzini wrote:
> On Tue, Jun 27, 2023 at 2:33=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >  - Fix a longstanding bug in the reporting of the number of entries ret=
urned by
> >    KVM_GET_CPUID2
>=20
> This description does not match the actual commit which says there is
> no functional change. I have removed this entry from the merge commit,
> letting it go under "Misc cleanups".

Hmm, which commit are you looking at?  This is the commit I was referring t=
o in
the tag.

commit ab322c43cce97ff6d05439c9b72bf1513e3e1020
Author: Sean Christopherson <seanjc@google.com>
Date:   Fri May 26 14:03:39 2023 -0700

    KVM: x86: Update number of entries for KVM_GET_CPUID2 on success, not f=
ailure
   =20
    Update cpuid->nent if and only if kvm_vcpu_ioctl_get_cpuid2() succeeds.
    The sole caller copies @cpuid to userspace only on success, i.e. the
    existing code effectively does nothing.
   =20
    Arguably, KVM should report the number of entries when returning -E2BIG=
 so
    that userspace doesn't have to guess the size, but all other similar KV=
M
    ioctls() don't report the size either, i.e. userspace is conditioned to
    guess.
