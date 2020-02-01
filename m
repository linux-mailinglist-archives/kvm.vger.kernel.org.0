Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF7114F6C7
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 06:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgBAFxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 00:53:43 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35678 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgBAFxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 00:53:43 -0500
Received: by mail-oi1-f194.google.com with SMTP id b18so9614212oie.2;
        Fri, 31 Jan 2020 21:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nn6Z1K4Ig+lUl4xv40lMeq9rx7gNTQqV1fkouNx1AkE=;
        b=qMfELv6gCVDzyWoHrI8dxesUDXE3M1cw7AJY/HgtTJBDZi6hj8nL+jyu8fNQ7ic8H0
         QCzkCGzeYtjWkO52gQOjFg2trtO7759pyuei63RbVGekUibOimrDGpULjZhUg4Z9qxrl
         /Xno4xQb5ARDonX9l9GFqB2cqd6Y4VD2xRLytPuwlvP8/qJsIvZJCZDsqGViAgNzOpIt
         orUKRghnQw3ykbGoHXbNg2NefxIUp6p3+oVGzhn57X30H83e0VHsaJy5+aCROgTHBO45
         L+EQQ9UNdaLzStCxTM0bgDq5CBZ6BAztuiUcS60FmtjeF6JF/HeyKuYBD589Th9foDja
         WKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nn6Z1K4Ig+lUl4xv40lMeq9rx7gNTQqV1fkouNx1AkE=;
        b=P6YzzvdG9pm7G54CaJHZOOcP5+M6mCQ50Ksr/ACOtORfjSo6TX0fEWvFLdPaDJNq8Y
         VsUZfhpe918N+nvNC8CgAxuBxUpxNgvGRTBXn258aloknc/1W/vG9ewrmMycpuUq5a6V
         mS3BuolSOqfGO5EpHw/0IiyZ2E3H0t6ngd0F7DA8VXdUJEHP0KII+tsFGPqYs7iGtT3H
         YSkj/Fuq4B+ToE3wVix3HiRXw5IhaAkXRLcKVBY5tyZ5hpMn5xaINaboB2fw0eby7oYp
         jDPMM16Uvipu1E7RHb6CAKtdWuCshKnhSBJCN3NqX7Dd+XXEk0ocIMJ63dYxY03TjOzH
         TbhQ==
X-Gm-Message-State: APjAAAUmaWiDS8vveUjR+5M++nbtQlISOiTR3WOhEZWBW5GtN73Da8Sm
        zM7GRdGzPigBB4IQHupqFQ3T9gBMAbPI/aziA7R1RwNg
X-Google-Smtp-Source: APXvYqwE113qFxAd9XWoPRNc6FEbRgUVY3TmHCvX+OR1Antl3haNngqyvW5T6CXiyN3NEGfJfubK/rC+j6aAjMntRwE=
X-Received: by 2002:aca:8d5:: with SMTP id 204mr8370686oii.141.1580536422319;
 Fri, 31 Jan 2020 21:53:42 -0800 (PST)
MIME-Version: 1.0
References: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sat, 1 Feb 2020 13:53:31 +0800
Message-ID: <CANRm+CyyuWUOAj81Sg8UH_jMybZWmvZxWPWZ_twMvFnPxKD3hQ@mail.gmail.com>
Subject: Re: [FYI PATCH 0/5] Missing TLB flushes
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 31 Jan 2020 at 02:02, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>
> The KVM hypervisor may provide a guest with ability to defer remote TLB
> flush when the remote VCPU is not running. When this feature is used,
> the TLB flush will happen only when the remote VPCU is scheduled to run
> again. This will avoid unnecessary (and expensive) IPIs.
>
> Under certain circumstances, when a guest initiates such deferred action,
> the hypervisor may miss the request. It is also possible that the guest
> may mistakenly assume that it has already marked remote VCPU as needing
> a flush when in fact that request had already been processed by the
> hypervisor. In both cases this will result in an invalid translation
> being present in a vCPU, potentially allowing accesses to memory locations
> in that guest's address space that should not be accessible.
>
> Note that only intra-guest memory is vulnerable.
>
> The attached patches address both of these problems:
> 1. The first patch makes sure the hypervisor doesn't accidentally clear
> guest's remote flush request
> 2. The rest of the patches prevent the race between hypervisor
> acknowledging a remote flush request and guest issuing a new one.

Looks good, thanks for the patchset.

    Wanpeng
