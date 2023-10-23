Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493B07D409E
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 22:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjJWUHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 16:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjJWUHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 16:07:16 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D931F9
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 13:07:14 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-53eeb28e8e5so747a12.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 13:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698091632; x=1698696432; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8FBAGvT7oXPuKf4HksbmiMPrXvT2KkJFmsdQBwoIyA=;
        b=QJmA1cnEu3f0kW1uzceTQ1jJBVSa0n/muP17Pr+EI5pdJpbgRYwm1e4jRVNEgFO1L5
         ztt7Ygq02reFwW7Knr2FtjEB6uKQA8SVjWlh0P/36dxpfCtM592OHW2YMTjZi8QK1UUu
         ML4M8xU3fhIwkOClhA9a9snL0xzPILJ2gaR0/IghKZu7RwuprC95QZApb4lXEKZIzs2w
         5uvmz7SF/W+OWEXdLiivCMZywf9jPzG0gvjXBXaY9SI+dmMqdiYZirL49Xi9vmxDSDYU
         RNQUrIEIVh+TXbhq2FWq7HTb37+Bi4R2zQ+6GbY2oZ2AR6GrB2dcJxkLB+SNx2YWETEk
         el2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698091632; x=1698696432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8FBAGvT7oXPuKf4HksbmiMPrXvT2KkJFmsdQBwoIyA=;
        b=FDvSDjp8Xf4IH99DmOWlOTWZ7VXKf+STytMO73KJQeQ9BLUjf33Vy12Y6hk5hPzgm7
         fru+NK4DXFLBKOMoZBrki9M+FH/CU87DfmFfiRLoYL1kpNUA6OeyZvQj58w8UWGb5XbG
         w7iluNghACrbBYc17LKTT1PFSKBUqs6QYfhIrl71M1YkhSz1MWNIL9dSu9GfMhSOtVkt
         O+qXHPT70Mr0V1bdcPU0TXSuw3xkdAHGjA54W0K+Rtw/EswOnpQuz/G/nThMVmZPC1Ry
         EWaBE6xjBvaf1ybzIwNFKw9XD5qXggIKAe3D8NZm0WJo/cpjN6qR8cUlk4sntJokw3Nl
         RTTQ==
X-Gm-Message-State: AOJu0Yx+b1oyKsSmJd8t0QF0ZhSNVh07L5Q9cgxagIJC3T55hQ0Fmwv0
        HrDyw8SPzSHfIk0y4QTqwX/nfK+ubjwgdYTkUIubbDjNyvQTyzGFnT4=
X-Google-Smtp-Source: AGHT+IFqd7U9qBGyLSBXnI9THliggciDIdPcecLSIPkORTTj+1VfD0X2pcapTtEqokL7YmZ+ebgVc2pWpeGnoJCAgo4=
X-Received: by 2002:a50:9fe3:0:b0:540:510:f866 with SMTP id
 c90-20020a509fe3000000b005400510f866mr7515edf.7.1698091632426; Mon, 23 Oct
 2023 13:07:12 -0700 (PDT)
MIME-Version: 1.0
References: <326f3f16-66f8-4394-ab49-5d943f43f25e@itsslomma.de>
 <ZTaO59KorjU4IjjH@google.com> <CALMp9eRzV_oJDY7eD7yvcB9di8NzyTX34W8rfaK-wf2-8zQ-9w@mail.gmail.com>
 <f9f6b30d-91fd-45af-8914-d2fad1c735f7@itsslomma.de>
In-Reply-To: <f9f6b30d-91fd-45af-8914-d2fad1c735f7@itsslomma.de>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 23 Oct 2023 13:06:57 -0700
Message-ID: <CALMp9eQ7Sio6W=upSQ8Ax-PyM-dAjPq2xji9NmakcF8wW2SqqA@mail.gmail.com>
Subject: Re: odd behaviour of virtualized CPUs
To:     Gerrit Slomma <gerrit.slomma@itsslomma.de>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
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

On Mon, Oct 23, 2023 at 10:43=E2=80=AFAM Gerrit Slomma
<gerrit.slomma@itsslomma.de> wrote:
>
> Why?
> As Sean pointed out if you have older CPUs that don't support a specific
> instruction set you need to restrict the capabilities in order to
> support live migration.

The x86 hardware virtualization facilities do not allow the hypervisor
to restrict capabilities a la carte. Some capabilities do have a
"gatekeeper," like a CR4 bit or an XCR0 bit, which, when clear, will
induce an exception if that capability is used. However, many
capabilities do not. Take the SERIALIZE instruction, for example. It
should raise #UD on platforms older than Sapphire Rapids, but if your
virtual machine is masquerading as an older microarchitecture on a
Sapphire Rapids host, you will find that the SERIALIZE instruction is
available, does not raise #UD, and works just as it does on bare
metal.

As a result, there is no way for a virtual CPU to masquerade as an
older microarchitecture when running on Sapphire Rapids.

It can come close enough to be acceptable for a heterogenous migration
pool, but it's still a virtualization hole.
