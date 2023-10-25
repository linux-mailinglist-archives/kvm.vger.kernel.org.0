Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFBA7D6C16
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 14:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344046AbjJYMim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 08:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbjJYMil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 08:38:41 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEDF8F
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 05:38:39 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-53f98cbcd76so9719a12.1
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 05:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698237518; x=1698842318; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3l3fK8JlnRDjMYiAMXlKadC5mulz1cY1IxH7egtavM=;
        b=bFFgKStkFAry370sQGddW0mcTkJIE6k4/z2ZOaQjKIalzxTfWLEQBF8NzLLL7tLYjd
         DxLWT0UsCFkeBoAK4UwuuvXSaIfdp/UaWfWqo0ZHiturCM8hr6hEbY3Jolis4YKqk9gM
         NHWLrT8xqV2JUY2ZFCfbifNbbYIk70e+4USi5NtubxezhIUhVaTPOaEG/2myBNhOGUVk
         w2q+hh02okgpaGzxKVl8k1KXXJ5+GskvoT4z8CLcEuo0kA1oteMmfJDPvyBTOScdmnPz
         AkLQzheupyhecLjaYf+J+GOinlCXoid/Cf7lGVERDODSr6nrwjHQZGPX7qfHTZ7pLyb6
         iUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698237518; x=1698842318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W3l3fK8JlnRDjMYiAMXlKadC5mulz1cY1IxH7egtavM=;
        b=QPPCgO+P2XuDs1YW/l/+nxSwWYwTtCI6GO3u7x51j/W5de+HnWivAcnyFcVoNT0QRc
         OGRmig2jmZue3+OmTP8xEvYowiSrG20aMHZdfECKr6z1SkkKxq5zTyA5b1/c5bdA3dFt
         XeBaAiPGDO+fA804OEG8HoJsAD8VAbiceT1zjeR3vgiZFZcqIW+P7nBQbZLhMc5zGV3/
         4yjhLx09cBZ1ua9VWWhOePxTKBPMNt8UTEgIFk1Scxv17nIwteHGqEQqD3nN7ee+sexS
         KvziUPrwkMZmMKLCJK9ltmif8hKRdYzJykPA455Btci35JdgLinz0EqhCBLitmJNftXa
         987Q==
X-Gm-Message-State: AOJu0Ywi2XfmYu+1ZjU3u5Z2gHW/1eaUhxA2YtIcmpPwIMcgX75Gz5kr
        yh+AAoWD09FzElynqewQ1C5fFLdj5UTfuo01EmMc8A==
X-Google-Smtp-Source: AGHT+IFV2kYyS0nXl907qHoBld9IgBOGa6z3I92wemf4cX+a+J09AbWj2FmewWIkgDqgwLMA1Zl/MsRimaHvir5XoA4=
X-Received: by 2002:a50:9556:0:b0:53f:c607:c87a with SMTP id
 v22-20020a509556000000b0053fc607c87amr73797eda.7.1698237517682; Wed, 25 Oct
 2023 05:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
 <20231024075748.1675382-5-dapeng1.mi@linux.intel.com> <CALMp9eSQyyihzEz+xpB0QCZ4=WqQ9TGiSwMYiFob0D_Z7OY7mg@mail.gmail.com>
 <305f1ee4-a8c3-48eb-9368-531329e5266e@linux.intel.com>
In-Reply-To: <305f1ee4-a8c3-48eb-9368-531329e5266e@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 25 Oct 2023 05:38:25 -0700
Message-ID: <CALMp9eT94bGZFr3sfPAssh4jJLnLe4jGosRieGVb4pK1E31b5Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests Patch 4/5] x86: pmu: Support validation for Intel
 PMU fixed counter 3
To:     "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Mingwei Zhang <mizhang@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 4:26=E2=80=AFAM Mi, Dapeng <dapeng1.mi@linux.intel.=
com> wrote:
>
>
> On 10/25/2023 3:05 AM, Jim Mattson wrote:
> > On Tue, Oct 24, 2023 at 12:51=E2=80=AFAM Dapeng Mi <dapeng1.mi@linux.in=
tel.com> wrote:
> >> Intel CPUs, like Sapphire Rapids, introduces a new fixed counter
> >> (fixed counter 3) to counter/sample topdown.slots event, but current
> >> code still doesn't cover this new fixed counter.
> >>
> >> So add code to validate this new fixed counter.
> > Can you explain how this "validates" anything?
>
>
> I may not describe the sentence clearly. This would validate the fixed
> counter 3 can count the slots event and get a valid count in a
> reasonable range. Thanks.

I thought the current vPMU implementation did not actually support
top-down slots. If it doesn't work, how can it be validated?

>
> >
> >> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >> ---
> >>   x86/pmu.c | 3 ++-
> >>   1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/x86/pmu.c b/x86/pmu.c
> >> index 1bebf493d4a4..41165e168d8e 100644
> >> --- a/x86/pmu.c
> >> +++ b/x86/pmu.c
> >> @@ -46,7 +46,8 @@ struct pmu_event {
> >>   }, fixed_events[] =3D {
> >>          {"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
> >>          {"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
> >> -       {"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
> >> +       {"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N},
> >> +       {"fixed 4", MSR_CORE_PERF_FIXED_CTR0 + 3, 1*N, 100*N}
> >>   };
> >>
> >>   char *buf;
> >> --
> >> 2.34.1
> >>
