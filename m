Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29C2D6E72
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 07:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfJOFI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 01:08:59 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:33305 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfJOFI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 01:08:59 -0400
Received: by mail-yw1-f66.google.com with SMTP id w140so6911630ywd.0
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 22:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i6t9RMGHc/zO7LCeOmHD7XR3AZ36qNLpZlad/3/Z52E=;
        b=gImz5ixetP5a1/XCuyRvVC57azoCau3LhWfW90lMeWH+kidkAgUDL7Q/Bj1LJMHQAm
         KwL78FnQ4MgNvuTxWLeG5AEueSM7pVPnrMXV3vNok3qgWGzxkYwSbf7HT5qkT0ovJ999
         6XgCpq5zOoTMOTzhA8lWz5N8QwSfo0WXsf9ZIlkcZgNW3hgg72eHWRXW9ql4u9Frms6c
         ZzGJK8KeKlkRGTfkcxGzwmmaKooEEFZj6Njm+1qI1oHiV3hCvZ9F4+URj2yBVlaJJl3o
         yWfbVh7INl9P+x5Qt/K/KbF8Qp38VYiC1BMcqMy6IrC8ySDcKJnhartsscPR8uzKO24t
         BxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i6t9RMGHc/zO7LCeOmHD7XR3AZ36qNLpZlad/3/Z52E=;
        b=N//cWWQsjFXgwQJsvFUqoDjBescuyl5ZHGJtpyhlSZBofzRq3yD7oyKiosnG5w4Fz/
         vcRiDY0QiGMArH5H6xVvDMGyIIS+jw+Jss+5SRTo5SXthT7f/R9XZS74ck+X8orB+5bw
         azX3h2g/qhaadnAgDFV41AFNekEK0EhUlMJGhQAQSfV/gcHjWwjNK9dbZkuQmfcspC+0
         pgZT4tzJOGZG3ZaRIX/BJR5XjlNw+hGbnM2N6URPpAn82BaRlUqb5FxfUolyUTXmF3bR
         PDnmYptzB12haU2BHCMH+G/9g53dMp395/j3m73g+enj5dcj7R2UovjarHAHc+PX8klp
         XDEw==
X-Gm-Message-State: APjAAAXn1SQxq8vhguFqMP6xv8R0jzMnblGKTnjQ5Cub32rfyNSkFSLW
        fNPxfm43ZPjPI9FKMxIlkdHe0GBGTkkowEdnWfE0AA==
X-Google-Smtp-Source: APXvYqyOf36U4JYLmpD+zBZJagaUOWQD78IUIjFNdhcSp+w0sH5Aw+2VNHgL8vXsipTrwpRu05jU/7Uw9jZCsC/Zu2M=
X-Received: by 2002:a81:996:: with SMTP id 144mr16039071ywj.57.1571116137749;
 Mon, 14 Oct 2019 22:08:57 -0700 (PDT)
MIME-Version: 1.0
References: <20191010073055.183635-1-suleiman@google.com> <20191010103939.GA12088@rkaganb.sw.ru>
In-Reply-To: <20191010103939.GA12088@rkaganb.sw.ru>
From:   Suleiman Souhlal <suleiman@google.com>
Date:   Tue, 15 Oct 2019 14:08:46 +0900
Message-ID: <CABCjUKAprLkXb4Mw0VAY9ODRD81sV0VyPZYFkuxKajcdqf67vw@mail.gmail.com>
Subject: Re: [RFC v2 0/2] kvm: Use host timekeeping in guest.
To:     Roman Kagan <rkagan@virtuozzo.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ssouhlal@freebsd.org" <ssouhlal@freebsd.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>, konrad.wilk@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 10, 2019 at 7:39 PM Roman Kagan <rkagan@virtuozzo.com> wrote:
>
> I wonder how feasible it is to map the host's vdso into the guest and
> thus make the guest use the *same* (as opposed to "synchronized") clock
> as the host's userspace?  Another benefit is that it's essentially an
> ABI so is not changed as liberally as internal structures like
> timekeeper, etc.  There is probably certain complication in handling the
> syscall fallback in the vdso when used in the guest kernel, though.
>
> You'll also need to ensure neither tsc scaling and nor offsetting is
> applied to the VM once this clock is enabled.

That is what I initially wanted to do, but I couldn't find an easy way
to map a host page into the guest, outside of the regular userspace
(ioctl) KVM way of adding memory to a VM.

-- Suleiman
