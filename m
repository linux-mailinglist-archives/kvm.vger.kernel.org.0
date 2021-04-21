Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2D3366983
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 12:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhDUK5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 06:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhDUK5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 06:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C009613FB;
        Wed, 21 Apr 2021 10:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619002622;
        bh=wIXOtHKDPyG2teIOsDxFC7sBnyiGDvLwiRR06+vvenI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oPQpLqyf+j6NLmiztuVd4I9EP3LJO/EVzlLuxYo5b3m/5hlj5G3P1WOvxJX4VzSoS
         LyPmcNXtOifjrw+Dv+xv6feCoxGFDeRDahVLFL5jXFhj+tBu0+ea+dJVg3dK2paH0K
         yNbp367TS/0VSd6TNBbzdqeZn8C+PuSM4buCOQU7Rh3hp1H9YSxHqZIsYD3wXHPbnq
         fisUTVOek3DH+X5//SjaiFhcfjRIDtNqf1wli2imaPQjnD+D+DDyhbfEwPrUD6B/m/
         014Pe8+QYf8Ju1K9DEybZpAbDgiYa7UHrZ8hxuQzI60IITsFSkBXAMjvtDD/ihi679
         zLX9sfKwmcxpw==
Date:   Wed, 21 Apr 2021 12:57:00 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v3 1/9] context_tracking: Move guest exit context
 tracking to separate helpers
Message-ID: <20210421105700.GC16580@lothringen>
References: <20210415222106.1643837-1-seanjc@google.com>
 <20210415222106.1643837-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415222106.1643837-2-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 03:20:58PM -0700, Sean Christopherson wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Provide separate context tracking helpers for guest exit, the standalone
> helpers will be called separately by KVM x86 in later patches to fix
> tick-based accounting.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Michael Tokarev <mjt@tls.msk.ru>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/context_tracking.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
> index bceb06498521..200d30cb3a82 100644
> --- a/include/linux/context_tracking.h
> +++ b/include/linux/context_tracking.h
> @@ -131,10 +131,15 @@ static __always_inline void guest_enter_irqoff(void)
>  	}
>  }
>  
> -static __always_inline void guest_exit_irqoff(void)
> +static __always_inline void context_tracking_guest_exit_irqoff(void)

You can make this context_tracking_guest_exit() since there is no irq-on
version.

Thanks.
