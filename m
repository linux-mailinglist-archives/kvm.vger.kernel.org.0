Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E2222AE88
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 14:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgGWMBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 08:01:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53075 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbgGWMBY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jul 2020 08:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595505682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cPGyi1XLifSOA1yXGeuHZfsgFwwkLUi8q0Ep7G+DUCY=;
        b=KvcKO0ft8j8SueUe1VJWcseIgLafzS1iP1cA8SlBdAKs4+T0BSywUSwK6u3w8zhe22n/7K
        /ZxonMEQLs8qpsmRcC3Dh375UaUxQ/OOZr288F3sUxrHDp/Uo2NVSgmPP8fPekWElFHxje
        k1G6Mdg49QwEMsNwA6GXhEkgkk/N7i4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-F-ByViL0PHWhKmEDT2pKwQ-1; Thu, 23 Jul 2020 08:01:20 -0400
X-MC-Unique: F-ByViL0PHWhKmEDT2pKwQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EE638064DE;
        Thu, 23 Jul 2020 12:01:19 +0000 (UTC)
Received: from gondolin (ovpn-112-228.ams2.redhat.com [10.36.112.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF78219C4F;
        Thu, 23 Jul 2020 12:01:14 +0000 (UTC)
Date:   Thu, 23 Jul 2020 14:01:12 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Add custom pgm cleanup
 function
Message-ID: <20200723140112.6525ddba.cohuck@redhat.com>
In-Reply-To: <20200717145813.62573-2-frankja@linux.ibm.com>
References: <20200717145813.62573-1-frankja@linux.ibm.com>
        <20200717145813.62573-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Jul 2020 10:58:11 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Sometimes we need to do cleanup which we don't necessarily want to add
> to interrupt.c, so lets add a way to register a cleanup function.

s/lets/let's/ :)

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/interrupt.h | 1 +
>  lib/s390x/interrupt.c     | 9 +++++++++
>  2 files changed, 10 insertions(+)
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
> index 243b9c2..36ba720 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -16,6 +16,7 @@
>  
>  static bool pgm_int_expected;
>  static bool ext_int_expected;
> +static void (*pgm_int_func)(void);
>  static struct lowcore *lc;
>  
>  void expect_pgm_int(void)
> @@ -51,8 +52,16 @@ void check_pgm_int_code(uint16_t code)
>  	       lc->pgm_int_code);
>  }
>  
> +void register_pgm_int_func(void (*f)(void))
> +{
> +	pgm_int_func = f;
> +}
> +
>  static void fixup_pgm_int(void)
>  {
> +	if (pgm_int_func)
> +		return (*pgm_int_func)();
> +

Maybe rather call this function, if set, instead of fixup_pgm_int() in
handle_pgm_int()? Feels a bit cleaner to me.
		
>  	switch (lc->pgm_int_code) {
>  	case PGM_INT_CODE_PRIVILEGED_OPERATION:
>  		/* Normal operation is in supervisor state, so this exception

