Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF1B1CE132
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 19:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730840AbgEKREn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 13:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730731AbgEKREn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 13:04:43 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE570C061A0E
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 10:04:42 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f18so10325875lja.13
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 10:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/mo0sXYy7ZUcg8/iVmBIYTh3WKI/O9UKGDKgE3MM9OU=;
        b=hXA4IfAyZ9uCnsRj1IlyziglyHt+A5cuk0JFQeVBiCHd9zjCrgOVMcKJF9i9K0lFkZ
         2C0EBsUocyE95044XVsYOj08QZufGfYjnK/suq9vFsO1TFNcA80W1xcerX5ScCEXy/Nd
         rED/AjvLfeVqsG+lg/Wk/5lSefhgNEdmBo3xyC6+sfroM2hkmWMdZ5kWIcqa3QKqvpaB
         Aa7BOzwQIgN+bIV4VaIc6ltfDuEXR2FcLFZUJ/Ae8f349zSm2WFwFKOcEEsr/MHkGwZY
         v6Rqq7VlvrVt08JcUojJNTr2VpUFyNe8xJNCHsV3y/TTNw6ahQimGkRuXPJ+YIhcFJBf
         EKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/mo0sXYy7ZUcg8/iVmBIYTh3WKI/O9UKGDKgE3MM9OU=;
        b=EQt7dQ3TmFO18eTaeVul3KF5txZphX/YlKxRFceNb/EAkrMO7ueOGwF3yZ5to9+ziM
         CtX+wJxBD0E6+vHIjaA/dpqX/6QJzTuEL77TSutkDVCbTo4uiJgM0CPK2bCPBELnf3DF
         vcNgWXxcrrL3NKUJn8iz03dHOfS+VPk7V4mHzIbojXrl/uiEk66NCJLg+1w5n8002wQ/
         ILDPN/gtmLTLpS7DN6P6GhWr4g37sVGi8Ccop4E65sHyW4W9XY8bM/8qT1q7KX7mhJI2
         I3UmQYQ6UOnfLH//Jb7aKQOGPNC18OLJRJp9bbT7fo9Bu9ZNl+LIuiwBPtoW2G+qzK+v
         vdOQ==
X-Gm-Message-State: AOAM530g4a0W1C4LwwqKYOk6ngbSXqCMhL51Xs6eFd0BVgeMDjJUYqJK
        ck6OR2mUcVefHxvF9wZ7a79gx9pJ5eFX7IWPSCR+CA==
X-Google-Smtp-Source: ABdhPJxgwHFVl1+McnRhXd3Gy7veJhg91K1rAcv5lPJNNEQ7CZDXxXmFozw0EfVRJSC/ejsFw2RnmMAQ5ErFRX3x/s8=
X-Received: by 2002:a2e:b0e3:: with SMTP id h3mr10987519ljl.69.1589216680793;
 Mon, 11 May 2020 10:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200504190526.84456-1-peterx@redhat.com> <20200505013929.GA17225@linux.intel.com>
 <20200505141245.GH6299@xz-x1> <20200511160537.GC24052@linux.intel.com>
In-Reply-To: <20200511160537.GC24052@linux.intel.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 11 May 2020 10:04:29 -0700
Message-ID: <CAOQ_Qsi-50zLtq8nKeUN8wYKkiq9TkX9fcNHwzZ_F5JX0qJp-g@mail.gmail.com>
Subject: Re: [PATCH] KVM: Fix a warning in __kvm_gfn_to_hva_cache_init()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Cook <tony-cook@bigpond.com>, zoran.davidovac@gmail.com,
        euloanty@live.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 11, 2020 at 9:05 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> +cc a few other people that have reported this at one time or another.
>
> On Tue, May 05, 2020 at 10:12:45AM -0400, Peter Xu wrote:
> > On Mon, May 04, 2020 at 06:39:29PM -0700, Sean Christopherson wrote:
> > > On Mon, May 04, 2020 at 03:05:26PM -0400, Peter Xu wrote:
> > > > GCC 10.0.1 gives me this warning when building KVM:
> > > >
> > > >   warning: =E2=80=98nr_pages_avail=E2=80=99 may be used uninitializ=
ed in this function [-Wmaybe-uninitialized]
> > > >   2442 |  for ( ; start_gfn <=3D end_gfn; start_gfn +=3D nr_pages_a=
vail) {
> > > >
> > > > It should not happen, but silent it.
> > >
> > > Heh, third times a charm?  This has been reported and proposed twice
> > > before[1][2].  Are you using any custom compiler flags?  E.g. -O3 is =
known
> > > to cause false positives with -Wmaybe-uninitialized.
> >
> > No, what I did was only upgrading to Fedora 32 (which will auto-upgrade=
 GCC),
> > so it should be using the default params of whatever provided.
> >
> > >
> > > If we do end up killing this warning, I'd still prefer to use
> > > uninitialized_var() over zero-initializing the variable.
> > >
> > > [1] https://lkml.kernel.org/r/20200218184756.242904-1-oupton@google.c=
om
> > > [2] https://bugzilla.kernel.org/show_bug.cgi?id=3D207173
> >
> > OK, I didn't know this is a known problem and discussions going on.  Bu=
t I
> > guess it would be good to address this sooner because it could become a=
 common
> > warning very soon after people upgrades gcc.
>
> Ya, others are hitting this as well.  It's especially painful with the
> existence of KVM_WERROR.
>
> Paolo, any preference on how to resolve this?  It would appear GCC 10 got
> "smarter".

Seems that doing absolutely nothing was the fix here :) See:

78a5255ffb6a ("Stop the ad-hoc games with -Wno-maybe-initialized")

--
Thanks,
Oliver
