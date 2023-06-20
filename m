Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5974736BF5
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 14:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjFTMcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 08:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbjFTMcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 08:32:50 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A915A10CF
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 05:32:49 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-312826ffedbso395123f8f.0
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 05:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687264368; x=1689856368;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NxL6Allu6tKi+Tgz0rkMSYNHdLIJ/J7IbU+aDVCqHbs=;
        b=LSglx++V8xepIHtsCdtanWg4aJqcYdk7Nb4CJaKdw8FaZnhZabTjidhpaN3gboJrG9
         npnv1xGAZGLp+MYOCy62LM7yI0I0k6eDVcB8UK5VFbqfgf5NLbqTCERMKox6UmfcKTYw
         7iRmH54uo4ybMQyU2L0fXMyPCZ3nwMhEs1amtBWUU7ivrRoeDKXqS6tbDv64OvDAH85a
         aTrp67C1GqmXbb8ivpbLTR3D0d9jzQySg+AP9W8JSMt7+jcM+XIA0VYrlu+IfRi6TXPV
         r+BXcajUBcoecAah9SiHHSva9/DQPpb7GYvxZtM+GuW3eV4iUkA+SNh2H2fdBdecUzXF
         XeOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687264368; x=1689856368;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NxL6Allu6tKi+Tgz0rkMSYNHdLIJ/J7IbU+aDVCqHbs=;
        b=iSPWJlYZT0a/jjMBhl15DKCk4cImOK4W6C/BvoNt8EgQBpn/zRbUzOWeztBYjJXFXK
         N7QwN57rCxlhSI34pdrzveOr/npeyoCi84MMkI3p0oTArLQmhZ5U335zdvBglZVx867m
         mlGPcucxsG+mBeHSUMWlKzi7seoI4bUv7jbPHlbIjcaweR0o7RdpJxXKs5qln+eo2KDS
         1w2Irmewo99NzfCdElmM+RZj78ZsMma0ijhqWeQ7nOyTKgKXJEEZNBQBVpxWzUIEEQiQ
         +l6DJTXJVkRIVKPpom0ceWh1Epg/QLN8owlctnQWY/ZjMX0++IgThQjilpvBs9B2cxsU
         2PEg==
X-Gm-Message-State: AC+VfDx9Xy3NUA+3iv6EQhiGYB5Mr1gM9Gxm7AJlBkF633GFGnqJhovM
        AUYIvXwluQd9c37Tn5pHsagvxhAzUa9niUNfCPk=
X-Google-Smtp-Source: ACHHUZ6z48D8wq6LZE3xRCtvlxpNhP9I+7VcCL216Fw86K1tauU+uvAPpqoDRfoYxP9gUUXNrPCfbg==
X-Received: by 2002:adf:f203:0:b0:30f:ca58:39ca with SMTP id p3-20020adff203000000b0030fca5839camr9253257wro.31.1687264368157;
        Tue, 20 Jun 2023 05:32:48 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id z13-20020adff74d000000b0030af15d7e41sm1971608wrp.4.2023.06.20.05.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 05:32:47 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 5D01B1FFBB;
        Tue, 20 Jun 2023 13:32:47 +0100 (BST)
References: <20230620083228.88796-1-philmd@linaro.org>
 <20230620083228.88796-3-philmd@linaro.org>
User-agent: mu4e 1.11.6; emacs 29.0.92
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [RFC PATCH 2/2] hw/i386: Rename 'hw/kvm/clock.h' ->
 'hw/i386/kvm/clock.h'
Date:   Tue, 20 Jun 2023 13:32:27 +0100
In-reply-to: <20230620083228.88796-3-philmd@linaro.org>
Message-ID: <87o7laiaa8.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> kvmclock_create() is only implemented in hw/i386/kvm/clock.h.
> Restrict the "hw/kvm/clock.h" header to i386 by moving it to
> hw/i386/.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
> RFC: No other arch had to implement this for 12 years,
>      safe enough to restrict to x86?

Importantly the implementation is certainly in i386 only:

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
