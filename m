Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6CC57AB14
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbiGTAnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiGTAnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:43:24 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4E85071C
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:43:23 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id id17so2813579wmb.1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QWg+c8mfSLpGnrIT5cTIiGQG7DyX5JzzwtgyUHZpsy4=;
        b=jqtQdn1tESs6xSio7z1YjSW/26bIfOaw5z7wHZpj+pdT81Ta/UTHGpbVlEs9Sq2zLn
         B2mLSmXn3C/RRz+2cbFEI9l1XjxGUTQJte4YtgctvHz61g6jkQsNu7FmBmXHF/gCFSH2
         rVFK7tiNdVQo1RRKLuStKCOoADITERFNi096XBVf67ZHzqmvOkubnhMJklhmRhV4BjoM
         ZSv9Tvp/W7GMgxnPGazX3UUOUAZ8zOjzt71LU4Fir5X0lV/QtEJWlN24s66bHrBt2XUi
         tS/ZbnfrFkwAjvb6INA84ktcKviA5phfnHAHbUx7fg3D13H1QmBgknoU8WGuA2zfe89d
         gyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QWg+c8mfSLpGnrIT5cTIiGQG7DyX5JzzwtgyUHZpsy4=;
        b=paNgdqKBnTzP5Jeqi1vo3lgX0vAvgnl29LfIJVQiJdN5TOmy2Cr4s14Zk52t9yJ85O
         H0JUNdyJDYVlHn/kIDA8b4u/aK3z8y+gYXZzeM3QDkVacszm8dlNMO/jYbl+IDR2BBCl
         YL4SR1KoLNh0XwsSlN9OygXft5OWm+8jrw3EHKjAmJTXvt5xc2KMgTrbeV6TGJ+aM/9L
         wpzX6y1IQ8nEh+DSej+JfW4JGWke1bncOq1qIA2170OAP4uaKTge36SbPnV/ITpKkDgD
         LGfz2ZDh/cKtKNGQriGQ0GKk1zpboxBjr38O6WK1vf5WyA58vo37OIYQ2n1fxNmVe4PT
         gofA==
X-Gm-Message-State: AJIora9GvQxCWMP1wQ6nk7In+udoUO88AGpfuwT4dXqelLm6cUXy7aL1
        vLgGkpsF7mN5UL2ttpX2zK2hwKPMS0fL636oGx2e4w==
X-Google-Smtp-Source: AGRyM1sAdelFgehnBB1OSIKPRvDpxwzFcPb5n9IG7FURM14GgRWav0ZHhwP05+SXl2PlR933ubt3y/muVSJeoxpLRXE=
X-Received: by 2002:a7b:c8d3:0:b0:3a2:fe0d:ba2e with SMTP id
 f19-20020a7bc8d3000000b003a2fe0dba2emr1465659wml.115.1658277801389; Tue, 19
 Jul 2022 17:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-18-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-18-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 17:43:09 -0700
