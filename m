Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B1FD00B5
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 20:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbfJHS3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 14:29:45 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:32890 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfJHS3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 14:29:45 -0400
Received: by mail-io1-f67.google.com with SMTP id z19so38826731ior.0
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 11:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nFBqKrWYzVevAqWlj4MwUnoGvm5LwGQa7c/udw32/uk=;
        b=rr1wYHsWE+EyQTfXmtPkbAae+AJF1dzTGin2U3uKmmzk2hp+/QHdrkZyJETn8YqklD
         c1Q6on7G5uUDJ7RoAa3O9givoK0OUo/hc4XKx66TY4OrJOl3HOT1kNlsYFj8mLVoon15
         xpnHfpnD1b9yXc/A682iDYG6rONW8R8s5l1Gmws9beBQXQ1zZWQ3RBdEnPXOSUpeN6zy
         x/j1CWVPbo/bqVWQ6SbK9N2SINsFtagA1MFnyrDN9vSBhj7YgxmDs+piLLpDzNWtRd7W
         jMqPjI3TTQBFbATaKPaoLAlwvylsMkdueRvJ/s/+M80icDmygl7sHPnf2sUjFpsGrxmq
         xm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nFBqKrWYzVevAqWlj4MwUnoGvm5LwGQa7c/udw32/uk=;
        b=QDYGoXxqh+iyHBCoj9AwIpSGBXe+0QGzCw3kBRNwCqLIB1nOUkqUKll3kc+IxW2eye
         PBcvjzztUi1i3EmqKW6zga03p4WMk4gTRJNGYy5dRAs4OjMqxvVtktUpVzvyJbwBJBUm
         gb0lCqTaNCExLwCLr98HerBeHeuPjpg5KLdpH4WtkycLQCpAs4Qq12qeNoO9bIIi1tDj
         KQ8yeKlOiYnFPWTGbjg1Htb6zAtz/mgknkQ7iWkbu9Ru4FZAeFH3jb1mANnEMgzDD70I
         SOlQ6hKkxeKw1u+PERRWFzlzQyoknMcJ3TcxhiIlyM3Kvj+DpXSq8QikWpLvb0MWudKM
         cKkA==
X-Gm-Message-State: APjAAAXOR82x+35Bt9jwPwXi3DAqJeWKyffnzj1W49aY36YhWKDJh9HN
        qC/PAXMeJbNYGbLDdLncn9/s68I1XmQhtZKgRMQSAw==
X-Google-Smtp-Source: APXvYqwV50Ef2BQ2bOQ//cj94vmb5seQktGMXKEZow3ymAb6uwbdVxDT6gUCrPVayZAzCFWsHbu1/lw1iwAXQlZm8kE=
X-Received: by 2002:a5e:8a43:: with SMTP id o3mr31593126iom.296.1570559384010;
 Tue, 08 Oct 2019 11:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <20191008180808.14181-1-vkuznets@redhat.com>
In-Reply-To: <20191008180808.14181-1-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 8 Oct 2019 11:29:32 -0700
Message-ID: <CALMp9eTqu2zff2g4pX-aR3P-AFNochKfJGZrA6zecE864FuwVQ@mail.gmail.com>
Subject: Re: [PATCH] selftests: kvm: fix sync_regs_test with newer gccs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 8, 2019 at 11:08 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Commit 204c91eff798a ("KVM: selftests: do not blindly clobber registers in
>  guest asm") was intended to make test more gcc-proof, however, the result
> is exactly the opposite: on newer gccs (e.g. 8.2.1) the test breaks with
>
> ==== Test Assertion Failure ====
>   x86_64/sync_regs_test.c:168: run->s.regs.regs.rbx == 0xBAD1DEA + 1
>   pid=14170 tid=14170 - Invalid argument
>      1  0x00000000004015b3: main at sync_regs_test.c:166 (discriminator 6)
>      2  0x00007f413fb66412: ?? ??:0
>      3  0x000000000040191d: _start at ??:?
>   rbx sync regs value incorrect 0x1.
>
> Apparently, compile is still free to play games with registers even
> when they have variables attaches.
>
> Re-write guest code with 'asm volatile' by embedding ucall there and
> making sure rbx is preserved.
>
> Fixes: 204c91eff798a ("KVM: selftests: do not blindly clobber registers in guest asm")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/x86_64/sync_regs_test.c     | 21 ++++++++++---------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> index 11c2a70a7b87..5c8224256294 100644
> --- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> @@ -22,18 +22,19 @@
>
>  #define VCPU_ID 5
>
> +#define UCALL_PIO_PORT ((uint16_t)0x1000)
> +
> +/*
> + * ucall is embedded here to protect against compiler reshuffling registers
> + * before calling a function. In this test we only need to get KVM_EXIT_IO
> + * vmexit and preserve RBX, no additional information is needed.
> + */
>  void guest_code(void)
>  {
> -       /*
> -        * use a callee-save register, otherwise the compiler
> -        * saves it around the call to GUEST_SYNC.
> -        */
> -       register u32 stage asm("rbx");
> -       for (;;) {
> -               GUEST_SYNC(0);
> -               stage++;
> -               asm volatile ("" : : "r" (stage));
> -       }
> +       asm volatile("1: in %[port], %%al\n"
> +                    "add $0x1, %%rbx\n"
> +                    "jmp 1b"
> +                    : : [port] "d" (UCALL_PIO_PORT) : "rax", "rbx");
>  }
A better solution might be something like:

register u32 stage = 0;
for (;;) {
        asm volatile("in %[port], %%al"
             :
             : "b" (stage), [port] "d" (UCALL_PIO_PORT)
             : "rax");
        stage++;
}

(Gmail no doubt has mangled the indentation. Sorry.)
