Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67F728EE7F
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 10:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgJOIaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 04:30:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25315 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729227AbgJOIaa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 04:30:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602750628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8RuH8teoWYZGjp5HmLWxmzvKmVOLtSA/ofhHqShv5vw=;
        b=ERxdNmQZEfLZsPlGqkob8Fv02xNb4E2LTuXN//deBL8bIPAcDNfw5dO66UxpnOrwJvPdWd
        FdQiOHMSHJ9Q7jPjr7D9MUZ4DJ5YfHvJsMGYCHa9V+u4r3DVFQ2KK30ZHGCPZI0hzwYLBR
        uBKHfgiepTyO4zU2oph3jgxA/iQiWTA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-w_SeLE9pM-iUwpG0j7de8A-1; Thu, 15 Oct 2020 04:30:27 -0400
X-MC-Unique: w_SeLE9pM-iUwpG0j7de8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56EB8803629
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 08:30:26 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-212.ams2.redhat.com [10.36.112.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41133100238C;
        Thu, 15 Oct 2020 08:30:24 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests 3/3] arm/arm64: Change dcache_line_size to
 ulong
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20201014191444.136782-1-drjones@redhat.com>
 <20201014191444.136782-4-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <f4d0035a-717b-042c-1469-0fdd3843cce7@redhat.com>
Date:   Thu, 15 Oct 2020 10:30:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20201014191444.136782-4-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/2020 21.14, Andrew Jones wrote:
> dcache_line_size is treated like a long in assembly, so make it one.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/arm/asm/processor.h   | 2 +-
>  lib/arm/setup.c           | 2 +-
>  lib/arm64/asm/processor.h | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> index e26ef89000a8..273366d1fe1c 100644
> --- a/lib/arm/asm/processor.h
> +++ b/lib/arm/asm/processor.h
> @@ -89,6 +89,6 @@ static inline u32 get_ctr(void)
>  	return read_sysreg(CTR);
>  }
>  
> -extern u32 dcache_line_size;
> +extern unsigned long dcache_line_size;
>  
>  #endif /* _ASMARM_PROCESSOR_H_ */
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 78562e47c01c..ea714d064afa 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -42,7 +42,7 @@ static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
>  struct mem_region *mem_regions = __initial_mem_regions;
>  phys_addr_t __phys_offset, __phys_end;
>  
> -u32 dcache_line_size;
> +unsigned long dcache_line_size;
>  
>  int mpidr_to_cpu(uint64_t mpidr)
>  {
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 02665b84cc7e..6ee7c1260b6b 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -115,7 +115,7 @@ static inline u64 get_ctr(void)
>  	return read_sysreg(ctr_el0);
>  }
>  
> -extern u32 dcache_line_size;
> +extern unsigned long dcache_line_size;
>  
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM64_PROCESSOR_H_ */
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

