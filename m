Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1919B2B8D10
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 09:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgKSI0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 03:26:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41330 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726457AbgKSI0t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 03:26:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605774408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpIn2i7sAcQpyxVbay0VI4lL0EOy5fG2XCzYeVTNrlg=;
        b=XxVHffSU5XMzYU4Z755vsEpLjxbzdGJ0W1flXidThDr4YoGpYGsAPF8aua9vxWF+OKTR+0
        vO9i3PcaJ5y/EBr4FN+J9XDGjlg/91HhFrVOHJ7shBsZVW7Jd0rehAQRABSYcjev1Q+yCP
        qtYuhNLteN3JRbO3Y8wGYxR+W8VhKFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-GMrrncfGOKWu7PcFoCyJQQ-1; Thu, 19 Nov 2020 03:26:45 -0500
X-MC-Unique: GMrrncfGOKWu7PcFoCyJQQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEA8B1005D5A;
        Thu, 19 Nov 2020 08:26:44 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D2F66064B;
        Thu, 19 Nov 2020 08:26:39 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/5] s390x: Add test_bit to library
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20201117154215.45855-1-frankja@linux.ibm.com>
 <20201117154215.45855-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <6d61a28d-d822-b9b5-8ec6-1ea0dca1ed70@redhat.com>
Date:   Thu, 19 Nov 2020 09:26:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201117154215.45855-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/11/2020 16.42, Janosch Frank wrote:
> Query/feature bits are commonly tested via MSB bit numbers on
> s390. Let's add test bit functions, so we don't need to copy code to
> test query bits.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/bitops.h   | 16 ++++++++++++++++
>  lib/s390x/asm/facility.h |  3 ++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
> index e7cdda9..a272dd7 100644
> --- a/lib/s390x/asm/bitops.h
> +++ b/lib/s390x/asm/bitops.h
> @@ -7,4 +7,20 @@
>  
>  #define BITS_PER_LONG	64
>  
> +static inline bool test_bit(unsigned long nr,
> +			    const volatile unsigned long *ptr)
> +{
> +	const volatile unsigned char *addr;
> +
> +	addr = ((const volatile unsigned char *)ptr);
> +	addr += (nr ^ (BITS_PER_LONG - 8)) >> 3;
> +	return (*addr >> (nr & 7)) & 1;
> +}
> +
> +static inline bool test_bit_inv(unsigned long nr,
> +				const volatile unsigned long *ptr)
> +{
> +	return test_bit(nr ^ (BITS_PER_LONG - 1), ptr);
> +}

I think you should mention in the patch description that these functions
match the implementations in the kernel (and thus are good for kernel
developers who are used to these).

Thus I think you should also now add a license statement to this file
("SPDX-License-Identifier: GPL-2.0" or so).

With these modifications:
Reviewed-by: Thomas Huth <thuth@redhat.com>

