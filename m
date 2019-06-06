Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D4E3741E
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfFFM2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:28:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33625 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfFFM2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:28:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so1750874wme.0
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 05:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6eqhmalEaUXj72ZSb3Ja7eEeYje4bUFaw4pRDq0ErWg=;
        b=udE/Q9A57Sps4cNH+QXPmhOZB4DxoUEeE13MzF3wYmowJx3rI4LfMBrvgkP9GEuHwh
         mvsTHVWbZ8dHGRUWFbyu4wqR02INY91fMtpvU/yJFQIxHolRTSA1bFS9uE04Y7p2NRkU
         CV+9g4K9KwTEl/o16F3nuaPtgRwQp/BSpLtXmxsz/6EJBmaWFMMQNaOnmwGobr1/0uVa
         YBI0yWwF0DFLXYP/tEKMf3TKhtUPkZro0iWfcSbS/EBXVw5HdkvClu9MSwLK53K7QnVK
         +zZYJu2YSkR9S4C9Dz43x7znscXwsBq1isBloTbrMVIMzwuo0shKv4vlhm8/sOeZtohu
         GfmQ==
X-Gm-Message-State: APjAAAXKsVatGpJ134ct9JaahmQxJ5kFYpq0kMRcHzBURkl/keIIp/+Q
        rgl2Mo0+aBnkginm0uU6CxsUFQ==
X-Google-Smtp-Source: APXvYqyTwQ4au1LDeiqq0guGn+inNGHHQvUfeYfEMt5RMeQMxvJ+TYkJyHITSheQT3TFf047LW97Jg==
X-Received: by 2002:a7b:c001:: with SMTP id c1mr26701818wmb.49.1559824124773;
        Thu, 06 Jun 2019 05:28:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id k185sm1274918wma.3.2019.06.06.05.28.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:28:44 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] arm64: timer: a few test improvements
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com
References: <20190603090933.20312-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <11c4634a-150f-e18e-b7a4-74716e834120@redhat.com>
Date:   Thu, 6 Jun 2019 14:28:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190603090933.20312-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/06/19 11:09, Andrew Jones wrote:
> 1) Ensure set_timer_irq_enabled() clears the pending interrupt
>    from the gic before proceeding with the next test.
> 2) Inform user we're about to wait for an interrupt - just in
>    case we never come back...
> 3) Allow the user to choose just vtimer or just ptimer tests,
>    or to reverse their order with -append 'ptimer vtimer'.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/timer.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index 275d0494083d..6f2ad1d76ab2 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -231,6 +231,7 @@ static void test_timer(struct timer_info *info)
>  	/* Disable the timer again and prepare to take interrupts */
>  	info->write_ctl(0);
>  	set_timer_irq_enabled(info, true);
> +	report("interrupt signal no longer pending", !gic_timer_pending(info));
>  
>  	report("latency within 10 ms", test_cval_10msec(info));
>  	report("interrupt received", info->irq_received);
> @@ -242,6 +243,7 @@ static void test_timer(struct timer_info *info)
>  	info->irq_received = false;
>  	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
> +	report_info("waiting for interrupt...");
>  	wfi();
>  	left = info->read_tval();
>  	report("interrupt received after TVAL/WFI", info->irq_received);
> @@ -328,12 +330,23 @@ static void print_timer_info(void)
>  
>  int main(int argc, char **argv)
>  {
> +	int i;
> +
>  	test_init();
>  
>  	print_timer_info();
>  
> -	test_vtimer();
> -	test_ptimer();
> +	if (argc == 1) {
> +		test_vtimer();
> +		test_ptimer();
> +	}
> +
> +	for (i = 1; i < argc; ++i) {
> +		if (strcmp(argv[i], "vtimer") == 0)
> +			test_vtimer();
> +		if (strcmp(argv[i], "ptimer") == 0)
> +			test_ptimer();
> +	}
>  
>  	return report_summary();
>  }
> 

Queued, thanks.

Paolo
