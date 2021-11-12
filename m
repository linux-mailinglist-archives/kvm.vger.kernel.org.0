Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EAD44E269
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 08:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbhKLHlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 02:41:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232346AbhKLHlh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 02:41:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636702726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xNi/87i983IT8LoHuNZjW6Y3OWNabGFCpYAA5infiiE=;
        b=ZwsHaFxNrTkZF68l/wnAdmg02BqsAvuw5nBhaKiK4acFLNk/fKEqIeB+2yShKq0YkH6UpP
        z2T/QO7Dj22IEoGn6Bn2pbcf2g//6iRturtgL5gZn5Mtmh0SUkBbaEG0knLURSY85m6PwT
        MgwJu0f13jmK2MWH/KIwkAJFr36X/n0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-qufA0f_tO8yTLeWjCwbNKg-1; Fri, 12 Nov 2021 02:38:45 -0500
X-MC-Unique: qufA0f_tO8yTLeWjCwbNKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D37619200C0;
        Fri, 12 Nov 2021 07:38:44 +0000 (UTC)
Received: from [10.33.192.183] (dhcp-192-183.str.redhat.com [10.33.192.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D22577E26;
        Fri, 12 Nov 2021 07:38:38 +0000 (UTC)
Message-ID: <6b28a9e3-6129-0202-fb2c-6398c3363f28@redhat.com>
Date:   Fri, 12 Nov 2021 08:38:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH] s390x: io: declare s390x CPU as big endian
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <20211111184835.113648-1-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211111184835.113648-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/2021 19.48, Pierre Morel wrote:
> To use the swap byte transformations we need to declare
> the s390x architecture as big endian.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/asm/io.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/lib/s390x/asm/io.h b/lib/s390x/asm/io.h
> index 1dc6283b..b5e661cf 100644
> --- a/lib/s390x/asm/io.h
> +++ b/lib/s390x/asm/io.h
> @@ -10,6 +10,7 @@
>   #define _ASMS390X_IO_H_
>   
>   #define __iomem
> +#define __cpu_is_be() (1)
>   
>   #include <asm-generic/io.h>
>   
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

Alternatively, I think you could also move this sequence from 
lib/ppc64/asm/io.h into lib/asm-generic/io.h:

#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
#define __cpu_is_be() (0)
#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
#define __cpu_is_be() (1)
#else
#error Undefined byte order
#endif

(replacing the hardcoded __cpu_is_be() in the generic code).

  Thomas

