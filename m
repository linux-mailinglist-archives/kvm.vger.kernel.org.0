Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB15B436FD5
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 04:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhJVCNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 22:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbhJVCNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 22:13:30 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6079CC061764;
        Thu, 21 Oct 2021 19:11:13 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id y67so3420652iof.10;
        Thu, 21 Oct 2021 19:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kd9RbEF+r4Kt9Rh7US30RNyY/dvqExss0dHw6wQ+3eU=;
        b=SMfmKCyikObqIIuzB27Kwn8Jh1DdlqOFAkhgQHaHz6wKGqqKo5guO9XZtrAjcTK3Vd
         hdonnFXpUBOROaKPQSkvrsWdg14UJ+In7vpXKD1SUf5lgGV+l8qakkuwEWMxcvltJWdB
         yVwBOHuVZqXwlir+Ii8XtwKl+z+sry6mBBGBT6RHjyJFxs6YRezflsf2jtUKiKJZyuPe
         8fOR7YGXjP+2rN1uODV4xHzki9qr/7oddY5ZHBLX+P4gJcY7dle/rTjZoyb7B+fekVwc
         6Q1XQVnWrCEkuOSRp3kklM7B87fcrULw+W+HnpM+r0kXzpXxh/L2dwq5nHLjB6E6L5tY
         W78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kd9RbEF+r4Kt9Rh7US30RNyY/dvqExss0dHw6wQ+3eU=;
        b=xWkf45o7/i8XZX332jQ2LLPBR/hXmx8iLS35D7DSCJ9cl1cm47BItktd1TiBFqqms/
         Z9RCo0s42HPhhGPXCh6NuqG4olHCS51jF+xu8gIKoYoe9Z/fm0+F/yxXegyNuGDQML7m
         UUVtLUYi7mO+uxrD+puH9wbrU11yBEvi/PgGwjWJoqAwDeDaV6ljkonHwV8nxsVodYYu
         +RpJj9sD/kkppEbiHmYo3PDKJ4srC7SGc+U4be0gzrDzRXYZgPeiebdSEptYfetTAbum
         L2sb+sfF7mrBHSpOJIUTuSUKdQG2omTeveULpCW4Nf5Ak1LTP6+H8urDv07RCXw8+NRW
         dNIg==
X-Gm-Message-State: AOAM532+NvRlMwbrq2qyNnPB52xFj4NJ6VQIXX3exsbUQNznF1vWwOQP
        BBi7U+LMkNxpL13x65a6+YJBY+9hEPjNfHCZg2Y=
X-Google-Smtp-Source: ABdhPJxO6pgSGdaqWl1bzepX2vJyc/rCZbhazUgbXO7YQQupDcjqgkeCxGpPChA+keFXb3IrIfky64xSVe+xBNHuB3E=
X-Received: by 2002:a5d:80d6:: with SMTP id h22mr3211325ior.152.1634868672251;
 Thu, 21 Oct 2021 19:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211019110154.4091-1-jiangshanlai@gmail.com> <20211019110154.4091-3-jiangshanlai@gmail.com>
 <593cdae9-c49d-6977-24d5-191f723188d7@redhat.com>
In-Reply-To: <593cdae9-c49d-6977-24d5-191f723188d7@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 22 Oct 2021 10:11:01 +0800
Message-ID: <CAJhGHyA-L9HTidmPt4nz=KbYySuEU1hkBdZPaznwUPp008HBFg@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: X86: Cache CR3 in prev_roots when PCID is disabled
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 22, 2021 at 1:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:

>
>           * If CR4.PCIDE is changed 1 -> 0, the guest TLB must be flushed.
>           * If CR4.PCIDE is changed 0 -> 1, there is no need to flush the TLB
>           * according to the SDM; however, stale prev_roots could be reused
>           * reused incorrectly by MOV to CR3 with NOFLUSH=1, so we free them
>           * all.  KVM_REQ_MMU_RELOAD is fit for the both cases; it
>           * is slow, but changing CR4.PCIDE is a rare case.
>

There is a double "reused" separated by "\".

>
>
> Can you confirm the above comments are accurate?
>

Yes, they are better and consistent with what I meant, only one redundant
"reused" in the comments.

thanks
Lai
