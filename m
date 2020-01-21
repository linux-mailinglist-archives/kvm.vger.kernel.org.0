Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B331436FD
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 07:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgAUGTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 01:19:30 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60594 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725916AbgAUGT3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 01:19:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579587568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=da3iuAcDc284IQUFQw4++S79+7I/H/FTovBCbpeQVtc=;
        b=SgfYLqbqpRzqGrFwV2a5Tm5x4ylTnYh14ZWIPJPqGgEAUTMWwMfs580kOzgBTEIzH/Gw1r
        pZrK4eRqOH5sOgoLTvDhEceH1pucfL/by0OoId0HQLAN/5uOIxNXWacvbkNoRh2aoJNExy
        MbaxgTy8DQVe9nAsUk7xTWg5aW5rCss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-P2PmQ7H4O76mbDrvHL4caw-1; Tue, 21 Jan 2020 01:19:25 -0500
X-MC-Unique: P2PmQ7H4O76mbDrvHL4caw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 100B4107ACC7;
        Tue, 21 Jan 2020 06:19:24 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-121.ams2.redhat.com [10.36.116.121])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D32F860DA;
        Tue, 21 Jan 2020 06:19:20 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 5/6] s390x: lib: fix program interrupt
 handler if sclp_busy was set
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <20200120184256.188698-1-imbrenda@linux.ibm.com>
 <20200120184256.188698-6-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <490d9ca5-feff-039d-e257-5a17d7ec0112@redhat.com>
Date:   Tue, 21 Jan 2020 07:19:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200120184256.188698-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2020 19.42, Claudio Imbrenda wrote:
> Fix the program interrupt handler for the case where sclp_busy is set.
> 
> The interrupt handler will attempt to write an error message on the
> console using the SCLP, and will wait for sclp_busy to become false
> before doing so. If an exception happenes between setting the flag and
> the SCLP call, or if the call itself raises an exception, we need to
> clear the flag so we can successfully print the error message.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/interrupt.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 05f30be..ccb376a 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -106,10 +106,13 @@ static void fixup_pgm_int(void)
>  
>  void handle_pgm_int(void)
>  {
> -	if (!pgm_int_expected)
> +	if (!pgm_int_expected) {
> +		/* Force sclp_busy to false, otherwise we will loop forever */
> +		sclp_handle_ext();
>  		report_abort("Unexpected program interrupt: %d at %#lx, ilen %d\n",
>  			     lc->pgm_int_code, lc->pgm_old_psw.addr,
>  			     lc->pgm_int_id);
> +	}
>  
>  	pgm_int_expected = false;
>  	fixup_pgm_int();
> 

Acked-by: Thomas Huth <thuth@redhat.com>

