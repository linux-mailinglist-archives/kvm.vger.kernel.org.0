Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB485358DB5
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 21:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhDHTtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 15:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbhDHTtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 15:49:45 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276DDC061760
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 12:49:33 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id x3so2200321ilg.5
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 12:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4MJeTU3WuRBkKKtsj5Ms3W6HzeeajynnG1QeCk73SOE=;
        b=N9oiJDzqOjGQ5UpNhPjVvIGLy1KKOWgBLhjFdvLrnWWG0o1Nnd+4PQpFD9IbTmBR6A
         HlqX6Sqx0ktjRUo8LVLvgIU0YEEPcsDrYj+8YrcboZNPTlAsfvGm5arCDKvKYIohrKix
         CX4qBQbOI2W5MWa5/JBR0JN4u29M99faGiSsYipASocmTZk0RN2NLQicHozqjYLtQPvy
         8GBmDMSHd8iAH8ouqt7Qw1Fn+z5oqak4csX6xetG4bAorYN7N/SdJs3cm0YEpAYMr8qN
         ny0uK9s7SeWeq1ngm0n++FIJYXbyq93eI2OYTaK6YTAhXAo9mYBeSav7ymZkC+xFOku6
         LbkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4MJeTU3WuRBkKKtsj5Ms3W6HzeeajynnG1QeCk73SOE=;
        b=je9ksuKCElR/CmtQQFS8Xqt37AAf/bc81yFvEcshrc967XRTVLSvFP4aEpRAyQlAgd
         Gr6bcchwdFEA0cYQ3S5QzrmQhlch7a0gguf6Zbcw8VkYmRCiDRjSCEAuIYxUlVaK7M3O
         46DVT9E/5WlrZy9zrcGohmP9wcUhmFnby5dzrrTV4lep+zDd+YqP8zKXL1zykshh82jd
         bQ9CocS1G9fCRHgxhfl7zqJGklcJtri3Oh36/KWNqX7CTiiq1nuwJIWrnEn6qs4K/bXK
         PYd4zU8jkdl4gUPXqCjsfmVm+axE8wq66Q4X2+rjfVBAoGrZ0bZX9gIA//HvRaXq8Gi7
         s0vQ==
X-Gm-Message-State: AOAM532pIZi1pxRNUsJfBs2d6h8qhEvLs/UrIwSeGSdf71vts7yTBwUh
        nvyJ6IXFA6RG3lITiwIyxOZzZGI/NoMu2mQVQ4msPg==
X-Google-Smtp-Source: ABdhPJwV7qOv33+/6Wp+7n9Ua++B3dsgN01+bpslZXBMXHSvOTsm2jR5D56u4sMvxwyywDKuBc2OWkGv9qrfF69YG+c=
X-Received: by 2002:a05:6e02:1c07:: with SMTP id l7mr1479464ilh.110.1617911372379;
 Thu, 08 Apr 2021 12:49:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210316014027.3116119-1-natet@google.com> <20210402115813.GB17630@ashkalra_ubuntu_server>
 <87bdd3a6-f5eb-91e4-9442-97dfef231640@redhat.com> <936fa1e7755687981bdbc3bad9ecf2354c748381.camel@linux.ibm.com>
In-Reply-To: <936fa1e7755687981bdbc3bad9ecf2354c748381.camel@linux.ibm.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 8 Apr 2021 12:48:56 -0700
Message-ID: <CABayD+cBdOMzy7g6X4W-M8ssMpbpDGxFA5o-Nc5CmWi-aeCArQ@mail.gmail.com>
Subject: Re: [RFC v2] KVM: x86: Support KVM VMs sharing SEV context
To:     jejb@linux.ibm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Nathan Tempelman <natet@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        dovmurik@linux.vnet.ibm.com, lersek@redhat.com, frankeh@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 8, 2021 at 10:43 AM James Bottomley <jejb@linux.ibm.com> wrote:
>
> On Fri, 2021-04-02 at 16:20 +0200, Paolo Bonzini wrote:
> > On 02/04/21 13:58, Ashish Kalra wrote:
> > > Hi Nathan,
> > >
> > > Will you be posting a corresponding Qemu patch for this ?
> >
> > Hi Ashish,
> >
> > as far as I know IBM is working on QEMU patches for guest-based
> > migration helpers.
>
> Yes, that's right, we'll take on this part.
>
> > However, it would be nice to collaborate on the low-level (SEC/PEI)
> > firmware patches to detect whether a CPU is part of the primary VM
> > or the mirror.  If Google has any OVMF patches already done for that,
> > it would be great to combine it with IBM's SEV migration code and
> > merge it into upstream OVMF.
>
> We've reached the stage with our prototyping where not having the OVMF
> support is blocking us from working on QEMU.  If we're going to have to
> reinvent the wheel in OVMF because Google is unwilling to publish the
> patches, can you at least give some hints about how you did it?
>
> Thanks,
>
> James

Hey James,
It's not strictly necessary to modify OVMF to make SEV VMs live
migrate. If we were to modify OVMF, we would contribute those changes
upstream.

Thanks,
Steve
