Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83397C9133
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 20:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbfJBSyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 14:54:40 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43515 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbfJBSyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 14:54:39 -0400
Received: by mail-io1-f66.google.com with SMTP id v2so59329024iob.10
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 11:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3r5iSDLGZ8r+gXNiaBNLJJqk1fe5WwzEJBwQCe2vUck=;
        b=Aa7u5mROY4zwTVOvdlxTPP3QwR2ijNoJH5ND5RovBs+s2OzhvsmGt5KxyaUEjSdHSC
         W9YvwlknPtpfuQ9B3bGNnXbVYl9sWxZh15Pa6dKQgVm5v41CnC/ltU93piXMvDWVQvrP
         OPvRvmIGu+dHYh3aISWuf/zKrN5ggBkAseDdEy3JYg/aAydf46hqIUovk9TnLDZvKNcA
         a+uXvcKAjOAiiDPPeBmh3y5v3lyT5JgZc3qUssO/YMkMCcjYuuWWleNiiTWVEJlhQai3
         PUp++kJyAKCOMYL9mCsxNXxgtG3Vn2Hs17Gby/M5oO6ArPZr1WlkjH9HQ5PA/DTAHFzr
         6gug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3r5iSDLGZ8r+gXNiaBNLJJqk1fe5WwzEJBwQCe2vUck=;
        b=CXMgyQvXpUa2lVCY65sgWOY5S5xnKcRsEVEIeocDEGa/DicR1UNe6Ky6zz4NI/RYKa
         nV6wzHvXvymzGGaP62nUAs1KqOQirn662GNHBQtvR6A7mDlHCE2jG14Aea4mv5dlJNq3
         jpIDjOTCSCTiIfZoQfQzNnm5Rmtb4yQgM0o59uETRSXjzx/kddKdAWrdwRwzTqNzR4jb
         2ZCKdeJek2aM13Vt5KtxoKiJO7PFzDLzSd68Jb+OAwc0hlQbJEXY5VyivgHZsnJxe83+
         sjAI3c8O887aSnVVOOzlOVYT3qdo6AuqhHOrdyuuYW6iBMGLtWN1tu6+SU+JrGjODx+d
         9ujg==
X-Gm-Message-State: APjAAAVmCPzNUvDdCOWZJclZ89/izYUyJuPBfvELmCjfXe92L6y/FwKO
        9amnDDUKvrzmX/0BWej8Mvj4ymiAYdyGW/nN2m3/Ug==
X-Google-Smtp-Source: APXvYqxGU7SB9vUY0cnrSpSxwIk1DQWFrlBUnyKTd4pXrWzuO00cefZQd4xbUvKX+JT3ealXOPiNXIb4qxPV2/+Q7mM=
X-Received: by 2002:a92:8e4f:: with SMTP id k15mr6063919ilh.108.1570042477811;
 Wed, 02 Oct 2019 11:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190927021927.23057-1-weijiang.yang@intel.com> <20190927021927.23057-5-weijiang.yang@intel.com>
In-Reply-To: <20190927021927.23057-5-weijiang.yang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 2 Oct 2019 11:54:26 -0700
Message-ID: <CALMp9eS1V2fRcwogcEkHonvVAgfc9dU=7A4V-D0Rcoc=v82VAw@mail.gmail.com>
Subject: Re: [PATCH v7 4/7] KVM: VMX: Load Guest CET via VMCS when CET is
 enabled in Guest
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> "Load Guest CET state" bit controls whether Guest CET states
> will be loaded at Guest entry. Before doing that, KVM needs
> to check if CPU CET feature is enabled on host and available
> to Guest.
>
> Note: SHSTK and IBT features share one control MSR:
> MSR_IA32_{U,S}_CET, which means it's difficult to hide
> one feature from another in the case of SHSTK != IBT,
> after discussed in community, it's agreed to allow Guest
> control two features independently as it won't introduce
> security hole.
>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f720baa7a9ba..ba1a83d11e69 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -44,6 +44,7 @@
>  #include <asm/spec-ctrl.h>
>  #include <asm/virtext.h>
>  #include <asm/vmx.h>
> +#include <asm/cet.h>
>
>  #include "capabilities.h"
>  #include "cpuid.h"
> @@ -2918,6 +2919,37 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>         vmcs_writel(GUEST_CR3, guest_cr3);
>  }
>
> +static int set_cet_bit(struct kvm_vcpu *vcpu, unsigned long cr4)

Nit: This function does not appear to set CR4.CET, as the name would imply.

> +{
> +       struct vcpu_vmx *vmx = to_vmx(vcpu);
> +       const u64 cet_bits = XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL;
> +       bool cet_xss = vmx_xsaves_supported() &&
> +                      (kvm_supported_xss() & cet_bits);
> +       bool cet_cpuid = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +                        guest_cpuid_has(vcpu, X86_FEATURE_IBT);
> +       bool cet_on = !!(cr4 & X86_CR4_CET);
> +
> +       if (cet_on && vmx->nested.vmxon)
> +               return 1;

This constraint doesn't appear to be architected. Also, this prevents
enabling CR4.CET when in VMX operation, but what about the other way
around (i.e. entering VMX operation with CR4.CET enabled)?

> +       if (cet_on && !cpu_x86_cet_enabled())
> +               return 1;

This seems odd. Why is kernel support for (SHSTK or IBT) required for
the guest to use (SHSTK or IBT)? If there's a constraint, shouldn't it
be 1:1? (i.e. kernel support for SHSTK is required for the guest to
use SHSTK and kernel support for IBT is required for the guest to use
IBT?) Either way, enforcement of this constraint seems late, here,
when the guest is trying to set CR4 to a value that, per the guest
CPUID information, should be legal. Shouldn't this constraint be
applied when setting the guest CPUID information, disallowing the
enumeration of SHSTK and/or IBT support on a platform where these
features are unavailable or disabled in the kernel?

> +       if (cet_on && !cet_xss)
> +               return 1;

Again, this constraint seems like it's being applied too late.
Returning 1 here will result in the guest's MOV-to-CR4 raising #GP,
even though there is no architected reason for it to do so.

> +       if (cet_on && !cet_cpuid)
> +               return 1;

What about the constraint that CR4.CET can't be set when CR0.WP is
clear? (And the reverse needs to be handled in vmx_set_cr0).

> +       if (cet_on)
> +               vmcs_set_bits(VM_ENTRY_CONTROLS,
> +                             VM_ENTRY_LOAD_GUEST_CET_STATE);

Have we ensured that this VM-entry control is supported on the platform?

> +       else
> +               vmcs_clear_bits(VM_ENTRY_CONTROLS,
> +                               VM_ENTRY_LOAD_GUEST_CET_STATE);
> +       return 0;
> +}
> +
>  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -2958,6 +2990,9 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>                         return 1;
>         }
>
> +       if (set_cet_bit(vcpu, cr4))
> +               return 1;
> +
>         if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
>                 return 1;
>
> --
> 2.17.2
>
