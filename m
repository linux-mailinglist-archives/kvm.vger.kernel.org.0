Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0650F6DDE54
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 16:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjDKOn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 10:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjDKOn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 10:43:56 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED37BDE
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 07:43:54 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id qb20so20576113ejc.6
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 07:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681224233; x=1683816233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kEXBW9SVgS3rCMO2/Yt+VZhmc7IQ314trffUzR2+58=;
        b=XiY/YjpK05AlGn6os2hVbvQSmT2gGFUw/YeRBrAoENKT/yRNC+JUjJqCxtfNZapDm3
         /yGInbkwnnha6Hqq545jVFPcLhLjiAxrnOumMQNorSXjHcvON98cGkPevkYkwgEoR7av
         0HJoVDxtjbfVZhq8UqOhh9CBzUIeqhHqsbduCKA/EF7FPflPOZ24i6GIFKJY6Nljnhqu
         xMLIbHeiNBAVqaUruv7iObReTOS/pJ1uhl2yUvPsrcN5vVwipUmaf5S2Hq3M0PtipADO
         lEJorqkoZWIpi4664xq8XjtMkP153uKXS4Vf2yNJK4EW8r/x9FYtrWIphyCz87OKjkeb
         G0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681224233; x=1683816233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7kEXBW9SVgS3rCMO2/Yt+VZhmc7IQ314trffUzR2+58=;
        b=1OIFUBmAiexnFWMf7vfrwYO9ffs8yVot2pIl3XhVBjne/18Qv6iNXgkTIqOIOrzn8X
         o328HZsjfFKgZ6N55Dy9L8CYulqCH14pMTLLEFfoFTWdgWVbAYp7p/8laZthLXssPTm/
         fnpwA49B3D1/xPo3ZNffBFjl7KvJ+McqiiPxYHuyNrvVo6mM4/M1m2vwHmkIJmWNXHnk
         0ZB4/H9ZW0spL+Ftpu72bwjmrRA7tCsA8e3slkvGFzjpQqdqsqSYE9xLPq1W+Oq9feMD
         /c9WoO3PKR8J50UD3srSDuCNXJwCUtJt6/QZ05YhJ2UsKSmzmVg1X3GfGgGTqStxEqyj
         Yo2g==
X-Gm-Message-State: AAQBX9dERTFYngch26XktKN9sIQOHy1woTs80J0eAmmX52xHsirmmdNx
        thSGxsq71tVK2WRtFvl92DqUxhsDOx6kkW6F0GE35A==
X-Google-Smtp-Source: AKy350YH6292cMbO9TxIJLl9nDCTxSTNc5nodk/S09BYTb/H6380MB3snJo+tS1QmcAqFJOM/yB7evs5iP4xKSjuMzs=
X-Received: by 2002:a17:906:2a48:b0:920:da8c:f7b0 with SMTP id
 k8-20020a1709062a4800b00920da8cf7b0mr5646066eje.6.1681224233464; Tue, 11 Apr
 2023 07:43:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230405153644.25300-1-akihiko.odaki@daynix.com>
In-Reply-To: <20230405153644.25300-1-akihiko.odaki@daynix.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 11 Apr 2023 15:43:42 +0100
Message-ID: <CAFEAcA_7KtRxVQB2fdeFe1g8j2PmXgckTX_L+GQ7uQwKongB4A@mail.gmail.com>
Subject: Re: [PATCH] target/arm: Initialize debug capabilities only once
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Apr 2023 at 16:36, Akihiko Odaki <akihiko.odaki@daynix.com> wrote=
:
>
> kvm_arm_init_debug() used to be called several times on a SMP system as
> kvm_arch_init_vcpu() calls it. Move the call to kvm_arch_init() to make
> sure it will be called only once; otherwise it will overwrite pointers
> to memory allocated with the previous call and leak it.
>
> Fixes: e4482ab7e3 ("target-arm: kvm - add support for HW assisted debug")
> Suggested-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
> Supersedes: <20230405070244.23464-1-akihiko.odaki@daynix.com>
> ("[PATCH] target/arm: Check if debug is already initialized")

Oops, I was going through my to-review folder in a somewhat
random order and hadn't realized this was a v2 of that
other patch I just replied to.

Applied to target-arm.next for 8.1, thanks.

-- PMM
