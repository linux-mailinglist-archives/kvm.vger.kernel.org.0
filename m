Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A92E520B
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 19:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505801AbfJYRJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 13:09:00 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35712 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505815AbfJYRHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 13:07:42 -0400
Received: by mail-qk1-f193.google.com with SMTP id w2so2428048qkf.2
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 10:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VgDmg/alHhFL2/reBjt7yhX8dDm9czIGmJbYcBf/R8k=;
        b=FSKTWEU+gv+2kxlptjJ2CSYuPcuw/O9uI9MhwtX8uuxayM8+Y4gKdn3ls6hEO0FN98
         YDDJGqU3hssMz2Z+2j8deJyqThsMEhaJaTXsfmX2WQSs92NCIazoqM+yZUrWiiH/Y8tV
         y4DQaEGG2yh1XEKkoDI797WGjlA5X78HgNQOErlUyHQDWBDnv9EC3HPAqoD/U9I9vjYu
         M9QcRwWab2mgl9MYmpGg07slP7VxMN+9mIsR7Y0L75Si/dU0BNKqZMVhWIvQlphVav6V
         UMK4bgJ1NCehM2RBjzKzCB89+5DxYIPLAoSDGFUoaMusxASVSKmMNUvy5qQv4u5gWzoS
         wG9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VgDmg/alHhFL2/reBjt7yhX8dDm9czIGmJbYcBf/R8k=;
        b=pJw8XyzpTmAV1Lz/VGWr0CcglFm06Lu+4tKdiXaXpOTZxtltWLJQ7e+o1bHtWEeGsg
         WYpW+7Cv3cqUycZZKImGq2ut90ipG+L4Mb30zLIGE/cELXjBXMHISK+ObROzPco9M1V1
         00Kg+6h8GO96JC3fRvBLoXb1eiizKNbNRtSW1skt+RwnHZPpo/7rTESfiWQkOgeWZkA4
         PlqkCuuFEnmF/ii/wqlbkL0IpZ8dYAgcHsigcshSf4ty63yd6y9pmoFB7BRTYD9eacMc
         Y0MNrIXZfNxTWtkT2rgt9Aakg5S/afQYlLbL6VwkDT//9wmhPtEAuiVNfHEcm3Gh1zaP
         2Owg==
X-Gm-Message-State: APjAAAUa17x6fzTXWMS4+BppIANoguTnSkJNlRDXQM940gU5I951P0ID
        fScS8Q52vYrwoinL6BAb0zU3HFgh/7Nzp1JNHJ/tPg==
X-Google-Smtp-Source: APXvYqz26EJXPP0I1bY8xhjU4BPbzm/zJPaIclz0cXSXsgo1W4o4StG2XKYGK0wiANRinTLQGt1yMO32DpVRVoEanBk=
X-Received: by 2002:a37:4e0a:: with SMTP id c10mr3649203qkb.459.1572023260467;
 Fri, 25 Oct 2019 10:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <20191024195431.183667-1-jmattson@google.com> <895ce968-7f70-000b-0510-c9040125f93a@redhat.com>
In-Reply-To: <895ce968-7f70-000b-0510-c9040125f93a@redhat.com>
From:   Ken Hofsass <hofsass@google.com>
Date:   Fri, 25 Oct 2019 10:07:29 -0700
Message-ID: <CAL1xVq00-EwHfiZgsFLm3GuAdbDajCBxuKxm7xTbKKUaf0wzPQ@mail.gmail.com>
Subject: Re: [PATCH v2] kvm: x86: Add cr3 to struct kvm_debug_exit_arch
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 3:18 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 24/10/19 21:54, Jim Mattson wrote:
> > From: Ken Hofsass <hofsass@google.com>
> >
> > A userspace agent can use cr3 to quickly determine whether a
> > KVM_EXIT_DEBUG is associated with a guest process of interest.
> >
> > KVM_CAP_DEBUG_EVENT_PDBR indicates support for the extension.
> >
> > Signed-off-by: Ken Hofsass <hofsass@google.com>
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Cc: Peter Shier <pshier@google.com>
> > ---
> > v1 -> v2: Changed KVM_CAP_DEBUG_EVENT_PG_BASE_ADDR to KVM_CAP_DEBUG_EVENT_PDBR
> >           Set debug.arch.cr3 in kvm_vcpu_do_singlestep and
> >                               kvm_vcpu_check_breakpoint
> >           Added svm support
>
> Perhaps you have already considered using KVM_CAP_SYNC_REGS instead,
> since Google contributed it in the first place, but anyway...  would it
> be enough for userspace to request KVM_SYNC_X86_SREGS when it enables
> breakpoints or singlestep?

Hi Paolo, from a functional perspective, using KVM_SYNC_X86_SREGS is
totally reasonable. But it currently introduces a non-trivial amount
of overhead because it affects all exits.

This change is a targeted optimization for use in instrumentation
scenarios. Specifically where debug breakpoint exits are a small
percentage of total exits and only a small percentage of the debug
exits are from processes of interest.

thanks,
Ken
