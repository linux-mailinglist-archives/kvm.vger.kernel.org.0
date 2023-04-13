Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6C26E063B
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 07:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjDMFHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 01:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDMFHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 01:07:10 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21F75BA2;
        Wed, 12 Apr 2023 22:07:08 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4eca9c8dd57so24771e87.1;
        Wed, 12 Apr 2023 22:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681362427; x=1683954427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TX7sRRid9awit1AAtC83vg5eH8pjTbDg4I2j4+jQwKU=;
        b=kS+OLw/Lqe8fkbB04uniKG+lwmu4vGoC+qLUtHqpXC+s+0m7OZnSWpVWYRQp615FSA
         yyes7szk8xr3DKJubBSQy0C2aX44enOWhcNNZZTM6h9LYgvs78YpXCqXqMxRCA72aHMq
         EAYr9J3Da3tkdfhgJM9pVvewhLdZHGTF9qBqm8wuEx4OIgXmU3WnXyiKBpVZLtnPhUrg
         4ptRD3synuM/c8n2iYFE5eLlg3OaVxUjxtO6U+VA5ybcXMp0lT9CqSIRuuUhybHFnvNB
         4/+augWlK7HtzgK5BB9Zf3xYodZBZHDZs7Vnwo7D/SMUhQOLn7BxiLBO0vaeiZdFaBVG
         X/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681362427; x=1683954427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TX7sRRid9awit1AAtC83vg5eH8pjTbDg4I2j4+jQwKU=;
        b=XEVU0bgyddekHEFEaeuMifWr8/p5a6PHu9RHU2EWa9eZjVH0oZkXUKDc8lm677ZavV
         dPMrsyjgWjBas48BNEoDnPaHi4V3EviTyIrAAyWodqBNdEAZVDj8Z6i0neenzlEzDpf6
         KRs6iyCUlnUV0ybQw+dgJeNWNsExttcmkVAffKHaAhOtP1VYJcC/o+ohObaSlqYub8Zm
         0pKEeXQ2VPXLVsVH/4tlWdnPR0dNtfLchekPboes0RdjxzFskLu6dMNM/yE/BA4t7Gu5
         e8mKWPkJtFph1nTZX9hfPxRsZSQJy2wwUvjgrjIMms/gcwocxKJGyfB7HbPrQ93B9J5h
         astA==
X-Gm-Message-State: AAQBX9ck+HMD37zVcYj6hgGfgY+njs++MJbxKn1C6HWqVO0u+XLk3+8K
        fIfSB/M+R6klTJhCGgrl5T0=
X-Google-Smtp-Source: AKy350Z9oxZZruutW3SOCaLih71+1Q72m9rkvwK1AYXTYfRotGa3BKY+bBY43SYHUE5NAtw3vAbstg==
X-Received: by 2002:a19:7615:0:b0:4e9:c792:c950 with SMTP id c21-20020a197615000000b004e9c792c950mr324230lff.1.1681362426674;
        Wed, 12 Apr 2023 22:07:06 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id b10-20020ac25e8a000000b004d856fe5121sm133850lfq.194.2023.04.12.22.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 22:07:06 -0700 (PDT)
Date:   Thu, 13 Apr 2023 08:07:02 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
        =?ISO-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: free sev_*asid_bitmap init if SEV init
 fails
Message-ID: <20230413080702.0000016b.zhi.wang.linux@gmail.com>
In-Reply-To: <CAEivzxfxm9Kg-ap9QeceGgTeCd0du7FrH7Kmi2dRZH6gah-8HQ@mail.gmail.com>
References: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com>
        <20230404122652.275005-2-aleksandr.mikhalitsyn@canonical.com>
        <20230411224737.00001d67.zhi.wang.linux@gmail.com>
        <CAEivzxfxm9Kg-ap9QeceGgTeCd0du7FrH7Kmi2dRZH6gah-8HQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Apr 2023 16:52:23 +0200
Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com> wrote:

> On Tue, Apr 11, 2023 at 9:47=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail.co=
m> wrote:
> >
> > On Tue,  4 Apr 2023 14:26:51 +0200
> > Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com> wrote:
> >
> > > If misc_cg_set_capacity() fails for some reason then we have
> > > a memleak for sev_reclaim_asid_bitmap/sev_asid_bitmap. It's
> > > not a case right now, because misc_cg_set_capacity() just can't
> > > fail and check inside it is always successful.
> > >
> > > But let's fix that for code consistency.
> > >
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: St=C3=A9phane Graber <stgraber@ubuntu.com>
> > > Cc: kvm@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical=
.com>
> > > ---
> > >  arch/x86/kvm/svm/sev.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index c25aeb550cd9..a42536a0681a 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -2213,8 +2213,13 @@ void __init sev_hardware_setup(void)
> > >       }
> > >
> > >       sev_asid_count =3D max_sev_asid - min_sev_asid + 1;
> > > -     if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
> > > +     if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count)) {
> > > +             bitmap_free(sev_reclaim_asid_bitmap);
> > > +             sev_reclaim_asid_bitmap =3D NULL;
> > > +             bitmap_free(sev_asid_bitmap);
> > > +             sev_asid_bitmap =3D NULL;
> > >               goto out;
> > > +     }
> > >
> > >       pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
> > >       sev_supported =3D true;
> >
> > It would be nice that another case can also be fixed:
> >
> >         sev_es_asid_count =3D min_sev_asid - 1;
> >         if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
> >                 goto out; /* <----HERE */
>=20
> Nope.
>=20
> There is no leak. Because when we are at this point then sev_supported
> =3D true and everything is fine.
>=20
Uh. You are right. Sorry that I was giving this comment based on my on-going
development branch.
> >
> > Maybe it would be a good idea to factor out an common error handling pa=
th.

