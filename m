Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94AC57A5C8
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 19:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbiGSRvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 13:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237923AbiGSRvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 13:51:41 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2C4558CB
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:51:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d8so2793598wrp.6
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SieDmqK9J1h609x4vSmfoTVzQMopY1SXeRb3Ll+BMWc=;
        b=Rx/6js5ipM757vGZL6pg2GyudRa09IykQ8MRFpbIRUFuy1mBqjCKrhsXxznN0xprPN
         x29xEl/Qaqr/vKjZ7I7K2ofEYGt6o+WJuqtvvWX9RIqlKl8dEHzFyGrb6rbWkMSGQbqq
         5ueLNicDXZYEjXXetR+PMiKBVAqyePG4LRgB6Vfldl7+nXCpf4zGetYbHTNKQHp2xB5y
         R6+s4BlazmhyFlV5ZV/R5OPEvrkimqTSfGHHIbQ3wcanqbkrQ/V9YLresql07lpQVC0D
         1Qbjps2NYf0mTTtXSIrAuvvE4jhEBFh+AlUISbrRjnkl/HobcsSXHQtZq91lQDjWjmlT
         MkNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SieDmqK9J1h609x4vSmfoTVzQMopY1SXeRb3Ll+BMWc=;
        b=p1C2Vj4j14Gs9ZdLAveBIzRYl4Xd0VvhOnf4RVAUWs0zP5Ian+stMUN+hoWCrx3jHw
         ULZZlMCZ+b3H5CdFTiJt+j0Jhwsyy1q9x5ZnFWtRGSd81iBtkjGQ0of6Y/DCVKxAWEe4
         ptGZ++B4zaY3pBMd0Xf034hw9DoTQM6Z0hOp4fcSGWeTVGxo4GfY43jB+M2FEiP/KaC6
         IRzpV32Sq+6DDCGwAmnqeh5sQjwb0qJBY1h2y9LLhOaKBJzXpgViy8BMYF7CUbun4oDR
         OfuL++JmzhiUHdYJFkyQ7DQs9XPmI7XtaXlsYfFe0UNm0sbVF/Fzt2SYkoEQAgJOBgVf
         yYsQ==
X-Gm-Message-State: AJIora9uKPgTKgRKJ9gQCBtOq57ule/LgZBP+PtrE+ET/DwlZjJzHzsA
        5LV1V7H6gRUWOTZiUduUejR8RPEkfQSqcVwzlFFb+w==
X-Google-Smtp-Source: AGRyM1vgAlJo4741zJxidIxS1f+q/y3qjO10bkWI8pwZWh4HfDxzQZHuMOAcMwVRZ7HxSUF5ynNRS83ySShFqJo1/sE=
X-Received: by 2002:a5d:6a4c:0:b0:21e:46d4:6eec with SMTP id
 t12-20020a5d6a4c000000b0021e46d46eecmr782189wrw.375.1658253099207; Tue, 19
 Jul 2022 10:51:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-12-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-12-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 10:51:27 -0700
Message-ID: <CAP-5=fVmRXQr9WmygngsCZ1=4f9e4YK_6GqTv9o1S3-8O=C1TA@mail.gmail.com>
Subject: Re: [PATCH 11/35] perf session: Create guest machines from id_index
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
> Now that id_index has machine_pid, use it to create guest machines.
> Create the guest machines with an idle thread because guest events
> for "swapper" will be possible.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Nothing obviously off to my unqualified eyes :-)

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/session.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 5141fe164e97..1af981d5ad3c 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -2751,6 +2751,24 @@ void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
>         fprintf(fp, "# ========\n#\n");
>  }
>
> +static int perf_session__register_guest(struct perf_session *session, pid_t machine_pid)
> +{
> +       struct machine *machine = machines__findnew(&session->machines, machine_pid);
> +       struct thread *thread;
> +
> +       if (!machine)
> +               return -ENOMEM;
> +
> +       machine->single_address_space = session->machines.host.single_address_space;
> +
> +       thread = machine__idle_thread(machine);
> +       if (!thread)
> +               return -ENOMEM;
> +       thread__put(thread);
> +
> +       return 0;
> +}
> +
>  int perf_event__process_id_index(struct perf_session *session,
>                                  union perf_event *event)
>  {
> @@ -2762,6 +2780,7 @@ int perf_event__process_id_index(struct perf_session *session,
>         size_t e2_sz = sizeof(struct id_index_entry_2);
>         size_t etot_sz = e1_sz + e2_sz;
>         struct id_index_entry_2 *e2;
> +       pid_t last_pid = 0;
>
>         max_nr = sz / e1_sz;
>         nr = ie->nr;
> @@ -2787,6 +2806,7 @@ int perf_event__process_id_index(struct perf_session *session,
>         for (i = 0; i < nr; i++, (e2 ? e2++ : 0)) {
>                 struct id_index_entry *e = &ie->entries[i];
>                 struct perf_sample_id *sid;
> +               int ret;
>
>                 if (dump_trace) {
>                         fprintf(stdout, " ... id: %"PRI_lu64, e->id);
> @@ -2814,6 +2834,17 @@ int perf_event__process_id_index(struct perf_session *session,
>
>                 sid->machine_pid = e2->machine_pid;
>                 sid->vcpu.cpu = e2->vcpu;
> +
> +               if (!sid->machine_pid)
> +                       continue;
> +
> +               if (sid->machine_pid != last_pid) {
> +                       ret = perf_session__register_guest(session, sid->machine_pid);
> +                       if (ret)
> +                               return ret;
> +                       last_pid = sid->machine_pid;
> +                       perf_guest = true;
> +               }
>         }
>         return 0;
>  }
> --
> 2.25.1
>
