Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DB23707CE
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 18:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhEAQGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 May 2021 12:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhEAQGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 May 2021 12:06:06 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7565C06138B
        for <kvm@vger.kernel.org>; Sat,  1 May 2021 09:05:16 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id o16so1768120ljp.3
        for <kvm@vger.kernel.org>; Sat, 01 May 2021 09:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7nlYoQExVbXQhvC/EaGOIk1M5S2Uav+x5xdbORmDf5o=;
        b=XEwq9R1H0HQHrvXfOtBwmFEP/4cLHs/4p+ksTho0zU/9blcwQfdwK5hL9D2Fzcq8az
         EOQw+j65UGDc/TZyaKkUq96pjaSLUS/g+SStreW1U+h9AEsuMlL1Vq6MLI/+dFDlwqm5
         GJvv7frzqQ0MYxZDAzcJOI+MbEF2787l/ezlo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7nlYoQExVbXQhvC/EaGOIk1M5S2Uav+x5xdbORmDf5o=;
        b=m/UkD6E1jMRI/3qkD/BCB+rdbTfAWBPGm2maGWgJ5WNAmNzZZRmf7AfqSWQEWSPpAB
         IKPtL4cMbkzj37cLJPZz3gGT8X0GkndfjohkDnAQPOVkXej3d7lLeuFBhr3jdLOMLA6i
         DetV0IelCfyOTK3odPPz5sE9MwaTiUXM1/MvLslI5B2bUmnDuvRUQRFBNwxLDifSftiF
         PK/Z0iCGaoM3P26Xm7jvwSPBLa7Map6/hKjmXRTz4aLn5DeikLUtC+rwD21OHVOEyjJw
         EO+07rDYAJqTqYvVxSXvHW1HMhKpQkfazTIP4mYjF+LFSbwv5g/01fL4RElL06V63TPQ
         KLQQ==
X-Gm-Message-State: AOAM530Zn8+hAeHM2xjvQX7T2gl21RONQUj1TRacTaCH+Tmk+vJK59ev
        Vmut/0iyHp6f7lX63M5F1JyU8WbemHRW0nR2
X-Google-Smtp-Source: ABdhPJyCbXKkO8sMMQi4pxMGOJgYLynvtOETUXHrS5q6g13FIcnPSjI8g2r4guZeUAGsbr+NnL62eQ==
X-Received: by 2002:a05:651c:1306:: with SMTP id u6mr7705431lja.197.1619885115038;
        Sat, 01 May 2021 09:05:15 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id d25sm601214ljg.96.2021.05.01.09.05.09
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 May 2021 09:05:10 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id 12so1639400lfq.13
        for <kvm@vger.kernel.org>; Sat, 01 May 2021 09:05:09 -0700 (PDT)
X-Received: by 2002:ac2:5f97:: with SMTP id r23mr6990675lfe.377.1619885109537;
 Sat, 01 May 2021 09:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210428230528.189146-1-pbonzini@redhat.com> <61aa0633-d69c-f1b6-dc9f-6ca9442fbbab@redhat.com>
In-Reply-To: <61aa0633-d69c-f1b6-dc9f-6ca9442fbbab@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 1 May 2021 09:04:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjhLXDRdxfhzHS8bPOxtNQuQLVpepsytCzN=LPxJuejTg@mail.gmail.com>
Message-ID: <CAHk-=wjhLXDRdxfhzHS8bPOxtNQuQLVpepsytCzN=LPxJuejTg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM, AMD PSP and ARM CoreSight changes for 5.13 merge window
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 1, 2021 at 1:00 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> is there anything wrong with this pull request?

No, it's still in my pending queue, and in fact I'll get around to it
today. It's just that I've always had something else I wanted to look
at, and this was always "I'll get to it when my queue is emptier"".
And the queue never emptied (but today is the first time I don't have
a lot of new pull requests pending overnight, yay!)

             Linus
