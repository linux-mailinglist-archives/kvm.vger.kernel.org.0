Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C7E57A593
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 19:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbiGSRmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 13:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiGSRmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 13:42:00 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38174545EA
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:41:59 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id 3so3585578vko.2
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DcsoP6m8Kg52tZZeH6+q4l07BNbA0q//GElbOkdpfLI=;
        b=VXCBjhV0D4wa+CYkZfeA8YOcthqJHWDWE2QuicigRoQyWltCf4zpG2IdAAsETDUsLy
         ZSs7WtSMX7VKnIEijXboD2rl1qfHJbAFV20txcPFCt5aBIZvpN0MLlJxQYHTEd5+dH84
         UBEJrSptpPEoWNYQ9TkPDTZ98PEdr+JYUdt2y0AFooq4DH74pDOAINsLp8B3t4YwxQ8W
         nb+9Xn4r7FnbQDCiMfq+dRoHBZrxREmrJpmqjIaXd9XQ3a5Ke+XHTNCnwLXqPBBjdmYX
         xprtchgWuUeYQJVwh4RbOlRmBxIY57rks2b0vENdvIx5+Gf9NpBvdMeZzyDylxTS8juU
         6OhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DcsoP6m8Kg52tZZeH6+q4l07BNbA0q//GElbOkdpfLI=;
        b=hKZImuHhL4Msnb9Zn5CStuiY1X/guW4K6+mN6EfSGB4ZFd57fd2e0jkZK4sxQ5i7tC
         WX6PaQdAbP7MDNnBpeAgF3RcoPDe363e/yhjUIs+/JQvMMQfs0MdtrMD9jAH+6Zj1kQI
         QT1RWikHIV3HGfKeUdGtGIPUwQSk6m2wuUjbvI2tpHUn13TTlOB3qyXbDpefjOMrG4Bf
         dqaUVvr1vMkU/FUpyfLFuSEDlqZ5+O575qyImMNv8PKobJVv8ymS0feJ+WTRrDQLwSvt
         QVE/DsSkCEvehg3RWfLB4FVpWBK/2A3GM5ytv9CyblQYHZp5FKEI5e+rr3cBBgwdqjjc
         kFLg==
X-Gm-Message-State: AJIora8fG5TVJMD9DK7l4ZnRNZx14l4BOTgZu/8CDCsU+l3ukYNmZ8qi
        FQioXvAr75Fwb0uqvwwTKpubglL1M5KUqhIzylrXEg==
X-Google-Smtp-Source: AGRyM1soQmHY+yPtvTig/Grv4PW8gjJgHHKoQhuc5aas1Yr+zzM5GZXrTrkB0Z4j4ojXzSjeHT4fM2A7l4KjCtXCS1g=
X-Received: by 2002:ac5:ccd4:0:b0:374:bdb0:8e92 with SMTP id
 j20-20020ac5ccd4000000b00374bdb08e92mr12187821vkn.30.1658252518084; Tue, 19
 Jul 2022 10:41:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-9-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-9-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 10:41:46 -0700
