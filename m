Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDA557AC38
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 03:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiGTBV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 21:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241479AbiGTBUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 21:20:33 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D615469F0E
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:16:05 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a5so23983377wrx.12
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bW+JKCRkrraL1G5WWSlYo9qIrZupPzOKLmThC+fgGao=;
        b=eavKJoLYp39eJ+OuLSSa1CvQnHWU83szgReL2+yzBxcOrUywcl3h9xNSztKN1YTc2J
         DuKheVv6jMqkdsu0iRSZi8nop2iOZcz27X3YuO8o6CxKmTw9TEuqxvE9yJ+pJNie9sFu
         SZx1wgnKG5c6ZULFGPBqzJxpOj7El+Fh679ZiAnawNJ472eEuXjETaa6zI4h80qUGmnL
         YXlFPzq3r6eg2WO8AHe/vI6FlyN2wrWHiNlleF2hEd8ZbcYCV9IHaA3ah9sSdpc98wt5
         TenaDC8QOoRuTLpJnPus2WKtb2DhsPVWTDfJZgfg4meBlkGFdcR3xrW9w4oZyKwD0sGy
         z9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bW+JKCRkrraL1G5WWSlYo9qIrZupPzOKLmThC+fgGao=;
        b=Qn7hHmkGDcCRKmb/+8ITgW7nWmrs2j/Ac07lEij0pY7wSUMS+hBvdG+lUuWhmMm9Pp
         ayN9wYsJIVtc7MGCUJpaUpIhf3mtueA4r35aCwesZDrs1f7DxUD/Zt1OHGmAH/S8Ktgb
         jZZWiNZZrfH5Kekr6NRm1IvU2lt3jRtVumbrTnBZfBWwdXOjpkZ2Wx0aPLT0Qr8zJAEh
         MlxeSCsCpGpiVuC9HCpjxdKGEprfdHKdBXHkK86MRLP62dxmAs/vghlMLnSdWvY5Xg/x
         kHaOKzPyACjnTM3bWRF9QJBdlUZ3I3caH/EDIZEbn042taBoxyMO6no204NWR9+hic2S
         yWbw==
X-Gm-Message-State: AJIora9uJBsuup59NJteal/7k5xkcXrAVtF8dz87ZY53Ga2TUKpTuqgE
        b34WBIyWL0vRqwR5dBEhGew2tO1t2Srg1vc4tUEjRzTWfFxOofkd
X-Google-Smtp-Source: AGRyM1vT8gdog19dsLbf908GQkADJf3t9ZiSnp1ex3lEChjSSJCdKA8Da8yefYrfZkwRdvoLOl3IgFVQA6Zw1hKgctw=
X-Received: by 2002:a5d:4d92:0:b0:21d:6f02:d971 with SMTP id
 b18-20020a5d4d92000000b0021d6f02d971mr27852330wru.300.1658279764042; Tue, 19
 Jul 2022 18:16:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-33-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-33-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 18:15:52 -0700
Message-ID: <CAP-5=fWRH0wUfsUA+=s8BFJLycth+xopfM-miyk0EPe+rUwoJw@mail.gmail.com>
Subject: Re: [PATCH 32/35] perf intel-pt: Determine guest thread from guest sideband
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
> Prior to decoding, determine what guest thread, if any, is running.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/intel-pt.c | 69 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 67 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
> index dc2af64f9e31..a08c2f059d5a 100644
> --- a/tools/perf/util/intel-pt.c
> +++ b/tools/perf/util/intel-pt.c
> @@ -196,6 +196,10 @@ struct intel_pt_queue {
>         struct machine *guest_machine;
>         struct thread *guest_thread;
>         struct thread *unknown_guest_thread;
> +       pid_t guest_machine_pid;
> +       pid_t guest_pid;
> +       pid_t guest_tid;
> +       int vcpu;
>         bool exclude_kernel;
>         bool have_sample;
>         u64 time;
> @@ -759,8 +763,13 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
>         cpumode = intel_pt_nr_cpumode(ptq, *ip, nr);
>
>         if (nr) {
> -               if ((!symbol_conf.guest_code && cpumode != PERF_RECORD_MISC_GUEST_KERNEL) ||
> -                   intel_pt_get_guest(ptq)) {
> +               if (ptq->pt->have_guest_sideband) {
> +                       if (!ptq->guest_machine || ptq->guest_machine_pid != ptq->pid) {
> +                               intel_pt_log("ERROR: guest sideband but no guest machine\n");
> +                               return -EINVAL;
> +                       }
> +               } else if ((!symbol_conf.guest_code && cpumode != PERF_RECORD_MISC_GUEST_KERNEL) ||
> +                          intel_pt_get_guest(ptq)) {
>                         intel_pt_log("ERROR: no guest machine\n");
>                         return -EINVAL;
>                 }
> @@ -1385,6 +1394,55 @@ static void intel_pt_first_timestamp(struct intel_pt *pt, u64 timestamp)
>         }
>  }
>
> +static int intel_pt_get_guest_from_sideband(struct intel_pt_queue *ptq)
> +{
> +       struct machines *machines = &ptq->pt->session->machines;
> +       struct machine *machine;
> +       pid_t machine_pid = ptq->pid;
> +       pid_t tid;
> +       int vcpu;
> +
> +       if (machine_pid <= 0)
> +               return 0; /* Not a guest machine */
> +
> +       machine = machines__find(machines, machine_pid);
> +       if (!machine)
> +               return 0; /* Not a guest machine */
> +
> +       if (ptq->guest_machine != machine) {
> +               ptq->guest_machine = NULL;
> +               thread__zput(ptq->guest_thread);
> +               thread__zput(ptq->unknown_guest_thread);
> +
> +               ptq->unknown_guest_thread = machine__find_thread(machine, 0, 0);
> +               if (!ptq->unknown_guest_thread)
> +                       return -1;
> +               ptq->guest_machine = machine;
> +       }
> +
> +       vcpu = ptq->thread ? ptq->thread->guest_cpu : -1;
> +       if (vcpu < 0)
> +               return -1;
> +
> +       tid = machine__get_current_tid(machine, vcpu);
> +
> +       if (ptq->guest_thread && ptq->guest_thread->tid != tid)
> +               thread__zput(ptq->guest_thread);
> +
> +       if (!ptq->guest_thread) {
> +               ptq->guest_thread = machine__find_thread(machine, -1, tid);
> +               if (!ptq->guest_thread)
> +                       return -1;
> +       }
> +
> +       ptq->guest_machine_pid = machine_pid;
> +       ptq->guest_pid = ptq->guest_thread->pid_;
> +       ptq->guest_tid = tid;
> +       ptq->vcpu = vcpu;
> +
> +       return 0;
> +}
> +
>  static void intel_pt_set_pid_tid_cpu(struct intel_pt *pt,
>                                      struct auxtrace_queue *queue)
>  {
> @@ -1405,6 +1463,13 @@ static void intel_pt_set_pid_tid_cpu(struct intel_pt *pt,
>                 if (queue->cpu == -1)
>                         ptq->cpu = ptq->thread->cpu;
>         }
> +
> +       if (pt->have_guest_sideband && intel_pt_get_guest_from_sideband(ptq)) {
> +               ptq->guest_machine_pid = 0;
> +               ptq->guest_pid = -1;
> +               ptq->guest_tid = -1;
> +               ptq->vcpu = -1;
> +       }
>  }
>
>  static void intel_pt_sample_flags(struct intel_pt_queue *ptq)
> --
> 2.25.1
>
