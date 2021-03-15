Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A80333ABD6
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 07:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhCOG4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 02:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhCOG4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 02:56:30 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BE7C061574;
        Sun, 14 Mar 2021 23:56:29 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id t83so23527867oih.12;
        Sun, 14 Mar 2021 23:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kCu0lyCUoe52qGsgPNzNVXib6I3EQmCP/5VwSI1JsdE=;
        b=SNnX2IrogncjSFDJheFquG/1xR5rMHKda0CI9utmvDIAF8x7IGHEfnnEqV8c/k+l9b
         eAI68RE5rKva8SWNkAISuGQQH4NIznmryloRpM9jEVVvDnyEeRLpw39Z3i+jpVA7LfKu
         Fj3MYo2P55Cnt+qKR+LiJco8FcmYxIu2JHmBU5tx6vtowXVl2s9vUB7Wt6xfuQJNvc3o
         mYrVFU8h3Yvv/PNfCIQzdye/KqB9oIhmMcJ1th5LAkzWilbb5mUWf3StcUZIySWLQcB2
         f7r8HQyDA9FsBFwhKLX7eYsdUolPUYNVKV1HvhwEpuDL0fnKCqhEB585IomtaQ5mqCJl
         K73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kCu0lyCUoe52qGsgPNzNVXib6I3EQmCP/5VwSI1JsdE=;
        b=lMlsMGnYVVAKGYM9TEsixdW5OFn0XAWrZkwyBfs44gShhAu9c3G58dXiGxn+Yaj1Xt
         xh1GO8Hh1/OUmaKEtsvRsj5YZ/X2+96k2gULnZrP3UKucH+ospeWMdV5LcSq1lY+MOG8
         myJqtavhoMboWFVop61Bed6ZBPrred3uRZz3XAo0WgqknudGwTRB07n3cH1Kj6E6i35o
         ud7kY+nHnKhTZ5spzy3ZEcePPCTcv1QGZ2IPXFJ17HRl+uMVDkwvb0QECMUGYK5YT3a+
         BXfgW+eowq29mZPMWotkAa2csh5Gv0oBJKRlz6ADeJ/hGkLUYt48gWIi+CWHNab/OsOx
         UBUA==
X-Gm-Message-State: AOAM530UtZHDxnzwyt5uHN+v6ofraPlJzxD1aRxsfrdJ49STE9CvYOix
        eBOxs9G90vZBUuZopi4CQUo1nwWU/CNQHqKVQPMgNUlf
X-Google-Smtp-Source: ABdhPJwGhtIr0J7Sg3g2apbSn3c1pLOIsmnGFfnu+l877kcHsrHwqMByT83HaG+yIbjZ3axUdFIXxSFBaqj+in0/FTs=
X-Received: by 2002:aca:1a01:: with SMTP id a1mr13584174oia.33.1615791388614;
 Sun, 14 Mar 2021 23:56:28 -0700 (PDT)
MIME-Version: 1.0
References: <1614057902-23774-1-git-send-email-wanpengli@tencent.com>
 <CANRm+CwX189YE_oi5x-b6Xx4=hpcGCqzLaHjmW6bz_=Fj2N7Mw@mail.gmail.com>
 <YEo9GsUTKQRbd3HF@google.com> <CANRm+Cy42tM1M2vkuZk3y_-_wD-re9QxvoxWPGmyew+k1j_67w@mail.gmail.com>
 <e363db67-598b-619a-f844-d68dfb1d041a@redhat.com>
In-Reply-To: <e363db67-598b-619a-f844-d68dfb1d041a@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 15 Mar 2021 14:56:17 +0800
Message-ID: <CANRm+CwMz8DBDNjcUyhZmv5vSsX47CiBEd0G8UQNEQextju6jA@mail.gmail.com>
Subject: Re: [PATCH] x86/kvm: Fix broken irq restoration in kvm_wait
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 13 Mar 2021 at 17:33, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 13/03/21 01:57, Wanpeng Li wrote:
> >> A third option would be to split the paths.  In the end, it's only the ptr/val
> >> line that's shared.
> > I just sent out a formal patch for my alternative fix, I think the
> > whole logic in kvm_wait is more clear w/ my version.
> >
>
> I don't know, having three "if"s in 10 lines of code is a bit daunting.

Fair enough, just sent out v3 per Sean's suggestion.

    Wanpeng
