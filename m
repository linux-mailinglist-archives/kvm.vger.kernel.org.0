Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9179635DCC9
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 12:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343964AbhDMKto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 06:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343968AbhDMKsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 06:48:52 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A610C061756
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 03:48:29 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id c6-20020a4aacc60000b02901e6260b12e2so1215464oon.3
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 03:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yxLJ4jx8zwDk/l6JxSedZpECocVz8godYHUHDpr6FEA=;
        b=RENUxgHAdiSY76wYt4rOshQmzTHere3sPQ5GTz5/bulLKvJbyQmdA3CRegxOjjVv9/
         54U0GoEyUibq3V1RI5RxChEL5w/Qnm37BdG3DIaWcxL4d7jzRkORs9V2ZMNZA1Toa4jw
         h2XSHxiih4HD7oDxISlhVBhLrMXX6Tji6XdjKQ/eDkCQ1ictH1WPSOCBa37hp2yXAq1L
         Nvj4pPVYZo8l6wWP54fwWlYx04Onn7nRS6YwVlu4Tb1wKbkYlaf5D0DEXwizY11nqOoj
         SUlfMPshSNyMt5jFr5oPQmey0A0joR76RSGBY3jAYGZlMqSkjzRoqlsnCajyezCvm8ue
         2VPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yxLJ4jx8zwDk/l6JxSedZpECocVz8godYHUHDpr6FEA=;
        b=L8SQsRjf/yu3fRiSSw0iVTz6dIU7lGB9rdvW5K/1eL2yV5DiLWY/x55oEkR67eEf+I
         YdQVc36MnlZzv8gfTZBLrBXPHD8LGW79RYaTyJVY07cuAPx6y2JPOtFnDlw7rEohHfia
         RrSGLizzp3zbog8t6+hw0bapmmxoLTCOLI2obiBFGdsUXmfbj6LhlOm4b2FdjBNQxK6M
         v9x7jR7u4uWlif2iIh9FcdpctaOy6t4oKbsbU72lu6T3BFMsWbLaW0do5HLXFYbL3b4M
         BBhqiVfdOyF7vWl2cHP+6su/omLDXK9hEP+/ioaOI4LVxEgIw7YF7xnOGYqpmUWzyxCy
         CMgQ==
X-Gm-Message-State: AOAM531b1w5TDrCxKlmkxOKReuFQlsA3h0+ldgKOeDyXh76rYfw6VbPO
        fwrQ3ZBMWKmjpSXlWxG3ykeN3CXM7m/BwbRI0s4=
X-Google-Smtp-Source: ABdhPJwvMJbyzQjQhXqYPrCYTGKf70zatUrhdhepuSnzn+uhQzUd3m0nXe/dXVKuIIvIPGKMVSpttbAOkiPQEbFq4sk=
X-Received: by 2002:a4a:e615:: with SMTP id f21mr4324558oot.41.1618310907968;
 Tue, 13 Apr 2021 03:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <36088364-0b3d-d492-0aa4-59ea8f1d1632@msgid.tls.msk.ru>
In-Reply-To: <36088364-0b3d-d492-0aa4-59ea8f1d1632@msgid.tls.msk.ru>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 13 Apr 2021 18:48:15 +0800
Message-ID: <CANRm+CyMpNS2OAC8CKGb9HUQe3v180e6gHOZYmVZ8gw=XQKYKw@mail.gmail.com>
Subject: Re: Commit "x86/kvm: Move context tracking where it belongs" broke
 guest time accounting
To:     Michael Tokarev <mjt@tls.msk.ru>
Cc:     kvm <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Apr 2021 at 18:55, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> Hi!
>
> It looks like this commit:
>
> commit 87fa7f3e98a1310ef1ac1900e7ee7f9610a038bc
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Jul 8 21:51:54 2020 +0200
>
>      x86/kvm: Move context tracking where it belongs
>
>      Context tracking for KVM happens way too early in the vcpu_run()
>      code. Anything after guest_enter_irqoff() and before guest_exit_irqoff()
>      cannot use RCU and should also be not instrumented.
>
>      The current way of doing this covers way too much code. Move it closer to
>      the actual vmenter/exit code.
>
> broke kvm guest cpu time accounting - after this commit, when running
> qemu-system-x86_64 -enable-kvm, the guest time (in /proc/stat and
> elsewhere) is always 0.
>
> I dunno why it happened, but it happened, and all kernels after 5.9
> are affected by this.
>
> This commit is found in a (painful) git bisect between kernel 5.8 and 5.10.

Hi Michael,

Please have a try.
https://lore.kernel.org/kvm/1618298169-3831-1-git-send-email-wanpengli@tencent.com/

    Wanpeng
