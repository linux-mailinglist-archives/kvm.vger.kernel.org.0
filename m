Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B86310A59
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 12:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhBELgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 06:36:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231737AbhBELZr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 06:25:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612524239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1khU1C0GfELsGU0Fj00nuXnaZ6zgV1rmRJ0fb1z6uq4=;
        b=AjFOFKQTWbJtq8r016vXaDCLfA9a/Uf9lKMqe8U05mulXa+4klC24g8t7VmMrIbsQL+MBZ
        JlvoXKdxB/zQEoxI3twmUgxFoW+MHiDojIw2ElfyowQWTVVUkELhNLzjazPdkouESl7dAH
        OPjGvppGORwfcekfDLyx8NpExEG3xTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-YGIWRmuOO8-Sgup-V2dHqQ-1; Fri, 05 Feb 2021 06:23:57 -0500
X-MC-Unique: YGIWRmuOO8-Sgup-V2dHqQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 744C8107ACC7;
        Fri,  5 Feb 2021 11:23:56 +0000 (UTC)
Received: from [10.36.113.43] (ovpn-113-43.ams2.redhat.com [10.36.113.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 08C3D60DA1;
        Fri,  5 Feb 2021 11:23:54 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 10/11] arm64: gic: its-trigger: Don't
 trigger the LPI while it is pending
To:     Alexandru Elisei <alexandru.elisei@arm.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, Zenghui Yu <yuzenghui@huawei.com>
References: <20210129163647.91564-1-alexandru.elisei@arm.com>
 <20210129163647.91564-11-alexandru.elisei@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a3d1c79d-22d8-f1f0-f594-6ce616401950@redhat.com>
Date:   Fri, 5 Feb 2021 12:23:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210129163647.91564-11-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/29/21 5:36 PM, Alexandru Elisei wrote:
> The its-trigger test checks that LPI 8195 is not delivered to the CPU while
> it is disabled at the ITS level. After that it is re-enabled and the test
> checks that the interrupt is properly asserted. After it's re-enabled and
> before the stats are examined, the test triggers the interrupt again, which
> can lead to the same interrupt being delivered twice: once after the
> configuration invalidation and before the INT command, and once after the
> INT command.
> 
> Add an explicit check that the interrupt has fired after the invalidation.
> Leave the check after the INT command to make sure the INT command still
> works for the now re-enabled LPI.
> 
> CC: Auger Eric <eric.auger@redhat.com>
> Suggested-by: Zenghui Yu <yuzenghui@huawei.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  arm/gic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index af2c112336e7..8bc2a35908f2 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -802,6 +802,9 @@ static void test_its_trigger(void)
>  
>  	/* Now call the invall and check the LPI hits */
>  	its_send_invall(col3);
> +	lpi_stats_expect(3, 8195);
> +	check_lpi_stats("dev2/eventid=20 pending LPI is received");
> +
>  	lpi_stats_expect(3, 8195);
>  	its_send_int(dev2, 20);
>  	check_lpi_stats("dev2/eventid=20 now triggers an LPI");
> 

