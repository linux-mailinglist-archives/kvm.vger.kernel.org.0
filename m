Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECF37D3E66
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 19:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjJWR6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 13:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjJWR6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 13:58:33 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C28A1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 10:58:32 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-3575da42138so6985ab.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 10:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698083911; x=1698688711; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfJGqGdTH39RlV73n8ZRtDromBqG4R/oxQlCFc0Ndko=;
        b=FQQHBzltWBTlqvuJVgfz8FzxMn4Rs1+dy9t+GOs1Da2DynuPuGTTJaryppeGY4i8LG
         l+4YGXIkFjK6WUmZP0U6Weg73QNYfKPANTS9DZwSye1RnMpLV3JKlhKxJqPsRRLsYuGf
         3+BK1dt0HsXd1jbMWEUqVGTf6fZc+aFDfG4+9+bs83+W8lhxA5TABPiOK59gIZjKPs9s
         MWZcc7ZAX9kue+bkL54MfIEF71ghkmcZTsDbzIisV/KR0+4ehYxQXwzqKnkLsMVGTen+
         MnrVd+gKPsQfcbQuPeWEIIUgoWp+lOQMxpMtzk+xtDrr9rJPspSTpwdHB9gwgXjdtNgl
         gYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698083911; x=1698688711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TfJGqGdTH39RlV73n8ZRtDromBqG4R/oxQlCFc0Ndko=;
        b=LOEPh99I44CcKVxzI8b0NfibnNDbJzVJpujojfUlHDFan+J5nBUY8+DtWlgS4rTVpr
         pZI403aueI3S63vyb/g0On9txO6vie1Yc35VsGExfBNTifFE4gp6My+rxRtWB5lKV8jf
         dho/Qk8YEmV6YTFLK58mzGZF+QVJbl3j4u8Slz/BKs0OivlGN0wBcFTrata1+uDq2ir6
         BeTXxW+hkaxJ3BmKRJpmDftrOdc2QihOM1WAqkoa7lp6qzOETIjT9XGfIjxZpbSUH53E
         GeqdVNTgWqfGvVNXTe5O/wByhasPLCM38pMfG6Z+e41a4ultu3VNyo/0vEck1RrAT3vd
         OKqg==
X-Gm-Message-State: AOJu0Yy/EvdwF6qtIX6E0yD+oxvXHo+liTLJpnpqZRN2tXO7jl7f0FgH
        WP0ujZIqdmt5gBuuMONB47+BdGFu3DvaZmS9vSgfRw==
X-Google-Smtp-Source: AGHT+IHFu+B+EkRtR9TtZ2HnO5hJ/bbYmjecKN2fzau01UI7bGBTJ8SmNfFiuS/aPe3ywIzuv4AuB6FgCqAsG1FO86A=
X-Received: by 2002:a92:d08f:0:b0:357:cb68:b1cd with SMTP id
 h15-20020a92d08f000000b00357cb68b1cdmr29333ilh.22.1698083911264; Mon, 23 Oct
 2023 10:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com> <86v8ax4hae.wl-maz@kernel.org>
In-Reply-To: <86v8ax4hae.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 23 Oct 2023 10:58:19 -0700
Message-ID: <CAJHc60yGk2Gfh-GRtOE94NS0K968iGTfn_3SSMYXxbgKaA_+Pg@mail.gmail.com>
Subject: Re: [PATCH v8 00/13] KVM: arm64: PMU: Allow userspace to limit the
 number of PMCs on vCPU
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 6:09=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 20 Oct 2023 22:40:40 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Hello,
> >
> > The goal of this series is to allow userspace to limit the number
> > of PMU event counters on the vCPU.  We need this to support migration
> > across systems that implement different numbers of counters.
>
> [...]
>
> I've gone through the initial patches, and stopped before the tests
> (which I usually can't be bothered to review anyway).
>
> The comments I have a relatively minor and could be applied as fixes
> on top if Oliver can be convinced to do so. Note that patch #4 has an
> attribution issue.
>
> > base-commit: 0a3a1665cbc59ee8d6326aa6c0b4a8d1cd67dda3
>
> maz@valley-girl:~/hot-poop/arm-platforms$ git describe 0a3a1665cbc59ee8d6=
326aa6c0b4a8d1cd67dda3
> fatal: 0a3a1665cbc59ee8d6326aa6c0b4a8d1cd67dda3 is neither a commit nor b=
lob
>
> Can you please make an effort to base your postings on a known, stable
> commit? A tagged -rc would be best. but certainly not a random commit.
>
I usually do base on a known -rc. But this series needed a couple of
series from kvmarm/next (mentioned in the original patch), and hence I
rebased on top of them. How do you suggest I handle this in the
future? Rebase to a known -rc on mainline, apply the required series,
and then my series on top?

Thank you.
Raghavendra
