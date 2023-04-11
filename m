Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBFC6DDB5C
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 14:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjDKM7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 08:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjDKM7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 08:59:19 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72AF44B8
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 05:59:09 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id bg24so5324015oib.5
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 05:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681217949; x=1683809949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oxCP1A0+vJC6rGQA6qVogYfyo3XWYkt2ipQ4u9C+9Vo=;
        b=gghZTbYWLEKhTXXH+mFPU2gDRnLmMwf5Fl9ypn03IS+Y+H8057BjEVr5ykex3eyuFO
         swk6sjSdyBXaZhedLClbY7ok86tiHw0zr4LkjOhr3QIMY36ua4MQ5i13dkHKt7uioI3w
         2Vxm3ZuJi9lVAa5L8jWkLuLTi2AZ1HbyGJhC7Ii0swcGz/5eSWJudCF8F88qtvqzx2oH
         fKJXL1Bvk3e4BSoVl4EeR98gqE5muWY4U1l7et4NehOeTy3J81V+uxJcgB+co+ZsGeFk
         5Y8QlvbbUZIFcJX8UQgixmgsO6i4D/0NxcL/SThL8sx9aWFnJ1NRZUB4DKhT30VtDUt/
         XQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681217949; x=1683809949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oxCP1A0+vJC6rGQA6qVogYfyo3XWYkt2ipQ4u9C+9Vo=;
        b=uHMU/LukxF9YyuwRaEvLVvKGktP0iCADfVmGKzmmvwZ3S0tNKBoGGAIKHvlIQ35uL+
         bWIFV2bcHUSx0ZTgnKy2plV6Lj+6JB4g6BecFgxJRKUac/hRLtphINUH71SuNhnh3sF4
         gPF2jkyoBTgq8gipf0um2LN/LB3rp8ET40/NSYwyONhzFRQ+U3a7fF0dXk/B1BSaymER
         VXUq3Sn42ynE/uHu06HT4sXpB7J5fCVLn90W3VvLWoAHkmqtIgyEW0TjD6pU2g8pgzST
         T0rTPe2RwN+Sj5asijUvjovgxjrWvHQpwQGXHw0wbfriuGGZyYosj+dc/Ab3Biy2Thaq
         3oNw==
X-Gm-Message-State: AAQBX9dqnI8d2QOqybP2teiyAk4mDRvk9f1A4OZaY7q92i3FKgsDi5y8
        oxun8bwScKk0prGnvZl99K+Jq8fkz07To6rWVkWrrA==
X-Google-Smtp-Source: AKy350bcNVrc7qnqc359b3WNy8WohYCXK5agomPwbAjVaUs8VyzzhZ7/AQ2DQDh76keg1NybpWlZjvAVc/7cE92qJZA=
X-Received: by 2002:a05:6808:3307:b0:383:fef9:6cac with SMTP id
 ca7-20020a056808330700b00383fef96cacmr3751840oib.9.1681217948915; Tue, 11 Apr
 2023 05:59:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230410105056.60973-1-likexu@tencent.com> <20230410105056.60973-6-likexu@tencent.com>
 <CALMp9eTLvJ6GW1mfgjO7CL7tW-79asykyz9=Fb=FfT74VRkDVA@mail.gmail.com> <9a7d5814-9eb1-d7af-7968-a6e3ebb90248@gmail.com>
In-Reply-To: <9a7d5814-9eb1-d7af-7968-a6e3ebb90248@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 11 Apr 2023 05:58:57 -0700
Message-ID: <CALMp9eR6DwY0EjAb1hcV9XGWQizN6R0dXtLaC4NXDgtCqv5cTA@mail.gmail.com>
Subject: Re: [PATCH V5 05/10] KVM: x86/pmu: Disable vPMU if the minimum num of
 counters isn't met
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Mon, Apr 10, 2023 at 11:17=E2=80=AFPM Like Xu <like.xu.linux@gmail.com> =
wrote:
>
> On 11/4/2023 1:36 pm, Jim Mattson wrote:
> > On Mon, Apr 10, 2023 at 3:51=E2=80=AFAM Like Xu <like.xu.linux@gmail.co=
m> wrote:
> >>
> >> From: Like Xu <likexu@tencent.com>
> >>
> >> Disable PMU support when running on AMD and perf reports fewer than fo=
ur
> >> general purpose counters. All AMD PMUs must define at least four count=
ers
> >> due to AMD's legacy architecture hardcoding the number of counters
> >> without providing a way to enumerate the number of counters to softwar=
e,
> >> e.g. from AMD's APM:
> >>
> >>   The legacy architecture defines four performance counters (PerfCtrn)
> >>   and corresponding event-select registers (PerfEvtSeln).
> >>
> >> Virtualizing fewer than four counters can lead to guest instability as
> >> software expects four counters to be available.
> >
> > I'm confused. Isn't zero less than four?
>
> As I understand it, you are saying that virtualization of zero counter is=
 also
> reasonable.
> If so, the above statement could be refined as:
>
>         Virtualizing fewer than four counters when vPMU is enabled may le=
ad to guest
> instability
>         as software expects at least four counters to be available, thus =
the vPMU is
> disabled if the
>         minimum number of KVM supported counters is not reached during in=
itialization.
>
> Jim, does this help you or could you explain more about your confusion ?

You say that "fewer than four counters can lead to guest instability
as software expects four counters to be available." Your solution is
to disable the PMU, which leaves zero counters available. Zero is less
than four. Hence, by your claim, disabling the PMU can lead to guest
instability. I don't see how this is an improvement over one, two, or
three counters.

> >
> >> Suggested-by: Sean Christopherson <seanjc@google.com>
> >> Signed-off-by: Like Xu <likexu@tencent.com>
> >> ---
> >>   arch/x86/kvm/pmu.h | 3 +++
> >>   1 file changed, 3 insertions(+)
> >>
> >> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> >> index dd7c7d4ffe3b..002b527360f4 100644
> >> --- a/arch/x86/kvm/pmu.h
> >> +++ b/arch/x86/kvm/pmu.h
> >> @@ -182,6 +182,9 @@ static inline void kvm_init_pmu_capability(const s=
truct kvm_pmu_ops *pmu_ops)
> >>                          enable_pmu =3D false;
> >>          }
> >>
> >> +       if (!is_intel && kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNT=
ERS)
> >> +               enable_pmu =3D false;
> >> +
> >>          if (!enable_pmu) {
> >>                  memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
> >>                  return;
> >> --
> >> 2.40.0
> >>
