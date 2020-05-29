Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441751E8C5C
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 01:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgE2XxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 19:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728581AbgE2XxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 19:53:20 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D489C03E969
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 16:53:19 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id b6so1358732ljj.1
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 16:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ICQtGJtrHJozomkdHTEOkutnUdLdZAowcRpo4XmM9/g=;
        b=BKeekuZS2zieYlq8mdCl6fz+pBpw9xzAhVyL+t5zKZaRWVqur00axzXw7v4sCNC5hv
         /1qWi5dvtrM55OwtMCQDzQrBrRFVZyYWsemIazEDWdf1hT4pNTGgP4ShCOvtAVfGGELX
         29aIJ+f8wXXFr8dj738yQ8rtoM6Aj7PLxA5II=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ICQtGJtrHJozomkdHTEOkutnUdLdZAowcRpo4XmM9/g=;
        b=HhAEV2afErM5PztzsFAzNx/yFPEf874KCflqzPvbmQgIg1/mGkVMygtOwuwZEcqJY+
         WUE2MxzCUldUOCQQr9WUKthSQ/4b9jXpTSDD3Fde6+RQkb01aS5i8OShZjtlI5crBtUz
         VwZCHkMdU3cTJ8hslzzqsgfeDDNts3977fWBMF1k/3rnPZnA5VYMUIKY4X2J8UcRod6X
         6yNkbj3BtVkOu6eCv91XNv9+nxlx5ZOSo1vQSZK9SSN6doniL+Rc5za3oAxRMAJORd4+
         RJv8aTbX4YZKx6csL6cwvOL+qKyfyo7wmDd8rhf233EKogAEeyGVSrRfvrCS3es0tm+D
         sE0g==
X-Gm-Message-State: AOAM5327PHRzBAs0vBREfnJUV+KuygiCrB9aXc5BdoodDrt3OcUIB/7Q
        Q148AJvmSl7LNL1EfAUa8aAeQdvER3Y=
X-Google-Smtp-Source: ABdhPJytjKk+AfuwHJGLWgiVgBodLbOkK8I43CggMggvJzmCpJJwpxa8In7Nj1DCTGpU/0AXYjzT8A==
X-Received: by 2002:a2e:b16e:: with SMTP id a14mr4906941ljm.70.1590796396913;
        Fri, 29 May 2020 16:53:16 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id k22sm2575540lfg.69.2020.05.29.16.53.15
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 16:53:16 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id m18so1326230ljo.5
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 16:53:15 -0700 (PDT)
X-Received: by 2002:a2e:8090:: with SMTP id i16mr4658232ljg.421.1590796395104;
 Fri, 29 May 2020 16:53:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200528234025.GT23230@ZenIV.linux.org.uk> <20200529232723.44942-1-viro@ZenIV.linux.org.uk>
 <20200529232723.44942-8-viro@ZenIV.linux.org.uk>
In-Reply-To: <20200529232723.44942-8-viro@ZenIV.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 29 May 2020 16:52:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgq2dzOdN4_=eY-XwxmcgyBM_esnPtXCvz1zStZKjiHKA@mail.gmail.com>
Message-ID: <CAHk-=wgq2dzOdN4_=eY-XwxmcgyBM_esnPtXCvz1zStZKjiHKA@mail.gmail.com>
Subject: Re: [PATCH 8/9] x86: kvm_hv_set_msr(): use __put_user() instead of
 32bit __clear_user()
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 4:27 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> a/arch/x86/kvm/hyperv.c
> -               if (__clear_user((void __user *)addr, sizeof(u32)))
> +               if (__put_user(0, (u32 __user *)addr))

I'm not doubting that this is a correct transformation and an
improvement, but why is it using that double-underscore version in the
first place?

There's a __copy_to_user() in kvm_hv_set_msr_pw() in addition to this
one in kvm_hv_set_msr(). Both go back to 2011 and commit 8b0cedff040b
("KVM: use __copy_to_user/__clear_user to write guest page") and both
look purely like "pointlessly avoid the access_ok".

All these KVM "optimizations" seem entirely pointless, since
access_ok() isn't the problem. And the address _claims_ to be
verified, but I'm not seeing it. There is not a single 'access_ok()'
anywhere in arch/x86/kvm/ that I can see.

It looks like the argument for the address being validated is that it
comes from "gfn_to_hva()", which should only return
host-virtual-addresses. That may be true.

But "should" is not "does", and honestly, the cost of gfn_to_hva() is
high enough that then using that as an argument for removing
"access_ok()" smells.

So I would suggest just removing all these completely bogus
double-underscore versions. It's pointless, it's wrong, and it's
unsafe.

This isn't even some critical path, but even if it was, that user
address check isn't where the problems are.

             Linus
