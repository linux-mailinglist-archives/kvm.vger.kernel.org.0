Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B321DD241
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 17:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgEUPpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 11:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgEUPpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 11:45:55 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14C7C061A0E
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 08:45:54 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id p123so1522766oop.12
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 08:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8h1ZPoBxJvuQvx2ziXpdx/NQiUgWmqZ1hoQbkwoXnSQ=;
        b=SlQZLiB4OFUSMtrURCnULNta22198oi+Z5RQAyBqo38LQk9Wha8N10/YPkuBWPYcSV
         v0dSGU9HBPNNIrm+eyaZTbxOTlAN/5UVuXo/cRYgucmP/HGV5nChW+Q00R9WpbIoCX6x
         PnDtVFdl4tD0EDId0iZ4Y8lp9MVazgA3g1/JGyZzN5QoT2KYF2uaj3bXRr4B5IhSI9Ix
         A+ZRl1caqAKOoRzSsN2cMlYXlQA5F+VlGNFj5+2ufUKqgS/NXx0aew8IzlZBikCPtrD5
         bMgxLoeMq5bcK8G35nZBb9ubrSzNanS+gwpQBB9ZWi77//UAfqBJZd82VOxRt5ykYr9O
         2Ozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8h1ZPoBxJvuQvx2ziXpdx/NQiUgWmqZ1hoQbkwoXnSQ=;
        b=Km85YAtIGK5lxf81rCBs+ejWMZRz2SnGJtYzoxnw68QMZ8+tYfA9vmeOtaEZrZblcx
         94xwb4nXVsNQ5h4RHPin0gusf1E0kj0peKX1lhlo/uN+hmKYB1FQ23Ut5wOvYfwBSfJo
         SZoLuHQIbbdPUrGRpSzakzehJkbIG/cJAFrbPksIVmWK2m2XhiXAl2NBoLQUOFhF3fkx
         xQReVyPx4I4RZikncYVOmoujtoNrUhHtYNchXwBO3jjCOezxSMMYrn1HFmtAluiaXNZI
         8Opi7IH97L3JnBJl4cGUWzVmFdH6BCcO0kf/Zb/Bx7XmQSqetAKt5ExfG5w64atghNug
         nbmg==
X-Gm-Message-State: AOAM532bfOhBxUao/u6fIwFzLClsw1iOQwJNRY2dcSXdsvJmb27Qp29i
        gjaSiHjE9zET0jw14Nm7aLgRWJxCCnCPg9ZcfbcdFQ==
X-Google-Smtp-Source: ABdhPJw5xr8eYxO7RpfOFZCX1bJlGCyf6NovnXN5CNJ3JraeuvE/zpszL7WYd8lUI2xweMQ38hKNv6LHhQvcl3d9SF0=
X-Received: by 2002:a4a:8253:: with SMTP id t19mr7809624oog.69.1590075954348;
 Thu, 21 May 2020 08:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200518155308.15851-1-f4bug@amsat.org> <20200518155308.15851-7-f4bug@amsat.org>
 <CAFEAcA8tGgyYgHXT5LVGz675JMq6VWR56H++XO5gtTrcaZiDQQ@mail.gmail.com> <0c0cbdc0-a809-b80b-ade3-9bdc6f95b1a8@redhat.com>
In-Reply-To: <0c0cbdc0-a809-b80b-ade3-9bdc6f95b1a8@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 21 May 2020 16:45:43 +0100
Message-ID: <CAFEAcA_WOEeV53yr7SmWqyOnbfWYg3COr-C+mjaCuAPw=refcQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 6/7] accel/kvm: Let KVM_EXIT_MMIO return error
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 May 2020 at 16:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 18/05/20 18:01, Peter Maydell wrote:
> > The "right" answer is that the kernel should enhance the KVM_EXIT_MMIO
> > API to allow userspace to say "sorry, you got a bus error on that
> > memory access the guest just tried" (which the kernel then has to
> > turn into an appropriate guest exception, or ignore, depending on
> > what the architecture requires.) You don't want to set ret to
> > non-zero here, because that will cause us to VM_STOP, and I
> > suspect that x86 at least is relying on the implict RAZ/WI
> > behaviour it currently gets.
>
> Yes, it is.  It may even be already possible to inject the right
> exception (on ARM) through KVM_SET_VCPU_EVENTS or something like that, too.

Yeah, in theory we could deliver an exception from userspace
by updating all the register state, but I think the kernel really
ought to do it both (a) because it's just a neater API to do it
that way round and (b) because the kernel is the one that has
the info about the faulting insn that it might need for things
like setting up a syndrome register value.

thanks
-- PMM
