Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7343B361459
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 23:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbhDOVup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 17:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236247AbhDOVuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 17:50:44 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C23C061756
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 14:50:19 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id i16-20020a9d68d00000b0290286edfdfe9eso13351873oto.3
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 14:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a4DOTBbYEKnT3EnjXiuFlp4qBusHe05Bi/ZftDfP8iI=;
        b=TMs3OTkoZpQrTMVqb9siJB81H/SU2Cyvmxywxt+jCDPZDntfBjWKju8NkqmM8LRauy
         7mq11Y1DF+8t6GO9EJC+OGSDXGMUeqskaGEMsoKZ0I5NalIf7Qsy/iv+gnuqcmMky26s
         NTye3gCqGBfPMNKocHfwkpOjNG89fZAqmgetBwfa7qQl6fSG4GdjcxE88FBVK1/Km184
         V2sZDVXWA5Dee3wZCXJhrJ0ZlqT5QMojlOGgcw2doeM2TazMY8pATAAPACTotEnQ9YIR
         m7O7rRVYVg6Y+hoytZiy9Ziuy003oMK+rxUyvxR5aIdn1xBrr4KXXmsfEmR128k6Vw8T
         3yXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a4DOTBbYEKnT3EnjXiuFlp4qBusHe05Bi/ZftDfP8iI=;
        b=uiuzd1bsTKnb0uc602gWaakqwwESK4EHwPNx55mBGKA6902s9rInnokExzqMn5jNdG
         m4ot7dAgQY1u9Ma0kQoqYF5o2kyql9UuWi6m+PuPD7hMT7SdXDihuvQ9L8iXQ3Vn/2Ya
         Q/Hp/257bB6rzFFxFOihIiU3puC2fbLVXcD5DUPuYiDGhO3oYoAHtkel0rwLcdQTQfxB
         w8GhvvdNqfvRXOeyX5D+/zFuxt5p+i8gqqN9FC1GcE0pugIAsScPmcrtKI9+GuSumNRq
         1DweG8HQIxKupVpo2zLUsZpluupsmSPLNcTAN2gqXtG6cMdYb3X+sfHo3QODTHBtisNO
         UJxA==
X-Gm-Message-State: AOAM531GgzkIXcZ6GZNLYyolgG1lEhr1nYQ8sPYXP0Awl7Hbptgp34sQ
        kt95610LrcGQz32CybGWbu1j5HS83XqsoqDLeZkkmA==
X-Google-Smtp-Source: ABdhPJwArKObs6KeZLmWKpYAJZakPx4EL1VEG6f5D8lDks543GYniDSSnRM6fFDXWgTL3A8vp0CsV2Ay1/oPYxpMers=
X-Received: by 2002:a9d:2f29:: with SMTP id h38mr1039188otb.241.1618523418458;
 Thu, 15 Apr 2021 14:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210412222050.876100-1-seanjc@google.com> <20210412222050.876100-2-seanjc@google.com>
In-Reply-To: <20210412222050.876100-2-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 15 Apr 2021 14:50:07 -0700
Message-ID: <CALMp9eT_pXwZZFGywhp3FQHESKC9LVncuJDDWRcYr=fLB=OTng@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: Destroy I/O bus devices on unregister failure
 _after_ sync'ing SRCU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hao Sun <sunhao.th@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 3:21 PM Sean Christopherson <seanjc@google.com> wrote:
>
> If allocating a new instance of an I/O bus fails when unregistering a
> device, wait to destroy the device until after all readers are guaranteed
> to see the new null bus.  Destroying devices before the bus is nullified
> could lead to use-after-free since readers expect the devices on their
> reference of the bus to remain valid.
>
> Fixes: f65886606c2d ("KVM: fix memory leak in kvm_io_bus_unregister_dev()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
