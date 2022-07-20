Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E6057AB51
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 03:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbiGTBJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 21:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiGTBJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 21:09:40 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE754A819
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:09:38 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so340568wmb.3
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RBVHVAW43BmInQW8xdWR/v8IxSN7KBGQTfI9TbyJA0U=;
        b=U1Lw/qiDoDIqyitCRCAlGJ/9641N+Vv9cSAAErraLVH325IfX1NfIerCLnJ5p1KSG2
         9+8v7A86wA1VWIibPPJSu0GaH8MGvQw+psEcWyyX7b6LjuoKGg23u0+rjPWt/g0zNVWL
         vwc3NuwEmDFX7NCshT4Pi+okffZT95HjVdDJfGSyd6IQ3D/jln1Ok7KAKICKCc0mIoIL
         oxUW1WvtypqyX/sr3RU77QQeYZ0UN9RcH6K6B45KO1bj6/rUzQj7ZeSUNwyFxkFo5duU
         WRVsrKNp5di7h74mJBKhYj7nmTv+joLbP0MJPa3kobt+pHqs9whxO7D30KJG4sZ8aZJw
         EBJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RBVHVAW43BmInQW8xdWR/v8IxSN7KBGQTfI9TbyJA0U=;
        b=HosE0A+STlSBcuUQSY9ZAwdw65roQOunOed9VAValISjuroiIISkqHcUQPDPUjsFcN
         HPCQpDZ2Ow3dHITJkucSF69azcJC9N/Nbi86vfl8YX/CkCfcg/LoPDjr26LgXvMquPzL
         D9YVihdSstvWWYNDRSMl8qK2PGMOdEXaW6z6eKujGZGjRL0hGWMii5GqPXoQF7NOyLYJ
         16cpn0TvWFQ/nw0+xyNSHI75DFY4ha/xOrHA9rDo6cGm+W/GSe82edvjp4PhxPuUkn/B
         b1IKJ4C0QTCNVsB3RL5f9eOFZ2h3p5LbOMx+AzFqlzhGT+GDu54XumqTqNCTDhZkmDah
         hSWA==
X-Gm-Message-State: AJIora/BF2gvZybif5LbFgkPuLsfDjeqIs1igecLmKoGiQprvxqjg01C
        ws43K6K7yw0+bQ7mKU/BSx10RGUAVP7WwaVWojDunw==
X-Google-Smtp-Source: AGRyM1txJjTrndM+sbtdvs/TWSbN+GJAz0n1EgDaOdmwLJpHQ2Foo2ces9t0uO7ZnwAko35RvufUgXmNw2ogOqlvC9k=
X-Received: by 2002:a7b:ce13:0:b0:3a3:102c:23d3 with SMTP id
 m19-20020a7bce13000000b003a3102c23d3mr1454769wmc.67.1658279377164; Tue, 19
 Jul 2022 18:09:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-27-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-27-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 18:09:24 -0700
Message-ID: <CAP-5=fXPCpKqPD3meS2tbWuubs2U1q139J2a=_TTAXrTaWVHZw@mail.gmail.com>
Subject: Re: [PATCH 26/35] perf tools: Handle injected guest kernel mmap event
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
> If a kernel mmap event was recorded inside a guest and injected into a host
> perf.data file, then it will match a host mmap_name not a guest mmap_name,
> see machine__set_mmap_name(). So try matching a host mmap_name in that
> case.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>


Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/machine.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 27d1a38f44c3..8f657225fb02 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1742,6 +1742,7 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
>         struct map *map;
>         enum dso_space_type dso_space;
>         bool is_kernel_mmap;
> +       const char *mmap_name = machine->mmap_name;
>
>         /* If we have maps from kcore then we do not need or want any others */
>         if (machine__uses_kcore(machine))
> @@ -1752,8 +1753,16 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
>         else
>                 dso_space = DSO_SPACE__KERNEL_GUEST;
>
> -       is_kernel_mmap = memcmp(xm->name, machine->mmap_name,
> -                               strlen(machine->mmap_name) - 1) == 0;
> +       is_kernel_mmap = memcmp(xm->name, mmap_name, strlen(mmap_name) - 1) == 0;
> +       if (!is_kernel_mmap && !machine__is_host(machine)) {
> +               /*
> +                * If the event was recorded inside the guest and injected into
> +                * the host perf.data file, then it will match a host mmap_name,
> +                * so try that - see machine__set_mmap_name().
> +                */
> +               mmap_name = "[kernel.kallsyms]";
> +               is_kernel_mmap = memcmp(xm->name, mmap_name, strlen(mmap_name) - 1) == 0;
> +       }
>         if (xm->name[0] == '/' ||
>             (!is_kernel_mmap && xm->name[0] == '[')) {
>                 map = machine__addnew_module_map(machine, xm->start,
> @@ -1767,7 +1776,7 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
>                         dso__set_build_id(map->dso, bid);
>
>         } else if (is_kernel_mmap) {
> -               const char *symbol_name = (xm->name + strlen(machine->mmap_name));
> +               const char *symbol_name = xm->name + strlen(mmap_name);
>                 /*
>                  * Should be there already, from the build-id table in
>                  * the header.
> --
> 2.25.1
>
