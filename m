Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533FA57A4AA
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 19:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbiGSRLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 13:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238088AbiGSRLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 13:11:08 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D2422515
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:11:05 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r2so21556164wrs.3
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0U6fFMNRGt64/ZNwg0Bl8o9WpVFF8ad2BEFkhwhwe4M=;
        b=FivoyDEe90QI6Fk72v2k312X2pcxdyt3pf8Vd3xHZ7HJqE85IzFr1KEoZEBQ3K8p5c
         ZIxRSfXd5GNh6vmA4J8L9bc3wkkGstJw8Bqo9zqPP1RIS+OgLfl7S2WTZux0UB0bndoM
         UoQuZf9v7kfaXJL4nuu4kpFNwplRGnsNthODV0VA9vr0D+ArUE3jdN3pZmRlGIHebeCc
         /3B88FMQEvC7hvmeXpJrqkfYsNX8Z3krnQ4XUfxUsLi6WdQOKk/EhZZP4Jy8OV3toGks
         c4cMjzRR6R05dloNM/aw4ax7kAQFFLHWGO+0C5IYy9ua0gC+2EeykTqvAQ+KQHeeF0ta
         6TRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0U6fFMNRGt64/ZNwg0Bl8o9WpVFF8ad2BEFkhwhwe4M=;
        b=RS5W2bQRsMD8dEQifJ3Hf4XcbtdkESLgedLtCuid0Qd3+derQgzpWcUygJmSEWRSlB
         fk+jjEJFDh3xbCjM3LJfIcMZMloI4sJH19RMgbfhc2jLMYQJVVnpoFIDwXuZR5UvdbV1
         k7EbyE38W/xUqVRsYnIrcqZtX9VZrxum48Kv/AHy8fezvRKkBX0mDgYtOjwaJ7zIJIj/
         S7mMnm5w2M78i7zk/L5/vFh4SLegQl1TWwfuQkWs3KO7VE3fxzgmaSsdDnmX+O6YnbzL
         iPbGug2P0I7L626c0c3b3pFFwUciKdb6J91/zXu1FQBtbRfXViSOVZog24jHDbTE044E
         PnCQ==
X-Gm-Message-State: AJIora/ZqukUxnBpUWyqMyCaUSLkUe2yPbdopLJ5JokrHbgDAP3iTiQf
        pX6yjEUiAoy+qKh9iu77hFmf9nQskiQK4P0+4zQ9yw==
X-Google-Smtp-Source: AGRyM1urMbzZiBsPEsUy9+LfgjDfiqi9bQuKKDQPv1QsIg6xxUkAXj5pogsv2jhGa3R5JhxVZWsDbSaBA0osGoVErtI=
X-Received: by 2002:a5d:4d8e:0:b0:21d:68d4:56eb with SMTP id
 b14-20020a5d4d8e000000b0021d68d456ebmr26823510wru.40.1658250663799; Tue, 19
 Jul 2022 10:11:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-7-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-7-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 10:10:51 -0700
Message-ID: <CAP-5=fVXE9FbuZ10W=TN5Xn0hPZ5eHVABkdQdj-V7QDYpKgVeQ@mail.gmail.com>
Subject: Re: [PATCH 06/35] perf tools: Add perf_event__synthesize_id_sample()
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

On Mon, Jul 11, 2022 at 2:32 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> Add perf_event__synthesize_id_sample() to enable the synthesis of
> ID samples.
>
> This is needed by perf inject. When injecting events from a guest perf.data
> file, there is a possibility that the sample ID numbers conflict. In that
> case, perf_event__synthesize_id_sample() can be used to re-write the ID
> sample.

This is great documentation, it would be nice to capture it with the
function declaration.

Thanks,
Ian

> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/synthetic-events.c | 47 ++++++++++++++++++++++++++++++
>  tools/perf/util/synthetic-events.h |  1 +
>  2 files changed, 48 insertions(+)
>
> diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
> index fe5db4bf0042..ed9623702f34 100644
> --- a/tools/perf/util/synthetic-events.c
> +++ b/tools/perf/util/synthetic-events.c
> @@ -1712,6 +1712,53 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type, u64 read_fo
>         return 0;
>  }
>
> +int perf_event__synthesize_id_sample(__u64 *array, u64 type, const struct perf_sample *sample)
> +{
> +       __u64 *start = array;
> +
> +       /*
> +        * used for cross-endian analysis. See git commit 65014ab3
> +        * for why this goofiness is needed.
> +        */
> +       union u64_swap u;
> +
> +       if (type & PERF_SAMPLE_TID) {
> +               u.val32[0] = sample->pid;
> +               u.val32[1] = sample->tid;
> +               *array = u.val64;
> +               array++;
> +       }
> +
> +       if (type & PERF_SAMPLE_TIME) {
> +               *array = sample->time;
> +               array++;
> +       }
> +
> +       if (type & PERF_SAMPLE_ID) {
> +               *array = sample->id;
> +               array++;
> +       }
> +
> +       if (type & PERF_SAMPLE_STREAM_ID) {
> +               *array = sample->stream_id;
> +               array++;
> +       }
> +
> +       if (type & PERF_SAMPLE_CPU) {
> +               u.val32[0] = sample->cpu;
> +               u.val32[1] = 0;
> +               *array = u.val64;
> +               array++;
> +       }
> +
> +       if (type & PERF_SAMPLE_IDENTIFIER) {
> +               *array = sample->id;
> +               array++;
> +       }
> +
> +       return (void *)array - (void *)start;
> +}
> +
>  int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process,
>                                     struct evlist *evlist, struct machine *machine)
>  {
> diff --git a/tools/perf/util/synthetic-events.h b/tools/perf/util/synthetic-events.h
> index 78a0450db164..b136ec3ec95d 100644
> --- a/tools/perf/util/synthetic-events.h
> +++ b/tools/perf/util/synthetic-events.h
> @@ -55,6 +55,7 @@ int perf_event__synthesize_extra_attr(struct perf_tool *tool, struct evlist *evs
>  int perf_event__synthesize_extra_kmaps(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
>  int perf_event__synthesize_features(struct perf_tool *tool, struct perf_session *session, struct evlist *evlist, perf_event__handler_t process);
>  int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process, struct evlist *evlist, struct machine *machine);
> +int perf_event__synthesize_id_sample(__u64 *array, u64 type, const struct perf_sample *sample);
>  int perf_event__synthesize_kernel_mmap(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
>  int perf_event__synthesize_mmap_events(struct perf_tool *tool, union perf_event *event, pid_t pid, pid_t tgid, perf_event__handler_t process, struct machine *machine, bool mmap_data);
>  int perf_event__synthesize_modules(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
> --
> 2.25.1
>
