Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021AF3DEED5
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 15:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbhHCNMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 09:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236351AbhHCNME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 09:12:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 607A360F8F;
        Tue,  3 Aug 2021 13:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627996313;
        bh=G9QZGioog0e7pS11z7Di9y9T7Cul6LuoangPMjmp7do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sQCZPKuox08viEWmQ1Vwdngj3jDYEtbBL3Z9zsohNDjLiqS1XGHC3OPoIDWEJzKDE
         ncOVT/DxqvlWY5abrYUO9v9/4XOJOaVaRJ0eVngCzWjg9f/cwgFCJbAlbpyENrNDRu
         heB9jxxVK0kD3RAAb5EqjdYJOMyc8DMQdf/Ap8rk=
Date:   Tue, 3 Aug 2021 15:11:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH kernel] KVM: Stop leaking memory in debugfs
Message-ID: <YQlAl7/GSHWwkzEj@kroah.com>
References: <20210730043217.953384-1-aik@ozlabs.ru>
 <YQklgq4NkL4UToVY@kroah.com>
 <CABgObfb+M9Qeow1EZy+eQwM1jwoZY3zdPJfZW+Q+MoWmkaqcFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfb+M9Qeow1EZy+eQwM1jwoZY3zdPJfZW+Q+MoWmkaqcFw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 03, 2021 at 02:52:17PM +0200, Paolo Bonzini wrote:
> On Tue, Aug 3, 2021 at 1:16 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Jul 30, 2021 at 02:32:17PM +1000, Alexey Kardashevskiy wrote:
> > >       snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
> > >       kvm->debugfs_dentry = debugfs_create_dir(dir_name, kvm_debugfs_dir);
> > > +     if (IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
> > > +             pr_err("Failed to create %s\n", dir_name);
> > > +             return 0;
> > > +     }
> >
> > It should not matter if you fail a debugfs call at all.
> >
> > If there is a larger race at work here, please fix that root cause, do
> > not paper over it by attempting to have debugfs catch the issue for you.
> 
> I don't think it's a race, it's really just a bug that is intrinsic in how
> the debugfs files are named.  You can just do something like this:
> 
> #include <unistd.h>
> #include <stdio.h>
> #include <fcntl.h>
> #include <sys/wait.h>
> #include <sys/ioctl.h>
> #include <linux/kvm.h>
> #include <stdlib.h>
> int main() {
>         int kvmfd = open("/dev/kvm", O_RDONLY);
>         int fd = ioctl(kvmfd, KVM_CREATE_VM, 0);
>         if (fork() == 0) {
>                 printf("before: %d\n", fd);
>                 sleep(2);
>         } else {
>                 close(fd);
>                 sleep(1);
>                 int fd = ioctl(kvmfd, KVM_CREATE_VM, 0);
>                 printf("after: %d\n", fd);
>                 wait(NULL);
>         }
> }
> 
> So Alexey's patch is okay and I've queued it, though with pr_warn_ratelimited
> instead of pr_err.

So userspace can create kvm resources with duplicate names?  That feels
wrong to me.

But if all that is "duplicate" is the debugfs kvm directory, why not ask
debugfs if it is already present before trying to create it again?  That
way you will not have debugfs complain about duplicate
files/directories.

thanks,

greg k-h
