Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E8257AB33
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiGTAwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiGTAwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:52:15 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CB361DAB
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:52:13 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d8so4010781wrp.6
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ER3SZDJ8bqLtYjsdIXnGnyOVa6KEaDU0tbGo3M8GQ+o=;
        b=RP8uq7dvzY7ZcOMl89frYcq648mtq8ptk2fVGpgJxzqsCqmqzv9UUjmW7Tqdh9ED23
         KK1yXDQfmVZKDZk0PnDdyc6rL/LE6RnoMwlsybiNYJ6ToWPP/uNHTJ4I7RjoaIJ2XaKM
         V+QzxYofeDBxV4CjjswBnmT7/5JPDljB2GZjMJhkjF6pXmZeC/Uhc4du1Hjt/0Mox1qQ
         Pm5AgXZuBPGZPWu8Bk8HpvIFpm5fk+0sS9IGfiUEEh001twCitcR+lcLC7iCkbW6busg
         MKDht1pz4Ilkir9bOkoEOIur7Dc5CBhsgGVaCWXsJmDwYY5c2UOrwYD/6WneNu6mhIBc
         7IQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ER3SZDJ8bqLtYjsdIXnGnyOVa6KEaDU0tbGo3M8GQ+o=;
        b=TXSRykoqJXjkFn7isWmmT6wY74Rs2kVe4RMx7unPlG7OYJ2QMMmS1HKJtl2zI5r/ks
         dWJYJfTBEcOZHxPmJGGmCn8C5BDQKphKtC2hQsZ8YCxOkB1nmAOUmiBkHkwLp66M0Ivc
         daBRyFCALyZhrx2EQmAps2Nz5WWpzdvq15lLD0WhDln3LKDdFjgyGAJPMaYRhiPizteW
         DSrg6cbZpYxf1gGs4KMuVOHen/DMlP/zIUPTnnhJRGGpKT3KJjdsWar0hFSudzQFLWmJ
         iO+2oW8vc2tgg4iDnPvLsaHuB7gShoN0HQKU0QFLUIRizKmZTWWqFAATZz6pv3bFFmRR
         UHKw==
X-Gm-Message-State: AJIora/L1G/K9n2YiSuhQcyHWlogmzhTvTKfstKE5dJX45+Pyj6ROfeA
        mryUPnKE+pzYTdNfilfVY2SD+V0KmQxFN9MPV0OC0qZgmoMGJQ==
X-Google-Smtp-Source: AGRyM1vsx7ghYMje2Teu7tpkP6iH8ZUNGB/d6Bp87NzqsLWVblYaV4K88DOI5w1/VO/mzL/JuHrdeTqrixdzcDSAcug=
X-Received: by 2002:a05:6000:1a8e:b0:21d:a7a8:54f4 with SMTP id
 f14-20020a0560001a8e00b0021da7a854f4mr29373150wry.654.1658278331696; Tue, 19
 Jul 2022 17:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-23-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-23-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 17:51:59 -0700
Message-ID: <CAP-5=fW6oTrkdhywsynTpUwt5xwZcWJtQVwRgcQKeT0gLWv5UQ@mail.gmail.com>
Subject: Re: [PATCH 22/35] perf tools: Automatically use guest kcore_dir if present
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
> When registering a guest machine using machine_pid from the id index,
> check perf.data for a matching kcore_dir subdirectory and set the
> kallsyms file name accordingly. If set, use it to find the machine's
> kernel symbols and object code (from kcore).
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/data.c    | 19 +++++++++++++++++++
>  tools/perf/util/data.h    |  1 +
>  tools/perf/util/machine.h |  1 +
>  tools/perf/util/session.c |  2 ++
>  tools/perf/util/symbol.c  |  6 ++++--
>  5 files changed, 27 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
> index 9782ccbe595d..a7f68c309545 100644
> --- a/tools/perf/util/data.c
> +++ b/tools/perf/util/data.c
> @@ -518,6 +518,25 @@ char *perf_data__kallsyms_name(struct perf_data *data)
>         return kallsyms_name;
>  }
>
> +char *perf_data__guest_kallsyms_name(struct perf_data *data, pid_t machine_pid)
> +{
> +       char *kallsyms_name;
> +       struct stat st;
> +
> +       if (!data->is_dir)
> +               return NULL;
> +
> +       if (asprintf(&kallsyms_name, "%s/kcore_dir__%d/kallsyms", data->path, machine_pid) < 0)

Is there a missing free for this in perf_data__close ?

Thanks,
Ian

> +               return NULL;
> +
> +       if (stat(kallsyms_name, &st)) {
> +               free(kallsyms_name);
> +               return NULL;
> +       }
> +
> +       return kallsyms_name;
> +}
> +
>  bool is_perf_data(const char *path)
>  {
>         bool ret = false;
> diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
> index 7de53d6e2d7f..173132d502f5 100644
> --- a/tools/perf/util/data.h
> +++ b/tools/perf/util/data.h
> @@ -101,5 +101,6 @@ unsigned long perf_data__size(struct perf_data *data);
>  int perf_data__make_kcore_dir(struct perf_data *data, char *buf, size_t buf_sz);
>  bool has_kcore_dir(const char *path);
>  char *perf_data__kallsyms_name(struct perf_data *data);
> +char *perf_data__guest_kallsyms_name(struct perf_data *data, pid_t machine_pid);
>  bool is_perf_data(const char *path);
>  #endif /* __PERF_DATA_H */
> diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
> index 5d7daf7cb7bc..d40b23c71420 100644
> --- a/tools/perf/util/machine.h
> +++ b/tools/perf/util/machine.h
> @@ -48,6 +48,7 @@ struct machine {
>         bool              single_address_space;
>         char              *root_dir;
>         char              *mmap_name;
> +       char              *kallsyms_filename;
>         struct threads    threads[THREADS__TABLE_SIZE];
>         struct vdso_info  *vdso_info;
>         struct perf_env   *env;
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 7ea0b91013ea..98e16659a149 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -2772,6 +2772,8 @@ static int perf_session__register_guest(struct perf_session *session, pid_t mach
>                 return -ENOMEM;
>         thread__put(thread);
>
> +       machine->kallsyms_filename = perf_data__guest_kallsyms_name(session->data, machine_pid);
> +
>         return 0;
>  }
>
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index f72baf636724..a4b22caa7c24 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -2300,11 +2300,13 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map)
>  static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map)
>  {
>         int err;
> -       const char *kallsyms_filename = NULL;
> +       const char *kallsyms_filename;
>         struct machine *machine = map__kmaps(map)->machine;
>         char path[PATH_MAX];
>
> -       if (machine__is_default_guest(machine)) {
> +       if (machine->kallsyms_filename) {
> +               kallsyms_filename = machine->kallsyms_filename;
> +       } else if (machine__is_default_guest(machine)) {
>                 /*
>                  * if the user specified a vmlinux filename, use it and only
>                  * it, reporting errors to the user if it cannot be used.
> --
> 2.25.1
>
