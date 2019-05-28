Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD512BFCC
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 08:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfE1G6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 02:58:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727161AbfE1G6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 02:58:42 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6A1E3087929
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 06:58:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D4F61001943;
        Tue, 28 May 2019 06:58:40 +0000 (UTC)
Date:   Tue, 28 May 2019 08:58:38 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com
Subject: Re: [PATCH] arm64: timer: ensure pending signal was cleared
Message-ID: <20190528065838.putv7nx7yftvudlh@kamzik.brq.redhat.com>
References: <20190527162636.28878-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527162636.28878-1-drjones@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 28 May 2019 06:58:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I see I forgot 'kvm-unit-tests' in the [PATCH] tag. Sorry about that.

On Mon, May 27, 2019 at 06:26:36PM +0200, Andrew Jones wrote:
> Ensure set_timer_irq_enabled() clears the pending interrupt from
> the gic before proceeding with the next test.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/timer.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index 275d0494083d..eebc451722d9 100644
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
> -- 
> 2.18.1
> 
