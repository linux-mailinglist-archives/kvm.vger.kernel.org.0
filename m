Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD5C4F2174
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 06:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiDECQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 22:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiDECQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 22:16:47 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736D0436697
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 18:11:26 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id f38so20743444ybi.3
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 18:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iVbRFb3pHKJObhGTfG4TyT4E0cfow5X3SEOtVm7qSqU=;
        b=D8RB3yzwW1THTOskjZcYFnmP4WkVo9Xx0bih+Eq2XdF3des0BmB41dk8Q5MCyR9mOi
         hPh+AGv+gTG3fUM3DRMyZK1EbiSGLDNPOU7EnkVBOkRhgVfqnSgj5p58xQTZoL/Z9YeK
         xGUATkEXjRYfTWebIUnQ9lyOTaUDql4l47eER4ak4WIxGXEuoPWdzBFCkzUNwRALUxyq
         Lzd5n36eq80YTcSls+P/7hSSS11v8hMRbmgDWIMPPjpS66vs84SeW/vxqNJ68iEFvbGR
         Joqf9+/Xje/9GvhVKr67Ql5MRB/x8+s8JamGESZisUs8ae6JyhWJT7ENUkr/fx10J7QD
         +1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iVbRFb3pHKJObhGTfG4TyT4E0cfow5X3SEOtVm7qSqU=;
        b=1EDAWSnZX/MH4hGaxQXxqf43daVJXPRlsHlIQ7sVC/JxsZ/cAVwlk2iVS+u7rLO4GA
         aJSdGq9z3i5rj02BZIJKukwiLrqXjHRZReZ0PyRMsVdOs/Htqx/iLIG00rhR9luNS5P8
         z3OwOfVP4w5w1H5/3D4kP4jOtDo78/EejKUdsd355X2Nr2JqtZiCVRdoSJ98tl2Zu+WY
         ZcG+ZXUu0vVPD6IYvX2meV2resa6zfbDpjLdvR5iW5opCO7+nQuCfYGOJNZzOkyKxZr8
         o+SmCfLf+3H6mplccFXa9szP3ik4nfGtTNhPRTMHtruzVyDX+lR3eAWzbLwe05fNVvXp
         81Ew==
X-Gm-Message-State: AOAM5300pRrM099xF5SEwjf6Knai9iCYPkCbwoulD7d1SYEAULNWqJ1q
        OhromLki8pHYlXSFv+xh6hZl3Q6V3jgiVV25DO8Xi+9SKEM=
X-Google-Smtp-Source: ABdhPJxtx/GH6LWYXx8C6ldpwgMglrOnpypW5aqgzqo7wrMaQbWjNebWBzYw94xuXDp+yqNNkgufUEvGH5nrWfeZq1Y=
X-Received: by 2002:a9d:6250:0:b0:5cd:afcf:999d with SMTP id
 i16-20020a9d6250000000b005cdafcf999dmr293865otk.75.1649118183603; Mon, 04 Apr
 2022 17:23:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220329134632.6064-1-likexu@tencent.com> <CALMp9eRqrkLRQ7UWNUdp3Z58WWgTqO-OPRuNo+EjcOW3c5eteQ@mail.gmail.com>
In-Reply-To: <CALMp9eRqrkLRQ7UWNUdp3Z58WWgTqO-OPRuNo+EjcOW3c5eteQ@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 4 Apr 2022 17:22:51 -0700
Message-ID: <CALMp9eTCqRD+LyQ13+-3nyKAHcJ-T00K-vfK3iu0RnFR=Ax0hQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/pmu: Update AMD PMC smaple period to fix guest NMI-watchdog
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor nit: "sample" is misspelled in the subject line.
