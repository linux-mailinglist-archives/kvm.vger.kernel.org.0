Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42BA2FEB0F
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 14:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731430AbhAUNFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 08:05:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48709 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731521AbhAUNFN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 08:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611234226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XKE8Ikbo44gU9oAzuqYUZ4W2KReI/37u3ACjWhbsuLo=;
        b=NQtJ0vz7s3jALmmGSS+gGxI/Ug5DSz/OBfCKctOBh2KL9EO9VjRDB3mYKfg5qzmGOgA76L
        Qfzm/GzD9dnBgZYJgcqvezAAbmqAdxctlLsg5rQ0xtWuddN3ItRpEsKzcGMqc6yRbMcHLO
        /J8kSIIwvlxcH4s3DXvuxVChEL2ZRVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-_RDPoQBkPKq70BVxR1SsKQ-1; Thu, 21 Jan 2021 08:03:43 -0500
X-MC-Unique: _RDPoQBkPKq70BVxR1SsKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04DFB806665;
        Thu, 21 Jan 2021 13:03:42 +0000 (UTC)
Received: from [10.36.115.70] (ovpn-115-70.ams2.redhat.com [10.36.115.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2551B2DAD0;
        Thu, 21 Jan 2021 13:03:40 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] lib/s390x/sclp: Clarify that the CPUEntry
 array could be at a different spot
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     cohuck@redhat.com
References: <20210121065703.561444-1-thuth@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <91340a60-2424-b798-54db-0baede574dbe@redhat.com>
Date:   Thu, 21 Jan 2021 14:03:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210121065703.561444-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.01.21 07:57, Thomas Huth wrote:
> The "struct CPUEntry entries[0]" in the ReadInfo structure is misleading
> since the entries could be add a completely different spot. Replace it
> by a proper comment instead.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/sclp.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 9f81c0f..8523133 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -131,10 +131,15 @@ typedef struct ReadInfo {
>  	uint16_t highest_cpu;
>  	uint8_t  _reserved5[124 - 122];     /* 122-123 */
>  	uint32_t hmfai;
> -	uint8_t reserved7[134 - 128];
> +	uint8_t reserved7[134 - 128];       /* 128-133 */
>  	uint8_t byte_134_diag318 : 1;
>  	uint8_t : 7;
> -	struct CPUEntry entries[0];
> +	/*
> +	 * At the end of the ReadInfo, there are also the CPU entries (see
> +	 * struct CPUEntry). When the Extended-Length SCCB (ELS) feature is
> +	 * enabled, the start of the CPU entries array begins at an offset
> +	 * denoted by the offset_cpu field, otherwise it's at offset 128.
> +	 */
>  } __attribute__((packed)) ReadInfo;
>  
>  typedef struct ReadCpuInfo {
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

