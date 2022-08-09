Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC1158DCCC
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 19:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245229AbiHIRHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 13:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245289AbiHIRHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 13:07:46 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D5C20BD1
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 10:07:44 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j1so15055706wrw.1
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 10:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VJbu0Vi6JsT3Ge0NwSkLjoyGgFVaYGY0641GU+LZJhY=;
        b=fvzM2GUUaZrmgyVaFSQsiiQM6O8bpQ/PHWn3++zGuNq8x5xtQK6QUVR+M6h/6+eyVl
         BFh1AMDIrR0975z9iHhMgrOs3gvIryx6m0goQhg4HIxelRl4ejAApEZyZIOCZWZPS+3H
         mDCMikiOSOjQgNN1pfpNxeG0l0TLzGV/AO4HjsTWeUVbhKLVPT+WNkxahiDHH+ad240E
         BOfsX+l6T+Ryuijm/PB6KafjYGc37tS4PbGk7elfEA+jENKRYefWU2GdCa80YgS5odqA
         1okFqqk+BPMfXfqESUGDnOikPzimREsT6/x38FcXY3TMg5pHO+ovKb+hXqYKNs7JLLCS
         tDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VJbu0Vi6JsT3Ge0NwSkLjoyGgFVaYGY0641GU+LZJhY=;
        b=QZafIHv9z1MSN6JuqVvBjHj3N67xRmA6UhUSmFPRspi+gsGjg456VwnnZaEZ+9DK/T
         rMzpWAyKtxsoTjouQ4QxFvnzyOXplOBzYv21mOxOKtmBb/0Mkv5rCld+2aDtoDkgARfU
         TheEESwegeHVh5klT856271OdxaQRyqIG3YSJLDQm7m9Ab/i08ZsbUvHBqqInIXHvplI
         +aE1yBBae23xCLjR0nd+Ed8po/Ho1Ahc2zcN4LJ4uYUf1WqYWQNJ0Us31YiFG/bWxuAm
         GrpN903SBZOIk+t2m85Fo74RIV0zQwo3LyAvjbtUcWN/QUo3dPOLE4Bf11f89f+kgV8B
         Wt0g==
X-Gm-Message-State: ACgBeo06envojjQi51PuTG8DTw+81GV3btgI2PeiNofgON0AceSxzC2+
        jiXz5DMOpKI3bopXtTPK+SNRDTjJwVINRhJVkA6OIQ==
X-Google-Smtp-Source: AA6agR6C6pGEJaHlcmIccbzG3l/LXUY9JxyRHbDjX/tgVsupnrZl7Tfk4Mg07ARiaMT3fu1Krv5Y6YtR9iIcV6+0gNU=
X-Received: by 2002:adf:e28d:0:b0:21e:4c3b:b446 with SMTP id
 v13-20020adfe28d000000b0021e4c3bb446mr14597055wri.300.1660064863280; Tue, 09
 Aug 2022 10:07:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-6-adrian.hunter@intel.com> <CAP-5=fUChJLqfJ__joVhtKwgjLTtBtMm8M0vt9eaOfLMmck85g@mail.gmail.com>
 <0e415212-b828-34d3-fd1b-ba518149bf89@intel.com>
