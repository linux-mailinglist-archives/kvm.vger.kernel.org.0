Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3934057AB20
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238820AbiGTAtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiGTAtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:49:17 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8660A50078
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:49:16 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z13so4387632wro.13
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CCHJ8TobgNF0fvOIJkxeBTzsYQrtkNxAc5kDWAR8KfI=;
        b=SxO1jUvGIpBRy5VdJnJT8+R8tvYeHZtqL9UrjN4GE6cgDwkdyy9FiLJ/jweKfvR86f
         oNLbVdYrlTK8G1Lw9DMg1SrVgExD9D4qMhlmRPXGwQd3xy24g9N84Ob1cEpZ5Aqr0SD5
         vxAWeMIKYPi+Jvun68SZE+XtIbq0NYkHHqHS2bdIX8O8Xlz65TLFPcsIaDTbJY3zgOjH
         PPkpT0caHTMtlAh+GdeVZBvJ9WBMVOTm8oJB4ZIracc3O2ZgNGF8DiF0CDXzEzaxOMGh
         zXVl/W1kbl3MFaVHsB8dZc11gnCF2VNTRhCenJsqJHvoNC3kESiWNH/S0uywLctBs3En
         zJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CCHJ8TobgNF0fvOIJkxeBTzsYQrtkNxAc5kDWAR8KfI=;
        b=c1ujhr937xQyUSJTMqhcZXywjlq94paNRFvNQV+iz75l9yGvhXtqrzLBAlhotfnq3p
         Y4k+C2MkbrEQfTK/VLdyweXpA+dl8VTyCTzzBZ3RMt+vp90vn+Zi+ePv0au/AWkebEJL
         DUoZBnxgIHgB3tkA1EWymaHjLCpNfudK9+CiP2b7XmDYzK+f6kgKLKAVdz0ihoyx1xi/
         g6MidMyLaqaopDLpy5/1eSHs3VeAarfEip0oM+icbQBFNsPHhDzoTULfonId5VEUvXJE
         GCyJfP0iBh4O1TGXpjyZI30oBkmsVPxTkMH6QZ8or3mEEVla6GOvYV8hxhmvOW5pdla1
         mQhQ==
X-Gm-Message-State: AJIora8sfvPz4936RoyAly//PWA3DgfCCts0gth1IXDqxO1TqDig2T51
        GVAG4oQ3CPqmFCJrNVVovGfAG4GYD9sJEpdmSiZcSQ==
X-Google-Smtp-Source: AGRyM1uvgh7fMymdevr4ko1E6swNPkbI4DxBgqYR2k9LfvWsS0SUhD4eMwTX2+9goi0zly+CcPFfTKxaIS7U+PffeWk=
X-Received: by 2002:a5d:6a4c:0:b0:21e:46d4:6eec with SMTP id
 t12-20020a5d6a4c000000b0021e46d46eecmr1642570wrw.375.1658278155003; Tue, 19
 Jul 2022 17:49:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-22-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-22-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 17:49:03 -0700
Message-ID: <CAP-5=fUKkR_coQQX-pce41OYCG4BuLxmidduXy53XKX4Jy+67g@mail.gmail.com>
Subject: Re: [PATCH 21/35] perf tools: Make has_kcore_dir() work also for
 guest kcore_dir
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
> Copies of /proc/kallsyms, /proc/modules and an extract of /proc/kcore can
> be stored in the perf.data output directory under the subdirectory named
> kcore_dir. Guest machines will have their files also under subdirectories
> beginning kcore_dir__ followed by the machine pid. Make has_kcore_dir()
> return true also if there is a guest machine kcore_dir.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/data.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
> index caabeac24c69..9782ccbe595d 100644
> --- a/tools/perf/util/data.c
> +++ b/tools/perf/util/data.c
> @@ -3,6 +3,7 @@
>  #include <linux/kernel.h>
>  #include <linux/string.h>
>  #include <linux/zalloc.h>
> +#include <linux/err.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <errno.h>
> @@ -481,16 +482,21 @@ int perf_data__make_kcore_dir(struct perf_data *data, char *buf, size_t buf_sz)
>
>  bool has_kcore_dir(const char *path)
>  {
> -       char *kcore_dir;
> -       int ret;
> -
> -       if (asprintf(&kcore_dir, "%s/kcore_dir", path) < 0)
> -               return false;
> -
> -       ret = access(kcore_dir, F_OK);
> +       struct dirent *d = ERR_PTR(-EINVAL);
> +       const char *name = "kcore_dir";
> +       DIR *dir = opendir(path);
> +       size_t n = strlen(name);
> +       bool result = false;
> +
> +       if (dir) {
> +               while (d && !result) {
> +                       d = readdir(dir);
> +                       result = d ? strncmp(d->d_name, name, n) : false;
> +               }
> +               closedir(dir);
> +       }
>
> -       free(kcore_dir);
> -       return !ret;
> +       return result;
>  }
>
>  char *perf_data__kallsyms_name(struct perf_data *data)
> --
> 2.25.1
>
