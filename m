Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00ABE57A5B4
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 19:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbiGSRsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 13:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiGSRsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 13:48:35 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9B654AC7
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:48:33 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a5so22689883wrx.12
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2aFgSsR5TdYMKNCLt3IuGrOxvlTk5DePSH8MwzccyyY=;
        b=MM+Tsw6IDrqNIcf00icoSmN3mUJQPLClSdAKPUVyGBzi0Liqp5GnfENwjom0aSLWjY
         301Fx65sFG5A+rFugeVO7agd4FJVVzwzyXigTUkG4bjwdvUAslwhRibnCy69KGru/xf+
         k43QHtZMM1muCHsyPjuawa4D0MVta2SvGa5ReBBnN0zW1+dvn5vDDw2ntcUtxZjYExCO
         3t//O1bWEhYDbnB/pjESCaIYXMD5apLp2O3c/x1UMJKqsNJIIPG62hpEymxAxhg+z272
         xotlx5DePXCQvtuINifC8CVXn/2FfffihN56AMCW9isae1zkjp71tgbgZY+b13QTb2OU
         Isvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2aFgSsR5TdYMKNCLt3IuGrOxvlTk5DePSH8MwzccyyY=;
        b=TK15tHCQ73WV9UuQs65+OZV8kZ5nQHOu57EsqGNNOdslCS74xGIxnPJLMsA6Ek22+H
         3ap0/7lZvgXK+n1dF3tBc46oYog1yzucw+un0cllC77F75VMkRR8c1l87vN3wY7k8KiY
         lohGErs6bMlXnrP+tn92xnyL8Mzvjs+9+XrJNK5ZUpRE0I86XFRCw5boC5GhlvPAXldA
         JmTai4VzT8e54FxC2OtyC0HZM5iGx03R2nDLPjKRgt7bon4HbeaH1fYWW8hMj1kRcGQJ
         GZACt77z5Ta3BBHUKQH2iEl5PCERO0apR5A2JO30/coXtlCmc9xd3Dzj1XiYf9BtgovK
         0u6w==
X-Gm-Message-State: AJIora8Q7sA/422ZUBe5fGslkGU00kL+P1IHVinK2iG8sckyl/7UORfU
        uKyt9+Yx3l+lUUgIIA7NSLaZww66vfOj/ZazGLwu7w==
X-Google-Smtp-Source: AGRyM1tlcz1MNwxdZ6ucx4dGEoCjyT5a6vh4yl98ZO3yMHXnuvqioBh/cT21MymyOFG/5s4lnSWZKUxMOhYNsOko/Lw=
X-Received: by 2002:a5d:4d92:0:b0:21d:6f02:d971 with SMTP id
 b18-20020a5d4d92000000b0021d6f02d971mr26948047wru.300.1658252911680; Tue, 19
 Jul 2022 10:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-11-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-11-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 10:48:19 -0700
Message-ID: <CAP-5=fUOHiOyKi0_Mp9EMD5Jz-K0+6R8Vz6=+rpAbhL1neqxEQ@mail.gmail.com>
Subject: Re: [PATCH 10/35] perf tools: Add machine_pid and vcpu to id_index
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