In-Reply-To: <0e415212-b828-34d3-fd1b-ba518149bf89@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 9 Aug 2022 10:07:30 -0700
Message-ID: <CAP-5=fXNWfn_SX6aBHAQ=RPRHwDpnTmV_QpRoHRWX-J06TZ-BA@mail.gmail.com>
Subject: Re: [PATCH 05/35] perf tools: Factor out evsel__id_hdr_size()
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
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 9, 2022 at 4:50 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> On 19/07/22 20:09, Ian Rogers wrote:
> > On Mon, Jul 11, 2022 at 2:32 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
> >>
> >> Factor out evsel__id_hdr_size() so it can be reused.
> >>
> >> This is needed by perf inject. When injecting events from a guest perf.data
> >> file, there is a possibility that the sample ID numbers conflict. To
> >> re-write an ID sample, the old one needs to be removed first, which means
> >> determining how big it is with evsel__id_hdr_size() and then subtracting
> >> that from the event size.
> >>
> >> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> >> ---
> >>  tools/perf/util/evlist.c | 28 +---------------------------
> >>  tools/perf/util/evsel.c  | 26 ++++++++++++++++++++++++++
> >>  tools/perf/util/evsel.h  |  2 ++
> >>  3 files changed, 29 insertions(+), 27 deletions(-)
> >>
> >> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> >> index 48af7d379d82..03fbe151b0c4 100644
> >> --- a/tools/perf/util/evlist.c
> >> +++ b/tools/perf/util/evlist.c
> >> @@ -1244,34 +1244,8 @@ bool evlist__valid_read_format(struct evlist *evlist)
> >>  u16 evlist__id_hdr_size(struct evlist *evlist)
> >>  {
> >>         struct evsel *first = evlist__first(evlist);
> >> -       struct perf_sample *data;
> >> -       u64 sample_type;
> >> -       u16 size = 0;
> >>
> >> -       if (!first->core.attr.sample_id_all)
> >> -               goto out;
> >> -
> >> -       sample_type = first->core.attr.sample_type;
> >> -
> >> -       if (sample_type & PERF_SAMPLE_TID)
> >> -               size += sizeof(data->tid) * 2;
> >> -
> >> -       if (sample_type & PERF_SAMPLE_TIME)
> >> -               size += sizeof(data->time);
> >> -
> >> -       if (sample_type & PERF_SAMPLE_ID)
> >> -               size += sizeof(data->id);
> >> -
> >> -       if (sample_type & PERF_SAMPLE_STREAM_ID)
> >> -               size += sizeof(data->stream_id);
> >> -
> >> -       if (sample_type & PERF_SAMPLE_CPU)
> >> -               size += sizeof(data->cpu) * 2;
> >> -
> >> -       if (sample_type & PERF_SAMPLE_IDENTIFIER)
> >> -               size += sizeof(data->id);
> >> -out:
> >> -       return size;
> >> +       return first->core.attr.sample_id_all ? evsel__id_hdr_size(first) : 0;
> >>  }
> >>
> >>  bool evlist__valid_sample_id_all(struct evlist *evlist)
> >> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> >> index a67cc3f2fa74..9a30ccb7b104 100644
> >> --- a/tools/perf/util/evsel.c
> >> +++ b/tools/perf/util/evsel.c
> >> @@ -2724,6 +2724,32 @@ int evsel__parse_sample_timestamp(struct evsel *evsel, union perf_event *event,
> >>         return 0;
> >>  }
> >>
> >> +u16 evsel__id_hdr_size(struct evsel *evsel)
> >> +{
> >> +       u64 sample_type = evsel->core.attr.sample_type;
> >
> > As this just uses core, would it be more appropriate to put it in libperf?
>
> AFAIK we move to libperf only as needed.

I don't think there is an expectation yet that libperf is stable - I
hope not as I need to nuke the CPU map empty function. So, the cost of
putting something there rather than perf is minimal, and perf can be
just a consumer of libperf as any other tool - which builds confidence
the API in libperf is complete. Jiri has posted patches in the past
migrating parse-events, there's no "need" for that but the point is to
improve the library API. I think this is the same case and minimal
cost given only core is being used. Given we're actively migrating
util APIs to libperf I think it is better to introduce simple APIs
like this in libperf rather than creating something that someone will
later have to migrate.

> >
> >> +       u16 size = 0;
> >
> > Perhaps size_t or int? u16 seems odd.
>
> Event header size member is 16-bit

sizeof is generally considered size_t so the code as-is has implicit
truncation - again I'll stand by it looking odd.

Thanks,
Ian

> >
> >> +
> >> +       if (sample_type & PERF_SAMPLE_TID)
> >> +               size += sizeof(u64);
> >> +
> >> +       if (sample_type & PERF_SAMPLE_TIME)
> >> +               size += sizeof(u64);
> >> +
> >> +       if (sample_type & PERF_SAMPLE_ID)
> >> +               size += sizeof(u64);
> >> +
> >> +       if (sample_type & PERF_SAMPLE_STREAM_ID)
> >> +               size += sizeof(u64);
> >> +
> >> +       if (sample_type & PERF_SAMPLE_CPU)
> >> +               size += sizeof(u64);
> >> +
> >> +       if (sample_type & PERF_SAMPLE_IDENTIFIER)
> >> +               size += sizeof(u64);
> >> +
> >> +       return size;
> >> +}
> >> +
> >>  struct tep_format_field *evsel__field(struct evsel *evsel, const char *name)
> >>  {
> >>         return tep_find_field(evsel->tp_format, name);
> >> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> >> index 92bed8e2f7d8..699448f2bc2b 100644
> >> --- a/tools/perf/util/evsel.h
> >> +++ b/tools/perf/util/evsel.h
> >> @@ -381,6 +381,8 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
> >>  int evsel__parse_sample_timestamp(struct evsel *evsel, union perf_event *event,
> >>                                   u64 *timestamp);
> >>
> >> +u16 evsel__id_hdr_size(struct evsel *evsel);
> >> +
> >
> > A comment would be nice, I know this is just moving code about but
> > this is a new function.
> >
> > Thanks,
> > Ian
> >
> >>  static inline struct evsel *evsel__next(struct evsel *evsel)
> >>  {
> >>         return list_entry(evsel->core.node.next, struct evsel, core.node);
> >> --
> >> 2.25.1
> >>
>
