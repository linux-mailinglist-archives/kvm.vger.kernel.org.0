Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2663B7FBC
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 11:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhF3JPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 05:15:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233561AbhF3JPe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Jun 2021 05:15:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625044385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5XdOVYuH8C6GxU3JoN2yvCHtQG6QFCcJv5U7M2F7J9I=;
        b=he1yEQ/DPpe8l4vGFGoYWAJR22iVn1N1Hir8v7a6P0XtuAV1q/bweSfmjLP6EFV0DLZ+UU
        Lx/xnKITlVPpDJUJ8DMrADzLx7GfMTfFFVIpB6S5uh35ObHNs/QyZXdyHKYX2cxykTvsCI
        ZLCTk1o5TWUT1o3oAutpWaX8P3ys+Fw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-zJX_CvIxNSqDi5G_RUGVCQ-1; Wed, 30 Jun 2021 05:13:03 -0400
X-MC-Unique: zJX_CvIxNSqDi5G_RUGVCQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97708804143;
        Wed, 30 Jun 2021 09:13:02 +0000 (UTC)
Received: from localhost (ovpn-112-48.ams2.redhat.com [10.36.112.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D9BF18AD4;
        Wed, 30 Jun 2021 09:12:59 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 5/5] lib: s390x: Print if a pgm happened
 while in SIE
In-Reply-To: <20210629133322.19193-6-frankja@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210629133322.19193-1-frankja@linux.ibm.com>
 <20210629133322.19193-6-frankja@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 30 Jun 2021 11:12:58 +0200
Message-ID: <87lf6rlnqd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 29 2021, Janosch Frank <frankja@linux.ibm.com> wrote:

> For debugging it helps if you know if the PGM happened while being in
> SIE or not.
>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/interrupt.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index b627942..76015b1 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -141,10 +141,21 @@ static void print_int_regs(struct stack_frame_int *stack)
>  static void print_pgm_info(struct stack_frame_int *stack)
>  
>  {
> +	bool in_sie;
> +
> +	in_sie = (lc->pgm_old_psw.addr >= (uintptr_t)sie_entry &&
> +		  lc->pgm_old_psw.addr <= (uintptr_t)sie_exit);
> +
>  	printf("\n");
> -	printf("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
> -	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
> -	       lc->pgm_int_id);
> +	if (!in_sie)
> +		printf("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
> +		       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
> +		       lc->pgm_int_id);
> +	else
> +		printf("Unexpected program interrupt in SIE: %d on cpu %d at %#lx, ilen %d\n",
> +		       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
> +		       lc->pgm_int_id);

Hm...

		printf("Unexpected program interrupt%s: %d on cpu %d at %#lx, ilen %d\n",
		       in_sie ? " in SIE" : "",
		       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
		       lc->pgm_int_id);

Matter of taste, I guess.

