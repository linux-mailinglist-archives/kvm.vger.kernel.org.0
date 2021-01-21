Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A242FEAE2
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 13:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbhAUM6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 07:58:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729383AbhAUM6D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 07:58:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611233796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C9w+mRmd2CN0EezxGvvAoeUc0jXrLh9ZdhFqOvV1prw=;
        b=T0W/RqqANdsWmiPrcwji+rqpKN2sWp+c+t/VStWiiNPLOpFckl8IPJqPg1LMLbOE6flrH9
        kExCfRo9CZkivB3XPbRVR4q1eyi5jKaUfp579rXXdQWgAMYA4AwvyQi/mVfYZhxNloVxhj
        IaPca49LHvXQAvUAZnkwpAPkmJdcKmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-H46CdZlRN36qAtpTAtPm5w-1; Thu, 21 Jan 2021 07:56:34 -0500
X-MC-Unique: H46CdZlRN36qAtpTAtPm5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C752195D584;
        Thu, 21 Jan 2021 12:56:14 +0000 (UTC)
Received: from gondolin (ovpn-113-94.ams2.redhat.com [10.36.113.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8595A5F9C8;
        Thu, 21 Jan 2021 12:56:10 +0000 (UTC)
Date:   Thu, 21 Jan 2021 13:54:40 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] lib/s390x/sclp: Clarify that the
 CPUEntry array could be at a different spot
Message-ID: <20210121135440.7cb55d4b.cohuck@redhat.com>
In-Reply-To: <20210121065703.561444-1-thuth@redhat.com>
References: <20210121065703.561444-1-thuth@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Jan 2021 07:57:03 +0100
Thomas Huth <thuth@redhat.com> wrote:

> The "struct CPUEntry entries[0]" in the ReadInfo structure is misleading
> since the entries could be add a completely different spot. Replace it

s/add/at/

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

This comment is really helpful, as the difference for ELS had actually
slipped my mind again...

>  } __attribute__((packed)) ReadInfo;
>  
>  typedef struct ReadCpuInfo {

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

