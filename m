Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D852D2A4C5D
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 18:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgKCRKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 12:10:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728524AbgKCRKi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 12:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604423437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hNhxIcil9wFWygpryW59M4MmWdq8m0vuyMf5//zFtSw=;
        b=iUJrag+qj0lideAfZkRuO+nmHfYo7tydHKTX1UYb0LN14QaNQWVrX0IeqLWfYnnonGzIIU
        T4zBIAfSBZRs+s14YOT+TVXjK26WxT/XVQYO/prrTj+EOfEPVJtFUjXzueSikpD9MxVfzr
        rLE+J6EM4Q962zCP3g4wGzbSwN0mAgs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-LNPgoV72Mk69UVoVryl3lQ-1; Tue, 03 Nov 2020 12:10:33 -0500
X-MC-Unique: LNPgoV72Mk69UVoVryl3lQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27EF318C9F47;
        Tue,  3 Nov 2020 17:10:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 48A4C73675;
        Tue,  3 Nov 2020 17:10:30 +0000 (UTC)
Date:   Tue, 3 Nov 2020 18:10:27 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH 2/2] arm: Add support for the DEVICE_nGRE
 and NORMAL_WT memory types
Message-ID: <20201103171027.jl7lrgp4bht4peo2@kamzik.brq.redhat.com>
References: <20201102115311.103750-1-nikos.nikoleris@arm.com>
 <20201102115311.103750-3-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102115311.103750-3-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 11:53:11AM +0000, Nikos Nikoleris wrote:
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/arm64/asm/pgtable-hwdef.h | 2 ++
>  arm/cstart64.S                | 6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
> index 3b6b0d6..16b59ba 100644
> --- a/lib/arm64/asm/pgtable-hwdef.h
> +++ b/lib/arm64/asm/pgtable-hwdef.h
> @@ -143,5 +143,7 @@
>  #define MT_DEVICE_GRE		2
>  #define MT_NORMAL_NC		3	/* writecombine */
>  #define MT_NORMAL		4
> +#define MT_NORMAL_WT		5
> +#define MT_DEVICE_nGRE		6
>  
>  #endif /* _ASMARM64_PGTABLE_HWDEF_H_ */
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index cedc678..540994d 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -154,6 +154,8 @@ halt:
>   *   DEVICE_GRE         010     00001100
>   *   NORMAL_NC          011     01000100
>   *   NORMAL             100     11111111
> + *   NORMAL_WT          101     10111011
> + *   DEVICE_nGRE        110     00001000
>   */
>  #define MAIR(attr, mt) ((attr) << ((mt) * 8))
>  
> @@ -184,7 +186,9 @@ asm_mmu_enable:
>  		     MAIR(0x04, MT_DEVICE_nGnRE) |	\
>  		     MAIR(0x0c, MT_DEVICE_GRE) |	\
>  		     MAIR(0x44, MT_NORMAL_NC) |		\
> -		     MAIR(0xff, MT_NORMAL)
> +		     MAIR(0xff, MT_NORMAL) |	        \
> +		     MAIR(0xbb, MT_NORMAL_WT) |         \
> +		     MAIR(0x08, MT_DEVICE_nGRE)
>  	msr	mair_el1, x1
>  
>  	/* TTBR0 */
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

