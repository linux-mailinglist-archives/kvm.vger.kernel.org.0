Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946247CB31F
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 21:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjJPTFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 15:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjJPTFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 15:05:32 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC190AB
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:05:28 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1c9b70b9671so32455ad.1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697483128; x=1698087928; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1VlSEnGZgno+VCZ2CMhUaRzE+QVLRzzBhFEmOew2zU=;
        b=jlDvdCTnJn/IfWByCKyn9hTTeKWzQQo7e7i5hSrwROUKyJ4kvba5VcRhSrhbDbIPdv
         t8F/PRha/FZIENUWauQOrs1j5wigO46AczN2WbtK37Bz/g7AjXJxMJ5sv0fFn0TjIi3q
         vtI5NFvmjH5QA1l1sT0PS8KJSGKydPoEkR+Lrs5TVlhICMMocYIPruyeTQV8WnyjGK0P
         9woDrDZRgStRnN9PxetS373oWcS2fDeQqjG/S2mSckNQUnSp50peh2KCIf+PqhKYUifH
         3vSB96yjQNUnGwkKv0PTKyAdulFZbk+Gh1PcL1YzckQ5xsYuLLOazyGpXKzRYZchUdUG
         yPgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697483128; x=1698087928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1VlSEnGZgno+VCZ2CMhUaRzE+QVLRzzBhFEmOew2zU=;
        b=j1zLLUgI8nE+551qWtbuxyeKuPcznUQsdMK9ZnVeI4puuQ54xZ553vBamySViyywWe
         9yoId/lNV9XhUhxLYNftr5lQX4om9nYSeTb9ahvHLVArPS7Kbl0R4Y5ptEV+gw2PHrIJ
         x3XYpPFRjTIgcbgL5QmVKwYIyd5lubWMQi7S95D1PDSCNGNc4FesSWOAG7t8HCHH/n4y
         kW/DoXzdwh1yfL4kwyPBPxzMUaS/BRWRFrs1m/n8BLx/yATsZuQgJVhncbErIAGPaek9
         dpQbT7aeeQ04vkLhp90S9+uiXgLvMm6YB+qAFB0Ws7XrQqabzut1KB7LelalRm0a4Ic3
         0p0w==
X-Gm-Message-State: AOJu0Yz9YgzZi6+NllDZgU84LAqOaPAXmHud2Vzp3VPli1WvKuZAFmHa
        kCrzeWok377qYV1EPxk452GWRGOSXCoUSu8GKpEfkA==
X-Google-Smtp-Source: AGHT+IGzqX6lfM4KPQZaOFHNso4U2b11m5YXW3DWX1mnMS9JBJdU3dcZ2THIjxAivTgEAatvr6FAe6c5mnJrC2Caufk=
X-Received: by 2002:a17:903:1c1:b0:1c9:af6a:6d0d with SMTP id
 e1-20020a17090301c100b001c9af6a6d0dmr25965plh.9.1697483128045; Mon, 16 Oct
 2023 12:05:28 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-11-rananta@google.com>
 <44608d30-c97a-c725-e8b2-0c5a81440869@redhat.com> <65b8bbdb-2187-3c85-0e5d-24befcf01333@redhat.com>
 <CAJHc60zPc6eM+t7pOM19aKbf_9cMvj_LnPnG1EO35=EP0jG+Tg@mail.gmail.com> <ZS2HTdhFO2aywPpe@linux.dev>
In-Reply-To: <ZS2HTdhFO2aywPpe@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 16 Oct 2023 12:05:16 -0700
Message-ID: <CAJHc60xFwcDu6e6GTY3WYowBxnbkCWU-EgwEOVGd4Qu5F_h10A@mail.gmail.com>
Subject: Re: [PATCH v7 10/12] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Sebastian Ott <sebott@redhat.com>, Marc Zyngier <maz@kernel.org>,
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

On Mon, Oct 16, 2023 at 11:56=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Fri, Oct 13, 2023 at 02:05:29PM -0700, Raghavendra Rao Ananta wrote:
> > Oliver,
> >
> > Aren't the selftest patches from the 'Enable writable ID regs' series
> > [1] merged into kvmarm/next? Looking at the log, I couldn't find them
> > and the last patch that went from the series was [2]. Am I missing
> > something?
> >
> > Thank you.
> > Raghavendra
> >
> > [1]: https://lore.kernel.org/all/169644154288.3677537.15121340860793882=
283.b4-ty@linux.dev/
> > [2]: https://lore.kernel.org/all/20231003230408.3405722-11-oliver.upton=
@linux.dev/
>
> This is intentional, updating the tools headers as it was done in the
> original series broke the perftool build. I backed out the selftest
> patches, but took the rest of the kernel changes into kvmarm/next so
> they could soak while we sort out the selftests mess. Hopefully we can
> get the fix reviewed in time [*]...
>
> [*] https://lore.kernel.org/kvmarm/20231011195740.3349631-1-oliver.upton@=
linux.dev/
>
> --
Ah, I see. In that case, since it impacts this series, do you want me
to rebase my series on top of your selftests series for v8?

Thank you.
Raghavendra
> Thanks,
> Oliver