Message-ID: <CAP-5=fUF_feSL-+=LQpg=6cRd_nXTWKCM4zU1k8TP-6veP26Rw@mail.gmail.com>
Subject: Re: [PATCH 08/35] perf buildid-cache: Add guestmount'd files to the
 build ID cache
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
> When the guestmount option is used, a guest machine's file system mount
> point is recorded in machine->root_dir.
>
> perf already iterates guest machines when adding files to the build ID
> cache, but does not take machine->root_dir into account.
>
> Use machine->root_dir to find files for guest build IDs, and add them to
> the build ID cache using the "proper" name i.e. relative to the guest root
> directory not the host root directory.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Is it plausible to add a test for this? Our tests create workload but
there's no existing hypervisor way to do this. Perhaps the test can
run in a hypervisor? Or maybe there's a route that doesn't involve
hypervisors.

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/build-id.c | 67 +++++++++++++++++++++++++++++---------
>  tools/perf/util/build-id.h | 16 ++++++---
>  2 files changed, 63 insertions(+), 20 deletions(-)
>
> diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
> index 4c9093b64d1f..7c9f441936ee 100644
> --- a/tools/perf/util/build-id.c
> +++ b/tools/perf/util/build-id.c
> @@ -625,9 +625,12 @@ static int build_id_cache__add_sdt_cache(const char *sbuild_id,
>  #endif
>
>  static char *build_id_cache__find_debug(const char *sbuild_id,
> -                                       struct nsinfo *nsi)
> +                                       struct nsinfo *nsi,
> +                                       const char *root_dir)
>  {
> +       const char *dirname = "/usr/lib/debug/.build-id/";
>         char *realname = NULL;
> +       char dirbuf[PATH_MAX];
>         char *debugfile;
>         struct nscookie nsc;
>         size_t len = 0;
> @@ -636,8 +639,12 @@ static char *build_id_cache__find_debug(const char *sbuild_id,
>         if (!debugfile)
>                 goto out;
>
> -       len = __symbol__join_symfs(debugfile, PATH_MAX,
> -                                  "/usr/lib/debug/.build-id/");
> +       if (root_dir) {
> +               path__join(dirbuf, PATH_MAX, root_dir, dirname);
> +               dirname = dirbuf;
> +       }
> +
> +       len = __symbol__join_symfs(debugfile, PATH_MAX, dirname);
>         snprintf(debugfile + len, PATH_MAX - len, "%.2s/%s.debug", sbuild_id,
>                  sbuild_id + 2);
>
> @@ -668,14 +675,18 @@ static char *build_id_cache__find_debug(const char *sbuild_id,
>
>  int
>  build_id_cache__add(const char *sbuild_id, const char *name, const char *realname,
> -                   struct nsinfo *nsi, bool is_kallsyms, bool is_vdso)
> +                   struct nsinfo *nsi, bool is_kallsyms, bool is_vdso,
> +                   const char *proper_name, const char *root_dir)
>  {
>         const size_t size = PATH_MAX;
>         char *filename = NULL, *dir_name = NULL, *linkname = zalloc(size), *tmp;
>         char *debugfile = NULL;
>         int err = -1;
>
> -       dir_name = build_id_cache__cachedir(sbuild_id, name, nsi, is_kallsyms,
> +       if (!proper_name)
> +               proper_name = name;
> +
> +       dir_name = build_id_cache__cachedir(sbuild_id, proper_name, nsi, is_kallsyms,
>                                             is_vdso);
>         if (!dir_name)
>                 goto out_free;
> @@ -715,7 +726,7 @@ build_id_cache__add(const char *sbuild_id, const char *name, const char *realnam
>          */
>         if (!is_kallsyms && !is_vdso &&
>             strncmp(".ko", name + strlen(name) - 3, 3)) {
> -               debugfile = build_id_cache__find_debug(sbuild_id, nsi);
> +               debugfile = build_id_cache__find_debug(sbuild_id, nsi, root_dir);
>                 if (debugfile) {
>                         zfree(&filename);
>                         if (asprintf(&filename, "%s/%s", dir_name,
> @@ -781,8 +792,9 @@ build_id_cache__add(const char *sbuild_id, const char *name, const char *realnam
>         return err;
>  }
>
> -int build_id_cache__add_s(const char *sbuild_id, const char *name,
> -                         struct nsinfo *nsi, bool is_kallsyms, bool is_vdso)
> +int __build_id_cache__add_s(const char *sbuild_id, const char *name,
> +                           struct nsinfo *nsi, bool is_kallsyms, bool is_vdso,
> +                           const char *proper_name, const char *root_dir)
>  {
>         char *realname = NULL;
>         int err = -1;
> @@ -796,8 +808,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *name,
>                         goto out_free;
>         }
>
> -       err = build_id_cache__add(sbuild_id, name, realname, nsi, is_kallsyms, is_vdso);
> -
> +       err = build_id_cache__add(sbuild_id, name, realname, nsi,
> +                                 is_kallsyms, is_vdso, proper_name, root_dir);
>  out_free:
>         if (!is_kallsyms)
>                 free(realname);
> @@ -806,14 +818,16 @@ int build_id_cache__add_s(const char *sbuild_id, const char *name,
>
>  static int build_id_cache__add_b(const struct build_id *bid,
>                                  const char *name, struct nsinfo *nsi,
> -                                bool is_kallsyms, bool is_vdso)
> +                                bool is_kallsyms, bool is_vdso,
> +                                const char *proper_name,
> +                                const char *root_dir)
>  {
>         char sbuild_id[SBUILD_ID_SIZE];
>
>         build_id__sprintf(bid, sbuild_id);
>
> -       return build_id_cache__add_s(sbuild_id, name, nsi, is_kallsyms,
> -                                    is_vdso);
> +       return __build_id_cache__add_s(sbuild_id, name, nsi, is_kallsyms,
> +                                      is_vdso, proper_name, root_dir);
>  }
>
>  bool build_id_cache__cached(const char *sbuild_id)
> @@ -896,6 +910,10 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
>         bool is_kallsyms = dso__is_kallsyms(dso);
>         bool is_vdso = dso__is_vdso(dso);
>         const char *name = dso->long_name;
> +       const char *proper_name = NULL;
> +       const char *root_dir = NULL;
> +       char *allocated_name = NULL;
> +       int ret = 0;
>
>         if (!dso->has_build_id)
>                 return 0;
> @@ -905,11 +923,28 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
>                 name = machine->mmap_name;
>         }
>
> +       if (!machine__is_host(machine)) {
> +               if (*machine->root_dir) {
> +                       root_dir = machine->root_dir;
> +                       ret = asprintf(&allocated_name, "%s/%s", root_dir, name);
> +                       if (ret < 0)
> +                               return ret;
> +                       proper_name = name;
> +                       name = allocated_name;
> +               } else if (is_kallsyms) {
> +                       /* Cannot get guest kallsyms */
> +                       return 0;
> +               }
> +       }
> +
>         if (!is_kallsyms && dso__build_id_mismatch(dso, name))
> -               return 0;
> +               goto out_free;
>
> -       return build_id_cache__add_b(&dso->bid, name, dso->nsinfo,
> -                                    is_kallsyms, is_vdso);
> +       ret = build_id_cache__add_b(&dso->bid, name, dso->nsinfo,
> +                                   is_kallsyms, is_vdso, proper_name, root_dir);
> +out_free:
> +       free(allocated_name);
> +       return ret;
>  }
>
>  static int
> diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
> index c19617151670..4e3a1169379b 100644
> --- a/tools/perf/util/build-id.h
> +++ b/tools/perf/util/build-id.h
> @@ -66,10 +66,18 @@ int build_id_cache__list_build_ids(const char *pathname, struct nsinfo *nsi,
>                                    struct strlist **result);
>  bool build_id_cache__cached(const char *sbuild_id);
>  int build_id_cache__add(const char *sbuild_id, const char *name, const char *realname,
> -                       struct nsinfo *nsi, bool is_kallsyms, bool is_vdso);
> -int build_id_cache__add_s(const char *sbuild_id,
> -                         const char *name, struct nsinfo *nsi,
> -                         bool is_kallsyms, bool is_vdso);
> +                       struct nsinfo *nsi, bool is_kallsyms, bool is_vdso,
> +                       const char *proper_name, const char *root_dir);
> +int __build_id_cache__add_s(const char *sbuild_id,
> +                           const char *name, struct nsinfo *nsi,
> +                           bool is_kallsyms, bool is_vdso,
> +                           const char *proper_name, const char *root_dir);
> +static inline int build_id_cache__add_s(const char *sbuild_id,
> +                                       const char *name, struct nsinfo *nsi,
> +                                       bool is_kallsyms, bool is_vdso)
> +{
> +       return __build_id_cache__add_s(sbuild_id, name, nsi, is_kallsyms, is_vdso, NULL, NULL);
> +}
>  int build_id_cache__remove_s(const char *sbuild_id);
>
>  extern char buildid_dir[];
> --
> 2.25.1
>
