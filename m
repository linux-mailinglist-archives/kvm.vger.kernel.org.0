Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA40657A2B2
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 17:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238141AbiGSPNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 11:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiGSPNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 11:13:34 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF6454059
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 08:13:33 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id ay11-20020a05600c1e0b00b003a3013da120so10197394wmb.5
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 08:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7HHHNGlzReGWpd/M8GTS31oYQW+jdBsAvEwbqXn8OjQ=;
        b=S1Vmx96rAFfuPzXa+NUsz0wgYJDKlsJ3hxZsaT0u9rxWcPHip2TGaynvrPrZGRvd85
         Ttj0mKr6NNMfzmMRqTKtUS5fKtVFWB6hmwTzQkTG6dQwzl2h+upGnqbnIs1ExrAf2+7+
         HRITGBYozO3KvagIppG13VfprYeD7o0vGUUN/jp0zsK/7s9qgQgvzVhFS6HqdsSsCSST
         TQu116z3NAr/SaCQO62/MrUzGmx5K7/86DYAi11YruXs13qQ+ulWPFMHS3qbzdNH9vS0
         MZ0ezDB+ThQ51G7mxcANuo/WHQ9sUDB7LUIYFX5FHkHFZYfedHblBxw6AtWhgbBMfWUU
         7XGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7HHHNGlzReGWpd/M8GTS31oYQW+jdBsAvEwbqXn8OjQ=;
        b=jbJdzlgVIk72pQ1DXubrIn22DvE9TL7EQtcEBLLqxuIV2gOBZRuNqlu/0RB3cxQbTE
         e851IO63bxu6sCLTVyZ2mXkJYDpsa6fPQI7S+j7QH3BV4N3WvrueTn/M11PKDDtDQMqy
         gj6HvECIs0Wd59zqedff/btGaLywkW+XT3RrcXhDW3vB40Gr1qhDtiJbxu3S8PsZtoCK
         yomCW4t7v7JIx6xBT375yQ/tBnQ7kwJJmwbH6BhSbhloDaUDi+fj0OJkMEswvZENO4Qs
         l4t4r0Oo8AaOiM5hFXKaCZ+8fBoXTDLkEhroC84e67C+jVmZQYHNJB2QyVbN9ChNOKyu
         oxPA==
X-Gm-Message-State: AJIora8sd5NvlA8id04yScWM3xZ3bqkHjvegqoxP/vz9ensiLcjMFw8r
        2AY5olbKRHc4q0P8z2wZ9t6KMKTJqPSIMvGoWuB8efX16to8gA==
X-Google-Smtp-Source: AGRyM1vJY7xVDoyVyew7rR5ALwnOHq3ZsMbJ6fPNuiVCBFDnClCKeKypl3zILKTzucKv/N9Nnpkb+rijCA1Lit7z9z8=
X-Received: by 2002:a05:600c:2854:b0:3a3:1551:d7d with SMTP id
 r20-20020a05600c285400b003a315510d7dmr13704233wmb.174.1658243611702; Tue, 19
 Jul 2022 08:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-2-adrian.hunter@intel.com> <YtV0vXJLbfTywZ1B@kernel.org>
 <569b5766-eb6f-8811-c5e5-f5a6972a0fd5@intel.com>
In-Reply-To: <569b5766-eb6f-8811-c5e5-f5a6972a0fd5@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 08:13:18 -0700
Message-ID: <CAP-5=fXF1VRKjjBt+kv7QqQSbLonaZZoo__2qT1MtvHSZueEEw@mail.gmail.com>
Subject: Re: [PATCH 01/35] perf tools: Fix dso_id inode generation comparison
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Jul 19, 2022 at 3:18 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> On 18/07/22 17:57, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Jul 11, 2022 at 12:31:44PM +0300, Adrian Hunter escreveu:
> >> Synthesized MMAP events have zero ino_generation, so do not compare zero
> >> values.
> >>
> >> Fixes: 0e3149f86b99 ("perf dso: Move dso_id from 'struct map' to 'struct dso'")
> >> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> >> ---
> >>  tools/perf/util/dsos.c | 10 ++++++++--
> >>  1 file changed, 8 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/tools/perf/util/dsos.c b/tools/perf/util/dsos.c
> >> index b97366f77bbf..839a1f384733 100644
> >> --- a/tools/perf/util/dsos.c
> >> +++ b/tools/perf/util/dsos.c
> >> @@ -23,8 +23,14 @@ static int __dso_id__cmp(struct dso_id *a, struct dso_id *b)
> >>      if (a->ino > b->ino) return -1;
> >>      if (a->ino < b->ino) return 1;
> >>
> >> -    if (a->ino_generation > b->ino_generation) return -1;
> >> -    if (a->ino_generation < b->ino_generation) return 1;
> >> +    /*
> >> +     * Synthesized MMAP events have zero ino_generation, so do not compare
> >> +     * zero values.
> >> +     */
> >> +    if (a->ino_generation && b->ino_generation) {
> >> +            if (a->ino_generation > b->ino_generation) return -1;
> >> +            if (a->ino_generation < b->ino_generation) return 1;
> >> +    }
> >
> > But comparing didn't harm right? when its !0 now we may have three
> > comparisions instead of 2 :-\
> >
> > The comment has some value tho, so I'm merging this :-)
>
> Thanks. I found it harmful because the mismatch resulted in a new
> dso that did not have a build ID whereas the original dso did have
> a build ID.  The build ID was essential because the object was not
> found otherwise.

That's good to know, could we add that also to the comment? Perhaps:

Synthesized MMAP events have zero ino_generation, avoid comparing them
with MMAP events with actual ino_generation.

Thanks,
Ian
