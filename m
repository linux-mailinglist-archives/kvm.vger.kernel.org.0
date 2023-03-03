Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885286A9B66
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 17:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCCQLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 11:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjCCQLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 11:11:51 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B5D5ADE4
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 08:11:50 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id cp12so1881764pfb.5
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 08:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677859909;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HMDvKOzUvhD+gnJmWPSHF6kgZbOBXLJVP7lXCp14qwU=;
        b=Il2WGuqZOvKej54xkarCiPLQ2EELr6aRPp00wr6KdN50chC84f795TR814t/voFvCe
         q1jeLDt8yANN28GLd3/oyFco67yrHv+0KpP9WqZ6qIuP9hHfwJUfzZOTxFAPJpFf1Ycf
         fZgMk9a7qAfLuvJ4WKly91QcuYMrlHYNSHqbMa94a4zTv+y9lSemMOptQOrF0JA69p8s
         x1incH/MSVEjftAQKa51MblWVGvYjKcZnC2Up4inZwtN6SXlE/vXRuR2Zb+x1bBKd0Al
         OS+N9ZBUBautK6RcMMyhjO/9ZSjkisVrlTo49OTJer3IQH7PY4rE0rk1mFBZs++oCKph
         pMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677859909;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HMDvKOzUvhD+gnJmWPSHF6kgZbOBXLJVP7lXCp14qwU=;
        b=bpOnVtIT07Xvc0c4UtU/uf+2oxkrSmdNX1knG8J9X2wEsD85Y7pyDBrd52ZArh1glQ
         +3nEVirqf5hwCAc05CFb5bcEZIZI1neFbV2WlHaGEvasKpa+oulLY7fx+gkm362rCKUr
         /p+Nop5fLMg2Wvxhzff7D8saIabFGv+8fs8tWKjRS7VGMb7J4zbBhDd5tVwSc+QCr3uQ
         75e8ziKXHtKAifF/wQf6sQ7TPgrA5DMculrB/O0MZlYjQM5/e8S+x8Ya75Z+i+u71Rh5
         0quY43f0/ZOUPSVw4YYNnofMqNHwGbMHhs8fzhpv79gXpLrJeAesYtk5fuHsZwYee2oi
         6skQ==
X-Gm-Message-State: AO0yUKVdH1o4c1vUbVIlHcbwpmWtJEvU0LP3fGVDYvPXNY239M6a05IO
        IErJWCAGMzdJ7b4DnfFVGtTsjliAx3CCuIQDBxgeyg==
X-Google-Smtp-Source: AK7set9qcSI9yW/sVjhnxw9EPtc5quH/RzknW0I8OjqjyUcZliJzkG7QEvJ4CBxAiaAvNpjENTeDGabUzjZ9qj0ybHo=
X-Received: by 2002:a63:5508:0:b0:502:fd71:d58c with SMTP id
 j8-20020a635508000000b00502fd71d58cmr736959pgb.9.1677859909483; Fri, 03 Mar
 2023 08:11:49 -0800 (PST)
MIME-Version: 1.0
References: <20230228150216.77912-1-cohuck@redhat.com> <20230228150216.77912-2-cohuck@redhat.com>
In-Reply-To: <20230228150216.77912-2-cohuck@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 3 Mar 2023 16:11:38 +0000
Message-ID: <CAFEAcA8FD75dXcPEyZOfF7cxbgynWTdDOJV7K7fYfAbRsPDdmg@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] arm/kvm: add support for MTE
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Feb 2023 at 15:02, Cornelia Huck <cohuck@redhat.com> wrote:
>
> Introduce a new cpu feature flag to control MTE support. To preserve
> backwards compatibility for tcg, MTE will continue to be enabled as
> long as tag memory has been provided.
>
> If MTE has been enabled, we need to disable migration, as we do not
> yet have a way to migrate the tags as well. Therefore, MTE will stay
> off with KVM unless requested explicitly.
>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst |  21 ++++++
>  hw/arm/virt.c                    |   2 +-
>  target/arm/cpu.c                 |  18 ++---
>  target/arm/cpu.h                 |   1 +
>  target/arm/cpu64.c               | 110 +++++++++++++++++++++++++++++++
>  target/arm/internals.h           |   1 +
>  target/arm/kvm.c                 |  29 ++++++++
>  target/arm/kvm64.c               |   5 ++
>  target/arm/kvm_arm.h             |  19 ++++++
>  target/arm/monitor.c             |   1 +
>  10 files changed, 194 insertions(+), 13 deletions(-)



> +static inline bool arm_machine_has_tag_memory(void)
> +{
> +#ifndef CONFIG_USER_ONLY
> +    Object *obj = object_dynamic_cast(qdev_get_machine(), TYPE_VIRT_MACHINE);
> +
> +    /* so far, only the virt machine has support for tag memory */
> +    if (obj) {
> +        VirtMachineState *vms = VIRT_MACHINE(obj);
> +
> +        return vms->mte;
> +    }

Code inside target/arm shouldn't be fishing around inside
the details of the board model like this. For TCG I think that
at this point (i.e. at realize) you should be able to tell if
the board has set up tag memory, because it will have set
cpu->tag_memory to non-NULL.

thanks
-- PMM
