Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BA17A5014
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjIRQ7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjIRQ6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:58:51 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2649182
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:58:43 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-34fa117f92bso2395ab.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695056323; x=1695661123; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=knRagvKuCPzhCIYhCOjRCh44VjecKJtrl8eHwZBErg4=;
        b=0ru6f5T3Isq+RB3EWYvBlX+hnugBdW6UtTSaogmPXLEWWqijFNwxdzyVkg+uO4EN0m
         8K/IkdJ8wvDl8vxhpbB3gW6YTYFBbw8diAsbTUs271KqiiPieoWOpM4wiCoAaUO6yyYW
         RK0IWCgm8XmuubaM7FX2sVNML0fysv/+Q2LXOWpq1GMOHu0fe5n6nLjRS4NFlwJ3FgLo
         poZBImG3T7wVXeQziDPrVc/Hm8v4DtUVAzLUHkgm4ay4vVy5hD+Bgz1prV2E6XIqruXN
         Zthv32XmTtWmfl2ZKzOIuxktGxtQ7INzwM3trKdp6GzlPTTNkLls0p5Nfx/CAV9J7tgh
         ZYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056323; x=1695661123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=knRagvKuCPzhCIYhCOjRCh44VjecKJtrl8eHwZBErg4=;
        b=RjhQQ5Z3uHmV09TzcuBb883+VSV0EapLJpnaUYCVk7w8kIJCPdC6RiTpaQcKexeCvd
         0roNgr78fKs2GdM95Tt3PL8nXHb+sT3o6PnR9VSb4CcvIVT2WTlqOnqSK/2L0gzXUBaW
         a+ve+eLQlqMWVSD4mMhkCxBxk918ZF4SrBJI+AW8MbuZY0+OLi9bvm8QoH1fm13YxvPM
         RKZNxe8MSZD+gq94ySwHbk6dCcVxY5HFPVEnIB9S8knludJAXUKijsxibUHgWMZwQo/U
         W9f1uWqoAg6WuQeBow0v0havTQbpK7DiKI5EIhye5dF3QJca6o+BFTsjE4ngeFsBotBj
         2RRQ==
X-Gm-Message-State: AOJu0YydE1hMvVoJdXOMDNuBNuxIgk3p52JyRgKDZjlI++G/Bq1M7ibO
        aypKffsjGm8LAE61drw8RiMPhx9HlEAm9L49USDqbw==
X-Google-Smtp-Source: AGHT+IFv1Ps0KGN+3uXX0L5vlmsQqy+WtzDDn/VsgDwBehY5y6fNEdqefWeJzC7fg+gcv+GeSBBp0dzvFA3WkKepQm0=
X-Received: by 2002:a05:6e02:19c5:b0:34f:71b0:e72b with SMTP id
 r5-20020a056e0219c500b0034f71b0e72bmr553193ill.27.1695056322944; Mon, 18 Sep
 2023 09:58:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-3-rananta@google.com>
 <ZQSxgWWZ3YdNgeiC@linux.dev> <CAJHc60ytL7T73wwabD8C2+RkVgN3OQsNuBwdQKz+Qen9b_hq9A@mail.gmail.com>
 <ZQh/H5aMoqpYgVZg@linux.dev>
In-Reply-To: <ZQh/H5aMoqpYgVZg@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 18 Sep 2023 09:58:31 -0700
Message-ID: <CAJHc60wnYYxkav7+Lu3b0iPmyujz-cW-py5Ksg2+098fh5BtVQ@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the
 guest on vCPU reset
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>,
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 9:47=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, Sep 18, 2023 at 09:41:02AM -0700, Raghavendra Rao Ananta wrote:
> > On Fri, Sep 15, 2023 at 12:33=E2=80=AFPM Oliver Upton <oliver.upton@lin=
ux.dev> wrote:
>
> [...]
>
> > > This would eliminate the possibility of returning ENODEV to userspace
> > > where we shouldn't.
> > >
> > I understand that we'll be breaking the API contract and userspace may
> > have to adapt to this change, but is it not acceptable to document and
> > return ENODEV, since ENODEV may offer more clarity to userspace as to
> > why the ioctl failed? In general, do we never extend the APIs?
>
> Yes, we extend the existing interfaces all the time, but we almost
> always require user opt in for user-visible changes in behavior. Look at
> the way arm64_check_features() is handled -- we hide the 'detailed'
> error and return EINVAL due to UAPI.
>
Got it. Let's return EINVAL then. Thanks!

- Raghavendra
> --
> Thanks,
> Oliver
