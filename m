Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C580022794F
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 09:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgGUHMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 03:12:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25244 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726782AbgGUHMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 03:12:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595315564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=FTLLsW6xXZH3ZFjwjuR01VT2YKHBFMnvxqR4hnfwWvs=;
        b=hgODTqaTYsiaPQi3842hZXlvGRl6frOs4vEnHjJHzXjzhOZGoZzERbQitdrkq9EQE4etc5
        66uqQje7VuagXQUUJkvHEUFQgqmzhuFb/M3DdUd6DigymEcN2jC9NZPlm4iqTlVIkUEMT/
        0PTr1/tvpVzcpkOb36UnrmFGnWYIZ4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-PTFQGQvAMgWYPgi2Stvl4A-1; Tue, 21 Jul 2020 03:12:41 -0400
X-MC-Unique: PTFQGQvAMgWYPgi2Stvl4A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8AD48018A1;
        Tue, 21 Jul 2020 07:12:40 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-102.ams2.redhat.com [10.36.112.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 14DF687319;
        Tue, 21 Jul 2020 07:12:35 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Add custom pgm cleanup function
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20200717145813.62573-1-frankja@linux.ibm.com>
 <20200717145813.62573-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c8a26cde-5e1f-5e49-c631-2bed93d911ea@redhat.com>
Date:   Tue, 21 Jul 2020 09:12:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200717145813.62573-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/07/2020 16.58, Janosch Frank wrote:
> Sometimes we need to do cleanup which we don't necessarily want to add
> to interrupt.c, so lets add a way to register a cleanup function.
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
>  	switch (lc->pgm_int_code) {
>  	case PGM_INT_CODE_PRIVILEGED_OPERATION:
>  		/* Normal operation is in supervisor state, so this exception
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

