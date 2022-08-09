Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D822558D8A8
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 14:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiHIMTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 08:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbiHIMTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 08:19:36 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA60317A8C;
        Tue,  9 Aug 2022 05:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660047574; x=1691583574;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tlslup8tA6uXEdmVXXsbJrKtD+rud/Eetzta+AoE1t4=;
  b=nrIMI4R19mwE5ENzsVqBjOf4lTjNsFjmIUl5zKRX/R+cySfL89EwFkTx
   yhitLpXkaUYZYaGYDajWwM9cClQHwDKwH6ggmQKeNCbg1QvQx0GFMvagA
   4O/UvQFeP9Y7s+AGe1Xsa54RLDIktd27txgM/AkKdhwbpcswuHT5u7SHh
   nOywXMjNnrDq2XSYcSR1J/gBP1rJESwtgroILggTowU0UJSTh3Mu9WVWj
   d1zpsVJZGyW0C+A3Gw7lT/NQsSMio7qIu2ylXiDtFJeSVICryRffFc37B
   PTTdRS0HBpaSLv5HOugvXSbQJGDDKhuuXHjs8m4A5h/8AjkW5OkDLElQB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="377109857"
X-IronPort-AV: E=Sophos;i="5.93,224,1654585200"; 
   d="scan'208";a="377109857"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 05:19:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,224,1654585200"; 
   d="scan'208";a="664410955"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.48.82])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 05:19:32 -0700
Message-ID: <87ba10ef-8d8e-4104-91c2-c8d8defafba3@intel.com>
Date:   Tue, 9 Aug 2022 15:19:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 10/35] perf tools: Add machine_pid and vcpu to id_index
Content-Language: en-US
To:     Ian Rogers <irogers@google.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-11-adrian.hunter@intel.com>
 <CAP-5=fUOHiOyKi0_Mp9EMD5Jz-K0+6R8Vz6=+rpAbhL1neqxEQ@mail.gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <CAP-5=fUOHiOyKi0_Mp9EMD5Jz-K0+6R8Vz6=+rpAbhL1neqxEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/07/22 20:48, Ian Rogers wrote:
