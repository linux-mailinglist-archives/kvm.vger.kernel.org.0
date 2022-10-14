Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219615FF657
	for <lists+kvm@lfdr.de>; Sat, 15 Oct 2022 00:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJNWTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 18:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJNWSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 18:18:31 -0400
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291801E0455;
        Fri, 14 Oct 2022 15:18:23 -0700 (PDT)
Received: by mail-oi1-f172.google.com with SMTP id w196so6481998oiw.8;
        Fri, 14 Oct 2022 15:18:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cv1UBJfQzFJqm9MKrYEI4Znkn0nH6Ew1AYP8Zj5KlyY=;
        b=4+uoCLhQgJh8gn47FIutjI+KQW48uW2qWCREq8YS+gR6cRrUE0uhvfMLOlo3OJbC+N
         eAWCxC0ly5TZ6qzA1VSiORHQvlzY9xCzW+N9Nd/FFaiZEYBPaaFBrYATJT7fz0/za+9+
         L9btK5vEqX5+tWPkbb4QTW5iL/DAEMjAQOqsKzV9Q4SoWkUYYCVk6irwnBl5zPHpMDR4
         /72An05tlmnNSMv/ohhuZU5Lj/jQEXFYieNRlodInHiTUAVcmlbIiJ57oS7owHL06vxK
         5FO1f2yts7hYbbdlJFWgBF7gsmNKI3/IGSPJVyeQ9/09DCWspUZor7DWsVa5LeWEeM7A
         A8zw==
X-Gm-Message-State: ACrzQf0rC0gDl93dVqawOvZhah8mSWooxBySHcyODs9x4tC5EwsKj3uJ
        qBegVCEyF5mao/33pJjktueQwCIVQJwQISaHH3s=
X-Google-Smtp-Source: AMsMyM7RcSpNsrdTB3IMVoBjep6aChMvzNXIw7J/EQwCOamIINOB833PUrM8CKc1Dr591uE93IP4/i+8N7GjctPKlJA=
X-Received: by 2002:a05:6808:181e:b0:350:e92a:9ab1 with SMTP id
 bh30-20020a056808181e00b00350e92a9ab1mr14639oib.209.1665785817076; Fri, 14
 Oct 2022 15:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220922071017.17398-1-dongli.zhang@oracle.com>
