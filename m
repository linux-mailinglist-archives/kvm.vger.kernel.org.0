Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8646D8A46
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 00:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjDEWIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 18:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbjDEWIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 18:08:01 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB455269
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:07:59 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id cu12so24633445pfb.13
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 15:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680732479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6G4NsFlCDV5fs2a2Hk+HPn6BW+TSo8l8fhvL/n7IKto=;
        b=Co/XH8kheGMcW5639kFQflWIBdRbseeE5Rgi33B4NHAwkIuhJ8cRjGblOk3jTnpe3M
         r8NDGd4BbIPvGUCTtlIr1C3Zi3M3kVBDoSPBmqFnbVUgJEH+rMm0xic9kbB5F1PS469K
         v1mqbc0XbrOyTEZFxU0ygPvmf+3dHmAY6CsJ9O7wnH7swCU/AVkriErypZpzAdgN2JX5
         g7RiLqySQwykhvK9Yp436hJ6RVIMG7NxCvKb3YHlnhCMdin4lAC9yBtRjNUKm8bUitaS
         sSu9j6TkAiYHkxQxzNBHO0Xb9op6XALV5XasEjMG0VTfxTM7nkVUzYMSqHE97uOdWJz9
         t2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680732479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6G4NsFlCDV5fs2a2Hk+HPn6BW+TSo8l8fhvL/n7IKto=;
        b=R5lXCcDZ6jGQnA06tAUilN209/03Fk0mmyoryKrd7hTL4oSrqMQAvb6ZTo2rHhi5vy
         Z+1ymQveHF9fKXBV5xluOCMTdHEvektPW1aLKvWkiiNzSId+AZj0QmBf0AeWRH1MQ1ma
         1vLgIjFEIYF1obkqwpRyY+X1JCFanqgHrdXC4YLNGsCeBqN7/pqxmhR/IOeXuxi5Ulr2
         qnyvCq0qfU8ivoTswp2RxQQcrNI/DPvrPFnmP0ItgaHN/3Er09SJ7PnIjjLrxJNf092o
         7rPUGogYyEXdO5Jr9Hb0mYnFAhnxtua70sRgRtMscbsBIxvkpH7DvzK7wy7X5MOvJVOx
         hxOA==
X-Gm-Message-State: AAQBX9c9FpGM6GsqQS6QjFwwaERnqJsHObyRRZLzVWAglB9zMvFzACKI
        vtRl6qqVE4rL7QgoG+0XU5eqeFUL60T263rnE7o+fA==
X-Google-Smtp-Source: AKy350YWe0LQY4a1WtMtO9UBAtN8fCXxF/yrfEr5xXDYzw+Sj0JKwU0Q2JALgP82rgc6URVJ5DF6xJk/YwaCPJm10os=
X-Received: by 2002:a05:6a00:999:b0:625:cda5:c28c with SMTP id
 u25-20020a056a00099900b00625cda5c28cmr4345578pfg.6.1680732478867; Wed, 05 Apr
 2023 15:07:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230331014356.1033759-1-davidai@google.com> <20230331014356.1033759-6-davidai@google.com>
 <CAL_JsqJErVOZZ==i1HpMABfuVEDC+drboLTntMDB0sUC9ZdQ_Q@mail.gmail.com>
In-Reply-To: <CAL_JsqJErVOZZ==i1HpMABfuVEDC+drboLTntMDB0sUC9ZdQ_Q@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 5 Apr 2023 15:07:22 -0700
Message-ID: <CAGETcx_YhXqgyuWwH7BrMV4-z2LVEq5-X-FtPvmi-9tCrjVXVw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/6] dt-bindings: cpufreq: add bindings for virtual
 kvm cpufreq
To:     Rob Herring <robh+dt@kernel.org>
Cc:     David Dai <davidai@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        kernel-team@android.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 31, 2023 at 5:47=E2=80=AFAM Rob Herring <robh+dt@kernel.org> wr=
ote:
>
> On Thu, Mar 30, 2023 at 8:45=E2=80=AFPM David Dai <davidai@google.com> wr=
ote:
> >
> > Add devicetree bindings for a virtual kvm cpufreq driver.
> >
> > Co-developed-by: Saravana Kannan <saravanak@google.com>
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > Signed-off-by: David Dai <davidai@google.com>
> > ---
> >  .../bindings/cpufreq/cpufreq-virtual-kvm.yaml | 39 +++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-v=
irtual-kvm.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-=
kvm.yaml b/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.ya=
ml
> > new file mode 100644
> > index 000000000000..31e64558a7f1
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yam=
l
> > @@ -0,0 +1,39 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/cpufreq/cpufreq-virtual-kvm.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Virtual KVM CPUFreq
> > +
> > +maintainers:
> > +  - David Dai <davidai@google.com>
> > +
> > +description: |
> > +
> > +  KVM CPUFreq is a virtualized driver in guest kernels that sends util=
ization
> > +  of its vCPUs as a hint to the host. The host uses hint to schedule v=
CPU
> > +  threads and select CPU frequency. It enables accurate Per-Entity Loa=
d
> > +  Tracking for tasks running in the guest by querying host CPU frequen=
cy
> > +  unless a virtualized FIE exists(Like AMUs).
> > +
> > +properties:
> > +  compatible:
> > +    const: virtual,kvm-cpufreq
> > +
> > +required:
> > +  - compatible
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +
> > +      cpufreq {
> > +            compatible =3D "virtual,kvm-cpufreq";
> > +      };
>
> The same thing was tried on non-virtual h/w too. This is not a device
> so it doesn't go in DT. It is just an abuse of DT as a kernel driver
> instantiation mechanism.

Because it has no registers it's reading and writing, right? Yeah,
just went with this for now to make it easy for people to cherry pick
and test it. Maybe we shouldn't have added documentation and made this
look too official.

In the end, I'm expecting this will be a real MMIO device. Until we
move from RFC to PATCH, feel free to ignore this patch.

-Saravana
