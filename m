Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85D611EA57
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 19:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfLMS2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 13:28:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27929 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728704AbfLMS2g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 13:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576261715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zfNgW3naic8ao+4XHnKtvSZWM9jHjtG9Jne1B+PapPQ=;
        b=IDggzVnLauq+KjHYbkVx10gUawD70DFPgBCGIAs3TwjWvI/1yPIkI+TXjeN8UL2+kfFzhf
        /sxo80S+coCJULeDx9HjaOH0QH6Ap7bq4zRAc+Ny30mOb+ZDIq9lKpxsMHKRGM34/JdOrp
        /X1eWulC79sBKAmpPJYxd0FsDeBqVlk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-sN4HewMyNPiM06YQQbPNLw-1; Fri, 13 Dec 2019 13:28:34 -0500
X-MC-Unique: sN4HewMyNPiM06YQQbPNLw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CCA61005502;
        Fri, 13 Dec 2019 18:28:33 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-115.brq.redhat.com [10.40.204.115])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79DBA60BF3;
        Fri, 13 Dec 2019 18:28:22 +0000 (UTC)
Date:   Fri, 13 Dec 2019 19:28:15 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 13/18] arm64: timer: Test behavior when
 timer disabled or masked
Message-ID: <20191213182815.i6sai77zv4jfunr4@kamzik.brq.redhat.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
 <20191128180418.6938-14-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191128180418.6938-14-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 06:04:13PM +0000, Alexandru Elisei wrote:
> When the timer is disabled (the *_CTL_EL0.ENABLE bit is clear) or the
> timer interrupt is masked at the timer level (the *_CTL_EL0.IMASK bit is
> set), timer interrupts must not be pending or asserted by the VGIC.
> However, only when the timer interrupt is masked, we can still check
> that the timer condition is met by reading the *_CTL_EL0.ISTATUS bit.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> 
> This test was used to discover a bug and test the fix introduced by KVM
> commit 16e604a437c8 ("KVM: arm/arm64: vgic: Reevaluate level sensitive
> interrupts on enable").

This kind of information can/should go above the ---, IMO.

Thanks,
drew

> 
>  arm/timer.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index d2cd5dc7a58b..09d527bb09a8 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -230,9 +230,17 @@ static void test_timer(struct timer_info *info)
>  
>  	/* Disable the timer again and prepare to take interrupts */
>  	info->write_ctl(0);
> +	isb();
> +	info->irq_received = false;
>  	set_timer_irq_enabled(info, true);
> +	report("no interrupt when timer is disabled", !info->irq_received);
>  	report("interrupt signal no longer pending", !gic_timer_pending(info));
>  
> +	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
> +	isb();
> +	report("interrupt signal not pending", !gic_timer_pending(info));
> +	report("timer condition met", info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
> +
>  	report("latency within 10 ms", test_cval_10msec(info));
>  	report("interrupt received", info->irq_received);
>  
> -- 
> 2.20.1
> 

