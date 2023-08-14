Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C842177BFB1
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 20:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjHNSWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 14:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjHNSWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 14:22:43 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7ED10D5
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 11:22:41 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-d67869054bfso2890566276.3
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 11:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692037361; x=1692642161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ImihNqCDZEllBXBLlPPm212FqeqO2Hv5TY4g220DYc=;
        b=u8QFUvLfP+61tqDzUSKKJJSR+DggyLEtLwaGODXLBpsV2LJKHgajUJYvTQZ/ThZuXj
         kT/NXHl1fbtN+DBqPD5XBQ32fg93M27O/pSjflRag/OKKn+1EakxC8L6usEhZMAN4ko1
         Uv17RdSJq3atTjHN0Mql24Nq2HFqhwlYhBcujhGHDgGRfSQV5GnfKp9HYuBDkLZveLPt
         yQiX/hiuJ1ZIFrYfjrOv2rEtBSKefjio4ElXmMzE+/4Wmg4KrMbIWOlF7HO3PnenqoQE
         wfGoFpmAZfpTwMhSxO/rRpb8heOmYhcfEKxvn3sgKE1apv83fU025UrszFE9dk68qDRh
         Qfmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692037361; x=1692642161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ImihNqCDZEllBXBLlPPm212FqeqO2Hv5TY4g220DYc=;
        b=Lh2/vUwanrFmQFakFx/kwHyFySNelgTkWHyB7np2lJ9a24A08hn/sSWbpocMk0W3jI
         KkqUlxWRFbpk55ZpuYnnWhJRhedrzGiv1hhlUk+K80IWIKe4mD2xzXj1008T9NUmbo4s
         YfU3gxp0pZ/UInwTQEdPTc5Zqrj/d/RkgM3hAH7vNpZNwiepi6ezvq7IE5+5gcL2xsEM
         Vjb/NVHZXgtvbQQRoxyGMmkCua9MZEJL2wlMyvEbbAd34Cbc4vJUlQ81kv7jXZgsT0LH
         OUj8g2iPh2gPZlnp7AQkenJxPUliVPTmhNdBeItXP+MPhgK8Jfj79UG6TgKHrqeBnw/c
         ABIA==
X-Gm-Message-State: AOJu0YxsYt8NZDti6/aOKLh421HelqRVuYYn1a8xQ7pRLavrcfHhNbP8
        qzLoX+ZqEVGMvfYnMasFCTyKZ8ViZtYA7OLsyDQ0JQ==
X-Google-Smtp-Source: AGHT+IF9NyoQSqCsdGBy/60m2cNbaWkTF1zofsIqVu9Aqq8Fsyh6TKMhlbbW0+c4+bqEnoARxOcS7czA4ztPBGZDoro=
X-Received: by 2002:a25:ab27:0:b0:d49:4869:1bd1 with SMTP id
 u36-20020a25ab27000000b00d4948691bd1mr11093807ybi.6.1692037360994; Mon, 14
 Aug 2023 11:22:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230809-virt-to-phys-powerpc-v1-1-12e912a7d439@linaro.org> <87a5uter64.fsf@mail.lhotse>
In-Reply-To: <87a5uter64.fsf@mail.lhotse>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 14 Aug 2023 20:22:28 +0200
Message-ID: <CACRpkdayi5PyH7bifvShWRgtZXsNh9o8vA1TGV8tTORngeO8Hw@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Make virt_to_pfn() a static inline
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023 at 2:37=E2=80=AFPM Michael Ellerman <mpe@ellerman.id.a=
u> wrote:

> > +static inline const void *pfn_to_kaddr(unsigned long pfn)
> > +{
> > +     return (const void *)(((unsigned long)__va(pfn)) << PAGE_SHIFT);
>
> Any reason to do it this way rather than:
>
> +       return __va(pfn << PAGE_SHIFT);
>
> Seems to be equivalent and much cleaner?

I was afraid of changing the semantic in the original macro
which converts to a virtual address before shifting, instead
of shifting first, but you're right, I'm too cautious. I'll propose
the elegant solution from you & Christophe instead!

Yours,
Linus Walleij
