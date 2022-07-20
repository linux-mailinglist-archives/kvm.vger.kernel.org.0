Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC2957AB4A
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 03:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238164AbiGTBGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 21:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiGTBGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 21:06:41 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0816148C94
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:06:38 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z12so24007879wrq.7
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V1NMyozbYwh5KEsPJ8ZlH7KeX37FK7/6uteBlF3ALhk=;
        b=AunOv5X5zQ4ZJby2fLOaMCmqSr/9UL4VWMZpnP21ghGRYjW3niaiz+ot2xdu/nTLf9
         ccBQgQz6JbjefYGakuh3kyO+QiGVzSysJLjMmc+Gj8D7tUMCTwlhH7DBzsAT6u0WqvHM
         cqZCRX4lhx67oa7l3I0N7e2/dUlCuB+OzUMO241G6dILPHQbwy/TlEpmf87HqIsDuhOi
         a0vHzIEN9OK93hAt2BHJMzUnpTUdwuOybyphasUSf7K5bpeajNA9jnBDxNXH4F8gjLOl
         TR6WBsiOLpN+k/rVvSn6r+vbZ12Is/PYf5g9Zh7FX7k84hY2e4b6gI+oaj/dfbga14Dv
         7oDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V1NMyozbYwh5KEsPJ8ZlH7KeX37FK7/6uteBlF3ALhk=;
        b=qWuHuzotNxyuNanHFpGf2f0Xco0VfWokHNuvluwFhfr8L1K9r91U8q27bZTzVUS+Bc
         j1WHFNIITTMhVk+p9URVCYMOY3uWQQfd8tqKYFaMSCc6mvhlmC71hJHYkMV5FPe+TaUd
         EZ2SHHIK6apA3jar7ieA+ipMg1ZnBPIWIDJ3IsSop/ulcj0G3T4v6BGQETkC90LSo5LZ
         oNvv0HBZybK+1oEB0uYwdVUC/LW3AYGhyIYImbFAJUSORjAvjWO4VnsDpX4HM+elFRja
         /YWEdcOvF9eQp2gW0NZyM4ZWWkkDhxPC+Za3O9/U776qLvppTMINLtywbEGWTrBEBb+t
         +Fug==
X-Gm-Message-State: AJIora/KxB3td2wxJa5iUhGewlqr2SjT7qFysePIe+b6ku860xMLZAsQ
        vjJvfo++nZgOoICfHfDl+H7c1oumvx68Y8gcJcfUVA==
X-Google-Smtp-Source: AGRyM1vsQBECniTKFhV1Ox/M4+yMyzOpyGPFl3d5fbt2v9sPTf5Tz34TWl00YjkA7lCp6/za6EtZ0gtuUGE3lCa2af8=
X-Received: by 2002:a5d:6a4c:0:b0:21e:46d4:6eec with SMTP id
 t12-20020a5d6a4c000000b0021e46d46eecmr1676512wrw.375.1658279196071; Tue, 19
 Jul 2022 18:06:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-25-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-25-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 18:06:23 -0700
Message-ID: <CAP-5=fXTHWoY-LudTnKDGCMRN61zyvSMtORduUjJ_eXgpai8BA@mail.gmail.com>
Subject: Re: [PATCH 24/35] perf inject: Add support for injecting guest
 sideband events
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
> Inject events from a perf.data file recorded in a virtual machine into
> a perf.data file recorded on the host at the same time.
>
> Only side band events (e.g. mmap, comm, fork, exit etc) and build IDs are
> injected.  Additionally, the guest kcore_dir is copied as kcore_dir__
> appended to the machine PID.
>
> This is non-trivial because:
>  o It is not possible to process 2 sessions simultaneously so instead
>  events are first written to a temporary file.
>  o To avoid conflict, guest sample IDs are replaced with new unused sample
>  IDs.
>  o Guest event's CPU is changed to be the host CPU because it is more
>  useful for reporting and analysis.
>  o Sample ID is mapped to machine PID which is recorded with VCPU in the
>  id index. This is important to allow guest events to be related to the
>  guest machine and VCPU.
>  o Timestamps must be converted.
>  o Events are inserted to obey finished-round ordering.
>
> The anticipated use-case is:
>  - start recording sideband events in a guest machine
>  - start recording an AUX area trace on the host which can trace also the
>  guest (e.g. Intel PT)
>  - run test case on the guest
>  - stop recording on the host
>  - stop recording on the guest
>  - copy the guest perf.data file to the host
>  - inject the guest perf.data file sideband events into the host perf.data
>  file using perf inject
>  - the resulting perf.data file can now be used
>
> Subsequent patches provide Intel PT support for this.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/Documentation/perf-inject.txt |   17 +
>  tools/perf/builtin-inject.c              | 1043 +++++++++++++++++++++-
>  2 files changed, 1059 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
> index 0570a1ccd344..646aa31586ed 100644
> --- a/tools/perf/Documentation/perf-inject.txt
> +++ b/tools/perf/Documentation/perf-inject.txt
> @@ -85,6 +85,23 @@ include::itrace.txt[]
>         without updating it. Currently this option is supported only by
>         Intel PT, refer linkperf:perf-intel-pt[1]
>
> +--guest-data=<path>,<pid>[,<time offset>[,<time scale>]]::
> +       Insert events from a perf.data file recorded in a virtual machine at
> +       the same time as the input perf.data file was recorded on the host.
> +       The Process ID (PID) of the QEMU hypervisor process must be provided,
> +       and the time offset and time scale (multiplier) will likely be needed
> +       to convert guest time stamps into host time stamps. For example, for
> +       x86 the TSC Offset and Multiplier could be provided for a virtual machine
> +       using Linux command line option no-kvmclock.
> +       Currently only mmap, mmap2, comm, task, context_switch, ksymbol,
> +       and text_poke events are inserted, as well as build ID information.
> +       The QEMU option -name debug-threads=on is needed so that thread names
> +       can be used to determine which thread is running which VCPU. Note
> +       libvirt seems to use this by default.
> +       When using perf record in the guest, option --sample-identifier
> +       should be used, and also --buildid-all and --switch-events may be
> +       useful.
> +

Would other hypervisors based on kvm like gVisor work if they
implemented name-debug-threads?

>  SEE ALSO
>  --------
>  linkperf:perf-record[1], linkperf:perf-report[1], linkperf:perf-archive[1],
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index c800911f68e7..fd4547bb75f7 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -26,6 +26,7 @@
>  #include "util/thread.h"
>  #include "util/namespaces.h"
>  #include "util/util.h"
> +#include "util/tsc.h"
>
>  #include <internal/lib.h>
>
> @@ -35,8 +36,70 @@
>
>  #include <linux/list.h>
>  #include <linux/string.h>
> +#include <linux/zalloc.h>
> +#include <linux/hash.h>
>  #include <errno.h>
>  #include <signal.h>
> +#include <inttypes.h>
> +
> +struct guest_event {
> +       struct perf_sample              sample;
> +       union perf_event                *event;
> +       char                            event_buf[PERF_SAMPLE_MAX_SIZE];
> +};
> +
> +struct guest_id {
> +       /* hlist_node must be first, see free_hlist() */
> +       struct hlist_node               node;
> +       u64                             id;
> +       u64                             host_id;
> +       u32                             vcpu;
> +};
> +
> +struct guest_tid {
> +       /* hlist_node must be first, see free_hlist() */
> +       struct hlist_node               node;
> +       /* Thread ID of QEMU thread */
> +       u32                             tid;
> +       u32                             vcpu;
> +};
> +
> +struct guest_vcpu {
> +       /* Current host CPU */
> +       u32                             cpu;
> +       /* Thread ID of QEMU thread */
> +       u32                             tid;
> +};
> +
> +struct guest_session {
> +       char                            *perf_data_file;
> +       u32                             machine_pid;
> +       u64                             time_offset;
> +       double                          time_scale;
> +       struct perf_tool                tool;
> +       struct perf_data                data;
> +       struct perf_session             *session;
> +       char                            *tmp_file_name;
> +       int                             tmp_fd;
> +       struct perf_tsc_conversion      host_tc;
> +       struct perf_tsc_conversion      guest_tc;
> +       bool                            copy_kcore_dir;
> +       bool                            have_tc;
> +       bool                            fetched;
> +       bool                            ready;
> +       u16                             dflt_id_hdr_size;
> +       u64                             dflt_id;
> +       u64                             highest_id;
> +       /* Array of guest_vcpu */
> +       struct guest_vcpu               *vcpu;
> +       size_t                          vcpu_cnt;
> +       /* Hash table for guest_id */
> +       struct hlist_head               heads[PERF_EVLIST__HLIST_SIZE];
> +       /* Hash table for guest_tid */
> +       struct hlist_head               tids[PERF_EVLIST__HLIST_SIZE];
> +       /* Place to stash next guest event */
> +       struct guest_event              ev;
> +};
>
>  struct perf_inject {
>         struct perf_tool        tool;
> @@ -59,6 +122,7 @@ struct perf_inject {
>         struct itrace_synth_opts itrace_synth_opts;
>         char                    event_copy[PERF_SAMPLE_MAX_SIZE];
>         struct perf_file_section secs[HEADER_FEAT_BITS];
> +       struct guest_session    guest_session;
>  };
>
>  struct event_entry {
> @@ -698,6 +762,841 @@ static int perf_inject__sched_stat(struct perf_tool *tool,
>         return perf_event__repipe(tool, event_sw, &sample_sw, machine);
>  }
>
> +static struct guest_vcpu *guest_session__vcpu(struct guest_session *gs, u32 vcpu)
> +{
> +       if (realloc_array_as_needed(gs->vcpu, gs->vcpu_cnt, vcpu, NULL))
> +               return NULL;
> +       return &gs->vcpu[vcpu];
> +}
> +
> +static int guest_session__output_bytes(struct guest_session *gs, void *buf, size_t sz)
> +{
> +       ssize_t ret = writen(gs->tmp_fd, buf, sz);
> +
> +       return ret < 0 ? ret : 0;
> +}
> +
> +static int guest_session__repipe(struct perf_tool *tool,
> +                                union perf_event *event,
> +                                struct perf_sample *sample __maybe_unused,
> +                                struct machine *machine __maybe_unused)
> +{
> +       struct guest_session *gs = container_of(tool, struct guest_session, tool);
> +
> +       return guest_session__output_bytes(gs, event, event->header.size);
> +}
> +
> +static int guest_session__map_tid(struct guest_session *gs, u32 tid, u32 vcpu)
> +{
> +       struct guest_tid *guest_tid = zalloc(sizeof(*guest_tid));
> +       int hash;
> +
> +       if (!guest_tid)
> +               return -ENOMEM;
> +
> +       guest_tid->tid = tid;
> +       guest_tid->vcpu = vcpu;
> +       hash = hash_32(guest_tid->tid, PERF_EVLIST__HLIST_BITS);
> +       hlist_add_head(&guest_tid->node, &gs->tids[hash]);
> +
> +       return 0;
> +}
> +
> +static int host_peek_vm_comms_cb(struct perf_session *session __maybe_unused,
> +                                union perf_event *event,
> +                                u64 offset __maybe_unused, void *data)
> +{
> +       struct guest_session *gs = data;
> +       unsigned int vcpu;
> +       struct guest_vcpu *guest_vcpu;
> +       int ret;
> +
> +       if (event->header.type != PERF_RECORD_COMM ||
> +           event->comm.pid != gs->machine_pid)
> +               return 0;
> +
> +       /*
> +        * QEMU option -name debug-threads=on, causes thread names formatted as
> +        * below, although it is not an ABI. Also libvirt seems to use this by
> +        * default. Here we rely on it to tell us which thread is which VCPU.
> +        */
> +       ret = sscanf(event->comm.comm, "CPU %u/KVM", &vcpu);
> +       if (ret <= 0)
> +               return ret;
> +       pr_debug("Found VCPU: tid %u comm %s vcpu %u\n",
> +                event->comm.tid, event->comm.comm, vcpu);
> +       if (vcpu > INT_MAX) {
> +               pr_err("Invalid VCPU %u\n", vcpu);
> +               return -EINVAL;
> +       }
> +       guest_vcpu = guest_session__vcpu(gs, vcpu);
> +       if (!guest_vcpu)
> +               return -ENOMEM;
> +       if (guest_vcpu->tid && guest_vcpu->tid != event->comm.tid) {
> +               pr_err("Fatal error: Two threads found with the same VCPU\n");
> +               return -EINVAL;
> +       }
> +       guest_vcpu->tid = event->comm.tid;
> +
> +       return guest_session__map_tid(gs, event->comm.tid, vcpu);
> +}
> +
> +static int host_peek_vm_comms(struct perf_session *session, struct guest_session *gs)
> +{
> +       return perf_session__peek_events(session, session->header.data_offset,
> +                                        session->header.data_size,
> +                                        host_peek_vm_comms_cb, gs);
> +}
> +
> +static bool evlist__is_id_used(struct evlist *evlist, u64 id)
> +{
> +       return evlist__id2sid(evlist, id);
> +}
> +
> +static u64 guest_session__allocate_new_id(struct guest_session *gs, struct evlist *host_evlist)
> +{
> +       do {
> +               gs->highest_id += 1;
> +       } while (!gs->highest_id || evlist__is_id_used(host_evlist, gs->highest_id));
> +
> +       return gs->highest_id;
> +}
> +
> +static int guest_session__map_id(struct guest_session *gs, u64 id, u64 host_id, u32 vcpu)
> +{
> +       struct guest_id *guest_id = zalloc(sizeof(*guest_id));
> +       int hash;
> +
> +       if (!guest_id)
> +               return -ENOMEM;
> +
> +       guest_id->id = id;
> +       guest_id->host_id = host_id;
> +       guest_id->vcpu = vcpu;
> +       hash = hash_64(guest_id->id, PERF_EVLIST__HLIST_BITS);
> +       hlist_add_head(&guest_id->node, &gs->heads[hash]);
> +
> +       return 0;
> +}
> +
> +static u64 evlist__find_highest_id(struct evlist *evlist)
> +{
> +       struct evsel *evsel;
> +       u64 highest_id = 1;
> +
> +       evlist__for_each_entry(evlist, evsel) {
> +               u32 j;
> +
> +               for (j = 0; j < evsel->core.ids; j++) {
> +                       u64 id = evsel->core.id[j];
> +
> +                       if (id > highest_id)
> +                               highest_id = id;
> +               }
> +       }
> +
> +       return highest_id;
> +}
> +
> +static int guest_session__map_ids(struct guest_session *gs, struct evlist *host_evlist)
> +{
> +       struct evlist *evlist = gs->session->evlist;
> +       struct evsel *evsel;
> +       int ret;
> +
> +       evlist__for_each_entry(evlist, evsel) {
> +               u32 j;
> +
> +               for (j = 0; j < evsel->core.ids; j++) {
> +                       struct perf_sample_id *sid;
> +                       u64 host_id;
> +                       u64 id;
> +
> +                       id = evsel->core.id[j];
> +                       sid = evlist__id2sid(evlist, id);
> +                       if (!sid || sid->cpu.cpu == -1)
> +                               continue;
> +                       host_id = guest_session__allocate_new_id(gs, host_evlist);
> +                       ret = guest_session__map_id(gs, id, host_id, sid->cpu.cpu);
> +                       if (ret)
> +                               return ret;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static struct guest_id *guest_session__lookup_id(struct guest_session *gs, u64 id)
> +{
> +       struct hlist_head *head;
> +       struct guest_id *guest_id;
> +       int hash;
> +
> +       hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
> +       head = &gs->heads[hash];
> +
> +       hlist_for_each_entry(guest_id, head, node)
> +               if (guest_id->id == id)
> +                       return guest_id;
> +
> +       return NULL;
> +}
> +
> +static int process_attr(struct perf_tool *tool, union perf_event *event,
> +                       struct perf_sample *sample __maybe_unused,
> +                       struct machine *machine __maybe_unused)
> +{
> +       struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
> +
> +       return perf_event__process_attr(tool, event, &inject->session->evlist);
> +}
> +
> +static int guest_session__add_attr(struct guest_session *gs, struct evsel *evsel)
> +{
> +       struct perf_inject *inject = container_of(gs, struct perf_inject, guest_session);
> +       struct perf_event_attr attr = evsel->core.attr;
> +       u64 *id_array;
> +       u32 *vcpu_array;
> +       int ret = -ENOMEM;
> +       u32 i;
> +
> +       id_array = calloc(evsel->core.ids, sizeof(*id_array));
> +       if (!id_array)
> +               return -ENOMEM;
> +
> +       vcpu_array = calloc(evsel->core.ids, sizeof(*vcpu_array));
> +       if (!vcpu_array)
> +               goto out;
> +
> +       for (i = 0; i < evsel->core.ids; i++) {
> +               u64 id = evsel->core.id[i];
> +               struct guest_id *guest_id = guest_session__lookup_id(gs, id);
> +
> +               if (!guest_id) {
> +                       pr_err("Failed to find guest id %"PRIu64"\n", id);
> +                       ret = -EINVAL;
> +                       goto out;
> +               }
> +               id_array[i] = guest_id->host_id;
> +               vcpu_array[i] = guest_id->vcpu;
> +       }
> +
> +       attr.sample_type |= PERF_SAMPLE_IDENTIFIER;
> +       attr.exclude_host = 1;
> +       attr.exclude_guest = 0;
> +
> +       ret = perf_event__synthesize_attr(&inject->tool, &attr, evsel->core.ids,
> +                                         id_array, process_attr);
> +       if (ret)
> +               pr_err("Failed to add guest attr.\n");
> +
> +       for (i = 0; i < evsel->core.ids; i++) {
> +               struct perf_sample_id *sid;
> +               u32 vcpu = vcpu_array[i];
> +
> +               sid = evlist__id2sid(inject->session->evlist, id_array[i]);
> +               /* Guest event is per-thread from the host point of view */
> +               sid->cpu.cpu = -1;
> +               sid->tid = gs->vcpu[vcpu].tid;
> +               sid->machine_pid = gs->machine_pid;
> +               sid->vcpu.cpu = vcpu;
> +       }
> +out:
> +       free(vcpu_array);
> +       free(id_array);
> +       return ret;
> +}
> +
> +static int guest_session__add_attrs(struct guest_session *gs)
> +{
> +       struct evlist *evlist = gs->session->evlist;
> +       struct evsel *evsel;
> +       int ret;
> +
> +       evlist__for_each_entry(evlist, evsel) {
> +               ret = guest_session__add_attr(gs, evsel);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int synthesize_id_index(struct perf_inject *inject, size_t new_cnt)
> +{
> +       struct perf_session *session = inject->session;
> +       struct evlist *evlist = session->evlist;
> +       struct machine *machine = &session->machines.host;
> +       size_t from = evlist->core.nr_entries - new_cnt;
> +
> +       return __perf_event__synthesize_id_index(&inject->tool, perf_event__repipe,
> +                                                evlist, machine, from);
> +}
> +
> +static struct guest_tid *guest_session__lookup_tid(struct guest_session *gs, u32 tid)
> +{
> +       struct hlist_head *head;
> +       struct guest_tid *guest_tid;
> +       int hash;
> +
> +       hash = hash_32(tid, PERF_EVLIST__HLIST_BITS);
> +       head = &gs->tids[hash];
> +
> +       hlist_for_each_entry(guest_tid, head, node)
> +               if (guest_tid->tid == tid)
> +                       return guest_tid;
> +
> +       return NULL;
> +}
> +
> +static bool dso__is_in_kernel_space(struct dso *dso)
> +{
> +       if (dso__is_vdso(dso))
> +               return false;
> +
> +       return dso__is_kcore(dso) ||
> +              dso->kernel ||
> +              is_kernel_module(dso->long_name, PERF_RECORD_MISC_CPUMODE_UNKNOWN);
> +}
> +
> +static u64 evlist__first_id(struct evlist *evlist)
> +{
> +       struct evsel *evsel;
> +
> +       evlist__for_each_entry(evlist, evsel) {
> +               if (evsel->core.ids)
> +                       return evsel->core.id[0];
> +       }
> +       return 0;
> +}
> +
> +static int process_build_id(struct perf_tool *tool,
> +                           union perf_event *event,
> +                           struct perf_sample *sample __maybe_unused,
> +                           struct machine *machine __maybe_unused)
> +{
> +       struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
> +
> +       return perf_event__process_build_id(inject->session, event);
> +}
> +
> +static int synthesize_build_id(struct perf_inject *inject, struct dso *dso, pid_t machine_pid)
> +{
> +       struct machine *machine = perf_session__findnew_machine(inject->session, machine_pid);
> +       u8 cpumode = dso__is_in_kernel_space(dso) ?
> +                       PERF_RECORD_MISC_GUEST_KERNEL :
> +                       PERF_RECORD_MISC_GUEST_USER;
> +
> +       if (!machine)
> +               return -ENOMEM;
> +
> +       dso->hit = 1;
> +
> +       return perf_event__synthesize_build_id(&inject->tool, dso, cpumode,
> +                                              process_build_id, machine);
> +}
> +
> +static int guest_session__add_build_ids(struct guest_session *gs)
> +{
> +       struct perf_inject *inject = container_of(gs, struct perf_inject, guest_session);
> +       struct machine *machine = &gs->session->machines.host;
> +       struct dso *dso;
> +       int ret;
> +
> +       /* Build IDs will be put in the Build ID feature section */
> +       perf_header__set_feat(&inject->session->header, HEADER_BUILD_ID);
> +
> +       dsos__for_each_with_build_id(dso, &machine->dsos.head) {
> +               ret = synthesize_build_id(inject, dso, gs->machine_pid);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int guest_session__ksymbol_event(struct perf_tool *tool,
> +                                       union perf_event *event,
> +                                       struct perf_sample *sample __maybe_unused,
> +                                       struct machine *machine __maybe_unused)
> +{
> +       struct guest_session *gs = container_of(tool, struct guest_session, tool);
> +
> +       /* Only support out-of-line i.e. no BPF support */
> +       if (event->ksymbol.ksym_type != PERF_RECORD_KSYMBOL_TYPE_OOL)
> +               return 0;
> +
> +       return guest_session__output_bytes(gs, event, event->header.size);
> +}
> +
> +static int guest_session__start(struct guest_session *gs, const char *name, bool force)
> +{
> +       char tmp_file_name[] = "/tmp/perf-inject-guest_session-XXXXXX";
> +       struct perf_session *session;
> +       int ret;
> +
> +       /* Only these events will be injected */
> +       gs->tool.mmap           = guest_session__repipe;
> +       gs->tool.mmap2          = guest_session__repipe;
> +       gs->tool.comm           = guest_session__repipe;
> +       gs->tool.fork           = guest_session__repipe;
> +       gs->tool.exit           = guest_session__repipe;
> +       gs->tool.lost           = guest_session__repipe;
> +       gs->tool.context_switch = guest_session__repipe;
> +       gs->tool.ksymbol        = guest_session__ksymbol_event;
> +       gs->tool.text_poke      = guest_session__repipe;
> +       /*
> +        * Processing a build ID creates a struct dso with that build ID. Later,
> +        * all guest dsos are iterated and the build IDs processed into the host
> +        * session where they will be output to the Build ID feature section
> +        * when the perf.data file header is written.
> +        */
> +       gs->tool.build_id       = perf_event__process_build_id;
> +       /* Process the id index to know what VCPU an ID belongs to */
> +       gs->tool.id_index       = perf_event__process_id_index;
> +
> +       gs->tool.ordered_events = true;
> +       gs->tool.ordering_requires_timestamps = true;
> +
> +       gs->data.path   = name;
> +       gs->data.force  = force;
> +       gs->data.mode   = PERF_DATA_MODE_READ;
> +
> +       session = perf_session__new(&gs->data, &gs->tool);
> +       if (IS_ERR(session))
> +               return PTR_ERR(session);
> +       gs->session = session;
> +
> +       /*
> +        * Initial events have zero'd ID samples. Get default ID sample size
> +        * used for removing them.
> +        */
> +       gs->dflt_id_hdr_size = session->machines.host.id_hdr_size;
> +       /* And default ID for adding back a host-compatible ID sample */
> +       gs->dflt_id = evlist__first_id(session->evlist);
> +       if (!gs->dflt_id) {
> +               pr_err("Guest data has no sample IDs");
> +               return -EINVAL;
> +       }
> +
> +       /* Temporary file for guest events */
> +       gs->tmp_file_name = strdup(tmp_file_name);
> +       if (!gs->tmp_file_name)
> +               return -ENOMEM;
> +       gs->tmp_fd = mkstemp(gs->tmp_file_name);
> +       if (gs->tmp_fd < 0)
> +               return -errno;
> +
> +       if (zstd_init(&gs->session->zstd_data, 0) < 0)
> +               pr_warning("Guest session decompression initialization failed.\n");
> +
> +       /*
> +        * perf does not support processing 2 sessions simultaneously, so output
> +        * guest events to a temporary file.
> +        */
> +       ret = perf_session__process_events(gs->session);
> +       if (ret)
> +               return ret;
> +
> +       if (lseek(gs->tmp_fd, 0, SEEK_SET))
> +               return -errno;
> +
> +       return 0;
> +}
> +
> +/* Free hlist nodes assuming hlist_node is the first member of hlist entries */
> +static void free_hlist(struct hlist_head *heads, size_t hlist_sz)
> +{
> +       struct hlist_node *pos, *n;
> +       size_t i;
> +
> +       for (i = 0; i < hlist_sz; ++i) {
> +               hlist_for_each_safe(pos, n, &heads[i]) {
> +                       hlist_del(pos);
> +                       free(pos);
> +               }
> +       }
> +}
> +
> +static void guest_session__exit(struct guest_session *gs)
> +{
> +       if (gs->session) {
> +               perf_session__delete(gs->session);
> +               free_hlist(gs->heads, PERF_EVLIST__HLIST_SIZE);
> +               free_hlist(gs->tids, PERF_EVLIST__HLIST_SIZE);
> +       }
> +       if (gs->tmp_file_name) {
> +               if (gs->tmp_fd >= 0)
> +                       close(gs->tmp_fd);
> +               unlink(gs->tmp_file_name);
> +               free(gs->tmp_file_name);
> +       }
> +       free(gs->vcpu);
> +       free(gs->perf_data_file);
> +}
> +
> +static void get_tsc_conv(struct perf_tsc_conversion *tc, struct perf_record_time_conv *time_conv)
> +{
> +       tc->time_shift          = time_conv->time_shift;
> +       tc->time_mult           = time_conv->time_mult;
> +       tc->time_zero           = time_conv->time_zero;
> +       tc->time_cycles         = time_conv->time_cycles;
> +       tc->time_mask           = time_conv->time_mask;
> +       tc->cap_user_time_zero  = time_conv->cap_user_time_zero;
> +       tc->cap_user_time_short = time_conv->cap_user_time_short;
> +}
> +
> +static void guest_session__get_tc(struct guest_session *gs)
> +{
> +       struct perf_inject *inject = container_of(gs, struct perf_inject, guest_session);
> +
> +       get_tsc_conv(&gs->host_tc, &inject->session->time_conv);
> +       get_tsc_conv(&gs->guest_tc, &gs->session->time_conv);
> +}
> +
> +static void guest_session__convert_time(struct guest_session *gs, u64 guest_time, u64 *host_time)
> +{
> +       u64 tsc;
> +
> +       if (!guest_time) {
> +               *host_time = 0;
> +               return;
> +       }
> +
> +       if (gs->guest_tc.cap_user_time_zero)
> +               tsc = perf_time_to_tsc(guest_time, &gs->guest_tc);
> +       else
> +               tsc = guest_time;
> +
> +       /*
> +        * This is the correct order of operations for x86 if the TSC Offset and
> +        * Multiplier values are used.
> +        */
> +       tsc -= gs->time_offset;
> +       tsc /= gs->time_scale;
> +
> +       if (gs->host_tc.cap_user_time_zero)
> +               *host_time = tsc_to_perf_time(tsc, &gs->host_tc);
> +       else
> +               *host_time = tsc;
> +}
> +
> +static int guest_session__fetch(struct guest_session *gs)
> +{
> +       void *buf = gs->ev.event_buf;
> +       struct perf_event_header *hdr = buf;
> +       size_t hdr_sz = sizeof(*hdr);
> +       ssize_t ret;
> +
> +       ret = readn(gs->tmp_fd, buf, hdr_sz);
> +       if (ret < 0)
> +               return ret;
> +
> +       if (!ret) {
> +               /* Zero size means EOF */
> +               hdr->size = 0;
> +               return 0;
> +       }
> +
> +       buf += hdr_sz;
> +
> +       ret = readn(gs->tmp_fd, buf, hdr->size - hdr_sz);
> +       if (ret < 0)
> +               return ret;
> +
> +       gs->ev.event = (union perf_event *)gs->ev.event_buf;
> +       gs->ev.sample.time = 0;
> +
> +       if (hdr->type >= PERF_RECORD_USER_TYPE_START) {
> +               pr_err("Unexpected type fetching guest event");
> +               return 0;
> +       }
> +
> +       ret = evlist__parse_sample(gs->session->evlist, gs->ev.event, &gs->ev.sample);
> +       if (ret) {
> +               pr_err("Parse failed fetching guest event");
> +               return ret;
> +       }
> +
> +       if (!gs->have_tc) {
> +               guest_session__get_tc(gs);
> +               gs->have_tc = true;
> +       }
> +
> +       guest_session__convert_time(gs, gs->ev.sample.time, &gs->ev.sample.time);
> +
> +       return 0;
> +}
> +
> +static int evlist__append_id_sample(struct evlist *evlist, union perf_event *ev,
> +                                   const struct perf_sample *sample)
> +{
> +       struct evsel *evsel;
> +       void *array;
> +       int ret;
> +
> +       evsel = evlist__id2evsel(evlist, sample->id);
> +       array = ev;
> +
> +       if (!evsel) {
> +               pr_err("No evsel for id %"PRIu64"\n", sample->id);
> +               return -EINVAL;
> +       }
> +
> +       array += ev->header.size;
> +       ret = perf_event__synthesize_id_sample(array, evsel->core.attr.sample_type, sample);
> +       if (ret < 0)
> +               return ret;
> +
> +       if (ret & 7) {
> +               pr_err("Bad id sample size %d\n", ret);
> +               return -EINVAL;
> +       }
> +
> +       ev->header.size += ret;
> +
> +       return 0;
> +}
> +
> +static int guest_session__inject_events(struct guest_session *gs, u64 timestamp)
> +{
> +       struct perf_inject *inject = container_of(gs, struct perf_inject, guest_session);
> +       int ret;
> +
> +       if (!gs->ready)
> +               return 0;
> +
> +       while (1) {
> +               struct perf_sample *sample;
> +               struct guest_id *guest_id;
> +               union perf_event *ev;
> +               u16 id_hdr_size;
> +               u8 cpumode;
> +               u64 id;
> +
> +               if (!gs->fetched) {
> +                       ret = guest_session__fetch(gs);
> +                       if (ret)
> +                               return ret;
> +                       gs->fetched = true;
> +               }
> +
> +               ev = gs->ev.event;
> +               sample = &gs->ev.sample;
> +
> +               if (!ev->header.size)
> +                       return 0; /* EOF */
> +
> +               if (sample->time > timestamp)
> +                       return 0;
> +
> +               /* Change cpumode to guest */
> +               cpumode = ev->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
> +               if (cpumode & PERF_RECORD_MISC_USER)
> +                       cpumode = PERF_RECORD_MISC_GUEST_USER;
> +               else
> +                       cpumode = PERF_RECORD_MISC_GUEST_KERNEL;
> +               ev->header.misc &= ~PERF_RECORD_MISC_CPUMODE_MASK;
> +               ev->header.misc |= cpumode;
> +
> +               id = sample->id;
> +               if (!id) {
> +                       id = gs->dflt_id;
> +                       id_hdr_size = gs->dflt_id_hdr_size;
> +               } else {
> +                       struct evsel *evsel = evlist__id2evsel(gs->session->evlist, id);
> +
> +                       id_hdr_size = evsel__id_hdr_size(evsel);
> +               }
> +
> +               if (id_hdr_size & 7) {
> +                       pr_err("Bad id_hdr_size %u\n", id_hdr_size);
> +                       return -EINVAL;
> +               }
> +
> +               if (ev->header.size & 7) {
> +                       pr_err("Bad event size %u\n", ev->header.size);
> +                       return -EINVAL;
> +               }
> +
> +               /* Remove guest id sample */
> +               ev->header.size -= id_hdr_size;
> +
> +               if (ev->header.size & 7) {
> +                       pr_err("Bad raw event size %u\n", ev->header.size);
> +                       return -EINVAL;
> +               }
> +
> +               guest_id = guest_session__lookup_id(gs, id);
> +               if (!guest_id) {
> +                       pr_err("Guest event with unknown id %llu\n",
> +                              (unsigned long long)id);
> +                       return -EINVAL;
> +               }
> +
> +               /* Change to host ID to avoid conflicting ID values */
> +               sample->id = guest_id->host_id;
> +               sample->stream_id = guest_id->host_id;
> +
> +               if (sample->cpu != (u32)-1) {
> +                       if (sample->cpu >= gs->vcpu_cnt) {
> +                               pr_err("Guest event with unknown VCPU %u\n",
> +                                      sample->cpu);
> +                               return -EINVAL;
> +                       }
> +                       /* Change to host CPU instead of guest VCPU */
> +                       sample->cpu = gs->vcpu[sample->cpu].cpu;
> +               }
> +
> +               /* New id sample with new ID and CPU */
> +               ret = evlist__append_id_sample(inject->session->evlist, ev, sample);
> +               if (ret)
> +                       return ret;
> +
> +               if (ev->header.size & 7) {
> +                       pr_err("Bad new event size %u\n", ev->header.size);
> +                       return -EINVAL;
> +               }
> +
> +               gs->fetched = false;
> +
> +               ret = output_bytes(inject, ev, ev->header.size);
> +               if (ret)
> +                       return ret;
> +       }
> +}
> +
> +static int guest_session__flush_events(struct guest_session *gs)
> +{
> +       return guest_session__inject_events(gs, -1);
> +}
> +
> +static int host__repipe(struct perf_tool *tool,
> +                       union perf_event *event,
> +                       struct perf_sample *sample,
> +                       struct machine *machine)
> +{
> +       struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
> +       int ret;
> +
> +       ret = guest_session__inject_events(&inject->guest_session, sample->time);
> +       if (ret)
> +               return ret;
> +
> +       return perf_event__repipe(tool, event, sample, machine);
> +}
> +
> +static int host__finished_init(struct perf_session *session, union perf_event *event)
> +{
> +       struct perf_inject *inject = container_of(session->tool, struct perf_inject, tool);
> +       struct guest_session *gs = &inject->guest_session;
> +       int ret;
> +
> +       /*
> +        * Peek through host COMM events to find QEMU threads and the VCPU they
> +        * are running.
> +        */
> +       ret = host_peek_vm_comms(session, gs);
> +       if (ret)
> +               return ret;
> +
> +       if (!gs->vcpu_cnt) {
> +               pr_err("No VCPU theads found for pid %u\n", gs->machine_pid);
> +               return -EINVAL;
> +       }
> +
> +       /*
> +        * Allocate new (unused) host sample IDs and map them to the guest IDs.
> +        */
> +       gs->highest_id = evlist__find_highest_id(session->evlist);
> +       ret = guest_session__map_ids(gs, session->evlist);
> +       if (ret)
> +               return ret;
> +
> +       ret = guest_session__add_attrs(gs);
> +       if (ret)
> +               return ret;
> +
> +       ret = synthesize_id_index(inject, gs->session->evlist->core.nr_entries);
> +       if (ret) {
> +               pr_err("Failed to synthesize id_index\n");
> +               return ret;
> +       }
> +
> +       ret = guest_session__add_build_ids(gs);
> +       if (ret) {
> +               pr_err("Failed to add guest build IDs\n");
> +               return ret;
> +       }
> +
> +       gs->ready = true;
> +
> +       ret = guest_session__inject_events(gs, 0);
> +       if (ret)
> +               return ret;
> +
> +       return perf_event__repipe_op2_synth(session, event);
> +}
> +
> +/*
> + * Obey finished-round ordering. The FINISHED_ROUND event is first processed
> + * which flushes host events to file up until the last flush time. Then inject
> + * guest events up to the same time. Finally write out the FINISHED_ROUND event
> + * itself.
> + */
> +static int host__finished_round(struct perf_tool *tool,
> +                               union perf_event *event,
> +                               struct ordered_events *oe)
> +{
> +       struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
> +       int ret = perf_event__process_finished_round(tool, event, oe);
> +       u64 timestamp = ordered_events__last_flush_time(oe);
> +
> +       if (ret)
> +               return ret;
> +
> +       ret = guest_session__inject_events(&inject->guest_session, timestamp);
> +       if (ret)
> +               return ret;
> +
> +       return perf_event__repipe_oe_synth(tool, event, oe);
> +}
> +
> +static int host__context_switch(struct perf_tool *tool,
> +                               union perf_event *event,
> +                               struct perf_sample *sample,
> +                               struct machine *machine)
> +{
> +       struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
> +       bool out = event->header.misc & PERF_RECORD_MISC_SWITCH_OUT;
> +       struct guest_session *gs = &inject->guest_session;
> +       u32 pid = event->context_switch.next_prev_pid;
> +       u32 tid = event->context_switch.next_prev_tid;
> +       struct guest_tid *guest_tid;
> +       u32 vcpu;
> +
> +       if (out || pid != gs->machine_pid)
> +               goto out;
> +
> +       guest_tid = guest_session__lookup_tid(gs, tid);
> +       if (!guest_tid)
> +               goto out;
> +
> +       if (sample->cpu == (u32)-1) {
> +               pr_err("Switch event does not have CPU\n");
> +               return -EINVAL;
> +       }
> +
> +       vcpu = guest_tid->vcpu;
> +       if (vcpu >= gs->vcpu_cnt)
> +               return -EINVAL;
> +
> +       /* Guest is switching in, record which CPU the VCPU is now running on */
> +       gs->vcpu[vcpu].cpu = sample->cpu;
> +out:
> +       return host__repipe(tool, event, sample, machine);
> +}
> +
>  static void sig_handler(int sig __maybe_unused)
>  {
>         session_done = 1;
> @@ -767,6 +1666,61 @@ static int parse_vm_time_correlation(const struct option *opt, const char *str,
>         return inject->itrace_synth_opts.vm_tm_corr_args ? 0 : -ENOMEM;
>  }
>
> +static int parse_guest_data(const struct option *opt, const char *str, int unset)
> +{
> +       struct perf_inject *inject = opt->value;
> +       struct guest_session *gs = &inject->guest_session;
> +       char *tok;
> +       char *s;
> +
> +       if (unset)
> +               return 0;
> +
> +       if (!str)
> +               goto bad_args;
> +
> +       s = strdup(str);
> +       if (!s)
> +               return -ENOMEM;
> +
> +       gs->perf_data_file = strsep(&s, ",");
> +       if (!gs->perf_data_file)
> +               goto bad_args;
> +
> +       gs->copy_kcore_dir = has_kcore_dir(gs->perf_data_file);
> +       if (gs->copy_kcore_dir)
> +               inject->output.is_dir = true;
> +
> +       tok = strsep(&s, ",");
> +       if (!tok)
> +               goto bad_args;
> +       gs->machine_pid = strtoul(tok, NULL, 0);
> +       if (!inject->guest_session.machine_pid)
> +               goto bad_args;
> +
> +       gs->time_scale = 1;
> +
> +       tok = strsep(&s, ",");
> +       if (!tok)
> +               goto out;
> +       gs->time_offset = strtoull(tok, NULL, 0);
> +
> +       tok = strsep(&s, ",");
> +       if (!tok)
> +               goto out;
> +       gs->time_scale = strtod(tok, NULL);
> +       if (!gs->time_scale)
> +               goto bad_args;
> +out:
> +       return 0;
> +
> +bad_args:
> +       pr_err("--guest-data option requires guest perf.data file name, "
> +              "guest machine PID, and optionally guest timestamp offset, "
> +              "and guest timestamp scale factor, separated by commas.\n");
> +       return -1;
> +}
> +
>  static int save_section_info_cb(struct perf_file_section *section,
>                                 struct perf_header *ph __maybe_unused,
>                                 int feat, int fd __maybe_unused, void *data)
> @@ -896,6 +1850,22 @@ static int copy_kcore_dir(struct perf_inject *inject)
>         return ret;
>  }
>
> +static int guest_session__copy_kcore_dir(struct guest_session *gs)
> +{
> +       struct perf_inject *inject = container_of(gs, struct perf_inject, guest_session);
> +       char *cmd;
> +       int ret;
> +
> +       ret = asprintf(&cmd, "cp -r -n %s/kcore_dir %s/kcore_dir__%u >/dev/null 2>&1",
> +                      gs->perf_data_file, inject->output.path, gs->machine_pid);
> +       if (ret < 0)
> +               return ret;
> +       pr_debug("%s\n", cmd);
> +       ret = system(cmd);
> +       free(cmd);
> +       return ret;
> +}
> +
>  static int output_fd(struct perf_inject *inject)
>  {
>         return inject->in_place_update ? -1 : perf_data__fd(&inject->output);
> @@ -904,6 +1874,7 @@ static int output_fd(struct perf_inject *inject)
>  static int __cmd_inject(struct perf_inject *inject)
>  {
>         int ret = -EINVAL;
> +       struct guest_session *gs = &inject->guest_session;
>         struct perf_session *session = inject->session;
>         int fd = output_fd(inject);
>         u64 output_data_offset;
> @@ -968,6 +1939,47 @@ static int __cmd_inject(struct perf_inject *inject)
>                 output_data_offset = roundup(8192 + session->header.data_offset, 4096);
>                 if (inject->strip)
>                         strip_init(inject);
> +       } else if (gs->perf_data_file) {
> +               char *name = gs->perf_data_file;
> +
> +               /*
> +                * Not strictly necessary, but keep these events in order wrt
> +                * guest events.
> +                */
> +               inject->tool.mmap               = host__repipe;
> +               inject->tool.mmap2              = host__repipe;
> +               inject->tool.comm               = host__repipe;
> +               inject->tool.fork               = host__repipe;
> +               inject->tool.exit               = host__repipe;
> +               inject->tool.lost               = host__repipe;
> +               inject->tool.context_switch     = host__repipe;
> +               inject->tool.ksymbol            = host__repipe;
> +               inject->tool.text_poke          = host__repipe;
> +               /*
> +                * Once the host session has initialized, set up sample ID
> +                * mapping and feed in guest attrs, build IDs and initial
> +                * events.
> +                */
> +               inject->tool.finished_init      = host__finished_init;
> +               /* Obey finished round ordering */
> +               inject->tool.finished_round     = host__finished_round,
> +               /* Keep track of which CPU a VCPU is runnng on */
> +               inject->tool.context_switch     = host__context_switch;
> +               /*
> +                * Must order events to be able to obey finished round
> +                * ordering.
> +                */
> +               inject->tool.ordered_events     = true;
> +               inject->tool.ordering_requires_timestamps = true;
> +               /* Set up a separate session to process guest perf.data file */
> +               ret = guest_session__start(gs, name, session->data->force);
> +               if (ret) {
> +                       pr_err("Failed to process %s, error %d\n", name, ret);
> +                       return ret;
> +               }
> +               /* Allow space in the header for guest attributes */
> +               output_data_offset += gs->session->header.data_offset;
> +               output_data_offset = roundup(output_data_offset, 4096);
>         }
>
>         if (!inject->itrace_synth_opts.set)
> @@ -980,6 +1992,18 @@ static int __cmd_inject(struct perf_inject *inject)
>         if (ret)
>                 return ret;
>
> +       if (gs->session) {
> +               /*
> +                * Remaining guest events have later timestamps. Flush them
> +                * out to file.
> +                */
> +               ret = guest_session__flush_events(gs);
> +               if (ret) {
> +                       pr_err("Failed to flush guest events\n");
> +                       return ret;
> +               }
> +       }
> +
>         if (!inject->is_pipe && !inject->in_place_update) {
>                 struct inject_fc inj_fc = {
>                         .fc.copy = feat_copy_cb,
> @@ -1014,8 +2038,17 @@ static int __cmd_inject(struct perf_inject *inject)
>
>                 if (inject->copy_kcore_dir) {
>                         ret = copy_kcore_dir(inject);
> -                       if (ret)
> +                       if (ret) {
> +                               pr_err("Failed to copy kcore\n");
>                                 return ret;
> +                       }
> +               }
> +               if (gs->copy_kcore_dir) {
> +                       ret = guest_session__copy_kcore_dir(gs);
> +                       if (ret) {
> +                               pr_err("Failed to copy guest kcore\n");
> +                               return ret;
> +                       }
>                 }
>         }
>
> @@ -1113,6 +2146,12 @@ int cmd_inject(int argc, const char **argv)
>                 OPT_CALLBACK_OPTARG(0, "vm-time-correlation", &inject, NULL, "opts",
>                                     "correlate time between VM guests and the host",
>                                     parse_vm_time_correlation),
> +               OPT_CALLBACK_OPTARG(0, "guest-data", &inject, NULL, "opts",
> +                                   "inject events from a guest perf.data file",
> +                                   parse_guest_data),
> +               OPT_STRING(0, "guestmount", &symbol_conf.guestmount, "directory",
> +                          "guest mount directory under which every guest os"
> +                          " instance has a subdir"),

Should guestmount also be in the man page? Also should it have a
hyphen like guest-data?

Thanks,
Ian

>                 OPT_END()
>         };
>         const char * const inject_usage[] = {
> @@ -1243,6 +2282,8 @@ int cmd_inject(int argc, const char **argv)
>
>         ret = __cmd_inject(&inject);
>
> +       guest_session__exit(&inject.guest_session);
> +
>  out_delete:
>         zstd_fini(&(inject.session->zstd_data));
>         perf_session__delete(inject.session);
> --
> 2.25.1
>
