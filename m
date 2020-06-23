Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5789204968
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 07:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbgFWF6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 01:58:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36676 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728800AbgFWF6I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 01:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592891884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=aj4SuPjLneX18FcbURn8U5Ip+IljG/R90Cts/mGJoD4=;
        b=jEj/yfKfwSYXEmovr0DjZ3uSesTqnUGLJYnj2qxd8XDqFgCS5jO/CmKSvXuT3e5oTomUdi
        0S+C60pnVRzwDabwQWv5DvBlHtrHwHUfAn91o/qJXrDG9dPb+I1MV+4kM/tmKg9KTnVw1f
        hNvhJSyjYHBBKf3qmefwi5UgA8XyhxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-RZl-KAqUMQm3wAAaazGBIQ-1; Tue, 23 Jun 2020 01:57:58 -0400
X-MC-Unique: RZl-KAqUMQm3wAAaazGBIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEA30804001;
        Tue, 23 Jun 2020 05:57:57 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 73C8A7CCE8;
        Tue, 23 Jun 2020 05:57:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 4/8] lib/alloc.c: add overflow check for
 calloc
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com
References: <20200622162141.279716-1-imbrenda@linux.ibm.com>
 <20200622162141.279716-5-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <efb517a5-f5d7-e870-2bb6-654690121c20@redhat.com>
Date:   Tue, 23 Jun 2020 07:57:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200622162141.279716-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/2020 18.21, Claudio Imbrenda wrote:
> Add an overflow check for calloc to prevent potential multiplication overflow.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/alloc.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/alloc.c b/lib/alloc.c
> index ed8f5f9..f4aa87a 100644
> --- a/lib/alloc.c
> +++ b/lib/alloc.c
> @@ -6,9 +6,43 @@ void *malloc(size_t size)
>  	return memalign(sizeof(long), size);
>  }
>  
> +static bool mult_overflow(size_t a, size_t b)
> +{
> +#if BITS_PER_LONG == 32
> +	/* 32 bit system, easy case: just use u64 */
> +	return (u64)a * (u64)b >= (1ULL << 32);
> +#else
> +#ifdef __SIZEOF_INT128__
> +	/* if __int128 is available use it (like the u64 case above) */
> +	unsigned __int128 res = a;
> +	res *= b;
> +	res >>= 64;
> +	return res != 0;
> +#else
> +	u64 tmp;
> +
> +	if ((a >> 32) && (b >> 32))
> +		return true;
> +	if (!(a >> 32) && !(b >> 32))
> +		return false;
> +	tmp = (u32)a;
> +	tmp *= (u32)b;
> +	tmp >>= 32;
> +	if (a < b)
> +		tmp += a * (b >> 32);
> +	else
> +		tmp += b * (a >> 32);
> +	return tmp >> 32;
> +#endif /* __SIZEOF_INT128__ */
> +#endif /* BITS_PER_LONG == 32 */
> +}

This caused a new regression in the CI:

 https://gitlab.com/huth/kvm-unit-tests/-/jobs/606930599#L1754

 https://travis-ci.com/github/huth/kvm-unit-tests/jobs/352515116#L546

lib/alloc.c: In function 'mult_overflow':
lib/alloc.c:24:9: error: right shift count >= width of type
[-Werror=shift-count-overflow]
   24 |  if ((a >> 32) && (b >> 32))
      |         ^~
lib/alloc.c:24:22: error: right shift count >= width of type
[-Werror=shift-count-overflow]
   24 |  if ((a >> 32) && (b >> 32))
      |                      ^~
lib/alloc.c:26:10: error: right shift count >= width of type
[-Werror=shift-count-overflow]
   26 |  if (!(a >> 32) && !(b >> 32))
      |          ^~
lib/alloc.c:26:24: error: right shift count >= width of type
[-Werror=shift-count-overflow]
   26 |  if (!(a >> 32) && !(b >> 32))
      |                        ^~
lib/alloc.c:32:17: error: right shift count >= width of type
[-Werror=shift-count-overflow]
   32 |   tmp += a * (b >> 32);
      |                 ^~
lib/alloc.c:34:17: error: right shift count >= width of type
[-Werror=shift-count-overflow]
   34 |   tmp += b * (a >> 32);
      |                 ^~
cc1: all warnings being treated as errors

Claudio, any ideas how to fix that?

Paolo, could you maybe push your staging branches to Githab or Gitlab
first, to see whether there are any regressions in Travis or Gitlab-CI
before you push the branch to the main repo? ... almost all of the
recent updates broke something, and analyzing the problems afterwards is
a little bit cumbersome...

 Thomas

