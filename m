Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E156AE6B5
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 17:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjCGQfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 11:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjCGQfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 11:35:13 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A2785A52
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 08:33:42 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-536c02eea4dso254709307b3.4
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 08:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678206793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+Nc9LwF0nQbmnLjsYLT6UnYPUF/RTIPHIvoLQFgE8g=;
        b=NzdUQkKbBvXaHtKpxaZL0+I+QJuoMzhQ1JpBkEmO2oIEd2rFkxFHnfkGYPU+NeL/x8
         xP94qvtV/0fyfUSvVR3rhNhV75Fu7qnoPcq/EjlSWEn9bUV+gv6NlOmpONzsKsRVcA/M
         mc4zdVmqycgZHgf09EChO74h05w65vx7DjcV4j/dSclAS7D/wfqdJJ6JYTwWHsW/OpCo
         8cu4sAY0RtRhuVtsdJCoS4XzdjUiWq5oBpM9kG0mtPfn0c1wdM2sVPqnW5nKfN8ysD5k
         k7r1ihb9YIyFZrDNGPJc//sxLWNn2aytiV91yDT4KKqLF3jieLHoZxFiolLyOK16lROe
         LY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678206793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+Nc9LwF0nQbmnLjsYLT6UnYPUF/RTIPHIvoLQFgE8g=;
        b=QwPTP2V1AjGqjx7HLenE49NhdkpaUXJpAbyRM6/w99Mevqmk/6SXzTW8cu00mDul+E
         2BQbLYP1mac9N4zTdiJFLVCpbMmtGxsEVRNI2ShriDBip76KXYR2aAfcB7QgONjTb4+f
         gw2GfWEXTMrPNWuJpk57UecamJZOYETYkM67ImBHeVi7tkMFhDhwpZIIzx+9/kK5Yfj1
         J2mC11jOwSsu0lgHNChkG7Dt1wNiti5JzLKUUiQR5yYq2aLCNSrds1wdVVz5zv74ItZw
         sTC2BSHLze3fX+maIAPwA+n8QzF/fd8j9UkM9nroMA+VAYrOtpp+IRh2nT5VC7KPLksc
         2AmA==
X-Gm-Message-State: AO0yUKXZd9iwQ5T13kBzO0kZX8mK8vdlC/p+GpmqTt2XmCB75SbGDBa2
        V2RU8aUYG4k9NQKu73mEx9DxL8dk31emqvMu8lIkyw==
X-Google-Smtp-Source: AK7set9vAu7XfONJOXfTySSSB3whkBdI9WWuZBn0mhW12kQEZ2GxSQZNd49xBcH88BgfzylShp10ncxhHXTvjJosyoY=
X-Received: by 2002:a81:ac60:0:b0:52f:184a:da09 with SMTP id
 z32-20020a81ac60000000b0052f184ada09mr9696651ywj.2.1678206793578; Tue, 07 Mar
 2023 08:33:13 -0800 (PST)
MIME-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-3-aaronlewis@google.com> <ZAJlTCWx8fpNp0Wi@google.com>
 <CAAAPnDFSFzNbCpMx5oG8wRiqyBRst+X1OPK4PWi9ZftTq-2fqg@mail.gmail.com>
In-Reply-To: <CAAAPnDFSFzNbCpMx5oG8wRiqyBRst+X1OPK4PWi9ZftTq-2fqg@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 7 Mar 2023 08:32:37 -0800
Message-ID: <CAL715WKxYBQWE_24n-YkQtv6d3SXwx=-f_h_OrNLQBBhtvQM1A@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 3, 2023 at 2:23=E2=80=AFPM Aaron Lewis <aaronlewis@google.com> =
wrote:
>
> On Fri, Mar 3, 2023 at 9:23=E2=80=AFPM Mingwei Zhang <mizhang@google.com>=
 wrote:
> >
> > On Fri, Feb 24, 2023, Aaron Lewis wrote:
> > > Be a good citizen and don't allow any of the supported MPX xfeatures[=
1]
> > > to be set if they can't all be set.  That way userspace or a guest
> > > doesn't fail if it attempts to set them in XCR0.
> > >
> > > [1] CPUID.(EAX=3D0DH,ECX=3D0):EAX.BNDREGS[bit-3]
> > >     CPUID.(EAX=3D0DH,ECX=3D0):EAX.BNDCSR[bit-4]
> > >
> > > Suggested-by: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Aaron Lewis <aaronlewis@google.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>

> > > ---
> > >  arch/x86/kvm/cpuid.c | 15 ++++++++++++++-
> > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index e1165c196970..b2e7407cd114 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -60,9 +60,22 @@ u32 xstate_required_size(u64 xstate_bv, bool compa=
cted)
> > >       return ret;
> > >  }
> > >
> > > +static u64 sanitize_xcr0(u64 xcr0)
> > > +{
> > > +     u64 mask;
> > > +
> > > +     mask =3D XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
> > > +     if ((xcr0 & mask) !=3D mask)
> > > +             xcr0 &=3D ~mask;
> > > +
> > > +     return xcr0;
> > > +}
> >
> > Is it better to put sanitize_xcr0() into the previous patch? If we do
> > that, this one will be just adding purely the MPX related logic and thu=
s
> > cleaner I think.
>
> I don't mind doing that.  I considered putting in its own commit
> actually.  The only reason I didn't is I wasn't sure it was
> appropriate to have a commit that only added an empty function.  If
> that's okay I think I'd lean more towards doing it that way.
>

Yeah, either way works for me.
