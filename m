Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15162116C73
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 12:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfLILnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 06:43:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55182 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727394AbfLILnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 06:43:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575891782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=vH2v+8bPpHfj0U0oMPr/6yE6fJGVMlDi/PGfTb2am+g=;
        b=OQ22tla50B2GFxK2PjHKKSik5Xop3qYaqFJiz9PWUEWIb6TJaYR9Azt+Z42fErRhBV5P+7
        +Fm8rcEz0fynQ28BQpztQTmZAGMYmBBOMT9aSBo7luFXggOQAfx0Xg3ty4tBxttf/M0MHC
        gKB392ic2juS92+3qj5/UaSS+6Ht+80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-fTFHgcWKN4aZcmkZ26GA_A-1; Mon, 09 Dec 2019 06:42:59 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A15C802CBD;
        Mon,  9 Dec 2019 11:42:58 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-121.ams2.redhat.com [10.36.116.121])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E38E41001B03;
        Mon,  9 Dec 2019 11:42:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 4/9] s390x: export the clock
 get_clock_ms() utility
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-5-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <fc6e103d-100b-151b-4a6e-359f3103d5fa@redhat.com>
Date:   Mon, 9 Dec 2019 12:42:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1575649588-6127-5-git-send-email-pmorel@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: fTFHgcWKN4aZcmkZ26GA_A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/2019 17.26, Pierre Morel wrote:
> To serve multiple times, the function get_clock_ms() is moved
> from intercept.c test to the new file asm/time.h.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> ---
>  lib/s390x/asm/time.h | 27 +++++++++++++++++++++++++++
>  s390x/intercept.c    | 11 +----------
>  2 files changed, 28 insertions(+), 10 deletions(-)
>  create mode 100644 lib/s390x/asm/time.h
> 
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> new file mode 100644
> index 0000000..b07ccbd
> --- /dev/null
> +++ b/lib/s390x/asm/time.h
> @@ -0,0 +1,27 @@
> +/*
> + * Clock utilities for s390
> + *
> + * Authors:
> + *  Thomas Huth <thuth@redhat.com>
> + *
> + * Copied from the s390/intercept test by:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +#ifndef _ASM_S390X_TIME_H_
> +#define _ASM_S390X_TIME_H_
> +
> +static inline uint64_t get_clock_ms(void)
> +{
> +	uint64_t clk;
> +
> +	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
> +
> +	/* Bit 51 is incrememented each microsecond */
> +	return (clk >> (63 - 51)) / 1000;
> +}
> +
> +

Please remove one of the two empty lines.

With that cosmetic nit fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>

