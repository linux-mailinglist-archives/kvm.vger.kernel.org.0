Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C45487FD3
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 01:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiAHAGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 19:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiAHAGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 19:06:55 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB021C061574
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 16:06:54 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id v124so3227203oie.0
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 16:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6y1oCb9FsJGNnOttI3nUfsYQ56k78qI2vypZBmXq17c=;
        b=eDRyeHcRSGIv4aSUKEFJmIZn7h23sMWjk2plSanToc9Jc1+olB6FKC/DFxaC3H4YLp
         GgZMfDPT8flkdtkb/WWJr+STHKhDY2o7CizMpFNXulEegOR9Bkx1A3LESJdkGbriEVg8
         swTnd1rYnjrnPr/y+aJfg6HM6C3eLE1RvrRZ5stqLPlcHmpChh3dO/65y5Yn00OEvpzC
         pJ8ndUUJSj1KIrbak8yGzZPInUhxjkQ5qFEX+kmAdjJV4vEW+2UowKbODW3P/p2iqr/R
         G7rempbLXHjLYs2D3DM7V/s7Ek68ACtZQkRE+v4JdlApjekzS3OneFYEnFS5COG+EMJa
         nvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6y1oCb9FsJGNnOttI3nUfsYQ56k78qI2vypZBmXq17c=;
        b=Iu0SWbfKrt+yQw+L9pMNWf+8l6YLJcWUTilwUgjA6dls9s0hdL4YQD1jstGK/RGtx2
         5FlTMr/q2OA2mKcBzFcfpo90ldkoovGfCaXxyqWiGizZJk33Y76SuJg/qasf1YIEdGSX
         Kdqy2rP76jNjBqbhIyP4qQzNaTA6jPeDMNsGqxiiuxhLd7g/J0eodE+yb8WIu7KWS8QA
         Em4vicMNKY9z39tFmuJ+d/Ce9UhYxJzUL5WZwUvAgFD/JfXbDstRt6FBA1R9iB7WOaYk
         HWH8wXEwpK36oAYnSf2ZWVVEMYoLjmmVsUgLyyqLq929sryJ77R+IUnCwBXfnXXfAy1L
         QDwA==
X-Gm-Message-State: AOAM532Egqldympe9g+fjLqanJzxchKclLYSCf+GC/OMfk13wCzmaCxG
        3YlJ3aKuoiiIX7Dx7w0seISZd9yQgIpHIQBvyZzGEw==
X-Google-Smtp-Source: ABdhPJwvDI3eReziG8/afRs5uk2kJ6CeH2dboGoUraFuxbDEp1m0yHxQwSx4iuQiQbCR6WW0Rt3gaIZ1OXuLW727hkM=
X-Received: by 2002:a05:6808:1b22:: with SMTP id bx34mr9315775oib.68.1641600414089;
 Fri, 07 Jan 2022 16:06:54 -0800 (PST)
MIME-Version: 1.0
References: <20200529074347.124619-1-like.xu@linux.intel.com>
 <20200529074347.124619-4-like.xu@linux.intel.com> <CALMp9eQNZsk-odGHNkLkkakk+Y01qqY5Mzm3x8n0A3YizfUJ7Q@mail.gmail.com>
 <7c44617d-39f5-4e82-ee45-f0d142ba0dbc@linux.intel.com>
In-Reply-To: <7c44617d-39f5-4e82-ee45-f0d142ba0dbc@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 7 Jan 2022 16:06:43 -0800
Message-ID: <CALMp9eTYPqZ-NMuBKkoNX+ZvomzSsCgz1=C2n+Ajaq-ttMys1Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: Test full-width counter writes support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 11:33 PM Like Xu <like.xu@linux.intel.com> wrote:
>
> On 2021/5/12 5:27, Jim Mattson wrote:
> > On Fri, May 29, 2020 at 12:44 AM Like Xu <like.xu@linux.intel.com> wrot=
e:
> >>
> >> When the full-width writes capability is set, use the alternative MSR
> >> range to write larger sign counter values (up to GP counter width).
> >>
> >> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> >> ---
> >
> >> +       /*
> >> +        * MSR_IA32_PMCn supports writing values =C3=A2=E2=82=AC=E2=80=
=B9=C3=A2=E2=82=AC=E2=80=B9up to GP counter width,
> >> +        * and only the lowest bits of GP counter width are valid.
> >> +        */
> >
> > Could you rewrite this comment in ASCII, please? I would do it, but
> > I'm not sure what the correct translation is.
> >
>
> My first submitted patch says that
> they are just Unicode "ZERO WIDTH SPACE".
>
> https://lore.kernel.org/kvm/20200508083218.120559-2-like.xu@linux.intel.c=
om/
>
> Here you go:
>
> ---
>
>  From 1b058846aabcd7a85b5c5f41cb2b63b6a348bdc4 Mon Sep 17 00:00:00 2001
> From: Like Xu <like.xu@linux.intel.com>
> Date: Wed, 12 May 2021 14:26:40 +0800
> Subject: [PATCH] x86: pmu: Fix a comment about full-width counter writes
>   support
>
> Remove two Unicode characters 'ZERO WIDTH SPACE' (U+200B).
>
> Fixes: 22f2901a0e ("x86: pmu: Test full-width counter writes support")
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   x86/pmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 5a3d55b..6cb3506 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -510,7 +510,7 @@ static void  check_gp_counters_write_width(void)
>          }
>
>          /*
> -        * MSR_IA32_PMCn supports writing values =C3=83=C2=A2=C3=A2=E2=80=
=9A=C2=AC=C3=A2=E2=82=AC=C2=B9=C3=83=C2=A2=C3=A2=E2=80=9A=C2=AC=C3=A2=E2=82=
=AC=C2=B9up to GP
> counter width,
> +        * MSR_IA32_PMCn supports writing values up to GP counter width,
>           * and only the lowest bits of GP counter width are valid.
>           */
>          for (i =3D 0; i < num_counters; i++) {
> --
> 2.31.1

Paolo:

Did this patch get overlooked? I'm still seeing the unicode characters
in this comment.