> On Mon, Jul 11, 2022 at 2:33 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>
>> When injecting events from a guest perf.data file, the events will have
>> separate sample ID numbers. These ID numbers can then be used to determine
>> which machine an event belongs to. To facilitate that, add machine_pid and
>> vcpu to id_index records. For backward compatibility, these are added at
>> the end of the record, and the length of the record is used to determine
>> if they are present or not.
>>
>> Note, this is needed because the events from a guest perf.data file contain
>> the pid/tid of the process running at that time inside the VM not the
>> pid/tid of the (QEMU) hypervisor thread. So a way is needed to relate
>> guest events back to the guest machine and VCPU, and using sample ID
>> numbers for that is relatively simple and convenient.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/lib/perf/include/internal/evsel.h |  4 ++
>>  tools/lib/perf/include/perf/event.h     |  5 +++
>>  tools/perf/util/session.c               | 40 ++++++++++++++++---
>>  tools/perf/util/synthetic-events.c      | 51 +++++++++++++++++++------
>>  tools/perf/util/synthetic-events.h      |  1 +
>>  5 files changed, 84 insertions(+), 17 deletions(-)
>>
>> diff --git a/tools/lib/perf/include/internal/evsel.h b/tools/lib/perf/include/internal/evsel.h
>> index 2a912a1f1989..a99a75d9e78f 100644
>> --- a/tools/lib/perf/include/internal/evsel.h
>> +++ b/tools/lib/perf/include/internal/evsel.h
>> @@ -30,6 +30,10 @@ struct perf_sample_id {
>>         struct perf_cpu          cpu;
>>         pid_t                    tid;
>>
>> +       /* Guest machine pid and VCPU, valid only if machine_pid is non-zero */
>> +       pid_t                    machine_pid;
>> +       struct perf_cpu          vcpu;
>> +
>>         /* Holds total ID period value for PERF_SAMPLE_READ processing. */
>>         u64                      period;
>>  };
>> diff --git a/tools/lib/perf/include/perf/event.h b/tools/lib/perf/include/perf/event.h
>> index 9f7ca070da87..c2dbd3e88885 100644
>> --- a/tools/lib/perf/include/perf/event.h
>> +++ b/tools/lib/perf/include/perf/event.h
>> @@ -237,6 +237,11 @@ struct id_index_entry {
>>         __u64                    tid;
>>  };
>>
>> +struct id_index_entry_2 {
>> +       __u64                    machine_pid;
>> +       __u64                    vcpu;
>> +};
>> +
>>  struct perf_record_id_index {
>>         struct perf_event_header header;
>>         __u64                    nr;
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index 4c9513bc6d89..5141fe164e97 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -2756,18 +2756,35 @@ int perf_event__process_id_index(struct perf_session *session,
>>  {
>>         struct evlist *evlist = session->evlist;
>>         struct perf_record_id_index *ie = &event->id_index;
>> +       size_t sz = ie->header.size - sizeof(*ie);
>>         size_t i, nr, max_nr;
>> +       size_t e1_sz = sizeof(struct id_index_entry);
>> +       size_t e2_sz = sizeof(struct id_index_entry_2);
>> +       size_t etot_sz = e1_sz + e2_sz;
>> +       struct id_index_entry_2 *e2;
>>
>> -       max_nr = (ie->header.size - sizeof(struct perf_record_id_index)) /
>> -                sizeof(struct id_index_entry);
>> +       max_nr = sz / e1_sz;
>>         nr = ie->nr;
>> -       if (nr > max_nr)
>> +       if (nr > max_nr) {
>> +               printf("Too big: nr %zu max_nr %zu\n", nr, max_nr);
>>                 return -EINVAL;
>> +       }
>> +
>> +       if (sz >= nr * etot_sz) {
>> +               max_nr = sz / etot_sz;
>> +               if (nr > max_nr) {
>> +                       printf("Too big2: nr %zu max_nr %zu\n", nr, max_nr);
>> +                       return -EINVAL;
>> +               }
>> +               e2 = (void *)ie + sizeof(*ie) + nr * e1_sz;
>> +       } else {
>> +               e2 = NULL;
>> +       }
>>
>>         if (dump_trace)
>>                 fprintf(stdout, " nr: %zu\n", nr);
>>
>> -       for (i = 0; i < nr; i++) {
>> +       for (i = 0; i < nr; i++, (e2 ? e2++ : 0)) {
>>                 struct id_index_entry *e = &ie->entries[i];
>>                 struct perf_sample_id *sid;
>>
>> @@ -2775,15 +2792,28 @@ int perf_event__process_id_index(struct perf_session *session,
>>                         fprintf(stdout, " ... id: %"PRI_lu64, e->id);
>>                         fprintf(stdout, "  idx: %"PRI_lu64, e->idx);
>>                         fprintf(stdout, "  cpu: %"PRI_ld64, e->cpu);
>> -                       fprintf(stdout, "  tid: %"PRI_ld64"\n", e->tid);
>> +                       fprintf(stdout, "  tid: %"PRI_ld64, e->tid);
>> +                       if (e2) {
>> +                               fprintf(stdout, "  machine_pid: %"PRI_ld64, e2->machine_pid);
>> +                               fprintf(stdout, "  vcpu: %"PRI_lu64"\n", e2->vcpu);
>> +                       } else {
>> +                               fprintf(stdout, "\n");
>> +                       }
>>                 }
>>
>>                 sid = evlist__id2sid(evlist, e->id);
>>                 if (!sid)
>>                         return -ENOENT;
>> +
>>                 sid->idx = e->idx;
>>                 sid->cpu.cpu = e->cpu;
>>                 sid->tid = e->tid;
>> +
>> +               if (!e2)
>> +                       continue;
>> +
>> +               sid->machine_pid = e2->machine_pid;
>> +               sid->vcpu.cpu = e2->vcpu;
>>         }
>>         return 0;
>>  }
>> diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
>> index ed9623702f34..2ae59c03ae77 100644
>> --- a/tools/perf/util/synthetic-events.c
>> +++ b/tools/perf/util/synthetic-events.c
>> @@ -1759,19 +1759,26 @@ int perf_event__synthesize_id_sample(__u64 *array, u64 type, const struct perf_s
>>         return (void *)array - (void *)start;
>>  }
>>
>> -int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process,
>> -                                   struct evlist *evlist, struct machine *machine)
>> +int __perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process,
>> +                                     struct evlist *evlist, struct machine *machine, size_t from)
>>  {
>>         union perf_event *ev;
>>         struct evsel *evsel;
>> -       size_t nr = 0, i = 0, sz, max_nr, n;
>> +       size_t nr = 0, i = 0, sz, max_nr, n, pos;
>> +       size_t e1_sz = sizeof(struct id_index_entry);
>> +       size_t e2_sz = sizeof(struct id_index_entry_2);
>> +       size_t etot_sz = e1_sz + e2_sz;
>> +       bool e2_needed = false;
>>         int err;
>>
>> -       max_nr = (UINT16_MAX - sizeof(struct perf_record_id_index)) /
>> -                sizeof(struct id_index_entry);
>> +       max_nr = (UINT16_MAX - sizeof(struct perf_record_id_index)) / etot_sz;
>>
>> -       evlist__for_each_entry(evlist, evsel)
>> +       pos = 0;
>> +       evlist__for_each_entry(evlist, evsel) {
>> +               if (pos++ < from)
>> +                       continue;
>>                 nr += evsel->core.ids;
>> +       }
>>
>>         if (!nr)
>>                 return 0;
>> @@ -1779,31 +1786,38 @@ int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_
>>         pr_debug2("Synthesizing id index\n");
>>
>>         n = nr > max_nr ? max_nr : nr;
>> -       sz = sizeof(struct perf_record_id_index) + n * sizeof(struct id_index_entry);
>> +       sz = sizeof(struct perf_record_id_index) + n * etot_sz;
>>         ev = zalloc(sz);
>>         if (!ev)
>>                 return -ENOMEM;
>>
>> +       sz = sizeof(struct perf_record_id_index) + n * e1_sz;
>> +
>>         ev->id_index.header.type = PERF_RECORD_ID_INDEX;
>> -       ev->id_index.header.size = sz;
>>         ev->id_index.nr = n;
>>
>> +       pos = 0;
>>         evlist__for_each_entry(evlist, evsel) {
>>                 u32 j;
>>
>> -               for (j = 0; j < evsel->core.ids; j++) {
>> +               if (pos++ < from)
>> +                       continue;
>> +               for (j = 0; j < evsel->core.ids; j++, i++) {
>>                         struct id_index_entry *e;
>> +                       struct id_index_entry_2 *e2;
>>                         struct perf_sample_id *sid;
>>
>>                         if (i >= n) {
>> +                               ev->id_index.header.size = sz + (e2_needed ? n * e2_sz : 0);
>>                                 err = process(tool, ev, NULL, machine);
>>                                 if (err)
>>                                         goto out_err;
>>                                 nr -= n;
>>                                 i = 0;
>> +                               e2_needed = false;
>>                         }
>>
>> -                       e = &ev->id_index.entries[i++];
>> +                       e = &ev->id_index.entries[i];
>>
>>                         e->id = evsel->core.id[j];
>>
>> @@ -1816,11 +1830,18 @@ int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_
>>                         e->idx = sid->idx;
>>                         e->cpu = sid->cpu.cpu;
>>                         e->tid = sid->tid;
>> +
>> +                       if (sid->machine_pid)
>> +                               e2_needed = true;
>> +
>> +                       e2 = (void *)ev + sz;
>> +                       e2[i].machine_pid = sid->machine_pid;
>> +                       e2[i].vcpu        = sid->vcpu.cpu;
>>                 }
>>         }
>>
>> -       sz = sizeof(struct perf_record_id_index) + nr * sizeof(struct id_index_entry);
>> -       ev->id_index.header.size = sz;
>> +       sz = sizeof(struct perf_record_id_index) + nr * e1_sz;
>> +       ev->id_index.header.size = sz + (e2_needed ? nr * e2_sz : 0);
>>         ev->id_index.nr = nr;
>>
>>         err = process(tool, ev, NULL, machine);
>> @@ -1830,6 +1851,12 @@ int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_
>>         return err;
>>  }
>>
>> +int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process,
>> +                                   struct evlist *evlist, struct machine *machine)
>> +{
>> +       return __perf_event__synthesize_id_index(tool, process, evlist, machine, 0);
>> +}
>> +
>>  int __machine__synthesize_threads(struct machine *machine, struct perf_tool *tool,
>>                                   struct target *target, struct perf_thread_map *threads,
>>                                   perf_event__handler_t process, bool needs_mmap,
>> diff --git a/tools/perf/util/synthetic-events.h b/tools/perf/util/synthetic-events.h
>> index b136ec3ec95d..81cb3d6af0b9 100644
>> --- a/tools/perf/util/synthetic-events.h
>> +++ b/tools/perf/util/synthetic-events.h
>> @@ -55,6 +55,7 @@ int perf_event__synthesize_extra_attr(struct perf_tool *tool, struct evlist *evs
>>  int perf_event__synthesize_extra_kmaps(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
>>  int perf_event__synthesize_features(struct perf_tool *tool, struct perf_session *session, struct evlist *evlist, perf_event__handler_t process);
>>  int perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process, struct evlist *evlist, struct machine *machine);
>> +int __perf_event__synthesize_id_index(struct perf_tool *tool, perf_event__handler_t process, struct evlist *evlist, struct machine *machine, size_t from);
> 
> Given there is only 1 use in the file defining the function, should
> this just be static with no header file declaration?

It is used perf inject also.

> 
> Thanks,
> Ian
> 
>>  int perf_event__synthesize_id_sample(__u64 *array, u64 type, const struct perf_sample *sample);
>>  int perf_event__synthesize_kernel_mmap(struct perf_tool *tool, perf_event__handler_t process, struct machine *machine);
>>  int perf_event__synthesize_mmap_events(struct perf_tool *tool, union perf_event *event, pid_t pid, pid_t tgid, perf_event__handler_t process, struct machine *machine, bool mmap_data);
>> --
>> 2.25.1
>>

