Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062E438F20C
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhEXRMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhEXRMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 13:12:16 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477F0C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 10:10:47 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id t22-20020a4ad0b60000b029020fe239e804so3698124oor.4
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 10:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A+CEnHoVhMFI7S/89O2vIMfE5DY0Ad1t+m9PmgMoGGs=;
        b=dWD4kcSZmiLJTwiAoL4BD/u0afuWitc/7bS9+2ryn1Xaj17+d+bzdcIjOGyUDqhKvz
         Dc3VGYxRg7A++q+umXQozDoKj+FY1cRJfnk65mJkoGlIRtIXKk7xqaglsVbofXL2dmyc
         4ISb9jM1oqHfssosm7uBv+4ARp3dCTU3Ikua6U/3EGflu4uQo22jGDJXHQ78MJwxS6Td
         Q3zIr3lTbJomf8EtjiZCkIXJcbpWDlFvsSyr8iDUwElfA7JIVBsEaX98ckiHhFiFirVQ
         jU1kDAmf11vicMDk1oLXRYGWqVolWO0y5yvp8PI7L/I1Ts99LBBGP2h5pd2tiGxqAiPh
         Pvww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A+CEnHoVhMFI7S/89O2vIMfE5DY0Ad1t+m9PmgMoGGs=;
        b=IOsI+Dp3rkwaz+YqcDVpyljNupCH8ltvtVDI4Sud6Eoi0K8pCEXJ77ehj4Mzmckrkd
         oIfYqMeT1f/IT6Bpgkl3AiD/XLu93UeVNt2NcZcE8PXHr7D9+4ih/t3A+GFEk/Qt1PwW
         +3oMM5KQlZNnzNTxLqI/t3eLI1XrsttWSChy3uU7DaFTWwetCmucIHd83RodwmQYaCMZ
         3KKw7Kha1zV8vjY118GS0DLrV6AoF4PE1i3hx0vOqgYCmObm63Z8oqF4SnL5qgYPGFx4
         j9YMxYZQyKZXZ3GYBjE5EHNd0nC4NezutImE77ROqzrwhhS1byaJyQG/3vDhtnEbNXzk
         HHYA==
X-Gm-Message-State: AOAM533vjTxKBIEa1940IjelV/nqjlzOWxQUJWI7nQsOIcjq4qP3Lwkl
        hVm3e6AjW4KC6DCW6eUGiTeoBKy9XQ5VkrUacQijgA==
X-Google-Smtp-Source: ABdhPJwEWvsiJOTv8VOetYtHytgMjPflZFU6jZmQvQ9qDrbcDRRSefz4b8gUvCEkPbaeThZcceFM/f5V+eTaa3Wc/H8=
X-Received: by 2002:a05:6820:100a:: with SMTP id v10mr18750741oor.55.1621876246130;
 Mon, 24 May 2021 10:10:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com> <20210520230339.267445-3-jmattson@google.com>
 <10d51d46-8b60-e147-c590-62a68f26f616@redhat.com> <CALMp9eQ0LQoesyRYA+PN=nzjLDVXjpNw6OxgupmL8vOgWqjiMA@mail.gmail.com>
 <e2ed4a75-e7d2-e391-0a19-5977bf087cdf@redhat.com>
In-Reply-To: <e2ed4a75-e7d2-e391-0a19-5977bf087cdf@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 May 2021 10:10:34 -0700
Message-ID: <CALMp9eR2JWQ380DEnv60tLh3p8Q01Hg3aZYY3LyOYHkDPeBsww@mail.gmail.com>
Subject: Re: [PATCH 02/12] KVM: x86: Wake up a vCPU when kvm_check_nested_events
 fails
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 9:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/05/21 18:39, Jim Mattson wrote:
> > Without this patch, the accompanying selftest never wakes up from HLT
> > in L2. If you can get the selftest to work without this patch, feel
> > free to drop it.
>
> Ok, that's a pretty good reason.  I'll try to debug it.
>
Note that it works (without this patch) if you change the HLT to an
infinite loop.
