Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323D9391B25
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 17:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbhEZPHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 11:07:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233472AbhEZPHu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 11:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622041579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PjLovZI7QWiNVj3Yel3XdwAUC8rzUPkP/bc1/f02aIQ=;
        b=aSfmyRpV9ZKor/R2p2aAn3/wfDcrpRlVHbPQl0yaTIVR8qlErYcCBgogneDwgZ0aC3fWKd
        U9Sw6GfI8cNMQ40jgahevaTkSV0m2TAjtL5AoT4HHJg+6MotOSf0XVfQ+TR/3mifVO8/GR
        l19OCL1LOX68qnxEIzvOZDv7H31tPyw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-gZN-IZcqPomryu_2wOp4Lw-1; Wed, 26 May 2021 11:06:14 -0400
X-MC-Unique: gZN-IZcqPomryu_2wOp4Lw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEFC7107ACE3;
        Wed, 26 May 2021 15:06:12 +0000 (UTC)
Received: from [10.36.112.15] (ovpn-112-15.ams2.redhat.com [10.36.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D716419D9D;
        Wed, 26 May 2021 15:06:09 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 1/4] arm64: remove invalid check from
 its-trigger test
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
        maz@kernel.org
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-2-alex.bennee@linaro.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <70b9dbfb-2b0f-f77b-d779-09dc1f766c7c@redhat.com>
Date:   Wed, 26 May 2021 17:06:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210525172628.2088-2-alex.bennee@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 5/25/21 7:26 PM, Alex Bennée wrote:
> While an IRQ is not "guaranteed to be visible until an appropriate
> invalidation" it doesn't stop the actual implementation delivering it
> earlier if it wants to. This is the case for QEMU's TCG and as tests
> should only be checking architectural compliance this check is
> invalid.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Shashi Mallela <shashi.mallela@linaro.org>
> ---
>  arm/gic.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 98135ef..bef061a 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -732,21 +732,19 @@ static void test_its_trigger(void)
>  			"dev2/eventid=20 does not trigger any LPI");
>  
>  	/*
> -	 * re-enable the LPI but willingly do not call invall
> -	 * so the change in config is not taken into account.
> -	 * The LPI should not hit
> +	 * re-enable the LPI but willingly do not call invall so the
> +	 * change in config is not taken into account. While "A change
So you may need to remove the above comment, ie. "but willingly do not
call invall so the change in config is not taken into account." as the
conclusion of this thread is it can be taken into account immediatly.

and also concat the comment below, "/* Now call the invall and check the
LPI hits */"
This is an "atomic" test now?

with that change
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Thanks

Eric
> +	 * to the LPI configuration is not guaranteed to be visible
> +	 * until an appropriate invalidation operation has completed"
> +	 * hardware that doesn't implement caches may have delivered
> +	 * the event at any point after the enabling.
>  	 */
>  	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
>  	stats_reset();
>  	cpumask_clear(&mask);
>  	its_send_int(dev2, 20);
> -	wait_for_interrupts(&mask);
> -	report(check_acked(&mask, -1, -1),
> -			"dev2/eventid=20 still does not trigger any LPI");
>  
>  	/* Now call the invall and check the LPI hits */
> -	stats_reset();
> -	cpumask_clear(&mask);
>  	cpumask_set_cpu(3, &mask);
>  	its_send_invall(col3);
>  	wait_for_interrupts(&mask);
> 

