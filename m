Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49049473A1F
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 02:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243098AbhLNBTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 20:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbhLNBTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 20:19:13 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE420C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:19:12 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id f186so42616274ybg.2
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZRkndmsDMVuEIH+6KsPSMK2F22PPxmnCH8dPJZ239sA=;
        b=rNSQG5PRTClLXS1K5OYsTfmHHAax4N65XcACquxpJyEiMNRNqdyAjf3eI9r8cKYh9J
         LqBW2wGF6b30ycX0+AabjeH1uQxQjt1+lS3kAiRE7X6vypUz1LmB1CM35lDemDsDDIk1
         JAStA6aZC7uoTpayvc3FX32UlVPPoZ5hjKfnqepOIhPwczH4O22jPAKoJut3dyA0g7fO
         itgqOxBnrfUiv7lda9WCWXP8Mj29AvYOtiuXoXRqUkYQoFX4jOwk0Xh3wgW2dLXX+NDi
         hr4TLM6oR46Ufn2rx+wYfMYTptH1B/v3ZbD8U7cJgYatHg1trfOqPdko97Td/o3rCqyd
         fnlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZRkndmsDMVuEIH+6KsPSMK2F22PPxmnCH8dPJZ239sA=;
        b=OP+eppXhZhq9/T+dLoDRyLCcI4WNHFt9jttmeRlaJJbEVHkXPp7gFp2FZTLjYEgHdW
         kZfh0AfmgWKjpoycXk+WKLPQDKuZj6Bm+N5xLIVt/w2v+rv/SO2flrInTF2eeZm1HMoD
         lEwIQ84+jgzF15OCErcJ09Fl30lBk4cfZYIFFO9PuyHLkUGz7mviLySyBVeCo+X9MCYZ
         PCixqHISRciLf+3BBS/ARsiTOpB+k5BxvrndzbUdSOO711Etk4tgmmy60M6zNHXNTvO8
         QDlbkj/TCaeMf/oCkEHLmMD++0fLUXQIWXs9XF0lSpKOxMHRhqJog7Eex6S68HaBMehZ
         Xp4w==
X-Gm-Message-State: AOAM533MxslfC8Ga9DSwWyIqdpuAyF8ru08dAV3GXcKwuYEuqxjpHV8z
        vYDa/CFuGgC+af5BEKDJR2ACk+lLj1mNqFiLa0FiIBqCh3k=
X-Google-Smtp-Source: ABdhPJxgY+gRB3eOLIdsnEE62qAeXY9hPWGv3MHbsJ3OFChAsUE/DvuOZTTvnhQeMqJr1hgFi9OjN0hso9KLc2sy+6w=
X-Received: by 2002:a25:4cc5:: with SMTP id z188mr2451952yba.248.1639444751847;
 Mon, 13 Dec 2021 17:19:11 -0800 (PST)
MIME-Version: 1.0
References: <20211209182624.2316453-1-aaronlewis@google.com>
 <20211209182624.2316453-4-aaronlewis@google.com> <YbJx1iB9ZowrVcuF@google.com>
In-Reply-To: <YbJx1iB9ZowrVcuF@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 14 Dec 2021 01:19:00 +0000
Message-ID: <CAAAPnDH9ghcFid5_b-US6o0eMyLFSCBWXBASbV_PB92srzdO6A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Add test coverage for the routing
 logic when exceptions occur in L2
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Having a gigantic asm blob is also unnecessary.  #GP can be generated with a
> non-canonical access purely in C.  Ditto for #AC though that may or may not be
> more readable.  #DE probably requires assembly to avoid compiler intervention.

For #AC I'd prefer to leave this in ASM.  To get this to work in C I
had to trick the compiler to not optimize the code away and when I was
playing with it in compiler explorer clang seemed to outsmart my
unaligning access with an aligned one which defeated the purpose.  It
seems more reliable for what I want to leave it in ASM.

> #UD and #BP should be short and sweet.  E.g.
>
> It should be fairly straightforward to create a framework to handle running each
> test, a la the vmx_tests array.  E.g. something like the below (completely untested).
> This way there's no need to skip instructions, thus no need for a exposing a bunch