On Mon, Jul 11, 2022 at 2:33 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> When injecting events from a guest perf.data file, the events will have
> separate sample ID numbers. These ID numbers can then be used to determine
> which machine an event belongs to. To facilitate that, add machine_pid and
> vcpu to id_index records. For backward compatibility, these are added at
> the end of the record, and the length of the record is used to determine
> if they are present or not.
>
> Note, this is needed because the events from a guest perf.data file contain
> the pid/tid of the process running at that time inside the VM not the
> pid/tid of the (QEMU) hypervisor thread. So a way is needed to relate
> guest events back to the guest machine and VCPU, and using sample ID
> numbers for that is relatively simple and convenient.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/lib/perf/include/internal/evsel.h |  4 ++
>  tools/lib/perf/include/perf/event.h     |  5 +++
>  tools/perf/util/session.c               | 40 ++++++++++++++++---
>  tools/perf/util/synthetic-events.c      | 51 +++++++++++++++++++------
>  tools/perf/util/synthetic-events.h      |  1 +
>  5 files changed, 84 insertions(+), 17 deletions(-)
>
> diff --git a/tools/lib/perf/include/internal/evsel.h b/tools/lib/perf/include/internal/evsel.h
> index 2a912a1f1989..a99a75d9e78f 100644
> --- a/tools/lib/perf/include/internal/evsel.h
> +++ b/tools/lib/perf/include/internal/evsel.h
> @@ -30,6 +30,10 @@ struct perf_sample_id {
>         struct perf_cpu          cpu;
>         pid_t                    tid;
>
> +       /* Guest machine pid and VCPU, valid only if machine_pid is non-zero */
> +       pid_t                    machine_pid;
> +       struct perf_cpu          vcpu;
> +
>         /* Holds total ID period value for PERF_SAMPLE_READ processing. */
>         u64                      period;
>  };
> diff --git a/tools/lib/perf/include/perf/event.h b/tools/lib/perf/include/perf/event.h
> index 9f7ca070da87..c2dbd3e88885 100644
> --- a/tools/lib/perf/include/perf/event.h
> +++ b/tools/lib/perf/include/perf/event.h
> @@ -237,6 +237,11 @@ struct id_index_entry {
>         __u64                    tid;
>  };
>
> +struct id_index_entry_2 {
> +       __u64                    machine_pid;
> +       __u64                    vcpu;
> +};
> +
>  struct perf_record_id_index {
>         struct perf_event_header header;
>         __u64                    nr;
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 4c9513bc6d89..5141fe164e97 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -2756,18 +2756,35 @@ int perf_event__process_id_index(struct perf_session *session,
>  {
>         struct evlist *evlist = session->evlist;
>         struct perf_record_id_index *ie = &event->id_index;
> +       size_t sz = ie->header.size - sizeof(*ie);
>         size_t i, nr, max_nr;
> +       size_t e1_sz = sizeof(struct id_index_entry);
> +       size_t e2_sz = sizeof(struct id_index_entry_2);
> +       size_t etot_sz = e1_sz + e2_sz;
> +       struct id_index_entry_2 *e2;
>
> -       max_nr = (ie->header.size - sizeof(struct perf_record_id_index)) /
> -                sizeof(struct id_index_entry);
> +       max_nr = sz / e1_sz;
>         nr = ie->nr;
> -       if (nr > max_nr)
> +       if (nr > max_nr) {
> +               printf("Too big: nr %zu max_nr %zu\n", nr, max_nr);
>                 return -EINVAL;
> +       }
> +
> +       if (sz >= nr * etot_sz) {
> +               max_nr = sz / etot_sz;
> +               if (nr > max_nr) {
> +                       printf("Too big2: nr %zu max_nr %zu\n", nr, max_nr);
> +                       return -EINVAL;
> +               }
> +               e2 = (void *)ie + sizeof(*ie) + nr * e1_sz;
> +       } else {
> +               e2 = NULL;
> +       }
>
>         if (dump_trace)
>                 fprintf(stdout, " nr: %zu\n", nr);
>
> -       for (i = 0; i < nr; i++) {
> +       for (i = 0; i < nr; i++, (e2 ? e2++ : 0)) {
>                 struct id_index_entry *e = &ie->entries[i];
>                 struct perf_sample_id *sid;
>
> @@ -2775,15 +2792,28 @@ int perf_event__process_id_index(struct perf_session *session,
>                         fprintf(stdout, " ... id: %"PRI_lu64, e->id);
>                         fprintf(stdout, "  idx: %"PRI_lu64, e->idx);
>                         fprintf(stdout, "  cpu: %"PRI_ld64, e->cpu);
> -                       fprintf(stdout, "  tid: %"PRI_ld64"\n", e->tid);
> +                       fprintf(stdout, "  tid: %"PRI_ld64, e->tid);
> +                       if (e2) {
> +                               fprintf(stdout, "  machine_pid: %"PRI_ld64, e2->machine_pid);
> +                               fprintf(stdout, "  vcpu: %"PRI_lu64"\n", e2->vcpu);
> +                       } else {
> +                               fprintf(stdout, "\n");
> +                       }
>                 }
>
>                 sid = evlist__id2sid(evlist, e->id);
>                 if (!sid)
>                         return -ENOENT;
> +
>                 sid->idx = e->idx;
>                 sid->cpu.cpu = e->cpu;
>                 sid->tid = e->tid;
> +
> +               if (!e2)
> +                       continue;
> +
> +               sid->machine_pid = e2->machine_pid;
> +               sid->vcpu.cpu = e2->vcpu;
>         }
>         return 0;
>  }
> diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
> index ed9623702f34..2ae59c03ae77 100644
> --- a/tools/perf/util/synthetic-events.c
> +++ b/tools/perf/util/synthetic-events.c
> @@ -1759,19 +1759,26 @@ int perf_event__synthesize_id_sample(__u64 *array, u64 type, const struct perf_s
>         return (void *)array - (void *)start;
>  }
>
> -int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process,
> -                                   struct evlist *evlist, struct machine *machine)
> +int __perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process,
> +                                     struct evlist *evlist, struct machine *machine, size_t from)
>  {
>         union perf_event *ev;
>         struct evsel *evsel;
> -       size_t nr = 0, i = 0, sz, max_nr, n;
> +       size_t nr = 0, i = 0, sz, max_nr, n, pos;
> +       size_t e1_sz = sizeof(struct id_index_entry);
> +       size_t e2_sz = sizeof(struct id_index_entry_2);
> +       size_t etot_sz = e1_sz + e2_sz;
> +       bool e2_needed = false;
>         int err;
>
> -       max_nr = (UINT16_MAX - sizeof(struct perf_record_id_index)) /
> -                sizeof(struct id_index_entry);
> +       max_nr = (UINT16_MAX - sizeof(struct perf_record_id_index)) / etot_sz;
>
> -       evlist__for_each_entry(evlist, evsel)
> +       pos = 0;
> +       evlist__for_each_entry(evlist, evsel) {
> +               if (pos++ < from)
> +                       continue;
>                 nr += evsel->core.ids;
> +       }
>
>         if (!nr)
>                 return 0;
> @@ -1779,31 +1786,38 @@ int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_
>         pr_debug2("Synthesizing id index\n");
>
>         n = nr > max_nr ? max_nr : nr;
> -       sz = sizeof(struct perf_record_id_index) + n * sizeof(struct id_index_entry);
> +       sz = sizeof(struct perf_record_id_index) + n * etot_sz;
>         ev = zalloc(sz);
>         if (!ev)
>                 return -ENOMEM;
>
> +       sz = sizeof(struct perf_record_id_index) + n * e1_sz;
> +
>         ev->id_index.header.type = PERF_RECORD_ID_INDEX;
> -       ev->id_index.header.size = sz;
>         ev->id_index.nr = n;
>
> +       pos = 0;
>         evlist__for_each_entry(evlist, evsel) {
>                 u32 j;
>
> -               for (j = 0; j < evsel->core.ids; j++) {
> +               if (pos++ < from)
> +                       continue;
> +               for (j = 0; j < evsel->core.ids; j++, i++) {
>                         struct id_index_entry *e;
> +                       struct id_index_entry_2 *e2;
>                         struct perf_sample_id *sid;
>
>                         if (i >= n) {
> +                               ev->id_index.header.size = sz + (e2_needed ? n * e2_sz : 0);
>                                 err = process(tool, ev, NULL, machine);
>                                 if (err)
>                                         goto out_err;
>                                 nr -= n;
>                                 i = 0;
> +                               e2_needed = false;
>                         }
>
> -                       e = &ev->id_index.entries[i++];
> +                       e = &ev->id_index.entries[i];
>
>                         e->id = evsel->core.id[j];
>
> @@ -1816,11 +1830,18 @@ int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_
>                         e->idx = sid->idx;
>                         e->cpu = sid->cpu.cpu;
>                         e->tid = sid->tid;
> +
> +                       if (sid->machine_pid)
> +                               e2_needed = true;
> +
> +                       e2 = (void *)ev + sz;
> +                       e2[i].machine_pid = sid->machine_pid;
> +                       e2[i].vcpu        = sid->vcpu.cpu;
>                 }
>         }
>
> -       sz = sizeof(struct perf_record_id_index) + nr * sizeof(struct id_index_entry);
> -       ev->id_index.header.size = sz;
> +       sz = sizeof(struct perf_record_id_index) + nr * e1_sz;
> +       ev->id_index.header.size = sz + (e2_needed ? nr * e2_sz : 0);
>         ev->id_index.nr = nr;
>
>         err = process(tool, ev, NULL, machine);
> @@ -1830,6 +1851,12 @@ int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_
>         return err;
>  }
>
> +int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process,
> +                                   struct evlist *evlist, struct machine *machine)
> +{
> +       return __perf_event__synthesize_id_index(tool, process, evlist, machine, 0);
> +}
> +
>  int __machine__synthesize_threads(struct machine *machine, struct perf_tool *tool,
>                                   struct target *target, struct perf_thread_map *threads,
>                                   perf_event__handler_t process, bool needs_mmap,
> diff --git a/tools/perf/util/synthetic-events.h b/tools/perf/util/synthetic-events.h
> index b136ec3ec95d..81cb3d6af0b9 100644
> --- a/tools/perf/util/synthetic-events.h
> +++ b/tools/perf/util/synthetic-events.h
> @@ -55,6 +55,7 @@ int perf_event__synthesize_extra_attr(struct perf_tool *tool, struct evlist *evs
>  int perf_event__synthesize_extra_kmaps(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
>  int perf_event__synthesize_features(struct perf_tool *tool, struct perf_session *session, struct evlist *evlist, perf_event__handler_t process);
>  int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process, struct evlist *evlist, struct machine *machine);
> +int __perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process, struct evlist *evlist, struct machine *machine, size_t from);

Given there is only 1 use in the file defining the function, should
this just be static with no header file declaration?

Thanks,
Ian

>  int perf_event__synthesize_id_sample(__u64 *array, u64 type, const struct perf_sample *sample);
>  int perf_event__synthesize_kernel_mmap(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
>  int perf_event__synthesize_mmap_events(struct perf_tool *tool, union perf_event *event, pid_t pid, pid_t tgid, perf_event__handler_t process, struct machine *machine, bool mmap_data);
> --
> 2.25.1
>
