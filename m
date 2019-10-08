Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F7BCF02F
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 03:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbfJHBHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 21:07:31 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40047 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbfJHBHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 21:07:30 -0400
Received: by mail-ot1-f68.google.com with SMTP id y39so12685435ota.7;
        Mon, 07 Oct 2019 18:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=80fE1au7f0pETwqvrZXQbXfCUZbLKkjvWDlcT8ifxy0=;
        b=cGnOUtg+G92nethGH+PlIpXQEOU8lgTWjmS1ukpIBX4MDQrN0i9MufdUkKgTKt4TDe
         /sLk3jDUb3R38+nLyQ3B+j91PCICBnDVbEzajUyCQWB76AxRVrh6G7EgkHDF9mY9Y98R
         qcl5oW+NOLY1SzAFTo9915JNbfjy9qGipLDHOXoJNX9oDesvz4nZ8VvR5axlOWYAiAA7
         seTT7oERIX5Efkavaq4XRY6Ig/edyoXyARga2R4Oyk3QS+fr+Y6LjOpE5cgefCGhitjY
         94Gzq7znQVy0o2w3V2823Y1LZVdiOtf234uSJlgQvahjhPT/6ilzxgO7GrgZiQz0QPQn
         c8dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=80fE1au7f0pETwqvrZXQbXfCUZbLKkjvWDlcT8ifxy0=;
        b=NCJ99eL0K4DEep3ogfiftQcCDgC4lkRl35FNjrkmWlULg3NSKMf+xXP40J7sxKOwvL
         dldUy9PXgYu2itIUKX+fsRfxVgzQ25N+nI9w81Pl0wpkyOlEQasOqsWfCVgX8xaqwCKE
         5Vb+vflGz8EFd/OIj/lywyClq+jbnwtjI3yBqS3saCRLFt+bBYWNc4IxwhB2j6v0Y8MF
         htR0p+aV2ujb+tJjgHrLu1TViPSJSicP7yiPAHWGC8ZqySyJPxPBhkXobisCbyPcsjQ9
         Y9/U1w4he8bxtbEWvVW/+Mfa/d7nqbjrVCEtjHuggCjBmk+GnAcVpn+l1n0/f83Cvl2K
         02Xg==
X-Gm-Message-State: APjAAAVhvGZ9Z4V7J0Uz6EdV84nSqVJ9M3WkAmONh1OQfKZpZSBIt8XU
        geskTWH3hhiyvkEa56m5Thh/boPIwiTFhz5+IJ5qbQ==
X-Google-Smtp-Source: APXvYqw5F0KCI3r0K8qjs0QLNJYJXakLqLbuF2gDpd2m9TNqseSSC+VZTtcK2Ye97NT8T5thC3jf7xRcie+Yk//43c0=
X-Received: by 2002:a9d:aa8:: with SMTP id 37mr22474954otq.56.1570496850007;
 Mon, 07 Oct 2019 18:07:30 -0700 (PDT)
MIME-Version: 1.0
References: <1569719216-32080-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1569719216-32080-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 8 Oct 2019 09:07:18 +0800
Message-ID: <CANRm+CyFvpWRCEtsfZNDExPqDOeX9o=yin+tBF2MHN0ThtAfmg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: Don't shrink/grow vCPU halt_poll_ns if host side
 polling is disabled
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping,
On Sun, 29 Sep 2019 at 09:07, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Don't waste cycles to shrink/grow vCPU halt_poll_ns if host
> side polling is disabled.
>
> Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * fix coding style
>
>  virt/kvm/kvm_main.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e6de315..9d5eed9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2359,20 +2359,23 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>         kvm_arch_vcpu_unblocking(vcpu);
>         block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>
> -       if (!vcpu_valid_wakeup(vcpu))
> -               shrink_halt_poll_ns(vcpu);
> -       else if (halt_poll_ns) {
> -               if (block_ns <= vcpu->halt_poll_ns)
> -                       ;
> -               /* we had a long block, shrink polling */
> -               else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
> +       if (!kvm_arch_no_poll(vcpu)) {
> +               if (!vcpu_valid_wakeup(vcpu)) {
>                         shrink_halt_poll_ns(vcpu);
> -               /* we had a short halt and our poll time is too small */
> -               else if (vcpu->halt_poll_ns < halt_poll_ns &&
> -                       block_ns < halt_poll_ns)
> -                       grow_halt_poll_ns(vcpu);
> -       } else
> -               vcpu->halt_poll_ns = 0;
> +               } else if (halt_poll_ns) {
> +                       if (block_ns <= vcpu->halt_poll_ns)
> +                               ;
> +                       /* we had a long block, shrink polling */
> +                       else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
> +                               shrink_halt_poll_ns(vcpu);
> +                       /* we had a short halt and our poll time is too small */
> +                       else if (vcpu->halt_poll_ns < halt_poll_ns &&
> +                               block_ns < halt_poll_ns)
> +                               grow_halt_poll_ns(vcpu);
> +               } else {
> +                       vcpu->halt_poll_ns = 0;
> +               }
> +       }
>
>         trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
>         kvm_arch_vcpu_block_finish(vcpu);
> --
> 2.7.4
>
