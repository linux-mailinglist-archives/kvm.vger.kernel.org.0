Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301E06E0244
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 01:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjDLXG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 19:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjDLXGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 19:06:54 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFE34234
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 16:06:53 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3e0965f70ecso379461cf.0
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 16:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681340813; x=1683932813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dwVaL64KESQ73tFqJhAn+OVsHN/maU89TV8jjV38IOc=;
        b=IGiPbu+KoqInvTbngvjlV9BcbaEZGiza8BATEXX9C7Hq/shdvgFCJnmLIS8dJbTUpL
         +wWq1nXNOWIW3v6JGCmtp49pUMDYcdmZ8lOV4lOeWZI8S7PwRhFKGSSZcUQ28R4nzK2t
         o8ICmCv4pcMevcPQK90x7hBVcffin/c6djXPvnB/oUiu6L7s/VGsF9I9d5Dn4QC51LIW
         kOwWK9djSWLBeCW8LI+vKYrLzdkZMbUkUOQon66RbDE64eRTEHxy+Gz/mEIrusC47aES
         Uc7+AhnGVFf/UQX1I5muj4ojIkxKxQjK51QFQ4IrXX2fWMDWaEafb2T/umoJ7LpqHf+8
         z1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681340813; x=1683932813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dwVaL64KESQ73tFqJhAn+OVsHN/maU89TV8jjV38IOc=;
        b=a7hJ1QJZFI/u3EcEZ9PF+BClvlL+3BBgvd0wQGKXVQCk6JMM1iqc4A9TOwMilgDVJF
         tENQwqw58/V8uNA3xLcz5+RRI4eMsp/qNsTMag/z8BOGg4O5QVkD+HxdZr7ulWc7RqxJ
         kV+uZMOzHhJsww2G772uGkQOhkcp7nNUwomzZTQ5f7lhxOROar1viU3wwxWB3vwHkkh2
         Ae721TlWXtLhbXsTsT1nst2jytOKvu4HD+5Zlg2/8unWOGCQ+Z544cBiRljM9QiJGEYf
         2RhLhCgkjSUYGakvIbB1bAhs3bKR+oYf4gFa3TsLUm2ZvtwtqkDlkefYDLOCFU3u+Ook
         03Fw==
X-Gm-Message-State: AAQBX9esngn+ha2VPQug4OPuveXUqoh63NRwJEpdH2B9WUz6xypEXIJj
        jg+sFY723qhGTuzwjfiL3Q2BVDTjdgCzdt7hdiUB1A==
X-Google-Smtp-Source: AKy350a6p56WmQlnP1QDEIPq7+qhGqPRT+GSi5RQdXJJxiJLQc8eNuwp0GMssor0wmhrBgDP9dtWCpGt5bhblPcG/1w=
X-Received: by 2002:ac8:4e44:0:b0:3d6:5f1b:1e7c with SMTP id
 e4-20020ac84e44000000b003d65f1b1e7cmr1093287qtw.9.1681340812792; Wed, 12 Apr
 2023 16:06:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230407233254.957013-1-seanjc@google.com>
In-Reply-To: <20230407233254.957013-1-seanjc@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 12 Apr 2023 23:06:41 +0000
Message-ID: <CAAAPnDFruYyoT=jT7+H=QXry0DHFyYCTO2cX=Nr=L4JH8g-Y4Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] KVM: selftests: Add "instructions required" testcase
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Apr 7, 2023 at 11:33=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> This is the selftests portion of Aaron's series[*] to fix incorrect
> "instructions required" counting.  The big change from v3 is to use a

nit: here and in the subject, s/required/retired/.

> common struct to copy counter values to/from the guest instead of smushin=
g
> the values into a single 64-bit value.
>
> [*] https://lkml.kernel.org/r/20230307141400.1486314-1-aaronlewis%40googl=
e.com
>
> Aaron Lewis (4):
>   KVM: selftests: Add a common helper for the PMU event filter guest
>     code
>   KVM: selftests: Add helpers for PMC asserts in PMU event filter test
>   KVM: selftests: Print detailed info in PMU event filter asserts
>   KVM: selftests: Test the PMU event "Instructions retired"
>
> Sean Christopherson (2):
>   KVM: selftests: Use error codes to signal errors in PMU event filter
>     test
>   KVM: selftests: Copy full counter values from guest in PMU event
>     filter test
>
>  .../kvm/x86_64/pmu_event_filter_test.c        | 252 ++++++++++--------
>  1 file changed, 140 insertions(+), 112 deletions(-)
>
>
> base-commit: b821bf96cf3bed0c1c8d34659299a3a1dc47218d
> --
> 2.40.0.577.gac1e443424-goog
>

Fingers crossed that marking this as "plain text" works this time.

Reviewed by: Aaron Lewis <aaronlewis@google.com>
