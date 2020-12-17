Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C302DD15F
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 13:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgLQMSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 07:18:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727418AbgLQMSt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 07:18:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608207443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mwquigWlR6PgHU55KZ6NPPZP+yyXZW6wmWHqQDj557I=;
        b=bU0A1eAqLjJ+8CBcFBgpijCNzWsN7IPHH2bqv9zx05WEelRfeqVQB9BoJz+PQBC7qsFvTG
        UoIWKynzyFs+PL4IhRsYnl7zm4uqsr6sS56vAkfgFxuCWUdt0nVoi5HZHpAkQBu4YJmcQQ
        mq0d4bDrKbI+2fSGdRux3yrnTqVV7EE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-qzzrljpaN-C4QweElTRBgg-1; Thu, 17 Dec 2020 07:17:19 -0500
X-MC-Unique: qzzrljpaN-C4QweElTRBgg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AA0E59;
        Thu, 17 Dec 2020 12:17:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5290A60CE7;
        Thu, 17 Dec 2020 12:17:16 +0000 (UTC)
Date:   Thu, 17 Dec 2020 13:17:14 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 1/1] arm: pmu: Don't read PMCR if PMU is
 not present
Message-ID: <20201217121714.kq7z3i6mj62hcu2z@kamzik.brq.redhat.com>
References: <20201217120057.88562-1-alexandru.elisei@arm.com>
 <20201217120057.88562-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217120057.88562-2-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 17, 2020 at 12:00:57PM +0000, Alexandru Elisei wrote:
> For arm and arm64, the PMU is an optional part of the architecture.
> According to ARM DDI 0487F.b, page D13-3683, accessing PMCR_EL0 when the
> PMU is not present generates an undefined exception (one would assume that
> this is also true for arm).
> 
> The pmu_probe() function reads the register before checking that a PMU is
> present, so defer accessing PMCR_EL0 until after we know that it is safe.
> 
> This hasn't been a problem so far because there's no hardware in the wild
> without a PMU and KVM, contrary to the architecture, has treated the PMU
> registers as RAZ/WI if the VCPU doesn't have the PMU feature. However,
> that's about to change as KVM will start treating the registers as
> undefined when the guest doesn't have a PMU.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/pmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index cc959e6a5c76..15c542a230ea 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -988,7 +988,7 @@ static void pmccntr64_test(void)
>  /* Return FALSE if no PMU found, otherwise return TRUE */
>  static bool pmu_probe(void)
>  {
> -	uint32_t pmcr = get_pmcr();
> +	uint32_t pmcr;
>  	uint8_t implementer;
>  
>  	pmu.version = get_pmu_version();
> @@ -997,6 +997,7 @@ static bool pmu_probe(void)
>  
>  	report_info("PMU version: 0x%x", pmu.version);
>  
> +	pmcr = get_pmcr();
>  	implementer = (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK;
>  	report_info("PMU implementer/ID code: %#"PRIx32"(\"%c\")/%#"PRIx32,
>  		    (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
> -- 
> 2.29.2
>

Queued, https://gitlab.com/rhdrjones/kvm-unit-tests/commits/arm/queue

Thanks,
drew 