In-Reply-To: <20220922071017.17398-1-dongli.zhang@oracle.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Fri, 14 Oct 2022 15:16:45 -0700
Message-ID: <CAM9d7cj8z+ryyzUHR+P1Dcpot2jjW+Qcc4CPQpfafTXN=LEU0Q@mail.gmail.com>
Subject: Re: [PATCH RFC 1/1] perf stat: do not fatal if the leader is errored
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     linux-perf-users <linux-perf-users@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, joe.jin@oracle.com,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Thu, Sep 22, 2022 at 12:10 AM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>
> Add kvm@vger.kernel.org as this issue is in virtualization env.
>
> The topdown metrics events became default since
> commit 42641d6f4d15 ("perf stat: Add Topdown metrics events as default
> events"). The perf will use 'slots' if the
> /sys/bus/event_source/devices/cpu/events/slots is available.
>
> Unfortunately, the 'slots' may not be supported in the virualization
> environment. The hypervisor may not expose the 'slots' counter to the VM
> in cpuid. As a result, the kernel may disable topdown slots and metrics
> events in intel_pmu_init() if slots event is not in CPUID. E.g., both
> c->weight and c->idxmsk64 are set to 0.
>
> There will be below error on Icelake VM since 'slots' is the leader:
>
> $ perf stat
> Error:
> The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (slots).
> /bin/dmesg | grep -i perf may provide additional information.
>
> This is because the stat_handle_error() returns COUNTER_FATAL when the
> 'slots' is used as leader of events.
>
> There are three options to fix the issue.
>
> 1. Do not expose /sys/bus/event_source/devices/cpu/events/slots to
> userspace so that pmu_have_event(pmu->name, "slots") returns false.
>
> 2. Run cpuid at perf userspace and avoid using 'slots' if it is not
> supported in cpuid.
>
> 3. Do not fatal perf if the leader is failed. Do not create events for an
> evsel if its leader is already failed.
>
> This RFC patch is with the 3rd option. Would you mind suggesting which
> option is better?

Sorry for the late reply but I think option 1 is the way to go.

The option 3 would be a transient workaround and it would affect
other events too.  If it's really needed, I think option 2 is slightly better
than option 3.  Or, we can add --force option to skip non-supported
events explicitly.

Thanks,
Namhyung

>
> Here is the output of patch.
>
> $ perf stat -v
> Using CPUID GenuineIntel-6-6A-6
> slots -> cpu/event=0,umask=0x4/
> topdown-retiring -> cpu/event=0,umask=0x80/
> topdown-bad-spec -> cpu/event=0,umask=0x81/
> topdown-fe-bound -> cpu/event=0,umask=0x82/
> topdown-be-bound -> cpu/event=0,umask=0x83/
> Control descriptor is not initialized
> Warning:
> slots event is not supported by the kernel.
> ^Ccpu-clock: 62021481051 62021480237 62021480237
> context-switches: 437 62021478064 62021478064
> cpu-migrations: 17 62021475294 62021475294
> page-faults: 12 62021471925 62021471925
> cycles: 15662273 62020909141 62020909141
> instructions: 6580385 62008944246 62008944246
> branches: 1446119 62008855550 62008855550
> branch-misses: 30970 62008643255 62008643255
> failed to read counter slots
> failed to read counter topdown-retiring
> failed to read counter topdown-bad-spec
> failed to read counter topdown-fe-bound
> failed to read counter topdown-be-bound
>
>  Performance counter stats for 'system wide':
>
>          62,021.48 msec cpu-clock                        #   16.006 CPUs utilized
>                437      context-switches                 #    7.046 /sec
>                 17      cpu-migrations                   #    0.274 /sec
>                 12      page-faults                      #    0.193 /sec
>         15,662,273      cycles                           #    0.000 GHz
>          6,580,385      instructions                     #    0.42  insn per cycle
>          1,446,119      branches                         #   23.316 K/sec
>             30,970      branch-misses                    #    2.14% of all branches
>    <not supported>      slots
>    <not supported>      topdown-retiring
>    <not supported>      topdown-bad-spec
>    <not supported>      topdown-fe-bound
>    <not supported>      topdown-be-bound
>
>        3.874991326 seconds time elapsed
>
> Thank you very much!
>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  tools/perf/builtin-stat.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 0b4a62e4ff67..1053cf0886c0 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -762,9 +762,7 @@ static enum counter_recovery stat_handle_error(struct evsel *counter)
>                  */
>                 counter->errored = true;
>
> -               if ((evsel__leader(counter) != counter) ||
> -                   !(counter->core.leader->nr_members > 1))
> -                       return COUNTER_SKIP;
> +               return COUNTER_SKIP;
>         } else if (evsel__fallback(counter, errno, msg, sizeof(msg))) {
>                 if (verbose > 0)
>                         ui__warning("%s\n", msg);
> @@ -843,6 +841,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
>                 if (target.use_bpf)
>                         break;
>
> +               if (evsel__leader(counter)->errored)
> +                       continue;
>                 if (counter->reset_group || counter->errored)
>                         continue;
>                 if (evsel__is_bpf(counter))
> @@ -901,6 +901,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
>                 evlist__for_each_cpu(evlist_cpu_itr, evsel_list, affinity) {
>                         counter = evlist_cpu_itr.evsel;
>
> +                       if (evsel__leader(counter)->errored)
> +                               continue;
>                         if (!counter->reset_group && !counter->errored)
>                                 continue;
>                         if (!counter->reset_group)
> --
> 2.17.1
>
