Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6719711BB9D
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 19:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbfLKSYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 13:24:48 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:40421 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbfLKSYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 13:24:48 -0500
Received: by mail-il1-f195.google.com with SMTP id b15so20297259ila.7
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 10:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M9tA+Tr9ovbWOXuGiYbM0B2FW2ZyDkx7Yvdcfc6MPLs=;
        b=idAqrZS5yOYwdeK/lgm7YpOyYtpiEJT5h1P6uhhaane+g2Xn7IV2dkSWP53z017gAQ
         /AlG0kqHi/x8IM6vj96WukdMd3t7bSnKbqp5avoga1TPrk8lNOneJRYi9DrVcClaM5rV
         uMgh5WkX8h3tYuTaK69vJOzJm8f0+V4ZPUEOhI47JT+9C8E3vc27FsRZS2QoQ5OC8p33
         kbpTVseXf9aflsmpw57dqgtpsIZKmbXYkuNctxJ6lcFkdTeQNFXDHSSF5LUtNox/2mDw
         OXWH7XGEe8tn/Bqh0f1qD3KYZ0F3d9lblN/7QzTO+cw7ICLs84AwE3dnQQJ8lYLgRFxE
         SRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M9tA+Tr9ovbWOXuGiYbM0B2FW2ZyDkx7Yvdcfc6MPLs=;
        b=FB7GIctyaoC2GvqxS6fGNUJZ1SpjXbTkbIw2+aghufdLHNq1nQTt6Rg8tlfDvsn1kM
         6B9YCVFOSnM8n1SYs21/KqrjcT7pgitpQktf4ObrHE8y7x8P3yMKREB12Eq6gib4gUKp
         kh/MbRq62LKMbpPrLtd88uY0DjZMFhEsvuU65ucLjU6d+5eJGOC0plm+SQN27USDgwg5
         fuh/80lhbNBm2irJDQdDE5siHQ+k2Tzc1dsIh/zgmncNlvHJ0sms4hfh4uXDl2iP5MgW
         pqGbwa1ZcFbWzEMsIT01SBKd6PxLTLk7viHYBsIOyPsDiaZldJH73T6Anc0WLEXc2F+8
         lIow==
X-Gm-Message-State: APjAAAXJcLRZt/DrwXwbsSDygv0K0H3K4CJYHk4GvNQYJbEgqBtjhYqt
        Gr/4N2mXnsslRC9JZIDnwnAU3Fz15Kg02cGC5DlYfA==
X-Google-Smtp-Source: APXvYqxOHiPfhWhJpgBQfI8f+K8kysFSEhs5Wj6CkL1K/PdLyHuY9O+4ujMgXwhSuP9+2dxlkR4HblBXuFY0uukuZlg=
X-Received: by 2002:a05:6e02:8eb:: with SMTP id n11mr4519653ilt.26.1576088687084;
 Wed, 11 Dec 2019 10:24:47 -0800 (PST)
MIME-Version: 1.0
References: <20191211175822.1925-1-sean.j.christopherson@intel.com> <20191211175822.1925-2-sean.j.christopherson@intel.com>
In-Reply-To: <20191211175822.1925-2-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 11 Dec 2019 10:24:36 -0800
Message-ID: <CALMp9eR93otezrDot23oODV1S6M9kUAF9oB5UD7+E765cHRXjw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Add build-time assertion on usage of bit()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 9:58 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Add build-time checks to ensure KVM isn't trying to do a reverse CPUID
> lookup on Linux-defined feature bits, along with comments to explain
> the gory details of X86_FEATUREs and bit().
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>
> Note, the premature newline in the first line of the second comment is
> intentional to reduce churn in the next patch.
>
>  arch/x86/kvm/x86.h | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index cab5e71f0f0f..4ee4175c66a7 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -144,9 +144,28 @@ static inline bool is_pae_paging(struct kvm_vcpu *vcpu)
>         return !is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu);
>  }
>
> -static inline u32 bit(int bitno)
> +/*
> + * Retrieve the bit mask from an X86_FEATURE_* definition.  Features contain
> + * the hardware defined bit number (stored in bits 4:0) and a software defined
> + * "word" (stored in bits 31:5).  The word is used to index into arrays of
> + * bit masks that hold the per-cpu feature capabilities, e.g. this_cpu_has().
> + */
> +static __always_inline u32 bit(int feature)
>  {
> -       return 1 << (bitno & 31);
> +       /*
> +        * bit() is intended to be used only for hardware-defined
> +        * words, i.e. words whose bits directly correspond to a CPUID leaf.
> +        * Retrieving the bit mask from a Linux-defined word is nonsensical
> +        * as the bit number/mask is an arbitrary software-defined value and
> +        * can't be used by KVM to query/control guest capabilities.
> +        */
> +       BUILD_BUG_ON((feature >> 5) == CPUID_LNX_1);
> +       BUILD_BUG_ON((feature >> 5) == CPUID_LNX_2);
> +       BUILD_BUG_ON((feature >> 5) == CPUID_LNX_3);
> +       BUILD_BUG_ON((feature >> 5) == CPUID_LNX_4);
> +       BUILD_BUG_ON((feature >> 5) > CPUID_7_EDX);

What is magical about CPUID_7_EDX?

> +
> +       return 1 << (feature & 31);

Why not BIT(feature & 31)?

>  }
>
>  static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
> --
> 2.24.0
>
