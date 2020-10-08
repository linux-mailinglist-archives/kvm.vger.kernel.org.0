Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C111D2873CC
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 14:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgJHMFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 08:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgJHMFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 08:05:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF5DC061755;
        Thu,  8 Oct 2020 05:05:42 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602158740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3bluUuuSdY5rIw0qPw0iXefBMzcHgh5padXn/NethWQ=;
        b=ahCQTcNavbgKnh16xStsfQ1yj+WCAJBHSKIP+WQJoZmyG8djnGp28PZBa9MW4eQc/oJoY0
        w1BpIFoBA8DP7UxfP2Zk7NbmvHj0dMVGzCftrN/CJHOnj5v+fc44rpEulY/+rUpa1DlZdx
        RUiDPmrxC5IDEEVtOnkTQd1CzdL1S5xNL8VOtL5zfnFP9wlpXWuKwcG7AEdJWUkYA6PDpQ
        R7SaGLRtUPIe46kNDa3lYhqEuADbhBpZqUq/Hu59qJUg+FkC/Nyt55nD5o3X7o7cnNngX7
        LGgxP02kY4au6Gw/rn99zREd6wTadeDjPM/Hru/0b4Cz03qhuxB8lfN0G71McA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602158740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3bluUuuSdY5rIw0qPw0iXefBMzcHgh5padXn/NethWQ=;
        b=N2yNWQRbg8TeI6w0lMawa+kCV7nPp199l9z5IVkDlrK3R82Y+7ym1CvFAjX9VzYQ31143p
        QOEUycH1XclGVsDQ==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
In-Reply-To: <20201007122046.1113577-5-dwmw2@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-5-dwmw2@infradead.org>
Date:   Thu, 08 Oct 2020 14:05:40 +0200
Message-ID: <87blhcx6qz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 13:20, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> This allows the host to indicate that IOAPIC and MSI emulation supports
> 15-bit destination IDs, allowing up to 32768 CPUs without interrupt
> remapping.
>
> cf. https://patchwork.kernel.org/patch/11816693/ for qemu
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/cpuid.rst     | 4 ++++
>  arch/x86/include/uapi/asm/kvm_para.h | 1 +
>  arch/x86/kernel/kvm.c                | 6 ++++++
>  3 files changed, 11 insertions(+)
>
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index a7dff9186bed..1726b5925d2b 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -92,6 +92,10 @@ KVM_FEATURE_ASYNC_PF_INT          14          guest checks this feature bit
>                                                async pf acknowledgment msr
>                                                0x4b564d07.
>  
> +KVM_FEATURE_MSI_EXT_DEST_ID       15          guest checks this feature bit
> +                                              before using extended destination
> +                                              ID bits in MSI address
> bits 11-5.

Why MSI_EXT_DEST_ID? It's enabling that for MSI and IO/APIC. The
underlying mechanism might be the same, but APIC_EXT_DEST_ID is more
general and then you might also make the explanation of that bit match
the changelog.

Thanks,

        tglx
