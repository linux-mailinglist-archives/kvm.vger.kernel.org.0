Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8B957AB05
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiGTAhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237461AbiGTAhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:37:14 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFD34E629
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:37:11 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z13so4362609wro.13
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V0PYLmnrHVGb/fEMdvljKjnfHXOxiDFIAmN3LqpuHZg=;
        b=lsL8XtGr4K9lSPudD9dZ2nWbEtXLzl7AXIb7DGBd4G0qUZdKxgThtETNx/BeLWtlOm
         RXXbXI4rSHP9jkxEnPSNCwXti6RAvr01MosdQq/NW5541VIDZoBu1Hzy/jRM7m2sjX4S
         S/IV6s3t4H8ZGpYsIj8UOdcruPeZgLNRk9de2YlKSQ01heBawSqs5lVXWwiiKnsEzR/q
         4wd29NPHWIGDka8VHn0eHOLKDx1WEzXPxW23ZMlzEpBctGBa6+SFtrRdytZGO39hRfBW
         Ut/F7JONLXFooabApVWAJ72gnP0A4UjaHK4GdxfhbuEW4U4ZV9yodPf+7UCJAxs1L4dv
         rx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V0PYLmnrHVGb/fEMdvljKjnfHXOxiDFIAmN3LqpuHZg=;
        b=rsTEnJy9FBVBDxGgo+1N0z9tiRxo8TZFxSP7xSgpSDsT6dqcXn1nMSRbUfztNXXXMc
         1U3d66p60TpEU5MxAmtrkjALfEtSv5SrTDpzbOVTcvY89/8zlXV+akMSwTGUXy9eivFm
         LR9yfAbo9s1wSJcexIdP2m1XCSJ4BVq7ds5QndU7XVG1o5XYnrr/GDkTURSv0wvP6cLB
         tO93dCxZrJB6Nv0BTgJQDevTUEgKx3TSiK9rkS+rayjknGmT0eRyopdHp9PaSNg6jQaT
         Ic4CQA6o4aRA0ZGScxBTazj4+Gopj9Fg4vXfDlJ2oTZhd8TgeMkWGmb2VacV9vmgdbuF
         9MCw==
X-Gm-Message-State: AJIora/NCGbEv8ukOBzRm5Pjfnrhy8nlMD7IOPY9XmK9PxjPsY5My/Pp
        oy80gmhYZDrQFHHXrMOsaEx3xlLiQm6usPFyfglUdg==
X-Google-Smtp-Source: AGRyM1t38kromuQVuwamWeriQrLtJqP3GfY2A3DIwLLesXKdQKo0y2EbOmN20GAxUmhMpx63D+Bc2OiU+WI4yrYRp24=
X-Received: by 2002:a5d:6a4c:0:b0:21e:46d4:6eec with SMTP id
 t12-20020a5d6a4c000000b0021e46d46eecmr1618956wrw.375.1658277429903; Tue, 19
 Jul 2022 17:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-14-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-14-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 17:36:57 -0700
Message-ID: <CAP-5=fXTTbzjsV=SWLXpdNLkK=5bVuCyEQH8bPw_Q6izgoJR6A@mail.gmail.com>
Subject: Re: [PATCH 13/35] perf tools: Add machine_pid and vcpu to perf_sample
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

On Mon, Jul 11, 2022 at 2:33 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> When parsing a sample with a sample ID, copy machine_pid and vcpu from
> perf_sample_id to perf_sample.
>
> Note, machine_pid will be zero when unused, so only a non-zero value
> represents a guest machine. vcpu should be ignored if machine_pid is zero.
>
> Note also, machine_pid is used with events that have come from injecting a
> guest perf.data file, however guest events recorded on the host (i.e. using
> perf kvm) have the (QEMU) hypervisor process pid to identify them - refer
> machines__find_for_cpumode().
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/event.h  |  2 ++
>  tools/perf/util/evlist.c | 14 +++++++++++++-
>  tools/perf/util/evsel.c  |  1 +
>  3 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> index cdd72e05fd28..a660f304f83c 100644
> --- a/tools/perf/util/event.h
> +++ b/tools/perf/util/event.h
> @@ -148,6 +148,8 @@ struct perf_sample {
>         u64 code_page_size;
>         u64 cgroup;
>         u32 flags;
> +       u32 machine_pid;
> +       u32 vcpu;
>         u16 insn_len;
>         u8  cpumode;
>         u16 misc;
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 03fbe151b0c4..64f5a8074c0c 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -1507,10 +1507,22 @@ int evlist__start_workload(struct evlist *evlist)
>  int evlist__parse_sample(struct evlist *evlist, union perf_event *event, struct perf_sample *sample)
>  {
>         struct evsel *evsel = evlist__event2evsel(evlist, event);
> +       int ret;
>
>         if (!evsel)
>                 return -EFAULT;
> -       return evsel__parse_sample(evsel, event, sample);
> +       ret = evsel__parse_sample(evsel, event, sample);
> +       if (ret)
> +               return ret;
> +       if (perf_guest && sample->id) {
> +               struct perf_sample_id *sid = evlist__id2sid(evlist, sample->id);
> +
> +               if (sid) {
> +                       sample->machine_pid = sid->machine_pid;
> +                       sample->vcpu = sid->vcpu.cpu;
> +               }
> +       }
> +       return 0;
>  }
>
>  int evlist__parse_sample_timestamp(struct evlist *evlist, union perf_event *event, u64 *timestamp)
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 9a30ccb7b104..14396ea5a968 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -2365,6 +2365,7 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
>         data->misc    = event->header.misc;
>         data->id = -1ULL;
>         data->data_src = PERF_MEM_DATA_SRC_NONE;
> +       data->vcpu = -1;
>
>         if (event->header.type != PERF_RECORD_SAMPLE) {
>                 if (!evsel->core.attr.sample_id_all)
> --
> 2.25.1
>
