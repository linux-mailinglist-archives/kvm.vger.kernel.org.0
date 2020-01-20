Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06FA814295C
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 12:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgATL14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 06:27:56 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30333 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726728AbgATL14 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 06:27:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579519674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u38wC2XLLu2Z7gSGkI0LGBD9aWJ8vKrtJ0jSDkyfN3g=;
        b=Ruk/xYiErB74CgRCswM+hBD8b8uki3SQzqQFD87QKLtb9v/9MdEXB72AmmR/rP7KgexGr9
        oXuR37ON4YTDIA9dBxpmdJAQJC/cMVTy8r0u7xAVu5SEC1uWqS9kelwCWY1D91deKYAr59
        6ZrtiEyOGV5NokgTkwAKpmddJdyy50c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-cmdhkIEzNo-kG2-WaYYK1A-1; Mon, 20 Jan 2020 06:27:51 -0500
X-MC-Unique: cmdhkIEzNo-kG2-WaYYK1A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41E8919057A0;
        Mon, 20 Jan 2020 11:27:50 +0000 (UTC)
Received: from gondolin (ovpn-205-161.brq.redhat.com [10.40.205.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F0F45C21A;
        Mon, 20 Jan 2020 11:27:46 +0000 (UTC)
Date:   Mon, 20 Jan 2020 12:27:43 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 6/9] s390x: smp: Loop if secondary cpu
 returns into cpu setup again
Message-ID: <20200120122743.68170875.cohuck@redhat.com>
In-Reply-To: <20200117104640.1983-7-frankja@linux.ibm.com>
References: <20200117104640.1983-1-frankja@linux.ibm.com>
        <20200117104640.1983-7-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Jan 2020 05:46:37 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Up to now a secondary cpu could have returned from the function it was
> executing and ending up somewhere in cstart64.S. This was mostly
> circumvented by an endless loop in the function that it executed.
> 
> Let's add a loop to the end of the cpu setup, so we don't have to rely
> on added loops in the tests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/cstart64.S | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 9af6bb3..5fd8d2f 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -162,6 +162,8 @@ smp_cpu_setup_state:
>  	/* We should only go once through cpu setup and not for every restart */
>  	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
>  	br	%r14
> +	/* If the function returns, just loop here */
> +0:	j	0

Would it make sense to e.g. load a disabled wait psw instead? Or does
that mess things up elsewhere?

>  
>  pgm_int:
>  	SAVE_REGS

