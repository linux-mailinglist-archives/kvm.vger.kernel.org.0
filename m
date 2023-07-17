Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844C37561A1
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 13:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjGQLfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 07:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjGQLfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 07:35:39 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94A6E4C
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 04:35:38 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-7653bd3ff2fso518310185a.3
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 04:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689593738; x=1692185738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bq8gCHQ3DK7I53K7E6T8jrcN3NhWzfZAuTdue3VyqQA=;
        b=3vRFiwFEzmUmLb0kPb504rDdmP8xzMBghMG1vWi0o/67gH272jU1EcreMwYuN5JVyk
         2DaV02Lib8lt+0O2hjavBdmtUNoDfY/OByiotPqnfa9nqZKGCeWF1RtsO9RLyTMhRnp2
         0vncWmj9pVI3dARu+ONdet5PFCN5GkE20G/S821oKgJmVkFKezCvCj5uIY3C0cQghb/C
         vHfqrxevlMpzfghkx4q6PjpiB8+RHrMiJZX36/JG8Eb4P6/LEAns+pIV4gQxgK3MClPD
         o+rH0A/15+tHGhrtsaEoOk5jFGmEdT7XQr0+VrqHQv9VSNbujVf74q3HQZw+3ySlejy1
         jdhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689593738; x=1692185738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bq8gCHQ3DK7I53K7E6T8jrcN3NhWzfZAuTdue3VyqQA=;
        b=heoaTIIuq0kY90c0Ez6lhx4VVqAuAI755B9lV77LPL+jZ+NVq8Gb5tWg9xyxOnr1Cs
         3U77nB0mwsgy6ZIhU4KX3UxC08MEcoaKc/BV5bZFFsheQLrO8Mc8omxpAAVaDJ7P8VG+
         ZtpZMXoQez9c2UQXpLJ6vDbV8q83TgY1luYnHinErTOTnjx1FYyetYbPQFf08N7GRGHz
         ZAYt9ecsQRquggKEOzYNLGGQk6sQ3wEItZ3th1OZ+x/rY7ifJ6GjWsNw2frQn9Llvb75
         +KSeyvK89OaFGDNG9x7G4vT02LJfkJwXevtez9yf4FSRS1oS8iDjxkSVGvgzBOo5NpaN
         CBmA==
X-Gm-Message-State: ABy/qLZ1jCB1a549tUEPyvhMUQ/raIBlLeeJCQ+5wLHrEU5YtHZs/f/a
        ulccjZ6yKLYrxEQ9b1Nrr1EGoWqayy2pASVBuEmmQA==
X-Google-Smtp-Source: APBJJlH/LLTn2FmYi52ai+ViPiSCHf+jKjw/3VATbUHhbhCEXjffKNAWxqnpjCZn78YpRwUIypSVx9F/Khim0JruDMs=
X-Received: by 2002:a0c:e605:0:b0:634:e718:2fa5 with SMTP id
 z5-20020a0ce605000000b00634e7182fa5mr10708869qvm.24.1689593737972; Mon, 17
 Jul 2023 04:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230717102300.3092062-1-tabba@google.com> <20230717102300.3092062-3-tabba@google.com>
 <20230717110304.GA8137@willie-the-truck>
In-Reply-To: <20230717110304.GA8137@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 17 Jul 2023 12:35:02 +0100
Message-ID: <CA+EHjTw_9mCR61Mi_m911jDxCF_rk9+_72inF7U-qhtrdgc93Q@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 2/2] Align the calculated guest ram size to the
 host's page size
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        penberg@kernel.org, alexandru.elisei@arm.com
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

Hi Will,


On Mon, Jul 17, 2023 at 12:03=E2=80=AFPM Will Deacon <will@kernel.org> wrot=
e:
>
> On Mon, Jul 17, 2023 at 11:23:00AM +0100, Fuad Tabba wrote:
> > If host_ram_size() * RAM_SIZE_RATIO does not result in a value
> > aligned to the host page size, it triggers an error in
> > __kvm_set_memory_region(), called via the
> > KVM_SET_USER_MEMORY_REGION ioctl, which requires the size to be
> > page-aligned.
> >
> > Fixes: 18bd8c3bd2a7 ("kvm tools: Don't use all of host RAM for guests b=
y default")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  builtin-run.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/builtin-run.c b/builtin-run.c
> > index 2801735..ff8ba0b 100644
> > --- a/builtin-run.c
> > +++ b/builtin-run.c
> > @@ -406,7 +406,7 @@ static u64 get_ram_size(int nr_cpus)
> >       if (ram_size > available)
> >               ram_size        =3D available;
> >
> > -     return ram_size;
> > +     return ALIGN(ram_size, host_page_size());
> >  }
>
> I guess we could avoid querying the page size twice if we also factored
> out a helper to grab _SC_PHYS_PAGES and then did the multiply by
> RAM_SIZE_RATIO before converting back to bytes.
>
> e.g. something like:
>
>         available =3D MIN_RAM_SIZE;
>
>         nrpages =3D host_ram_nrpages() * RAM_SIZE_RATIO;
>         if (nrpages)
>                 available =3D nrpages * host_page_size();
>
> and then host_ram_size() just calls the two new helpers.
>
> What do you think?

Sounds good to me. I'll respin.

Cheers,
/fuad

>
> Will
