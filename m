Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C27C67E74C
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 02:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390568AbfHBAv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 20:51:59 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46374 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390549AbfHBAv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 20:51:59 -0400
Received: by mail-ot1-f68.google.com with SMTP id z23so48012059ote.13;
        Thu, 01 Aug 2019 17:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MKtmBE9da7Bw1V+smHoYvGcwbbIS/1PsJuf/DHA7EGc=;
        b=iavBX5VUTp+3S1HbFEs0fbaR7/q0aj9QeEkYqmPAahkEvEb9XGvoWneyMxuH+HHKkh
         Px/9SwjBN8nP0Bf/3gWhZ2bM9/P20gL/9Gm3aQi6vm1uUulg3In8NY1YY+kgialSB89f
         vnhSK6GfSFwbjI/lQnggGQPwkISAXV8fDAkpfup65dOI5Cjo/UH4TbOf/21H+Ru/bZm8
         z+o1eU1wrmWs0FthskPQbjxy3UjlxzmpFAr2RW3dOSHxVu8C8eMIiOqzqDzEh+zG9JzL
         ZgCzKmlFHSKIdbQ6DB1rn5yp64rhwrZoSQCqiigUbqZoKG1Mbqx9iXnaGAbb64JWTNml
         g/OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MKtmBE9da7Bw1V+smHoYvGcwbbIS/1PsJuf/DHA7EGc=;
        b=M3YMwJNzwxOPgQbhhKFkvBInWcWGbnfrL06wWpgvu7tjxDSpnhzpZ9hzNjKIZntwy2
         nypNTJbJFhx/DhaGslSy8QvOC7THt3PhT8anLHgTU23kYhNCYGK5NOLeYRscOWBJF7Xz
         lbDnOod1d4nmOuX1SzFyeQgljSFB45fMTqmUfnpqOpqtklO0Au6eF0R8hQ8bVyC1uJqL
         B03uxYwwLfOR6mSjFPmST8lt9VUb3bNi+bJHtEE5AuBAGrsqJo4Hiz6fAhaMFCNtFcB/
         pBchUt37UA2QzCrQkD7M7yo40m+DiQjOL2VC3ggXhqlu4IFMyRyoeEBDjV6E65CdW5Pf
         71Iw==
X-Gm-Message-State: APjAAAUdHlsMdFipR0dd1Fxv+g8B+E9TJriorg9nUYGryEK1EytELkHJ
        O80HrvYLze1qIEMH+xeOfAMdPeL7drVFJ0MC3KyCGVcj
X-Google-Smtp-Source: APXvYqzh1wL2IbrQbsHM6VXimh98RM1D3HiCeB5kdIxHY/I9XBbRACItyy8iPaFArrxjDDZB+2GnUJ5PURmY1UtAeE4=
X-Received: by 2002:a9d:738b:: with SMTP id j11mr11966250otk.185.1564707118010;
 Thu, 01 Aug 2019 17:51:58 -0700 (PDT)
MIME-Version: 1.0
References: <1564479235-25074-1-git-send-email-wanpengli@tencent.com> <04700afaf68114b5ab329f5a5182e21578c15795.camel@suse.com>
In-Reply-To: <04700afaf68114b5ab329f5a5182e21578c15795.camel@suse.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 2 Aug 2019 08:51:39 +0800
Message-ID: <CANRm+CwYC=rpEbe_OD+H6tDAFy4xYP6+JKRN2YHeH0TWt5234Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: Disable wake-affine vCPU process to mitigate lock
 holder preemption
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 1 Aug 2019 at 20:57, Dario Faggioli <dfaggioli@suse.com> wrote:
>
> On Tue, 2019-07-30 at 17:33 +0800, Wanpeng Li wrote:
> > However, in multiple VMs over-subscribe virtualization scenario, it
> > increases
> > the probability to incur vCPU stacking which means that the sibling
> > vCPUs from
> > the same VM will be stacked on one pCPU. I test three 80 vCPUs VMs
> > running on
> > one 80 pCPUs Skylake server(PLE is supported), the ebizzy score can
> > increase 17%
> > after disabling wake-affine for vCPU process.
> >
> Can't we achieve this by removing SD_WAKE_AFFINE from the relevant
> scheduling domains? By acting on
> /proc/sys/kernel/sched_domain/cpuX/domainY/flags, I mean?
>
> Of course this will impact all tasks, not only KVM vcpus. But if the
> host does KVM only anyway...

Yes, not only kvm host and dedicated kvm host, unless introduce
per-process flags, otherwise can't appeal to both.

Regards,
Wanpeng Li
