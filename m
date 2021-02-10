Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D98316532
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 12:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhBJL1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 06:27:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230394AbhBJLZj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 06:25:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612956251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4xXmzCp16uCSyaK18QJkIBZ4yfdIl2fEn0iAMZ1KEds=;
        b=GFXiPZOqtRKEU8toWMbruqv+L00CpbqYJNmFkHNB1WPBYAwniq6rknIo4Xci1jXJDlCI9L
        M8UEHdwcNdKU/6WirBgo1FOtdfdPVd8MnyzTSGN4HtqNpP4vD9XRQR6Up0slBlScPEtrpn
        Xr22rQcdB3lE65V3RUEmuJL7AkQ5NEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-IQur6wwVOhGZejMa_XFfiw-1; Wed, 10 Feb 2021 06:24:07 -0500
X-MC-Unique: IQur6wwVOhGZejMa_XFfiw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49027100CCC2;
        Wed, 10 Feb 2021 11:24:06 +0000 (UTC)
Received: from gondolin (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C6D07C80A;
        Wed, 10 Feb 2021 11:23:59 +0000 (UTC)
Date:   Wed, 10 Feb 2021 12:23:56 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 2/3] s390x: check for specific program
 interrupt
Message-ID: <20210210122356.13f07c91.cohuck@redhat.com>
In-Reply-To: <20210209185154.1037852-3-imbrenda@linux.ibm.com>
References: <20210209185154.1037852-1-imbrenda@linux.ibm.com>
        <20210209185154.1037852-3-imbrenda@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  9 Feb 2021 19:51:53 +0100
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> We already have check_pgm_int_code to check and report if a specific
> program interrupt has occourred, but this approach has some issues.

s/occourred/occurred/

> 
> In order to specify which test is being run, it was needed to push and
> pop a prefix for each test, which is not nice to read both in the code
> and in the output.
> 
> Another issue is that sometimes the condition to test for might require
> other checks in addition to the interrupt.
> 
> The simple function added in this patch tests if the program intteruupt

s/intteruupt/interrupt/

> received is the one expected.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/interrupt.h | 1 +
>  lib/s390x/interrupt.c     | 6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 1a2e2cd8..a33437b1 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -23,6 +23,7 @@ void expect_pgm_int(void);
>  void expect_ext_int(void);
>  uint16_t clear_pgm_int(void);
>  void check_pgm_int_code(uint16_t code);
> +int is_pgm(int expected);
>  
>  /* Activate low-address protection */
>  static inline void low_prot_enable(void)
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 59e01b1a..6f660285 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -51,6 +51,12 @@ void check_pgm_int_code(uint16_t code)
>  	       lc->pgm_int_code);
>  }
>  
> +int is_pgm(int expected)

is_pgm() is a bit non-descriptive. Maybe check_pgm_int_code_noreport()?

Also, maybe let it take a uint16_t parameter?

> +{
> +	mb();
> +	return expected == lc->pgm_int_code;
> +}
> +
>  void register_pgm_cleanup_func(void (*f)(void))
>  {
>  	pgm_cleanup_func = f;

