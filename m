Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1682F309B
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 14:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbhALNH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 08:07:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729886AbhALNHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 08:07:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B8702311B;
        Tue, 12 Jan 2021 13:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610456827;
        bh=AAVThBMSN6NMX4AAzXi3Ln1jtkaPVvhGY2TI/Z+L7Rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fgNjEF4bQdQXvkrVWWOBJEs9lwF3zlEYBpaLq2P7eKlpF9UPyUE6NJAvZm8wN9W82
         ggBNPpR194gK7PWvF53LvENanWLNE2Xc4euoiB+XV703LhvaVvRBf+gAz7lq1/mVsG
         ESqElFii2bw4Tp2l0o/2c7sKMM98oMS3tHStF1Do=
Date:   Tue, 12 Jan 2021 14:08:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adrian Catangiu <acatan@amazon.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, graf@amazon.com, arnd@arndb.de,
        ebiederm@xmission.com, rppt@kernel.org, 0x7f454c46@gmail.com,
        borntraeger@de.ibm.com, Jason@zx2c4.com, jannh@google.com,
        w@1wt.eu, colmmacc@amazon.com, luto@kernel.org, tytso@mit.edu,
        ebiggers@kernel.org, dwmw@amazon.co.uk, bonzini@gnu.org,
        sblbir@amazon.com, raduweis@amazon.com, corbet@lwn.net,
        mst@redhat.com, mhocko@kernel.org, rafael@kernel.org, pavel@ucw.cz,
        mpe@ellerman.id.au, areber@redhat.com, ovzxemul@gmail.com,
        avagin@gmail.com, ptikhomirov@virtuozzo.com, gil@azul.com,
        asmehra@redhat.com, dgunigun@redhat.com, vijaysun@ca.ibm.com,
        oridgar@gmail.com, ghammer@redhat.com
Subject: Re: [PATCH v4 1/2] drivers/misc: sysgenid: add system generation id
 driver
Message-ID: <X/2fP9LNWXvp7up9@kroah.com>
References: <1610453760-13812-1-git-send-email-acatan@amazon.com>
 <1610453760-13812-2-git-send-email-acatan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610453760-13812-2-git-send-email-acatan@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 02:15:59PM +0200, Adrian Catangiu wrote:
> +``read()``:
> +  Read is meant to provide the *new* system generation counter when a
> +  generation change takes place. The read operation blocks until the
> +  associated counter is no longer up to date, at which point the new
> +  counter is provided/returned.
> +  Nonblocking ``read()`` uses ``EAGAIN`` to signal that there is no
> +  *new* counter value available. The generation counter is considered
> +  *new* for each open file descriptor that hasn't confirmed the new
> +  value following a generation change. Therefore, once a generation
> +  change takes place, all ``read()`` calls will immediately return the
> +  new generation counter and will continue to do so until the
> +  new value is confirmed back to the driver through ``write()``.
> +  Partial reads are not allowed - read buffer needs to be at least
> +  ``sizeof(unsigned)`` in size.

"sizeof(unsigned)"?  How about being specific and making this a real "X
bits big" value please.

"unsigned" does not work well across user/kernel boundries.  Ok, that's
on understatement, the correct thing is "does not work at all".

Please be specific in your apis.

This is listed elsewhere also.

> +``write()``:
> +  Write is used to confirm the up-to-date Sys Gen counter back to the
> +  driver.
> +  Following a VM generation change, all existing watchers are marked
> +  as *outdated*. Each file descriptor will maintain the *outdated*
> +  status until a ``write()`` confirms the up-to-date counter back to
> +  the driver.
> +  Partial writes are not allowed - write buffer should be exactly
> +  ``sizeof(unsigned)`` in size.
> +
> +``poll()``:
> +  Poll is implemented to allow polling for generation counter updates.
> +  Such updates result in ``EPOLLIN`` polling status until the new
> +  up-to-date counter is confirmed back to the driver through a
> +  ``write()``.
> +
> +``ioctl()``:
> +  The driver also adds support for tracking count of open file
> +  descriptors that haven't acknowledged a generation counter update,
> +  as well as a mechanism for userspace to *force* a generation update:
> +
> +  - SYSGENID_GET_OUTDATED_WATCHERS: immediately returns the number of
> +    *outdated* watchers - number of file descriptors that were open
> +    during a system generation change, and which have not yet confirmed
> +    the new generation counter.

But this number can instantly change after it is read, what good is it?
It should never be relied on, so why is this needed at all?

What can userspace do with this information?

thanks,

greg k-h
