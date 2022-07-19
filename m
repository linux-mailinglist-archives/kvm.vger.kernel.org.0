Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F7F57A49F
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 19:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbiGSRJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 13:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237779AbiGSRJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 13:09:19 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6906B4F657
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:09:18 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v67-20020a1cac46000000b003a1888b9d36so12421302wme.0
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AHFK/Ws0HkMtSGr6JyX7gyAaX6z2dwuYDOmxJ/uuHbM=;
        b=XYR3Qk2vD8KyHQSmdb6ChddMuI8wX9gtmxQeTkyAOHrh18Sl3ZOokOJUjndbgDd3OR
         UyYhwLS5ayUD419ocx49QYGct4CEl/d6JYemo9eaNuv5gVnrYyuaxymM+2/W6PNLeOJJ
         n1ekHRIDeGuFZDVmlGkYO5MJ+qo5LouCG86lBmYccW88q/PJd40T07d+fFNbntooeuXS
         6CAwF/jzOCu7TfDZMQrhOJIa35KLcSVN38dHLOSTnUciEzxOnwIAjdyEy078/CbYgjHv
         dBTD8mWr10tIluxSZ0jbWxtELcpMMipWq1MOfUD54KFoLrXNfzguXFMJO996LoIgjyDn
         rjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AHFK/Ws0HkMtSGr6JyX7gyAaX6z2dwuYDOmxJ/uuHbM=;
        b=2/GIlfWqIVAFMPbPV4UioaBhUGXdjHXZS3x9lFCjFYdHT1uGsDlbQU681gLrNNCMmr
         HmUXl/nLC76yYCcyCG0AESCPgXJuwUU56ERhHbJUNVk6etGfW8o+L05jBj6NfpHBRWjc
         DED1fa1bkrRbF4PQh40lMgQuBM/3hmfKm2cxsUfkToRvdydsTN5elwTVaEWbyx9hS51D
         Ki6MygdplM/H4CQFaYvKy0lwkE3VAbfAUC1L/Q20lei+QAPiFovI3Wo2N+/kqbmZ23o3
         VdBHpvDKJQQEHv0S7/aBGOqO1eSOvPSY7iRD93utoQRyZ2r0tFsY0cHs0C0l7iXH6q+n
         gMTw==
X-Gm-Message-State: AJIora8GU00TueJ2eLKlDSVwqdJkg3Ye25O589bIJ1yLWuhlX3T+LvU/
        6Xp20+4ph383jrsU2WEG/K8gYp9KUAU6LbkAxJmTDA==
X-Google-Smtp-Source: AGRyM1srBjMkatgJomJDmzmYp4yZG1rVQNKYI013Rwv53viY4pCO2XG83rMauV2CdR7GmxK95jrTlLqEuu8nUDGfvZ0=
X-Received: by 2002:a05:600c:2854:b0:3a3:1551:d7d with SMTP id
 r20-20020a05600c285400b003a315510d7dmr269156wmb.174.1658250556794; Tue, 19
 Jul 2022 10:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-6-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-6-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 10:09:04 -0700
Message-ID: <CAP-5=fUChJLqfJ__joVhtKwgjLTtBtMm8M0vt9eaOfLMmck85g@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 11, 2022 at 2:32 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> Factor out evsel__id_hdr_size() so it can be reused.
>
> This is needed by perf inject. When injecting events from a guest perf.data
> file, there is a possibility that the sample ID numbers conflict. To
> re-write an ID sample, the old one needs to be removed first, which means
> determining how big it is with evsel__id_hdr_size() and then subtracting
> that from the event size.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/evlist.c | 28 +---------------------------
>  tools/perf/util/evsel.c  | 26 ++++++++++++++++++++++++++
>  tools/perf/util/evsel.h  |  2 ++
>  3 files changed, 29 insertions(+), 27 deletions(-)
>
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 48af7d379d82..03fbe151b0c4 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -1244,34 +1244,8 @@ bool evlist__valid_read_format(struct evlist *evlist)
>  u16 evlist__id_hdr_size(struct evlist *evlist)
>  {
>         struct evsel *first = evlist__first(evlist);
> -       struct perf_sample *data;
> -       u64 sample_type;
> -       u16 size = 0;
>
> -       if (!first->core.attr.sample_id_all)
> -               goto out;
> -
> -       sample_type = first->core.attr.sample_type;
> -
> -       if (sample_type & PERF_SAMPLE_TID)
> -               size += sizeof(data->tid) * 2;
> -
> -       if (sample_type & PERF_SAMPLE_TIME)
> -               size += sizeof(data->time);
> -
> -       if (sample_type & PERF_SAMPLE_ID)
> -               size += sizeof(data->id);
> -
> -       if (sample_type & PERF_SAMPLE_STREAM_ID)
> -               size += sizeof(data->stream_id);
> -
> -       if (sample_type & PERF_SAMPLE_CPU)
> -               size += sizeof(data->cpu) * 2;
> -
> -       if (sample_type & PERF_SAMPLE_IDENTIFIER)
> -               size += sizeof(data->id);
> -out:
> -       return size;
> +       return first->core.attr.sample_id_all ? evsel__id_hdr_size(first) : 0;
>  }
>
>  bool evlist__valid_sample_id_all(struct evlist *evlist)
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index a67cc3f2fa74..9a30ccb7b104 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -2724,6 +2724,32 @@ int evsel__parse_sample_timestamp(struct evsel *evsel, union perf_event *event,
>         return 0;
>  }
>
> +u16 evsel__id_hdr_size(struct evsel *evsel)
> +{
> +       u64 sample_type = evsel->core.attr.sample_type;

As this just uses core, would it be more appropriate to put it in libperf?

> +       u16 size = 0;

Perhaps size_t or int? u16 seems odd.

> +
> +       if (sample_type & PERF_SAMPLE_TID)
> +               size += sizeof(u64);
> +
> +       if (sample_type & PERF_SAMPLE_TIME)
> +               size += sizeof(u64);
> +
> +       if (sample_type & PERF_SAMPLE_ID)
> +               size += sizeof(u64);
> +
> +       if (sample_type & PERF_SAMPLE_STREAM_ID)
> +               size += sizeof(u64);
> +
> +       if (sample_type & PERF_SAMPLE_CPU)
> +               size += sizeof(u64);
> +
> +       if (sample_type & PERF_SAMPLE_IDENTIFIER)
> +               size += sizeof(u64);
> +
> +       return size;
> +}
> +
>  struct tep_format_field *evsel__field(struct evsel *evsel, const char *name)
>  {
>         return tep_find_field(evsel->tp_format, name);
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 92bed8e2f7d8..699448f2bc2b 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -381,6 +381,8 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
>  int evsel__parse_sample_timestamp(struct evsel *evsel, union perf_event *event,
>                                   u64 *timestamp);
>
> +u16 evsel__id_hdr_size(struct evsel *evsel);
> +

A comment would be nice, I know this is just moving code about but
this is a new function.

Thanks,
Ian

>  static inline struct evsel *evsel__next(struct evsel *evsel)
>  {
>         return list_entry(evsel->core.node.next, struct evsel, core.node);
> --
> 2.25.1
>
