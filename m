Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E305C57A4B0
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 19:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbiGSRML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 13:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238253AbiGSRMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 13:12:09 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982003E748
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:12:02 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id p26-20020a1c545a000000b003a2fb7c1274so7820197wmi.1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+iAMKSPyDppnW2drRMfC/DPQpbs37SaFNxH0H50ARZI=;
        b=O4NZkZYPqKMHT4nkgfKSUBmSRXIHX7Xjwz9LKUGh/yri9UiZab70JDTT2lnPU0ifjW
         1ygD5BQogbi6L/wnERj2t3rJ5JSbFWL5rDHKQqBPVThyrDAYX96sulwjrLwIWFwHOg1u
         pHwSnoF3JuH/x/+9T5ImiOHCy7LF/41/RkzmYG1GETdJkp8MHUMyVG/OABGriwDV8Xte
         VGByh68mkeH3usd3nsyx9xEHVcVUMIZ1rapz0kznz/fThMO7VjVj9e+LZ9OeMRmL/EMy
         h5qSsDGG51BUntktLnJ9rGdi2Atg0gbNZP/u/rq8NvWQX2pORSF+RhkfKtKrYLa1BSHG
         tlbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+iAMKSPyDppnW2drRMfC/DPQpbs37SaFNxH0H50ARZI=;
        b=c0s37AYQcAvwsS1JMiF9h5Bs7XFe0oQAqhsQ5px675uR7cY1GJDokTKQmMZJYeYdmy
         pBOq1dYH7QQzd+u34crDLrJl32RTpMlrjuhRcbklGi3Duj8z34craY951MJTgT99FA5h
         w6A53E+WjZgGbqsjqxOV40e3JbPGVrKPwe0XJ2DNF2lTW5lU801T9984TKFnxIUbPL/2
         X1jwJ7OHwS52K5jj9a9z2KhxHZO/60zyoKWkuWuybS2yhuidtMuEZIC1fwrHUml+LfIA
         oAoPoRmQoa1UAG62A+xBN2EJIdkZ+aJxpJjlFCSmrygd8jYb69qyEXLXIO1POrhCOwbd
         krtg==
X-Gm-Message-State: AJIora/ku/zWcuLK5ttQQZLRfT8Nob+MihXC+5V53RipJEFTPhZZFpVE
        /H3YWSgLLHLll2mMCTT6XIpbQ+gu0Xkd2yt4MnSYJ2SMF5JkS2Co
X-Google-Smtp-Source: AGRyM1tSnTrIGMlPQIc7VTFsvWbxlskp6X+tgzxneY4fax0JYBtF4IpoL7Y1h3CUtrD+EWH9+RyBdQCDNqpZLHZ8vMY=
X-Received: by 2002:a05:600c:4e8f:b0:3a1:8b21:ebbc with SMTP id
 f15-20020a05600c4e8f00b003a18b21ebbcmr266369wmq.149.1658250721039; Tue, 19
 Jul 2022 10:12:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-8-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-8-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 10:11:49 -0700
Message-ID: <CAP-5=fXtV=p_N=hQPUXzw6TV4st=qpEp7U8H-eDZJgr2BoiVeQ@mail.gmail.com>
Subject: Re: [PATCH 07/35] perf script: Add --dump-unsorted-raw-trace option
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
> When reviewing the results of perf inject, it is useful to be able to see
> the events in the order they appear in the file.
>
> So add --dump-unsorted-raw-trace option to do an unsorted dump.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/Documentation/perf-script.txt | 3 +++
>  tools/perf/builtin-script.c              | 8 ++++++++
>  2 files changed, 11 insertions(+)
>
> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index 1a557ff8f210..e250ff5566cf 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -79,6 +79,9 @@ OPTIONS
>  --dump-raw-trace=::
>          Display verbose dump of the trace data.
>
> +--dump-unsorted-raw-trace=::
> +        Same as --dump-raw-trace but not sorted in time order.
> +
>  -L::
>  --Latency=::
>          Show latency attributes (irqs/preemption disabled, etc).
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 7cf21ab16f4f..4b00a50faf00 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -3746,6 +3746,7 @@ int cmd_script(int argc, const char **argv)
>         bool header = false;
>         bool header_only = false;
>         bool script_started = false;
> +       bool unsorted_dump = false;
>         char *rec_script_path = NULL;
>         char *rep_script_path = NULL;
>         struct perf_session *session;
> @@ -3794,6 +3795,8 @@ int cmd_script(int argc, const char **argv)
>         const struct option options[] = {
>         OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
>                     "dump raw trace in ASCII"),
> +       OPT_BOOLEAN(0, "dump-unsorted-raw-trace", &unsorted_dump,
> +                   "dump unsorted raw trace in ASCII"),
>         OPT_INCR('v', "verbose", &verbose,
>                  "be more verbose (show symbol address, etc)"),
>         OPT_BOOLEAN('L', "Latency", &latency_format,
> @@ -3956,6 +3959,11 @@ int cmd_script(int argc, const char **argv)
>         data.path  = input_name;
>         data.force = symbol_conf.force;
>
> +       if (unsorted_dump) {
> +               dump_trace = true;
> +               script.tool.ordered_events = false;
> +       }
> +
>         if (symbol__validate_sym_arguments())
>                 return -1;
>
> --
> 2.25.1
>
