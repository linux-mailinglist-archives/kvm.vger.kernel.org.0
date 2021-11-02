Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E720E4436E3
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 21:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhKBUEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 16:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhKBUEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 16:04:34 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F210C061203
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 13:01:59 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id g3so103394ljm.8
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 13:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BDslnEzmaYl8XemO8H14C3E5c69KKbu6q3LyWC8hs6c=;
        b=Y27DdbKfhZ9/em7rMZL3gynod2fwnh07kZ/RrJMtHRxIkaacuz/t1gWiIlisWzp66P
         0vy3sU9WnqbGhx5odG2aKcwRyOfePyWlTLndkiWKaDlR2hoamDr2VC6rHkxfOtWpuP+Z
         ziv8The/TmmcLSQp4curc6nXf41+Kb5ZcCP4bOpkUWs8/1LWyxEvLyTfIx8L7cKL7xWh
         95rhU0KD2PlzngyxJiEn+D1lI+/dUUk91seFcdbdceB/C+WrwBIvN2lncT+KH+Ur9yqe
         rI1OKChd+w93QeyfYRhCaM+RJyUnXCkYukVxTqjjHT/WxI8HhfI7xw38Z7Mw4UX/+a9v
         0vQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BDslnEzmaYl8XemO8H14C3E5c69KKbu6q3LyWC8hs6c=;
        b=1VC4NwgG1SV/zHmBHGyCli32DC0EY/wq6aRhaz1zDPMPlI0cbJxOnthuw9pxnLHkk5
         lY+lpENLEHGIP8Yw++yUOoJObDEFOt62TNXgAtVCdCh5O/FCQFbj+CHy+De4/+MDtUqU
         rPJrYnXST/SB7VucL/74IRsf5cM1JdHF9kVfHhsfE1CDXzVXtXtHCNN54wDGkck4IyH8
         ENu6LshW/TcCiwAA1RsgcPAGbcUfhMg6H7huM+fuNQQhE4Qt9LpCIGjiE7mnI3rYS68P
         4MINxu6GucW/SChW9LK8gFv1nrQVcw0zubEp4VGwG4nX65Z1xxiX1Sy9Xp/nCcmm30W6
         3RQA==
X-Gm-Message-State: AOAM532Eaiw+ZHrsUoRUrTITViZyOIytzyXz0UaMg2HYWL4XxFH2Ck5b
        p4qlUgdR5xGzBUSxmZKHbDT/8wxUmc2sVYF5sgEjyA==
X-Google-Smtp-Source: ABdhPJxwGH/Xjrm74EIMk3UQCQLZsG2pEJnnfrQ2FDpM1CoFNZIbHEdfny5vZ0lVDpSfXmbDZCATT/vApVIzPh/Vpzo=
X-Received: by 2002:a05:651c:1051:: with SMTP id x17mr38505200ljm.337.1635883317514;
 Tue, 02 Nov 2021 13:01:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com> <20211102094651.2071532-7-oupton@google.com>
 <875ytaak5q.wl-maz@kernel.org> <CAOQ_Qsgc7aA89OMBZTqYykbdKLypBhra0FNQZRPTEHpcaaqyhw@mail.gmail.com>
In-Reply-To: <CAOQ_Qsgc7aA89OMBZTqYykbdKLypBhra0FNQZRPTEHpcaaqyhw@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 2 Nov 2021 13:01:46 -0700
Message-ID: <CAOQ_Qsj1rjL5RgkgEL+Bkp9OY6i51VaQetBfppYVF1XLq92rXQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] selftests: KVM: Test OS lock behavior
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 2, 2021 at 7:53 AM Oliver Upton <oupton@google.com> wrote:
> >
> > I haven't had a change to properly review the series, but this one
> > definitely caught my eye. My expectations are that BRK is *not*
> > affected by the OS Lock. The ARMv8 ARM goes as far as saying:
> >
> > <quote>
> > Breakpoint Instruction exceptions are enabled regardless of the state
> > of the OS Lock and the OS Double Lock.
> > </quote>
> >
> > as well as:
> >
> > <quote>
> > There is no enable control for Breakpoint Instruction exceptions. They
> > are always enabled, and cannot be masked.
> > </quote>
>
> /facepalm I had thought I read "Breakpoint Instruction exceptions" in
> the list on D2.5 "The effect of powerdown on debug exceptions",
> although on second read I most definitely did not. And if I had read
> the bottom of the section, I'd of seen one of the quotes.
>
> > I wonder how your test succeeds, though.
>
> Probably because the expectations I wrote match the non-architected
> behavior I implemented :-)

Alright, gave the series a good once over after this and fixed up
quite a few things. Unless you're ready for it, I'll hold back for a
bit to avoid spamming inboxes. As an FYI, here's the fixes I have
queued up:

v2 -> v3:
- Stop trapping debug exceptions when the OS Lock is enabled, as it
   does *not* block software breakpoint exceptions (Marc)
 - Trap accesses to debug registers if the OS Lock is enabled to prevent
   the guest from wiping out KVM's configuration of MDSCR_EL1
 - Update the debug-exceptions test to expect a software breakpoint
   exception even when the OS Lock is enabled.

--
Thanks,
Oliver
