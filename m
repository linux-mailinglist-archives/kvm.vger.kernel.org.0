Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCB67AE57
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 18:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfG3QrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 12:47:03 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44213 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbfG3QrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 12:47:03 -0400
Received: by mail-ot1-f66.google.com with SMTP id b7so16832173otl.11
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 09:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUkRSKmD93EEaLhM8tNdzGVabn/OtuV4nTMemeBGWHA=;
        b=V5/Z5B2nzOXRzWeTVqCQ55MDNnGl2HBP/bmAySM+cRNa4/YEL249lTHRJtrMJ50oNR
         Svp3FBDGvcg1/d33ohc9PU3ZeKC2GaYBlYcZmTExS6rCcMpx/ClkjUkQg48AIwNcJI9I
         7SVk+g4H8EOmUdtHNOLsenD4OdTxNZQKLE4TZCVlwlcaGH3F343TRVAZH6YqDk+En/by
         YyZ49xNI45na6CfxkJrOQiQRHbOSvLqCQO7HgqQ4bKb0l0mhWzA4K0YCPBE//BAQ3McB
         PWsrL+VpOG8jlo4Md8AX+fbdb2ZAogEvbmeJSL2Rwzwy9w2JUh/CEUAd4yBA1Y+hW9zw
         YbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUkRSKmD93EEaLhM8tNdzGVabn/OtuV4nTMemeBGWHA=;
        b=OULy5Au4y1erCmozBZbUalQfH7tC3buzOT/uyAGLYeKcNlDvdD2qpjVIqSfdFC3nK5
         FR358sWnzxfsartqAvnCqE0JLMJAnRsd4pKcvjxOCMrbJpKP2b6qqIX8LSaXWB8GH9HR
         U8/dUlFWOYZpg7UzIwrbLezIFcYJLlzivYHRZanTIdQeZZ7P6fMWc+ONS/JLLTvnJN1W
         yN8NHeDdcxCxTB5yEj/YyTUGEUpyshYmQE7mgEjm8r1b5bpwPJPrUbdMQSmgfKrTJjon
         IKIBO6S0INTowZkh1a0bUcHi9L2lVvlfaCzMzoPuOuFn4EgbNm8hzmxKLpCEmVXEcL8d
         tDhg==
X-Gm-Message-State: APjAAAXGCZ//J3hqh1hLRz2G8NTcHoyfY7VZgSM4uPv+L5WsB34PpXr5
        gwCj/C4ZVmuB7nWdVx0gw5SjPRH9yDY5X4R5QQufoA==
X-Google-Smtp-Source: APXvYqyWW4S8ROi5zSb2O8UjWKsqQufpGz3Z+VohcQPodGtBNPBYt/C4m+kskBsFObP65wB6ekYyoLuC4mMlqVEv22M=
X-Received: by 2002:a9d:711e:: with SMTP id n30mr80997084otj.97.1564505222637;
 Tue, 30 Jul 2019 09:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
In-Reply-To: <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 30 Jul 2019 17:46:51 +0100
Message-ID: <CAFEAcA_M7kTA-tmdNdP4-pVjKkdzHFXuSeR3wKYSohK+W38m+Q@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH 3/3] i386/kvm: initialize struct at full
 before ioctl call
To:     Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Qemu-block <qemu-block@nongnu.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Alberto Garcia <berto@igalia.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Jul 2019 at 17:05, Andrey Shinkevich
<andrey.shinkevich@virtuozzo.com> wrote:
>
> Not the whole structure is initialized before passing it to the KVM.
> Reduce the number of Valgrind reports.
>
> Signed-off-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>

Does it even make sense to try to valgrind a KVM-enabled run
of QEMU? As soon as we run the guest it will make modifications
to memory which Valgrind can't track; and I don't think
Valgrind supports the KVM_RUN ioctl anyway...

thanks
-- PMM
