Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD2057AC1A
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 03:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238691AbiGTBSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 21:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241205AbiGTBSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 21:18:35 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E1A6C114
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:14:54 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so340837wmb.5
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YtETk/RtD2vfpKLPOYkK3onAIfmX1vMQdXew1DBAtWE=;
        b=VjHJMI94hF15HeECAjWZcPQbMufkMPjqLIIExiPZ5qpah+cB3gf29WmBjTPZ/CavYw
         urwYjQepGXpKdyesjkgxQSDuqk1ZgWyBxBOX+aPSQy+RvlWtOzBb+TY0wa5PE8WRVhbq
         /NpvkwUGddPCn5BOong0Rby+i06xSMVIaf3Ej+eVZkZ+Vo3mwK64E6pBXbL8PmYq4Zk3
         Jl/l1KWAL2RH+Gjn8t3xn7Yx2TojfuB9egRAemN79qmmOqeMDrOpGILcKE0Qc93/GwTb
         NbSCvKmhqUgWoxM1iuUC4TCt6DjW5g04lb+vKSrDCmdZhW/d9MhqTF85O+3HKl5aI5ZG
         xtFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YtETk/RtD2vfpKLPOYkK3onAIfmX1vMQdXew1DBAtWE=;
        b=aedQfQsnRzaPX5JFn9Mzj+VGh3FTzyH1rcb/Xa/D5JZUqFMufxeHeCWZNhDTJfPtmf
         1Oiw/i5Y0VQ/50VESx73gJBXONl5LTfTCT5rGXyieEleMFf1HYbrW9amhTdp/Vv2Mhd1
         dSsP/pF++HvSHUA7CgRXjGZ2jxY9etz6aXAls2VbOuYJi5Pbt8nVOVIt6SM9bB9ID2jb
         hf2Fh97rkJ6ewke100pDGXXlu87BMNQPSR6oIlizdQBP48GVgDBjdHqe0scK1/NXDKk0
         L4KAL5xwIBJkb39yWdDMlYKdaUzygTgTESSq+0YcIEp4R9d2RfdbiP6LVmNCRm8IeOPG
         POEA==
X-Gm-Message-State: AJIora8IvmK6EEjWjVdebInD1CH/0a1EfLDjbSzLDBm6O9Gt0OvifpEW
        YavcXgBCXjzn/8/Y/U3/BovsarO484q7zAfQoLJXUUV674MUnrq+
X-Google-Smtp-Source: AGRyM1sSipGrC2xG2iqHNRsY+NyReM9AdVDMAmwIm7gnydC6CBKRlCCn5BoAB5dIx7zaUZ5nLyDMnnJBxqYhUViNO2c=
X-Received: by 2002:a05:600c:2854:b0:3a3:1551:d7d with SMTP id
 r20-20020a05600c285400b003a315510d7dmr1437492wmb.174.1658279692551; Tue, 19
 Jul 2022 18:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-32-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-32-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 18:14:40 -0700
Message-ID: <CAP-5=fW0kHPpz5-krEoeRk7QBE7HyerfX-5MrAkukudSTSY52Q@mail.gmail.com>
Subject: Re: [PATCH 31/35] perf intel-pt: Disable sync switch with guest sideband
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
> The sync_switch facility attempts to better synchronize context switches
> with the Intel PT trace, however it is not designed for guest machine
> context switches, so disable it when guest sideband is detected.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/intel-pt.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>
> diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
> index 98b097fec476..dc2af64f9e31 100644
> --- a/tools/perf/util/intel-pt.c
> +++ b/tools/perf/util/intel-pt.c
> @@ -74,6 +74,7 @@ struct intel_pt {
>         bool data_queued;
>         bool est_tsc;
>         bool sync_switch;
> +       bool sync_switch_not_supported;
>         bool mispred_all;
>         bool use_thread_stack;
>         bool callstack;
> @@ -2638,6 +2639,9 @@ static void intel_pt_enable_sync_switch(struct intel_pt *pt)
>  {
>         unsigned int i;
>
> +       if (pt->sync_switch_not_supported)
> +               return;
> +
>         pt->sync_switch = true;
>
>         for (i = 0; i < pt->queues.nr_queues; i++) {
> @@ -2649,6 +2653,23 @@ static void intel_pt_enable_sync_switch(struct intel_pt *pt)
>         }
>  }
>
> +static void intel_pt_disable_sync_switch(struct intel_pt *pt)
> +{
> +       unsigned int i;
> +
> +       pt->sync_switch = false;
> +
> +       for (i = 0; i < pt->queues.nr_queues; i++) {
> +               struct auxtrace_queue *queue = &pt->queues.queue_array[i];
> +               struct intel_pt_queue *ptq = queue->priv;
> +
> +               if (ptq) {
> +                       ptq->sync_switch = false;
> +                       intel_pt_next_tid(pt, ptq);
> +               }
> +       }
> +}
> +
>  /*
>   * To filter against time ranges, it is only necessary to look at the next start
>   * or end time.
> @@ -3090,6 +3111,14 @@ static int intel_pt_guest_context_switch(struct intel_pt *pt,
>
>         pt->have_guest_sideband = true;
>
> +       /*
> +        * sync_switch cannot handle guest machines at present, so just disable
> +        * it.
> +        */
> +       pt->sync_switch_not_supported = true;
> +       if (pt->sync_switch)
> +               intel_pt_disable_sync_switch(pt);
> +
>         if (out)
>                 return 0;
>
> --
> 2.25.1
>
