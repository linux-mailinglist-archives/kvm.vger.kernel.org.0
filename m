Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845CC395975
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 13:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhEaLNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 07:13:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230518AbhEaLNI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 07:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622459488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bN/jO0qq7kWNB8J3VG5LjI9UZDxmWoc3uI17iUOD0D8=;
        b=JfPaF5vRITTSJrNLI4zEwhIFA3PKKKj932n0BYoHn3C0DB1RPt80fk6taM6moMolGMlCf4
        3Lri1gUp2gB+79ZPervBRMH+/nR51ZdqTu3vnVBeiy9vH4fGzLhlq9PeTy6QYJKtSfEUoR
        JxFS8HqgpytmLye1EWsj++IUqfivnVw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-xNs7B_lGODW5iEDouCLVvg-1; Mon, 31 May 2021 07:11:27 -0400
X-MC-Unique: xNs7B_lGODW5iEDouCLVvg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3400B8049D0;
        Mon, 31 May 2021 11:11:26 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-190.ams2.redhat.com [10.36.113.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3F48BA63;
        Mon, 31 May 2021 11:11:21 +0000 (UTC)
Date:   Mon, 31 May 2021 13:11:19 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH] s390x: selftest: Fix report output
Message-ID: <20210531131119.65587773.cohuck@redhat.com>
In-Reply-To: <20210531105003.44737-1-frankja@linux.ibm.com>
References: <20210531105003.44737-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 31 May 2021 10:50:03 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> To make our TAP parser (and me) happy we don't want to have to reports

"we want to have two reports" ?

If that's not what has been intended, I'm confused :)

> with exactly the same wording.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/selftest.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/s390x/selftest.c b/s390x/selftest.c
> index b2fe2e7b..c2ca9896 100644
> --- a/s390x/selftest.c
> +++ b/s390x/selftest.c
> @@ -47,12 +47,19 @@ static void test_malloc(void)
>  	*tmp2 = 123456789;
>  	mb();
>  
> -	report((uintptr_t)tmp & 0xf000000000000000ul, "malloc: got vaddr");
> -	report(*tmp == 123456789, "malloc: access works");
> +	report_prefix_push("malloc");
> +	report_prefix_push("ptr_0");
> +	report((uintptr_t)tmp & 0xf000000000000000ul, "allocated memory");
> +	report(*tmp == 123456789, "wrote allocated memory");
> +	report_prefix_pop();
> +
> +	report_prefix_push("ptr_1");
>  	report((uintptr_t)tmp2 & 0xf000000000000000ul,
> -	       "malloc: got 2nd vaddr");
> -	report((*tmp2 == 123456789), "malloc: access works");
> -	report(tmp != tmp2, "malloc: addresses differ");
> +	       "allocated memory");
> +	report((*tmp2 == 123456789), "wrote allocated memory");
> +	report_prefix_pop();
> +
> +	report(tmp != tmp2, "allocated memory addresses differ");
>  
>  	expect_pgm_int();
>  	configure_dat(0);
> @@ -62,6 +69,7 @@ static void test_malloc(void)
>  
>  	free(tmp);
>  	free(tmp2);
> +	report_prefix_pop();
>  }
>  
>  int main(int argc, char**argv)

