Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714966B6E05
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 04:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCMDgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 23:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjCMDf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 23:35:57 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB86D31E2C
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 20:35:56 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id y2so10606363pjg.3
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 20:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678678556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XIVDKNgNNnu7iJidCAmkeAHFjqwKfwXTuL13VCoOInQ=;
        b=OHPdAgmcGU4QMibOut+sWb1Mt3yexKZ+FGNJSMuSuf/Z8Jt1h6UtKkMXBxGdTHctL9
         oVIWxgsPVk524AJEpmL1bOqTWCbKlNet6yr5mqfEkSaxAXZoV3Ps4A46yvo0jz7Rdyem
         x6eXadJTQLU8zjhJ53dciyxBu5LaG0xyzxeooK4zRv0pgYgzDCkYGdcv06QBYzD9e0f5
         cw7WocKdrsfrBCslixZvrJBQ4Arbn6zpYsP/FFs6i6QCuQ1TY/0p/MoD0X5LNbYXI8j7
         UK0NO1+vC6kiU7BC3pdxWzjpGfxsEyH6vK35nGbNtG4pr0xFq1cFRPrNoJAo5q8mM683
         YOKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678678556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XIVDKNgNNnu7iJidCAmkeAHFjqwKfwXTuL13VCoOInQ=;
        b=E0LcL2US9QZiUvGkxyVT2yxE4lwa6k8uWSJOQZqE9kpjK0VXiCkn+rdLjsiMaoKLpQ
         cLN1MN6i6cX70UBZuUCX32R4bqWmwoWbuv189dbOjgdCPqXRb/PjAvZ6sFgsgUm5iaL0
         g9zUl90jCUzUNi6Y0lxiE+qGZMONuIdl+jAVdkntBvV5BB2XWvtZ8vJGoBv6by5flPiv
         9ns98qQpPuvS1TGp0t0wBTPpl0wilG/j7Aw8yME6yAqAyXtQvDXNfRhMsJ4XJx4QiUwQ
         oOwHlthEbKa6tpbWpWpXgrjHFqt0Bazi/YCfYZq8MKHfk9LFNFd7hsL1uDYeCtU/NsAi
         eZ9A==
X-Gm-Message-State: AO0yUKVOA3Z9LGDYb7S+Er2Q/BYvFuZkjZfSut3mgTn6W3wPdCzZKwc9
        vfc16Aas4m5vOTvh0nTt01LokeubJ4gXqeoVgxE/Vg==
X-Google-Smtp-Source: AK7set9ytJ+OvrhbrLetsnIDo/dfpOg8EONiPahVU2UwpRmMYqsdRD/mpKfb4P9rmj1BRrcC6/ounfQ9rh5k4KZbWJo=
X-Received: by 2002:a17:90a:ba03:b0:230:b842:143e with SMTP id
 s3-20020a17090aba0300b00230b842143emr11836800pjr.6.1678678556258; Sun, 12 Mar
 2023 20:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230302055033.3081456-1-reijiw@google.com> <87wn3m3ta0.wl-maz@kernel.org>
In-Reply-To: <87wn3m3ta0.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 12 Mar 2023 20:35:39 -0700
Message-ID: <CAAeT=FzTSboSVB=VJ_mkmkOmMtftjzOaQQfAOwmnUuomOwfiYw@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: arm64: PMU: Preserve vPMC registers properly on migration
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>
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

Hi Marc,

On Sun, Mar 12, 2023 at 8:04=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 02 Mar 2023 05:50:31 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > The series fixes two problems in preserving vPMU counter (vPMC)
> > registers (PMCCNTR_EL0/PMEVCNTR<n>_EL0) during migration.
> >
> > One of the problems is that KVM may not return the current values
> > of the vPMC registers for KVM_GET_ONE_REG.
> >
> > The other one might cause KVM to reset the vPMC registers on the
> > first KVM_RUN on the destination. This is because userspace might
> > save PMCR_EL0 with PMCR_EL0.{C,P} bits set on the source, and
> > restore it on the destination.
>
> This looks good to me. Can you please add the relevant Fixes: tags and
> a Cc: to stable? With that, that'd be a candidate for -rc3, I think.

Thank you for the review!

I posted v2, which addressed the comments above, and the comment
for the patch-2 (remove the line break).

Thank you,
Reiji



>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
