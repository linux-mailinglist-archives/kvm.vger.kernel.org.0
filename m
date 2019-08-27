Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 396639DDCE
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 08:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfH0G2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 02:28:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728547AbfH0G2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 02:28:04 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2D8FA88309
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 06:28:03 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id g2so610612wmk.5
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 23:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zkIg0ZIIUVyciovXQn4VPl/ZugAFsHHle55Ze4sqrZE=;
        b=Xkl7LuU+H68AGIj4/FFHB1Z76fgI/NFKIFdit+kx/T8xna/Nz3ikaLCX/AnKGoWyin
         8FJbCdXJgxROtLDUFOwiDblNp6KKRvxqAQiqC0hoaMQVoz1Oft+VgsNYe3Z9abWAsytK
         BA/WV4D3OOqZsjbZCyQOv92SJPhL2oCio+NlqCcniXLp6O3Ftrx+BorLxmPMUU00ETqf
         NV37CmJKZUImvZ2BSqhrz7dk/wQ5CAO/GGWqG7i1d4XgF2ShT+uWlHoCGmigXz0b1gBU
         h+3y19QfBVuUlwC5XjMZVRrrOD59qYy/5ld3QpHvQw8nrE3RwY7zTRzWmxVBXpByDm2V
         oMNg==
X-Gm-Message-State: APjAAAVPGy05O4ercka75MFdh3PcRy4j1wEzuZND4wV/Yb4b4uenfxPG
        0DD9GaOnxi6Unx/TctB01FdUaTQs32luwLTCZiCclXqVkq4/EmgffNjxIvQN4nrEuBu79OdEk51
        amXqUhQxi8Qqm
X-Received: by 2002:adf:ee45:: with SMTP id w5mr5486396wro.148.1566887281593;
        Mon, 26 Aug 2019 23:28:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwN16MFzKVrXZ2t6xgozBVGOi6mkaNZ2f2CdhJap6g7ZY6NgFNPgyCmSkGmmjNZHokamnZcZg==
X-Received: by 2002:adf:ee45:: with SMTP id w5mr5486377wro.148.1566887281342;
        Mon, 26 Aug 2019 23:28:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-161-20.net.upcbroadband.cz. [89.176.161.20])
        by smtp.gmail.com with ESMTPSA id c187sm3077655wmd.39.2019.08.26.23.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 23:28:00 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: x86: Only print persistent reasons for kvm disabled once
In-Reply-To: <20190826182320.9089-1-tony.luck@intel.com>
References: <20190826182320.9089-1-tony.luck@intel.com>
Date:   Tue, 27 Aug 2019 08:27:59 +0200
Message-ID: <87imqjm8b4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tony Luck <tony.luck@intel.com> writes:

> When I boot my server I'm treated to a console log with:
>
> [   40.520510] kvm: disabled by bios
> [   40.551234] kvm: disabled by bios
> [   40.607987] kvm: disabled by bios
> [   40.659701] kvm: disabled by bios
> [   40.691224] kvm: disabled by bios
> [   40.718786] kvm: disabled by bios
> [   40.750122] kvm: disabled by bios
> [   40.797170] kvm: disabled by bios
> [   40.828408] kvm: disabled by bios
>
>  ... many, many more lines, one for every logical CPU

(If I didn't miss anything) we have the following code:

__init vmx_init()
        kvm_init();
            kvm_arch_init()

and we bail on first error so there should be only 1 message per module
load attempt. The question I have is who (and why) is trying to load
kvm-intel (or kvm-amd which is not any different) for each CPU? Is it
udev? Can this be changed?

In particular, I'm worried about eVMCS enablement in vmx_init(), we will
also get a bunch of "KVM: vmx: using Hyper-V Enlightened VMCS" messages
if the consequent kvm_arch_init() fails.

>
> Since it isn't likely that BIOS is going to suddenly enable
> KVM between bringing up one CPU and the next, we might as
> well just print this once.
>
> Same for a few other unchanging reasons that might keep
> kvm from being initialized.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 93b0bd45ac73..56d4a43dd2db 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7007,18 +7007,18 @@ int kvm_arch_init(void *opaque)
>  	struct kvm_x86_ops *ops = opaque;
>  
>  	if (kvm_x86_ops) {
> -		printk(KERN_ERR "kvm: already loaded the other module\n");
> +		pr_err_once("kvm: already loaded the other module\n");
>  		r = -EEXIST;
>  		goto out;
>  	}
>  
>  	if (!ops->cpu_has_kvm_support()) {
> -		printk(KERN_ERR "kvm: no hardware support\n");
> +		pr_err_once("kvm: no hardware support\n");
>  		r = -EOPNOTSUPP;
>  		goto out;
>  	}
>  	if (ops->disabled_by_bios()) {
> -		printk(KERN_ERR "kvm: disabled by bios\n");
> +		pr_err_once("kvm: disabled by bios\n");
>  		r = -EOPNOTSUPP;
>  		goto out;
>  	}
> @@ -7029,7 +7029,7 @@ int kvm_arch_init(void *opaque)
>  	 * vCPU's FPU state as a fxregs_state struct.
>  	 */
>  	if (!boot_cpu_has(X86_FEATURE_FPU) || !boot_cpu_has(X86_FEATURE_FXSR)) {
> -		printk(KERN_ERR "kvm: inadequate fpu\n");
> +		pr_err_once("kvm: inadequate fpu\n");
>  		r = -EOPNOTSUPP;
>  		goto out;
>  	}

The messages themselves may need some love but this is irrelevant to the
patch, so

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
