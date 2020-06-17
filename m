Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914081FC86E
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 10:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgFQIVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 04:21:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32624 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725846AbgFQIVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 04:21:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592382068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ug9Lv8PhDyLrDVQL3rPhvFz8zEQJBaxtjpZPOqjHtUQ=;
        b=PCMkeewCxDaAWNnxB2P5Ox6541ur/8MJ3pKmtGjPTrGfugMON91w8kk4GO/jglHedqpJko
        Wn4Z9rKYgmOq43lu1qxW/BHPpgDTHvtOgPMoRYl1oC4oT3MKN0S/U45JSULrbpj7d3ZdGv
        rrkicVyNluMiQavlhAjQ709a81VWz+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-5J0K3unLMXqFRrAFe4bwoQ-1; Wed, 17 Jun 2020 04:21:01 -0400
X-MC-Unique: 5J0K3unLMXqFRrAFe4bwoQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C488E879513;
        Wed, 17 Jun 2020 08:21:00 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A203F5C1BD;
        Wed, 17 Jun 2020 08:20:56 +0000 (UTC)
Date:   Wed, 17 Jun 2020 10:20:53 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v9 04/12] s390x: interrupt registration
Message-ID: <20200617102053.47c4a52c.cohuck@redhat.com>
In-Reply-To: <1592213521-19390-5-git-send-email-pmorel@linux.ibm.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
        <1592213521-19390-5-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Jun 2020 11:31:53 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

Subject: "s390: I/O interrupt registration" ?

> Let's make it possible to add and remove a custom io interrupt handler,
> that can be used instead of the normal one.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/interrupt.c | 23 ++++++++++++++++++++++-
>  lib/s390x/interrupt.h |  8 ++++++++
>  2 files changed, 30 insertions(+), 1 deletion(-)
>  create mode 100644 lib/s390x/interrupt.h
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 3a40cac..243b9c2 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -10,9 +10,9 @@
>   * under the terms of the GNU Library General Public License version 2.
>   */
>  #include <libcflat.h>
> -#include <asm/interrupt.h>
>  #include <asm/barrier.h>
>  #include <sclp.h>
> +#include <interrupt.h>
>  
>  static bool pgm_int_expected;
>  static bool ext_int_expected;
> @@ -144,12 +144,33 @@ void handle_mcck_int(void)
>  		     stap(), lc->mcck_old_psw.addr);
>  }
>  
> +static void (*io_int_func)(void);
> +
>  void handle_io_int(void)
>  {
> +	if (io_int_func)
> +		return io_int_func();
> +
>  	report_abort("Unexpected io interrupt: on cpu %d at %#lx",
>  		     stap(), lc->io_old_psw.addr);
>  }
>  
> +int register_io_int_func(void (*f)(void))
> +{
> +	if (io_int_func)
> +		return -1;
> +	io_int_func = f;
> +	return 0;
> +}
> +
> +int unregister_io_int_func(void (*f)(void))
> +{
> +	if (io_int_func != f)
> +		return -1;

Not sure if we really need these checks, but they don't hurt, either.

> +	io_int_func = NULL;
> +	return 0;
> +}
> +
>  void handle_svc_int(void)
>  {
>  	report_abort("Unexpected supervisor call interrupt: on cpu %d at %#lx",

Acked-by: Cornelia Huck <cohuck@redhat.com>

