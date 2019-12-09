Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC8B116C68
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 12:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfLILk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 06:40:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29309 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727326AbfLILk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 06:40:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575891624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=XAASUJToeGbzww/WVJVbmqdcQyBY7i9FVgSgyNNOSl8=;
        b=EbMGrlK6B9cU97D2NFp+vWlc3AHLjPXa8MB6+p+UuVImzMnAfOrfRSSBs0hbUDkNkrTN2s
        E0NAqyoHafrBJ7JAfpgHTnI1lpxc59gXMhvwaP7HtIr1JdiKKCIpoQDbl9LI11KrPLeXlh
        cnfXpKxJos/tQ0guwhMs3QUloSX7QM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-dyatXqGsMK2hj4n9fNzXBQ-1; Mon, 09 Dec 2019 06:40:22 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45E0D802B7E;
        Mon,  9 Dec 2019 11:40:21 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-121.ams2.redhat.com [10.36.116.121])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D8AB5D6C5;
        Mon,  9 Dec 2019 11:40:16 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 3/9] s390: interrupt registration
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-4-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c2decfb9-71e3-556d-2b91-4cd19ad9312a@redhat.com>
Date:   Mon, 9 Dec 2019 12:40:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1575649588-6127-4-git-send-email-pmorel@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: dyatXqGsMK2hj4n9fNzXBQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/2019 17.26, Pierre Morel wrote:
> Define two functions to register and to unregister a call back for IO
> Interrupt handling.
> 
> Per default we keep the old behavior, so does a successful unregister
> of the callback.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/interrupt.c | 23 ++++++++++++++++++++++-
>  lib/s390x/interrupt.h |  7 +++++++
>  2 files changed, 29 insertions(+), 1 deletion(-)
>  create mode 100644 lib/s390x/interrupt.h
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 3e07867..e0eae4d 100644
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
> @@ -140,12 +140,33 @@ void handle_mcck_int(void)
>  		     lc->mcck_old_psw.addr);
>  }
>  
> +static void (*io_int_func)(void);
> +
>  void handle_io_int(void)
>  {
> +	if (*io_int_func)
> +		return (*io_int_func)();
> +
>  	report_abort("Unexpected io interrupt: at %#lx",
>  		     lc->io_old_psw.addr);
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
> +	io_int_func = NULL;
> +	return 0;
> +}
> +
>  void handle_svc_int(void)
>  {
>  	report_abort("Unexpected supervisor call interrupt: at %#lx",
> diff --git a/lib/s390x/interrupt.h b/lib/s390x/interrupt.h
> new file mode 100644
> index 0000000..e945ef7
> --- /dev/null
> +++ b/lib/s390x/interrupt.h
> @@ -0,0 +1,7 @@
> +#ifndef __INTERRUPT_H
> +#include <asm/interrupt.h>
> +
> +int register_io_int_func(void (*f)(void));
> +int unregister_io_int_func(void (*f)(void));
> +
> +#endif
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

