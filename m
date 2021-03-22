Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BC6343CE4
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 10:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCVJcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 05:32:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229931AbhCVJbg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 05:31:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616405496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JpP864OhAelqi2XxdlcwzQsHQU1z0raGRpWasPWndnM=;
        b=ZKNKJOpVx/Szerk2AcCz/Hx/CquWpDRQXwDSgqrB16m+kYC1onXzdfFeRBkl8ZATTm8J1r
        9lFq/YMv9TgqIVHDfsTMCxI+INywfwO3SNu+qwIJWUlI1ofvf105yM7KwECbsrH2QqVCJL
        59hJZML0Y9NXTYhzPgNzLsD/KlWsQ3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-t_ROxPNdM-aqWdsWDkF1Ug-1; Mon, 22 Mar 2021 05:31:31 -0400
X-MC-Unique: t_ROxPNdM-aqWdsWDkF1Ug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDF441034B34;
        Mon, 22 Mar 2021 09:31:29 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A100260C04;
        Mon, 22 Mar 2021 09:31:28 +0000 (UTC)
Date:   Mon, 22 Mar 2021 10:31:25 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH 1/4] arm/arm64: Avoid calling
 cpumask_test_cpu for CPUs above nr_cpu
Message-ID: <20210322093125.qlbr3wjvinyu7o6m@kamzik.brq.redhat.com>
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
 <20210319122414.129364-2-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319122414.129364-2-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 12:24:11PM +0000, Nikos Nikoleris wrote:
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/arm/asm/cpumask.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/arm/asm/cpumask.h b/lib/arm/asm/cpumask.h
> index 6683bb6..02124de 100644
> --- a/lib/arm/asm/cpumask.h
> +++ b/lib/arm/asm/cpumask.h
> @@ -105,7 +105,7 @@ static inline void cpumask_copy(cpumask_t *dst, const cpumask_t *src)
>  
>  static inline int cpumask_next(int cpu, const cpumask_t *mask)
>  {
> -	while (cpu < nr_cpus && !cpumask_test_cpu(++cpu, mask))
> +	while (++cpu < nr_cpus && !cpumask_test_cpu(cpu, mask))
>  		;
>  	return cpu;

This looks like the right thing to do, but I'm surprised that
I've never seen an assert in cpumask_test_cpu, even though
it looks like we call cpumask_next with cpu == nr_cpus - 1
in several places.

Can you please add a commit message explaining how you found
this bug?

Thanks,
drew

