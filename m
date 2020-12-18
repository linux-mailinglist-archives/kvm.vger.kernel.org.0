Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9B02DDF65
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 09:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732691AbgLRIJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 03:09:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732304AbgLRIJb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 03:09:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608278885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RPa6hLZH9TuZyafl4EET0MgXUDM3g9JcdSdA1PKueBY=;
        b=Z4bJra7ncyyvys5EmyygkNJZ0nyJfAanoKH7MgQhCbcnbQCJvrGKh8um/TK3FK/fN0aZ0C
        ZHkoOMc0Q7E1a6SMjOPGrbdarXlK6g+AiteuiJhcEGuKMIKGUYFFCh4uTcvFQZnXbHTrmW
        FdUN8UisJWtOCUtmq1f+YmnhfwQXqG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-R8Ic2qUUOya8ivLQyL6f7Q-1; Fri, 18 Dec 2020 03:08:01 -0500
X-MC-Unique: R8Ic2qUUOya8ivLQyL6f7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74E091015C84;
        Fri, 18 Dec 2020 08:07:59 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3648771C94;
        Fri, 18 Dec 2020 08:07:53 +0000 (UTC)
Date:   Fri, 18 Dec 2020 09:07:51 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com,
        eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH] arm64: microbench: fix unexpected PPI
Message-ID: <20201218080751.xps77ogq2flsp4e4@kamzik.brq.redhat.com>
References: <20201218071542.15368-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218071542.15368-1-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 18, 2020 at 03:15:42PM +0800, Jingyi Wang wrote:
> For the origin value of CNTV_CVAL_EL0 architecturally UNKNOWN, we may
> receive an unexpected PPI before we actual trigger the timer interrupt.
> So we should set ARCH_TIMER_CTL_IMASK in timer_prep.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 362f93e..95c418c 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -227,7 +227,7 @@ static bool timer_prep(void)
>  	}
>  
>  	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
> -	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
> +	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
>  	isb();
>  
>  	gic_prep_common();
> -- 
> 2.19.1
>

Queued, https://gitlab.com/rhdrjones/kvm-unit-tests/commits/arm/queue

Thanks,
drew 

