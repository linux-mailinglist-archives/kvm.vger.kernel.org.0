Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E417142977
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 12:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgATLaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 06:30:09 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27115 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726451AbgATLaJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 06:30:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579519808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m960agLCjRzcUn/mYA4HIf0uj8dMob5viCb3ZitrCno=;
        b=e+6Z/R/Ji5ZH/zqnp0GFG/Wdx9jCYSq38iuLdpBYNTDoBKt8Uyiphk0CyluvVyNzCtmMyc
        b5TnzUtOqme6b4jcASvc/RXH87Npplx8d/AgJu4ulkOZe8wnZxVY7xdLWTeHN884rXXaZQ
        cSqNLtRs7HZ2aq28Iyu8qoXW2+N6QEc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-ga5C8PU0MzyR-xnfr5-TBw-1; Mon, 20 Jan 2020 06:30:05 -0500
X-MC-Unique: ga5C8PU0MzyR-xnfr5-TBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 058DC8017CC;
        Mon, 20 Jan 2020 11:30:04 +0000 (UTC)
Received: from gondolin (ovpn-205-161.brq.redhat.com [10.40.205.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC75F860E0;
        Mon, 20 Jan 2020 11:29:59 +0000 (UTC)
Date:   Mon, 20 Jan 2020 12:29:56 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 7/9] s390x: smp: Remove unneeded cpu
 loops
Message-ID: <20200120122956.6879d159.cohuck@redhat.com>
In-Reply-To: <20200117104640.1983-8-frankja@linux.ibm.com>
References: <20200117104640.1983-1-frankja@linux.ibm.com>
        <20200117104640.1983-8-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Jan 2020 05:46:38 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Now that we have a loop which is executed after we return from the
> main function of a secondary cpu, we can remove the surplus loops.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 555ed72..c12a3db 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -29,15 +29,9 @@ static void wait_for_flag(void)
>  	}
>  }
>  
> -static void cpu_loop(void)
> -{
> -	for (;;) {}
> -}
> -
>  static void test_func(void)
>  {
>  	testflag = 1;
> -	cpu_loop();
>  }
>  
>  static void test_start(void)
> @@ -234,7 +228,7 @@ int main(void)
>  
>  	/* Setting up the cpu to give it a stack and lowcore */
>  	psw.mask = extract_psw_mask();
> -	psw.addr = (unsigned long)cpu_loop;
> +	psw.addr = (unsigned long)test_func;

Before, you did not set testflag here... intended change?

>  	smp_cpu_setup(1, psw);
>  	smp_cpu_stop(1);
>  

