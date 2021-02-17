Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2979131DCDB
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 17:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbhBQQCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 11:02:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233811AbhBQQCu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 11:02:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613577684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cmZglzZ54ozWbqqK1NjGe7+944JUuKg5N2LK9/XrvMA=;
        b=UzGoMGvs1LMb7mJAEhVGfeYDRsEJEMRf47HrwiZ/Gtjdf1qxlQJrNAEGFBHj37389XO4aZ
        ItNZ9eU4dyl4dYcx88TorfJoZFQRtDn2wW9Vk/1V+2JGMYC0EC8XE19WnpkwMNjnWBgGva
        98xrp1ab+fHsBcN3XJpeJqyJwwG1xxo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-0v8fbV9MPY278gv7-0ZeRw-1; Wed, 17 Feb 2021 11:01:22 -0500
X-MC-Unique: 0v8fbV9MPY278gv7-0ZeRw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA73B100CCCD;
        Wed, 17 Feb 2021 16:01:20 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-116.ams2.redhat.com [10.36.112.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62DCC60657;
        Wed, 17 Feb 2021 16:01:16 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: Provide preliminary
 backtrace support
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210217144116.3368-1-frankja@linux.ibm.com>
 <20210217144116.3368-6-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <1bba9659-efa4-192a-ef60-ab62069f2901@redhat.com>
Date:   Wed, 17 Feb 2021 17:01:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210217144116.3368-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/2021 15.41, Janosch Frank wrote:
> After the stack changes we can finally use -mbackchain and have a
> working backtrace.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/interrupt.c | 12 ++++++++++++
>   lib/s390x/stack.c     | 20 ++++++++++++++------
>   s390x/Makefile        |  1 +
>   3 files changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index a59df80e..23ad922c 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -115,6 +115,18 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>   	/* suppressed/terminated/completed point already at the next address */
>   }
>   
> +static void print_pgm_info(struct stack_frame_int *stack)
> +
> +{
> +	printf("\n");
> +	printf("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
> +	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
> +	       lc->pgm_int_id);
> +	dump_stack();
> +	report_summary();
> +	abort();
> +}

I asssume this hunk should go into the next patch instead?
Or should the change to handle_pgm_int() from the next patch go into this 
patch here instead?
Otherwise you have an unused static function here and the compiler might 
complain about it (when bisecting later).

  Thomas

