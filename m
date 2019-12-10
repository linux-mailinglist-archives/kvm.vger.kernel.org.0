Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16C2118F60
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 18:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfLJR5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 12:57:23 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:47030 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfLJR5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 12:57:22 -0500
Received: by mail-il1-f194.google.com with SMTP id t17so16874944ilm.13
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 09:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F5GBQVg48b5VsOIQpufm20CNN3LYpyLqTajosSboWeU=;
        b=lqimS6JKMLtVxp2Epms9wvg0N4KBcih7YIkPKttizUDR5v32IJqHD3mZlz1yrfkalZ
         ZVRX9PRBrAkxjyNPb1G3pBCw791QbfhvYVGven1Wvfv1FxDOYtyv+qSMDbig5hU7AQqT
         bNhjJGBfBTgwckLsShVDdectpd0pvmIOnn0SYsdNokCg7q/+1/ba+BEmlKZ/+86Sy8hT
         k5tUVhMEbWpXQwqYmI7MPyrRlh3IUIRNxbJgaQbhq0deBVoVC86z9s7QL3a6vydXoH/l
         0XPLFO2WeY5+GaXpWYr8I6AoNAbCFQEW8liuSsEcTNR5QgluDNVaeKVa8qLwXx0RnNKX
         tpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F5GBQVg48b5VsOIQpufm20CNN3LYpyLqTajosSboWeU=;
        b=n4EdTVUgiyU8aIpL6JzAGl2/FhxRBTFlPuSsJ9ElbKrcT5lF+2B6NzvhMs/YhMQxRn
         pwFXMBqQUFEROnbFHz2o4qa7XLc8Ii2d7WctC4LKOVVbgKaRK4EqQoypxTMsTN/u5N3j
         7rLU8hlONMSCzHTauMdlMI6xZ064xJJF5hi5Ok4VHWltk9Fo1LICqG4WAAN5QJ9VQhIy
         lvauO3BwX51NVxqTfHtNZ+hKR4eB4Y2W9ntpzWq99ssyl6fOgP1KFWcP2NlAKfqoQpzY
         ixnt9ExfAW4N/TUFulCKqh4awEapj6BoEYLg1ELMHlF7mHpaJy2e+QjwVGYjVEC5JF1d
         rVdg==
X-Gm-Message-State: APjAAAVFNNRMU4+tu4yQoTvU1GEQ0H9vP2PG8I/lNfz54NlaKu3OkU8m
        DXDLlx1lGCa73gGIbE1vmBnVSeHKlbWEVc+dbJnHYQ==
X-Google-Smtp-Source: APXvYqxU+ZjButpypBkRV9jDQajjTJQJmgoXAGqmA+EbjCH+03P3OdPFHSefkQY+vnlZEbw7cV/WXgs9Fzq31RDCQ18=
X-Received: by 2002:a92:d30e:: with SMTP id x14mr35764797ila.108.1576000641934;
 Tue, 10 Dec 2019 09:57:21 -0800 (PST)
MIME-Version: 1.0
References: <20191206231302.3466-1-krish.sadhukhan@oracle.com> <20191206231302.3466-2-krish.sadhukhan@oracle.com>
In-Reply-To: <20191206231302.3466-2-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Dec 2019 09:57:10 -0800
Message-ID: <CALMp9eQ4_qtcO1BbraOwXHamXwi4M3AOq1NE7X84wgxxm=ismA@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: nVMX: Check GUEST_SYSENTER_ESP and
 GUEST_SYSENTER_EIP on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 6, 2019 at 3:49 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> According to section "Checks on Guest Control Registers, Debug Registers, and
> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
> of nested guests:
>
>     "The IA32_SYSENTER_ESP field and the IA32_SYSENTER_EIP field must each
>      contain a canonical address."
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0e7c9301fe86..a2d1c305a7d8 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2770,6 +2770,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>             CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
>                 return -EINVAL;
>
> +       if (CC(!is_noncanonical_address(vmcs12->guest_sysenter_esp)) ||
> +           CC(!is_noncanonical_address(vmcs12->guest_sysenter_eip)))
> +               return -EINVAL;
> +

Don't the hardware checks on the corresponding vmcs02 fields suffice
in this case?

>         if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
>             CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
>                 return -EINVAL;
> --
> 2.20.1
>
