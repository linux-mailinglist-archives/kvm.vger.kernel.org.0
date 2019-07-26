Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB7377381
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 23:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387459AbfGZVfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 17:35:44 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40438 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGZVfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 17:35:44 -0400
Received: by mail-lj1-f196.google.com with SMTP id m8so19203714lji.7
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2019 14:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cVmcZwFhu0VmRu42g2oqdHVRFxqVWleFTBghf3PdU0s=;
        b=auPaSao4Pu92MrHcL8ri0lwhHW+MxKtMjV1DpxAsA7pVZXiYOWxWxhMCN+yWqE/ApM
         N1RAQkb6zmoRJMBukop8ckoCwrxu+fdsXpdHaXZqjEngnR6ahHT+uJi/+bo3yEWp6UbC
         NE3E48fT2I4XCRhysWOc0g0KiUbHZXwqDqq8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cVmcZwFhu0VmRu42g2oqdHVRFxqVWleFTBghf3PdU0s=;
        b=oMpQhV35F9/RTGiSw+3CLk8d3lbXAXdvA1M6+oOM+4aYgoMpkkTHhUSL80JtOzEDOI
         Y/aiscxJkiix5M3yJBFPlrHf++t+uirxV2A9h6P5pXbyUEMyfiZZDTlKYCByK9wTkf0K
         nG2TMdcYRAyE1PsqSt815nmnS6vuLnbTDjSj1D7v4xCR+LQnY5Rjq+R02vuKNqK6f1gH
         Bh1RDtrOSWsw5VTjIjST8C7HOy+GT4Kzyz595CJTPf89UcbBFjTn+OGaYoBsPF72De4V
         R9GZf5mH4VHvAwQyqXn8R0F+jndeLfjspw8pEhslEncHOxHVdGl0/f1OtuFOrWES6jfV
         grEA==
X-Gm-Message-State: APjAAAVyRaERFd8pFZlKs48FStymKaM6M2KLV2PR1qHyyarCXZR/yF4x
        ZHqoyIV+6whWR08rzeDycjk/wOdbivU=
X-Google-Smtp-Source: APXvYqxSErCxiomzwfj9H7V2iZZ2E27JUXFfOk71pFyhHB4XG4LBJxiGtqNAIuqbmPBnTZBjMRJCXw==
X-Received: by 2002:a2e:8847:: with SMTP id z7mr51283546ljj.51.1564176942284;
        Fri, 26 Jul 2019 14:35:42 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id f10sm8674760lfh.82.2019.07.26.14.35.41
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 14:35:41 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id v18so52762716ljh.6
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2019 14:35:41 -0700 (PDT)
X-Received: by 2002:a2e:b003:: with SMTP id y3mr51555432ljk.72.1564176941127;
 Fri, 26 Jul 2019 14:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b4358f058e924c6d@google.com> <000000000000e87d14058e9728d7@google.com>
In-Reply-To: <000000000000e87d14058e9728d7@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 26 Jul 2019 14:35:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=whnM5+FBJuVoxXELvFgecuc0+vW7ibWy4Gc5qJbW8HL2Q@mail.gmail.com>
Message-ID: <CAHk-=whnM5+FBJuVoxXELvFgecuc0+vW7ibWy4Gc5qJbW8HL2Q@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in vhost_worker
To:     syzbot <syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com>
Cc:     Jason Wang <jasowang@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        michal.lkml@markovi.net, "Michael S. Tsirkin" <mst@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        virtualization@lists.linux-foundation.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 26, 2019 at 8:26 AM syzbot
<syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit 0ecfebd2b52404ae0c54a878c872bb93363ada36
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Jul 7 22:41:56 2019 +0000
>
>      Linux 5.2

That seems very unlikely. That commit literally just changes the
EXTRAVERSION part of the version string.

So even if something actually depended on the version number, even
that wouldn't have triggered any semantic change.

              Linus
