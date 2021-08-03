Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15E13DEE3D
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 14:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbhHCMwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 08:52:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235805AbhHCMwn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 08:52:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627995152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1e0CmMEL83WqdLcdVYEsCcbtntf5BnVnii0Ea1ZAFFA=;
        b=MMrV3Syp7S0q3yJReMfoDGNra9Q+2MAEW2r/CWFgFOoMVHlhllPaSGTwqVtEW8/Cgruix7
        blHv+XRTb0aaOf0mHfCO60dFzprZYcs6JU8eWefm1p5I8Lvx6QUdq2aOkuM2RT4pCTfrbV
        CqCYkAB0hTO+MbXRMg42trMbUNjOsIQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-aTZkXJGHMLKpKmNNzH59Nw-1; Tue, 03 Aug 2021 08:52:30 -0400
X-MC-Unique: aTZkXJGHMLKpKmNNzH59Nw-1
Received: by mail-pj1-f71.google.com with SMTP id 16-20020a17090a1990b0290178031dca45so577054pji.9
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 05:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1e0CmMEL83WqdLcdVYEsCcbtntf5BnVnii0Ea1ZAFFA=;
        b=DRo3o7SfFcyYUi+oEt2c+/n2pMYfj3ajeUi7m/3IwvITP1uEDmtDCbVZ38QiIxbc8e
         gyWEWcSD+JOxM824R5AITqNiwTQP3kz72+TTMeGGaYlRfs3DLEk6d8/tbAcC0+kEcoTf
         EyzG0/MBzza8FiO51W6pA1/hQ2JxvgpkMxFyALpZKdcZ+jwG/KuOTt/P0BMS2E5w41DV
         lprwUA35QKMw6P62uxykLm9q0lpWpBtiPfj+p//5W+m0h/j+nebNSiHxTTRMYQDldEdi
         GXeJONo4h8AnD9/xJlgCdzXb8mIeIKezhJKnW0KsQ0o+ein9/cCKuoU3bvJjOYnJNI/9
         Os4Q==
X-Gm-Message-State: AOAM531CnVqBhghb2KLP4f1i3anPQk9G0+xAWffH/UMY7O0r5GdukcYg
        XbqCEQvDIbStj03fAo3sIfsXLjXaSHcSpr7cKDv8mLtJwJBp5Sxk2mc15BAid1itSKFTYqS29Ud
        PjMASNWoZzOn1Zvensyov5PPQxsAd
X-Received: by 2002:a62:b615:0:b029:34a:3920:a7ea with SMTP id j21-20020a62b6150000b029034a3920a7eamr22355466pff.21.1627995149488;
        Tue, 03 Aug 2021 05:52:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4ikkr08NYYktnHUlEdmpFVB7A+oX79XPR1VnPIsMyaCkS1EbwHZ+ZyqfBBTwjkVz3XU8wsDGoYgkiCgoB/Tg=
X-Received: by 2002:a62:b615:0:b029:34a:3920:a7ea with SMTP id
 j21-20020a62b6150000b029034a3920a7eamr22355435pff.21.1627995149184; Tue, 03
 Aug 2021 05:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210730043217.953384-1-aik@ozlabs.ru> <YQklgq4NkL4UToVY@kroah.com>
In-Reply-To: <YQklgq4NkL4UToVY@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 3 Aug 2021 14:52:17 +0200
Message-ID: <CABgObfb+M9Qeow1EZy+eQwM1jwoZY3zdPJfZW+Q+MoWmkaqcFw@mail.gmail.com>
Subject: Re: [RFC PATCH kernel] KVM: Stop leaking memory in debugfs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 3, 2021 at 1:16 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Jul 30, 2021 at 02:32:17PM +1000, Alexey Kardashevskiy wrote:
> >       snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
> >       kvm->debugfs_dentry = debugfs_create_dir(dir_name, kvm_debugfs_dir);
> > +     if (IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
> > +             pr_err("Failed to create %s\n", dir_name);
> > +             return 0;
> > +     }
>
> It should not matter if you fail a debugfs call at all.
>
> If there is a larger race at work here, please fix that root cause, do
> not paper over it by attempting to have debugfs catch the issue for you.

I don't think it's a race, it's really just a bug that is intrinsic in how
the debugfs files are named.  You can just do something like this:

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/ioctl.h>
#include <linux/kvm.h>
#include <stdlib.h>
int main() {
        int kvmfd = open("/dev/kvm", O_RDONLY);
        int fd = ioctl(kvmfd, KVM_CREATE_VM, 0);
        if (fork() == 0) {
                printf("before: %d\n", fd);
                sleep(2);
        } else {
                close(fd);
                sleep(1);
                int fd = ioctl(kvmfd, KVM_CREATE_VM, 0);
                printf("after: %d\n", fd);
                wait(NULL);
        }
}

So Alexey's patch is okay and I've queued it, though with pr_warn_ratelimited
instead of pr_err.

Paolo

