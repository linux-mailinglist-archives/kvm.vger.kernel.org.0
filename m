Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FEA233099
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 12:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgG3KxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 06:53:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60397 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726774AbgG3KxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 06:53:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596106392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TZG3QxrqrNChMWWgL/XQYq0U/s4mrgs7me4EpFxSN1w=;
        b=WIF67cuDCxj2k+E9H6lTcexuMdSmnS0ugEjJfwP7PN422G7tvgQrT4tAON0wmTSDxju11V
        OMTC4GvBegImAspJ3watZHD1WyoPIhLSlWAXOR4vltZjnlSz3d4zX1JSn1mxph795pgslA
        ByNpr1A23MRX/hrINWgZ8XL59ViBJKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-r6mFVPu7MeWt3obg1JpdCg-1; Thu, 30 Jul 2020 06:53:10 -0400
X-MC-Unique: r6mFVPu7MeWt3obg1JpdCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B483107ACCA;
        Thu, 30 Jul 2020 10:53:09 +0000 (UTC)
Received: from gondolin (ovpn-112-203.ams2.redhat.com [10.36.112.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCA2E1B46C;
        Thu, 30 Jul 2020 10:53:04 +0000 (UTC)
Date:   Thu, 30 Jul 2020 12:53:02 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] s390x: Add custom pgm cleanup
 function
Message-ID: <20200730125302.28e0e5b6.cohuck@redhat.com>
In-Reply-To: <20200727095415.494318-2-frankja@linux.ibm.com>
References: <20200727095415.494318-1-frankja@linux.ibm.com>
        <20200727095415.494318-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jul 2020 05:54:13 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Sometimes we need to do cleanup which we don't necessarily want to add
> to interrupt.c, so lets add a way to register a cleanup function.

s/lets/let's/

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/asm/interrupt.h |  1 +
>  lib/s390x/interrupt.c     | 10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 4cfade9..b2a7c83 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -15,6 +15,7 @@
>  #define EXT_IRQ_EXTERNAL_CALL	0x1202
>  #define EXT_IRQ_SERVICE_SIG	0x2401
>  
> +void register_pgm_int_func(void (*f)(void));
>  void handle_pgm_int(void);
>  void handle_ext_int(void);
>  void handle_mcck_int(void);
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 243b9c2..51cc733 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -16,6 +16,7 @@
>  
>  static bool pgm_int_expected;
>  static bool ext_int_expected;
> +static void (*pgm_int_func)(void);

Hm, didn't you want to rename this to pgm_cleanup_func?

>  static struct lowcore *lc;
>  
>  void expect_pgm_int(void)
> @@ -51,6 +52,11 @@ void check_pgm_int_code(uint16_t code)
>  	       lc->pgm_int_code);
>  }
>  
> +void register_pgm_int_func(void (*f)(void))

...then, register_pgm_cleanup_func() would probably be a better name
here.

> +{
> +	pgm_int_func = f;
> +}
> +
>  static void fixup_pgm_int(void)
>  {
>  	switch (lc->pgm_int_code) {
> @@ -115,6 +121,10 @@ void handle_pgm_int(void)
>  	}
>  
>  	pgm_int_expected = false;
> +
> +	if (pgm_int_func)
> +		return (*pgm_int_func)();

I'd probably use an else branch, but this is fine as well.

> +
>  	fixup_pgm_int();
>  }
>  

