Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3E636AB51
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 05:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhDZD7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Apr 2021 23:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhDZD7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Apr 2021 23:59:12 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AC8C061574;
        Sun, 25 Apr 2021 20:58:30 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id i9-20020a4ad0890000b02901efee2118aaso4412946oor.7;
        Sun, 25 Apr 2021 20:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pJcHx53fOQrfY4fDIgr3iDfc0pRFuBpk9u0pstUbVcA=;
        b=To8l842Eif8GnCvJUhRl/NcIAGlyF31OXHNcSyAAKMqRnTS9bOepC/WugSK4omsUyx
         YyoHe3n+D00f65VvXQ1ZdlCRJpQPqdmsq/4u5F+2fk6HJb6/Ut794+ki1Dme0GQcP3s4
         66yZ6VleZ1g62OCD1sKSdo0d8i1lT0viu+KhKV1nP5hZ5H7R13fOMvNkJuLkwrMj92wg
         QYfaiYtyCo2IF2yQ5f3o41wMNtMTzJjhoktM8pAfg9AnT6gIy0T3l+jC3QhTn2NHv9WH
         rvFy4yZvCmdjyhFTqVUTr1Bv2kjqWyXYZFU9gHGBj0CxrW2HrRbpKM3vupznZVz0n4d0
         dBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pJcHx53fOQrfY4fDIgr3iDfc0pRFuBpk9u0pstUbVcA=;
        b=P0kG7ld7znVYBXeAVJnCOnxeGOvRS2MkyHKjHFz6pt2H3qgfzuDVjuN6UhsLHbZjoX
         At7fTI2tb9kvp8bzRFGHHDxivhNoBdvmpzHCbsgojHR6qPeKlGp1MKh7/bEa72DF+wCw
         CSzCqYQqXHXVE1Zu/d/Ud+klNnz4XKFox+7Iv57ulclOJbeMK6I9Yml95nOaUU23Md77
         2beSRMGhjyLGOnAgedGVGuyR7ngE0wZR94E/BZGblP3RwDEk3tNdcvgJOZy1QT/EFM81
         V0CNfFybEkqdheFUTVcXXOfN2Lf1uaK81BE85Olx6yd+rD2FmUIDIFSD7BJx4L/pEuSO
         ahyw==
X-Gm-Message-State: AOAM533J8j/llukMgOyxhRsTMTqrR33oVAfp7MZY/Q83FkapKQLImwK/
        2kRossCA2LcPhRqtiHye9L7OS30Hl8InCxFMwtw=
X-Google-Smtp-Source: ABdhPJwnxeZ0SgSfHFTx1EFStdplwG8tZeVocaae5TYTE/2BLKUTnsZNtIqLYVW8CMNFhMto50be6DXeiLhhf48QSnU=
X-Received: by 2002:a4a:a223:: with SMTP id m35mr11588461ool.39.1619409509623;
 Sun, 25 Apr 2021 20:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <CANRm+CzoS=HhiHg6w6dy8P+r3POeP3uMZqFvJr4oHMa1aNJqxg@mail.gmail.com>
 <20210426031858.12003-1-kentaishiguro@sslab.ics.keio.ac.jp>
In-Reply-To: <20210426031858.12003-1-kentaishiguro@sslab.ics.keio.ac.jp>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 26 Apr 2021 11:58:19 +0800
Message-ID: <CANRm+Cz9GgQFDbbW_3bRO35FwvMGJ-ZFa0rSvEimxFzrvwmpJw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Mitigating Excessive Pause-Loop Exiting in
 VM-Agnostic KVM
To:     Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
Cc:     David Hildenbrand <david@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        =?UTF-8?B?5rKz6YeO5YGl5LqM?= <kono@sslab.ics.keio.ac.jp>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pierre-Louis Aublin <pl@sslab.ics.keio.ac.jp>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Apr 2021 at 11:19, Kenta Ishiguro
<kentaishiguro@sslab.ics.keio.ac.jp> wrote:
>
> Thank you for the reply.
>
> My question is about following scenario:
> 1. running vCPU receives IPI and the vCPU's ipi_received gets true
> 2. the vCPU responds to the IPI
> 3. the vCPU exits
> 4. the vCPU is preempted by KVM
> 5. the vCPU is boosted, but it has already responded to the IPI
> 6. the vCPU enters and the vCPU's ipi_received is cleaned
>
> In this case, I think the check of vcpu->preempted does not limit the candidate vCPUs.

Good point, you are right. However, actually I played with that code a
bit before, I have another version adding the vcpu->preempted checking
when marking IPI receiver, the score is not as good as expected.

    Wanpeng
