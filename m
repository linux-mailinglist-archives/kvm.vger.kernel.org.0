Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E848048F
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 08:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfHCGDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 02:03:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52596 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfHCGDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Aug 2019 02:03:08 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so69873788wms.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 23:03:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/bB8Tbrp6SJ+FGTr4csz+1D60Rf87D30EGS4/Cd4pOQ=;
        b=DdszHPX0Yn0UkGClDmwMWfNeedGBB1f/mvcMK03/9SIdn/uDKKlKwC+NX0vBIXBFOM
         vyfy/i/Oi9hHMlJeVoc62Xqd9R93E0ou6vRNfjRAi1Z2JfrrmwVlYyZE2y7LC7RJO6cQ
         SOrrSZoSbaAe8urAhvR+w12QXMIKDQ+S5cvLgWr9UmJzESLZgbiu+0gEo6qf4U78uQSL
         BqrNhF47V8YNYb6xr3UPAdfrhPuGMXJDqlEPmVVjeRzK+RdMrjEnrgbNk+9ThqPyc54l
         0ZNSCSY4sgH5usw0FnS/g11Y8HfwlfaV8XMgE4EthOqWkCaajyvlkB/RZ/RPLL6TGAjy
         RwMw==
X-Gm-Message-State: APjAAAXc1hkVvTipfU7xg+bKdG81w/97zS4OBNkPY3ti1owB9vtwlN1h
        SyhX1XaBONTrQj77t0jJwm16K8NZt6c=
X-Google-Smtp-Source: APXvYqzmXtzAIcuj5yKJypFgHWm6U9OgstcVcB6Y5ltzAT+GHKA1HqHuRFuXPJ+KmmZti0tSUDoYrA==
X-Received: by 2002:a1c:5f55:: with SMTP id t82mr7517714wmb.111.1564812186238;
        Fri, 02 Aug 2019 23:03:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id f7sm77310740wrv.38.2019.08.02.23.03.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 23:03:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] arm: timer: Fix potential deadlock when
 waiting for interrupt
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     drjones@redhat.com, kvmarm@lists.cs.columbia.edu,
        marc.zyngier@arm.com
References: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <edcac547-58e1-4031-6ee0-e8f7daef0d15@redhat.com>
Date:   Sat, 3 Aug 2019 08:03:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 11:28, Alexandru Elisei wrote:
> Commit 204e85aa9352 ("arm64: timer: a few test improvements") added a call
> to report_info after enabling the timer and before the wfi instruction. The
> uart that printf uses is emulated by userspace and is slow, which makes it
> more likely that the timer interrupt will fire before executing the wfi
> instruction, which leads to a deadlock.
> 
> An interrupt can wake up a CPU out of wfi, regardless of the
> PSTATE.{A, I, F} bits. Fix the deadlock by masking interrupts on the CPU
> before enabling the timer and unmasking them after the wfi returns so the
> CPU can execute the timer interrupt handler.
> 
> Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/timer.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index 6f2ad1d76ab2..f2f60192ba62 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -242,9 +242,11 @@ static void test_timer(struct timer_info *info)
>  	/* Test TVAL and IRQ trigger */
>  	info->irq_received = false;
>  	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
> +	local_irq_disable();
>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
>  	report_info("waiting for interrupt...");
>  	wfi();
> +	local_irq_enable();
>  	left = info->read_tval();
>  	report("interrupt received after TVAL/WFI", info->irq_received);
>  	report("timer has expired (%d)", left < 0, left);
> 

Queued, thanks.

Paolo
