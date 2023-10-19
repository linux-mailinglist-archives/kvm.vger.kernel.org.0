Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECC17D0315
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 22:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346466AbjJSUSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 16:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbjJSUSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 16:18:12 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8673612A
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 13:18:10 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c9c496c114so54195ad.0
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 13:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697746690; x=1698351490; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=re69crmlRFvuit7vgWY0A8Ey7T/2hSy2QGFgqasYm7Y=;
        b=F+OoxEFcOT5QqgbqZx7onn5lCI23oiSsImo13FnXFOPMHNpPVIgzTcXIM6lf/qg1Cc
         8BG7xFLIaLaidEJ5OvHqTvl9sVqFZb7NFs9f/QTSyDUnrFx4Bj+2DykKBHZ/R8wMc8VP
         c+JgeZNjqpR6n/0zIVLSkVFr5j2NDD/HnwZdtY30zcYsXZuVlqrlMIdq0vBSy1Qe7MtY
         ooI34gVB4mZtmW0d9rh3/GP0IoKLR32oas97O7QLt61QnCMfJ1L4CMcfy2Wt5T9Gu6LW
         1BWU2fjViYA8Uc3kz6Farov4tr9uBGkStXtxZ9jqUZQCoM1vn6qB/SUsQrsPnR1UtHfD
         d3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697746690; x=1698351490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=re69crmlRFvuit7vgWY0A8Ey7T/2hSy2QGFgqasYm7Y=;
        b=dKG8YwqFfHSWyD320EX7Yy5E0s29Ln6l9eil2gIWjBQ9d88/d4k/Lp2EQMF3fFbFjf
         QRzP5K5Fd5Vkc4njSa6ojXksu7TxeN2+ofQ6rwX+dm9c75phHp66zFMpS1cUAlxxG1NN
         YV9Aq3b85i1oBoQjzZFLvJRjsSa3sV1MNM8YL+Sc6o2oAQV1rMNYl1/0gsKd2bFdgrzs
         r8lLvMAEiBsde6KM1oFETEwBQNURyEbMRxbFsGkR+H2Fq0A82NtVh/X4zCk0ssj9lTJt
         psl4IragGw9CPEMgC7+9jtNo/wjRHtI2owpeOggygAbJhHgOQm2DVsOozbI/ytNQ3U0Z
         N/+w==
X-Gm-Message-State: AOJu0YzSpBv2MPkemQ6aaYdHs283eUeMBiw2ZVKriuY9/WLpZmL+AZwX
        1ZI5CNagpMbTLkQX6aumbZZr7O+0cVYgJa33CmVkWQ==
X-Google-Smtp-Source: AGHT+IHBuZ18aPFC5tbiN39OPHUSbaheZLj3eZFoc72z1OMOJqTRu9TrdQCDkRczySNC2f1yEKxOHu95/xwWlWnDbA8=
X-Received: by 2002:a17:903:40cb:b0:1b9:d96c:bca7 with SMTP id
 t11-20020a17090340cb00b001b9d96cbca7mr42965pld.25.1697746689771; Thu, 19 Oct
 2023 13:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com> <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
 <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com> <CAJHc60xc1dM_d4W+hOOnM5+DceF45htTfrbmdv=Q4vPf8T04Ow@mail.gmail.com>
 <CAJHc60yr5U+sxSAaZipei_4TNaU0_EAWKLG8cr+5v_Z1WYRMuw@mail.gmail.com>
 <CAJHc60yQSzsuTJLcyzs5vffgRzR5i0vKQwLnhavAon6hoSkb+A@mail.gmail.com> <ZTF-FlDtvha-6Pw1@linux.dev>
In-Reply-To: <ZTF-FlDtvha-6Pw1@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 19 Oct 2023 13:17:58 -0700
Message-ID: <CAJHc60yNfGo8A+RLozgEsDO=75SQAB5dswAWgFzc3OS7_3FfKQ@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Eric Auger <eauger@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

On Thu, Oct 19, 2023 at 12:06=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Raghu,
>
> Can you please make sure you include leading and trailing whitespace for
> your inline replies? The message gets extremely dense and is difficult
> to read.
>
> Also -- delete any unrelated context from your replies. If there's a
> localized conversation about a particular detail there's no reason to
> keep the entire thread in the body.
>
Sorry about that. I'll try to keep it clean.

> On Thu, Oct 19, 2023 at 11:46:22AM -0700, Raghavendra Rao Ananta wrote:
> > On Wed, Oct 18, 2023 at 2:16=E2=80=AFPM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > > I had a brief discussion about this with Oliver, and it looks like we
> > > might need a couple of additional changes for these register accesses=
:
> > > - For the userspace accesses, we have to implement explicit get_user
> > > and set_user callbacks that to filter out the unimplemented counters
> > > using kvm_pmu_valid_counter_mask().
> > Re-thinking the first case: Since these registers go through a reset
> > (reset_pmu_reg()) during initialization, where the valid counter mask
> > is applied, and since we are sanitizing the registers with the mask
> > before running the guest (below case), will implementing the
> > {get,set}_user() add any value, apart from just keeping userspace in
> > sync with every update of PMCR.N?
>
> KVM's sysreg emulation (as seen from userspace) fails to uphold the RES0
> bits of these registers. That's a bug.
>
Got it. Thanks for the confirmation. I'll implement these as originally pla=
nned.

Thank you.
Raghavendra

> --
> Thanks,
> Oliver
