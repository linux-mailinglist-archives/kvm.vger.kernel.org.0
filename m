Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EE457AB07
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbiGTAhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbiGTAhy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:37:54 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB80F4E63B
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:37:53 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id u5so887169wrm.4
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hgH1tvYEEyqwJwI8paE3cVCRS3k0UqWKM/aSARN/AlY=;
        b=IHQFVbJ2j/kFQMtawDxdtL48gU6cv5afOPcRO0W2ZDG5pvEKlX77+broRNagpeQ7La
         tEchT3E2a3zgqhdunNjx6KwUOvtdxW8bl0mjfc6+tOu7AVrxNqxjdEh9NtQhroPxNp3X
         173CTmYSLmwd7ZQNwaE7taU8Dj+FSIIn3iblCA0qS0tT3j9XER/csO/qwIcwD+YcpLqJ
         xv/XM84JfIBzAYedh7zwIdilNxafsYZBB+FEJ7+7nuw6BUWTbcfsXjtbzsD8qRpNrOmW
         ziNSJcC0KK+eZ4UPpHocVz7n+90suqMa6Cbovi1DzSEf26qGg7hz0ELGrC/eLL16/7YQ
         Xcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hgH1tvYEEyqwJwI8paE3cVCRS3k0UqWKM/aSARN/AlY=;
        b=XYhKIFwX51uwDumM0SzsxVzko54+1kHcqJ9blYXP0XSH6yoCDPhBMWc7UYVzHj5+LN
         7VQQ0i34MU4CmuJ1Zmham4zjn3n0JKxM9JHKxhAIPI1grhdVr2gHD2MXr+9stkV8FpCS
         6l5jD0a5PkiMZtj14yoe5fQqhLJ8Vbnlto8AW7k0brzucQaoSTkRq3zkteVLejU+O0a5
         H+AVZ6BH56xP8m06qR3SeI2mCVwkgOgNZrzNa8kfR4oWkPZSeeGHXXUHtIw5DLk3vgop
         f9yRg+aImIvFVivy5RrP3n8xfkWcupucFnEE0CWRGO5l3/jV+8EJd7rH9gmKEyRdVYmO
         f/NQ==
X-Gm-Message-State: AJIora/8Vl2Oa8sxdrVstPwF6egY/qhJzmO1c50CDZu3uIKAOEhvJN+D
        asnciyoMZ7Kx32OxwhFS1maAPIAVaDlsd9iKIrR1Sw==
X-Google-Smtp-Source: AGRyM1vBIk0Bn9MU6iede+X74KkkMjq/dsZs7yta7t6pINmUxXjkocvZi/cehVzzSEMz5IxQGmQxmEM1tG8297o+viA=
X-Received: by 2002:a5d:4d8e:0:b0:21d:68d4:56eb with SMTP id
 b14-20020a5d4d8e000000b0021d68d456ebmr27742751wru.40.1658277472130; Tue, 19
 Jul 2022 17:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-15-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-15-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 17:37:40 -0700
Message-ID: <CAP-5=fW2UaXJbDB7_YMWCQBEzJLVyBCOCx=tQv-0Ku-iyf-=+A@mail.gmail.com>
Subject: Re: [PATCH 14/35] perf tools: Use sample->machine_pid to find guest machine
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
> If machine_pid is set, use it to find the guest machine.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/session.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 91a091c35945..f3e9fa557bc9 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1418,7 +1418,9 @@ static struct machine *machines__find_for_cpumode(struct machines *machines,
>              (sample->cpumode == PERF_RECORD_MISC_GUEST_USER))) {
>                 u32 pid;
>
> -               if (event->header.type == PERF_RECORD_MMAP
> +               if (sample->machine_pid)
> +                       pid = sample->machine_pid;
> +               else if (event->header.type == PERF_RECORD_MMAP
>                     || event->header.type == PERF_RECORD_MMAP2)
>                         pid = event->mmap.pid;
>                 else
> --
> 2.25.1
>
