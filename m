Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9167D32C37
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 11:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbfFCJPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 05:15:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728909AbfFCJNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 05:13:55 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B56937F7AB
        for <kvm@vger.kernel.org>; Mon,  3 Jun 2019 09:13:55 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF5DF38E20;
        Mon,  3 Jun 2019 09:13:54 +0000 (UTC)
Date:   Mon, 3 Jun 2019 11:13:52 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com
Subject: Re: [PATCH] arm64: timer: ensure pending signal was cleared
Message-ID: <20190603091352.oxa2xr6gmcqkpkpq@kamzik.brq.redhat.com>
References: <20190527162636.28878-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527162636.28878-1-drjones@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 03 Jun 2019 09:13:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

This patch is now superseded by ("[PATCH kvm-unit-tests] arm64: timer: a
few test improvements", Jun 3, 2019)[*], as I've added a couple more
improvements to the timer test and squashed them altogether.

Thanks,
drew

[*] message id <20190603090933.20312-1-drjones@redhat.com>
