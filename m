Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D7957B04E
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 07:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiGTF1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 01:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGTF1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 01:27:34 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81EA65D65
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 22:27:32 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h17so24584606wrx.0
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 22:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o1bzwrZ7xrNQsZMDri7vhFpI42cHYCiVcTDW2mlHIhk=;
        b=NC/9tb7lkvCSVXA4rC0UW7s/1GlhM0fH/nqJWI5ve5eM0H5JcaMvNnRkG0aTdNfoKO
         DHanGIvCxFnadQrAsigzqfikgMVPYtO89ie/RLytxrYyuoySTnnMKLEuNoWerSm+9iCa
         9irtsq0aFvFsJBajnE5EyzVg2Pd3ACw2/o2xkdUnxLeIiqdhuuJD2hhK5monj8agz3kf
         2E3JcWCeHEhMjBK6KKBRnvt6R/B4scGVBQrO5GIIenxQCI1xGoAhET7fuEiszyowgUk0
         h7DGqh7EAJmta4tRybntImsAe8J2WIpZ1TYVgukiKsvZCKWPjut6leZwLLtIfynmk8JY
         EBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o1bzwrZ7xrNQsZMDri7vhFpI42cHYCiVcTDW2mlHIhk=;
        b=NvimI7GxMOB2XDes7aXZPda/tZpUptnQIz7Ae2C3j5Yyj0Cw66aUkWMbQg3P4q4XzW
         uqgS/L6TRqwxm/ruuUa1jelEMACnlK+BmPq8pF9oldJeCod8H7veG0A86Bl3hZYhZ7Ch
         G8s6FOq4YrZ+AWWlgj7SZywwy1vKHYU72imus1Ss+aIpvC0X3Su05b+tSyIMh5IXUEj9
         lQ9hVjtoC6J1VuCHIPDH548cDttiRc1TnJyqszgzThWAOejVB+Bpvvnrufl0fF114sp7
         wJHcgTNxkucaFhuMboBHliTzNzcMOR4DlFvmt8O4vy+bgHoaryb+8JkGkE2ZkwsTvMuo
         kVTg==
X-Gm-Message-State: AJIora+/05oHk7eq3xaQmZyEuFQ4E5WZk9e0Q8wjlWTIsEjCE7ZKD7Gy
        bKfYgpyAbQdxox1nr2Ibd/LgBozNeAh9GN5+1L4Z6A==
X-Google-Smtp-Source: AGRyM1uzkIOODuIU3J2njxuPFpUFVushkZvg9zAr4muiUYOWDyqem3fW63/iDwgrB4LAhVkl9/cLjf6guZxfSDki+0I=
X-Received: by 2002:a05:6000:1a8e:b0:21d:a7a8:54f4 with SMTP id
 f14-20020a0560001a8e00b0021da7a854f4mr29946946wry.654.1658294851283; Tue, 19
 Jul 2022 22:27:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-34-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-34-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 22:27:19 -0700
Message-ID: <CAP-5=fXbpECSAZahduzcNuGRTbiaUuh4eoXnK6Dfnd5bcoRhNQ@mail.gmail.com>
Subject: Re: [PATCH 33/35] perf intel-pt: Add machine_pid and vcpu to auxtrace_error
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

On Mon, Jul 11, 2022 at 2:34 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> When decoding with guest sideband information, for VMX non-root (NR)
> i.e. guest errors, replace the host (hypervisor) pid/tid with guest values,
> and provide also the new machine_pid and vcpu values.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/intel-pt.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
>
> diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
> index a08c2f059d5a..143a096b567b 100644
> --- a/tools/perf/util/intel-pt.c
> +++ b/tools/perf/util/intel-pt.c
> @@ -2404,7 +2404,8 @@ static int intel_pt_synth_iflag_chg_sample(struct intel_pt_queue *ptq)
>  }
>
>  static int intel_pt_synth_error(struct intel_pt *pt, int code, int cpu,
> -                               pid_t pid, pid_t tid, u64 ip, u64 timestamp)
> +                               pid_t pid, pid_t tid, u64 ip, u64 timestamp,
> +                               pid_t machine_pid, int vcpu)
>  {
>         union perf_event event;
>         char msg[MAX_AUXTRACE_ERROR_MSG];
> @@ -2421,8 +2422,9 @@ static int intel_pt_synth_error(struct intel_pt *pt, int code, int cpu,
>
>         intel_pt__strerror(code, msg, MAX_AUXTRACE_ERROR_MSG);
>
> -       auxtrace_synth_error(&event.auxtrace_error, PERF_AUXTRACE_ERROR_ITRACE,
> -                            code, cpu, pid, tid, ip, msg, timestamp);
> +       auxtrace_synth_guest_error(&event.auxtrace_error, PERF_AUXTRACE_ERROR_ITRACE,
> +                                  code, cpu, pid, tid, ip, msg, timestamp,
> +                                  machine_pid, vcpu);
>
>         err = perf_session__deliver_synth_event(pt->session, &event, NULL);
>         if (err)
> @@ -2437,11 +2439,22 @@ static int intel_ptq_synth_error(struct intel_pt_queue *ptq,
>  {
>         struct intel_pt *pt = ptq->pt;
>         u64 tm = ptq->timestamp;
> +       pid_t machine_pid = 0;
> +       pid_t pid = ptq->pid;
> +       pid_t tid = ptq->tid;
> +       int vcpu = -1;
>
>         tm = pt->timeless_decoding ? 0 : tsc_to_perf_time(tm, &pt->tc);
>
> -       return intel_pt_synth_error(pt, state->err, ptq->cpu, ptq->pid,
> -                                   ptq->tid, state->from_ip, tm);
> +       if (pt->have_guest_sideband && state->from_nr) {
> +               machine_pid = ptq->guest_machine_pid;
> +               vcpu = ptq->vcpu;
> +               pid = ptq->guest_pid;
> +               tid = ptq->guest_tid;
> +       }
> +
> +       return intel_pt_synth_error(pt, state->err, ptq->cpu, pid, tid,
> +                                   state->from_ip, tm, machine_pid, vcpu);
>  }
>
>  static int intel_pt_next_tid(struct intel_pt *pt, struct intel_pt_queue *ptq)
> @@ -3028,7 +3041,8 @@ static int intel_pt_process_timeless_sample(struct intel_pt *pt,
>  static int intel_pt_lost(struct intel_pt *pt, struct perf_sample *sample)
>  {
>         return intel_pt_synth_error(pt, INTEL_PT_ERR_LOST, sample->cpu,
> -                                   sample->pid, sample->tid, 0, sample->time);
> +                                   sample->pid, sample->tid, 0, sample->time,
> +                                   sample->machine_pid, sample->vcpu);
>  }
>
>  static struct intel_pt_queue *intel_pt_cpu_to_ptq(struct intel_pt *pt, int cpu)
> --
> 2.25.1
>
