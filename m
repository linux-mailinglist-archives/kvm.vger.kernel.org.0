Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02756709CE3
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 18:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjESQvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 12:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjESQvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 12:51:03 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A5B10D9
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 09:50:44 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-510e682795fso3757502a12.3
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 09:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1684515043; x=1687107043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EtABjzB0C4odF5c0xpse4cUAQWQzyn/IxLw5sIWp3wA=;
        b=5jFMv+RKVKdIkhypHP4y08tfdCV9hkIMZJ8Qxsb9Ky58QuT/DtVSobRoMgT0sxoj0o
         tY2UcczNDxlDLLqfZZxst8cn+BG3VWjev7T1kKUKz9vc5n92Jya8098evqNTIXnk6jEP
         uC2BrHe5N0G+xn6L5+Um7IVUq3jpF+8QIqFkJzrtwqML3E6d4Jb8BtYvSyNkP6KDsL6p
         HkiUefmkBhuhH9p+e+LYpEbG8wUGuQdhuIH2kAMKFE+ILzAY7/vDIZ9iY3abVIZscz+t
         rB2mKXzYaP73i+0UHovGtFicMeWFA4YBFHSm2iju3FXl6DGbWDziipD10ily2NQ+Rzha
         7Ypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684515043; x=1687107043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EtABjzB0C4odF5c0xpse4cUAQWQzyn/IxLw5sIWp3wA=;
        b=RSc5GO7j1Ye1W9urju7sWUN8rTySgaLIC67va8GELKNKPsc40CfO+MWGdcRSnL11YJ
         r0b7VqFV1zblKuCMIcR8hueCzwNcVQsqZk/F7kBYGXzB6QJ+ykCCeSzYuc70pnM4epUI
         MvFkpovypGTzoF3fuQ7elBnt+wzZeCtrdvchfWGMNlzsbC4q1u2gfaVU0ODhAM2BVKe1
         cSdJmR7mbpRljWCCiVyxKzVq5HMVy6791aEfbr8zaeRZ52B+fm10jbOyR3kvrx3EbEWx
         TcM1ZuZ6CHkSw/ltaGJOc+xYUVFIpnbyjnYSW9UZE3xQrViGG4XiZ9QQG7Pr3rtcLt4q
         1OYA==
X-Gm-Message-State: AC+VfDwRS3nhonlQLNjEuIuQUTctoHNQLOWstaWL57TvDoUwOgy3QrqH
        aEDVrOpkmjClRv5xXvdYk369qy/rGaJo8ba7nrORPw==
X-Google-Smtp-Source: ACHHUZ7Wa66h7rfCspUIEGJSIRWIT6LEQ5VwUl0kcVhQLSxwKBGekN9/RNnvcHqS6J/oIW2wTZKT2v4ZfW4OGKooXO8=
X-Received: by 2002:aa7:c303:0:b0:504:a2e5:d951 with SMTP id
 l3-20020aa7c303000000b00504a2e5d951mr2846985edq.13.1684515042920; Fri, 19 May
 2023 09:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230518161949.11203-1-andy.chiu@sifive.com> <20230518161949.11203-4-andy.chiu@sifive.com>
In-Reply-To: <20230518161949.11203-4-andy.chiu@sifive.com>
From:   Evan Green <evan@rivosinc.com>
Date:   Fri, 19 May 2023 09:50:06 -0700
Message-ID: <CALs-HstHyZ055SDu8s_KyACERufD1tU8_hxM1UckN4YF4ms2Cg@mail.gmail.com>
Subject: Re: [PATCH -next v20 03/26] riscv: hwprobe: Add support for probing V
 in RISCV_HWPROBE_KEY_IMA_EXT_0
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Celeste Liu <coelacanthus@outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023 at 9:20=E2=80=AFAM Andy Chiu <andy.chiu@sifive.com> wr=
ote:
>
> Probing kernel support for Vector extension is available now. This only
> add detection for V only. Extenions like Zvfh, Zk are not in this scope.
>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Thanks Andy!

Reviewed-by: Evan Green <evan@rivosinc.com>

ps- This will end up conflicting with my patch which moves that hunk
to a helper function, and also allocates the same hwprobe bit [1].
The fixup is very straightforward for a human, so the ordering isn't a big
deal either way. But I thought I'd give you a heads up so you weren't
surprised if someone mentioned it.

[1] https://lore.kernel.org/lkml/20230509182504.2997252-4-evan@rivosinc.com=
/
