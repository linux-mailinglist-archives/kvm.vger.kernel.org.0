Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84837C98F1
	for <lists+kvm@lfdr.de>; Sun, 15 Oct 2023 14:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjJOMZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Oct 2023 08:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjJOMZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Oct 2023 08:25:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D66DA
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 05:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697372706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gOp94H6OSlV2qKKGzaRSRBTczHZK7QO4ptY+js4GFCE=;
        b=Dx6D0eGGkSqbKQpyQl3wzrs5LHXvFkJuuveQ0y32HmtdlfL7Jc3sfvHrErV6uHI9eSbwex
        xXemHYEEgcFX0xRuQTiaP4RO4hnwfu/iX/a7qd9Sts9F8x6ZRWUHERd8KWxQo8T/uf42F2
        8mkOHWo1+P3f+fo/U4bXh0RoWhF31s0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-JmkzKS5OOges_MY2_5RyJA-1; Sun, 15 Oct 2023 08:24:49 -0400
X-MC-Unique: JmkzKS5OOges_MY2_5RyJA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9b95fa56bd5so247647166b.0
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 05:24:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697372689; x=1697977489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gOp94H6OSlV2qKKGzaRSRBTczHZK7QO4ptY+js4GFCE=;
        b=N09ruQGjzorYzx8GtfjFV1+eOFowo6MXERqhWa/+59CyihLywGODzrCRgyxqjtueOP
         +XxfVeZLCG3Xql6oMh5n8lDSkYF46nnHqnw7Sv8hF7xnTp27wEtb5JECA5gRQmBU00S8
         SGFED4cyA2qMs1l7LOmEvaDBOfaUSHRv6kgyvcilYFwDbW10/TRl8A4xGcS4xIBnNDGe
         3WC5pKIRmIL3UsgxthRRlroADLjgpHYUnKx9JJ5byP+7QUuRZs3xH6APjyKqJ0jjHzN8
         sTovqOi6WGQMWrxQCkpLuEokrUOi6kQ8aP/ocoD5EVJOQqNRRWCmwyzUqlTgbj+IG21l
         0q1A==
X-Gm-Message-State: AOJu0Yz5HmJeaYmcg7N5DgxVjAekaT6Al+hwmnRACqVP3cq+6DyroHZB
        HL3aIQD60RGfG1IIEx0AOpctSuGbRLndrM4vZicUO/wpz5yRfXrmTrS78zg3LpUrhOiwDMMKrvI
        F+y3oggaL1LmAmxbWW9aYaFnf8NDd
X-Received: by 2002:a17:907:7f90:b0:9c2:2d0a:320c with SMTP id qk16-20020a1709077f9000b009c22d0a320cmr1218030ejc.46.1697372688857;
        Sun, 15 Oct 2023 05:24:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxypXeWL0pcRwMDbvkaI/MwiX0K5GTxq4IH0RGAc4sH2lRlCBzXr83VcMmheM+B/NhuK67KB5TOskIK7IN110=
X-Received: by 2002:a17:907:7f90:b0:9c2:2d0a:320c with SMTP id
 qk16-20020a1709077f9000b009c22d0a320cmr1218016ejc.46.1697372688516; Sun, 15
 Oct 2023 05:24:48 -0700 (PDT)
MIME-Version: 1.0
References: <20231013234808.1115781-1-seanjc@google.com>
In-Reply-To: <20231013234808.1115781-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sun, 15 Oct 2023 14:24:35 +0200
Message-ID: <CABgObfY_p4ysKh1kya8GxHSwF4gFx25vavUJOWMZES=Y-8SvcA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: PMU fixes for 6.6
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 14, 2023 at 1:48=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please pull three PMU fixes for 6.6.  These aren't super urgent and have =
all
> existed from some time, i.e. don't absolutely need to go into 6.6, but I =
also
> don't see a good reason to hold them back (they're all tagged for stable,=
 so
> it's kind of a moot point).

Pulled, thanks.

Paolo

> The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6=
d3:
>
>   Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux=
 into HEAD (2023-09-23 05:35:55 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-pmu-6.6-fixes
>
> for you to fetch changes up to 73554b29bd70546c1a9efc9c160641ef1b849358:
>
>   KVM: x86/pmu: Synthesize at most one PMI per VM-exit (2023-09-25 14:42:=
52 -0700)
>
> ----------------------------------------------------------------
> KVM x86/pmu fixes for 6.6:
>
>  - Truncate writes to PMU counters to the counter's width to avoid spurio=
us
>    overflows when emulating counter events in software.
>
>  - Set the LVTPC entry mask bit when handling a PMI (to match Intel-defin=
ed
>    architectural behavior).
>
>  - Treat KVM_REQ_PMI as a wake event instead of queueing host IRQ work to
>    kick the guest out of emulated halt.
>
> ----------------------------------------------------------------
> Jim Mattson (2):
>       KVM: x86: Mask LVTPC when handling a PMI
>       KVM: x86/pmu: Synthesize at most one PMI per VM-exit
>
> Roman Kagan (1):
>       KVM: x86/pmu: Truncate counter value to allowed width on write
>
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/lapic.c            |  8 ++++++--
>  arch/x86/kvm/pmu.c              | 27 +--------------------------
>  arch/x86/kvm/pmu.h              |  6 ++++++
>  arch/x86/kvm/svm/pmu.c          |  2 +-
>  arch/x86/kvm/vmx/pmu_intel.c    |  4 ++--
>  arch/x86/kvm/x86.c              |  3 +++
>  7 files changed, 19 insertions(+), 32 deletions(-)
>

