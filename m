Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E089765BD0
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 21:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjG0TDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 15:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjG0TDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 15:03:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E41210B
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 12:03:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d052f49702dso1214882276.3
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 12:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690484600; x=1691089400;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Og4MB+QUlTN92g1kEiXmx1dOUDtTzF+MON+MST5kvTs=;
        b=MR1h0dJrgmsudEu/zhKSOxOUDNi45xqymydSeB6izb6kk9TlZcsysQm9pCQVHaPfMy
         sC1WsbxuJuvId8j9LEXNnq76s0W9P1FRRLIc03SlWUW8HgzYiYU//iQlqi+we8clQJOd
         0P5mOGN6bnPWtJ9POVuAArvPjjoigcSNMnN3Vh02NXLOIWhcDb2atC762SDq28slggdl
         BJ3D7mBngPPJFmzX6i3nFeEBwJFCNl5ky8wioz060xf4eMHeunF6T/yPWH95EjlwTQHu
         wHJw8bw00w0a56teyDYvFeYtEcLgvEdTIEu5TbXiMGmpQ7CTx1A2VO5ah/h856qlHAqc
         SzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690484600; x=1691089400;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Og4MB+QUlTN92g1kEiXmx1dOUDtTzF+MON+MST5kvTs=;
        b=h4i/4oUjIZB9nyOHSH/gYy3DX/wjoH78nDgWqsXMRzIgPMPb5gxkKcRaPCzKpdA1bE
         oHyFTHWrTIONrfe0uI0/2ZyeImUPpqjFtmxvWlfRlopy3WI4My9bsJMd3Ctifn5Punir
         CBb8JVV8VXNKFA6bXnf3Mjm8wX4rdCmhNGnFzfNCwWrt8do1eUHhfcknNrkWQGkWHdjW
         tkFJF8kI0TbEReghlK+ZenVzMevvaKPKeJrNhN42Hwe1oZ/kpLKwxlzW4nP0oXSAzYH/
         a2BhZDyrhbQL9ahpBHeQpvHZawuj0070CC8y0iuPMOg8ysr99LbFby9oQwhVFhvWsfIP
         Pq1Q==
X-Gm-Message-State: ABy/qLb47oAahDrbDTBfwvaBU/uEcHFmBaACzK3Hvl9575XIjfgNsdhP
        B2Ryg/w/ij6QkFeJQuigRXYFcj1l3bg=
X-Google-Smtp-Source: APBJJlFm/LS2E8PBmjnXqFyLVbmPObNaRmmegsrt3s2bja0WuvYbYAwo60KPZcrejUcPOHjprovctF9Rz/4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce4b:0:b0:d05:7ba4:67f9 with SMTP id
 x72-20020a25ce4b000000b00d057ba467f9mr1446ybe.3.1690484599851; Thu, 27 Jul
 2023 12:03:19 -0700 (PDT)
Date:   Thu, 27 Jul 2023 12:03:18 -0700
In-Reply-To: <14c0e28b-1a90-5d61-6758-7a25bd317405@gmail.com>
Mime-Version: 1.0
References: <20230607224520.4164598-1-aaronlewis@google.com>
 <ZMGhJAMqtFa6sTkl@google.com> <14c0e28b-1a90-5d61-6758-7a25bd317405@gmail.com>
Message-ID: <ZMK/dluS5ALq1NYj@google.com>
Subject: Re: [PATCH v3 0/5] Add printf and formatted asserts in the guest
From:   Sean Christopherson <seanjc@google.com>
To:     JinrongLiang <ljr.kernel@gmail.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
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

On Thu, Jul 27, 2023, JinrongLiang wrote:
>=20
> =E5=9C=A8 2023/7/27 06:41, Sean Christopherson =E5=86=99=E9=81=93:
> > Side topic, if anyone lurking out there wants an easy (but tedious and =
boring)
> > starter project, we should convert all tests to the newfangled formatti=
ng and
> > drop GUEST_ASSERT_N entirely.  Once all tests are converted, GUEST_ASSE=
RT_FMT()
> > and REPORT_GUEST_ASSERT_FMT can drop the "FMT" postfix.
>=20
> I'd be happy to get the job done.
>=20
> However, before I proceed, could you please provide a more detailed examp=
le
> or further guidance on the desired formatting and the specific changes yo=
u
> would like to see?

Hrm, scratch that request.  I was thinking we could convert tests one-by-on=
e, but
that won't work well because to do a one-by-one conversions, tests that use
GUEST_ASSERT_EQ() would need to first convert to e.g. GUEST_ASSERT_EQ_FMT()=
 and
then convert back, which would be a silly amount of churn just to a void a =
single
selftests-wide patch.

It probably makes sense to just convert everything as part of this series. =
 There
are quite a few asserts that need a message, but not *that* many.
