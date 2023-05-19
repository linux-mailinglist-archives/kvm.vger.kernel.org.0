Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C74C70A129
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 23:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjESVCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 17:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjESVCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 17:02:13 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605831A5
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 14:02:11 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6435432f56bso2365889b3a.3
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 14:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684530131; x=1687122131;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mw3Ozc4fZg2tj7CT8Q6YsEZOU9HXZu7Pqk3RzFDGAeg=;
        b=hNqb88g2Aeap67x1FMTjGHF4R/Xg7gRRWKuiWZSgR63RmDKjcslfpiMQ/XEeL3j6+R
         DG31pafPWlx0zaTuIJ4RwvepIWrUKJFkVkKtod5fcTr6Hu+JKiJAJEPtnRMdAe+0BPR2
         gIs18PQLRxZY1NDqP1K8Xvdfw+ys4n2aNDSCWQqsrD+CunKeFcuP47lED449bgiSsOjO
         p+CVxQuMmoH0SEbHGDeBe6TQHCAz91qxWyiq8FmWzP1GXons1ME+1VMdGnLBa9oDebnU
         Q3ARPv/fHksN59aDO1JExSqEtmCobGVo2EuvLXstm3Va95C+HI/C1YrV+0Iyr6iW/FY0
         FPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684530131; x=1687122131;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mw3Ozc4fZg2tj7CT8Q6YsEZOU9HXZu7Pqk3RzFDGAeg=;
        b=GaPGZX4ifMnVAxyRiEfPdCoxCLFWEVOdqhaY5Ol/6THyXTzNnfflmCX7Qi95YScAsZ
         b6sadVFPuF8CE74GbgZsEkA6FU+aBrG4ZddippvdFSVysE0LBltVNpJaUqKTM0Uhb8mf
         85vwPK3Y/H053rIth5XPxU70qP/nNcACNpQDF4yww43hP379ruC3/SUDf3nVUGLim0zC
         Aef1qwixCzw+8f2dNijuPLXDX+sne1CZHjTkqYFiZjRbkdGu5O29KEvijZZLzfKaSyH/
         W3C4zq73FoiVZSA8Irp2fm770t/Csdcr9vB6I8LbYmYofiAqO0jktG0QUzTKkfx4QGUR
         8jDw==
X-Gm-Message-State: AC+VfDyvHjGXqZJtb0bzGTOrzvaC6Ea50sNG7zaWsIw16i3KRoZn3wSc
        y/BAzDK2tYJ0gaG8CHmFogvkxins14w=
X-Google-Smtp-Source: ACHHUZ7NvdrVLKzYiaTxHRsLQSoMdRHj0JrAs5j8t7q4YRdK3vLRz1AQvmxSAVOq0KKowdDTiH0p7G2+xFQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d28:b0:63b:1a20:5ea2 with SMTP id
 fa40-20020a056a002d2800b0063b1a205ea2mr1615463pfb.1.1684530130898; Fri, 19
 May 2023 14:02:10 -0700 (PDT)
Date:   Fri, 19 May 2023 14:02:09 -0700
In-Reply-To: <CAEivzxcx3yCXO_Hk1_xgWZgkHrTmZNNXVBU2ox2Y=vVY_vnG-g@mail.gmail.com>
Mime-Version: 1.0
References: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com>
 <20230404122652.275005-3-aleksandr.mikhalitsyn@canonical.com>
 <ZGe9I+S78pQ/RPs7@google.com> <CAEivzxcx3yCXO_Hk1_xgWZgkHrTmZNNXVBU2ox2Y=vVY_vnG-g@mail.gmail.com>
Message-ID: <ZGfj0QrdgQDhrR0M@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: add some info prints to SEV init
From:   Sean Christopherson <seanjc@google.com>
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     pbonzini@redhat.com,
        "=?iso-8859-1?Q?St=E9phane?= Graber" <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023, Aleksandr Mikhalitsyn wrote:
> On Fri, May 19, 2023 at 8:17=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, Apr 04, 2023, Alexander Miqqqqkhalitsyn wrote:
> > > Let's add a few pr_info's to sev_hardware_setup to make SEV/SEV-ES
> > > enabling a little bit handier for users. Right now it's too hard
> > > to guess why SEV/SEV-ES are failing to enable.
> >
> > Hmm, I'm somewhat torn, but I'm against taking this patch, at least not=
 in its
> > current form.  I appreciated that determining why KVM isn't enabling SE=
V/SEV-ES
> > is annoying, but there's very little actionable information provided he=
re that
> > isn't also super obvious.  I also don't want to start us down a slipper=
y slope
> > of printing out messages every time KVM doesn't enable a feature.
> >
> > If someone tries to enable SEV and doesn't check that their CPU support=
s SEV,
> > then IMO that's on them.  Ditto for SEV-ES.
> >
> > The NPT thing is mildly interesting, but practically speaking I don't e=
xpect that
> > to ever be a hindrace for generic enabling.  Ditto for MMIO caching.
> >
> > The decode assists check is (a) completely unactionable for the vast, v=
ast majority
> > of users and (b) is a WARN_ON_ONCE() condition.
> >
> > The ASID stuff is by far the most interesting, but that's also quite in=
teresting
> > for when SEV and SEV-ES _are_ fully supported.
> >
> > So if we want to provide the user more info, I'd prefer to do something=
 like the
> > below, which I think would be more helpful and would avoid my slippery =
slope
> > concerns.
>=20
> Dear Sean,
>=20
> Thanks for looking into this!
>=20
> I agree with your points, let's go that way and print only ASID stuff
> as it can be not obvious to the end-user.
>=20
> I'm ready to prepare -v2 if you don't mind.

Ya, fire away.  Thanks!
