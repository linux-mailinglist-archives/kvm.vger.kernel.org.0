Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49188135E88
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387792AbgAIQoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:44:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22820 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387468AbgAIQoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 11:44:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578588247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=5PWz96YXEW9H8kGncu+HTEQ2fVw5ek+taBOP1ObiuxM=;
        b=DbRMctgQYE0IYHRRBA7ZrFI2JC+gA7bM3WEXC7S6iswCHZhUS6VpHkasKJEisyGLw7gEwo
        OSiiCeHIflcBhit3ps0YzlzwY3sUCff6PAoJc8Xh8EsXktE7T8CbKClXJ3JqotGgFXbX1x
        KMd5PubwxXc//4TEAqNUYXQfLhwdVAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-njIotr9PM32U7rSM80pW7g-1; Thu, 09 Jan 2020 11:44:04 -0500
X-MC-Unique: njIotr9PM32U7rSM80pW7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE7B790203F;
        Thu,  9 Jan 2020 16:44:02 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-32.ams2.redhat.com [10.36.117.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF01E61069;
        Thu,  9 Jan 2020 16:43:56 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v6 3/4] s390x: lib: add SPX and STPX
 instruction wrapper
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <20200109161625.154894-1-imbrenda@linux.ibm.com>
 <20200109161625.154894-4-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5c6f563e-3d09-5274-b050-a64122097e9b@redhat.com>
Date:   Thu, 9 Jan 2020 17:43:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200109161625.154894-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/01/2020 17.16, Claudio Imbrenda wrote:
> Add a wrapper for the SET PREFIX and STORE PREFIX instructions, and
> use it instead of using inline assembly everywhere.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 10 ++++++++++
>  s390x/intercept.c        | 33 +++++++++++++--------------------
>  2 files changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 1a5e3c6..465fe0f 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -284,4 +284,14 @@ static inline int servc(uint32_t command, unsigned long sccb)
>  	return cc;
>  }
>  
> +static inline void spx(uint32_t *new_prefix)

Looking at this a second time ... why is new_prefix a pointer? A normal
value should be sufficient here, shouldn't it?

> +{
> +	asm volatile("spx %0" : : "Q" (*new_prefix) : "memory");
> +}
> +
> +static inline void stpx(uint32_t *current_prefix)
> +{
> +	asm volatile("stpx %0" : "=Q" (*current_prefix));
> +}
> +

 Thomas

