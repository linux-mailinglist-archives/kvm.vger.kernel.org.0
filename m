Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3770675D753
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 00:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjGUWS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 18:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjGUWS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 18:18:26 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D8B3A8E
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:18:24 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-346258cf060so34155ab.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689977904; x=1690582704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nuLBv3g8K9IsEHg/8v7jXFBJAq1gR83ThPuj2n0XHlg=;
        b=kVbNNg6jX4MpNx+oinKIMeJ8hdEjNCd3kTcJW7lSMbiF9A7co4fVOx0D/l2RLpvlHW
         Sj9AP1vrrD2/IG2vaLedSotyYkhVPHjgJ/+DZ6M/aELWmvJo3sNXMuWnAzXGIfImwz3r
         SVkw0SWkFtGwwlvU/qwc4IhCT7gAoC3Y22dkWqrO+HABVKISq9FNGxBB5jBMMNnK7nCH
         q5DI6Fvu35vaML7a7SJbz06Y3fDJqvWmWUVYedRb1wVtMfAnuXM00jKraiVlvxbv9t3g
         kmflUBlGddnDHqxjghT4mGsWUgmPd3xioB9OIgLmx5nG1fDWuYAVQBli6QP29KfP2/ZB
         1LLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689977904; x=1690582704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nuLBv3g8K9IsEHg/8v7jXFBJAq1gR83ThPuj2n0XHlg=;
        b=iEba5r0yqJkHWZe7/fmIUuCl8h4i0yr4kvRR5PZK/p4MdSf9Rz6eWnN6k5hzmET5pR
         ZTeH6GeAAI1YBgGbNp5NWbU7FKG5m4OdHS21LqhjMtenPqb3b7cpPvmJsYRWtdHUCoey
         gszwTuiBjQs37jfNmQFWVQaVD5244jF2q1LVVLZ7frQPFHdBxRffzrIW3rsNeKj0MnL8
         GCkBIE6oe7Xnuj8iq8HALN16T7kIx6W4cZalRl5noAqrptb41EPPzycqgthDze2fENvj
         bYfIitByiFGmmAkt5mAccUkkLGejwVtejC1DkhcveZ0HQ0rA+YfTBDzQow7xaitKAqSa
         lJdQ==
X-Gm-Message-State: ABy/qLb2vwV2Wmufu0QBheXJbMlGnZUlfU4078s60QafGv59Ltg708s4
        UITWJIYYIZ4Y+7eRKxw7lXPJKPh9JYf1i3df1hPGGw==
X-Google-Smtp-Source: APBJJlHtWWpYitSf/rEUAvYLeT4hvnKZaCSaMxYi/S/hGsrdzfXCmt/qnSdZ/AXiw1B4oBkhrmi6VaJjgN+PAWr/5c4=
X-Received: by 2002:a05:6e02:1b8d:b0:346:676f:3517 with SMTP id
 h13-20020a056e021b8d00b00346676f3517mr31062ili.11.1689977904125; Fri, 21 Jul
 2023 15:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
 <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com> <ZLiUrP9ZFMr/Wf4/@chao-email>
 <CALMp9eTQ5zDpjK+=e+Rhu=zvLv_f0scqkUCif2tveq+ahTAYCg@mail.gmail.com>
 <ZLjqVszO4AMx9F7T@chao-email> <CALMp9eSw9g0oRh7rT=Nd5aTwiu_zMz21tRrZG5D_QEfTn1h=HQ@mail.gmail.com>
 <ZLn9hgQy77x0hLil@chao-email> <20230721190114.xznm7xfnuxciufa3@desk>
 <CALMp9eTNM5VZzpSR6zbkjude6kxgBcOriWDoSkjanMmBtksKYw@mail.gmail.com> <20230721205404.kqxj3pspexjl6qai@desk>
In-Reply-To: <20230721205404.kqxj3pspexjl6qai@desk>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 21 Jul 2023 15:18:12 -0700
Message-ID: <CALMp9eSqe09RgwTQUe5Qi15E+Q+wm1QhO5P5-ryvF9OzV9gR0w@mail.gmail.com>
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

On Fri, Jul 21, 2023 at 1:54=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> On Fri, Jul 21, 2023 at 12:18:36PM -0700, Jim Mattson wrote:
> > > Please note that clearing STIBP bit on one thread does not disable ST=
IBP
> > > protection if the sibling has it set:
> > >
> > >   Setting bit 1 (STIBP) of the IA32_SPEC_CTRL MSR on a logical proces=
sor
> > >   prevents the predicted targets of indirect branches on any logical
> > >   processor of that core from being controlled by software that execu=
tes
> > >   (or executed previously) on another logical processor of the same c=
ore
> > >   [1].
> >
> > I stand corrected. For completeness, then, is it true now and
> > forevermore that passing IA32_SPEC_CTRL through to the guest for write
> > can in no way compromise code running on the sibling thread?
>
> As IA32_SPEC_CTRL is a thread-scope MSR, a malicious guest would be able
> to turn off the mitigation on its own thread only. Looking at the
> current controls in this MSR, I don't see how a malicious guest can
> compromise code running on sibling thread.

Does this imply that where core-shared resources are affected (as with
STIBP), the mitigation is enabled whenever at least one thread
requests it?

> But, I don't think there is a guarantee that future mitigations would
> not allow a malicious guest to compromise code running on sibling. To
> avoid this, care must be taken to add such mitigations to other MSRs
> that are not exported to guests.

Can you make sure that the right people at Intel get that message?
