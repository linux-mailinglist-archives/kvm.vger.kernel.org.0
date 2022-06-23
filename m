Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502BD557A0B
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 14:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiFWMLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 08:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiFWMLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 08:11:49 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7488A4DF7E
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 05:11:48 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-3178ea840easo153780177b3.13
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 05:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S7K6L24c+Y1b2KwK/Q66A3sSE8CSQ8aoyDZ6Ql0AsV0=;
        b=sSpGHUTCswvHhT4H1B5KfzqfwiD7oQxtmXZiGYZWoxAyeQ53n3xZie+Ig2mwn4fCKe
         Xkk5l8mFLX0kRrjF8NztrOQAuU52WLUKrooX1ha86jVcPQT+lVHJJzr3EiJ+UF7TjqFM
         nqdYctf2D2InwbxppBsCmKuKQpNw34cClqkrbhhan/C7GZWJQrWrENeasaFTmg0tWRFp
         g/2Ucg8+GEoDhWWrC6Nrg6Fi/50TmkWKpcFMB9baLyloRj6wdJU9WXjRf1SB3ztDT0cg
         FKJhzLt3sFIqvSV/cOBVRkiQZLYWTjptf9Q+C/PdBnkfcBF+uIqQeDB+soTPzUrdXTPY
         stZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S7K6L24c+Y1b2KwK/Q66A3sSE8CSQ8aoyDZ6Ql0AsV0=;
        b=dYTjM4RTA9O9nZBEmQzwuo6cvq1CB3MSqQ/H/WxuKCLFP1dYyUbB3Khn+/rdygWH9o
         uwOO60rNxyItCVP+L/0d2L7u7duEbbKA4Or1gjZfgt5DcItktcrcxmp47cy1rwCmUou5
         h6Db768Nf67Nkbs1MOcBMP3aCXk+YSi1Oibuku2Eq8krxna851Ehdf/ABycdqnEk7+2U
         8zZ3N8UpyTxBRRe21LAo8RRRb1V9Jt14b9m4YAlrvxB0RkPSJx2Lb4dh9oubehqtuOsb
         SlYewTABsaLmEScpROARnA9iLquBkd8MU08dswQczCzhd6rKZ0Bn7yTbMS9n5YHDXicB
         trUA==
X-Gm-Message-State: AJIora/nGFIo6oW17ldG7q6nybK8ZnwFKw+HwQA7L3MYdXT4EaDB066C
        dSqX0qBrsD+/5T5BgIIQwHjt5QnRu+1A/7aaOw4Dsw==
X-Google-Smtp-Source: AGRyM1tHM2PH06jLutpzWpAloSsRpnBlSBJrLzjiiLlW8Jb+1R5M99HLQ2wspI2xTF78Np9POqoBFx6jx+SutF94Y5w=
X-Received: by 2002:a81:8486:0:b0:317:a4af:4e0a with SMTP id
 u128-20020a818486000000b00317a4af4e0amr10199573ywf.455.1655986307630; Thu, 23
 Jun 2022 05:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220623102617.2164175-1-pdel@fb.com> <20220623102617.2164175-3-pdel@fb.com>
In-Reply-To: <20220623102617.2164175-3-pdel@fb.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 23 Jun 2022 13:11:36 +0100
Message-ID: <CAFEAcA9k_gW7GDDDiLf7gp-wX=_OCKzKeMHe5Rr5ZZe167kaYA@mail.gmail.com>
Subject: Re: [PATCH 02/14] sysbus: Remove sysbus_address_space
To:     Peter Delevoryas <pdel@fb.com>
Cc:     clg@kaod.org, andrew@aj.id.au, joel@jms.id.au, pbonzini@redhat.com,
        berrange@redhat.com, eduardo@habkost.net,
        marcel.apfelbaum@gmail.com, richard.henderson@linaro.org,
        f4bug@amsat.org, ani@anisinha.ca, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jun 2022 at 11:56, Peter Delevoryas <pdel@fb.com> wrote:
>
> sysbus_address_space returns the address space associated with a
> SysBusDevice.
>
> That address space is always the global singleton "system_memory", which
> is retrieved through get_system_memory().
>
> This abstraction isn't very useful. Users of the sysbus API (machine
> authors) should know that sysbus_mmio_map et al. are mapping devices
> into the global singleton memory region, not into a specific container
> or some memory region specific to the device's parent bus.
>
> Lastly, only a few uses of this function exist. They can all be
> refactored to just use get_system_memory() directly.

Yeah, we definitely don't need two functions doing the same
thing here.

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM
