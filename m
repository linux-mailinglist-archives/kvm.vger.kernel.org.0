Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF091760031
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 22:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjGXUBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 16:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjGXUBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 16:01:38 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371FA139
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 13:01:37 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id d75a77b69052e-4036bd4fff1so71421cf.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 13:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690228896; x=1690833696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jl5MeJuJjAxGXKAhFzC6oX05QXNcvphfhbANRVK+qck=;
        b=GG4r0BC37PIz8ancFPPNMnS3x0H3KAsAkXwF+2c1DahOgfRp5Kofi4JD8MQxHBaBTY
         9NEH+Lg8Z+jQf9x+gCyIDrMNsBrySBzM0KxuTQ8ysgY9aa+cvRjjpNAob3vX/3lzzGv/
         zlWFDpnP0ryav0bk7HZ6AW0extqW8tdQAJShZqiY/qhgXW9vn4Ak7YT0+7vh91PLdoo/
         kpwBQ+5tfIHF/I1MXC6zuBBC70dLRAIwu1kMvpcVVuMWwB0SNlI+1e+cbBFoPEXKPKxP
         IFdugXOftG6UcKJyaal2BiWDWbta5znvtIiF6M5YKArK5QY3aolsgjpTszR82RDBNGlI
         5y8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690228896; x=1690833696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jl5MeJuJjAxGXKAhFzC6oX05QXNcvphfhbANRVK+qck=;
        b=dUtXD6scpsVw8t368DB+SHpU4lPUpuB4ObP16oBIjq2k0bdsrzqWPHziKNsmrduKlJ
         8In6ZU14lfvfhuNHqdfQ9CMo/wW/cuMjLtR3B7DnhHOTbWcRXy16nTrI4zmuwY+5fXVB
         U7Kjn48JAp09GhWKgH7z77vgrv+NMDd4v7at7KtYDGHIkGFW3z8dSBZcaoNoyJp70EEc
         02WNUabVuBWpX1HQw5WjxyZw+lgSM9oe4GnWtCCq34bTVVL55R8Jgo7NNHsvR60B4CNS
         wyijYUMLYL1XnmCDLHQWKuqjJv4xieQYxWDpjOUHxbc1DYBNyc10r9pHsR7vuX90mth1
         9jxQ==
X-Gm-Message-State: ABy/qLasGzG3xb727yx8RIOuCAfe2xkU7oVVLwOO6a5vl9uYzGmFvai6
        F4UdlEjVcpAxf0takysntexoHphqY6JKp1h9L8gMG1bAHtafu26u8wg=
X-Google-Smtp-Source: APBJJlGemP0CkN9ORNU1xUd19yyneWURMHpShwjwAkWDWnU+1Silam/zQvCl/47hWwbUTNLOV+7IrV6rjQtOUi7jWRs=
X-Received: by 2002:ac8:5716:0:b0:403:f3f5:1a8 with SMTP id
 22-20020ac85716000000b00403f3f501a8mr551111qtw.12.1690228896233; Mon, 24 Jul
 2023 13:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <ZLiUrP9ZFMr/Wf4/@chao-email> <CALMp9eTQ5zDpjK+=e+Rhu=zvLv_f0scqkUCif2tveq+ahTAYCg@mail.gmail.com>
 <ZLjqVszO4AMx9F7T@chao-email> <CALMp9eSw9g0oRh7rT=Nd5aTwiu_zMz21tRrZG5D_QEfTn1h=HQ@mail.gmail.com>
 <ZLn9hgQy77x0hLil@chao-email> <20230721190114.xznm7xfnuxciufa3@desk>
 <CALMp9eTNM5VZzpSR6zbkjude6kxgBcOriWDoSkjanMmBtksKYw@mail.gmail.com>
 <20230721205404.kqxj3pspexjl6qai@desk> <CALMp9eSqe09RgwTQUe5Qi15E+Q+wm1QhO5P5-ryvF9OzV9gR0w@mail.gmail.com>
 <20230721222904.y3nabprqdk3aa555@desk> <20230724192540.xp4qulsufqmjwki3@desk>
In-Reply-To: <20230724192540.xp4qulsufqmjwki3@desk>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 Jul 2023 13:01:25 -0700
Message-ID: <CALMp9eSVpdT2v_FzN+Sk=BHamVzLQwRvZvB-GjfMawJ2ZDmdPQ@mail.gmail.com>
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24, 2023 at 12:26=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> On Fri, Jul 21, 2023 at 03:29:04PM -0700, Pawan Gupta wrote:
> > On Fri, Jul 21, 2023 at 03:18:12PM -0700, Jim Mattson wrote:
> > > On Fri, Jul 21, 2023 at 1:54=E2=80=AFPM Pawan Gupta
> > > <pawan.kumar.gupta@linux.intel.com> wrote:
> > > >
> > > > On Fri, Jul 21, 2023 at 12:18:36PM -0700, Jim Mattson wrote:
> > > > > > Please note that clearing STIBP bit on one thread does not disa=
ble STIBP
> > > > > > protection if the sibling has it set:
> > > > > >
> > > > > >   Setting bit 1 (STIBP) of the IA32_SPEC_CTRL MSR on a logical =
processor
> > > > > >   prevents the predicted targets of indirect branches on any lo=
gical
> > > > > >   processor of that core from being controlled by software that=
 executes
> > > > > >   (or executed previously) on another logical processor of the =
same core
> > > > > >   [1].
> > > > >
> > > > > I stand corrected. For completeness, then, is it true now and
> > > > > forevermore that passing IA32_SPEC_CTRL through to the guest for =
write
> > > > > can in no way compromise code running on the sibling thread?
> > > >
> > > > As IA32_SPEC_CTRL is a thread-scope MSR, a malicious guest would be=
 able
> > > > to turn off the mitigation on its own thread only. Looking at the
> > > > current controls in this MSR, I don't see how a malicious guest can
> > > > compromise code running on sibling thread.
> > >
> > > Does this imply that where core-shared resources are affected (as wit=
h
> > > STIBP), the mitigation is enabled whenever at least one thread
> > > requests it?
> >
> > Let me check with CPU architects.
>
> For the controls present in IA32_SPEC_CTRL MSR, if atleast one of the
> thread has the mitigation enabled, current CPUs do not disable core-wide
> mitigations when core-shared resources are affected.
>
> This will be the guiding principle for future mitigation controls that
> may be added to IA32_SPEC_CTRL MSR.

Excellent. Thank you!