Message-ID: <CAP-5=fVukKzxtQQFm6PH-ZxNQ-_hVnbYB-LiOek8O8u-8Vbq-Q@mail.gmail.com>
Subject: Re: [PATCH 17/35] perf auxtrace: Add machine_pid and vcpu to auxtrace_error
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
> Add machine_pid and vcpu to struct perf_record_auxtrace_error. The existing
> fmt member is used to identify the new format.
>
> The new members make it possible to easily differentiate errors from guest
> machines.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/lib/perf/include/perf/event.h           |  2 ++
>  tools/perf/util/auxtrace.c                    | 30 +++++++++++++++----
>  tools/perf/util/auxtrace.h                    |  4 +++
>  .../scripting-engines/trace-event-python.c    |  4 ++-
>  tools/perf/util/session.c                     |  4 +++
>  5 files changed, 37 insertions(+), 7 deletions(-)
>
> diff --git a/tools/lib/perf/include/perf/event.h b/tools/lib/perf/include/perf/event.h
> index c2dbd3e88885..556bb06798f2 100644
> --- a/tools/lib/perf/include/perf/event.h
> +++ b/tools/lib/perf/include/perf/event.h
> @@ -279,6 +279,8 @@ struct perf_record_auxtrace_error {
>         __u64                    ip;
>         __u64                    time;
>         char                     msg[MAX_AUXTRACE_ERROR_MSG];
> +       __u32                    machine_pid;
> +       __u32                    vcpu;
>  };
>
>  struct perf_record_aux {
> diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
> index 511dd3caa1bc..6edab8a16de6 100644
> --- a/tools/perf/util/auxtrace.c
> +++ b/tools/perf/util/auxtrace.c
> @@ -1189,9 +1189,10 @@ void auxtrace_buffer__free(struct auxtrace_buffer *buffer)
>         free(buffer);
>  }
>
> -void auxtrace_synth_error(struct perf_record_auxtrace_error *auxtrace_error, int type,
> -                         int code, int cpu, pid_t pid, pid_t tid, u64 ip,
> -                         const char *msg, u64 timestamp)
> +void auxtrace_synth_guest_error(struct perf_record_auxtrace_error *auxtrace_error, int type,
> +                               int code, int cpu, pid_t pid, pid_t tid, u64 ip,
> +                               const char *msg, u64 timestamp,
> +                               pid_t machine_pid, int vcpu)
>  {
>         size_t size;
>
> @@ -1207,12 +1208,26 @@ void auxtrace_synth_error(struct perf_record_auxtrace_error *auxtrace_error, int
>         auxtrace_error->ip = ip;
>         auxtrace_error->time = timestamp;
>         strlcpy(auxtrace_error->msg, msg, MAX_AUXTRACE_ERROR_MSG);
> -
> -       size = (void *)auxtrace_error->msg - (void *)auxtrace_error +
> -              strlen(auxtrace_error->msg) + 1;
> +       if (machine_pid) {
> +               auxtrace_error->fmt = 2;
> +               auxtrace_error->machine_pid = machine_pid;
> +               auxtrace_error->vcpu = vcpu;
> +               size = sizeof(*auxtrace_error);
> +       } else {
> +               size = (void *)auxtrace_error->msg - (void *)auxtrace_error +
> +                      strlen(auxtrace_error->msg) + 1;
> +       }
>         auxtrace_error->header.size = PERF_ALIGN(size, sizeof(u64));
>  }
>
> +void auxtrace_synth_error(struct perf_record_auxtrace_error *auxtrace_error, int type,
> +                         int code, int cpu, pid_t pid, pid_t tid, u64 ip,
> +                         const char *msg, u64 timestamp)
> +{
> +       auxtrace_synth_guest_error(auxtrace_error, type, code, cpu, pid, tid,
> +                                  ip, msg, timestamp, 0, -1);
> +}
> +
>  int perf_event__synthesize_auxtrace_info(struct auxtrace_record *itr,
>                                          struct perf_tool *tool,
>                                          struct perf_session *session,
> @@ -1662,6 +1677,9 @@ size_t perf_event__fprintf_auxtrace_error(union perf_event *event, FILE *fp)
>         if (!e->fmt)
>                 msg = (const char *)&e->time;
>
> +       if (e->fmt >= 2 && e->machine_pid)
> +               ret += fprintf(fp, " machine_pid %d vcpu %d", e->machine_pid, e->vcpu);
> +
>         ret += fprintf(fp, " cpu %d pid %d tid %d ip %#"PRI_lx64" code %u: %s\n",
>                        e->cpu, e->pid, e->tid, e->ip, e->code, msg);
>         return ret;
> diff --git a/tools/perf/util/auxtrace.h b/tools/perf/util/auxtrace.h
> index cd0d25c2751c..6a4fbfd34c6b 100644
> --- a/tools/perf/util/auxtrace.h
> +++ b/tools/perf/util/auxtrace.h
> @@ -595,6 +595,10 @@ int auxtrace_index__process(int fd, u64 size, struct perf_session *session,
>                             bool needs_swap);
>  void auxtrace_index__free(struct list_head *head);
>
> +void auxtrace_synth_guest_error(struct perf_record_auxtrace_error *auxtrace_error, int type,
> +                               int code, int cpu, pid_t pid, pid_t tid, u64 ip,
> +                               const char *msg, u64 timestamp,
> +                               pid_t machine_pid, int vcpu);
>  void auxtrace_synth_error(struct perf_record_auxtrace_error *auxtrace_error, int type,
>                           int code, int cpu, pid_t pid, pid_t tid, u64 ip,
>                           const char *msg, u64 timestamp);
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index adba01b7d9dd..3367c5479199 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -1559,7 +1559,7 @@ static void python_process_auxtrace_error(struct perf_session *session __maybe_u
>                 msg = (const char *)&e->time;
>         }
>
> -       t = tuple_new(9);
> +       t = tuple_new(11);
>
>         tuple_set_u32(t, 0, e->type);
>         tuple_set_u32(t, 1, e->code);
> @@ -1570,6 +1570,8 @@ static void python_process_auxtrace_error(struct perf_session *session __maybe_u
>         tuple_set_u64(t, 6, tm);
>         tuple_set_string(t, 7, msg);
>         tuple_set_u32(t, 8, cpumode);
> +       tuple_set_s32(t, 9, e->machine_pid);
> +       tuple_set_s32(t, 10, e->vcpu);
>
>         call_object(handler, t, handler_name);
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index f3e9fa557bc9..7ea0b91013ea 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -895,6 +895,10 @@ static void perf_event__auxtrace_error_swap(union perf_event *event,
>         event->auxtrace_error.ip   = bswap_64(event->auxtrace_error.ip);
>         if (event->auxtrace_error.fmt)
>                 event->auxtrace_error.time = bswap_64(event->auxtrace_error.time);
> +       if (event->auxtrace_error.fmt >= 2) {
> +               event->auxtrace_error.machine_pid = bswap_32(event->auxtrace_error.machine_pid);
> +               event->auxtrace_error.vcpu = bswap_32(event->auxtrace_error.vcpu);
> +       }
>  }
>
>  static void perf_event__thread_map_swap(union perf_event *event,
> --
> 2.25.1
>
