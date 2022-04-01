Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBA64EFBB9
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 22:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352558AbiDAUmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 16:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239896AbiDAUmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 16:42:11 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57C6174BB5
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 13:40:20 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id v12so5418745ljd.3
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 13:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XoSP3hMLfu85/1JEUuOtPJh8kpd6w7SHg/LZEyV60Ps=;
        b=BmxvnjiSUtj1QaEfWViPd99IiS4Iovkvs/qZCvlsIYl13dHqNSDTC0hWMuOpMiKHPV
         kI+Bx1QVp/F0NbIypef3IbNmkvMBfPNwHiR6qRlH0sYUIoo7Kt0hvOrkVUDdf0s2snq9
         KBplvRS39sVsg7Ih4Ngj4cTRUzJMAJ4y2iGUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XoSP3hMLfu85/1JEUuOtPJh8kpd6w7SHg/LZEyV60Ps=;
        b=pVACk83Hv7gzt6Gsjhf49VNSDD+16kTibJ7A27Cjlz0BJHO8KKrCb3CdfA+g1JjNsN
         yyTSK1q06OW3ADeQr61KvjMS3FgeM+q1SUZ66tx2JLl9YtVYWXdDbgGCsi2SpoAkFlYA
         njMFhnbL8KzeiQs/82d1J3G51aFMwybtl9R3OgkxgKDjwZB74erIZR9uziB+qa+zl/9A
         nBItodkRnwe9vPYGPoDHT5di6a3z7CaMjUBO1ehPv7OvDWrkpNZjA0F+cC/MEFrz5og0
         yG2A4jbo4uYGSCv2MUrNhcxgxCZT2leKHjt35uQvAsxSFDKFM9hk4zfcavqUPBnoSTef
         xgyQ==
X-Gm-Message-State: AOAM532x2oShldJWkAhrqojEV5o63KWxCVTkG5j7alJ+aVZTK/ILqQFl
        e+EaaSz3b/wWAtfAWLPwwPNUVE7tAmPGDhVjNHc=
X-Google-Smtp-Source: ABdhPJykgLl8ochjtAhm1v3iEPLA1CE3NNPBnCNYzVVZzrq7leQt9JBWEFVZzTmq4yx8RoaWeCH43g==
X-Received: by 2002:a05:651c:243:b0:24a:fb54:31d3 with SMTP id x3-20020a05651c024300b0024afb5431d3mr5419883ljn.242.1648845618797;
        Fri, 01 Apr 2022 13:40:18 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id p15-20020a19f10f000000b0044a36e3cc33sm336367lfh.298.2022.04.01.13.40.16
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 13:40:17 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id g24so5398731lja.7
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 13:40:16 -0700 (PDT)
X-Received: by 2002:a2e:a549:0:b0:249:9ec3:f2b with SMTP id
 e9-20020a2ea549000000b002499ec30f2bmr14333618ljn.358.1648845616539; Fri, 01
 Apr 2022 13:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220401153256.103938-1-pbonzini@redhat.com>
In-Reply-To: <20220401153256.103938-1-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 1 Apr 2022 13:40:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgSqvsP08ox-KwAU4TztVsjx07cMQni-rFEzxZQw6+iiA@mail.gmail.com>
Message-ID: <CAHk-=wgSqvsP08ox-KwAU4TztVsjx07cMQni-rFEzxZQw6+iiA@mail.gmail.com>
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.18
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 1, 2022 at 8:33 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> The larger change here is support for in-kernel delivery of Xen events
> and timers, but there are also several other smaller features and fixes,
> consisting of 1-2 patches each.

No.

I've had enough with the big random kvm pull requests.

NONE of this has been in linux-next before the merge window. In fact,
None of it was there even the first week of the merge window.

So by all means send me fixes.

But no more of this last-minute development stuff, which clearfly was
not ready to go before the merge window started, and must have been
some wild last-minute merging thing.

kvm needs to make stability as a priority.

              Linus
