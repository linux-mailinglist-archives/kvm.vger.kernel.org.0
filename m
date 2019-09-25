Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978B3BE82A
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 00:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfIYWO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 18:14:59 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42059 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfIYWO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 18:14:58 -0400
Received: by mail-io1-f65.google.com with SMTP id n197so1016559iod.9
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 15:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oN2m4++0LKr6bYfqCXcWdRY1alpvZSl28bU6nXFdaRo=;
        b=nWA7771D16q31tdoOAptSyiO4fw0bxdwPLiA2aW6WNm3y555sp4lMyWdhpn9DseJj9
         i7Mbuaps/im/Hp+Ofs3yiga+jYR/tbxF6JcMY3sOrnEUhJo1xFG2V3napIb1eoZEKcld
         yg8/C2yxtiYdAt+rRo4p2hkf5998b2pRB8LEyzPJU6pJhU/FcqyKH/+9LuKysD9QzE+p
         gyvW5pZHdtMHEavMaAAyEofiCYpeClJivd7cbJWj3EmHAfcGyllwAD+sky5NkZADi/Oe
         A4ne8r4ANNVH/68nshgcxglgxbXckv5QUdH3ZEVslFfuH+SdkCON1s1QEO3axn3y52kC
         jhXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oN2m4++0LKr6bYfqCXcWdRY1alpvZSl28bU6nXFdaRo=;
        b=b5is0WqDjfU21bkv5pqqd6lAYPLVSo1QLe9KQphEE2uwSCWlrREz+qazy0Q0rxBkXC
         3zjHV7xbUQBs31PVqSurcVzjZzblzuly1ltsZFc1OLG9uFlnJPiD3Ux2u5o654vKuxXk
         vGmxv6IYKIB6ZXxHsV1SvT+1KJdEl72Z7z6RUSsVg/rMCg2Wp9ol+A+GaprMP54bmV/U
         38R6B3IyshzCm6QEYv+vxZj3lptxlLfZPVHaolee/Rog8TQ+EykHtGsoilPW26mK2ien
         rqpKdKXL0lG2Urmd/hHs4O+RC3MXGiKIGmSnpnHhFNQATXnFUWc6j2ooJgvKULcENHSV
         lVYw==
X-Gm-Message-State: APjAAAWR/u/ymMlYv087n8u/NWnzpVZtCoQSmEAqdPgoBE3ivwv/LmIf
        aYaOn1k149dG8TYIOrJkjpfVC1U3vL8D0+wqvkqweA==
X-Google-Smtp-Source: APXvYqwnzPkSsiUbT68TdAM7/Fq82PmpQ5Z0A/CfGt1w6IWIPokbXcJ9ji5UArTZ6/VDdNS3FrcxTS4scZPUkGpDCyo=
X-Received: by 2002:a6b:6a01:: with SMTP id x1mr238446iog.119.1569449697712;
 Wed, 25 Sep 2019 15:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190925213721.21245-1-bigeasy@linutronix.de> <20190925213721.21245-2-bigeasy@linutronix.de>
In-Reply-To: <20190925213721.21245-2-bigeasy@linutronix.de>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 25 Sep 2019 15:14:46 -0700
Message-ID: <CALMp9eTbaoCh=izdFHGEnX2-mBKZaWJ_Bkg3b53csVQgs+XmuQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: svm: Pass XSAVES to guest if available on host
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 2:37 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> In commit
>    55412b2eda2b7 ("kvm: x86: Add kvm_x86_ops hook that enables XSAVES for guest")
>
> XSAVES was enabled on VMX with a few additional tweaks and was always
> disabled on SVM. Before ZEN XSAVES was not available so it made no
> difference. With Zen it is possible to expose it to the guest if it is
> available on the host.
> I didn't find anything close to VMX's "VM-Execution Controls" and
> exposing this flag based on the CPUID flags cause no harm so far.
>
> Expose the XSAVES flag to the guest if the host supports it.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/x86/kvm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index e0368076a1ef9..3878eb766fa39 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5992,7 +5992,7 @@ static bool svm_mpx_supported(void)
>
>  static bool svm_xsaves_supported(void)
>  {
> -       return false;
> +       return boot_cpu_has(X86_FEATURE_XSAVES);
>  }
>
>  static bool svm_umip_emulated(void)
> --
> 2.23.0

This is inadequate. Please read the existing thread, "[Patch] KVM:
SVM: Fix svm_xsaves_supported." Aaron Lewis is working on completing
this as we speak.
