Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED09276D60F
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 19:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbjHBRu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 13:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjHBRtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 13:49:53 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D87170D
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 10:49:13 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1bb571ea965so5559438fac.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 10:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690998552; x=1691603352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jkqdJMsvnVrRBo60+NUWMzNrzTaghjxAkAcp9NTjI7U=;
        b=qYZLszf+G832APU0iLQ9SDhHuPTE3ItqB1h1SOE36kWmrQQh/dmguNVkGU45Hq9yf8
         5Js/rXDP2hz8lYlp/9XADzFOJco2hlateqHcVjgHvYC4GYJf0t8UwSqdjPywq3+AycOG
         DLfaBn4hqTCglB9+hqaHj82XmSBWOK9qQy7g0rsnvV8MmKA9ddPuNhmHC1zRbfrv7eXd
         Tl3vbF0u8sTrlLURWVKPy9WenP7SMBeciiCChg/IuMi68UstzQEuAv1tqf7zvQ6jkoaS
         qIBqUxNkywVThWo0kz0nOjX4udk2CB6WnKuY7oDVs9biFODpN2r212df2uGyWVwLI6NH
         B4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690998552; x=1691603352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jkqdJMsvnVrRBo60+NUWMzNrzTaghjxAkAcp9NTjI7U=;
        b=e3Wz4OobqxU9BnKeanUnczVgF3Lk/amb03kdrlcItXq7CLVO/hZrxgDXPBuFzOl+Zl
         O9JKRbYH3hp5CgI6Dh/4nckLBDoqEFIy44jxyZmRV6K+8GUi2SZ0wZ3RDHW91U6/A5Wv
         dp3F2B/EbE0Lp0r5PJyfsQtadvmdmzZ6J17tmb2pa7VL4pLGfnRCg21f9c60k+aaGexb
         xmQQsWWkKdnhOU1svvxmXx8vGSgna7O5aFIUsB/n9kjjETviE93djZcvgTeq9iiAiJ56
         oG1XPFZP2kA1JsKE9IzKpj4m44LTQQInN3+8VFN0Gaswj7jxEeaYnzjCpFwDW5ZmZwOF
         7NtQ==
X-Gm-Message-State: ABy/qLavwaaAyuFvo5cJirqYQpsy88Rxnu4a60YeoDX6/XD18t4OJO4j
        uNLzJGIzOJUynwZvumqC/hQBVz6YQeeV4/8CYnTFGw==
X-Google-Smtp-Source: APBJJlF+hW45L4zt+hV6v1CvORUlP0mnh2MB6RDtiOS9QHnRZhAqJKTZsof6tHpAhnXoQnSabSlwJi5om+C3bOdNWqI=
X-Received: by 2002:a05:6870:f102:b0:1ba:63b2:899d with SMTP id
 k2-20020a056870f10200b001ba63b2899dmr18481008oac.32.1690998552110; Wed, 02
 Aug 2023 10:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
 <20230801152007.337272-2-jingzhangos@google.com> <ZMmdnou5Pk/9V1Gs@linux.dev>
 <CAAdAUtj-6tk53TE6p0TYBfmFghj94g+Sg2KK_80Gar18kJ=5OA@mail.gmail.com> <ZMqMofRCmB14XUZr@linux.dev>
In-Reply-To: <ZMqMofRCmB14XUZr@linux.dev>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 2 Aug 2023 10:48:59 -0700
Message-ID: <CAAdAUtiemHnLK-y4AmEa53bw4ZhvRsebQWAMjV5dTSxEG0BUJA@mail.gmail.com>
Subject: Re: [PATCH v7 01/10] KVM: arm64: Allow userspace to get the writable
 masks for feature ID registers
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 2, 2023 at 10:04=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Wed, Aug 02, 2023 at 08:55:43AM -0700, Jing Zhang wrote:
> > > > +#define ARM64_FEATURE_ID_SPACE_SIZE  (3 * 8 * 8)
> > > > +
> > > > +struct feature_id_writable_masks {
> > > > +     __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
> > > > +};
> > >
> > > This UAPI is rather difficult to extend in the future. We may need to
> > > support describing the masks of multiple ranges of registers in the
> > > future. I was thinking something along the lines of:
> > >
> > >         enum reg_mask_range_idx {
> > >                 FEATURE_ID,
> > >         };
> > >
> > >         struct reg_mask_range {
> > >                 __u64 idx;
> > >                 __u64 *masks;
> > >                 __u64 rsvd[6];
> > >         };
> > >
> > Since have the way to map sysregs encoding to the index in the mask
> > array, we can extend the UAPI by just adding a size field in struct
> > feature_id_writable_masks like below:
> > struct feature_id_writable_masks {
> >          __u64 size;
> >          __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
> > };
> > The 'size' field can be used as input for the size of 'mask' array and
> > output for the number of masks actually read in.
> > This way, we can freely add more ranges without breaking anything in us=
erspace.
> > WDYT?
>
> Sorry, 'index' is a bit overloaded in this context. The point I was
> trying to get across is that we might want to describe a completely
> different range of registers than the feature ID registers in the
> future. Nonetheless, we shouldn't even presume the shape of future
> extensions to the ioctl.
>
>         struct reg_mask_range {
>                 __u64 addr;     /* pointer to mask array */
>                 __u64 rsvd[7];
>         };
>
> Then in KVM we should require ::rsvd be zero and fail the ioctl
> otherwise.
Got it. Will add the ::rsvd for future expansion.

Thanks,
Jing
>
> --
> Thanks,
> Oliver
