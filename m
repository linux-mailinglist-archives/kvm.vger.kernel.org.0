Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DCA57A5A6
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 19:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiGSRoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 13:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbiGSRoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 13:44:20 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C605A893
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:44:19 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v67-20020a1cac46000000b003a1888b9d36so12484026wme.0
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5IdDA2kur7c9Hb9+rG+ZdCMyG3JxbIJL1PSzFQgUH5o=;
        b=ZIIuhS4ua1uTO7kwc1l4rxuBA7LXRypBuAlsFPWzhNL9nFofU5DhNkgZNJz6DOKCv2
         6l3M/kJC4byCfVYv3yK5egHU2DDv4tf8/LVREEDKjH61gLP6wAcTKW+UsP6jG+KgDKG9
         Ye7cyJk2u8YfQmOAJ4SRqU9lOhepi0VJnqLwx3zwGs+W0h8oSXQeO6012KktbTFd0S5c
         WiwUH4lasS2Aplz2TS+R33KdVDALvTyz50aWoulKMpAmLRpxbdteFzvbJH+9Ldag2SSP
         ugiZDkbbA3DYUHyYPCYuo3HhnGdTE6Mc9CwRZLOrsiae9I+ygG5qAcMqljE233yFTXwe
         jYVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5IdDA2kur7c9Hb9+rG+ZdCMyG3JxbIJL1PSzFQgUH5o=;
        b=5cp+ke65XMI3vxh99lKEVKEnA2D/w0qCxbGLsmrxi3TwSjAEDnvFOr+fvq3Qh4eBSO
         t1EBMvGihZtGqR9jjwEcYvuj9fyHlUaeMJ1bsaN8dAia0eoF8PlG9bEFyMxKXlNWmrMf
         n1srguiWkYQLsFuLuTQlHhyD+fK5K3BKn0lMWkyMiMfVGrYL0TTxCuFFedGmimcN3T1+
         zEsuuJdghfKaXWdgqgYX47L1DghLOR7EbYMe+As3nvVJ40xuFAjEdWXM6HrrYaJQKcIY
         hQRab4qe6qax06WNf4dr08zDiV6khZs6YkN4+2hAutStnxo+U0GUoaJAqiKCxRuq1UB/
         90Rw==
X-Gm-Message-State: AJIora8FCqHWDTAXYDz5zp55Beu37Hg4zn6XDopo+oXCRiO13qthmvvQ
        LKW6ndl+iEnN8YdNOCPZA0LLYissXw2CEvMY5HMOeA==
X-Google-Smtp-Source: AGRyM1sFIIq6afZ2uT/z8JrOxJJ4F4jlXibmTDlVkwYmHmy4Zx5TUiRGDshGxvAHKGCwDqY5Ckk1wHAzMzOGjNcbe50=
X-Received: by 2002:a05:600c:2854:b0:3a3:1551:d7d with SMTP id
 r20-20020a05600c285400b003a315510d7dmr384741wmb.174.1658252657786; Tue, 19
 Jul 2022 10:44:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-10-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-10-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 10:44:05 -0700
Message-ID: <CAP-5=fX4ndBB+0kdW9Bq4b3MDf_appDUj0RiCzbL52k_Agqheg@mail.gmail.com>
Subject: Re: [PATCH 09/35] perf buildid-cache: Do not require purge files to
 also be in the file system
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
> realname() returns NULL if the file is not in the file system, but we can
> still remove it from the build ID cache in that case, so continue and
> attempt the purge with the name provided.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/build-id.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
> index 7c9f441936ee..9e176146eb10 100644
> --- a/tools/perf/util/build-id.c
> +++ b/tools/perf/util/build-id.c
> @@ -561,14 +561,11 @@ char *build_id_cache__cachedir(const char *sbuild_id, const char *name,
>         char *realname = (char *)name, *filename;
>         bool slash = is_kallsyms || is_vdso;
>
> -       if (!slash) {
> +       if (!slash)
>                 realname = nsinfo__realpath(name, nsi);
> -               if (!realname)
> -                       return NULL;
> -       }
>
>         if (asprintf(&filename, "%s%s%s%s%s", buildid_dir, slash ? "/" : "",
> -                    is_vdso ? DSO__NAME_VDSO : realname,
> +                    is_vdso ? DSO__NAME_VDSO : (realname ? realname : name),

nit:  is_vdso ? DSO__NAME_VDSO : (realname ?: name),

Thanks,
Ian

>                      sbuild_id ? "/" : "", sbuild_id ?: "") < 0)
>                 filename = NULL;
>
> --
> 2.25.1
>
