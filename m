Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B47F57AB11
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbiGTAmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbiGTAmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:42:19 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8285651413
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:42:18 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id ay11-20020a05600c1e0b00b003a3013da120so334296wmb.5
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qdzg5dRrrvZkFJYc/FsK4s6W7dGDoVHBhYE1aXDxorA=;
        b=qx3XnfIuSVf42uMNXdFmCdTMajg2L9bUAl5SS8urym7r5VLPiZT0qceeOf88X2+XKy
         mZzsz6gh/+NGWkcN1/UYu4h7ZLrcc2iX1MKCR3lvyfPXeD8E1BgVB0R1AEM0l3uRp5aA
         /dckGEcilZfmMrkAsxajvj9re2PiGUwhCEjgJygrt77UrWDL1p9lznxagsYOizR40Ctr
         nWZTb+KsslAtGJB2R31xv4n7tvHL7lxJ0WENnmfIX7IVUzwD+y4XYpzKn8ob1wCV/2Xx
         9QyZPUWRWmsrp7gynoNXy134I/PZTZkNl0gVo7TCj/COtlf9xZebPQAECT5ZsuXAp9rF
         OI+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qdzg5dRrrvZkFJYc/FsK4s6W7dGDoVHBhYE1aXDxorA=;
        b=cCakbhmk/TD30K5oSSFYraeM+tO+h6MfbI2J1o2b67TiAAtm0bwv+76lGwa7W13+Pc
         BMeNo57hifKiMuisDs1iD/CJIYRM2yS8wZkHPLE29VFOnuTbFbw+rA2qG/kULjKS0XdL
         4ngR8G4wDBe2L/cRayVbh5Groo8IZ86Jqga2k1mM61jdPaxDveHTGRjm6VxiuPRxTAQg
         YH7F2BvtjupZYN+mgLHnBqw1xH+NsiMnxg53UdEl73TRKjeSd+PBLyCsjUmSP2w4/BmL
         lDTftQK7+odmND4NLMkzrsanq0XkT/lgUxQ3TJ8TUpLnfLdGsIxE0gbrZ9XVAA1G5Iom
         QzQg==
X-Gm-Message-State: AJIora/MWeeSSDpqwMtu6jm/7KDsyRbVQC9vFTea0EgKvYEzB6K/pFMi
        BwFuju5ybbbcrgERPPGsNf9L7ICDyofRnEeMT3w7cQ==
X-Google-Smtp-Source: AGRyM1vlv37S8QMugy6reFEVuL5KY3LdRVcyMIlMrG9/Qf6nn3kZzbdgMtFBbOX04a4oGrmcowRCsLyN5CDDQ0IIoVA=
X-Received: by 2002:a7b:ce13:0:b0:3a3:102c:23d3 with SMTP id
 m19-20020a7bce13000000b003a3102c23d3mr1393303wmc.67.1658277736957; Tue, 19
 Jul 2022 17:42:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-17-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-17-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 17:42:04 -0700
Message-ID: <CAP-5=fXpFq=zEjQAp7YexBq1t0sQshiK2By8zeKEpfqG3_gjLA@mail.gmail.com>
Subject: Re: [PATCH 16/35] perf dlfilter: Add machine_pid and vcpu
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
> Add machine_pid and vcpu to struct perf_dlfilter_sample. The 'size' can be
> used to determine if the values are present, however machine_pid is zero if
> unused in any case. vcpu should be ignored if machine_pid is zero.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/Documentation/perf-dlfilter.txt | 22 ++++++++++++++++++++++
>  tools/perf/include/perf/perf_dlfilter.h    |  8 ++++++++
>  tools/perf/util/dlfilter.c                 |  2 ++
>  3 files changed, 32 insertions(+)
>
> diff --git a/tools/perf/Documentation/perf-dlfilter.txt b/tools/perf/Documentation/perf-dlfilter.txt
> index 594f5a5a0c9e..fb22e3b31dc5 100644
> --- a/tools/perf/Documentation/perf-dlfilter.txt
> +++ b/tools/perf/Documentation/perf-dlfilter.txt
> @@ -107,9 +107,31 @@ struct perf_dlfilter_sample {
>         __u64 raw_callchain_nr; /* Number of raw_callchain entries */
>         const __u64 *raw_callchain; /* Refer <linux/perf_event.h> */
>         const char *event;
> +       __s32 machine_pid;
> +       __s32 vcpu;
>  };
>  ----
>
> +Note: 'machine_pid' and 'vcpu' are not original members, but were added together later.
> +'size' can be used to determine their presence at run time.
> +PERF_DLFILTER_HAS_MACHINE_PID will be defined if they are present at compile time.
> +For example:
> +[source,c]
> +----
> +#include <perf/perf_dlfilter.h>
> +#include <stddef.h>
> +#include <stdbool.h>
> +
> +static inline bool have_machine_pid(const struct perf_dlfilter_sample *sample)
> +{
> +#ifdef PERF_DLFILTER_HAS_MACHINE_PID
> +       return sample->size >= offsetof(struct perf_dlfilter_sample, vcpu) + sizeof(sample->vcpu);
> +#else
> +       return false;
> +#endif
> +}
> +----
> +
>  The perf_dlfilter_fns structure
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> diff --git a/tools/perf/include/perf/perf_dlfilter.h b/tools/perf/include/perf/perf_dlfilter.h
> index 3eef03d661b4..a26e2f129f83 100644
> --- a/tools/perf/include/perf/perf_dlfilter.h
> +++ b/tools/perf/include/perf/perf_dlfilter.h
> @@ -9,6 +9,12 @@
>  #include <linux/perf_event.h>
>  #include <linux/types.h>
>
> +/*
> + * The following macro can be used to determine if this header defines
> + * perf_dlfilter_sample machine_pid and vcpu.
> + */
> +#define PERF_DLFILTER_HAS_MACHINE_PID
> +
>  /* Definitions for perf_dlfilter_sample flags */
>  enum {
>         PERF_DLFILTER_FLAG_BRANCH       = 1ULL << 0,
> @@ -62,6 +68,8 @@ struct perf_dlfilter_sample {
>         __u64 raw_callchain_nr; /* Number of raw_callchain entries */
>         const __u64 *raw_callchain; /* Refer <linux/perf_event.h> */
>         const char *event;
> +       __s32 machine_pid;
> +       __s32 vcpu;
>  };
>
>  /*
> diff --git a/tools/perf/util/dlfilter.c b/tools/perf/util/dlfilter.c
> index db964d5a52af..54e4d4495e00 100644
> --- a/tools/perf/util/dlfilter.c
> +++ b/tools/perf/util/dlfilter.c
> @@ -495,6 +495,8 @@ int dlfilter__do_filter_event(struct dlfilter *d,
>         ASSIGN(misc);
>         ASSIGN(raw_size);
>         ASSIGN(raw_data);
> +       ASSIGN(machine_pid);
> +       ASSIGN(vcpu);
>
>         if (sample->branch_stack) {
>                 d_sample.brstack_nr = sample->branch_stack->nr;
> --
> 2.25.1
>
