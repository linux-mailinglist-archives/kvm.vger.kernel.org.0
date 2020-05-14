Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A171D389F
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 19:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgENRrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 13:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725965AbgENRrH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 13:47:07 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24831C061A0C
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 10:47:07 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 17so4215350ilj.3
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 10:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hq9TTD9sv3H6E//fPojWMNxvG+QCBAqmIw81AfdjMYE=;
        b=rmEYr5/5WsjGQ1GaWuJX+YnTiWiaHsCeJPXoomAc9zM8grJcXo8WhnmsEoQTo/o3zd
         BfqFLxN9LzkS5HXzCC8NChrTsiZShUO2OtjKAmgI2fxI4I46MxY5vA6NxwdJ5R9u6yP7
         winlASYBxvuCPafG9sYu7XguuLmzbjXaqt/YjMvZ7W/dMmWuMF3unHDocZ1gMf12HSMe
         s5/BR7YhSr/15flbMKoKnjFNbN5Q4uCxm2f+deYGPw+NpaxSpU6HSeaADLf5sRS4zkuV
         w73oIcr2skn4cjFz7gd8C1ieIwQAextIxpbTC3oXrayNauBJaMj7g6YflvXaKqYb0jSC
         d6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hq9TTD9sv3H6E//fPojWMNxvG+QCBAqmIw81AfdjMYE=;
        b=M6c45C+whNvzHC566oCX3VvE5yDibR+PmKMKjNpq+laWXtkqriyoiIiPbvB0tPqw6x
         iDaTFgUumW6oi18vjxn1/m+MfTm8CrlgqlJCOIK6UGC0u1HTHoRYM6S7bhUzKqEursT7
         Hmd8/MdDzSchBS+/cflhx0QYDpql20vyxxtzNWPQYz+bI+6Yyexulm7jrZW4TOGtdN9f
         BOyJm+KFJJM6c+17qm9zwkngE5YqrLkaN1elyZmfyczla1GQ9GPudXk17uSOiGTwzdtG
         SHC27++mwb+WWcic6Cj5F10FEnxxzFQtMVZKVA/iM12Kb2J5BVC+Il9wHqePQryxlxBw
         61qQ==
X-Gm-Message-State: AOAM532/5lkXXPpmA6qN/n56cO5rf62WQKPwns+x+GjjlBTTfxZg3C0P
        4c5n+ZYXwLIsrlihj0zS8jKD7xnwmscPBJ0qMThbEMFE
X-Google-Smtp-Source: ABdhPJzFWGcXVn+VguWJeR0y1meSPEP0b2qH3MdWDDPkKoqfn81dZqmtECsA5qih6rzJXJFsH9ao+xAeD2IvWUJEGrk=
X-Received: by 2002:a92:d8ca:: with SMTP id l10mr5822330ilo.118.1589478426006;
 Thu, 14 May 2020 10:47:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200511225616.19557-1-jmattson@google.com>
In-Reply-To: <20200511225616.19557-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 14 May 2020 10:46:55 -0700
Message-ID: <CALMp9eTibESYUA-2q2AtRES8b7AOEzZtda4g9r3OV8erbZ3TKg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jue Wang <juew@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 11, 2020 at 3:56 PM Jim Mattson <jmattson@google.com> wrote:
>
> Bank_num is a one-based count of banks, not a zero-based index. It
> overflows the allocated space only when strictly greater than
> KVM_MAX_MCE_BANKS.
>
> Fixes: a9e38c3e01ad ("KVM: x86: Catch potential overrun in MCE setup")
> Signed-off-by: Jue Wang <juew@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d786c7d27ce5..5bf45c9aa8e5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3751,7 +3751,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>         unsigned bank_num = mcg_cap & 0xff, bank;
>
>         r = -EINVAL;
> -       if (!bank_num || bank_num >= KVM_MAX_MCE_BANKS)
> +       if (!bank_num || bank_num > KVM_MAX_MCE_BANKS)
>                 goto out;
>         if (mcg_cap & ~(kvm_mce_cap_supported | 0xff | 0xff0000))
>                 goto out;
> --
> 2.26.2.645.ge9eca65c58-goog
>

Ping?
