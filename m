Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795C135E6A4
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347697AbhDMSq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346394AbhDMSq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 14:46:26 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB2EC061574
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:46:05 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id n2so27546658ejy.7
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BMGgkIUNC5wWSbI0C1p7AMY+wrQiOl3v5uY4HYbC/nA=;
        b=mRHHof94dBTjnv2kql1qxtKewllGuJC7CJTPW+gffF3hjEG/vYqShSSh9lDYIGDTZW
         +2f5H5GYi9BMd979sRs2hichgCR1CFTVXFx13NO7FvDVI1Kp44mYBorL/ls0WUNneyyB
         /JTqivyXzzjZJpZ4llQutwzxtvBSsTvz4bB3cPR+5JNtBakN5/VYtzIvJdaEBUethCfG
         0bGzPtJhwx5x3rsBUsU7MaC+/gPylvCadXuMIBW3DaK/KN5FffKAyDdlMyUcpNVBXuQ7
         DjYoNZT+Jj4RHjC8Bt37cCXI9UPgPC0qZ9/z4htSGHq1+v/huhtfkdApmWjZxdcIOxk1
         DnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BMGgkIUNC5wWSbI0C1p7AMY+wrQiOl3v5uY4HYbC/nA=;
        b=gMOX+6TCDIwob9pIypAaaQruxyEFACX3SKukKoDIGAbsBRen1mN/ExdbJFNz9IxJhs
         /tY8nWctjGuRMssklA68wHqmwO0q8lT6wXRS5LG7/f/T+E7yDp2LIqnFC2C/0O6pUy3B
         /y5pbxnjVY3EaL11F3NqMtm1qPW7MrISprHqPUfpWwaYSJyO1yOsMGNRN4CtsbJoIkEq
         LClg6UsPWqAEO+NYhuUyGZGW40Qlg+q/lQRDmMGfa/hyEkoP0AqosliVA81ErZFTC01D
         MppuFgvwnPzPKgEG2EmuKV//LY3K+ahiCF1ItjwyRDZ2fQQApExYgqHeoXIF2mybWMvf
         UNCg==
X-Gm-Message-State: AOAM533gQy+4BljRwvM0Wsfhuias9SRELLM6t/CUl3xRKcP0VE6xRhCG
        njrj//+h1MPA1E+aGZcBCYtyJSQe7Am+l2s6x63/z/Jo+u8=
X-Google-Smtp-Source: ABdhPJwOAKdwimwdXmyd9YZC1Lo2ZFNJZlqxhMHcPG2WDWSOeFiYrvVfHRaqwggt18Drl/Opi1c9PgTsxhMlYzmPg5Q=
X-Received: by 2002:a17:906:48c4:: with SMTP id d4mr14395692ejt.548.1618339563693;
 Tue, 13 Apr 2021 11:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210412130938.68178-1-david.edmondson@oracle.com>
 <20210412130938.68178-6-david.edmondson@oracle.com> <YHRvchkUSIeU8tRR@google.com>
 <cuno8eisbf9.fsf@oracle.com>
In-Reply-To: <cuno8eisbf9.fsf@oracle.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 13 Apr 2021 11:45:52 -0700
Message-ID: <CAAAPnDGy2MZF2QVTTdNQgQC3Sh9mOjJx-cetn2nZ4cu6-h1Zvg@mail.gmail.com>
Subject: Re: [PATCH 5/6] KVM: SVM: pass a proper reason in kvm_emulate_instruction()
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>
> > Depending on what you're trying to do with the info, maybe there's a better
> > option.  E.g. Aaron is working on a series that includes passing pass the code
> > stream (instruction bytes) to userspace on emulation failure, though I'm not
> > sure if he's planning on providing the VM-Exit reason.
>
> Having the instruction stream will be good.
>
> Aaron: do you have anything to share now? In what time frame do you
> think you might submit patches?

I should be able to have something out later this week.  There is no
exit reason as Sean indicated, so if that's important it will have to
be reworked afterwards.  For struct internal in kvm_run I use data[0]
for flags to indicate what's contained in the rest of it, I use
data[1] as the instruction size, and I use data[2,3] to store the
instruction bytes.  Hope that helps.

>
> I'm happy to re-work this to make the exit reason available, if that's
> the appropriate direction.
>
> dme.
> --
> And you're standing here beside me, I love the passing of time.
