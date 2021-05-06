Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C612E375A6E
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhEFSve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhEFSvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 14:51:33 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D5AC061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 11:50:34 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id z13so9286040lft.1
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 11:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OdYY4j9zix9lebc0x62okL+STiBk6LvPYD5somUhJts=;
        b=rzJsidqQkbKoI+nB4AGSbC6anHahnJH8EOgcYO5Ey7CzVvH4KoNPavfq4kpfF1h0uP
         t6b7sOCYP5q+08PwNWSwHpgXiZnp8EsA2lcVNw4LK4IjgQTzV0dwy1MoZ5svM1oz7pYo
         YD0TK5lhLzy49evSdLoYQJnYVPgOdvpqapor9LyXUslo4X/QLTa0DKIE8nuCzie/7m4e
         uy6r5Yi9eqPf5AtmkbbC8mwupTf/GM61jlEs89SuPsBg+SHx2xYRBWckYBtfjPkoZnRM
         fkbd3HPp1xNipXQQ4b6tNa+Wiq6CCW5oEJ82hRNHHLduyjfmtIUMxQGzUOe5nojhSegs
         8+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OdYY4j9zix9lebc0x62okL+STiBk6LvPYD5somUhJts=;
        b=Ua8ydt4tDHBfqr8ID5tLcZWSfhrCfmaidJj215HLfE32WcI093xvSOBZH8zQXgFA6K
         +JOEowIOmUyi07p7Ppgn4WrjSTfIDYlRWhPdA+gCo11ZQYFcdMb8cC/MVuzHlTKsKTDl
         dV9HOTAmVmJ0niITnatcOhTIw3sQtMcQBcQu1In0ng0wX8ectC/LBAVzIYjJ28S4/zXf
         05LNu9POvzuDAuMX3eUvZbSebwUdfHnnd8cpeu2LaysO4UVs12PFlbq0XGBHhtJcHvpl
         YqDaFLztvg9YVhlK5YhitIHZsSgUiuAZvorij2o213vI7nbYlINM2BhG2TfDD/sQ7w0/
         hwXg==
X-Gm-Message-State: AOAM533mRqymWA1lzYu0/Dn6sKHba/2nDigHjasDeVnSJEPwdkLzF/M7
        20aeIhjazP0v/l5FguqYVH9wGLoYa8GIEd05E3kfUA==
X-Google-Smtp-Source: ABdhPJw8sg7+P2OnRhXIDlGabMDjeWXfqattGggnOw/YN3UrHVJA9h2sThLkrrDQLsGrrQ+d8Lk5zoN5d/fkcMzk5dg=
X-Received: by 2002:a05:6512:3e9:: with SMTP id n9mr3977859lfq.207.1620327032309;
 Thu, 06 May 2021 11:50:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210506004847.210466-1-jacobhxu@google.com> <YJQSx9vb1lT3P79j@google.com>
 <CALMp9eSWA+KKA93fdyX7o+rEPogP-QJvY+CADTnDPXmCoEg1Yw@mail.gmail.com>
In-Reply-To: <CALMp9eSWA+KKA93fdyX7o+rEPogP-QJvY+CADTnDPXmCoEg1Yw@mail.gmail.com>
From:   Jacob Xu <jacobhxu@google.com>
Date:   Thu, 6 May 2021 11:50:20 -0700
Message-ID: <CAJ5mJ6ggCrAdWNqbUrYGWWv+erLJ5oT=WoN2b5pVFH9ZQPxtCA@mail.gmail.com>
Subject: Re: [PATCH] x86: Do not assign values to unaligned pointer to 128 bits
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Please use [kvm-unit-tests PATCH ...] for the subject
Oops, I'll resend v2 with the correct prefix.

> Shouldn't this be '16', as in 16 bytes / 128 bits?
> Or possibly sizeof(*mem)?
Replaced with sizeof below.

> use a pattern other than '0', if only for giggles?
replaced uint8_t with uint32_t for more giggles and selected
0xdecafbad from the wikipedia page for Hexspeak.


>  And would it makes sense to use a pattern other than '0', if only for giggles?


> Or possibly sizeof(*mem)?
